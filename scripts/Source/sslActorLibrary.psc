scriptname sslActorLibrary extends sslSystemLibrary

; Data
Faction property AnimatingFaction auto
Faction property GenderFaction auto
Faction property ForbiddenFaction auto
Weapon property DummyWeapon auto
Armor property NudeSuit auto
form[] property Strapons auto hidden

Spell property CumVaginalOralAnalSpell auto
Spell property CumOralAnalSpell auto
Spell property CumVaginalOralSpell auto
Spell property CumVaginalAnalSpell auto
Spell property CumVaginalSpell auto
Spell property CumOralSpell auto
Spell property CumAnalSpell auto

Keyword property CumOralKeyword auto
Keyword property CumAnalKeyword auto
Keyword property CumVaginalKeyword auto
Keyword property ActorTypeNPC auto

; FormList property ValidActorList auto
; FormList property NoStripList auto
; FormList property StripList auto

Furniture property BaseMarker auto
Package property DoNothing auto

; Local

;/-----------------------------------------------\;
;|	Actor Handling/Effect Functions              |;
;\-----------------------------------------------/;

Actor[] function MakeActorArray(Actor Actor1 = none, Actor Actor2 = none, Actor Actor3 = none, Actor Actor4 = none, Actor Actor5 = none)
	Actor[] output
	if Actor1 != none
		output = sslUtility.PushActor(Actor1, output)
	endIf
	if Actor2 != none
		output = sslUtility.PushActor(Actor2, output)
	endIf
	if Actor3 != none
		output = sslUtility.PushActor(Actor3, output)
	endIf
	if Actor4 != none
		output = sslUtility.PushActor(Actor4, output)
	endIf
	if Actor5 != none
		output = sslUtility.PushActor(Actor5, output)
	endIf
	return output
endFunction

bool function CheckActor(Actor CheckRef, int CheckGender = -1)
	int IsGender = GetGender(CheckRef)
	return (CheckGender != 2 && IsGender != 2 && (CheckGender == -1 || IsGender == CheckGender) && IsValidActor(CheckRef))
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
	int[] genders = GenderCount(Positions)
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
			int gender = GetGender(FoundRef)
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
		if GetGender(ActorRef) != PriorityGender
			int n = (i + 1)
			while n < ActorCount
				; Swap for actor who has correct gender
				if GetGender(Positions[n]) == PriorityGender
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

function ApplyCum(Actor ActorRef, int CumID)
	AddCum(ActorRef, (cumID == 1 || cumID == 4 || cumID == 5 || cumID == 7), (cumID == 2 || cumID == 4 || cumID == 6 || cumID == 7), (cumID == 3 || cumID == 5 || cumID == 6 || cumID == 7))
endFunction

function AddCum(Actor ActorRef, bool Vaginal = true, bool Oral = true, bool Anal = true)
	Vaginal = Vaginal || ActorRef.HasMagicEffectWithKeyword(CumVaginalKeyword)
	Oral = Oral || ActorRef.HasMagicEffectWithKeyword(CumOralKeyword)
	Anal = Anal || ActorRef.HasMagicEffectWithKeyword(CumAnalKeyword)
	; To specific a scenario to really warrant the check
	; bool ToggleGhost = ActorRef.IsGhost()
	; if ToggleGhost
	; 	ActorRef.SetGhost(false)
	; endIf
	if Vaginal && !Oral && !Anal
		CumVaginalSpell.Cast(ActorRef, ActorRef)
	elseIf Oral && !Vaginal && !Anal
		CumOralSpell.Cast(ActorRef, ActorRef)
	elseIf Anal && !Vaginal && !Oral
		CumAnalSpell.Cast(ActorRef, ActorRef)
	elseIf Vaginal && Oral && !Anal
		CumVaginalOralSpell.Cast(ActorRef, ActorRef)
	elseIf Vaginal && Anal && !Oral
		CumVaginalAnalSpell.Cast(ActorRef, ActorRef)
	elseIf Oral && Anal && !Vaginal
		CumOralAnalSpell.Cast(ActorRef, ActorRef)
	else
		CumVaginalOralAnalSpell.Cast(ActorRef, ActorRef)
	endIf
	; if ToggleGhost
	; 	ActorRef.SetGhost(true)
	; endIf
endFunction

function ClearCum(Actor ActorRef)
	ActorRef.DispelSpell(CumVaginalSpell)
	ActorRef.DispelSpell(CumOralSpell)
	ActorRef.DispelSpell(CumAnalSpell)
	ActorRef.DispelSpell(CumVaginalOralSpell)
	ActorRef.DispelSpell(CumVaginalAnalSpell)
	ActorRef.DispelSpell(CumOralAnalSpell)
	ActorRef.DispelSpell(CumVaginalOralAnalSpell)
endFunction

;/-----------------------------------------------\;
;|	Equipment Functions                          |;
;\-----------------------------------------------/;

form[] function StripActor(Actor ActorRef, Actor VictimRef = none, bool DoAnimate = true, bool LeadIn = false)
	return StripSlots(ActorRef, Config.GetStrip((GetGender(ActorRef) == 1), LeadIn, (VictimRef != none), (VictimRef != none && ActorRef == VictimRef)), DoAnimate)
endFunction

bool function IsStrippable(form ItemRef)
	; Check previous validations
	if ItemRef != none && StorageUtil.FormListFind(self, "SexLab.StripList", ItemRef) != -1
		return true
	elseIf ItemRef == none || StorageUtil.FormListFind(self, "SexLab.NoStripList", ItemRef) != -1
		return false
	endIf
	; Check keywords
	int i = ItemRef.GetNumKeywords()
	while i
		i -= 1
		string kw = ItemRef.GetNthKeyword(i).GetString()
		if StringUtil.Find(kw, "NoStrip") != -1 || StringUtil.Find(kw, "Bound") != -1
			StorageUtil.FormListAdd(self, "SexLab.NoStripList", ItemRef, true)
			return false
		endIf
	endWhile
	StorageUtil.FormListAdd(self, "SexLab.StripList", ItemRef, true)
	return true
endFunction

form function StripSlot(Actor ActorRef, int SlotMask)
	form ItemRef = ActorRef.GetWornForm(SlotMask)
	if IsStrippable(ItemRef)
		ActorRef.UnequipItem(ItemRef, false, true)
		; StorageUtil.FormListAdd(ActorRef, "SexLab.StrippedItems", ItemRef)
	endIf
	return ItemRef
endFunction

form[] function StripSlots(Actor ActorRef, bool[] Strip, bool DoAnimate = false, bool AllowNudesuit = true, int Gender = 0)
	if Strip.Length != 33
		return none
	endIf
	; Start stripping animation
	if DoAnimate
		Debug.SendAnimationEvent(ActorRef, "Arrok_Undress_G"+Gender)
	endIf
	form[] Stripped = new form[34]
	; Strip weapon
	if Strip[32]
		Stripped[33] = ActorRef.GetEquippedWeapon(true)
		Stripped[32] = ActorRef.GetEquippedWeapon(false)
		if Stripped[33] != none || Stripped[32] != none
			ActorRef.AddItem(DummyWeapon, 1, true)
			ActorRef.EquipItem(DummyWeapon, false, true)
			ActorRef.UnEquipItem(DummyWeapon, false, true)
			ActorRef.RemoveItem(DummyWeapon, 1, true)
		endIf
	endIf
	; Strip armors
	int i = 32
	while i
		i -= 1
		if Strip[i]
			Stripped[i] = StripSlot(ActorRef, Armor.GetMaskForSlot(i + 30))
			if Stripped[i] && DoAnimate
				Utility.Wait(0.25)
			endIf
		endIf
	endWhile
	; Apply Nudesuit
	if Strip[2] && AllowNudesuit && ((Gender == 0 && Config.bUseMaleNudeSuit) || (Gender == 1  && Config.bUseFemaleNudeSuit)) && !ActorRef.IsEquipped(NudeSuit)
		; ActorRef.AddItem(NudeSuit, 1, true)
		ActorRef.EquipItem(NudeSuit, false, true)
	endIf
	return sslUtility.ClearNone(Stripped)
endFunction

function UnstripActor(Actor ActorRef, form[] Stripped, bool IsVictim = false)
	int i = Stripped.Length
	; Remove nudesuits
	if ActorRef.IsEquipped(NudeSuit)
		ActorRef.UnequipItem(NudeSuit, true, true)
		ActorRef.RemoveItem(NudeSuit, 1, true)
	elseIf IsVictim && !Config.bReDressVictim
		return ; Actor is victim, don't redress
	endIf
	; Equip stripped
	int hand = 1
	while i
		i -= 1
		if Stripped[i]
			int type = Stripped[i].GetType()
			if type == 22 || type == 82
				ActorRef.EquipSpell((Stripped[i] as Spell), hand)
			else
				ActorRef.EquipItem(Stripped[i], false, true)
			endIf
			; Move to other hand if weapon, light, spell, or leveledspell
			hand -= ((hand == 1 && (type == 41 || type == 31 || type == 22 || type == 82)) as int)
		endIf
	endWhile
endFunction

form[] function GetStripped(Actor ActorRef)
	int i = StorageUtil.FormListCount(ActorRef, "SexLab.StrippedItems")
	form[] output = sslUtility.FormArray(i)
	while i
		i -= 1
		output[i] = StorageUtil.FormListGet(ActorRef, "SexLab.StrippedItems", i)
	endWhile
	return output
endFunction

function StoreStripped(Actor ActorRef, bool[] Strip, bool DoAnimate = false, bool AllowNudesuit = true, int Gender = 0)
	form[] Stripped = StripSlots(ActorRef, Strip, DoAnimate, AllowNudesuit, Gender)
	int i = Stripped.Length
	while i
		i -= 1
		StorageUtil.FormListAdd(ActorRef, "SexLab.StrippedItems", Stripped[i])
	endWhile
endFunction

function UnstripStored(Actor ActorRef, bool IsVictim = false)
	UnstripActor(ActorRef, GetStripped(ActorRef), IsVictim)
	StorageUtil.FormListClear(ActorRef, "SexLab.StrippedItems")
endFunction

; ------------------------------------------------------- ;
; --- Strapon Functions                               --- ;
; ------------------------------------------------------- ;

form function WornStrapon(Actor ActorRef)
	int i = Strapons.Length
	while i
		i -= 1
		if ActorRef.IsEquipped(Strapons[i])
			return Strapons[i]
		endIf
	endWhile
	return none
endFunction

bool function HasStrapon(Actor ActorRef)
	return WornStrapon(ActorRef) != none
endFunction

form function PickStrapon(Actor ActorRef)
	form strapon = WornStrapon(ActorRef)
	if strapon != none
		return strapon
	endIf
	return Strapons[Utility.RandomInt(0, Strapons.Length - 1)]
endFunction

form function EquipStrapon(Actor ActorRef)
	if GetGender(ActorRef) == 1
		form strapon = PickStrapon(ActorRef)
		if strapon != none
			ActorRef.AddItem(strapon, 1, true)
			ActorRef.EquipItem(strapon, false, true)
		endIf
		return strapon
	endIf
	return none
endFunction

function UnequipStrapon(Actor ActorRef)
	if GetGender(ActorRef) == 1
		int i = Strapons.Length
		while i
			i -= 1
			if ActorRef.IsEquipped(Strapons[i])
				ActorRef.UnequipItem(Strapons[i], false, true)
				ActorRef.RemoveItem(Strapons[i], 1, true)
			endIf
		endWhile
	endIf
endFunction

Armor function LoadStrapon(string esp, int id)
	Armor strapon = Game.GetFormFromFile(id, esp) as Armor
	if strapon != none
		Strapons = sslUtility.PushForm(strapon, Strapons)
	endif
	return strapon
endFunction

; ------------------------------------------------------- ;
; --- Actor Validation                                --- ;
; ------------------------------------------------------- ;

bool function IsActorActive(Actor ActorRef)
	return StorageUtil.FormListFind(self, "Registry", ActorRef) != -1
endFunction

int function ValidateActor(Actor ActorRef)
	if !ActorRef
		Log("ValidateActor() -- Failed to validate (NONE) -- Because they don't exist.")
		return -1
	elseIf IsActorActive(ActorRef)
		Log("ValidateActor() -- Failed to validate ("+ActorRef.GetLeveledActorBase().GetName()+") -- They appear to already be animating")
		return -10
	endIf
	; TODO: Doing this also means passing creatures that may have had animation disabled, might want to check that as well before bypassing
	if StorageUtil.FormListFind(self, "SexLab.ValidActors", ActorRef) != -1
		Log("ValidateActor() -- Validated ("+ActorRef.GetLeveledActorBase().GetName()+") -- CACHE HIT")
		return 1
	elseIf !CanAnimate(ActorRef)
		Log("ValidateActor() -- Failed to validate ("+ActorRef.GetLeveledActorBase().GetName()+") -- They are forbidden from animating")
		return -11
	elseIf !ActorRef.Is3DLoaded()
		Log("ValidateActor() -- Failed to validate ("+ActorRef.GetLeveledActorBase().GetName()+") -- They are not loaded")
		return -12
	elseIf ActorRef.IsDead()
		Log("ValidateActor() -- Failed to validate ("+ActorRef.GetLeveledActorBase().GetName()+") -- He's dead Jim.")
		return -13
	elseIf ActorRef.IsDisabled()
		Log("ValidateActor() -- Failed to validate ("+ActorRef.GetLeveledActorBase().GetName()+") -- They are disabled")
		return -14
	elseIf ActorRef.IsFlying()
		Log("ValidateActor() -- Failed to validate ("+ActorRef.GetLeveledActorBase().GetName()+") -- They are flying.")
		return -15
	elseIf ActorRef != PlayerRef && !ActorRef.HasKeyword(ActorTypeNPC) && !CreatureSlots.AllowedCreature(ActorRef.GetLeveledActorBase().GetRace())
		Log("ValidateActor() -- Failed to validate ("+ActorRef.GetLeveledActorBase().GetName()+") -- They are a creature that is currently not supported ("+ActorRef.GetLeveledActorBase().GetName()+")")
		return -16
	endIf
	StorageUtil.FormListAdd(self, "SexLab.ValidActors", ActorRef, false)
	return 1
endFunction

bool function CanAnimate(Actor ActorRef)
	Race ActorRace = ActorRef.GetLeveledActorBase().GetRace()
	String RaceName = ActorRace.GetName()+MiscUtil.GetRaceEditorID(ActorRace)
	return !(ActorRef.IsInFaction(ForbiddenFaction) || ActorRace.IsRaceFlagSet(0x00000004) || StringUtil.Find(RaceName, "Child") != -1  || StringUtil.Find(RaceName, "Little") != -1 || StringUtil.Find(RaceName, "117") != -1 || StringUtil.Find(RaceName, "Elin") != -1   || StringUtil.Find(RaceName, "Enfant") != -1 || (StringUtil.Find(RaceName, "Monli") != -1 && ActorRef.GetScale() < 0.93))
endFunction

bool function IsValidActor(Actor ActorRef)
	return ValidateActor(ActorRef) == 1
endFunction

function ForbidActor(Actor ActorRef)
	ActorRef.AddToFaction(ForbiddenFaction)
endFunction

function AllowActor(Actor ActorRef)
	ActorRef.RemoveFromFaction(ForbiddenFaction)
endFunction

bool function IsForbidden(Actor ActorRef)
	return ActorRef.IsInFaction(ForbiddenFaction) ;|| ActorRef.HasKeyWordString("SexLabForbid")
endFunction

; ------------------------------------------------------- ;
; --- Gender Functions                                --- ;
; ------------------------------------------------------- ;

function TreatAsMale(Actor ActorRef)
	ActorRef.SetFactionRank(GenderFaction, 0)
endFunction

function TreatAsFemale(Actor ActorRef)
	ActorRef.SetFactionRank(GenderFaction, 1)
endFunction

function ClearForcedGender(Actor ActorRef)
	ActorRef.RemoveFromFaction(GenderFaction)
endFunction

int function GetGender(Actor ActorRef)
	if ActorRef.IsInFaction(GenderFaction)
		return ActorRef.GetFactionRank(GenderFaction)
	endIf
	ActorBase Base = ActorRef.GetLeveledActorBase()
	if StorageUtil.GetIntValue(Base.GetRace(), "SexLab.HasRace") == 1
		return 2 ; Creature
	endIf
	return Base.GetSex() ; Default
endFunction

int[] function GenderCount(Actor[] Positions)
	int[] Genders = new int[3]
	int i = Positions.Length
	while i
		i -= 1
		int g = GetGender(Positions[i])
		Genders[g] = Genders[g] + 1
	endWhile
	return Genders
endFunction

bool function IsCreature(Actor ActorRef)
	return CreatureSlots.AllowedCreature(ActorRef.GetLeveledActorBase().GetRace())
endFunction

int function MaleCount(Actor[] Positions)
	return GenderCount(Positions)[0]
endFunction

int function FemaleCount(Actor[] Positions)
	return GenderCount(Positions)[1]
endFunction

int function CreatureCount(Actor[] Positions)
	return GenderCount(Positions)[2]
endFunction

string function MakeGenderTag(Actor[] Positions)
	string Tag
	int[] Genders = ActorLib.GenderCount(Positions)
	while Genders[1]
		Genders[1] = (Genders[1] - 1)
		Tag += "F"
	endWhile
	while Genders[0]
		Genders[0] = (Genders[0] - 1)
		Tag += "M"
	endWhile
	while Genders[2]
		Genders[2] = (Genders[2] - 1)
		Tag += "C"
	endWhile
	return Tag
endFunction

string function GetGenderTag(int Females = 0, int Males = 0, int Creatures = 0)
	string Tag
	while Females
		Females -= 1
		Tag += "F"
	endWhile
	while Males
		Males -= 1
		Tag += "M"
	endWhile
	while Creatures
		Creatures -= 1
		Tag += "C"
	endWhile
	return Tag
endFunction
