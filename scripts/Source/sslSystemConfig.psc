scriptname sslSystemConfig extends sslSystemLibrary

; // TODO: Add a 3rd person mod detection when determining FNIS sensitive variables.
; // Disable it when no longer relevant.
; ------------------------------------------------------- ;
; --- System Resources                                --- ;
; ------------------------------------------------------- ;

SexLabFramework property SexLab auto

int function GetVersion()
	return SexLabUtil.GetVersion()
endFunction

string function GetStringVer()
	return SexLabUtil.GetStringVer()
endFunction

bool property Enabled hidden
	bool function get()
		return SexLab.Enabled
	endFunction
endProperty

; bool property InDebugMode auto hidden
bool property DebugMode hidden
	bool function get()
		return InDebugMode
	endFunction
	function set(bool value)
		InDebugMode = value
		if InDebugMode
			Debug.OpenUserLog("SexLabDebug")
			Debug.TraceUser("SexLabDebug", "SexLab Debug/Development Mode Deactivated")
			MiscUtil.PrintConsole("SexLab Debug/Development Mode Activated")
			if PlayerRef && PlayerRef != none
				PlayerRef.AddSpell((Game.GetFormFromFile(0x073CC, "SexLab.esm") as Spell))
				PlayerRef.AddSpell((Game.GetFormFromFile(0x5FE9B, "SexLab.esm") as Spell))
			endIf				
		else
			if Debug.TraceUser("SexLabDebug", "SexLab Debug/Development Mode Deactivated")
				Debug.CloseUserLog("SexLabDebug")
			endIf
			MiscUtil.PrintConsole("SexLab Debug/Development Mode Deactivated")
			if PlayerRef && PlayerRef != none
				PlayerRef.RemoveSpell((Game.GetFormFromFile(0x073CC, "SexLab.esm") as Spell))
				PlayerRef.RemoveSpell((Game.GetFormFromFile(0x5FE9B, "SexLab.esm") as Spell))
			endIf				
		endIf
		int eid = ModEvent.Create("SexLabDebugMode")
		ModEvent.PushBool(eid, value)
		ModEvent.Send(eid)
	endFunction
endProperty


Faction property AnimatingFaction auto
Faction property GenderFaction auto
Faction property ForbiddenFaction auto
Weapon property DummyWeapon auto
Armor property NudeSuit auto
Armor property CalypsStrapon auto
Form[] property Strapons auto hidden

Spell property SelectedSpell auto

Spell property CumVaginalOralAnalSpell auto
Spell property CumOralAnalSpell auto
Spell property CumVaginalOralSpell auto
Spell property CumVaginalAnalSpell auto
Spell property CumVaginalSpell auto
Spell property CumOralSpell auto
Spell property CumAnalSpell auto

Spell property Vaginal1Oral1Anal1 auto
Spell property Vaginal2Oral1Anal1 auto
Spell property Vaginal2Oral2Anal1 auto
Spell property Vaginal2Oral1Anal2 auto
Spell property Vaginal1Oral2Anal1 auto
Spell property Vaginal1Oral2Anal2 auto
Spell property Vaginal1Oral1Anal2 auto
Spell property Vaginal2Oral2Anal2 auto
Spell property Oral1Anal1 auto
Spell property Oral2Anal1 auto
Spell property Oral1Anal2 auto
Spell property Oral2Anal2 auto
Spell property Vaginal1Oral1 auto
Spell property Vaginal2Oral1 auto
Spell property Vaginal1Oral2 auto
Spell property Vaginal2Oral2 auto
Spell property Vaginal1Anal1 auto
Spell property Vaginal2Anal1 auto
Spell property Vaginal1Anal2 auto
Spell property Vaginal2Anal2 auto
Spell property Vaginal1 auto
Spell property Vaginal2 auto
Spell property Oral1 auto
Spell property Oral2 auto
Spell property Anal1 auto
Spell property Anal2 auto

Keyword property CumOralKeyword auto
Keyword property CumAnalKeyword auto
Keyword property CumVaginalKeyword auto
Keyword property CumOralStackedKeyword auto
Keyword property CumAnalStackedKeyword auto
Keyword property CumVaginalStackedKeyword auto

Keyword property ActorTypeNPC auto
Keyword property SexLabActive auto
Keyword property FurnitureBedRoll auto

; FormList property ValidActorList auto
; FormList property NoStripList auto
; FormList property StripList auto

Furniture property BaseMarker auto
Package property DoNothing auto

Sound property OrgasmFX auto
Sound property SquishingFX auto
Sound property SuckingFX auto
Sound property SexMixedFX auto

Sound[] property HotkeyUp auto
Sound[] property HotkeyDown auto

Static property LocationMarker auto
FormList property BedsList auto
FormList property BedRollsList auto
FormList property DoubleBedsList auto
Message property UseBed auto
Message property CleanSystemFinish auto
Message property CheckSKSE auto
Message property CheckFNIS auto
Message property CheckSkyrim auto
Message property CheckSexLabUtil auto
Message property CheckPapyrusUtil auto
Message property CheckSkyUI auto
Message property TakeThreadControl auto

Topic property LipSync auto
VoiceType property SexLabVoiceM auto
VoiceType property SexLabVoiceF auto
FormList property SexLabVoices auto
; FormList property VoicesPlayer auto ; No longer used - v1.56
SoundCategory property AudioSFX auto
SoundCategory property AudioVoice auto

Idle property IdleReset auto

GlobalVariable property DebugVar1 auto
GlobalVariable property DebugVar2 auto
GlobalVariable property DebugVar3 auto
GlobalVariable property DebugVar4 auto
GlobalVariable property DebugVar5 auto

; ------------------------------------------------------- ;
; --- Config Properties                               --- ;
; ------------------------------------------------------- ;

; Booleans
bool property RestrictAggressive auto hidden
bool property AllowCreatures auto hidden
bool property NPCSaveVoice auto hidden
bool property UseStrapons auto hidden
bool property RestrictStrapons auto hidden
bool property RedressVictim auto hidden
bool property RagdollEnd auto hidden
bool property UseMaleNudeSuit auto hidden
bool property UseFemaleNudeSuit auto hidden
bool property UndressAnimation auto hidden
bool property UseLipSync auto hidden
bool property UseExpressions auto hidden
bool property RefreshExpressions auto hidden
bool property ScaleActors auto hidden
bool property UseCum auto hidden
bool property AllowFFCum auto hidden
bool property DisablePlayer auto hidden
bool property AutoTFC auto hidden
bool property AutoAdvance auto hidden
bool property ForeplayStage auto hidden
bool property OrgasmEffects auto hidden
bool property RaceAdjustments auto hidden
bool property BedRemoveStanding auto hidden
bool property UseCreatureGender auto hidden
bool property LimitedStrip auto hidden
bool property RestrictSameSex auto hidden
bool property RestrictGenderTag auto hidden
bool property SeparateOrgasms auto hidden
bool property RemoveHeelEffect auto hidden
bool property AdjustTargetStage auto hidden
bool property ShowInMap auto hidden
bool property DisableTeleport auto hidden
bool property SeedNPCStats auto hidden
bool property DisableScale auto hidden
bool property FixVictimPos auto hidden

; Integers
int property AnimProfile auto hidden
int property AskBed auto hidden
int property NPCBed auto hidden
int property OpenMouthSize auto hidden
int property UseFade auto hidden

int property Backwards auto hidden
int property AdjustStage auto hidden
int property AdvanceAnimation auto hidden
int property ChangeAnimation auto hidden
int property ChangePositions auto hidden
int property AdjustChange auto hidden
int property AdjustForward auto hidden
int property AdjustSideways auto hidden
int property AdjustUpward auto hidden
int property RealignActors auto hidden
int property MoveScene auto hidden
int property RestoreOffsets auto hidden
int property RotateScene auto hidden
int property EndAnimation auto hidden
int property ToggleFreeCamera auto hidden
int property TargetActor auto hidden
int property AdjustSchlong auto hidden

; Floats
float property CumTimer auto hidden
float property ShakeStrength auto hidden
float property AutoSUCSM auto hidden
float property MaleVoiceDelay auto hidden
float property FemaleVoiceDelay auto hidden
float property ExpressionDelay auto hidden
float property VoiceVolume auto hidden
float property SFXDelay auto hidden
float property SFXVolume auto hidden
float property LeadInCoolDown auto hidden

; Boolean Arrays
bool[] property StripMale auto hidden
bool[] property StripFemale auto hidden
bool[] property StripLeadInFemale auto hidden
bool[] property StripLeadInMale auto hidden
bool[] property StripVictim auto hidden
bool[] property StripAggressor auto hidden

; Float Array
float[] property StageTimer auto hidden
float[] property StageTimerLeadIn auto hidden
float[] property StageTimerAggr auto hidden
float[] property OpenMouthMale auto hidden
float[] property OpenMouthFemale auto hidden
float[] property BedOffset auto hidden

; Compatibility checks
bool property HasHDTHeels auto hidden
bool property HasNiOverride auto hidden
bool property HasFrostfall auto hidden
bool property HasSchlongs auto hidden
bool property HasMFGFix auto hidden

FormList property FrostExceptions auto hidden
MagicEffect HDTHeelEffect

; Data
Actor CrosshairRef
Actor property TargetRef auto hidden
Actor[] property TargetRefs auto hidden

int HookCount
bool HooksInit
sslThreadHook[] ThreadHooks

int property LipsPhoneme auto hidden
bool property LipsFixedValue auto hidden
int property LipsMinValue auto hidden
int property LipsMaxValue auto hidden
int property LipsSoundTime auto hidden
float property LipsMoveTime auto hidden

; ------------------------------------------------------- ;
; --- Config Accessors                                --- ;
; ------------------------------------------------------- ;

float function GetVoiceDelay(bool IsFemale = false, int Stage = 1, bool IsSilent = false)
	if IsSilent
		return 3.0 ; Return basic delay for loop
	endIf
	float VoiceDelay = MaleVoiceDelay
	if IsFemale
		VoiceDelay = FemaleVoiceDelay
	endIf
	if Stage > 1
		VoiceDelay -= (Stage * 0.8) + Utility.RandomFloat(-0.2, 0.4)
		if VoiceDelay < 0.8
			return Utility.RandomFloat(0.8, 1.3) ; Can't have delay shorter than animation update loop
		endIf
	endIf
	return VoiceDelay
endFunction

bool[] function GetStrip(bool IsFemale, bool IsLeadIn = false, bool IsAggressive = false, bool IsVictim = false)
	if IsLeadIn
		if IsFemale
			return StripLeadInFemale
		else
			return StripLeadInMale
		endIf
 	elseif IsAggressive
 		if IsVictim
 			return StripVictim
 		else
 			return StripAggressor
 		endIf
 	elseIf IsFemale
 		return StripFemale
 	else
 		return StripMale
 	endIf
endFunction

bool function UsesNudeSuit(bool IsFemale)
	return ((!IsFemale && UseMaleNudeSuit) || (IsFemale && UseFemaleNudeSuit))
endFunction

bool function HasCreatureInstall()
	return FNIS.GetMajor(true) > 0 && (Game.GetCameraState() < 8 || PlayerRef.GetAnimationVariableInt("SexLabCreature") > 0)
endFunction

float[] function GetOpenMouthPhonemes(bool isFemale)
	float[] Phonemes = new float[16]
	int i = 16
	while i > 0
		i -= 1
		if isFemale
			Phonemes[i] = OpenMouthFemale[i]
		else
			Phonemes[i] = OpenMouthMale[i]
		endIf
	endWhile
	return Phonemes
endFunction

bool function SetOpenMouthPhonemes(bool isFemale, float[] Phonemes)
	if Phonemes.Length < 16
		return false
	endIf
	if OpenMouthFemale.Length < 16
		OpenMouthFemale = new float[17]
	endIf
	if OpenMouthMale.Length < 16
		OpenMouthMale = new float[17]
	endIf
	int i = 16
	while i > 0
		i -= 1
		if isFemale
			OpenMouthFemale[i] = PapyrusUtil.ClampFloat(Phonemes[i], 0.0, 1.0)
		else
			OpenMouthMale[i] = PapyrusUtil.ClampFloat(Phonemes[i], 0.0, 1.0)
		endIf
	endWhile
	return true
endFunction

bool function SetOpenMouthPhoneme(bool isFemale, int id, float value)
	if id < 0 || id > 15 
		return false
	endIf
	if isFemale
		if OpenMouthFemale.Length < 16
			OpenMouthFemale = new float[17]
		endIf
		OpenMouthFemale[id] = PapyrusUtil.ClampFloat(value, 0.0, 1.0)
	else
		if OpenMouthMale.Length < 16
			OpenMouthMale = new float[17]
		endIf
		OpenMouthMale[id] = PapyrusUtil.ClampFloat(value, 0.0, 1.0)
	endIf
	return true
endFunction

int function GetOpenMouthExpression(bool isFemale)
	if isFemale
		if OpenMouthFemale.Length >= 17 && OpenMouthFemale[16] >= 0.0 && OpenMouthFemale[16] <= 16.0
			return OpenMouthFemale[16] as int
		endIf
	else
		if OpenMouthMale.Length >= 17 && OpenMouthMale[16] >= 0.0 && OpenMouthMale[16] <= 16.0
			return OpenMouthMale[16] as int
		endIf
	endIf
	return 16
endFunction

bool function SetOpenMouthExpression(bool isFemale, int value)
	if isFemale
		if OpenMouthFemale.Length < 17
			OpenMouthFemale = new float[17]
		endIf
		OpenMouthFemale[16] = PapyrusUtil.ClampInt(value, 0, 16) as Float
		return true
	else
		if OpenMouthMale.Length < 17
			OpenMouthMale = new float[17]
		endIf
		OpenMouthMale[16] = PapyrusUtil.ClampInt(value, 0, 16) as Float
		return true
	endIf
	return false
endFunction

bool function AddCustomBed(Form BaseBed, int BedType = 0)
	if !BaseBed
		return false
	elseIf !BedsList.HasForm(BaseBed)
		BedsList.AddForm(BaseBed)
	endIf
	if BedType == 1 && !BedRollsList.HasForm(BaseBed)
		BedRollsList.AddForm(BaseBed)
	elseIf BedType == 2 && !DoubleBedsList.HasForm(BaseBed)
		DoubleBedsList.AddForm(BaseBed)
	endIf
	return true
endFunction

bool function SetCustomBedOffset(Form BaseBed, float Forward = 0.0, float Sideward = 0.0, float Upward = 37.0, float Rotation = 0.0)
	if !BaseBed || !BedsList.HasForm(BaseBed)
		Log("Invalid form or bed does not exist currently in bed list.", "SetBedOffset("+BaseBed+")")
		return false
	endIf
	float[] off = new float[4]
	off[0] = Forward
	off[1] = Sideward
	off[2] = Upward
	off[3] = PapyrusUtil.ClampFloat(Rotation, -360.0, 360.0)
	StorageUtil.FloatListCopy(BaseBed, "SexLab.BedOffset", off)
	return true
endFunction

bool function ClearCustomBedOffset(Form BaseBed)
	return StorageUtil.FloatListClear(BaseBed, "SexLab.BedOffset") > 0
endFunction

float[] function GetBedOffsets(Form BaseBed)
	float[] Offsets = new float[4]
	if StorageUtil.FloatListCount(BaseBed, "SexLab.BedOffset") == 4
		StorageUtil.FloatListSlice(BaseBed, "SexLab.BedOffset", Offsets)
		return Offsets
	endIf
	int i = BedOffset.Length
	; For some reason with the old function if you change the value of the variable with the returned BedOffset Array the value also change on the original BedOffset
	while i > 0
		i -= 1
		Offsets[i] = BedOffset[i]
	endWhile
	return Offsets
endFunction

; ------------------------------------------------------- ;
; --- Strapon Functions                               --- ;
; ------------------------------------------------------- ;

Form function GetStrapon()
	if Strapons.Length > 0
		return Strapons[Utility.RandomInt(0, (Strapons.Length - 1))]
	endIf
	return none
endFunction

Form function WornStrapon(Actor ActorRef)
	int i = Strapons.Length
	while i
		i -= 1
		if ActorRef.GetItemCount(Strapons[i]) > 0
			return Strapons[i]
		endIf
	endWhile
	return none
endFunction

bool function HasStrapon(Actor ActorRef)
	return WornStrapon(ActorRef) != none
endFunction

Form function PickStrapon(Actor ActorRef)
	form Strapon = WornStrapon(ActorRef)
	if Strapon
		return Strapon
	endIf
	return GetStrapon()
endFunction

Form function EquipStrapon(Actor ActorRef)
	form Strapon = PickStrapon(ActorRef)
	if Strapon
		ActorRef.AddItem(Strapon, 1, true)
		ActorRef.EquipItem(Strapon, false, true)
	endIf
	return Strapon
endFunction

function UnequipStrapon(Actor ActorRef)
	int i = Strapons.Length
	while i
		i -= 1
		if ActorRef.IsEquipped(Strapons[i])
			ActorRef.RemoveItem(Strapons[i], 1, true)
		endIf
	endWhile
endFunction

function LoadStrapons()
	Strapons = new form[1]
	Strapons[0] = CalypsStrapon

	if Game.GetModByName("StrapOnbyaeonv1.1.esp") != 255
		LoadStrapon("StrapOnbyaeonv1.1.esp", 0x0D65)
	endIf
	if Game.GetModByName("TG.esp") != 255
		LoadStrapon("TG.esp", 0x0182B)
	endIf
	if Game.GetModByName("Futa equippable.esp") != 255
		LoadStrapon("Futa equippable.esp", 0x0D66)
		LoadStrapon("Futa equippable.esp", 0x0D67)
		LoadStrapon("Futa equippable.esp", 0x01D96)
		LoadStrapon("Futa equippable.esp", 0x022FB)
		LoadStrapon("Futa equippable.esp", 0x022FC)
		LoadStrapon("Futa equippable.esp", 0x022FD)
	endIf
	if Game.GetModByName("Skyrim_Strap_Ons.esp") != 255
		LoadStrapon("Skyrim_Strap_Ons.esp", 0x00D65)
		LoadStrapon("Skyrim_Strap_Ons.esp", 0x02859)
		LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285A)
		LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285B)
		LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285C)
		LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285D)
		LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285E)
		LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285F)
	endIf
	if Game.GetModByName("SOS Equipable Schlong.esp") != 255
		LoadStrapon("SOS Equipable Schlong.esp", 0x0D62)
	endIf
	ModEvent.Send(ModEvent.Create("SexLabLoadStrapons"))
endFunction

Armor function LoadStrapon(string esp, int id)
	Form Strapon = Game.GetFormFromFile(id, esp)
	if Strapon && (Strapon as Armor)
		Strapons = PapyrusUtil.PushForm(Strapons, Strapon)
	endif
	return Strapon as Armor
endFunction

; ------------------------------------------------------- ;
; --- Hotkeys                                         --- ;
; ------------------------------------------------------- ;

sslThreadController Control

event OnKeyDown(int keyCode)
	if !Utility.IsInMenuMode() && !UI.IsMenuOpen("Console") && !UI.IsMenuOpen("Loading Menu")
		if keyCode == ToggleFreeCamera
			ToggleFreeCamera()
		elseIf keyCode == TargetActor
			if Control
				DisableThreadControl(Control)
			else
				SetTargetActor()
			endIf
		elseIf keyCode == EndAnimation && BackwardsPressed()
			ThreadSlots.StopAll()
		endIf
	endIf
endEvent

event OnCrosshairRefChange(ObjectReference ActorRef)
	CrosshairRef = none
	if ActorRef
		CrosshairRef = ActorRef as Actor
	endIf
endEvent

function SetTargetActor()
	if CrosshairRef && CrosshairRef != none
		TargetRef = CrosshairRef
		SelectedSpell.Cast(TargetRef, TargetRef)
		Debug.Notification("SexLab Target Selected: "+TargetRef.GetLeveledActorBase().GetName())
		; Give them stats if they need it
		Stats.SeedActor(TargetRef)
		; Attempt to grab control of their animation?
		sslThreadController TargetThread = ThreadSlots.GetActorController(TargetRef)
		if TargetThread && !TargetThread.HasPlayer && (TargetThread.GetState() == "Animating" || TargetThread.GetState() == "Advancing")
			sslThreadController PlayerThread = ThreadSlots.GetActorController(PlayerRef)
			if (!PlayerThread || !(PlayerThread.GetState() == "Animating" || PlayerThread.GetState() == "Advancing")) && TakeThreadControl.Show()
				if PlayerThread != none
					ThreadSlots.StopThread(PlayerThread)
				endIf
				GetThreadControl(TargetThread) 
			endIf
		endIf
	endif
endFunction

function AddTargetActor(Actor ActorRef)
	if ActorRef
		if TargetRefs.Find(ActorRef) != -1
			TargetRefs[TargetRefs.Find(ActorRef)] = none
		endIf
		TargetRefs[4] = TargetRefs[3]
		TargetRefs[3] = TargetRefs[2]
		TargetRefs[2] = TargetRefs[1]
		TargetRefs[1] = TargetRefs[0]
		TargetRefs[0] = ActorRef
	endIf
endFunction

; Actor function GetNthValidTargetActor(int i)
; 	Form FormRef = StorageUtil.FormListGet(self, "TargetActors", i)
; 	if SexLabUtil.IsActor(FormRef)
; 		return FormRef as Actor
; 	endIf
; 	return none
; endFunction

; Actor[] function GetTargetActors()
; 	StorageUtil.FormListRemove(self, "TargetActors", TargetRef, true)

; 	Actor[] Target
; 	int i = StorageUtil.FormListFilterByTypes(self, "TargetActors")
; 	while i

; 	endWhile

; 	Form[] All = new Form[5]
; 	StorageUtil.FormListSlice(self, "TargetActors", All)

; 	int i = 5
; 	while i
; 		i -= 1
; 		if All[i]
; 			if !SexLabUtil.IsActor(FormRef)
; 				StorageUtil.FormListRemove(self, "TargetActors", All[i])
; 			else

; 			endIf
; 		endIf

; 	endWhile



; endFunction

sslThreadController function GetThreadControlled()
	return Control
endFunction

function GetThreadControl(sslThreadController TargetThread)
	if Control || !(TargetThread.GetState() == "Animating" || TargetThread.GetState() == "Advancing")
		Log("Failed to control thread "+TargetThread)
		return ; Control not available
	endIf
	; Set active controlled thread
	Control = TargetThread
	if !Control || Control == none
		Log("Failed to control thread "+TargetThread)
		return ; Control not available
	endIf
	; Lock players movement
	PlayerRef.StopCombat()
	if PlayerRef.IsWeaponDrawn()
		PlayerRef.SheatheWeapon()
	endIf
	PlayerRef.SetFactionRank(AnimatingFaction, 1)
	ActorUtil.AddPackageOverride(PlayerRef, DoNothing, 100, 1)
	PlayerRef.EvaluatePackage()
	Game.DisablePlayerControls(true, true, false, false, false, false, false, false, 0)
	Game.SetPlayerAIDriven()
	; Give player control
	Control.AutoAdvance = false
	Control.EnableHotkeys(true)
	Log("Player has taken control of thread "+Control)
endFunction

function DisableThreadControl(sslThreadController TargetThread)
	if Control && Control == TargetThread
		; Release players thread control
		MiscUtil.SetFreeCameraState(false)
		if Game.GetCameraState() == 0
			Game.ForceThirdPerson()
		endIf
		Control.DisableHotkeys()
		Control.AutoAdvance = true
		Control = none
		; Unlock players movement
		PlayerRef.RemoveFromFaction(AnimatingFaction)
		ActorUtil.RemovePackageOverride(PlayerRef, DoNothing)
		PlayerRef.EvaluatePackage()
		Game.EnablePlayerControls()
		Game.SetPlayerAIDriven(false)
	endIf
endfunction

function ToggleFreeCamera()
	if Game.GetCameraState() != 3
		MiscUtil.SetFreeCameraSpeed(AutoSUCSM)
	endIf
	MiscUtil.ToggleFreeCamera()
endFunction

bool function BackwardsPressed()
	return Input.GetNumKeysPressed() > 1 && MirrorPress(Backwards)
endFunction

bool function AdjustStagePressed()
	return (!AdjustTargetStage && Input.GetNumKeysPressed() > 1 && MirrorPress(AdjustStage)) \
		|| (AdjustTargetStage && !(Input.GetNumKeysPressed() > 1 && MirrorPress(AdjustStage)))
endFunction

bool function IsAdjustStagePressed()
	return Input.GetNumKeysPressed() > 1 && MirrorPress(AdjustStage)
endFunction

bool function MirrorPress(int mirrorkey)
	if mirrorkey == 42 || mirrorkey == 54  ; Shift
		return Input.IsKeyPressed(42) || Input.IsKeyPressed(54)
	elseif mirrorkey == 29 || mirrorkey == 157 ; Ctrl
		return Input.IsKeyPressed(29) || Input.IsKeyPressed(157)
	elseif mirrorkey == 56 || mirrorkey == 184 ; Alt
		return Input.IsKeyPressed(56) || Input.IsKeyPressed(184)
	else
		return Input.IsKeyPressed(mirrorkey)
	endIf
endFunction

; ------------------------------------------------------- ;
; --- Animation Profiles                              --- ;
; ------------------------------------------------------- ;

function ExportProfile(int Profile = 1)
	SaveAdjustmentProfile()
endFunction

function ImportProfile(int Profile = 1)
	SetAdjustmentProfile("../SexLab/AnimationProfile_"+Profile+".json")
endfunction

function SwapToProfile(int Profile)
	AnimProfile = Profile
	SetAdjustmentProfile("../SexLab/AnimationProfile_"+Profile+".json")
endFunction

bool function SetAdjustmentProfile(string ProfileName) global native
bool function SaveAdjustmentProfile() global native

; ------------------------------------------------------- ;
; --- 3rd party compatibility                         --- ;
; ------------------------------------------------------- ;

Spell function GetHDTSpell(Actor ActorRef)
	if !HasHDTHeels || !HDTHeelEffect || !ActorRef; || !ActorRef.GetWornForm(Armor.GetMaskForSlot(37))
		return none
	endIf
	int i = ActorRef.GetSpellCount()
	while i
		i -= 1
		Spell SpellRef = ActorRef.GetNthSpell(i)
		Log(SpellRef.GetName(), "Checking("+SpellRef+") for HDT HighHeels")
		if SpellRef && StringUtil.Find(SpellRef.GetName(), "Heel") != -1
			return SpellRef
		endIf
		int n = SpellRef.GetNumEffects()
		while n
			n -= 1
			if SpellRef.GetNthEffectMagicEffect(n) == HDTHeelEffect
				return SpellRef
			endIf
		endWhile
	endWhile
	return none
endFunction


Faction property BardExcludeFaction auto
ReferenceAlias property BardBystander1 auto
ReferenceAlias property BardBystander2 auto
ReferenceAlias property BardBystander3 auto
ReferenceAlias property BardBystander4 auto
ReferenceAlias property BardBystander5 auto

bool function CheckBardAudience(Actor ActorRef, bool RemoveFromAudience = true)
	if !ActorRef
		return false; Invalid argument
	elseIf RemoveFromAudience
		return BystanderClear(ActorRef, BardBystander1) || BystanderClear(ActorRef, BardBystander2) || BystanderClear(ActorRef, BardBystander3) \
			|| BystanderClear(ActorRef, BardBystander4) || BystanderClear(ActorRef, BardBystander5)
	else
		return ActorRef == BardBystander1.GetReference() || ActorRef == BardBystander2.GetReference() || ActorRef == BardBystander3.GetReference() \
			|| ActorRef == BardBystander4.GetReference() || ActorRef == BardBystander5.GetReference()
	endIf
endFunction

bool function BystanderClear(Actor ActorRef, ReferenceAlias BardBystander)
	if ActorRef == BardBystander.GetReference()
		BardBystander.Clear()
		ActorRef.EvaluatePackage()
		Log("Cleared from bard audience", "CheckBardAudience("+ActorRef+")")
		return true
	endIf
	return false
endFunction

; ------------------------------------------------------- ;
; --- System Use                                      --- ;
; ------------------------------------------------------- ;

bool function CheckSystemPart(string CheckSystem)
	if CheckSystem == "Skyrim"
		return (StringUtil.SubString(Debug.GetVersionNumber(), 0, 3) as float) >= 1.5

	elseIf CheckSystem == "SKSE"
		return SKSE.GetScriptVersionRelease() >= 64

	elseIf CheckSystem == "SkyUI"
		return Quest.GetQuest("SKI_ConfigManagerInstance") != none

	elseIf CheckSystem == "SexLabUtil"
		return SexLabUtil.GetPluginVersion() >= 16300

	elseIf CheckSystem == "PapyrusUtil"
		return PapyrusUtil.GetVersion() >= 39

	elseIf CheckSystem == "NiOverride"
		return SKSE.GetPluginVersion("SKEE64") >= 7 || NiOverride.GetScriptVersion() >= 7 ;SSE

	elseIf CheckSystem == "FNIS"
		return FNIS.VersionCompare(7, 0, 0) >= 0

	elseIf CheckSystem == "FNISGenerated"
		return FNIS.IsGenerated()

	elseIf CheckSystem == "FNISCreaturePack"
		return FNIS.VersionCompare(7, 0, 0, true) >= 0

	elseIf CheckSystem == "FNISSexLabFramework" && PlayerRef.Is3DLoaded() && Game.GetCameraState() > 3
		return PlayerRef.GetAnimationVariableInt("SexLabFramework") >= 16000

	elseIf CheckSystem == "FNISSexLabCreature" && PlayerRef.Is3DLoaded() && Game.GetCameraState() > 3
		return PlayerRef.GetAnimationVariableInt("SexLabCreature") >= 16000

	endIf
	return false
endFunction

bool function CheckSystem()
	; Check Skyrim Version
	if !CheckSystemPart("Skyrim")
		CheckSkyrim.Show(1.5)
		return false
	; Check SKSE install
	elseIf !CheckSystemPart("SKSE")
		CheckSKSE.Show(2.17)
		return false
	; Check SkyUI install - depends on passing SKSE check passing
	elseIf !CheckSystemPart("SkyUI")
		CheckSkyUI.Show(5.2)
		return false
	; Check SexLabUtil install - this should never happen if they have properly updated
	elseIf !CheckSystemPart("SexLabUtil")
		CheckSexLabUtil.Show()
		return false
	; Check PapyrusUtil install - depends on passing SKSE check passing
	elseIf !CheckSystemPart("PapyrusUtil")
		CheckPapyrusUtil.Show(3.9)
		return false
	; Check FNIS generation - soft fail
	; elseIf CheckSystemPart("FNISSexLabFramework")
		; CheckFNIS.Show()
	endIf
	; Return result
	return true
endFunction

function Reload()
	; DebugMode = true
	if DebugMode
		Debug.OpenUserLog("SexLabDebug")
		Debug.TraceUser("SexLabDebug", "Config Reloading...")
	endIf

	LoadLibs(false)
	SexLab = SexLabUtil.GetAPI()

	; SetVehicle Scaling Fix
	SexLabUtil.VehicleFixMode((DisableScale as int))

	; Configure SFX & Voice volumes
	AudioVoice.SetVolume(VoiceVolume)
	AudioSFX.SetVolume(SFXVolume)

	; Remove any targeted actors
	RegisterForCrosshairRef()
	CrosshairRef = none
	TargetRef    = none

	; TFC Toggle key
	UnregisterForAllKeys()
	RegisterForKey(ToggleFreeCamera)
	RegisterForKey(TargetActor)
	RegisterForKey(EndAnimation)

	; Mod compatability checks
	; - HDT/NiO High Heels
	HasNiOverride = Config.CheckSystemPart("NiOverride")
	HasHDTHeels   = Game.GetModByName("hdtHighHeel.esm") != 255
	if HasHDTHeels && !HDTHeelEffect
		HDTHeelEffect = Game.GetFormFromFile(0x800, "hdtHighHeel.esm") as MagicEffect
	endIf
	; - Frostfall exposure pausing
	HasFrostfall = Game.GetModByName("Frostfall.esp") != 255; && Game.GetModByName("Campfire.esm") != 255; || Game.GetModByName("Chesko_Frostfall.esp") != 255
	if HasFrostfall && !FrostExceptions
		FrostExceptions = Game.GetFormFromFile(0x6E7E6, "Frostfall.esp") as FormList
	endIf
	; - SOS/SAM Schlongs (currently unused)
	HasSchlongs = Game.GetModByName("Schlongs of Skyrim - Core.esm") != 255 || Game.GetModByName("SAM - Shape Atlas for Men.esp") != 255

	; - MFG Fix check
	HasMFGFix = MfgConsoleFunc.ResetPhonemeModifier(PlayerRef) ; TODO: May need to check another way, some players might get upset that their mfg is reset on load

	if !FadeToBlackHoldImod || FadeToBlackHoldImod == none
		FadeToBlackHoldImod = Game.GetFormFromFile(0xF756E, "Skyrim.esm") as ImageSpaceModifier ;0xF756D **0xF756E 0x10100C** 0xF756F 0xFDC57 0xFDC58 0x 0x 0x
	endIf
	if !FadeToBlurHoldImod || FadeToBlurHoldImod == none
		FadeToBlurHoldImod = Game.GetFormFromFile(0x44F3B, "Skyrim.esm") as ImageSpaceModifier ;0x201D3 0x44F3B **0xFD809 0x1037E2 0x1037E3 0x1037E4 0x1037E5 0x1037E6** 0x
	endIf
	if !ForceBlackVFX || ForceBlackVFX == none
		ForceBlackVFX = Game.GetFormFromFile(0x8FC39, "SexLab.esm") as VisualEffect ;0x44F3A 
	endIf
	if !ForceBlurVFX || ForceBlurVFX == none
		ForceBlurVFX = Game.GetFormFromFile(0x8FC3A, "SexLab.esm") as VisualEffect ;0x101967
	endIf

	; Clean valid actors list
	StorageUtil.FormListRemove(self, "ValidActors", PlayerRef, true)
	StorageUtil.FormListRemove(self, "ValidActors", none, true)


	; TODO: confirm forms are the same in SSE
	if GetBedOffsets(Game.GetFormFromFile(0xB8371, "Skyrim.esm"))[3] != 180.0
		SetCustomBedOffset(Game.GetFormFromFile(0xB8371, "Skyrim.esm"), 0.0, 0.0, 0.0, 180.0) 	; BedRoll Ground
	endIf
	Form DA02Altar = Game.GetFormFromFile(0x5ED79, "Skyrim.esm")
	if DA02Altar && !BedsList.HasForm(DA02Altar)
		BedsList.AddForm(DA02Altar)
		BedRollsList.AddForm(DA02Altar)
	endIf
	Form CivilWarCot01L = Game.GetFormFromFile(0xE2826, "Skyrim.esm")
	if CivilWarCot01L && !BedsList.HasForm(CivilWarCot01L)
		BedsList.AddForm(CivilWarCot01L)
	endIf
	Form WRTempleHealingAltar01 = Game.GetFormFromFile(0xD4848, "Skyrim.esm")
	if WRTempleHealingAltar01 && !BedsList.HasForm(WRTempleHealingAltar01)
		BedsList.AddForm(WRTempleHealingAltar01)
		SetCustomBedOffset(WRTempleHealingAltar01, 0.0, 0.0, 39.0, 90.0)
	endIf
	Form HHFurnitureBedSingle01 = Game.GetFormFromFile(0x2FBC7, "Skyrim.esm")
	if HHFurnitureBedSingle01 && !BedsList.HasForm(HHFurnitureBedSingle01)
		BedsList.AddForm(HHFurnitureBedSingle01)
	endIf
	
	; Dawnguard additions
	if Game.GetModByName("Dawnguard.esm") != 255
		; Serana doesn't have ActorTypeNPC, force validate.
		StorageUtil.FormListAdd(self, "ValidActors", Game.GetFormFromFile(0x2B6C, "Dawnguard.esm"), false)
		; Bedroll
		Form DLC1BedrollGroundF = Game.GetFormFromFile(0xC651, "Dawnguard.esm")
		if DLC1BedrollGroundF && !BedsList.HasForm(DLC1BedrollGroundF)
			BedsList.AddForm(DLC1BedrollGroundF)
			BedRollsList.AddForm(DLC1BedrollGroundF)
			SetCustomBedOffset(DLC1BedrollGroundF, 0.0, 0.0, 0.0, 180.0)
		endIf
	endIf

	; Dragonborn additions
	if Game.GetModByName("Dragonborn.esm") != 255 && !BedsList.HasForm(Game.GetFormFromFile(0x21749, "Dragonborn.esm"))
		Log("Adding Dragonborn beds to formlist...")
		; Single Bed
		Form DLC2DarkElfBed01             = Game.GetFormFromFile(0x21749, "Dragonborn.esm")
		Form DLC2DarkElfBed01R            = Game.GetFormFromFile(0x35037, "Dragonborn.esm")
		Form DLC2DarkElfBed01L            = Game.GetFormFromFile(0x35038, "Dragonborn.esm")
		BedsList.AddForm(DLC2DarkElfBed01)
		BedsList.AddForm(DLC2DarkElfBed01R)
		BedsList.AddForm(DLC2DarkElfBed01L)
		; Double Bed
		Form DLC2DarkElfBedDouble01       = Game.GetFormFromFile(0x32802, "Dragonborn.esm")
		Form DLC2DarkElfBedDouble01R      = Game.GetFormFromFile(0x36796, "Dragonborn.esm")
		Form DLC2DarkElfBedDouble01L      = Game.GetFormFromFile(0x36797, "Dragonborn.esm")
		BedsList.AddForm(DLC2DarkElfBedDouble01)
		BedsList.AddForm(DLC2DarkElfBedDouble01R)
		BedsList.AddForm(DLC2DarkElfBedDouble01L)
		DoubleBedsList.AddForm(DLC2DarkElfBedDouble01)
		DoubleBedsList.AddForm(DLC2DarkElfBedDouble01R)
		DoubleBedsList.AddForm(DLC2DarkElfBedDouble01L)
		; Bedroll
		Form BedRollHay01LDirtSnowPath01F = Game.GetFormFromFile(0x18617, "Dragonborn.esm")
		Form BedRollHay01LDirtSnowPath01R = Game.GetFormFromFile(0x18618, "Dragonborn.esm")
		Form BedRollHay01LDirtSnowPath    = Game.GetFormFromFile(0x1EE28, "Dragonborn.esm")
		Form BedrollHay01IceL             = Game.GetFormFromFile(0x25E51, "Dragonborn.esm")
		Form BedrollHay01IceR             = Game.GetFormFromFile(0x25E52, "Dragonborn.esm")
		Form BedrollHay01R_Ash            = Game.GetFormFromFile(0x28A68, "Dragonborn.esm")
		Form BedrollHay01L_Ash            = Game.GetFormFromFile(0x28AA9, "Dragonborn.esm")
		Form BedrollHay01LDirtPath01L     = Game.GetFormFromFile(0x2C0B2, "Dragonborn.esm")
		Form BedrollHay01LDirtPath01F     = Game.GetFormFromFile(0x2C0B3, "Dragonborn.esm")
		Form BedrollHay01LDirtPath01R     = Game.GetFormFromFile(0x2C0B4, "Dragonborn.esm")
		Form BedrollHay01GlacierL         = Game.GetFormFromFile(0x3D131, "Dragonborn.esm")
		Form BedrollHay01GlacierR         = Game.GetFormFromFile(0x3D132, "Dragonborn.esm")
		BedsList.AddForm(BedRollHay01LDirtSnowPath01F)
		BedsList.AddForm(BedRollHay01LDirtSnowPath01R)
		BedsList.AddForm(BedRollHay01LDirtSnowPath)
		BedsList.AddForm(BedrollHay01IceL)
		BedsList.AddForm(BedrollHay01IceR)
		BedsList.AddForm(BedrollHay01R_Ash)
		BedsList.AddForm(BedrollHay01L_Ash)
		BedsList.AddForm(BedrollHay01LDirtPath01L)
		BedsList.AddForm(BedrollHay01LDirtPath01F)
		BedsList.AddForm(BedrollHay01LDirtPath01R)
		BedsList.AddForm(BedrollHay01GlacierL)
		BedsList.AddForm(BedrollHay01GlacierR)
		BedRollsList.AddForm(BedRollHay01LDirtSnowPath01F)
		BedRollsList.AddForm(BedRollHay01LDirtSnowPath01R)
		BedRollsList.AddForm(BedRollHay01LDirtSnowPath)
		BedRollsList.AddForm(BedrollHay01IceL)
		BedRollsList.AddForm(BedrollHay01IceR)
		BedRollsList.AddForm(BedrollHay01R_Ash)
		BedRollsList.AddForm(BedrollHay01L_Ash)
		BedRollsList.AddForm(BedrollHay01LDirtPath01L)
		BedRollsList.AddForm(BedrollHay01LDirtPath01F)
		BedRollsList.AddForm(BedrollHay01LDirtPath01R)
		BedRollsList.AddForm(BedrollHay01GlacierL)
		BedRollsList.AddForm(BedrollHay01GlacierR)
	endIf

	; Remove gender override if player's gender matches normally
	if PlayerRef.GetFactionRank(GenderFaction) == PlayerRef.GetLeveledActorBase().GetSex()
		PlayerRef.RemoveFromFaction(GenderFaction)
	endIf

	; Clear or register creature animations if it's been toggled
	if !AllowCreatures && CreatureSlots.Slotted > 0
		CreatureSlots.Setup()
	elseIf AllowCreatures && CreatureSlots.Slotted < 1
		CreatureSlots.Setup()
		CreatureSlots.RegisterSlots()
	endIf

	; Remove any NPC thread control player has
	DisableThreadControl(Control)

	; Load json animation profile
	ImportProfile(PapyrusUtil.ClampInt(AnimProfile, 1, 5))

	; Init Thread Hooks
	if !HooksInit
		InitThreadHooks()
	endIf
endFunction

function InitThreadHooks()
	HookCount = 0
	ThreadHooks = new sslThreadHook[64]
	HooksInit = true
endFunction

int function RegisterThreadHook(sslThreadHook Hook)
	if !Hook
		Log("RegisterThreadHook("+Hook+") - INVALID HOOK")
		return -1
	elseIf !HooksInit
		InitThreadHooks()
	elseIf HookCount >= 64
		Log("RegisterThreadHook("+Hook+") - FAILED TO REGISTER, AT CAPACITY")
		return -1
	endIf

	; Find current index
	int idx = ThreadHooks.Find(Hook)

	; Add new hook
	if idx == -1
		idx = ThreadHooks.Find(none)
		ThreadHooks[idx] = Hook
	endIf

	; Update counter if higher than current saved count
	if (idx + 1) > HookCount
		HookCount = (idx + 1)
	endIf 

	Log("RegisterThreadHook("+Hook+") - Registered hook at ["+idx+"/"+HookCount+"]")

	; TODO: Should probably add better error handling incase count ever exceeds 64, but very unlikely.

	return ThreadHooks.Find(Hook)
endFunction

sslThreadHook[] function GetThreadHooks()
	return ThreadHooks
endFunction
int function GetThreadHookCount()
	return HookCount
endFunction

function Setup()
	parent.Setup()
	SetDefaults()
endFunction

function SetDefaults()
	DebugMode = false

	; Booleans
	RestrictAggressive = true
	; AllowCreatures     = false
	NPCSaveVoice       = false
	UseStrapons        = true
	RestrictStrapons   = false
	RedressVictim      = true
	RagdollEnd         = false
	UseMaleNudeSuit    = false
	UseFemaleNudeSuit  = false
	UndressAnimation   = false
	UseLipSync         = false
	UseExpressions     = false
	RefreshExpressions = true
	ScaleActors        = false
	UseCum             = true
	AllowFFCum         = false
	DisablePlayer      = false
	AutoTFC            = false
	AutoAdvance        = true
	ForeplayStage      = false
	OrgasmEffects      = false
	RaceAdjustments    = true
	BedRemoveStanding  = true
	UseCreatureGender  = false
	LimitedStrip       = false
	RestrictSameSex    = false
	RestrictGenderTag  = true
	SeparateOrgasms    = false
	RemoveHeelEffect   = HasHDTHeels
	AdjustTargetStage  = false
	ShowInMap          = false
	DisableTeleport    = true
	SeedNPCStats       = true
	DisableScale       = true ; TMP: enabled by default for testing
	FixVictimPos       = false
	LipsFixedValue     = true

	; Integers
	AnimProfile        = 1
	AskBed             = 1
	NPCBed             = 0
	OpenMouthSize      = 80
	UseFade            = 0

	Backwards          = 54 ; Right Shift
	AdjustStage        = 157; Right Ctrl
	AdvanceAnimation   = 57 ; Space
	ChangeAnimation    = 24 ; O
	ChangePositions    = 13 ; =
	AdjustChange       = 37 ; K
	AdjustForward      = 38 ; L
	AdjustSideways     = 40 ; '
	AdjustUpward       = 39 ; ;
	RealignActors      = 26 ; [
	MoveScene          = 27 ; ]
	RestoreOffsets     = 12 ; -
	RotateScene        = 22 ; U
	ToggleFreeCamera   = 81 ; NUM 3
	EndAnimation       = 207; End
	TargetActor        = 49 ; N
	AdjustSchlong      = 46 ; C
	LipsSoundTime      = 0  ; Don't Cut
	LipsPhoneme        = 1  ; BigAah
	LipsMinValue       = 20
	LipsMaxValue       = 50


	; Floats
	CumTimer           = 120.0
	ShakeStrength      = 0.7
	AutoSUCSM          = 5.0
	MaleVoiceDelay     = 5.0
	FemaleVoiceDelay   = 4.0
	ExpressionDelay    = 2.0
	VoiceVolume        = 1.0
	SFXDelay           = 3.0
	SFXVolume          = 1.0
	LeadInCoolDown     = 0.0
	LipsMoveTime       = 0.2

	; Boolean strip arrays
	StripMale = new bool[33]
	StripMale[0] = true
	StripMale[1] = true
	StripMale[2] = true
	StripMale[3] = true
	StripMale[7] = true
	StripMale[8] = true
	StripMale[9] = true
	StripMale[4] = true
	StripMale[11] = true
	StripMale[15] = true
	StripMale[16] = true
	StripMale[17] = true
	StripMale[19] = true
	StripMale[23] = true
	StripMale[24] = true
	StripMale[26] = true
	StripMale[27] = true
	StripMale[28] = true
	StripMale[29] = true
	StripMale[32] = true

	StripFemale = new bool[33]
	StripFemale[0] = true
	StripFemale[1] = true
	StripFemale[2] = true
	StripFemale[3] = true
	StripFemale[4] = true
	StripFemale[7] = true
	StripFemale[8] = true
	StripFemale[9] = true
	StripFemale[11] = true
	StripFemale[15] = true
	StripFemale[16] = true
	StripFemale[17] = true
	StripFemale[19] = true
	StripFemale[23] = true
	StripFemale[24] = true
	StripFemale[26] = true
	StripFemale[27] = true
	StripFemale[28] = true
	StripFemale[29] = true
	StripFemale[32] = true

	StripLeadInFemale = new bool[33]
	StripLeadInFemale[0] = true
	StripLeadInFemale[2] = true
	StripLeadInFemale[9] = true
	StripLeadInFemale[14] = true
	StripLeadInFemale[32] = true

	StripLeadInMale = new bool[33]
	StripLeadInMale[0] = true
	StripLeadInMale[2] = true
	StripLeadInMale[8] = true
	StripLeadInMale[9] = true
	; StripLeadInMale[14] = true
	StripLeadInMale[19] = true
	StripLeadInMale[22] = true
	StripLeadInMale[32] = true

	StripVictim = new bool[33]
	StripVictim[1] = true
	StripVictim[2] = true
	StripVictim[4] = true
	StripVictim[9] = true
	StripVictim[11] = true
	StripVictim[16] = true
	StripVictim[24] = true
	StripVictim[26] = true
	StripVictim[28] = true
	StripVictim[32] = true

	StripAggressor = new bool[33]
	StripAggressor[2] = true
	StripAggressor[4] = true
	StripAggressor[9] = true
	StripAggressor[16] = true
	StripAggressor[24] = true
	StripAggressor[26] = true

	; Float timer arrays
	StageTimer = new float[5]
	StageTimer[0] = 30.0
	StageTimer[1] = 20.0
	StageTimer[2] = 15.0
	StageTimer[3] = 15.0
	StageTimer[4] = 9.0

	StageTimerLeadIn = new float[5]
	StageTimerLeadIn[0] = 10.0
	StageTimerLeadIn[1] = 10.0
	StageTimerLeadIn[2] = 10.0
	StageTimerLeadIn[3] = 8.0
	StageTimerLeadIn[4] = 8.0

	StageTimerAggr = new float[5]
	StageTimerAggr[0] = 20.0
	StageTimerAggr[1] = 15.0
	StageTimerAggr[2] = 10.0
	StageTimerAggr[3] = 10.0
	StageTimerAggr[4] = 4.0

	OpenMouthMale = new float[17]
	OpenMouthMale[1] = 0.8
	OpenMouthMale[16] = 16.0

	OpenMouthFemale = new float[17]
	OpenMouthFemale[1] = 1.0
	OpenMouthFemale[16] = 16.0

	BedOffset = new float[4]
	BedOffset[0] = 0.0
	BedOffset[2] = 37.0

	; Valid actor types refrence
	;/ ActorTypes = new int[3]
	ActorTypes[0] = 43 ; kNPC
	ActorTypes[1] = 44 ; kLeveledCharacter
	ActorTypes[2] = 62 ; kCharacter /;

	; Reload config
	Reload()

	; Reset data
	LoadStrapons()

	if !HotkeyUp || HotkeyUp.Length != 3 || HotkeyUp.Find(none) != -1
		HotkeyUp = new Sound[3]
		hotkeyUp[0] = Game.GetFormFromFile(0x8AAF0, "SexLab.esm") as Sound
		hotkeyUp[1] = Game.GetFormFromFile(0x8AAF1, "SexLab.esm") as Sound
		hotkeyUp[2] = Game.GetFormFromFile(0x8AAF2, "SexLab.esm") as Sound
	endIf
	if !HotkeyDown || HotkeyDown.Length != 3 || HotkeyDown.Find(none) != -1
		HotkeyDown = new Sound[3]
		hotkeyDown[0] = Game.GetFormFromFile(0x8AAF3, "SexLab.esm") as Sound
		hotkeyDown[1] = Game.GetFormFromFile(0x8AAF4, "SexLab.esm") as Sound
		hotkeyDown[2] = Game.GetFormFromFile(0x8AAF5, "SexLab.esm") as Sound
	endIf

	; Rest some player configurations
	if PlayerRef && PlayerRef != none
		Stats.SetSkill(PlayerRef, "Sexuality", 75)
		VoiceSlots.ForgetVoice(PlayerRef)
	endIf
endFunction

; ------------------------------------------------------- ;
; --- Export/Import to JSON                           --- ;
; ------------------------------------------------------- ;

string File
function ExportSettings()
	File = "../SexLab/SexlabConfig.json"

	; Set label of export
	JsonUtil.SetStringValue(File, "ExportLabel", PlayerRef.GetLeveledActorBase().GetName()+" - "+Utility.GetCurrentRealTime() as int)

	; Booleans
	ExportBool("RestrictAggressive", RestrictAggressive)
	ExportBool("AllowCreatures", AllowCreatures)
	ExportBool("NPCSaveVoice", NPCSaveVoice)
	ExportBool("UseStrapons", UseStrapons)
	ExportBool("RestrictStrapons", RestrictStrapons)
	ExportBool("RedressVictim", RedressVictim)
	ExportBool("RagdollEnd", RagdollEnd)
	ExportBool("UseMaleNudeSuit", UseMaleNudeSuit)
	ExportBool("UseFemaleNudeSuit", UseFemaleNudeSuit)
	ExportBool("UndressAnimation", UndressAnimation)
	ExportBool("UseLipSync", UseLipSync)
	ExportBool("UseExpressions", UseExpressions)
	ExportBool("RefreshExpressions", RefreshExpressions)
	ExportBool("ScaleActors", ScaleActors)
	ExportBool("UseCum", UseCum)
	ExportBool("AllowFFCum", AllowFFCum)
	ExportBool("DisablePlayer", DisablePlayer)
	ExportBool("AutoTFC", AutoTFC)
	ExportBool("AutoAdvance", AutoAdvance)
	ExportBool("ForeplayStage", ForeplayStage)
	ExportBool("OrgasmEffects", OrgasmEffects)
	ExportBool("RaceAdjustments", RaceAdjustments)
	ExportBool("BedRemoveStanding", BedRemoveStanding)
	ExportBool("UseCreatureGender", UseCreatureGender)
	ExportBool("LimitedStrip", LimitedStrip)
	ExportBool("RestrictSameSex", RestrictSameSex)
	ExportBool("RestrictGenderTag", RestrictGenderTag)
	ExportBool("SeparateOrgasms", SeparateOrgasms)
	ExportBool("RemoveHeelEffect", RemoveHeelEffect)
	ExportBool("AdjustTargetStage", AdjustTargetStage)
	ExportBool("ShowInMap", ShowInMap)
	ExportBool("DisableTeleport", DisableTeleport)
	ExportBool("SeedNPCStats", SeedNPCStats)
	ExportBool("DisableScale", DisableScale)
	ExportBool("FixVictimPos", FixVictimPos)
	ExportBool("LipsFixedValue", LipsFixedValue)

	; Integers
	ExportInt("AnimProfile", AnimProfile)
	ExportInt("AskBed", AskBed)
	ExportInt("NPCBed", NPCBed)
	ExportInt("OpenMouthSize", OpenMouthSize)
	ExportInt("UseFade", UseFade)

	ExportInt("Backwards", Backwards)
	ExportInt("AdjustStage", AdjustStage)
	ExportInt("AdvanceAnimation", AdvanceAnimation)
	ExportInt("ChangeAnimation", ChangeAnimation)
	ExportInt("ChangePositions", ChangePositions)
	ExportInt("AdjustChange", AdjustChange)
	ExportInt("AdjustForward", AdjustForward)
	ExportInt("AdjustSideways", AdjustSideways)
	ExportInt("AdjustUpward", AdjustUpward)
	ExportInt("RealignActors", RealignActors)
	ExportInt("MoveScene", MoveScene)
	ExportInt("RestoreOffsets", RestoreOffsets)
	ExportInt("RotateScene", RotateScene)
	ExportInt("EndAnimation", EndAnimation)
	ExportInt("ToggleFreeCamera", ToggleFreeCamera)
	ExportInt("TargetActor", TargetActor)
	ExportInt("AdjustSchlong", AdjustSchlong)
	ExportInt("LipsSoundTime", LipsSoundTime)
	ExportInt("LipsPhoneme", LipsPhoneme)
	ExportInt("LipsMinValue", LipsMinValue)
	ExportInt("LipsMaxValue", LipsMaxValue)

	; Floats
	ExportFloat("CumTimer", CumTimer)
	ExportFloat("ShakeStrength", ShakeStrength)
	ExportFloat("AutoSUCSM", AutoSUCSM)
	ExportFloat("MaleVoiceDelay", MaleVoiceDelay)
	ExportFloat("FemaleVoiceDelay", FemaleVoiceDelay)
	ExportFloat("ExpressionDelay", ExpressionDelay)
	ExportFloat("VoiceVolume", VoiceVolume)
	ExportFloat("SFXDelay", SFXDelay)
	ExportFloat("SFXVolume", SFXVolume)
	ExportFloat("LeadInCoolDown", LeadInCoolDown)
	ExportFloat("LipsMoveTime", LipsMoveTime)

	; Boolean Arrays
	ExportBoolList("StripMale", StripMale, 33)
	ExportBoolList("StripFemale", StripFemale, 33)
	ExportBoolList("StripLeadInFemale", StripLeadInFemale, 33)
	ExportBoolList("StripLeadInMale", StripLeadInMale, 33)
	ExportBoolList("StripVictim", StripVictim, 33)
	ExportBoolList("StripAggressor", StripAggressor, 33)

	; Float Array
	ExportFloatList("StageTimer", StageTimer, 5)
	ExportFloatList("StageTimerLeadIn", StageTimerLeadIn, 5)
	ExportFloatList("StageTimerAggr", StageTimerAggr, 5)
	ExportFloatList("OpenMouthMale", OpenMouthMale, 17)
	ExportFloatList("OpenMouthFemale", OpenMouthFemale, 17)

	; Export object registry
	ExportAnimations()
	ExportCreatures()
	ExportExpressions()
	ExportVoices()

	; Export striplist items
	StorageUtil.FormListRemove(none, "AlwaysStrip", none, true)
	Form[] AlwaysStrip = StorageUtil.FormListToArray(none, "AlwaysStrip")
	int i = AlwaysStrip.Length
	while i
		i -= 1
		if AlwaysStrip[i]
			JsonUtil.FormListAdd(File, "AlwaysStrip", AlwaysStrip[i], false)
		endIf
	endWhile
	
	StorageUtil.IntListRemove(none, "SometimesStrip", 0, true)
	StorageUtil.IntListRemove(none, "SometimesStrip", 100, true)
	Form[] SometimesStrip = StorageUtil.FormListToArray(none, "SometimesStrip")
	int[] SometimesStripVal = StorageUtil.IntListToArray(none, "SometimesStrip")
	i = SometimesStrip.Length
	while i
		i -= 1
		if SometimesStrip[i]
			JsonUtil.FormListAdd(File, "SometimesStrip", SometimesStrip[i], false)
			JsonUtil.IntListAdd(File, "SometimesStripVal", SometimesStripVal[i], false)
		endIf
	endWhile
	
	StorageUtil.FormListRemove(none, "NoStrip", none, true)
	Form[] NoStrip = StorageUtil.FormListToArray(none, "NoStrip")
	i = NoStrip.Length
	while i
		i -= 1
		if NoStrip[i]
			JsonUtil.FormListAdd(File, "NoStrip", NoStrip[i], false)
		endIf
	endWhile

	; Save to JSON file
	JsonUtil.Save(File, true)
endFunction

function ImportSettings()
	File = "../SexLab/SexlabConfig.json"

	; Booleans
	RestrictAggressive = ImportBool("RestrictAggressive", RestrictAggressive)
	AllowCreatures     = ImportBool("AllowCreatures", AllowCreatures)
	NPCSaveVoice       = ImportBool("NPCSaveVoice", NPCSaveVoice)
	UseStrapons        = ImportBool("UseStrapons", UseStrapons)
	RestrictStrapons   = ImportBool("RestrictStrapons", RestrictStrapons)
	RedressVictim      = ImportBool("RedressVictim", RedressVictim)
	RagdollEnd         = ImportBool("RagdollEnd", RagdollEnd)
	UseMaleNudeSuit    = ImportBool("UseMaleNudeSuit", UseMaleNudeSuit)
	UseFemaleNudeSuit  = ImportBool("UseFemaleNudeSuit", UseFemaleNudeSuit)
	UndressAnimation   = ImportBool("UndressAnimation", UndressAnimation)
	UseLipSync         = ImportBool("UseLipSync", UseLipSync)
	UseExpressions     = ImportBool("UseExpressions", UseExpressions)
	RefreshExpressions = ImportBool("RefreshExpressions", RefreshExpressions)
	ScaleActors        = ImportBool("ScaleActors", ScaleActors)
	UseCum             = ImportBool("UseCum", UseCum)
	AllowFFCum         = ImportBool("AllowFFCum", AllowFFCum)
	DisablePlayer      = ImportBool("DisablePlayer", DisablePlayer)
	AutoTFC            = ImportBool("AutoTFC", AutoTFC)
	AutoAdvance        = ImportBool("AutoAdvance", AutoAdvance)
	ForeplayStage      = ImportBool("ForeplayStage", ForeplayStage)
	OrgasmEffects      = ImportBool("OrgasmEffects", OrgasmEffects)
	RaceAdjustments    = ImportBool("RaceAdjustments", RaceAdjustments)
	BedRemoveStanding  = ImportBool("BedRemoveStanding", BedRemoveStanding)
	UseCreatureGender  = ImportBool("UseCreatureGender", UseCreatureGender)
	LimitedStrip       = ImportBool("LimitedStrip", LimitedStrip)
	RestrictSameSex    = ImportBool("RestrictSameSex", RestrictSameSex)
	RestrictGenderTag  = ImportBool("RestrictGenderTag", RestrictGenderTag)
	SeparateOrgasms    = ImportBool("SeparateOrgasms", SeparateOrgasms)
	RemoveHeelEffect   = ImportBool("RemoveHeelEffect", RemoveHeelEffect)
	AdjustTargetStage  = ImportBool("AdjustTargetStage", AdjustTargetStage)
	ShowInMap          = ImportBool("ShowInMap", ShowInMap)
	DisableTeleport    = ImportBool("DisableTeleport", DisableTeleport)
	SeedNPCStats       = ImportBool("SeedNPCStats", SeedNPCStats)
	DisableScale       = ImportBool("DisableScale", DisableScale)
	FixVictimPos       = ImportBool("FixVictimPos", FixVictimPos)
	LipsFixedValue     = ImportBool("LipsFixedValue", LipsFixedValue)

	; Integers
	AnimProfile        = ImportInt("AnimProfile", AnimProfile)
	AskBed             = ImportInt("AskBed", AskBed)
	NPCBed             = ImportInt("NPCBed", NPCBed)
	OpenMouthSize      = ImportInt("OpenMouthSize", OpenMouthSize)
	UseFade            = ImportInt("UseFade", UseFade)

	Backwards          = ImportInt("Backwards", Backwards)
	AdjustStage        = ImportInt("AdjustStage", AdjustStage)
	AdvanceAnimation   = ImportInt("AdvanceAnimation", AdvanceAnimation)
	ChangeAnimation    = ImportInt("ChangeAnimation", ChangeAnimation)
	ChangePositions    = ImportInt("ChangePositions", ChangePositions)
	AdjustChange       = ImportInt("AdjustChange", AdjustChange)
	AdjustForward      = ImportInt("AdjustForward", AdjustForward)
	AdjustSideways     = ImportInt("AdjustSideways", AdjustSideways)
	AdjustUpward       = ImportInt("AdjustUpward", AdjustUpward)
	RealignActors      = ImportInt("RealignActors", RealignActors)
	MoveScene          = ImportInt("MoveScene", MoveScene)
	RestoreOffsets     = ImportInt("RestoreOffsets", RestoreOffsets)
	RotateScene        = ImportInt("RotateScene", RotateScene)
	EndAnimation       = ImportInt("EndAnimation", EndAnimation)
	ToggleFreeCamera   = ImportInt("ToggleFreeCamera", ToggleFreeCamera)
	TargetActor        = ImportInt("TargetActor", TargetActor)
	AdjustSchlong      = ImportInt("AdjustSchlong", AdjustSchlong)
	LipsSoundTime      = ImportInt("LipsSoundTime", LipsSoundTime)
	LipsPhoneme        = ImportInt("LipsPhoneme", LipsPhoneme)
	LipsMinValue       = ImportInt("LipsMinValue", LipsMinValue)
	LipsMaxValue       = ImportInt("LipsMaxValue", LipsMaxValue)

	; Floats
	CumTimer           = ImportFloat("CumTimer", CumTimer)
	ShakeStrength      = ImportFloat("ShakeStrength", ShakeStrength)
	AutoSUCSM          = ImportFloat("AutoSUCSM", AutoSUCSM)
	MaleVoiceDelay     = ImportFloat("MaleVoiceDelay", MaleVoiceDelay)
	FemaleVoiceDelay   = ImportFloat("FemaleVoiceDelay", FemaleVoiceDelay)
	ExpressionDelay    = ImportFloat("ExpressionDelay", ExpressionDelay)
	VoiceVolume        = ImportFloat("VoiceVolume", VoiceVolume)
	SFXDelay           = ImportFloat("SFXDelay", SFXDelay)
	SFXVolume          = ImportFloat("SFXVolume", SFXVolume)
	LeadInCoolDown     = ImportFloat("LeadInCoolDown", LeadInCoolDown)
	LipsMoveTime       = ImportFloat("LipsMoveTime", LipsMoveTime)

	; Boolean Arrays
	StripMale          = ImportBoolList("StripMale", StripMale, 33)
	StripFemale        = ImportBoolList("StripFemale", StripFemale, 33)
	StripLeadInFemale  = ImportBoolList("StripLeadInFemale", StripLeadInFemale, 33)
	StripLeadInMale    = ImportBoolList("StripLeadInMale", StripLeadInMale, 33)
	StripVictim        = ImportBoolList("StripVictim", StripVictim, 33)
	StripAggressor     = ImportBoolList("StripAggressor", StripAggressor, 33)

	; Float Array
	StageTimer         = ImportFloatList("StageTimer", StageTimer, 5)
	StageTimerLeadIn   = ImportFloatList("StageTimerLeadIn", StageTimerLeadIn, 5)
	StageTimerAggr     = ImportFloatList("StageTimerAggr", StageTimerAggr, 5)
	OpenMouthMale      = ImportFloatList("OpenMouthMale", OpenMouthMale, 17)
	OpenMouthFemale    = ImportFloatList("OpenMouthFemale", OpenMouthFemale, 17)

	; Import object registry
	ImportAnimations()
	ImportCreatures()
	ImportExpressions()
	ImportVoices()

	; Import striplist items
	Form[] AlwaysStrip = JsonUtil.FormListToArray(File, "AlwaysStrip")
	int i = AlwaysStrip.Length
	while i
		i -= 1
		if AlwaysStrip[i]
			ActorLib.MakeAlwaysStrip(AlwaysStrip[i])
		endIf
	endWhile
	StorageUtil.FormListRemove(none, "AlwaysStrip", none, true)

	Form[] SometimesStrip = JsonUtil.FormListToArray(File, "SometimesStrip")
	int[] SometimesStripVal = JsonUtil.IntListToArray(File, "SometimesStripVal")
	i = SometimesStrip.Length
	while i
		i -= 1
		if SometimesStrip[i]
			StorageUtil.SetIntValue(SometimesStrip[i], "SometimesStrip", SometimesStripVal[i])
		endIf
	endWhile
	StorageUtil.IntListRemove(none, "SometimesStrip", 0, true)
	StorageUtil.IntListRemove(none, "SometimesStrip", 100, true)

	Form[] NoStrip = JsonUtil.FormListToArray(File, "NoStrip")
	i = NoStrip.Length
	while i
		i -= 1
		if NoStrip[i]
			ActorLib.MakeNoStrip(NoStrip[i])
		endIf
	endWhile
	StorageUtil.FormListRemove(none, "NoStrip", none, true)

	; Reload settings with imported values
	Reload()
endFunction

; Integers
function ExportInt(string Name, int Value)
	JsonUtil.SetIntValue(File, Name, Value)
endFunction
int function ImportInt(string Name, int Value)
	return JsonUtil.GetIntValue(File, Name, Value)
endFunction

; Booleans
function ExportBool(string Name, bool Value)
	JsonUtil.SetIntValue(File, Name, Value as int)
endFunction
bool function ImportBool(string Name, bool Value)
	return JsonUtil.GetIntValue(File, Name, Value as int) as bool
endFunction

; Floats
function ExportFloat(string Name, float Value)
	JsonUtil.SetFloatValue(File, Name, Value)
endFunction
float function ImportFloat(string Name, float Value)
	return JsonUtil.GetFloatValue(File, Name, Value)
endFunction

; Float Arrays
function ExportFloatList(string Name, float[] Values, int len)
	JsonUtil.FloatListClear(File, Name)
	JsonUtil.FloatListCopy(File, Name, Values)
endFunction
float[] function ImportFloatList(string Name, float[] Values, int len)
	if JsonUtil.FloatListCount(File, Name) == len
		if Values.Length != len
			Values = Utility.CreateFloatArray(len)
		endIf
		int i
		while i < len
			Values[i] = JsonUtil.FloatListGet(File, Name, i)
			i += 1
		endWhile
	endIf
	return Values
endFunction

; Boolean Arrays
function ExportBoolList(string Name, bool[] Values, int len)
	JsonUtil.IntListClear(File, Name)
	int i
	while i < len
		JsonUtil.IntListAdd(File, Name, Values[i] as int)
		i += 1
	endWhile
endFunction
bool[] function ImportBoolList(string Name, bool[] Values, int len)
	if JsonUtil.IntListCount(File, Name) == len
		if Values.Length != len
			Values = Utility.CreateBoolArray(len)
		endIf
		int i
		while i < len
			Values[i] = JsonUtil.IntListGet(File, Name, i) as bool
			i += 1
		endWhile
	endIf
	return Values
endFunction

; Animations
function ExportAnimations()
	JsonUtil.StringListClear(File, "Animations")
	int i = AnimSlots.Slotted
	while i
		i -= 1
		sslBaseAnimation Slot = AnimSlots.GetBySlot(i)
		JsonUtil.StringListAdd(File, "Animations", sslUtility.MakeArgs(",", Slot.Registry, Slot.Enabled as int, Slot.HasTag("LeadIn") as int, Slot.HasTag("Aggressive") as int))
	endWhile
endfunction
function ImportAnimations()
	int i = JsonUtil.StringListCount(File, "Animations")
	while i
		i -= 1
		; Registrar, Enabled, Foreplay, Aggressive
		string[] args = PapyrusUtil.StringSplit(JsonUtil.StringListGet(File, "Animations", i))
		if args.Length == 4 && AnimSlots.FindByRegistrar(args[0]) != -1
			sslBaseAnimation Slot = AnimSlots.GetbyRegistrar(args[0])
			Slot.Enabled = (args[1] as int) as bool
			Slot.AddTagConditional("LeadIn", (args[2] as int) as bool)
			Slot.AddTagConditional("Aggressive", (args[3] as int) as bool)
		endIf
	endWhile
endFunction

; Creatures
function ExportCreatures()
	JsonUtil.StringListClear(File, "Creatures")
	int i = CreatureSlots.Slotted
	while i
		i -= 1
		sslBaseAnimation Slot = CreatureSlots.GetBySlot(i)
		JsonUtil.StringListAdd(File, "Creatures", sslUtility.MakeArgs(",", Slot.Registry, Slot.Enabled as int))
	endWhile
endFunction
function ImportCreatures()
	int i = JsonUtil.StringListCount(File, "Creatures")
	while i
		i -= 1
		; Registrar, Enabled
		string[] args = PapyrusUtil.StringSplit(JsonUtil.StringListGet(File, "Creatures", i))
		if args.Length == 2 && CreatureSlots.FindByRegistrar(args[0]) != -1
			CreatureSlots.GetbyRegistrar(args[0]).Enabled = (args[1] as int) as bool
		endIf
	endWhile
endFunction

; Expressions
function ExportExpressions()
	int i = ExpressionSlots.Slotted
	while i
		i -= 1
		ExpressionSlots.GetBySlot(i).ExportJson()
	endWhile
endfunction
function ImportExpressions()
	int i = ExpressionSlots.Slotted
	while i
		i -= 1
		ExpressionSlots.GetBySlot(i).ImportJson()
	endWhile
endFunction

; Voices
function ExportVoices()
	JsonUtil.StringListClear(File, "Voices")
	int i = VoiceSlots.Slotted
	while i
		i -= 1
		sslBaseVoice Slot = VoiceSlots.GetBySlot(i)
		JsonUtil.StringListAdd(File, "Voices", sslUtility.MakeArgs(",", Slot.Registry, Slot.Enabled as int))
	endWhile
	; Player voice
	JsonUtil.SetStringValue(File, "PlayerVoice", VoiceSlots.GetSavedName(PlayerRef))
endfunction
function ImportVoices()
	int i = JsonUtil.StringListCount(File, "Voices")
	while i
		i -= 1
		; Registrar, Enabled
		string[] args = PapyrusUtil.StringSplit(JsonUtil.StringListGet(File, "Voices", i))
		if args.Length == 2 && VoiceSlots.FindByRegistrar(args[0]) != -1
			VoiceSlots.GetbyRegistrar(args[0]).Enabled = (args[1] as int) as bool
		endIf
	endWhile
	; Player voice
	VoiceSlots.ForgetVoice(PlayerRef)
	VoiceSlots.SaveVoice(PlayerRef, VoiceSlots.GetByName(JsonUtil.GetStringValue(File, "PlayerVoice", "$SSL_Random")))
endFunction

; ------------------------------------------------------- ;
; --- Misc                                            --- ;
; ------------------------------------------------------- ;

; int[] property ActorTypes auto hidden
function StoreActor(Form FormRef) global
	if FormRef
		StorageUtil.FormListAdd(none, "SexLab.ActorStorage", FormRef, false)
	endIf
endFunction

ImageSpaceModifier FadeEffect
VisualEffect ForceVFX
VisualEffect ForceBlackVFX
VisualEffect ForceBlurVFX
ImageSpaceModifier FadeToBlackHoldImod
ImageSpaceModifier FadeToBlurHoldImod
function RemoveFade(bool forceTest = false)
	if !forceTest && UseFade < 1
		return
	endIf
	if FadeEffect && FadeEffect != none
		bool Black = UseFade % 2 != 0
		If UseFade < 3
			if forceTest
				Utility.WaitMenuMode(5.0)
				if ForceVFX
					ForceVFX.Stop(PlayerRef)
				endIf
				FadeEffect.Remove()
			else
				if ForceVFX
					ForceVFX.Stop(PlayerRef)
				endIf
				ImageSpaceModifier.RemoveCrossFade()
			endIf
		else
			Game.FadeOutGame(false, Black, 0.5, 1.5)
		endIf
		FadeEffect = none
	endIf
endFunction

function ApplyFade(bool forceTest = false)
	if !forceTest && UseFade < 1
		return
	endIf
	if FadeEffect && FadeEffect != none
		FadeEffect.Remove()
	endIf
	FadeEffect = none
	bool Black
	if UseFade % 2 != 0
		if FadeToBlackHoldImod && FadeToBlackHoldImod != none
			FadeEffect = FadeToBlackHoldImod
			Black = True
		endIf
	else
		if FadeToBlurHoldImod && FadeToBlurHoldImod != none
			FadeEffect = FadeToBlurHoldImod
			Black = False
		endIf
	endIf
	if FadeEffect && FadeEffect != none
		If UseFade < 3
			if forceTest
				FadeEffect.Apply()
			else
				FadeEffect.ApplyCrossFade()
			endIf
			if Black && ForceBlackVFX
				ForceVFX = ForceBlackVFX
			elseIf !Black && ForceBlurVFX
				ForceVFX = ForceBlurVFX
			endIf
			if ForceVFX
				ForceVFX.Play(PlayerRef)
			endIf
		else
			Game.FadeOutGame(true, Black, 0.5, 3.0)
		endIf
	endIf
endFunction

event OnInit()
	parent.OnInit()
	SetDefaults()
endEvent

function ReloadData()
	; ActorTypeNPC =            Game.GetForm(0x13794)
	; AnimatingFaction =        Game.GetFormFromFile(0xE50F, "SexLab.esm")
	; AudioSFX =                Game.GetFormFromFile(0x61428, "SexLab.esm")
	; AudioVoice =              Game.GetFormFromFile(0x61429, "SexLab.esm")
	; BaseMarker =              Game.GetFormFromFile(0x45A93 "SexLab.esm")
	; BedRollsList =            Game.GetFormFromFile(0x6198C, "SexLab.esm")
	; BedsList =                Game.GetFormFromFile(0x181B1, "SexLab.esm")
	; CalypsStrapon =           Game.GetFormFromFile(0x1A22A, "SexLab.esm")
	; CheckFNIS =               Game.GetFormFromFile(0x70C38, "SexLab.esm")
	; CheckPapyrusUtil =        Game.GetFormFromFile(0x70C3B, "SexLab.esm")
	; CheckSKSE =               Game.GetFormFromFile(0x70C39, "SexLab.esm")
	; CheckSkyrim =             Game.GetFormFromFile(0x70C3A, "SexLab.esm")
	; CheckSkyUI =              Game.GetFormFromFile(0x70C3C, "SexLab.esm")
	; CleanSystemFinish =       Game.GetFormFromFile(0x6CB9E, "SexLab.esm")
	; CumAnalKeyword =          Game.GetFormFromFile(0x, "SexLab.esm")
	; CumAnalSpell =            Game.GetFormFromFile(0x, "SexLab.esm")
	; CumOralAnalSpell =        Game.GetFormFromFile(0x, "SexLab.esm")
	; CumOralKeyword =          Game.GetFormFromFile(0x, "SexLab.esm")
	; CumOralSpell =            Game.GetFormFromFile(0x, "SexLab.esm")
	; CumVaginalAnalSpell =     Game.GetFormFromFile(0x, "SexLab.esm")
	; CumVaginalKeyword =       Game.GetFormFromFile(0x, "SexLab.esm")
	; CumVaginalOralAnalSpell = Game.GetFormFromFile(0x, "SexLab.esm")
	; CumVaginalOralSpell =     Game.GetFormFromFile(0x, "SexLab.esm")
	; CumVaginalSpell =         Game.GetFormFromFile(0x, "SexLab.esm")
	; DoNothing =               Game.GetFormFromFile(0x, "SexLab.esm")
	; DummyWeapon =             Game.GetFormFromFile(0x, "SexLab.esm")
	; ForbiddenFaction =        Game.GetFormFromFile(0x, "SexLab.esm")
	; GenderFaction =           Game.GetFormFromFile(0x, "SexLab.esm")
	; LipSync =                 Game.GetFormFromFile(0x, "SexLab.esm")
	; LocationMarker =          Game.GetFormFromFile(0x, "SexLab.esm")
	; NudeSuit =                Game.GetFormFromFile(0x, "SexLab.esm")
	; OrgasmFX =                Game.GetFormFromFile(0x, "SexLab.esm")
	; SexLabVoiceF =            Game.GetFormFromFile(0x, "SexLab.esm")
	; SexLabVoiceM =            Game.GetFormFromFile(0x, "SexLab.esm")
	; SexMixedFX =              Game.GetFormFromFile(0x, "SexLab.esm")
	; SquishingFX =             Game.GetFormFromFile(0x, "SexLab.esm")
	; SuckingFX =               Game.GetFormFromFile(0x, "SexLab.esm")
	; UseBed =                  Game.GetFormFromFile(0x, "SexLab.esm")
	; VoicesPlayer =            Game.GetFormFromFile(0x, "SexLab.esm")
endFunction

; ------------------------------------------------------- ;
; --- Pre 1.50 Config Accessors                       --- ;
; ------------------------------------------------------- ;

bool property bRestrictAggressive hidden
	bool function get()
		return RestrictAggressive
	endFunction
endProperty
bool property bAllowCreatures hidden
	bool function get()
		return AllowCreatures
	endFunction
endProperty
bool property bUseStrapons hidden
	bool function get()
		return UseStrapons
	endFunction
endProperty
bool property bRedressVictim hidden
	bool function get()
		return RedressVictim
	endFunction
endProperty
bool property bRagdollEnd hidden
	bool function get()
		return RagdollEnd
	endFunction
endProperty
bool property bUndressAnimation hidden
	bool function get()
		return UndressAnimation
	endFunction
endProperty
bool property bScaleActors hidden
	bool function get()
		return ScaleActors
	endFunction
endProperty
bool property bUseCum hidden
	bool function get()
		return UseCum
	endFunction
endProperty
bool property bAllowFFCum hidden
	bool function get()
		return AllowFFCum
	endFunction
endProperty
bool property bDisablePlayer hidden
	bool function get()
		return DisablePlayer
	endFunction
endProperty
bool property bAutoTFC hidden
	bool function get()
		return AutoTFC
	endFunction
endProperty
bool property bAutoAdvance hidden
	bool function get()
		return AutoAdvance
	endFunction
endProperty
bool property bForeplayStage hidden
	bool function get()
		return ForeplayStage
	endFunction
endProperty
bool property bOrgasmEffects hidden
	bool function get()
		return OrgasmEffects
	endFunction
endProperty
