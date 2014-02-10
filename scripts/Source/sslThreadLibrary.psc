scriptname sslThreadLibrary extends sslSystemLibrary

; Data
Sound property sfxSquishing01 auto
Sound property sfxSucking01 auto
Sound property sfxSexMix01 auto
Sound property OrgasmEffect auto
Static property LocationMarker auto
FormList property BedsList auto
FormList property BedRollsList auto
Message property mAdjustChange auto
Message property mUseBed auto
Message property mMoveScene auto

; bool function IsActorFree(actor position)
;	return Threads.FindActorController(position) == -1
; endFunction

bool function CheckBed(ObjectReference BedRef, bool ignoreUsed = true, bool ignoreOwned = true)
	return BedRef != none && BedRef.IsEnabled() && BedRef.Is3DLoaded() && (!ignoreUsed || (ignoreUsed && !BedRef.IsFurnitureInUse(true)))
endFunction

ObjectReference function FindBed(ObjectReference centerRef, float radius = 1000.0, bool ignoreUsed = true, ObjectReference ignore1 = none, ObjectReference ignore2 = none)
	if centerRef == none || radius < 0
		return none ; Invalid args
	endIf
	; Check nearest bed first
	ObjectReference NearBed = Game.FindClosestReferenceOfAnyTypeInListFromRef(BedsList, centerRef, radius)
	if CheckBed(NearBed, ignoreUsed) && NearBed != ignore1 && NearBed != ignore2
		return NearBed ; Nearby valid bed found
	elseIf NearBed == none
		return none ; No nearby valid bed found at all, give up.
	endIf
	; Create supression list
	form[] supress = new Form[12]
	supress[11] = ignore1
	supress[10] = ignore2
	; Attempt 10 times before giving up
	int attempts = 10
	while attempts
		attempts -= 1
		; Find nearby
		ObjectReference BedRef = Game.FindRandomReferenceOfAnyTypeInListFromRef(BedsList, centerRef, radius)
		if BedRef == none
			return none ; If none, than none in radius, give up now.
		elseIf supress.Find(BedRef) == -1
			; Add to supression list
			supress[attempts] = BedRef
			; Check if free
			if CheckBed(BedRef, ignoreUsed)
				return BedRef
			endIf
		endIf
	endWhile
	; No beds found in attempts
	return none
endFunction

; int function FindNext(actor[] Positions, sslBaseAnimation Animation, int offset, bool findCreature)
; 	while offset
; 		offset -= 1
; 		if Animation.HasRace(Positions[offset].GetLeveledActorBase().GetRace()) == findCreature
; 			return offset
; 		endIf
; 	endwhile
; 	return -1
; endFunction

; actor[] function SortCreatures(actor[] Positions, sslBaseAnimation Animation)
; 	if Positions.Length < 2 || !Animation.IsCreature
; 		return Positions ; Nothing to sort
; 	endIf
; 	int slot
; 	int i
; 	while i < Positions.Length
; 		; Put non creatures first
; 		if !Animation.HasRace(Positions[i].GetLeveledActorBase().GetRace()) && i > slot
; 			actor moved = Positions[slot]
; 			Positions[slot] = Positions[i]
; 			Positions[i] = moved
; 			slot += 1
; 		endIf
; 		i += 1
; 	endWhile
; 	return Positions
; endFunction
