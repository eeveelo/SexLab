scriptname sslConfigMenu extends SKI_ConfigBase
{Skyrim SexLab Mod Configuration Menu}

int function GetVersion()
	return 1190
endFunction

string function GetStringVer()
	return StringUtil.Substring(((GetVersion() as float / 1000.0) as string), 0, 4)
endFunction

bool function DebugMode()
	return true
endFunction

event OnVersionUpdate(int version)
	float current = (CurrentVersion as float / 1000.0)
	float latest = (version as float / 1000.0)
	Debug.Notification("Starting SexLab v"+GetStringVer())
endEvent

event OnConfigInit()
	_SetupSystem()
endEvent

event OnGameReload()
	_CheckSystem()
	parent.OnGameReload()
endEvent

; Framework
SexLabFramework property SexLab auto

sslAnimationSlots property AnimSlots auto
sslAnimationLibrary property AnimLib auto

sslVoiceSlots property VoiceSlots auto
sslVoiceLibrary property VoiceLib auto

sslThreadSlots property ThreadSlots auto
sslThreadLibrary property ThreadLib auto

sslActorSlots property ActorSlots auto
sslActorLibrary property ActorLib auto
sslActorStats property Stats auto

; Data
actor property PlayerRef auto
message property mOldSkyrim auto
message property mOldSKSE auto
message property mNoSKSE auto
message property mDirtyUpgrade auto
message property mCleanSystemFinish auto
message property mSystemDisabled auto
message property mSystemUpdated auto
spell property SexLabDebugSpell auto

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
int[] oidAggrAnimation
int[] oidForeplayAnimation
int[] oidRemoveStrapon

; Default strapon
armor property aCalypsStrapon auto

function SetDefaults()
	AnimLib._Defaults()
	VoiceLib._Defaults()
	ActorLib._Defaults()
	ThreadLib._Defaults()

	oidToggleVoice = new int[128]
	oidToggleAnimation = new int[128]
	oidAggrAnimation = new int[128]
	oidForeplayAnimation = new int[128]
	
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

	Pages = new string[11]
	Pages[0] = "$SSL_AnimationSettings"
	Pages[1] = "$SSL_PlayerHotkeys"
	Pages[2] = "$SSL_NormalTimersStripping"
	Pages[3] = "$SSL_ForeplayTimersStripping"
	Pages[4] = "$SSL_AggressiveTimersStripping"
	Pages[5] = "$SSL_ToggleVoices"
	Pages[6] = "$SSL_ToggleAnimations"
	Pages[7] = "$SSL_ForeplayAnimations"
	Pages[8] = "$SSL_AggressiveAnimations"
	if Game.GetPlayer().GetActorBase().GetSex() > 0
		Pages[9] = "$SSL_SexDiary"
	else
		Pages[9] = "$SSL_SexJournal"
	endIf
	Pages[10] = "$SSL_RebuildClean"

	FindStrapons()
endFunction

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

		AddToggleOptionST("RestrictAggressive","$SSL_RestrictAggressive", AnimLib.bRestrictAggressive)
		AddToggleOptionST("ScaleActors","$SSL_EvenActorsHeight", ActorLib.bScaleActors)
		AddToggleOptionST("RagdollEnd","$SSL_RagdollEnding", ActorLib.bRagdollEnd)
		AddToggleOptionST("UndressAnimation","$SSL_UndressAnimation", ActorLib.bUndressAnimation)
		AddToggleOptionST("ReDressVictim","$SSL_VictimsRedress", ActorLib.bReDressVictim)
		AddTextOptionST("NPCBed","$SSL_NPCsUseBeds", ThreadLib.sNPCBed)
		AddToggleOptionST("UseCum","$SSL_ApplyCumEffects", ActorLib.bUseCum)
		AddToggleOptionST("AllowFemaleFemaleCum","$SSL_AllowFemaleFemaleCum", ActorLib.bAllowFFCum)
		AddSliderOptionST("CumEffectTimer","$SSL_CumEffectTimer", ActorLib.fCumTimer, "$SSL_Seconds")
		AddToggleOptionST("StraponsFemale","$SSL_FemalesUseStrapons", ActorLib.bUseStrapons)
		AddToggleOptionST("NudeSuitMales","$SSL_UseNudeSuitMales", ActorLib.bUseMaleNudeSuit)
		AddToggleOptionST("NudeSuitFemales","$SSL_UseNudeSuitFemales", ActorLib.bUseFemaleNudeSuit)
		SetCursorPosition(1)
		AddToggleOptionST("ForeplayStage","$SSL_PreSexForeplay", ThreadLib.bForeplayStage)
		AddToggleOptionST("PlayerTCL","$SSL_PlayerTCL", ActorLib.bEnableTCL)

		AddHeaderOption("$SSL_PlayerSettings")
		AddToggleOptionST("AutoAdvance","$SSL_AutoAdvanceStages", ThreadLib.bAutoAdvance)
		AddToggleOptionST("DisableVictim","$SSL_DisableVictimControls", ActorLib.bDisablePlayer)

		AddHeaderOption("$SSL_SoundsVoices")
		AddTextOptionST("PlayerVoice","$SSL_PCVoice", "$SSL_Random")
		AddSliderOptionST("VoiceVolume","$SSL_VoiceVolume", (ActorLib.fVoiceVolume * 100), "{0}%")
		AddSliderOptionST("MaleVoiceDelay","$SSL_MaleVoiceDelay", ActorLib.fMaleVoiceDelay, "$SSL_Seconds")
		AddSliderOptionST("FemaleVoiceDelay","$SSL_FemaleVoiceDelay", ActorLib.fFemaleVoiceDelay, "$SSL_Seconds")
		AddSliderOptionST("SFXVolume","$SSL_SFXVolume", (ThreadLib.fSFXVolume * 100), "{0}%")
		AddSliderOptionST("SFXDelay","$SSL_SFXDelay", ThreadLib.fSFXDelay, "$SSL_Seconds")

	elseIf page == "$SSL_PlayerHotkeys"
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption("$SSL_SceneManipulation")
		AddKeyMapOptionST("BackwardsModifier", "$SSL_ReverseDirectionModifier", ActorLib.kBackwards)
		AddKeyMapOptionST("AdvanceAnimation", "$SSL_AdvanceAnimationStage", ActorLib.kAdvanceAnimation)
		AddKeyMapOptionST("ChangeAnimation", "$SSL_ChangeAnimationSet", ActorLib.kChangeAnimation)
		AddKeyMapOptionST("ChangePositions", "$SSL_SwapActorPositions", ActorLib.kChangePositions)
		AddKeyMapOptionST("MoveSceneLocation", "$SSL_MoveSceneLocation", ActorLib.kMoveScene)
		AddKeyMapOptionST("RotateScene", "$SSL_RotateScene", ActorLib.kRotateScene)

		SetCursorPosition(1)

		AddHeaderOption("$SSL_AlignmentAdjustments")
		AddKeyMapOptionST("AdjustStage","$SSL_AdjustStage", ActorLib.kAdjustStage)
		AddKeyMapOptionST("AdjustChange","$SSL_ChangeActorBeingMoved", ActorLib.kAdjustChange)
		AddKeyMapOptionST("AdjustForward","$SSL_MoveActorForwardBackward", ActorLib.kAdjustForward)
		AddKeyMapOptionST("AdjustUpward","$SSL_AdjustPositionUpwardDownward", ActorLib.kAdjustUpward)
		AddKeyMapOptionST("AdjustSideways","$SSL_MoveActorLeftRight", ActorLib.kAdjustSideways)
		AddKeyMapOptionST("RealignActors","$SSL_RealignActors", ActorLib.kRealignActors)
		AddKeyMapOptionST("RestoreOffsets","$SSL_DeleteSavedAdjustments", ActorLib.kRestoreOffsets)

	elseIf page == "$SSL_NormalTimersStripping"
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption("$SSL_ConsensualStageTimers")
		oidStageTimer[0] = AddSliderOption("$SSL_Stage1Length", ThreadLib.fStageTimer[0], "$SSL_Seconds")
		oidStageTimer[1] = AddSliderOption("$SSL_Stage2Length", ThreadLib.fStageTimer[1], "$SSL_Seconds")
		oidStageTimer[2] = AddSliderOption("$SSL_Stage3Length", ThreadLib.fStageTimer[2], "$SSL_Seconds")
		AddEmptyOption()

		AddHeaderOption("$SSL_FemaleStripFrom")
		oidStripFemale[32] = AddToggleOption("$SSL_Weapons", ThreadLib.bStripFemale[32])
		i = 0
		while i < 32
			int slot = i + 30
			string name = GetSlotName(slot)
			if name != "IGNORE"
				oidStripFemale[i] = AddToggleOption(name, ThreadLib.bStripFemale[i])
			endIf
			if slot == 43
				AddHeaderOption("$SSL_ExtraSlots")
			endIf
			i += 1
		endWhile

		SetCursorPosition(1)
		AddHeaderOption("")
		oidStageTimer[3] = AddSliderOption("$SSL_Stage4Length", ThreadLib.fStageTimer[3], "$SSL_Seconds")
		oidStageTimer[4] = AddSliderOption("$SSL_StageEndingLength", ThreadLib.fStageTimer[4], "$SSL_Seconds")
		AddEmptyOption()
		AddEmptyOption()

		AddHeaderOption("$SSL_MaleStripFrom")
		oidStripMale[32] = AddToggleOption("$SSL_Weapons", ThreadLib.bStripMale[32])
		i = 0
		while i < 32
			int slot = i + 30
			string name = GetSlotName(slot)
			if name != "IGNORE"
				oidStripMale[i] = AddToggleOption(name, ThreadLib.bStripMale[i])
			endIf
			if slot == 43
				AddHeaderOption("$SSL_ExtraSlots")
			endIf
			i += 1
		endWhile

	elseIf page == "$SSL_ForeplayTimersStripping"
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption("$SSL_ForeplayIntroAnimationTimers")
		oidStageTimerLeadIn[0] = AddSliderOption("$SSL_Stage1Length", ThreadLib.fStageTimerLeadIn[0], "$SSL_Seconds")
		oidStageTimerLeadIn[1] = AddSliderOption("$SSL_Stage2Length", ThreadLib.fStageTimerLeadIn[1], "$SSL_Seconds")
		oidStageTimerLeadIn[2] = AddSliderOption("$SSL_Stage3Length", ThreadLib.fStageTimerLeadIn[2], "$SSL_Seconds")
		AddEmptyOption()

		AddHeaderOption("$SSL_FemaleStripFrom")
		oidStripVictim[32] = AddToggleOption("$SSL_Weapons", ThreadLib.bStripLeadInFemale[32])
		i = 0
		while i < 32
			int slot = i + 30
			string name = GetSlotName(slot)
			if name != "IGNORE"
				oidStripLeadInFemale[i] = AddToggleOption(name, ThreadLib.bStripLeadInFemale[i])
			endIf
			if slot == 43
				AddHeaderOption("$SSL_ExtraSlots")
			endIf
			i += 1
		endWhile

		SetCursorPosition(1)
		AddHeaderOption("")
		oidStageTimerLeadIn[3] = AddSliderOption("$SSL_Stage4Length", ThreadLib.fStageTimerLeadIn[3], "$SSL_Seconds")
		oidStageTimerLeadIn[4] = AddSliderOption("$SSL_StageEndingLength", ThreadLib.fStageTimerLeadIn[4], "$SSL_Seconds")
		AddEmptyOption()
		AddEmptyOption()

		AddHeaderOption("$SSL_MaleStripFrom")
		oidStripAggressor[32] = AddToggleOption("$SSL_Weapons", ThreadLib.bStripLeadInMale[32])
		i = 0
		while i < 32
			int slot = i + 30
			string name = GetSlotName(slot)
			if name != "IGNORE"
				oidStripLeadInMale[i] = AddToggleOption(name, ThreadLib.bStripLeadInMale[i])
			endIf
			if slot == 43
				AddHeaderOption("$SSL_ExtraSlots")
			endIf
			i += 1
		endWhile


	elseIf page == "$SSL_AggressiveTimersStripping"
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption("$SSL_AggressiveAnimationTimers")
		oidStageTimerAggr[0] = AddSliderOption("$SSL_Stage1Length", ThreadLib.fStageTimerAggr[0], "$SSL_Seconds")
		oidStageTimerAggr[1] = AddSliderOption("$SSL_Stage2Length", ThreadLib.fStageTimerAggr[1], "$SSL_Seconds")
		oidStageTimerAggr[2] = AddSliderOption("$SSL_Stage3Length", ThreadLib.fStageTimerAggr[2], "$SSL_Seconds")
		AddEmptyOption()

		AddHeaderOption("$SSL_VictimStripFrom")
		oidStripVictim[32] = AddToggleOption("$SSL_Weapons", ThreadLib.bStripVictim[32])
		i = 0
		while i < 32
			int slot = i + 30
			string name = GetSlotName(slot)
			if name != "IGNORE"
				oidStripVictim[i] = AddToggleOption(name, ThreadLib.bStripVictim[i])
			endIf
			if slot == 43
				AddHeaderOption("$SSL_ExtraSlots")
			endIf
			i += 1
		endWhile

		SetCursorPosition(1)
		AddHeaderOption("")
		oidStageTimerAggr[3] = AddSliderOption("$SSL_Stage4Length", ThreadLib.fStageTimerAggr[3], "$SSL_Seconds")
		oidStageTimerAggr[4] = AddSliderOption("$SSL_StageEndingLength", ThreadLib.fStageTimerAggr[4], "$SSL_Seconds")
		AddEmptyOption()
		AddEmptyOption()

		AddHeaderOption("$SSL_AggressorStripFrom")
		oidStripAggressor[32] = AddToggleOption("$SSL_Weapons", ThreadLib.bStripAggressor[32])
		i = 0
		while i < 32
			int slot = i + 30
			string name = GetSlotName(slot)
			if name != "IGNORE"
				oidStripAggressor[i] = AddToggleOption(name, ThreadLib.bStripAggressor[i])
			endIf
			if slot == 43
				AddHeaderOption("$SSL_ExtraSlots")
			endIf
			i += 1
		endWhile

	elseIf page == "$SSL_ToggleAnimations"
		SetCursorFillMode(LEFT_TO_RIGHT)

		i = 0
		while i < AnimSlots.Animations.Length
			if AnimSlots.Animations[i].Registered
				oidToggleAnimation[i] = AddToggleOption(AnimSlots.Animations[i].Name, AnimSlots.Animations[i].Enabled)
			endIf
			i += 1
		endWhile
	elseIf page == "$SSL_ForeplayAnimations"
		SetCursorFillMode(LEFT_TO_RIGHT)

		i = 0
		while i < AnimSlots.Animations.Length
			if AnimSlots.Animations[i].Registered
				oidForeplayAnimation[i] = AddToggleOption(AnimSlots.Animations[i].Name, AnimSlots.Animations[i].HasTag("LeadIn"))
			endIf
			i += 1
		endWhile
	elseIf page == "$SSL_AggressiveAnimations"
		SetCursorFillMode(LEFT_TO_RIGHT)

		i = 0
		while i < AnimSlots.Animations.Length
			if AnimSlots.Animations[i].Registered
				oidAggrAnimation[i] = AddToggleOption(AnimSlots.Animations[i].Name, AnimSlots.Animations[i].HasTag("Aggressive"))
			endIf
			i += 1
		endWhile
	elseIf page == "$SSL_ToggleVoices"
		SetCursorFillMode(LEFT_TO_RIGHT)

		i = 0
		while i < VoiceSlots.Voices.Length
			if VoiceSlots.Voices[i].Registered
				oidToggleVoice[i] = AddToggleOption(VoiceSlots.Voices[i].Name, VoiceSlots.Voices[i].Enabled)
			endIf
			i += 1
		endWhile
	elseIf page == "$SSL_SexDiary" || page == "$SSL_SexJournal"
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption("$SSL_SexualExperience")
		int full = Stats.fTimeSpent as int
		int seconds = full % 60
		int minutes = Math.Floor((full / 60) % 60)
		int hours = Math.Floor(full / 3600)
		AddTextOption("$SSL_TimeSpentHavingSex", hours+":"+minutes+":"+seconds)
		AddTextOption("$SSL_MaleSexualPartners", Stats.iMalePartners)
		AddTextOption("$SSL_FemaleSexualPartners", Stats.iFemalePartners)
		AddTextOption("$SSL_TimesMasturbated", Stats.iMasturbationCount)
		AddTextOption("$SSL_VaginalExperience", Stats.iVaginalCount)
		AddTextOption("$SSL_AnalExperience", Stats.iAnalCount)
		AddTextOption("$SSL_OralExperience", Stats.iOralCount)
		AddTextOption("$SSL_TimesVictim", Stats.iVictimCount)
		AddTextOption("$SSL_TimesAggressive", Stats.iAggressorCount)

		SetCursorPosition(1)
		AddHeaderOption("$SSL_SexualStats")
		AddTextOption("$SSL_Sexuality", Stats.GetPlayerSexuality())
		if Stats.GetPlayerPurityLevel() < 0
			AddTextOption("$SSL_SexualPerversion", Stats.GetPlayerPurityTitle())
		else
			AddTextOption("$SSL_SexualPurity", Stats.GetPlayerPurityTitle())
		endIf
		AddTextOption("$SSL_VaginalProficiency", Stats.GetPlayerStatTitle("Vaginal"))
		AddTextOption("$SSL_AnalProficiency", Stats.GetPlayerStatTitle("Anal"))
		AddTextOption("$SSL_OralProficiency", Stats.GetPlayerStatTitle("Oral"))

	elseIf page == "$SSL_RebuildClean"
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption("SexLab v"+GetStringVer()+" by Ashal@LoversLab.com")
		AddEmptyOption()
		AddHeaderOption("$SSL_Maintenance")
		if SexLab.Enabled
			AddTextOptionST("ToggleSystem","$SSL_EnabledSystem", "$SSL_DoDisable")
		else
			AddTextOptionST("ToggleSystem","$SSL_DisabledSystem", "$SSL_DoEnable")
		endIf
		AddTextOptionST("StopCurrentAnimations","$SSL_StopCurrentAnimations", "$SSL_ClickHere")
		AddTextOptionST("RestoreDefaultSettings","$SSL_RestoreDefaultSettings", "$SSL_ClickHere")
		AddTextOptionST("ResetAnimationRegistry","$SSL_ResetAnimationRegistry", "$SSL_ClickHere")
		AddTextOptionST("ResetVoiceRegistry","$SSL_ResetVoiceRegistry", "$SSL_ClickHere")
		AddTextOptionST("ResetPlayerSexStats","$SSL_ResetPlayerSexStats", "$SSL_ClickHere")
		AddEmptyOption()
		AddHeaderOption("$SSL_UpgradeUninstallReinstall")
		AddTextOptionST("CleanSystem","$SSL_CleanSystem", "$SSL_ClickHere")
		AddEmptyOption()

		SetCursorPosition(1)
		AddHeaderOption("$SSL_TranslatorCredit")
		AddEmptyOption()
		AddHeaderOption("$SSL_AvailableStrapons")
		AddTextOptionST("RebuildStraponList","$SSL_RebuildStraponList", "$SSL_ClickHere")
		i = 0
		while i < ActorLib.Strapons.Length
			if ActorLib.Strapons[i] != none
				if ActorLib.Strapons[i].GetName() == "strapon"
					oidRemoveStrapon[i] = AddTextOption("Aeon/Horker", "$SSL_Remove")
				else
					oidRemoveStrapon[i] = AddTextOption(ActorLib.Strapons[i].GetName(), "$SSL_Remove")
				endIf
			endIf
			i += 1
		endWhile
	endIf

endEvent

state RestrictAggressive
	event OnSelectST()
		AnimLib.bRestrictAggressive = !AnimLib.bRestrictAggressive
		SetToggleOptionValueST(AnimLib.bRestrictAggressive)
	endEvent
	event OnDefaultST()
		AnimLib.bRestrictAggressive = true
		SetToggleOptionValueST(AnimLib.bRestrictAggressive)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoRestrictAggressive")
	endEvent
endState
state ScaleActors
	event OnSelectST()
		ActorLib.bScaleActors = !ActorLib.bScaleActors
		SetToggleOptionValueST(ActorLib.bScaleActors)
	endEvent
	event OnDefaultST()
		ActorLib.bScaleActors = true
		SetToggleOptionValueST(ActorLib.bScaleActors)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoScaleActors")
	endEvent
endState
state RagdollEnd
	event OnSelectST()
		ActorLib.bRagdollEnd = !ActorLib.bRagdollEnd
		SetToggleOptionValueST(ActorLib.bRagdollEnd)
	endEvent
	event OnDefaultST()
		ActorLib.bRagdollEnd = false
		SetToggleOptionValueST(ActorLib.bRagdollEnd)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoRagdollEnd")
	endEvent
endState
state UndressAnimation
	event OnSelectST()
		ActorLib.bUndressAnimation = !ActorLib.bUndressAnimation
		SetToggleOptionValueST(ActorLib.bUndressAnimation)
	endEvent
	event OnDefaultST()
		ActorLib.bUndressAnimation = true
		SetToggleOptionValueST(ActorLib.bUndressAnimation)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoUndressAnimation")
	endEvent
endState
state ReDressVictim
	event OnSelectST()
		ActorLib.bReDressVictim = !ActorLib.bReDressVictim
		SetToggleOptionValueST(ActorLib.bReDressVictim)
	endEvent
	event OnDefaultST()
		ActorLib.bReDressVictim = true
		SetToggleOptionValueST(ActorLib.bReDressVictim)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoReDressVictim")
	endEvent
endState
state NPCBed 
	event OnSelectST()
		if ThreadLib.sNPCBed == "$SSL_Never"
			ThreadLib.sNPCBed = "$SSL_Sometimes"
		elseif ThreadLib.sNPCBed == "$SSL_Sometimes"
			ThreadLib.sNPCBed = "$SSL_Always"
		else
			ThreadLib.sNPCBed = "$SSL_Never"
		endIf
		SetTextOptionValueST(ThreadLib.sNPCBed)
	endEvent
	event OnDefaultST()
		ThreadLib.sNPCBed = "$SSL_Never"
		SetTextOptionValueST(ThreadLib.sNPCBed)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoNPCBed")
	endEvent
endState
state UseCum
	event OnSelectST()
		ActorLib.bUseCum = !ActorLib.bUseCum
		SetToggleOptionValueST(ActorLib.bUseCum)
	endEvent
	event OnDefaultST()
		ActorLib.bUseCum = true
		SetToggleOptionValueST(ActorLib.bUseCum)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoUseCum")
	endEvent
endState
state AllowFemaleFemaleCum
	event OnSelectST()
		ActorLib.bAllowFFCum = !ActorLib.bAllowFFCum
		SetToggleOptionValueST(ActorLib.bAllowFFCum)
	endEvent
	event OnDefaultST()
		ActorLib.bAllowFFCum = false
		SetToggleOptionValueST(ActorLib.bAllowFFCum)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAllowFFCum")
	endEvent
endState
state CumEffectTimer
	event OnSliderOpenST()
		SetSliderDialogStartValue(ActorLib.fCumTimer)
		SetSliderDialogDefaultValue(120.0)
		SetSliderDialogRange(1.0, 600.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		ActorLib.fCumTimer = value
		SetSliderOptionValueST(ActorLib.fCumTimer, "$SSL_Seconds")
	endEvent
	event OnDefaultST()
		ActorLib.fCumTimer = 120.0
		SetToggleOptionValueST(ActorLib.fCumTimer, "$SSL_Seconds")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoCumTimer")
	endEvent
endState
state StraponsFemale
	event OnSelectST()
		ActorLib.bUseStrapons = !ActorLib.bUseStrapons
		SetToggleOptionValueST(ActorLib.bUseStrapons)
	endEvent
	event OnDefaultST()
		ActorLib.bUseStrapons = true
		SetToggleOptionValueST(ActorLib.bUseStrapons)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoUseStrapons")
	endEvent
endState
state NudeSuitMales
	event OnSelectST()
		ActorLib.bUseMaleNudeSuit = !ActorLib.bUseMaleNudeSuit
		SetToggleOptionValueST(ActorLib.bUseMaleNudeSuit)
	endEvent
	event OnDefaultST()
		ActorLib.bUseMaleNudeSuit = false
		SetToggleOptionValueST(ActorLib.bUseMaleNudeSuit)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoMaleNudeSuit")
	endEvent
endState
state NudeSuitFemales
	event OnSelectST()
		ActorLib.bUseFemaleNudeSuit = !ActorLib.bUseFemaleNudeSuit
		SetToggleOptionValueST(ActorLib.bUseFemaleNudeSuit)
	endEvent
	event OnDefaultST()
		ActorLib.bUseFemaleNudeSuit = false
		SetToggleOptionValueST(ActorLib.bUseFemaleNudeSuit)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoFemaleNudeSuit")
	endEvent
endState
state ForeplayStage
	event OnSelectST()
		ThreadLib.bForeplayStage = !ThreadLib.bForeplayStage
		SetToggleOptionValueST(ThreadLib.bForeplayStage)
	endEvent
	event OnDefaultST()
		ThreadLib.bForeplayStage = true
		SetToggleOptionValueST(ThreadLib.bForeplayStage)
	endEvent
	event OnHighlightST()
		SetInfoText("")
	endEvent
endState
state PlayerTCL
	event OnSelectST()
		ActorLib.bEnableTCL = !ActorLib.bEnableTCL
		SetToggleOptionValueST(ActorLib.bEnableTCL)
	endEvent
	event OnDefaultST()
		ActorLib.bEnableTCL = true
		SetToggleOptionValueST(ActorLib.bEnableTCL)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoPlayerTCL")
	endEvent
endState
state AutoAdvance
	event OnSelectST()
		ThreadLib.bAutoAdvance = !ThreadLib.bAutoAdvance
		SetToggleOptionValueST(ThreadLib.bAutoAdvance)
	endEvent
	event OnDefaultST()
		ThreadLib.bAutoAdvance = false
		SetToggleOptionValueST(ThreadLib.bAutoAdvance)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAutoAdvance")
	endEvent
endState
state DisableVictim
	event OnSelectST()
		ActorLib.bDisablePlayer = !ActorLib.bDisablePlayer
		SetToggleOptionValueST(ActorLib.bDisablePlayer)
	endEvent
	event OnDefaultST()
		ActorLib.bDisablePlayer = false
		SetToggleOptionValueST(ActorLib.bDisablePlayer)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoDisablePlayer")
	endEvent
endState
state PlayerVoice
	event OnSelectST()
		int current = ( VoiceSlots.FindByName(VoiceLib.sPlayerVoice) + 1 )
		if current >= VoiceSlots.GetCount()
			current = -1
		endIf
		if current == -1
			VoiceLib.sPlayerVoice = "$SSL_Random"
		else
			VoiceLib.sPlayerVoice = VoiceSlots.GetBySlot(current).Name
		endIf
		SetTextOptionValueST(VoiceLib.sPlayerVoice)
	endEvent
	event OnDefaultST()
		VoiceLib.sPlayerVoice = "$SSL_Random"
		SetTextOptionValueST(VoiceLib.sPlayerVoice)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoPlayerVoice")
	endEvent
endState
state VoiceVolume
	event OnSliderOpenST()
		SetSliderDialogStartValue((ActorLib.fVoiceVolume * 100))
		SetSliderDialogDefaultValue(70)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endEvent
	event OnSliderAcceptST(float value)
		ActorLib.fVoiceVolume = ( value / 100 )
		SetSliderOptionValueST(ActorLib.fVoiceVolume, "{0}%")
	endEvent
	event OnDefaultST()
		ActorLib.fVoiceVolume = 0.70
		SetSliderOptionValueST(70, "{0}%")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoVoiceVolume")
	endEvent
endState
state MaleVoiceDelay
	event OnSliderOpenST()
		SetSliderDialogStartValue(ActorLib.fMaleVoiceDelay)
		SetSliderDialogDefaultValue(7.0)
		SetSliderDialogRange(4.0, 45.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		ActorLib.fMaleVoiceDelay = value
		SetSliderOptionValueST(ActorLib.fMaleVoiceDelay, "$SSL_Seconds")
	endEvent
	event OnDefaultST()
		ActorLib.fMaleVoiceDelay = 7.0
		SetSliderOptionValueST(ActorLib.fMaleVoiceDelay, "$SSL_Seconds")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoMaleVoiceDelay")
	endEvent
endState
state FemaleVoiceDelay
	event OnSliderOpenST()
		SetSliderDialogStartValue(ActorLib.fFemaleVoiceDelay)
		SetSliderDialogDefaultValue(6.0)
		SetSliderDialogRange(4.0, 45.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		ActorLib.fFemaleVoiceDelay = value
		SetSliderOptionValueST(ActorLib.fFemaleVoiceDelay, "$SSL_Seconds")
	endEvent
	event OnDefaultST()
		ActorLib.fFemaleVoiceDelay = 6.0
		SetSliderOptionValueST(ActorLib.fFemaleVoiceDelay, "$SSL_Seconds")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoFemaleVoiceDelay")
	endEvent
endState
state SFXVolume
	event OnSliderOpenST()
		SetSliderDialogStartValue((ThreadLib.fSFXVolume * 100))
		SetSliderDialogDefaultValue(80)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endEvent
	event OnSliderAcceptST(float value)
		ThreadLib.fSFXVolume = (value / 100.0)
		SetSliderOptionValueST(value, "{0}%")
	endEvent
	event OnDefaultST()
		ThreadLib.fSFXVolume = 0.80
		SetSliderOptionValueST(80, "{0}%")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoSFXVolume")
	endEvent
endState
state SFXDelay
	event OnSliderOpenST()
		SetSliderDialogStartValue(ThreadLib.fSFXDelay)
		SetSliderDialogDefaultValue(4.0)
		SetSliderDialogRange(4.0, 30.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		ThreadLib.fSFXDelay = value
		SetSliderOptionValueST(ThreadLib.fSFXDelay, "$SSL_Seconds")
	endEvent
	event OnDefaultST()
		ThreadLib.fSFXDelay = 4.0
		SetSliderOptionValueST(ThreadLib.fSFXDelay, "$SSL_Seconds")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoSFXDelay")
	endEvent
endState

; Hotkeys
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

state BackwardsModifier
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			ActorLib.kBackwards = newKeyCode
			SetKeyMapOptionValueST(ActorLib.kBackwards)
		endIf
	endEvent
	event OnDefaultST()
		ActorLib.kBackwards = 54
		SetKeyMapOptionValueST(ActorLib.kBackwards)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoBackwards")
	endEvent
endState
state AdvanceAnimation
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			ActorLib.kAdvanceAnimation = newKeyCode
			SetKeyMapOptionValueST(ActorLib.kAdvanceAnimation)
		endIf
	endEvent
	event OnDefaultST()
		ActorLib.kAdvanceAnimation = 57
		SetKeyMapOptionValueST(ActorLib.kAdvanceAnimation)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAdvanceAnimation")
	endEvent
endState
state ChangeAnimation
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			ActorLib.kChangeAnimation = newKeyCode
			SetKeyMapOptionValueST(ActorLib.kChangeAnimation)
		endIf
	endEvent
	event OnDefaultST()
		ActorLib.kChangeAnimation = 24
		SetKeyMapOptionValueST(ActorLib.kChangeAnimation)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoChangeAnimation")
	endEvent
endState
state ChangePositions
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			ActorLib.kChangePositions = newKeyCode
			SetKeyMapOptionValueST(ActorLib.kChangePositions)
		endIf
	endEvent
	event OnDefaultST()
		ActorLib.kChangePositions = 13
		SetKeyMapOptionValueST(ActorLib.kChangePositions)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoChangePositions")
	endEvent
endState
state MoveSceneLocation
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			ActorLib.kMoveScene = newKeyCode
			SetKeyMapOptionValueST(ActorLib.kMoveScene)
		endIf
	endEvent
	event OnDefaultST()
		ActorLib.kMoveScene = 27
		SetKeyMapOptionValueST(ActorLib.kMoveScene)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoMoveScene")
	endEvent
endState
state RotateScene
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			ActorLib.kRotateScene = newKeyCode
			SetKeyMapOptionValueST(ActorLib.kRotateScene)
		endIf
	endEvent
	event OnDefaultST()
		ActorLib.kRotateScene = 22
		SetKeyMapOptionValueST(ActorLib.kRotateScene)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoRotateScene")
	endEvent
endState
state AdjustStage
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			ActorLib.kAdjustStage = newKeyCode
			SetKeyMapOptionValueST(ActorLib.kAdjustStage)
		endIf
	endEvent
	event OnDefaultST()
		ActorLib.kAdjustStage = 157
		SetKeyMapOptionValueST(ActorLib.kAdjustStage)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAdjustStage")
	endEvent
endState

state AdjustChange
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			ActorLib.kAdjustChange = newKeyCode
			SetKeyMapOptionValueST(ActorLib.kAdjustChange)
		endIf
	endEvent
	event OnDefaultST()
		ActorLib.kAdjustChange = 37
		SetKeyMapOptionValueST(ActorLib.kAdjustChange)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAdjustChange")
	endEvent
endState
state AdjustForward
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			ActorLib.kAdjustForward = newKeyCode
			SetKeyMapOptionValueST(ActorLib.kAdjustForward)
		endIf
	endEvent
	event OnDefaultST()
		ActorLib.kAdjustForward = 38
		SetKeyMapOptionValueST(ActorLib.kAdjustForward)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAdjustForward")
	endEvent
endState
state AdjustUpward
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			ActorLib.kAdjustUpward = newKeyCode
			SetKeyMapOptionValueST(ActorLib.kAdjustUpward)
		endIf
	endEvent
	event OnDefaultST()
		ActorLib.kAdjustUpward = 39
		SetKeyMapOptionValueST(ActorLib.kAdjustUpward)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAdjustUpward")
	endEvent
endState
state AdjustSideways
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			ActorLib.kAdjustSideways = newKeyCode
			SetKeyMapOptionValueST(ActorLib.kAdjustSideways)
		endIf
	endEvent
	event OnDefaultST()
		ActorLib.kAdjustSideways = 40
		SetKeyMapOptionValueST(ActorLib.kAdjustSideways)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAdjustSideways")
	endEvent
endState
state RealignActors
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			ActorLib.kRealignActors = newKeyCode
			SetKeyMapOptionValueST(ActorLib.kRealignActors)
		endIf
	endEvent
	event OnDefaultST()
		ActorLib.kRealignActors = 26
		SetKeyMapOptionValueST(ActorLib.kRealignActors)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoRealignActors")
	endEvent
endState
state RestoreOffsets
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			ActorLib.kRestoreOffsets = newKeyCode
			SetKeyMapOptionValueST(ActorLib.kRestoreOffsets)
		endIf
	endEvent
	event OnDefaultST()
		ActorLib.kRestoreOffsets = 12
		SetKeyMapOptionValueST(ActorLib.kRestoreOffsets)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoRestoreOffsets")
	endEvent
endState

; Rebuild Page
state ToggleSystem
	event OnSelectST()
		bool run
		if SexLab.Enabled
			run = ShowMessage("$SSL_WarnDisableSexLab")
		else
			run = ShowMessage("$SSL_WarnEnableSexLab")
		endIf
		if run
			SexLab._EnableSystem(!SexLab.Enabled)
			ForcePageReset()
		endIf
	endEvent
endState
state StopCurrentAnimations
	event OnSelectST()
		ShowMessage("$SSL_StopRunningAnimations", false)
		ThreadSlots._StopAll()
	endEvent
endState
state RestoreDefaultSettings
	event OnSelectST()
		bool run = ShowMessage("$SSL_WarnRestoreDefaults")
		if run
			SetDefaults()			
			ShowMessage("$SSL_RunRestoreDefaults", false)
			ForcePageReset()
		endIf
	endEvent
endState
state ResetAnimationRegistry
	event OnSelectST()
		bool run = ShowMessage("$SSL_WarnRebuildAnimations")
		if run
			ThreadSlots._StopAll()
			AnimSlots._Setup()

			ShowMessage("$SSL_RunRebuildAnimations", false)
		endIf
	endEvent
endState
state ResetVoiceRegistry
	event OnSelectST()
		bool run = ShowMessage("$SSL_WarnRebuildVoices")
		if run
			VoiceSlots._Setup()
			ShowMessage("$SSL_RunRebuildVoices", false)
		endIf
	endEvent
endState
state ResetPlayerSexStats
	event OnSelectST()
		bool run = ShowMessage("$SSL_WarnResetStats")
		if run
			Stats._Setup()
			ShowMessage("$SSL_RunResetStats", false)
		endIf
	endEvent
endState
state CleanSystem
	event OnSelectST()
		bool run = ShowMessage("$SSL_WarnCleanSystem")
		if run
			ShowMessage("$SSL_RunCleanSystem", false)
			_SetupSystem()
			mCleanSystemFinish.Show()
		endIf
	endEvent
endState
state RebuildStraponList
	event OnSelectST()
		FindStrapons()
		int found = ActorLib.Strapons.Length
		if found > 0
			ShowMessage("$SSL_FoundStrapon", false)
		else
			ShowMessage("$SSL_NoStrapons", false)
		endIf
		ForcePageReset()
	endEvent
endState



event OnOptionSliderOpen(int option)
	if option == oidStageTimer[0]
		SetSliderDialogStartValue(ThreadLib.fStageTimer[0])
		SetSliderDialogDefaultValue(30.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)
	elseIf option == oidStageTimer[1]
		SetSliderDialogStartValue(ThreadLib.fStageTimer[1])
		SetSliderDialogDefaultValue(20.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)
	elseIf option == oidStageTimer[2]
		SetSliderDialogStartValue(ThreadLib.fStageTimer[2])
		SetSliderDialogDefaultValue(15.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)
	elseIf option == oidStageTimer[3]
		SetSliderDialogStartValue(ThreadLib.fStageTimer[3])
		SetSliderDialogDefaultValue(15.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)
	elseIf option == oidStageTimer[4]
		SetSliderDialogStartValue(ThreadLib.fStageTimer[4])
		SetSliderDialogDefaultValue(7.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)

	elseIf option == oidStageTimerLeadIn[0]
		SetSliderDialogStartValue(ThreadLib.fStageTimerLeadIn[0])
		SetSliderDialogDefaultValue(30.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)
	elseIf option == oidStageTimerLeadIn[1]
		SetSliderDialogStartValue(ThreadLib.fStageTimerLeadIn[1])
		SetSliderDialogDefaultValue(20.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)
	elseIf option == oidStageTimerLeadIn[2]
		SetSliderDialogStartValue(ThreadLib.fStageTimerLeadIn[2])
		SetSliderDialogDefaultValue(15.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)
	elseIf option == oidStageTimerLeadIn[3]
		SetSliderDialogStartValue(ThreadLib.fStageTimerLeadIn[3])
		SetSliderDialogDefaultValue(15.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)
	elseIf option == oidStageTimerLeadIn[4]
		SetSliderDialogStartValue(ThreadLib.fStageTimerLeadIn[4])
		SetSliderDialogDefaultValue(7.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)

	elseIf option == oidStageTimerAggr[0]
		SetSliderDialogStartValue(ThreadLib.fStageTimerAggr[0])
		SetSliderDialogDefaultValue(30.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)
	elseIf option == oidStageTimerAggr[1]
		SetSliderDialogStartValue(ThreadLib.fStageTimerAggr[1])
		SetSliderDialogDefaultValue(20.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)
	elseIf option == oidStageTimerAggr[2]
		SetSliderDialogStartValue(ThreadLib.fStageTimerAggr[2])
		SetSliderDialogDefaultValue(15.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)
	elseIf option == oidStageTimerAggr[3]
		SetSliderDialogStartValue(ThreadLib.fStageTimerAggr[3])
		SetSliderDialogDefaultValue(15.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)
	elseIf option == oidStageTimerAggr[4]
		SetSliderDialogStartValue(ThreadLib.fStageTimerAggr[4])
		SetSliderDialogDefaultValue(7.0)
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)
	endIf
endEvent

event OnOptionSliderAccept(int option, float value)
	if option == oidStageTimer[0]
		ThreadLib.fStageTimer[0] = value
		SetSliderOptionValue(oidStageTimer[0], value, "$SSL_Seconds")
	elseIf option == oidStageTimer[1]
		ThreadLib.fStageTimer[1] = value
		SetSliderOptionValue(oidStageTimer[1], value, "$SSL_Seconds")
	elseIf option == oidStageTimer[2]
		ThreadLib.fStageTimer[2] = value
		SetSliderOptionValue(oidStageTimer[2], value, "$SSL_Seconds")
	elseIf option == oidStageTimer[3]
		ThreadLib.fStageTimer[3] = value
		SetSliderOptionValue(oidStageTimer[3], value, "$SSL_Seconds")
	elseIf option == oidStageTimer[4]
		ThreadLib.fStageTimer[4] = value
		SetSliderOptionValue(oidStageTimer[4], value, "$SSL_Seconds")

	elseIf option == oidStageTimerLeadIn[0]
		ThreadLib.fStageTimerLeadIn[0] = value
		SetSliderOptionValue(oidStageTimerLeadIn[0], value, "$SSL_Seconds")
	elseIf option == oidStageTimerLeadIn[1]
		ThreadLib.fStageTimerLeadIn[1] = value
		SetSliderOptionValue(oidStageTimerLeadIn[1], value, "$SSL_Seconds")
	elseIf option == oidStageTimerLeadIn[2]
		ThreadLib.fStageTimerLeadIn[2] = value
		SetSliderOptionValue(oidStageTimerLeadIn[2], value, "$SSL_Seconds")
	elseIf option == oidStageTimerLeadIn[3]
		ThreadLib.fStageTimerLeadIn[3] = value
		SetSliderOptionValue(oidStageTimerLeadIn[3], value, "$SSL_Seconds")
	elseIf option == oidStageTimerLeadIn[4]
		ThreadLib.fStageTimerLeadIn[4] = value
		SetSliderOptionValue(oidStageTimerLeadIn[4], value, "$SSL_Seconds")

	elseIf option == oidStageTimerAggr[0]
		ThreadLib.fStageTimerAggr[0] = value
		SetSliderOptionValue(oidStageTimerAggr[0], value, "$SSL_Seconds")
	elseIf option == oidStageTimerAggr[1]
		ThreadLib.fStageTimerAggr[1] = value
		SetSliderOptionValue(oidStageTimerAggr[1], value, "$SSL_Seconds")
	elseIf option == oidStageTimerAggr[2]
		ThreadLib.fStageTimerAggr[2] = value
		SetSliderOptionValue(oidStageTimerAggr[2], value, "$SSL_Seconds")
	elseIf option == oidStageTimerAggr[3]
		ThreadLib.fStageTimerAggr[3] = value
		SetSliderOptionValue(oidStageTimerAggr[3], value, "$SSL_Seconds")
	elseIf option == oidStageTimerAggr[4]
		ThreadLib.fStageTimerAggr[4] = value
		SetSliderOptionValue(oidStageTimerAggr[4], value, "$SSL_Seconds")
	endIf
endEvent

event OnOptionSelect(int option)
	int i = 0
	while i < 128
		if option == oidToggleVoice[i]
			VoiceSlots.Voices[i].Enabled = !VoiceSlots.Voices[i].Enabled
			SetToggleOptionValue(option, VoiceSlots.Voices[i].Enabled)
			i = 128
		elseif option == oidToggleAnimation[i]
			AnimSlots.Animations[i].Enabled = !AnimSlots.Animations[i].Enabled
			SetToggleOptionValue(option, AnimSlots.Animations[i].Enabled)
			i = 128
		elseif option == oidAggrAnimation[i]
			if !AnimSlots.Animations[i].HasTag("Aggressive")
				AnimSlots.Animations[i].AddTag("Aggressive")
			else
				AnimSlots.Animations[i].RemoveTag("Aggressive")
			endIf
			SetToggleOptionValue(option, AnimSlots.Animations[i].HasTag("Aggressive"))
			i = 128
		elseif option == oidForeplayAnimation[i]
			if !AnimSlots.Animations[i].HasTag("LeadIn")
				AnimSlots.Animations[i].AddTag("LeadIn")
			else
				AnimSlots.Animations[i].RemoveTag("LeadIn")
			endIf
			SetToggleOptionValue(option, AnimSlots.Animations[i].HasTag("LeadIn"))
			i = 128
		elseIf i < 33 && option == oidStripMale[i]
			ThreadLib.bStripMale[i] = !ThreadLib.bStripMale[i] 
			SetToggleOptionValue(option, ThreadLib.bStripMale[i])
			i = 128
		elseIf i < 33 && option == oidStripFemale[i]
			ThreadLib.bStripFemale[i] = !ThreadLib.bStripFemale[i] 
			SetToggleOptionValue(option, ThreadLib.bStripFemale[i])
			i = 128
		elseIf i < 33 && option == oidStripLeadInMale[i]
			ThreadLib.bStripLeadInMale[i] = !ThreadLib.bStripLeadInMale[i] 
			SetToggleOptionValue(option, ThreadLib.bStripLeadInMale[i])
			i = 128
		elseIf i < 33 && option == oidStripLeadInFemale[i]
			ThreadLib.bStripLeadInFemale[i] = !ThreadLib.bStripLeadInFemale[i] 
			SetToggleOptionValue(option, ThreadLib.bStripLeadInFemale[i])
			i = 128
		elseIf i < 33 && option == oidStripVictim[i]
			ThreadLib.bStripVictim[i] = !ThreadLib.bStripVictim[i] 
			SetToggleOptionValue(option, ThreadLib.bStripVictim[i])
			i = 128
		elseIf i < 33 && option == oidStripAggressor[i]
			ThreadLib.bStripAggressor[i] = !ThreadLib.bStripAggressor[i] 
			SetToggleOptionValue(option, ThreadLib.bStripAggressor[i])
			i = 128
		elseIf i < 10 && option == oidRemoveStrapon[i]
			form[] strapons = ActorLib.Strapons
			form toRemove = strapons[i]
			form[] newStrapons
			int s = 0
			while s < strapons.Length
				if strapons[s] != toRemove
					newStrapons = sslUtility.PushForm(strapons[s], newStrapons)
				endIf
				s += 1
			endWhile
			ActorLib.Strapons = newStrapons
			ForcePageReset()
			i = 128
		endIf
		i += 1
	endWhile
endEvent

event OnOptionHighlight(int option)
	; What are we?
	int i = 0
	while i < 128
		if option == oidToggleVoice[i]
			SetInfoText("$SSL_EnableVoice")
			i = 128
		elseif option == oidToggleAnimation[i]
			SetInfoText("$SSL_EnableAnimation")
			i = 128
		elseif option == oidForeplayAnimation[i]
			SetInfoText("$SSL_ToggleForeplay")
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
endEvent

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
		return "$SSL_MiscSlot48"
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
		return "$SSL_MiscSlot60"
	elseif slot == 61
		return "$SSL_MiscSlot61"
	elseif slot == 62
		return "$SSL_Weapons"
	else
		return "$SSL_Unknown"
	endIf
endFunction

function FindStrapons()
	ActorLib.Strapons = new form[1]
	ActorLib.Strapons[0] = aCalypsStrapon

	ActorLib.LoadStrapon("StrapOnbyaeonv1.1.esp", 0x0D65)
	ActorLib.LoadStrapon("TG.esp", 0x0182B)

	armor check = ActorLib.LoadStrapon("Futa equippable.esp", 0x0D66)
	if check != none
		ActorLib.LoadStrapon("Futa equippable.esp", 0x0D67)
		ActorLib.LoadStrapon("Futa equippable.esp", 0x01D96)
		ActorLib.LoadStrapon("Futa equippable.esp", 0x022FB)
		ActorLib.LoadStrapon("Futa equippable.esp", 0x022FC)
		ActorLib.LoadStrapon("Futa equippable.esp", 0x022FD)
	endIf

	check = ActorLib.LoadStrapon("Skyrim_Strap_Ons.esp", 0x00D65)
	if check != none
		ActorLib.LoadStrapon("Skyrim_Strap_Ons.esp", 0x02859)
		ActorLib.LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285A)
		ActorLib.LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285B)
		ActorLib.LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285C)
		ActorLib.LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285D)
		ActorLib.LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285E)
		ActorLib.LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285F)
	endIf
endFunction

function _SetupSystem()
	; Init Stats
	Stats._Setup()
	; Init animations
	AnimSlots._Setup()
	; Init voices
	VoiceSlots._Setup()
	; Init Alias Slots
	ActorSlots._Setup()
	; Init Thread Controllers
	ThreadSlots._Setup()
	; Init Sexlab
	SexLab._Setup()
	; Init Defaults
	SetDefaults()
	; Finished
	Debug.TraceAndBox("SexLab v"+GetStringVer()+" has finished installing")
endFunction

function _CheckSystem()
	; Refresh system init
	SexLab._Setup()
	; Check SKSE Version
	float skseNeeded = 1.0609
	float skseInstalled = SKSE.GetVersion() + SKSE.GetVersionMinor() * 0.01 + SKSE.GetVersionBeta() * 0.0001
	if skseInstalled == 0
		mNoSKSE.Show()
		SexLab._EnableSystem(false)
	elseif skseInstalled < skseNeeded
		mOldSKSE.Show(skseInstalled, skseNeeded)
		SexLab._EnableSystem(false)
	endIf
	; Check Skyrim Version
	float skyrimNeeded = 1.8
	float skyrimMajor = StringUtil.SubString(Debug.GetVersionNumber(), 0, 3) as float
	if skyrimMajor < skyrimNeeded
		mOldSkyrim.Show(skyrimMajor, skyrimNeeded)
		SexLab._EnableSystem(false)
	endIf
	; Check for Schlongs of Skyrim
	ActorLib.sosEnabled = false
	form check = Game.GetFormFromFile(0x0D64, "Schlongs of Skyrim.esp") ; Armor SkinNaked
	if check != none
		ActorLib.sosEnabled = true
		Debug.Trace("SexLab Compatibility: 'Schlongs of Skyrim.esp' was found")
	else
		check = Game.GetFormFromFile(0x0D67, "Schlongs of Skyrim - Light.esp") ; ArmorAddon NakedTorso
		if check != none
			ActorLib.sosEnabled = true
			Debug.Trace("SexLab Compatibility: 'Schlongs of Skyrim - Light.esp' was found")
		endIf
	endIf
	; Add debug spell
	if DebugMode() && !PlayerRef.HasSpell(SexLabDebugSpell)
		PlayerRef.AddSpell(SexLabDebugSpell, true)
	endIf
endFunction