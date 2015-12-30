scriptname sslSystemConfig extends sslSystemLibrary

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
			PlayerRef.AddSpell((Game.GetFormFromFile(0x073CC, "SexLab.esm") as Spell))
			PlayerRef.AddSpell((Game.GetFormFromFile(0x5FE9B, "SexLab.esm") as Spell))
		else
			if Debug.TraceUser("SexLabDebug", "SexLab Debug/Development Mode Deactivated")
				Debug.CloseUserLog("SexLabDebug")
			endIf
			MiscUtil.PrintConsole("SexLab Debug/Development Mode Deactivated")
			PlayerRef.RemoveSpell((Game.GetFormFromFile(0x073CC, "SexLab.esm") as Spell))
			PlayerRef.RemoveSpell((Game.GetFormFromFile(0x5FE9B, "SexLab.esm") as Spell))
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
bool property RedressVictim auto hidden
bool property RagdollEnd auto hidden
bool property UseMaleNudeSuit auto hidden
bool property UseFemaleNudeSuit auto hidden
bool property UndressAnimation auto hidden
bool property UseLipSync auto hidden
bool property UseExpressions auto hidden
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
bool property SeparateOrgasms auto hidden
bool property RemoveHeelEffect auto hidden
bool property AdjustTargetStage auto hidden
bool property DisableTeleport auto hidden
bool property SeedNPCStats auto hidden

; Integers
int property AnimProfile auto hidden
int property AskBed auto hidden
int property NPCBed auto hidden

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
float property AutoSUCSM auto hidden
float property MaleVoiceDelay auto hidden
float property FemaleVoiceDelay auto hidden
float property VoiceVolume auto hidden
float property SFXDelay auto hidden
float property SFXVolume auto hidden

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
float[] property BedOffset auto hidden

; Compatibility checks
bool property HasHDTHeels auto hidden
bool property HasNiOverride auto hidden
bool property HasFrostfall auto hidden
bool property HasSchlongs auto hidden

FormList property FrostExceptions auto hidden
MagicEffect HDTHeelEffect

; Data
Actor property TargetRef auto hidden
Actor CrosshairRef

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

;/ function SetActorNoScale(Actor ActorRef, bool NoScale = true)
	if !ActorRef
		Log("Invalid Actor", "SetActorNoScale("+ActorRef+", "+NoScale+")")
	elseIf NoScale
		StorageUtil.FormListAdd(self, "NoScale", ActorRef.GetLeveledActorBase(), false)
	else
		StorageUtil.FormListRemove(self, "NoScale", ActorRef.GetLeveledActorBase(), true)
	endIf
endFunction

function SetRaceNoScale(Race RaceRef, bool NoScale = true)
	if !RaceRef
		Log("Invalid Race", "SetRaceNoScale("+RaceRef+", "+NoScale+")")
	elseIf NoScale
		StorageUtil.FormListAdd(self, "NoScale", RaceRef, false)
	else
		StorageUtil.FormListRemove(self, "NoScale", RaceRef, true)
	endIf
endFunction

bool function ActorIsNoScale(Actor ActorRef)
	if ActorRef
		ActorBase BaseRef = ActorRef.GetLeveledActorBase()
		return StorageUtil.FormListHas(self, "NoScale", BaseRef) || StorageUtil.FormListHas(self, "NoScale", BaseRef.GetRace())
	endIf
	return false
endFunction /;

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
			ActorRef.UnequipItem(Strapons[i], false, true)
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
	if CrosshairRef
		TargetRef = CrosshairRef
		SelectedSpell.Cast(TargetRef, TargetRef)
		Debug.Notification("SexLab Target Selected: "+TargetRef.GetLeveledActorBase().GetName())
		; Give them stats if they need it
		Stats.SeedActor(TargetRef)
		; Attempt to grab control of their animation?
		sslThreadController TargetThread = ThreadSlots.GetActorController(TargetRef)
		if TargetThread && !TargetThread.HasPlayer && !ThreadSlots.GetActorController(PlayerRef) && TakeThreadControl.Show()
			GetThreadControl(TargetThread)
		endIf
	endif
endFunction

function GetThreadControl(sslThreadController TargetThread)
	if Control || !(TargetThread.GetState() == "Animating" || TargetThread.GetState() == "Advancing")
		Log("Failed to control thread "+TargetThread)
		return ; Control not available
	endIf
	; Set active controlled thread
	Control = TargetThread
	; Lock players movement
	PlayerRef.StopCombat()
	if PlayerRef.IsWeaponDrawn()
		PlayerRef.SheatheWeapon()
	endIf
	PlayerRef.SetFactionRank(AnimatingFaction, 1)
	ActorUtil.AddPackageOverride(PlayerRef, DoNothing, 100, 1)
	PlayerRef.EvaluatePackage()
	Game.SetPlayerAIDriven()
	; Give player control
	Control.AutoAdvance = false
	Control.EnableHotkeys(true)
	Log("Player has taken control of thread "+Control)
endFunction

function DisableThreadControl(sslThreadController TargetThread)
	if Control && Control == TargetThread
		; Release players thread control
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
	if !HasHDTHeels || !HDTHeelEffect || !ActorRef || !ActorRef.GetWornForm(Armor.GetMaskForSlot(37))
		return none
	endIf
	int i = ActorRef.GetSpellCount()
	while i
		i -= 1
		Spell SpellRef = ActorRef.GetNthSpell(i)
		if SpellRef && StringUtil.Find(SpellRef.GetName(), "High Heel") != -1
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
		return (StringUtil.SubString(Debug.GetVersionNumber(), 0, 3) as float) >= 1.9

	elseIf CheckSystem == "SKSE"
		return SKSE.GetScriptVersionRelease() >= 48

	elseIf CheckSystem == "SkyUI"
		return Quest.GetQuest("SKI_ConfigManagerInstance") != none

	elseIf CheckSystem == "SexLabUtil"
		return SexLabUtil.GetPluginVersion() >= 16100

	elseIf CheckSystem == "PapyrusUtil"
		return PapyrusUtil.GetVersion() >= 32

	elseIf CheckSystem == "FNIS"
		return FNIS.VersionCompare(5, 4, 2) >= 0

	elseIf CheckSystem == "FNISGenerated"
		return FNIS.IsGenerated()

	elseIf CheckSystem == "FNISCreaturePack"
		return FNIS.VersionCompare(5, 1, 0, true) >= 0

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
		CheckSkyrim.Show()
		return false
	; Check SKSE install
	elseIf !CheckSystemPart("SKSE")
		CheckSKSE.Show(1.73)
		return false
	; Check SkyUI install - depends on passing SKSE check passing
	elseIf !CheckSystemPart("SkyUI")
		CheckSkyUI.Show(5.0)
		return false
	; Check SexLabUtil install - this should never happen if they have properly updated
	elseIf !CheckSystemPart("SexLabUtil")
		CheckSexLabUtil.Show()
		return false
	; Check PapyrusUtil install - depends on passing SKSE check passing
	elseIf !CheckSystemPart("PapyrusUtil")
		CheckPapyrusUtil.Show(3.2)
		return false
	; Check FNIS generation - soft fail
	; elseIf CheckSystemPart("FNISSexLabFramework")
		; CheckFNIS.Show()
	endIf
	; Return result
	return true
endFunction

function Reload()
	DebugMode = true
	if DebugMode
		Debug.OpenUserLog("SexLabDebug")
		Debug.TraceUser("SexLabDebug", "Config Reloading...")
	endIf

	LoadLibs(false)
	SexLab = SexLabUtil.GetAPI()

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

	; Mod compatability checks
	; - HDT/NiO High Heels
	HasNiOverride = SKSE.GetPluginVersion("NiOverride") >= 6 && NiOverride.GetScriptVersion() >= 6
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

	; Clean valid actors list
	StorageUtil.FormListRemove(self, "ValidActors", PlayerRef, true)
	StorageUtil.FormListRemove(self, "ValidActors", none, true)
	if Game.GetModByName("Dawnguard.esm") != 255
		StorageUtil.FormListAdd(self, "ValidActors", Game.GetFormFromFile(0x2B6C, "Dawnguard.esm"), false)
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
endFunction

function Setup()
	parent.Setup()
	SetDefaults()
endFunction

function SetDefaults()
	DebugMode = true

	; Booleans
	RestrictAggressive = true
	; AllowCreatures     = false
	NPCSaveVoice       = false
	UseStrapons        = true
	RedressVictim      = true
	RagdollEnd         = false
	UseMaleNudeSuit    = false
	UseFemaleNudeSuit  = false
	UndressAnimation   = false
	UseLipSync         = false
	UseExpressions     = false
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
	SeparateOrgasms    = false
	RemoveHeelEffect   = HasHDTHeels
	AdjustTargetStage  = false
	DisableTeleport    = true
	SeedNPCStats       = true
	
	; Integers
	AnimProfile        = 1
	AskBed             = 1
	NPCBed             = 0

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

	; Floats
	CumTimer           = 120.0
	AutoSUCSM          = 5.0
	MaleVoiceDelay     = 5.0
	FemaleVoiceDelay   = 4.0
	VoiceVolume        = 1.0
	SFXDelay           = 3.0
	SFXVolume          = 1.0

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

	BedOffset = new float[4]
	BedOffset[0] = 30.0
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
	Stats.SetSkill(PlayerRef, "Sexuality", 75)
	VoiceSlots.ForgetVoice(PlayerRef)
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
	ExportBool("RedressVictim", RedressVictim)
	ExportBool("RagdollEnd", RagdollEnd)
	ExportBool("UseMaleNudeSuit", UseMaleNudeSuit)
	ExportBool("UseFemaleNudeSuit", UseFemaleNudeSuit)
	ExportBool("UndressAnimation", UndressAnimation)
	ExportBool("UseLipSync", UseLipSync)
	ExportBool("UseExpressions", UseExpressions)
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
	ExportBool("SeparateOrgasms", SeparateOrgasms)
	ExportBool("RemoveHeelEffect", RemoveHeelEffect)
	ExportBool("AdjustTargetStage", AdjustTargetStage)
	ExportBool("DisableTeleport", DisableTeleport)
	ExportBool("SeedNPCStats", SeedNPCStats)

	; Integers
	ExportInt("AnimProfile", AnimProfile)
	ExportInt("AskBed", AskBed)
	ExportInt("NPCBed", NPCBed)

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

	; Floats
	ExportFloat("CumTimer", CumTimer)
	ExportFloat("AutoSUCSM", AutoSUCSM)
	ExportFloat("MaleVoiceDelay", MaleVoiceDelay)
	ExportFloat("FemaleVoiceDelay", FemaleVoiceDelay)
	ExportFloat("VoiceVolume", VoiceVolume)
	ExportFloat("SFXDelay", SFXDelay)
	ExportFloat("SFXVolume", SFXVolume)

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

	; Export object registry
	ExportAnimations()
	ExportCreatures()
	ExportExpressions()
	ExportVoices()

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
	RedressVictim      = ImportBool("RedressVictim", RedressVictim)
	RagdollEnd         = ImportBool("RagdollEnd", RagdollEnd)
	UseMaleNudeSuit    = ImportBool("UseMaleNudeSuit", UseMaleNudeSuit)
	UseFemaleNudeSuit  = ImportBool("UseFemaleNudeSuit", UseFemaleNudeSuit)
	UndressAnimation   = ImportBool("UndressAnimation", UndressAnimation)
	UseLipSync         = ImportBool("UseLipSync", UseLipSync)
	UseExpressions     = ImportBool("UseExpressions", UseExpressions)
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
	SeparateOrgasms    = ImportBool("SeparateOrgasms", SeparateOrgasms)
	RemoveHeelEffect   = ImportBool("RemoveHeelEffect", RemoveHeelEffect)
	AdjustTargetStage  = ImportBool("AdjustTargetStage", AdjustTargetStage)
	DisableTeleport    = ImportBool("DisableTeleport", DisableTeleport)
	SeedNPCStats       = ImportBool("SeedNPCStats", SeedNPCStats)

	; Integers
	AnimProfile        = ImportInt("AnimProfile", AnimProfile)
	AskBed             = ImportInt("AskBed", AskBed)
	NPCBed             = ImportInt("NPCBed", NPCBed)

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

	; Floats
	CumTimer           = ImportFloat("CumTimer", CumTimer)
	AutoSUCSM          = ImportFloat("AutoSUCSM", AutoSUCSM)
	MaleVoiceDelay     = ImportFloat("MaleVoiceDelay", MaleVoiceDelay)
	FemaleVoiceDelay   = ImportFloat("FemaleVoiceDelay", FemaleVoiceDelay)
	VoiceVolume        = ImportFloat("VoiceVolume", VoiceVolume)
	SFXDelay           = ImportFloat("SFXDelay", SFXDelay)
	SFXVolume          = ImportFloat("SFXVolume", SFXVolume)

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

	; Export object registry
	ImportAnimations()
	ImportCreatures()
	ImportExpressions()
	ImportVoices()

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