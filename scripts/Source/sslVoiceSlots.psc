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
	; Select valid voices by gender
	bool[] valid = sslUtility.BoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		valid[i] = Slots[i].Registered && Slots[i].Enabled && Slots[i].Gender == gender
	endWhile
	; Pick random index within range
	int pos = valid.Find(true, Utility.RandomInt())


	if count < 1
		return none ; No valid voices found
	endIf
	sslBaseAnimation[] output = sslUtility.AnimationArray(count)
	int pos = valid.Find(true)
	while pos != -1 && pos < valid.Length
		count -= 1
		output[count] = Slots[pos]
		pos = valid.Find(true, (pos + 1))
	endWhile
	return output

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
	int i = 50
	while i
		i -= 1
		Slots[i] = GetNthAlias(i) as sslBaseVoice
		Slots[i].Initialize()
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
