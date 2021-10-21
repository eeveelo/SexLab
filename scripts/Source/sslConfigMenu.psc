scriptname sslConfigMenu extends SKI_ConfigBase
{Skyrim SexLab Mod Configuration Menu}

import PapyrusUtil
import SexLabUtil

; Framework
Actor property PlayerRef auto
SexLabFramework property SexLab auto
sslSystemConfig property Config auto
sslSystemAlias property SystemAlias auto

; Function libraries
sslActorLibrary ActorLib
sslThreadLibrary ThreadLib
sslActorStats Stats

; Object registries
sslThreadSlots ThreadSlots
sslAnimationSlots AnimSlots
sslCreatureAnimationSlots CreatureSlots
sslVoiceSlots VoiceSlots
sslExpressionSlots ExpressionSlots

; Common Data
Actor TargetRef
int TargetFlag
string TargetName
string PlayerName

; ------------------------------------------------------- ;
; --- Configuration Events                            --- ;
; ------------------------------------------------------- ;

; Proxy to SexLabUtil.psc so modders don't have to add dependency to this script, and thus SkyUI SDK
int function GetVersion()
	return SexLabUtil.GetVersion()
endFunction
string function GetStringVer()
	return SexLabUtil.GetStringVer()
endFunction

event OnVersionUpdate(int version)
	LoadLibs(false)
	if CurrentVersion > 0 && CurrentVersion < 15920
		ResetAllQuests()
		LoadLibs(true)
		SystemAlias.SetupSystem()
	; elseIf CurrentVersion == 0 && Config.DebugMode
	; 	LoadLibs(true)
	; 	SystemAlias.SetupSystem()
	endIf
endEvent

event OnGameReload()
	Debug.Trace("SexLab MCM Loaded CurrentVerison: "+CurrentVersion+" / "+SexLabUtil.GetVersion())
	MiscUtil.PrintConsole("SexLab MCM Loaded CurrentVerison: "+CurrentVersion+" / "+SexLabUtil.GetVersion())
	RegisterForModEvent("SKICP_pageSelected", "OnPageSelected")
	parent.OnGameReload()
endEvent

function LoadLibs(bool Forced = false)
	; Sync function Libraries - SexLabQuestFramework
	if Forced || !SexLab || !Config || !ThreadLib || !ThreadSlots || !ActorLib || !Stats || !SystemAlias
		Form SexLabQuestFramework  = Game.GetFormFromFile(0xD62, "SexLab.esm")
		if SexLabQuestFramework
			SexLab      = SexLabQuestFramework as SexLabFramework
			Config      = SexLabQuestFramework as sslSystemConfig
			ThreadLib   = SexLabQuestFramework as sslThreadLibrary
			ThreadSlots = SexLabQuestFramework as sslThreadSlots
			ActorLib    = SexLabQuestFramework as sslActorLibrary
			Stats       = SexLabQuestFramework as sslActorStats
			SystemAlias = SexLab.GetNthAlias(0) as sslSystemAlias
		endIf
	endIf
	; Sync animation registry - SexLabQuestAnimations
	if Forced || !AnimSlots
		Form SexLabQuestAnimations = Game.GetFormFromFile(0x639DF, "SexLab.esm")
		if SexLabQuestAnimations
			AnimSlots = SexLabQuestAnimations as sslAnimationSlots
		endIf
	endIf
	; Sync secondary object registry - SexLabQuestRegistry
	if Forced || !CreatureSlots || !VoiceSlots || !ExpressionSlots
		Form SexLabQuestRegistry   = Game.GetFormFromFile(0x664FB, "SexLab.esm")
		if SexLabQuestRegistry
			CreatureSlots   = SexLabQuestRegistry as sslCreatureAnimationSlots
			ExpressionSlots = SexLabQuestRegistry as sslExpressionSlots
			VoiceSlots      = SexLabQuestRegistry as sslVoiceSlots
		endIf
	endIf
	; Sync data
	if Forced || !PlayerRef
		PlayerRef = Game.GetPlayer()
	endIf
endFunction

; ------------------------------------------------------- ;
; --- Create MCM Pages                                --- ;
; ------------------------------------------------------- ;

event OnPageReset(string page)
	; Manual install pending
	if !SystemAlias.IsInstalled
		UnloadCustomContent()
		InstallMenu()

	; Animation Editor
	elseIf ShowAnimationEditor
		AnimationEditor()

	; Logo Splash
	elseif page != ""
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

		elseIf page == "$SSL_StripEditor"
			StripEditor()

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
		; elseIf page == "Troubleshoot"
		; 	Troubleshoot()

		; System rebuild & clean
		elseIf page == "$SSL_RebuildClean"
			RebuildClean()

		endIf
	else
		if PlayerRef.IsInFaction(Config.AnimatingFaction) && (Config.GetThreadControlled() != none || ThreadSlots.FindActorController(PlayerRef) != -1)
			UnloadCustomContent()
			AnimationEditor()
			PreventOverwrite = true
		else
			LoadCustomContent("SexLab/logo.dds", 184, 31)
		endIf
	endIf

endEvent

bool ShowAnimationEditor = false
event OnPageSelected(String a_eventName, String a_strArg, Float a_numArg, Form a_sender)
	if ShowAnimationEditor && (a_numArg as int) != Pages.Find("$SSL_ToggleAnimations")
		Log("Page:"+ a_numArg+" ToggleAnimationsPages:"+Pages.Find("$SSL_ToggleAnimations"),"OnPageSelected")
		ShowAnimationEditor = false
	elseIf EditOpenMouth && (a_numArg as int) != Pages.Find("$SSL_ExpressionEditor")
		EditOpenMouth = false
	endIf
endEvent

; ------------------------------------------------------- ;
; --- Config Setup                                    --- ;
; ------------------------------------------------------- ;

event OnConfigOpen()
	; Make sure we have all the needed libraries
	LoadLibs()
	
	; MCM option pages
	if !SystemAlias.IsInstalled
		Pages     = new string[1]
		Pages[0]  = "Install"
	else
		Pages     = new string[10]
		Pages[0]  = "$SSL_SexDiary"
		Pages[1]  = "$SSL_AnimationSettings"
		Pages[2]  = "$SSL_SoundSettings"
		Pages[3]  = "$SSL_PlayerHotkeys"
		Pages[4]  = "$SSL_TimersStripping"
		Pages[5]  = "$SSL_ToggleAnimations"
		Pages[6]  = "$SSL_AnimationEditor"
		Pages[7]  = "$SSL_ExpressionEditor"
		Pages[8]  = "$SSL_StripEditor"
		Pages[9]  = "$SSL_RebuildClean"
		; Pages[]  = "Troubleshoot"
		if PlayerRef.GetLeveledActorBase().GetSex() == 0
			Pages[0] = "$SSL_SexJournal"
		endIf
	endIf

	; Basic player info
	PlayerName = PlayerRef.GetLeveledActorBase().GetName()

	; Target actor
	TargetRef = Config.TargetRef
	EmptyStatToggle = false
	if TargetRef && TargetRef.Is3DLoaded()
		TargetName = TargetRef.GetLeveledActorBase().GetName()
		TargetFlag = OPTION_FLAG_NONE
	else
		TargetRef = none
		TargetName = "$SSL_NoTarget"
		TargetFlag = OPTION_FLAG_DISABLED
		Config.TargetRef = none
	endIf
	if TargetRef
		StatRef = TargetRef
	else
		StatRef = PlayerRef
	endIf

	; Reset animation editor auto selector
	PreventOverwrite = false

	; All paged menus need this
	PerPage = 125

	; AnimationEditor
	AnimEditPage = 1

	; ToggleAnimations
	TogglePage = 1
	ta = 0
	EditTags = false
	TagFilter = ""
	TagMode = ""

	; Stripping/Timers toggles
	ts = 0

	if StageTimer.Length != 5
		StageTimer = new float[5]
		StageTimer[0] = 30.0
		StageTimer[1] = 20.0
		StageTimer[2] = 15.0
		StageTimer[3] = 15.0
		StageTimer[4] = 9.0
	endIf
	if StageTimerLeadIn.Length != 5
		StageTimerLeadIn = new float[5]
		StageTimerLeadIn[0] = 10.0
		StageTimerLeadIn[1] = 10.0
		StageTimerLeadIn[2] = 10.0
		StageTimerLeadIn[3] = 8.0
		StageTimerLeadIn[4] = 8.0
	endIf
	if StageTimerAggr.Length != 5
		StageTimerAggr = new float[5]
		StageTimerAggr[0] = 20.0
		StageTimerAggr[1] = 15.0
		StageTimerAggr[2] = 10.0
		StageTimerAggr[3] = 10.0
		StageTimerAggr[4] = 4.0
	endIf
	
	; Animation Settings
	if Chances.Length != 3 || Chances.Find("") != -1
		Chances = new string[3]
		Chances[0] = "$SSL_Never"
		Chances[1] = "$SSL_Sometimes"
		Chances[2] = "$SSL_Always"
	endIf
	if BedOpt.Length != 3 || BedOpt.Find("") != -1
		BedOpt = new string[3]
		BedOpt[0] = "$SSL_Never"
		BedOpt[1] = "$SSL_Always"
		BedOpt[2] = "$SSL_NotVictim"
	endIf
	if FadeOpt.Length != 5 || FadeOpt.Find("") != -1
		FadeOpt = new string[5]
		FadeOpt[0] = "$SSL_Never"
		FadeOpt[1] = "$SSL_UseBlack"
		FadeOpt[2] = "$SSL_UseBlur"
		FadeOpt[3] = "$SSL_SolidBlack"
		FadeOpt[4] = "$SSL_SolidWhite"
	endIf

	; Expression Editor
	if Phases.Length != 5 || Phases.Find("") != -1
		Phases = new string[5]
		Phases[0] = "Phase 1"
		Phases[1] = "Phase 2"
		Phases[2] = "Phase 3"
		Phases[3] = "Phase 4"
		Phases[4] = "Phase 5"
	endIf

	if Moods.Length != 17 || Moods.Find("") != -1
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
	endIf

	if Phonemes.Length != 16 || Phonemes.Find("") != -1
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
	endIf

	if Modifiers.Length != 14 || Modifiers.Find("") != -1
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
	endIf

	if SoundTreatment.Length != 3 || SoundTreatment.Find("") != -1
		SoundTreatment = new string[3]
		SoundTreatment[0] = "$SSL_WaitToEnd"
		SoundTreatment[1] = "$SSL_KeepPlaying"
		SoundTreatment[2] = "$SSL_CutOnTime"
	endIf

	; Timers & Stripping
	if TSModes.Length != 3 || TSModes.Find("") != -1
		TSModes = new string[3]
		TSModes[0] = "$SSL_NormalTimersStripping"
		TSModes[1] = "$SSL_ForeplayTimersStripping"
		TSModes[2] = "$SSL_AggressiveTimersStripping"
	endIf

	; Biped item slots (i + 30)
	if Biped.Length != 33 || Biped.Find("") != -1
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
	endIf

	; Strip Editor
	; ShowFullInventory = false
	; Items = GetItems(PlayerRef)
	FullInventoryPlayer = false
	FullInventoryTarget = false
endEvent

event OnConfigClose()
	ModEvent.Send(ModEvent.Create("SexLabConfigClose"))
	; Reset animation editor auto selector
	PreventOverwrite = false
	; Clear Player Partners array
	if PlayerPartners
		PlayerPartners = PapyrusUtil.ActorArray(0)
	endIf
	; Realign actors if an adjustment in editor was just made
	if AutoRealign
		AutoRealign = false
		sslThreadController Thread = Config.GetThreadControlled()
		if !Thread
			Thread = ThreadSlots.GetActorController(PlayerRef)
		endIf
		if Thread
			ModEvent.Send(ModEvent.Create(Thread.Key("RealignActors"))) ; Instead the function because don't allow reopen the Config until the all Menu be fully closed
		endIf
	endIf
endEvent

; ------------------------------------------------------- ;
; --- Object Pagination                               --- ;
; ------------------------------------------------------- ;

; All paged menus need
int PerPage
int LastPage

string[] function PaginationMenu(string BeforePages = "", string AfterPages = "", int CurrentPage)
	string[] Output
	if BeforePages != ""
		Output = PapyrusUtil.PushString(Output, BeforePages)
	endIf
	if CurrentPage < LastPage
		Output = PapyrusUtil.PushString(Output, "$SSL_NextPage")
	endIf
	if CurrentPage > 1
		Output = PapyrusUtil.PushString(Output, "$SSL_PrevPage")
	endIf
	if AfterPages != ""
		Output = PapyrusUtil.PushString(Output, AfterPages)
	endIf
	return Output
endfunction

; ------------------------------------------------------- ;
; --- Mapped State Option Events                      --- ;
; ------------------------------------------------------- ;

string[] function MapOptions()
	return StringSplit(GetState(), "_")
endFunction

event OnHighlightST()
	string[] Options = MapOptions()
	; Animation Toggle
	if Options[0] == "Animation"
		sslBaseAnimation Slot = AnimToggles[(Options[1] as int)]
		if Config.MirrorPress(Config.AdjustStage)
			SetInfoText("$SSL_AnimationEditor") ;ToDo
		else
			SetInfoText(Slot.Name+" Tags:\n"+StringJoin(Slot.GetTags(), ", "))
		endIf
	; Restrict Strapons
	elseIf Options[0] == "RestrictStrapons"
		SetInfoText("$SSL_InfoRestrictStrapons")

	; Fix Victim Position
	elseIf Options[0] == "FixVictimPos"
		SetInfoText("$SSL_InfoFixVictimPos")

	; Voice Toggle
	elseIf Options[0] == "Voice"
		sslBaseVoice Slot = VoiceSlots.GetBySlot(Options[1] as int)
		SetInfoText(Slot.Name+" Tags:\n"+StringJoin(Slot.GetTags(), ", "))

	; Timers & Stripping - Stripping
	elseIf Options[0] == "Stripping"
		if Options[2] as int < 32
			string InfoText = PlayerRef.GetLeveledActorBase().GetName()+" Slot "+((Options[2] as int) + 30)+": "
			InfoText += GetItemName(PlayerRef.GetWornForm(Armor.GetMaskForSlot((Options[2] as int) + 30)), "?")
			if TargetRef
				InfoText += "\n"+TargetRef.GetLeveledActorBase().GetName()+" Slot "+((Options[2] as int) + 30)+": "
				InfoText += GetItemName(TargetRef.GetWornForm(Armor.GetMaskForSlot((Options[2] as int) + 30)), "?")
			endIf
			SetInfoText(InfoText)
		else
			SetInfoText("")
		endIf

	; Strip Editor
	elseIf Options[0] == "StripEditor"
		Form ItemRef
		if (Options[1] as int) == 0
			ItemRef = ItemsPlayer[(Options[2] as int)]
		else
			ItemRef = ItemsTarget[(Options[2] as int)]
		endIf
		string InfoText = GetItemName(ItemRef, "?")
		Armor ArmorRef = ItemRef as Armor
		if ArmorRef
			int[] SlotMasks = GetAllMaskSlots(ArmorRef.GetSlotMask())
			if SlotMasks && ArmorRef
				InfoText += "\nArmor Slots: "+SlotMasks
			endIf
		else
			InfoText += "\nWeapon"
		endIf
		SetInfoText(InfoText)

	; Strip Editor
	elseIf Options[0] == "StripEditorPossibility"
		Form ItemRef
		if (Options[1] as int) == 0
			ItemRef = ItemsPlayer[(Options[2] as int)]
		else
			ItemRef = ItemsTarget[(Options[2] as int)]
		endIf
		string InfoText = GetItemName(ItemRef, "?")
		Armor ArmorRef = ItemRef as Armor
		if ArmorRef
			int[] SlotMasks = GetAllMaskSlots(ArmorRef.GetSlotMask())
			if SlotMasks && ArmorRef
				InfoText += "\nArmor Slots: "+SlotMasks
			endIf
		else
			InfoText += "\nWeapon"
		endIf
		SetInfoText(InfoText)

	; Advanced OpenMouth Expression
	elseIf Options[0] == "AdvancedOpenMouth"
		SetInfoText("$SSL_InfoAdvancedOpenMouth")

	; Alt OpenMouth Expression
	elseIf Options[0] == "OpenMouthExpression"
		SetInfoText("$SSL_InfoOpenMouthExpression")

	elseIf Options[0] == "LipsPhoneme"
		SetInfoText("$SSL_InfoLipsPhoneme")

	elseIf Options[0] == "LipsFixedValue"
		SetInfoText("$SSL_InfoLipsFixedValue")

	elseIf Options[0] == "LipsMinValue"
		SetInfoText("$SSL_InfoLipsMinValue")

	elseIf Options[0] == "LipsMaxValue"
		SetInfoText("$SSL_InfoLipsMaxValue")

	elseIf Options[0] == "LipsMoveTime"
		SetInfoText("$SSL_InfoLipsMoveTime")

	elseIf Options[0] == "LipsSoundTime"
		SetInfoText("$SSL_InfoLipsSoundTime")

	; Clean CACHE
	elseIf Options[0] == "CleanCACHE"
		SetInfoText("$SSL_InfoCleanCACHE")

	; Error & Warning
	elseIf Options[0] == "InstallError"
		SetInfoText("CRITICAL ERROR: File Integrity Framework quest / files overwritten...\nUnable to resolve needed variables. Install unable continue as result.\nUsually caused by incompatible SexLab addons. Disable other SexLab addons (NOT SexLab.esm) one by one and trying again until this message goes away. Alternatively, with TES5Edit after the background loader finishes check for any mods overriding SexLab.esm's Quest records. ScocLB.esm & SexlabScocLB.esp are the most common cause of this problem.\nIf using Mod Organizer, check that no mods are overwriting any of SexLab Frameworks files. There should be no red - symbol under flags for your SexLab Framework install in Mod Organizer.")

	elseIf Options[0] == "FNISWarning"
		SetInfoText("Important FNIS Check:\nIf you're getting a '?' on any checks try scrolling in and out of 3rd person mode then checking again while still in 3rd. These '?' are just soft warnings and can usually be ignored safely.\nIf scrolling in and out doesn't work and characters stand frozen in place during animation than these are the most likely causes. Fix your FNIS install.")
	endIf
endEvent

event OnSliderOpenST()
	string[] Options = MapOptions()

	; Animation Editor
	if Options[0] == "Adjust"
		; Stage, Slot
		if Options[2] == "3" ; SOS
			SetSliderDialogStartValue(Animation.GetSchlong(AdjustKey, Position, Options[1] as int))
			SetSliderDialogRange(-9, 9)
			SetSliderDialogInterval(1)
			SetSliderDialogDefaultValue(Animation.GetSchlong("Global", Position, Options[1] as int))
		else ; Alignments
			SetSliderDialogStartValue(Animation.GetAdjustment(AdjustKey, Position, Options[1] as int, Options[2] as int))
			SetSliderDialogRange(-100.0, 100.0)
			SetSliderDialogInterval(0.50)
			SetSliderDialogDefaultValue(Animation.GetAdjustment("Global", Position, Options[1] as int, Options[2] as int))
		endIf
	; Animation Editor (Animation Offsets)
	elseIf Options[0] == "AnimationOffset"
		AnimOffsets = Animation.GetBedOffsets()
		SetSliderDialogStartValue(AnimOffsets[Options[2] as int])
		if Options[2] == "3" ; Rotation
			SetSliderDialogRange(0, 360)
			SetSliderDialogInterval(15)
		else
			SetSliderDialogRange(-100.0, 100.0)
			SetSliderDialogInterval(0.50)
		endIf
		SetSliderDialogDefaultValue(0.0)

	; Expression OpenMouth Editor
	elseIf Options[0] == "OpenMouth"
		; Gender, ID
		SetSliderDialogStartValue(Config.GetOpenMouthPhonemes(Options[1] == "1")[Options[2] as int] * 100)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
		if Options[2] == "1"
			if Options[1] == "1"
				SetSliderDialogDefaultValue(100)
			else
				SetSliderDialogDefaultValue(80)
			endIf
		else
			SetSliderDialogDefaultValue(0)
		endIf

	elseIf Options[0] == "LipsMinValue"
		SetSliderDialogStartValue(Config.LipsMinValue)
		SetSliderDialogRange(0, 90)
		SetSliderDialogInterval(5)
		SetSliderDialogDefaultValue(20)

	elseIf Options[0] == "LipsMaxValue"
		SetSliderDialogStartValue(Config.LipsMaxValue)
		SetSliderDialogRange(10, 100)
		SetSliderDialogInterval(5)
		SetSliderDialogDefaultValue(50)

	elseIf Options[0] == "LipsMoveTime"
		SetSliderDialogStartValue(Config.LipsMoveTime)
		SetSliderDialogRange(0.2, 3.8)
		SetSliderDialogInterval(0.4)
		SetSliderDialogDefaultValue(0.2)

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
		SetSliderDialogDefaultValue(GetTimersDef()[(Options[2] as int)])

	; Strip Editor
	elseIf Options[0] == "StripEditorPossibility"
		Form ItemRef
		if (Options[1] as int) == 0
			ItemRef = ItemsPlayer[(Options[2] as int)]
		else
			ItemRef = ItemsTarget[(Options[2] as int)]
		endIf

		SetSliderDialogStartValue(StorageUtil.GetIntValue(ItemRef, "SometimesStrip", 100))
		SetSliderDialogRange(1, 100)
		SetSliderDialogInterval(1)
		SetSliderDialogDefaultValue(100)
	endIf

endEvent

event OnSliderAcceptST(float value)
	string[] Options = MapOptions()

	; Animation Editor
	if Options[0] == "Adjust"
		; Stage, Slot
		if Config.MirrorPress(Config.AdjustStage) && ShowMessage("$SSL_WarnApplyAllStages", true, "$Yes", "$No")
			int Stage = 1
			while Stage <= Animation.StageCount
				Animation.SetAdjustment(AdjustKey, Position, Stage, Options[2] as int, value)
				Stage += 1
			endWhile
			Config.ExportProfile(Config.AnimProfile)
			ForcePageReset()
		else
			Animation.SetAdjustment(AdjustKey, Position, Options[1] as int, Options[2] as int, value)
			Config.ExportProfile(Config.AnimProfile)
			if Options[2] == "3" ; SOS
				SetSliderOptionValueST(value, "{0}")
			else
				SetSliderOptionValueST(value, "{2}")
			endIf
		endIf
		AutoRealign = PlayerRef.IsInFaction(Config.AnimatingFaction) && (Config.GetThreadControlled() != none || ThreadSlots.FindActorController(PlayerRef) != -1)

	; Animation Editor (Animation Offsets)
	elseIf Options[0] == "AnimationOffset"
		AnimOffsets[Options[2] as int] = value
		Animation.SetBedOffsets(AnimOffsets[0], AnimOffsets[1], AnimOffsets[2], AnimOffsets[3])
		Animation.ExportOffsets("BedOffset")
		if Options[2] == "3" ; Rotation
			SetSliderOptionValueST(value, "{0}")
		else
			SetSliderOptionValueST(value, "{2}")
		endIf
		AutoRealign = PlayerRef.IsInFaction(Config.AnimatingFaction) && ThreadSlots.FindActorController(PlayerRef) != -1

	; Expression OpenMouth Editor
	elseIf Options[0] == "OpenMouth"
		; Gender, ID, Value
		Config.SetOpenMouthPhoneme(Options[1] == "1", Options[2] as int, value / 100.0)
		SetSliderOptionValueST(value as int)

	elseIf Options[0] == "LipsMinValue"
		Config.LipsMinValue = value as int
		SetSliderOptionValueST(Config.LipsMinValue, "{0}")

	elseIf Options[0] == "LipsMaxValue"
		Config.LipsMaxValue = value as int
		SetSliderOptionValueST(Config.LipsMaxValue, "{0}")

	elseIf Options[0] == "LipsMoveTime"
		Config.LipsMoveTime = value
		SetSliderOptionValueST(Config.LipsMoveTime, "$SSL_Seconds")

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

	; Strip Editor
	elseIf Options[0] == "StripEditorPossibility"
		Form ItemRef
		if (Options[1] as int) == 0
			ItemRef = ItemsPlayer[(Options[2] as int)]
		else
			ItemRef = ItemsTarget[(Options[2] as int)]
		endIf

		if value == 100
			StorageUtil.UnsetIntValue(ItemRef, "SometimesStrip")
		else
			StorageUtil.SetIntValue(ItemRef, "SometimesStrip", value as int)
		endIf
		
		SetSliderOptionValueST(value as int, "{0}%")
		
		string StripEditorST = "StripEditor_"+Options[1]+"_"+Options[2]
		SetTextOptionValueST(GetStripState(ItemRef), false, StripEditorST)

	;	ForcePageReset()
	endIf

endEvent

event OnMenuOpenST()
	string[] Options = MapOptions()

	; Expression OpenMouth & LipSync Editor
	if Options[0] == "LipsPhoneme"
		string[] LipsPhonemes = new String[1]
		LipsPhonemes[0] = "$SSL_Automatic"
		LipsPhonemes = MergeStringArray(LipsPhonemes, Phonemes)
		SetMenuDialogStartIndex(Config.LipsPhoneme + 1)
		SetMenuDialogDefaultIndex(2) ; BigAah
		SetMenuDialogOptions(LipsPhonemes)
	endIf
endEvent

event OnMenuAcceptST(int i)
	string[] Options = MapOptions()

	; Expression OpenMouth & LipSync Editor
	if Options[0] == "LipsPhoneme"
		if i >= 0
			Config.LipsPhoneme = i - 1
			SetMenuOptionValueST(SexLabUtil.StringIfElse(Config.LipsPhoneme >= 0, Phonemes[ClampInt(Config.LipsPhoneme, 0, 15)], "$SSL_Automatic"))
		endIf
	endIf
endEvent

event OnSelectST()
	string[] Options = MapOptions()

	; Sound Settings - Voice Toggle
	if Options[0] == "Voice"
		sslBaseVoice Slot = VoiceSlots.GetBySlot(Options[1] as int)
		Slot.Enabled = !Slot.Enabled
		SetToggleOptionValueST(Slot.Enabled)

	; Timers & Stripping - Stripping
	elseIf Options[0] == "Stripping"
		bool[] Stripping = GetStripping(Options[1] as int)
		int i = Options[2] as int
		Stripping[i] = !Stripping[i]
		SetToggleOptionValueST(Stripping[i])

	; Restrict Strapons
	elseIf Options[0] == "RestrictStrapons"
		Config.RestrictStrapons = !Config.RestrictStrapons
		SetToggleOptionValueST(Config.RestrictStrapons)
		
	; Fix Victim Position
	elseIf Options[0] == "FixVictimPos"
		Config.FixVictimPos = !Config.FixVictimPos
		SetToggleOptionValueST(Config.FixVictimPos)
		
	; Expression OpenMouth & LipSync Editor
	elseIf Options[0] == "LipsFixedValue"
		Config.LipsFixedValue = !Config.LipsFixedValue
		SetToggleOptionValueST(Config.LipsFixedValue)
		
	; Strip Editor
	elseIf Options[0] == "StripEditor"
		Form ItemRef
		if (Options[1] as int) == 0
			ItemRef = ItemsPlayer[(Options[2] as int)]
		else
			ItemRef = ItemsTarget[(Options[2] as int)]
		endIf

		if ActorLib.IsAlwaysStrip(ItemRef)
			ActorLib.ClearStripOverride(ItemRef)
			StorageUtil.UnsetIntValue(ItemRef, "SometimesStrip")
		elseIf ActorLib.IsNoStrip(ItemRef)
			ActorLib.MakeAlwaysStrip(ItemRef)
		else
			ActorLib.MakeNoStrip(ItemRef)
		endIf
		SetTextOptionValueST(GetStripState(ItemRef))
	
		string StripEditorPossibilityST = "StripEditorPossibility_"+Options[1]+"_"+Options[2]
		SetSliderOptionValueST(StorageUtil.GetIntValue(ItemRef, "SometimesStrip", 100), "{0}%", false, StripEditorPossibilityST)
		SetOptionFlagsST(SexLabUtil.IntIfElse(ActorLib.IsAlwaysStrip(ItemRef), OPTION_FLAG_NONE, OPTION_FLAG_DISABLED), false, StripEditorPossibilityST)
		
	;	ForcePageReset()
		
	; Animation Toggle
	elseIf Options[0] == "Animation"
		; Get animation to toggle
		sslBaseAnimation Slot
		Slot = AnimToggles[(Options[1] as int)]
		
		if Config.MirrorPress(Config.AdjustStage)
			Position = 0
			Animation = Slot
			AdjustKey = "Global"
			PreventOverwrite = true
			ShowAnimationEditor = true
			ForcePageReset()
		;	AnimationEditor()
		else
			; if ta == 3
			; 	; Slot = CreatureSlots.GetBySlot(Options[1] as int)
			; 	Slot = AnimToggles[i]
			; else
			; 	; Slot = AnimSlots.GetBySlot(Options[1] as int)
			; endIf
			; Toggle action
			if ta == 1
				Slot.ToggleTag("LeadIn")
				; Invalite all cache so it can now include this one
				; LeadIn, Aggressive and Bed animations are not goods for the InvalidateByTags() funtion
				AnimationSlots.ClearAnimCache()
			elseIf ta == 2
				Slot.ToggleTag("Aggressive")
				; Invalite all cache so it can now include this one
				; LeadIn, Aggressive and Bed animations are not goods for the InvalidateByTags() funtion
				AnimationSlots.ClearAnimCache()
			elseIf EditTags
				Slot.ToggleTag(TagFilter)
				; Invalite all cache so it can now include this one
				AnimationSlots.InvalidateByTags(TagFilter)
			else
				Slot.Enabled = !Slot.Enabled
				if Slot.Enabled
					; Invalite cache by tags so it can now include this one
					AnimationSlots.InvalidateByTags(PapyrusUtil.StringJoin(Slot.GetRawTags()))
				else
					; Invalidate cache containing animation
					AnimationSlots.InvalidateByAnimation(Slot)
				endIf
			endIf

			SetToggleOptionValueST(GetToggle(Slot))
		endIf

	; Toggle Expressions
	elseIf Options[0] == "Expression"
		sslBaseExpression Slot = ExpressionSlots.GetBySlot(Options[2] as int)
		Slot.ToggleTag(Options[1])
		SetToggleOptionValueST(Slot.HasTag(Options[1]))

	; Advanced OpenMouth Expressions
	elseIf Options[0] == "AdvancedOpenMouth"
		EditOpenMouth = !EditOpenMouth
		ForcePageReset()

	; Alt OpenMouth Expression
	elseIf Options[0] == "OpenMouthExpression"
		if Config.GetOpenMouthExpression(Options[1] == "1") == 16
			Config.SetOpenMouthExpression(Options[1] == "1", 15)
		else
			Config.SetOpenMouthExpression(Options[1] == "1", 16)
		endIf
		SetToggleOptionValueST(Config.GetOpenMouthExpression(Options[1] == "1") == 15)

	elseIf Options[0] == "LipsSoundTime"
		Config.LipsSoundTime = sslUtility.IndexTravel(Config.LipsSoundTime + 1, 3) - 1
		SetTextOptionValueST(SoundTreatment[Config.LipsSoundTime + 1])

	; Toggle Strapons
	elseIf Options[0] == "Strapon"
		int i = Options[1] as int
		Form[] Output
		Form[] Strapons = Config.Strapons
		int n = Strapons.Length
		while n
			n -= 1
			if n != i
				Output = PushForm(Output, Strapons[n])
			endIf
		endWhile
		Config.Strapons = Output
		ForcePageReset()

	; Clean CACHE
	elseIf Options[0] == "CleanCACHE"
		SetOptionFlagsST(OPTION_FLAG_DISABLED)
		SetTextOptionValueST("Working")

		; Clear animation CACHE
		CreatureSlots.ClearAnimCache()
		AnimSlots.ClearAnimCache()

		; Clear animation tag CACHE
		CreatureSlots.ClearTagCache()
		AnimSlots.ClearTagCache()

		SetTextOptionValueST("$Done")
		SetOptionFlagsST(OPTION_FLAG_NONE)

	; Install System
	elseIf Options[0] == "InstallSystem"
		SetOptionFlagsST(OPTION_FLAG_DISABLED)
		SetTextOptionValueST("Working")

		SystemAlias.InstallSystem()

		SetTextOptionValueST("$SSL_ClickHere")
		SetOptionFlagsST(OPTION_FLAG_NONE)
		ForcePageReset()
	endIf
endEvent

event OnDefaultST()
	string[] Options = MapOptions()

	; Comment
	if Options[0] == ""
	
	; Restrict Strapons
	elseIf Options[0] == "RestrictStrapons"
		Config.RestrictStrapons = False
		SetTextOptionValueST(Config.RestrictStrapons)
	
	; Fix Victim Position
	elseIf Options[0] == "FixVictimPos"
		Config.FixVictimPos = True
		SetTextOptionValueST(Config.FixVictimPos)
	
	; Expression OpenMouth & LipSync Editor
	elseIf Options[0] == "LipsPhoneme"
		Config.LipsPhoneme = 1
		SetMenuOptionValueST(SexLabUtil.StringIfElse(Config.LipsPhoneme >= 0, Phonemes[ClampInt(Config.LipsPhoneme, 0, 15)], "$SSL_Automatic"))
	
	elseIf Options[0] == "LipsFixedValue"
		Config.LipsFixedValue = true
		SetToggleOptionValueST(Config.LipsFixedValue)
	
	endIf
endEvent

; ------------------------------------------------------- ;
; --- Install Menu                                    --- ;
; ------------------------------------------------------- ;

function InstallMenu()
	SetCursorFillMode(TOP_TO_BOTTOM)

	AddHeaderOption("SexLab v"+GetStringVer())
	AddHeaderOption("$SSL_PrerequisiteCheck")
	SystemCheckOptions()

	SetCursorPosition(1)
	AddHeaderOption("SexLab v"+GetStringVer()+" by Ashal@LoversLab.com")

	; Check for critical failure from missing SystemAlias not being found.
	if !SexLab || !SystemAlias || !Config || !ActorLib || !ThreadLib || !ThreadSlots || !AnimSlots || !CreatureSlots || !VoiceSlots || !ExpressionSlots 
		AddTextOptionST("InstallError", "CRITICAL ERROR: File Integrity", "README")
		SetInfoText("CRITICAL ERROR: File Integrity Framework quest / files overwritten...\nUnable to resolve needed variables. Install unable continue as result.\nUsually caused by incompatible SexLab addons. Disable other SexLab addons (NOT SexLab.esm) one by one and trying again until this message goes away. Alternatively, with TES5Edit after the background loader finishes check for any mods overriding SexLab.esm's Quest records. ScocLB.esm & SexlabScocLB.esp are the most common cause of this problem.\nIf using Mod Organizer, check that no mods are overwriting any of SexLab Frameworks files. There should be no red - symbol under flags for your SexLab Framework install in Mod Organizer.")
		return
	endIf

	; Install/Update button
	string AliasState = SystemAlias.GetState()
	int opt = OPTION_FLAG_NONE
	if AliasState == "Updating" || AliasState == "Installing"
		opt = OPTION_FLAG_DISABLED
	endIf
	
	AddTextOptionST("InstallSystem_0","","$SSL_InstallUpdateSexLab{"+GetStringVer()+"}", opt)
	AddTextOptionST("InstallSystem_1","","$SSL_ClickHere", opt)

	if AliasState == "Updating"
		AddTextOption("$SSL_CurrentlyUpdating", "!")
	elseIf AliasState == "Installing"
		AddTextOption("$SSL_CurrentlyInstalling", "!")
	endIf

endFunction

function SystemCheckOptions()
	AddTextOption("Skyrim Script Extender (2.0.17+)", StringIfElse(Config.CheckSystemPart("SKSE"), "<font color='#00FF00'>ok</font>", "<font color='#FF0000'>X</font>"), OPTION_FLAG_DISABLED)
	AddTextOption("SexLabUtil.dll SKSE Plugin  (1.6+)", StringIfElse(Config.CheckSystemPart("SexLabUtil"), "<font color='#00FF00'>ok</font>", "<font color='#FF0000'>X</font>"), OPTION_FLAG_DISABLED)
	AddTextOption("PapyrusUtil.dll SKSE Plugin  (3.9+)", StringIfElse(Config.CheckSystemPart("PapyrusUtil"), "<font color='#00FF00'>ok</font>", "<font color='#FF0000'>X</font>"), OPTION_FLAG_DISABLED)
	AddTextOption("SKEE64.dll SKSE Plugin  (3.4+)", StringIfElse(Config.CheckSystemPart("NiOverride"), "<font color='#00FF00'>ok</font>", "<font color='#0000FF'>?</font>"), OPTION_FLAG_DISABLED)
	AddTextOption("FNIS - Fores New Idles in Skyrim (7.0+)", StringIfElse(Config.CheckSystemPart("FNIS"), "<font color='#00FF00'>ok</font>", "<font color='#FF0000'>X</font>"), OPTION_FLAG_DISABLED)
	AddTextOption("FNIS For Users Behaviors Generated", StringIfElse(Config.CheckSystemPart("FNISGenerated"), "<font color='#00FF00'>ok</font>", "<font color='#0000FF'>?</font>"), OPTION_FLAG_DISABLED)
	AddTextOption("FNIS SexLab Framework Idles", StringIfElse(Config.CheckSystemPart("FNISSexLabFramework"), "<font color='#00FF00'>ok</font>", "<font color='#0000FF'>?</font>"), OPTION_FLAG_DISABLED)
	AddTextOption("FNIS Creature Pack (7.0+)", StringIfElse(Config.CheckSystemPart("FNISCreaturePack"), "<font color='#00FF00'>ok</font>", "<font color='#0000FF'>?</font>"), OPTION_FLAG_DISABLED)
	AddTextOption("FNIS SexLab Creature Idles", StringIfElse(Config.CheckSystemPart("FNISSexLabCreature"), "<font color='#00FF00'>ok</font>", "<font color='#0000FF'>?</font>"), OPTION_FLAG_DISABLED)
	; Show soft error warning if relevant
	if !Config.CheckSystemPart("NiOverride") || !Config.CheckSystemPart("FNISGenerated") || !Config.CheckSystemPart("FNISSexLabFramework") || !Config.CheckSystemPart("FNISCreaturePack") || !Config.CheckSystemPart("FNISSexLabCreature")
		AddTextOptionST("FNISWarning", "INFO: On '?' Warning", "README")
		SetInfoText("Important FNIS Check:\nIf you're getting a '?' on any checks try scrolling in and out of 3rd person mode then checking again while still in 3rd. These '?' are just soft warnings and can usually be ignored safely.\nIf scrolling in and out doesn't work and characters stand frozen in place during animation than these are the most likely causes. Fix your FNIS install.")
	endIf
endFunction

; ------------------------------------------------------- ;
; --- Animation Settings                              --- ;
; ------------------------------------------------------- ;

string[] Chances
string[] BedOpt
string[] FadeOpt

function AnimationSettings()
	SetCursorFillMode(TOP_TO_BOTTOM)
	AddHeaderOption("$SSL_PlayerSettings")
	AddToggleOptionST("AutoAdvance","$SSL_AutoAdvanceStages", Config.AutoAdvance)
	AddToggleOptionST("DisableVictim","$SSL_DisableVictimControls", Config.DisablePlayer)
	AddToggleOptionST("AutomaticTFC","$SSL_AutomaticTFC", Config.AutoTFC)
	AddSliderOptionST("AutomaticSUCSM","$SSL_AutomaticSUCSM", Config.AutoSUCSM, "{0}")
	AddTextOptionST("PlayerGender","$SSL_PlayerGender", SexLabUtil.StringIfElse(ActorLib.GetGender(PlayerRef) % 2 == 0, "$SSL_Male", "$SSL_Female"))
	if TargetRef
		AddTextOptionST("TargetGender","$SSL_{"+TargetName+"}sGender", SexLabUtil.StringIfElse(ActorLib.GetGender(TargetRef) % 2 == 0, "$SSL_Male", "$SSL_Female"))
	endIf

	AddHeaderOption("$SSL_ExtraEffects")
	AddMenuOptionST("UseFade","$SSL_UseFade", FadeOpt[ClampInt(Config.UseFade, 0, 4)])
	AddToggleOptionST("UseExpressions","$SSL_UseExpressions", Config.UseExpressions)
	AddToggleOptionST("RefreshExpressions","$SSL_RefreshExpressions", Config.RefreshExpressions)
	AddSliderOptionST("ExpressionDelay","$SSL_ExpressionDelay", Config.ExpressionDelay, "{1}x")
	AddToggleOptionST("UseLipSync", "$SSL_UseLipSync", Config.UseLipSync)
	AddToggleOptionST("SeparateOrgasms","$SSL_SeparateOrgasms", Config.SeparateOrgasms)
	AddToggleOptionST("OrgasmEffects","$SSL_OrgasmEffects", Config.OrgasmEffects)
	AddSliderOptionST("ShakeStrength","$SSL_ShakeStrength", (Config.ShakeStrength * 100), "{0}%")
	AddToggleOptionST("UseCum","$SSL_ApplyCumEffects", Config.UseCum)
	AddToggleOptionST("AllowFemaleFemaleCum","$SSL_AllowFemaleFemaleCum", Config.AllowFFCum, SexLabUtil.IntIfElse((!Config.UseCum), OPTION_FLAG_DISABLED, OPTION_FLAG_NONE))
	AddSliderOptionST("CumEffectTimer","$SSL_CumEffectTimer", Config.CumTimer, "$SSL_Seconds")
	AddToggleOptionST("LimitedStrip","$SSL_LimitedStrip", Config.LimitedStrip)
	AddToggleOptionST("ShowInMap","$SSL_ShowInMap", Config.ShowInMap)
	AddTextOptionST("NPCBed","$SSL_NPCsUseBeds", Chances[ClampInt(Config.NPCBed, 0, 2)])
	AddTextOptionST("AskBed","$SSL_AskBed", BedOpt[ClampInt(Config.AskBed, 0, 2)])

	SetCursorPosition(1)
	AddMenuOptionST("AnimationProfile", "$SSL_AnimationProfile", "Profile #"+Config.AnimProfile)
	AddToggleOptionST("AllowCreatures","$SSL_AllowCreatures", Config.AllowCreatures)
	AddToggleOptionST("UseCreatureGender","$SSL_UseCreatureGender", Config.UseCreatureGender)
	AddHeaderOption("$SSL_AnimationHandling")
	AddToggleOptionST("RaceAdjustments","$SSL_RaceAdjustments", Config.RaceAdjustments)
	AddToggleOptionST("DisableTeleport","$SSL_DisableTeleport", Config.DisableTeleport)
	AddToggleOptionST("SeedNPCStats","$SSL_SeedNPCStats", Config.SeedNPCStats)
	AddToggleOptionST("ScaleActors","$SSL_EvenActorsHeight", Config.ScaleActors, SexLabUtil.IntIfElse(Config.DisableScale, OPTION_FLAG_DISABLED, OPTION_FLAG_NONE))
	AddToggleOptionST("DisableScale","$SSL_DisableScale", Config.DisableScale)
	AddToggleOptionST("ForeplayStage","$SSL_PreSexForeplay", Config.ForeplayStage)
	AddSliderOptionST("LeadInCoolDown","$SSL_LeadInCoolDown", Config.LeadInCoolDown, "$SSL_Seconds", SexLabUtil.IntIfElse(Config.ForeplayStage, OPTION_FLAG_NONE, OPTION_FLAG_DISABLED))
	AddToggleOptionST("FixVictimPos","$SSL_FixVictimPos", Config.FixVictimPos)
	AddToggleOptionST("RestrictAggressive","$SSL_RestrictAggressive", Config.RestrictAggressive)
	AddToggleOptionST("RestrictSameSex","$SSL_RestrictSameSex", Config.RestrictSameSex)
	AddToggleOptionST("RestrictGenderTag","$SSL_RestrictGenderTag", Config.RestrictGenderTag)
	AddToggleOptionST("UndressAnimation","$SSL_UndressAnimation", Config.UndressAnimation)
	AddToggleOptionST("RedressVictim","$SSL_VictimsRedress", Config.RedressVictim)
	AddToggleOptionST("StraponsFemale","$SSL_FemalesUseStrapons", Config.UseStrapons)
	AddToggleOptionST("RestrictStrapons","$SSL_RestrictStrapons", Config.RestrictStrapons)
	AddToggleOptionST("RemoveHeelEffect","$SSL_RemoveHeelEffect", Config.RemoveHeelEffect)
	AddToggleOptionST("BedRemoveStanding","$SSL_BedRemoveStanding", Config.BedRemoveStanding)
	AddToggleOptionST("RagdollEnd","$SSL_RagdollEnding", Config.RagdollEnd)
	AddToggleOptionST("NudeSuitMales","$SSL_UseNudeSuitMales", Config.UseMaleNudeSuit)
	AddToggleOptionST("NudeSuitFemales","$SSL_UseNudeSuitFemales", Config.UseFemaleNudeSuit)
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

state DisableTeleport
	event OnSelectST()
		Config.DisableTeleport = !Config.DisableTeleport
		SetToggleOptionValueST(Config.DisableTeleport)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoDisableTeleport")
	endEvent
endState

state SeedNPCStats
	event OnSelectST()
		Config.SeedNPCStats = !Config.SeedNPCStats
		SetToggleOptionValueST(Config.SeedNPCStats)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoSeedNPCStats")
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
	AddTextOptionST("AdjustTargetStage", "$SSL_AdjustTargetStage", StringIfElse(Config.AdjustTargetStage, "$SSL_CurrentStage", "$SSL_AllStages"))
	AddKeyMapOptionST("AdjustStage", StringIfElse(Config.AdjustTargetStage, "$SSL_AdjustAllStages", "$SSL_AdjustStage"), Config.AdjustStage)
	AddKeyMapOptionST("BackwardsModifier", "$SSL_ReverseDirectionModifier", Config.Backwards)
	AddKeyMapOptionST("AdjustChange","$SSL_ChangeActorBeingMoved", Config.AdjustChange)
	AddKeyMapOptionST("AdjustForward","$SSL_MoveActorForwardBackward", Config.AdjustForward)
	AddKeyMapOptionST("AdjustUpward","$SSL_AdjustPositionUpwardDownward", Config.AdjustUpward)
	AddKeyMapOptionST("AdjustSideways","$SSL_MoveActorLeftRight", Config.AdjustSideways)
	AddKeyMapOptionST("AdjustSchlong","$SSL_AdjustSchlong", Config.AdjustSchlong)
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
		if newKeyCode == 1 || !KeyConflict(newKeyCode, conflictControl, conflictName)
			if newKeyCode == 1
				newKeyCode = -1
			endIf
			Config.AdjustStage = newKeyCode
			SetKeyMapOptionValueST(Config.AdjustStage)
		endIf
	endEvent
	event OnDefaultST()
		Config.AdjustStage = 157
		SetKeyMapOptionValueST(Config.AdjustStage)
	endEvent
	event OnHighlightST()
		SetInfoText(StringIfElse(Config.AdjustTargetStage, "$SSL_InfoAdjustAllStages", "$SSL_InfoAdjustStage"))
	endEvent
endState
state AdjustChange
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if newKeyCode == 1 || !KeyConflict(newKeyCode, conflictControl, conflictName)
			if newKeyCode == 1
				newKeyCode = -1
			endIf
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
		if newKeyCode == 1 || !KeyConflict(newKeyCode, conflictControl, conflictName)
			if newKeyCode == 1
				newKeyCode = -1
			endIf
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
		if newKeyCode == 1 || !KeyConflict(newKeyCode, conflictControl, conflictName)
			if newKeyCode == 1
				newKeyCode = -1
			endIf
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
		if newKeyCode == 1 || !KeyConflict(newKeyCode, conflictControl, conflictName)
			if newKeyCode == 1
				newKeyCode = -1
			endIf
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
state AdjustSchlong
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if newKeyCode == 1 || !KeyConflict(newKeyCode, conflictControl, conflictName)
			if newKeyCode == 1
				newKeyCode = -1
			endIf
			Config.AdjustSchlong = newKeyCode
			SetKeyMapOptionValueST(Config.AdjustSchlong)
		endIf
	endEvent
	event OnDefaultST()
		Config.AdjustSchlong = 46
		SetKeyMapOptionValueST(Config.AdjustSchlong)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAdjustSchlong")
	endEvent
endState
state RotateScene
	event OnKeyMapChangeST(int newKeyCode, string conflictControl, string conflictName)
		if newKeyCode == 1 || !KeyConflict(newKeyCode, conflictControl, conflictName)
			if newKeyCode == 1
				newKeyCode = -1
			endIf
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
		if newKeyCode == 1 || !KeyConflict(newKeyCode, conflictControl, conflictName)
			if newKeyCode == 1
				newKeyCode = -1
			endIf
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
		if newKeyCode == 1 || !KeyConflict(newKeyCode, conflictControl, conflictName)
			if newKeyCode == 1
				newKeyCode = -1
			endIf
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
		if newKeyCode == 1 || !KeyConflict(newKeyCode, conflictControl, conflictName)
			if newKeyCode == 1
				newKeyCode = -1
			endIf
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
		if newKeyCode == 1 || !KeyConflict(newKeyCode, conflictControl, conflictName)
			if newKeyCode == 1
				newKeyCode = -1
			endIf
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
		if newKeyCode == 1 || !KeyConflict(newKeyCode, conflictControl, conflictName)
			if newKeyCode == 1
				newKeyCode = -1
			endIf
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
		if newKeyCode == 1 || !KeyConflict(newKeyCode, conflictControl, conflictName)
			if newKeyCode == 1
				newKeyCode = -1
			endIf
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
		if newKeyCode == 1 || !KeyConflict(newKeyCode, conflictControl, conflictName)
			if newKeyCode == 1
				newKeyCode = -1
			endIf
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
		if newKeyCode == 1 || !KeyConflict(newKeyCode, conflictControl, conflictName)
			if newKeyCode == 1
				newKeyCode = -1
			endIf
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
		if newKeyCode == 1 || !KeyConflict(newKeyCode, conflictControl, conflictName)
			if newKeyCode == 1
				newKeyCode = -1
			endIf
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
		if newKeyCode == 1 || !KeyConflict(newKeyCode, conflictControl, conflictName)
			if newKeyCode == 1
				newKeyCode = -1
			endIf
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
state AdjustTargetStage
	event OnSelectST()
		Config.AdjustTargetStage = !Config.AdjustTargetStage
		ForcePageReset()
	endEvent
	event OnDefaultST()
		Config.AdjustTargetStage = false
		SetTextOptionValueST("$SSL_AllStages")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAdjustTargetStage")
	endEvent
endState

; ------------------------------------------------------- ;
; --- Troubleshoot                                    --- ;
; ------------------------------------------------------- ;

function Troubleshoot()
	AddTextOptionST("AnimationTrouble", "Animations Don't Play", "$SSL_ClickHere")
	AddTextOptionST("VoiceTrouble", "Characters don't play any moans during animation", "$SSL_ClickHere")
	AddTextOptionST("LipSyncTrouble", "Characters don't lipsync their moans", "$SSL_ClickHere")
endFunction

state AnimationTrouble
	event OnSelectST()
		if ShowMessage("To perform this test, you will need to find a safe location to wait while the tests are performed. Are you in a safe location?", true, "$Yes", "$No")
			ShowMessage("Close all menus to continue...", false)
			Utility.Wait(0.1)
			(Quest.GetQuest("SexLabTroubleshoot") as sslTroubleshoot).PerformTests("FNIS,ThreadSlots,AnimSlots")
		endIf
	endEvent
endState

state VoiceTrouble
	event OnSelectST()
		if ShowMessage("To perform this test, you will need to find a safe location to wait while the tests are performed. Are you in a safe location?", true, "$Yes", "$No")
			ShowMessage("Close all menus to continue...", false)
			Utility.Wait(0.1)
			(Quest.GetQuest("SexLabTroubleshoot") as sslTroubleshoot).PerformTests("VoiceSlots,PlayVoice")
		endIf
	endEvent
endState

state LipSyncTrouble
	event OnSelectST()
		if ShowMessage("To perform this test, you will need to find a safe location to wait while the tests are performed. Are you in a safe location?", true, "$Yes", "$No")
			ShowMessage("Close all menus to continue...", false)
			Utility.Wait(0.1)
			(Quest.GetQuest("SexLabTroubleshoot") as sslTroubleshoot).PerformTests("PlayVoice,LipSync")
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
		sslBaseVoice Voice = VoiceSlots.GetBySlot(i)
		if Voice
			AddToggleOptionST("Voice_"+i, Voice.Name, Voice.Enabled)
		endIf
		i += 1
	endWhile
endFunction

; ------------------------------------------------------- ;
; --- Animation Editor                                --- ;
; ------------------------------------------------------- ;

; Current edit target
sslBaseAnimation Animation
sslBaseAnimation ControlledAnimation
sslAnimationSlots AnimationSlots
bool PreventOverwrite
bool IsCreatureEditor
bool AutoRealign
string AdjustKey
int Position
int AnimEditPage
float[] AnimOffsets ; = forward, side, up, rotate

function AnimationEditor()
	SetCursorFillMode(LEFT_TO_RIGHT)

	; Auto select players animation if they are animating right now
	if !PreventOverwrite 
		sslThreadController Thread = Config.GetThreadControlled()
		if !(Thread && (Thread.GetState() == "Animating" || Thread.GetState() == "Advancing"))
			if TargetRef && TargetRef != none && TargetRef.IsInFaction(Config.AnimatingFaction)
				Thread = ThreadSlots.GetActorController(TargetRef)
			endIf
			if !(Thread && (Thread.GetState() == "Animating" || Thread.GetState() == "Advancing"))
				if PlayerRef.IsInFaction(Config.AnimatingFaction)
					Thread = ThreadSlots.GetActorController(PlayerRef)
				endIf
			endIf
		endIf
		if Thread && Thread.Animation
			PreventOverwrite = true
			Position  = Thread.GetAdjustPos()
			Animation = Thread.Animation
			ControlledAnimation = Thread.Animation
			AdjustKey = Thread.AdjustKey
		endIf
	endIf

	; Pick a default animation
	if !Animation
		Position  = 0
		Animation = AnimSlots.GetBySlot(0)
		AdjustKey = "Global"
		IsCreatureEditor = false
	endIf

	; Check if editing a creature animation
	AnimationSlots   = AnimSlots
	IsCreatureEditor = Animation.IsCreature
	if IsCreatureEditor
		AnimationSlots = CreatureSlots
	endIf

	; Set current pagination settings
	PerPage      = 125
	LastPage     = AnimationSlots.PageCount(PerPage)
	AnimEditPage = AnimationSlots.FindPage(Animation.Registry, PerPage)

	; Adjustkeys for current animation
	AdjustKeys    = new string[1]
	AdjustKeys[0] = "Animation"
	AdjustKeys = MergeStringArray(AdjustKeys, Animation.GetAdjustKeys())

	; Show editor options
	SetTitleText(Animation.Name)
	AddMenuOptionST("AnimationSelect", "$SSL_Animation", Animation.Name)
	AddToggleOptionST("AnimationEnabled", "$SSL_Enabled", Animation.Enabled)

	AddMenuOptionST("AnimationAdjustKey", "$SSL_AdjustmentProfile", AdjustKey)
	if AdjustKey == "Animation"
		string Type = "Bed"
		Type = "Bed"
		AnimOffsets = Animation.GetBedOffsets()
		if (Animation.PositionCount == 1 && (!IsCreatureEditor || (Animation.HasActorRace(PlayerRef) || (TargetRef && Animation.HasActorRace(PlayerRef))))) || (Animation.PositionCount >= 2 && TargetRef && (!IsCreatureEditor || (Animation.HasActorRace(PlayerRef) || Animation.HasActorRace(TargetRef))))
			AddTextOptionST("AnimationTest", "$SSL_PlayAnimation", "$SSL_ClickHere")
		else
			AddTextOptionST("AnimationTest", "$SSL_PlayAnimation", "$SSL_ClickHere", OPTION_FLAG_DISABLED)
		endIf
		
		AddHeaderOption(Type + " Adjustments")
		AddHeaderOption("")

		AddSliderOptionST("AnimationOffset_"+Type+"_0", "$SSL_AdjustForwards", AnimOffsets[0], "{2}")
		AddSliderOptionST("AnimationOffset_"+Type+"_1", "$SSL_AdjustSideways", AnimOffsets[1], "{2}")
		AddSliderOptionST("AnimationOffset_"+Type+"_2", "$SSL_AdjustUpwards",  AnimOffsets[2], "{2}")
		AddSliderOptionST("AnimationOffset_"+Type+"_3", "$SSL_AdjustRotation",  AnimOffsets[3], "{0}")
	else
		AddMenuOptionST("AnimationPosition", "$SSL_Position", "$SSL_{"+GenderLabel(Animation.GetGender(Position))+"}Gender{"+(Position + 1)+"}Position")

		AddMenuOptionST("AnimationAdjustCopy", "$SSL_CopyFromProfile", "$SSL_Select")

		if (Animation.PositionCount == 1 && (!IsCreatureEditor || (Animation.HasActorRace(PlayerRef) || (TargetRef && Animation.HasActorRace(PlayerRef))))) || (Animation.PositionCount >= 2 && TargetRef && (!IsCreatureEditor || (Animation.HasActorRace(PlayerRef) || Animation.HasActorRace(TargetRef))))
			AddTextOptionST("AnimationTest", "$SSL_PlayAnimation", "$SSL_ClickHere")
		else
			AddTextOptionST("AnimationTest", "$SSL_PlayAnimation", "$SSL_ClickHere", OPTION_FLAG_DISABLED)
		endIf

		string Profile
		if AdjustKey && AdjustKey != "Global"
			string[] RaceIDs = StringSplit(AdjustKey, ".")
			string id = RaceIDs[Position]
			Race RaceRef = Race.GetRace(id)
			string Gender = ""
			if !(RaceRef || id == "Humanoid" || sslCreatureAnimationSlots.HasRaceKey(id))
				int i = 0
				while i < 6
					i += 1
					id = StringUtil.Substring(RaceIDs[Position], 0, (StringUtil.GetLength(RaceIDs[Position]) - i))
					RaceRef = Race.GetRace(id)
					if RaceRef || id == "Humanoid" || sslCreatureAnimationSlots.HasRaceKey(id)
						Gender = StringUtil.GetNthChar(RaceIDs[Position], (StringUtil.GetLength(RaceIDs[Position]) - i))
						i = 6
					endIf
				endWhile
			endIf
			if Gender && (Gender != "M") && (Gender != "F") && (Gender != "C")
				Gender = ""
			endIf
			if RaceRef
				id = RaceRef.GetName()
			elseIf id != "Humanoid"
				id = RaceIDs[Position]
			endIf
			Profile = "$SSL_{"+id+"}-{"+GenderLabel(Gender)+"}"
		else
			Profile = "$SSL_{Global}-{"+GenderLabel(Animation.GetGender(Position))+"}"
		endIf

		int Stage = 1
		while Stage <= Animation.StageCount

			float[] Adjustments = Animation.GetPositionAdjustments(AdjustKey, Position, Stage)
			; Log(Adjustments, "AnimationEditor("+AdjustKey+", "+Position+", "+Stage+")")

			AddHeaderOption("$SSL_Stage{"+Stage+"}Adjustments")
			AddHeaderOption(Profile)

			AddSliderOptionST("Adjust_"+Stage+"_0", "$SSL_AdjustForwards", Adjustments[0], "{2}")
			AddSliderOptionST("Adjust_"+Stage+"_1", "$SSL_AdjustSideways", Adjustments[1], "{2}")
			AddSliderOptionST("Adjust_"+Stage+"_2", "$SSL_AdjustUpwards",  Adjustments[2], "{2}")
			AddSliderOptionST("Adjust_"+Stage+"_3", "$SSL_SchlongUpDown",  Adjustments[3], "{0}")

			Stage += 1
		endWhile
	endIf
endFunction

string function GenderLabel(string id)
	if id == "0" || id == "M"
		return "$SSL_Male"
	elseIf id == "1" || id == "F"
		return "$SSL_Female"
	elseIf id >= "2" || id == "C"
		return "$SSL_Creature"
	endIf
	return "$SSL_Unknown"
endFunction

string[] PageOptions
string[] MenuOptions
string[] AdjustKeys

state AnimationEnabled
	event OnSelectST()
		Animation.Enabled = !Animation.Enabled
		SetToggleOptionValueST(Animation.Enabled)
		if Animation.Enabled
			if Animation.IsCreature
				CreatureSlots.InvalidateByTags(PapyrusUtil.StringJoin(Animation.GetRawTags()))
			else
				AnimationSlots.InvalidateByTags(PapyrusUtil.StringJoin(Animation.GetRawTags()))
			endIf
		else
			if Animation.IsCreature
				CreatureSlots.InvalidateByAnimation(Animation)
			else
				AnimationSlots.InvalidateByAnimation(Animation)
			endIf
		endIf
	endEvent
	event OnDefaultST()
		Animation.Enabled = true
		SetToggleOptionValueST(Animation.Enabled)
		if Animation.IsCreature
			CreatureSlots.InvalidateByTags(PapyrusUtil.StringJoin(Animation.GetRawTags()))
		else
			AnimationSlots.InvalidateByTags(PapyrusUtil.StringJoin(Animation.GetRawTags()))
		endIf
	endEvent
endState

state AnimationSelect

	event OnMenuOpenST()
		if Config.AllowCreatures
			PageOptions = PaginationMenu(StringIfElse(IsCreatureEditor, "$SSL_SwitchNormalAnimationEditor", "$SSL_SwitchCreatureAnimationEditor"), "", AnimEditPage)
		else
			PageOptions = PaginationMenu("", "", AnimEditPage)
		endIf
		MenuOptions = MergeStringArray(PageOptions, AnimationSlots.GetSlotNames(AnimEditPage, PerPage))
		SetMenuDialogOptions(MenuOptions)
		int MenuIndex = MenuOptions.Find(Animation.Name)
		if !MenuIndex
			MenuIndex = PageOptions.Length - 1
		endIf
		SetMenuDialogStartIndex(MenuIndex)
		SetMenuDialogDefaultIndex(MenuIndex)
	endEvent

	event OnMenuAcceptST(int i)
		if i >= 0
			AdjustKey = "Global"
			Position  = 0
			if MenuOptions[i] == "$SSL_SwitchNormalAnimationEditor" || MenuOptions[i] == "$SSL_SwitchCreatureAnimationEditor"
				if IsCreatureEditor
					IsCreatureEditor = false
					Animation = AnimSlots.GetBySlot(0)
				else
					IsCreatureEditor = true
					Animation = CreatureSlots.GetBySlot(0)
				endIf
			elseIf MenuOptions[i] == "$SSL_PrevPage"
				Animation = AnimationSlots.GetBySlot(((AnimEditPage - 2) * PerPage))
			elseIf MenuOptions[i] == "$SSL_NextPage"
				Animation = AnimationSlots.GetBySlot((AnimEditPage * PerPage))
			else
				i -= PageOptions.Length
				i += ((AnimEditPage - 1) * PerPage)
				Animation = AnimationSlots.GetBySlot(i)
			endIf		
			SetMenuOptionValueST(Animation.Name)
			ForcePageReset()
		endIf
	endEvent
	
	event OnDefaultST()
		if IsCreatureEditor
			Animation = CreatureSlots.GetBySlot(0)
		else
			Animation = AnimSlots.GetBySlot(0)
		endIf
		AdjustKey = "Global"
		Position  = 0
		SetMenuOptionValueST(Animation.Name)
		ForcePageReset()
	endEvent

	event OnHighlightST()
		SetInfoText(Animation.Name+" Tags:\n"+StringJoin(Animation.GetTags(), ", "))
	endEvent
endState

state AnimationPosition
	event OnMenuOpenST()
		string[] Positions = Utility.CreateStringArray(Animation.PositionCount)
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
		if i >= 0
			Position = i
			SetMenuOptionValueST("$SSL_{"+GenderLabel(Animation.GetGender(i))+"}Gender{"+(i + 1)+"}Position")
			PreventOverwrite = true
			ForcePageReset()
		endIf
	endEvent
	event OnDefaultST()
		if Position != 0
			Position = 0
			SetMenuOptionValueST(Position)
			PreventOverwrite = true
			ForcePageReset()
		endIf
	endEvent
endState

state AnimationAdjustKey
	event OnMenuOpenST()
		SetMenuDialogStartIndex(AdjustKeys.Find(AdjustKey))
		SetMenuDialogDefaultIndex(AdjustKeys.Find("Global"))
		SetMenuDialogOptions(AdjustKeys)
	endEvent
	event OnMenuAcceptST(int i)
		AdjustKey = "Global"
		if i >= 0 && i < AdjustKeys.Length
			AdjustKey = AdjustKeys[i]
		endIf
		if Config.MirrorPress(Config.AdjustStage) && AdjustKey != "Global" && AdjustKey != "Animation" && ShowMessage("$SSL_WarnProfileRemove{"+AdjustKey+"}", true, "$Yes", "$No")
			Animation.RestoreOffsets(AdjustKey)
			AdjustKey = "Global"
		endIf
		SetMenuOptionValueST(AdjustKey)
		PreventOverwrite = true
		ForcePageReset()
	endEvent
	event OnDefaultST()
		if AdjustKey != "Global"
			AdjustKey = "Global"
			SetMenuOptionValueST(AdjustKey)
			PreventOverwrite = true
			ForcePageReset()
		endIf
	endEvent
endState

string[] TempAdjustKeys
state AnimationAdjustCopy
	event OnMenuOpenST()
		TempAdjustKeys = RemoveString(AdjustKeys,"Animation")
		SetMenuDialogStartIndex(TempAdjustKeys.Find(AdjustKey))
		SetMenuDialogDefaultIndex(TempAdjustKeys.Find("Global"))
		SetMenuDialogOptions(TempAdjustKeys)
	endEvent
	event OnMenuAcceptST(int i)
		string CopyKey = "Global"
		if i >= 0
			CopyKey = TempAdjustKeys[i]
		endIf
		if CopyKey != AdjustKey && ShowMessage("$SSL_ProfileOverwrite{"+AdjustKey+"}With{"+CopyKey+"}", true, "$Yes", "$No")
			Animation.RestoreOffsets(AdjustKey)
			int n = Animation.PositionCount
			while n
				n -= 1
				Animation.CopyAdjustmentsFrom(AdjustKey, CopyKey, n)
			endWhile
			ForcePageReset()
		endIf
		; SetMenuOptionValueST(TempAdjustKeys[i])
	endEvent
	event OnDefaultST()
		AdjustKey = "Global"
		SetMenuOptionValueST(AdjustKey)
		ForcePageReset()
	endEvent
endState

state AnimationTest
	event OnSelectST()
		if ShowMessage("About to player test animation "+Animation.Name+" for preview purposes.\n\nDo you wish to continue?", true, "$Yes", "$No")

			sslThreadModel Thread = SexLab.NewThread()
			if Thread
				; Add single animation to thread
				sslBaseAnimation[] Anims = new sslBaseAnimation[1]
				Anims[0] = Animation
				Thread.SetForcedAnimations(Anims)
				; Disable extra effects, this is a test - keep it simple
				Thread.DisableBedUse(true)
				Thread.DisableLeadIn(true)
				; select a solo actor
				if Animation.PositionCount == 1
					string RaceKey = ""
					int FindGender = Animation.GetGender(0)
					if FindGender > 1
						RaceKey = Animation.RaceType
					elseif FindGender > 0 && !(Animation.HasTag("Vaginal") || Animation.HasTag("Pussy") || Animation.HasTag("Cunnilingus") || Animation.HasTag("Futa"))
						FindGender = -1
					elseif FindGender == 0 && Config.UseStrapons && Animation.UseStrapon(0, 1)
						FindGender = -1
					endIf

					bool ValidPlayer = ThreadLib.CheckActor(PlayerRef, FindGender) && (RaceKey == "" || sslCreatureAnimationSlots.GetAllRaceKeys(PlayerRef.GetLeveledActorBase().GetRace()).Find(RaceKey) != -1)
					bool ValidTarget = ThreadLib.CheckActor(TargetRef, FindGender) && (RaceKey == "" || sslCreatureAnimationSlots.GetAllRaceKeys(TargetRef.GetLeveledActorBase().GetRace()).Find(RaceKey) != -1)
					if ValidPlayer && ValidTarget
						if ShowMessage("Which actor would you like to play the solo animation "+Animation.Name+" with?", true, TargetName, PlayerName)
							Thread.AddActor(TargetRef)
						else
							Thread.AddActor(PlayerRef)
						endIf
					elseIf ValidTarget
						Thread.AddActor(TargetRef)
					elseIf ValidPlayer
						Thread.AddActor(PlayerRef)
					else
						ShowMessage("Failed to start test animation.\n  None valid actor selected", false)
					endIf
				; Add actors
				elseIf Animation.PositionCount >= 2
					Thread.AddActors(ThreadLib.FindAnimationPartners(Animation, PlayerRef, 1500, PlayerRef, TargetRef))
				endIf
				if Animation.PositionCount != Thread.ActorCount
					ShowMessage("Failed to start test animation.\n  Animation.PositionCount["+Animation.PositionCount+"] and ActorCount["+Thread.ActorCount+"] don't match", false)
				else
					ShowMessage("Starting animation "+Animation.Name+".\n\nClose all menus and return to the game to continue...", false)
					Utility.Wait(0.5)
					if !Thread.StartThread()
						ShowMessage("Failed to start test animation.", false)
					endIf
				endIf
			else
				ShowMessage("Failed to start test animation.", false)
			endIf
		endIf
	endEvent
endState

; ------------------------------------------------------- ;
; --- Toggle Animations                               --- ;
; ------------------------------------------------------- ;

sslBaseAnimation[] AnimToggles
string[] TAModes
string[] TFAction
string[] TagCache
string TagFilter
string TagMode
bool EditTags
int TogglePage
int ta
int TFA

function AddAnimationsTag(string Tag)
	if Tag == "" || AnimToggles.Length < 1
		return
	endIf
	
	int i
	while i < AnimToggles.Length
		if AnimToggles[i] && AnimToggles[i].Registered && (!TagFilter || EditTags || AnimToggles[i].HasTag(TagFilter))
			AnimToggles[i].AddTag(Tag)
		endIf
		i += 1
	endWhile
endFunction

function RemoveAnimationsTag(string Tag)
	if Tag == "" || AnimToggles.Length < 1
		return
	endIf
	
	int i
	while i < AnimToggles.Length
		if AnimToggles[i] && AnimToggles[i].Registered && (!TagFilter || EditTags || AnimToggles[i].HasTag(TagFilter))
			AnimToggles[i].RemoveTag(Tag)
		endIf
		i += 1
	endWhile
endFunction

function ToggleAnimationsTag(string Tag)
	if Tag == "" || AnimToggles.Length < 1
		return
	endIf
	
	int i
	while i < AnimToggles.Length
		if AnimToggles[i] && AnimToggles[i].Registered && (!TagFilter || EditTags || AnimToggles[i].HasTag(TagFilter))
			AnimToggles[i].ToggleTag(Tag)
		endIf
		i += 1
	endWhile
endFunction

function ToggleAnimations()
	SetCursorFillMode(LEFT_TO_RIGHT)

	; Allow tag toggling only on main animation toggle and creature
	bool AllowTagToggle = (ta == 0 || ta == 3)

	;if !AllowTagToggle
	;	TagFilter = ""
	;	EditTags = false
	;endIf

	; Setup pagination
	PerPage  = 122
	LastPage = AnimationSlots.PageCount(PerPage)
	if TogglePage > LastPage || TogglePage < 1
		TogglePage = 1
	endIf

	; Get relevant slot registry
	AnimationSlots = AnimSlots
	if ta == 3
		AnimationSlots = CreatureSlots		
	endIf

	; Get animations to be toggled
	AnimToggles = AnimationSlots.GetSlots(TogglePage, PerPage)
	int Slotted = AnimationSlots.Slotted

	; Mode select
	if Config.AllowCreatures
		TAModes = new string[4]
		TAModes[0] = "$SSL_ToggleAnimations"
		TAModes[1] = "$SSL_ForeplayAnimations"
		TAModes[2] = "$SSL_AggressiveAnimations"
		TAModes[3] = "$SSL_CreatureAnimations"
	else
		TAModes = new string[3]
		TAModes[0] = "$SSL_ToggleAnimations"
		TAModes[1] = "$SSL_ForeplayAnimations"
		TAModes[2] = "$SSL_AggressiveAnimations"
	endIf

	TFA = 0
	If TagFilter
		if EditTags
			TFAction = new string[5]
			TFAction[0] = "$SSL_ToggleTag{"+TagFilter+"}"
			TFAction[1] = "$SSL_ToggleFilter"
			TFAction[2] = "$SSL_InvertTagFromAll{"+TagFilter+"}"
			TFAction[3] = "$SSL_AddTagToAll{"+TagFilter+"}"
			TFAction[4] = "$SSL_RemoveTagFromAll{"+TagFilter+"}"
		else
			TFAction = new string[2]
			TFAction[0] = "$SSL_ToggleAnimations"
			TFAction[1] = "$SSL_ToggleFilter"
		endIf
	elseIf ta == 1 || ta == 2
		TFAction = new string[4]
		if ta == 1
			TagMode = "LeadIn"
		else
			TagMode = "Aggressive"
		endIf
		TFAction[0] = "$SSL_ToggleTag{"+TagMode+"}"
		TFAction[1] = "$SSL_InvertTagFromAll{"+TagMode+"}"
		TFAction[2] = "$SSL_AddTagToAll{"+TagMode+"}"
		TFAction[3] = "$SSL_RemoveTagFromAll{"+TagMode+"}"
	else
		TFAction = new string[1]
		TFAction[0] = "$SSL_ToggleAnimations"
	endIf
	
	SetTitleText(TAModes[ta])
	AddMenuOptionST("TAModeSelect", "$SSL_View", TAModes[ta])

	; Page select
	AddTextOptionST("AnimationTogglePage", "Page #", TogglePage+" / "+LastPage, DoDisable(Slotted <= PerPage))


	;if AllowTagToggle
		AddMenuOptionST("FilterByTag", "Filter By Tag:", StringIfElse(!TagFilter, "---", TagFilter), DoDisable(!AllowTagToggle))
		AddMenuOptionST("FilterAction", "Action:", TFAction[TFA], DoDisable(TFAction.Length < 2))
	;	AddTextOptionST("ToggleAction", "Toggle Action:", StringIfElse(EditTags && TagFilter, "Has: \""+TagFilter+"\"", "$SSL_DoDisable"), DoDisable(!TagFilter))
	;endIf

	AddHeaderOption("")
	AddHeaderOption("")

	int i
	while i < AnimToggles.Length
		if AnimToggles[i] && AnimToggles[i].Registered && (!TagFilter || EditTags || AnimToggles[i].HasTag(TagFilter))
			AddToggleOptionST("Animation_"+i, AnimToggles[i].Name, GetToggle(AnimToggles[i]))
		endIf
		i += 1
	endWhile
endFunction

bool function GetToggle(sslBaseAnimation Anim)
	if ta == 1
		return Anim.HasTag("LeadIn")
	elseIf ta == 2
		return Anim.HasTag("Aggressive")
	elseIf EditTags
		return Anim.HasTag(TagFilter)
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
		if i != ta
			TagFilter = ""
			EditTags = false
		endIf
		ta = i
		TogglePage = 1
		SetMenuOptionValueST(TAModes[ta])
		ForcePageReset()
	endEvent
	event OnDefaultST()
		ta = 0
		TogglePage = 1
		SetMenuOptionValueST(TAModes[ta])
		ForcePageReset()
	endEvent
endState

state AnimationTogglePage
	event OnSelectST()
		TogglePage += 1
		if TogglePage > LastPage
			TogglePage = 1
		endIf
		SetTextOptionValueST(TogglePage)
		ForcePageReset()
	endEvent
	event OnDefaultST()
		TogglePage = 1
		SetTextOptionValueST(TogglePage)
	endEvent
	event OnHighlightST()
		SetInfoText("")
	endEvent
endState

state FilterByTag
	event OnMenuOpenST()
		TagCache    = new string[1]
		TagCache[0] = "( NONE )"
		if ta == 3
			TagCache = MergeStringArray(TagCache, AnimationSlots.GetTagCache())
		else
			TagCache = MergeStringArray(TagCache, RemoveString(RemoveString(AnimationSlots.GetTagCache(),"LeadIn"),"Aggressive"))
		endIf
		SortStringArray(TagCache)
		if TagFilter && TagCache.Find(TagFilter) != -1
			SetMenuDialogStartIndex(TagCache.Find(TagFilter))
		else
			SetMenuDialogStartIndex(0)
		endIf
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(TagCache)
	endEvent
	event OnMenuAcceptST(int i)
		TagFilter = StringIfElse(i < 1, "", TagCache[i])
		TagCache = Utility.CreateStringArray(0)
		TogglePage = 1
		SetMenuOptionValueST(TagFilter)
		ForcePageReset()
	endEvent
	event OnDefaultST()
		TagFilter = ""
		TogglePage = 1
		SetMenuOptionValueST(TAModes[ta])
		ForcePageReset()
	endEvent
endState

state FilterAction
	event OnMenuOpenST()
		SetMenuDialogStartIndex(TFA)
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(TFAction)
	endEvent
	event OnMenuAcceptST(int i)
		if i >= 0
			TFA = i
		endIf
		SetMenuOptionValueST(TFAction[TFA])
		if TagFilter
			if TFA == 1
				EditTags = !EditTags
			elseIf TFA == 2
				if ShowMessage("$SSL_WarnInvertTagFromAll{"+TagFilter+"}", true, "$Yes", "$No")
					ToggleAnimationsTag(TagFilter)
				endIf
			elseIf TFA == 3
				if ShowMessage("$SSL_WarnAddTagToAll{"+TagFilter+"}", true, "$Yes", "$No")
					AddAnimationsTag(TagFilter)
				endIf
			elseIf TFA == 4
				if ShowMessage("$SSL_WarnRemoveTagFromAll{"+TagFilter+"}", true, "$Yes", "$No")
					RemoveAnimationsTag(TagFilter)
				endIf
			endIf
			ForcePageReset()
		elseIf ta == 1 || ta == 2
			TFAction = new string[4]
			if TFA == 1
				if ShowMessage("$SSL_WarnInvertTagFromAll{"+TagMode+"}", true, "$Yes", "$No")
					ToggleAnimationsTag(TagMode)
				endIf
			elseIf TFA == 2
				if ShowMessage("$SSL_WarnAddTagToAll{"+TagMode+"}", true, "$Yes", "$No")
					AddAnimationsTag(TagMode)
				endIf
			elseIf TFA == 3
				if ShowMessage("$SSL_WarnRemoveTagFromAll{"+TagMode+"}", true, "$Yes", "$No")
					RemoveAnimationsTag(TagMode)
				endIf
			endIf
			if TFA != 0
				ForcePageReset()
			endIf
		endIf
	endEvent
	event OnDefaultST()
		TFA = 0
		SetMenuOptionValueST(TFAction[TFA])
	endEvent
endState

state ToggleAction
	event OnSelectST()
		EditTags = !EditTags
		ForcePageReset()
	endEvent
	event OnDefaultST()
		EditTags = false
		SetTextOptionValueST("Enable/Disable")
		ForcePageReset()
	endEvent
	event OnHighlightST()
		SetInfoText("")
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
bool EditOpenMouth
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
string[] SoundTreatment

function ExpressionEditor()
	SetCursorFillMode(LEFT_TO_RIGHT)

	if !Expression
		Expression = ExpressionSlots.GetBySlot(0)
		Phase = 1
	endIf

	int FlagF = OPTION_FLAG_NONE
	int FlagM = OPTION_FLAG_NONE
	if Phase > Expression.PhasesFemale
		FlagF = OPTION_FLAG_DISABLED
	endIf
	if Phase > Expression.PhasesMale
		FlagM = OPTION_FLAG_DISABLED
	endIf

	; Left
	; 0. OpenMouth Config
	; 1. Name
	; 2. Normal Tag
	; 3. Victim Tag
	; 4. Aggressor Tag
	; 5. Phase Select

	; Right
	; 0. OpenMouth Config
	; 1. <empty>
	; 2. Export Expression
	; 3. Import Expression
	; 4. Player Test
	; 5. Target Test

	; 0
	if EditOpenMouth
		SetTitleText("$SSL_OpenMouthSyncLipsConfig")

		AddHeaderOption("$SSL_OpenMouthConfig")
		AddHeaderOption("")

		AddSliderOptionST("OpenMouthSize","$SSL_OpenMouthSize", Config.OpenMouthSize, "{0}%")

		AddTextOptionST("AdvancedOpenMouth", "$SSL_EditExpression", "$SSL_ClickHere")

		AddToggleOptionST("OpenMouthExpression_1", "Use Alt Female Expression", Config.GetOpenMouthExpression(True) == 15)
		AddToggleOptionST("OpenMouthExpression_0", "Use Alt Male Expression", Config.GetOpenMouthExpression(False) == 15)

		AddTextOptionST("ExpressionTestPlayer", "$SSL_TestOnPlayer", "$SSL_Apply")
		AddTextOptionST("ExpressionTestTarget", "$SSL_TestOn{"+TargetName+"}", "$SSL_Apply", Math.LogicalAnd(OPTION_FLAG_NONE, (TargetRef == none) as int))

		; OpenMouth Phoneme settings
		AddHeaderOption("$SSL_{$SSL_Female}-{$SSL_Phoneme}")
		AddHeaderOption("$SSL_{$SSL_Male}-{$SSL_Phoneme}")

		int i = 0
		while i <= 15
			AddSliderOptionST("OpenMouth_1_"+i, Phonemes[i], Config.OpenMouthFemale[i] * 100, "{0}")
			AddSliderOptionST("OpenMouth_0_"+i, Phonemes[i], Config.OpenMouthMale[i] * 100, "{0}")
			i += 1
		endWhile

		AddHeaderOption("$SSL_SyncLipsConfig")
		AddHeaderOption("")


		AddMenuOptionST("LipsPhoneme", "$SSL_LipsPhoneme", SexLabUtil.StringIfElse(Config.LipsPhoneme >= 0, Phonemes[ClampInt(Config.LipsPhoneme, 0, 15)], "$SSL_Automatic"))
		AddToggleOptionST("LipsFixedValue", "$SSL_LipsFixedValue", Config.LipsFixedValue)

		AddSliderOptionST("LipsMinValue", "$SSL_LipsMinValue", Config.LipsMinValue, "{0}")
		AddSliderOptionST("LipsMaxValue", "$SSL_LipsMaxValue", Config.LipsMaxValue, "{0}")

		AddTextOptionST("LipsSoundTime", "$SSL_LipsSoundTime", SoundTreatment[ClampInt(Config.LipsSoundTime + 1, 0, 2)])
		AddSliderOptionST("LipsMoveTime", "$SSL_LipsMoveTime", Config.LipsMoveTime, "$SSL_Seconds")

		return ; to hide the rest of the options

	else
		SetTitleText(Expression.Name)

		AddHeaderOption("$SSL_OpenMouthConfig")
		AddHeaderOption("")

		AddSliderOptionST("OpenMouthSize","$SSL_OpenMouthSize", Config.OpenMouthSize, "{0}%")
		AddTextOptionST("AdvancedOpenMouth", "$SSL_EditOpenMouth", "$SSL_ClickHere")

	endIf

	; 1
	AddHeaderOption("$SSL_ExpressionEditor")
	AddHeaderOption("")

	AddMenuOptionST("ExpressionSelect", "$SSL_ModifyingExpression", Expression.Name)
	AddToggleOptionST("ExpressionEnabled", "$SSL_Enabled", Expression.Enabled)

	; 2
	AddToggleOptionST("ExpressionNormal", "$SSL_ExpressionsNormal", Expression.HasTag("Normal"))
	AddTextOptionST("ExportExpression", "$SSL_ExportExpression", "$SSL_ClickHere")

	; 3
	AddToggleOptionST("ExpressionVictim", "$SSL_ExpressionsVictim", Expression.HasTag("Victim"))
	AddTextOptionST("ImportExpression", "$SSL_ImportExpression", "$SSL_ClickHere")

	; 4
	AddToggleOptionST("ExpressionAggressor", "$SSL_ExpressionsAggressor", Expression.HasTag("Aggressor"))
	AddTextOptionST("ExpressionTestPlayer", "$SSL_TestOnPlayer", "$SSL_Apply", Math.LogicalAnd(OPTION_FLAG_NONE, (!Expression.HasPhase(Phase, PlayerRef)) as int))

	; AddTextOptionST("ExpressionCopyFromPlayer", "$SSL_ExpressionCopyFrom", "$SSL_ClickHere")
	; AddTextOptionST("ExpressionCopyFromTarget", "$SSL_ExpressionCopyFrom", "$SSL_ClickHere", Math.LogicalAnd(OPTION_FLAG_NONE, (TargetRef == none) as int))

	; 5
	AddMenuOptionST("ExpressionPhase", "$SSL_Modifying{"+Expression.Name+"}Phase", Phase)
	AddTextOptionST("ExpressionTestTarget", "$SSL_TestOn{"+TargetName+"}", "$SSL_Apply", Math.LogicalAnd(OPTION_FLAG_NONE, (TargetRef == none || !Expression.HasPhase(Phase, TargetRef)) as int))

	; Show expression customization options
	float[] FemaleModifiers = Expression.GetModifiers(Phase, Female)
	float[] FemalePhonemes  = Expression.GetPhonemes(Phase, Female)

	float[] MaleModifiers   = Expression.GetModifiers(Phase, Male)
	float[] MalePhonemes    = Expression.GetPhonemes(Phase, Male)

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

	; Expression/Mood settings
	AddHeaderOption("$SSL_{$SSL_Female}-{$SSL_Mood}", FlagF)
	AddHeaderOption("$SSL_{$SSL_Male}-{$SSL_Mood}", FlagM)

	AddMenuOptionST("MoodTypeFemale", "$SSL_MoodType", Moods[Expression.GetMoodType(Phase, Female)], FlagF)
	AddMenuOptionST("MoodTypeMale", "$SSL_MoodType", Moods[Expression.GetMoodType(Phase, Male)], FlagM)

	AddSliderOptionST("MoodAmountFemale", "$SSL_MoodStrength", Expression.GetMoodAmount(Phase, Female), "{0}", FlagF)
	AddSliderOptionST("MoodAmountMale", "$SSL_MoodStrength", Expression.GetMoodAmount(Phase, Male), "{0}", FlagM)

	; Modifier settings
	AddHeaderOption("$SSL_{$SSL_Female}-{$SSL_Modifier}", FlagF)
	AddHeaderOption("$SSL_{$SSL_Male}-{$SSL_Modifier}", FlagM)

	int i = 0
	while i <= 13
		AddSliderOptionST("Expression_1_"+Modifier+"_"+i, Modifiers[i], FemaleModifiers[i] * 100, "{0}", FlagF)
		AddSliderOptionST("Expression_0_"+Modifier+"_"+i, Modifiers[i], MaleModifiers[i] * 100, "{0}", FlagM)
		i += 1
	endWhile

	; Phoneme settings
	AddHeaderOption("$SSL_{$SSL_Female}-{$SSL_Phoneme}", FlagF)
	AddHeaderOption("$SSL_{$SSL_Male}-{$SSL_Phoneme}", FlagM)
	i = 0
	while i <= 15
		AddSliderOptionST("Expression_1_"+Phoneme+"_"+i, Phonemes[i], FemalePhonemes[i] * 100, "{0}", FlagF)
		AddSliderOptionST("Expression_0_"+Phoneme+"_"+i, Phonemes[i], MalePhonemes[i] * 100, "{0}", FlagM)
		i += 1
	endWhile
endFunction

state ExpressionSelect
	event OnMenuOpenST()
		SetMenuDialogStartIndex(ExpressionSlots.Expressions.Find(Expression))
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(ExpressionSlots.GetNames(ExpressionSlots.Expressions))
	endEvent
	event OnMenuAcceptST(int i)
		if i >= 0
			Phase = 1
			Expression = ExpressionSlots.GetBySlot(i)
			SetMenuOptionValueST(Expression.Name)
			ForcePageReset()
		endIf
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
		if i >= 0
			Phase = i + 1
			SetMenuOptionValueST(Phase)
			ForcePageReset()
		endIf
	endEvent
	event OnDefaultST()
		Phase = 1
		SetMenuOptionValueST(Phase)
		ForcePageReset()
	endEvent
endState

state ExportExpression
	event OnSelectST()
		if ShowMessage("$SSL_WarnExportExpression{"+Expression.Name+"}", true, "$Yes", "$No")
			if Expression.ExportJson()
				ShowMessage("$SSL_SuccessExportExpression")
			else
				ShowMessage("$SSL_ErrorExportExpression")
			endIf
		endIf
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoExportExpression{"+Expression.Registry+"}")
	endEvent
endState

state ImportExpression
	event OnSelectST()
		if ShowMessage("$SSL_WarnImportExpression{"+Expression.Name+"}", true, "$Yes", "$No")
			if Expression.ImportJson()
				ShowMessage("$SSL_SuccessImportExpression")
				Phase = 1
				ForcePageReset()
			else
				ShowMessage("$SSL_ErrorImportExpression")
			endIf
		endIf
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoImportExpression{"+Expression.Registry+"}")
	endEvent
endState

state ExpressionCopyFromPlayer
	event OnSelectST()
		Actor ActorRef = PlayerRef
		if TargetRef && ShowMessage("$SSL_ExpressionCopyFromTarget", true, TargetName, PlayerName)
			ActorRef == TargetRef
		endIf
		float[] Preset = sslBaseExpression.GetCurrentMFG(ActorRef)
		if PapyrusUtil.AddFloatValues(Preset) > (Preset[30] + Preset[31])
			Expression.SetPhase(Phase, ActorRef.GetLeveledActorBase().GetSex(), Preset)
		else
			ShowMessage("$SSL_ExpressionCopy{"+ActorRef.GetLeveledActorBase().GetName()+"}Empty")
		endIf
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_ExpressionCopyFromInfo")
	endEvent
endState

state ExpressionTestPlayer
	event OnSelectST()
		TestApply(PlayerRef)
	endEvent
endState

state ExpressionTestTarget
	event OnSelectST()
		TestApply(TargetRef)
	endEvent
endState

function TestApply(Actor ActorRef)
	if !ActorRef || !ActorRef.Is3DLoaded()
		return
	endIf
	string ActorName = ActorRef.GetLeveledActorBase().GetName()
	if EditOpenMouth
		if ShowMessage("$SSL_WarnTestExpression{"+ActorName+"}", true, "$Yes", "$No")
			ShowMessage("$SSL_StartTestOpenMouth", false)
			Utility.Wait(0.1)
			Game.ForceThirdPerson()
			sslBaseExpression.OpenMouth(ActorRef)
			Utility.Wait(0.1)
			Debug.Notification("$SSL_AppliedTestExpression")
			Utility.WaitMenuMode(15.0)
			sslBaseExpression.CloseMouth(ActorRef)
			ActorRef.ClearExpressionOverride()
			Debug.Notification("$SSL_RestoredTestExpression")
		endIf
	elseIf Expression && ShowMessage("$SSL_WarnTestExpression{"+ActorName+"}", true, "$Yes", "$No")
		bool testOpenMouth = false
		if ShowMessage("$SSL_WarnTestExpressionWithOpenMouth", true, "$Yes", "$No")
			testOpenMouth = true
		endIf
		ShowMessage("$SSL_StartTestExpression{"+Expression.Name+"}_{"+phase+"}", false)
		Utility.Wait(0.1)
		Game.ForceThirdPerson()
		if testOpenMouth
			sslBaseExpression.OpenMouth(ActorRef)
			Utility.Wait(1.0)
		endIf
		Expression.ApplyPhase(ActorRef, Phase, ActorRef.GetLeveledActorBase().GetSex())
		Log("Expression.Applied("+Expression.Name+") Strength:"+100+"; OpenMouth:"+testOpenMouth)
		Utility.Wait(0.1)
		Debug.Notification("$SSL_AppliedTestExpression")
		Utility.WaitMenuMode(15.0)
		sslBaseExpression.ClearMFG(ActorRef)
		ActorRef.ResetExpressionOverrides()
		ActorRef.ClearExpressionOverride()
		Debug.Notification("$SSL_RestoredTestExpression")
	endIf
endFunction

state ExpressionEnabled
	event OnSelectST()
		Expression.Enabled = !Expression.Enabled
		SetToggleOptionValueST(Expression.Enabled)
	endEvent
	event OnDefaultST()
		Expression.Enabled = Expression.HasTag("Normal") && Expression.HasTag("Victim") && Expression.HasTag("Aggressor")
		SetToggleOptionValueST(Expression.Enabled)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoExpressionEnabled")
	endEvent
endState
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
		if Phase > 1 && ShowMessage("$SSL_WarnCopyPreviousPhase", true, "$Yes", "$No")
			float[] PeviousPhase = Expression.GenderPhase((Phase - 1), Female)
			float[] NewValues = new float[32]
			int i = PeviousPhase.Length
			while i
				i -= 1
				NewValues[i] = PeviousPhase[i]
			endWhile
			Expression.SetPhase(Phase, Female, NewValues)
		endIf
		ForcePageReset()
	endEvent
endState
state ExpressionAddPhaseMale
	event OnSelectST()
		Expression.AddPhase(Phase, Male)
		if Phase > 1 && ShowMessage("$SSL_WarnCopyPreviousPhase", true, "$Yes", "$No")
			float[] PeviousPhase = Expression.GenderPhase((Phase - 1), Male)
			float[] NewValues = new float[32]
			int i = PeviousPhase.Length
			while i
				i -= 1
				NewValues[i] = PeviousPhase[i]
			endWhile
			Expression.SetPhase(Phase, Male, NewValues)
		endIf
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
		if i > 14
			ShowMessage("$SSL_WarnMoodForbidden{"+Moods[i]+"}")
			Expression.SetIndex(Phase, Female, Mood, 0, 0)
			SetMenuOptionValueST(Moods[0])
		elseIf i >= 0
			Expression.SetIndex(Phase, Female, Mood, 0, i)
			SetMenuOptionValueST(Moods[i])
		endIf
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
		if i > 14
			ShowMessage("$SSL_WarnMoodForbidden{"+Moods[i]+"}")
			Expression.SetIndex(Phase, Male, Mood, 0, 0)
			SetMenuOptionValueST(Moods[0])
		elseIf i >= 0
			Expression.SetIndex(Phase, Male, Mood, 0, i)
			SetMenuOptionValueST(Moods[i])
		endIf
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
Actor[] PlayerPartners
function SexDiary()
	SetCursorFillMode(TOP_TO_BOTTOM)

	if TargetRef != StatRef
		AddTextOptionST("SetStatTarget", "$SSL_Viewing{"+StatRef.GetLeveledActorBase().GetName()+"}", "$SSL_View{"+TargetName+"}", TargetFlag)
	else
		AddTextOptionST("SetStatTarget", "$SSL_Viewing{"+TargetName+"}", "$SSL_View{"+PlayerName+"}")
	endIf

	AddHeaderOption("$SSL_SexualExperience")
	AddTextOption("$SSL_TimeSpentHavingSex", Stats.ParseTime(Stats.GetSkill(StatRef, "TimeSpent") as int))
	AddTextOption("$SSL_VaginalProficiency", Stats.GetSkillTitle(StatRef, "Vaginal"))
	AddTextOption("$SSL_AnalProficiency", Stats.GetSkillTitle(StatRef, "Anal"))
	AddTextOption("$SSL_OralProficiency", Stats.GetSkillTitle(StatRef, "Oral"))
	AddTextOption("$SSL_ForeplayProficiency", Stats.GetSkillTitle(StatRef, "Foreplay"))
	AddTextOption("$SSL_SexualPurity", Stats.GetPureTitle(StatRef))
	AddTextOption("$SSL_SexualPerversion", Stats.GetLewdTitle(StatRef))
	; AddEmptyOption()

	Actor ActorRef
	if StatRef == PlayerRef
		if !PlayerPartners || PlayerPartners.Length < 1
			PlayerPartners = Stats.MostUsedPlayerSexPartners(3)
		endIf
		int i = 0
		while i < PlayerPartners.Length
			if PlayerPartners[i] != none
				AddTextOption("$SSL_MostActivePartner", PlayerPartners[i].GetLeveledActorBase().GetName()+" ("+Stats.PlayerSexCount(PlayerPartners[i])+")")
			endIf
			i += 1
		endWhile
	else
		ActorRef = Stats.LastSexPartner(StatRef)
		if ActorRef
			AddTextOption("$SSL_LastPartner", ActorRef.GetLeveledActorBase().GetName())
		endIf
	endIf

	ActorRef = Stats.LastAggressor(StatRef)
	if ActorRef
		AddTextOption("$SSL_LastAggressor", ActorRef.GetLeveledActorBase().GetName())
	endIf

	ActorRef = Stats.LastVictim(StatRef)
	if ActorRef
		AddTextOption("$SSL_LastVictim", ActorRef.GetLeveledActorBase().GetName())
	endIf


	SetCursorPosition(1)

	AddTextOptionST("ResetTargetStats", "$SSL_Reset{"+StatRef.GetLeveledActorBase().GetName()+"}Stats", "$SSL_ClickHere")

	AddHeaderOption("$SSL_SexualStats")
	AddTextOptionST("SetStatSexuality", "$SSL_Sexuality", Stats.GetSexualityTitle(StatRef))
	AddTextOption("$SSL_MaleSexualPartners", Stats.GetSkill(StatRef, "Males"))
	AddTextOption("$SSL_FemaleSexualPartners", Stats.GetSkill(StatRef, "Females"))
	AddTextOption("$SSL_CreatureSexualPartners", Stats.GetSkill(StatRef, "Creatures"))
	AddTextOption("$SSL_TimesMasturbated", Stats.GetSkill(StatRef, "Masturbation"))
	AddTextOption("$SSL_TimesAggressive", Stats.GetSkill(StatRef, "Aggressor"))
	AddTextOption("$SSL_TimesVictim", Stats.GetSkill(StatRef, "Victim"))
	AddTextOption("$SSL_TimesVaginal", Stats.GetSkill(StatRef, "VaginalCount"))
	AddTextOption("$SSL_TimesAnal", Stats.GetSkill(StatRef, "AnalCount"))
	AddTextOption("$SSL_TimesOral", Stats.GetSkill(StatRef, "OralCount"))

	; Custom stats set by other mods
	if StatRef == PlayerRef
		int i = Stats.GetNumStats()
		while i
			i -= 1
			AddTextOption(Stats.GetNthStat(i), Stats.GetStatFull(StatRef, Stats.GetNthStat(i)))
		endWhile
	else
		AddTextOption("$SSL_TimesWithPlayer", Stats.PlayerSexCount(StatRef))
	endIf
endFunction

state SetStatTarget
	event OnSelectST()
		if StatRef == PlayerRef && TargetRef
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
			Stats.SetSkill(StatRef, "Sexuality", 50)
		elseIf Stats.IsBisexual(StatRef)
			Stats.SetSkill(StatRef, "Sexuality", 1)
		else
			Stats.SetSkill(StatRef, "Sexuality", 100)
		endIf
		SetTextOptionValueST(Stats.GetSexualityTitle(StatRef))
	endEvent
endState

bool EmptyStatToggle
state ResetTargetStats
	event OnSelectST()
		if ShowMessage("$SSL_WarnReset{"+StatRef.GetLeveledActorBase().GetName()+"}Stats")
			EmptyStatToggle = !EmptyStatToggle
			if EmptyStatToggle || StatRef == PlayerRef
				Stats.EmptyStats(StatRef)
			else
				Stats.ResetStats(StatRef)
			endIf
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

; Float timer arrays
float[] StageTimer
float[] StageTimerLeadIn
float[] StageTimerAggr
float[] function GetTimersDef()
	if ts == 1
		return StageTimerLeadIn
	elseIf ts == 2
		return StageTimerAggr
	else
		return StageTimer
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
		if i < 0
			i = ts
		endIf
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
; --- Strip Editor                                    --- ;
; ------------------------------------------------------- ;

Form[] ItemsPlayer
Form[] ItemsTarget
bool FullInventoryPlayer
bool FullInventoryTarget

function StripEditor()
	AddHeaderOption("$SSL_Equipment{"+PlayerName+"}")
	AddToggleOptionST("FullInventoryPlayer", "$SSL_FullInventory", FullInventoryPlayer)

	ItemsPlayer = GetItems(PlayerRef, FullInventoryPlayer)
	int Max = AddItemToggles(ItemsPlayer, 0, 123)
;	if ItemsPlayer.Length % 2 != 0
;		AddEmptyOption()
;		Max -= 1
;	endIf ;Not longer need with StripEditorPossibility option

	if TargetRef && Max >= 4
		AddHeaderOption("$SSL_Equipment{"+TargetRef.GetLeveledActorBase().GetName()+"}")
		AddToggleOptionST("FullInventoryTarget", "$SSL_FullInventory", FullInventoryTarget)

		ItemsTarget = GetItems(TargetRef, FullInventoryTarget)
		Max = AddItemToggles(ItemsTarget, 1, Max)
	endIf

	if Max < 1
		AddHeaderOption("NOTICE: Max display of items reached!")
	endIf
endFunction

int function AddItemToggles(Form[] Items, int ID, int Max)
	if !Items
		return Max
	endIf
	int i
	while i < Items.Length && Max
		if Items[i]
			AddTextOptionST("StripEditor_"+ID+"_"+i, GetItemName(Items[i]), GetStripState(Items[i]))
			Max -= 1
			AddSliderOptionST("StripEditorPossibility_"+ID+"_"+i,"Possibility", StorageUtil.GetIntValue(Items[i], "SometimesStrip", 100), "{0}%", SexLabUtil.IntIfElse(ActorLib.IsAlwaysStrip(Items[i]), OPTION_FLAG_NONE, OPTION_FLAG_DISABLED))
			Max -= 1
		endIf
		i += 1
	endWhile
	return Max
endFunction

; function AddStripToggles(Form[] Items, )

string function GetStripState(Form ItemRef)
	if !ItemRef
		return "none"
	elseIf ActorLib.IsNoStrip(ItemRef)
		return "$SSL_NeverRemove"
	elseIf ActorLib.IsAlwaysStrip(ItemRef)
		if StorageUtil.GetIntValue(ItemRef, "SometimesStrip", 100) < 100
			return "$SSL_SometimesRemove"
		endIf
		return "$SSL_AlwaysRemove"
	else
		return "---"
	endIf
endFunction

bool function IsToggleable(Form ItemRef)
	return !SexLabUtil.HasKeywordSub(ItemRef, "NoStrip") && !SexLabUtil.HasKeywordSub(ItemRef, "AlwaysStrip")
endFunction
;/ int function ItemToggleFlag(Form ItemRef)
	if !ItemRef || SexLabUtil.HasKeywordSub(ItemRef, "NoStrip") || SexLabUtil.HasKeywordSub(ItemRef, "AlwaysStrip")
		return OPTION_FLAG_DISABLED
	else
		return OPTION_FLAG_NONE
	endIf
endFunction /;

Form[] function GetItems(Actor ActorRef, bool FullInventory = false)
	if FullInventory
		return GetFullInventory(ActorRef)
	else
		return GetEquippedItems(ActorRef)
	endIf
endFunction

string function GetItemName(Form ItemRef, string AltName = "$SSL_Unknown")
	if ItemRef
		string Name = ItemRef.GetName()
		if Name != "" && Name != " "
			return Name
		else 
			return AltName
		endIf
	endIf
	return "none"
endFunction

int[] function GetAllMaskSlots(int Mask)
	int i = 30
	int Slot = 0x01
	int[] Output
	while i < 62
		if Math.LogicalAnd(Mask, Slot) == Slot
			Output = PapyrusUtil.PushInt(Output, i)
		endIf
		Slot *= 2
		i += 1
	endWhile
	return Output
endFunction

Form[] function GetEquippedItems(Actor ActorRef)
	Form[] Output = new Form[34]
	; Weapons
	Form ItemRef
	ItemRef = ActorRef.GetEquippedWeapon(false) ; Right Hand
	if ItemRef && IsToggleable(ItemRef)
		Output[33] = ItemRef
	endIf
	ItemRef = ActorRef.GetEquippedWeapon(true) ; Left Hand
	if ItemRef && ItemRef != Output[33] && IsToggleable(ItemRef)
		Output[32] = ItemRef
	endIf

	; Armor
	int i
	int Slot = 0x01
	while i < 32
		Form WornRef = ActorRef.GetWornForm(Slot)
		if WornRef
			if WornRef as ObjectReference
				WornRef = (WornRef as ObjectReference).GetBaseObject()
			endIf
			if Output.Find(WornRef) == -1 && IsToggleable(WornRef)
				Output[i] = WornRef
			endIf
		endIf
		Slot *= 2
		i    += 1
	endWhile
	return PapyrusUtil.ClearNone(Output)
endFunction

Form[] function GetFullInventory(Actor ActorRef)
	int[] Valid = new int[3]
	Valid[0] = 26 ; kArmor
	Valid[1] = 41 ; kWeapon 
	Valid[2] = 53 ; kLeveledItem
	;/ Valid[3] = 124 ; kOutfit
	Valid[4] = 102 ; kARMA
	Valid[5] = 120 ; kEquipSlot /;

	Form[] Output = GetEquippedItems(ActorRef)
	Form[] Items  = ActorRef.GetContainerForms()
	int n = Output.Length
	int i = Items.Length
	Output = Utility.ResizeFormArray(Output, 126)
	while i && n < 126
		i -= 1
		Form ItemRef = Items[i]
		if ItemRef && Valid.Find(ItemRef.GetType()) != -1
			if ItemRef as ObjectReference
				ItemRef = (ItemRef as ObjectReference).GetBaseObject()
			endIf
			if Output.Find(ItemRef) == -1 && IsToggleable(ItemRef)
				Output[n] = ItemRef
				n += 1
			endIf
		endIf
	endWhile
	return PapyrusUtil.ClearNone(Output)
endFunction

state FullInventoryPlayer
	event OnSelectST()
		FullInventoryPlayer = !FullInventoryPlayer
		ForcePageReset()
	endEvent
endState

state FullInventoryTarget
	event OnSelectST()
		FullInventoryTarget = !FullInventoryTarget
		ForcePageReset()
	endEvent
endState

; ------------------------------------------------------- ;
; --- Rebuild & Clean                                 --- ;
; ------------------------------------------------------- ;

function RebuildClean()
	int i

	SetCursorFillMode(TOP_TO_BOTTOM)

	AddHeaderOption("SexLab v"+GetStringVer()+" by Ashal@LoversLab.com")
	if SexLab.Enabled
		AddTextOptionST("ToggleSystem","$SSL_EnabledSystem", "$SSL_DoDisable")
	else
		AddTextOptionST("ToggleSystem","$SSL_DisabledSystem", "$SSL_DoEnable")
	endIf
	AddTextOptionST("CleanSystem","$SSL_CleanSystem", "$SSL_ClickHere")

	; AddHeaderOption("$SSL_UpgradeUninstallReinstall")

	AddHeaderOption("$SSL_Maintenance")
	AddTextOptionST("StopCurrentAnimations","$SSL_StopCurrentAnimations", "$SSL_ClickHere")
	AddTextOptionST("CleanCACHE","$SSL_CleanCACHE", "$SSL_ClickHere")
	AddTextOptionST("RestoreDefaultSettings","$SSL_RestoreDefaultSettings", "$SSL_ClickHere")
	AddTextOptionST("ResetAnimationRegistry","$SSL_ResetAnimationRegistry", "$SSL_ClickHere")
	AddTextOptionST("ResetVoiceRegistry","$SSL_ResetVoiceRegistry", "$SSL_ClickHere")
	AddTextOptionST("ResetExpressionRegistry","$SSL_ResetExpressionRegistry", "$SSL_ClickHere")
	AddTextOptionST("ResetStripOverrides","$SSL_ResetStripOverrides", "$SSL_ClickHere")
	AddTextOptionST("ClearNPCSexSkills","$SSL_ClearNPCSexSkills", "$SSL_ClickHere")

	AddHeaderOption("$SSL_AvailableStrapons")
	AddTextOptionST("RebuildStraponList","$SSL_RebuildStraponList", "$SSL_ClickHere")
	i = Config.Strapons.Length
	while i
		i -= 1
		if Config.Strapons[i]
			string Name = Config.Strapons[i].GetName()
			if Name == "strapon"
				Name = "Aeon/Horker"
			endIf
			AddTextOptionST("Strapon_"+i, Name, "$SSL_Remove")
		endIf
	endWhile

	SetCursorPosition(1)
	AddToggleOptionST("DebugMode","$SSL_DebugMode", Config.InDebugMode)

	AddTextOptionST("ExportSettings","$SSL_ExportSettings", "$SSL_ClickHere")
	AddTextOptionST("ImportSettings","$SSL_ImportSettings", "$SSL_ClickHere")

	AddHeaderOption("Registry Info")


	if AnimSlots.GetDisabledCount() > 0 || CreatureSlots.GetDisabledCount() > 0
		AddTextOptionST("NeverRegisterDisabled","$SSL_NeverRegisterDisabled", "$SSL_ClickHere")
	else
		AddTextOptionST("NeverRegisterDisabled","$SSL_NeverRegisterDisabled", "--", OPTION_FLAG_DISABLED)
	endIf
	if AnimSlots.GetSuppressedCount() > 0
		AddTextOptionST("ResetNeverRegisters","$SSL_ResetNeverRegisters", "$SSL_ClickHere")
	else
		AddTextOptionST("ResetNeverRegisters","$SSL_ResetNeverRegisters", "--", OPTION_FLAG_DISABLED)
	endIf

	AddTextOption("Animations (Character)", AnimSlots.Slotted+" / "+AnimSlots.GetNumAliases(), OPTION_FLAG_DISABLED)
	AddTextOption("Animations (Creature)", CreatureSlots.Slotted+" / "+CreatureSlots.GetNumAliases(), OPTION_FLAG_DISABLED)
	AddTextOption("Voices", VoiceSlots.Slotted+" / 375", OPTION_FLAG_DISABLED)
	AddTextOption("Expressions", ExpressionSlots.Slotted+" / 375", OPTION_FLAG_DISABLED)


	AddHeaderOption("System Requirements")
	SystemCheckOptions()	
endFunction

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
		SetSliderDialogDefaultValue(5)
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
state PlayerGender
	event OnSelectST()
		ActorLib.TreatAsGender(PlayerRef, ActorLib.GetGender(PlayerRef) % 2 == 0)
		SetTextOptionValueST(SexLabUtil.StringIfElse(ActorLib.GetGender(PlayerRef) % 2 == 0, "$SSL_Male", "$SSL_Female"))
	endEvent
	event OnDefaultST()
		ActorLib.ClearForcedGender(PlayerRef)
		SetTextOptionValueST(SexLabUtil.StringIfElse(ActorLib.GetGender(PlayerRef) % 2 == 0, "$SSL_Male", "$SSL_Female"))
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoPlayerGender")
	endEvent
endState
state TargetGender
	event OnSelectST()
		ActorLib.TreatAsGender(TargetRef, ActorLib.GetGender(TargetRef) % 2 == 0)
		SetTextOptionValueST(SexLabUtil.StringIfElse(ActorLib.GetGender(TargetRef) % 2 == 0, "$SSL_Male", "$SSL_Female"))
	endEvent
	event OnDefaultST()
		ActorLib.ClearForcedGender(TargetRef)
		SetTextOptionValueST(SexLabUtil.StringIfElse(ActorLib.GetGender(TargetRef) % 2 == 0, "$SSL_Male", "$SSL_Female"))
	endEvent
endState
state UseFade
	event OnMenuOpenST()
		SetMenuDialogStartIndex(Config.UseFade)
		SetMenuDialogDefaultIndex(2)
		SetMenuDialogOptions(FadeOpt)
	endEvent
	event OnMenuAcceptST(int i)
		if i < 0
			i = Config.UseFade
		endIf
		Config.UseFade = i
		SetMenuOptionValueST(FadeOpt[Config.UseFade])
		if Config.UseFade > 0
			if ShowMessage("$SSL_UseFadeTest", true, "$Yes", "$No")
				Utility.Wait(0.1)
				Config.ApplyFade(true)
				Config.RemoveFade(true)
			endIf
		endIf
	endEvent
	event OnDefaultST()
		Config.UseFade = 2
		SetMenuOptionValueST(FadeOpt[Config.UseFade])
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_UseFadeInfo")
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
state RefreshExpressions
	event OnSelectST()
		Config.RefreshExpressions = !Config.RefreshExpressions
		SetToggleOptionValueST(Config.RefreshExpressions)
	endEvent
	event OnDefaultST()
		Config.RefreshExpressions = true
		SetToggleOptionValueST(Config.RefreshExpressions)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoRefreshExpressions")
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
state ShowInMap
	event OnSelectST()
		Config.ShowInMap = !Config.ShowInMap
		SetToggleOptionValueST(Config.ShowInMap)
	endEvent
	event OnDefaultST()
		Config.ShowInMap = false
		SetToggleOptionValueST(Config.ShowInMap)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoShowInMap")
	endEvent
endState
state LimitedStrip
	event OnSelectST()
		Config.LimitedStrip = !Config.LimitedStrip
		SetToggleOptionValueST(Config.LimitedStrip)
	endEvent
	event OnDefaultST()
		Config.LimitedStrip = false
		SetToggleOptionValueST(Config.LimitedStrip)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_LimitedStripInfo")
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
		ForcePageReset()
	endEvent
	event OnDefaultST()
		Config.UseCum = true
		SetToggleOptionValueST(Config.UseCum)
		ForcePageReset()
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
		SetSliderDialogRange(0, 43200)
		SetSliderDialogInterval(10)
	endEvent
	event OnSliderAcceptST(float value)
		Config.CumTimer = value
		SetSliderOptionValueST(Config.CumTimer, "$SSL_Seconds")
	endEvent
	event OnDefaultST()
		Config.CumTimer = 120.0
		SetSliderOptionValueST(Config.CumTimer, "$SSL_Seconds")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoCumTimer")
	endEvent
endState


state OpenMouthSize
	event OnSliderOpenST()
		SetSliderDialogStartValue(Config.OpenMouthSize)
		SetSliderDialogDefaultValue(80)
		SetSliderDialogRange(20, 100)
		SetSliderDialogInterval(1)
	endEvent
	event OnSliderAcceptST(float value)
		Config.OpenMouthSize = value as int
		SetSliderOptionValueST(Config.OpenMouthSize, "{0}%")
	endEvent
	event OnDefaultST()
		Config.OpenMouthSize = 80
		SetSliderOptionValueST(Config.OpenMouthSize, "{0}%")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoOpenMouthSize")
	endEvent
endState

state OrgasmEffects
	event OnSelectST()
		Config.OrgasmEffects = !Config.OrgasmEffects
		SetToggleOptionValueST(Config.OrgasmEffects)
		ForcePageReset()
	endEvent
	event OnDefaultST()
		Config.OrgasmEffects = true
		SetToggleOptionValueST(Config.OrgasmEffects)
		ForcePageReset()
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoOrgasmEffects")
	endEvent
endState
state SeparateOrgasms
	event OnSelectST()
		Config.SeparateOrgasms = !Config.SeparateOrgasms
		SetToggleOptionValueST(Config.SeparateOrgasms)
	endEvent
	event OnDefaultST()
		Config.SeparateOrgasms = false
		SetToggleOptionValueST(Config.SeparateOrgasms)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoSeparateOrgasms")
	endEvent
endState
state RemoveHeelEffect
	event OnSelectST()
		Config.RemoveHeelEffect = !Config.RemoveHeelEffect
		SetToggleOptionValueST(Config.RemoveHeelEffect)
	endEvent
	event OnDefaultST()
		Config.RemoveHeelEffect = Config.HasHDTHeels
		SetToggleOptionValueST(Config.RemoveHeelEffect)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoRemoveHeelEffect")
	endEvent
endState

state AllowCreatures
	event OnSelectST()
		Config.AllowCreatures = !Config.AllowCreatures
		SetToggleOptionValueST(Config.AllowCreatures)
		; Register creature animations if needed
		if !Config.AllowCreatures && CreatureSlots.Slotted > 0
			CreatureSlots.Setup()
		elseIf Config.AllowCreatures && CreatureSlots.Slotted < 1
			CreatureSlots.Setup()
			CreatureSlots.RegisterSlots()
		endIf
	endEvent
	event OnDefaultST()
		Config.AllowCreatures = false
		SetToggleOptionValueST(Config.AllowCreatures)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAllowCreatures")
	endEvent
endState
state UseCreatureGender
	event OnSelectST()
		Config.UseCreatureGender = !Config.UseCreatureGender
		CreatureSlots.ClearAnimCache()
		SetToggleOptionValueST(Config.UseCreatureGender)
	endEvent
	event OnDefaultST()
		if Config.UseCreatureGender
			CreatureSlots.ClearAnimCache()
		endIf
		Config.UseCreatureGender = false
		SetToggleOptionValueST(Config.UseCreatureGender)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoUseCreatureGender")
	endEvent
endState
state AskBed
	event OnSelectST()
		Config.AskBed = sslUtility.IndexTravel(Config.AskBed, 3)
		SetTextOptionValueST(BedOpt[Config.AskBed])
	endEvent
	event OnDefaultST()
		Config.AskBed = 1
		SetTextOptionValueST(BedOpt[Config.AskBed])
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoAskBed")
	endEvent
endState
state NPCBed
	event OnSelectST()
		Config.NPCBed = sslUtility.IndexTravel(Config.NPCBed, 3)
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
state BedRemoveStanding
	event OnSelectST()
		Config.BedRemoveStanding = !Config.BedRemoveStanding
		SetToggleOptionValueST(Config.BedRemoveStanding)
	endEvent
	event OnDefaultST()
		Config.BedRemoveStanding = true
		SetToggleOptionValueST(Config.BedRemoveStanding)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoBedRemoveStanding")
	endEvent
endState
state ForeplayStage
	event OnSelectST()
		Config.ForeplayStage = !Config.ForeplayStage
		SetToggleOptionValueST(Config.ForeplayStage)
		ForcePageReset()
	endEvent
	event OnDefaultST()
		Config.ForeplayStage = true
		SetToggleOptionValueST(Config.ForeplayStage)
		ForcePageReset()
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoForeplayStage")
	endEvent
endState
state LeadInCoolDown
	event OnSliderOpenST()
		SetSliderDialogStartValue(Config.LeadInCoolDown)
		SetSliderDialogDefaultValue(0)
		SetSliderDialogRange(0, 3600)
		SetSliderDialogInterval(30)
	endEvent
	event OnSliderAcceptST(float value)
		Config.LeadInCoolDown = value
		SetSliderOptionValueST(Config.LeadInCoolDown, "$SSL_Seconds")
	endEvent
	event OnDefaultST()
		Config.LeadInCoolDown = 0.0
		SetToggleOptionValueST(Config.LeadInCoolDown, "$SSL_Seconds")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoLeadInCoolDown")
	endEvent
endState
state ScaleActors
	event OnSelectST()
		Config.ScaleActors = !Config.ScaleActors
		SetToggleOptionValueST(Config.ScaleActors)
		if Config.ScaleActors && Config.DisableScale
			Config.DisableScale = false
			SexLabUtil.VehicleFixMode(0)
		endIf
		ForcePageReset()
	endEvent
	event OnDefaultST()
		Config.ScaleActors = false
		SetToggleOptionValueST(Config.ScaleActors)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoScaleActors")
	endEvent
endState
state DisableScale
	event OnSelectST()
		Config.DisableScale = !Config.DisableScale
		SetToggleOptionValueST(Config.DisableScale)
		SexLabUtil.VehicleFixMode((Config.DisableScale as int))
		if Config.DisableScale && Config.ScaleActors
			Config.ScaleActors = false
		endIf
		ForcePageReset()
	endEvent
	event OnDefaultST()
		Config.DisableScale = false
		SexLabUtil.VehicleFixMode(0)
		SetToggleOptionValueST(Config.DisableScale)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoDisableScale")
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
state RestrictSameSex
	event OnSelectST()
		Config.RestrictSameSex = !Config.RestrictSameSex
		SetToggleOptionValueST(Config.RestrictSameSex)
	endEvent
	event OnDefaultST()
		Config.RestrictSameSex = false
		SetToggleOptionValueST(Config.RestrictSameSex)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoRestrictSameSex")
	endEvent
endState
state RestrictGenderTag
	event OnSelectST()
		Config.RestrictGenderTag = !Config.RestrictGenderTag
		SetToggleOptionValueST(Config.RestrictGenderTag)
	endEvent
	event OnDefaultST()
		Config.RestrictGenderTag = false
		SetToggleOptionValueST(Config.RestrictGenderTag)
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoRestrictGenderTag")
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
string[] VoiceNames
state PlayerVoice
	event OnMenuOpenST()
		VoiceNames = VoiceSlots.GetNormalSlotNames(true)
		SetMenuDialogOptions(VoiceNames)
		SetMenuDialogStartIndex(VoiceNames.Find(VoiceSlots.GetSavedName(PlayerRef)))
		SetMenuDialogDefaultIndex(0)
	endEvent
	event OnMenuAcceptST(int i)
		if i < 1
			VoiceSlots.ForgetVoice(PlayerRef)
			SetMenuOptionValueST("$SSL_Random")
		else
			sslBaseVoice Voice = VoiceSlots.GetByName(VoiceNames[i])
			VoiceSlots.SaveVoice(PlayerRef, Voice)
			SetMenuOptionValueST(VoiceNames[i])
			sslThreadController Thread = ThreadSlots.GetActorController(PlayerRef)
			if Thread
				Thread.SetVoice(PlayerRef, Voice)
			endIf
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
		VoiceNames = VoiceSlots.GetNormalSlotNames(true)
		SetMenuDialogOptions(VoiceNames)
		SetMenuDialogStartIndex(VoiceNames.Find(VoiceSlots.GetSavedName(TargetRef)))
		SetMenuDialogDefaultIndex(0)
	endEvent
	event OnMenuAcceptST(int i)
		if i < 1
			VoiceSlots.ForgetVoice(TargetRef)
			SetMenuOptionValueST("$SSL_Random")
		else
			sslBaseVoice Voice = VoiceSlots.GetByName(VoiceNames[i])
			VoiceSlots.SaveVoice(TargetRef, Voice)
			SetMenuOptionValueST(VoiceNames[i])
			sslThreadController Thread = ThreadSlots.GetActorController(TargetRef)
			if Thread
				Thread.SetVoice(TargetRef, Voice)
			endIf
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
		SetSliderOptionValueST((Config.SFXVolume * 100), "{0}%")
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
		SetSliderOptionValueST((Config.VoiceVolume * 100), "{0}%")
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
state ExpressionDelay
	event OnSliderOpenST()
		SetSliderDialogStartValue(Config.ExpressionDelay)
		SetSliderDialogDefaultValue(2)
		SetSliderDialogRange(0.5, 5)
		SetSliderDialogInterval(0.5)
	endEvent
	event OnSliderAcceptST(float value)
		Config.ExpressionDelay = value
		SetSliderOptionValueST(Config.ExpressionDelay, "{1}x")
	endEvent
	event OnDefaultST()
		Config.ExpressionDelay = 2.0
		SetSliderOptionValueST(Config.ExpressionDelay, "{1}x")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoExpressionDelay")
	endEvent
endState
state ShakeStrength
	event OnSliderOpenST()
		SetSliderDialogStartValue(Config.ShakeStrength * 100)
		SetSliderDialogDefaultValue(70)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(5)
	endEvent
	event OnSliderAcceptST(float value)
		Config.ShakeStrength = (value / 100.0)
		SetSliderOptionValueST(value, "{0}%")
	endEvent
	event OnDefaultST()
		Config.ShakeStrength = 0.7
		SetSliderOptionValueST((Config.ShakeStrength * 100), "{0}%")
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoShakeStrength")
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
			SetOptionFlagsST(OPTION_FLAG_DISABLED)
			SetTextOptionValueST("$SSL_Resetting")			
			Config.SetDefaults()
			ShowMessage("$SSL_RunRestoreDefaults", false)
			SetTextOptionValueST("$SSL_ClickHere")
			SetOptionFlagsST(OPTION_FLAG_NONE)
			; ForcePageReset()
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
		SetOptionFlagsST(OPTION_FLAG_DISABLED)
		SetTextOptionValueST("$SSL_Resetting")		
		ThreadSlots.StopAll()
		AnimSlots.Setup()
		CreatureSlots.Setup()
		ShowMessage("$SSL_RunRebuildAnimations", false)
		Debug.Notification("$SSL_RunRebuildAnimations")
		SetTextOptionValueST("$SSL_ClickHere")
		SetOptionFlagsST(OPTION_FLAG_NONE)
		ForcePageReset()
	endEvent
endState
state ResetVoiceRegistry
	event OnSelectST()
		SetOptionFlagsST(OPTION_FLAG_DISABLED)
		SetTextOptionValueST("$SSL_Resetting")		
		VoiceSlots.Setup()
		ShowMessage("$SSL_RunRebuildVoices", false)
		Debug.Notification("$SSL_RunRebuildVoices")
		SetTextOptionValueST("$SSL_ClickHere")
		SetOptionFlagsST(OPTION_FLAG_NONE)
		ForcePageReset()
	endEvent
endState
state ResetExpressionRegistry
	event OnSelectST()
		SetOptionFlagsST(OPTION_FLAG_DISABLED)
		SetTextOptionValueST("$SSL_Resetting")		
		ExpressionSlots.Setup()
		ShowMessage("$SSL_RunRebuildExpressions", false)
		Debug.Notification("$SSL_RunRebuildExpressions")
		SetTextOptionValueST("$SSL_ClickHere")
		SetOptionFlagsST(OPTION_FLAG_NONE)
		ForcePageReset()
	endEvent
endState
state ResetStripOverrides
	event OnSelectST()
		SetOptionFlagsST(OPTION_FLAG_DISABLED)
		SetTextOptionValueST("$SSL_Resetting")		
		ActorLib.ResetStripOverrides()
		ShowMessage("$Done", false)
		SetTextOptionValueST("$SSL_ClickHere")
		SetOptionFlagsST(OPTION_FLAG_NONE)
	endEvent
endState
state ClearNPCSexSkills
	event OnSelectST()
		SetOptionFlagsST(OPTION_FLAG_DISABLED)
		SetTextOptionValueST("$SSL_Resetting")

		Stats.ClearNPCSexSkills()
		
		ShowMessage("$Done", false)
		SetTextOptionValueST("$SSL_ClickHere")
		SetOptionFlagsST(OPTION_FLAG_NONE)
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
			ThreadSlots.StopAll()
			ShowMessage("$SSL_RunCleanSystem", false)
			Utility.Wait(0.1)

			; Setup & clean system
			ResetAllQuests()
			SystemAlias.SetupSystem()

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
			Config.ExportSettings()
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
			Config.ImportSettings()
			ShowMessage("$SSL_RunImportSettings", false)
		endIf
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoImportSettings")
	endEvent
endState

state NeverRegisterDisabled
	event OnSelectST()
		if ShowMessage("$SSL_MessageNeverRegisterDisabled{"+AnimSlots.GetDisabledCount()+"}")

			SetOptionFlagsST(OPTION_FLAG_DISABLED)
			SetTextOptionValueST("$SSL_Resetting")		

			AnimSlots.SuppressDisabled()
			CreatureSlots.SuppressDisabled()

			ThreadSlots.StopAll()
			AnimSlots.Setup()
			CreatureSlots.Setup()
			ShowMessage("$SSL_RunRebuildAnimations", false)
			Debug.Notification("$SSL_RunRebuildAnimations")
			SetTextOptionValueST("$SSL_ClickHere")
			SetOptionFlagsST(OPTION_FLAG_NONE)
		
			ForcePageReset()
		endIf
	endEvent
endState

state ResetNeverRegisters
	event OnSelectST()
		SetOptionFlagsST(OPTION_FLAG_DISABLED)
		SetTextOptionValueST("$SSL_Resetting")		

		AnimSlots.ClearSuppressed()

		ThreadSlots.StopAll()
		AnimSlots.Setup()
		CreatureSlots.Setup()
		ShowMessage("$SSL_RunRebuildAnimations", false)
		Debug.Notification("$SSL_RunRebuildAnimations")
		SetTextOptionValueST("$SSL_ClickHere")
		SetOptionFlagsST(OPTION_FLAG_NONE)

		ForcePageReset()
	endEvent
	event OnHighlightST()
		SetInfoText("$SSL_InfoResetNeverRegisters{"+AnimSlots.GetSuppressedCount()+"}_{"+PapyrusUtil.StringJoin(AnimSlots.GetSuppressedList(), ", ")+"}")
	endEvent
endState




; ------------------------------------------------------- ;
; --- Misc Utilities                                  --- ;
; ------------------------------------------------------- ;

function Log(string Log, string Type = "NOTICE")
	Log = Type+": "+Log
	if Config.DebugMode
		SexLabUtil.PrintConsole(Log)
	endIf
	if Type == "FATAL"
		Debug.TraceStack("SEXLAB - "+Log)
	else
		Debug.Trace("SEXLAB - "+Log)
	endIf
endFunction

function ResetAllQuests()
	bool SaveDebug = Config.DebugMode
	; Reset relevant quests
	ResetQuest(Game.GetFormFromFile(0x00D62, "SexLab.esm") as Quest)
	ResetQuest(Game.GetFormFromFile(0x639DF, "SexLab.esm") as Quest)
	ResetQuest(Game.GetFormFromFile(0x664FB, "SexLab.esm") as Quest)
	ResetQuest(Game.GetFormFromFile(0x78818, "SexLab.esm") as Quest)
	sslThreadController[] Threads = ThreadSlots.Threads
	int i = Threads.Length
	while i
		i -= 1
		ResetQuest(Threads[i])
	endwhile
	Config.DebugMode = SaveDebug
endFunction

function ResetQuest(Quest QuestRef)
	if QuestRef
		while QuestRef.IsStarting()
			Utility.WaitMenuMode(0.1)
		endWhile
		QuestRef.Stop()
		while QuestRef.IsStopping()
			Utility.WaitMenuMode(0.1)
		endWhile
		if !QuestRef.Start()
			QuestRef.Start()
			Log("Failed to start quest!", "ResetQuest("+QuestRef+")")
		endIf
	else
		Log("Invalid quest!", "ResetQuest("+QuestRef+")")
	endIf
endFunction

int function DoDisable(bool check)
	if check
		return OPTION_FLAG_DISABLED
	endIf
	return OPTION_FLAG_NONE
endFunction

function DEPRECATED()
	string log = "SexLab DEPRECATED -- sslConfigMenu.psc -- Use of this property has been deprecated, the mod that called this function should be updated as soon as possible. If you are not the author of this mod, notify them of this error if possible."
	Debug.TraceStack(log, 1)
	if (Game.GetFormFromFile(0xD62, "SexLab.esm") as sslSystemConfig).InDebugMode
		MiscUtil.PrintConsole(log)
	endIf
endFunction
