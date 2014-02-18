scriptname sslThreadLibrary extends sslSystemLibrary

; Data
Sound property OrgasmFX auto
Static property LocationMarker auto
FormList property BedsList auto
FormList property BedRollsList auto
Message property UseBed auto

; bool function IsActorFree(actor position)
;	return Threads.FindActorController(position) == -1
; endFunction

bool function CheckBed(ObjectReference BedRef, bool IgnoreUsed = true)
	return BedRef != none && BedRef.IsEnabled() && BedRef.Is3DLoaded() && (!IgnoreUsed || (IgnoreUsed && !BedRef.IsFurnitureInUse(true)))
endFunction

ObjectReference function FindBed(ObjectReference CenterRef, float Radius = 1000.0, bool IgnoreUsed = true, ObjectReference IgnoreRef1 = none, ObjectReference IgnoreRef2 = none)
	if CenterRef == none || Radius < 1.0
		return none ; Invalid args
	endIf
	; Search for a nearby bed first before looking for random
	ObjectReference NearRef = Game.FindClosestReferenceOfAnyTypeInListFromRef(BedsList, CenterRef, Radius)
	if NearRef == none || (CheckBed(NearRef, IgnoreUsed) && NearRef != IgnoreRef1 && NearRef != IgnoreRef2)
		return NearRef ; Use the nearby bed if found, if none than give up now and just return none
	endIf
	form[] Suppressed = new Form[10]
	Suppressed[9] = NearRef
	Suppressed[8] = IgnoreRef1
	Suppressed[7] = IgnoreRef2
	int i = 7
	while i
		i -= 1
		ObjectReference BedRef = Game.FindRandomReferenceOfAnyTypeInListFromRef(BedsList, CenterRef, Radius)
		if BedRef == none || (Suppressed.Find(BedRef) == -1 && CheckBed(BedRef, IgnoreUsed))
			return BedRef ; Found valid bed or none nearby and we should give up
		else
			Suppressed[i] = BedRef ; Add to suppression list
		endIf
	endWhile
	return none ; Nothing found in search loop
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
