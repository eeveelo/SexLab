scriptname sslSystemConfig extends sslSystemLibrary

; ------------------------------------------------------- ;
; --- System Resources                                --- ;
; ------------------------------------------------------- ;

SexLabFramework property SexLab auto

bool bDebugMode
bool property DebugMode hidden
	bool function get()
		return bDebugMode
	endFunction
endProperty

bool property Enabled hidden
	bool function get()
		return SexLab.Enabled
	endFunction
endProperty

Faction property AnimatingFaction auto
Faction property GenderFaction auto
Faction property ForbiddenFaction auto
Weapon property DummyWeapon auto
Armor property NudeSuit auto
Armor property CalypsStrapon auto
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

Sound property OrgasmFX auto
Sound property SquishingFX auto
Sound property SuckingFX auto
Sound property SexMixedFX auto

Static property LocationMarker auto
FormList property BedsList auto
FormList property BedRollsList auto
Message property UseBed auto
Message property CleanSystemFinish auto
Message property CheckSKSE auto
Message property CheckFNIS auto
Message property CheckSkyrim auto
Message property CheckPapyrusUtil auto
Message property CheckSkyUI auto

Topic property LipSync auto
VoiceType property SexLabVoiceM auto
VoiceType property SexLabVoiceF auto
FormList property VoicesPlayer auto
SoundCategory property AudioSFX auto
SoundCategory property AudioVoice auto

; ------------------------------------------------------- ;
; --- Config Properties                               --- ;
; ------------------------------------------------------- ;

bool property bDisablePlayer auto hidden
float property fMaleVoiceDelay auto hidden
float property fFemaleVoiceDelay auto hidden
float property fVoiceVolume auto hidden
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
bool property bUseLipSync auto hidden
bool property bUseExpressions auto hidden

bool[] property bStripMale auto hidden
bool[] property bStripFemale auto hidden
bool[] property bStripLeadInFemale auto hidden
bool[] property bStripLeadInMale auto hidden
bool[] property bStripVictim auto hidden
bool[] property bStripAggressor auto hidden

bool property bRestrictAggressive auto hidden
bool property bAllowCreatures auto hidden

bool property bNPCSaveVoice auto hidden

int property kBackwards auto hidden ; Right Shift
int property kAdjustStage auto hidden; Right Ctrl

int property kBackwardsAlt auto hidden ; Left Shift
int property kAdjustStageAlt auto hidden; Left Ctrl

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
int property kToggleFreeCamera auto hidden ; NUM 3
int property kEndAnimation auto hidden ; End
int property kTargetActor auto hidden ; N

bool property bAutoTFC auto hidden
float property fAutoSUCSM auto hidden

float property fSFXDelay auto hidden
float property fSFXVolume auto hidden
bool property bAutoAdvance auto hidden
bool property bForeplayStage auto hidden
bool property bOrgasmEffects auto hidden
bool property bRaceAdjustments auto hidden
string property sNPCBed auto hidden
float[] property fStageTimer auto hidden
float[] property fStageTimerLeadIn auto hidden
float[] property fStageTimerAggr auto hidden

int property AnimProfile auto hidden

Actor property TargetRef auto hidden
Actor CrosshairRef

; ------------------------------------------------------- ;
; --- Config Accessors                                --- ;
; ------------------------------------------------------- ;

float function GetVoiceDelay(bool IsFemale = false, int Stage = 1, bool IsSilent = false)
	if IsSilent
		return 3.0 ; Return basic delay for loop
	endIf
	float VoiceDelay
	if IsFemale
		VoiceDelay = fFemaleVoiceDelay
	else
		VoiceDelay = fMaleVoiceDelay
	endIf
	if Stage > 1
		VoiceDelay -= (Stage * 0.8) + Utility.RandomFloat(-0.4, 0.4)
		if VoiceDelay < 0.8
			return Utility.RandomFloat(0.8, 1.3) ; Can't have delay shorter than animation update loop
		endIf
	endIf
	return VoiceDelay
endFunction

bool[] function GetStrip(bool IsFemale, bool IsLeadIn = false, bool IsAggressive = false, bool IsVictim = false)
	if IsLeadIn
		if IsFemale
			return bStripLeadInFemale
		else
			return bStripLeadInMale
		endIf
 	elseif IsAggressive
 		if IsVictim
 			return bStripVictim
 		else
 			return bStripAggressor
 		endIf
 	elseIf IsFemale
 		return bStripFemale
 	else
 		return bStripMale
 	endIf
endFunction

bool function UsesNudeSuit(bool IsFemale)
	return ((!IsFemale && bUseMaleNudeSuit) || (IsFemale && bUseFemaleNudeSuit))
endFunction

Form function GetStrapon()
	if Strapons.Length > 0
		return Strapons[Utility.RandomInt(0, (Strapons.Length - 1))]
	endIf
	return none
endFunction

; ------------------------------------------------------- ;
; --- Hotkeys                                         --- ;
; ------------------------------------------------------- ;

event OnKeyDown(int keyCode)
	if !Utility.IsInMenuMode() && !UI.IsMenuOpen("Console") && !UI.IsMenuOpen("Loading Menu")
		if keyCode == kToggleFreeCamera
			ToggleFreeCamera()
		elseIf keyCode == kTargetActor
			SetTargetActor()
		endIf
	endIf
endEvent

event OnCrosshairRefChange(ObjectReference ActorRef)
	CrosshairRef = none
	if ActorRef != none
		CrosshairRef = ActorRef as Actor
	endIf
endEvent

function SetTargetActor()
	if CrosshairRef != none
		TargetRef = CrosshairRef
		Debug.Notification("SexLab Target Selected: "+TargetRef.GetLeveledActorBase().GetName())
		Stats.SeedActor(TargetRef)
	endif
endFunction

function ToggleFreeCamera()
	if Game.GetCameraState() != 3
		MiscUtil.SetFreeCameraSpeed(fAutoSUCSM)
	endIf
	MiscUtil.ToggleFreeCamera()
endFunction


bool function BackwardsPressed()
	return Input.GetNumKeysPressed() > 1 && (Input.IsKeyPressed(kBackwards) || (kBackwards == 54 && Input.IsKeyPressed(42)) || (kBackwards == 42 && Input.IsKeyPressed(54)))
endFunction

bool function AdjustStagePressed()
	return Input.GetNumKeysPressed() > 1 && (Input.IsKeyPressed(kAdjustStage) || (kAdjustStage == 157 && Input.IsKeyPressed(29)) || (kAdjustStage == 29 && Input.IsKeyPressed(157)))
endFunction

function HotkeyCallback(sslThreadController Thread, int keyCode)

	; Advance Stage
	if keyCode == kAdvanceAnimation
		Thread.AdvanceStage(BackwardsPressed())

	; Change Animation
	elseIf keyCode == kChangeAnimation
		Thread.ChangeAnimation(BackwardsPressed())

	; Forward / Backward adjustments
	elseIf keyCode == kAdjustForward
		Thread.AdjustForward(BackwardsPressed(), AdjustStagePressed())

	; Up / Down adjustments
	elseIf keyCode == kAdjustUpward
		Thread.AdjustUpward(BackwardsPressed(), AdjustStagePressed())

	; Left / Right adjustments
	elseIf keyCode == kAdjustSideways
		Thread.AdjustSideways(BackwardsPressed(), AdjustStagePressed())

	; Rotate Scene
	elseIf keyCode == kRotateScene
		Thread.RotateScene(BackwardsPressed())

	; Change Adjusted Actor
	elseIf keyCode == kAdjustChange
		Thread.AdjustChange(BackwardsPressed())

	; RePosition Actors
	elseIf keyCode == kRealignActors
		Thread.RealignActors()

	; Change Positions
	elseIf keyCode == kChangePositions
		Thread.ChangePositions(BackwardsPressed())

	; Restore animation offsets
	elseIf keyCode == kRestoreOffsets
		Thread.RestoreOffsets()

	; Move Scene
	elseIf keyCode == kMoveScene
		Thread.MoveScene()

	; EndAnimation
	elseIf keyCode == kEndAnimation
		Thread.EndAnimation(true)

	endIf
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
	form Strapon = WornStrapon(ActorRef)
	if Strapon != none
		return Strapon
	endIf
	return Config.Strapons[Utility.RandomInt(0, Config.Strapons.Length - 1)]
endFunction

form function EquipStrapon(Actor ActorRef)
	form Strapon = PickStrapon(ActorRef)
	if Strapon != none
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
	int i = Game.GetModCount()
	while i
		i -= 1
		string Name = Game.GetModName(i)
		if Name == "StrapOnbyaeonv1.1.esp"
			LoadStrapon("StrapOnbyaeonv1.1.esp", 0x0D65)
		elseif Name == "TG.esp"
			LoadStrapon("TG.esp", 0x0182B)
		elseif Name == "Futa equippable.esp"
			LoadStrapon("Futa equippable.esp", 0x0D66)
			LoadStrapon("Futa equippable.esp", 0x0D67)
			LoadStrapon("Futa equippable.esp", 0x01D96)
			LoadStrapon("Futa equippable.esp", 0x022FB)
			LoadStrapon("Futa equippable.esp", 0x022FC)
			LoadStrapon("Futa equippable.esp", 0x022FD)
		elseif Name == "Skyrim_Strap_Ons.esp"
			LoadStrapon("Skyrim_Strap_Ons.esp", 0x00D65)
			LoadStrapon("Skyrim_Strap_Ons.esp", 0x02859)
			LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285A)
			LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285B)
			LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285C)
			LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285D)
			LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285E)
			LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285F)
		elseif Name == "SOS Equipable Schlong.esp"
			LoadStrapon("SOS Equipable Schlong.esp", 0x0D62)
		endif
	endWhile
endFunction

Armor function LoadStrapon(string esp, int id)
	Armor Strapon = Game.GetFormFromFile(id, esp) as Armor
	if Strapon != none
		Strapons = sslUtility.PushForm(Strapon, Strapons)
	endif
	return Strapon
endFunction

; ------------------------------------------------------- ;
; --- Animation Profiles                              --- ;
; ------------------------------------------------------- ;

function ExportProfile(int Profile = 1)
	; Save normal animation profiles
	int i = AnimSlots.Slotted
	while i
		i -= 1
		AnimSlots.Slots[i].SaveProfile(Profile)
	endwhile
	; Save creature animation profiles
	i = CreatureSlots.Slotted
	while i
		i -= 1
		CreatureSlots.Slots[i].SaveProfile(Profile)
	endwhile
	; Log("AnimationProfile_"+Profile+".json", "Export")
endFunction

function ImportProfile(int Profile = 1)
	; Load normal animation profiles
	int i = AnimSlots.Slotted
	while i
		i -= 1
		AnimSlots.Slots[i].LoadProfile(Profile)
	endwhile
	; Load creature animation profiles
	i = CreatureSlots.Slotted
	while i
		i -= 1
		CreatureSlots.Slots[i].LoadProfile(Profile)
	endwhile
	; Log("AnimationProfile_"+Profile+".json", "Import")
endfunction

string function ProfileLabel(int Profile = 1)
	string LabelKey = "AnimationProfile.Label."+Profile
	string JSON = "AnimationProfile_"+Profile+".json"
	; Load existing label
	StorageUtil.ImportFile(JSON, LabelKey, 4, restrictGlobal = true)
	; Set a default label if it didn't load
	string Label = StorageUtil.GetStringValue(none, LabelKey, "Profile #"+Profile+" (no label)")
	StorageUtil.SetStringValue(none, LabelKey, Label)
	; Save label
	StorageUtil.ExportFile(JSON, LabelKey, 4, restrictGlobal = true)
	return Label
endFunction

; ------------------------------------------------------- ;
; --- System Use                                      --- ;
; ------------------------------------------------------- ;

bool function CheckSystem()
	; Check Skyrim Version
	if (StringUtil.SubString(Debug.GetVersionNumber(), 0, 3) as float) < 1.9
		CheckSkyrim.Show()
		return false
	; Check SKSE install
	elseIf SKSE.GetScriptVersionRelease() < 45
		CheckSKSE.Show(1.7)
		return false
	; Check SkyUI install - depends on passing SKSE check passing
	elseIf Quest.GetQuest("SKI_ConfigManagerInstance") == none
		CheckSkyUI.Show(4.1)
		return false
	; Check PapyrusUtil install - depends on passing SKSE check passing
	elseIf PapyrusUtil.GetVersion() < 19
		CheckPapyrusUtil.Show(1.9)
		return false
	endIf
	; Return result
	return true
endFunction

function ReloadConfig()
	; TFC Toggle key
	UnregisterForAllKeys()
	RegisterForKey(kToggleFreeCamera)
	RegisterForKey(kTargetActor)
	; Configure SFX & Voice volumes
	AudioVoice.SetVolume(fVoiceVolume)
	AudioSFX.SetVolume(fSFXVolume)
	; Load animation profile
	ImportProfile(AnimProfile)
	; Remove any targeted actors
	RegisterForCrosshairRef()
	CrosshairRef = none
	TargetRef = none
endFunction

function SetDebugMode(bool enabled)
	bDebugMode = enabled
	if enabled
		PlayerRef.AddSpell((Game.GetFormFromFile(0x073CC, "SexLab.esm") as Spell))
		PlayerRef.AddSpell((Game.GetFormFromFile(0x5FE9B, "SexLab.esm") as Spell))
	else
		PlayerRef.RemoveSpell((Game.GetFormFromFile(0x073CC, "SexLab.esm") as Spell))
		PlayerRef.RemoveSpell((Game.GetFormFromFile(0x5FE9B, "SexLab.esm") as Spell))
	endIf
endFunction

function SetDefaults()
	SexLab = Quest.GetQuest("SexLabQuestFramework") as SexLabFramework
	PlayerRef = Game.GetPlayer()

	StorageUtil.SetIntValue(PlayerRef, "sslActorStats.Sexuality", 100)

	VoiceSlots.ForgetVoice(PlayerRef)

	bDebugMode = true

	sNPCBed = "$SSL_Never"

	; Config
	fSFXDelay = 3.0
	fSFXVolume = 1.0

	; Config Hotkeys
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
	kToggleFreeCamera = 81 ; NUM 3
	kEndAnimation = 207 ; End
	kTargetActor = 49 ; N

	; TFC hotkey settings
	fAutoSUCSM = 5.0
	fMaleVoiceDelay = 5.0
	fFemaleVoiceDelay = 4.0
	fVoiceVolume = 1.0
	fCumTimer = 120.0

	; Config
	bDisablePlayer = false

	bScaleActors = false
	bUseCum = true
	bAllowFFCum = false
	bUseStrapons = true
	bReDressVictim = true
	bRagdollEnd = false
	bUseMaleNudeSuit = false
	bUseFemaleNudeSuit = false
	bUndressAnimation = false
	bUseLipSync = false
	bUseExpressions = false
	bNPCSaveVoice = false
	bAutoAdvance = true
	bForeplayStage = false
	bOrgasmEffects = false
	bRaceAdjustments = true
	bRestrictAggressive = true
	bAllowCreatures = true
	bAutoTFC = false

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

	; Timers
	fStageTimer = new float[5]
	fStageTimer[0] = 30.0
	fStageTimer[1] = 20.0
	fStageTimer[2] = 15.0
	fStageTimer[3] = 15.0
	fStageTimer[4] = 9.0

	fStageTimerLeadIn = new float[5]
	fStageTimerLeadIn[0] = 10.0
	fStageTimerLeadIn[1] = 10.0
	fStageTimerLeadIn[2] = 10.0
	fStageTimerLeadIn[3] = 8.0
	fStageTimerLeadIn[4] = 8.0

	fStageTimerAggr = new float[5]
	fStageTimerAggr[0] = 20.0
	fStageTimerAggr[1] = 15.0
	fStageTimerAggr[2] = 10.0
	fStageTimerAggr[3] = 10.0
	fStageTimerAggr[4] = 3.0

	; Set animation profile labels
	AnimProfile = 1
	ProfileLabel(1)
	ProfileLabel(2)
	ProfileLabel(3)
	ProfileLabel(4)
	ProfileLabel(5)
	ImportProfile(1)

	; Config loaders
	Setup()
	LoadStrapons()
	ReloadConfig()
endFunction

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

