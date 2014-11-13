scriptname sslTroubleshoot extends Quest

import Debug
import SexLabUtil

Actor property PlayerRef auto
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

function PerformTests(string testList)
	if Prepare()
		string[] Tests = sslUtility.ArgString(testList)
		bool Continue = true
		int i
		while i < Tests.Length && Continue
			GoToState(Tests[i])
			Utility.Wait(0.5)
			Continue = DoTest()
			i += 1
		endWhile
		GoToState("")
		Utility.Wait(1.0)
		UnlockPlayer()
	endIf
endFunction

; ------------------------------------------------------- ;
; --- Animation Testing                               --- ;
; ------------------------------------------------------- ;

state AnimSlots
	bool function DoTest()

		; Test animation slots for errors
		if !AnimSlots.TestSlots()
			Error(100, "SexLab's sslAnimSlots script has failed to load a resource or properly setup. Something may be wrong with your SexLab.esm or you may have missing scripts.")
			Repair(true)
			return false
		endif

		if AnimSlots.Slotted < 1 || AnimSlots.Animations.Length < 1
			Error(101, "sslAnimSlots appears to have no animations registered.")
			Repair(true)
			return false
		endIf

		; Check health of all animations
		Notify("Checking Animation Health...")
		bool dirty = false
		sslBaseAnimation[] Animations = AnimSlots.Animations
		int i = AnimSlots.Slotted
		while i > 0
			i -= 1
			sslBaseAnimation Animation = Animations[i]
			string id = Animation.Name+" ("+i+")"

			Log("-- Animation ("+id+") --")
			Log(id+" Enabled: "+Animation.Enabled)
			Log(id+" Registrar: "+Animation.Registry)
			Log(id+" Positions: "+Animation.PositionCount)
			Log(id+" Males: "+Animation.Males)
			Log(id+" Females: "+Animation.Females)
			Log(id+" Creatures: "+Animation.Creatures)
			Log(id+" Stages: "+Animation.StageCount)
			Log(id+" SFX: "+Animation.SoundFX)
			Log(id+" Tags: "+Animation.GetTags())
			Log("----")

			if Animation.Registered
				if Animation.GetTags().Length < 1
					Notify(id+" has no tags...")
					dirty = true
				endIf
				if Animation.StageCount < 1
					Error(130, id+" has no stages...")
					dirty = true
				endIf
				if Animation.PositionCount < 1
					Error(131, id+" has no positions...")
					dirty = true
				endIf
			endIf

		endwhile
		if dirty
			Tell("One of the animations had a critical error that would negatively impact it's use.")
			Repair()
			return false
		endIf

		; Attempt to pick MF animations
		Animations = AnimSlots.GetByType(2, 1, 1)
		if Animations.Length < 1
			Error(110, "Failed to find valid animations for Male + Female pairing. Either your animations have not properly run their setup scripts or all Male + Female animations are disabled.")
			Repair()
			return false
		endIf

		return true
	endFunction

	function Repair(bool force = false)
		if force || Ask("Attempt to repair animations slots automatically?")
			Log("Setting up animation slots... Please wait 30-60 seconds than attempt to test your animations or perform this troubleshoot process again.")
			AnimSlots.GoToState("")
			Utility.Wait(0.1)
			AnimSlots.Setup()
		endIf
	endFunction
endState

state ThreadSlots
	bool function DoTest()
		; Test thread slot script
		if !ThreadSlots.TestSlots()
			Error(150, "SexLab's sslThreadSlots script has failed to load a resource or properly setup. Something may be wrong with your SexLab.esm or you may have missing scripts.")
			Repair()
			return false
		endIf

		; Check health of all threads
		Notify("Checking Thread Health...")
		int i
		while i < 15
			sslThreadController Thread = ThreadSlots.GetController(i)
			Notify("-- Thread: "+i+" --")
			if Thread == none
				Error(151, "Thread ID ("+i+") is none, Something may be wrong with your SexLab.esm or your Skyrim may have failed during the install/upgrade process due to an unknown error. Attempting to correct this error now...")
				Repair(true)
				return false
			endIf
			if Thread.GetState() != "Unlocked"
				Error(152, "Thread ID ("+i+") is not in the correct unlocked state, attempting to correct this error now...")
				Thread.SetTID(i)
			endIf
			if Thread.ActorAlias.Length < 5
				Error(153, "Thread ID ("+i+") does not have proper actor alias slots, attempting to correct this error now...")
				sslActorAlias[] AliasSlots = new sslActorAlias[5]
				AliasSlots[0] = Thread.GetNthAlias(0) as sslActorAlias
				AliasSlots[1] = Thread.GetNthAlias(1) as sslActorAlias
				AliasSlots[2] = Thread.GetNthAlias(2) as sslActorAlias
				AliasSlots[3] = Thread.GetNthAlias(3) as sslActorAlias
				AliasSlots[4] = Thread.GetNthAlias(4) as sslActorAlias
				Thread.ActorAlias = AliasSlots
				Log("Created ActorAlias slots: "+Thread.ActorAlias)
			endIf
			int n
			while n < 5
				sslActorAlias ActorAlias = Thread.ActorAlias[n]
				if ActorAlias.GetReference() != none
					Error(153, "Actor Alias ("+n+") is not empty, attempting to correct this error now...")
					ActorAlias.ClearAlias()
				endIf
				; if ActorAlias.TestAlias()
				; 	Error(154, "Actor Alias ("+n+") failed to load a resource, something may be wrong with your SexLab.esm or you may have missing scripts. Attempting to correct this error now...")
				; 	ActorAlias.Setup()
				; endIf
				n += 1
			endWhile
			i += 1
		endWhile

		return true
	endFunction

	function Repair(bool force = false)
		if force || Ask("Attempt to fix thread slots automatically?")
			Log("Setting up thread slots... Please wait 45-90 seconds than attempt to test your animations or perform the troubleshoot process again.")
			ThreadSlots.GoToState("")
			Utility.Wait(0.1)
			ThreadSlots.Setup()
		endIf
	endFunction
endState

state FNIS
	bool function DoTest()

		; Check FNIS generation
		if !FNIS.IsGenerated()
			Error(160, "You most likely have not run the GenerateFNISforUsers.exe tool for your current version of FNIS.")
			return false
		endIf

		; Attempt to play event
		Tell("Attempting to play test animation on player, pay attention to your characters animation...")
		Debug.SendAnimationEvent(PlayerRef, "IdleForceDefaultState")
		Utility.Wait(0.5)
		Game.ForceThirdPerson()
		Debug.SendAnimationEvent(PlayerRef, "SexLab_Test_"+SexLabUtil.GetVersion())
		Utility.Wait(8.0)
		if !Ask("Did the animation play on your character?")
			Error(161, "FNIS installation error.")
			Tell("Suggestion 1: Ensure you have run the GenerateFNISforUsers.exe tool that comes with FNIS, that you have checked any relevant patches, and that the line \"Reading SexLab V"+SexLabUtil.GetStringVer()+" ...\" appears in the output after running the generator.")
			Tell("Suggestion 2: SexLab's Animation List file may be missing from your install. Ensure the file /data/meshes/actors/character/animations/SexLab/FNIS_SexLab_List.txt exists in your Skyrim install, it is common for Nexus Mod Manager to improperly install this file.")
			Tell("Suggestion 3: SexLab's Behavior file may be missing from your install. Ensure the file /data/meshes/actors/character/behaviors/FNIS_SexLab_Behavior.hkx exists in your Skyrim install.")
			return false
		endIf

		return true
	endFunction
endState

state StartAnimation
	bool function DoTest()

	endFunction
endState

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

	; Notify of start
	Tell(" -- SexLab Troubleshoot -- \nin 5 seconds your characters movement will be locked. Ensure you are in a safe place out of combat with you're weapons/spells sheathed.")
	Utility.Wait(5.0)

	; Attempt to lock the players movement
	LockPlayer()

	return true
endFunction


function Tell(string msg)
	Debug.MessageBox(msg)
	Utility.Wait(0.1)
	Log(msg)
endFunction

function Log(string msg)
	Debug.Trace(msg)
	SexLabUtil.PrintConsole(msg)
	Debug.TraceUser("SexLab", msg)
endFunction

function Notify(string msg)
	Debug.Notification(msg)
	SexLabUtil.PrintConsole(msg)
	Debug.Trace(msg)
	Debug.TraceUser("SexLab", msg)
	Utility.Wait(0.1)
endFunction

function Error(int errorid, string msg)
	Debug.TraceAndbox(msg)
	Utility.Wait(0.1)
	SexLabUtil.PrintConsole(msg)
	Debug.TraceUser("SexLab", msg)
	string id = "--- Error ID ( "+errorid+" ) ---"
	SexLabUtil.PrintConsole(id)
	Debug.TraceUser("SexLab", id)
endFunction

bool function Ask(string msg)
	Tell(msg)
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

bool function DoTest()
	Log("Null DoTest() call, this should never happen...")
	return false
endFunction

function Repair(bool force = false)
	Log("Null Repair() call, this should never happen...")
endFunction
