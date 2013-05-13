scriptname sslSystemConfig extends SKI_ConfigBase
{Skyrim Sex Lab Mod Configuration Menu}

int function GetVersion()
	return 4
endFunction

; Resources
SexLabFramework property SexLab auto

; Config Settings
bool property bRestrictAggressive auto hidden
int oidRestrictAggressive
bool property bEnableTCL auto hidden
int oidEnableTCL
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
string property sNPCBed auto hidden
int oidNPCBed
bool property bUseMaleNudeSuit auto hidden
int oidUseMaleNudeSuit
bool property bUseFemaleNudeSuit auto hidden
int oidUseFemaleNudeSuit
float[] property fStageTimer auto hidden
int[] oidStageTimer
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
int property kRestoreOffsets auto hidden
int oidRestoreOffsets
bool[] property bStripMale auto hidden
int[] oidStripMale
bool[] property bStripFemale auto hidden
int[] oidStripFemale
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
	bEnableTCL = false
	bScaleActors = true
	bAllowFFCum = false
	fCumTimer = 120.0
	sPlayerVoice = "Random"
	bUseStrapons = true
	bAutoAdvance = true
	bDisablePlayer = true
	bReDressVictim = true
	sNPCBed = "Never"
	bUseMaleNudeSuit = false
	bUseFemaleNudeSuit = false

	fMaleVoiceDelay = 7.0
	fFemaleVoiceDelay = 6.0
	fSFXDelay = 4.0
	fVoiceVolume = 0.7
	fSFXVolume = 0.8

	; Controls Page
	kBackwards = 54 ; Right Shift
	kAdvanceAnimation = 57 ; Space
	kChangeAnimation =  24 ; O
	kChangePositions = 38 ; L
	kAdjustChange = 37 ; K
	kAdjustForward = 39 ; ;
	kAdjustSideways = 40 ; '
	kAdjustUpward = 0 ;  Not used
	kRealignActors = 26 ; [
	kRestoreOffsets = 27 ; ]

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
	bStripMale[22] = true
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
	bStripFemale[22] = true
	bStripFemale[23] = true
	bStripFemale[24] = true
	bStripFemale[26] = true
	bStripFemale[27] = true
	bStripFemale[28] = true
	bStripFemale[29] = true
	bStripFemale[32] = true

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
	bStripVictim[22] = true
	bStripVictim[24] = true
	bStripVictim[26] = true
	bStripVictim[28] = true
	bStripVictim[32] = true

	bStripAggressor[2] = true
	bStripAggressor[4] = true
	bStripAggressor[9] = true
	bStripAggressor[16] = true
	bStripAggressor[22] = true
	bStripAggressor[24] = true
	bStripAggressor[26] = true

	fStageTimer = new float[5]
	oidStageTimer = new int[5]

	fStageTimer[0] = 30.0
	fStageTimer[1] = 20.0
	fStageTimer[2] = 15.0
	fStageTimer[3] = 15.0
	fStageTimer[4] = 5.0

	fStageTimerAggr = new float[5]
	oidStageTimerAggr = new int[5]

	fStageTimerAggr[0] = 20.0
	fStageTimerAggr[1] = 15.0
	fStageTimerAggr[2] = 10.0
	fStageTimerAggr[3] = 10.0
	fStageTimerAggr[4] = 3.0

	SexLab.Data.FindStrapons()
	oidRemoveStrapon = new int[10]

	sPureTitles = new string[7]
	sPureTitles[0] = "Neutral"
	sPureTitles[1] = "Unsullied"
	sPureTitles[3] = "Virtuous"
	sPureTitles[4] = "Ever Faithful"
	sPureTitles[6] = "Saintly"

	sImpureTitles = new string[7]
	sImpureTitles[0] = "Neutral"
	sImpureTitles[1] = "Experimenting"
	sImpureTitles[2] = "Unusually Horny"
	sImpureTitles[3] = "Promiscuous"
	sImpureTitles[4] = "Sexual Deviant"

	sStatTitles = new string[7]
	sStatTitles[0] = "Unskilled"
	sStatTitles[1] = "Novice"
	sStatTitles[2] = "Apprentice"
	sStatTitles[3] = "Journeyman"
	sStatTitles[4] = "Expert"
	sStatTitles[5] = "Master"
	sStatTitles[6] = "Grand Master"

	Pages = new string[10]
	Pages[0] = "Animation Settings"
	Pages[1] = "Player Hotkeys"
	Pages[2] = "Stage Timers"
	Pages[3] = "Male/Female Stripping"
	Pages[4] = "Victim/Aggressor Stripping"
	Pages[5] = "Toggle Voices"
	Pages[6] = "Toggle Animations"
	Pages[7] = "Aggressive Animations"
	Pages[9] = "Rebuild & Clean"

	if SexLab.PlayerRef.GetLeveledActorBase().GetSex() > 0
		Pages[8] = "Sex Diary"
		sPureTitles[2] = "Prim & Proper"
		sPureTitles[5] = "Ladylike"
		sImpureTitles[5] = "Debaucherous"
		sImpureTitles[6] = "Nymphomaniac"
	else
		Pages[8] = "Sex Journal"
		sPureTitles[2] = "Clean Cut"
		sPureTitles[5] = "Lordly"
		sImpureTitles[5] = "Depraved"
		sImpureTitles[6] = "Hypersexual"
	endIf
endFunction

event OnConfigInit()
	;Game.GetPlayer().AddSpell(SexLab.Data.SexLabDebugSpell, true)
	SetDefaults()
endEvent

event OnVersionUpdate(int version)
	if CurrentVersion > 0 && !SexLab._CheckClean()
		SexLab.Data.mDirtyUpgrade.Show(CurrentVersion, version)
	endIf

	; Rev 4
	if version >= 4 && CurrentVersion < 4
		SetDefaults()
	endIf
endEvent

event OnPageReset(string page)
	int i = 0

	if page == ""
		LoadCustomContent("SexLab/logo.dds", 184, 31)
		return
	else
		UnloadCustomContent()
	endIf

	if page == "Animation Settings"
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("Global Settings")
		oidRestrictAggressive = AddToggleOption("Restrict Aggressive Animations", bRestrictAggressive)
		oidScaleActors = AddToggleOption("Even Actors Height", bScaleActors)
		oidEnableTCL = AddToggleOption("Toggle Collisions For Player", bEnableTCL)
		oidReDressVictim = AddToggleOption("Victim's Re-dress", bReDressVictim)
		oidNPCBed = AddTextOption("NPCs Use Beds", sNPCBed)
		oidUseCum = AddToggleOption("Apply Cum Effects", bUseCum)
		oidAllowFFCum = AddToggleOption("Allow Female/Female Cum", bAllowFFCum)
		oidCumTimer = AddSliderOption("Cum Effect Timer", fCumTimer, "{0} seconds")
		oidUseStrapons = AddToggleOption("Females Use Strapons", bUseStrapons)
		oidUseMaleNudeSuit = AddToggleOption("Use Nude Suit For Males", bUseMaleNudeSuit)
		oidUseFemaleNudeSuit = AddToggleOption("Use Nude Suit For Females", bUseFemaleNudeSuit)

		SetCursorPosition(1)
		AddHeaderOption("Player Settings")
		oidAutoAdvance = AddToggleOption("Auto Advance Stages", bAutoAdvance)
		oidDisablePlayer = AddToggleOption("Disable Victim Controls", bDisablePlayer)
		AddEmptyOption()
		AddHeaderOption("Sounds/Voices")
		oidPlayerVoice = AddTextOption("PC Voice", sPlayerVoice)
		oidVoiceVolume = AddSliderOption("Voice Volume", fVoiceVolume, "{2}")
		oidMaleVoiceDelay = AddSliderOption("Male Voice Delay", fMaleVoiceDelay, "{0} seconds")
		oidFemaleVoiceDelay = AddSliderOption("Female Voice Delay", fFemaleVoiceDelay, "{0} seconds")
		oidSFXVolume = AddSliderOption("SFX Volume", fSFXVolume, "{2}")
		oidSFXDelay = AddSliderOption("SFX Delay", fSFXDelay, "{0} seconds")
		

	elseIf page == "Player Hotkeys"
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("Animation Adjustments")
		oidBackwards = AddKeyMapOption("Reverse Direction Modifier", kBackwards)

		oidAdvanceAnimation = AddKeyMapOption("Advance Animation Stage", kAdvanceAnimation)
		oidChangeAnimation = AddKeyMapOption("Change Animation Set", kChangeAnimation)
		oidChangePositions = AddKeyMapOption("Swap Actor Positions", kChangePositions)

		oidAdjustChange = AddKeyMapOption("Change Actor to Adjust", kAdjustChange)
		oidAdjustForward = AddKeyMapOption("Adjust Position - Forward/Backward", kAdjustForward)
		oidAdjustSideways = AddKeyMapOption("Adjust Position - Left/Right", kAdjustSideways)
		;oidAdjustUpward = AddKeyMapOption("Adjust Position - Upward/Downward", kAdjustUpward)
		oidRealignActors = AddKeyMapOption("Re-Position Actors", kRealignActors)
		oidRestoreOffsets = AddKeyMapOption("Delete Saved Adjustments", kRestoreOffsets)


	elseIf page == "Stage Timers"
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("Consensual Animation Timers")
		oidStageTimer[0] = AddSliderOption("Stage 1 Length", fStageTimer[0], "{0} seconds")
		oidStageTimer[1] = AddSliderOption("Stage 2 Length", fStageTimer[1], "{0} seconds")
		oidStageTimer[2] = AddSliderOption("Stage 3 Length", fStageTimer[2], "{0} seconds")
		oidStageTimer[3] = AddSliderOption("Stage 4+ Length", fStageTimer[3], "{0} seconds")
		oidStageTimer[4] = AddSliderOption("Stage Ending Length", fStageTimer[4], "{0} seconds")

		SetCursorPosition(1)
		AddHeaderOption("Aggressive Animation Timers")
		oidStageTimerAggr[0] = AddSliderOption("Stage 1 Length", fStageTimerAggr[0], "{0} seconds")
		oidStageTimerAggr[1] = AddSliderOption("Stage 2 Length", fStageTimerAggr[1], "{0} seconds")
		oidStageTimerAggr[2] = AddSliderOption("Stage 3 Length", fStageTimerAggr[2], "{0} seconds")
		oidStageTimerAggr[3] = AddSliderOption("Stage 4+ Length", fStageTimerAggr[3], "{0} seconds")
		oidStageTimerAggr[4] = AddSliderOption("Stage Ending Length", fStageTimerAggr[4], "{0} seconds")

	elseIf page == "Male/Female Stripping"
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption("Male: Strip From")
		oidStripMale[32] = AddToggleOption("Weapons", bStripMale[32])
		i = 0
		while i < 32
			int slot = i + 30
			string name = GetSlotName(slot)
			if name != "IGNORE"
				oidStripMale[i] = AddToggleOption(name, bStripMale[i])
			endIf
			if slot == 43
				AddHeaderOption("Extra Slots, not always accurately labeled")
			endIf
			i += 1
		endWhile

		SetCursorPosition(1)
		AddHeaderOption("Female: Strip From")
		oidStripFemale[32] = AddToggleOption("Weapons", bStripFemale[32])
		i = 0
		while i < 32
			int slot = i + 30
			string name = GetSlotName(slot)
			if name != "IGNORE"
				oidStripFemale[i] = AddToggleOption(name, bStripFemale[i])
			endIf
			if slot == 43
				AddHeaderOption("Extra Slots, not always accurately labeled")
			endIf
			i += 1
		endWhile
	elseIf page == "Victim/Aggressor Stripping"
		SetCursorFillMode(TOP_TO_BOTTOM)

		AddHeaderOption("Victim: Strip From")
		oidStripVictim[32] = AddToggleOption("Weapons", bStripVictim[32])
		i = 0
		while i < 32
			int slot = i + 30
			string name = GetSlotName(slot)
			if name != "IGNORE"
				oidStripVictim[i] = AddToggleOption(name, bStripVictim[i])
			endIf
			if slot == 43
				AddHeaderOption("Extra Slots, not always accurately labeled")
			endIf
			i += 1
		endWhile

		SetCursorPosition(1)
		AddHeaderOption("Aggressor: Strip From")
		oidStripAggressor[32] = AddToggleOption("Weapons", bStripAggressor[32])
		i = 0
		while i < 32
			int slot = i + 30
			string name = GetSlotName(slot)
			if name != "IGNORE"
				oidStripAggressor[i] = AddToggleOption(name, bStripAggressor[i])
			endIf
			if slot == 43
				AddHeaderOption("Extra Slots, not always accurately labeled")
			endIf
			i += 1
		endWhile
	elseIf page == "Toggle Animations"
		SetCursorFillMode(LEFT_TO_RIGHT)
		i = 0
		while i < SexLab.animation.Length
			if SexLab.animation[i] != none
				oidToggleAnimation[i] = AddToggleOption(SexLab.animation[i].name, SexLab.animation[i].enabled)
			endIf
			i += 1
		endWhile
	elseIf page == "Aggressive Animations"
		SetCursorFillMode(LEFT_TO_RIGHT)
		i = 0
		while i < SexLab.animation.Length
			if SexLab.animation[i] != none
				oidAggrAnimation[i] = AddToggleOption(SexLab.animation[i].name, SexLab.animation[i].HasTag("Aggressive"))
			endIf
			i += 1
		endWhile
	elseIf page == "Toggle Voices"
		SetCursorFillMode(LEFT_TO_RIGHT)
		i = 0
		while i < SexLab.voice.Length
			if SexLab.voice[i] != none
				oidToggleVoice[i] = AddToggleOption(SexLab.voice[i].name, SexLab.voice[i].enabled)
			endIf
			i += 1
		endWhile
	elseIf page == "Sex Diary" || page == "Sex Journal"
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("Sexual Experience")
		int full = SexLab.Data.fTimeSpent as int
		int seconds = full % 60
		int minutes = Math.Floor((full / 60) % 60)
		int hours = Math.Floor(full / 3600)
		AddTextOption("Time Spent Having Sex", hours+":"+minutes+":"+seconds)
		AddTextOption("Male Sexual Partners", SexLab.Data.iMalePartners)
		AddTextOption("Female Sexual Partners", SexLab.Data.iFemalePartners)
		AddTextOption("Times Masturbated", SexLab.Data.iMasturbationCount)
		AddTextOption("Vaginal Experience", SexLab.Data.iVaginalCount)
		AddTextOption("Anal Experience", SexLab.Data.iAnalCount)
		AddTextOption("Oral Experience", SexLab.Data.iOralCount)
		AddTextOption("Times Victim", SexLab.Data.iVictimCount)
		AddTextOption("Times Aggressive", SexLab.Data.iAggressorCount)

		SetCursorPosition(1)
		AddHeaderOption("Sexual Stats")
		AddTextOption("Sexuality", SexLab.GetPlayerSexuality())
		if SexLab.GetPlayerPurityLevel() < 0
			AddTextOption("Sexual Perversion", SexLab.GetPlayerPurityTitle())
		else
			AddTextOption("Sexual Purity", SexLab.GetPlayerPurityTitle())
		endIf
		AddTextOption("Vaginal Proficiency", SexLab.GetPlayerStatTitle("Vaginal"))
		AddTextOption("Anal Proficiency", SexLab.GetPlayerStatTitle("Anal"))
		AddTextOption("Oral Proficiency", SexLab.GetPlayerStatTitle("Oral"))

	elseIf page == "Rebuild & Clean"
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("Maintenance")
		oidStopAnimations = AddTextOption("Stop Current Animations", "Click Here")
		oidRestoreDefaults = AddTextOption("Restore Default Settings", "Click Here")
		oidRebuildAnimations = AddTextOption("Clear Animation Registry", "Click Here")
		oidRebuildVoices = AddTextOption("Clear Voice Registry", "Click Here")
		oidResetStats = AddTextOption("Reset Player Sex Stats", "Click Here")
		AddEmptyOption()
		AddHeaderOption("Upgrade/Uninstall/Reinstall")
		oidCleanSystem = AddTextOption("Clean System", "Click Here")
		AddEmptyOption()
		AddHeaderOption("Latest Version Available @ LoversLab.com")

		SetCursorPosition(1)
		AddHeaderOption("Available Strapons")
		oidFindStrapons = AddTextOption("Rebuild Strapon List", "Click Here")
		i = 0
		while i < SexLab.Data.strapons.Length
			if SexLab.Data.strapons[i] != none
				if SexLab.Data.strapons[i].GetName() == "strapon"
					oidRemoveStrapon[i] = AddTextOption("Aeon/Horker", "Remove")
				else
					oidRemoveStrapon[i] = AddTextOption(SexLab.Data.strapons[i].GetName(), "Remove")
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
		SetSliderOptionValue(oidCumTimer, fCumTimer, "{0} Seconds")

	elseIf option == oidMaleVoiceDelay
		fMaleVoiceDelay = value
		SetSliderOptionValue(oidMaleVoiceDelay, fMaleVoiceDelay, "{0} Seconds")

	elseIf option == oidFemaleVoiceDelay
		fFemaleVoiceDelay = value
		SetSliderOptionValue(oidFemaleVoiceDelay, fFemaleVoiceDelay, "{0} Seconds")

	elseIf option == oidVoiceVolume
		fVoiceVolume = value
		SetSliderOptionValue(oidVoiceVolume, fVoiceVolume, "{2}")

	elseIf option == oidSFXVolume
		fSFXVolume = value
		SetSliderOptionValue(oidSFXVolume, fSFXVolume, "{2}")

	elseIf option == oidSFXDelay
		fSFXDelay = value
		SetSliderOptionValue(oidSFXDelay, fSFXDelay, "{0} Seconds")

	elseIf option == oidStageTimer[0]
		fStageTimer[0] = value
		SetSliderOptionValue(oidStageTimer[0], fStageTimer[0], "{0} Seconds")
	elseIf option == oidStageTimer[1]
		fStageTimer[1] = value
		SetSliderOptionValue(oidStageTimer[1], fStageTimer[1], "{0} Seconds")
	elseIf option == oidStageTimer[2]
		fStageTimer[2] = value
		SetSliderOptionValue(oidStageTimer[2], fStageTimer[2], "{0} Seconds")
	elseIf option == oidStageTimer[3]
		fStageTimer[3] = value
		SetSliderOptionValue(oidStageTimer[3], fStageTimer[3], "{0} Seconds")
	elseIf option == oidStageTimer[4]
		fStageTimer[4] = value
		SetSliderOptionValue(oidStageTimer[4], fStageTimer[4], "{0} Seconds")

	elseIf option == oidStageTimerAggr[0]
		fStageTimerAggr[0] = value
		SetSliderOptionValue(oidStageTimerAggr[0], fStageTimerAggr[0], "{0} Seconds")
	elseIf option == oidStageTimerAggr[1]
		fStageTimerAggr[1] = value
		SetSliderOptionValue(oidStageTimerAggr[1], fStageTimerAggr[1], "{0} Seconds")
	elseIf option == oidStageTimerAggr[2]
		fStageTimerAggr[2] = value
		SetSliderOptionValue(oidStageTimerAggr[2], fStageTimerAggr[2], "{0} Seconds")
	elseIf option == oidStageTimerAggr[3]
		fStageTimerAggr[3] = value
		SetSliderOptionValue(oidStageTimerAggr[3], fStageTimerAggr[3], "{0} Seconds")
	elseIf option == oidStageTimerAggr[4]
		fStageTimerAggr[4] = value
		SetSliderOptionValue(oidStageTimerAggr[4], fStageTimerAggr[4], "{0} Seconds")
	endIf
endEvent

event OnOptionSelect(int option)
	{Called when the user selects a non-dialog option}

	; Settings
	if option == oidRestrictAggressive
		bRestrictAggressive = !bRestrictAggressive 
		SetToggleOptionValue(option, bRestrictAggressive)

	elseif option == oidEnableTCL
		bEnableTCL = !bEnableTCL 
		SetToggleOptionValue(option, bEnableTCL)

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

	elseif option == oidNPCBed
		if sNPCBed == "Never"
			sNPCBed = "Sometimes"
		elseif sNPCBed == "Sometimes"
			sNPCBed = "Always"
		else
			sNPCBed = "Never"
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
			ShowMessage("Found and saved "+found+" strapons for use", false)
		else
			ShowMessage("Found no supported strapon mods", false)
		endIf
		ForcePageReset()
	elseif option == oidStopAnimations
		ShowMessage("All currently running animations are now halting.", false)
		SexLab._StopAnimations()

	elseif option == oidCleanSystem
		bool run = ShowMessage("Running this will disable SexLab, stop all animations, and clear the animation and voice registeries. It is suggested you run this when upgrading, uninstalling, or reinstalling the mod. Do you want to continue?")
		if run
			ShowMessage("Close all menus and return to the game to begin the cleaning process.", false)
			SexLab._CleanSystem()
		endIf

	elseif option == oidRebuildAnimations
		bool run = ShowMessage("Running this will uninstall all animations registered with SexLab, requiring you to reload your game in order to reinstall them. Do you want to continue?")
		if run
			SexLab._StopAnimations()
			SexLab._ClearAnimations()
			ShowMessage("Animation registry cleared, save and reload your game to reinstall any animations present.", false)
		endIf

	elseif option == oidRebuildVoices
		bool run = ShowMessage("Running this will uninstall all voices registered with SexLab, requiring you to reload your game in order to reinstall them. Do you want to continue?")
		if run
			SexLab._ClearVoices()
			ShowMessage("Voice registry cleared, save and reload your game to reinstall any voices present.", false)
		endIf

	elseif option == oidResetStats
		bool run = ShowMessage("Running this will reset all your experience and stats saved in your Sex Diary/Journal. Do you want to continue?")
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
			ShowMessage("Your Sex Diary/Journal has been reset.", false)
		endIf

	elseif option == oidRestoreDefaults
		bool run = ShowMessage("Restore SexLab's settings to default?")
		if run
			SetDefaults()			
			ShowMessage("Defaults restored.", false)
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
			sPlayerVoice = "Random"
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
		SetInfoText("Animations marked aggressive will only show in victim/aggressor animations")
	elseIf option == oidUseCum
		SetInfoText("Apply a cum effect to female characters after sex with a male")
	elseIf option == oidAllowFFCum
		SetInfoText("Apply a cum effect to female characters after sex even if with another female")
	elseIf option == oidCumTimer
		SetInfoText("How long the above cum effect will display on a character")
	elseIf option == oidUseStrapons
		SetInfoText("Females will use strapons when in a male context")
	elseIf option == oidAutoAdvance
		SetInfoText("Animations will not automatically advance by timer when player is involved")
	elseIf option == oidDisablePlayer
		SetInfoText("When player is the victim in an animation animation controls are not enabled")
	elseIf option == oidReDressVictim
		SetInfoText("Victims in animations will not automatically dress after the animation ends")
	elseIf option == oidNPCBed
		SetInfoText("How often animations not involving the player will opt to use a nearby bed")
	elseIf option == oidUseMaleNudeSuit
		SetInfoText("Males will equip a nude appearing outfit instead of using their normal nude model")
	elseIf option == oidUseFemaleNudeSuit
		SetInfoText("Females will equip a nude appearing outfit instead of using their normal nude model")
	elseIf option == oidBackwards
		SetInfoText("Will make many of the other hotkeys go backwards when used with this key")
	elseIf option == oidAdvanceAnimation
		SetInfoText("Forces the current animation to advance to it's next stage")
	elseIf option == oidChangeAnimation
		SetInfoText("Cycle through list of animation sets available to the current animation process")
	elseIf option == oidChangePositions
		SetInfoText("Swap adjusted character with another character in the animation")
	elseIf option == oidRealignActors
		SetInfoText("Reposition all characters in the animation according to their saved offsets")
	elseIf option == oidAdjustChange
		SetInfoText("Change which character you are adjusting within the animation")
	elseIf option == oidRestoreOffsets
		SetInfoText("Revert the current animations adjustments to their default setting")
	elseIf option == oidAdjustForward
		SetInfoText("Move adjusted character forward or backward when modifier key is also held")
	elseIf option == oidAdjustSideways
		SetInfoText("Move adjusted character left or right depending on if modifier key is also held")
	elseIf option == oidAdjustUpward
		SetInfoText("Move adjusted character up or down when modifier key is also held")
	elseIf option == oidPlayerVoice
		SetInfoText("The player character will always use this voice")
	elseIf option == oidMaleVoiceDelay
		SetInfoText("Male's will start out voicing at this interval and will decrease with each stage")
	elseIf option == oidFemaleVoiceDelay
		SetInfoText("Female's will start out voicing at this interval and will decrease with each stage")
	elseIf option == oidSFXDelay
		SetInfoText("Applicable sound effects will start out at this interval and will decrease with each stage")
	elseIf option == oidVoiceVolume
		SetInfoText("The overall volume of the voices from 0.0 as silent to 1.0 as full volume")
	elseIf option == oidSFXVolume
		SetInfoText("The overall volume of the SFX from 0.0 as silent to 1.0 as full volume")
	elseIf option == oidEnableTCL
		SetInfoText("Collisions will be toggled automatically when the player is involved, helps align player but can cause other problems")
	elseIf option == oidScaleActors
		SetInfoText("Actors will scale to the average height between them during animation, greatly helps many animations line up properly")
	else
		; What are we?
		int i = 0
		while i < 128
			if option == oidToggleVoice[i]
				SetInfoText("Enable the voice "+SexLab.voice[i].name+" for selection")
				i = 128
			elseif option == oidToggleAnimation[i]
				SetInfoText("Enable the animation "+SexLab.animation[i].name+" for selection")
				i = 128
			elseif option == oidAggrAnimation[i]
				SetInfoText("Use the animation "+SexLab.animation[i].name+" in victim/aggressor animations")
				i = 128
			elseIf i < 33 && option == oidStripMale[i]
				if i != 32
					SetInfoText("Remove armor/clothing covering a male's bipped slot #"+(i + 30)+" during consensual animations")
				else
					SetInfoText("Disarm the male's of weapons during consensual animations")
				endIf
				i = 128
			elseIf i < 33 && option == oidStripFemale[i]
				if i != 32
					SetInfoText("Remove armor/clothing covering a female's bipped slot #"+(i + 30)+" during consensual animations")
				else
					SetInfoText("Disarm female's of weapons during consensual animations")
				endIf
				i = 128
			elseIf i < 33 && option == oidStripVictim[i]
				if i != 32
					SetInfoText("Remove armor/clothing covering the victim's bipped slot #"+(i + 30)+" during aggressive animations")
				else
					SetInfoText("Disarm the victim of weapons during aggressive animations")
				endIf
				i = 128
			elseIf i < 33 && option == oidStripAggressor[i]
				if i != 32
					SetInfoText("Remove armor/clothing covering a females bipped slot #"+(i + 30)+" during aggressive animations")
				else
					SetInfoText("Disarm the aggressor of weapons during aggressive animations")
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
		return "Head "
	elseif slot == 31
		return "Hair"
	elseif slot == 32
		return "Torso "
	elseif slot == 33
		return "Hands"
	elseif slot == 34
		return "Forearms"
	elseif slot == 35
		return "Amulet"
	elseif slot == 36
		return "Ring "
	elseif slot == 37
		return "Feet"
	elseif slot == 38
		return "Calves"
	elseif slot == 39
		return "Shield "
	elseif slot == 40
		return "Tail "
	elseif slot == 41
		return "Long Hair"
	elseif slot == 42
		return "Circlet"
	elseif slot == 43
		return "Ears"
	elseif slot == 44
		return "Face/Mouth"
	elseif slot == 45
		return "Neck"
	elseif slot == 46
		return "Chest "
	elseif slot == 47
		return "Back"
	elseif slot == 48
		return "Misc"
	elseif slot == 49
		return "Pelvis/Outergarnments"
	elseif slot == 50
		return "IGNORE" ; decapitated head [NordRace]
	elseif slot == 51
		return "IGNORE" ; decapitate [NordRace]
	elseif slot == 52
		return "Pelvis/Undergarnments"
	elseif slot == 53
		return "Legs/Right Leg"
	elseif slot == 54
		return "Legs/Left Leg"
	elseif slot == 55
		return "Face/Jewelry"
	elseif slot == 56
		return "Chest/Undergarnments"
	elseif slot == 57
		return "Shoulders"
	elseif slot == 58
		return "Arms/Left Arm/Undergarnments"
	elseif slot == 59
		return "Arms/Right Arm/Outergarnments"
	elseif slot == 60
		return "Misc Slot"
	elseif slot == 61
		return "Misc Slot"
	elseif slot == 62
		return "Weapons"
	else
		return "Unknown"
	endIf
endFunction

