scriptname sslConfigMenu extends SKI_ConfigBase
{Skyrim SexLab Mod Configuration Menu}

int function GetVersion()
	return 14000
endFunction

string function GetStringVer()
	return StringUtil.Substring(((GetVersion() as float / 10000.0) as string), 0, 4)
endFunction

event OnVersionUpdate(int version)

endEvent

event OnConfigInit()
	; Init System
	SetupSystem()
	; Init Stats
	; Stats._Setup()
	SetDefaults()
endEvent

event OnGameReload()
	parent.OnGameReload()
	; Configure SFX & Voice volumes
	AudioVoice.SetVolume(Config.fVoiceVolume)
	AudioSFX.SetVolume(Config.fSFXVolume)
	; Debug reset
	AnimSlots.Setup()
endEvent

; Framework
SexLabFramework property SexLab auto hidden
sslSystemConfig property Config auto hidden
; Libraries
sslActorLibrary property ActorLib auto hidden
sslThreadLibrary property ThreadLib auto hidden
sslActorStats property Stats auto hidden
; Object Registeries
sslAnimationSlots property AnimSlots auto hidden
sslCreatureAnimationSlots property CreatureSlots auto hidden
sslVoiceSlots property VoiceSlots auto hidden
sslThreadSlots property ThreadSlots auto hidden

; Data
Actor property PlayerRef auto
Armor property CalypsStrapon auto
SoundCategory property AudioSFX auto
SoundCategory property AudioVoice auto

Message property OldSkyrim auto
Message property OldSKSE auto
Message property NoSKSE auto
; message property mCleanSystemFinish auto
; message property mSystemDisabled auto
; message property mSystemUpdated auto
; spell property SexLabDebugSpell auto
; spell property SexLabDebugSelfSpell auto


; OIDs
int[] oidStageTimer
int[] oidStageTimerLeadIn
int[] oidStageTimerAggr
int[] oidStripMale
int[] oidStripFemale
int[] oidStripLeadInFemale
int[] oidStripLeadInMale
int[] oidStripVictim
int[] oidStripAggressor
int[] oidToggleVoice
int[] oidToggleAnimation
int[] oidToggleCreatureAnimation
int[] oidToggleExpressionNormal
int[] oidToggleExpressionVictim
int[] oidToggleExpressionAggressor
int[] oidAggrAnimation
int[] oidForeplayAnimation
int[] oidRemoveStrapon

function SetDefaults()
	Config.SetDefaults()

	AudioVoice.SetVolume(Config.fVoiceVolume)
	AudioSFX.SetVolume(Config.fSFXVolume)

	oidToggleVoice = new int[50]
	oidToggleCreatureAnimation = new int[50]
	oidToggleAnimation = new int[100]
	oidAggrAnimation = new int[100]
	oidForeplayAnimation = new int[100]
	oidToggleExpressionNormal = new int[40]
	oidToggleExpressionVictim = new int[40]
	oidToggleExpressionAggressor = new int[40]

	oidStripMale = new int[33]
	oidStripFemale = new int[33]
	oidStripLeadInFemale = new int[33]
	oidStripLeadInMale = new int[33]
	oidStripVictim = new int[33]
	oidStripAggressor = new int[33]

	oidStageTimer = new int[5]
	oidStageTimerLeadIn = new int[5]
	oidStageTimerAggr = new int[5]

	oidRemoveStrapon = new int[10]

	Pages = new string[13]
	Pages[0] = "$SSL_AnimationSettings"
	Pages[1] = "$SSL_SoundSettings"
	Pages[2] = "$SSL_PlayerHotkeys"
	Pages[3] = "$SSL_NormalTimersStripping"
	Pages[4] = "$SSL_ForeplayTimersStripping"
	Pages[5] = "$SSL_AggressiveTimersStripping"
	Pages[6] = "$SSL_ToggleAnimations"
	Pages[7] = "$SSL_ForeplayAnimations"
	Pages[8] = "$SSL_AggressiveAnimations"
	Pages[9] = "$SSL_CreatureAnimations"
	Pages[10] = "$SSL_ExpressionSelection"
	if PlayerRef.GetLeveledActorBase().GetSex() == 1
		Pages[11] = "$SSL_SexDiary"
	else
		Pages[11] = "$SSL_SexJournal"
	endIf
	Pages[12] = "$SSL_RebuildClean"

	FindStrapons()
endFunction

function SetupSystem()
	; Wait until out of menus to setup
	while Utility.IsInMenuMode() || !PlayerRef.Is3DLoaded()
		Utility.Wait(1.0)
	endWhile
	; Grab properties to make sure they are all set properly
	SexLab        = Quest.GetQuest("SexLabQuestFramework") as SexLabFramework
	Config        = Quest.GetQuest("SexLabQuestFramework") as sslSystemConfig
	ActorLib      = Quest.GetQuest("SexLabQuestFramework") as sslActorLibrary
	ThreadLib     = Quest.GetQuest("SexLabQuestFramework") as sslThreadLibrary
	Stats         = Quest.GetQuest("SexLabQuestFramework") as sslActorStats
	ThreadSlots   = Quest.GetQuest("SexLabQuestFramework") as sslThreadSlots
	AnimSlots     = Quest.GetQuest("SexLabQuestAnimations") as sslAnimationSlots
	CreatureSlots = Quest.GetQuest("SexLabQuestCreatureAnimations") as sslCreatureAnimationSlots
	VoiceSlots    = Quest.GetQuest("SexLabQuestRegistry") as sslVoiceSlots
	; Init Defaults
	SexLab.Initialize()
	CheckSystem()
	SetDefaults()
	; Setup Libraries
	ActorLib.Setup()
	ThreadLib.Setup()
	Stats.Setup()
	; Setup Slots
	ThreadSlots.Setup()
	AnimSlots.Setup()
	CreatureSlots.Setup()
	VoiceSlots.Setup()
	; Finished
	Debug.Notification("$SSL_SexLabUpdated")
endFunction

event OnPageReset(string page)
	int i

	; Logo
	if page == ""
		LoadCustomContent("SexLab/logo.dds", 184, 31)
		return
	endIf
	UnloadCustomContent()

	; Animation Settings
	if page == "$SSL_AnimationSettings"
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("$SSL_PlayerSettings")
		AddToggleOptionST("AutoAdvance","$SSL_AutoAdvanceStages", Config.bAutoAdvance)
		AddToggleOptionST("DisableVictim","$SSL_DisableVictimControls", Config.bDisablePlayer)
		AddToggleOptionST("AutomaticTFC","$SSL_AutomaticTFC", Config.bAutoTFC)
		AddSliderOptionST("AutomaticSUCSM","$SSL_AutomaticSUCSM", Config.fAutoSUCSM, "{0}")

		AddHeaderOption("$SSL_ExtraEffects")
		AddToggleOptionST("ScaleActors","$SSL_EvenActorsHeight", Config.bScaleActors)
		AddToggleOptionST("ReDressVictim","$SSL_VictimsRedress", Config.bReDressVictim)
		AddToggleOptionST("UseCum","$SSL_ApplyCumEffects", Config.bUseCum)
		AddToggleOptionST("AllowFemaleFemaleCum","$SSL_AllowFemaleFemaleCum", Config.bAllowFFCum)
		AddSliderOptionST("CumEffectTimer","$SSL_CumEffectTimer", Config.fCumTimer, "$SSL_Seconds")
		AddToggleOptionST("OrgasmEffects","$SSL_OrgasmEffects", Config.bOrgasmEffects)

		SetCursorPosition(1)
		AddHeaderOption("$SSL_AnimationHandling")
		AddToggleOptionST("AllowCreatures","$SSL_AllowCreatures", Config.bAllowCreatures)
		AddToggleOptionST("RagdollEnd","$SSL_RagdollEnding", Config.bRagdollEnd)
		AddToggleOptionST("ForeplayStage","$SSL_PreSexForeplay", Config.bForeplayStage)
		AddToggleOptionST("RestrictAggressive","$SSL_RestrictAggressive", Config.bRestrictAggressive)
		AddToggleOptionST("UndressAnimation","$SSL_UndressAnimation", Config.bUndressAnimation)
		AddToggleOptionST("StraponsFemale","$SSL_FemalesUseStrapons", Config.bUseStrapons)
		AddToggleOptionST("NudeSuitMales","$SSL_UseNudeSuitMales", Config.bUseMaleNudeSuit)
		AddToggleOptionST("NudeSuitFemales","$SSL_UseNudeSuitFemales", Config.bUseFemaleNudeSuit)
		AddTextOptionST("NPCBed","$SSL_NPCsUseBeds", Config.sNPCBed)

	; Player Diary/Journal
	elseIf page == "$SSL_SexDiary" || page == "$SSL_SexJournal"
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption("$SSL_SexualExperience")
		AddTextOption("$SSL_TimeSpentHavingSex", Stats.ParseTime(Stats.GetFloat(PlayerRef, "TimeSpent") as int))
		AddTextOption("$SSL_TimeSinceLastSex", Stats.LastSexTimerString(PlayerRef))
		AddTextOption("$SSL_MaleSexualPartners", Stats.GetInt(PlayerRef, "Males"))
		AddTextOption("$SSL_FemaleSexualPartners", Stats.GetInt(PlayerRef, "Females"))
		AddTextOption("$SSL_CreatureSexualPartners", Stats.GetInt(PlayerRef, "Creatures"))
		AddTextOption("$SSL_TimesMasturbated", Stats.GetInt(PlayerRef, "Masturbation"))
		AddTextOption("$SSL_VaginalExperience", Stats.GetInt(PlayerRef, "Vaginal"))
		AddTextOption("$SSL_AnalExperience", Stats.GetInt(PlayerRef, "Anal"))
		AddTextOption("$SSL_OralExperience", Stats.GetInt(PlayerRef, "Oral"))
		AddTextOption("$SSL_TimesVictim", Stats.GetInt(PlayerRef, "Victim"))
		AddTextOption("$SSL_TimesAggressive", Stats.GetInt(PlayerRef, "Aggressor"))

		SetCursorPosition(1)
		AddHeaderOption("$SSL_SexualStats")
		AddTextOption("$SSL_Sexuality", Stats.GetSexualityTitle(PlayerRef))
		AddTextOption("$SSL_SexualPurity", Stats.GetPureLevel(PlayerRef))
		AddTextOption("$SSL_SexualPerversion", Stats.GetImpureLevel(PlayerRef))
		AddTextOption("$SSL_VaginalProficiency", Stats.GetSkillTitle(PlayerRef, "Vaginal"))
		AddTextOption("$SSL_AnalProficiency", Stats.GetSkillTitle(PlayerRef, "Anal"))
		AddTextOption("$SSL_OralProficiency", Stats.GetSkillTitle(PlayerRef, "Oral"))
		AddEmptyOption()
	endIf

endEvent

state AutoAdvance
	event OnSelectST()
		Config.bAutoAdvance = !Config.bAutoAdvance
		SetToggleOptionValueST(Config.bAutoAdvance)
	endEvent
	event OnDefaultST()
		Config.bAutoAdvance = false
		SetToggleOptionValueST(Config.bAutoAdvance)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAutoAdvance")
	endEvent
endState
state DisableVictim
	event OnSelectST()
		Config.bDisablePlayer = !Config.bDisablePlayer
		SetToggleOptionValueST(Config.bDisablePlayer)
	endEvent
	event OnDefaultST()
		Config.bDisablePlayer = false
		SetToggleOptionValueST(Config.bDisablePlayer)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoDisablePlayer")
	endEvent
endState
state AutomaticTFC
	event OnSelectST()
		Config.bAutoTFC = !Config.bAutoTFC
		SetToggleOptionValueST(Config.bAutoTFC)
	endEvent
	event OnDefaultST()
		Config.bAutoTFC = false
		SetToggleOptionValueST(Config.bAutoTFC)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAutomaticTFC")
	endEvent
endState
state AutomaticSUCSM
	event OnSliderOpenST()
		SetSliderDialogStartValue(Config.fAutoSUCSM)
		SetSliderDialogDefaultValue(3.0)
		SetSliderDialogRange(1.0, 20.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		Config.fAutoSUCSM = value
		SetSliderOptionValueST(Config.fAutoSUCSM, "{0}")
	endEvent
	event OnDefaultST()
		Config.fAutoSUCSM = 5.0
		SetToggleOptionValueST(Config.fAutoSUCSM, "{0}")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAutomaticSUCSM")
	endEvent
endState

state ScaleActors
	event OnSelectST()
		Config.bScaleActors = !Config.bScaleActors
		SetToggleOptionValueST(Config.bScaleActors)
	endEvent
	event OnDefaultST()
		Config.bScaleActors = true
		SetToggleOptionValueST(Config.bScaleActors)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoScaleActors")
	endEvent
endState
state ReDressVictim
	event OnSelectST()
		Config.bReDressVictim = !Config.bReDressVictim
		SetToggleOptionValueST(Config.bReDressVictim)
	endEvent
	event OnDefaultST()
		Config.bReDressVictim = true
		SetToggleOptionValueST(Config.bReDressVictim)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoReDressVictim")
	endEvent
endState
state UseCum
	event OnSelectST()
		Config.bUseCum = !Config.bUseCum
		SetToggleOptionValueST(Config.bUseCum)
	endEvent
	event OnDefaultST()
		Config.bUseCum = true
		SetToggleOptionValueST(Config.bUseCum)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoUseCum")
	endEvent
endState
state AllowFemaleFemaleCum
	event OnSelectST()
		Config.bAllowFFCum = !Config.bAllowFFCum
		SetToggleOptionValueST(Config.bAllowFFCum)
	endEvent
	event OnDefaultST()
		Config.bAllowFFCum = false
		SetToggleOptionValueST(Config.bAllowFFCum)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAllowFFCum")
	endEvent
endState
state CumEffectTimer
	event OnSliderOpenST()
		SetSliderDialogStartValue(Config.fCumTimer)
		SetSliderDialogDefaultValue(120.0)
		SetSliderDialogRange(5.0, 900.0)
		SetSliderDialogInterval(5.0)
	endEvent
	event OnSliderAcceptST(float value)
		Config.fCumTimer = value
		SetSliderOptionValueST(Config.fCumTimer, "$SSL_Seconds")
	endEvent
	event OnDefaultST()
		Config.fCumTimer = 120.0
		SetToggleOptionValueST(Config.fCumTimer, "$SSL_Seconds")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoCumTimer")
	endEvent
endState
state OrgasmEffects
	event OnSelectST()
		Config.bOrgasmEffects = !Config.bOrgasmEffects
		SetToggleOptionValueST(Config.bOrgasmEffects)
	endEvent
	event OnDefaultST()
		Config.bOrgasmEffects = true
		SetToggleOptionValueST(Config.bOrgasmEffects)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoOrgasmEffects")
	endEvent
endState

state AllowCreatures
	event OnSelectST()
		Config.bAllowCreatures = !Config.bAllowCreatures
		SetToggleOptionValueST(Config.bAllowCreatures)
	endEvent
	event OnDefaultST()
		Config.bAllowCreatures = false
		SetToggleOptionValueST(Config.bAllowCreatures)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAllowCreatures")
	endEvent
endState
state RagdollEnd
	event OnSelectST()
		Config.bRagdollEnd = !Config.bRagdollEnd
		SetToggleOptionValueST(Config.bRagdollEnd)
	endEvent
	event OnDefaultST()
		Config.bRagdollEnd = false
		SetToggleOptionValueST(Config.bRagdollEnd)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoRagdollEnd")
	endEvent
endState
state ForeplayStage
	event OnSelectST()
		Config.bForeplayStage = !Config.bForeplayStage
		SetToggleOptionValueST(Config.bForeplayStage)
	endEvent
	event OnDefaultST()
		Config.bForeplayStage = true
		SetToggleOptionValueST(Config.bForeplayStage)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoForeplayStage")
	endEvent
endState
state RestrictAggressive
	event OnSelectST()
		Config.bRestrictAggressive = !Config.bRestrictAggressive
		SetToggleOptionValueST(Config.bRestrictAggressive)
	endEvent
	event OnDefaultST()
		Config.bRestrictAggressive = true
		SetToggleOptionValueST(Config.bRestrictAggressive)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoRestrictAggressive")
	endEvent
endState
state UndressAnimation
	event OnSelectST()
		Config.bUndressAnimation = !Config.bUndressAnimation
		SetToggleOptionValueST(Config.bUndressAnimation)
	endEvent
	event OnDefaultST()
		Config.bUndressAnimation = false
		SetToggleOptionValueST(Config.bUndressAnimation)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoUndressAnimation")
	endEvent
endState
state StraponsFemale
	event OnSelectST()
		Config.bUseStrapons = !Config.bUseStrapons
		SetToggleOptionValueST(Config.bUseStrapons)
	endEvent
	event OnDefaultST()
		Config.bUseStrapons = true
		SetToggleOptionValueST(Config.bUseStrapons)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoUseStrapons")
	endEvent
endState
state NudeSuitMales
	event OnSelectST()
		Config.bUseMaleNudeSuit = !Config.bUseMaleNudeSuit
		SetToggleOptionValueST(Config.bUseMaleNudeSuit)
	endEvent
	event OnDefaultST()
		Config.bUseMaleNudeSuit = false
		SetToggleOptionValueST(Config.bUseMaleNudeSuit)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoMaleNudeSuit")
	endEvent
endState
state NudeSuitFemales
	event OnSelectST()
		Config.bUseFemaleNudeSuit = !Config.bUseFemaleNudeSuit
		SetToggleOptionValueST(Config.bUseFemaleNudeSuit)
	endEvent
	event OnDefaultST()
		Config.bUseFemaleNudeSuit = false
		SetToggleOptionValueST(Config.bUseFemaleNudeSuit)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoFemaleNudeSuit")
	endEvent
endState
state NPCBed
	event OnSelectST()
		if Config.sNPCBed == "$SSL_Never"
			Config.sNPCBed = "$SSL_Sometimes"
		elseif Config.sNPCBed == "$SSL_Sometimes"
			Config.sNPCBed = "$SSL_Always"
		else
			Config.sNPCBed = "$SSL_Never"
		endIf
		SetTextOptionValueST(Config.sNPCBed)
	endEvent
	event OnDefaultST()
		Config.sNPCBed = "$SSL_Never"
		SetTextOptionValueST(Config.sNPCBed)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoNPCBed")
	endEvent
endState



function FindStrapons()
	ActorLib.Strapons = new form[1]
	ActorLib.Strapons[0] = CalypsStrapon
	int i = Game.GetModCount()
	while i
		i -= 1
		string Name = Game.GetModName(i)
		if Name == "StrapOnbyaeonv1.1.esp"
			ActorLib.LoadStrapon("StrapOnbyaeonv1.1.esp", 0x0D65)
		elseif Name == "TG.esp"
			ActorLib.LoadStrapon("TG.esp", 0x0182B)
		elseif Name == "Futa equippable.esp"
			ActorLib.LoadStrapon("Futa equippable.esp", 0x0D66)
			ActorLib.LoadStrapon("Futa equippable.esp", 0x0D67)
			ActorLib.LoadStrapon("Futa equippable.esp", 0x01D96)
			ActorLib.LoadStrapon("Futa equippable.esp", 0x022FB)
			ActorLib.LoadStrapon("Futa equippable.esp", 0x022FC)
			ActorLib.LoadStrapon("Futa equippable.esp", 0x022FD)
		elseif Name == "Skyrim_Strap_Ons.esp"
			ActorLib.LoadStrapon("Skyrim_Strap_Ons.esp", 0x00D65)
			ActorLib.LoadStrapon("Skyrim_Strap_Ons.esp", 0x02859)
			ActorLib.LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285A)
			ActorLib.LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285B)
			ActorLib.LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285C)
			ActorLib.LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285D)
			ActorLib.LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285E)
			ActorLib.LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285F)
		elseif Name == "SOS Equipable Schlong.esp"
			ActorLib.LoadStrapon("SOS Equipable Schlong.esp", 0x0D62)
		endif
	endWhile
endFunction

function CheckSystem()
	; Check SKSE Version
	float skseNeeded = 1.0616
	float skseInstalled = SKSE.GetVersion() + SKSE.GetVersionMinor() * 0.01 + SKSE.GetVersionBeta() * 0.0001
	if skseInstalled == 0
		NoSKSE.Show()
		SexLab.EnableSystem(false)
	elseif skseInstalled < skseNeeded
		OldSKSE.Show(skseInstalled, skseNeeded)
		SexLab.EnableSystem(false)
	endIf
	; Check Skyrim Version
	float skyrimNeeded = 1.9
	float skyrimMajor = StringUtil.SubString(Debug.GetVersionNumber(), 0, 3) as float
	if skyrimMajor < skyrimNeeded
		OldSkyrim.Show(skyrimMajor, skyrimNeeded)
		SexLab.EnableSystem(false)
	endIf
endFunction

event OnRaceSwitchComplete()
	StorageUtil.FormListClear(ActorLib, "SexLab.ValidActors")
	if Pages.Length > 0
		if PlayerRef.GetLeveledActorBase().GetSex() == 1
			Pages[11] = "$SSL_SexDiary"
		else
			Pages[11] = "$SSL_SexJournal"
		endIf
	endIf
endEvent
