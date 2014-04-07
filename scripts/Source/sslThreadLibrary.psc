scriptname sslThreadLibrary extends sslSystemLibrary

; Data
Sound property OrgasmFX auto hidden
Sound property SquishingFX auto hidden
Sound property SuckingFX auto hidden
Sound property SexMixedFX auto hidden

Static property LocationMarker auto hidden
FormList property BedsList auto hidden
FormList property BedRollsList auto hidden
Message property CheckFNIS auto hidden
Message property UseBed auto hidden

Topic property LipSync auto hidden
VoiceType property SexLabVoiceM auto hidden
VoiceType property SexLabVoiceF auto hidden
FormList property VoicesPlayer auto hidden

bool function CheckFNIS()
	Game.ForceThirdPerson()
	if PlayerRef.GetAnimationVariableInt("SexLabVer") < 150 || PlayerRef.GetAnimationVariableInt("FNISmajor") < 5
		CheckFNIS.Show(5.0)
		return false
	endIf
	return true
endFunction

bool function CheckActor(Actor CheckRef, int CheckGender = -1)
	int IsGender = ActorLib.GetGender(CheckRef)
	return (CheckGender != 2 && IsGender != 2 && (CheckGender == -1 || IsGender == CheckGender) && ActorLib.IsValidActor(CheckRef))
endFunction

Actor function FindAvailableActor(ObjectReference CenterRef, float Radius = 5000.0, int FindGender = -1, actor IgnoreRef1 = none, actor IgnoreRef2 = none, actor IgnoreRef3 = none, actor IgnoreRef4 = none)
	if CenterRef == none || FindGender > 2 || FindGender < -1 || Radius < 0.1
		return none ; Invalid args
	endIf
	; Create supression list
	form[] Suppressed = new form[25]
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
		if FoundRef == none || (Suppressed.Find(FoundRef) == -1 && CheckActor(FoundRef, FindGender))
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
	if needed <= 0 || Positions.Length < 1
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
		if FoundRef == none
			return Positions ; None means no actor in radius, give up now
		elseIf Positions.Find(FoundRef) == -1
			; Add actor
			Positions = sslUtility.PushActor(FoundRef, Positions)
			; Update search counts
			int gender = ActorLib.GetGender(FoundRef)
			males -= (gender == 0) as int
			females -= (gender == 1) as int
			needed -= 1
		endIf
		attempts -= 1
	endWhile
	; Output whatever we have at this point
	return Positions
endFunction

Actor[] function SortActors(Actor[] Positions, bool FemaleFirst = true)
	int ActorCount = Positions.Length
	if ActorCount < 2
		return Positions ; Why reorder a single actor?
	endIf
	int PriorityGender = (FemaleFirst as int)
	Actor[] Sorted = sslUtility.ActorArray(ActorCount)
	int i
	while i < ActorCount
		; Fill actor into sorted array
		Actor ActorRef = Positions[i]
		Sorted[i] = ActorRef
		; Check if actor is proper gender
		if ActorLib.GetGender(ActorRef) != PriorityGender
			int n = (i + 1)
			while n < ActorCount
				; Swap for actor who has correct gender
				if ActorLib.GetGender(Positions[n]) == PriorityGender
					Actor NextRef = Positions[n]
					Sorted[i] = NextRef
					Positions[i] = NextRef
					Positions[n] = ActorRef
					n = ActorCount
				endIf
				n += 1
			endWhile
		endIf
		i += 1
	endWhile
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

function Setup()
	parent.Setup()
	OrgasmFX       = Config.OrgasmFX
	SquishingFX    = Config.SquishingFX
	SuckingFX      = Config.SuckingFX
	SexMixedFX     = Config.SexMixedFX
	LocationMarker = Config.LocationMarker
	BedsList       = Config.BedsList
	BedRollsList   = Config.BedRollsList
	CheckFNIS      = Config.CheckFNIS
	UseBed         = Config.UseBed
	LipSync        = Config.LipSync
	SexLabVoiceM   = Config.SexLabVoiceM
	SexLabVoiceF   = Config.SexLabVoiceF
	VoicesPlayer   = Config.VoicesPlayer
endFunction
