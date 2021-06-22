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

Spell property Vaginal1Oral1Anal1 auto hidden
Spell property Vaginal2Oral1Anal1 auto hidden
Spell property Vaginal2Oral2Anal1 auto hidden
Spell property Vaginal2Oral1Anal2 auto hidden
Spell property Vaginal1Oral2Anal1 auto hidden
Spell property Vaginal1Oral2Anal2 auto hidden
Spell property Vaginal1Oral1Anal2 auto hidden
Spell property Vaginal2Oral2Anal2 auto hidden
Spell property Oral1Anal1 auto hidden
Spell property Oral2Anal1 auto hidden
Spell property Oral1Anal2 auto hidden
Spell property Oral2Anal2 auto hidden
Spell property Vaginal1Oral1 auto hidden
Spell property Vaginal2Oral1 auto hidden
Spell property Vaginal1Oral2 auto hidden
Spell property Vaginal2Oral2 auto hidden
Spell property Vaginal1Anal1 auto hidden
Spell property Vaginal2Anal1 auto hidden
Spell property Vaginal1Anal2 auto hidden
Spell property Vaginal2Anal2 auto hidden
Spell property Vaginal1 auto hidden
Spell property Vaginal2 auto hidden
Spell property Oral1 auto hidden
Spell property Oral2 auto hidden
Spell property Anal1 auto hidden
Spell property Anal2 auto hidden

Keyword property CumOralKeyword auto hidden
Keyword property CumAnalKeyword auto hidden
Keyword property CumVaginalKeyword auto hidden
Keyword property CumOralStackedKeyword auto hidden
Keyword property CumAnalStackedKeyword auto hidden
Keyword property CumVaginalStackedKeyword auto hidden

Keyword property ActorTypeNPC auto hidden

Furniture property BaseMarker auto hidden
Package property DoNothing auto hidden

;/-----------------------------------------------\;
;|	Actor Handling/Effect Functions              |;
;\-----------------------------------------------/;

function ApplyCum(Actor ActorRef, int CumID)
	AddCum(ActorRef, (cumID == 1 || cumID == 4 || cumID == 5 || cumID == 7), (cumID == 2 || cumID == 4 || cumID == 6 || cumID == 7), (cumID == 3 || cumID == 5 || cumID == 6 || cumID == 7))
endFunction

function ClearCum(Actor ActorRef)
	if !ActorRef
		return ; Nothing to do
	endIf
	ActorRef.DispelSpell(CumVaginalSpell)
	ActorRef.DispelSpell(CumOralSpell)
	ActorRef.DispelSpell(CumAnalSpell)
	ActorRef.DispelSpell(CumVaginalOralSpell)
	ActorRef.DispelSpell(CumVaginalAnalSpell)
	ActorRef.DispelSpell(CumOralAnalSpell)
	ActorRef.DispelSpell(CumVaginalOralAnalSpell)
	ActorRef.DispelSpell(Vaginal1Oral1Anal1)
	ActorRef.DispelSpell(Vaginal2Oral1Anal1)
	ActorRef.DispelSpell(Vaginal2Oral2Anal1)
	ActorRef.DispelSpell(Vaginal2Oral1Anal2)
	ActorRef.DispelSpell(Vaginal1Oral2Anal1)
	ActorRef.DispelSpell(Vaginal1Oral2Anal2)
	ActorRef.DispelSpell(Vaginal1Oral1Anal2)
	ActorRef.DispelSpell(Vaginal2Oral2Anal2)
	ActorRef.DispelSpell(Oral1Anal1)
	ActorRef.DispelSpell(Oral2Anal1)
	ActorRef.DispelSpell(Oral1Anal2)
	ActorRef.DispelSpell(Oral2Anal2)
	ActorRef.DispelSpell(Vaginal1Oral1)
	ActorRef.DispelSpell(Vaginal2Oral1)
	ActorRef.DispelSpell(Vaginal1Oral2)
	ActorRef.DispelSpell(Vaginal2Oral2)
	ActorRef.DispelSpell(Vaginal1Anal1)
	ActorRef.DispelSpell(Vaginal2Anal1)
	ActorRef.DispelSpell(Vaginal1Anal2)
	ActorRef.DispelSpell(Vaginal2Anal2)
	ActorRef.DispelSpell(Vaginal1)
	ActorRef.DispelSpell(Vaginal2)
	ActorRef.DispelSpell(Oral1)
	ActorRef.DispelSpell(Oral2)
	ActorRef.DispelSpell(Anal1)
	ActorRef.DispelSpell(Anal2)
endFunction

function AddCum(Actor ActorRef, bool Vaginal = true, bool Oral = true, bool Anal = true)
	if !ActorRef && !Vaginal && !Oral && !Anal
		return ; Nothing to do
	endIf

	int kVaginal = ((Vaginal || ActorRef.HasMagicEffectWithKeyword(CumVaginalStackedKeyword)) as int) + (ActorRef.HasMagicEffectWithKeyword(CumVaginalKeyword) as int)
	int kOral    = ((Oral || ActorRef.HasMagicEffectWithKeyword(CumOralStackedKeyword)) as int)       + (ActorRef.HasMagicEffectWithKeyword(CumOralKeyword) as int)
	int kAnal    = ((Anal || ActorRef.HasMagicEffectWithKeyword(CumAnalStackedKeyword)) as int)       + (ActorRef.HasMagicEffectWithKeyword(CumAnalKeyword) as int)
	Log("Vaginal:"+Vaginal+"-"+kVaginal+" Oral:"+Oral+"-"+kOral+" Anal:"+Anal+"-"+kAnal)

	if kVaginal == 1 && kOral == 1 && kAnal == 1
		Vaginal1Oral1Anal1.Cast(ActorRef, ActorRef)
	elseif kVaginal == 2 && kOral == 1 && kAnal == 1
		Vaginal2Oral1Anal1.Cast(ActorRef, ActorRef)
	elseif kVaginal == 2 && kOral == 2 && kAnal == 1
		Vaginal2Oral2Anal1.Cast(ActorRef, ActorRef)
	elseif kVaginal == 2 && kOral == 1 && kAnal == 2
		Vaginal2Oral1Anal2.Cast(ActorRef, ActorRef)
	elseif kVaginal == 1 && kOral == 2 && kAnal == 1
		Vaginal1Oral2Anal1.Cast(ActorRef, ActorRef)
	elseif kVaginal == 1 && kOral == 2 && kAnal == 2
		Vaginal1Oral2Anal2.Cast(ActorRef, ActorRef)
	elseif kVaginal == 1 && kOral == 1 && kAnal == 2
		Vaginal1Oral1Anal2.Cast(ActorRef, ActorRef)
	elseif kVaginal == 2 && kOral == 2 && kAnal == 2
		Vaginal2Oral2Anal2.Cast(ActorRef, ActorRef)
	elseif kVaginal == 0 && kOral == 1 && kAnal == 1
		Oral1Anal1.Cast(ActorRef, ActorRef)
	elseif kVaginal == 0 && kOral == 2 && kAnal == 1
		Oral2Anal1.Cast(ActorRef, ActorRef)
	elseif kVaginal == 0 && kOral == 1 && kAnal == 2
		Oral1Anal2.Cast(ActorRef, ActorRef)
	elseif kVaginal == 0 && kOral == 2 && kAnal == 2
		Oral2Anal2.Cast(ActorRef, ActorRef)
	elseif kVaginal == 1 && kOral == 1 && kAnal == 0
		Vaginal1Oral1.Cast(ActorRef, ActorRef)
	elseif kVaginal == 2 && kOral == 1 && kAnal == 0
		Vaginal2Oral1.Cast(ActorRef, ActorRef)
	elseif kVaginal == 1 && kOral == 2 && kAnal == 0
		Vaginal1Oral2.Cast(ActorRef, ActorRef)
	elseif kVaginal == 2 && kOral == 2 && kAnal == 0
		Vaginal2Oral2.Cast(ActorRef, ActorRef)
	elseif kVaginal == 1 && kOral == 0 && kAnal == 1
		Vaginal1Anal1.Cast(ActorRef, ActorRef)
	elseif kVaginal == 2 && kOral == 0 && kAnal == 1
		Vaginal2Anal1.Cast(ActorRef, ActorRef)
	elseif kVaginal == 1 && kOral == 0 && kAnal == 2
		Vaginal1Anal2.Cast(ActorRef, ActorRef)
	elseif kVaginal == 2 && kOral == 0 && kAnal == 2
		Vaginal2Anal2.Cast(ActorRef, ActorRef)
	elseif kVaginal == 1 && kOral == 0 && kAnal == 0
		Vaginal1.Cast(ActorRef, ActorRef)
	elseif kVaginal == 2 && kOral == 0 && kAnal == 0
		Vaginal2.Cast(ActorRef, ActorRef)
	elseif kVaginal == 0 && kOral == 1 && kAnal == 0
		Oral1.Cast(ActorRef, ActorRef)
	elseif kVaginal == 0 && kOral == 2 && kAnal == 0
		Oral2.Cast(ActorRef, ActorRef)
	elseif kVaginal == 0 && kOral == 0 && kAnal == 1
		Anal1.Cast(ActorRef, ActorRef)
	elseif kVaginal == 0 && kOral == 0 && kAnal == 2
		Anal2.Cast(ActorRef, ActorRef)
	endIf
endFunction

int function CountCum(Actor ActorRef, bool Vaginal = true, bool Oral = true, bool Anal = true)
	if !ActorRef && !Vaginal && !Oral && !Anal
		return -1; Nothing to do
	endIf
	int Amount
	if Vaginal
		Amount += ActorRef.HasMagicEffectWithKeyword(CumVaginalKeyword) as int
		Amount += ActorRef.HasMagicEffectWithKeyword(CumVaginalStackedKeyword) as int
	endIf
	if Oral
		Amount += ActorRef.HasMagicEffectWithKeyword(CumOralKeyword) as int
		Amount += ActorRef.HasMagicEffectWithKeyword(CumOralStackedKeyword) as int
	endIf
	if Anal
		Amount += ActorRef.HasMagicEffectWithKeyword(CumAnalKeyword) as int
		Amount += ActorRef.HasMagicEffectWithKeyword(CumAnalStackedKeyword) as int
	endIf
	return Amount
endFunction

function legacy_AddCum(Actor ActorRef, bool Vaginal = true, bool Oral = true, bool Anal = true)
	if !ActorRef && !Vaginal && !Oral && !Anal
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

;/-----------------------------------------------\;
;|	Equipment Functions                          |;
;\-----------------------------------------------/;

Form[] function StripActor(Actor ActorRef, Actor VictimRef = none, bool DoAnimate = true, bool LeadIn = false)
	return StripSlots(ActorRef, Config.GetStrip((GetGender(ActorRef) == 1), LeadIn, (VictimRef != none), (VictimRef != none && ActorRef == VictimRef)), DoAnimate)
endFunction

function MakeNoStrip(Form ItemRef)
	if ItemRef && !FormListHas(none, "NoStrip", ItemRef)
		FormListAdd(none, "NoStrip", ItemRef, false)
		FormListRemove(none, "AlwaysStrip", ItemRef, true)
		ObjectReference ObjRef = ItemRef as ObjectReference
		if ObjRef && ObjRef.GetBaseObject()
			ItemRef = ObjRef.GetBaseObject()
			FormListAdd(none, "NoStrip", ItemRef, false)
			FormListRemove(none, "AlwaysStrip", ItemRef, true)
		endIf
	endIf
endFunction

function MakeAlwaysStrip(Form ItemRef)
	if ItemRef && !FormListHas(none, "AlwaysStrip", ItemRef)
		FormListAdd(none, "AlwaysStrip", ItemRef, false)
		FormListRemove(none, "NoStrip", ItemRef, true)
		ObjectReference ObjRef = ItemRef as ObjectReference
		if ObjRef
			FormListAdd(none, "AlwaysStrip", ObjRef, false)
			FormListRemove(none, "NoStrip", ObjRef, true)
		endIf
	endIf
endFunction

function ClearStripOverride(Form ItemRef)
	FormListRemove(none, "NoStrip", ItemRef, true)
	FormListRemove(none, "AlwaysStrip", ItemRef, true)
	ObjectReference ObjRef = ItemRef as ObjectReference
	if ObjRef && ObjRef.GetBaseObject()
		FormListRemove(none, "NoStrip", ItemRef, true)
		FormListRemove(none, "AlwaysStrip", ItemRef, true)
	endIf
endFunction

function ResetStripOverrides()
	FormListClear(none, "NoStrip")
	FormListClear(none, "AlwaysStrip")
endFunction

bool function IsNoStrip(Form ItemRef)
	return FormListHas(none, "NoStrip", ItemRef) || SexLabUtil.HasKeywordSub(ItemRef, "NoStrip")
endFunction

bool function IsAlwaysStrip(Form ItemRef)
	return FormListHas(none, "AlwaysStrip", ItemRef) || SexLabUtil.HasKeywordSub(ItemRef, "AlwaysStrip")
endFunction

bool function IsStrippable(Form ItemRef)
	return ItemRef && (IsAlwaysStrip(ItemRef) || !IsNoStrip(ItemRef))
endFunction

bool function ContinueStrip(Form ItemRef, bool DoStrip = true)
	if !ItemRef
		return False
	endIf
	if StorageUtil.FormListHas(none, "AlwaysStrip", ItemRef) || SexLabUtil.HasKeywordSub(ItemRef, "AlwaysStrip")
		if StorageUtil.GetIntValue(ItemRef, "SometimesStrip", 100) < 100
			if !DoStrip
				return (StorageUtil.GetIntValue(ItemRef, "SometimesStrip", 100) >= Utility.RandomInt(76, 100))
			endIf
			return (StorageUtil.GetIntValue(ItemRef, "SometimesStrip", 100) >= Utility.RandomInt(1, 100))
		endIf
		return True
	endIf
	return (DoStrip && !(StorageUtil.FormListHas(none, "NoStrip", ItemRef) || SexLabUtil.HasKeywordSub(ItemRef, "NoStrip")))
endFunction

Form function StripSlot(Actor ActorRef, int SlotMask)
	if !ActorRef
		return none
	endIf
	Form ItemRef = ActorRef.GetWornForm(SlotMask)
	if IsStrippable(ItemRef)
		ActorRef.UnequipItemEX(ItemRef, 0, false)
		return ItemRef
	endIf
	return none
endFunction

Form[] function StripSlots(Actor ActorRef, bool[] Strip, bool DoAnimate = false, bool AllowNudesuit = true)
	if !ActorRef || Strip.Length < 33
		return Utility.CreateFormArray(0)
	endIf
	int Gender = ActorRef.GetLeveledActorBase().GetSex()
	; Start stripping animation
	;if DoAnimate
	;	Debug.SendAnimationEvent(ActorRef, "Arrok_Undress_G"+Gender)
	;endIf
	; Get Nudesuit
	bool UseNudeSuit = Strip[2] && ((Gender == 0 && Config.UseMaleNudeSuit) || (Gender == 1 && Config.UseFemaleNudeSuit))
	if UseNudeSuit && ActorRef.GetItemCount(Config.NudeSuit) < 1
		ActorRef.AddItem(Config.NudeSuit, 1, true)
	endIf
	; Stripped storage
	Form ItemRef
	Form[] Stripped = new Form[34]
	; Strip weapons
	if ActorRef.IsWeaponDrawn() || ActorRef == PlayerRef
		ActorRef.SheatheWeapon() ; To prevent issues with the animation if the player is stocked on the weapon drawn idle. For some reason hapen more than expected
	endIf
	; Right hand
	ItemRef = ActorRef.GetEquippedObject(1)
	if ContinueStrip(ItemRef, Strip[32])
		Stripped[33] = ItemRef
		ActorRef.UnequipItemEX(ItemRef, 1, false)
		SetIntValue(ItemRef, "Hand", 1)
	endIf
	; Left hand
	ItemRef = ActorRef.GetEquippedObject(0)
	if ContinueStrip(ItemRef, Strip[32])
		Stripped[32] = ItemRef
		ActorRef.UnequipItemEX(ItemRef, 2, false)
		SetIntValue(ItemRef, "Hand", 2) 
	endIf
	; Strip armors
	Form BodyRef = ActorRef.GetWornForm(Armor.GetMaskForSlot(32))
	int i = 31
	while i >= 0
		; Grab item in slot
		ItemRef = ActorRef.GetWornForm(Armor.GetMaskForSlot(i + 30))
		if ContinueStrip(ItemRef, Strip[i])
			; Start stripping animation
			if DoAnimate && ItemRef == BodyRef ;Body
				Debug.SendAnimationEvent(ActorRef, "Arrok_Undress_G"+Gender)
				Utility.Wait(1.0)
			endIf
			ActorRef.UnequipItemEX(ItemRef, 0, false)
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
		ActorRef.RemoveItem(NudeSuit, n, true)
	endIf
	; Actor is victim, don't redress
	if IsVictim && !Config.RedressVictim
		return
	endIf
	; Equip stripped
	while i
		i -= 1
		if Stripped[i]
 			int hand = GetIntValue(Stripped[i], "Hand", 0)
 			if hand != 0
	 			UnsetIntValue(Stripped[i], "Hand")
	 		endIf
	 		ActorRef.EquipItemEx(Stripped[i], hand, false)
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
	; Remove actors stuck in animating faction
	elseIf ActorRef.IsInFaction(AnimatingFaction) && (ActorRef != PlayerRef || Config.GetThreadControlled() == none) && Config.ThreadSlots.FindActorController(ActorRef) == -1
		ActorRef.RemoveFromFaction(AnimatingFaction)
		Log("ValidateActor("+ActorRef.GetLeveledActorBase().GetName()+") -- WARN -- Was in AnimatingFaction but not in a thread")
	endIf	
	ActorBase BaseRef = ActorRef.GetLeveledActorBase()
	; Primary checks
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
	elseIf ActorRef.IsInFaction(ForbiddenFaction)
		Log("ValidateActor("+BaseRef.GetName()+") -- FALSE -- They are flagged as forbidden from animating.")
		return -11
	elseIf FormListFind(Config, "ValidActors", ActorRef) != -1
		Log("ValidateActor("+BaseRef.GetName()+") -- TRUE -- HIT")
		return 1
	elseIf !CanAnimate(ActorRef)
		ActorRef.AddToFaction(ForbiddenFaction)
		Log("ValidateActor("+BaseRef.GetName()+") -- FALSE -- They are not supported for animation.")
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
	endIf
	Log("ValidateActor("+BaseRef.GetName()+") -- TRUE -- MISS")
	FormListAdd(Config, "ValidActors", ActorRef, false)
	return 1
endFunction

bool function CanAnimate(Actor ActorRef)
	if !ActorRef
		return false
	endIf
	Race ActorRace  = ActorRef.GetLeveledActorBase().GetRace()
	string RaceName = ActorRace.GetName()+MiscUtil.GetRaceEditorID(ActorRace)
	return !(ActorRace.IsRaceFlagSet(0x00000004) || StringUtil.Find(RaceName, "Moli") != -1 || StringUtil.Find(RaceName, "Child") != -1  || StringUtil.Find(RaceName, "Little") != -1 || StringUtil.Find(RaceName, "117") != -1 || StringUtil.Find(RaceName, "Enfant") != -1 || StringUtil.Find(RaceName, "Teen") != -1 || (StringUtil.Find(RaceName, "Elin") != -1 && ActorRef.GetScale() < 0.92) ||  (StringUtil.Find(RaceName, "Monli") != -1 && ActorRef.GetScale() < 0.92))
endFunction

bool function IsValidActor(Actor ActorRef)
	return ValidateActor(ActorRef) == 1
endFunction

function ForbidActor(Actor ActorRef)
	FormListRemove(Config, "ValidActors", ActorRef, true)
	if ActorRef
		ActorRef.AddToFaction(ForbiddenFaction)
	endIf
endFunction

function AllowActor(Actor ActorRef)
	if ActorRef
		ActorRef.RemoveFromFaction(ForbiddenFaction)
	endIf
endFunction

bool function IsForbidden(Actor ActorRef)
	return ActorRef && ActorRef.IsInFaction(ForbiddenFaction) ;|| ActorRef.HasKeyWordString("SexLabForbid")
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
	if !ActorRef
		return
	endIf
	ActorRef.RemoveFromFaction(GenderFaction)
	int eid = ModEvent.Create("SexLabActorGenderChange")
	if eid
		ModEvent.PushForm(eid, ActorRef)
		ModEvent.PushInt(eid, ActorRef.GetLeveledActorBase().GetSex())
		ModEvent.Send(eid)
	endIf
endFunction

function TreatAsGender(Actor ActorRef, bool AsFemale)
	if !ActorRef
		return
	endIf
	ActorRef.RemoveFromFaction(GenderFaction)
	int sex = ActorRef.GetLeveledActorBase().GetSex()
	if (sex != 0 && !AsFemale) || (sex != 1 && AsFemale) 
		ActorRef.SetFactionRank(GenderFaction, AsFemale as int)
	endIf
	; Send event for whenever an actor's gender is altered
	int eid = ModEvent.Create("SexLabActorGenderChange")
	if eid
		ModEvent.PushForm(eid, ActorRef)
		ModEvent.PushInt(eid, AsFemale as int)
		ModEvent.Send(eid)
	endIf
endFunction

int function GetTrans(Actor ActorRef)
	if ActorRef && ActorRef != none && ActorRef.IsInFaction(Config.GenderFaction)
		if sslCreatureAnimationSlots.HasRaceType(ActorRef.GetLeveledActorBase().GetRace())
			return 2 + ActorRef.GetFactionRank(Config.GenderFaction)
		else
			return ActorRef.GetFactionRank(Config.GenderFaction)
		endIf
	endIf
	return -1
endFunction

int[] function GetTransAll(Actor[] Positions)
	int i = Positions.Length
	int[] Trans = Utility.CreateIntArray(i)
	while i > 0
		i -= 1
		Trans[i] = GetTrans(Positions[i])
	endWhile
	return Trans
endFunction

int[] function TransCount(Actor[] Positions)
	int[] Trans = new int[4]
	int i = Positions.Length
	while i > 0
		i -= 1
		int g = GetTrans(Positions[i])
		if g >= 0 && g < 4
			Trans[g] = Trans[g] + 1
		endIf
	endWhile
	return Trans
endFunction

int function GetGender(Actor ActorRef)
	if ActorRef
		ActorBase BaseRef = ActorRef.GetLeveledActorBase()
		if sslCreatureAnimationSlots.HasRaceType(BaseRef.GetRace())
			if !Config.UseCreatureGender
				return 2 ; Creature - All Male
			elseIf ActorRef.IsInFaction(GenderFaction)
				return 2 + ActorRef.GetFactionRank(GenderFaction) ; CreatureGender + Override
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
	return ActorRef && CreatureSlots.AllowedCreature(ActorRef.GetLeveledActorBase().GetRace())
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
	FormListClear(Config, "ValidActors")
	FormListClear(Config, "StripList")
	FormListClear(Config, "NoStripList")
	; Load object data
	AnimatingFaction = Config.AnimatingFaction
	GenderFaction    = Config.GenderFaction
	ForbiddenFaction = Config.ForbiddenFaction
	DummyWeapon      = Config.DummyWeapon
	NudeSuit         = Config.NudeSuit
	ActorTypeNPC     = Config.ActorTypeNPC
	BaseMarker       = Config.BaseMarker
	DoNothing        = Config.DoNothing
	; cum keywords
	CumOralKeyword           = Config.CumOralKeyword
	CumAnalKeyword           = Config.CumAnalKeyword
	CumVaginalKeyword        = Config.CumVaginalKeyword
	CumVaginalStackedKeyword = Config.CumVaginalStackedKeyword
	CumOralStackedKeyword    = Config.CumOralStackedKeyword
	CumAnalStackedKeyword    = Config.CumAnalStackedKeyword
	; cum spells
	Vaginal1Oral1Anal1 = Config.Vaginal1Oral1Anal1
	Vaginal2Oral1Anal1 = Config.Vaginal2Oral1Anal1
	Vaginal2Oral2Anal1 = Config.Vaginal2Oral2Anal1
	Vaginal2Oral1Anal2 = Config.Vaginal2Oral1Anal2
	Vaginal1Oral2Anal1 = Config.Vaginal1Oral2Anal1
	Vaginal1Oral2Anal2 = Config.Vaginal1Oral2Anal2
	Vaginal1Oral1Anal2 = Config.Vaginal1Oral1Anal2
	Vaginal2Oral2Anal2 = Config.Vaginal2Oral2Anal2
	Oral1Anal1         = Config.Oral1Anal1
	Oral2Anal1         = Config.Oral2Anal1
	Oral1Anal2         = Config.Oral1Anal2
	Oral2Anal2         = Config.Oral2Anal2
	Vaginal1Oral1      = Config.Vaginal1Oral1
	Vaginal2Oral1      = Config.Vaginal2Oral1
	Vaginal1Oral2      = Config.Vaginal1Oral2
	Vaginal2Oral2      = Config.Vaginal2Oral2
	Vaginal1Anal1      = Config.Vaginal1Anal1
	Vaginal2Anal1      = Config.Vaginal2Anal1
	Vaginal1Anal2      = Config.Vaginal1Anal2
	Vaginal2Anal2      = Config.Vaginal2Anal2
	Vaginal1           = Config.Vaginal1
	Vaginal2           = Config.Vaginal2
	Oral1              = Config.Oral1
	Oral2              = Config.Oral2
	Anal1              = Config.Anal1
	Anal2              = Config.Anal2
	; < 1.61 legacy cum spells
	CumVaginalOralAnalSpell = Config.CumVaginalOralAnalSpell
	CumOralAnalSpell        = Config.CumOralAnalSpell
	CumVaginalOralSpell     = Config.CumVaginalOralSpell
	CumVaginalAnalSpell     = Config.CumVaginalAnalSpell
	CumVaginalSpell         = Config.CumVaginalSpell
	CumOralSpell            = Config.CumOralSpell
	CumAnalSpell            = Config.CumAnalSpell
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
