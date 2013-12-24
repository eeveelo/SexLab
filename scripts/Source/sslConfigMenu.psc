scriptname sslConfigMenu extends SKI_ConfigBase
{Skyrim SexLab Mod Configuration Menu}

int function GetVersion()
	return 13101
endFunction

string function GetStringVer()
	return StringUtil.Substring(((GetVersion() as float / 10000.0) as string), 0, 4)
endFunction

bool function DebugMode()
	return false
endFunction

event OnVersionUpdate(int version)
	float current = (CurrentVersion as float / 10000.0)
	float latest = (version as float / 10000.0)
	; Notify update
	if CurrentVersion < GetVersion()
		Debug.Notification("Updating to SexLab v"+GetStringVer())
		; Resetup system
		if CurrentVersion > 0
			_SetupSystem()
		endIf
	endIf
endEvent

event OnConfigInit()
	; Init System
	_SetupSystem()
	; Init Stats
	Stats._Setup()
endEvent

event OnGameReload()
	parent.OnGameReload()
	_CheckSystem()
	ThreadSlots._StopAll()
	ActorLib.ValidActorList.RemoveAddedForm(PlayerRef)
endEvent

; Framework
SexLabFramework property SexLab auto

sslAnimationSlots property AnimSlots auto
sslAnimationLibrary property AnimLib auto

sslCreatureAnimationSlots property CreatureAnimSlots auto

sslVoiceSlots property VoiceSlots auto
sslVoiceLibrary property VoiceLib auto

sslExpressionSlots property ExpressionSlots auto
sslExpressionLibrary property ExpressionLib auto

sslThreadSlots property ThreadSlots auto
sslThreadLibrary property ThreadLib auto

sslActorSlots property ActorSlots auto
sslActorLibrary property ActorLib auto
sslActorStats property Stats auto

sslControlLibrary property ControlLib auto

; Data
actor property PlayerRef auto
message property mOldSkyrim auto
message property mOldSKSE auto
message property mNoSKSE auto
message property mCleanSystemFinish auto
message property mSystemDisabled auto
message property mSystemUpdated auto
spell property SexLabDebugSpell auto
armor property aCalypsStrapon auto

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
	AnimLib._Defaults()
	VoiceLib._Defaults()
	ExpressionLib._Defaults()
	ActorLib._Defaults()
	ThreadLib._Defaults()
	ControlLib._Defaults()

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
	if PlayerRef.GetLeveledActorBase().GetSex() > 0
		Pages[11] = "$SSL_SexDiary"
	else
		Pages[11] = "$SSL_SexJournal"
	endIf
	Pages[12] = "$SSL_RebuildClean"

	FindStrapons()
endFunction

event OnPageReset(string page)
	int i

	if page == ""
		LoadCustomContent("SexLab/logo.dds", 184, 31)
		return
	else
		UnloadCustomContent()
	endIf

	if page == "$SSL_AnimationSettings"
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption("$SSL_PlayerSettings")
		AddToggleOptionST("AutoAdvance","$SSL_AutoAdvanceStages", ThreadLib.bAutoAdvance)
		AddToggleOptionST("DisableVictim","$SSL_DisableVictimControls", ActorLib.bDisablePlayer)
		AddToggleOptionST("AutomaticTFC","$SSL_AutomaticTFC", ControlLib.bAutoTFC)
		AddSliderOptionST("AutomaticSUCSM","$SSL_AutomaticSUCSM", ControlLib.fAutoSUCSM, "{0}")

		AddHeaderOption("$SSL_ExtraEffects")
		AddToggleOptionST("ScaleActors","$SSL_EvenActorsHeight", ActorLib.bScaleActors)
		AddToggleOptionST("ReDressVictim","$SSL_VictimsRedress", ActorLib.bReDressVictim)
		AddToggleOptionST("UseCum","$SSL_ApplyCumEffects", ActorLib.bUseCum)
		AddToggleOptionST("AllowFemaleFemaleCum","$SSL_AllowFemaleFemaleCum", ActorLib.bAllowFFCum)
		AddSliderOptionST("CumEffectTimer","$SSL_CumEffectTimer", ActorLib.fCumTimer, "$SSL_Seconds")
		AddToggleOptionST("OrgasmEffects","$SSL_OrgasmEffects", ThreadLib.bOrgasmEffects)

		SetCursorPosition(1)
		AddHeaderOption("$SSL_AnimationHandling")
		AddToggleOptionST("AllowCreatures","$SSL_AllowCreatures", AnimLib.bAllowCreatures)
		AddToggleOptionST("RagdollEnd","$SSL_RagdollEnding", ActorLib.bRagdollEnd)
		AddToggleOptionST("ForeplayStage","$SSL_PreSexForeplay", ThreadLib.bForeplayStage)
		AddToggleOptionST("RestrictAggressive","$SSL_RestrictAggressive", AnimLib.bRestrictAggressive)
		AddToggleOptionST("UndressAnimation","$SSL_UndressAnimation", ActorLib.bUndressAnimation)
		AddToggleOptionST("StraponsFemale","$SSL_FemalesUseStrapons", ActorLib.bUseStrapons)
		AddToggleOptionST("NudeSuitMales","$SSL_UseNudeSuitMales", ActorLib.bUseMaleNudeSuit)
		AddToggleOptionST("NudeSuitFemales","$SSL_UseNudeSuitFemales", ActorLib.bUseFemaleNudeSuit)
		AddTextOptionST("NPCBed","$SSL_NPCsUseBeds", ThreadLib.sNPCBed)

	elseIf page == "$SSL_SoundSettings"
		SetCursorFillMode(LEFT_TO_RIGHT)

		; Voices & SFX
		AddTextOptionST("PlayerVoice","$SSL_PCVoice", VoiceLib.sPlayerVoice)
		AddToggleOptionST("NPCSaveVoice","$SSL_NPCSaveVoice", VoiceLib.bNPCSaveVoice)
		AddSliderOptionST("SFXVolume","$SSL_SFXVolume", (ThreadLib.fSFXVolume * 100), "{0}%")
		AddSliderOptionST("VoiceVolume","$SSL_VoiceVolume", (ActorLib.fVoiceVolume * 100), "{0}%")
		AddSliderOptionST("SFXDelay","$SSL_SFXDelay", ThreadLib.fSFXDelay, "$SSL_Seconds")
		AddSliderOptionST("MaleVoiceDelay","$SSL_MaleVoiceDelay", ActorLib.fMaleVoiceDelay, "$SSL_Seconds")
		AddEmptyOption()
		AddSliderOptionST("FemaleVoiceDelay","$SSL_FemaleVoiceDelay", ActorLib.fFemaleVoiceDelay, "$SSL_Seconds")


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

	elseIf page == "$SSL_PlayerHotkeys"
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption("$SSL_SceneManipulation")
		AddKeyMapOptionST("BackwardsModifier", "$SSL_ReverseDirectionModifier", ControlLib.kBackwards)
		AddKeyMapOptionST("AdvanceAnimation", "$SSL_AdvanceAnimationStage", ControlLib.kAdvanceAnimation)
		AddKeyMapOptionST("ChangeAnimation", "$SSL_ChangeAnimationSet", ControlLib.kChangeAnimation)
		AddKeyMapOptionST("ChangePositions", "$SSL_SwapActorPositions", ControlLib.kChangePositions)
		AddKeyMapOptionST("MoveSceneLocation", "$SSL_MoveSceneLocation", ControlLib.kMoveScene)
		AddKeyMapOptionST("RotateScene", "$SSL_RotateScene", ControlLib.kRotateScene)
		AddKeyMapOptionST("ToggleFreeCamera", "$SSL_ToggleFreeCamera", ControlLib.kToggleFreeCamera)

		SetCursorPosition(1)

		AddHeaderOption("$SSL_AlignmentAdjustments")
		AddKeyMapOptionST("AdjustStage","$SSL_AdjustStage", ControlLib.kAdjustStage)
		AddKeyMapOptionST("AdjustChange","$SSL_ChangeActorBeingMoved", ControlLib.kAdjustChange)
		AddKeyMapOptionST("AdjustForward","$SSL_MoveActorForwardBackward", ControlLib.kAdjustForward)
		AddKeyMapOptionST("AdjustUpward","$SSL_AdjustPositionUpwardDownward", ControlLib.kAdjustUpward)
		AddKeyMapOptionST("AdjustSideways","$SSL_MoveActorLeftRight", ControlLib.kAdjustSideways)
		AddKeyMapOptionST("RealignActors","$SSL_RealignActors", ControlLib.kRealignActors)
		AddKeyMapOptionST("RestoreOffsets","$SSL_DeleteSavedAdjustments", ControlLib.kRestoreOffsets)

	elseIf page == "$SSL_NormalTimersStripping"
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption("$SSL_ConsensualStageTimers")
		oidStageTimer[0] = AddSliderOption("$SSL_Stage1Length", ThreadLib.fStageTimer[0], "$SSL_Seconds")
		oidStageTimer[1] = AddSliderOption("$SSL_Stage2Length", ThreadLib.fStageTimer[1], "$SSL_Seconds")
		oidStageTimer[2] = AddSliderOption("$SSL_Stage3Length", ThreadLib.fStageTimer[2], "$SSL_Seconds")
		AddEmptyOption()

		AddHeaderOption("$SSL_FemaleStripFrom")
		oidStripFemale[32] = AddToggleOption("$SSL_Weapons", ActorLib.bStripFemale[32])
		i = 0
		while i < 32
			int slot = i + 30
			string name = GetSlotName(slot)
			if name != "IGNORE"
				oidStripFemale[i] = AddToggleOption(name, ActorLib.bStripFemale[i])
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
		oidStripMale[32] = AddToggleOption("$SSL_Weapons", ActorLib.bStripMale[32])
		i = 0
		while i < 32
			int slot = i + 30
			string name = GetSlotName(slot)
			if name != "IGNORE"
				oidStripMale[i] = AddToggleOption(name, ActorLib.bStripMale[i])
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
		oidStripVictim[32] = AddToggleOption("$SSL_Weapons", ActorLib.bStripLeadInFemale[32])
		i = 0
		while i < 32
			int slot = i + 30
			string name = GetSlotName(slot)
			if name != "IGNORE"
				oidStripLeadInFemale[i] = AddToggleOption(name, ActorLib.bStripLeadInFemale[i])
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
		oidStripAggressor[32] = AddToggleOption("$SSL_Weapons", ActorLib.bStripLeadInMale[32])
		i = 0
		while i < 32
			int slot = i + 30
			string name = GetSlotName(slot)
			if name != "IGNORE"
				oidStripLeadInMale[i] = AddToggleOption(name, ActorLib.bStripLeadInMale[i])
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
		oidStripVictim[32] = AddToggleOption("$SSL_Weapons", ActorLib.bStripVictim[32])
		i = 0
		while i < 32
			int slot = i + 30
			string name = GetSlotName(slot)
			if name != "IGNORE"
				oidStripVictim[i] = AddToggleOption(name, ActorLib.bStripVictim[i])
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
		oidStripAggressor[32] = AddToggleOption("$SSL_Weapons", ActorLib.bStripAggressor[32])
		i = 0
		while i < 32
			int slot = i + 30
			string name = GetSlotName(slot)
			if name != "IGNORE"
				oidStripAggressor[i] = AddToggleOption(name, ActorLib.bStripAggressor[i])
			endIf
			if slot == 43
				AddHeaderOption("$SSL_ExtraSlots")
			endIf
			i += 1
		endWhile

	elseIf page == "$SSL_ToggleAnimations"
		SetCursorFillMode(LEFT_TO_RIGHT)

		i = 0
		while i < AnimSlots.Slotted
			if AnimSlots.Slots[i].Registered
				oidToggleAnimation[i] = AddToggleOption(AnimSlots.Slots[i].Name, AnimSlots.Slots[i].Enabled)
			endIf
			i += 1
		endWhile

	elseIf page == "$SSL_ForeplayAnimations"
		SetCursorFillMode(LEFT_TO_RIGHT)

		i = 0
		while i < AnimSlots.Slotted
			if AnimSlots.Slots[i].Registered
				oidForeplayAnimation[i] = AddToggleOption(AnimSlots.Slots[i].Name, AnimSlots.Slots[i].HasTag("LeadIn"))
			endIf
			i += 1
		endWhile

	elseIf page == "$SSL_AggressiveAnimations"
		SetCursorFillMode(LEFT_TO_RIGHT)

		i = 0
		while i < AnimSlots.Slotted
			if AnimSlots.Slots[i].Registered
				oidAggrAnimation[i] = AddToggleOption(AnimSlots.Slots[i].Name, AnimSlots.Slots[i].HasTag("Aggressive"))
			endIf
			i += 1
		endWhile

	elseIf page == "$SSL_CreatureAnimations"
		SetCursorFillMode(LEFT_TO_RIGHT)
		i = 0
		while i < CreatureAnimSlots.Slotted
			if CreatureAnimSlots.Slots[i].Registered
				oidToggleCreatureAnimation[i] = AddToggleOption(CreatureAnimSlots.Slots[i].Name, CreatureAnimSlots.Slots[i].Enabled)
			endIf
			i += 1
		endWhile

	elseIf page == "$SSL_ExpressionSelection"
		SetCursorFillMode(LEFT_TO_RIGHT)

		AddHeaderOption("$SSL_ExpressionsNormal")
		AddHeaderOption("")
		i = 0
		while i < ExpressionSlots.Slotted
			if ExpressionSlots.Expression[i].Registered
				oidToggleExpressionNormal[i] = AddToggleOption(ExpressionSlots.Expression[i].Name, ExpressionSlots.Expression[i].HasTag("Normal"))
			endIf
			i += 1
		endWhile

		if ExpressionSlots.Slotted % 2 != 0
			AddEmptyOption()
		endIf

		AddHeaderOption("$SSL_ExpressionsVictim")
		AddHeaderOption("")
		i = 0
		while i < ExpressionSlots.Slotted
			if ExpressionSlots.Expression[i].Registered
				oidToggleExpressionVictim[i] = AddToggleOption(ExpressionSlots.Expression[i].Name, ExpressionSlots.Expression[i].HasTag("Victim"))
			endIf
			i += 1
		endWhile

		if ExpressionSlots.Slotted % 2 != 0
			AddEmptyOption()
		endIf

		AddHeaderOption("$SSL_ExpressionsAggressor")
		AddHeaderOption("")
		i = 0
		while i < ExpressionSlots.Slotted
			if ExpressionSlots.Expression[i].Registered
				oidToggleExpressionAggressor[i] = AddToggleOption(ExpressionSlots.Expression[i].Name, ExpressionSlots.Expression[i].HasTag("Aggressor"))
			endIf
			i += 1
		endWhile

	elseIf page == "$SSL_SexDiary" || page == "$SSL_SexJournal"
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption("$SSL_SexualExperience")
		AddTextOption("$SSL_TimeSpentHavingSex", Stats.ParseTime(Stats.fTimeSpent as int))
		AddTextOption("$SSL_MaleSexualPartners", Stats.iMalePartners)
		AddTextOption("$SSL_FemaleSexualPartners", Stats.iFemalePartners)
		AddTextOption("$SSL_CreatureSexualPartners", Stats.iCreaturePartners)
		AddTextOption("$SSL_TimesMasturbated", Stats.iMasturbationCount)
		AddTextOption("$SSL_VaginalExperience", Stats.iVaginalCount)
		AddTextOption("$SSL_AnalExperience", Stats.iAnalCount)
		AddTextOption("$SSL_OralExperience", Stats.iOralCount)
		AddTextOption("$SSL_TimesVictim", Stats.iVictimCount)
		AddTextOption("$SSL_TimesAggressive", Stats.iAggressorCount)

		SetCursorPosition(1)
		AddHeaderOption("$SSL_SexualStats")
		AddTextOption("$SSL_Sexuality", Stats.GetPlayerSexualityTitle())
		if Stats.GetPlayerPurityLevel() < 0
			AddTextOption("$SSL_SexualPerversion", Stats.GetPlayerPurityTitle())
		else
			AddTextOption("$SSL_SexualPurity", Stats.GetPlayerPurityTitle())
		endIf
		AddTextOption("$SSL_VaginalProficiency", Stats.GetPlayerSkillTitle("Vaginal"))
		AddTextOption("$SSL_AnalProficiency", Stats.GetPlayerSkillTitle("Anal"))
		AddTextOption("$SSL_OralProficiency", Stats.GetPlayerSkillTitle("Oral"))
		AddEmptyOption()
		; Custom stats set by other mods
		i = 0
		while i < Stats.CustomStats.Length
			string stat = Stats.CustomStats[i]
			AddTextOption(stat, Stats.GetStatFull(stat))
			i += 1
		endWhile

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
		AddHeaderOption("")
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
		ActorLib.bUndressAnimation = false
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
state OrgasmEffects
	event OnSelectST()
		ThreadLib.bOrgasmEffects = !ThreadLib.bOrgasmEffects
		SetToggleOptionValueST(ThreadLib.bOrgasmEffects)
	endEvent
	event OnDefaultST()
		ThreadLib.bOrgasmEffects = true
		SetToggleOptionValueST(ThreadLib.bOrgasmEffects)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoOrgasmEffects")
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
		SetSliderDialogRange(5.0, 900.0)
		SetSliderDialogInterval(5.0)
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
state AllowCreatures
	event OnSelectST()
		AnimLib.bAllowCreatures = !AnimLib.bAllowCreatures
		SetToggleOptionValueST(AnimLib.bAllowCreatures)
	endEvent
	event OnDefaultST()
		AnimLib.bAllowCreatures = false
		SetToggleOptionValueST(AnimLib.bAllowCreatures)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAllowCreatures")
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
		SetInfoText("$SSL_InfoForeplayStage")
	endEvent
endState
state PlayerTCL
	event OnSelectST()
		ActorLib.bEnableTCL = !ActorLib.bEnableTCL
		SetToggleOptionValueST(ActorLib.bEnableTCL)
	endEvent
	event OnDefaultST()
		ActorLib.bEnableTCL = false
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
state AutomaticTFC
	event OnSelectST()
		ControlLib.bAutoTFC = !ControlLib.bAutoTFC
		SetToggleOptionValueST(ControlLib.bAutoTFC)
	endEvent
	event OnDefaultST()
		ControlLib.bAutoTFC = false
		SetToggleOptionValueST(ControlLib.bAutoTFC)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAutomaticTFC")
	endEvent
endState
state AutomaticSUCSM
	event OnSliderOpenST()
		SetSliderDialogStartValue(ControlLib.fAutoSUCSM)
		SetSliderDialogDefaultValue(3.0)
		SetSliderDialogRange(1.0, 20.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		ControlLib.fAutoSUCSM = value
		SetSliderOptionValueST(ControlLib.fAutoSUCSM, "{0}")
	endEvent
	event OnDefaultST()
		ControlLib.fAutoSUCSM = 5.0
		SetToggleOptionValueST(ControlLib.fAutoSUCSM, "{0}")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAutomaticSUCSM")
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
state NPCSaveVoice
	event OnSelectST()
		VoiceLib.bNPCSaveVoice = !VoiceLib.bNPCSaveVoice
		SetToggleOptionValueST(VoiceLib.bNPCSaveVoice)
	endEvent
	event OnDefaultST()
		VoiceLib.bNPCSaveVoice = true
		SetToggleOptionValueST(VoiceLib.bNPCSaveVoice)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoNPCSaveVoice")
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
		SetSliderOptionValueST(value, "{0}%")
	endEvent
	event OnDefaultST()
		ActorLib.fVoiceVolume = 1.0
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
		ThreadLib.fSFXVolume = 1.0
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
			ControlLib.kBackwards = newKeyCode
			SetKeyMapOptionValueST(ControlLib.kBackwards)
		endIf
	endEvent
	event OnDefaultST()
		ControlLib.kBackwards = 54
		SetKeyMapOptionValueST(ControlLib.kBackwards)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoBackwards")
	endEvent
endState
state AdvanceAnimation
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			ControlLib.kAdvanceAnimation = newKeyCode
			SetKeyMapOptionValueST(ControlLib.kAdvanceAnimation)
		endIf
	endEvent
	event OnDefaultST()
		ControlLib.kAdvanceAnimation = 57
		SetKeyMapOptionValueST(ControlLib.kAdvanceAnimation)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAdvanceAnimation")
	endEvent
endState
state ChangeAnimation
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			ControlLib.kChangeAnimation = newKeyCode
			SetKeyMapOptionValueST(ControlLib.kChangeAnimation)
		endIf
	endEvent
	event OnDefaultST()
		ControlLib.kChangeAnimation = 24
		SetKeyMapOptionValueST(ControlLib.kChangeAnimation)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoChangeAnimation")
	endEvent
endState
state ChangePositions
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			ControlLib.kChangePositions = newKeyCode
			SetKeyMapOptionValueST(ControlLib.kChangePositions)
		endIf
	endEvent
	event OnDefaultST()
		ControlLib.kChangePositions = 13
		SetKeyMapOptionValueST(ControlLib.kChangePositions)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoChangePositions")
	endEvent
endState
state MoveSceneLocation
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			ControlLib.kMoveScene = newKeyCode
			SetKeyMapOptionValueST(ControlLib.kMoveScene)
		endIf
	endEvent
	event OnDefaultST()
		ControlLib.kMoveScene = 27
		SetKeyMapOptionValueST(ControlLib.kMoveScene)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoMoveScene")
	endEvent
endState
state RotateScene
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			ControlLib.kRotateScene = newKeyCode
			SetKeyMapOptionValueST(ControlLib.kRotateScene)
		endIf
	endEvent
	event OnDefaultST()
		ControlLib.kRotateScene = 22
		SetKeyMapOptionValueST(ControlLib.kRotateScene)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoRotateScene")
	endEvent
endState
state ToggleFreeCamera
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			ControlLib.kToggleFreeCamera = newKeyCode
			SetKeyMapOptionValueST(ControlLib.kToggleFreeCamera)
		endIf
	endEvent
	event OnDefaultST()
		ControlLib.kToggleFreeCamera = 81
		SetKeyMapOptionValueST(ControlLib.kToggleFreeCamera)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoToggleFreeCamera")
	endEvent
endState
state AdjustStage
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			ControlLib.kAdjustStage = newKeyCode
			SetKeyMapOptionValueST(ControlLib.kAdjustStage)
		endIf
	endEvent
	event OnDefaultST()
		ControlLib.kAdjustStage = 157
		SetKeyMapOptionValueST(ControlLib.kAdjustStage)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAdjustStage")
	endEvent
endState

state AdjustChange
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			ControlLib.kAdjustChange = newKeyCode
			SetKeyMapOptionValueST(ControlLib.kAdjustChange)
		endIf
	endEvent
	event OnDefaultST()
		ControlLib.kAdjustChange = 37
		SetKeyMapOptionValueST(ControlLib.kAdjustChange)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAdjustChange")
	endEvent
endState
state AdjustForward
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			ControlLib.kAdjustForward = newKeyCode
			SetKeyMapOptionValueST(ControlLib.kAdjustForward)
		endIf
	endEvent
	event OnDefaultST()
		ControlLib.kAdjustForward = 38
		SetKeyMapOptionValueST(ControlLib.kAdjustForward)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAdjustForward")
	endEvent
endState
state AdjustUpward
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			ControlLib.kAdjustUpward = newKeyCode
			SetKeyMapOptionValueST(ControlLib.kAdjustUpward)
		endIf
	endEvent
	event OnDefaultST()
		ControlLib.kAdjustUpward = 39
		SetKeyMapOptionValueST(ControlLib.kAdjustUpward)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAdjustUpward")
	endEvent
endState
state AdjustSideways
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			ControlLib.kAdjustSideways = newKeyCode
			SetKeyMapOptionValueST(ControlLib.kAdjustSideways)
		endIf
	endEvent
	event OnDefaultST()
		ControlLib.kAdjustSideways = 40
		SetKeyMapOptionValueST(ControlLib.kAdjustSideways)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAdjustSideways")
	endEvent
endState
state RealignActors
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			ControlLib.kRealignActors = newKeyCode
			SetKeyMapOptionValueST(ControlLib.kRealignActors)
		endIf
	endEvent
	event OnDefaultST()
		ControlLib.kRealignActors = 26
		SetKeyMapOptionValueST(ControlLib.kRealignActors)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoRealignActors")
	endEvent
endState
state RestoreOffsets
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			ControlLib.kRestoreOffsets = newKeyCode
			SetKeyMapOptionValueST(ControlLib.kRestoreOffsets)
		endIf
	endEvent
	event OnDefaultST()
		ControlLib.kRestoreOffsets = 12
		SetKeyMapOptionValueST(ControlLib.kRestoreOffsets)
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
		if ShowMessage("$SSL_WarnRestoreDefaults")
			SetDefaults()
			ShowMessage("$SSL_RunRestoreDefaults", false)
			ForcePageReset()
		endIf
	endEvent
endState
state ResetAnimationRegistry
	event OnSelectST()
		if ShowMessage("$SSL_WarnRebuildAnimations")
			Utility.Wait(0.10)
			ThreadSlots._StopAll()
			AnimSlots._Setup()
			CreatureAnimSlots._Setup()
			Debug.Notification("$SSL_RunRebuildAnimations")
		endIf
	endEvent
endState
state ResetVoiceRegistry
	event OnSelectST()
		if ShowMessage("$SSL_WarnRebuildVoices")
			Utility.Wait(0.10)
			VoiceSlots._Setup()
			Debug.Notification("$SSL_RunRebuildVoices")
		endIf
	endEvent
endState
state ResetPlayerSexStats
	event OnSelectST()
		if ShowMessage("$SSL_WarnResetStats")
			Stats._Setup()
			Debug.Notification("$SSL_RunResetStats")
		endIf
	endEvent
endState
state CleanSystem
	event OnSelectST()
		if ShowMessage("$SSL_WarnCleanSystem")
			ShowMessage("$SSL_RunCleanSystem", false)
			Utility.Wait(0.10)
			_SetupSystem()
			mCleanSystemFinish.Show()
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
	int i
	if CurrentPage == "$SSL_SoundSettings"
		i = oidToggleVoice.Find(option)
		VoiceSlots.Voices[i].Enabled = !VoiceSlots.Voices[i].Enabled
		SetToggleOptionValue(option, VoiceSlots.Voices[i].Enabled)
	elseif CurrentPage == "$SSL_CreatureAnimations"
		i = oidToggleCreatureAnimation.Find(option)
		CreatureAnimSlots.Slots[i].Enabled = !CreatureAnimSlots.Slots[i].Enabled
		SetToggleOptionValue(option, CreatureAnimSlots.Slots[i].Enabled)
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
	elseIf CurrentPage == "$SSL_NormalTimersStripping"
		i = oidStripMale.Find(option)
		if i >= 0
			ActorLib.bStripMale[i] = !ActorLib.bStripMale[i]
			SetToggleOptionValue(option, ActorLib.bStripMale[i])
		else
			i = oidStripFemale.Find(option)
			ActorLib.bStripFemale[i] = !ActorLib.bStripFemale[i]
			SetToggleOptionValue(option, ActorLib.bStripFemale[i])
		endIf
	elseIf CurrentPage == "$SSL_ForeplayTimersStripping"
		i = oidStripLeadInMale.Find(option)
		if i >= 0
			ActorLib.bStripLeadInMale[i] = !ActorLib.bStripLeadInMale[i]
			SetToggleOptionValue(option, ActorLib.bStripLeadInMale[i])
		else
			i = oidStripLeadInFemale.Find(option)
			ActorLib.bStripLeadInFemale[i] = !ActorLib.bStripLeadInFemale[i]
			SetToggleOptionValue(option, ActorLib.bStripLeadInFemale[i])
		endIf
	elseIf CurrentPage == "$SSL_AggressiveTimersStripping"
		i = oidStripVictim.Find(option)
		if i >= 0
			ActorLib.bStripVictim[i] = !ActorLib.bStripVictim[i]
			SetToggleOptionValue(option, ActorLib.bStripVictim[i])
		else
			i = oidStripAggressor.Find(option)
			ActorLib.bStripAggressor[i] = !ActorLib.bStripAggressor[i]
			SetToggleOptionValue(option, ActorLib.bStripAggressor[i])
		endIf
	elseif CurrentPage == "$SSL_ExpressionSelection"
		i = oidToggleExpressionNormal.Find(option)
		if i != -1
			SetToggleOptionValue(option, ExpressionSlots.Expression[i].ToggleTag("Normal"))
			return
		endIf
		i = oidToggleExpressionVictim.Find(option)
		if i != -1
			SetToggleOptionValue(option, ExpressionSlots.Expression[i].ToggleTag("Victim"))
			return
		endIf
		i = oidToggleExpressionAggressor.Find(option)
		if i != -1
			SetToggleOptionValue(option, ExpressionSlots.Expression[i].ToggleTag("Aggressor"))
			return
		endIf
	elseIf CurrentPage == "$SSL_RebuildClean"
		i = oidRemoveStrapon.Find(option)
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
	endIf
endEvent

event OnOptionHighlight(int option)
	if oidToggleVoice.Find(option) != -1
		SetInfoText("$SSL_EnableVoice")
	elseif oidToggleExpressionNormal.Find(option) != -1
		SetInfoText("$SSL_ToggleExpressionNormal")
	elseif oidToggleExpressionVictim.Find(option) != -1
		SetInfoText("$SSL_ToggleExpressionVictim")
	elseif oidToggleExpressionAggressor.Find(option) != -1
		SetInfoText("$SSL_ToggleExpressionAggressor")
	elseif oidToggleCreatureAnimation.Find(option) != -1
		SetInfoText("$SSL_ToggleCreatureAnimation")
	elseif oidToggleAnimation.Find(option) != -1
		SetInfoText("$SSL_EnableAnimation")
	elseif oidForeplayAnimation.Find(option) != -1
		SetInfoText("$SSL_ToggleForeplay")
	elseif oidAggrAnimation.Find(option) != -1
		SetInfoText("$SSL_ToggleAggressive")
	elseIf oidStripMale.Find(option) != -1
		if oidStripMale.Find(option) != 32
			SetInfoText("$SSL_StripMale")
		else
			SetInfoText("$SSL_StripMaleWeapon")
		endIf
	elseIf oidStripFemale.Find(option) != -1
		if oidStripFemale.Find(option) != 32
			SetInfoText("$SSL_StripFemale")
		else
			SetInfoText("$SSL_StripFemaleWeapon")
		endIf
	elseIf oidStripLeadInFemale.Find(option) != -1
		if oidStripLeadInFemale.Find(option) != 32
			SetInfoText("$SSL_StripLeadInFemale")
		else
			SetInfoText("$SSL_StripLeadInFemaleWeapon")
		endIf
	elseIf oidStripLeadInMale.Find(option) != -1
		if oidStripLeadInMale.Find(option) != 32
			SetInfoText("$SSL_StripLeadInMale")
		else
			SetInfoText("$SSL_StripLeadInMaleWeapon")
		endIf
	elseIf oidStripVictim.Find(option) != -1
		if oidStripVictim.Find(option) != 32
			SetInfoText("$SSL_StripVictim")
		else
			SetInfoText("$SSL_StripVictimWeapon")
		endIf
	elseIf oidStripAggressor.Find(option) != -1
		if oidStripAggressor.Find(option) != 32
			SetInfoText("$SSL_StripAggressor")
		else
			SetInfoText("$SSL_StripAggressorWeapon")
		endIf
	endIf
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

	int mods = Game.GetModCount()
	while mods
		mods -= 1
		string name = Game.GetModName(mods)
		if name == "StrapOnbyaeonv1.1.esp"
			ActorLib.LoadStrapon("StrapOnbyaeonv1.1.esp", 0x0D65)
		elseif name == "TG.esp"
			ActorLib.LoadStrapon("TG.esp", 0x0182B)
		elseif name == "Futa equippable.esp"
			ActorLib.LoadStrapon("Futa equippable.esp", 0x0D66)
			ActorLib.LoadStrapon("Futa equippable.esp", 0x0D67)
			ActorLib.LoadStrapon("Futa equippable.esp", 0x01D96)
			ActorLib.LoadStrapon("Futa equippable.esp", 0x022FB)
			ActorLib.LoadStrapon("Futa equippable.esp", 0x022FC)
			ActorLib.LoadStrapon("Futa equippable.esp", 0x022FD)
		elseif name == "Skyrim_Strap_Ons.esp"
			ActorLib.LoadStrapon("Skyrim_Strap_Ons.esp", 0x00D65)
			ActorLib.LoadStrapon("Skyrim_Strap_Ons.esp", 0x02859)
			ActorLib.LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285A)
			ActorLib.LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285B)
			ActorLib.LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285C)
			ActorLib.LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285D)
			ActorLib.LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285E)
			ActorLib.LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285F)
		elseif name == "SOS Equipable Schlong.esp"
			ActorLib.LoadStrapon("SOS Equipable Schlong.esp", 0x0D62)
		endif
	endWhile
endFunction

function _SetupSystem()
	SexLab._EnableSystem(false)
	; Init animations
	AnimSlots._Setup()
	; Init creature animations
	CreatureAnimSlots._Setup()
	; Init voices
	VoiceSlots._Setup()
	; Init expressions
	ExpressionSlots._Setup()
	; Init Alias Slots
	ActorSlots._Setup()
	; Init Thread Controllers
	ThreadSlots._Setup()
	; Init Sexlab
	SexLab._Setup()
	; Init Defaults
	SetDefaults()
	; Finished
	Debug.Notification("$SSL_SexLabUpdated")
endFunction

function _CheckSystem()
	; Check SKSE Version
	float skseNeeded = 1.0616
	float skseInstalled = SKSE.GetVersion() + SKSE.GetVersionMinor() * 0.01 + SKSE.GetVersionBeta() * 0.0001
	if skseInstalled == 0
		mNoSKSE.Show()
		SexLab._EnableSystem(false)
	elseif skseInstalled < skseNeeded
		mOldSKSE.Show(skseInstalled, skseNeeded)
		SexLab._EnableSystem(false)
	endIf
	; Check Skyrim Version
	float skyrimNeeded = 1.9
	float skyrimMajor = StringUtil.SubString(Debug.GetVersionNumber(), 0, 3) as float
	if skyrimMajor < skyrimNeeded
		mOldSkyrim.Show(skyrimMajor, skyrimNeeded)
		SexLab._EnableSystem(false)
	endIf
	; Check for Schlongs of Skyrim
	ActorLib.sosEnabled = false
	int mods = Game.GetModCount()
	while mods
		mods -= 1
		string name = Game.GetModName(mods)
		if name == "Schlongs of Skyrim.esp" || name == "Schlongs of Skyrim - Light.esp"
			Debug.Trace("SexLab Compatibility: '"+name+"' enabled")
			ActorLib.sosEnabled = true
			mods = 0
		endIf
	endwhile
endFunction
