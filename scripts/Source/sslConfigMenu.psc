scriptname sslConfigMenu extends SKI_ConfigBase
{Skyrim SexLab Mod Configuration Menu}

int function GetVersion()
	return 14200
endFunction

string function GetStringVer()
	return StringUtil.Substring(((GetVersion() as float / 10000.0) as string), 0, 4)+" Alpha 2"
endFunction

event OnVersionUpdate(int version)
	if CurrentVersion < GetVersion() && CurrentVersion > 1
		Debug.Notification("Updating SexLab to v"+GetStringVer())
		SetupSystem()
	endIf
endEvent

event OnConfigInit()
	; Init System
	SetupSystem()
	; Init Stats
	Stats.Setup()
endEvent

event OnGameReload()
	parent.OnGameReload()
	; Configure SFX & Voice volumes
	AudioVoice.SetVolume(Config.fVoiceVolume)
	AudioSFX.SetVolume(Config.fSFXVolume)
	; Check system
	CheckSystem()
	; TFC Toggle key
	Config.ToggleFreeCameraEnable()
	; ALPHA DEBUG:
	Config.SetDebugMode(true)
	SetupSystem()
endEvent

; Framework
SexLabFramework SexLab
sslSystemConfig Config
; Libraries
sslActorLibrary ActorLib
sslThreadLibrary ThreadLib
sslActorStats Stats
; Object Registeries
sslAnimationSlots AnimSlots
sslCreatureAnimationSlots CreatureSlots
sslThreadSlots ThreadSlots
sslVoiceSlots VoiceSlots
sslExpressionSlots ExpressionSlots

; Data
Actor property PlayerRef auto
Armor property CalypsStrapon auto
SoundCategory property AudioSFX auto
SoundCategory property AudioVoice auto

Message property OldSkyrim auto
Message property OldSKSE auto
Message property NoSKSE auto
Message property CleanSystemFinish auto
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
; int[] oidToggleExpressionNormal
; int[] oidToggleExpressionVictim
; int[] oidToggleExpressionAggressor
int[] oidAggrAnimation
int[] oidForeplayAnimation
int[] oidRemoveStrapon

string[] SlotNames

function SetDefaults()
	Config.SetDefaults()

	AudioVoice.SetVolume(Config.fVoiceVolume)
	AudioSFX.SetVolume(Config.fSFXVolume)

	oidToggleVoice = new int[75]
	oidToggleCreatureAnimation = new int[75]
	oidToggleAnimation = new int[125]
	oidAggrAnimation = new int[125]
	oidForeplayAnimation = new int[125]
	; oidToggleExpressionNormal = new int[40]
	; oidToggleExpressionVictim = new int[40]
	; oidToggleExpressionAggressor = new int[40]

	; oidStripMale = new int[33]
	; oidStripFemale = new int[33]
	; oidStripLeadInFemale = new int[33]
	; oidStripLeadInMale = new int[33]
	; oidStripVictim = new int[33]
	; oidStripAggressor = new int[33]

	oidStageTimer = new int[5]
	oidStageTimerLeadIn = new int[5]
	oidStageTimerAggr = new int[5]

	oidRemoveStrapon = new int[10]

	SlotNames = new string[33]
	SlotNames[0] = "$SSL_Head"
	SlotNames[1] = "$SSL_Hair"
	SlotNames[2] = "$SSL_Torso"
	SlotNames[3] = "$SSL_Hands"
	SlotNames[4] = "$SSL_Forearms"
	SlotNames[5] = "$SSL_Amulet"
	SlotNames[6] = "$SSL_Ring"
	SlotNames[7] = "$SSL_Feet"
	SlotNames[8] = "$SSL_Calves"
	SlotNames[9] = "$SSL_Shield"
	SlotNames[10] = "$SSL_Tail"
	SlotNames[11] = "$SSL_LongHair"
	SlotNames[12] = "$SSL_Circlet"
	SlotNames[13] = "$SSL_Ears"
	SlotNames[14] = "$SSL_FaceMouth"
	SlotNames[15] = "$SSL_Neck"
	SlotNames[16] = "$SSL_Chest"
	SlotNames[17] = "$SSL_Back"
	SlotNames[18] = "$SSL_MiscSlot48"
	SlotNames[19] = "$SSL_PelvisOutergarnments"
	SlotNames[20] = "" ; decapitated head [NordRace]
	SlotNames[21] = "" ; decapitate [NordRace]
	SlotNames[22] = "$SSL_PelvisUndergarnments"
	SlotNames[23] = "$SSL_LegsRightLeg"
	SlotNames[24] = "$SSL_LegsLeftLeg"
	SlotNames[25] = "$SSL_FaceJewelry"
	SlotNames[26] = "$SSL_ChestUndergarnments"
	SlotNames[27] = "$SSL_Shoulders"
	SlotNames[28] = "$SSL_ArmsLeftArmUndergarnments"
	SlotNames[29] = "$SSL_ArmsRightArmOutergarnments"
	SlotNames[30] = "$SSL_MiscSlot60"
	SlotNames[31] = "$SSL_MiscSlot61"
	SlotNames[32] = "$SSL_Weapons"

	Pages = new string[12]
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
	; Pages[10] = "$SSL_ExpressionSelection"
	if PlayerRef.GetLeveledActorBase().GetSex() == 1
		Pages[10] = "$SSL_SexDiary"
	else
		Pages[10] = "$SSL_SexJournal"
	endIf
	Pages[11] = "$SSL_RebuildClean"

	FindStrapons()
endFunction

function SetupSystem()
	; Wait until out of menus to setup
	while Utility.IsInMenuMode() || !PlayerRef.Is3DLoaded()
		Utility.Wait(1.0)
	endWhile
	; Grab libraries to make sure they are all set properly
	Quest SexLabQuestFramework  = Quest.GetQuest("SexLabQuestFramework")
	Config          = SexLabQuestFramework as sslSystemConfig
	ActorLib        = SexLabQuestFramework as sslActorLibrary
	ThreadLib       = SexLabQuestFramework as sslThreadLibrary
	Stats           = SexLabQuestFramework as sslActorStats
	ThreadSlots     = SexLabQuestFramework as sslThreadSlots
	Quest SexLabQuestAnimations = Quest.GetQuest("SexLabQuestAnimations")
	AnimSlots       = SexLabQuestAnimations as sslAnimationSlots
	Quest SexLabQuestRegistry   = Quest.GetQuest("SexLabQuestRegistry")
	CreatureSlots   = SexLabQuestRegistry as sslCreatureAnimationSlots
	VoiceSlots      = SexLabQuestRegistry as sslVoiceSlots
	ExpressionSlots = SexLabQuestRegistry as sslExpressionSlots
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

string function GetSlotName(int slot)
	return SlotNames[(slot - 30)]
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

	; Sound Settings
	elseIf page == "$SSL_SoundSettings"
		SetCursorFillMode(LEFT_TO_RIGHT)
		; Voices & SFX
		AddTextOptionST("PlayerVoice","$SSL_PCVoice", VoiceSlots.GetSavedName(PlayerRef))
		AddToggleOptionST("NPCSaveVoice","$SSL_NPCSaveVoice", Config.bNPCSaveVoice)
		AddSliderOptionST("SFXVolume","$SSL_SFXVolume", (Config.fSFXVolume * 100), "{0}%")
		AddSliderOptionST("VoiceVolume","$SSL_VoiceVolume", (Config.fVoiceVolume * 100), "{0}%")
		AddSliderOptionST("SFXDelay","$SSL_SFXDelay", Config.fSFXDelay, "$SSL_Seconds")
		AddSliderOptionST("MaleVoiceDelay","$SSL_MaleVoiceDelay", Config.fMaleVoiceDelay, "$SSL_Seconds")
		AddEmptyOption()
		AddSliderOptionST("FemaleVoiceDelay","$SSL_FemaleVoiceDelay", Config.fFemaleVoiceDelay, "$SSL_Seconds")

		; Toggle Voices
		AddHeaderOption("$SSL_ToggleVoices")
		AddHeaderOption("")
		i = 0
		while i < VoiceSlots.Slotted
			if VoiceSlots.Voices[i].Registered
				oidToggleVoice[i] = AddToggleOption(VoiceSlots.Voices[i].Name, VoiceSlots.Voices[i].Enabled)
			endIf
			i += 1
		endWhile

	; Hotkey selection & config
	elseIf page == "$SSL_PlayerHotkeys"
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption("$SSL_AlignmentAdjustments")
		AddKeyMapOptionST("AdjustStage","$SSL_AdjustStage", Config.kAdjustStage)
		AddKeyMapOptionST("AdjustChange","$SSL_ChangeActorBeingMoved", Config.kAdjustChange)
		AddKeyMapOptionST("AdjustForward","$SSL_MoveActorForwardBackward", Config.kAdjustForward)
		AddKeyMapOptionST("AdjustUpward","$SSL_AdjustPositionUpwardDownward", Config.kAdjustUpward)
		AddKeyMapOptionST("AdjustSideways","$SSL_MoveActorLeftRight", Config.kAdjustSideways)
		AddKeyMapOptionST("RotateScene", "$SSL_RotateScene", Config.kRotateScene)
		AddKeyMapOptionST("RestoreOffsets","$SSL_DeleteSavedAdjustments", Config.kRestoreOffsets)

		SetCursorPosition(1)

		AddHeaderOption("$SSL_SceneManipulation")
		AddKeyMapOptionST("RealignActors","$SSL_RealignActors", Config.kRealignActors)
		AddKeyMapOptionST("AdvanceAnimation", "$SSL_AdvanceAnimationStage", Config.kAdvanceAnimation)
		AddKeyMapOptionST("ChangeAnimation", "$SSL_ChangeAnimationSet", Config.kChangeAnimation)
		AddKeyMapOptionST("ChangePositions", "$SSL_SwapActorPositions", Config.kChangePositions)
		AddKeyMapOptionST("MoveSceneLocation", "$SSL_MoveSceneLocation", Config.kMoveScene)
		AddKeyMapOptionST("BackwardsModifier", "$SSL_ReverseDirectionModifier", Config.kBackwards)
		AddKeyMapOptionST("ToggleFreeCamera", "$SSL_ToggleFreeCamera", Config.kToggleFreeCamera)

	; Normal timers + stripping
	elseIf page == "$SSL_NormalTimersStripping"
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption("$SSL_ConsensualStageTimers")
		oidStageTimer[0] = AddSliderOption("$SSL_Stage1Length", Config.fStageTimer[0], "$SSL_Seconds")
		oidStageTimer[1] = AddSliderOption("$SSL_Stage2Length", Config.fStageTimer[1], "$SSL_Seconds")
		oidStageTimer[2] = AddSliderOption("$SSL_Stage3Length", Config.fStageTimer[2], "$SSL_Seconds")
		AddEmptyOption()

		AddHeaderOption("$SSL_FemaleStripFrom")
		oidStripFemale = new int[33]
		StripSlots(oidStripFemale, Config.bStripFemale)

		SetCursorPosition(1)
		AddHeaderOption("")
		oidStageTimer[3] = AddSliderOption("$SSL_Stage4Length", Config.fStageTimer[3], "$SSL_Seconds")
		oidStageTimer[4] = AddSliderOption("$SSL_StageEndingLength", Config.fStageTimer[4], "$SSL_Seconds")
		AddEmptyOption()
		AddEmptyOption()

		AddHeaderOption("$SSL_MaleStripFrom")
		oidStripMale = new int[33]
		StripSlots(oidStripMale, Config.bStripMale)

	; Foreplay/Leadin timers + stripping
	elseIf page == "$SSL_ForeplayTimersStripping"
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption("$SSL_ConsensualStageTimers")
		oidStageTimerLeadIn[0] = AddSliderOption("$SSL_Stage1Length", Config.fStageTimerLeadIn[0], "$SSL_Seconds")
		oidStageTimerLeadIn[1] = AddSliderOption("$SSL_Stage2Length", Config.fStageTimerLeadIn[1], "$SSL_Seconds")
		oidStageTimerLeadIn[2] = AddSliderOption("$SSL_Stage3Length", Config.fStageTimerLeadIn[2], "$SSL_Seconds")
		AddEmptyOption()

		AddHeaderOption("$SSL_FemaleStripFrom")
		oidStripLeadInFemale = new int[33]
		StripSlots(oidStripLeadInFemale, Config.bStripLeadInFemale)

		SetCursorPosition(1)
		AddHeaderOption("")
		oidStageTimerLeadIn[3] = AddSliderOption("$SSL_Stage4Length", Config.fStageTimerLeadIn[3], "$SSL_Seconds")
		oidStageTimerLeadIn[4] = AddSliderOption("$SSL_StageEndingLength", Config.fStageTimerLeadIn[4], "$SSL_Seconds")
		AddEmptyOption()
		AddEmptyOption()

		AddHeaderOption("$SSL_MaleStripFrom")
		oidStripLeadInMale = new int[33]
		StripSlots(oidStripLeadInMale, Config.bStripLeadInMale)

	; Aggressive timers + stripping
	elseIf page == "$SSL_AggressiveTimersStripping"
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption("$SSL_ConsensualStageTimers")
		oidStageTimerAggr[0] = AddSliderOption("$SSL_Stage1Length", Config.fStageTimerAggr[0], "$SSL_Seconds")
		oidStageTimerAggr[1] = AddSliderOption("$SSL_Stage2Length", Config.fStageTimerAggr[1], "$SSL_Seconds")
		oidStageTimerAggr[2] = AddSliderOption("$SSL_Stage3Length", Config.fStageTimerAggr[2], "$SSL_Seconds")
		AddEmptyOption()

		AddHeaderOption("$SSL_VictimStripFrom")
		oidStripVictim = new int[33]
		StripSlots(oidStripVictim, Config.bStripVictim)

		SetCursorPosition(1)
		AddHeaderOption("")
		oidStageTimerAggr[3] = AddSliderOption("$SSL_Stage4Length", Config.fStageTimerAggr[3], "$SSL_Seconds")
		oidStageTimerAggr[4] = AddSliderOption("$SSL_StageEndingLength", Config.fStageTimerAggr[4], "$SSL_Seconds")
		AddEmptyOption()
		AddEmptyOption()

		AddHeaderOption("$SSL_AggressorStripFrom")
		oidStripAggressor = new int[33]
		StripSlots(oidStripAggressor, Config.bStripAggressor)

	; Toggle animations on/off
	elseIf page == "$SSL_ToggleAnimations"
		SetCursorFillMode(LEFT_TO_RIGHT)

		i = 0
		while i < AnimSlots.Slotted
			if AnimSlots.Slots[i].Registered
				oidToggleAnimation[i] = AddToggleOption(AnimSlots.Slots[i].Name, AnimSlots.Slots[i].Enabled)
			endIf
			i += 1
		endWhile

	; Toggle foreplay use of animations on/off
	elseIf page == "$SSL_ForeplayAnimations"
		SetCursorFillMode(LEFT_TO_RIGHT)

		i = 0
		while i < AnimSlots.Slotted
			if AnimSlots.Slots[i].Registered
				oidForeplayAnimation[i] = AddToggleOption(AnimSlots.Slots[i].Name, AnimSlots.Slots[i].HasTag("LeadIn"))
			endIf
			i += 1
		endWhile

	; Toggle aggressive use of animations on/off
	elseIf page == "$SSL_AggressiveAnimations"
		SetCursorFillMode(LEFT_TO_RIGHT)

		i = 0
		while i < AnimSlots.Slotted
			if AnimSlots.Slots[i].Registered
				oidAggrAnimation[i] = AddToggleOption(AnimSlots.Slots[i].Name, AnimSlots.Slots[i].HasTag("Aggressive"))
			endIf
			i += 1
		endWhile

	; Toggle creature animatons
	elseIf page == "$SSL_CreatureAnimations"
		SetCursorFillMode(LEFT_TO_RIGHT)
		i = 0
		while i < CreatureSlots.Slotted
			if CreatureSlots.Slots[i].Registered
				oidToggleCreatureAnimation[i] = AddToggleOption(CreatureSlots.Slots[i].Name, CreatureSlots.Slots[i].Enabled)
			endIf
			i += 1
		endWhile

	; Player Diary/Journal
	elseIf page == "$SSL_SexDiary" || page == "$SSL_SexJournal"
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption("$SSL_SexualExperience")
		AddTextOption("$SSL_VaginalExperience", Stats.GetSkill(PlayerRef, "Vaginal"))
		AddTextOption("$SSL_AnalExperience", Stats.GetSkill(PlayerRef, "Anal"))
		AddTextOption("$SSL_OralExperience", Stats.GetSkill(PlayerRef, "Oral"))
		AddTextOption("$SSL_ForeplayExperience", Stats.GetSkill(PlayerRef, "Foreplay"))

		AddTextOption("$SSL_MaleSexualPartners", Stats.GetInt(PlayerRef, "Males"))
		AddTextOption("$SSL_FemaleSexualPartners", Stats.GetInt(PlayerRef, "Females"))
		AddTextOption("$SSL_CreatureSexualPartners", Stats.GetInt(PlayerRef, "Creatures"))
		AddTextOption("$SSL_TimesMasturbated", Stats.GetInt(PlayerRef, "Masturbation"))
		AddTextOption("$SSL_TimesAggressive", Stats.GetInt(PlayerRef, "Aggressor"))
		AddTextOption("$SSL_TimesVictim", Stats.GetInt(PlayerRef, "Victim"))
		AddTextOption("$SSL_TimeSpentHavingSex", Stats.ParseTime(Stats.GetFloat(PlayerRef, "TimeSpent") as int))
		AddTextOption("$SSL_TimeSinceLastSex", Stats.LastSexTimerString(PlayerRef))

		SetCursorPosition(1)
		AddHeaderOption("$SSL_SexualStats")
		AddTextOption("$SSL_VaginalProficiency", Stats.GetSkillTitle(PlayerRef, "Vaginal"))
		AddTextOption("$SSL_AnalProficiency", Stats.GetSkillTitle(PlayerRef, "Anal"))
		AddTextOption("$SSL_OralProficiency", Stats.GetSkillTitle(PlayerRef, "Oral"))
		AddTextOption("$SSL_ForeplayProficiency", Stats.GetSkillTitle(PlayerRef, "Foreplay"))

		AddTextOption("$SSL_SexualPurity", Stats.GetPureTitle(PlayerRef))
		AddTextOption("$SSL_SexualPerversion", Stats.GetLewdTitle(PlayerRef))
		AddTextOption("$SSL_Sexuality", Stats.GetSexualityTitle(PlayerRef))

		AddEmptyOption()

	; System rebuild & clean
	elseIf page == "$SSL_RebuildClean"
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption("SexLab v"+GetStringVer()+" by Ashal@LoversLab.com")
		AddHeaderOption("$SSL_Maintenance")
		if SexLab.Enabled
			AddTextOptionST("ToggleSystem","$SSL_EnabledSystem", "$SSL_DoDisable")
		else
			AddTextOptionST("ToggleSystem","$SSL_DisabledSystem", "$SSL_DoEnable")
		endIf
		AddTextOptionST("RestoreDefaultSettings","$SSL_RestoreDefaultSettings", "$SSL_ClickHere")
		AddTextOptionST("StopCurrentAnimations","$SSL_StopCurrentAnimations", "$SSL_ClickHere")
		AddTextOptionST("ResetAnimationRegistry","$SSL_ResetAnimationRegistry", "$SSL_ClickHere")
		AddTextOptionST("ResetVoiceRegistry","$SSL_ResetVoiceRegistry", "$SSL_ClickHere")
		AddTextOptionST("ResetPlayerSexStats","$SSL_ResetPlayerSexStats", "$SSL_ClickHere")
		AddEmptyOption()
		AddHeaderOption("$SSL_UpgradeUninstallReinstall")
		AddTextOptionST("CleanSystem","$SSL_CleanSystem", "$SSL_ClickHere")

		SetCursorPosition(1)
		AddEmptyOption()
		AddHeaderOption("")
		; AddTextOptionST("ExportSettings","$SSL_ExportSettings", "$SSL_ClickHere")
		; AddTextOptionST("ImportSettings","$SSL_ImportSettings", "$SSL_ClickHere")
		AddEmptyOption()
		AddHeaderOption("$SSL_AvailableStrapons")
		AddTextOptionST("RebuildStraponList","$SSL_RebuildStraponList", "$SSL_ClickHere")
		i = ActorLib.Strapons.Length
		while i
			i -= 1
			if ActorLib.Strapons[i] != none
				string Name = ActorLib.Strapons[i].GetName()
				if Name == "strapon"
					Name = "Aeon/Horker"
				endIf
				oidRemoveStrapon[i] = AddTextOption(Name, "$SSL_Remove")
			endIf
		endWhile
	endIf

endEvent

function StripSlots(int[] OIDs, bool[] Enabled)
	OIDs[32] = AddToggleOption("$SSL_Weapons", Enabled[32])
	int i
	while i < 32
		if SlotNames[i] != ""
			OIDs[i] = AddToggleOption(SlotNames[i], Enabled[i])
		endIf
		if i == 13
			AddHeaderOption("$SSL_ExtraSlots")
		endIf
		i += 1
	endWhile
endFunction

function CheckSystem()
	; Check SKSE Version
	if SKSE.GetScriptVersionRelease() < 45
		Debug.MessageBox("Outdated or no SKSE install detected, SexLab currently requires SKSE v1.7.0 or newer in order to function.")
		SexLab.EnableSystem(false)
	endIf
	; Check Skyrim Version
	float skyrimNeeded = 1.9
	float skyrimMajor = StringUtil.SubString(Debug.GetVersionNumber(), 0, 3) as float
	if skyrimMajor < skyrimNeeded
		Debug.MessageBox("SexLab requires Skyrim v1.9.32 or newer in order to function, please update your install before continuing to use the mod.")
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
state PlayerVoice
	event OnSelectST()
		int Next = VoiceSlots.FindSaved(PlayerRef) + 1
		if Next < VoiceSlots.Slotted
			VoiceSlots.SaveVoice(PlayerRef, VoiceSlots.GetBySlot(Next))
		else
			VoiceSlots.ForgetVoice(PlayerRef)
		endIf
		SetTextOptionValueST(VoiceSlots.GetSavedName(PlayerRef))
	endEvent
	event OnDefaultST()
		VoiceSlots.ForgetVoice(PlayerRef)
		SetTextOptionValueST("$SSL_Random")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoPlayerVoice")
	endEvent
endState
state NPCSaveVoice
	event OnSelectST()
		Config.bNPCSaveVoice = !Config.bNPCSaveVoice
		SetToggleOptionValueST(Config.bNPCSaveVoice)
	endEvent
	event OnDefaultST()
		Config.bNPCSaveVoice = false
		SetToggleOptionValueST(Config.bNPCSaveVoice)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoNPCSaveVoice")
	endEvent
endState
state SFXVolume
	event OnSliderOpenST()
		SetSliderDialogStartValue((Config.fSFXVolume * 100))
		SetSliderDialogDefaultValue(80)
		SetSliderDialogRange(1, 100)
		SetSliderDialogInterval(1)
	endEvent
	event OnSliderAcceptST(float value)
		Config.fSFXVolume = (value / 100.0)
		AudioSFX.SetVolume(Config.fSFXVolume)
		SetSliderOptionValueST(value, "{0}%")
	endEvent
	event OnDefaultST()
		Config.fSFXVolume = 0.8
		SetSliderOptionValueST(80, "{0}%")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoSFXVolume")
	endEvent
endState
state VoiceVolume
	event OnSliderOpenST()
		SetSliderDialogStartValue((Config.fVoiceVolume * 100))
		SetSliderDialogDefaultValue(80)
		SetSliderDialogRange(1, 100)
		SetSliderDialogInterval(1)
	endEvent
	event OnSliderAcceptST(float value)
		Config.fVoiceVolume = (value / 100.0)
		AudioVoice.SetVolume(Config.fVoiceVolume)
		SetSliderOptionValueST(value, "{0}%")
	endEvent
	event OnDefaultST()
		Config.fVoiceVolume = 0.8
		SetSliderOptionValueST(780, "{0}%")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoVoiceVolume")
	endEvent
endState
state SFXDelay
	event OnSliderOpenST()
		SetSliderDialogStartValue(Config.fSFXDelay)
		SetSliderDialogDefaultValue(4.0)
		SetSliderDialogRange(4.0, 30.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		Config.fSFXDelay = value
		SetSliderOptionValueST(Config.fSFXDelay, "$SSL_Seconds")
	endEvent
	event OnDefaultST()
		Config.fSFXDelay = 4.0
		SetSliderOptionValueST(Config.fSFXDelay, "$SSL_Seconds")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoSFXDelay")
	endEvent
endState
state MaleVoiceDelay
	event OnSliderOpenST()
		SetSliderDialogStartValue(Config.fMaleVoiceDelay)
		SetSliderDialogDefaultValue(7.0)
		SetSliderDialogRange(4.0, 45.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		Config.fMaleVoiceDelay = value
		SetSliderOptionValueST(Config.fMaleVoiceDelay, "$SSL_Seconds")
	endEvent
	event OnDefaultST()
		Config.fMaleVoiceDelay = 7.0
		SetSliderOptionValueST(Config.fMaleVoiceDelay, "$SSL_Seconds")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoMaleVoiceDelay")
	endEvent
endState
state FemaleVoiceDelay
	event OnSliderOpenST()
		SetSliderDialogStartValue(Config.fFemaleVoiceDelay)
		SetSliderDialogDefaultValue(6.0)
		SetSliderDialogRange(4.0, 45.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		Config.fFemaleVoiceDelay = value
		SetSliderOptionValueST(Config.fFemaleVoiceDelay, "$SSL_Seconds")
	endEvent
	event OnDefaultST()
		Config.fFemaleVoiceDelay = 6.0
		SetSliderOptionValueST(Config.fFemaleVoiceDelay, "$SSL_Seconds")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoFemaleVoiceDelay")
	endEvent
endState

bool function KeyConflict(int newKeyCode, string conflictControl, string conflictName)
	bool continue = true
	if (conflictControl != "")
		string msg
		if (conflictName != "")
			msg = "This key is already mapped to: \n'" + conflictControl + "'\n(" + conflictName + ")\n\nAre you sure you want to continue?"
		else
			msg = "This key is already mapped to: \n'" + conflictControl + "'\n\nAre you sure you want to continue?"
		endIf
		continue = ShowMessage(msg, true, "$Yes", "$No")
	endIf
	return !continue
endFunction

state AdjustStage
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.kAdjustStage = newKeyCode
			SetKeyMapOptionValueST(Config.kAdjustStage)
		endIf
	endEvent
	event OnDefaultST()
		Config.kAdjustStage = 157
		SetKeyMapOptionValueST(Config.kAdjustStage)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAdjustStage")
	endEvent
endState
state AdjustChange
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.kAdjustChange = newKeyCode
			SetKeyMapOptionValueST(Config.kAdjustChange)
		endIf
	endEvent
	event OnDefaultST()
		Config.kAdjustChange = 37
		SetKeyMapOptionValueST(Config.kAdjustChange)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAdjustChange")
	endEvent
endState
state AdjustForward
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.kAdjustForward = newKeyCode
			SetKeyMapOptionValueST(Config.kAdjustForward)
		endIf
	endEvent
	event OnDefaultST()
		Config.kAdjustForward = 38
		SetKeyMapOptionValueST(Config.kAdjustForward)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAdjustForward")
	endEvent
endState
state AdjustUpward
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.kAdjustUpward = newKeyCode
			SetKeyMapOptionValueST(Config.kAdjustUpward)
		endIf
	endEvent
	event OnDefaultST()
		Config.kAdjustUpward = 39
		SetKeyMapOptionValueST(Config.kAdjustUpward)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAdjustUpward")
	endEvent
endState
state AdjustSideways
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.kAdjustSideways = newKeyCode
			SetKeyMapOptionValueST(Config.kAdjustSideways)
		endIf
	endEvent
	event OnDefaultST()
		Config.kAdjustSideways = 40
		SetKeyMapOptionValueST(Config.kAdjustSideways)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAdjustSideways")
	endEvent
endState
state RotateScene
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.kRotateScene = newKeyCode
			SetKeyMapOptionValueST(Config.kRotateScene)
		endIf
	endEvent
	event OnDefaultST()
		Config.kRotateScene = 22
		SetKeyMapOptionValueST(Config.kRotateScene)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoRotateScene")
	endEvent
endState
state RestoreOffsets
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.kRestoreOffsets = newKeyCode
			SetKeyMapOptionValueST(Config.kRestoreOffsets)
		endIf
	endEvent
	event OnDefaultST()
		Config.kRestoreOffsets = 12
		SetKeyMapOptionValueST(Config.kRestoreOffsets)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoRestoreOffsets")
	endEvent
endState

state RealignActors
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.kRealignActors = newKeyCode
			SetKeyMapOptionValueST(Config.kRealignActors)
		endIf
	endEvent
	event OnDefaultST()
		Config.kRealignActors = 26
		SetKeyMapOptionValueST(Config.kRealignActors)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoRealignActors")
	endEvent
endState
state AdvanceAnimation
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.kAdvanceAnimation = newKeyCode
			SetKeyMapOptionValueST(Config.kAdvanceAnimation)
		endIf
	endEvent
	event OnDefaultST()
		Config.kAdvanceAnimation = 57
		SetKeyMapOptionValueST(Config.kAdvanceAnimation)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAdvanceAnimation")
	endEvent
endState
state ChangeAnimation
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.kChangeAnimation = newKeyCode
			SetKeyMapOptionValueST(Config.kChangeAnimation)
		endIf
	endEvent
	event OnDefaultST()
		Config.kChangeAnimation = 24
		SetKeyMapOptionValueST(Config.kChangeAnimation)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoChangeAnimation")
	endEvent
endState
state ChangePositions
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.kChangePositions = newKeyCode
			SetKeyMapOptionValueST(Config.kChangePositions)
		endIf
	endEvent
	event OnDefaultST()
		Config.kChangePositions = 13
		SetKeyMapOptionValueST(Config.kChangePositions)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoChangePositions")
	endEvent
endState
state MoveSceneLocation
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.kMoveScene = newKeyCode
			SetKeyMapOptionValueST(Config.kMoveScene)
		endIf
	endEvent
	event OnDefaultST()
		Config.kMoveScene = 27
		SetKeyMapOptionValueST(Config.kMoveScene)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoMoveScene")
	endEvent
endState
state BackwardsModifier
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.kBackwards = newKeyCode
			SetKeyMapOptionValueST(Config.kBackwards)
		endIf
	endEvent
	event OnDefaultST()
		Config.kBackwards = 54
		SetKeyMapOptionValueST(Config.kBackwards)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoBackwards")
	endEvent
endState
state ToggleFreeCamera
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.kToggleFreeCamera = newKeyCode
			SetKeyMapOptionValueST(Config.kToggleFreeCamera)
			Config.ToggleFreeCameraEnable()
		endIf
	endEvent
	event OnDefaultST()
		Config.kToggleFreeCamera = 81
		SetKeyMapOptionValueST(Config.kToggleFreeCamera)
		Config.ToggleFreeCameraEnable()
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoToggleFreeCamera")
	endEvent
endState


state ToggleSystem
	event OnSelectST()
		bool run
		if SexLab.Enabled
			run = ShowMessage("$SSL_WarnDisableSexLab")
		else
			run = ShowMessage("$SSL_WarnEnableSexLab")
		endIf
		if run
			SexLab.EnableSystem(!SexLab.Enabled)
			ForcePageReset()
		endIf
	endEvent
endState
state RestoreDefaultSettings
	event OnSelectST()
		if ShowMessage("$SSL_WarnRestoreDefaults")
			SetDefaults()
			ShowMessage("$SSL_RunRestoreDefaults", false)
			ForcePageReset()
		endIf
	endEvent
endState
state StopCurrentAnimations
	event OnSelectST()
		ShowMessage("$SSL_StopRunningAnimations", false)
		ThreadSlots.StopAll()
	endEvent
endState
state ResetAnimationRegistry
	event OnSelectST()
		if ShowMessage("$SSL_WarnRebuildAnimations")
			ThreadSlots.StopAll()
			AnimSlots.Setup()
			CreatureSlots.Setup()
			Debug.Notification("$SSL_RunRebuildAnimations")
		endIf
	endEvent
endState
state ResetVoiceRegistry
	event OnSelectST()
		if ShowMessage("$SSL_WarnRebuildVoices")
			VoiceSlots.Setup()
			Debug.Notification("$SSL_RunRebuildVoices")
		endIf
	endEvent
endState
state ResetPlayerSexStats
	event OnSelectST()
		if ShowMessage("$SSL_WarnResetStats")
			Stats.ResetActor(PlayerRef)
			Debug.Notification("$SSL_RunResetStats")
		endIf
	endEvent
endState
state CleanSystem
	event OnSelectST()
		if ShowMessage("$SSL_WarnCleanSystem")
			ShowMessage("$SSL_RunCleanSystem", false)
			Utility.Wait(0.10)
			SetupSystem()
			CleanSystemFinish.Show()
		endIf
	endEvent
endState
state RebuildStraponList
	event OnSelectST()
		FindStrapons()
		if ActorLib.Strapons.Length > 0
			ShowMessage("$SSL_FoundStrapon", false)
		else
			ShowMessage("$SSL_NoStrapons", false)
		endIf
		ForcePageReset()
	endEvent
endState

event OnOptionSliderOpen(int option)
	int i
	if CurrentPage == "$SSL_NormalTimersStripping"
		i = oidStageTimer.find(option)
		SetSliderDialogStartValue(Config.fStageTimer[i])
	elseIf CurrentPage == "$SSL_ForeplayTimersStripping"
		i = oidStageTimerLeadIn.find(option)
		SetSliderDialogStartValue(Config.fStageTimerLeadIn[i])
	elseIf CurrentPage == "$SSL_AggressiveTimersStripping"
		i = oidStageTimerAggr.find(option)
		SetSliderDialogStartValue(Config.fStageTimerAggr[i])
	endIf
	SetSliderDialogRange(3.0, 300.0)
	SetSliderDialogInterval(1.0)
	SetSliderDialogDefaultValue(15.0)
endEvent

event OnOptionSliderAccept(int option, float value)
	int i
	if CurrentPage == "$SSL_NormalTimersStripping"
		i = oidStageTimer.find(option)
		Config.fStageTimer[i] = value
		SetSliderOptionValue(option, value, "$SSL_Seconds")
	elseIf CurrentPage == "$SSL_ForeplayTimersStripping"
		i = oidStageTimerLeadIn.find(option)
		Config.fStageTimerLeadIn[i] = value
		SetSliderOptionValue(option, value, "$SSL_Seconds")
	elseIf CurrentPage == "$SSL_AggressiveTimersStripping"
		i = oidStageTimerAggr.find(option)
		Config.fStageTimerAggr[i] = value
		SetSliderOptionValue(option, value, "$SSL_Seconds")
	endIf
endEvent


event OnOptionSelect(int option)
	int i
	if CurrentPage == "$SSL_SoundSettings"
		i = oidToggleVoice.Find(option)
		VoiceSlots.Voices[i].Enabled = !VoiceSlots.Voices[i].Enabled
		SetToggleOptionValue(option, VoiceSlots.Voices[i].Enabled)

	elseif CurrentPage == "$SSL_CreatureAnimations"
		i = oidToggleCreatureAnimation.Find(option)
		CreatureSlots.Slots[i].Enabled = !CreatureSlots.Slots[i].Enabled
		SetToggleOptionValue(option, CreatureSlots.Slots[i].Enabled)

	elseif CurrentPage == "$SSL_ToggleAnimations"
		i = oidToggleAnimation.Find(option)
		AnimSlots.Slots[i].Enabled = !AnimSlots.Slots[i].Enabled
		SetToggleOptionValue(option, AnimSlots.Slots[i].Enabled)

	elseif CurrentPage == "$SSL_AggressiveAnimations"
		i = oidAggrAnimation.Find(option)
		SetToggleOptionValue(option, AnimSlots.Slots[i].ToggleTag("Aggressive"))

	elseif CurrentPage == "$SSL_ForeplayAnimations"
		i = oidForeplayAnimation.Find(option)
		SetToggleOptionValue(option, AnimSlots.Slots[i].ToggleTag("LeadIn"))

	; Toggle male/female stripping
	elseIf CurrentPage == "$SSL_NormalTimersStripping"
		i = oidStripMale.Find(option)
		if i >= 0
			Config.bStripMale[i] = !Config.bStripMale[i]
			SetToggleOptionValue(option, Config.bStripMale[i])
		else
			i = oidStripFemale.Find(option)
			Config.bStripFemale[i] = !Config.bStripFemale[i]
			SetToggleOptionValue(option, Config.bStripFemale[i])
		endIf

	; Toggle foreplay stripping
	elseIf CurrentPage == "$SSL_ForeplayTimersStripping"
		i = oidStripLeadInMale.Find(option)
		if i >= 0
			Config.bStripLeadInMale[i] = !Config.bStripLeadInMale[i]
			SetToggleOptionValue(option, Config.bStripLeadInMale[i])
		else
			i = oidStripLeadInFemale.Find(option)
			Config.bStripLeadInFemale[i] = !Config.bStripLeadInFemale[i]
			SetToggleOptionValue(option, Config.bStripLeadInFemale[i])
		endIf

	; Toggle victim/aggressor
	elseIf CurrentPage == "$SSL_AggressiveTimersStripping"
		i = oidStripVictim.Find(option)
		if i >= 0
			Config.bStripVictim[i] = !Config.bStripVictim[i]
			SetToggleOptionValue(option, Config.bStripVictim[i])
		else
			i = oidStripAggressor.Find(option)
			Config.bStripAggressor[i] = !Config.bStripAggressor[i]
			SetToggleOptionValue(option, Config.bStripAggressor[i])
		endIf

	; Toggle expressions
	; elseif CurrentPage == "$SSL_ExpressionSelection"
	; 	i = oidToggleExpressionNormal.Find(option)
	; 	if i != -1
	; 		SetToggleOptionValue(option, ExpressionSlots.Expression[i].ToggleTag("Normal"))
	; 		return
	; 	endIf
	; 	i = oidToggleExpressionVictim.Find(option)
	; 	if i != -1
	; 		SetToggleOptionValue(option, ExpressionSlots.Expression[i].ToggleTag("Victim"))
	; 		return
	; 	endIf
	; 	i = oidToggleExpressionAggressor.Find(option)
	; 	if i != -1
	; 		SetToggleOptionValue(option, ExpressionSlots.Expression[i].ToggleTag("Aggressor"))
	; 		return
	; 	endIf

	elseIf CurrentPage == "$SSL_RebuildClean"
		i = oidRemoveStrapon.Find(option)
		form[] newStrapons
		form[] strapons = ActorLib.Strapons
		form toRemove = strapons[i]
		int s = strapons.Length
		while s
			s -= 1
			if strapons[s] != toRemove
				newStrapons = sslUtility.PushForm(strapons[s], newStrapons)
			endIf
		endWhile
		ActorLib.Strapons = newStrapons
		ForcePageReset()
	endIf
endEvent
