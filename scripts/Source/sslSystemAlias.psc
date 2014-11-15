scriptname sslSystemAlias extends ReferenceAlias

SexLabFramework property SexLab auto
sslSystemConfig property Config auto
Actor property PlayerRef auto


event OnPlayerLoadGame()
	Log("Version "+SexLabUtil.GetStringVer(), "LOADED")
	Config.Reload()
	if Config.CheckSystem()
		ValidateTrackedFactions()
		ValidateTrackedActors()
		SexLab.Factory.Cleanup()
	else
		SexLab.GoToState("Disabled")
	endIf
endEvent

event OnInit()
	Config.LoadLibs(false)
	Config.DebugMode = true
	if !Config.CheckSystem()
		SexLab.GoToState("Disabled")
	endIf
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

function Log(string Log, string Type = "NOTICE")
	Log = "SEXLAB - "+Type+": "+Log
	SexLabUtil.PrintConsole(Log)
	Debug.Trace(Log)
endFunction

