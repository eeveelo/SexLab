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

event OnPageReset(string page)
	LoadCustomContent("SexLab/logo.dds", 184, 31)
endEvent

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
