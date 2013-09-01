scriptname sslVoiceRegistry extends Quest

sslBaseVoice[] Registry
sslBaseVoice[] property Voices hidden
	sslBaseVoice[] function get()
		return Registry
	endFunction
endProperty
Scene[] AnimationSlots
bool locked

topic property SexLabMoanMild auto
topic property SexLabMoanMedium auto
topic property SexLabMoanHot auto

VoiceType property SexLabVoiceM auto
VoiceType property SexLabVoiceF auto
FormList property VoicesPlayer auto

actor property PlayerRef auto
sslSystemConfig property Config auto

;/-----------------------------------------------\;
;|	Search Animations                            |;
;\-----------------------------------------------/;
sslBaseVoice function PickVoice(actor a)
	if a == PlayerRef && Config.sPlayerVoice != "$SSL_Random"
		return GetByName(Config.sPlayerVoice)
	else
		return GetByGender(a.GetLeveledActorBase().GetSex())
	endIf
endFunction

sslBaseVoice function GetByGender(int g)
	int[] voiceReturn
	int i = 0
	while i < Registry.Length
		if Registry[i].Slotted && Registry[i].Gender == g && Registry[i].Enabled
			voiceReturn = sslUtility.PushInt(i, voiceReturn)
		endIf
		i += 1
	endWhile
	if voiceReturn.Length == 0
		return none
	endIf
	return Registry[(utility.RandomInt(0, voiceReturn.Length - 1))]
endFunction

sslBaseVoice function GetByName(string findName)
	int i = 0
	while i < Registry.Length
		if Registry[i].Slotted && Registry[i].name == findName
			return Registry[i]
		endIf
		i += 1
	endWhile
	return none
endFunction

sslBaseVoice function GetByTag(string tag1, string tag2 = "", string tagSuppress = "", bool requireAll = true)
	int i = 0
	while i < Registry.Length
		if Registry[i].Enabled
			bool check1 = Registry[i].HasTag(tag1)
			bool check2 = Registry[i].HasTag(tag2)
			bool supress = Registry[i].HasTag(tagSuppress)
			if requireAll && check1 && (check2 || tag2 == "") && !(supress && tagSuppress != "")
				return Registry[i]
			elseif !requireAll && (check1 || check2) && !(supress && tagSuppress != "")
				return Registry[i]
			endIf
		endIf
		i += 1
	endWhile
	return none
endFunction

sslBaseVoice function GetBySlot(int slot)
	return Registry[slot]
endFunction

int function GetFreeSlot()
	int i = 0
	while i < Registry.Length
		if !Registry[i].Slotted
			return i
		endIf
		i += 1
	endWhile
	return -1
endFunction

;/-----------------------------------------------\;
;|	Locate Animations                            |;
;\-----------------------------------------------/;

int function FindByName(string findName)
	int i = 0
	while i < Registry.Length
		if Registry[i].Slotted && Registry[i].Name == findName
			return i
		endIf
		i += 1
	endWhile
	return -1
endFunction


int function FindByRegistrar(string id)
	int i = 0
	while i < Registry.Length
		if Registry[i].Slotted && Registry[i].Registrar == id
			return i
		endIf
		i += 1
	endWhile
	return -1
endFunction

;/-----------------------------------------------\;
;|	Manage Animations                            |;
;\-----------------------------------------------/;

int function GetCount(bool ignoreDisabled = true)
	int count = 0
	int i = 0
	while i < Registry.Length
		if Registry[i].Slotted && ((ignoreDisabled && Registry[i].Enabled) || !ignoreDisabled)
			count += 1
		endIf
		i += 1
	endWhile
	return count
endFunction

;/-----------------------------------------------\;
;|	System Animations                            |;
;\-----------------------------------------------/;

sslBaseVoice property SexLabVoiceSlot000 auto
sslBaseVoice property SexLabVoiceSlot001 auto
sslBaseVoice property SexLabVoiceSlot002 auto
sslBaseVoice property SexLabVoiceSlot003 auto
sslBaseVoice property SexLabVoiceSlot004 auto
sslBaseVoice property SexLabVoiceSlot005 auto
sslBaseVoice property SexLabVoiceSlot006 auto
sslBaseVoice property SexLabVoiceSlot007 auto
sslBaseVoice property SexLabVoiceSlot008 auto
sslBaseVoice property SexLabVoiceSlot009 auto
sslBaseVoice property SexLabVoiceSlot010 auto
sslBaseVoice property SexLabVoiceSlot011 auto
sslBaseVoice property SexLabVoiceSlot012 auto
sslBaseVoice property SexLabVoiceSlot013 auto
sslBaseVoice property SexLabVoiceSlot014 auto
sslBaseVoice property SexLabVoiceSlot015 auto
sslBaseVoice property SexLabVoiceSlot016 auto
sslBaseVoice property SexLabVoiceSlot017 auto
sslBaseVoice property SexLabVoiceSlot018 auto
sslBaseVoice property SexLabVoiceSlot019 auto
sslBaseVoice property SexLabVoiceSlot020 auto
sslBaseVoice property SexLabVoiceSlot021 auto
sslBaseVoice property SexLabVoiceSlot022 auto
sslBaseVoice property SexLabVoiceSlot023 auto
sslBaseVoice property SexLabVoiceSlot024 auto
sslBaseVoice property SexLabVoiceSlot025 auto
sslBaseVoice property SexLabVoiceSlot026 auto
sslBaseVoice property SexLabVoiceSlot027 auto
sslBaseVoice property SexLabVoiceSlot028 auto
sslBaseVoice property SexLabVoiceSlot029 auto
sslBaseVoice property SexLabVoiceSlot030 auto
sslBaseVoice property SexLabVoiceSlot031 auto
sslBaseVoice property SexLabVoiceSlot032 auto
sslBaseVoice property SexLabVoiceSlot033 auto
sslBaseVoice property SexLabVoiceSlot034 auto
sslBaseVoice property SexLabVoiceSlot035 auto
sslBaseVoice property SexLabVoiceSlot036 auto
sslBaseVoice property SexLabVoiceSlot037 auto
sslBaseVoice property SexLabVoiceSlot038 auto
sslBaseVoice property SexLabVoiceSlot039 auto
sslBaseVoice property SexLabVoiceSlot040 auto
sslBaseVoice property SexLabVoiceSlot041 auto
sslBaseVoice property SexLabVoiceSlot042 auto
sslBaseVoice property SexLabVoiceSlot043 auto
sslBaseVoice property SexLabVoiceSlot044 auto
sslBaseVoice property SexLabVoiceSlot045 auto
sslBaseVoice property SexLabVoiceSlot046 auto
sslBaseVoice property SexLabVoiceSlot047 auto
sslBaseVoice property SexLabVoiceSlot048 auto
sslBaseVoice property SexLabVoiceSlot049 auto

function _Setup()
	Registry = new sslBaseVoice[50]
	Registry[0] = SexLabVoiceSlot000
	Registry[1] = SexLabVoiceSlot001
	Registry[2] = SexLabVoiceSlot002
	Registry[3] = SexLabVoiceSlot003
	Registry[4] = SexLabVoiceSlot004
	Registry[5] = SexLabVoiceSlot005
	Registry[6] = SexLabVoiceSlot006
	Registry[7] = SexLabVoiceSlot007
	Registry[8] = SexLabVoiceSlot008
	Registry[9] = SexLabVoiceSlot009
	Registry[10] = SexLabVoiceSlot010
	Registry[11] = SexLabVoiceSlot011
	Registry[12] = SexLabVoiceSlot012
	Registry[13] = SexLabVoiceSlot013
	Registry[14] = SexLabVoiceSlot014
	Registry[15] = SexLabVoiceSlot015
	Registry[16] = SexLabVoiceSlot016
	Registry[17] = SexLabVoiceSlot017
	Registry[18] = SexLabVoiceSlot018
	Registry[19] = SexLabVoiceSlot019
	Registry[20] = SexLabVoiceSlot020
	Registry[21] = SexLabVoiceSlot021
	Registry[22] = SexLabVoiceSlot022
	Registry[23] = SexLabVoiceSlot023
	Registry[24] = SexLabVoiceSlot024
	Registry[25] = SexLabVoiceSlot025
	Registry[26] = SexLabVoiceSlot026
	Registry[27] = SexLabVoiceSlot027
	Registry[28] = SexLabVoiceSlot028
	Registry[29] = SexLabVoiceSlot029
	Registry[30] = SexLabVoiceSlot030
	Registry[31] = SexLabVoiceSlot031
	Registry[32] = SexLabVoiceSlot032
	Registry[33] = SexLabVoiceSlot033
	Registry[34] = SexLabVoiceSlot034
	Registry[35] = SexLabVoiceSlot035
	Registry[36] = SexLabVoiceSlot036
	Registry[37] = SexLabVoiceSlot037
	Registry[38] = SexLabVoiceSlot038
	Registry[39] = SexLabVoiceSlot039
	Registry[40] = SexLabVoiceSlot040
	Registry[41] = SexLabVoiceSlot041
	Registry[42] = SexLabVoiceSlot042
	Registry[43] = SexLabVoiceSlot043
	Registry[44] = SexLabVoiceSlot044
	Registry[45] = SexLabVoiceSlot045
	Registry[46] = SexLabVoiceSlot046
	Registry[47] = SexLabVoiceSlot047
	Registry[48] = SexLabVoiceSlot048
	Registry[49] = SexLabVoiceSlot049

	int i
	while i < Registry.Length
		Registry[i].InitializeVoice()
		i += 1
	endWhile

	_Load()
endFunction


sslVoiceDefaults property Defaults auto
function _Load()
	Defaults.LoadVoices()
	Debug.Notification("Registered SexLab Voices: "+GetCount(false))
endFunction
