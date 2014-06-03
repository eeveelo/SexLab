scriptname sslConfigMenu extends SKI_ConfigBase
{Skyrim SexLab Mod Configuration Menu}

import StorageUtil
import sslUtility

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
	if CurrentVersion < 15600

		; v1.51 - Fixed missing ChangeActors() and removed exprsionprofile.json support
		; v1.52 - Altered exporting
		; v1.53 - Changed ActorAlias off of ActorLibrary and ActorLibrary back to sslSystemLibrary
		; v1.54 - Added legacy scripts
		; v1.55 - Added ObjectFactory, moved MCM script back to original Form ID
		; v1.56 - New MCM menu quest; rendering all the previous upgrade stuff useless as it's going to start from scratch

		; Pre 1.56 data cleanup
		FormListClear(none, "NoStripList")
		FormListClear(none, "StripList")
		FormListClear(none, "SexLabActors")
		StringListClear(none, "SexLabCreatures")

		; Install system
		SetupSystem()

		Debug.Notification("SexLab "+SexLabUtil.GetStringVer()+" Installed...")
		EventType = "SexLabInstalled"

	; Update System - v1.5x incremental updates
	elseIf CurrentVersion < version

		Quest SexLabQuestFramework  = Game.GetFormFromFile(0xD62, "SexLab.esm") as Quest
		Quest SexLabQuestAnimations = Game.GetFormFromFile(0x639DF, "SexLab.esm") as Quest
		Quest SexLabQuestRegistry   = Game.GetFormFromFile(0x664FB, "SexLab.esm") as Quest

		SexLab.GoToState("Disabled")

		; v.157 - Fixed actor stripping, expression tags being searched wrong, and refactored thread installs
		if CurrentVersion < 15700
			ExpressionSlots.Setup()
			ThreadSlots.Setup()
			Debug.Notification("SexLab "+SexLabUtil.GetStringVer()+" Updated...")
		endIf

		SexLab.GoToState("Enabled")

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
		; Debug.Notification("$SSL_SexLabUpdated")
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
		ThreadSlots.StopAll()
		Config.Reload()
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

		; Player Diary/Journal
	elseIf page == "Troubleshoot"
		Troubleshoot()


	; System rebuild & clean
	elseIf page == "$SSL_RebuildClean"
		RebuildClean()

	endIf

endEvent

; ------------------------------------------------------- ;
; --- Mapped State Option Events                      --- ;
; ------------------------------------------------------- ;

string[] function MapOptions()
	return ArgString(GetState(), "_")
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
		SetSliderDialogRange(3, 300)
		SetSliderDialogInterval(1)
		SetSliderDialogDefaultValue(15)

	endIf

endEvent

event OnSliderAcceptST(float value)
	string[] Options = MapOptions()

	; Animation Editor
	if Options[0] == "Adjust"
		; Stage, Slot
		Animation.SetAdjustment(Animation.Key("Adjust."+AdjustKey), Position, Options[1] as int, Options[2] as int, value)
		StorageUtil.ExportFile("AnimationProfile_"+Config.AnimProfile+".json", Animation.Key("Adjust."+AdjustKey))
		SetSliderOptionValueST(value, "{2}")

	; Expression Editor
	elseIf Options[0] == "Expression"
		; Gender, Type, ID
		Expression.SetIndex(Phase, Options[1] as int, Options[2] as int, Options[3] as int, value as int)
		; Expression.SavePhase(Phase, Options[1] as int)
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
				Output = PushForm(Strapons[n], Output)
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

string[] Chances

function AnimationSettings()
	SetCursorFillMode(TOP_TO_BOTTOM)
	; AddHeaderOption("$SSL_PlayerSettings")
	AddToggleOptionST("AutoAdvance","$SSL_AutoAdvanceStages", Config.AutoAdvance)
	AddToggleOptionST("DisableVictim","$SSL_DisableVictimControls", Config.DisablePlayer)
	AddToggleOptionST("AutomaticTFC","$SSL_AutomaticTFC", Config.AutoTFC)
	AddSliderOptionST("AutomaticSUCSM","$SSL_AutomaticSUCSM", Config.AutoSUCSM, "{0}")
	; AddHeaderOption("$SSL_ExtraEffects")
	AddToggleOptionST("UseExpressions","$SSL_UseExpressions", Config.UseExpressions)
	AddToggleOptionST("UseLipSync", "$SSL_UseLipSync", Config.UseLipSync)
	AddToggleOptionST("OrgasmEffects","$SSL_OrgasmEffects", Config.OrgasmEffects)
	AddToggleOptionST("UseCum","$SSL_ApplyCumEffects", Config.UseCum)
	AddToggleOptionST("AllowFemaleFemaleCum","$SSL_AllowFemaleFemaleCum", Config.AllowFFCum)
	AddSliderOptionST("CumEffectTimer","$SSL_CumEffectTimer", Config.CumTimer, "$SSL_Seconds")
	AddToggleOptionST("RagdollEnd","$SSL_RagdollEnding", Config.RagdollEnd)

	SetCursorPosition(1)
	; AddHeaderOption("$SSL_AnimationHandling")
	AddMenuOptionST("AnimationProfile", "$SSL_AnimationProfile", "Profile #"+Config.AnimProfile)
	AddToggleOptionST("RaceAdjustments","$SSL_RaceAdjustments", Config.RaceAdjustments)
	AddToggleOptionST("AllowCreatures","$SSL_AllowCreatures", Config.AllowCreatures)
	AddToggleOptionST("ScaleActors","$SSL_EvenActorsHeight", Config.ScaleActors)
	AddToggleOptionST("ForeplayStage","$SSL_PreSexForeplay", Config.ForeplayStage)
	AddToggleOptionST("RestrictAggressive","$SSL_RestrictAggressive", Config.RestrictAggressive)
	AddToggleOptionST("UndressAnimation","$SSL_UndressAnimation", Config.UndressAnimation)
	AddToggleOptionST("RedressVictim","$SSL_VictimsRedress", Config.RedressVictim)
	AddToggleOptionST("StraponsFemale","$SSL_FemalesUseStrapons", Config.UseStrapons)
	AddToggleOptionST("NudeSuitMales","$SSL_UseNudeSuitMales", Config.UseMaleNudeSuit)
	AddToggleOptionST("NudeSuitFemales","$SSL_UseNudeSuitFemales", Config.UseFemaleNudeSuit)
	AddTextOptionST("NPCBed","$SSL_NPCsUseBeds", Chances[ClampInt(Config.NPCBed, 0, 2)])
endFunction

state AnimationProfile
	event OnMenuOpenST()
		string[] Profiles = new string[5]
		Profiles[0] = "AnimationProfile_1.json"
		Profiles[1] = "AnimationProfile_2.json"
		Profiles[2] = "AnimationProfile_3.json"
		Profiles[3] = "AnimationProfile_4.json"
		Profiles[4] = "AnimationProfile_5.json"
		SetMenuDialogStartIndex((Config.AnimProfile - 1))
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(Profiles)
	endEvent
	event OnMenuAcceptST(int i)
		i += 1
		; Export/Set/Import profiles
		Config.SwapToProfile(ClampInt(i, 1, 5))
		SetMenuOptionValueST("Profile #"+Config.AnimProfile)
	endEvent
	event OnDefaultST()
		OnMenuAcceptST(1)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAnimationProfile")
	endEvent
endState

state RaceAdjustments
	event OnSelectST()
		Config.RaceAdjustments = !Config.RaceAdjustments
		SetToggleOptionValueST(Config.RaceAdjustments)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoRaceAdjustments")
	endEvent
endState

; ------------------------------------------------------- ;
; --- Player Hotkeys                                  --- ;
; ------------------------------------------------------- ;

function PlayerHotkeys()
	SetCursorFillMode(TOP_TO_BOTTOM)

	AddHeaderOption("$SSL_GlobalHotkeys")
	AddKeyMapOptionST("TargetActor", "$SSL_TargetActor", Config.TargetActor)
	AddKeyMapOptionST("ToggleFreeCamera", "$SSL_ToggleFreeCamera", Config.ToggleFreeCamera)

	AddHeaderOption("$SSL_SceneManipulation")
	AddKeyMapOptionST("RealignActors","$SSL_RealignActors", Config.RealignActors)
	AddKeyMapOptionST("EndAnimation", "$SSL_EndAnimation", Config.EndAnimation)
	AddKeyMapOptionST("AdvanceAnimation", "$SSL_AdvanceAnimationStage", Config.AdvanceAnimation)
	AddKeyMapOptionST("ChangeAnimation", "$SSL_ChangeAnimationSet", Config.ChangeAnimation)
	AddKeyMapOptionST("ChangePositions", "$SSL_SwapActorPositions", Config.ChangePositions)
	AddKeyMapOptionST("MoveSceneLocation", "$SSL_MoveSceneLocation", Config.MoveScene)

	SetCursorPosition(1)
	AddHeaderOption("$SSL_AlignmentAdjustments")
	AddKeyMapOptionST("BackwardsModifier", "$SSL_ReverseDirectionModifier", Config.Backwards)
	AddKeyMapOptionST("AdjustStage","$SSL_AdjustStage", Config.AdjustStage)
	AddKeyMapOptionST("AdjustChange","$SSL_ChangeActorBeingMoved", Config.AdjustChange)
	AddKeyMapOptionST("AdjustForward","$SSL_MoveActorForwardBackward", Config.AdjustForward)
	AddKeyMapOptionST("AdjustUpward","$SSL_AdjustPositionUpwardDownward", Config.AdjustUpward)
	AddKeyMapOptionST("AdjustSideways","$SSL_MoveActorLeftRight", Config.AdjustSideways)
	AddKeyMapOptionST("RotateScene", "$SSL_RotateScene", Config.RotateScene)
	AddKeyMapOptionST("RestoreOffsets","$SSL_DeleteSavedAdjustments", Config.RestoreOffsets)
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
			Config.AdjustStage = newKeyCode
			SetKeyMapOptionValueST(Config.AdjustStage)
		endIf
	endEvent
	event OnDefaultST()
		Config.AdjustStage = 157
		SetKeyMapOptionValueST(Config.AdjustStage)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAdjustStage")
	endEvent
endState
state AdjustChange
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.AdjustChange = newKeyCode
			SetKeyMapOptionValueST(Config.AdjustChange)
		endIf
	endEvent
	event OnDefaultST()
		Config.AdjustChange = 37
		SetKeyMapOptionValueST(Config.AdjustChange)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAdjustChange")
	endEvent
endState
state AdjustForward
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.AdjustForward = newKeyCode
			SetKeyMapOptionValueST(Config.AdjustForward)
		endIf
	endEvent
	event OnDefaultST()
		Config.AdjustForward = 38
		SetKeyMapOptionValueST(Config.AdjustForward)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAdjustForward")
	endEvent
endState
state AdjustUpward
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.AdjustUpward = newKeyCode
			SetKeyMapOptionValueST(Config.AdjustUpward)
		endIf
	endEvent
	event OnDefaultST()
		Config.AdjustUpward = 39
		SetKeyMapOptionValueST(Config.AdjustUpward)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAdjustUpward")
	endEvent
endState
state AdjustSideways
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.AdjustSideways = newKeyCode
			SetKeyMapOptionValueST(Config.AdjustSideways)
		endIf
	endEvent
	event OnDefaultST()
		Config.AdjustSideways = 40
		SetKeyMapOptionValueST(Config.AdjustSideways)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAdjustSideways")
	endEvent
endState
state RotateScene
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.RotateScene = newKeyCode
			SetKeyMapOptionValueST(Config.RotateScene)
		endIf
	endEvent
	event OnDefaultST()
		Config.RotateScene = 22
		SetKeyMapOptionValueST(Config.RotateScene)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoRotateScene")
	endEvent
endState
state RestoreOffsets
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.RestoreOffsets = newKeyCode
			SetKeyMapOptionValueST(Config.RestoreOffsets)
		endIf
	endEvent
	event OnDefaultST()
		Config.RestoreOffsets = 12
		SetKeyMapOptionValueST(Config.RestoreOffsets)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoRestoreOffsets")
	endEvent
endState

state RealignActors
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.RealignActors = newKeyCode
			SetKeyMapOptionValueST(Config.RealignActors)
		endIf
	endEvent
	event OnDefaultST()
		Config.RealignActors = 26
		SetKeyMapOptionValueST(Config.RealignActors)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoRealignActors")
	endEvent
endState
state AdvanceAnimation
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.AdvanceAnimation = newKeyCode
			SetKeyMapOptionValueST(Config.AdvanceAnimation)
		endIf
	endEvent
	event OnDefaultST()
		Config.AdvanceAnimation = 57
		SetKeyMapOptionValueST(Config.AdvanceAnimation)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAdvanceAnimation")
	endEvent
endState
state ChangeAnimation
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.ChangeAnimation = newKeyCode
			SetKeyMapOptionValueST(Config.ChangeAnimation)
		endIf
	endEvent
	event OnDefaultST()
		Config.ChangeAnimation = 24
		SetKeyMapOptionValueST(Config.ChangeAnimation)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoChangeAnimation")
	endEvent
endState
state ChangePositions
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.ChangePositions = newKeyCode
			SetKeyMapOptionValueST(Config.ChangePositions)
		endIf
	endEvent
	event OnDefaultST()
		Config.ChangePositions = 13
		SetKeyMapOptionValueST(Config.ChangePositions)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoChangePositions")
	endEvent
endState
state MoveSceneLocation
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.MoveScene = newKeyCode
			SetKeyMapOptionValueST(Config.MoveScene)
		endIf
	endEvent
	event OnDefaultST()
		Config.MoveScene = 27
		SetKeyMapOptionValueST(Config.MoveScene)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoMoveScene")
	endEvent
endState
state BackwardsModifier
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.Backwards = newKeyCode
			SetKeyMapOptionValueST(Config.Backwards)
		endIf
	endEvent
	event OnDefaultST()
		Config.Backwards = 54
		SetKeyMapOptionValueST(Config.Backwards)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoBackwards")
	endEvent
endState
state EndAnimation
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.EndAnimation = newKeyCode
			SetKeyMapOptionValueST(Config.EndAnimation)
		endIf
	endEvent
	event OnDefaultST()
		Config.EndAnimation = 207
		SetKeyMapOptionValueST(Config.EndAnimation)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoEndAnimation")
	endEvent
endState
state TargetActor
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.UnregisterForKey(Config.TargetActor)
			Config.TargetActor = newKeyCode
			Config.RegisterForKey(Config.TargetActor)
			SetKeyMapOptionValueST(Config.TargetActor)
		endIf
	endEvent
	event OnDefaultST()
		Config.UnregisterForKey(Config.TargetActor)
		Config.TargetActor = 49
		Config.RegisterForKey(Config.TargetActor)
		SetKeyMapOptionValueST(Config.TargetActor)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoTargetActor")
	endEvent
endState
state ToggleFreeCamera
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if !KeyConflict(newKeyCode, conflictControl, conflictName)
			Config.UnregisterForKey(Config.ToggleFreeCamera)
			Config.ToggleFreeCamera = newKeyCode
			Config.RegisterForKey(Config.ToggleFreeCamera)
			SetKeyMapOptionValueST(Config.ToggleFreeCamera)
		endIf
	endEvent
	event OnDefaultST()
		Config.UnregisterForKey(Config.ToggleFreeCamera)
		Config.ToggleFreeCamera = 81
		Config.RegisterForKey(Config.ToggleFreeCamera)
		SetKeyMapOptionValueST(Config.ToggleFreeCamera)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoToggleFreeCamera")
	endEvent
endState

; ------------------------------------------------------- ;
; --- Troubleshoot                                    --- ;
; ------------------------------------------------------- ;

function Troubleshoot()
	AddTextOptionST("AnimationTrouble", "Animations Don't Play", "$SSL_ClickHere")
endFunction

state AnimationTrouble
	event OnSelectST()
		if ShowMessage("To perform this test, you will be transported to a safe location. Once the test has completed you will return to your current location.\n\nClose all menus to continue...", true, "$Yes", "$No")
			Utility.Wait(0.1)
		endIf
	endEvent
endState

; ------------------------------------------------------- ;
; --- Sound Settings                                  --- ;
; ------------------------------------------------------- ;

function SoundSettings()
	SetCursorFillMode(LEFT_TO_RIGHT)

	; Voices & SFX
	AddMenuOptionST("PlayerVoice","$SSL_PCVoice", VoiceSlots.GetSavedName(PlayerRef))
	AddToggleOptionST("NPCSaveVoice","$SSL_NPCSaveVoice", Config.NPCSaveVoice)
	AddMenuOptionST("TargetVoice","$SSL_Target{"+TargetName+"}Voice", VoiceSlots.GetSavedName(TargetRef), TargetFlag)
	AddSliderOptionST("VoiceVolume","$SSL_VoiceVolume", (Config.VoiceVolume * 100), "{0}%")
	AddSliderOptionST("SFXVolume","$SSL_SFXVolume", (Config.SFXVolume * 100), "{0}%")
	AddSliderOptionST("MaleVoiceDelay","$SSL_MaleVoiceDelay", Config.MaleVoiceDelay, "$SSL_Seconds")
	AddSliderOptionST("SFXDelay","$SSL_SFXDelay", Config.SFXDelay, "$SSL_Seconds")
	AddSliderOptionST("FemaleVoiceDelay","$SSL_FemaleVoiceDelay", Config.FemaleVoiceDelay, "$SSL_Seconds")

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
		string[] RaceIDs = ArgString(AdjustKey, ".")
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
		string[] Positions = StringArray(Animation.PositionCount)
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
				Actor[] Positions = MakeActorArray(PlayerRef, TargetRef)
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
	if !Config.UseExpressions
		AddHeaderOption("$SSL_ExpressionsDisabled")
		AddToggleOptionST("UseExpressions","$SSL_UseExpressions", Config.UseExpressions)
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

	if PlayerRef.GetLeveledActorBase().GetSex() == 1
		AddTextOptionST("ExpressionTestPlayer", "$SSL_TestOnPlayer", "$SSL_Apply", FlagF)
	else
		AddTextOptionST("ExpressionTestPlayer", "$SSL_TestOnPlayer", "$SSL_Apply", FlagM)
	endIf

	AddToggleOptionST("ExpressionVictim", "$SSL_ExpressionsVictim", Expression.HasTag("Victim"), FlagF)

	if TargetRef != none
		if TargetRef.GetLeveledActorBase().GetSex() == 1
			AddTextOptionST("ExpressionTestTarget", "$SSL_TestOn{"+TargetName+"}", "$SSL_Apply", FlagF)
		else
			AddTextOptionST("ExpressionTestTarget", "$SSL_TestOn{"+TargetName+"}", "$SSL_Apply", FlagM)
		endIf
	else
		AddTextOptionST("ExpressionTestTarget", "$SSL_TestOn{"+TargetName+"}", "$SSL_Apply", TargetFlag)
	endIf

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
		Utility.WaitMenuMode(15.0)
		PlayerRef.ClearExpressionOverride()
		MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)
		TargetRef.ClearExpressionOverride()
		MfgConsoleFunc.ResetPhonemeModifier(TargetRef)
	endIf
endFunction

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
	SetCursorFillMode(LEFT_TO_RIGHT)
	; Custom stats set by other mods
	int i = Stats.GetNumStats()
	while i
		i -= 1
		AddTextOption(Stats.GetNthStat(i), Stats.GetStatFull(StatRef, Stats.GetNthStat(i)))
	endWhile
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
			Stats.SetInt(StatRef, "Sexuality", 1)
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
		return Config.StageTimerLeadIn
	elseIf ts == 2
		return Config.StageTimerAggr
	else
		return Config.StageTimer
	endIf
endFunction

bool[] function GetStripping(int type)
	if ts == 1
		if type == 1
			return Config.StripLeadInFemale
		else
			return Config.StripLeadInMale
		endIf
	elseIf ts == 2
		if type == 1
			return Config.StripVictim
		else
			return Config.StripAggressor
		endIf
	else
		if type == 1
			return Config.StripFemale
		else
			return Config.StripMale
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

	AddTextOptionST("RestoreDefaultSettings","$SSL_RestoreDefaultSettings", "$SSL_ClickHere")
	AddTextOptionST("StopCurrentAnimations","$SSL_StopCurrentAnimations", "$SSL_ClickHere")
	AddTextOptionST("ResetAnimationRegistry","$SSL_ResetAnimationRegistry", "$SSL_ClickHere")
	AddTextOptionST("ResetVoiceRegistry","$SSL_ResetVoiceRegistry", "$SSL_ClickHere")
	AddTextOptionST("ResetExpressionRegistry","$SSL_ResetExpressionRegistry", "$SSL_ClickHere")
	AddTextOptionST("ExportSettings","$SSL_ExportSettings", "$SSL_ClickHere")
	AddTextOptionST("ImportSettings","$SSL_ImportSettings", "$SSL_ClickHere")
	AddHeaderOption("$SSL_UpgradeUninstallReinstall")
	AddTextOptionST("CleanSystem","$SSL_CleanSystem", "$SSL_ClickHere")

	SetCursorPosition(1)
	AddToggleOptionST("DebugMode","$SSL_DebugMode", Config.DebugMode)
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
	bool DebugMode = Config.DebugMode
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
	Config.DebugMode = DebugMode
	return true
endFunction

event OnConfigOpen()
	; MCM option pages
	Pages     = new string[9]
	Pages[0]  = "$SSL_SexDiary"
	Pages[1]  = "$SSL_AnimationSettings"
	Pages[2]  = "$SSL_SoundSettings"
	Pages[3]  = "$SSL_TimersStripping"
	Pages[4]  = "$SSL_PlayerHotkeys"
	; Pages[4]  = "$SSL_ExpressionSelection"
	Pages[5]  = "$SSL_ExpressionEditor"
	Pages[6]  = "$SSL_ToggleAnimations"
	Pages[7]  = "$SSL_AnimationEditor"
	Pages[8]  = "$SSL_RebuildClean"
	; Pages[9]  = "Troubleshoot"
	if PlayerRef.GetLeveledActorBase().GetSex() == 0
		Pages[0] = "$SSL_SexJournal"
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

	; Animation Settings
	Chances = new string[3]
	Chances[0] = "$SSL_Never"
	Chances[1] = "$SSL_Sometimes"
	Chances[2] = "$SSL_Always"

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
		Config.AutoAdvance = !Config.AutoAdvance
		SetToggleOptionValueST(Config.AutoAdvance)
	endEvent
	event OnDefaultST()
		Config.AutoAdvance = false
		SetToggleOptionValueST(Config.AutoAdvance)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAutoAdvance")
	endEvent
endState
state DisableVictim
	event OnSelectST()
		Config.DisablePlayer = !Config.DisablePlayer
		SetToggleOptionValueST(Config.DisablePlayer)
	endEvent
	event OnDefaultST()
		Config.DisablePlayer = false
		SetToggleOptionValueST(Config.DisablePlayer)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoDisablePlayer")
	endEvent
endState
state AutomaticTFC
	event OnSelectST()
		Config.AutoTFC = !Config.AutoTFC
		SetToggleOptionValueST(Config.AutoTFC)
	endEvent
	event OnDefaultST()
		Config.AutoTFC = false
		SetToggleOptionValueST(Config.AutoTFC)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAutomaticTFC")
	endEvent
endState
state AutomaticSUCSM
	event OnSliderOpenST()
		SetSliderDialogStartValue(Config.AutoSUCSM)
		SetSliderDialogDefaultValue(3)
		SetSliderDialogRange(1, 20)
		SetSliderDialogInterval(1)
	endEvent
	event OnSliderAcceptST(float value)
		Config.AutoSUCSM = value
		SetSliderOptionValueST(Config.AutoSUCSM, "{0}")
	endEvent
	event OnDefaultST()
		Config.AutoSUCSM = 5.0
		SetToggleOptionValueST(Config.AutoSUCSM, "{0}")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAutomaticSUCSM")
	endEvent
endState

state UseExpressions
	event OnSelectST()
		Config.UseExpressions = !Config.UseExpressions
		SetToggleOptionValueST(Config.UseExpressions)
	endEvent
	event OnDefaultST()
		Config.UseExpressions = false
		SetToggleOptionValueST(Config.UseExpressions)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoUseExpressions")
	endEvent
endState
state UseLipSync
	event OnSelectST()
		Config.UseLipSync = !Config.UseLipSync
		SetToggleOptionValueST(Config.UseLipSync)
	endEvent
	event OnDefaultST()
		Config.UseLipSync = false
		SetToggleOptionValueST(Config.UseLipSync)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoUseLipSync")
	endEvent
endState
state RedressVictim
	event OnSelectST()
		Config.RedressVictim = !Config.RedressVictim
		SetToggleOptionValueST(Config.RedressVictim)
	endEvent
	event OnDefaultST()
		Config.RedressVictim = true
		SetToggleOptionValueST(Config.RedressVictim)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoReDressVictim")
	endEvent
endState
state UseCum
	event OnSelectST()
		Config.UseCum = !Config.UseCum
		SetToggleOptionValueST(Config.UseCum)
	endEvent
	event OnDefaultST()
		Config.UseCum = true
		SetToggleOptionValueST(Config.UseCum)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoUseCum")
	endEvent
endState
state AllowFemaleFemaleCum
	event OnSelectST()
		Config.AllowFFCum = !Config.AllowFFCum
		SetToggleOptionValueST(Config.AllowFFCum)
	endEvent
	event OnDefaultST()
		Config.AllowFFCum = false
		SetToggleOptionValueST(Config.AllowFFCum)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAllowFFCum")
	endEvent
endState
state CumEffectTimer
	event OnSliderOpenST()
		SetSliderDialogStartValue(Config.CumTimer)
		SetSliderDialogDefaultValue(120)
		SetSliderDialogRange(5, 900)
		SetSliderDialogInterval(5)
	endEvent
	event OnSliderAcceptST(float value)
		Config.CumTimer = value
		SetSliderOptionValueST(Config.CumTimer, "$SSL_Seconds")
	endEvent
	event OnDefaultST()
		Config.CumTimer = 120.0
		SetToggleOptionValueST(Config.CumTimer, "$SSL_Seconds")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoCumTimer")
	endEvent
endState
state OrgasmEffects
	event OnSelectST()
		Config.OrgasmEffects = !Config.OrgasmEffects
		SetToggleOptionValueST(Config.OrgasmEffects)
	endEvent
	event OnDefaultST()
		Config.OrgasmEffects = true
		SetToggleOptionValueST(Config.OrgasmEffects)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoOrgasmEffects")
	endEvent
endState

state AllowCreatures
	event OnSelectST()
		Config.AllowCreatures = !Config.AllowCreatures
		SetToggleOptionValueST(Config.AllowCreatures)
	endEvent
	event OnDefaultST()
		Config.AllowCreatures = false
		SetToggleOptionValueST(Config.AllowCreatures)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAllowCreatures")
	endEvent
endState
state RagdollEnd
	event OnSelectST()
		Config.RagdollEnd = !Config.RagdollEnd
		SetToggleOptionValueST(Config.RagdollEnd)
	endEvent
	event OnDefaultST()
		Config.RagdollEnd = false
		SetToggleOptionValueST(Config.RagdollEnd)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoRagdollEnd")
	endEvent
endState
state ForeplayStage
	event OnSelectST()
		Config.ForeplayStage = !Config.ForeplayStage
		SetToggleOptionValueST(Config.ForeplayStage)
	endEvent
	event OnDefaultST()
		Config.ForeplayStage = true
		SetToggleOptionValueST(Config.ForeplayStage)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoForeplayStage")
	endEvent
endState
state ScaleActors
	event OnSelectST()
		Config.ScaleActors = !Config.ScaleActors
		SetToggleOptionValueST(Config.ScaleActors)
	endEvent
	event OnDefaultST()
		Config.ScaleActors = true
		SetToggleOptionValueST(Config.ScaleActors)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoScaleActors")
	endEvent
endState
state RestrictAggressive
	event OnSelectST()
		Config.RestrictAggressive = !Config.RestrictAggressive
		SetToggleOptionValueST(Config.RestrictAggressive)
	endEvent
	event OnDefaultST()
		Config.RestrictAggressive = true
		SetToggleOptionValueST(Config.RestrictAggressive)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoRestrictAggressive")
	endEvent
endState
state UndressAnimation
	event OnSelectST()
		Config.UndressAnimation = !Config.UndressAnimation
		SetToggleOptionValueST(Config.UndressAnimation)
	endEvent
	event OnDefaultST()
		Config.UndressAnimation = false
		SetToggleOptionValueST(Config.UndressAnimation)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoUndressAnimation")
	endEvent
endState
state StraponsFemale
	event OnSelectST()
		Config.UseStrapons = !Config.UseStrapons
		SetToggleOptionValueST(Config.UseStrapons)
	endEvent
	event OnDefaultST()
		Config.UseStrapons = true
		SetToggleOptionValueST(Config.UseStrapons)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoUseStrapons")
	endEvent
endState
state NudeSuitMales
	event OnSelectST()
		Config.UseMaleNudeSuit = !Config.UseMaleNudeSuit
		SetToggleOptionValueST(Config.UseMaleNudeSuit)
	endEvent
	event OnDefaultST()
		Config.UseMaleNudeSuit = false
		SetToggleOptionValueST(Config.UseMaleNudeSuit)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoMaleNudeSuit")
	endEvent
endState
state NudeSuitFemales
	event OnSelectST()
		Config.UseFemaleNudeSuit = !Config.UseFemaleNudeSuit
		SetToggleOptionValueST(Config.UseFemaleNudeSuit)
	endEvent
	event OnDefaultST()
		Config.UseFemaleNudeSuit = false
		SetToggleOptionValueST(Config.UseFemaleNudeSuit)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoFemaleNudeSuit")
	endEvent
endState
state NPCBed
	event OnSelectST()
		Config.NPCBed = IndexTravel(Config.NPCBed, 3)
		SetTextOptionValueST(Chances[Config.NPCBed])
	endEvent
	event OnDefaultST()
		Config.NPCBed = 0
		SetTextOptionValueST(Chances[Config.NPCBed])
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoNPCBed")
	endEvent
endState
state PlayerVoice
	event OnMenuOpenST()
		int i = VoiceSlots.Slotted
		string[] VoiceNames = StringArray(i + 1)
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
		string[] VoiceNames = StringArray(i + 1)
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
		Config.NPCSaveVoice = !Config.NPCSaveVoice
		SetToggleOptionValueST(Config.NPCSaveVoice)
	endEvent
	event OnDefaultST()
		Config.NPCSaveVoice = false
		SetToggleOptionValueST(Config.NPCSaveVoice)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoNPCSaveVoice")
	endEvent
endState
state SFXVolume
	event OnSliderOpenST()
		SetSliderDialogStartValue((Config.SFXVolume * 100))
		SetSliderDialogDefaultValue(100)
		SetSliderDialogRange(1, 100)
		SetSliderDialogInterval(1)
	endEvent
	event OnSliderAcceptST(float value)
		Config.SFXVolume = (value / 100.0)
		Config.AudioSFX.SetVolume(Config.SFXVolume)
		SetSliderOptionValueST(value, "{0}%")
	endEvent
	event OnDefaultST()
		Config.SFXVolume = 1.0
		SetSliderOptionValueST(Config.SFXVolume, "{0}%")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoSFXVolume")
	endEvent
endState
state VoiceVolume
	event OnSliderOpenST()
		SetSliderDialogStartValue((Config.VoiceVolume * 100))
		SetSliderDialogDefaultValue(100)
		SetSliderDialogRange(1, 100)
		SetSliderDialogInterval(1)
	endEvent
	event OnSliderAcceptST(float value)
		Config.VoiceVolume = (value / 100.0)
		Config.AudioVoice.SetVolume(Config.VoiceVolume)
		SetSliderOptionValueST(value, "{0}%")
	endEvent
	event OnDefaultST()
		Config.VoiceVolume = 1.0
		SetSliderOptionValueST(Config.VoiceVolume, "{0}%")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoVoiceVolume")
	endEvent
endState
state SFXDelay
	event OnSliderOpenST()
		SetSliderDialogStartValue(Config.SFXDelay)
		SetSliderDialogDefaultValue(3)
		SetSliderDialogRange(1, 30)
		SetSliderDialogInterval(1)
	endEvent
	event OnSliderAcceptST(float value)
		Config.SFXDelay = value
		SetSliderOptionValueST(Config.SFXDelay, "$SSL_Seconds")
	endEvent
	event OnDefaultST()
		Config.SFXDelay = 3.0
		SetSliderOptionValueST(Config.SFXDelay, "$SSL_Seconds")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoSFXDelay")
	endEvent
endState
state MaleVoiceDelay
	event OnSliderOpenST()
		SetSliderDialogStartValue(Config.MaleVoiceDelay)
		SetSliderDialogDefaultValue(5)
		SetSliderDialogRange(1, 45)
		SetSliderDialogInterval(1)
	endEvent
	event OnSliderAcceptST(float value)
		Config.MaleVoiceDelay = value
		SetSliderOptionValueST(Config.MaleVoiceDelay, "$SSL_Seconds")
	endEvent
	event OnDefaultST()
		Config.MaleVoiceDelay = 5.0
		SetSliderOptionValueST(Config.MaleVoiceDelay, "$SSL_Seconds")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoMaleVoiceDelay")
	endEvent
endState
state FemaleVoiceDelay
	event OnSliderOpenST()
		SetSliderDialogStartValue(Config.FemaleVoiceDelay)
		SetSliderDialogDefaultValue(4)
		SetSliderDialogRange(1, 45)
		SetSliderDialogInterval(1)
	endEvent
	event OnSliderAcceptST(float value)
		Config.FemaleVoiceDelay = value
		SetSliderOptionValueST(Config.FemaleVoiceDelay, "$SSL_Seconds")
	endEvent
	event OnDefaultST()
		Config.FemaleVoiceDelay = 4.0
		SetSliderOptionValueST(Config.FemaleVoiceDelay, "$SSL_Seconds")
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
		SetTextOptionValueST("$SSL_Resetting")
		SetOptionFlagsST(OPTION_FLAG_DISABLED)
		ThreadSlots.StopAll()
		AnimSlots.Setup()
		CreatureSlots.Setup()
		ShowMessage("$SSL_RunRebuildAnimations", false)
		Debug.Notification("$SSL_RunRebuildAnimations")
		SetOptionFlagsST(OPTION_FLAG_NONE)
		SetTextOptionValueST("$SSL_ClickHere")
	endEvent
endState
state ResetVoiceRegistry
	event OnSelectST()
		SetTextOptionValueST("$SSL_Resetting")
		SetOptionFlagsST(OPTION_FLAG_DISABLED)
		VoiceSlots.Setup()
		ShowMessage("$SSL_RunRebuildVoices", false)
		Debug.Notification("$SSL_RunRebuildVoices")
		SetOptionFlagsST(OPTION_FLAG_NONE)
		SetTextOptionValueST("$SSL_ClickHere")
	endEvent
endState
state ResetExpressionRegistry
	event OnSelectST()
		SetTextOptionValueST("$SSL_Resetting")
		SetOptionFlagsST(OPTION_FLAG_DISABLED)
		ExpressionSlots.Setup()
		ShowMessage("$SSL_RunRebuildExpressions", false)
		Debug.Notification("$SSL_RunRebuildExpressions")
		SetOptionFlagsST(OPTION_FLAG_NONE)
		SetTextOptionValueST("$SSL_ClickHere")
	endEvent
endState
state DebugMode
	event OnSelectST()
		Config.DebugMode = !Config.DebugMode
		SetToggleOptionValueST(Config.DebugMode)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoDebugMode")
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
			ShowMessage("$SSL_RunExportSettings", false)
		endIf
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoExportSettings")
	endEvent
endState
state ImportSettings
	event OnSelectST()
		if ShowMessage("$SSL_WarnImportSettings")
			ImportSettings()
			ShowMessage("$SSL_RunImportSettings", false)
		endIf
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoImportSettings")
	endEvent
endState


function ExportSettings()
	; Clear any potentially lingering storage data
	debug_DeleteValues(self)
	Utility.WaitMenuMode(0.5)
	; Set label of export
	SetStringValue(self, "ExportLabel", PlayerRef.GetLeveledActorBase().GetName()+" - "+Utility.GetCurrentRealTime() as int)

	; Booleans
	ExportBool("RestrictAggressive", Config.RestrictAggressive)
	ExportBool("AllowCreatures", Config.AllowCreatures)
	ExportBool("NPCSaveVoice", Config.NPCSaveVoice)
	ExportBool("UseStrapons", Config.UseStrapons)
	ExportBool("RedressVictim", Config.RedressVictim)
	ExportBool("RagdollEnd", Config.RagdollEnd)
	ExportBool("UseMaleNudeSuit", Config.UseMaleNudeSuit)
	ExportBool("UseFemaleNudeSuit", Config.UseFemaleNudeSuit)
	ExportBool("UndressAnimation", Config.UndressAnimation)
	ExportBool("UseLipSync", Config.UseLipSync)
	ExportBool("UseExpressions", Config.UseExpressions)
	ExportBool("ScaleActors", Config.ScaleActors)
	ExportBool("UseCum", Config.UseCum)
	ExportBool("AllowFFCum", Config.AllowFFCum)
	ExportBool("DisablePlayer", Config.DisablePlayer)
	ExportBool("AutoTFC", Config.AutoTFC)
	ExportBool("AutoAdvance", Config.AutoAdvance)
	ExportBool("ForeplayStage", Config.ForeplayStage)
	ExportBool("OrgasmEffects", Config.OrgasmEffects)
	ExportBool("RaceAdjustments", Config.RaceAdjustments)

	; Integers
	Config.AnimProfile        = ImportInt("AnimProfile", Config.AnimProfile)
	Config.NPCBed             = ImportInt("NPCBed", Config.NPCBed)

	Config.Backwards          = ImportInt("Backwards", Config.Backwards)
	Config.AdjustStage        = ImportInt("AdjustStage", Config.AdjustStage)
	Config.AdvanceAnimation   = ImportInt("AdvanceAnimation", Config.AdvanceAnimation)
	Config.ChangeAnimation    = ImportInt("ChangeAnimation", Config.ChangeAnimation)
	Config.ChangePositions    = ImportInt("ChangePositions", Config.ChangePositions)
	Config.AdjustChange       = ImportInt("AdjustChange", Config.AdjustChange)
	Config.AdjustForward      = ImportInt("AdjustForward", Config.AdjustForward)
	Config.AdjustSideways     = ImportInt("AdjustSideways", Config.AdjustSideways)
	Config.AdjustUpward       = ImportInt("AdjustUpward", Config.AdjustUpward)
	Config.RealignActors      = ImportInt("RealignActors", Config.RealignActors)
	Config.MoveScene          = ImportInt("MoveScene", Config.MoveScene)
	Config.RestoreOffsets     = ImportInt("RestoreOffsets", Config.RestoreOffsets)
	Config.RotateScene        = ImportInt("RotateScene", Config.RotateScene)
	Config.EndAnimation       = ImportInt("EndAnimation", Config.EndAnimation)
	Config.ToggleFreeCamera   = ImportInt("ToggleFreeCamera", Config.ToggleFreeCamera)
	Config.TargetActor        = ImportInt("TargetActor", Config.TargetActor)

	; Floats
	ExportFloat("CumTimer", Config.CumTimer)
	ExportFloat("AutoSUCSM", Config.AutoSUCSM)
	ExportFloat("MaleVoiceDelay", Config.MaleVoiceDelay)
	ExportFloat("FemaleVoiceDelay", Config.FemaleVoiceDelay)
	ExportFloat("VoiceVolume", Config.VoiceVolume)
	ExportFloat("SFXDelay", Config.SFXDelay)
	ExportFloat("SFXVolume", Config.SFXVolume)

	; Boolean Arrays
	ExportBoolList("StripMale", Config.StripMale, 33)
	ExportBoolList("StripFemale", Config.StripFemale, 33)
	ExportBoolList("StripLeadInFemale", Config.StripLeadInFemale, 33)
	ExportBoolList("StripLeadInMale", Config.StripLeadInMale, 33)
	ExportBoolList("StripVictim", Config.StripVictim, 33)
	ExportBoolList("StripAggressor", Config.StripAggressor, 33)

	; Float Array
	ExportFloatList("StageTimer", Config.StageTimer, 5)
	ExportFloatList("StageTimerLeadIn", Config.StageTimerLeadIn, 5)
	ExportFloatList("StageTimerAggr", Config.StageTimerAggr, 5)

	; Export object registry
	ExportAnimations()
	ExportCreatures()
	ExportExpressions()
	ExportVoices()

	; Save to JSON file
	ExportFile("SexLabConfig.json", restrictForm = self, append = false)
	Utility.WaitMenuMode(0.5)
	; Clear storageutil values from save after export
	debug_DeleteValues(self)
	Utility.WaitMenuMode(0.5)
endFunction

function ImportSettings()
	; Clear any potentially lingering storage data
	debug_DeleteValues(self)
	; Load JSON file
	Utility.WaitMenuMode(0.5)
	ImportFile("SexLabConfig.json")
	Utility.WaitMenuMode(0.5)

	; Booleans
	Config.RestrictAggressive = ImportBool("RestrictAggressive", Config.RestrictAggressive)
	Config.AllowCreatures     = ImportBool("AllowCreatures", Config.AllowCreatures)
	Config.NPCSaveVoice       = ImportBool("NPCSaveVoice", Config.NPCSaveVoice)
	Config.UseStrapons        = ImportBool("UseStrapons", Config.UseStrapons)
	Config.RedressVictim      = ImportBool("RedressVictim", Config.RedressVictim)
	Config.RagdollEnd         = ImportBool("RagdollEnd", Config.RagdollEnd)
	Config.UseMaleNudeSuit    = ImportBool("UseMaleNudeSuit", Config.UseMaleNudeSuit)
	Config.UseFemaleNudeSuit  = ImportBool("UseFemaleNudeSuit", Config.UseFemaleNudeSuit)
	Config.UndressAnimation   = ImportBool("UndressAnimation", Config.UndressAnimation)
	Config.UseLipSync         = ImportBool("UseLipSync", Config.UseLipSync)
	Config.UseExpressions     = ImportBool("UseExpressions", Config.UseExpressions)
	Config.ScaleActors        = ImportBool("ScaleActors", Config.ScaleActors)
	Config.UseCum             = ImportBool("UseCum", Config.UseCum)
	Config.AllowFFCum         = ImportBool("AllowFFCum", Config.AllowFFCum)
	Config.DisablePlayer      = ImportBool("DisablePlayer", Config.DisablePlayer)
	Config.AutoTFC            = ImportBool("AutoTFC", Config.AutoTFC)
	Config.AutoAdvance        = ImportBool("AutoAdvance", Config.AutoAdvance)
	Config.ForeplayStage      = ImportBool("ForeplayStage", Config.ForeplayStage)
	Config.OrgasmEffects      = ImportBool("OrgasmEffects", Config.OrgasmEffects)
	Config.RaceAdjustments    = ImportBool("RaceAdjustments", Config.RaceAdjustments)

	; Integers
	Config.SwapToProfile(GetIntValue(self, "AnimProfile", Config.AnimProfile))
	Config.NPCBed             = ImportInt("NPCBed", Config.NPCBed)

	Config.Backwards          = ImportInt("Backwards", Config.Backwards)
	Config.AdjustStage        = ImportInt("AdjustStage", Config.AdjustStage)
	Config.AdvanceAnimation   = ImportInt("AdvanceAnimation", Config.AdvanceAnimation)
	Config.ChangeAnimation    = ImportInt("ChangeAnimation", Config.ChangeAnimation)
	Config.ChangePositions    = ImportInt("ChangePositions", Config.ChangePositions)
	Config.AdjustChange       = ImportInt("AdjustChange", Config.AdjustChange)
	Config.AdjustForward      = ImportInt("AdjustForward", Config.AdjustForward)
	Config.AdjustSideways     = ImportInt("AdjustSideways", Config.AdjustSideways)
	Config.AdjustUpward       = ImportInt("AdjustUpward", Config.AdjustUpward)
	Config.RealignActors      = ImportInt("RealignActors", Config.RealignActors)
	Config.MoveScene          = ImportInt("MoveScene", Config.MoveScene)
	Config.RestoreOffsets     = ImportInt("RestoreOffsets", Config.RestoreOffsets)
	Config.RotateScene        = ImportInt("RotateScene", Config.RotateScene)
	Config.EndAnimation       = ImportInt("EndAnimation", Config.EndAnimation)
	Config.ToggleFreeCamera   = ImportInt("ToggleFreeCamera", Config.ToggleFreeCamera)
	Config.TargetActor        = ImportInt("TargetActor", Config.TargetActor)

	; Floats
	Config.CumTimer           = ImportFloat("CumTimer", Config.CumTimer)
	Config.AutoSUCSM          = ImportFloat("AutoSUCSM", Config.AutoSUCSM)
	Config.MaleVoiceDelay     = ImportFloat("MaleVoiceDelay", Config.MaleVoiceDelay)
	Config.FemaleVoiceDelay   = ImportFloat("FemaleVoiceDelay", Config.FemaleVoiceDelay)
	Config.VoiceVolume        = ImportFloat("VoiceVolume", Config.VoiceVolume)
	Config.SFXDelay           = ImportFloat("SFXDelay", Config.SFXDelay)
	Config.SFXVolume          = ImportFloat("SFXVolume", Config.SFXVolume)

	; Boolean Arrays
	Config.StripMale          = ImportBoolList("StripMale", Config.StripMale, 33)
	Config.StripFemale        = ImportBoolList("StripFemale", Config.StripFemale, 33)
	Config.StripLeadInFemale  = ImportBoolList("StripLeadInFemale", Config.StripLeadInFemale, 33)
	Config.StripLeadInMale    = ImportBoolList("StripLeadInMale", Config.StripLeadInMale, 33)
	Config.StripVictim        = ImportBoolList("StripVictim", Config.StripVictim, 33)
	Config.StripAggressor     = ImportBoolList("StripAggressor", Config.StripAggressor, 33)

	; Float Array
	Config.StageTimer         = ImportFloatList("StageTimer", Config.StageTimer, 5)
	Config.StageTimerLeadIn   = ImportFloatList("StageTimerLeadIn", Config.StageTimerLeadIn, 5)
	Config.StageTimerAggr     = ImportFloatList("StageTimerAggr", Config.StageTimerAggr, 5)

	; Export object registry
	ImportAnimations()
	ImportCreatures()
	ImportExpressions()
	ImportVoices()

	; Clear storageutil values from save after import
	debug_DeleteValues(self)

	; Reload settings with imported values
	Config.Reload()
endFunction

; Floats
function ExportFloat(string Name, float Value)
	SetFloatValue(self, Name, Value)
endFunction
float function ImportFloat(string Name, float Value)
	Value = GetFloatValue(self, Name, Value)
	return Value
endFunction

; Integers
function ExportInt(string Name, int Value)
	SetIntValue(self, Name, Value)
endFunction
int function ImportInt(string Name, int Value)
	Value = GetIntValue(self, Name, Value)
	return Value
endFunction

; Booleans
function ExportBool(string Name, bool Value)
	SetIntValue(self, Name, Value as int)
endFunction
bool function ImportBool(string Name, bool Value)
	Value = GetIntValue(self, Name, Value as int) as bool
	return Value
endFunction

; Float Arrays
function ExportFloatList(string Name, float[] Values, int len)
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
	return Values
endFunction

; Boolean Arrays
function ExportBoolList(string Name, bool[] Values, int len)
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
	return Values
endFunction

; Animations
function ExportAnimations()
	int i = AnimSlots.Slotted
	sslBaseAnimation[] Anims = AnimSlots.Animations
	while i
		i -= 1
		StringListAdd(self, "Animations", MakeArgs(",", Anims[i].Registry, Anims[i].Enabled as int, Anims[i].HasTag("Foreplay") as int, Anims[i].HasTag("Aggressive") as int))
	endWhile
endfunction

function ImportAnimations()
	int i = StringListCount(self, "Animations")
	while i
		i -= 1
		; Registrar, Enabled, Foreplay, Aggressive
		string[] args = ArgString(StringListGet(self, "Animations", i))
		if args.Length == 4 && AnimSlots.FindByRegistrar(args[0]) != -1
			sslBaseAnimation Slot = AnimSlots.GetbyRegistrar(args[0])
			Slot.Enabled = (args[1] as int) as bool
			Slot.AddTagConditional("Foreplay", (args[2] as int) as bool)
			Slot.AddTagConditional("Aggressive", (args[3] as int) as bool)
		endIf
	endWhile
endFunction

; Creatures
function ExportCreatures()
	int i = CreatureSlots.Slotted
	sslBaseAnimation[] Anims = CreatureSlots.Animations
	while i
		i -= 1
		StringListAdd(self, "Creatures", MakeArgs(",", Anims[i].Registry, Anims[i].Enabled as int))
	endWhile
endFunction

function ImportCreatures()
	int i = StringListCount(self, "Creatures")
	while i
		i -= 1
		; Registrar, Enabled
		string[] args = ArgString(StringListGet(self, "Creatures", i))
		if args.Length == 2 && CreatureSlots.FindByRegistrar(args[0]) != -1
			CreatureSlots.GetbyRegistrar(args[0]).Enabled = (args[1] as int) as bool
		endIf
	endWhile
endFunction

; Expressions
function ExportExpressions()
	int i = ExpressionSlots.Slotted
	sslBaseExpression[] Exprs = ExpressionSlots.Expressions
	while i
		i -= 1
		StringListAdd(self, "Expressions", MakeArgs(",", Exprs[i].Registry, Exprs[i].HasTag("Consensual") as int, Exprs[i].HasTag("Victim") as int, Exprs[i].HasTag("Aggressor") as int))
	endWhile
endfunction

function ImportExpressions()
	int i = StringListCount(self, "Expressions")
	while i
		i -= 1
		; Registrar, Concensual, Victim, Aggressor
		string[] args = ArgString(StringListGet(self, "Expressions", i))
		if args.Length == 4 && ExpressionSlots.FindByRegistrar(args[0]) != -1
			sslBaseExpression Slot = ExpressionSlots.GetbyRegistrar(args[0])
			Slot.AddTagConditional("Consensual", (args[1] as int) as bool)
			Slot.AddTagConditional("Victim", (args[2] as int) as bool)
			Slot.AddTagConditional("Aggressor", (args[3] as int) as bool)
		endIf
	endWhile
endFunction

; Voices
function ExportVoices()
	int i = VoiceSlots.Slotted
	sslBaseVoice[] Voices = VoiceSlots.Voices
	while i
		i -= 1
		StringListAdd(self, "Voices", MakeArgs(",", Voices[i].Registry, Voices[i].Enabled as int))
	endWhile
	; Player voice
	SetStringValue(self, "PlayerVoice", VoiceSlots.GetSavedName(PlayerRef))
endfunction

function ImportVoices()
	int i = StringListCount(self, "Voices")
	while i
		i -= 1
		; Registrar, Enabled
		string[] args = ArgString(StringListGet(self, "Voices", i))
		if args.Length == 2 && VoiceSlots.FindByRegistrar(args[0]) != -1
			VoiceSlots.GetbyRegistrar(args[0]).Enabled = (args[1] as int) as bool
		endIf
	endWhile
	; Player voice
	VoiceSlots.ForgetVoice(PlayerRef)
	VoiceSlots.SaveVoice(PlayerRef, VoiceSlots.GetByName(GetStringValue(self, "PlayerVoice", "$SSL_Random")))
endFunction



function DEPRECATED()
	string log = "SexLab DEPRECATED -- sslConfigMenu.psc -- Use of this property has been deprecated, the mod that called this function should be updated as soon as possible. If you are not the author of this mod, notify them of this error if possible."
	Debug.TraceStack(log, 1)
	if (Game.GetFormFromFile(0xD62, "SexLab.esm") as sslSystemConfig).DebugMode
		MiscUtil.PrintConsole(log)
	endIf
endFunction
sslAnimationLibrary property AnimLib hidden
	sslAnimationLibrary function get()
		DEPRECATED()
		return (Game.GetFormFromFile(0xD62, "SexLab.esm") as SexLabFramework).AnimLib
	endFunction
endProperty
sslVoiceLibrary property VoiceLib hidden
	sslVoiceLibrary function get()
		DEPRECATED()
		return (Game.GetFormFromFile(0xD62, "SexLab.esm") as SexLabFramework).VoiceLib
	endFunction
endProperty
sslExpressionLibrary property ExpressionLib hidden
	sslExpressionLibrary function get()
		DEPRECATED()
		return (Game.GetFormFromFile(0xD62, "SexLab.esm") as SexLabFramework).ExpressionLib
	endFunction
endProperty
