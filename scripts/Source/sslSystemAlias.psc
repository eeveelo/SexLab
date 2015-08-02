scriptname sslSystemAlias extends ReferenceAlias

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

; ------------------------------------------------------- ;
; --- System Startup                                  --- ;
; ------------------------------------------------------- ;

event OnPlayerLoadGame()
	Log("Version "+CurrentVersion+" / "+SexLabUtil.GetVersion(), "LOADED")
	; Check for install
	if CurrentVersion > 0 && Config.CheckSystem()
		Config.Reload()
		ThreadSlots.StopAll()
		; Perform pending updates
		UpdateSystem(CurrentVersion, SexLabUtil.GetVersion())
		; Cleanup tasks
		ValidateTrackedFactions()
		ValidateTrackedActors()
		Factory.Cleanup()
		Config.CleanActorStorage()

		; Send game loaded event
		ModEvent.Send(ModEvent.Create("SexLabGameLoaded"))
	endIf
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

event OnInit()
	GoToState("")
	LoadLibs(false)
	Version = 0
endEvent

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

	if StorageUtil.FormListCount(none, "SexLab.ActorStorage") < 1
		Config.PreloadSavedStorage()
	endIf

	GoToState("Ready")
	SexLab.GoToState("Enabled")
	LogAll("SexLab v"+SexLabUtil.GetStringVer()+" - Ready!")
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

		; TODO: first update by 1.60 should probably be done by MCM instead, so quests can be reset
		; Perform update functions
		if OldVersion <= 15921
			; Full system setup
			ThreadLib.Setup()
			ActorLib.Setup()
			Stats.Setup()
			Factory.Setup()
			VoiceSlots.Setup()
			ExpressionSlots.Setup()
			AnimSlots.Setup()
			CreatureSlots.Setup()
			ThreadSlots.Setup()
			if StorageUtil.FormListCount(none, "SexLab.ActorStorage") < 1
				Config.PreloadSavedStorage()
			endIf
		endIf

		Config.ImportSettings()

		; End update functions
		GoToState("Ready")
		SexLab.GoToState("Enabled")
		LogAll("SexLab Update v"+SexLabUtil.GetStringVer()+" - Ready!")
		SendVersionEvent("SexLabUpdated")
	endIf
endEvent

event InstallSystem()
	; Begin installation
	LogAll("SexLab v"+SexLabUtil.GetStringVer()+" - Installing...")
	; Init system
	if SetupSystem()
		SendVersionEvent("SexLabInstalled")
	else
		Debug.TraceAndBox("SexLab v"+SexLabUtil.GetStringVer()+" - INSTALL ERROR, CHECK YOUR PAPYRUS LOGS!")
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

import StorageUtil

function ValidateTrackedActors()
	FormListRemove(Config, "TrackedActors", none, true)
	Form[] TrackedActors = FormListToArray(Config, "TrackedActors")
	int i = TrackedActors.Length
	while i > 0
		i -= 1
		if !Config.IsActor(TrackedActors[i])
			FormListRemoveAt(Config, "TrackedActors", i)
			StringListClear(TrackedActors[i], "SexLabEvents")
		endIf
	endWhile
endFunction

function ValidateTrackedFactions()
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

;/ function CleanLists()
	FormListRemove(Config, "ValidActors", none, true)
	int count = FormListCount(Config, "ValidActors")
	int i = count
	while i > 0
		i -= 1
		Form FormRef = FormListGet(Config, "ValidActors", i)
		if !FormRef
			FormListRemoveAt(Config, "ValidActors", i)
		else
			Actor ActorRef = FormRef as Actor
			if !ActorRef
				FormListRemoveAt(Config, "ValidActors", i)
				; Log(FormRef+" - Not Actor", "Removing")
			elseIf ActorRef.IsDead() || ActorRef.IsDisabled()
				FormListRemove(Config, "ValidActors", ActorRef)
				FormListRemove(none, "SexLab.SkilledActors", ActorRef, true)
				FormListRemove(Config, "TrackedActors", ActorRef, true)
				FloatListClear(ActorRef, "SexLabSkills")
				Stats.ResetStats(ActorRef)
				; Log(FormRef + " - "+ ActorRef.GetLeveledActorBase().GetName()+" - IsDead: " + ActorRef.IsDead() + " IsDisabled: " + ActorRef.IsDisabled(), "Removing")
			endIf
		endIf
	endWhile
	Log("Actors Total: "+count+" / Removed: "+(count - FormListCount(Config, "ValidActors")), "CleanLists")
endFunction /;

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
endFunction
