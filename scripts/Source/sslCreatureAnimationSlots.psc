scriptname sslCreatureAnimationSlots extends sslAnimationSlots

; ------------------------------------------------------- ;
; --- Creature aniamtion support                      --- ;
; ------------------------------------------------------- ;

sslBaseAnimation[] function GetByRace(int ActorCount, Race CreatureRace)
	bool[] Valid = sslUtility.BoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		Valid[i] = Slots[i].Enabled && ActorCount == Slots[i].PositionCount && Slots[i].HasRace(CreatureRace)
	endWhile
	return GetList(valid)
endFunction

bool function HasCreature(Actor ActorRef)
	return ActorRef != PlayerRef && HasRace(ActorRef.GetLeveledActorBase().GetRace())
endFunction

bool function HasRace(Race CreatureRace)
	return StorageUtil.GetIntValue(CreatureRace, "SexLab.HasCreature") == 1
endFunction

bool function AllowedCreature(Race CreatureRace)
	return  Config.AllowCreatures && StorageUtil.FormListFind(none, "SexLab.CreatureRaces", CreatureRace) != -1 ;StorageUtil.GetIntValue(CreatureRace, "SexLab.HasCreature") == 1
endFunction

function AddRace(Race CreatureRace) global
	StorageUtil.SetIntValue(CreatureRace, "SexLab.HasCreature", 1)
	StorageUtil.FormListAdd(none, "SexLab.CreatureRaces", CreatureRace)
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

function RegisterSlots()
	; Clear creature list
	StorageUtil.FormListClear(none, "SexLab.CreatureRaces")
	; Register default voices
	sslCreatureAnimationDefaults Defaults = Quest.GetQuest("SexLabQuestRegistry") as sslCreatureAnimationDefaults
	Defaults.Slots = self
	Defaults.Initialize()
	Defaults.LoadCreatureAnimations()
	; Send mod event for 3rd party voices
	ModEvent.Send(ModEvent.Create("SexLabSlotCreatureAnimations"))
	Debug.Notification("$SSL_NotifyCreatureAnimationInstall")
endFunction
