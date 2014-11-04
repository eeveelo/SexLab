scriptname sslCreatureAnimationSlots extends sslAnimationSlots

; ------------------------------------------------------- ;
; --- Creature aniamtion support                      --- ;
; ------------------------------------------------------- ;

sslBaseAnimation[] function GetByRace(int ActorCount, Race RaceRef)
	string RaceID = MiscUtil.GetRaceEditorID(RaceRef)
	bool[] Valid = PapyrusUtil.BoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		Valid[i] = Slots[i].Enabled && ActorCount == Slots[i].PositionCount && Slots[i].HasRaceID(RaceID)
	endWhile
	return GetList(Valid)
endFunction

bool function HasCreature(Actor ActorRef)
	return SexLabUtil.HasCreature(ActorRef)
endFunction

bool function HasRace(Race RaceRef)
	return SexLabUtil.HasRace(RaceRef)
endFunction

bool function AllowedCreature(Race RaceRef)
	return Config.AllowCreatures && SexLabUtil.HasRace(RaceRef)
endFunction

bool function AllowedCreatureCombination(Race RaceRef1, Race RaceRef2)
	if Config.AllowCreatures && SexLabUtil.HasRace(RaceRef1) && SexLabUtil.HasRace(RaceRef2)
		int i = Slotted
		while i
			i -= 1
			if Slots[i].Enabled && Slots[i].HasRace(RaceRef1) && Slots[i].HasRace(RaceRef2)
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
	StorageUtil.StringListClear(Config, "SexLabCreatures")
	; Register default voices
	(Quest.GetQuest("SexLabQuestRegistry") as sslCreatureAnimationDefaults).LoadCreatureAnimations()
	; Send mod event for 3rd party voices
	ModEvent.Send(ModEvent.Create("SexLabSlotCreatureAnimations"))
	Debug.Notification("$SSL_NotifyCreatureAnimationInstall")
endFunction
