scriptname sslTroubleshoot extends Quest

import Debug
import SexLabUtil


Actor property PlayerRef auto hidden
SexLabFramework property SexLab auto
Message property AskContinue auto

; Settings access
sslSystemConfig property Config auto

; Function libraries
sslActorLibrary property ActorLib auto
sslThreadLibrary property ThreadLib auto
sslActorStats property Stats auto

; Object registeries
sslThreadSlots property ThreadSlots auto
sslAnimationSlots property AnimSlots auto
sslCreatureAnimationSlots property CreatureSlots auto
sslVoiceSlots property VoiceSlots auto
sslExpressionSlots property ExpressionSlots auto


; ------------------------------------------------------- ;
; --- Animation Testing                               --- ;
; ------------------------------------------------------- ;

function AnimationTrouble()
	if !Prepare()
		return
	endIf
	GoToState("TestAnimations")
	PerformTests()
	UnlockPlayer()
endFunction

state TestAnimations
	function PerformTests()
		; Test animation slots for errors
		if !AnimSlots.TestSlots()
			Error(100, "SexLab's sslAnimSlots script has failed to load a resource or properly setup. Something may be wrong with your SexLab.esm or you may have missing scripts.")
			SetupAnimations()
			return
		endif
		; Attempt to pick a MF animation
		sslBaseAnimation[] Animations = AnimSlots.GetByDefault(1, 1)
		if Animations.Length < 1
			Error(110, "Failed to find valid animations for Male + Female pairing. Either your animations have not properly run their setup scripts or all Male + Female animations are disabled.")
			SetupAnimations()
			return
		endIf
		; Attempt to play female animation
		Notify("Attempting to play animation event...")
		sslBaseAnimation Anim = Animations[0]
		if PlayerRef.GetLeveledActorBase().GetSex() == 1
			Log("Attempting to play '"+Anim.Name+"' Stage 2 Position 0 (female) animation on player...")
			SendAnimationEvent(PlayerRef, Anim.FetchPositionStage(0, 2))
		else
			Log("Attempting to play '"+Anim.Name+"' Stage 2 Position 1 (male) animation on player...")
			SendAnimationEvent(PlayerRef, Anim.FetchPositionStage(0, 2))
		endIf
		Wait(8.0)
		if !Ask("Did the animation play on your character?")
			; Bad FNIS
			if Ask("Did your character stand at a T-Pose with arms out, not playing idle animations?")
				Error(120, "Fores New Idles in Skyrim (FNIS) Error")
			elseIf Ask("Did your character simply stand their playing their normal idle animation?")
				Error(121, "Fores New Idles in Skyrim (FNIS) Error OR SexLab install error")
			endIf
			Log("Solution 1: You may not be running the most recent version of FNIS. SexLab currently requires at least version 5.0.0")
			Log("Solution 2: Ensure you have run the GenerateFNISforUsers.exe tool that comes with FNIS and that you have checked any relevant patches.")
			Log("Solution 3: SexLab's Animation List file may be missing from your install. Ensure the file /data/meshes/actors/character/animations/SexLab/FNIS_SexLab_List.txt exists in your Skyrim install, it is common for Nexus Mod Manager to improperly install this file.")
			Log("Solution 4: SexLab's Behavior file may be missing from your install. Ensure the file /data/meshes/actors/character/behaviors/FNIS_SexLab_Behavior.hkx exists in your Skyrim install.")
			Log("Solution 5: Your Skyrim may have failed to properly setup the SexLab animation scripts, this may be able to be fixed automatically...")
			SetupAnimations()
			return
		endIf
		; Check health of all animations
		Notify("Checking Animation Health...")
		bool dirty = false
		Animations = AnimSlots.Animations
		int i = AnimSlots.Slotted
		while i > 0
			i -= 1
			Anim = Animations[i]
			if Anim.Registered
				if !Anim.Enabled
					Notify(Anim.Name+" ("+i+") is not enabled...")
				endIf
				if Anim.GetTags().Length < 1
					Notify(Anim.Name+" ("+i+") has no tags..."+Anim.GetTags())
					dirty = true
				endIf
				if Anim.StageCount < 1
					Error(130, Anim.Name+" has no stages...")
					dirty = true
				endIf
				if Anim.PositionCount < 1
					Error(131, Anim.Name+" has no positions...")
					dirty = true
				endIf
			endIf
		endwhile
		if dirty
			Log("One of the animations had a critical error that would negatively impact it's use.")
			SetupAnimations()
			return
		endIf
		; Animation checks passed, try testing threads
		if !ThreadSlots.TestSlots()
			Error(150, "SexLab's sslThreadSlots script has failed to load a resource or properly setup. Something may be wrong with your SexLab.esm or you may have missing scripts.")
			SetupThreads()
			return
		endIf
		; Check health of all threads
		Notify("Checking Thread Health...")
		i = 0
		while i < 15
			sslThreadController Thread = ThreadSlots.GetController(i)
			Notify("Checking Thread: "+i)
			if Thread == none
				Error(151, "Thread ID ("+i+") is none, Something may be wrong with your SexLab.esm or your Skyrim may have failed during the install/upgrade process due to an unknown error.")
				SetupThreads()
				return
			endIf
			if Thread.GetState() != "Unlocked"
				Error(152, "Thread ID ("+i+") is not in the correct unlocked state, attempting to correct this error now...")
				Thread.SetTID(i)
			endIf
			int n = 0
			while n < 5
				sslActorAlias ActorAlias = Thread.PositionAlias(n)
				if ActorAlias.GetReference() != none
					Error(153, "Actor Alias ("+n+") is not empty, attempting to correct this error now...")
					ActorAlias.ClearAlias()
				endIf
				if ActorAlias.TestAlias()
					Error(154, "Actor Alias ("+n+") failed to load a resource, something may be wrong with your SexLab.esm or you may have missing scripts. Attempting to correct this error now...")
					ActorAlias.Setup()
				endIf
				n += 1
			endWhile
			i += 1
		endWhile
		; Try to start a thread
	endFunction
endState


function SetupAnimations()
	if Ask("Attempt to fix animations slots automatically?")
		Log("Setting up animation slots... Please wait 30-60 seconds than attempt to test your animations or perform the troubleshoot process again.")
		AnimSlots.GoToState("")
		Utility.Wait(0.1)
		AnimSlots.Setup()
	endIf
endFunction

function SetupThreads()
	if Ask("Attempt to fix thread slots automatically?")
		Log("Setting up thread slots... Please wait 45-90 seconds than attempt to test your animations or perform the troubleshoot process again.")
		ThreadSlots.GoToState("")
		Utility.Wait(0.1)
		ThreadSlots.Setup()
	endIf
endFunction

; ------------------------------------------------------- ;
; --- Misc System Utilities                           --- ;
; ------------------------------------------------------- ;


bool function Prepare()
	GoToState("")
	UnregisterForUpdate()
	OpenUserLog("SexLab")

	; ; Turn on Papyrus log and tracing
	; Utility.SetINIBool("bEnableLogging:Papyrus", true)
	; Utility.SetINIBool("bEnableTrace:Papyrus", true)

	; Notify of start
	Log(" -- SexLab Troubleshoot -- \nin 5 seconds your characters movement will be locked. Ensure you are in a safe place out of combat with you're weapons/spells sheathed.")
	Utility.Wait(5.0)

	; Make sure SexLab has it's resources
	SexLab = SexLabUtil.GetAPI()
	bool[] Checks = new bool[10]
	Checks[0] = SexLab.Config != none
	Checks[1] = SexLab.PlayerRef != none
	Checks[2] = SexLab.ThreadSlots != none
	Checks[3] = SexLab.AnimSlots != none
	Checks[4] = SexLab.VoiceSlots != none
	Checks[5] = SexLab.ExpressionSlots != none
	Checks[6] = SexLab.CreatureSlots != none
	Checks[7] = SexLab.ActorLib != none
	Checks[8] = SexLab.ThreadLib != none
	Checks[9] = SexLab.Stats != none
	if Checks.Find(false) != -1
		Error(20, "SexLab is missing a resource. This is generally a sign something is wrong with your SexLab.esm or you are missing scripts.")
		Trace("SexLabFramework Checks -- "+Checks)
		PrintConsole("SexLabFramework Checks -- "+Checks)
		return false
	endIf

	; Load ts resources
	PlayerRef       = SexLab.PlayerRef
	Config          = SexLab.Config
	ActorLib        = SexLab.ActorLib
	ThreadLib       = SexLab.ThreadLib
	Stats           = SexLab.Stats
	ThreadSlots     = SexLab.ThreadSlots
	AnimSlots       = SexLab.AnimSlots
	CreatureSlots   = SexLab.CreatureSlots
	VoiceSlots      = SexLab.VoiceSlots
	ExpressionSlots = SexLab.ExpressionSlots
	AskContinue     = Game.GetFormFromFile(0x7C358, "SexLab.esm") as Message

	; Make sure we were able to get them...
	if !SexLab || !Config || !AskContinue
		Error(10, "Troubleshooter failed to aquire SexLab resources. This is generally a sign something is wrong with your SexLab.esm or you are missing scripts.")
		return false
	endIf


	; Check system requirements
	if !Config.CheckSystem()
		Error(20, "Your Skyrim has failed a required dependency check, halting troubleshoot process now.")
		return false
	endIf

	; Attempt to lock the players movement
	LockPlayer()

	return true
endFunction

bool function PreTest()
	;/ SexLab = SexLabUtil.GetAPI()
	Config = SexLabUtil.GetConfig()
	AskContinue = Game.GetFormFromFile(0x7C358, "SexLab.esm") as Message

	; Error ID -- 9
	if !SexLab || !Config || !AskContinue
		return ErrorOut(9, "Trouble Shooter failed to aquire SexLab resources. This is generally a sign something is wrong with your SexLab.esm or you are missing scripts.")
	endIf
	; Error ID -- 10
	if !SexLab.Config || !SexLab.PlayerRef || !SexLab.ThreadSlots || !SexLab.AnimSlots || !SexLab.VoiceSlots || !SexLab.ExpressionSlots || !SexLab.CreatureSlots || !SexLab.ActorLib || !SexLab.ThreadLib || !SexLab.Stats
		return ErrorOut(10, "SexLabFramework API script has failed to load a resource. Something may be wrong with your SexLab.esm or you may have missing scripts.")
	endIf
	; Error ID -- 11
	if !SexLab.Config.TestLibrary()
		return ErrorOut(11, "SexLab's sslSystemConfnig script has failed to load a resource. Something may be wrong with your SexLab.esm or you may have missing scripts.")
	endIf
	; Error ID -- 12
	if !SexLab.ActorLib.TestLibrary()
		return ErrorOut(12, "SexLab's sslActorLibrary script has failed to load a resource. Something may be wrong with your SexLab.esm or you may have missing scripts.")
	endIf
	; Error ID -- 13
	if !SexLab.ThreadLib.TestLibrary()
		return ErrorOut(13, "SexLab's sslThreadLibrary script has failed to load a resource. Something may be wrong with your SexLab.esm or you may have missing scripts.")
	endIf
	; Error ID -- 14
	if !SexLab.Stats.TestLibrary()
		return ErrorOut(14, "SexLab's sslActorStats script has failed to load a resource. Something may be wrong with your SexLab.esm or you may have missing scripts.")
	endIf
	; Error ID -- 15
	if !SexLab.ThreadSlots.TestSlots()
		return ErrorOut(15, "SexLab's sslThreadSlots script has failed to load a resource. Something may be wrong with your SexLab.esm or you may have missing scripts.")
	endIf
	; Error ID -- 16
	if !SexLab.AnimSlots.TestSlots()
		return ErrorOut(16, "SexLab's sslAnimSlots script has failed to load a resource. Something may be wrong with your SexLab.esm or you may have missing scripts.")
	endIf
	; Error ID -- 17
	if !SexLab.CreatureSlots.TestSlots()
		return ErrorOut(17, "SexLab's sslCreatureSlots script has failed to load a resource. Something may be wrong with your SexLab.esm or you may have missing scripts.")
	endIf
	; Error ID -- 18
	if !SexLab.VoiceSlots.TestSlots()
		return ErrorOut(18, "SexLab's sslVoiceSlots script has failed to load a resource. Something may be wrong with your SexLab.esm or you may have missing scripts.")
	endIf
	; Error ID -- 19
	if !SexLab.ExpressionSlots.TestSlots()
		return ErrorOut(19, "SexLab's sslExpressionSlots script has failed to load a resource. Something may be wrong with your SexLab.esm or you may have missing scripts.")
	endIf /;

	PlayerRef.StopCombat()
	PlayerRef.SheatheWeapon()

	return true
endFunction




function Log(string msg)
	TraceAndBox(msg)
	Utility.Wait(0.1)
	PrintConsole(msg)
	TraceUser("SexLab", msg)
endFunction

function Notify(string msg)
	Notification(msg)
	PrintConsole(msg)
	Trace(msg)
	TraceUser("SexLab", msg)
	Utility.Wait(0.1)
endFunction

function Error(int errorid, string msg)
	MessageBox(msg)
	Utility.Wait(0.1)
	PrintConsole(msg)
	Trace(msg)
	TraceUser("SexLab", msg)
	string id = "--- Error ID ( "+errorid+" ) ---"
	PrintConsole(id)
	TraceUser("SexLab", id)
endFunction

bool function Ask(string msg)
	Log(msg)
	Utility.Wait(0.1)
	return AskContinue.Show()
endFunction

function LockPlayer()
	Game.SetPlayerAIDriven()
	Game.ForceThirdPerson()
	Game.DisablePlayerControls(true, true, true, false, true, true, true, true)
	Game.ForceThirdPerson()
	Debug.SendAnimationEvent(PlayerRef, "IdleForceDefaultState")
	PlayerRef.StopCombat()
	PlayerRef.SheatheWeapon()
	Utility.Wait(1.0)
	Game.ForceThirdPerson()
endFunction

function UnlockPlayer()
	Game.EnablePlayerControls()
	Game.SetPlayerAIDriven(false)
	Debug.SendAnimationEvent(PlayerRef, "IdleForceDefaultState")
	Utility.Wait(1.0)
endFunction

function PerformTests()
endFunction
