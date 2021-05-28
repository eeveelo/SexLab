scriptname sslSystemAlias extends ReferenceAlias

import StorageUtil
import SexLabUtil

; Framework
SexLabFramework property SexLab auto
sslSystemConfig property Config auto

; Function libraries
sslActorLibrary property ActorLib auto
sslThreadLibrary property ThreadLib auto
sslActorStats property Stats auto

; Object registry
sslThreadSlots property ThreadSlots auto
sslAnimationSlots property AnimSlots auto
sslCreatureAnimationSlots property CreatureSlots auto
sslVoiceSlots property VoiceSlots auto
sslExpressionSlots property ExpressionSlots auto
sslObjectFactory property Factory auto

Actor PlayerRef

; ------------------------------------------------------- ;
; --- System Startup                                  --- ;
; ------------------------------------------------------- ;

event OnPlayerLoadGame()
	LoadLibs()
	; Config.DebugMode = true
	Log("Version "+CurrentVersion+" / "+SexLabUtil.GetVersion(), "LOADED")
	; Check for install
	if CurrentVersion > 0 && Config.CheckSystem()
		Config.Reload()
		ThreadSlots.StopAll()
		; Perform pending updates
		UpdateSystem(CurrentVersion, SexLabUtil.GetVersion())
		; Cleanup tasks
		Factory.Cleanup()
		CleanTrackedFactions()
		CleanTrackedActors()
		; Send game loaded event
		ModEvent.Send(ModEvent.Create("SexLabGameLoaded"))
	elseIf !IsInstalled && !ForcedOnce && GetState() == "" && Config.CheckSystem()
		Utility.Wait(0.1)
		RegisterForSingleUpdate(30.0)
	elseIf Version == 0 && GetState() == "Ready" && Config.CheckSystem()
		Utility.Wait(0.1)
		Log("SexLab somehow failed to install but things it did, not sure how this happened and it never should, attempting to fix it automatically now... ")
		InstallSystem()
	endIf
endEvent

event OnInit()
	GoToState("")
	Version = 0
	LoadLibs(false)
	ForcedOnce = false
endEvent

; ------------------------------------------------------- ;
; --- System Install/Update                           --- ;
; ------------------------------------------------------- ;

int Version
int property CurrentVersion hidden
	int function get()
		return Version
	endFunction
endProperty

bool ForcedOnce = false
bool property IsInstalled hidden
	bool function get()
		return Version > 0 && GetState() == "Ready"
	endFunction
endProperty

bool property UpdatePending hidden
	bool function get()
		return Version > 0 && Version < SexLabUtil.GetVersion()
	endFunction
endProperty

bool property PreloadDone hidden
	bool function get()
		return GetIntValue(Config, "PreloadDone", 0) == 1
	endFunction
	function set(bool value)
		SetIntValue(Config, "PreloadDone", value as int)
	endFunction
endProperty

bool function SetupSystem()
	Version = SexLabUtil.GetVersion()
	SexLab.GoToState("Disabled")
	GoToState("Installing")

	; Framework
	LoadLibs(false)
	SexLab.Setup()
	Config.Setup()

	; Function libraries
	ThreadLib.Setup()
	ActorLib.Setup()
	Stats.Setup()

	; Object registry
	Factory.Setup()
	VoiceSlots.Setup()
	ExpressionSlots.Setup()
	AnimSlots.Setup()
	CreatureSlots.Setup()
	ThreadSlots.Setup()

	; Finish setup
	GoToState("Ready")
	SexLab.GoToState("Enabled")
	LogAll("SexLab v"+SexLabUtil.GetStringVer()+" - Ready!")
	; Clean storage lists
	CleanActorStorage()
	return true
endFunction

event UpdateSystem(int OldVersion, int NewVersion)
	if OldVersion <= 0 || NewVersion <= 0
		Debug.TraceAndBox("SEXLAB ERROR: Unknown call to system update: "+OldVersion+"->"+NewVersion)

	elseif NewVersion < OldVersion
		Debug.TraceAndBox("SEXLAB ERROR: Unsupported version rollback detected ("+OldVersion+"->"+NewVersion+") Proceed at your own risk!")

	elseif OldVersion < NewVersion
		LogAll("SexLab v"+SexLabUtil.GetStringVer()+" - Updating...")
		SexLab.GoToState("Disabled")
		GoToState("Updating")
		Version = NewVersion

		Config.ExportSettings()

		; Perform update functions
		if OldVersion >= 16000 && NewVersion >= 16200 ; 1.62
			AnimSlots.Setup()
			CreatureSlots.Setup()

			ActorLib.Setup()    ; New cum spells
			ThreadSlots.Setup() ; New alias event arrays
			
			; Install creature voices, if needed.
			if Config.AllowCreatures
				(Game.GetFormFromFile(0x664FB, "SexLab.esm") as sslVoiceDefaults).LoadCreatureVoices()
			endIf

		elseif OldVersion == 16000
			PreloadDone = true

		elseIf OldVersion < 16000
			; Full system setup for < 1.60
			SexLab.Setup()
			Config.Setup()
			ThreadLib.Setup()
			ActorLib.Setup()
			Stats.Setup()
			Factory.Setup()
			VoiceSlots.Setup()
			ExpressionSlots.Setup()
			AnimSlots.Setup()
			CreatureSlots.Setup()
			ThreadSlots.Setup()

		elseIf OldVersion < 16209
			; Some system setup for < 1.63 SE dev beta 9
			bool AllowCreatures = Config.AllowCreatures
			Config.Setup()
			Config.AllowCreatures = AllowCreatures
			AnimSlots.Setup()
			CreatureSlots.Setup()
		endIf

		Config.ImportSettings()

		; End update functions
		GoToState("Ready")
		SexLab.GoToState("Enabled")
		LogAll("SexLab Update v"+SexLabUtil.GetStringVer()+" - Ready!")
		SendVersionEvent("SexLabUpdated")
		; Clean storage lists
		CleanActorStorage()
	endIf
endEvent

event InstallSystem()
	ForcedOnce = true
	; Begin installation
	LogAll("SexLab v"+SexLabUtil.GetStringVer()+" - Installing...")
	; Init system
	if SetupSystem()
		SendVersionEvent("SexLabInstalled")
	else
		Debug.TraceAndBox("SexLab v"+SexLabUtil.GetStringVer()+" - INSTALL ERROR, CHECK YOUR PAPYRUS LOGS!")
		ForcedOnce = false
	endIf
endEvent

function SendVersionEvent(string VersionEvent)
	int eid = ModEvent.Create(VersionEvent)
	ModEvent.PushInt(eid, CurrentVersion)
	ModEvent.Send(eid)
endFunction

; ------------------------------------------------------- ;
; --- System Cleanup                                  --- ;
; ------------------------------------------------------- ;

function CleanTrackedActors()
	FormListRemove(Config, "TrackedActors", none, true)
	Form[] TrackedActors = FormListToArray(Config, "TrackedActors")
	int i = TrackedActors.Length
	while i > 0
		i -= 1
		if !IsActor(TrackedActors[i])
			FormListRemoveAt(Config, "TrackedActors", i)
			StringListClear(TrackedActors[i], "SexLabEvents")
		endIf
	endWhile
endFunction

function CleanTrackedFactions()
	FormListRemove(Config, "TrackedFactions", none, true)
	Form[] TrackedFactions = FormListToArray(Config, "TrackedFactions")
	int i = TrackedFactions.Length
	while i
		i -= 1
		if !TrackedFactions[i] || TrackedFactions[i].GetType() != 11 ; kFaction
			FormListRemoveAt(Config, "TrackedFactions", i)
			StringListClear(TrackedFactions[i], "SexLabEvents")
		endIf
	endWhile
endFunction

function CleanActorStorage()
	if !PreloadDone
		GoToState("PreloadStorage")
		return
	endIf
	Log("Starting..." ,"CleanActorStorage")
	FormListRemove(none, "SexLab.ActorStorage", none, true)

	Form[] ActorStorage = FormListToArray(none, "SexLab.ActorStorage")
	int i = ActorStorage.Length
	while i > 0
		i -= 1
		bool IsActor = IsActor(ActorStorage[i])
		if !IsActor || (IsActor && !IsImportant(ActorStorage[i] as Actor, false))
			ClearFromActorStorage(ActorStorage[i])
		endIf
	endWhile
	; Log change in storage
	int Count = FormListCount(none, "SexLab.ActorStorage")
	if Count != ActorStorage.Length
		Log(ActorStorage.Length+" -> "+Count, "CleanActorStorage")
	else
		Log("Done - "+Count, "CleanActorStorage")
	endIf
	debug_Cleanup()
endFunction

function ClearFromActorStorage(Form FormRef)
	if IsActor(FormRef)
		Actor ActorRef = FormRef as Actor
		sslActorStats._ResetStats(ActorRef)
		Stats.ClearCustomStats(ActorRef)
		Stats.ClearLegacyStats(ActorRef)
	endIf
	UnsetStringValue(FormRef, "SexLab.SavedVoice")
	UnsetStringValue(FormRef, "SexLab.CustomVoiceAlias")
	UnsetFormValue(FormRef, "SexLab.CustomVoiceQuest")
 	FormListClear(FormRef, "SexPartners")
	FormListClear(FormRef, "WasVictimOf")
	FormListClear(FormRef, "WasAggressorTo")
	FloatListClear(FormRef, "SexLabSkills")
	FormListRemove(Config, "ValidActors", FormRef, true)
	FormListRemove(none, "SexLab.SkilledActors", FormRef, true)
	FormListRemove(none, "SexLab.ActorStorage", FormRef, true)
endFunction

bool function IsActor(Form FormRef) global
	if FormRef
		int Type = FormRef.GetType()
		return Type == 43 || Type == 44 || Type == 62 ; kNPC = 43 kLeveledCharacter = 44 kCharacter = 62
	endIf
	return false
endFunction

bool function IsImportant(Actor ActorRef, bool Strict = false) global
	if ActorRef == Game.GetPlayer()
		return true
	elseIf !ActorRef || ActorRef.IsDead() || ActorRef.IsDeleted() || ActorRef.IsChild()
		return false
	elseIf !Strict
		return true
	endIf
	; Strict check
	ActorBase BaseRef = ActorRef.GetLeveledActorBase()
	return BaseRef.IsUnique() || BaseRef.IsEssential() || BaseRef.IsInvulnerable() || BaseRef.IsProtected() || ActorRef.IsGuard() || ActorRef.IsPlayerTeammate() || ActorRef.Is3DLoaded()
endFunction

; ------------------------------------------------------- ;
; --- System Utils                                   --- ;
; ------------------------------------------------------- ;

function Log(string Log, string Type = "NOTICE")
	Log = "SEXLAB - "+Type+": "+Log
	SexLabUtil.PrintConsole(Log)
	Debug.Trace(Log)
endFunction

function LogAll(string Log)
	Log = "SexLab  - "+Log
	Debug.Notification(Log)
	Debug.Trace(Log)
	MiscUtil.PrintConsole(Log)
endFunction

function MenuWait()
	Utility.Wait(2.0)
	while Utility.IsInMenuMode()
		Utility.Wait(0.5)
	endWhile
endFunction

function LoadLibs(bool Forced = false)
	; Sync function Libraries - SexLabQuestFramework
	if Forced || !SexLab || !Config || !ThreadLib || !ThreadSlots || !ActorLib || !Stats
		Form SexLabQuestFramework  = Game.GetFormFromFile(0xD62, "SexLab.esm")
		if SexLabQuestFramework
			SexLab      = SexLabQuestFramework as SexLabFramework
			Config      = SexLabQuestFramework as sslSystemConfig
			ThreadLib   = SexLabQuestFramework as sslThreadLibrary
			ThreadSlots = SexLabQuestFramework as sslThreadSlots
			ActorLib    = SexLabQuestFramework as sslActorLibrary
			Stats       = SexLabQuestFramework as sslActorStats
		endIf
	endIf
	; Sync animation registry - SexLabQuestAnimations
	if Forced || !AnimSlots
		Form SexLabQuestAnimations = Game.GetFormFromFile(0x639DF, "SexLab.esm")
		if SexLabQuestAnimations
			AnimSlots = SexLabQuestAnimations as sslAnimationSlots
		endIf
	endIf
	; Sync secondary object registry - SexLabQuestRegistry
	if Forced || !CreatureSlots || !VoiceSlots || !ExpressionSlots
		Form SexLabQuestRegistry   = Game.GetFormFromFile(0x664FB, "SexLab.esm")
		if SexLabQuestRegistry
			CreatureSlots   = SexLabQuestRegistry as sslCreatureAnimationSlots
			ExpressionSlots = SexLabQuestRegistry as sslExpressionSlots
			VoiceSlots      = SexLabQuestRegistry as sslVoiceSlots
		endIf
	endIf
	; Sync phantom object registry - SexLabObjectFactory
	if Forced || !Factory
		Form SexLabObjectFactory = Game.GetFormFromFile(0x78818, "SexLab.esm")
		if SexLabObjectFactory
			Factory = SexLabObjectFactory as sslObjectFactory
		endIf
	endIf
	if Forced || !PlayerRef
		PlayerRef = GetReference() as Actor
	endIf
endFunction

state PreloadStorage
	event OnBeginState()
		RegisterForSingleUpdate(0.1)
	endEvent
	event OnUpdate()
		GoToState("Ready")
		if PreloadDone
			return
		endIf
		PreloadDone = true
		Log("Preloading actor storage... This may take a long time...")
		; Start actor preloading
		int PreCount = FormListCount(none, "SexLab.ActorStorage")
		FormListRemove(none, "SexLab.ActorStorage", none, true)
		; Check actors with saved stats
		Actor[] Actors = sslActorStats.GetAllSkilledActors()
		int i = Actors.Length
		while i > 0
			i -= 1
			if Actors[i] && !FormListHas(none, "SexLab.ActorStorage", Actors[i])
				sslSystemConfig.StoreActor(Actors[i])
			endIf
		endWhile
		; Check string values for SexLab.SavedVoice
		Form[] Forms = debug_AllStringObjs()
		i = Forms.Length
		while i > 0
			i -= 1
			if Forms[i] && !FormListHas(none, "SexLab.ActorStorage", Forms[i]) && HasStringValue(Forms[i], "SexLab.SavedVoice")
				sslSystemConfig.StoreActor(Forms[i])
			endIf
		endWhile
		; Check form list for partners, victims, aggressors, or legacy skill storage
		Forms = debug_AllFormListObjs()
		i = Forms.Length
		while i > 0
			i -= 1
			if Forms[i] && !FormListHas(none, "SexLab.ActorStorage", Forms[i]) && (FormListCount(Forms[i], "SexPartners") > 0 || FormListCount(Forms[i], "WasAggressorTo") > 0 || FormListCount(Forms[i], "WasVictimOf") > 0 || FloatListCount(Forms[i], "SexLabSkills") > 0)
				sslSystemConfig.StoreActor(Forms[i])
			endIf
		endWhile
		; Load legacy skilled actor storage
		i = FormListCount(none, "SexLab.SkilledActors")
		while i > 0
			i -= 1
			Form FormRef = FormListGet(none, "SexLab.SkilledActors", i)
			if FormRef && FormRef != PlayerRef
				if IsActor(FormRef)
					Stats.UpgradeLegacyStats(FormRef, IsImportant(FormRef as Actor, true))
				else
					ClearFromActorStorage(FormRef)
				endIf
			endIf
		endWhile
		FormListClear(none, "SexLab.SkilledActors")
		; Log change in storage
		int Count = FormListCount(none, "SexLab.ActorStorage")
		if Count != PreCount
			Log(PreCount+" -> "+Count, "PreloadSavedStorage")
		else
			Log("Done - "+Count, "PreloadSavedStorage")
		endIf
		; Preload finished, now clean it.
		CleanActorStorage()
	endEvent
endState

sslThreadModel Thread
state Ready
	; ##################################################
	; #                                                #
	; #           Debug Animation Handlers             #
	; #                                                #
	; ##################################################


	; Called from spell, validates the target and places actor in storage for scene use.
	; Returns True if the actor is successfully added to storage, False if they fail to validate.
	bool function RegisterDebugActor(Actor ActorRef)
		; Validate we can add the actor before trying to register them.
		;  - Actor is valid target for starting an animation
		if SexLab.IsValidActor(ActorRef)
			if !Thread
				Thread = SexLab.NewThread()
				; Claim an available animation thread from SexLab we can add our actors to.
				if !Thread
					Debug.Trace("--- SexLab Debug Sex --- Failed to create the animation thread - See debug log for details.")
					UnregisterForUpdate() ; Stop any update event to prevent issues.
					return false ; Stop the function now since we failed to add the actor.
				endIf
			endIf

			; Add all our actors at once into the scene using all default settings.
			if Thread.AddActor(ActorRef) < 0
				Debug.Trace("--- SexLab Debug Sex --- Failed to slot one of the actors into the animation thread - See debug log for details.")
				return false ; Stop the function now since we failed to add the actor.
			endIf

			
			; Actor has passed pre-registration checks, continue with the registration!
			; if we've now reached our limit of 5, skip waiting for more actors to have their spell effect expire, lets just get started now.
			if Thread.ActorCount >= 5
				TriggerDebugSex()
			else
				UnregisterForUpdate()
				RegisterForSingleUpdate(10.0)
			endIf
			return true ; We have successfully registered the actor into slots or started animation.
		endIf
		return false ; Failed pre-registration check
	endFunction

	; Takes our current Slots array and attempts to start a sex scene using the contained actors, however many actors it has, between 1 and 3.
	function TriggerDebugSex()
		UnregisterForUpdate()
		; Don't allow multiple instances to try and start a scene since we only keep a single actor Slots array.

		; Claim an available animation thread from SexLab we can add our actors to.
		;sslThreadModel Thread = SexLab.NewThread()
		if !Thread
			Debug.Trace("--- SexLab Debug Sex --- Failed to create the animation thread - See debug log for details.")
			UnregisterForUpdate() ; Stop any update event to prevent issues.
			return ; Stop the function now since we failed to add the actor.
		endIf

		if PapyrusUtil.RemoveActor(Thread.Positions, none).Length < 1
			Debug.Trace("--- SexLab Debug Sex --- Failed to slot the actors into the animation thread - See debug log for details.")
			UnregisterForUpdate() ; Stop any update event to prevent issues.
			Thread = none ; Empty out the Thread to allow start new one.
			return ; Stop the function now since we failed to add the actor.
		endIf

		; Set our custom hook name "SexLabDebug" in the thread.
		Thread.SetHook("SexLabDebug")
		; Register our script to respond to the hook's event that is triggered at the end of animation.
		;  -  If an event was registered for just "HookAnimationEnd" it would be attached to the global hook and be triggered after EVERY scene started by SexLab
		;  -  _SexLabDebug makes it a non global hook that is called from our above Thread.SetHook("SexLabDebug") so we can focus on just the end event we want.
		RegisterForModEvent("HookAnimationEnd_SexLabDebug", "AnimationEnd")

		; Since this is just a basic example, we'll keep the scene simple and let SexLab and player configuration figure out most of the stuff on it's own.
		; a.k.a. Ooohhh yeah, https://www.youtube.com/watch?v=AqZcYPEszN8
		Thread.StartThread()

		; Empty out the Thread to allow start new one.
		Thread = none
	endFunction

	event OnUpdate()
		TriggerDebugSex()
	endEvent
endState

bool function RegisterDebugActor(Actor ActorRef)
	Log("Cannot add the actor on a locked System", "RegisterDebugActor() ERROR")
	return false
endFunction

function TriggerDebugSex()
	Log("Cannot start a Debug Sex Scene on a locked System", "TriggerDebugSex() ERROR")
endFunction

; Our AnimationEnd hook, called from the RegisterForModEvent("HookAnimationEnd_SexLabDebug", "AnimationEnd") in TriggerDebugSex()
;  -  HookAnimationEnd is sent by SexLab called once the sex animation has fully stopped.
event AnimationEnd(int ThreadID, bool HasPlayer)
	; Get the thread that triggered this event via the thread id
	sslThreadController ThreadController = SexLab.GetController(ThreadID)
	; Get our list of actors that were in this animation thread.
	Actor[] Positions = ThreadController.Positions
	; Loop through our list of actors a and display some flavor text.
	;  -  This is rather pointless use of hooks, but this supposed to be an example, so whatever.
	int i = Positions.Length
	while i > 0
		i -= 1
		Debug.Notification(Positions[i].GetLeveledActorBase().GetName() + "'s irresistible aura fades.")
	endWhile
endEvent

; Check if we should force install system, because user hasn't done it manually yet for some reason. Or it failed somehow.
event OnUpdate()
	if !IsInstalled && !ForcedOnce && GetState() == ""
		ForcedOnce = true
		LogAll("Automatically Installing SexLab v"+SexLabUtil.GetStringVer())
		InstallSystem()
	endIf
endEvent