scriptname sslThreadLibrary extends sslSystemLibrary

import StorageUtil

; Data
FormList property BedsList auto hidden
FormList property DoubleBedsList auto hidden
FormList property BedRollsList auto hidden
Keyword property FurnitureBedRoll auto hidden

; ------------------------------------------------------- ;
; --- Object Locators                                 --- ;
; ------------------------------------------------------- ;

bool function CheckActor(Actor CheckRef, int CheckGender = -1)
	int IsGender = ActorLib.GetGender(CheckRef)
	return ((CheckGender < 2 && IsGender < 2) || (CheckGender >= 2 && IsGender >= 2)) && (CheckGender == -1 || IsGender == CheckGender) && ActorLib.IsValidActor(CheckRef)
endFunction

Actor function FindAvailableActor(ObjectReference CenterRef, float Radius = 5000.0, int FindGender = -1, Actor IgnoreRef1 = none, Actor IgnoreRef2 = none, Actor IgnoreRef3 = none, Actor IgnoreRef4 = none, string RaceKey = "")
	if !CenterRef || FindGender > 3 || FindGender < -1 || Radius < 0.1
		return none ; Invalid args
	endIf
	; Normalize creature genders search
	if RaceKey != "" || FindGender >= 2
		if FindGender == 0 || !Config.UseCreatureGender
			FindGender = 2
		elseIf FindGender == 1
			FindGender = 3
		endIf
	endIf
	; Create supression list
	Form[] Suppressed = new Form[25]
	Suppressed[24] = CenterRef
	Suppressed[23] = IgnoreRef1
	Suppressed[22] = IgnoreRef2
	Suppressed[21] = IgnoreRef3
	Suppressed[20] = IgnoreRef4
	; Attempt 20 times before giving up.
	int i = 20
	while i
		i -= 1
		Actor FoundRef = Game.FindRandomActorFromRef(CenterRef, Radius)
		if !FoundRef || (Suppressed.Find(FoundRef) == -1 && CheckActor(FoundRef, FindGender) && (RaceKey == "" || sslCreatureAnimationSlots.HasRaceID(RaceKey, FoundRef.GetLeveledActorBase().GetRace())))
			return FoundRef ; None means no actor in radius, give up now
		endIf
		Suppressed[i] = FoundRef
	endWhile
	; No actor found in attempts
	return none
endFunction

; TODO: probably needs some love
Actor[] function FindAvailablePartners(actor[] Positions, int total, int males = -1, int females = -1, float radius = 10000.0)
	int needed = (total - Positions.Length)
	if needed <= 0
		return Positions ; Nothing to do
	endIf
	; Get needed gender counts based on current counts
	int[] genders = ActorLib.GenderCount(Positions)
	males -= genders[0]
	females -= genders[1]
	; Loop through until filled or we give up
	int attempts = 30
	while needed && attempts
		; Determine needed gender
		int findGender = -1
		if males > 0 && females < 1
			findGender = 0
		elseif females > 0 && males < 1
			findGender = 1
		endIf
		; Locate actor
		int have = Positions.Length
		actor FoundRef
		if have == 2
			FoundRef = FindAvailableActor(Positions[0], radius, findGender, Positions[1])
		elseif have == 3
			FoundRef = FindAvailableActor(Positions[0], radius, findGender, Positions[1], Positions[2])
		elseif have == 4
			FoundRef = FindAvailableActor(Positions[0], radius, findGender, Positions[1], Positions[2], Positions[3])
		else
			FoundRef = FindAvailableActor(Positions[0], radius, findGender)
		endIf
		; Validate/Add them
		if !FoundRef
			return Positions ; None means no actor in radius, give up now
		elseIf Positions.Find(FoundRef) == -1
			; Add actor
			Positions = PapyrusUtil.PushActor(Positions, FoundRef)
			; Update search counts
			int gender = ActorLib.GetGender(FoundRef)
			males   -= (gender == 0) as int
			females -= (gender == 1) as int
			needed  -= 1
		endIf
		attempts -= 1
	endWhile
	; Output whatever we have at this point
	return Positions
endFunction

Actor[] function SortActors(Actor[] Positions, bool FemaleFirst = true)
	int ActorCount = Positions.Length
	int Priority   = FemaleFirst as int
	if ActorCount < 2 || (ActorCount == 2 && ActorLib.GetGender(Positions[0]) == Priority)
		return Positions ; No need to sort actors.
	endIf
	; Check first occurance of priority gender.
	int[] Genders = ActorLib.GetGendersAll(Positions)
	int i = Genders.Find(Priority)
	if i == -1 ;|| (i == 0 && Genders.RFind(Priority) == 0)
		return Positions ; Prefered gender not present
	endIf
	; Sort actors of priority gender into start of array
	Actor[] Sorted
	while i < ActorCount
		; Priority gender or last actor, just add them.
		if Genders[i] == Priority
			Genders[i] = -1
			Sorted = PapyrusUtil.PushActor(Sorted, Positions[i])
		endIf
		i += 1
	endwhile
	; Insert remaining actors
	i = 0
	while i < ActorCount
		if Genders[i] != -1
			Sorted = PapyrusUtil.PushActor(Sorted, Positions[i])
		endIf
		i += 1
	endWhile
	; Return sorted actor array
	return Sorted
endFunction

int function FindNext(Actor[] Positions, sslBaseAnimation Animation, int offset, bool FindCreature)
	while offset
		offset -= 1
		if Animation.HasRace(Positions[offset].GetLeveledActorBase().GetRace()) == FindCreature
			return offset
		endIf
	endwhile
	return -1
endFunction

Actor[] function SortCreatures(actor[] Positions, sslBaseAnimation Animation)
	if Positions.Length < 2 || !Animation.IsCreature
		return Positions ; Nothing to sort
	endIf
	int slot
	int i
	while i < Positions.Length
		; Put non creatures first
		if !Animation.HasRace(Positions[i].GetLeveledActorBase().GetRace()) && i > slot
			Actor moved = Positions[slot]
			Positions[slot] = Positions[i]
			Positions[i] = moved
			slot += 1
		endIf
		i += 1
	endWhile
	return Positions
endFunction

bool function IsBedRoll(ObjectReference BedRef)
	if BedRef 
		return BedRef.HasKeyword(FurnitureBedRoll) || BedRollsList.HasForm(BedRef.GetBaseObject()) \
			|| StringUtil.Find(BedRef.GetDisplayName(), "roll") != -1 || StringUtil.Find(BedRef.GetDisplayName(), "pile") != -1
	endIf
	return false
endFunction

bool function IsDoubleBed(ObjectReference BedRef)
	return BedRef && DoubleBedsList.HasForm(BedRef.GetBaseObject())
endFunction

bool function IsSingleBed(ObjectReference BedRef)
	return BedRef && BedsList.HasForm(BedRef.GetBaseObject()) && !BedRollsList.HasForm(BedRef.GetBaseObject()) && !DoubleBedsList.HasForm(BedRef.GetBaseObject())
endFunction

int function GetBedType(ObjectReference BedRef)
	if BedRef
		Form BaseRef = BedRef.GetBaseObject()
		if !BedsList.HasForm(BaseRef)
			return 0
		elseIf IsBedRoll(Bedref);BedRollsList.HasForm(BedRef.GetBaseObject()) || BedRef.HasKeyword(FurnitureBedRoll)
			return 1
		elseIf DoubleBedsList.HasForm(BaseRef)
			return 3
		else
			return 2
		endIf
	endIf
	return 0
endFunction

bool function IsBedAvailable(ObjectReference BedRef)
	; Check furniture use
	if !BedRef || BedRef.IsFurnitureInUse(true)
		return false
	endIf
	; Check if used by a current thread
	sslThreadController[] Threads = ThreadSlots.Threads
	int i
	while i < 15
		if Threads[i].BedRef == BedRef
			return false
		endIf
		i += 1
	endwhile
	; Bed is free for use
	return true
endFunction

bool function CheckBed(ObjectReference BedRef, bool IgnoreUsed = true)
	return BedRef && BedRef.IsEnabled() && BedRef.Is3DLoaded() && (!IgnoreUsed || (IgnoreUsed && IsBedAvailable(BedRef)))
endFunction

bool function SameFloor(ObjectReference BedRef, float Z, float Tolerance = 5.0)
	return Math.Abs(Z - BedRef.GetPositionZ()) <= Tolerance
endFunction

ObjectReference function FindBed(ObjectReference CenterRef, float Radius = 1000.0, bool IgnoreUsed = true, ObjectReference IgnoreRef1 = none, ObjectReference IgnoreRef2 = none)
	if !CenterRef || Radius < 1.0
		return none ; Invalid args
	endIf
	; Current elevation to determine bed being on same floor
	float Z = CenterRef.GetPositionZ()
	; Search a couple times for a nearby bed on the same elevation first before looking for random
	ObjectReference NearRef = Game.FindClosestReferenceOfAnyTypeInListFromRef(BedsList, CenterRef, Radius)
	if !NearRef || (NearRef != IgnoreRef1 && NearRef != IgnoreRef2 && SameFloor(NearRef, Z) && CheckBed(NearRef, IgnoreUsed))
		return NearRef
	endIf
	NearRef = Game.FindRandomReferenceOfAnyTypeInListFromRef(BedsList, CenterRef, Radius)
	if !NearRef || (NearRef != IgnoreRef1 && NearRef != IgnoreRef2 && SameFloor(NearRef, Z) && CheckBed(NearRef, IgnoreUsed))
		return NearRef
	endIf
	NearRef = Game.FindRandomReferenceOfAnyTypeInListFromRef(BedsList, CenterRef, Radius)
	if !NearRef || (NearRef != IgnoreRef1 && NearRef != IgnoreRef2 && SameFloor(NearRef, Z) && CheckBed(NearRef, IgnoreUsed))
		return NearRef
	endIf
	; Failover to any random useable bed
	form[] Suppressed = new Form[10]
	Suppressed[9] = NearRef
	Suppressed[8] = IgnoreRef1
	Suppressed[7] = IgnoreRef2
	int i = 7
	while i
		i -= 1
		ObjectReference BedRef = Game.FindRandomReferenceOfAnyTypeInListFromRef(BedsList, CenterRef, Radius)
		if !BedRef || (Suppressed.Find(BedRef) == -1 && CheckBed(BedRef, IgnoreUsed))
			return BedRef ; Found valid bed or none nearby and we should give up
		else
			Suppressed[i] = BedRef ; Add to suppression list
		endIf
	endWhile
	return none ; Nothing found in search loop
endFunction

; ------------------------------------------------------- ;
; --- Actor Tracking                                  --- ;
; ------------------------------------------------------- ;

function TrackActor(Actor ActorRef, string Callback)
	FormListAdd(Config, "TrackedActors", ActorRef, false)
	StringListAdd(ActorRef, "SexLabEvents", Callback, false)
endFunction

function TrackFaction(Faction FactionRef, string Callback)
	FormListAdd(Config, "TrackedFactions", FactionRef, false)
	StringListAdd(FactionRef, "SexLabEvents", Callback, false)
endFunction

function UntrackActor(Actor ActorRef, string Callback)
	StringListRemove(ActorRef, "SexLabEvents", Callback, true)
	if StringListCount(ActorRef, "SexLabEvents") < 1
		FormListRemove(Config, "TrackedActors", ActorRef, true)
	endif
endFunction

function UntrackFaction(Faction FactionRef, string Callback)
	StringListRemove(FactionRef, "SexLabEvents", Callback, true)
	if StringListCount(FactionRef, "SexLabEvents") < 1
		FormListRemove(Config, "TrackedFactions", FactionRef, true)
	endif
endFunction

bool function IsActorTracked(Actor ActorRef)
	if ActorRef == PlayerRef || StringListCount(ActorRef, "SexLabEvents") > 0
		return true
	endIf
	int i = FormListCount(Config, "TrackedFactions")
	while i
		i -= 1
		Faction FactionRef = FormListGet(Config, "TrackedFactions", i) as Faction
		if FactionRef && ActorRef.IsInFaction(FactionRef)
			return true
		endIf
	endWhile
	return false
endFunction

function SendTrackedEvent(Actor ActorRef, string Hook = "", int id = -1)
	; Append hook type, global if empty
	if Hook != ""
		Hook = "_"+Hook
	endIf
	; Send generic player callback event
	if ActorRef == PlayerRef
		SetupActorEvent(PlayerRef, "PlayerTrack"+Hook, id)
	endIf
	; Send actor callback events
	int i = StringListCount(ActorRef, "SexLabEvents")
	while i
		i -= 1
		SetupActorEvent(ActorRef, StringListGet(ActorRef, "SexLabEvents", i)+Hook, id)
	endWhile
	; Send faction callback events
	i = FormListCount(Config, "TrackedFactions")
	while i
		i -= 1
		Faction FactionRef = FormListGet(Config, "TrackedFactions", i) as Faction
		if FactionRef && ActorRef.IsInFaction(FactionRef)
			int n = StringListCount(FactionRef, "SexLabEvents")
			while n
				n -= 1
				SetupActorEvent(ActorRef, StringListGet(FactionRef, "SexLabEvents", n)+Hook, id)
			endwhile
		endIf
	endWhile
endFunction

function SetupActorEvent(Actor ActorRef, string Callback, int id = -1)
	int eid = ModEvent.Create(Callback)
	ModEvent.PushForm(eid, ActorRef)
	ModEvent.PushInt(eid, id)
	ModEvent.Send(eid)
endFunction

; ------------------------------------------------------- ;
; --- System use only                                 --- ;
; ------------------------------------------------------- ;

function Setup()
	parent.Setup()
	BedsList       = Config.BedsList
	DoubleBedsList = Config.DoubleBedsList
	BedRollsList   = Config.BedRollsList
	FurnitureBedRoll = Config.FurnitureBedRoll
endFunction
