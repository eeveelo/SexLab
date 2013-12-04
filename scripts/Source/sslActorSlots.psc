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
	if FindActor(position) != -1 || Lib.ValidateActor(position) < 1
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

sslActorAlias[] function GetActorSlots(int tid)
	tid *= 5
	sslActorAlias[] ActorSlots = new sslActorAlias[5]
	ActorSlots[0] = GetNthAlias(tid) as sslActorAlias
	ActorSlots[1] = GetNthAlias(tid + 1) as sslActorAlias
	ActorSlots[2] = GetNthAlias(tid + 2) as sslActorAlias
	ActorSlots[3] = GetNthAlias(tid + 3) as sslActorAlias
	ActorSlots[4] = GetNthAlias(tid + 4) as sslActorAlias
	return ActorSlots
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
	int i = 75
	while i
		i -= 1
		ActorSlot[i] = GetNthAlias(i) as sslActorAlias
		ActorSlot[i].ClearAlias()
		ActorSlot[i].TryToClear()
	endWhile
	; Rebind Hotkeys
	Lib.ControlLib._HKClear()
endFunction
