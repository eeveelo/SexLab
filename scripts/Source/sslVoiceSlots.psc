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
	; SexLabUtil.Log("GetRandom("+Gender+") - "+Count, List, "NOTICE", "trace,console")
	if Count > 0
		return GetByRegistrar(StorageUtil.StringListGet(self, List, Utility.RandomInt(0, (Count - 1))))
	endIf
	return none
endFunction

sslBaseVoice function PickVoice(Actor ActorRef)
	bool IsPlayer = ActorRef == Lib.PlayerRef
	; Find if a saved voice exists and in what slot
	sslBaseVoice Saved = GetSaved(ActorRef)
	if Saved != none
		if !Config.bNPCSaveVoice && !IsPlayer
			; They have a saved voice, but NPC saved voices is disabled
			ForgetVoice(ActorRef)
		else
			return Saved ; Use the saved voice
		endIf
	endIf
	; Pick a random voice based on gender
	sslBaseVoice Picked = GetRandom(ActorRef.GetLeveledActorBase().GetSex())
	; Save the voice to NPC for reuse, if enabled
	if Picked != none && !IsPlayer && Config.bNPCSaveVoice
		SaveVoice(ActorRef, Picked)
	endIf
	return Picked
endFunction

sslBaseVoice function GetByTags(string Tags, string TagsSuppressed = "", bool RequireAll = true)
	string[] Search = sslUtility.ArgString(Tags)
	if Search.Length == 0
		return none
	endIf
	string[] Suppress = sslUtility.ArgString(TagsSuppressed)
	bool[] Valid = sslUtility.BoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		Valid[i] = Slots[i].Enabled && (TagsSuppressed == "" || Slots[i].CheckTags(Suppress, false, true)) && Slots[i].CheckTags(Search, RequireAll)
	endWhile
	sslBaseVoice[] Found = GetList(valid)
	int r = Utility.RandomInt(0, (Found.Length - 1))
	return Found[r]
endFunction

sslBaseVoice function GetByRegistrar(string Registrar)
	int i = FindByRegistrar(Registrar)
	if i != -1
		return Slots[i]
	endIf
	return none
endFunction

int function FindByName(string FindName)
	int i = Slotted
	while i
		i -= 1
		if Slots[i].Name == FindName
			return i
		endIf
	endWhile
	return -1
endFunction

sslBaseVoice function GetByName(string FindName)
	return GetBySlot(FindByName(FindName))
endFunction

sslBaseVoice function GetBySlot(int index)
	if index < 0 || index >= Slotted
		return none
	endIf
	return Slots[index]
endFunction

sslBaseVoice function GetSaved(Actor ActorRef)
	return GetByRegistrar(StorageUtil.GetStringValue(ActorRef, "SexLab.SavedVoice", ""))
endFunction

string function GetSavedName(Actor ActorRef)
	sslBaseVoice Voice = GetSaved(ActorRef)
	if Voice == none || !Voice.Registered
		return "$SSL_Random"
	endIf
	return Voice.Name
endFunction

function SaveVoice(Actor ActorRef, sslBaseVoice Saving)
	StorageUtil.SetStringValue(ActorRef, "SexLab.SavedVoice", Saving.Registry)
endFunction

function ForgetVoice(Actor ActorRef)
	StorageUtil.UnsetStringValue(ActorRef, "SexLab.SavedVoice")
endFunction

; ------------------------------------------------------- ;
; --- System Use Only                                 --- ;
; ------------------------------------------------------- ;

sslBaseVoice[] function GetList(bool[] Valid)
	int i = sslUtility.CountTrue(Valid)
	if i == 0
		return none ; OR empty array?
	endIf
	string Found
	sslBaseVoice[] Output = sslUtility.VoiceArray(i)
	int pos = Valid.Find(true)
	while pos != -1 && pos < Slotted
		i -= 1
		Output[i] = Slots[pos]
		pos = Valid.Find(true, (pos + 1))
		Found += Output[i].Name+", "
	endWhile
	Lib.Log("Found Voices("+Output.Length+"): "+Found)
	return Output
endFunction

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
