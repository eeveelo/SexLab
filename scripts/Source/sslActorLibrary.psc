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

Keyword property kwCumOral auto
Keyword property kwCumAnal auto
Keyword property kwCumVaginal auto

FormList property ValidActorList auto
FormList property NoStripList auto
FormList property StripList auto

Furniture property BaseMarker auto
Package property DoNothing auto


; Local


;/-----------------------------------------------\;
;|	Actor Handling/Effect Functions              |;
;\-----------------------------------------------/;

actor[] function MakeActorArray(actor a1 = none, actor a2 = none, actor a3 = none, actor a4 = none, actor a5 = none)
	actor[] output
	if a1 != none
		output = sslUtility.PushActor(a1, output)
	endIf
	if a2 != none
		output = sslUtility.PushActor(a2, output)
	endIf
	if a3 != none
		output = sslUtility.PushActor(a3, output)
	endIf
	if a4 != none
		output = sslUtility.PushActor(a4, output)
	endIf
	if a5 != none
		output = sslUtility.PushActor(a5, output)
	endIf
	return output
endFunction

actor function FindAvailableActor(ObjectReference centerRef, float radius = 5000.0, int findGender = -1, actor ignore1 = none, actor ignore2 = none, actor ignore3 = none, actor ignore4 = none)
	if centerRef == none || findGender > 2 || findGender < -1 || radius < 0
		return none ; Invalid args
	endIf
	; Create supression list
	form[] supress = new form[35]
	supress[34] = centerRef
	supress[33] = ignore1
	supress[32] = ignore2
	supress[31] = ignore3
	supress[30] = ignore4
	; Attempt 30 times before giving up.
	int attempts = 30
	while attempts
		attempts -= 1
		; Get random actor
		actor FoundRef = Game.FindRandomActorFromRef(centerRef, radius)
		if FoundRef == none
			return none ; None means no actor in radius, give up now
		endIf
		; Validate actor
		int gender
		bool valid = supress.Find(FoundRef) == -1
		if valid
			; Get their gender if we need it
			gender = GetGender(FoundRef)
			; Supress from future validation attempts
			supress[attempts] = FoundRef
		endIf
		valid = valid && (findGender != 2 && gender != 2) ; Supress creatures
		valid = valid && (findGender == -1 || findGender == gender) ; Validate gender
		valid = valid && IsValidActor(FoundRef) ; Actor Validate
		if valid
			return FoundRef ; Actor passed validation, end loop/function
		endIf
	endWhile
	; No actor found in attempts
	return none
endFunction

actor[] function FindAvailablePartners(actor[] Positions, int total, int males = -1, int females = -1, float radius = 10000.0)
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

actor[] function SortActors(actor[] Positions, bool femaleFirst = true)
	if Positions.Length < 2
		return Positions ; Why reorder a single actor?
	endIf
	int len = Positions.Length
	int Female = femaleFirst as int
	actor[] Sorted = sslUtility.ActorArray(len)
	int i
	while i < len
		; Fill actor into sorted array
		actor ActorRef = Positions[i]
		Sorted[i] = ActorRef
		; Check if actor is proper gender
		if GetGender(ActorRef) != Female
			int n = (i + 1)
			while n < len
				actor NextRef = Positions[n]
				; Swap for actor who has correct gender
				if GetGender(NextRef) == Female
					Sorted[i] = NextRef
					Positions[i] = NextRef
					Positions[n] = ActorRef
					n = len
				endIf
				n += 1
			endWhile
		endIf
		i += 1
	endWhile
	return Sorted
endFunction

function ApplyCum(actor a, int cumID)
	; Apply passed id
	AddCum(a, (cumID == 1 || cumID == 4 || cumID == 5 || cumID == 7), (cumID == 2 || cumID == 4 || cumID == 6 || cumID == 7), (cumID == 3 || cumID == 5 || cumID == 6 || cumID == 7))
endFunction

function AddCum(actor a, bool vaginal = true, bool oral = true, bool anal = true)
	vaginal = vaginal || a.HasMagicEffectWithKeyword(kwCumVaginal)
	oral = oral || a.HasMagicEffectWithKeyword(kwCumOral)
	anal = anal || a.HasMagicEffectWithKeyword(kwCumAnal)
	bool ToggleGhost = a.IsGhost()
	if ToggleGhost
		a.SetGhost(false)
	endIf
	if vaginal && !oral && !anal
		CumVaginalSpell.Cast(a, a)
	elseIf oral && !vaginal && !anal
		CumOralSpell.Cast(a, a)
	elseIf anal && !vaginal && !oral
		CumAnalSpell.Cast(a, a)
	elseIf vaginal && oral && !anal
		CumVaginalOralSpell.Cast(a, a)
	elseIf vaginal && anal && !oral
		CumVaginalAnalSpell.Cast(a, a)
	elseIf oral && anal && !vaginal
		CumOralAnalSpell.Cast(a, a)
	else
		CumVaginalOralAnalSpell.Cast(a, a)
	endIf
	if ToggleGhost
		a.SetGhost(true)
	endIf
endFunction

function ClearCum(actor a)
	a.DispelSpell(CumVaginalSpell)
	a.DispelSpell(CumOralSpell)
	a.DispelSpell(CumAnalSpell)
	a.DispelSpell(CumVaginalOralSpell)
	a.DispelSpell(CumVaginalAnalSpell)
	a.DispelSpell(CumOralAnalSpell)
	a.DispelSpell(CumVaginalOralAnalSpell)
endFunction

;/-----------------------------------------------\;
;|	Equipment Functions                          |;
;\-----------------------------------------------/;

function StripAnimation(actor a)
	; Determine gender and animation switch
	int gender = a.GetLeveledActorBase().GetSex()
	if gender == 1
		Debug.SendAnimationEvent(a, "Arrok_FemaleUndress")
	else
		Debug.SendAnimationEvent(a, "Arrok_MaleUndress")
	endIf
endFunction

form[] function StripActor(actor a, actor victim = none, bool animate = true, bool leadIn = false)
	return StripSlots(a, GetStrip(a, victim, leadIn), animate)
endFunction

bool[] function GetStrip(actor a, actor victim, bool leadin)
	bool female = GetGender(a) == 1
	if leadin && !female
		return Config.bStripLeadInMale
	elseif leadin && female
		return Config.bStripLeadInFemale
 	elseif victim != none && a == victim
		return Config.bStripVictim
 	elseif victim != none && a != victim
 		return Config.bStripAggressor
 	elseif victim == none && !female
 		return Config.bStripMale
 	else
 		return Config.bStripFemale
 	endIf
endFunction

bool function IsStrippable(form item)
	; Check previous validations
	if item != none && StorageUtil.FormListFind(none, "SexLab.StripList", item) != -1
		return true
	elseIf item == none || StorageUtil.FormListFind(none, "SexLab.NoStripList", item) != -1
		return false
	endIf
	; Check keywords
	int i = item.GetNumKeywords()
	while i
		i -= 1
		string kw = item.GetNthKeyword(i).GetString()
		if StringUtil.Find(kw, "NoStrip") != -1 || StringUtil.Find(kw, "Bound") != -1
			StorageUtil.FormListAdd(none, "SexLab.NoStripList", item, true)
			return false
		endIf
	endWhile
	StorageUtil.FormListAdd(none, "SexLab.StripList", item, true) != -1
	return true
endFunction

form function StripSlot(actor a, int slotmask, bool store = false)
	form item = a.GetWornForm(slotmask)
	if item != none && IsStrippable(item)
		a.UnequipItem(item, false, true)
		if store
			StorageUtil.FormListAdd(a, "SexLab.StrippedItems", item)
		endIf
		return item
	endIf
	return none
endFunction

form function StripWeapon(actor a, bool rightHand = true, bool store = false)
	Weapon item = a.GetEquippedWeapon(rightHand)
	if item != none && IsStrippable(item)
		int type = a.GetEquippedItemType((rightHand as int))
		if type == 5 || type == 6 || type == 7
			a.AddItem(DummyWeapon, 1, true)
			a.EquipItem(DummyWeapon, false, true)
			a.UnEquipItem(DummyWeapon, false, true)
			a.RemoveItem(DummyWeapon, 1, true)
		else
			a.UnequipItem(item, false, true)
		endIf
		if store
			StorageUtil.FormListAdd(a, "SexLab.StrippedItems", item)
		endIf
		return item
	endIf
	return none
endFunction

form[] function StripSlots(actor a, bool[] strip, bool animate = false, bool allowNudesuit = true)
	if strip.Length != 33
		return none
	endIf

	; Start stripping animation
	if animate
		StripAnimation(a)
	endIf
	; Item storage
	form[] items = new form[34]
	; Strip weapon
	if strip[32]
		items[32] = StripWeapon(a, true)
		items[33] = StripWeapon(a, false)
		if animate && (items[32] != none || items[32] != none)
			Utility.Wait(0.15)
		endIf
	endIf
	; Strip armors
	int i
	while i < 32
		if strip[i]
			items[i] = StripSlot(a, Armor.GetMaskForSlot(i + 30))
			if animate && items[i] != none
				Utility.Wait(0.15)
			endIf
		endIf
		i += 1
	endWhile
	; Apply Nudesuit
	if strip[2] && allowNudesuit && (Config.bUseMaleNudeSuit || Config.bUseFemaleNudeSuit)
		int gender = a.GetLeveledActorBase().GetSex()
		if (gender == 0 && Config.bUseMaleNudeSuit) || (gender == 1  && Config.bUseFemaleNudeSuit)
			a.AddItem(NudeSuit, 1, true)
			a.EquipItem(NudeSuit, false, true)
		endIf
	endIf
	return sslUtility.ClearNone(items)
endFunction

function UnstripActor(actor a, form[] stripped, actor victim = none)
	int i = stripped.Length
	if i < 1
		return
	endIf
	; Remove nudesuits
	if a.IsEquipped(NudeSuit)
		a.UnequipItem(NudeSuit, true, true)
		a.RemoveItem(NudeSuit, 1, true)
	endIf
	if a == victim && !Config.bReDressVictim
		return ; Don't requip victims
	endIf
	; Requip stripped
	int hand = 1
	while i
		i -= 1
		if stripped[i] != none
			int type = stripped[i].GetType()
			if type == 22 || type == 82
				a.EquipSpell(stripped[i] as spell, hand)
			else
				a.EquipItem(stripped[i], false, true)
			endIf
			; Move to other hand if weapon, light, spell, or leveledspell
			hand -= ((hand == 1 && (type == 41 || type == 31 || type == 22 || type == 82)) as int)
		endIf
		Utility.Wait(0.25)
	endWhile
endFunction

function StripActorStorage(actor a, bool[] strip, bool animate = false, bool allowNudesuit = true)
	if strip.Length != 33
		return none
	endIf
	; Start stripping animation
	if animate
		StripAnimation(a)
	endIf
	; Strip weapon
	if strip[32]
		StripWeapon(a, true, true)
		StripWeapon(a, false, true)
	endIf
	; Strip armors
	int i
	while i < 32
		if strip[i] && StripSlot(a, Armor.GetMaskForSlot(i + 30), true) != none && animate
			Utility.Wait(0.15)
		endIf
		i += 1
	endWhile
	; Apply Nudesuit
	if strip[2] && allowNudesuit && (Config.bUseMaleNudeSuit || Config.bUseFemaleNudeSuit)
		int gender = a.GetLeveledActorBase().GetSex()
		if (gender == 0 && Config.bUseMaleNudeSuit) || (gender == 1  && Config.bUseFemaleNudeSuit)
			a.AddItem(NudeSuit, 1, true)
			a.EquipItem(NudeSuit, false, true)
		endIf
	endIf
endFunction

function UnstripActorStorage(actor a, bool IsVictim = false)
	; Remove nudesuits
	if a.IsEquipped(NudeSuit)
		a.UnequipItem(NudeSuit, true, true)
		a.RemoveItem(NudeSuit, 1, true)
	endIf
	; Skip victim redressing
	if IsVictim && !Config.bReDressVictim
		StorageUtil.FormListClear(a, "SexLab.StrippedItems")
		return ; Don't requip victims
	endIf
	; Equip items in storage
	int hand = 1
	int i = StorageUtil.FormListCount(a, "SexLab.StrippedItems")
	while i
		i -= 1
		form item = StorageUtil.FormListGet(a, "SexLab.StrippedItems", i)
		int type = item.GetType()
		if type == 22 || type == 82
			a.EquipSpell(item as Spell, hand)
		else
			a.EquipItem(item, false, true)
		endIf
		; Move to other hand if weapon, light, spell, or leveledspell
		hand -= ((hand == 1 && (type == 41 || type == 31 || type == 22 || type == 82)) as int)
	endWhile
	; Clear stripped storage
	StorageUtil.FormListClear(a, "SexLab.StrippedItems")
endFunction

form function WornStrapon(actor a)
	int i = Strapons.Length
	while i
		i -= 1
		if a.IsEquipped(Strapons[i])
			return Strapons[i]
		endIf
	endWhile
	return none
endFunction

bool function HasStrapon(actor a)
	return WornStrapon(a) != none
endFunction

form function PickStrapon(actor a)
	int i = Strapons.Length
	form strapon = WornStrapon(a)
	if strapon != none
		return strapon
	endIf
	return Strapons[Utility.RandomInt(0, Strapons.Length - 1)]
endFunction

form function EquipStrapon(actor a)
	if GetGender(a) == 1
		form strapon = PickStrapon(a)
		if strapon != none
			a.AddItem(strapon, 1, true)
			a.EquipItem(strapon, false, true)
		endIf
		return strapon
	endIf
	return none
endFunction

function UnequipStrapon(actor a)
	int straponCount = Strapons.Length
	if straponCount == 0
		return
	endIf
	if GetGender(a) == 1
		int i = 0
		while i < straponCount
			Form strapon = Strapons[i]
			if a.IsEquipped(strapon)
				a.UnequipItem(strapon, false, true)
				a.RemoveItem(strapon, 1, true)
			endIf
			i += 1
		endWhile
	endIf
endFunction

;/-----------------------------------------------\;
;|	Validation Functions                         |;
;\-----------------------------------------------/;

bool function IsActorActive(actor a)
	return StorageUtil.FormListFind(self, "Registry", a) != -1
endFunction

int function ValidateActor(actor a)
	if IsActorActive(a)
		Debug.Trace("--- SexLab --- Failed to validate ("+a.GetLeveledActorBase().GetName()+") :: They appear to already be animating")
		return -10
	endIf

	;DEBUG
	return 1

	if ValidActorList.HasForm(a)
		return 1
	endIf
	if a.IsInFaction(ForbiddenFaction)
		Debug.Trace("--- SexLab --- Failed to validate ("+a.GetLeveledActorBase().GetName()+") :: They are forbidden from animating")
		return -11
	endIf
	if !a.Is3DLoaded()
		Debug.Trace("--- SexLab --- Failed to validate ("+a.GetLeveledActorBase().GetName()+") :: They are not loaded")
		return -12
	endIf
	if a.IsDead()
		Debug.Trace("--- SexLab --- Failed to validate ("+a.GetLeveledActorBase().GetName()+") :: He's dead Jim.")
		return -13
	endIf
	if a.IsDisabled()
		Debug.Trace("--- SexLab --- Failed to validate ("+a.GetLeveledActorBase().GetName()+") :: They are disabled")
		return -14
	endIf
	if a.IsFlying()
		Debug.Trace("--- SexLab --- Failed to validate ("+a.GetLeveledActorBase().GetName()+") :: They are flying.")
		return -15
	endIf
	Race ActorRace = a.GetLeveledActorBase().GetRace()
	String RaceName = ActorRace.GetName()+MiscUtil.GetRaceEditorID(ActorRace)
	if ActorRace.IsRaceFlagSet(0x00000004) || StringUtil.Find(RaceName, "Child") != -1 || StringUtil.Find(RaceName, "Little") != -1 || StringUtil.Find(RaceName, "117") != -1 || (StringUtil.Find(RaceName, "Monli") != -1 && a.GetScale() < 0.93) || StringUtil.Find(RaceName, "Elin") != -1 || StringUtil.Find(RaceName, "Enfant") != -1
		Debug.Trace("--- SexLab --- Failed to validate ("+a.GetLeveledActorBase().GetName()+") :: They are forbidden from animating")
		return -11
	endIf
	; TODO: Creature checking
	if a != PlayerRef && !a.HasKeywordString("ActorTypeNPC") ;&& !AnimLib.AllowedCreature(ActorRace)
		Debug.Trace("--- SexLab --- Failed to validate ("+a.GetLeveledActorBase().GetName()+") :: They are a creature that is currently not supported ("+ActorRace.GetName()+")")
		return -16
	endIf
	ValidActorList.AddForm(a)
	return 1
endFunction

bool function IsValidActor(actor a)
	return ValidateActor(a) == 1
endFunction

function ForbidActor(actor a)
	a.AddToFaction(ForbiddenFaction)
endFunction

function AllowActor(actor a)
	a.RemoveFromFaction(ForbiddenFaction)
endFunction

bool function IsForbidden(actor a)
	return a.IsInFaction(ForbiddenFaction) || a.HasKeyWordString("SexLabForbid")
endFunction

;/-----------------------------------------------\;
;|	Gender Functions                             |;
;\-----------------------------------------------/;

function TreatAsMale(actor a)
	a.SetFactionRank(GenderFaction, 0)
endFunction

function TreatAsFemale(actor a)
	a.SetFactionRank(GenderFaction, 1)
endFunction

function ClearForcedGender(actor a)
	a.RemoveFromFaction(GenderFaction)
endFunction

int function GetGender(actor a)
	if a.IsInFaction(GenderFaction)
		return a.GetFactionRank(GenderFaction)
	endIf
	ActorBase Base = a.GetLeveledActorBase()
	if StorageUtil.GetIntValue(Base.GetRace(), "SexLab.HasRace") == 1
		return 2 ; Creature
	endIf
	return Base.GetSex() ; Default
endFunction

int[] function GenderCount(actor[] pos)
	int[] genders = new int[3]
	int i = 0
	while i < pos.Length
		int g = GetGender(pos[i])
		genders[g] = genders[g] + 1
		i += 1
	endWhile
	return genders
endFunction

int function MaleCount(actor[] pos)
	int[] gender = GenderCount(pos)
	return gender[0]
endFunction

int function FemaleCount(actor[] pos)
	int[] gender = GenderCount(pos)
	return gender[1]
endFunction

int function CreatureCount(actor[] pos)
	int[] gender = GenderCount(pos)
	return gender[2]
endFunction

;/-----------------------------------------------\;
;|	System Use Only                              |;
;\-----------------------------------------------/;

armor function LoadStrapon(string esp, int id)
	armor strapon = Game.GetFormFromFile(id, esp) as armor
	if strapon != none
		Strapons = sslUtility.PushForm(strapon, Strapons)
	endif
	return strapon
endFunction
