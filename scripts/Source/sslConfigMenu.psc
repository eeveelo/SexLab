scriptname sslConfigMenu extends SKI_ConfigBase
{Skyrim SexLab Mod Configuration Menu}

import StorageUtil

; Framework
Actor property PlayerRef auto
SexLabFramework property SexLab auto
sslSystemConfig property Config auto

; Function libraries
sslActorLibrary ActorLib
sslThreadLibrary ThreadLib
sslActorStats Stats

; Object registeries
sslThreadSlots ThreadSlots
sslAnimationSlots AnimSlots
sslCreatureAnimationSlots CreatureSlots
sslVoiceSlots VoiceSlots
sslExpressionSlots ExpressionSlots

; Common Data
Actor TargetRef
int TargetFlag
string TargetName

; ------------------------------------------------------- ;
; --- Configuration Events                            --- ;
; ------------------------------------------------------- ;

event OnVersionUpdate(int version)
	string EventType
	; Install System - Fresh install or pre v1.50
	if CurrentVersion < 15000

		SetupSystem()
		Debug.Notification("SexLab Installed...")
		EventType = "SexLabInstalled"

	; Update System - v1.5x incremental updates
	elseIf CurrentVersion < version

		; v1.51 - I don't exists yet and am only here as a reference for future self.
		if CurrentVersion < 15100
			Debug.TraceAndBox("SexLab Error: Getting this error should be impossible, the hell did you do?")
		endIf

		EventType = "SexLabUpdated"
	endIf
	; Send update/install event
	int eid = ModEvent.Create(EventType)
	ModEvent.PushInt(eid, version)
	ModEvent.Send(eid)
endEvent

function SetupSystem()
	; Wait until out of menus to setup resources
	; while Utility.IsInMenuMode() || !PlayerRef.Is3DLoaded()
	; 	Utility.Wait(1.0)
	; endWhile
	Debug.Notification("Installing SexLab v"+GetStringVer())
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
	; Ensure we have the important varables
	Quest SexLabQuestFramework = Game.GetFormFromFile(0xD62, "SexLab.esm") as Quest
	SexLab = SexLabQuestFramework as SexLabFramework
	Config = SexLabQuestFramework as sslSystemConfig
	; Reload SexLab's voice/tfc config at load
	if CurrentVersion > 0 && Config.CheckSystem()
		Config.ReloadConfig()
	else
		SexLab.GoToState("Disabled")
	endIf
	Debug.Trace("SexLab Loaded CurrentVerison: "+CurrentVersion)
endEvent

; event OnRaceSwitchComplete()
; 	StorageUtil.FormListClear(SexLab, "ValidActors")
; 	if Pages.Length > 0
; 		if PlayerRef.GetLeveledActorBase().GetSex() == 1
; 			Pages[11] = "$SSL_SexDiary"
; 		else
; 			Pages[11] = "$SSL_SexJournal"
; 		endIf
; 	endIf
; endEvent

; ------------------------------------------------------- ;
; --- Create MCM Pages                                --- ;
; ------------------------------------------------------- ;

event OnPageReset(string page)
	; Logo
	if page == ""
		LoadCustomContent("SexLab/logo.dds", 184, 31)
		return
	endIf
	UnloadCustomContent()

	; General Animation Settings
	if page == "$SSL_AnimationSettings"
		AnimationSettings()

	; Toggle Voices + SFX Settings
	elseIf page == "$SSL_SoundSettings"
		SoundSettings()

	; Hotkey selection & config
	elseIf page == "$SSL_PlayerHotkeys"
		PlayerHotkeys()

	; Timers & stripping
	elseIf page == "$SSL_TimersStripping"
		TimersStripping()

	; Toggle animations on/off
	elseIf page == "$SSL_ToggleAnimations"
		ToggleAnimations()

	; Animation Editor
	elseIf page == "$SSL_AnimationEditor"
		AnimationEditor()

	; Toggle expressions
	; elseIf page == "$SSL_ExpressionSelection"
	; 	ToggleExpressions()

	; Toggle/Edit Expressions
	elseIf page == "$SSL_ExpressionEditor"
		ExpressionEditor()

	; Player Diary/Journal
	elseIf page == "$SSL_SexDiary" || page == "$SSL_SexJournal"
		SexDiary()

	; System rebuild & clean
	elseIf page == "$SSL_RebuildClean"
		RebuildClean()

	endIf

endEvent

; ------------------------------------------------------- ;
; --- Mapped State Option Events                      --- ;
; ------------------------------------------------------- ;

string[] function MapOptions()
	return sslUtility.ArgString(GetState(), "_")
endFunction

event OnSliderOpenST()
	string[] Options = MapOptions()

	; Animation Editor
	if Options[0] == "Adjust"
		; Stage, Slot
		SetSliderDialogStartValue(Animation.GetAdjustment(Animation.Key("Adjust."+AdjustKey), Position, Options[1] as int, Options[2] as int))
		if Options[2] == "3" ; SOS
			SetSliderDialogRange(-9, 9)
			SetSliderDialogInterval(1)
			SetSliderDialogDefaultValue(0)
		else ; Alignments
			SetSliderDialogRange(-100.0, 100.0)
			SetSliderDialogInterval(0.50)
			SetSliderDialogDefaultValue(0.0)
		endIf
	; Expression Editor
	elseIf Options[0] == "Expression"
		; Gender, Type, ID
		SetSliderDialogStartValue( Expression.GetIndex(Phase, Options[1] as int, Options[2] as int, Options[3] as int) )
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
		SetSliderDialogDefaultValue(0)

	; Timers & Stripping - Timers
	elseIf Options[0] == "Timers"
		float[] Timers = GetTimers()
		SetSliderDialogStartValue(Timers[(Options[2] as int)])
		SetSliderDialogRange(3.0, 300.0)
		SetSliderDialogInterval(1.0)
		SetSliderDialogDefaultValue(15.0)

	endIf

endEvent

event OnSliderAcceptST(float value)
	string[] Options = MapOptions()

	; Animation Editor
	if Options[0] == "Adjust"
		; Stage, Slot
		Animation.SetAdjustment(Animation.Key("Adjust."+AdjustKey), Position, Options[1] as int, Options[2] as int, value)
		Animation.SaveProfile(Config.AnimProfile)
		SetSliderOptionValueST(value)
	; Expression Editor
	elseIf Options[0] == "Expression"
		; Gender, Type, ID
		Expression.SetIndex(Phase, Options[1] as int, Options[2] as int, Options[3] as int, value as int)
		SetSliderOptionValueST(value as int)

	; Timers & Stripping - Timers
	elseIf Options[0] == "Timers"
		float[] Timers = GetTimers()
		Timers[(Options[2] as int)] = value
		SetSliderOptionValueST(value, "$SSL_Seconds")

	endIf

endEvent

event OnSelectST()
	string[] Options = MapOptions()

	; Sound Settings - Voice Toggle
	if Options[0] == "Voice"
		sslBaseVoice Slot = VoiceSlots.Voices[(Options[1] as int)]
		Slot.Enabled = !Slot.Enabled
		SetToggleOptionValueST(Slot.Enabled)

	; Timers & Stripping - Stripping
	elseIf Options[0] == "Stripping"
		bool[] Stripping = GetStripping(Options[1] as int)
		int i = Options[2] as int
		Stripping[i] = !Stripping[i]
		SetToggleOptionValueST(Stripping[i])

	; Animation Toggle
	elseIf Options[0] == "Animation"
		; Get animation to toggle
		sslBaseAnimation Slot
		if ta == 3
			Slot = CreatureSlots.GetBySlot(Options[1] as int)
		else
			Slot = AnimSlots.GetBySlot(Options[1] as int)
		endIf
		; Toggle action
		if ta == 1
			Slot.ToggleTag("LeadIn")
		elseIf ta == 2
			Slot.ToggleTag("Aggressive")
		else
			Slot.Enabled = !Slot.Enabled
		endIf

		SetToggleOptionValueST(GetToggle(Slot))

	; Toggle Expressions
	elseIf Options[0] == "Expression"
		sslBaseExpression Slot = ExpressionSlots.GetBySlot(Options[2] as int)
		Slot.ToggleTag(Options[1])
		SetToggleOptionValueST(Slot.HasTag(Options[1]))

	; Toggle Strapons
	elseIf Options[0] == "Strapon"
		int i = Options[1] as int
		Form[] Output
		Form[] Strapons = Config.Strapons
		int n = Strapons.Length
		while n
			n -= 1
			if n != i
				Output = sslUtility.PushForm(Strapons[n], Output)
			endIf
		endWhile
		Config.Strapons = Output
		ForcePageReset()
	endIf
endEvent

; event OnDefaultST()
; endEvent

; event OnHighlightST()
; endEvent

; ------------------------------------------------------- ;
; --- Animation Settings                              --- ;
; ------------------------------------------------------- ;

function AnimationSettings()
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
	; AddHeaderOption("$SSL_AnimationHandling")
	AddMenuOptionST("AnimationProfile", "$SSL_AnimationProfile", Config.ProfileLabel(Config.AnimProfile))
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
endFunction

state AnimationProfile
	event OnMenuOpenST()
		string[] Profiles = new string[5]
		Profiles[0] = Config.ProfileLabel(1)
		Profiles[1] = Config.ProfileLabel(2)
		Profiles[2] = Config.ProfileLabel(3)
		Profiles[3] = Config.ProfileLabel(4)
		Profiles[4] = Config.ProfileLabel(5)
		SetMenuDialogStartIndex((Config.AnimProfile - 1))
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(Profiles)
	endEvent
	event OnMenuAcceptST(int i)
		i += 1
		; Export/Set/Import profiles
		Config.ExportProfile(Config.AnimProfile)
		Config.AnimProfile = sslUtility.ClampInt(i, 1, 5)
		Config.ImportProfile(Config.AnimProfile)
		SetMenuOptionValueST(Config.ProfileLabel(Config.AnimProfile))
	endEvent
	event OnDefaultST()
		OnMenuAcceptST(1)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAnimationProfile")
	endEvent
endState

; ------------------------------------------------------- ;
; --- Player Hotkeys                                  --- ;
; ------------------------------------------------------- ;

function PlayerHotkeys()
	SetCursorFillMode(TOP_TO_BOTTOM)

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

	SetCursorPosition(1)
	AddHeaderOption("$SSL_AlignmentAdjustments")
	AddKeyMapOptionST("BackwardsModifier", "$SSL_ReverseDirectionModifier", Config.kBackwards)
	AddKeyMapOptionST("AdjustStage","$SSL_AdjustStage", Config.kAdjustStage)
	AddKeyMapOptionST("AdjustChange","$SSL_ChangeActorBeingMoved", Config.kAdjustChange)
	AddKeyMapOptionST("AdjustForward","$SSL_MoveActorForwardBackward", Config.kAdjustForward)
	AddKeyMapOptionST("AdjustUpward","$SSL_AdjustPositionUpwardDownward", Config.kAdjustUpward)
	AddKeyMapOptionST("AdjustSideways","$SSL_MoveActorLeftRight", Config.kAdjustSideways)
	AddKeyMapOptionST("RotateScene", "$SSL_RotateScene", Config.kRotateScene)
	AddKeyMapOptionST("RestoreOffsets","$SSL_DeleteSavedAdjustments", Config.kRestoreOffsets)
endFunction

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
			Config.UnregisterForKey(Config.kTargetActor)
			Config.kTargetActor = newKeyCode
			Config.RegisterForKey(Config.kTargetActor)
			SetKeyMapOptionValueST(Config.kTargetActor)
		endIf
	endEvent
	event OnDefaultST()
		Config.UnregisterForKey(Config.kTargetActor)
		Config.kTargetActor = 49
		Config.RegisterForKey(Config.kTargetActor)
		SetKeyMapOptionValueST(Config.kTargetActor)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoTargetActor")
	endEvent
endState
state ToggleFreeCamera
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.UnregisterForKey(Config.kToggleFreeCamera)
			Config.kToggleFreeCamera = newKeyCode
			Config.RegisterForKey(Config.kToggleFreeCamera)
			SetKeyMapOptionValueST(Config.kToggleFreeCamera)
		endIf
	endEvent
	event OnDefaultST()
		Config.UnregisterForKey(Config.kToggleFreeCamera)
		Config.kToggleFreeCamera = 81
		Config.RegisterForKey(Config.kToggleFreeCamera)
		SetKeyMapOptionValueST(Config.kToggleFreeCamera)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoToggleFreeCamera")
	endEvent
endState


; ------------------------------------------------------- ;
; --- Sound Settings                                  --- ;
; ------------------------------------------------------- ;

function SoundSettings()
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
	int i
	while i < VoiceSlots.Slotted
		if VoiceSlots.Voices[i].Registered
			AddToggleOptionST("Voice_"+i, VoiceSlots.Voices[i].Name, VoiceSlots.Voices[i].Enabled)
		endIf
		i += 1
	endWhile
endFunction

; ------------------------------------------------------- ;
; --- Animation Editor                                --- ;
; ------------------------------------------------------- ;

; Current edit target
sslBaseAnimation Animation
string AdjustKey
int Position

function AnimationEditor()
	SetCursorFillMode(LEFT_TO_RIGHT)

	if Animation == none
		Animation = AnimSlots.GetBySlot(0)
		AdjustKey = "Global"
		Position  = 0
	endIf

	Animation.InitAdjustments(Animation.Key("Adjust."+AdjustKey))

	SetTitleText(Animation.Name)
	AddMenuOptionST("AnimationSelect", "$SSL_Animation", Animation.Name)
	if Animation.PositionCount == 1 || (Animation.PositionCount == 2 && TargetRef != none)
		AddTextOptionST("AnimationTest", "$SSL_PlayAnimation", "$SSL_ClickHere")
	else
		AddTextOptionST("AnimationTest", "$SSL_PlayAnimation", "$SSL_ClickHere", OPTION_FLAG_DISABLED)
	endIf

	AddMenuOptionST("AnimationAdjustKey", "$SSL_AdjustmentProfile", AdjustKey)
	AddMenuOptionST("AnimationPosition", "$SSL_Position", "$SSL_{"+GenderLabel(Animation.GetGender(Position))+"}Gender{"+(Position + 1)+"}Position")

	string Profile
	if AdjustKey != "Global"
		string[] RaceIDs = sslUtility.ArgString(AdjustKey, ".")
		string id = StringUtil.Substring(RaceIDs[Position], 0, (StringUtil.GetLength(RaceIDs[Position]) - 1))
		Race RaceRef = Race.GetRace(id)
		if RaceRef != none
			id = RaceRef.GetName()
		endIf
		Profile = "$SSL_{"+id+"}-{"+GenderLabel(StringUtil.GetNthChar(RaceIDs[Position], (StringUtil.GetLength(RaceIDs[Position]) - 1)))+"}"
	else
		Profile = "$SSL_{Global}-{"+GenderLabel(Animation.GetGender(Position))+"}"
	endIf

	int Stage = 1
	while Stage <= Animation.StageCount

		float[] Adjustments = Animation.GetPositionAdjustments(Animation.Key("Adjust."+AdjustKey), Position, Stage)
		AddHeaderOption("$SSL_Stage{"+Stage+"}Adjustments")
		AddHeaderOption(Profile)

		AddSliderOptionST("Adjust_"+Stage+"_0", "$SSL_AdjustForwards", Adjustments[0], "{2}")
		AddSliderOptionST("Adjust_"+Stage+"_1", "$SSL_AdjustSideways", Adjustments[1], "{2}")
		AddSliderOptionST("Adjust_"+Stage+"_2", "$SSL_AdjustUpwards",  Adjustments[2], "{2}")
		AddSliderOptionST("Adjust_"+Stage+"_3", "$SSL_SchlongUpDown",  Adjustments[3], "{0}")

		Stage += 1
	endWhile
endFunction

string function GenderLabel(string id)
	if id == "0" || id == "M"
		return "$SSL_Male"
	elseIf id == "1" || id == "F"
		return "$SSL_Female"
	elseIf id == "2" || id == "C"
		return "$SSL_Creature"
	endIf
	return "$Unknown"
endFunction

state AnimationSelect
	event OnMenuOpenST()
		SetMenuDialogStartIndex(AnimSlots.Slots.Find(Animation))
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(AnimSlots.GetNames())
	endEvent
	event OnMenuAcceptST(int i)
		Animation = AnimSlots.GetBySlot(i)
		AdjustKey = "Global"
		Position  = 0
		SetMenuOptionValueST(Animation.Name)
		ForcePageReset()
	endEvent
	event OnDefaultST()
		Animation = AnimSlots.GetBySlot(0)
		AdjustKey = "Global"
		Position  = 0
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
			Positions[i] = "$SSL_{"+GenderLabel(Animation.GetGender(i))+"}Gender{"+(i + 1)+"}Position"
		endWhile
		SetMenuDialogStartIndex(Position)
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(Positions)
	endEvent
	event OnMenuAcceptST(int i)
		Position = i
		SetMenuOptionValueST("$SSL_{"+GenderLabel(Animation.GetGender(i))+"}Gender{"+(i + 1)+"}Position")
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
		SetMenuDialogStartIndex(AdjustKeys.Find(AdjustKey))
		SetMenuDialogDefaultIndex(AdjustKeys.Find("Global"))
		SetMenuDialogOptions(AdjustKeys)
	endEvent
	event OnMenuAcceptST(int i)
		string[] AdjustKeys = Animation.GetAdjustKeys()
		AdjustKey  = AdjustKeys[i]
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

; ------------------------------------------------------- ;
; --- Toggle Animations                               --- ;
; ------------------------------------------------------- ;

string[] TAModes
int ta

function ToggleAnimations()
	SetCursorFillMode(LEFT_TO_RIGHT)

	SetTitleText(TAModes[ta])
	AddMenuOptionST("TAModeSelect", "$SSL_View", TAModes[ta])
	AddHeaderOption("")

	sslBaseAnimation[] Slots
	int Slotted

	if ta == 3
		Slots   = CreatureSlots.Slots
		Slotted = CreatureSlots.Slotted
	else
		Slots   = AnimSlots.Slots
		Slotted = AnimSlots.Slotted
	endIf

	int i
	while i < Slotted
		if Slots[i].Registered
			AddToggleOptionST("Animation_"+i, Slots[i].Name, GetToggle(Slots[i]))
		endIf
		i += 1
	endWhile
endFunction

sslBaseAnimation[] function GetSlots()
	if ta == 3
		return CreatureSlots.Slots
	else
		return AnimSlots.Slots
	endIf
endFunction

bool function GetToggle(sslBaseAnimation Anim)
	if ta == 1
		return Anim.HasTag("LeadIn")
	elseIf ta == 2
		return Anim.HasTag("Aggressive")
	else
		return Anim.Enabled
	endIf
endFunction

state TAModeSelect
	event OnMenuOpenST()
		SetMenuDialogStartIndex(ta)
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(TAModes)
	endEvent
	event OnMenuAcceptST(int i)
		ta = i
		SetMenuOptionValueST(TAModes[ta])
		ForcePageReset()
	endEvent
	event OnDefaultST()
		ta = 0
		SetMenuOptionValueST(TAModes[ta])
		ForcePageReset()
	endEvent
endState

; ------------------------------------------------------- ;
; --- Toggle Expressions                              --- ;
; ------------------------------------------------------- ;

function ToggleExpressions()
	SetCursorFillMode(LEFT_TO_RIGHT)

	int flag = 0x00
	if !Config.bUseExpressions
		AddHeaderOption("$SSL_ExpressionsDisabled")
		AddToggleOptionST("UseExpressions","$SSL_UseExpressions", Config.bUseExpressions)
		flag = OPTION_FLAG_DISABLED
	endIf

	AddHeaderOption("$SSL_ExpressionsNormal")
	AddHeaderOption("")
	int i
	while i < ExpressionSlots.Slotted
		sslBaseExpression Exp = ExpressionSlots.Expressions[i]
		if Exp.Registered && Exp.Enabled
			AddToggleOptionST("Expression_Normal_"+i, Exp.Name, Exp.HasTag("Normal") && flag == 0x00, flag)
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
			AddToggleOptionST("Expression_Victim_"+i, Exp.Name, Exp.HasTag("Victim") && flag == 0x00, flag)
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
			AddToggleOptionST("Expression_Aggressor_"+i, Exp.Name, Exp.HasTag("Aggressor") && flag == 0x00, flag)
		endIf
		i += 1
	endWhile
endFunction

; ------------------------------------------------------- ;
; --- Expression Editor                               --- ;
; ------------------------------------------------------- ;

; Current edit target
sslBaseExpression Expression
int Phase
; Type flags
int property Male = 0 autoreadonly
int property Female = 1 autoreadonly
int property Phoneme = 0 autoreadonly
int property Modifier = 16 autoreadonly
int property Mood = 30 autoreadonly
; Labels
string[] Phases
string[] Moods
string[] Phonemes
string[] Modifiers

function ExpressionEditor()
	SetCursorFillMode(LEFT_TO_RIGHT)

	int i
	if Expression == none
		Expression = ExpressionSlots.GetBySlot(0)
		Phase = 1
	endIf

	int Flag  = OPTION_FLAG_NONE
	int FlagF = OPTION_FLAG_NONE
	int FlagM = OPTION_FLAG_NONE
	if Phase > Expression.PhasesFemale && Phase > Expression.PhasesMale
		Flag  = OPTION_FLAG_DISABLED
		FlagF = OPTION_FLAG_DISABLED
		FlagM = OPTION_FLAG_DISABLED
	else
		if Phase > Expression.PhasesFemale
			FlagF = OPTION_FLAG_DISABLED
		endIf
		if Phase > Expression.PhasesMale
			FlagM = OPTION_FLAG_DISABLED
		endIf
	endIf

	SetTitleText(Expression.Name)
	AddMenuOptionST("ExpressionSelect", "$SSL_ModifyingExpression", Expression.Name)
	AddToggleOptionST("ExpressionNormal", "$SSL_ExpressionsNormal", Expression.HasTag("Normal"), Flag)

	AddTextOptionST("ExpressionTestPlayer", "$SSL_TestOnPlayer", "$SSL_Apply")
	AddToggleOptionST("ExpressionVictim", "$SSL_ExpressionsVictim", Expression.HasTag("Victim"), Flag)

	AddTextOptionST("ExpressionTestTarget", "$SSL_TestOn{"+TargetName+"}", "$SSL_Apply", TargetFlag)
	AddToggleOptionST("ExpressionAggressor", "$SSL_ExpressionsAggressor", Expression.HasTag("Aggressor"), Flag)

	AddMenuOptionST("ExpressionPhase", "$SSL_Modifying{"+Expression.Name+"}Phase", Phase)
	AddHeaderOption("")

	; Show expression customization options
	int[] FemaleModifiers = Expression.GetModifiers(Phase, Female)
	int[] FemalePhonemes  = Expression.GetPhonemes(Phase, Female)

	int[] MaleModifiers   = Expression.GetModifiers(Phase, Male)
	int[] MalePhonemes    = Expression.GetPhonemes(Phase, Male)

	; Add/Remove Female Phase
	if Phase == (Expression.PhasesFemale + 1)
		AddTextOptionST("ExpressionAddPhaseFemale", "$SSL_AddFemalePhase", "$SSL_ClickHere")
	elseIf Phase > Expression.PhasesFemale
		AddTextOptionST("ExpressionAddPhaseFemale", "$SSL_AddFemalePhase", "$SSL_ClickHere", OPTION_FLAG_DISABLED)
	elseIf Phase == Expression.PhasesFemale
		AddTextOptionST("ExpressionRemovePhaseFemale", "$SSL_RemoveFemalePhase", "$SSL_ClickHere")
	elseIf Phase < Expression.PhasesFemale
		AddTextOptionST("ExpressionRemovePhaseFemale", "$SSL_RemoveFemalePhase", "$SSL_ClickHere", OPTION_FLAG_DISABLED)
	else
		AddEmptyOption()
	endIf
	; Add/Remove Male Phase
	if Phase == (Expression.PhasesMale + 1)
		AddTextOptionST("ExpressionAddPhaseMale", "$SSL_AddMalePhase", "$SSL_ClickHere")
	elseIf Phase > Expression.PhasesMale
		AddTextOptionST("ExpressionAddPhaseMale", "$SSL_AddMalePhase", "$SSL_ClickHere", OPTION_FLAG_DISABLED)
	elseIf Phase == Expression.PhasesMale
		AddTextOptionST("ExpressionRemovePhaseMale", "$SSL_RemoveMalePhase", "$SSL_ClickHere")
	elseIf Phase < Expression.PhasesMale
		AddTextOptionST("ExpressionRemovePhaseMale", "$SSL_RemoveMalePhase", "$SSL_ClickHere", OPTION_FLAG_DISABLED)
	else
		AddEmptyOption()
	endIf

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
		AddSliderOptionST("Expression_1_"+Modifier+"_"+i, Modifiers[i], FemaleModifiers[i], "{0}", FlagF)
		AddSliderOptionST("Expression_0_"+Modifier+"_"+i, Modifiers[i], MaleModifiers[i], "{0}", FlagM)
		i += 1
	endWhile
	AddHeaderOption("$SSL_{$SSL_Female}-{$SSL_Phoneme}", FlagF)
	AddHeaderOption("$SSL_{$SSL_Male}-{$SSL_Phoneme}", FlagM)
	i = 0
	while i < 16
		AddSliderOptionST("Expression_1_"+Phoneme+"_"+i, Phonemes[i], FemalePhonemes[i], "{0}", FlagF)
		AddSliderOptionST("Expression_0_"+Phoneme+"_"+i, Phonemes[i], MalePhonemes[i], "{0}", FlagM)
		i += 1
	endWhile
endFunction

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


state ExpressionNormal
	event OnSelectST()
		Expression.ToggleTag("Normal")
		SetToggleOptionValueST(Expression.HasTag("Normal"))
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_ToggleExpressionNormal")
	endEvent
endState
state ExpressionVictim
	event OnSelectST()
		Expression.ToggleTag("Victim")
		SetToggleOptionValueST(Expression.HasTag("Victim"))
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_ToggleExpressionVictim")
	endEvent
endState
state ExpressionAggressor
	event OnSelectST()
		Expression.ToggleTag("Aggressor")
		SetToggleOptionValueST(Expression.HasTag("Aggressor"))
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_ToggleExpressionAggressor")
	endEvent
endState

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

; ------------------------------------------------------- ;
; --- Sex Diary/Journal Editor                        --- ;
; ------------------------------------------------------- ;

Actor StatRef

function SexDiary()
	SetCursorFillMode(TOP_TO_BOTTOM)

	if TargetRef != StatRef
		AddTextOptionST("SetStatTarget", "$SSL_Viewing{"+StatRef.GetLeveledActorBase().GetName()+"}", "$SSL_View{"+TargetName+"}", TargetFlag)
	else
		AddTextOptionST("SetStatTarget", "$SSL_Viewing{"+TargetName+"}", "$SSL_View{"+PlayerRef.GetLeveledActorBase().GetName()+"}")
	endIf

	AddHeaderOption("$SSL_SexualExperience")
	AddTextOption("$SSL_TimeSpentHavingSex", Stats.ParseTime(Stats.GetFloat(StatRef, "TimeSpent") as int))
	AddTextOption("$SSL_VaginalProficiency", Stats.GetSkillTitle(StatRef, "Vaginal"))
	AddTextOption("$SSL_AnalProficiency", Stats.GetSkillTitle(StatRef, "Anal"))
	AddTextOption("$SSL_OralProficiency", Stats.GetSkillTitle(StatRef, "Oral"))
	AddTextOption("$SSL_ForeplayProficiency", Stats.GetSkillTitle(StatRef, "Foreplay"))
	AddTextOption("$SSL_SexualPurity", Stats.GetPureTitle(StatRef))
	AddTextOption("$SSL_SexualPerversion", Stats.GetLewdTitle(StatRef))
	AddEmptyOption()

	SetCursorPosition(1)

	AddTextOptionST("ResetTargetStats", "$SSL_Reset{"+StatRef.GetLeveledActorBase().GetName()+"}Stats", "$SSL_ClickHere")

	AddHeaderOption("$SSL_SexualStats")
	AddTextOptionST("SetStatSexuality", "$SSL_Sexuality", Stats.GetSexualityTitle(StatRef))
	AddTextOption("$SSL_MaleSexualPartners", Stats.GetInt(StatRef, "Males"))
	AddTextOption("$SSL_FemaleSexualPartners", Stats.GetInt(StatRef, "Females"))
	AddTextOption("$SSL_CreatureSexualPartners", Stats.GetInt(StatRef, "Creatures"))
	AddTextOption("$SSL_TimesMasturbated", Stats.GetInt(StatRef, "Masturbation"))
	AddTextOption("$SSL_TimesAggressive", Stats.GetInt(StatRef, "Aggressor"))
	AddTextOption("$SSL_TimesVictim", Stats.GetInt(StatRef, "Victim"))
	AddEmptyOption()
endFunction

state SetStatTarget
	event OnSelectST()
		if StatRef == PlayerRef && TargetRef != none
			StatRef = TargetRef
		else
			StatRef = PlayerRef
		endIf
		ForcePageReset()
	endEvent
endState
state SetStatSexuality
	event OnSelectST()
		int Ratio = Stats.GetSexuality(StatRef)
		if Stats.IsStraight(StatRef)
			Stats.SetInt(StatRef, "Sexuality", 50)
		elseIf Stats.IsBisexual(StatRef)
			Stats.SetInt(StatRef, "Sexuality", 0)
		else
			Stats.SetInt(StatRef, "Sexuality", 100)
		endIf
		SetTextOptionValueST(Stats.GetSexualityTitle(StatRef))
	endEvent
endState
state ResetTargetStats
	event OnSelectST()
		if ShowMessage("$SSL_WarnReset{"+StatRef.GetLeveledActorBase().GetName()+"}Stats")
			Stats.ResetStats(StatRef)
			ForcePageReset()
		endIf
	endEvent
endState

; ------------------------------------------------------- ;
; --- Timers & Stripping                              --- ;
; ------------------------------------------------------- ;

string[] Biped
string[] TSModes
int ts

function TimersStripping()
	SetCursorFillMode(LEFT_TO_RIGHT)

	SetTitleText(TSModes[ts])
	AddMenuOptionST("TSModeSelect", "$SSL_View", TSModes[ts])
	AddHeaderOption("")

	; Timers
	float[] Timers = GetTimers()

	if ts == 1
		AddHeaderOption("$SSL_ForeplayIntroAnimationTimers")
	elseIf ts == 2
		AddHeaderOption("$SSL_AggressiveAnimationTimers")
	else
		AddHeaderOption("$SSL_ConsensualStageTimers")
	endIf

	AddHeaderOption("")
	AddSliderOptionST("Timers_"+ts+"_0", "$SSL_Stage1Length", Timers[0], "$SSL_Seconds")
	AddSliderOptionST("Timers_"+ts+"_3", "$SSL_Stage4Length", Timers[3], "$SSL_Seconds")
	AddSliderOptionST("Timers_"+ts+"_1", "$SSL_Stage2Length", Timers[1], "$SSL_Seconds")
	AddSliderOptionST("Timers_"+ts+"_4", "$SSL_StageEndingLength", Timers[4], "$SSL_Seconds")
	AddSliderOptionST("Timers_"+ts+"_2", "$SSL_Stage3Length", Timers[2], "$SSL_Seconds")
	AddEmptyOption()
	; Stripping
	bool[] Strip1 = GetStripping(1)
	bool[] Strip0 = GetStripping(0)
	if ts == 2
		AddHeaderOption("$SSL_VictimStripFrom")
		AddHeaderOption("$SSL_AggressorStripFrom")
	else
		AddHeaderOption("$SSL_FemaleStripFrom")
		AddHeaderOption("$SSL_MaleStripFrom")
	endIf
	AddToggleOptionST("Stripping_1_32", Biped[32], Strip1[32])
	AddToggleOptionST("Stripping_0_32", Biped[32], Strip0[32])
	int i
	while i < 32
		AddToggleOptionST("Stripping_1_"+i, Biped[i], Strip1[i])
		AddToggleOptionST("Stripping_0_"+i, Biped[i], Strip0[i])
		if i == 13
			AddHeaderOption("$SSL_ExtraSlots")
			AddHeaderOption("$SSL_ExtraSlots")
		endIf
		i += 1
	endWhile
endFunction

float[] function GetTimers()
	if ts == 1
		return Config.fStageTimerLeadIn
	elseIf ts == 2
		return Config.fStageTimerAggr
	else
		return Config.fStageTimer
	endIf
endFunction

bool[] function GetStripping(int type)
	if ts == 1
		if type == 1
			return Config.bStripLeadInFemale
		else
			return Config.bStripLeadInMale
		endIf
	elseIf ts == 2
		if type == 1
			return Config.bStripVictim
		else
			return Config.bStripAggressor
		endIf
	else
		if type == 1
			return Config.bStripFemale
		else
			return Config.bStripMale
		endIf
	endIf
endFunction

state TSModeSelect
	event OnMenuOpenST()
		SetMenuDialogStartIndex(ts)
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(TSModes)
	endEvent
	event OnMenuAcceptST(int i)
		ts = i
		SetMenuOptionValueST(TSModes[ts])
		ForcePageReset()
	endEvent
	event OnDefaultST()
		ts = 0
		SetMenuOptionValueST(TSModes[ts])
		ForcePageReset()
	endEvent
endState

; ------------------------------------------------------- ;
; --- Rebuild & Clean                                 --- ;
; ------------------------------------------------------- ;

function RebuildClean()
	SetCursorFillMode(TOP_TO_BOTTOM)

	AddHeaderOption("SexLab v"+GetStringVer()+" by Ashal@LoversLab.com")
	AddHeaderOption("$SSL_Maintenance")
	if SexLab.Enabled
		AddTextOptionST("ToggleSystem","$SSL_EnabledSystem", "$SSL_DoDisable")
	else
		AddTextOptionST("ToggleSystem","$SSL_DisabledSystem", "$SSL_DoEnable")
	endIf

	AddTextOptionST("ResetAnimationRegistry","$SSL_ResetAnimationRegistry", "$SSL_ClickHere")
	AddTextOptionST("ResetVoiceRegistry","$SSL_ResetVoiceRegistry", "$SSL_ClickHere")
	AddTextOptionST("ResetPlayerSexStats","$SSL_ResetPlayerSexStats", "$SSL_ClickHere")
	AddTextOptionST("RestoreDefaultSettings","$SSL_RestoreDefaultSettings", "$SSL_ClickHere")
	AddTextOptionST("StopCurrentAnimations","$SSL_StopCurrentAnimations", "$SSL_ClickHere")
	AddEmptyOption()
	AddHeaderOption("$SSL_UpgradeUninstallReinstall")
	AddTextOptionST("CleanSystem","$SSL_CleanSystem", "$SSL_ClickHere")

	SetCursorPosition(1)
	AddTextOptionST("ExportSettings","$SSL_ExportSettings", "$SSL_ClickHere")
	AddTextOptionST("ImportSettings","$SSL_ImportSettings", "$SSL_ClickHere")
	AddHeaderOption("$SSL_AvailableStrapons")
	AddTextOptionST("RebuildStraponList","$SSL_RebuildStraponList", "$SSL_ClickHere")
	int i = Config.Strapons.Length
	while i
		i -= 1
		if Config.Strapons[i] != none
			string Name = Config.Strapons[i].GetName()
			if Name == "strapon"
				Name = "Aeon/Horker"
			endIf
			AddTextOptionST("Strapon_"+i, Name, "$SSL_Remove")
		endIf
	endWhile
endFunction

; ------------------------------------------------------- ;
; --- Config Setup                                    --- ;
; ------------------------------------------------------- ;

; Proxy to SexLabUtil.psc so modders don't have to add dependency to this script, and thus SkyUI SDK
int function GetVersion()
	return SexLabUtil.GetVersion()
endFunction
string function GetStringVer()
	return SexLabUtil.GetStringVer()
endFunction

bool function SetDefaults()
	; Check system install before we continue
	if !Config.CheckSystem()
		SexLab.GoToState("Disabled")
		return false
	endIf
	; Prepare base framework script
	SexLab.Setup()
	; Grab libraries to make sure they are all set properly
	ActorLib        = SexLab.ActorLib
	ThreadLib       = SexLab.ThreadLib
	Stats           = SexLab.Stats
	ThreadSlots     = SexLab.ThreadSlots
	AnimSlots       = SexLab.AnimSlots
	CreatureSlots   = SexLab.CreatureSlots
	VoiceSlots      = SexLab.VoiceSlots
	ExpressionSlots = SexLab.ExpressionSlots
	; Set config properties to their default
	Config.SetDefaults()
	return true
endFunction

event OnConfigOpen()
	; MCM option pages
	Pages     = new string[9]
	Pages[0]  = "$SSL_AnimationSettings"
	Pages[1]  = "$SSL_SoundSettings"
	Pages[2]  = "$SSL_TimersStripping"
	Pages[3]  = "$SSL_PlayerHotkeys"
	; Pages[4]  = "$SSL_ExpressionSelection"
	Pages[4]  = "$SSL_ExpressionEditor"
	Pages[5]  = "$SSL_ToggleAnimations"
	Pages[6]  = "$SSL_AnimationEditor"
	Pages[7]  = "$SSL_SexDiary"
	Pages[8]  = "$SSL_RebuildClean"
	if PlayerRef.GetLeveledActorBase().GetSex() == 0
		Pages[7] = "$SSL_SexJournal"
	endIf

	; Target actor
	StatRef = PlayerRef
	TargetRef = Config.TargetRef
	if TargetRef != none && TargetRef.Is3DLoaded()
		TargetName = TargetRef.GetLeveledActorBase().GetName()
		TargetFlag = OPTION_FLAG_NONE
	else
		TargetRef = none
		TargetName = "$SSL_NoTarget"
		TargetFlag = OPTION_FLAG_DISABLED
		Config.TargetRef = none
	endIf

	; Animation Editor

	; Expression Editor
	Phases = new string[5]
	Phases[0] = "Phase 1"
	Phases[1] = "Phase 2"
	Phases[2] = "Phase 3"
	Phases[3] = "Phase 4"
	Phases[4] = "Phase 5"

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

	Phonemes = new string[16]
	Phonemes[0]  = "0: Aah"
	Phonemes[1]  = "1: BigAah"
	Phonemes[2]  = "2: BMP"
	Phonemes[3]  = "3: ChjSh"
	Phonemes[4]  = "4: DST"
	Phonemes[5]  = "5: Eee"
	Phonemes[6]  = "6: Eh"
	Phonemes[7]  = "7: FV"
	Phonemes[8]  = "8: i"
	Phonemes[9]  = "9: k"
	Phonemes[10] = "10: N"
	Phonemes[11] = "11: Oh"
	Phonemes[12] = "12: OohQ"
	Phonemes[13] = "13: R"
	Phonemes[14] = "14: Th"
	Phonemes[15] = "15: W"

	Modifiers = new string[14]
	Modifiers[0]  = "0: BlinkL"
	Modifiers[1]  = "1: BlinkR"
	Modifiers[2]  = "2: BrowDownL"
	Modifiers[3]  = "3: BrownDownR"
	Modifiers[4]  = "4: BrowInL"
	Modifiers[5]  = "5: BrowInR"
	Modifiers[6]  = "6: BrowUpL"
	Modifiers[7]  = "7: BrowUpR"
	Modifiers[8]  = "8: LookDown"
	Modifiers[9]  = "9: LookLeft"
	Modifiers[10] = "10: LookRight"
	Modifiers[11] = "11: LookUp"
	Modifiers[12] = "12: SquintL"
	Modifiers[13] = "13: SquintR"

	; Timers & Stripping
	ts = 0
	TSModes = new string[3]
	TSModes[0] = "$SSL_NormalTimersStripping"
	TSModes[1] = "$SSL_ForeplayTimersStripping"
	TSModes[2] = "$SSL_AggressiveTimersStripping"

	Biped = new string[33]
	Biped[0]  = "$SSL_Head"
	Biped[1]  = "$SSL_Hair"
	Biped[2]  = "$SSL_Torso"
	Biped[3]  = "$SSL_Hands"
	Biped[4]  = "$SSL_Forearms"
	Biped[5]  = "$SSL_Amulet"
	Biped[6]  = "$SSL_Ring"
	Biped[7]  = "$SSL_Feet"
	Biped[8]  = "$SSL_Calves"
	Biped[9]  = "$SSL_Shield"
	Biped[10] = "$SSL_Tail"
	Biped[11] = "$SSL_LongHair"
	Biped[12] = "$SSL_Circlet"
	Biped[13] = "$SSL_Ears"
	Biped[14] = "$SSL_FaceMouth"
	Biped[15] = "$SSL_Neck"
	Biped[16] = "$SSL_Chest"
	Biped[17] = "$SSL_Back"
	Biped[18] = "$SSL_MiscSlot48"
	Biped[19] = "$SSL_PelvisOutergarnments"
	Biped[20] = "$SSL_DecapitatedHead" ; decapitated head [NordRace]
	Biped[21] = "$SSL_Decapitate" ; decapitate [NordRace]
	Biped[22] = "$SSL_PelvisUndergarnments"
	Biped[23] = "$SSL_LegsRightLeg"
	Biped[24] = "$SSL_LegsLeftLeg"
	Biped[25] = "$SSL_FaceJewelry"
	Biped[26] = "$SSL_ChestUndergarnments"
	Biped[27] = "$SSL_Shoulders"
	Biped[28] = "$SSL_ArmsLeftArmUndergarnments"
	Biped[29] = "$SSL_ArmsRightArmOutergarnments"
	Biped[30] = "$SSL_MiscSlot60"
	Biped[31] = "$SSL_MiscSlot61"
	Biped[32] = "$SSL_Weapons"

	; Toggle Animations
	ta = 0
	TAModes = new string[4]
	TAModes[0] = "$SSL_ToggleAnimations"
	TAModes[1] = "$SSL_ForeplayAnimations"
	TAModes[2] = "$SSL_AggressiveAnimations"
	TAModes[3] = "$SSL_CreatureAnimations"
endEvent

event OnConfigClose()
	Phases    = new string[1]
	Moods     = new string[1]
	Phonemes  = new string[1]
	Modifiers = new string[1]
	TSModes   = new string[1]
	TAModes   = new string[1]
	Biped     = new string[1]
endEvent

; ------------------------------------------------------- ;
; --- Unorganized State Option Dump                   --- ;
; ------------------------------------------------------- ;

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
		SetSliderDialogDefaultValue(3.0)
		SetSliderDialogRange(0.8, 30.0)
		SetSliderDialogInterval(0.2)
	endEvent
	event OnSliderAcceptST(float value)
		Config.fSFXDelay = value
		SetSliderOptionValueST(Config.fSFXDelay, "$SSL_Seconds")
	endEvent
	event OnDefaultST()
		Config.fSFXDelay = 3.0
		SetSliderOptionValueST(Config.fSFXDelay, "$SSL_Seconds")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoSFXDelay")
	endEvent
endState
state MaleVoiceDelay
	event OnSliderOpenST()
		SetSliderDialogStartValue(Config.fMaleVoiceDelay)
		SetSliderDialogDefaultValue(5.0)
		SetSliderDialogRange(0.8, 45.0)
		SetSliderDialogInterval(0.2)
	endEvent
	event OnSliderAcceptST(float value)
		Config.fMaleVoiceDelay = value
		SetSliderOptionValueST(Config.fMaleVoiceDelay, "$SSL_Seconds")
	endEvent
	event OnDefaultST()
		Config.fMaleVoiceDelay = 5.0
		SetSliderOptionValueST(Config.fMaleVoiceDelay, "$SSL_Seconds")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoMaleVoiceDelay")
	endEvent
endState
state FemaleVoiceDelay
	event OnSliderOpenST()
		SetSliderDialogStartValue(Config.fFemaleVoiceDelay)
		SetSliderDialogDefaultValue(4.0)
		SetSliderDialogRange(0.8, 45.0)
		SetSliderDialogInterval(0.2)
	endEvent
	event OnSliderAcceptST(float value)
		Config.fFemaleVoiceDelay = value
		SetSliderOptionValueST(Config.fFemaleVoiceDelay, "$SSL_Seconds")
	endEvent
	event OnDefaultST()
		Config.fFemaleVoiceDelay = 4.0
		SetSliderOptionValueST(Config.fFemaleVoiceDelay, "$SSL_Seconds")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoFemaleVoiceDelay")
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
			ModEvent.Send(ModEvent.Create("SexLabReset"))
			Config.CleanSystemFinish.Show()
		endIf
	endEvent
endState
state RebuildStraponList
	event OnSelectST()
		Config.LoadStrapons()
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
			ExportSettings()
			; StorageUtil.FileSetIntValue("SexLabConfig.Exported", 1)
			ShowMessage("$SSL_RunExportSettings", false)
		endIf
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoExportSettings")
	endEvent
endState
state ImportSettings
	event OnSelectST()
		; if StorageUtil.FileGetIntValue("SexLabConfig.Exported") != 1
		; 	ShowMessage("$SSL_WarnImportSettingsEmpty", false)
		if ShowMessage("$SSL_WarnImportSettings")
			ImportSettings()
			StorageUtil.FileUnsetIntValue("SexLabConfig.Exported")
			ShowMessage("$SSL_RunImportSettings", false)
		endIf
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoImportSettings")
	endEvent
endState


function ExportSettings()
	; Set label of export
	ExportString("ExportLabel", PlayerRef.GetLeveledActorBase().GetName()+" - "+Utility.GetCurrentRealTime() as int)

	; Strings
	ExportString("sNPCBed", Config.sNPCBed)

	; Booleans
	ExportBool("bRestrictAggressive", Config.bRestrictAggressive)
	ExportBool("bAllowCreatures", Config.bAllowCreatures)
	ExportBool("bNPCSaveVoice", Config.bNPCSaveVoice)
	ExportBool("bUseStrapons", Config.bUseStrapons)
	ExportBool("bReDressVictim", Config.bReDressVictim)
	ExportBool("bRagdollEnd", Config.bRagdollEnd)
	ExportBool("bUseMaleNudeSuit", Config.bUseMaleNudeSuit)
	ExportBool("bUseFemaleNudeSuit", Config.bUseFemaleNudeSuit)
	ExportBool("bUndressAnimation", Config.bUndressAnimation)
	ExportBool("bUseLipSync", Config.bUseLipSync)
	ExportBool("bUseExpressions", Config.bUseExpressions)
	ExportBool("bScaleActors", Config.bScaleActors)
	ExportBool("bUseCum", Config.bUseCum)
	ExportBool("bAllowFFCum", Config.bAllowFFCum)
	ExportBool("bDisablePlayer", Config.bDisablePlayer)
	ExportBool("bAutoTFC", Config.bAutoTFC)
	ExportBool("bAutoAdvance", Config.bAutoAdvance)
	ExportBool("bForeplayStage", Config.bForeplayStage)
	ExportBool("bOrgasmEffects", Config.bOrgasmEffects)
	ExportBool("bRaceAdjustments", Config.bRaceAdjustments)

	; Integers
	ExportInt("kBackwards", Config.kBackwards)
	ExportInt("kAdjustStage", Config.kAdjustStage)
	ExportInt("kBackwardsAlt", Config.kBackwardsAlt)
	ExportInt("kAdjustStageAlt", Config.kAdjustStageAlt)
	ExportInt("kAdvanceAnimation", Config.kAdvanceAnimation)
	ExportInt("kChangeAnimation", Config.kChangeAnimation)
	ExportInt("kChangePositions", Config.kChangePositions)
	ExportInt("kAdjustChange", Config.kAdjustChange)
	ExportInt("kAdjustForward", Config.kAdjustForward)
	ExportInt("kAdjustSideways", Config.kAdjustSideways)
	ExportInt("kAdjustUpward", Config.kAdjustUpward)
	ExportInt("kRealignActors", Config.kRealignActors)
	ExportInt("kMoveScene", Config.kMoveScene)
	ExportInt("kRestoreOffsets", Config.kRestoreOffsets)
	ExportInt("kRotateScene", Config.kRotateScene)
	ExportInt("kToggleFreeCamera", Config.kToggleFreeCamera)
	ExportInt("kEndAnimation", Config.kEndAnimation)
	ExportInt("AnimProfile", Config.AnimProfile)

	; Floats
	ExportFloat("fCumTimer", Config.fCumTimer)
	ExportFloat("fAutoSUCSM", Config.fAutoSUCSM)
	ExportFloat("fMaleVoiceDelay", Config.fMaleVoiceDelay)
	ExportFloat("fFemaleVoiceDelay", Config.fFemaleVoiceDelay)
	ExportFloat("fVoiceVolume", Config.fVoiceVolume)
	ExportFloat("fSFXDelay", Config.fSFXDelay)
	ExportFloat("fSFXVolume", Config.fSFXVolume)

	; Boolean Arrays
	ExportBoolList("bStripMale", Config.bStripMale, 33)
	ExportBoolList("bStripFemale", Config.bStripFemale, 33)
	ExportBoolList("bStripLeadInFemale", Config.bStripLeadInFemale, 33)
	ExportBoolList("bStripLeadInMale", Config.bStripLeadInMale, 33)
	ExportBoolList("bStripVictim", Config.bStripVictim, 33)
	ExportBoolList("bStripAggressor", Config.bStripAggressor, 33)

	; Float Array
	ExportFloatList("fStageTimer", Config.fStageTimer, 5)
	ExportFloatList("fStageTimerLeadIn", Config.fStageTimerLeadIn, 5)
	ExportFloatList("fStageTimerAggr", Config.fStageTimerAggr, 5)

	; Export object registry
	ExportAnimations()
	ExportCreatures()
	ExportExpressions()
	ExportVoices()

	; Save to JSON file
	ExportFile("SexLabConfig.json", restrictForm = self, append = false)
endFunction

function ImportSettings()
	; Load JSON file
	ImportFile("SexLabConfig.json")

	; Strings
	Config.sNPCBed             = ImportString("sNPCBed", Config.sNPCBed)

	; Booleans
	Config.bRestrictAggressive = ImportBool("bRestrictAggressive", Config.bRestrictAggressive)
	Config.bAllowCreatures     = ImportBool("bAllowCreatures", Config.bAllowCreatures)
	Config.bNPCSaveVoice       = ImportBool("bNPCSaveVoice", Config.bNPCSaveVoice)
	Config.bUseStrapons        = ImportBool("bUseStrapons", Config.bUseStrapons)
	Config.bReDressVictim      = ImportBool("bReDressVictim", Config.bReDressVictim)
	Config.bRagdollEnd         = ImportBool("bRagdollEnd", Config.bRagdollEnd)
	Config.bUseMaleNudeSuit    = ImportBool("bUseMaleNudeSuit", Config.bUseMaleNudeSuit)
	Config.bUseFemaleNudeSuit  = ImportBool("bUseFemaleNudeSuit", Config.bUseFemaleNudeSuit)
	Config.bUndressAnimation   = ImportBool("bUndressAnimation", Config.bUndressAnimation)
	Config.bUseLipSync         = ImportBool("bUseLipSync", Config.bUseLipSync)
	Config.bUseExpressions     = ImportBool("bUseExpressions", Config.bUseExpressions)
	Config.bScaleActors        = ImportBool("bScaleActors", Config.bScaleActors)
	Config.bUseCum             = ImportBool("bUseCum", Config.bUseCum)
	Config.bAllowFFCum         = ImportBool("bAllowFFCum", Config.bAllowFFCum)
	Config.bDisablePlayer      = ImportBool("bDisablePlayer", Config.bDisablePlayer)
	Config.bAutoTFC            = ImportBool("bAutoTFC", Config.bAutoTFC)
	Config.bAutoAdvance        = ImportBool("bAutoAdvance", Config.bAutoAdvance)
	Config.bForeplayStage      = ImportBool("bForeplayStage", Config.bForeplayStage)
	Config.bOrgasmEffects      = ImportBool("bOrgasmEffects", Config.bOrgasmEffects)
	Config.bRaceAdjustments    = ImportBool("bRaceAdjustments", Config.bRaceAdjustments)

	; Integers
	Config.kBackwards          = ImportInt("kBackwards", Config.kBackwards)
	Config.kAdjustStage        = ImportInt("kAdjustStage", Config.kAdjustStage)
	Config.kBackwardsAlt       = ImportInt("kBackwardsAlt", Config.kBackwardsAlt)
	Config.kAdjustStageAlt     = ImportInt("kAdjustStageAlt", Config.kAdjustStageAlt)
	Config.kAdvanceAnimation   = ImportInt("kAdvanceAnimation", Config.kAdvanceAnimation)
	Config.kChangeAnimation    = ImportInt("kChangeAnimation", Config.kChangeAnimation)
	Config.kChangePositions    = ImportInt("kChangePositions", Config.kChangePositions)
	Config.kAdjustChange       = ImportInt("kAdjustChange", Config.kAdjustChange)
	Config.kAdjustForward      = ImportInt("kAdjustForward", Config.kAdjustForward)
	Config.kAdjustSideways     = ImportInt("kAdjustSideways", Config.kAdjustSideways)
	Config.kAdjustUpward       = ImportInt("kAdjustUpward", Config.kAdjustUpward)
	Config.kRealignActors      = ImportInt("kRealignActors", Config.kRealignActors)
	Config.kMoveScene          = ImportInt("kMoveScene", Config.kMoveScene)
	Config.kRestoreOffsets     = ImportInt("kRestoreOffsets", Config.kRestoreOffsets)
	Config.kRotateScene        = ImportInt("kRotateScene", Config.kRotateScene)
	Config.kToggleFreeCamera   = ImportInt("kToggleFreeCamera", Config.kToggleFreeCamera)
	Config.kEndAnimation       = ImportInt("kEndAnimation", Config.kEndAnimation)
	Config.AnimProfile         = ImportInt("AnimProfile", Config.AnimProfile)

	; Floats
	Config.fCumTimer           = ImportFloat("fCumTimer", Config.fCumTimer)
	Config.fAutoSUCSM          = ImportFloat("fAutoSUCSM", Config.fAutoSUCSM)
	Config.fMaleVoiceDelay     = ImportFloat("fMaleVoiceDelay", Config.fMaleVoiceDelay)
	Config.fFemaleVoiceDelay   = ImportFloat("fFemaleVoiceDelay", Config.fFemaleVoiceDelay)
	Config.fVoiceVolume        = ImportFloat("fVoiceVolume", Config.fVoiceVolume)
	Config.fSFXDelay           = ImportFloat("fSFXDelay", Config.fSFXDelay)
	Config.fSFXVolume          = ImportFloat("fSFXVolume", Config.fSFXVolume)

	; Boolean Arrays
	Config.bStripMale          = ImportBoolList("bStripMale", Config.bStripMale, 33)
	Config.bStripFemale        = ImportBoolList("bStripFemale", Config.bStripFemale, 33)
	Config.bStripLeadInFemale  = ImportBoolList("bStripLeadInFemale", Config.bStripLeadInFemale, 33)
	Config.bStripLeadInMale    = ImportBoolList("bStripLeadInMale", Config.bStripLeadInMale, 33)
	Config.bStripVictim        = ImportBoolList("bStripVictim", Config.bStripVictim, 33)
	Config.bStripAggressor     = ImportBoolList("bStripAggressor", Config.bStripAggressor, 33)

	; Float Array
	Config.fStageTimer         = ImportFloatList("fStageTimer", Config.fStageTimer, 5)
	Config.fStageTimerLeadIn   = ImportFloatList("fStageTimerLeadIn", Config.fStageTimerLeadIn, 5)
	Config.fStageTimerAggr     = ImportFloatList("fStageTimerAggr", Config.fStageTimerAggr, 5)

	; Export object registry
	ImportAnimations()
	ImportCreatures()
	ImportExpressions()
	ImportVoices()

	; Reload settings with imported values
	Config.ReloadConfig()
endFunction

; Floats
function ExportFloat(string Name, float Value)
	SetFloatValue(self, Name, Value)
endFunction
float function ImportFloat(string Name, float Value)
	Value = GetFloatValue(self, Name, Value)
	UnsetFloatValue(self, Name)
	return Value
endFunction

; Integers
function ExportInt(string Name, int Value)
	SetIntValue(self, Name, Value)
endFunction
int function ImportInt(string Name, int Value)
	Value = GetIntValue(self, Name, Value)
	UnsetIntValue(self, Name)
	return Value
endFunction

; Booleans
function ExportBool(string Name, bool Value)
	SetIntValue(self, Name, Value as int)
endFunction
bool function ImportBool(string Name, bool Value)
	Value = GetIntValue(self, Name, Value as int) as bool
	UnsetIntValue(self, Name)
	return Value
endFunction

; Strings
function ExportString(string Name, string Value)
	SetStringValue(self, Name, Value)
endFunction
string function ImportString(string Name, string Value)
	Value = GetStringValue(self, Name, Value)
	UnsetStringValue(self, Name)
	return Value
endFunction

; Float Arrays
function ExportFloatList(string Name, float[] Values, int len)
	FloatListClear(self, Name)
	int i
	while i < len
		FloatListAdd(self, Name, Values[i])
		i += 1
	endWhile
endFunction
float[] function ImportFloatList(string Name, float[] Values, int len)
	if FloatListCount(self, Name) == len
		int i
		while i < len
			Values[i] = FloatListGet(self, Name, i)
			i += 1
		endWhile
	endIf
	FloatListClear(self, Name)
	return Values
endFunction

; Boolean Arrays
function ExportBoolList(string Name, bool[] Values, int len)
	IntListClear(self, Name)
	int i
	while i < len
		IntListAdd(self, Name, Values[i] as int)
		i += 1
	endWhile
endFunction
bool[] function ImportBoolList(string Name, bool[] Values, int len)
	if IntListCount(self, Name) == len
		int i
		while i < len
			Values[i] = IntListGet(self, Name, i) as bool
			i += 1
		endWhile
	endIf
	IntListClear(self, Name)
	return Values
endFunction

; Animations
function ExportAnimations()
	int i = AnimSlots.Slotted
	sslBaseAnimation[] Anims = AnimSlots.Animations
	StringListClear(self, "Animations")
	while i
		i -= 1
		StringListAdd(self, "Animations", sslUtility.MakeArgs(",", Anims[i].Registry, Anims[i].Enabled as int, Anims[i].HasTag("Foreplay") as int, Anims[i].HasTag("Aggressive") as int))
	endWhile
endfunction

function ImportAnimations()
	int i = StringListCount(self, "Animations")
	while i
		i -= 1
		; Registrar, Enabled, Foreplay, Aggressive
		string[] args = sslUtility.ArgString(StringListGet(self, "Animations", i))
		if args.Length == 4 && AnimSlots.FindByRegistrar(args[0]) != -1
			sslBaseAnimation Slot = AnimSlots.GetbyRegistrar(args[0])
			Slot.Enabled = (args[1] as int) as bool
			Slot.AddTagConditional("Foreplay", (args[2] as int) as bool)
			Slot.AddTagConditional("Aggressive", (args[3] as int) as bool)
		endIf
	endWhile
	StringListClear(self, "Animations")
endFunction

; Creatures
function ExportCreatures()
	int i = CreatureSlots.Slotted
	sslBaseAnimation[] Anims = CreatureSlots.Animations
	StringListClear(self, "Creatures")
	while i
		i -= 1
		StringListAdd(self, "Creatures", sslUtility.MakeArgs(",", Anims[i].Registry, Anims[i].Enabled as int))
	endWhile
endFunction

function ImportCreatures()
	int i = StringListCount(self, "Creatures")
	while i
		i -= 1
		; Registrar, Enabled
		string[] args = sslUtility.ArgString(StringListGet(self, "Creatures", i))
		if args.Length == 2 && CreatureSlots.FindByRegistrar(args[0]) != -1
			CreatureSlots.GetbyRegistrar(args[0]).Enabled = (args[1] as int) as bool
		endIf
	endWhile
	StringListClear(self, "Creatures")
endFunction

; Expressions
function ExportExpressions()
	int i = ExpressionSlots.Slotted
	sslBaseExpression[] Exprs = ExpressionSlots.Expressions
	StringListClear(self, "Expressions")
	while i
		i -= 1
		StringListAdd(self, "Expressions", sslUtility.MakeArgs(",", Exprs[i].Registry, Exprs[i].HasTag("Consensual") as int, Exprs[i].HasTag("Victim") as int, Exprs[i].HasTag("Aggressor") as int))
	endWhile
endfunction

function ImportExpressions()
	int i = StringListCount(self, "Expressions")
	while i
		i -= 1
		; Registrar, Concensual, Victim, Aggressor
		string[] args = sslUtility.ArgString(StringListGet(self, "Expressions", i))
		if args.Length == 4 && ExpressionSlots.FindByRegistrar(args[0]) != -1
			sslBaseExpression Slot = ExpressionSlots.GetbyRegistrar(args[0])
			Slot.AddTagConditional("Consensual", (args[1] as int) as bool)
			Slot.AddTagConditional("Victim", (args[2] as int) as bool)
			Slot.AddTagConditional("Aggressor", (args[3] as int) as bool)
		endIf
	endWhile
	StringListClear(self, "Expressions")
endFunction

; Voices
function ExportVoices()
	int i = VoiceSlots.Slotted
	sslBaseVoice[] Voices = VoiceSlots.Voices
	StringListClear(self, "Voices")
	while i
		i -= 1
		StringListAdd(self, "Voices", sslUtility.MakeArgs(",", Voices[i].Registry, Voices[i].Enabled as int))
	endWhile
	; Player voice
	ExportString("PlayerVoice", VoiceSlots.GetSavedName(PlayerRef))
endfunction

function ImportVoices()
	int i = StringListCount(self, "Voices")
	while i
		i -= 1
		; Registrar, Enabled
		string[] args = sslUtility.ArgString(StringListGet(self, "Voices", i))
		if args.Length == 2 && VoiceSlots.FindByRegistrar(args[0]) != -1
			VoiceSlots.GetbyRegistrar(args[0]).Enabled = (args[1] as int) as bool
		endIf
	endWhile
	StringListClear(self, "Voices")
	; Player voice
	VoiceSlots.ForgetVoice(PlayerRef)
	VoiceSlots.SaveVoice(PlayerRef, VoiceSlots.GetByName(GetStringValue(self, "PlayerVoice", "$SSL_Random")))
	UnsetStringValue(self, "PlayerVoice")
endFunction
