scriptname sslActorLibrary extends sslSystemAlias

import StorageUtil

; Data
Faction property AnimatingFaction auto hidden
Faction property GenderFaction auto hidden
Faction property ForbiddenFaction auto hidden
Weapon property DummyWeapon auto hidden
Armor property NudeSuit auto hidden

Spell property CumVaginalOralAnalSpell auto hidden
Spell property CumOralAnalSpell auto hidden
Spell property CumVaginalOralSpell auto hidden
Spell property CumVaginalAnalSpell auto hidden
Spell property CumVaginalSpell auto hidden
Spell property CumOralSpell auto hidden
Spell property CumAnalSpell auto hidden

Keyword property CumOralKeyword auto hidden
Keyword property CumAnalKeyword auto hidden
Keyword property CumVaginalKeyword auto hidden
Keyword property ActorTypeNPC auto hidden

Furniture property BaseMarker auto hidden
Package property DoNothing auto hidden

;/-----------------------------------------------\;
;|	Actor Handling/Effect Functions              |;
;\-----------------------------------------------/;

function ApplyCum(Actor ActorRef, int CumID)
	AddCum(ActorRef, (cumID == 1 || cumID == 4 || cumID == 5 || cumID == 7), (cumID == 2 || cumID == 4 || cumID == 6 || cumID == 7), (cumID == 3 || cumID == 5 || cumID == 6 || cumID == 7))
endFunction

function AddCum(Actor ActorRef, bool Vaginal = true, bool Oral = true, bool Anal = true)
	Vaginal = Vaginal || ActorRef.HasMagicEffectWithKeyword(CumVaginalKeyword)
	Oral = Oral || ActorRef.HasMagicEffectWithKeyword(CumOralKeyword)
	Anal = Anal || ActorRef.HasMagicEffectWithKeyword(CumAnalKeyword)
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

function CacheStrippable(Actor ActorRef)
	int i = ActorRef.GetNumItems()
	while i
		i -= 1
		form ItemRef = ActorRef.GetNthForm(i)
		if ItemRef.GetType() == 26 && IsStrippable(ItemRef)
			; Log(ItemRef.GetName()+" Is Strippable")
		endIf
	endWhile
endFunction

form[] function StripActor(Actor ActorRef, Actor VictimRef = none, bool DoAnimate = true, bool LeadIn = false)
	return StripSlots(ActorRef, Config.GetStrip((GetGender(ActorRef) == 1), LeadIn, (VictimRef != none), (VictimRef != none && ActorRef == VictimRef)), DoAnimate)
endFunction

bool function IsStrippable(form ItemRef)
	; Check previous validations
	if ItemRef != none && FormListFind(none, "StripList", ItemRef) != -1
		return true
	elseIf ItemRef == none || FormListFind(none, "NoStripList", ItemRef) != -1
		return false
	endIf
	; Check keywords
	int i = ItemRef.GetNumKeywords()
	while i
		i -= 1
		string kw = ItemRef.GetNthKeyword(i).GetString()
		if StringUtil.Find(kw, "NoStrip") != -1 || StringUtil.Find(kw, "Bound") != -1
			FormListAdd(none, "NoStripList", ItemRef, true)
			return false
		endIf
	endWhile
	FormListAdd(none, "StripList", ItemRef, true)
	return true
endFunction

form function StripSlot(Actor ActorRef, int SlotMask)
	form ItemRef = ActorRef.GetWornForm(SlotMask)
	if IsStrippable(ItemRef)
		ActorRef.UnequipItem(ItemRef, false, true)
		return ItemRef
	endIf
	return none
endFunction

form[] function StripSlots(Actor ActorRef, bool[] Strip, bool DoAnimate = false, bool AllowNudesuit = true)
	if Strip.Length != 33
		return none
	endIf
	int Gender = ActorRef.GetLeveledActorBase().GetSex()
	; Start stripping animation
	if DoAnimate
		Debug.SendAnimationEvent(ActorRef, "Arrok_Undress_G"+Gender)
	endIf
	; Get Nudesuit
	bool UseNudeSuit = Strip[2] && AllowNudesuit && ((Gender == 0 && Config.UseMaleNudeSuit) || (Gender == 1  && Config.UseFemaleNudeSuit)) && !ActorRef.IsEquipped(NudeSuit)
	if UseNudeSuit
		ActorRef.AddItem(NudeSuit, 1, true)
	endIf
	form[] Stripped = new form[34]
	; Strip weapon
	if Strip[32]
		; Left hand
		Stripped[32] = ActorRef.GetEquippedWeapon(false)
		if IsStrippable(Stripped[32])
			; ActorRef.AddItem(DummyWeapon, 1, true)
			; ActorRef.EquipItem(DummyWeapon, false, true)
			; ActorRef.UnEquipItem(DummyWeapon, false, true)
			; ActorRef.RemoveItem(DummyWeapon, 1, true)
			ActorRef.UnequipItem(Stripped[32], false, true)
		endIf
		; Right hand
		Stripped[33] = ActorRef.GetEquippedWeapon(true)
		if IsStrippable(Stripped[33])
			ActorRef.UnequipItem(Stripped[33], false, true)
		endIf
	endIf
	; Strip armors
	Form ItemRef
	int i = Strip.Find(true)
	while i != -1
		; Grab item in slot
		ItemRef = ActorRef.GetWornForm(Armor.GetMaskForSlot(i + 30))
		if IsStrippable(ItemRef)
			ActorRef.UnequipItem(ItemRef, false, true)
			Stripped[i] = ItemRef
		endIf
		; Move to next slot
		i += 1
		if i < 32
			i = Strip.Find(true, i)
		else
			i = -1
		endIf
	endWhile
	; Apply Nudesuit
	if UseNudeSuit
		ActorRef.EquipItem(NudeSuit, false, true)
	endIf
	; output stripped items
	return sslUtility.ClearNone(Stripped)
endFunction

function UnstripActor(Actor ActorRef, form[] Stripped, bool IsVictim = false)
	int i = Stripped.Length
	; Remove nudesuits
	if ActorRef.IsEquipped(NudeSuit)
		ActorRef.UnequipItem(NudeSuit, true, true)
		ActorRef.RemoveItem(NudeSuit, 1, true)
	elseIf IsVictim && !Config.RedressVictim
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
				; hand -= 1
			else
				ActorRef.EquipItem(Stripped[i], false, true)
			endIf
			; Move to other hand if weapon, light, spell, or leveledspell
			hand -= ((hand == 1 && (type == 41 || type == 31 || type == 22 || type == 82)) as int)
		endIf
	endWhile
endFunction

; ------------------------------------------------------- ;
; --- Actor Validation                                --- ;
; ------------------------------------------------------- ;

int function ValidateActor(Actor ActorRef)
	ActorBase BaseRef = ActorRef.GetLeveledActorBase()
	if !ActorRef
		Log("ValidateActor() -- Failed to validate (NONE) -- Because they don't exist.")
		return -1
	elseIf SexLabUtil.IsActorActive(ActorRef)
		Log("ValidateActor() -- Failed to validate ("+BaseRef.GetName()+") -- They appear to already be animating")
		return -10
	elseIf FormListFind(Storage, "ValidActors", ActorRef) != -1
		return 1
	elseIf !CanAnimate(ActorRef)
		Log("ValidateActor() -- Failed to validate ("+BaseRef.GetName()+") -- They are forbidden from animating")
		return -11
	elseIf !ActorRef.Is3DLoaded()
		Log("ValidateActor() -- Failed to validate ("+BaseRef.GetName()+") -- They are not loaded")
		return -12
	elseIf ActorRef.IsDead()
		Log("ValidateActor() -- Failed to validate ("+BaseRef.GetName()+") -- He's dead Jim.")
		return -13
	elseIf ActorRef.IsDisabled()
		Log("ValidateActor() -- Failed to validate ("+BaseRef.GetName()+") -- They are disabled")
		return -14
	elseIf ActorRef.IsFlying()
		Log("ValidateActor() -- Failed to validate ("+BaseRef.GetName()+") -- They are flying.")
		return -15
	elseIf ActorRef != PlayerRef && !ActorRef.HasKeyword(ActorTypeNPC) && !CreatureSlots.AllowedCreature(BaseRef.GetRace())
		Log("ValidateActor() -- Failed to validate ("+BaseRef.GetName()+") -- They are a creature that is currently not supported ("+MiscUtil.GetRaceEditorID(BaseRef.GetRace())+")")
		return -16
	endIf
	FormListAdd(Storage, "ValidActors", ActorRef, false)
	return 1
endFunction

bool function CanAnimate(Actor ActorRef)
	Race ActorRace = ActorRef.GetLeveledActorBase().GetRace()
	string RaceName = ActorRace.GetName()+MiscUtil.GetRaceEditorID(ActorRace)
	return !(ActorRef.IsInFaction(ForbiddenFaction) || ActorRace.IsRaceFlagSet(0x00000004) || StringUtil.Find(RaceName, "Child") != -1  || StringUtil.Find(RaceName, "Little") != -1 || StringUtil.Find(RaceName, "117") != -1 || StringUtil.Find(RaceName, "Enfant") != -1 || (StringUtil.Find(RaceName, "Elin") != -1 && ActorRef.GetScale() < 0.94) ||  (StringUtil.Find(RaceName, "Monli") != -1 && ActorRef.GetScale() < 0.92))
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
	ActorBase BaseRef = ActorRef.GetLeveledActorBase()
	if SexLabUtil.HasRace(BaseRef.GetRace())
		return 2 ; Creature
	endIf
	return BaseRef.GetSex() ; Default
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
	int[] Genders = GenderCount(Positions)
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

; ------------------------------------------------------- ;
; --- System Use Only                                 --- ;
; ------------------------------------------------------- ;

; function Setup()
; 	parent.Setup()
; 	FormListClear(Storage, "ValidActors")
; 	FormListClear(none, "StripList")
; 	FormListClear(none, "NoStripList")
; 	; No longer used
; 	FormListClear(Storage, "StripList")
; 	FormListClear(Storage, "NoStripList")
; 	FormListClear(Storage, "Registry")
; endFunction
function Setup()
	parent.Setup()
	AnimatingFaction        = Config.AnimatingFaction
	GenderFaction           = Config.GenderFaction
	ForbiddenFaction        = Config.ForbiddenFaction
	DummyWeapon             = Config.DummyWeapon
	NudeSuit                = Config.NudeSuit
	CumVaginalOralAnalSpell = Config.CumVaginalOralAnalSpell
	CumOralAnalSpell        = Config.CumOralAnalSpell
	CumVaginalOralSpell     = Config.CumVaginalOralSpell
	CumVaginalAnalSpell     = Config.CumVaginalAnalSpell
	CumVaginalSpell         = Config.CumVaginalSpell
	CumOralSpell            = Config.CumOralSpell
	CumAnalSpell            = Config.CumAnalSpell
	CumOralKeyword          = Config.CumOralKeyword
	CumAnalKeyword          = Config.CumAnalKeyword
	CumVaginalKeyword       = Config.CumVaginalKeyword
	ActorTypeNPC            = Config.ActorTypeNPC
	BaseMarker              = Config.BaseMarker
	DoNothing               = Config.DoNothing
endFunction
