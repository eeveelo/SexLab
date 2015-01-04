scriptname sslVoiceSlots extends Quest

import PapyrusUtil
import StorageUtil

; Voices storage
string[] Registry
Alias[] AliasSlots
int property Slotted auto hidden
sslBaseVoice[] property Voices hidden
	sslBaseVoice[] function get()
		return GetSlots(1)
	endFunction
endProperty

; Libraries
sslSystemConfig property Config auto
Actor property PlayerRef auto

; ------------------------------------------------------- ;
; --- Voice Filtering                                 --- ;
; ------------------------------------------------------- ;

sslBaseVoice[] function GetAllGender(int Gender)
	bool[] Valid = Utility.CreateBoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		sslBaseVoice Slot = GetBySlot(i)
		Valid[i] = Slot.Enabled && (Gender == Slot.Gender || Slot.Gender == -1)
	endwhile
	return GetList(Valid)
endFunction

sslBaseVoice function PickGender(int Gender = 1)
	; Get list of valid voices
	bool[] Valid = Utility.CreateBoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		sslBaseVoice Slot = GetBySlot(i)
		Valid[i] = Slot.Enabled && (Gender == Slot.Gender || Slot.Gender == -1)
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
	if Saved && (IsPlayer || Config.NPCSaveVoice)
		return Saved ; Use saved voice
	endIf
	; Pick a random voice based on gender
	sslBaseVoice Picked = PickGender(ActorRef.GetLeveledActorBase().GetSex())
	; Save the voice to NPC for reuse, if enabled
	if Picked && !IsPlayer && Config.NPCSaveVoice
		SaveVoice(ActorRef, Picked)
	endIf
	return Picked
endFunction

sslBaseVoice function GetByTags(string Tags, string TagsSuppressed = "", bool RequireAll = true)
	string[] Search = StringSplit(Tags)
	if Search.Length == 0
		return none
	endIf
	string[] Suppress = StringSplit(TagsSuppressed)
	bool[] Valid = Utility.CreateBoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		sslBaseVoice Slot = GetBySlot(i)
		Valid[i] = Slot.Enabled && (TagsSuppressed == "" || Slot.CheckTags(Suppress, false, true)) && Slot.CheckTags(Search, RequireAll)
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
		Form VoiceQuest = GetFormValue(ActorRef, "SexLab.CustomVoiceQuest")
		string VoiceAlias = GetStringValue(ActorRef, "SexLab.CustomVoiceAlias")
		if VoiceQuest && VoiceAlias != ""
			return (VoiceQuest as Quest).GetAliasByName(VoiceAlias) as sslBaseVoice
		endIf
	endIf
	return GetBySlot(FindSaved(ActorRef))
endFunction

string function GetSavedName(Actor ActorRef)
	if !ActorRef
		return "$SSL_Random"
	endIf
	sslBaseVoice Voice = GetSaved(ActorRef)
	if !Voice
		return "$SSL_Random"
	endIf
	return Voice.Name
endFunction

function SaveVoice(Actor ActorRef, sslBaseVoice Saving)
	if !Saving
		return
	endIf
	ForgetVoice(ActorRef)
	if Registry.Find(Saving.Registry) != -1
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
	sslBaseVoice[] Output
	if Valid.Length > 0 && Valid.Find(true) != -1
		int n = Valid.Find(true)
		int i = CountBool(Valid, true)
		Output = sslUtility.VoiceArray(i)
		while n != -1
			i -= 1
			Output[i] = GetBySlot(n)
			n += 1
			if n < Slotted
				n = Valid.Find(true, n)
			else
				n = -1
			endIf
		endWhile
	endIf
	return Output
endFunction

sslBaseVoice function GetByRegistrar(string Registrar)
	return GetBySlot(FindByRegistrar(Registrar))
endFunction

sslBaseVoice function GetByName(string FindName)
	return GetBySlot(FindByName(FindName))
endFunction

sslBaseVoice function GetBySlot(int index)
	if index >= 0 && index < Slotted
		return AliasSlots[index] as sslBaseVoice
	endIf
	return none
endFunction

sslBaseVoice[] function GetSlots(int page = 1)
	if page > 3 || page < 1
		return sslUtility.VoiceArray(0)
	endIf
	sslBaseVoice[] PageSlots = new sslBaseVoice[125]
	int i = 125
	int n = page * 125
	while i
		i -= 1
		n -= 1
		if AliasSlots[n]
			PageSlots[i] = AliasSlots[n] as sslBaseVoice
		endIf
	endWhile
	return PageSlots
endFunction

int function FindByRegistrar(string Registrar)
	if Registrar != ""
		return Registry.Find(Registrar)
	endIf
	return -1
endFunction

bool function IsRegistered(string Registrar)
	return FindByRegistrar(Registrar) != -1
endFunction

int property PageCount hidden
	int function get()
		return (Slotted / 125) + 1
	endFunction
endProperty

int function FindPage(string Registrar)
	int i = Registry.Find(Registrar)
	if i != -1
		return (i / 125) + 1
	endIf
	return -1
endFunction

int function FindByName(string FindName)
	int i = Slotted
	while i
		i -= 1
		if GetBySlot(i).Name == FindName
			return i
		endIf
	endWhile
	return -1
endFunction

string[] function GetSlotNames(int page = 1)
	return GetNames(GetSlots(page))
endfunction

string[] function GetNames(sslBaseVoice[] SlotList)
	int i = SlotList.Length
	string[] Names = Utility.CreateStringArray(i)
	while i
		i -= 1
		if SlotList[i]
			Names[i] = SlotList[i].Name
		endIf
	endWhile
	if Names.Find("") != -1
		Names = PapyrusUtil.RemoveString(Names, "")
	endIf
	return Names
endFunction

sslBaseVoice function RegisterVoice(string Registrar, Form CallbackForm = none, ReferenceAlias CallbackAlias = none)
	; Return existing Voice
	if FindByRegistrar(Registrar) != -1
		return GetbyRegistrar(Registrar)
	endIf
	; Get free Voice slot
	int id = Register(Registrar)
	sslBaseVoice Slot = GetBySlot(id)
	if id != -1 && Slot != none
		Slot.Initialize()
		Slot.Registry = Registrar
		Slot.Enabled  = true
		sslObjectFactory.SendCallback(Registrar, id, CallbackForm, CallbackAlias)
	endIf
	return Slot
endFunction

; ------------------------------------------------------- ;
; --- System Use Only                                 --- ;
; ------------------------------------------------------- ;

function Setup()
	GoToState("Locked")
	; Init slots
	Slotted   = 0
	Registry   = Utility.CreateStringArray(375)
	AliasSlots = Utility.CreateAliasArray(375, GetNthAlias(0))

	; DEV TEMP: SKSE Beta workaround - clear used dummy aliases
	int i = AliasSlots.Length
	while i
		i -= 1
		AliasSlots[i] = none
	endWhile

	; Init Libraries
	PlayerRef = Game.GetPlayer()
	Config    = Game.GetFormFromFile(0xD62, "SexLab.esm") as sslSystemConfig
	; Init defaults
	RegisterSlots()
	; RegisterCreatureVoices()
	GoToState("")
endFunction

function RegisterSlots()
	; Register default voices
	(Game.GetFormFromFile(0x664FB, "SexLab.esm") as sslVoiceDefaults).LoadVoices()
	; Send mod event for 3rd party voices
	ModEvent.Send(ModEvent.Create("SexLabSlotVoices"))
	Debug.Notification("$SSL_NotifyVoiceInstall")
endFunction

int function Register(string Registrar)
	if Registry.Find(Registrar) != -1 || Slotted >= Registry.Length
		return -1
	endIf
	Slotted += 1
	int i = Registry.Find("")
	Registry[i]   = Registrar
	AliasSlots[i] = GetNthAlias(i)
	return i
endFunction

bool function TestSlots()
	return true;PlayerRef && Config && Slotted > 0 && Registry.Length == 100 && Slots1.Length == 100 && Slots1.Find(none) > 0 && Registry.Find("") > 0
endFunction

state Locked
	function Setup()
	endFunction
endState

; function RegisterCreatureVoices()
; 	VoiceType CV
; 	; Falmer
; 	CV = Game.GetForm(0x1F1D2) as VoiceType
; 	AddCreatureVoice(CV, Game.GetForm(0x6B955) as Topic) ; Hit
; 	AddCreatureVoice(CV, Game.GetForm(0x67595) as Topic) ; Death
; endFunction

; function AddCreatureVoice(VoiceType Creature, Topic VoiceTopic)
; 	StorageUtil.FormListAdd(Creature, "SexLabVoices", VoiceTopic, false)
; endFunction

; Topic function GetCreatureVoice(VoiceType Creature)
; 	int i = StorageUtil.FormListCount(Creature, "SexLabVoices")
; 	if i > 0
; 		return StorageUtil.FormListGet(Creature, "SexLabVoices", Utility.RandomInt(0, (i - 1))) as Topic
; 	endIf
; 	return none
; endFunction
