scriptname sslSystemConfig extends sslSystemLibrary

import StorageUtil

; ------------------------------------------------------- ;
; --- Config Resources                                --- ;
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

string property sPlayerVoice auto hidden
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
		if VoiceDelay < 0.6
			return Utility.RandomFloat(0.6, 1.3) ; Can't have delay shorter than animation update loop
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

; ------------------------------------------------------- ;
; --- Hotkeys                                         --- ;
; ------------------------------------------------------- ;

function ToggleFreeCamera()
	if Game.GetCameraState() != 3
		MiscUtil.SetFreeCameraSpeed(fAutoSUCSM)
	endIf
	MiscUtil.ToggleFreeCamera()
endFunction

function ToggleFreeCameraEnable()
	UnregisterForAllKeys()
	RegisterForKey(kToggleFreeCamera)
endFunction

event OnKeyDown(int keyCode)
	if !Utility.IsInMenuMode() && !UI.IsMenuOpen("Console") && !UI.IsMenuOpen("Loading Menu")
		if keyCode == kToggleFreeCamera
			ToggleFreeCamera()
		endIf
	endIf
endEvent

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
; --- System Use                                      --- ;
; ------------------------------------------------------- ;

function SetDebugMode(bool enabling)
	bDebugMode = enabling
	if enabling
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
	bDebugMode = true

	sPlayerVoice = "$SSL_Random"
	bNPCSaveVoice = false

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

	; TFC hotkey settings
	bAutoTFC = false
	fAutoSUCSM = 5.0

	bRestrictAggressive = true
	bAllowCreatures = true

	; Config
	bDisablePlayer = false
	fMaleVoiceDelay = 6.0
	fFemaleVoiceDelay = 5.0
	fVoiceVolume = 1.0
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
	bUseLipSync = false
	bUseExpressions = false

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

	; Config
	fSFXDelay = 4.0
	fSFXVolume = 1.0
	bAutoAdvance = true
	bForeplayStage = false
	bOrgasmEffects = false
	bRaceAdjustments = true
	sNPCBed = "$SSL_Never"

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
endFunction


function ExportJSON()
	ExportString("sPlayerVoice", sPlayerVoice)
	ExportString("sNPCBed", sNPCBed)
	ExportBool("bRestrictAggressive", bRestrictAggressive)
	ExportBool("bAllowCreatures", bAllowCreatures)
	ExportBool("bNPCSaveVoice", bNPCSaveVoice)
	ExportBool("bUseStrapons", bUseStrapons)
	ExportBool("bReDressVictim", bReDressVictim)
	ExportBool("bRagdollEnd", bRagdollEnd)
	ExportBool("bUseMaleNudeSuit", bUseMaleNudeSuit)
	ExportBool("bUseFemaleNudeSuit", bUseFemaleNudeSuit)
	ExportBool("bUndressAnimation", bUndressAnimation)
	ExportBool("bUseLipSync", bUseLipSync)
	ExportBool("bUseExpressions", bUseExpressions)
	ExportBool("bScaleActors", bScaleActors)
	ExportBool("bUseCum", bUseCum)
	ExportBool("bAllowFFCum", bAllowFFCum)
	ExportBool("bDisablePlayer", bDisablePlayer)
	ExportBool("bAutoTFC", bAutoTFC)
	ExportBool("bDebugMode", bDebugMode)
	ExportBool("bAutoAdvance", bAutoAdvance)
	ExportBool("bForeplayStage", bForeplayStage)
	ExportBool("bOrgasmEffects", bOrgasmEffects)
	ExportBool("bRaceAdjustments", bRaceAdjustments)
	ExportInt("kBackwards", kBackwards)
	ExportInt("kAdjustStage", kAdjustStage)
	ExportInt("kBackwardsAlt", kBackwardsAlt)
	ExportInt("kAdjustStageAlt", kAdjustStageAlt)
	ExportInt("kAdvanceAnimation", kAdvanceAnimation)
	ExportInt("kChangeAnimation", kChangeAnimation)
	ExportInt("kChangePositions", kChangePositions)
	ExportInt("kAdjustChange", kAdjustChange)
	ExportInt("kAdjustForward", kAdjustForward)
	ExportInt("kAdjustSideways", kAdjustSideways)
	ExportInt("kAdjustUpward", kAdjustUpward)
	ExportInt("kRealignActors", kRealignActors)
	ExportInt("kMoveScene", kMoveScene)
	ExportInt("kRestoreOffsets", kRestoreOffsets)
	ExportInt("kRotateScene", kRotateScene)
	ExportInt("kToggleFreeCamera", kToggleFreeCamera)
	ExportInt("kEndAnimation", kEndAnimation)
	ExportFloat("fCumTimer", fCumTimer)
	ExportFloat("fAutoSUCSM", fAutoSUCSM)
	ExportFloat("fMaleVoiceDelay", fMaleVoiceDelay)
	ExportFloat("fFemaleVoiceDelay", fFemaleVoiceDelay)
	ExportFloat("fVoiceVolume", fVoiceVolume)
	ExportFloat("fSFXDelay", fSFXDelay)
	ExportFloat("fSFXVolume", fSFXVolume)

	ExportBoolList("bStripMale", bStripMale, 33)
	ExportBoolList("bStripFemale", bStripFemale, 33)
	ExportBoolList("bStripLeadInFemale", bStripLeadInFemale, 33)
	ExportBoolList("bStripLeadInMale", bStripLeadInMale, 33)
	ExportBoolList("bStripVictim", bStripVictim, 33)
	ExportBoolList("bStripAggressor", bStripAggressor, 33)

	ExportFloatList("fStageTimer", fStageTimer, 5)
	ExportFloatList("fStageTimerLeadIn", fStageTimerLeadIn, 5)
	ExportFloatList("fStageTimerAggr", fStageTimerAggr, 5)

endFunction

function ImportJSON()
	sPlayerVoice        = ImportString("sPlayerVoice", sPlayerVoice)
	sNPCBed             = ImportString("sNPCBed", sNPCBed)

	bRestrictAggressive = ImportBool("bRestrictAggressive", bRestrictAggressive)
	bAllowCreatures     = ImportBool("bAllowCreatures", bAllowCreatures)
	bNPCSaveVoice       = ImportBool("bNPCSaveVoice", bNPCSaveVoice)
	bUseStrapons        = ImportBool("bUseStrapons", bUseStrapons)
	bReDressVictim      = ImportBool("bReDressVictim", bReDressVictim)
	bRagdollEnd         = ImportBool("bRagdollEnd", bRagdollEnd)
	bUseMaleNudeSuit    = ImportBool("bUseMaleNudeSuit", bUseMaleNudeSuit)
	bUseFemaleNudeSuit  = ImportBool("bUseFemaleNudeSuit", bUseFemaleNudeSuit)
	bUndressAnimation   = ImportBool("bUndressAnimation", bUndressAnimation)
	bUseLipSync         = ImportBool("bUseLipSync", bUseLipSync)
	bUseExpressions     = ImportBool("bUseExpressions", bUseExpressions)
	bScaleActors        = ImportBool("bScaleActors", bScaleActors)
	bUseCum             = ImportBool("bUseCum", bUseCum)
	bAllowFFCum         = ImportBool("bAllowFFCum", bAllowFFCum)
	bDisablePlayer      = ImportBool("bDisablePlayer", bDisablePlayer)
	bAutoTFC            = ImportBool("bAutoTFC", bAutoTFC)
	bDebugMode          = ImportBool("bDebugMode", bDebugMode)
	bAutoAdvance        = ImportBool("bAutoAdvance", bAutoAdvance)
	bForeplayStage      = ImportBool("bForeplayStage", bForeplayStage)
	bOrgasmEffects      = ImportBool("bOrgasmEffects", bOrgasmEffects)
	bRaceAdjustments    = ImportBool("bRaceAdjustments", bRaceAdjustments)

	kBackwards          = ImportInt("kBackwards", kBackwards)
	kAdjustStage        = ImportInt("kAdjustStage", kAdjustStage)
	kBackwardsAlt       = ImportInt("kBackwardsAlt", kBackwardsAlt)
	kAdjustStageAlt     = ImportInt("kAdjustStageAlt", kAdjustStageAlt)
	kAdvanceAnimation   = ImportInt("kAdvanceAnimation", kAdvanceAnimation)
	kChangeAnimation    = ImportInt("kChangeAnimation", kChangeAnimation)
	kChangePositions    = ImportInt("kChangePositions", kChangePositions)
	kAdjustChange       = ImportInt("kAdjustChange", kAdjustChange)
	kAdjustForward      = ImportInt("kAdjustForward", kAdjustForward)
	kAdjustSideways     = ImportInt("kAdjustSideways", kAdjustSideways)
	kAdjustUpward       = ImportInt("kAdjustUpward", kAdjustUpward)
	kRealignActors      = ImportInt("kRealignActors", kRealignActors)
	kMoveScene          = ImportInt("kMoveScene", kMoveScene)
	kRestoreOffsets     = ImportInt("kRestoreOffsets", kRestoreOffsets)
	kRotateScene        = ImportInt("kRotateScene", kRotateScene)
	kToggleFreeCamera   = ImportInt("kToggleFreeCamera", kToggleFreeCamera)
	kEndAnimation       = ImportInt("kEndAnimation", kEndAnimation)

	fCumTimer           = ImportFloat("fCumTimer", fCumTimer)
	fAutoSUCSM          = ImportFloat("fAutoSUCSM", fAutoSUCSM)
	fMaleVoiceDelay     = ImportFloat("fMaleVoiceDelay", fMaleVoiceDelay)
	fFemaleVoiceDelay   = ImportFloat("fFemaleVoiceDelay", fFemaleVoiceDelay)
	fVoiceVolume        = ImportFloat("fVoiceVolume", fVoiceVolume)
	fSFXDelay           = ImportFloat("fSFXDelay", fSFXDelay)
	fSFXVolume          = ImportFloat("fSFXVolume", fSFXVolume)

	bStripMale          = ImportBoolList("bStripMale", bStripMale, 33)
	bStripFemale        = ImportBoolList("bStripFemale", bStripFemale, 33)
	bStripLeadInFemale  = ImportBoolList("bStripLeadInFemale", bStripLeadInFemale, 33)
	bStripLeadInMale    = ImportBoolList("bStripLeadInMale", bStripLeadInMale, 33)
	bStripVictim        = ImportBoolList("bStripVictim", bStripVictim, 33)
	bStripAggressor     = ImportBoolList("bStripAggressor", bStripAggressor, 33)

	fStageTimer         = ImportFloatList("fStageTimer", fStageTimer, 5)
	fStageTimerLeadIn   = ImportFloatList("fStageTimerLeadIn", fStageTimerLeadIn, 5)
	fStageTimerAggr     = ImportFloatList("fStageTimerAggr", fStageTimerAggr, 5)
endFunction



function ExportFloat(string Name, float Value)
	FileSetFloatValue("SexLabConfig."+Name, Value)
endFunction
float function ImportFloat(string Name, float Value)
	Name = "SexLabConfig."+Name
	Value = FileGetFloatValue(Name, Value)
	FileUnsetFloatValue(Name)
	return Value
endFunction

function ExportInt(string Name, int Value)
	FileSetIntValue("SexLabConfig."+Name, Value)
endFunction
int function ImportInt(string Name, int Value)
	Name = "SexLabConfig."+Name
	Value = FileGetIntValue(Name, Value)
	FileUnsetIntValue(Name)
	return Value
endFunction

function ExportBool(string Name, bool Value)
	FileSetIntValue("SexLabConfig."+Name, Value as int)
endFunction
bool function ImportBool(string Name, bool Value)
	Name = "SexLabConfig."+Name
	Value = FileGetIntValue(Name, Value as int) as bool
	FileUnsetIntValue(Name)
	return Value
endFunction

function ExportString(string Name, string Value)
	FileSetStringValue("SexLabConfig."+Name, Value)
endFunction
string function ImportString(string Name, string Value)
	Name = "SexLabConfig."+Name
	Value = FileGetStringValue(Name, Value)
	FileUnsetStringValue(Name)
	return Value
endFunction

function ExportFloatList(string Name, float[] Values, int len)
	Name = "SexLabConfig."+Name
	FileFloatListClear(Name)
	int i
	while i < len
		FileFloatListAdd(Name, Values[i])
		i += 1
	endWhile
endFunction
float[] function ImportFloatList(string Name, float[] Values, int len)
	Name = "SexLabConfig."+Name
	if FileFloatListCount(Name) == len
		int i
		while i < len
			Values[i] = FileFloatListGet(Name, i)
			i += 1
		endWhile
	endIf
	FileFloatListClear(Name)
	return Values
endFunction

function ExportBoolList(string Name, bool[] Values, int len)
	Name = "SexLabConfig."+Name
	FileIntListClear(Name)
	int i
	while i < len
		FileIntListAdd(Name, Values[i] as int)
		i += 1
	endWhile
endFunction
bool[] function ImportBoolList(string Name, bool[] Values, int len)
	Name = "SexLabConfig."+Name
	if FileIntListCount(Name) == len
		int i
		while i < len
			Values[i] = FileIntListGet(Name, i) as bool
			i += 1
		endWhile
	endIf
	FileIntListClear(Name)
	return Values
endFunction
