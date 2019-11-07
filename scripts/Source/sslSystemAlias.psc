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

; Check if we should force install system, because user hasn't done it manually yet for some reason. Or it failed somehow.
event OnUpdate()
	if !IsInstalled && !ForcedOnce && GetState() == ""
		ForcedOnce = true
		LogAll("Automatically Installing SexLab v"+SexLabUtil.GetStringVer())
		InstallSystem()
	endIf
endEvent