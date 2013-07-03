scriptname sslSystemConfig extends SKI_ConfigBase
{Skyrim Sex Lab Mod Configuration Menu}

int function GetVersion()
	return 110
endFunction

bool function DebugMode()
	return true
endFunction

; Resources
SexLabFramework property SexLab auto

; Config Settings
bool property bRestrictAggressive auto hidden
int oidRestrictAggressive
bool property bEnableTCL auto hidden ; DEPRECATED for animation specific tcl's in v1.1
int oidEnableTCL ; DEPRECATED for animation specific tcl's in v1.1
bool property bScaleActors auto hidden
int oidScaleActors
bool property bUseCum auto hidden
int oidUseCum
bool property bAllowFFCum auto hidden
int oidAllowFFCum
float property fCumTimer auto hidden
int oidCumTimer
bool property bUseStrapons auto hidden
int oidUseStrapons
int oidFindStrapons
bool property bAutoAdvance auto hidden
int oidAutoAdvance
bool property bDisablePlayer auto hidden
int oidDisablePlayer
bool property bReDressVictim auto hidden
int oidReDressVictim
bool property bRagdollEnd auto hidden
int oidRagdollEnd
bool property bForeplayStage auto hidden
int oidForeplayStage
string property sNPCBed auto hidden
int oidNPCBed
bool property bUseMaleNudeSuit auto hidden
int oidUseMaleNudeSuit
bool property bUseFemaleNudeSuit auto hidden
int oidUseFemaleNudeSuit
bool property bUndressAnimation auto hidden
int oidUndressAnimation

float[] property fStageTimer auto hidden
int[] oidStageTimer
float[] property fStageTimerLeadIn auto hidden
int[] oidStageTimerLeadIn
float[] property fStageTimerAggr auto hidden
int[] oidStageTimerAggr

int property kBackwards auto hidden
int oidBackwards
int property kAdvanceAnimation auto hidden
int oidAdvanceAnimation
int property kChangeAnimation auto hidden
int oidChangeAnimation
int property kChangePositions auto hidden
int oidChangePositions
int property kRealignActors auto hidden
int oidRealignActors
int property kAdjustChange auto hidden
int oidAdjustChange
int property kAdjustForward auto hidden
int oidAdjustForward
int property kAdjustSideways auto hidden
int oidAdjustSideways
int property kAdjustUpward auto hidden
int oidAdjustUpward
int property kMoveScene auto hidden
int oidMoveScene
int property kRotateScene auto hidden
int oidRotateScene
int property kRestoreOffsets auto hidden
int oidRestoreOffsets

bool[] property bStripMale auto hidden
int[] oidStripMale
bool[] property bStripFemale auto hidden
int[] oidStripFemale
bool[] property bStripLeadInFemale auto hidden
int[] oidStripLeadInFemale
bool[] property bStripLeadInMale auto hidden
int[] oidStripLeadInMale
bool[] property bStripVictim auto hidden
int[] oidStripVictim
bool[] property bStripAggressor auto hidden
int[] oidStripAggressor
string property sPlayerVoice auto hidden

int oidPlayerVoice
int[] oidToggleVoice
int[] oidToggleAnimation
int[] oidAggrAnimation

float property fMaleVoiceDelay auto hidden
int oidMaleVoiceDelay
float property fFemaleVoiceDelay auto hidden
int oidFemaleVoiceDelay
float property fSFXDelay auto hidden
int oidSFXDelay  
float property fVoiceVolume auto hidden
int oidVoiceVolume
float property fSFXVolume auto hidden
int oidSFXVolume

int[] oidRemoveStrapon

int oidStopAnimations  
int oidRestoreDefaults
int oidCleanSystem
int oidRebuildAnimations
int oidRebuildVoices
int oidResetStats

string[] property sStatTitles auto hidden
string[] property sPureTitles auto hidden
string[] property sImpureTitles auto hidden

function SetDefaults()
	bRestrictAggressive = true
	bUseCum = true
	; DEPRECATED for animation specific tcl's in v1.1
	; bEnableTCL = false
	bScaleActors = true
	bAllowFFCum = false
	fCumTimer = 120.0
	sPlayerVoice = "$SSL_Random"
	bUseStrapons = true
	bAutoAdvance = true
	bDisablePlayer = true
	bReDressVictim = true
	sNPCBed = "$SSL_Never"
	bUseMaleNudeSuit = false
	bUseFemaleNudeSuit = false
	bRagdollEnd = true
	bForeplayStage = true
	bUndressAnimation = true

	fMaleVoiceDelay = 7.0
	fFemaleVoiceDelay = 6.0
	fSFXDelay = 4.0
	fVoiceVolume = 0.7
	fSFXVolume = 0.8

	; Controls Page
	kBackwards = 54 ; Right Shift
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

	oidToggleVoice = new int[128]
	oidToggleAnimation = new int[128]
	oidAggrAnimation = new int[128]

	bStripMale = new bool[33]
	oidStripMale = new int[33]
	bStripFemale = new bool[33]
	oidStripFemale = new int[33]

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
	oidStripLeadInFemale = new int[33]
	bStripLeadInMale = new bool[33]
	oidStripLeadInMale = new int[33]

	bStripLeadInFemale[0] = true
	bStripLeadInFemale[2] = true
	bStripLeadInFemale[9] = true
	bStripLeadInFemale[14] = true
	bStripLeadInFemale[32] = true

	bStripLeadInMale[0] = true
	bStripLeadInMale[2] = true
	bStripLeadInMale[9] = true
	bStripLeadInMale[14] = true
	bStripLeadInMale[32] = true

	bStripVictim = new bool[33]
	oidStripVictim = new int[33]
	bStripAggressor = new bool[33]
	oidStripAggressor = new int[33]

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

	bStripAggressor[2] = true
	bStripAggressor[4] = true
	bStripAggressor[9] = true
	bStripAggressor[16] = true
	bStripAggressor[24] = true
	bStripAggressor[26] = true

	fStageTimer = new float[5]
	oidStageTimer = new int[5]

	fStageTimer[0] = 30.0
	fStageTimer[1] = 20.0
	fStageTimer[2] = 15.0
	fStageTimer[3] = 15.0
	fStageTimer[4] = 9.0

	fStageTimerLeadIn = new float[5]
	oidStageTimerLeadIn = new int[5]

	fStageTimerLeadIn[0] = 10.0
	fStageTimerLeadIn[1] = 10.0
	fStageTimerLeadIn[2] = 10.0
	fStageTimerLeadIn[3] = 8.0
	fStageTimerLeadIn[4] = 8.0

	fStageTimerAggr = new float[5]
	oidStageTimerAggr = new int[5]

	fStageTimerAggr[0] = 20.0
	fStageTimerAggr[1] = 15.0
	fStageTimerAggr[2] = 10.0
	fStageTimerAggr[3] = 10.0
	fStageTimerAggr[4] = 3.0

	oidRemoveStrapon = new int[10]

	sPureTitles = new string[7]
	sPureTitles[0] = "$SSL_Neutral"
	sPureTitles[1] = "$SSL_Unsullied"
	sPureTitles[3] = "$SSL_Virtuous"
	sPureTitles[4] = "$SSL_EverFaithful"
	sPureTitles[6] = "$SSL_Saintly"

	sImpureTitles = new string[7]
	sImpureTitles[0] = "$SSL_Neutral"
	sImpureTitles[1] = "$SSL_Experimenting"
	sImpureTitles[2] = "$SSL_UnusuallyHorny"
	sImpureTitles[3] = "$SSL_Promiscuous"
	sImpureTitles[4] = "$SSL_SexualDeviant"

	sStatTitles = new string[7]
	sStatTitles[0] = "$SSL_Unskilled"
	sStatTitles[1] = "$SSL_Novice"
	sStatTitles[2] = "$SSL_Apprentice"
	sStatTitles[3] = "$SSL_Journeyman"
	sStatTitles[4] = "$SSL_Expert"
	sStatTitles[5] = "$SSL_Master"
	sStatTitles[6] = "$SSL_GrandMaster"

	Pages = new string[10]
	Pages[0] = "$SSL_AnimationSettings"
	Pages[1] = "$SSL_PlayerHotkeys"
	Pages[2] = "$SSL_NormalTimersStripping"
	Pages[3] = "$SSL_ForeplayTimersStripping"
	Pages[4] = "$SSL_AggressiveTimersStripping"
	Pages[5] = "$SSL_ToggleVoices"
	Pages[6] = "$SSL_ToggleAnimations"
	Pages[7] = "$SSL_AggressiveAnimations"
	Pages[9] = "$SSL_RebuildClean"

	if SexLab.PlayerRef.GetActorBase().GetSex() > 0
		Pages[8] = "$SSL_SexDiary"
		sPureTitles[2] = "$SSL_PrimProper"
		sPureTitles[5] = "$SSL_Ladylike"
		sImpureTitles[5] = "$SSL_Debaucherous"
		sImpureTitles[6] = "$SSL_Nymphomaniac"
	else
		Pages[8] = "$SSL_SexJournal"
		sPureTitles[2] = "$SSL_CleanCut"
		sPureTitles[5] = "$SSL_Lordly"
		sImpureTitles[5] = "$SSL_Depraved"
		sImpureTitles[6] = "$SSL_Hypersexual"
	endIf
endFunction

event OnConfigInit()
	SexLab._CheckSystem()
	SexLab._SetupSystem()
	SetDefaults()
	SexLab.Data.LoadAnimations()
	SexLab.Data.LoadVoices()
endEvent

event OnPlayerLoadGame()
	SexLab._CheckSystem()
	Sexlab._StopAnimations()
	SexLab.Data.LoadAnimations()
	SexLab.Data.LoadVoices()
	SetDefaults()
endEvent

event OnVersionUpdate(int version)
	float current = (CurrentVersion as float / 100.0)
	float latest = (version as float / 100.0)
	if CurrentVersion > 1 && !SexLab._CheckClean() && (current - latest) > 10
		SexLab.Data.mDirtyUpgrade.Show(current, latest)
	endIf
	SetDefaults()

	; ; Rev 4
	; if version >= 4 && CurrentVersion < 4
	; 	SetDefaults()
	; endIf
endEvent

event OnPageReset(string page)
	int i = 0

	if page == ""
		LoadCustomContent("SexLab/logo.dds", 184, 31)
		return
	else
		UnloadCustomContent()
	endIf

	if page == "$SSL_AnimationSettings"
		SetCursorFillMode(TOP_TO_BOTTOM)
		oidRestrictAggressive = AddToggleOption("$SSL_RestrictAggressive", bRestrictAggressive)
		oidForeplayStage = AddToggleOption("$SSL_PreSexForeplay", bForeplayStage)
		oidScaleActors = AddToggleOption("$SSL_EvenActorsHeight", bScaleActors)
		oidRagdollEnd = AddToggleOption("$SSL_RagdollEnding", bRagdollEnd)
		oidUndressAnimation = AddToggleOption("$SSL_UndressAnimation", bUndressAnimation)
		; DEPRECATED for animation specific tcl's in v1.1
		; oidEnableTCL = AddToggleOption("Toggle Collisions For Player", bEnableTCL)
		oidReDressVictim = AddToggleOption("$SSL_VictimsRedress", bReDressVictim)
		oidNPCBed = AddTextOption("$SSL_NPCsUseBeds", sNPCBed)
		oidUseCum = AddToggleOption("$SSL_ApplyCumEffects", bUseCum)
		oidAllowFFCum = AddToggleOption("$SSL_AllowFemaleFemaleCum", bAllowFFCum)
		oidCumTimer = AddSliderOption("$SSL_CumEffectTimer", fCumTimer, "$SSL_Seconds")
		oidUseStrapons = AddToggleOption("$SSL_FemalesUseStrapons", bUseStrapons)
		oidUseMaleNudeSuit = AddToggleOption("$SSL_UseNudeSuitMales", bUseMaleNudeSuit)
		oidUseFemaleNudeSuit = AddToggleOption("$SSL_UseNudeSuitFemales", bUseFemaleNudeSuit)

		SetCursorPosition(1)
		AddHeaderOption("$SSL_PlayerSettings")
		oidAutoAdvance = AddToggleOption("$SSL_AutoAdvanceStages", bAutoAdvance)
		oidDisablePlayer = AddToggleOption("$SSL_DisableVictimControls", bDisablePlayer)
		AddEmptyOption()
		AddHeaderOption("$SSL_SoundsVoices")
		oidPlayerVoice = AddTextOption("$SSL_PCVoice", sPlayerVoice)
		oidVoiceVolume = AddSliderOption("$SSL_VoiceVolume", fVoiceVolume, "{2}")
		oidMaleVoiceDelay = AddSliderOption("$SSL_MaleVoiceDelay", fMaleVoiceDelay, "$SSL_Seconds")
		oidFemaleVoiceDelay = AddSliderOption("$SSL_FemaleVoiceDelay", fFemaleVoiceDelay, "$SSL_Seconds")
		oidSFXVolume = AddSliderOption("$SSL_SFXVolume", fSFXVolume, "{2}")
		oidSFXDelay = AddSliderOption("$SSL_SFXDelay", fSFXDelay, "$SSL_Seconds")
		

	elseIf page == "$SSL_PlayerHotkeys"
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("$SSL_SceneManipulation")
		oidBackwards = AddKeyMapOption("$SSL_ReverseDirectionModifier", kBackwards)
		oidAdvanceAnimation = AddKeyMapOption("$SSL_AdvanceAnimationStage", kAdvanceAnimation)
		oidChangeAnimation = AddKeyMapOption("$SSL_ChangeAnimationSet", kChangeAnimation)
		oidChangePositions = AddKeyMapOption("$SSL_SwapActorPositions", kChangePositions)
		oidMoveScene = AddKeyMapOption("$SSL_MoveSceneLocation", kMoveScene)
		oidRotateScene = AddKeyMapOption("$SSL_RotateScene", kRotateScene)
		SetCursorPosition(1)
		AddHeaderOption("$SSL_AlignmentAdjustments")
		oidAdjustChange = AddKeyMapOption("$SSL_ChangeActorBeingMoved", kAdjustChange)
		oidAdjustForward = AddKeyMapOption("$SSL_MoveActorForwardBackward", kAdjustForward)
		oidAdjustUpward = AddKeyMapOption("$SSL_AdjustPositionUpwardDownward", kAdjustUpward)
		oidAdjustSideways = AddKeyMapOption("$SSL_MoveActorLeftRight", kAdjustSideways)
		oidRealignActors = AddKeyMapOption("$SSL_RealignActors", kRealignActors)
		oidRestoreOffsets = AddKeyMapOption("$SSL_DeleteSavedAdjustments", kRestoreOffsets)

	elseIf page == "$SSL_NormalTimersStripping"

		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption("$SSL_ConsensualStageTimers")
		oidStageTimer[0] = AddSliderOption("$SSL_Stage1Length", fStageTimer[0], "$SSL_Seconds")
		oidStageTimer[1] = AddSliderOption("$SSL_Stage2Length", fStageTimer[1], "$SSL_Seconds")
		oidStageTimer[2] = AddSliderOption("$SSL_Stage3Length", fStageTimer[2], "$SSL_Seconds")
		AddEmptyOption()

		AddHeaderOption("$SSL_FemaleStripFrom")
		oidStripFemale[32] = AddToggleOption("$SSL_Weapons", bStripFemale[32])
		i = 0
		while i < 32
			int slot = i + 30
			string name = GetSlotName(slot)
			if name != "IGNORE"
				oidStripFemale[i] = AddToggleOption(name, bStripFemale[i])
			endIf
			if slot == 43
				AddHeaderOption("$SSL_ExtraSlots")
			endIf
			i += 1
		endWhile

		SetCursorPosition(1)
		AddHeaderOption("")
		oidStageTimer[3] = AddSliderOption("$SSL_Stage4Length", fStageTimer[3], "$SSL_Seconds")
		oidStageTimer[4] = AddSliderOption("$SSL_StageEndingLength", fStageTimer[4], "$SSL_Seconds")
		AddEmptyOption()
		AddEmptyOption()

		AddHeaderOption("$SSL_MaleStripFrom")
		oidStripMale[32] = AddToggleOption("$SSL_Weapons", bStripMale[32])
		i = 0
		while i < 32
			int slot = i + 30
			string name = GetSlotName(slot)
			if name != "IGNORE"
				oidStripMale[i] = AddToggleOption(name, bStripMale[i])
			endIf
			if slot == 43
				AddHeaderOption("$SSL_ExtraSlots")
			endIf
			i += 1
		endWhile

	elseIf page == "$SSL_ForeplayTimersStripping"
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("$SSL_ForeplayIntroAnimationTimers")
		oidStageTimerLeadIn[0] = AddSliderOption("$SSL_Stage1Length", fStageTimerLeadIn[0], "$SSL_Seconds")
		oidStageTimerLeadIn[1] = AddSliderOption("$SSL_Stage2Length", fStageTimerLeadIn[1], "$SSL_Seconds")
		oidStageTimerLeadIn[2] = AddSliderOption("$SSL_Stage3Length", fStageTimerLeadIn[2], "$SSL_Seconds")
		AddEmptyOption()

		AddHeaderOption("$SSL_FemaleStripFrom")
		oidStripVictim[32] = AddToggleOption("$SSL_Weapons", bStripLeadInFemale[32])
		i = 0
		while i < 32
			int slot = i + 30
			string name = GetSlotName(slot)
			if name != "IGNORE"
				oidStripLeadInFemale[i] = AddToggleOption(name, bStripLeadInFemale[i])
			endIf
			if slot == 43
				AddHeaderOption("$SSL_ExtraSlots")
			endIf
			i += 1
		endWhile

		SetCursorPosition(1)
		AddHeaderOption("")
		oidStageTimerLeadIn[3] = AddSliderOption("$SSL_Stage4Length", fStageTimerLeadIn[3], "$SSL_Seconds")
		oidStageTimerLeadIn[4] = AddSliderOption("$SSL_StageEndingLength", fStageTimerLeadIn[4], "$SSL_Seconds")
		AddEmptyOption()
		AddEmptyOption()

		AddHeaderOption("$SSL_MaleStripFrom")
		oidStripAggressor[32] = AddToggleOption("$SSL_Weapons", bStripLeadInMale[32])
		i = 0
		while i < 32
			int slot = i + 30
			string name = GetSlotName(slot)
			if name != "IGNORE"
				oidStripLeadInMale[i] = AddToggleOption(name, bStripLeadInMale[i])
			endIf
			if slot == 43
				AddHeaderOption("$SSL_ExtraSlots")
			endIf
			i += 1
		endWhile


	elseIf page == "$SSL_AggressiveTimersStripping"

		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("$SSL_AggressiveAnimationTimers")
		oidStageTimerAggr[0] = AddSliderOption("$SSL_Stage1Length", fStageTimerAggr[0], "$SSL_Seconds")
		oidStageTimerAggr[1] = AddSliderOption("$SSL_Stage2Length", fStageTimerAggr[1], "$SSL_Seconds")
		oidStageTimerAggr[2] = AddSliderOption("$SSL_Stage3Length", fStageTimerAggr[2], "$SSL_Seconds")
		AddEmptyOption()

		AddHeaderOption("$SSL_VictimStripFrom")
		oidStripVictim[32] = AddToggleOption("$SSL_Weapons", bStripVictim[32])
		i = 0
		while i < 32
			int slot = i + 30
			string name = GetSlotName(slot)
			if name != "IGNORE"
				oidStripVictim[i] = AddToggleOption(name, bStripVictim[i])
			endIf
			if slot == 43
				AddHeaderOption("$SSL_ExtraSlots")
			endIf
			i += 1
		endWhile

		SetCursorPosition(1)
		AddHeaderOption("")
		oidStageTimerAggr[3] = AddSliderOption("$SSL_Stage4Length", fStageTimerAggr[3], "$SSL_Seconds")
		oidStageTimerAggr[4] = AddSliderOption("$SSL_StageEndingLength", fStageTimerAggr[4], "$SSL_Seconds")
		AddEmptyOption()
		AddEmptyOption()

		AddHeaderOption("$SSL_AggressorStripFrom")
		oidStripAggressor[32] = AddToggleOption("$SSL_Weapons", bStripAggressor[32])
		i = 0
		while i < 32
			int slot = i + 30
			string name = GetSlotName(slot)
			if name != "IGNORE"
				oidStripAggressor[i] = AddToggleOption(name, bStripAggressor[i])
			endIf
			if slot == 43
				AddHeaderOption("$SSL_ExtraSlots")
			endIf
			i += 1
		endWhile

	elseIf page == "$SSL_ToggleAnimations"
		SetCursorFillMode(LEFT_TO_RIGHT)
		i = 0
		while i < SexLab.animation.Length
			if SexLab.animation[i] != none
				oidToggleAnimation[i] = AddToggleOption(SexLab.animation[i].name, SexLab.animation[i].enabled)
			endIf
			i += 1
		endWhile
	elseIf page == "$SSL_AggressiveAnimations"
		SetCursorFillMode(LEFT_TO_RIGHT)
		i = 0
		while i < SexLab.animation.Length
			if SexLab.animation[i] != none
				oidAggrAnimation[i] = AddToggleOption(SexLab.animation[i].name, SexLab.animation[i].HasTag("Aggressive"))
			endIf
			i += 1
		endWhile
	elseIf page == "$SSL_ToggleVoices"
		SetCursorFillMode(LEFT_TO_RIGHT)
		i = 0
		while i < SexLab.voice.Length
			if SexLab.voice[i] != none
				oidToggleVoice[i] = AddToggleOption(SexLab.voice[i].name, SexLab.voice[i].enabled)
			endIf
			i += 1
		endWhile
	elseIf page == "$SSL_SexDiary" || page == "$SSL_SexJournal"
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("$SSL_SexualExperience")
		int full = SexLab.Data.fTimeSpent as int
		int seconds = full % 60
		int minutes = Math.Floor((full / 60) % 60)
		int hours = Math.Floor(full / 3600)
		AddTextOption("$SSL_TimeSpentHavingSex", hours+":"+minutes+":"+seconds)
		AddTextOption("$SSL_MaleSexualPartners", SexLab.Data.iMalePartners)
		AddTextOption("$SSL_FemaleSexualPartners", SexLab.Data.iFemalePartners)
		AddTextOption("$SSL_TimesMasturbated", SexLab.Data.iMasturbationCount)
		AddTextOption("$SSL_VaginalExperience", SexLab.Data.iVaginalCount)
		AddTextOption("$SSL_AnalExperience", SexLab.Data.iAnalCount)
		AddTextOption("$SSL_OralExperience", SexLab.Data.iOralCount)
		AddTextOption("$SSL_TimesVictim", SexLab.Data.iVictimCount)
		AddTextOption("$SSL_TimesAggressive", SexLab.Data.iAggressorCount)

		SetCursorPosition(1)
		AddHeaderOption("$SSL_SexualStats")
		AddTextOption("$SSL_Sexuality", SexLab.GetPlayerSexuality())
		if SexLab.GetPlayerPurityLevel() < 0
			AddTextOption("$SSL_SexualPerversion", SexLab.GetPlayerPurityTitle())
		else
			AddTextOption("$SSL_SexualPurity", SexLab.GetPlayerPurityTitle())
		endIf
		AddTextOption("$SSL_VaginalProficiency", SexLab.GetPlayerStatTitle("Vaginal"))
		AddTextOption("$SSL_AnalProficiency", SexLab.GetPlayerStatTitle("Anal"))
		AddTextOption("$SSL_OralProficiency", SexLab.GetPlayerStatTitle("Oral"))

	elseIf page == "$SSL_RebuildClean"
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("Created By Ashal@LoversLab.com")
		AddEmptyOption()
		AddHeaderOption("$SSL_Maintenance")
		oidStopAnimations = AddTextOption("$SSL_StopCurrentAnimations", "$SSL_ClickHere")
		oidRestoreDefaults = AddTextOption("$SSL_RestoreDefaultSettings", "$SSL_ClickHere")
		oidRebuildAnimations = AddTextOption("$SSL_ResetAnimationRegistry", "$SSL_ClickHere")
		oidRebuildVoices = AddTextOption("$SSL_ResetVoiceRegistry", "$SSL_ClickHere")
		oidResetStats = AddTextOption("$SSL_ResetPlayerSexStats", "$SSL_ClickHere")
		AddEmptyOption()
		AddHeaderOption("$SSL_UpgradeUninstallReinstall")
		oidCleanSystem = AddTextOption("$SSL_CleanSystem", "$SSL_ClickHere")
		AddEmptyOption()

		SetCursorPosition(1)
		AddHeaderOption("$SSL_TranslatedBy")
		AddEmptyOption()
		AddHeaderOption("$SSL_AvailableStrapons")
		oidFindStrapons = AddTextOption("$SSL_RebuildStraponList", "$SSL_ClickHere")
		i = 0
		while i < SexLab.Data.strapons.Length
			if SexLab.Data.strapons[i] != none
				if SexLab.Data.strapons[i].GetName() == "strapon"
					oidRemoveStrapon[i] = AddTextOption("Aeon/Horker", "$SSL_Remove")
				else
					oidRemoveStrapon[i] = AddTextOption(SexLab.Data.strapons[i].GetName(), "$SSL_Remove")
				endIf
			endIf
			i += 1
		endWhile
	endIf

endEvent

;#---------------------------#
;#     Option Adjustment     #
;#---------------------------#

event OnOptionSliderOpen(int option)
	if option == oidCumTimer
		SetSliderDialogStartValue(fCumTimer)
		SetSliderDialogDefaultValue(120.0)
		SetSliderDialogRange(1.0, 300.0)
		SetSliderDialogInterval(1.0)

	elseIf option == oidMaleVoiceDelay
		SetSliderDialogStartValue(fMaleVoiceDelay)
		SetSliderDialogDefaultValue(7.0)
		SetSliderDialogRange(4.0, 60.0)
		SetSliderDialogInterval(1.0)

	elseIf option == oidFemaleVoiceDelay
		SetSliderDialogStartValue(fFemaleVoiceDelay)
		SetSliderDialogDefaultValue(6.0)
		SetSliderDialogRange(4.0, 60.0)
		SetSliderDialogInterval(1.0)

	elseIf option == oidSFXDelay
		SetSliderDialogStartValue(fSFXDelay)
		SetSliderDialogDefaultValue(4.0)
		SetSliderDialogRange(4.0, 60.0)
		SetSliderDialogInterval(1.0)

	elseIf option == oidVoiceVolume
		SetSliderDialogStartValue(fVoiceVolume)
		SetSliderDialogDefaultValue(0.7)
		SetSliderDialogRange(0.0, 1.0)
		SetSliderDialogInterval(0.01)

	elseIf option == oidSFXVolume
		SetSliderDialogStartValue(fSFXVolume)
		SetSliderDialogDefaultValue(0.8)
		SetSliderDialogRange(0.0, 1.0)
		SetSliderDialogInterval(0.01)

	elseIf option == oidStageTimer[0]
		SetSliderDialogStartValue(fStageTimer[0])
		SetSliderDialogDefaultValue(30.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)
	elseIf option == oidStageTimer[1]
		SetSliderDialogStartValue(fStageTimer[1])
		SetSliderDialogDefaultValue(20.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)
	elseIf option == oidStageTimer[2]
		SetSliderDialogStartValue(fStageTimer[2])
		SetSliderDialogDefaultValue(15.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)
	elseIf option == oidStageTimer[3]
		SetSliderDialogStartValue(fStageTimer[3])
		SetSliderDialogDefaultValue(15.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)
	elseIf option == oidStageTimer[4]
		SetSliderDialogStartValue(fStageTimer[4])
		SetSliderDialogDefaultValue(7.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)

	elseIf option == oidStageTimerLeadIn[0]
		SetSliderDialogStartValue(fStageTimerLeadIn[0])
		SetSliderDialogDefaultValue(30.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)
	elseIf option == oidStageTimerLeadIn[1]
		SetSliderDialogStartValue(fStageTimerLeadIn[1])
		SetSliderDialogDefaultValue(20.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)
	elseIf option == oidStageTimerLeadIn[2]
		SetSliderDialogStartValue(fStageTimerLeadIn[2])
		SetSliderDialogDefaultValue(15.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)
	elseIf option == oidStageTimerLeadIn[3]
		SetSliderDialogStartValue(fStageTimerLeadIn[3])
		SetSliderDialogDefaultValue(15.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)
	elseIf option == oidStageTimerLeadIn[4]
		SetSliderDialogStartValue(fStageTimerLeadIn[4])
		SetSliderDialogDefaultValue(7.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)

	elseIf option == oidStageTimerAggr[0]
		SetSliderDialogStartValue(fStageTimerAggr[0])
		SetSliderDialogDefaultValue(30.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)
	elseIf option == oidStageTimerAggr[1]
		SetSliderDialogStartValue(fStageTimerAggr[1])
		SetSliderDialogDefaultValue(20.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)
	elseIf option == oidStageTimerAggr[2]
		SetSliderDialogStartValue(fStageTimerAggr[2])
		SetSliderDialogDefaultValue(15.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)
	elseIf option == oidStageTimerAggr[3]
		SetSliderDialogStartValue(fStageTimerAggr[3])
		SetSliderDialogDefaultValue(15.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)
	elseIf option == oidStageTimerAggr[4]
		SetSliderDialogStartValue(fStageTimerAggr[4])
		SetSliderDialogDefaultValue(7.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)
	endIf


endEvent

event OnOptionSliderAccept(int option, float value)
	if option == oidCumTimer
		fCumTimer = value
		SetSliderOptionValue(oidCumTimer, fCumTimer, "$SSL_Seconds")

	elseIf option == oidMaleVoiceDelay
		fMaleVoiceDelay = value
		SetSliderOptionValue(oidMaleVoiceDelay, fMaleVoiceDelay, "$SSL_Seconds")

	elseIf option == oidFemaleVoiceDelay
		fFemaleVoiceDelay = value
		SetSliderOptionValue(oidFemaleVoiceDelay, fFemaleVoiceDelay, "$SSL_Seconds")

	elseIf option == oidVoiceVolume
		fVoiceVolume = value
		SetSliderOptionValue(oidVoiceVolume, fVoiceVolume, "{2}")

	elseIf option == oidSFXVolume
		fSFXVolume = value
		SetSliderOptionValue(oidSFXVolume, fSFXVolume, "{2}")

	elseIf option == oidSFXDelay
		fSFXDelay = value
		SetSliderOptionValue(oidSFXDelay, fSFXDelay, "$SSL_Seconds")

	elseIf option == oidStageTimer[0]
		fStageTimer[0] = value
		SetSliderOptionValue(oidStageTimer[0], fStageTimer[0], "$SSL_Seconds")
	elseIf option == oidStageTimer[1]
		fStageTimer[1] = value
		SetSliderOptionValue(oidStageTimer[1], fStageTimer[1], "$SSL_Seconds")
	elseIf option == oidStageTimer[2]
		fStageTimer[2] = value
		SetSliderOptionValue(oidStageTimer[2], fStageTimer[2], "$SSL_Seconds")
	elseIf option == oidStageTimer[3]
		fStageTimer[3] = value
		SetSliderOptionValue(oidStageTimer[3], fStageTimer[3], "$SSL_Seconds")
	elseIf option == oidStageTimer[4]
		fStageTimer[4] = value
		SetSliderOptionValue(oidStageTimer[4], fStageTimer[4], "$SSL_Seconds")

	elseIf option == oidStageTimerLeadIn[0]
		fStageTimerLeadIn[0] = value
		SetSliderOptionValue(oidStageTimerLeadIn[0], fStageTimerLeadIn[0], "$SSL_Seconds")
	elseIf option == oidStageTimerLeadIn[1]
		fStageTimerLeadIn[1] = value
		SetSliderOptionValue(oidStageTimerLeadIn[1], fStageTimerLeadIn[1], "$SSL_Seconds")
	elseIf option == oidStageTimerLeadIn[2]
		fStageTimerLeadIn[2] = value
		SetSliderOptionValue(oidStageTimerLeadIn[2], fStageTimerLeadIn[2], "$SSL_Seconds")
	elseIf option == oidStageTimerLeadIn[3]
		fStageTimerLeadIn[3] = value
		SetSliderOptionValue(oidStageTimerLeadIn[3], fStageTimerLeadIn[3], "$SSL_Seconds")
	elseIf option == oidStageTimerLeadIn[4]
		fStageTimerLeadIn[4] = value
		SetSliderOptionValue(oidStageTimerLeadIn[4], fStageTimerLeadIn[4], "$SSL_Seconds")

	elseIf option == oidStageTimerAggr[0]
		fStageTimerAggr[0] = value
		SetSliderOptionValue(oidStageTimerAggr[0], fStageTimerAggr[0], "$SSL_Seconds")
	elseIf option == oidStageTimerAggr[1]
		fStageTimerAggr[1] = value
		SetSliderOptionValue(oidStageTimerAggr[1], fStageTimerAggr[1], "$SSL_Seconds")
	elseIf option == oidStageTimerAggr[2]
		fStageTimerAggr[2] = value
		SetSliderOptionValue(oidStageTimerAggr[2], fStageTimerAggr[2], "$SSL_Seconds")
	elseIf option == oidStageTimerAggr[3]
		fStageTimerAggr[3] = value
		SetSliderOptionValue(oidStageTimerAggr[3], fStageTimerAggr[3], "$SSL_Seconds")
	elseIf option == oidStageTimerAggr[4]
		fStageTimerAggr[4] = value
		SetSliderOptionValue(oidStageTimerAggr[4], fStageTimerAggr[4], "$SSL_Seconds")
	endIf
endEvent

event OnOptionSelect(int option)
	{Called when the user selects a non-dialog option}

	; Settings
	if option == oidRestrictAggressive
		bRestrictAggressive = !bRestrictAggressive 
		SetToggleOptionValue(option, bRestrictAggressive)

	elseif option == oidForeplayStage
		bForeplayStage = !bForeplayStage 
		SetToggleOptionValue(option, bForeplayStage)

	; DEPRECATED for animation specific tcl's in v1.1
	; elseif option == oidEnableTCL
	; 	bEnableTCL = !bEnableTCL 
	; 	SetToggleOptionValue(option, bEnableTCL)

	elseif option == oidScaleActors
		bScaleActors = !bScaleActors
		SetToggleOptionValue(option, bScaleActors)

	elseif option == oidAutoAdvance
		bAutoAdvance = !bAutoAdvance 
		SetToggleOptionValue(option, bAutoAdvance)

	elseIf option == oidDisablePlayer
		bDisablePlayer = !bDisablePlayer 
		SetToggleOptionValue(option, bDisablePlayer)
		
	elseIf option == oidReDressVictim
		bReDressVictim = !bReDressVictim 
		SetToggleOptionValue(option, bReDressVictim)

	elseIf option == oidRagdollEnd
		bRagdollEnd = !bRagdollEnd 
		SetToggleOptionValue(option, bRagdollEnd)

	elseIf option == oidUndressAnimation
		bUndressAnimation = !bUndressAnimation 
		SetToggleOptionValue(option, bUndressAnimation)

	elseif option == oidNPCBed
		if sNPCBed == "$SSL_Never"
			sNPCBed = "$SSL_Sometimes"
		elseif sNPCBed == "$SSL_Sometimes"
			sNPCBed = "$SSL_Always"
		else
			sNPCBed = "$SSL_Never"
		endIf
		SetTextOptionValue(option, sNPCBed)

	elseif option == oidUseCum
		bUseCum = !bUseCum
		SetToggleOptionValue(option, bUseCum)

	elseif option == oidAllowFFCum
		bAllowFFCum = !bAllowFFCum
		SetToggleOptionValue(option, bAllowFFCum)

	elseif option == oidUseStrapons
		bUseStrapons = !bUseStrapons
		SetToggleOptionValue(option, bUseStrapons)

	elseif option == oidFindStrapons
		SexLab.Data.FindStrapons()
		int found = SexLab.Data.Strapons.Length
		if found > 0
			ShowMessage("$SSL_FoundStrapon", false)
		else
			ShowMessage("$SSL_NoStrapons", false)
		endIf
		ForcePageReset()
	elseif option == oidStopAnimations
		ShowMessage("$SSL_StopRunningAnimations", false)
		SexLab._StopAnimations()

	elseif option == oidCleanSystem
		bool run = ShowMessage("$SSL_WarnCleanSystem")
		if run
			ShowMessage("$SSL_RunCleanSystem", false)
			SexLab._CleanSystem()
		endIf

	elseif option == oidRebuildAnimations
		bool run = ShowMessage("$SSL_WarnRebuildAnimations")
		if run
			SexLab._StopAnimations()
			SexLab._ClearAnimations()
			SexLab.Data.LoadAnimations()
			ShowMessage("$SSL_RunRebuildAnimations", false)
		endIf

	elseif option == oidRebuildVoices
		bool run = ShowMessage("$SSL_WarnRebuildVoices")
		if run
			SexLab._ClearVoices()
			SexLab.Data.LoadVoices()
			ShowMessage("$SSL_RunRebuildVoices", false)
		endIf

	elseif option == oidResetStats
		bool run = ShowMessage("$SSL_WarnResetStats")
		if run
			SexLab.Data.fTimeSpent = 0.0
			SexLab.Data.fSexualPurity = 0.0
			SexLab.Data.iMalePartners = 0
			SexLab.Data.iFemalePartners = 0
			SexLab.Data.iMasturbationCount = 0
			SexLab.Data.iAnalCount = 0
			SexLab.Data.iVaginalCount = 0
			SexLab.Data.iOralCount = 0
			SexLab.Data.iVictimCount = 0
			SexLab.Data.iAggressorCount = 0
			ShowMessage("$SSL_RunResetStats", false)
		endIf

	elseif option == oidRestoreDefaults
		bool run = ShowMessage("$SSL_WarnRestoreDefaults")
		if run
			SetDefaults()			
			ShowMessage("$SSL_RunRestoreDefaults", false)
			ForcePageReset()
		endIf

	; Voice Settings
	elseif option == oidPlayerVoice
		sslBaseVoice voice
		form[] voices
		int gender = SexLab.PlayerRef.GetLeveledActorBase().GetSex()
		int current = SexLab.FindVoiceByName(sPlayerVoice)

		int i = 0
		while i < SexLab.voice.Length
			voice = SexLab.voice[i]
			if voice != none && voice.enabled && voice.gender == gender
				voices = sslUtility.PushForm(voice,voices)
			endIf
			i += 1
		endWhile

		i = 0
		if current != -1
			while i < voices.Length
				if (voices[i] as sslBaseVoice).name == SexLab.voice[current].name
					current = i
					i = voices.Length
				endIf
				i += 1
			endWhile
		endIf

		current += 1
		if current >= voices.Length
			current = -1
		endIf

		if current == -1
			sPlayerVoice = "$SSL_Random"
		else
			voice = voices[current] as sslBaseVoice
			sPlayerVoice = voice.name
		endIf
	
		SetTextOptionValue(oidPlayerVoice, sPlayerVoice)

	elseIf option == oidUseMaleNudeSuit
		bUseMaleNudesuit = !bUseMaleNudesuit 
		SetToggleOptionValue(option, bUseMaleNudesuit)

	elseIf option == oidUseFemaleNudeSuit
		bUseFemaleNudesuit = !bUseFemaleNudesuit 
		SetToggleOptionValue(option, bUseFemaleNudesuit)

	else
		; What are we?
		int i = 0
		while i < 128
			if option == oidToggleVoice[i]
				SexLab.voice[i].enabled = !SexLab.voice[i].enabled
				SetToggleOptionValue(option, SexLab.voice[i].enabled)
				i = 128
			elseif option == oidToggleAnimation[i]
				SexLab.animation[i].enabled = !SexLab.animation[i].enabled
				SetToggleOptionValue(option, SexLab.animation[i].enabled)
				i = 128
			elseif option == oidAggrAnimation[i]
				if !SexLab.animation[i].HasTag("Aggressive")
					SexLab.animation[i].AddTag("Aggressive")
				else
					SexLab.animation[i].RemoveTag("Aggressive")
				endIf
				SetToggleOptionValue(option, SexLab.animation[i].HasTag("Aggressive"))
				i = 128
			elseIf i < 33 && option == oidStripMale[i]
				bStripMale[i] = !bStripMale[i] 
				SetToggleOptionValue(option, bStripMale[i])
				i = 128
			elseIf i < 33 && option == oidStripFemale[i]
				bStripFemale[i] = !bStripFemale[i] 
				SetToggleOptionValue(option, bStripFemale[i])
				i = 128

			elseIf i < 33 && option == oidStripLeadInMale[i]
				bStripLeadInMale[i] = !bStripLeadInMale[i] 
				SetToggleOptionValue(option, bStripLeadInMale[i])
				i = 128
			elseIf i < 33 && option == oidStripLeadInFemale[i]
				bStripLeadInFemale[i] = !bStripLeadInFemale[i] 
				SetToggleOptionValue(option, bStripLeadInFemale[i])
				i = 128

			elseIf i < 33 && option == oidStripVictim[i]
				bStripVictim[i] = !bStripVictim[i] 
				SetToggleOptionValue(option, bStripVictim[i])
				i = 128
			elseIf i < 33 && option == oidStripAggressor[i]
				bStripAggressor[i] = !bStripAggressor[i] 
				SetToggleOptionValue(option, bStripAggressor[i])
				i = 128
			elseIf i < 10 && option == oidRemoveStrapon[i]
				form toRemove = SexLab.Data.strapons[i]
				form[] strapons = SexLab.Data.strapons
				form[] newStrapons
				int s = 0
				while s < strapons.Length
					if strapons[s] != toRemove
						newStrapons = sslUtility.PushForm(strapons[s], newStrapons)
					endIf
					s += 1
				endWhile
				SexLab.Data.strapons = newStrapons
				ForcePageReset()
				i = 128
			endIf

			i += 1
		endWhile
	endIf
endEvent

event OnOptionHighlight(int option)
	if option == oidRestrictAggressive
		SetInfoText("$SSL_InfoRestrictAggressive")
	elseIf option == oidUseCum
		SetInfoText("$SSL_InfoUseCum")
	elseIf option == oidAllowFFCum
		SetInfoText("$SSL_InfoAllowFFCum")
	elseIf option == oidCumTimer
		SetInfoText("$SSL_InfoCumTimer")
	elseIf option == oidUseStrapons
		SetInfoText("$SSL_InfoUseStrapons")
	elseIf option == oidAutoAdvance
		SetInfoText("$SSL_InfoAutoAdvance")
	elseIf option == oidDisablePlayer
		SetInfoText("$SSL_InfoDisablePlayer")
	elseIf option == oidReDressVictim
		SetInfoText("$SSL_InfoReDressVictim")
	elseIf option == oidNPCBed
		SetInfoText("$SSL_InfoNPCBed")
	elseIf option == oidUseMaleNudeSuit
		SetInfoText("$SSL_InfoMaleNudeSuit")
	elseIf option == oidUseFemaleNudeSuit
		SetInfoText("$SSL_InfoFemaleNudeSuit")
	elseIf option == oidBackwards
		SetInfoText("$SSL_InfoBackwards")
	elseIf option == oidAdvanceAnimation
		SetInfoText("$SSL_InfoAdvanceAnimation")
	elseIf option == oidChangeAnimation
		SetInfoText("$SSL_InfoChangeAnimation")
	elseIf option == oidChangePositions
		SetInfoText("$SSL_InfoChangePositions")
	elseIf option == oidRealignActors
		SetInfoText("$SSL_InfoRealignActors")
	elseIf option == oidAdjustChange
		SetInfoText("$SSL_InfoAdjustChange")
	elseIf option == oidRestoreOffsets
		SetInfoText("$SSL_InfoRestoreOffsets")
	elseIf option == oidAdjustForward
		SetInfoText("$SSL_InfoAdjustForward")
	elseIf option == oidAdjustSideways
		SetInfoText("$SSL_InfoAdjustSideways")
	elseIf option == oidAdjustUpward
		SetInfoText("$SSL_InfoAdjustUpward")
	elseIf option == oidPlayerVoice
		SetInfoText("$SSL_InfoPlayerVoice")
	elseIf option == oidMaleVoiceDelay
		SetInfoText("$SSL_InfoMaleVoiceDelay")
	elseIf option == oidFemaleVoiceDelay
		SetInfoText("$SSL_InfoFemaleVoiceDelay")
	elseIf option == oidSFXDelay
		SetInfoText("$SSL_InfoSFXDelay")
	elseIf option == oidVoiceVolume
		SetInfoText("$SSL_InfoVoiceVolume")
	elseIf option == oidSFXVolume
		SetInfoText("$SSL_InfoSFXVolume")
	; DEPRECATED for animation specific tcl's in v1.1
	; elseIf option == oidEnableTCL
	; 	SetInfoText("Collisions will be toggled automatically when the player is involved, helps align player but can cause other problems")
	elseIf option == oidScaleActors
		SetInfoText("$SSL_InfoScaleActors")
	elseIf option == oidRagdollEnd
		SetInfoText("$SSL_InfoRagdollEnd")
	elseIf option == oidMoveScene
		SetInfoText("$SSL_InfoMoveScene")
	elseIf option == oidRotateScene
		SetInfoText("$SSL_InfoRotateScene")
	elseIf option == oidUndressAnimation
		SetInfoText("$SSL_InfoUndressAnimation")
	else
		; What are we?
		int i = 0
		while i < 128
			if option == oidToggleVoice[i]
				SetInfoText("$SSL_EnableVoice")
				i = 128
			elseif option == oidToggleAnimation[i]
				SetInfoText("$SSL_EnableAnimation")
				i = 128
			elseif option == oidAggrAnimation[i]
				SetInfoText("$SSL_ToggleAggressive")
				i = 128
			elseIf i < 33 && option == oidStripMale[i]
				if i != 32
					SetInfoText("$SSL_StripMale")
				else
					SetInfoText("$SSL_StripMaleWeapon")
				endIf
				i = 128
			elseIf i < 33 && option == oidStripFemale[i]
				if i != 32
					SetInfoText("$SSL_StripFemale")
				else
					SetInfoText("$SSL_StripFemaleWeapon")
				endIf
				i = 128

			elseIf i < 33 && option == oidStripLeadInFemale[i]
				if i != 32
					SetInfoText("$SSL_StripLeadInFemale")
				else
					SetInfoText("$SSL_StripLeadInFemaleWeapon")
				endIf
				i = 128
			elseIf i < 33 && option == oidStripLeadInMale[i]
				if i != 32
					SetInfoText("$SSL_StripLeadInMale")
				else
					SetInfoText("$SSL_StripLeadInMaleWeapon")
				endIf
				i = 128

			elseIf i < 33 && option == oidStripVictim[i]
				if i != 32
					SetInfoText("$SSL_StripVictim")
				else
					SetInfoText("$SSL_StripVictimWeapon")
				endIf
				i = 128
			elseIf i < 33 && option == oidStripAggressor[i]
				if i != 32
					SetInfoText("$SSL_StripAggressor")
				else
					SetInfoText("$SSL_StripAggressorWeapon")
				endIf
				i = 128
			endIf

			i += 1
		endWhile
	endIf
endEvent
;#---------------------------#
;#   END Option Adjustment   #
;#---------------------------#


;#---------------------------#
;#      Map Control Key      #
;#---------------------------#

event OnOptionKeyMapChange(int option, int keyCode, string conflictControl, string conflictName)
	bool continue = true

	; Check for conflict
	if conflictControl != ""
		string msg
		if conflictName != ""
			msg = "This key is already mapped to:\n'" + conflictControl + "'\n(" + conflictName + ")\n\nAre you sure you want to continue?"
		else
			msg = "This key is already mapped to:\n'" + conflictControl + "'\n\nAre you sure you want to continue?"
		endIf
		continue = ShowMessage(msg, true, "$Yes", "$No")
	endIf

	; Set allowed key change
	if continue
		if option == oidAdvanceAnimation
			kAdvanceAnimation = keyCode

		elseIf option == oidChangeAnimation
			kChangeAnimation = keyCode

		elseIf option == oidChangePositions
			kChangePositions = keyCode

		elseIf option == oidRealignActors
			kRealignActors = keyCode

		elseIf option == oidAdjustChange
			kAdjustChange = keyCode

		elseIf option == oidAdjustForward
			kAdjustForward = keyCode

		elseIf option == oidAdjustSideways
			kAdjustSideways = keyCode

		elseIf option == oidAdjustUpward
			kAdjustUpward = keyCode

		elseIf option == oidRestoreOffsets
			kRestoreOffsets = keyCode

		elseIf option == oidMoveScene
			kMoveScene = keyCode

		elseIf option == oidRotateScene
			kRotateScene = keyCode

		endIf

		; Set MCM value
		SetKeymapOptionValue(option, keyCode)
	endIf
endEvent
;#---------------------------#
;#    END Map Control Key    #
;#---------------------------#

string function GetSlotName(int slot)
	if slot == 30
		return "$SSL_Head"
	elseif slot == 31
		return "$SSL_Hair"
	elseif slot == 32
		return "$SSL_Torso"
	elseif slot == 33
		return "$SSL_Hands"
	elseif slot == 34
		return "$SSL_Forearms"
	elseif slot == 35
		return "$SSL_Amulet"
	elseif slot == 36
		return "$SSL_Ring"
	elseif slot == 37
		return "$SSL_Feet"
	elseif slot == 38
		return "$SSL_Calves"
	elseif slot == 39
		return "$SSL_Shield"
	elseif slot == 40
		return "$SSL_Tail"
	elseif slot == 41
		return "$SSL_LongHair"
	elseif slot == 42
		return "$SSL_Circlet"
	elseif slot == 43
		return "$SSL_Ears"
	elseif slot == 44
		return "$SSL_FaceMouth"
	elseif slot == 45
		return "$SSL_Neck"
	elseif slot == 46
		return "$SSL_Chest"
	elseif slot == 47
		return "$SSL_Back"
	elseif slot == 48
		return "$SSL_Misc"
	elseif slot == 49
		return "$SSL_PelvisOutergarnments"
	elseif slot == 50
		return "IGNORE" ; decapitated head [NordRace]
	elseif slot == 51
		return "IGNORE" ; decapitate [NordRace]
	elseif slot == 52
		return "$SSL_PelvisUndergarnments"
	elseif slot == 53
		return "$SSL_LegsRightLeg"
	elseif slot == 54
		return "$SSL_LegsLeftLeg"
	elseif slot == 55
		return "$SSL_FaceJewelry"
	elseif slot == 56
		return "$SSL_ChestUndergarnments"
	elseif slot == 57
		return "$SSL_Shoulders"
	elseif slot == 58
		return "$SSL_ArmsLeftArmUndergarnments"
	elseif slot == 59
		return "$SSL_ArmsRightArmOutergarnments"
	elseif slot == 60
		return "$SSL_MiscSlot"
	elseif slot == 61
		return "$SSL_MiscSlot"
	elseif slot == 62
		return "$SSL_Weapons"
	else
		return "$SSL_Unknown"
	endIf
endFunction

