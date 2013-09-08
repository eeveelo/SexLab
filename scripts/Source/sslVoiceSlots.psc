scriptname sslVoiceSlots extends Quest

sslVoiceDefaults property Defaults auto
sslVoiceLibrary property Lib auto

sslBaseVoice[] Slots
sslBaseVoice[] property Voices hidden
	sslBaseVoice[] function get()
		return Slots
	endFunction
endProperty

string[] registry
int slotted

bool property FreeSlots hidden
	bool function get()
		return slotted < 50
	endFunction
endProperty

;/-----------------------------------------------\;
;|	Search Voices                                |;
;\-----------------------------------------------/;

sslBaseVoice function GetRandom(int gender)
	int[] voiceReturn
	int i
	while i < slotted
		if Slots[i].Registered && Slots[i].Gender == gender && Slots[i].Enabled
			voiceReturn = sslUtility.PushInt(i, voiceReturn)
		endIf
		i += 1
	endWhile
	if voiceReturn.Length == 0
		return none
	endIf
	return Slots[( voiceReturn[( utility.RandomInt(0, voiceReturn.Length - 1) )] )]
endFunction

sslBaseVoice function GetByName(string findName)
	int i
	while i < slotted
		if Slots[i].Registered && Slots[i].name == findName
			return Slots[i]
		endIf
		i += 1
	endWhile
	return none
endFunction

sslBaseVoice function GetByTag(string tag1, string tag2 = "", string tagSuppress = "", bool requireAll = true)
	int i
	while i < slotted
		if Slots[i].Enabled
			bool check1 = Slots[i].HasTag(tag1)
			bool check2 = Slots[i].HasTag(tag2)
			bool supress = Slots[i].HasTag(tagSuppress)
			if requireAll && check1 && (check2 || tag2 == "") && !(supress && tagSuppress != "")
				return Slots[i]
			elseif !requireAll && (check1 || check2) && !(supress && tagSuppress != "")
				return Slots[i]
			endIf
		endIf
		i += 1
	endWhile
	return none
endFunction

sslBaseVoice function GetBySlot(int slot)
	return Slots[slot]
endFunction

;/-----------------------------------------------\;
;|	Locate Voices                                |;
;\-----------------------------------------------/;

int function FindByName(string findName)
	int i
	while i < slotted
		if Slots[i].Registered && Slots[i].Name == findName
			return i
		endIf
		i += 1
	endWhile
	return -1
endFunction

int function FindByRegistrar(string registrar)
	return registry.Find(registrar)
endFunction

int function Find(sslBaseVoice findVoice)
	return Slots.Find(findVoice)
endFunction

;/-----------------------------------------------\;
;|	Manage Voices                                |;
;\-----------------------------------------------/;

sslBaseVoice function GetFree()
	return Slots[slotted]
endFunction

int function Register(sslBaseVoice Claiming, string registrar)
	registry = sslUtility.PushString(registrar, registry)
	slotted = registry.Length
	Claiming.Initialize()
	return Slots.Find(Claiming)
endFunction

int function GetCount(bool ignoreDisabled = true)
	if !ignoreDisabled
		return slotted
	endIf
	int count = 0
	int i = 0
	while i < slotted
		if Slots[i].Registered && Slots[i].Enabled
			count += 1
		endIf
		i += 1
	endWhile
	return count
endFunction

;/-----------------------------------------------\;
;|	System Voices                                |;
;\-----------------------------------------------/;

sslBaseVoice property VoiceSlot000 auto
sslBaseVoice property VoiceSlot001 auto
sslBaseVoice property VoiceSlot002 auto
sslBaseVoice property VoiceSlot003 auto
sslBaseVoice property VoiceSlot004 auto
sslBaseVoice property VoiceSlot005 auto
sslBaseVoice property VoiceSlot006 auto
sslBaseVoice property VoiceSlot007 auto
sslBaseVoice property VoiceSlot008 auto
sslBaseVoice property VoiceSlot009 auto
sslBaseVoice property VoiceSlot010 auto
sslBaseVoice property VoiceSlot011 auto
sslBaseVoice property VoiceSlot012 auto
sslBaseVoice property VoiceSlot013 auto
sslBaseVoice property VoiceSlot014 auto
sslBaseVoice property VoiceSlot015 auto
sslBaseVoice property VoiceSlot016 auto
sslBaseVoice property VoiceSlot017 auto
sslBaseVoice property VoiceSlot018 auto
sslBaseVoice property VoiceSlot019 auto
sslBaseVoice property VoiceSlot020 auto
sslBaseVoice property VoiceSlot021 auto
sslBaseVoice property VoiceSlot022 auto
sslBaseVoice property VoiceSlot023 auto
sslBaseVoice property VoiceSlot024 auto
sslBaseVoice property VoiceSlot025 auto
sslBaseVoice property VoiceSlot026 auto
sslBaseVoice property VoiceSlot027 auto
sslBaseVoice property VoiceSlot028 auto
sslBaseVoice property VoiceSlot029 auto
sslBaseVoice property VoiceSlot030 auto
sslBaseVoice property VoiceSlot031 auto
sslBaseVoice property VoiceSlot032 auto
sslBaseVoice property VoiceSlot033 auto
sslBaseVoice property VoiceSlot034 auto
sslBaseVoice property VoiceSlot035 auto
sslBaseVoice property VoiceSlot036 auto
sslBaseVoice property VoiceSlot037 auto
sslBaseVoice property VoiceSlot038 auto
sslBaseVoice property VoiceSlot039 auto
sslBaseVoice property VoiceSlot040 auto
sslBaseVoice property VoiceSlot041 auto
sslBaseVoice property VoiceSlot042 auto
sslBaseVoice property VoiceSlot043 auto
sslBaseVoice property VoiceSlot044 auto
sslBaseVoice property VoiceSlot045 auto
sslBaseVoice property VoiceSlot046 auto
sslBaseVoice property VoiceSlot047 auto
sslBaseVoice property VoiceSlot048 auto
sslBaseVoice property VoiceSlot049 auto

function _Setup()
	Slots = new sslBaseVoice[50]
	Slots[0] = VoiceSlot000
	Slots[1] = VoiceSlot001
	Slots[2] = VoiceSlot002
	Slots[3] = VoiceSlot003
	Slots[4] = VoiceSlot004
	Slots[5] = VoiceSlot005
	Slots[6] = VoiceSlot006
	Slots[7] = VoiceSlot007
	Slots[8] = VoiceSlot008
	Slots[9] = VoiceSlot009
	Slots[10] = VoiceSlot010
	Slots[11] = VoiceSlot011
	Slots[12] = VoiceSlot012
	Slots[13] = VoiceSlot013
	Slots[14] = VoiceSlot014
	Slots[15] = VoiceSlot015
	Slots[16] = VoiceSlot016
	Slots[17] = VoiceSlot017
	Slots[18] = VoiceSlot018
	Slots[19] = VoiceSlot019
	Slots[20] = VoiceSlot020
	Slots[21] = VoiceSlot021
	Slots[22] = VoiceSlot022
	Slots[23] = VoiceSlot023
	Slots[24] = VoiceSlot024
	Slots[25] = VoiceSlot025
	Slots[26] = VoiceSlot026
	Slots[27] = VoiceSlot027
	Slots[28] = VoiceSlot028
	Slots[29] = VoiceSlot029
	Slots[30] = VoiceSlot030
	Slots[31] = VoiceSlot031
	Slots[32] = VoiceSlot032
	Slots[33] = VoiceSlot033
	Slots[34] = VoiceSlot034
	Slots[35] = VoiceSlot035
	Slots[36] = VoiceSlot036
	Slots[37] = VoiceSlot037
	Slots[38] = VoiceSlot038
	Slots[39] = VoiceSlot039
	Slots[40] = VoiceSlot040
	Slots[41] = VoiceSlot041
	Slots[42] = VoiceSlot042
	Slots[43] = VoiceSlot043
	Slots[44] = VoiceSlot044
	Slots[45] = VoiceSlot045
	Slots[46] = VoiceSlot046
	Slots[47] = VoiceSlot047
	Slots[48] = VoiceSlot048
	Slots[49] = VoiceSlot049

	int i
	while i < Slots.Length
		Slots[i].Initialize()
		i += 1
	endWhile
	
	string[] init
	registry = init
	slotted = 0

	Defaults.LoadVoices()
endFunction