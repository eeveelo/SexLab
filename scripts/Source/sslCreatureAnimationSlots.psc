scriptname sslCreatureAnimationSlots extends sslAnimationSlots

; Local use
sslSystemConfig Config
sslThreadLibrary Lib

; ------------------------------------------------------- ;
; --- Creature aniamtion support                      --- ;
; ------------------------------------------------------- ;

sslBaseAnimation[] function GetByRace(int ActorCount, Race CreatureRace)
	bool[] Valid = new bool[75]
	int i = Slotted
	while i
		i -= 1
		Valid[i] = Slots[i].Enabled && ActorCount == Slots.PositionCount && Slots[i].HasRace(CreatureRace)
	endWhile
	return GetList(valid)
endFunction

bool function HasRace(Race CreatureRace)
	return StorageUtil.GetIntValue(CreatureRace, "SexLab.HasCreature") == 1
endFunction

function AddRace(Race CreatureRace)
	StorageUtil.SetIntValue(CreatureRace, "SexLab.HasCreature", 1)
	StorageUtil.FormListAdd(self, "CreatureTypes", CreatureRace, false)
endFunction

bool function AllowedCreature(Race CreatureRace)
	return  Config.bAllowCreatures && StorageUtil.GetIntValue(CreatureRace, "SexLab.HasCreature") == 1
endFunction

bool function AllowedCreatureCombination(Race CreatureRace1, Race CreatureRace2)
	if AllowedCreature(CreatureRace1) && AllowedCreature(CreatureRace2)
		int i = Slotted
		while i
			i -= 1
			if Slots[i].Enabled && Slots[i].HasRace(CreatureRace1) && Slots[i].HasRace(CreatureRace2)
				return true
			endIf
		endWhile
	endIf
	return false
endFunction

; ------------------------------------------------------- ;
; --- System Use Only                                 --- ;
; ------------------------------------------------------- ;

function Setup()
	GoToState("Setup")
endFunction

state Setup
	event OnBeginState()
		RegisterForSingleUpdate(1.0)
	endEvent
	event OnUpdate()
		; Init variables
		Slotted = 0
		Slots = new sslBaseAnimation[125]
		StorageUtil.StringListClear(self, "Animations")
		StorageUtil.FormListClear(self, "CreatureTypes")
		Lib = Quest.GetQuest("SexLabQuestFramework") as sslThreadLibrary
		Config = Quest.GetQuest("SexLabQuestFramework") as sslSystemConfig
		; Register default animations
		sslCreatureAnimationDefaults Defaults = Quest.GetQuest("SexLabQuestRegistry") as sslCreatureAnimationDefaults
		Defaults.Slots = self
		Defaults.LoadAnimations()
		; Send mod event for 3rd party animations
		ModEvent.Send(ModEvent.Create("SexLabSlotCreatureAnimations"))
		Debug.Notification("$SSL_NotifyCreatureAnimationInstall")
		GoToState("")
	endEvent
endState
