scriptname sslActorLibrary extends Quest

; Scripts
sslActorStats property Stats auto
sslActorSlots property Slots auto

sslAnimationLibrary property AnimLib auto

; Data
faction property AnimatingFaction auto
faction property GenderFaction auto
faction property ForbiddenFaction auto
actor property PlayerRef auto
weapon property DummyWeapon auto
armor property NudeSuit auto
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

Furniture property BaseMarker auto

; Config Settings
bool property SOSEnabled auto hidden
bool property bDisablePlayer auto hidden
float property fMaleVoiceDelay auto hidden
float property fFemaleVoiceDelay auto hidden
float property fVoiceVolume auto hidden
bool property bEnableTCL auto hidden
bool property bScaleActors auto hidden
bool property bUseCum auto hidden
bool property bAllowFFCum auto hidden
float property fCumTimer auto hidden
bool property bUseStrapons auto hidden
bool property bReDressVictim auto hidden
bool property bRagdollEnd auto hidden
bool property bUseMaleNudeSuit auto hidden
bool property bUseFemaleNudeSuit auto hidden
bool property bUndressAnimation auto hidden

int property kBackwards auto hidden ; Right Shift
int property kAdjustStage auto hidden; Right Ctrl
int property kAdvanceAnimation auto hidden ; Space
int property kChangeAnimation auto hidden ; O
int property kChangePositions auto hidden ; =
int property kAdjustChange auto hidden ; K
int property kAdjustForward auto hidden ; L
int property kAdjustSideways auto hidden ; '
int property kAdjustUpward auto hidden ; ;
int property kRealignActors auto hidden ; [
int property kMoveScene auto hidden ; ]
int property kRestoreOffsets auto hidden ; -
int property kRotateScene auto hidden ; U

bool[] property bStripMale auto hidden
bool[] property bStripFemale auto hidden
bool[] property bStripLeadInFemale auto hidden
bool[] property bStripLeadInMale auto hidden
bool[] property bStripVictim auto hidden
bool[] property bStripAggressor auto hidden

; Local
bool hkReady
sslThreadController PlayerController

int function ValidateActor(actor a)

	String ActorName = a.GetLeveledActorBase().GetName()

	if a.IsInFaction(AnimatingFaction)
		if Slots.FindActor(a) == -1
			a.RemoveFromFaction(AnimatingFaction)
		else
			Debug.Trace("--- SexLab --- Failed to validate ("+ActorName+") :: They appear to already be animating")
			return -10
		endIf
	endIf

	if a.HasKeywordString("SexLabForbid") || a.IsInFaction(ForbiddenFaction)
		Debug.Trace("--- SexLab --- Failed to validate ("+ActorName+") :: They are forbidden from animating")
		return -11
	endIf

	if !a.Is3DLoaded()
		Debug.Trace("--- SexLab --- Failed to validate ("+ActorName+") :: They are not loaded")
		return -12
	endIf

	if a.IsDead()
		Debug.Trace("--- SexLab --- Failed to validate ("+ActorName+") :: He's dead Jim.")
		return -13
	endIf

	if a.IsDisabled()
		Debug.Trace("--- SexLab --- Failed to validate ("+ActorName+") :: They are disabled")
		return -14
	endIf

	if a.IsFlying()
		Debug.Trace("--- SexLab --- Failed to validate ("+ActorName+") :: They are flying.")
		return -15
	endIf

	Race ActorRace = a.GetLeveledActorBase().GetRace()
	String RaceName = ActorRace.GetName()

	if ActorRace.IsRaceFlagSet(0x00000004) || StringUtil.Find(RaceName, "Child") != -1 || StringUtil.Find(RaceName, "117") != -1 || StringUtil.Find(RaceName, "Monli") != -1 || StringUtil.Find(RaceName, "Elin") != -1
		ForbidActor(a)
		Debug.Trace("--- SexLab --- Failed to validate ("+ActorName+") :: They are forbidden from animating")
		return -11
	endIf

	if a != PlayerRef && !a.HasKeywordString("ActorTypeNPC") && !AnimLib.AllowedCreature(ActorRace)
		Debug.Trace("--- SexLab --- Failed to validate ("+ActorName+") :: They are a creature that is currently not supported ("+RaceName+")")
		return -16
	endIf

	return 1
endFunction

bool function IsValidActor(actor a)
	return ValidateActor(a) == 1
endFunction

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
	form[] supress = new form[5]
	supress[0] = centerRef
	supress[1] = ignore1
	supress[2] = ignore2
	supress[3] = ignore3
	supress[4] = ignore4
	; Attempt 30 times before giving up.
	int attempt = 30
	while attempt
		attempt -= 1
		; Get random actor
		actor foundRef = Game.FindRandomActorFromRef(centerRef, radius)
		; Validate actor
		int gender
		bool valid = foundRef != none && supress.Find(foundRef) == -1
		if valid
			; Get their gender if we need it
			gender = GetGender(foundRef)
			; Supress from future validation attempts
			supress = sslUtility.PushForm(foundRef, supress)
		endIf
		valid = valid && (findGender != 2 && gender != 2) ; Supress creatures
		valid = valid && (findGender == -1 || findGender == gender) ; Validate gender
		valid = valid && IsValidActor(foundRef) ; Actor Validate
		if valid
			return foundRef ; Actor passed validation, end loop/function
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
		if FoundRef != none && Positions.Find(FoundRef) == -1
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
	int slot
	int priority = (femaleFirst as int)
	int i
	while i < Positions.Length
		if GetGender(Positions[i]) == priority && i > slot
			actor moved = Positions[slot]
			Positions[slot] = Positions[i]
			Positions[i] = moved
			slot += 1
		endIf
		i += 1
	endWhile
	return Positions
endFunction

function ApplyCum(actor a, int cumID)
	if cumID < 1
		return ; Invalid ID
	endIf
	; Check current locations
	bool anal = a.HasMagicEffectWithKeyword(kwCumAnal)
	bool oral = a.HasMagicEffectWithKeyword(kwCumOral)
	bool vaginal = a.HasMagicEffectWithKeyword(kwCumVaginal)
	; Apply passed id + current
	if cumID == 1 && !anal && !oral
		CumVaginalSpell.Cast(a, a)
	elseif cumID == 2 && !anal && !vaginal
		CumOralSpell.Cast(a, a)
	elseif cumID == 3 && !oral && !vaginal
		CumAnalSpell.Cast(a, a)
	elseif (cumID == 4 || cumID == 1 || cumID == 2) && (vaginal || oral) && !anal
		CumVaginalOralSpell.Cast(a, a)
	elseif (cumID == 5 || cumID == 1 || cumID == 3) && (vaginal || anal) && !oral
		CumVaginalAnalSpell.Cast(a, a)
	elseif (cumID == 6 || cumID == 2 || cumID == 3) && (oral || anal) && !vaginal
		CumOralAnalSpell.Cast(a, a)
	else
		CumVaginalOralAnalSpell.Cast(a, a)
	endIf
endFunction

form[] function StripActor(actor a, actor victim = none, bool animate = true, bool leadIn = false)
	bool[] strip = GetStrip(a, victim, leadIn)
	return StripSlots(a, strip, animate)
endFunction

bool[] function GetStrip(actor a, actor victim, bool leadin)
	bool female = GetGender(a) == 1
	if leadin && !female
		return bStripLeadInMale
	elseif leadin && female
		return bStripLeadInFemale
 	elseif victim != none && a == victim
		return bStripVictim
 	elseif victim != none && a != victim
 		return bStripAggressor
 	elseif victim == none && !female
 		return bStripMale
 	else
 		return bStripFemale
 	endIf
endFunction

bool function IsStrippable(form item)
	if item == none
		return false
	endIf
	int i = item.GetNumKeywords()
	while i
		i -= 1
		string kw = item.GetNthKeyword(i).GetString()
		if StringUtil.Find(kw, "NoStrip") != -1 || StringUtil.Find(kw, "Bound") != -1
			return false
		endIf
	endWhile
	return true
endFunction

form[] function StripSlots(actor a, bool[] strip, bool animate = false, bool allowNudesuit = true)
	if strip.Length != 33
		return none
	endIf
	; Determine gender and animation switch
	int gender = a.GetLeveledActorBase().GetSex()
	if animate
		if gender == 0
			Debug.SendAnimationEvent(a, "Arrok_FemaleUndress")
		else
			Debug.SendAnimationEvent(a, "Arrok_MaleUndress")
		endIf
	endIf
	; Item storage
	form[] items = new form[34]
	; Strip weapon
	if strip[32]
		Weapon eWeap = a.GetEquippedWeapon(true)
		if IsStrippable(eWeap)
			int type = a.GetEquippedItemType(1)
			if type == 5 || type == 6 || type == 7
				a.AddItem(DummyWeapon, 1, true)
				a.EquipItem(DummyWeapon, false, true)
				a.UnEquipItem(DummyWeapon, false, true)
				a.RemoveItem(DummyWeapon, 1, true)
			else
				a.UnequipItem(eWeap, false, true)
			endIf
			items[32] = eWeap
		endIf
		eWeap = a.GetEquippedWeapon(false)
		if IsStrippable(eWeap)
			a.UnequipItem(eWeap, false, true)
			items[33] = eWeap
			if animate
				Utility.Wait(0.20)
			endIf
		endIf
	endIf
	; Strip armors
	int i
	while i < 32
		if strip[i]
			form item = a.GetWornForm(Armor.GetMaskForSlot(i + 30))
			if IsStrippable(item)
				a.UnequipItem(item, false, true)
				items[i] = item
				if animate
					Utility.Wait(0.20)
				endIf
			endIf
		endIf
		i += 1
	endWhile
	; Apply Nudesuit
	if strip[2] && allowNudesuit
		if (gender == 0 && bUseMaleNudeSuit) || (gender == 1  && bUseFemaleNudeSuit)
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
	if bUseMaleNudeSuit || bUseFemaleNudeSuit
		a.UnequipItem(NudeSuit, true, true)
		a.RemoveItem(NudeSuit, 1, true)
	endIf
	if a == victim && !bReDressVictim
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
			if type == 41 || type == 31 || type == 22 || type == 82
				hand = 0
			endIf
		endIf
		Utility.Wait(0.25)
	endWhile
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

function ForbidActor(actor a)
	a.AddToFaction(ForbiddenFaction)
endFunction

function AllowActor(actor a)
	a.RemoveFromFaction(ForbiddenFaction)
endFunction

bool function IsForbidden(actor a)
	return a.HasKeyWordString("SexLabForbid") || !a.IsInFaction(ForbiddenFaction)
endFunction

function TreatAsMale(actor a)
	a.AddToFaction(GenderFaction)
	a.SetFactionRank(GenderFaction, 0)
endFunction

function TreatAsFemale(actor a)
	a.AddToFaction(GenderFaction)
	a.SetFactionRank(GenderFaction, 1)
endFunction

function ClearForcedGender(actor a)
	a.RemoveFromFaction(GenderFaction)
endFunction

int function GetGender(actor a)
	ActorBase Base = a.GetLeveledActorBase()
	if AnimLib.CreatureSlots.HasRace(Base.GetRace())
		return 2 ; Creature
	elseif a.GetFactionRank(GenderFaction) == 0 || a.HasKeywordString("SexLabTreatMale")
		return 0 ; Male
	elseif a.GetFactionRank(GenderFaction) == 1 || a.HasKeywordString("SexLabTreatFemale")
		return 1 ; Female
	else
		return Base.GetSex() ; Default
	endIf
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

;#---------------------------#
;#    Hotkeys For Player     #
;#---------------------------#
function _HKStart(sslThreadController Controller)
	RegisterForKey(kBackwards)
	RegisterForKey(kAdjustStage)
	RegisterForKey(kAdvanceAnimation)
	RegisterForKey(kChangeAnimation)
	RegisterForKey(kChangePositions)
	RegisterForKey(kAdjustChange)
	RegisterForKey(kAdjustForward)
	RegisterForKey(kAdjustSideways)
	RegisterForKey(kAdjustUpward)
	RegisterForKey(kRealignActors)
	RegisterForKey(kRestoreOffsets)
	RegisterForKey(kMoveScene)
	RegisterForKey(kRotateScene)
	PlayerController = Controller
	hkReady = true
endFunction

function _HKClear()
	UnregisterForAllKeys()
	PlayerController = none
	hkReady = true
endFunction

event OnKeyDown(int keyCode)
	if PlayerController != none && hkReady && !UI.IsMenuOpen("Console") && !UI.IsMenuOpen("Main Menu") && !UI.IsMenuOpen("Loading Menu") && !UI.IsMenuOpen("MessageBoxMenu")
		hkReady = false
		Utility.Wait(0.001)

		bool backwards
		if kBackwards == 42 || kBackwards == 54
			; Check both shift keys
			backwards = ( input.IsKeyPressed(42) || input.IsKeyPressed(54) )
		else
			backwards = input.IsKeyPressed(kBackwards)
		endIf

		bool adjustingstage
		if kAdjustStage == 157 || kAdjustStage == 29
			; Check both ctrl keys
			adjustingstage = ( input.IsKeyPressed(157) || input.IsKeyPressed(29) )
		else
			adjustingstage = input.IsKeyPressed(kBackwards)
		endIf

		; Advance Stage
		if keyCode == kAdvanceAnimation
			PlayerController.AdvanceStage(backwards)
		; Change Animation
		elseIf keyCode == kChangeAnimation
			PlayerController.ChangeAnimation(backwards)
		; Change Positions
		elseIf keyCode == kChangePositions
			PlayerController.ChangePositions(backwards)
		; Forward / Backward adjustments
		elseIf keyCode == kAdjustForward
			PlayerController.AdjustForward(backwards, adjustingstage)
		; Left / Right adjustments
		elseIf keyCode == kAdjustSideways
			PlayerController.AdjustSideways(backwards, adjustingstage)
		; Up / Down adjustments
		elseIf keyCode == kAdjustUpward
			PlayerController.AdjustUpward(backwards, adjustingstage)
		; Change Adjusted Actor
		elseIf keyCode == kAdjustChange
			PlayerController.AdjustChange(backwards)
		; RePosition Actors
		elseIf keyCode == kRealignActors
			PlayerController.RealignActors()
		; Restore animation offsets
		elseIf keyCode == kRestoreOffsets
			PlayerController.RestoreOffsets()
		; Move Scene
		elseIf keyCode == kMoveScene
			PlayerController.MoveScene()
		; Rotate Scene
		elseIf keyCode == kRotateScene
			PlayerController.RotateScene(backwards)
		endIf
		hkReady = true
	endIf
endEvent
;#---------------------------#
;#  END Hotkeys For Player   #
;#---------------------------#


armor function LoadStrapon(string esp, int id)
	armor strapon = Game.GetFormFromFile(id, esp) as armor
	if strapon != none
		Strapons = sslUtility.PushForm(strapon, Strapons)
	endif
	return strapon
endFunction

function _Defaults()
	; Config
	SOSEnabled = false
	bDisablePlayer = false
	fMaleVoiceDelay = 7.0
	fFemaleVoiceDelay = 6.0
	fVoiceVolume = 0.7
	bEnableTCL = false
	bScaleActors = false
	bUseCum = true
	bAllowFFCum = false
	fCumTimer = 120.0
	bUseStrapons = true
	bReDressVictim = true
	bRagdollEnd = false
	bUseMaleNudeSuit = false
	bUseFemaleNudeSuit = false
	bUndressAnimation = false

	; Hotkeys
	kBackwards = 54 ; Right Shift
	kAdjustStage = 157; Right Ctrl
	kAdvanceAnimation = 57 ; Space
	kChangeAnimation =  24 ; O
	kChangePositions = 13 ; =
	kAdjustChange = 37 ; K
	kAdjustForward = 38 ; L
	kAdjustSideways = 40 ; '
	kAdjustUpward = 39 ; ;
	kRealignActors = 26 ; [
	kMoveScene = 27 ; ]
	kRestoreOffsets = 12 ; -
	kRotateScene = 22 ; U

	; Strip
	bStripMale = new bool[33]
	bStripMale[0] = true
	bStripMale[1] = true
	bStripMale[2] = true
	bStripMale[3] = true
	bStripMale[7] = true
	bStripMale[8] = true
	bStripMale[9] = true
	bStripMale[4] = true
	bStripMale[11] = true
	bStripMale[15] = true
	bStripMale[16] = true
	bStripMale[17] = true
	bStripMale[19] = true
	bStripMale[23] = true
	bStripMale[24] = true
	bStripMale[26] = true
	bStripMale[27] = true
	bStripMale[28] = true
	bStripMale[29] = true
	bStripMale[32] = true

	bStripFemale = new bool[33]
	bStripFemale[0] = true
	bStripFemale[1] = true
	bStripFemale[2] = true
	bStripFemale[3] = true
	bStripFemale[4] = true
	bStripFemale[7] = true
	bStripFemale[8] = true
	bStripFemale[9] = true
	bStripFemale[11] = true
	bStripFemale[15] = true
	bStripFemale[16] = true
	bStripFemale[17] = true
	bStripFemale[19] = true
	bStripFemale[23] = true
	bStripFemale[24] = true
	bStripFemale[26] = true
	bStripFemale[27] = true
	bStripFemale[28] = true
	bStripFemale[29] = true
	bStripFemale[32] = true

	bStripLeadInFemale = new bool[33]
	bStripLeadInFemale[0] = true
	bStripLeadInFemale[2] = true
	bStripLeadInFemale[9] = true
	bStripLeadInFemale[14] = true
	bStripLeadInFemale[32] = true

	bStripLeadInMale = new bool[33]
	bStripLeadInMale[0] = true
	bStripLeadInMale[2] = true
	bStripLeadInMale[9] = true
	bStripLeadInMale[14] = true
	bStripLeadInMale[32] = true

	bStripVictim = new bool[33]
	bStripVictim[1] = true
	bStripVictim[2] = true
	bStripVictim[4] = true
	bStripVictim[9] = true
	bStripVictim[11] = true
	bStripVictim[16] = true
	bStripVictim[24] = true
	bStripVictim[26] = true
	bStripVictim[28] = true
	bStripVictim[32] = true

	bStripAggressor = new bool[33]
	bStripAggressor[2] = true
	bStripAggressor[4] = true
	bStripAggressor[9] = true
	bStripAggressor[16] = true
	bStripAggressor[24] = true
	bStripAggressor[26] = true
endFunction
