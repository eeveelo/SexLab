scriptname sslSystemAlias extends ReferenceAlias

; Framework
SexLabFramework property SexLab auto
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
sslObjectFactory property Factory auto

; Misc
; Actor property PlayerRef auto

; ------------------------------------------------------- ;
; --- System Install/Update                           --- ;
; ------------------------------------------------------- ;

int Version
int property CurrentVersion hidden
	int function get()
		return Version
	endFunction
endProperty

bool function SetupSystem()
	LoadLibs(true)
	Config.DebugMode = true
	; Disable system from being used during setup
	SexLab.GoToState("Disabled")

	; Framework
	SexLab.Setup()
	Config.Setup()
	Config.SetDefaults()

	; Function libraries
	ThreadLib.Setup()
	ActorLib.Setup()
	Stats.Setup()

	; Object registeries
	Factory.Setup()
	VoiceSlots.Setup()
	ExpressionSlots.Setup()
	CreatureSlots.Setup()
	AnimSlots.Setup()
	ThreadSlots.Setup()

	Version = SexLabUtil.GetVersion()
	SexLab.GoToState("Enabled")
	return true
endFunction

event UpdateSystem(int ToVersion)
	SexLab.GoToState("Disabled")
	LogAll("SexLab v"+SexLabUtil.GetStringVer()+" - Updating...")

	; Perform update functions
	ThreadLib.Setup()
	ActorLib.Setup()
	Stats.Setup()
	Factory.Setup()
	VoiceSlots.Setup()
	ExpressionSlots.Setup()
	CreatureSlots.Setup()
	AnimSlots.Setup()
	ThreadSlots.Setup()

	LogAll("SexLab Update v"+SexLabUtil.GetStringVer()+" - Ready!")
	Version = ToVersion
	SexLab.GoToState("Enabled")
endEvent

event InstallSystem()
	; Begin installation
	LogAll("SexLab v"+SexLabUtil.GetStringVer()+" - Installing...")
	; Init system
	if SetupSystem()
		LogAll("SexLab v"+SexLabUtil.GetStringVer()+" - Ready!")
	else
		Debug.TraceAndBox("SexLab v"+SexLabUtil.GetStringVer()+" - INSTALL ERROR, CHECK YOUR PAPYRUS LOGS!")
	endIf
endEvent

; ------------------------------------------------------- ;
; --- System Startup                                  --- ;
; ------------------------------------------------------- ;

event OnPlayerLoadGame()
	Log("Version "+CurrentVersion, "LOADED")
	if Config.CheckSystem()
		; Check for update/install
		if CurrentVersion <= 0
			InstallSystem()
		elseIf CurrentVersion < SexLabUtil.GetVersion()
			UpdateSystem(SexLabUtil.GetVersion())
		else
			Config.Reload()
			ValidateTrackedFactions()
			ValidateTrackedActors()
			SexLab.Factory.Cleanup()
		endIf
	else
		SexLab.GoToState("Disabled")
	endIf
endEvent

event OnInit()
	LoadLibs(false)
	RegisterForModEvent("SexLabInstalled", "InstallDone")
	RegisterForModEvent("SexLabUpdated", "UpdateDone")
endEvent

event InstallDone(int ver)
	LogAll("InstallDone("+ver+")")
endEvent

event UpdateDone(int ver)
	LogAll("UpdateDone("+ver+")")
endEvent

function ValidateTrackedActors()
	int i = StorageUtil.FormListCount(Config, "TrackedActors")
	while i
		i -= 1
		Actor ActorRef = StorageUtil.FormListGet(Config, "TrackedActors", i) as Actor
		if !ActorRef
			StorageUtil.FormListRemoveAt(Config, "TrackedActors", i)
		endIf
	endWhile
endFunction

function ValidateTrackedFactions()
	int i = StorageUtil.FormListCount(Config, "TrackedFactions")
	while i
		i -= 1
		Faction FactionRef = StorageUtil.FormListGet(Config, "TrackedFactions", i) as Faction
		if !FactionRef
			StorageUtil.FormListRemoveAt(Config, "TrackedFactions", i)
		endIf
	endWhile
endFunction

function CleanLists()
	int count = StorageUtil.FormListCount(Config, "ValidActors")
	Log("Total Actors: "+count, "CleanLists")
	int i = StorageUtil.FormListCount(Config, "ValidActors")
	while i > 0
		i -= 1
		Form FormRef = StorageUtil.FormListGet(Config, "ValidActors", i)
		if !FormRef
			StorageUtil.FormListRemoveAt(Config, "ValidActors", i)
			; Log("Is None", "Removing")
		else
			Actor ActorRef = FormRef as Actor
			if !ActorRef
				StorageUtil.FormListRemoveAt(Config, "ValidActors", i)
				; Log(FormRef+" - Not Actor", "Removing")
			elseIf ActorRef.IsDead() || ActorRef.IsDisabled()
				StorageUtil.FormListRemove(Config, "ValidActors", ActorRef)
				StorageUtil.FormListRemove(none, "SexLab.SkilledActors", ActorRef, true)
				StorageUtil.FormListRemove(Config, "TrackedActors", ActorRef, true)
				StorageUtil.FloatListClear(ActorRef, "SexLabSkills")
				SexLab.Stats.ClearCustomStats(ActorRef)
				; Log(FormRef + " - "+ ActorRef.GetLeveledActorBase().GetName()+" - IsDead: " + ActorRef.IsDead() + " IsDisabled: " + ActorRef.IsDisabled(), "Removing")
			endIf
		endIf
	endWhile
	Log("Actors Removed: "+(count - StorageUtil.FormListCount(Config, "ValidActors")), "CleanLists")
endFunction

; ------------------------------------------------------- ;
; --- System Utils                                    --- ;
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
	; Sync data
	; if Forced || !PlayerRef
	; 	PlayerRef = Game.GetPlayer()
	; endIf
endFunction
