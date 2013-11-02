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
int property Slotted auto hidden

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

function _Setup()
	Slots = new sslBaseVoice[50]
	int i
	while i < 50
		if i < 10
			Slots[i] = GetAliasByName("VoiceSlot00"+i) as sslBaseVoice
		else
			Slots[i] = GetAliasByName("VoiceSlot0"+i) as sslBaseVoice
		endIf
		Slots[i].Initialize()
		i += 1
	endWhile
	Initialize()
	Defaults.LoadVoices()
	SendModEvent("SexLabSlotVoices")
	Debug.Notification("$SSL_NotifyVoiceInstall")
endFunction

function Initialize()
	string[] init
	registry = init
	Slotted = 0
endFunction
