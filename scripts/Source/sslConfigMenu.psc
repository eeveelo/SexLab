scriptname sslConfigMenu extends SKI_ConfigBase
{Skyrim SexLab Mod Configuration Menu}

import sslUtility

; Proxy to SexLabUtil.psc so modders don't have to add dependency to this script, and thus SkyUI SDK
int function GetVersion()
	return SexLabUtil.GetVersion()
endFunction

string function GetStringVer()
	return SexLabUtil.GetStringVer()
endFunction

event OnVersionUpdate(int version)
	SetupSystem()
endEvent

function SetupSystem()
	; Wait until out of menus to setup resources
	while Utility.IsInMenuMode() || !PlayerRef.Is3DLoaded()
		Utility.Wait(1.0)
	endWhile
	Debug.Notification("Installing SexLab v"+GetStringVer())
	; Stop()
	; Start()
	; Init Defaults and check is sytem is able to install
	if SetDefaults()
		; Disable system from being used during setup
		SexLab.GoToState("Disabled")
		; Setup object slots
		VoiceSlots.Setup()
		ExpressionSlots.Setup()
		CreatureSlots.Setup()
		AnimSlots.Setup()
		ThreadSlots.Setup()
		; Enable system for use
		SexLab.GoToState("Enabled")
		Debug.Notification("$SSL_SexLabUpdated")
		; ALPHA DEBUG
		Config.SetDebugMode(true)
	endIf
endFunction

event OnGameReload()
	parent.OnGameReload()
	Debug.Trace("SexLab Loaded CurrentVerison: "+CurrentVersion)
	; Ensure we have the important varables
	Quest SexLabQuestFramework = Game.GetFormFromFile(0xD62, "SexLab.esm") as Quest
	SexLab = SexLabQuestFramework as SexLabFramework
	Config = SexLabQuestFramework as sslSystemConfig
	; Reload SexLab's voice/tfc config at load
	if CurrentVersion > 0 && Config.CheckSystem()
		TargetRef = none
		RegisterForKey(Config.kTargetActor)
		Config.ReloadConfig()
	else
		SexLab.GoToState("Disabled")
	endIf
endEvent

event OnKeyDown(int keyCode)
	If keyCode == Config.kTargetActor
		RegisterforCrosshairRef()
	endIf
endEvent

event OnCrosshairRefChange(ObjectReference Ref)
	TargetRef = (Ref as Actor)
	if TargetRef != none && TargetRef.HasKeyword(Config.ActorTypeNPC)
		Stats.SeedActor(StatTarget)
		Debug.Notification("SexLab Target Selected: "+TargetRef.GetLeveledActorBase().GetName())
		MiscUtil.PrintConsole("SexLab Target Selected: "+TargetRef.GetLeveledActorBase().GetName())
		UnregisterforCrosshairRef()
	endIF
endEvent

; Data
Actor property PlayerRef auto
Message property CleanSystemFinish auto
Actor TargetRef

; Expression editor
int property Male = 0 autoreadonly
int property Female = 1 autoreadonly
int property Phoneme = 0 autoreadonly
int property Modifier = 16 autoreadonly
int property Mood = 30 autoreadonly

; Framework
SexLabFramework property SexLab auto
sslSystemConfig property Config auto

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

sslBaseExpression Expression
int Phase

string[] Moods
string[] Phases

sslBaseAnimation Animation
string[] Genders
string AdjustKey
int Position

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
int[] oidFemaleModifiers
int[] oidFemalePhonemes
int[] oidMaleModifiers
int[] oidMalePhonemes
int[] oidAnimForward
int[] oidAnimSideways
int[] oidAnimUpward
int[] oidAnimRotate
int[] oidAnimSchlong

Actor StatTarget
string TargetName
int TargetFlag

bool function SetDefaults()
	; MCM option pages
	Pages     = new string[15]
	Pages[0]  = "$SSL_AnimationSettings"
	Pages[1]  = "$SSL_SoundSettings"
	Pages[2]  = "$SSL_PlayerHotkeys"
	Pages[3]  = "$SSL_NormalTimersStripping"
	Pages[4]  = "$SSL_ForeplayTimersStripping"
	Pages[5]  = "$SSL_AggressiveTimersStripping"
	Pages[6]  = "$SSL_ToggleAnimations"
	Pages[7]  = "$SSL_ForeplayAnimations"
	Pages[8]  = "$SSL_AggressiveAnimations"
	Pages[9]  = "$SSL_CreatureAnimations"
	Pages[10] = "$SSL_ExpressionSelection"
	Pages[11] = "$SSL_ExpressionEditor"
	Pages[12] = "$SSL_AnimationEditor"
	if PlayerRef.GetLeveledActorBase().GetSex() == 1
		Pages[13] = "$SSL_SexDiary"
	else
		Pages[13] = "$SSL_SexJournal"
	endIf
	Pages[14] = "$SSL_RebuildClean"

	Moods = new string[17]
	Moods[0]  = "Dialogue Anger"
	Moods[1]  = "Dialogue Fear"
	Moods[2]  = "Dialogue Happy"
	Moods[3]  = "Dialogue Sad"
	Moods[4]  = "Dialogue Surprise"
	Moods[5]  = "Dialogue Puzzled"
	Moods[6]  = "Dialogue Disgusted"
	Moods[7]  = "Mood Neutral"
	Moods[8]  = "Mood Anger"
	Moods[9]  = "Mood Fear"
	Moods[10] = "Mood Happy"
	Moods[11] = "Mood Sad"
	Moods[12] = "Mood Surprise"
	Moods[13] = "Mood Puzzled"
	Moods[14] = "Mood Disgusted"
	Moods[15] = "Combat Anger"
	Moods[16] = "Combat Shout"

	Phases = new string[5]
	Phases[0] = "Phase 1"
	Phases[1] = "Phase 2"
	Phases[2] = "Phase 3"
	Phases[3] = "Phase 4"
	Phases[4] = "Phase 5"

	; OIDs
	oidToggleVoice               = new int[125]
	oidToggleCreatureAnimation   = new int[125]
	oidToggleAnimation           = new int[125]
	oidAggrAnimation             = new int[125]
	oidForeplayAnimation         = new int[125]

	oidStripMale                 = new int[33]
	oidStripFemale               = new int[33]
	oidStripLeadInFemale         = new int[33]
	oidStripLeadInMale           = new int[33]
	oidStripVictim               = new int[33]
	oidStripAggressor            = new int[33]

	oidStageTimer                = new int[5]
	oidStageTimerLeadIn          = new int[5]
	oidStageTimerAggr            = new int[5]

	oidRemoveStrapon             = new int[20]

	oidToggleExpressionNormal    = new int[40]
	oidToggleExpressionVictim    = new int[40]
	oidToggleExpressionAggressor = new int[40]
	oidFemaleModifiers           = new int[14]
	oidFemalePhonemes            = new int[16]
	oidMaleModifiers             = new int[14]
	oidMalePhonemes              = new int[16]

	oidAnimForward               = new int[125]
	oidAnimSideways              = new int[125]
	oidAnimUpward                = new int[125]
	oidAnimSchlong               = new int[125]

	Genders = new string[3]
	Genders[0] = "$SSL_Male"
	Genders[1] = "$SSL_Female"
	Genders[2] = "$SSL_Creature"

	; Check system install before we continue
	if !Config.CheckSystem()
		SexLab.GoToState("Disabled")
		return false
	endIf

	; Prepare base framework script
	SexLab.Setup()
	Config.SetDefaults()

	; Grab libraries to make sure they are all set properly
	ActorLib        = SexLab.ActorLib
	ThreadLib       = SexLab.ThreadLib
	Stats           = SexLab.Stats
	ThreadSlots     = SexLab.ThreadSlots
	AnimSlots       = SexLab.AnimSlots
	CreatureSlots   = SexLab.CreatureSlots
	VoiceSlots      = SexLab.VoiceSlots
	ExpressionSlots = SexLab.ExpressionSlots

	return true
endFunction

; UI.InvokeStringA(JOURNAL_MENU, MENU_ROOT + ".setPageNames", Pages)
; SetPage("", -1)
; SetPage("Toggle Animations", 2)
; OnPageReset("Information")

event OnConfigOpen()
	if TargetRef != none && TargetRef.Is3DLoaded()
		TargetName = TargetRef.GetLeveledActorBase().GetName()
		TargetFlag = OPTION_FLAG_NONE
	else
		TargetRef = none
		TargetName = "$SSL_NoTarget"
		TargetFlag = OPTION_FLAG_DISABLED
	endIf
	StatTarget = PlayerRef
endEvent


event OnPageReset(string page)
	int i
	; Logo
	if page == ""
		LoadCustomContent("SexLab/logo.dds", 184, 31)
		return
	endIf
	UnloadCustomContent()

	if page == "$SSL_AnimationEditor"
		SetCursorFillMode(LEFT_TO_RIGHT)

		if Animation == none
			Animation = AnimSlots.GetBySlot(0)
			AdjustKey = "Global"
			Position  = 0
			; Stage = 1
		endIf

		Animation.InitAdjustments(Animation.Key("Adjust."+AdjustKey))

		SetTitleText(Animation.Name)
		AddMenuOptionST("AnimationSelect", "$SSL_Animation", Animation.Name)
		if Animation.PositionCount == 1 || (Animation.PositionCount == 2 && TargetRef != none)
			AddTextOptionST("AnimationTest", "$SSL_PlayAnimation", "$SSL_ClickHere")
		else
			AddTextOptionST("AnimationTest", "$SSL_PlayAnimation", "$SSL_ClickHere", OPTION_FLAG_DISABLED)
		endIf

		if Animation.GetAdjustKeys().Length > 1
			AddMenuOptionST("AnimationAdjustKey", "$SSL_AdjustmentProfile", AdjustKey)
		else
			AdjustKey = "Global"
			AddMenuOption("Adjustment Profile", "Global")
		endIf

		AddMenuOptionST("AnimationPosition", "$SSL_Position", "$SSL_{"+Genders[Animation.GetGender(Position)]+"}Gender{"+(Position + 1)+"}Position")

		AddEmptyOption()
		AddEmptyOption()

		string Profile
		if AdjustKey != "Global"
			string[] RaceIDs = sslUtility.ArgString(AdjustKey, ".")
			string id = StringUtil.Substring(RaceIDs[Position], 0, (StringUtil.GetLength(RaceIDs[Position]) - 1))
			Race RaceRef = Race.GetRace(id)
			if RaceRef != none
				id = RaceRef.GetName()
			endIf
			if StringUtil.GetNthChar(RaceIDs[Position], (StringUtil.GetLength(RaceIDs[Position]) - 1)) == "F"
				Profile = "$SSL_{"+id+"}-{$SSL_Female}"
			else
				Profile = "$SSL_{"+id+"}-{$SSL_Male}"
			endIf
		else
			Profile = "$SSL_{Global}-{"+Genders[Animation.GetGender(Position)]+"}"
		endIf

		int Stage = 1
		while Stage <= Animation.StageCount

			float[] Adjustments = Animation.GetPositionAdjustments(Animation.Key("Adjust."+AdjustKey), Position, Stage)
			AddHeaderOption("$SSL_Stage{"+Stage+"}Adjustments")
			AddHeaderOption(Profile)

			oidAnimForward[Stage]  = AddSliderOption("$SSL_AdjustForwards", Adjustments[0], "{2}")
			oidAnimSideways[Stage] = AddSliderOption("$SSL_AdjustSideways", Adjustments[1], "{2}")
			oidAnimUpward[Stage]   = AddSliderOption("$SSL_AdjustUpwards",  Adjustments[2], "{2}")
			oidAnimSchlong[Stage]  = AddSliderOption("$SSL_SchlongUpDown", Adjustments[3], "{0}")

			Stage += 1
		endWhile


	elseIf page == "$SSL_ExpressionEditor"
		SetCursorFillMode(LEFT_TO_RIGHT)

		if Expression == none
			Expression = ExpressionSlots.GetBySlot(0)
			Phase = 1
		endIf

		SetTitleText(Expression.Name)
		AddMenuOptionST("ExpressionSelect", "$SSL_ModifyingExpression", Expression.Name)
		AddMenuOptionST("ExpressionPhase", "$SSL_Modifying{"+Expression.Name+"}Phase", Phase)

		int FlagF = OPTION_FLAG_NONE
		int FlagM = OPTION_FLAG_NONE

		if Phase > Expression.PhasesFemale
			FlagF = OPTION_FLAG_DISABLED
		endIf
		if Phase > Expression.PhasesMale
			FlagM = OPTION_FLAG_DISABLED
		endIf

		AddTextOptionST("ExpressionTestPlayer", "$SSL_TestOnPlayer", "$SSL_Apply")
		AddTextOptionST("ExpressionTestTarget", "$SSL_TestOn{"+TargetName+"}", "$SSL_Apply", TargetFlag)

		AddEmptyOption()
		AddEmptyOption()

		; Show expression customization menu
		if Expression != none

			int[] FemaleModifiers = Expression.GetModifiers(Phase, Female)
			int[] FemalePhonemes  = Expression.GetPhonemes(Phase, Female)

			int[] MaleModifiers   = Expression.GetModifiers(Phase, Male)
			int[] MalePhonemes    = Expression.GetPhonemes(Phase, Male)

			; AddToggleOptionST("ToggleExpression","$SSL_EndableExpression", Expression.Enabled)
			; AddHeaderOption("")

			if Phase == (Expression.PhasesFemale + 1)
				AddTextOptionST("ExpressionAddPhaseFemale", "Add Female Phase", "$SSL_ClickHere")
			elseIf Phase == Expression.PhasesFemale
				AddTextOptionST("ExpressionRemovePhaseFemale", "Remove Female Phase", "$SSL_ClickHere")
			else
				AddHeaderOption("")
			endIf

			if Phase == (Expression.PhasesMale + 1)
				AddTextOptionST("ExpressionAddPhaseMale", "Add Male Phase", "$SSL_ClickHere")
			elseIf Phase == Expression.PhasesMale
				AddTextOptionST("ExpressionRemovePhaseMale", "Remove Male Phase", "$SSL_ClickHere")
			else
				AddHeaderOption("")
			endIf

			; AddTextOptionST("ExpressionPhaseFemale", "$SSL_Modify{$SSL_Female}Phase", Phase)
			; AddTextOptionST("ExpressionPhaseMale", "$SSL_Modify{$SSL_Male}Phase", Phase)

			AddHeaderOption("$SSL_{$SSL_Female}-{$SSL_Mood}", FlagF)
			AddHeaderOption("$SSL_{$SSL_Male}-{$SSL_Mood}", FlagM)


			AddMenuOptionST("MoodTypeFemale", "$SSL_MoodType", Moods[Expression.GetMoodType(Phase, Female)], FlagF)
			AddMenuOptionST("MoodTypeMale", "$SSL_MoodType", Moods[Expression.GetMoodType(Phase, Male)], FlagM)

			AddSliderOptionST("MoodAmountFemale", "$SSL_MoodStrength", Expression.GetMoodAmount(Phase, Female), "{0}", FlagF)
			AddSliderOptionST("MoodAmountMale", "$SSL_MoodStrength", Expression.GetMoodAmount(Phase, Male), "{0}", FlagM)

			AddHeaderOption("$SSL_{$SSL_Female}-{$SSL_Modifier}", FlagF)
			AddHeaderOption("$SSL_{$SSL_Male}-{$SSL_Modifier}", FlagM)
			i = 0
			while i < 14
				oidFemaleModifiers[i] = AddSliderOption(SexLabUtil.ModifierLabel(i), FemaleModifiers[i], "{0}", FlagF)
				oidMaleModifiers[i]   = AddSliderOption(SexLabUtil.ModifierLabel(i), MaleModifiers[i], "{0}", FlagM)
				i += 1
			endWhile
			AddHeaderOption("$SSL_{$SSL_Female}-{$SSL_Phoneme}", FlagF)
			AddHeaderOption("$SSL_{$SSL_Male}-{$SSL_Phoneme}", FlagM)
			i = 0
			while i < 16
				oidFemalePhonemes[i] = AddSliderOption(SexLabUtil.PhonemeLabel(i), FemalePhonemes[i], "{0}", FlagF)
				oidMalePhonemes[i]   = AddSliderOption(SexLabUtil.PhonemeLabel(i), MalePhonemes[i], "{0}", FlagM)
				i += 1
			endWhile

		endIf
	endIf

	; Animation Settings
	if page == "$SSL_AnimationSettings"

		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("$SSL_PlayerSettings")
		AddToggleOptionST("AutoAdvance","$SSL_AutoAdvanceStages", Config.bAutoAdvance)
		AddToggleOptionST("DisableVictim","$SSL_DisableVictimControls", Config.bDisablePlayer)
		AddToggleOptionST("AutomaticTFC","$SSL_AutomaticTFC", Config.bAutoTFC)
		AddSliderOptionST("AutomaticSUCSM","$SSL_AutomaticSUCSM", Config.fAutoSUCSM, "{0}")

		AddHeaderOption("$SSL_ExtraEffects")
		AddToggleOptionST("UseExpressions","$SSL_UseExpressions", Config.bUseExpressions)
		AddToggleOptionST("UseLipSync", "$SSL_UseLipSync", Config.bUseLipSync)
		AddToggleOptionST("OrgasmEffects","$SSL_OrgasmEffects", Config.bOrgasmEffects)
		AddToggleOptionST("UseCum","$SSL_ApplyCumEffects", Config.bUseCum)
		AddToggleOptionST("AllowFemaleFemaleCum","$SSL_AllowFemaleFemaleCum", Config.bAllowFFCum)
		AddSliderOptionST("CumEffectTimer","$SSL_CumEffectTimer", Config.fCumTimer, "$SSL_Seconds")

		SetCursorPosition(1)
		AddHeaderOption("$SSL_AnimationHandling")
		AddToggleOptionST("AllowCreatures","$SSL_AllowCreatures", Config.bAllowCreatures)
		AddToggleOptionST("ScaleActors","$SSL_EvenActorsHeight", Config.bScaleActors)
		AddToggleOptionST("ForeplayStage","$SSL_PreSexForeplay", Config.bForeplayStage)
		AddToggleOptionST("RestrictAggressive","$SSL_RestrictAggressive", Config.bRestrictAggressive)
		AddToggleOptionST("UndressAnimation","$SSL_UndressAnimation", Config.bUndressAnimation)
		AddToggleOptionST("ReDressVictim","$SSL_VictimsRedress", Config.bReDressVictim)
		AddToggleOptionST("RagdollEnd","$SSL_RagdollEnding", Config.bRagdollEnd)
		AddToggleOptionST("StraponsFemale","$SSL_FemalesUseStrapons", Config.bUseStrapons)
		AddToggleOptionST("NudeSuitMales","$SSL_UseNudeSuitMales", Config.bUseMaleNudeSuit)
		AddToggleOptionST("NudeSuitFemales","$SSL_UseNudeSuitFemales", Config.bUseFemaleNudeSuit)
		AddTextOptionST("NPCBed","$SSL_NPCsUseBeds", Config.sNPCBed)

	; Sound Settings
	elseIf page == "$SSL_SoundSettings"
		SetCursorFillMode(LEFT_TO_RIGHT)

		; Voices & SFX
		AddMenuOptionST("PlayerVoice","$SSL_PCVoice", VoiceSlots.GetSavedName(PlayerRef))
		AddToggleOptionST("NPCSaveVoice","$SSL_NPCSaveVoice", Config.bNPCSaveVoice)
		AddMenuOptionST("TargetVoice","$SSL_Target{"+TargetName+"}Voice", VoiceSlots.GetSavedName(TargetRef), TargetFlag)
		AddSliderOptionST("VoiceVolume","$SSL_VoiceVolume", (Config.fVoiceVolume * 100), "{0}%")
		AddSliderOptionST("SFXVolume","$SSL_SFXVolume", (Config.fSFXVolume * 100), "{0}%")
		AddSliderOptionST("MaleVoiceDelay","$SSL_MaleVoiceDelay", Config.fMaleVoiceDelay, "$SSL_Seconds")
		AddSliderOptionST("SFXDelay","$SSL_SFXDelay", Config.fSFXDelay, "$SSL_Seconds")
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
		AddKeyMapOptionST("BackwardsModifier", "$SSL_ReverseDirectionModifier", Config.kBackwards)
		AddKeyMapOptionST("AdjustStage","$SSL_AdjustStage", Config.kAdjustStage)
		AddKeyMapOptionST("AdjustChange","$SSL_ChangeActorBeingMoved", Config.kAdjustChange)
		AddKeyMapOptionST("AdjustForward","$SSL_MoveActorForwardBackward", Config.kAdjustForward)
		AddKeyMapOptionST("AdjustUpward","$SSL_AdjustPositionUpwardDownward", Config.kAdjustUpward)
		AddKeyMapOptionST("AdjustSideways","$SSL_MoveActorLeftRight", Config.kAdjustSideways)
		AddKeyMapOptionST("RotateScene", "$SSL_RotateScene", Config.kRotateScene)
		AddKeyMapOptionST("RestoreOffsets","$SSL_DeleteSavedAdjustments", Config.kRestoreOffsets)

		SetCursorPosition(1)
		AddHeaderOption("$SSL_GlobalHotkeys")
		AddKeyMapOptionST("TargetActor", "$SSL_TargetActor", Config.kTargetActor)
		AddKeyMapOptionST("ToggleFreeCamera", "$SSL_ToggleFreeCamera", Config.kToggleFreeCamera)

		AddHeaderOption("$SSL_SceneManipulation")
		AddKeyMapOptionST("RealignActors","$SSL_RealignActors", Config.kRealignActors)
		AddKeyMapOptionST("EndAnimation", "$SSL_EndAnimation", Config.kEndAnimation)
		AddKeyMapOptionST("AdvanceAnimation", "$SSL_AdvanceAnimationStage", Config.kAdvanceAnimation)
		AddKeyMapOptionST("ChangeAnimation", "$SSL_ChangeAnimationSet", Config.kChangeAnimation)
		AddKeyMapOptionST("ChangePositions", "$SSL_SwapActorPositions", Config.kChangePositions)
		AddKeyMapOptionST("MoveSceneLocation", "$SSL_MoveSceneLocation", Config.kMoveScene)

	; Normal timers + stripping
	elseIf page == "$SSL_NormalTimersStripping"
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption("$SSL_ConsensualStageTimers")
		oidStageTimer[0] = AddSliderOption("$SSL_Stage1Length", Config.fStageTimer[0], "$SSL_Seconds")
		oidStageTimer[1] = AddSliderOption("$SSL_Stage2Length", Config.fStageTimer[1], "$SSL_Seconds")
		oidStageTimer[2] = AddSliderOption("$SSL_Stage3Length", Config.fStageTimer[2], "$SSL_Seconds")
		AddEmptyOption()

		AddHeaderOption("$SSL_FemaleStripFrom")
		StripSlots(oidStripFemale, Config.bStripFemale)

		SetCursorPosition(1)
		AddHeaderOption("")
		oidStageTimer[3] = AddSliderOption("$SSL_Stage4Length", Config.fStageTimer[3], "$SSL_Seconds")
		oidStageTimer[4] = AddSliderOption("$SSL_StageEndingLength", Config.fStageTimer[4], "$SSL_Seconds")
		AddEmptyOption()
		AddEmptyOption()

		AddHeaderOption("$SSL_MaleStripFrom")
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
		StripSlots(oidStripLeadInFemale, Config.bStripLeadInFemale)

		SetCursorPosition(1)
		AddHeaderOption("")
		oidStageTimerLeadIn[3] = AddSliderOption("$SSL_Stage4Length", Config.fStageTimerLeadIn[3], "$SSL_Seconds")
		oidStageTimerLeadIn[4] = AddSliderOption("$SSL_StageEndingLength", Config.fStageTimerLeadIn[4], "$SSL_Seconds")
		AddEmptyOption()
		AddEmptyOption()

		AddHeaderOption("$SSL_MaleStripFrom")
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
		StripSlots(oidStripVictim, Config.bStripVictim)

		SetCursorPosition(1)
		AddHeaderOption("")
		oidStageTimerAggr[3] = AddSliderOption("$SSL_Stage4Length", Config.fStageTimerAggr[3], "$SSL_Seconds")
		oidStageTimerAggr[4] = AddSliderOption("$SSL_StageEndingLength", Config.fStageTimerAggr[4], "$SSL_Seconds")
		AddEmptyOption()
		AddEmptyOption()

		AddHeaderOption("$SSL_AggressorStripFrom")
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

		int flag = 0x00
		if !Config.bForeplayStage
			AddHeaderOption("$SSL_ForeplayDisabled")
			AddToggleOptionST("ForeplayStage","$SSL_PreSexForeplay", Config.bForeplayStage)
			flag = OPTION_FLAG_DISABLED
		endIf

		i = 0
		while i < AnimSlots.Slotted
			if AnimSlots.Slots[i].Registered
				oidForeplayAnimation[i] = AddToggleOption(AnimSlots.Slots[i].Name, AnimSlots.Slots[i].HasTag("LeadIn") && flag == 0x00, flag)
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

		int flag = 0x00
		if !Config.bAllowCreatures
			AddHeaderOption("$SSL_CreaturesDisabled")
			AddToggleOptionST("AllowCreatures","$SSL_AllowCreatures", Config.bAllowCreatures)
			flag = OPTION_FLAG_DISABLED
		endIf

		i = 0
		while i < CreatureSlots.Slotted
			if CreatureSlots.Slots[i].Registered
				oidToggleCreatureAnimation[i] = AddToggleOption(CreatureSlots.Slots[i].Name, CreatureSlots.Slots[i].Enabled && flag == 0x00, flag)
			endIf
			i += 1
		endWhile

	; Toggle expressions
	elseIf page == "$SSL_ExpressionSelection"
		SetCursorFillMode(LEFT_TO_RIGHT)

		int flag = 0x00
		if !Config.bUseExpressions
			AddHeaderOption("$SSL_ExpressionsDisabled")
			AddToggleOptionST("UseExpressions","$SSL_UseExpressions", Config.bUseExpressions)
			flag = OPTION_FLAG_DISABLED
		endIf

		AddHeaderOption("$SSL_ExpressionsNormal")
		AddHeaderOption("")
		i = 0
		while i < ExpressionSlots.Slotted
			sslBaseExpression Exp = ExpressionSlots.Expressions[i]
			if Exp.Registered && Exp.Enabled
				oidToggleExpressionNormal[i] = AddToggleOption(Exp.Name, Exp.HasTag("Normal") && flag == 0x00, flag)
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
			sslBaseExpression Exp = ExpressionSlots.Expressions[i]
			if Exp.Registered && Exp.Enabled
				oidToggleExpressionVictim[i] = AddToggleOption(Exp.Name, Exp.HasTag("Victim") && flag == 0x00, flag)
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
			sslBaseExpression Exp = ExpressionSlots.Expressions[i]
			if Exp.Registered && Exp.Enabled
				oidToggleExpressionAggressor[i] = AddToggleOption(Exp.Name, Exp.HasTag("Aggressor") && flag == 0x00, flag)
			endIf
			i += 1
		endWhile

	; Player Diary/Journal
	elseIf page == "$SSL_SexDiary" || page == "$SSL_SexJournal"
		SetCursorFillMode(TOP_TO_BOTTOM)

		if TargetRef != StatTarget
			AddTextOptionST("SetStatTarget", "$SSL_Viewing{"+StatTarget.GetLeveledActorBase().GetName()+"}", "$SSL_View{"+TargetName+"}", TargetFlag)
		else
			AddTextOptionST("SetStatTarget", "$SSL_Viewing{"+TargetName+"}", "$SSL_View{"+PlayerRef.GetLeveledActorBase().GetName()+"}")
		endIf

		AddHeaderOption("$SSL_SexualExperience")
		AddTextOption("$SSL_TimeSpentHavingSex", Stats.ParseTime(Stats.GetFloat(StatTarget, "TimeSpent") as int))
		AddTextOption("$SSL_VaginalProficiency", Stats.GetSkillTitle(StatTarget, "Vaginal"))
		AddTextOption("$SSL_AnalProficiency", Stats.GetSkillTitle(StatTarget, "Anal"))
		AddTextOption("$SSL_OralProficiency", Stats.GetSkillTitle(StatTarget, "Oral"))
		AddTextOption("$SSL_ForeplayProficiency", Stats.GetSkillTitle(StatTarget, "Foreplay"))
		AddTextOption("$SSL_SexualPurity", Stats.GetPureTitle(StatTarget))
		AddTextOption("$SSL_SexualPerversion", Stats.GetLewdTitle(StatTarget))
		AddEmptyOption()


		SetCursorPosition(1)

		AddTextOptionST("ResetTargetStats", "$SSL_Reset{"+StatTarget.GetLeveledActorBase().GetName()+"}Stats", "$SSL_ClickHere")

		AddHeaderOption("$SSL_SexualStats")
		AddTextOptionST("SetStatSexuality", "$SSL_Sexuality", Stats.GetSexualityTitle(StatTarget))
		AddTextOption("$SSL_MaleSexualPartners", Stats.GetInt(StatTarget, "Males"))
		AddTextOption("$SSL_FemaleSexualPartners", Stats.GetInt(StatTarget, "Females"))
		AddTextOption("$SSL_CreatureSexualPartners", Stats.GetInt(StatTarget, "Creatures"))
		AddTextOption("$SSL_TimesMasturbated", Stats.GetInt(StatTarget, "Masturbation"))
		AddTextOption("$SSL_TimesAggressive", Stats.GetInt(StatTarget, "Aggressor"))
		AddTextOption("$SSL_TimesVictim", Stats.GetInt(StatTarget, "Victim"))
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
		AddTextOptionST("ExportSettings","$SSL_ExportSettings", "$SSL_ClickHere")
		AddTextOptionST("ImportSettings","$SSL_ImportSettings", "$SSL_ClickHere")
		AddHeaderOption("$SSL_AvailableStrapons")
		AddTextOptionST("RebuildStraponList","$SSL_RebuildStraponList", "$SSL_ClickHere")
		i = Config.Strapons.Length
		while i
			i -= 1
			if Config.Strapons[i] != none
				string Name = Config.Strapons[i].GetName()
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
		string Label = SexLabUtil.SlotLabel(i)
		if Label != ""
			OIDs[i] = AddToggleOption(Label, Enabled[i])
		endIf
		if i == 13
			AddHeaderOption("$SSL_ExtraSlots")
		endIf
		i += 1
	endWhile
endFunction

event OnRaceSwitchComplete()
	StorageUtil.FormListClear(SexLab, "ValidActors")
	if Pages.Length > 0
		if PlayerRef.GetLeveledActorBase().GetSex() == 1
			Pages[11] = "$SSL_SexDiary"
		else
			Pages[11] = "$SSL_SexJournal"
		endIf
	endIf
endEvent

state AnimationSelect
	event OnMenuOpenST()
		SetMenuDialogStartIndex(AnimSlots.Slots.Find(Animation))
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(AnimSlots.GetNames())
	endEvent
	event OnMenuAcceptST(int i)
		Animation = AnimSlots.GetBySlot(i)
		AdjustKey = "Global"
		SetMenuOptionValueST(Animation.Name)
		ForcePageReset()
	endEvent
	event OnDefaultST()
		Animation = AnimSlots.GetBySlot(0)
		AdjustKey = "Global"
		SetMenuOptionValueST(Animation.Name)
		ForcePageReset()
	endEvent
endState

state AnimationPosition
	event OnMenuOpenST()
		string[] Positions = sslUtility.StringArray(Animation.PositionCount)
		int i = Positions.Length
		while i
			i -= 1
			Positions[i] = "$SSL_{"+Genders[Animation.GetGender(i)]+"}Gender{"+(i + 1)+"}Position"
		endWhile
		SetMenuDialogStartIndex(Position)
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(Positions)
	endEvent
	event OnMenuAcceptST(int i)
		Position = i
		SetMenuOptionValueST("$SSL_{"+Genders[Animation.GetGender(i)]+"}Gender{"+(i + 1)+"}Position")
		ForcePageReset()
	endEvent
	event OnDefaultST()
		Position = 0
		SetMenuOptionValueST(Position)
		ForcePageReset()
	endEvent
endState

state AnimationAdjustKey
	event OnMenuOpenST()
		string[] AdjustKeys = Animation.GetAdjustKeys()
		MiscUtil.PrintConsole("AdjustKeys["+AdjustKeys.Length+"]: "+AdjustKeys)
		SetMenuDialogStartIndex(AdjustKeys.Find(AdjustKey))
		SetMenuDialogDefaultIndex(AdjustKeys.Find("Global"))
		SetMenuDialogOptions(AdjustKeys)
	endEvent
	event OnMenuAcceptST(int i)
		string[] AdjustKeys = Animation.GetAdjustKeys()
		AdjustKey  = AdjustKeys[i]
		MiscUtil.PrintConsole("Set AdjustKey ["+i+"]: "+AdjustKey)
		SetMenuOptionValueST(AdjustKeys[i])
		ForcePageReset()
	endEvent
	event OnDefaultST()
		AdjustKey = "Global"
		SetMenuOptionValueST(AdjustKey)
		ForcePageReset()
	endEvent
endState


state AnimationTest
	event OnSelectST()
		if !ShowMessage("About to player test animation "+Animation.Name+" for preview purposes.\n\nDo you wish to continue?", true, "$Yes", "$No")
			return
		endIf
		ShowMessage("Starting animation "+Animation.Name+".\n\nClose all menus and return to the game to continue...", false)
		Utility.Wait(0.5)

		sslThreadModel Thread = SexLab.NewThread()
		if Thread != none
			; Add single animation to thread
			sslBaseAnimation[] Anims = new sslBaseAnimation[1]
			Anims[0] = Animation
			Thread.SetAnimations(Anims)
			; Disable extra effects, this is a test - keep it simple
			Thread.DisableBedUse(true)
			Thread.DisableLeadIn(true)
			; select a solo actor
			if Animation.PositionCount == 1
				if TargetRef != none && TargetRef.Is3DLoaded() && ShowMessage("Which actor would you like to play the solo animation \""+Animation.Name+"\" with?", true, TargetName, PlayerRef.GetLeveledActorBase().GetName())
					Thread.AddActor(TargetRef)
				else
					Thread.AddActor(PlayerRef)
				endIf
			; Add player and target
			elseIf Animation.PositionCount == 2 && TargetRef != none
				Actor[] Positions = sslUtility.MakeActorArray(PlayerRef, TargetRef)
				Positions = ThreadLib.SortActors(Positions)
				Thread.AddActor(Positions[0])
				Thread.AddActor(Positions[1])
			endIf
		endIf
		if Thread == none || Thread.StartThread() == none
			ShowMessage("Failed to start test animation.", false)
		endIf
	endEvent
endState


state ExpressionSelect
	event OnMenuOpenST()
		SetMenuDialogStartIndex(ExpressionSlots.Expressions.Find(Expression))
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(ExpressionSlots.GetNames())
	endEvent
	event OnMenuAcceptST(int i)
		Phase = 1
		Expression = ExpressionSlots.GetBySlot(i)
		SetMenuOptionValueST(Expression.Name)
		ForcePageReset()
	endEvent
	event OnDefaultST()
		Expression = ExpressionSlots.GetBySlot(0)
		SetMenuOptionValueST(Expression.Name)
		ForcePageReset()
	endEvent
endState

state ExpressionPhase
	event OnMenuOpenST()
		SetMenuDialogStartIndex(Phase - 1)
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(Phases)
	endEvent
	event OnMenuAcceptST(int i)
		Phase = i + 1
		SetMenuOptionValueST(Phase)
		ForcePageReset()
	endEvent
	event OnDefaultST()
		Phase = 1
		SetMenuOptionValueST(Phase)
		ForcePageReset()
	endEvent
endState

state ExpressionTestPlayer
	event OnSelectST()
		if PlayerRef.Is3DLoaded()
			TestApply(PlayerRef)
		endIf
	endEvent
endState

state ExpressionTestTarget
	event OnSelectST()
		if TargetRef != none && TargetRef.Is3DLoaded()
			TestApply(TargetRef)
		endIf
	endEvent
endState

function TestApply(Actor ActorRef)
	string ActorName = ActorRef.GetLeveledActorBase().GetName()
	sslBaseExpression Exp = Expression
	if ShowMessage("Expression will be applied to "+ActorName+" for preview purposes, after 30 seconds they will be reset to their default.\n\nDo you wish to continue?", true, "$Yes", "$No")
		ShowMessage("Applying "+Exp.Name+" phase "+Phase+" on "+ActorName+".\n\nClose all menus and return to the game to continue...", false)
		Utility.Wait(0.1)
		Game.ForceThirdPerson()
		Exp.ApplyPhase(ActorRef, Phase, ActorRef.GetLeveledActorBase().GetSex())
		Debug.Notification(Exp.Name+" has been applied to "+ActorName)
		Debug.Notification("Reverting expression in 15 seconds...")
		RegisterForSingleUpdate(15)
	endIf
endFunction

event OnUpdate()
	Debug.Notification("Reverting expression...")
	PlayerRef.ClearExpressionOverride()
	MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)
	TargetRef.ClearExpressionOverride()
	MfgConsoleFunc.ResetPhonemeModifier(TargetRef)
endEvent


state ExpressionAddPhaseFemale
	event OnSelectST()
		Expression.AddPhase(Phase, Female)
		ForcePageReset()
	endEvent
endState
state ExpressionAddPhaseMale
	event OnSelectST()
		Expression.AddPhase(Phase, Male)
		ForcePageReset()
	endEvent
endState

state ExpressionRemovePhaseFemale
	event OnSelectST()
		Expression.EmptyPhase(Phase, Female)
		ForcePageReset()
	endEvent
endState
state ExpressionRemovePhaseMale
	event OnSelectST()
		Expression.EmptyPhase(Phase, Male)
		ForcePageReset()
	endEvent
endState

state MoodTypeFemale
	event OnMenuOpenST()
		SetMenuDialogStartIndex(Expression.GetMoodType(Phase, Female))
		SetMenuDialogDefaultIndex(7)
		SetMenuDialogOptions(Moods)
	endEvent
	event OnMenuAcceptST(int i)
		Expression.SetIndex(Phase, Female, Mood, 0, i)
		SetMenuOptionValueST(Moods[i])
	endEvent
	event OnDefaultST()
		Expression.SetIndex(Phase, Female, Mood, 0, 7)
		SetMenuOptionValueST(Moods[7])
	endEvent
endState
state MoodAmountFemale
	event OnSliderOpenST()
		SetSliderDialogStartValue(Expression.GetMoodAmount(Phase, Female))
		SetSliderDialogDefaultValue(50)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endEvent
	event OnSliderAcceptST(float value)
		Expression.SetIndex(Phase, Female, Mood, 1, value as int)
		SetSliderOptionValueST(value as int)
	endEvent
	event OnDefaultST()
		Expression.SetIndex(Phase, Female, Mood, 1, 50)
		SetSliderOptionValueST(50)
	endEvent
endState

state MoodTypeMale
	event OnMenuOpenST()
		SetMenuDialogStartIndex(Expression.GetMoodType(Phase, Male))
		SetMenuDialogDefaultIndex(7)
		SetMenuDialogOptions(Moods)
	endEvent
	event OnMenuAcceptST(int i)
		Expression.SetIndex(Phase, Male, Mood, 0, i)
		SetMenuOptionValueST(Moods[i])
	endEvent
	event OnDefaultST()
		Expression.SetIndex(Phase, Male, Mood, 0, 7)
		SetMenuOptionValueST(Moods[7])
	endEvent
endState
state MoodAmountMale
	event OnSliderOpenST()
		SetSliderDialogStartValue(Expression.GetMoodAmount(Phase, Male))
		SetSliderDialogDefaultValue(50)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endEvent
	event OnSliderAcceptST(float value)
		Expression.SetIndex(Phase, Male, Mood, 1, value as int)
		SetSliderOptionValueST(value as int)
	endEvent
	event OnDefaultST()
		Expression.SetIndex(Phase, Male, Mood, 1, 50)
		SetSliderOptionValueST(50)
	endEvent
endState


int function AnimStage(int i)
	int Stages = Animation.StageCount
	int Actors = Animation.PositionCount
	while Actors
		Actors -= 1
		if i > (Actors * Stages)
			MiscUtil.PrintConsole("Stage: "+i+" -> "+(i - (Actors * Stages) + 1))
			return (i - (Actors * Stages) + 1)
		endIf
	endWhile
	return -1
endFunction

int function AnimPos(int i)
	int Stages = Animation.StageCount
	int Actors = Animation.PositionCount
	while Actors
		Actors -= 1
		if i > (Actors * Stages)
			MiscUtil.PrintConsole("Position: "+i+" -> "+Actors)
			return Actors
		endIf
	endWhile
	return -1
endFunction

event OnOptionSliderOpen(int option)
	int i

	if CurrentPage == "$SSL_AnimationEditor"
		; Adjust SOS
		if oidAnimSchlong.Find(option) != -1
			SetSliderDialogStartValue(Animation.GetAdjustment(Animation.Key("Adjust."+AdjustKey), Position, oidAnimSchlong.Find(option), 3))
			SetSliderDialogRange(-9.0, 9.0)
			SetSliderDialogInterval(1.0)
			SetSliderDialogDefaultValue(0.0)
			return

		; Adjust forward
		elseIf oidAnimForward.Find(option) != -1
			SetSliderDialogStartValue(Animation.GetAdjustment(Animation.Key("Adjust."+AdjustKey), Position, oidAnimForward.Find(option), 0))

		; Adjust sidways
		elseIf oidAnimSideways.Find(option) != -1
			SetSliderDialogStartValue(Animation.GetAdjustment(Animation.Key("Adjust."+AdjustKey), Position, oidAnimSideways.Find(option), 1))

		; Adjust upwards
		elseIf oidAnimUpward.Find(option) != -1
			SetSliderDialogStartValue(Animation.GetAdjustment(Animation.Key("Adjust."+AdjustKey), Position, oidAnimUpward.Find(option), 2))

		endIf

		SetSliderDialogRange(-100.0, 100.0)
		SetSliderDialogInterval(0.50)
		SetSliderDialogDefaultValue(0.0)
		return
	elseIf CurrentPage == "$SSL_ExpressionEditor"

		; Female presets
		if oidFemalePhonemes.Find(option) != -1
			SetSliderDialogStartValue(Expression.GetIndex(Phase, Female, Phoneme, oidFemalePhonemes.Find(option)))

		elseIf oidFemaleModifiers.Find(option) != -1
			SetSliderDialogStartValue(Expression.GetIndex(Phase, Female, Modifier, oidFemaleModifiers.Find(option)))

		; Male presets
		elseIf oidMalePhonemes.Find(option) != -1
			SetSliderDialogStartValue(Expression.GetIndex(Phase, Male, Phoneme, oidMalePhonemes.Find(option)))

		elseIf oidMaleModifiers.Find(option) != -1
			SetSliderDialogStartValue(Expression.GetIndex(Phase, Male, Modifier, oidMaleModifiers.Find(option)))

		endIf
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
		SetSliderDialogDefaultValue(0)
		return

	elseIf CurrentPage == "$SSL_NormalTimersStripping"
		i = oidStageTimer.Find(option)
		SetSliderDialogStartValue(Config.fStageTimer[i])
	elseIf CurrentPage == "$SSL_ForeplayTimersStripping"
		i = oidStageTimerLeadIn.Find(option)
		SetSliderDialogStartValue(Config.fStageTimerLeadIn[i])
	elseIf CurrentPage == "$SSL_AggressiveTimersStripping"
		i = oidStageTimerAggr.Find(option)
		SetSliderDialogStartValue(Config.fStageTimerAggr[i])
	endIf
	SetSliderDialogRange(3.0, 300.0)
	SetSliderDialogInterval(1.0)
	SetSliderDialogDefaultValue(15.0)
endEvent

event OnOptionSliderAccept(int option, float value)
	int i

	if CurrentPage == "$SSL_AnimationEditor"

		; Adjust SOS
		if oidAnimSchlong.Find(option) != -1
			Animation.SetAdjustment(Animation.Key("Adjust."+AdjustKey), Position, oidAnimSchlong.Find(option), 3, value)
			SetSliderOptionValue(option, value, "{0}")

		; Adjust forward
		elseIf oidAnimForward.Find(option) != -1
			Animation.SetAdjustment(Animation.Key("Adjust."+AdjustKey), Position, oidAnimForward.Find(option), 0, value)
			SetSliderOptionValue(option, value, "{2}")

		; Adjust sidways
		elseIf oidAnimSideways.Find(option) != -1
			Animation.SetAdjustment(Animation.Key("Adjust."+AdjustKey), Position, oidAnimSideways.Find(option), 1, value)
			SetSliderOptionValue(option, value, "{2}")

		; Adjust upwards
		elseIf oidAnimUpward.Find(option) != -1
			Animation.SetAdjustment(Animation.Key("Adjust."+AdjustKey), Position, oidAnimUpward.Find(option), 2, value)
			SetSliderOptionValue(option, value, "{2}")

		endIf

	elseIf CurrentPage == "$SSL_ExpressionEditor"
		; Female presets
		if oidFemalePhonemes.Find(option) != -1
			Expression.SetIndex(Phase, Female, Phoneme, oidFemalePhonemes.Find(option), value as int)

		elseIf oidFemaleModifiers.Find(option) != -1
			Expression.SetIndex(Phase, Female, Modifier, oidFemaleModifiers.Find(option), value as int)

		; Male presets
		elseIf oidMalePhonemes.Find(option) != -1
			Expression.SetIndex(Phase, Male, Phoneme, oidMalePhonemes.Find(option), value as int)

		elseIf oidMaleModifiers.Find(option) != -1
			Expression.SetIndex(Phase, Male, Modifier, oidMaleModifiers.Find(option), value as int)
		endIf

		SetSliderOptionValue(option, value, "{0}")

	elseIf CurrentPage == "$SSL_NormalTimersStripping"
		i = oidStageTimer.Find(option)
		Config.fStageTimer[i] = value
		SetSliderOptionValue(option, value, "$SSL_Seconds")

	elseIf CurrentPage == "$SSL_ForeplayTimersStripping"
		i = oidStageTimerLeadIn.Find(option)
		Config.fStageTimerLeadIn[i] = value
		SetSliderOptionValue(option, value, "$SSL_Seconds")

	elseIf CurrentPage == "$SSL_AggressiveTimersStripping"
		i = oidStageTimerAggr.Find(option)
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
	elseif CurrentPage == "$SSL_ExpressionSelection"
		i = oidToggleExpressionNormal.Find(option)
		if i != -1
			SetToggleOptionValue(option, ExpressionSlots.Expressions[i].ToggleTag("Normal"))
			return
		endIf
		i = oidToggleExpressionVictim.Find(option)
		if i != -1
			SetToggleOptionValue(option, ExpressionSlots.Expressions[i].ToggleTag("Victim"))
			return
		endIf
		i = oidToggleExpressionAggressor.Find(option)
		if i != -1
			SetToggleOptionValue(option, ExpressionSlots.Expressions[i].ToggleTag("Aggressor"))
			return
		endIf

	elseIf CurrentPage == "$SSL_RebuildClean"
		i = oidRemoveStrapon.Find(option)
		Form[] Output
		Form[] Strapons = Config.Strapons
		int n = Strapons.Length
		while n
			n -= 1
			if n != i
				Output = PushForm(Strapons[n], Output)
			endIf
		endWhile
		Config.Strapons = Output
		ForcePageReset()
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

state UseExpressions
	event OnSelectST()
		Config.bUseExpressions = !Config.bUseExpressions
		SetToggleOptionValueST(Config.bUseExpressions)
	endEvent
	event OnDefaultST()
		Config.bUseExpressions = false
		SetToggleOptionValueST(Config.bUseExpressions)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoUseExpressions")
	endEvent
endState
state UseLipSync
	event OnSelectST()
		Config.bUseLipSync = !Config.bUseLipSync
		SetToggleOptionValueST(Config.bUseLipSync)
	endEvent
	event OnDefaultST()
		Config.bUseLipSync = false
		SetToggleOptionValueST(Config.bUseLipSync)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoUseLipSync")
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
	event OnMenuOpenST()
		int i = VoiceSlots.Slotted
		string[] VoiceNames = sslUtility.StringArray(i + 1)
		VoiceNames[0] = "$SSL_Random"
		while i
			i -= 1
			VoiceNames[(i + 1)] = VoiceSlots.Voices[i].Name
		endWhile
		SetMenuDialogStartIndex(VoiceSlots.FindSaved(PlayerRef) + 1)
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(VoiceNames)
	endEvent
	event OnMenuAcceptST(int i)
		i -= 1
		if i < 0
			VoiceSlots.ForgetVoice(PlayerRef)
			SetMenuOptionValueST("$SSL_Random")
		else
			VoiceSlots.SaveVoice(PlayerRef, VoiceSlots.GetBySlot(i))
			SetMenuOptionValueST(VoiceSlots.GetBySlot(i).Name)
		endIf
	endEvent
	event OnDefaultST()
		VoiceSlots.ForgetVoice(PlayerRef)
		SetMenuOptionValueST("$SSL_Random")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoPlayerVoice")
	endEvent
endState
state TargetVoice
	event OnMenuOpenST()
		int i = VoiceSlots.Slotted
		string[] VoiceNames = sslUtility.StringArray(i + 1)
		VoiceNames[0] = "$SSL_Random"
		while i
			i -= 1
			VoiceNames[(i + 1)] = VoiceSlots.Voices[i].Name
		endWhile
		SetMenuDialogStartIndex(VoiceSlots.FindSaved(TargetRef) + 1)
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(VoiceNames)
	endEvent
	event OnMenuAcceptST(int i)
		i -= 1
		if i < 0
			VoiceSlots.ForgetVoice(TargetRef)
			SetMenuOptionValueST("$SSL_Random")
		else
			VoiceSlots.SaveVoice(TargetRef, VoiceSlots.GetBySlot(i))
			SetMenuOptionValueST(VoiceSlots.GetBySlot(i).Name)
		endIf
	endEvent
	event OnDefaultST()
		VoiceSlots.ForgetVoice(TargetRef)
		SetMenuOptionValueST("$SSL_Random")
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
		SetSliderDialogDefaultValue(100)
		SetSliderDialogRange(1, 100)
		SetSliderDialogInterval(1)
	endEvent
	event OnSliderAcceptST(float value)
		Config.fSFXVolume = (value / 100.0)
		Config.AudioSFX.SetVolume(Config.fSFXVolume)
		SetSliderOptionValueST(value, "{0}%")
	endEvent
	event OnDefaultST()
		Config.fSFXVolume = 1.0
		SetSliderOptionValueST(Config.fSFXVolume, "{0}%")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoSFXVolume")
	endEvent
endState
state VoiceVolume
	event OnSliderOpenST()
		SetSliderDialogStartValue((Config.fVoiceVolume * 100))
		SetSliderDialogDefaultValue(100)
		SetSliderDialogRange(1, 100)
		SetSliderDialogInterval(1)
	endEvent
	event OnSliderAcceptST(float value)
		Config.fVoiceVolume = (value / 100.0)
		Config.AudioVoice.SetVolume(Config.fVoiceVolume)
		SetSliderOptionValueST(value, "{0}%")
	endEvent
	event OnDefaultST()
		Config.fVoiceVolume = 1.0
		SetSliderOptionValueST(Config.fVoiceVolume, "{0}%")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoVoiceVolume")
	endEvent
endState
state SFXDelay
	event OnSliderOpenST()
		SetSliderDialogStartValue(Config.fSFXDelay)
		SetSliderDialogDefaultValue(4.0)
		SetSliderDialogRange(2.0, 30.0)
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
		SetSliderDialogDefaultValue(6.0)
		SetSliderDialogRange(2.0, 45.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		Config.fMaleVoiceDelay = value
		SetSliderOptionValueST(Config.fMaleVoiceDelay, "$SSL_Seconds")
	endEvent
	event OnDefaultST()
		Config.fMaleVoiceDelay = 6.0
		SetSliderOptionValueST(Config.fMaleVoiceDelay, "$SSL_Seconds")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoMaleVoiceDelay")
	endEvent
endState
state FemaleVoiceDelay
	event OnSliderOpenST()
		SetSliderDialogStartValue(Config.fFemaleVoiceDelay)
		SetSliderDialogDefaultValue(5.0)
		SetSliderDialogRange(2.0, 45.0)
		SetSliderDialogInterval(1.0)
	endEvent
	event OnSliderAcceptST(float value)
		Config.fFemaleVoiceDelay = value
		SetSliderOptionValueST(Config.fFemaleVoiceDelay, "$SSL_Seconds")
	endEvent
	event OnDefaultST()
		Config.fFemaleVoiceDelay = 5.0
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
state EndAnimation
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.kEndAnimation = newKeyCode
			SetKeyMapOptionValueST(Config.kEndAnimation)
		endIf
	endEvent
	event OnDefaultST()
		Config.kEndAnimation = 207
		SetKeyMapOptionValueST(Config.kEndAnimation)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoEndAnimation")
	endEvent
endState
state TargetActor
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.kTargetActor = newKeyCode
			UnregisterForAllKeys()
			RegisterForKey(Config.kTargetActor)
			SetKeyMapOptionValueST(Config.kTargetActor)
		endIf
	endEvent
	event OnDefaultST()
		Config.kTargetActor = 49
		UnregisterForAllKeys()
		RegisterForKey(Config.kTargetActor)
		SetKeyMapOptionValueST(Config.kTargetActor)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoTargetActor")
	endEvent
endState
state ToggleFreeCamera
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.kToggleFreeCamera = newKeyCode
			Config.ReloadConfig()
			SetKeyMapOptionValueST(Config.kToggleFreeCamera)
		endIf
	endEvent
	event OnDefaultST()
		Config.kToggleFreeCamera = 81
		Config.ReloadConfig()
		SetKeyMapOptionValueST(Config.kToggleFreeCamera)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoToggleFreeCamera")
	endEvent
endState
state SetStatTarget
	event OnSelectST()
		if StatTarget == PlayerRef || TargetRef == none
			StatTarget = TargetRef
		else
			StatTarget = PlayerRef
		endIf
		ForcePageReset()
	endEvent
endState
state SetStatSexuality
	event OnSelectST()
		int Ratio = Stats.GetSexuality(StatTarget)
		if Stats.IsStraight(StatTarget)
			Stats.SetInt(StatTarget, "Sexuality", 50)
		elseIf Stats.IsBisexual(StatTarget)
			Stats.SetInt(StatTarget, "Sexuality", 0)
		else
			Stats.SetInt(StatTarget, "Sexuality", 100)
		endIf
		SetTextOptionValueST(Stats.GetSexualityTitle(StatTarget))
	endEvent
endState
state ResetTargetStats
	event OnSelectST()
		if ShowMessage("$SSL_WarnReset{"+StatTarget.GetLeveledActorBase().GetName()+"}Stats")
			Stats.ResetStats(StatTarget)
			ForcePageReset()
		endIf
	endEvent
endState

state ToggleSystem
	event OnSelectST()
		if SexLab.Enabled && ShowMessage("$SSL_WarnDisableSexLab")
			SexLab.GoToState("Disabled")
		elseIf !SexLab.Enabled && ShowMessage("$SSL_WarnEnableSexLab")
			SexLab.GoToState("Enabled")
		endIf
		ForcePageReset()
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
			SexLabUtil.Wait(30.0)
			Debug.Notification("$SSL_RunRebuildAnimations")
		endIf
	endEvent
endState
state ResetVoiceRegistry
	event OnSelectST()
		if ShowMessage("$SSL_WarnRebuildVoices")
			VoiceSlots.Setup()
			SexLabUtil.Wait(10.0)
			Debug.Notification("$SSL_RunRebuildVoices")
		endIf
	endEvent
endState
state ResetPlayerSexStats
	event OnSelectST()
		if ShowMessage("$SSL_WarnResetStats")
			Stats.ResetStats(PlayerRef)
			Debug.Notification("$SSL_RunResetStats")
		endIf
	endEvent
endState
state CleanSystem
	event OnSelectST()
		if ShowMessage("$SSL_WarnCleanSystem")
			ShowMessage("$SSL_RunCleanSystem", false)
			Utility.Wait(0.1)
			SetupSystem()
			Config.CleanSystemFinish.Show()
		endIf
	endEvent
endState
state RebuildStraponList
	event OnSelectST()
		Config.FindStrapons()
		if Config.Strapons.Length > 0
			ShowMessage("$SSL_FoundStrapon", false)
		else
			ShowMessage("$SSL_NoStrapons", false)
		endIf
		ForcePageReset()
	endEvent
endState
state ExportSettings
	event OnSelectST()
		if ShowMessage("$SSL_WarnExportSettings")
			Config.ExportSettings()
			StorageUtil.FileSetIntValue("SexLabConfig.Exported", 1)
			ShowMessage("$SSL_RunExportSettings", false)
		endIf
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoExportSettings")
	endEvent
endState
state ImportSettings
	event OnSelectST()
		if StorageUtil.FileGetIntValue("SexLabConfig.Exported") != 1
			ShowMessage("$SSL_WarnImportSettingsEmpty", false)
		elseif ShowMessage("$SSL_WarnImportSettings")
			Config.ImportSettings()
			StorageUtil.FileUnsetIntValue("SexLabConfig.Exported")
			ShowMessage("$SSL_RunImportSettings", false)
		endIf
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoImportSettings")
	endEvent
endState
