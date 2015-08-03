scriptname sslActorLibrary extends sslSystemLibrary

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
	if !Vaginal && !Oral && !Anal
		return ; Nothing to do
	endIf
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

Form[] function StripActor(Actor ActorRef, Actor VictimRef = none, bool DoAnimate = true, bool LeadIn = false)
	return StripSlots(ActorRef, Config.GetStrip((GetGender(ActorRef) == 1), LeadIn, (VictimRef != none), (VictimRef != none && ActorRef == VictimRef)), DoAnimate)
endFunction

function MakeNoStrip(Form ItemRef)
	if ItemRef && !StorageUtil.FormListHas(none, "NoStrip", ItemRef)
		StorageUtil.FormListAdd(none, "NoStrip", ItemRef, false)
		StorageUtil.FormListRemove(none, "AlwaysStrip", ItemRef, true)
	endIf
endFunction

function MakeAlwaysStrip(Form ItemRef)
	if ItemRef && !StorageUtil.FormListHas(none, "AlwaysStrip", ItemRef)
		StorageUtil.FormListAdd(none, "AlwaysStrip", ItemRef, false)
		StorageUtil.FormListRemove(none, "NoStrip", ItemRef, true)
	endIf
endFunction

function ClearStripOverride(Form ItemRef)
	StorageUtil.FormListRemove(none, "NoStrip", ItemRef, true)
	StorageUtil.FormListRemove(none, "AlwaysStrip", ItemRef, true)
endFunction

function ResetStripOverrides()
	StorageUtil.FormListClear(none, "NoStrip")
	StorageUtil.FormListClear(none, "AlwaysStrip")
endFunction

bool function IsNoStrip(Form ItemRef)
	return SexLabUtil.HasKeywordSub(ItemRef, "NoStrip") || StorageUtil.FormListHas(none, "NoStrip", ItemRef)
endFunction

bool function IsAlwaysStrip(Form ItemRef)
	return SexLabUtil.HasKeywordSub(ItemRef, "AlwaysStrip") || StorageUtil.FormListHas(none, "AlwaysStrip", ItemRef)
endFunction

bool function IsStrippable(Form ItemRef)
	return ItemRef && !SexLabUtil.HasKeywordSub(ItemRef, "NoStrip") && !StorageUtil.FormListHas(none, "NoStrip", ItemRef)
endFunction

Form function StripSlot(Actor ActorRef, int SlotMask)
	Form ItemRef = ActorRef.GetWornForm(SlotMask)
	if IsStrippable(ItemRef)
		ActorRef.UnequipItem(ItemRef, false, true)
		return ItemRef
	endIf
	return none
endFunction

Form[] function StripSlots(Actor ActorRef, bool[] Strip, bool DoAnimate = false, bool AllowNudesuit = true)
	if Strip.Length != 33
		return none
	endIf
	int Gender = ActorRef.GetLeveledActorBase().GetSex()
	; Start stripping animation
	if DoAnimate
		Debug.SendAnimationEvent(ActorRef, "Arrok_Undress_G"+Gender)
	endIf
	; Get Nudesuit
	bool UseNudeSuit = Strip[2] && ((Gender == 0 && Config.UseMaleNudeSuit) || (Gender == 1 && Config.UseFemaleNudeSuit))
	if UseNudeSuit && ActorRef.GetItemCount(Config.NudeSuit) < 1
		ActorRef.AddItem(Config.NudeSuit, 1, true)
	endIf
	; Stripped storage
	Form[] Stripped = new Form[34]
	Form ItemRef
	; Strip weapon
	if Strip[32]
		; Right hand
		ItemRef = ActorRef.GetEquippedWeapon(false)
		if IsStrippable(ItemRef)
			ActorRef.UnequipItemEX(ItemRef, 1, false)
			Stripped[33] = ItemRef
		endIf
		; Left hand
		ItemRef = ActorRef.GetEquippedWeapon(true)
		if IsStrippable(ItemRef)
			ActorRef.UnequipItemEX(ItemRef, 2, false)
			Stripped[32] = ItemRef
		endIf
	endIf
	; Strip armors
	int i = Strip.RFind(true, 31)
	while i >= 0
		; Grab item in slot
		ItemRef = ActorRef.GetWornForm(Armor.GetMaskForSlot(i + 30))
		if ItemRef && (IsAlwaysStrip(ItemRef) || (Strip[i] && IsStrippable(ItemRef)))
			ActorRef.UnequipItem(ItemRef, false, true)
			Stripped[i] = ItemRef
		endIf
		i -= 1
	endWhile
	; Apply Nudesuit
	if UseNudeSuit
		ActorRef.EquipItem(NudeSuit, true, true)
	endIf
	; output stripped items
	return PapyrusUtil.ClearNone(Stripped)
endFunction

function UnstripActor(Actor ActorRef, Form[] Stripped, bool IsVictim = false)
	int i = Stripped.Length
	; Remove nudesuits
	int n = ActorRef.GetItemCount(NudeSuit)
	if n > 0
		ActorRef.UnequipItem(NudeSuit, true, true)
		ActorRef.RemoveItem(NudeSuit, n, true)
	endIf
	; Actor is victim, don't redress
	if IsVictim && !Config.RedressVictim
		return
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

; ------------------------------------------------------- ;
; --- Actor Validation                                --- ;
; ------------------------------------------------------- ;

int function ValidateActor(Actor ActorRef)
	if !ActorRef
		Log("ValidateActor(NONE) -- FALSE -- Because they don't exist.")
		return -1
	endIf
	ActorBase BaseRef = ActorRef.GetLeveledActorBase()
	if ActorRef.IsInFaction(AnimatingFaction)
		Log("ValidateActor("+BaseRef.GetName()+") -- FALSE -- They appear to already be animating")
		return -10
	elseIf !ActorRef.Is3DLoaded()
		Utility.WaitMenuMode(2.0)
		if ActorRef.Is3DLoaded()
			Log("ValidateActor("+BaseRef.GetName()+") -- RECHECK -- The actor wasn't loadded but was after a short wait...")
			return ValidateActor(ActorRef)
		endIf
		Log("ValidateActor("+BaseRef.GetName()+") -- FALSE -- They are not loaded")
		return -12
	elseIf ActorRef.IsDead() && ActorRef.GetActorValue("Health") < 1.0
		Log("ValidateActor("+BaseRef.GetName()+") -- FALSE -- He's dead Jim.")
		return -13
	elseIf ActorRef.IsDisabled()
		Log("ValidateActor("+BaseRef.GetName()+") -- FALSE -- They are disabled")
		return -14
	elseIf ActorRef.IsFlying()
		Log("ValidateActor("+BaseRef.GetName()+") -- FALSE -- They are flying.")
		return -15
	elseIf ActorRef.IsOnMount()
		Log("ValidateActor("+BaseRef.GetName()+") -- FALSE -- They are currently mounted.")
		return -16
	elseIf FormListFind(Config, "ValidActors", ActorRef) != -1
		Log("ValidateActor("+BaseRef.GetName()+") -- TRUE -- HIT")
		return 1
	elseIf !CanAnimate(ActorRef)
		Log("ValidateActor("+BaseRef.GetName()+") -- FALSE -- They are forbidden from animating")
		return -11
	elseIf ActorRef != PlayerRef && !ActorRef.HasKeyword(ActorTypeNPC)
		if !Config.AllowCreatures
			Log("ValidateActor("+BaseRef.GetName()+") -- FALSE -- They are possibly a creature but creature animations are currently disabled")
			return -17
		elseIf !sslCreatureAnimationSlots.HasCreatureType(ActorRef)
			Log("ValidateActor("+BaseRef.GetName()+") -- FALSE -- They are a creature type that is currently not supported ("+MiscUtil.GetRaceEditorID(BaseRef.GetRace())+")")
			return -18
		elseIf !CreatureSlots.HasAnimation(BaseRef.GetRace(), GetGender(ActorRef))
			Log("ValidateActor("+BaseRef.GetName()+") -- FALSE -- They are valid creature type, but have no valid animations currently enabled or installed.")
			return -19
		endIf
		Log("ValidateActor("+BaseRef.GetName()+") -- TRUE -- CREATURE")
		return 1
	else
		Log("ValidateActor("+BaseRef.GetName()+") -- TRUE -- MISS")
		FormListAdd(Config, "ValidActors", ActorRef, false)
		return 1
	endIf
endFunction

bool function CanAnimate(Actor ActorRef)
	Race ActorRace  = ActorRef.GetLeveledActorBase().GetRace()
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
	TreatAsGender(ActorRef, false)
endFunction

function TreatAsFemale(Actor ActorRef)
	TreatAsGender(ActorRef, true)
endFunction

function ClearForcedGender(Actor ActorRef)
	ActorRef.RemoveFromFaction(GenderFaction)
endFunction

function TreatAsGender(Actor ActorRef, bool AsFemale)
	ActorRef.RemoveFromFaction(GenderFaction)
	int sex = ActorRef.GetLeveledActorBase().GetSex()
	if (sex != 0 && !AsFemale) || (sex != 1 && AsFemale) 
		ActorRef.SetFactionRank(GenderFaction, AsFemale as int)
	endIf
endFunction

int function GetGender(Actor ActorRef)
	if ActorRef
		ActorBase BaseRef = ActorRef.GetLeveledActorBase()
		if sslCreatureAnimationSlots.HasRaceType(BaseRef.GetRace())
			if !Config.UseCreatureGender
				return 2 ; Creature - All Male
			else
				return 2 + BaseRef.GetSex() ; CreatureGenders: 2+
			endIf
		elseIf ActorRef.IsInFaction(GenderFaction)
			return ActorRef.GetFactionRank(GenderFaction) ; Override
		else
			return BaseRef.GetSex() ; Default
		endIf
	endIf
	return 0 ; Invalid actor - default to male for compatibility
endFunction

int[] function GetGendersAll(Actor[] Positions)
	int i = Positions.Length
	int[] Genders = Utility.CreateIntArray(i)
	while i > 0
		i -= 1
		Genders[i] = GetGender(Positions[i])
	endWhile
	return Genders
endFunction

int[] function GenderCount(Actor[] Positions)
	int[] Genders = new int[4]
	int i = Positions.Length
	while i > 0
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
	int[] Genders = GenderCount(Positions)
	return Genders[2] + Genders[3]
endFunction

int function CreatureMaleCount(Actor[] Positions)
	return GenderCount(Positions)[2]
endFunction

int function CreatureFemaleCount(Actor[] Positions)
	return GenderCount(Positions)[3]
endFunction

string function MakeGenderTag(Actor[] Positions)
	return SexLabUtil.MakeGenderTag(Positions)
endFunction

string function GetGenderTag(int Females = 0, int Males = 0, int Creatures = 0)
	return SexLabUtil.GetGenderTag(Females, Males, Creatures)
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
	; Clear library caches
	StorageUtil.FormListClear(Config, "ValidActors")
	StorageUtil.FormListClear(Config, "StripList")
	StorageUtil.FormListClear(Config, "NoStripList")
	; Load object data
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

; ------------------------------------------------------- ;
; --- Pre 1.50 Config Accessors                       --- ;
; ------------------------------------------------------- ;

float property fMaleVoiceDelay hidden
	float function get()
		return Config.MaleVoiceDelay
	endFunction
endProperty
float property fFemaleVoiceDelay hidden
	float function get()
		return Config.FemaleVoiceDelay
	endFunction
endProperty
float property fVoiceVolume hidden
	float function get()
		return Config.VoiceVolume
	endFunction
endProperty
float property fCumTimer hidden
	float function get()
		return Config.CumTimer
	endFunction
endProperty
bool property bDisablePlayer hidden
	bool function get()
		return Config.DisablePlayer
	endFunction
endProperty
bool property bScaleActors hidden
	bool function get()
		return Config.ScaleActors
	endFunction
endProperty
bool property bUseCum hidden
	bool function get()
		return Config.UseCum
	endFunction
endProperty
bool property bAllowFFCum hidden
	bool function get()
		return Config.AllowFFCum
	endFunction
endProperty
bool property bUseStrapons hidden
	bool function get()
		return Config.UseStrapons
	endFunction
endProperty
bool property bReDressVictim hidden
	bool function get()
		return Config.ReDressVictim
	endFunction
endProperty
bool property bRagdollEnd hidden
	bool function get()
		return Config.RagdollEnd
	endFunction
endProperty
bool property bUseMaleNudeSuit hidden
	bool function get()
		return Config.UseMaleNudeSuit
	endFunction
endProperty
bool property bUseFemaleNudeSuit hidden
	bool function get()
		return Config.UseFemaleNudeSuit
	endFunction
endProperty
bool property bUndressAnimation hidden
	bool function get()
		return Config.UndressAnimation
	endFunction
endProperty
bool[] property bStripMale hidden
	bool[] function get()
		return Config.StripMale
	endFunction
endProperty
bool[] property bStripFemale hidden
	bool[] function get()
		return Config.StripFemale
	endFunction
endProperty
bool[] property bStripLeadInFemale hidden
	bool[] function get()
		return Config.StripLeadInFemale
	endFunction
endProperty
bool[] property bStripLeadInMale hidden
	bool[] function get()
		return Config.StripLeadInMale
	endFunction
endProperty
bool[] property bStripVictim hidden
	bool[] function get()
		return Config.StripVictim
	endFunction
endProperty
bool[] property bStripAggressor hidden
	bool[] function get()
		return Config.StripAggressor
	endFunction
endProperty
