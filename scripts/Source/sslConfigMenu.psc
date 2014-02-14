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
	_SetupSystem()
	; Init Stats
	; Stats._Setup()
endEvent

event OnGameReload()
	parent.OnGameReload()
	; Config.ValidActorList.RemoveAddedForm(PlayerRef)
	AudioVoice.SetVolume(Config.fVoiceVolume)
	AudioSFX.SetVolume(Config.fSFXVolume)
	; ThreadSlots._StopAll()
endEvent

; Framework
SexLabFramework property SexLab auto
sslSystemConfig property Config auto
sslThreadSlots property ThreadSlots auto
sslAnimationSlots property AnimSlots auto

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
	Config._Defaults()

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
	if PlayerRef.GetLeveledActorBase().GetSex() > 0
		Pages[11] = "$SSL_SexDiary"
	else
		Pages[11] = "$SSL_SexJournal"
	endIf
	Pages[12] = "$SSL_RebuildClean"

	; FindStrapons()
endFunction

event OnPageReset(string page)
	LoadCustomContent("SexLab/logo.dds", 184, 31)
endEvent


function _SetupSystem()
	_CheckSystem()

	; AnimSlots = (Quest.GetQuest("SexLabQuestAnimations") as sslAnimationSlots)

	; SexLab._EnableSystem(false)
	; Init Defaults
	SetDefaults()
	; Init animations
	; AnimLib._Setup()
	AnimSlots.Setup()
	; ; Init creature animations
	; CreatureAnimSlots._Setup()
	; ; Init voices
	; Config._Setup()
	; VoiceSlots._Setup()
	; ; Init expressions
	; ExpressionLib._Setup()
	; ExpressionSlots._Setup()
	; ; Init Alias Slots
	; Config._Setup()
	; ActorSlots._Setup()
	; ; Init control Library
	;Config._Setup()
	; ; Init Thread Controllers
	; Config._Setup()
	ThreadSlots.Setup()
	; ; Init Sexlab
	; SexLab._Setup()

	; Finished
	Debug.Notification("$SSL_SexLabUpdated")
endFunction

function _CheckSystem()
	; Check SKSE Version
	float skseNeeded = 1.0616
	float skseInstalled = SKSE.GetVersion() + SKSE.GetVersionMinor() * 0.01 + SKSE.GetVersionBeta() * 0.0001
	if skseInstalled == 0
		NoSKSE.Show()
		; SexLab._EnableSystem(false)
	elseif skseInstalled < skseNeeded
		OldSKSE.Show(skseInstalled, skseNeeded)
		; SexLab._EnableSystem(false)
	endIf
	; Check Skyrim Version
	float skyrimNeeded = 1.9
	float skyrimMajor = StringUtil.SubString(Debug.GetVersionNumber(), 0, 3) as float
	if skyrimMajor < skyrimNeeded
		OldSkyrim.Show(skyrimMajor, skyrimNeeded)
		; SexLab._EnableSystem(false)
	endIf
endFunction
