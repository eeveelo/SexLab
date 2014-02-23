scriptname sslVoiceSlots extends Quest

; Library for voice
sslThreadLibrary property Lib auto hidden
sslSystemConfig property Config auto hidden

int property Slotted auto hidden
; Voices readonly storage
sslBaseVoice[] Slots
sslBaseVoice[] property Voices hidden
	sslBaseVoice[] function get()
		return Slots
	endFunction
endProperty

; ------------------------------------------------------- ;
; --- Voice Filtering                                 --- ;
; ------------------------------------------------------- ;

sslBaseVoice function GetRandom(int Gender = 1)
	; Select valid voices by gender
	String List = "Voice.Female"
	if Gender == 0
		List = "Voice.Male"
	endIf
	int Count = StorageUtil.StringListCount(self, List)
	SexLabUtil.Log("GetRandom("+Gender+") - "+Count, List, "NOTICE", "trace,console")
	if Count > 0
		return GetByRegistrar(StorageUtil.StringListGet(self, List, Utility.RandomInt(0, (Count - 1))))
	endIf
	return none
endFunction

; ------------------------------------------------------- ;
; --- Find single voice object                        --- ;
; ------------------------------------------------------- ;

sslBaseVoice function GetByRegistrar(string Registrar)
	int i = FindByRegistrar(Registrar)
	if i != -1
		return Slots[i]
	endIf
	return none
endFunction

; ------------------------------------------------------- ;
; --- System Use Only                                 --- ;
; ------------------------------------------------------- ;

bool function IsRegistered(string Registrar)
	return FindByRegistrar(Registrar) != -1
endFunction

int function FindByRegistrar(string Registrar)
	return StorageUtil.StringListFind(self, "Voice.Registry", Registrar)
endFunction

sslBaseVoice function Register(string Registrar)
	if FindByRegistrar(Registrar) == -1 && Slotted < Slots.Length
		StorageUtil.StringListAdd(self, "Voice.Registry", Registrar, false)
		Slotted = StorageUtil.StringListCount(self, "Voice.Registry")
		return Slots[(Slotted - 1)]
	endIf
	return none
endFunction

function RegisterVoices()
	; Register default animations
	(Quest.GetQuest("SexLabQuestRegistry") as sslVoiceDefaults).LoadVoices()
	; Send mod event for 3rd party animations
	ModEvent.Send(ModEvent.Create("SexLabSlotVoices"))
	Debug.Notification("$SSL_NotifyVoiceInstall")
endFunction

function Setup()
	; Clear Slots
	Slots = new sslBaseVoice[50]
	int i = Slots.Length
	while i
		i -= 1
		Alias BaseAlias = GetNthAlias(i)
		if BaseAlias != none
			Slots[i] = BaseAlias as sslBaseVoice
			Slots[i].Clear()
		endIf
	endWhile
	; Init variables
	Slotted = 0
	StorageUtil.StringListClear(self, "Voice.Registry")
	StorageUtil.StringListClear(self, "Voice.Female")
	StorageUtil.StringListClear(self, "Voice.Male")
	Lib = (Quest.GetQuest("SexLabQuestFramework") as sslThreadLibrary)
	Config = (Quest.GetQuest("SexLabQuestFramework") as sslSystemConfig)
	; Register animations
	RegisterVoices()
endFunction
