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
		Form ItemRef = ActorRef.GetNthForm(i)
		if ItemRef.GetType() == 26 && IsStrippable(ItemRef)
			Log(ItemRef, "IsStrippable")
		endIf
	endWhile
endFunction

Form[] function StripActor(Actor ActorRef, Actor VictimRef = none, bool DoAnimate = true, bool LeadIn = false)
	return StripSlots(ActorRef, Config.GetStrip((GetGender(ActorRef) == 1), LeadIn, (VictimRef != none), (VictimRef != none && ActorRef == VictimRef)), DoAnimate)
endFunction

bool function IsStrippable(Form ItemRef)
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
		ActorRef.EquipItem(NudeSuit, true, true)
	endIf
	; output stripped items
	return sslUtility.ClearNone(Stripped)
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
	ActorBase BaseRef = ActorRef.GetLeveledActorBase()
	if !ActorRef
		Log("ValidateActor() -- Failed to validate (NONE) -- Because they don't exist.")
		return -1
	elseIf SexLabUtil.IsActorActive(ActorRef)
		Log("ValidateActor() -- Failed to validate ("+BaseRef.GetName()+") -- They appear to already be animating")
		return -10
	elseIf FormListFind(self, "ValidActors", ActorRef) != -1
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
	elseIf ActorRef != PlayerRef && !ActorRef.HasKeyword(ActorTypeNPC) && !CreatureSlots.AllowedCreature(BaseRef.GetRace()) ; (!Config.AllowCreatures || (Config.AllowCreatures && !SexLabUtil.HasRace(BaseRef.GetRace())))
		Log("ValidateActor() -- Failed to validate ("+BaseRef.GetName()+") -- They are a creature that is currently not supported ("+MiscUtil.GetRaceEditorID(BaseRef.GetRace())+")")
		return -16
	endIf
	FormListAdd(self, "ValidActors", ActorRef, false)
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
	ActorBase BaseRef = ActorRef.GetLeveledActorBase()
	if SexLabUtil.HasRace(BaseRef.GetRace())
		return 2 ; Creature
	elseIf ActorRef.IsInFaction(GenderFaction)
		return ActorRef.GetFactionRank(GenderFaction) ; Override
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
