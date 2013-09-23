scriptname sslActorSlots extends Quest
; Scripts
sslActorLibrary property Lib auto

; Local
sslActorAlias[] ActorSlot

int property ActiveActors hidden
	int function get()
		int count
		int i
		while i < 75
			count += (ActorSlot[i].GetReference() == none) as int
			i += 1
		endWhile
		return count
	endFunction
endProperty

sslActorAlias function SlotActor(actor position, sslThreadController ThreadView)
	if Lib.ValidateActor(position) < 1
		return none
	endIf
	int i
	while i < 75
		if ActorSlot[i].ForceRefIfEmpty(position)
			Debug.Trace("SexLab: Slotting ActorSlot["+i+"] with "+position)
			ActorSlot[i].SetAlias(ThreadView)
			return ActorSlot[i]
		endIf
		i += 1
	endWhile
	return none
endFunction

int function FindActor(actor position)
	if position != none
		int i = 0
		while i < 75
			if (ActorSlot[i].GetReference() as actor) == position
				return i
			endIf
			i += 1
		endWhile
	endIf
	return -1
endFunction

sslActorAlias function GetSlot(int slot)
	return ActorSlot[slot]
endFunction

function ClearSlot(int slot)
	if slot >= 0 && slot < 75
		actor position = ActorSlot[slot].GetReference() as actor
		Debug.Trace("SexLab: Clearing ActorSlot["+slot+"] of "+position)
		ActorSlot[slot].TryToClear()
		ActorSlot[slot].TryToReset()
		position.EvaluatePackage()
	endIf
endFunction

function ClearActor(actor position)
	int slot = FindActor(position)
	if slot != -1
		ClearSlot(slot)
	endIf
endFunction

sslActorAlias function GetActorAlias(actor position)
	return ActorSlot[FindActor(position)]
endFunction

;/-----------------------------------------------\;
;|	Actor Slots Setup                            |;
;\-----------------------------------------------/;

function _Setup()
	ActorSlot = new sslActorAlias[75]

	int i
	while i < 75
		if i < 10
			ActorSlot[i] = GetAliasByName("ActorSlot00"+i) as sslActorAlias
		else
			ActorSlot[i] = GetAliasByName("ActorSlot0"+i) as sslActorAlias
		endIf
		ActorSlot[i].ClearAlias()
		ActorSlot[i].TryToClear()
		i += 1
	endWhile

	; Reind Hotkeys
	Lib._HKClear()
endFunction