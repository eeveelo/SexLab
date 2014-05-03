scriptname sslVoiceSlots extends Quest

import sslUtility
import StorageUtil

; Voices storage
int property Slotted auto hidden
string[] Registry

sslBaseVoice[] Slots
sslBaseVoice[] property Voices hidden
	sslBaseVoice[] function get()
		return Slots
	endFunction
endProperty

; Libraries
sslSystemConfig Config
Actor PlayerRef

; ------------------------------------------------------- ;
; --- Voice Filtering                                 --- ;
; ------------------------------------------------------- ;

sslBaseVoice[] function GetAllGender(int Gender)
	bool[] Valid = BoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		Valid[i] = Slots[i].Enabled && (Gender == Slots[i].Gender || Slots[i].Gender == -1)
	endwhile
	return GetList(Valid)
endFunction

sslBaseVoice function PickGender(int Gender = 1)
	; Get list of valid voices
	bool[] Valid = BoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		Valid[i] = Slots[i].Enabled && (Gender == Slots[i].Gender || Slots[i].Gender == -1)
	endwhile
	; Select a random true in the list
	i = Utility.RandomInt(0, (Slotted - 1))
	int Slot = Valid.Find(true, i)
	if Slot == -1
		Slot = Valid.RFind(true, i)
	endIf
	return GetbySlot(Slot)
endFunction

sslBaseVoice function PickVoice(Actor ActorRef)
	bool IsPlayer = ActorRef == PlayerRef
	; Find if a saved voice exists and in what slot
	sslBaseVoice Saved = GetSaved(ActorRef)
	if Saved != none && (IsPlayer || Config.NPCSaveVoice)
		return Saved ; Use saved voice
	endIf
	; Pick a random voice based on gender
	sslBaseVoice Picked = PickGender(ActorRef.GetLeveledActorBase().GetSex())
	; Save the voice to NPC for reuse, if enabled
	if Picked != none && !IsPlayer && Config.NPCSaveVoice
		SaveVoice(ActorRef, Picked)
	endIf
	return Picked
endFunction

sslBaseVoice function GetByTags(string Tags, string TagsSuppressed = "", bool RequireAll = true)
	string[] Search = ArgString(Tags)
	if Search.Length == 0
		return none
	endIf
	string[] Suppress = ArgString(TagsSuppressed)
	bool[] Valid = BoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		Valid[i] = Slots[i].Enabled && (TagsSuppressed == "" || Slots[i].CheckTags(Suppress, false, true)) && Slots[i].CheckTags(Search, RequireAll)
	endWhile
	sslBaseVoice[] Found = GetList(Valid)
	int r = Utility.RandomInt(0, (Found.Length - 1))
	return Found[r]
endFunction

int function FindSaved(Actor ActorRef)
	return FindByRegistrar(GetStringValue(ActorRef, "SexLab.SavedVoice", ""))
endFunction

sslBaseVoice function GetSaved(Actor ActorRef)
	if HasCustomVoice(ActorRef)
		form QuestForm = GetFormValue(ActorRef, "SexLab.CustomVoiceQuest")
		string AliasName = GetStringValue(ActorRef, "SexLab.CustomVoiceAlias")
		if QuestForm != none && AliasName != ""
			return (QuestForm as Quest).GetAliasByName(AliasName) as sslBaseVoice
		endIf
	endIf
	return GetBySlot(FindSaved(ActorRef))
endFunction

string function GetSavedName(Actor ActorRef)
	if ActorRef == none
		return "$SSL_Random"
	endIf
	sslBaseVoice Voice = GetSaved(ActorRef)
	if Voice == none
		return "$SSL_Random"
	endIf
	return Voice.Name
endFunction

function SaveVoice(Actor ActorRef, sslBaseVoice Saving)
	ForgetVoice(ActorRef)
	if Slots.Find(Saving) != -1
		; Voice is a default one from this script
		SetStringValue(ActorRef, "SexLab.SavedVoice", Saving.Registry)
	else
		; Voice is a custom one from another quest/script
		SetFormValue(ActorRef, "SexLab.CustomVoiceQuest", Saving.GetOwningQuest())
		SetStringValue(ActorRef, "SexLab.CustomVoiceAlias", Saving.GetName())
	endIf
endFunction

function ForgetVoice(Actor ActorRef)
	; Local default voices
	UnsetStringValue(ActorRef, "SexLab.SavedVoice")
	; Custom voice
	UnsetFormValue(ActorRef, "SexLab.CustomVoiceQuest")
	UnsetStringValue(ActorRef, "SexLab.CustomVoiceAlias")
endFunction

bool function HasCustomVoice(Actor ActorRef)
	return HasFormValue(ActorRef, "SexLab.CustomVoiceQuest") && HasStringValue(ActorRef, "SexLab.CustomVoiceAlias")
endFunction

; ------------------------------------------------------- ;
; --- Slotting Common                                 --- ;
; ------------------------------------------------------- ;

sslBaseVoice[] function GetList(bool[] Valid)
	int i = CountTrue(Valid)
	if i == 0
		return none ; OR empty array?
	endIf
	string Found
	sslBaseVoice[] Output = VoiceArray(i)
	int pos = Valid.Find(true)
	while pos != -1
		i -= 1
		Output[i] = Slots[pos]
		pos += 1
		if pos < Slotted
			pos = Valid.Find(true, pos)
		else
			pos = -1
		endIf
		Found += Output[i].Name+", "
	endWhile
	SexLabUtil.DebugLog("Found Voices("+Output.Length+"): "+Found, "", Config.DebugMode)
	return Output
endFunction

sslBaseVoice function GetByRegistrar(string Registrar)
	return GetBySlot(FindByRegistrar(Registrar))
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

int function FindByRegistrar(string Registrar)
	if Registrar == ""
		return -1
	endIf
	return Registry.Find(Registrar)
endFunction

bool function IsRegistered(string Registrar)
	return FindByRegistrar(Registrar) != -1
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

sslBaseVoice function RegisterVoice(string Registrar, Form CallbackForm = none, ReferenceAlias CallbackAlias = none)
	; Return existing Voice
	if FindByRegistrar(Registrar) != -1
		return GetbyRegistrar(Registrar)
	endIf
	; Get free Voice slot
	int id = Register(Registrar)
	if id != -1
		; Get slot
		sslBaseVoice Slot = GetNthAlias(id) as sslBaseVoice
		Voices[id] = Slot
		; Init Voice
		Slot.Initialize()
		Slot.Registry = Registrar
		Slot.Enabled = true
		; Send load event
		sslObjectFactory.SendCallback(Registrar, id, CallbackForm, CallbackAlias)
	endIf
endFunction

; ------------------------------------------------------- ;
; --- System Use Only                                 --- ;
; ------------------------------------------------------- ;

function Setup()
	GoToState("Locked")
	; Init slots
	Slotted = 0
	Registry = new string[100]
	Slots = new sslBaseVoice[100]
	; Init Libraries
	SexLabFramework SexLab = Quest.GetQuest("SexLabQuestFramework") as SexLabFramework
	PlayerRef = SexLab.PlayerRef
	Config    = SexLab.Config
	; Init defaults
	RegisterSlots()
	GoToState("")
endFunction

function RegisterSlots()
	; Register default voices
	(Quest.GetQuest("SexLabQuestRegistry") as sslVoiceDefaults).LoadVoices()
	; Send mod event for 3rd party voices
	ModEvent.Send(ModEvent.Create("SexLabSlotVoices"))
	Debug.Notification("$SSL_NotifyVoiceInstall")
endFunction

int function Register(string Registrar)
	int i = Registry.Find("")
	if Registry.Find(Registrar) == -1 && i != -1
		Registry[i] = Registrar
		Slotted = i + 1
		return i
	endIf
	return -1
endFunction

state Locked
	function Setup()
	endFunction
endState
