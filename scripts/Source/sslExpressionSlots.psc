scriptname sslExpressionSlots extends Quest

import StorageUtil

; Expression storage
int property Slotted auto hidden
string[] Registry

sslBaseExpression[] Slots
sslBaseExpression[] property Expressions hidden
	sslBaseExpression[] function get()
		return Slots
	endFunction
endProperty

; ------------------------------------------------------- ;
; --- Expression Filtering                            --- ;
; ------------------------------------------------------- ;

sslBaseExpression function PickExpression(Actor ActorRef, Actor VictimRef = none)
	string Tag
	if ActorRef == VictimRef
		Tag = "Victim"
	elseIf VictimRef != none && ActorRef != VictimRef
		Tag = "Aggressor"
	else
		Tag = "Normal"
	endIf
	bool IsFemale = ActorRef.GetLeveledActorBase().GetSex() == 1
	bool[] Valid = sslUtility.BoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		Valid[i] = Slots[i].Registered && Slots[i].HasTag(Tag) && ((IsFemale && Slots[i].PhasesFemale > 0) || (!IsFemale && Slots[i].PhasesMale > 0))
	endWhile
	return SelectRandom(Valid)
endFunction

sslBaseExpression function RandomByTag(string Tag)
	bool[] Valid = sslUtility.BoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		Valid[i] = Slots[i].Registered && Slots[i].HasTag(Tag)
	endWhile
	return SelectRandom(Valid)
endFunction

sslBaseExpression function SelectRandom(bool[] Valid)
	int i = Utility.RandomInt(0, (Slotted - 1))
	int Slot = Valid.Find(true, i)
	if Slot == -1
		Slot = Valid.RFind(true, i)
	endIf
	return GetbySlot(Slot)
endFunction

; ------------------------------------------------------- ;
; --- Slotting Common                                 --- ;
; ------------------------------------------------------- ;

sslBaseExpression[] function GetList(bool[] Valid)
	return none
endFunction

sslBaseExpression function GetByRegistrar(string Registrar)
	return GetBySlot(FindByRegistrar(Registrar))
endFunction

sslBaseExpression function GetByName(string FindName)
	return GetBySlot(FindByName(FindName))
endFunction

sslBaseExpression function GetBySlot(int index)
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

string[] function GetNames()
	string[] Output = sslUtility.StringArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		Output[i] = Slots[i].Name
	endWhile
	return Output
endFunction

sslBaseExpression function RegisterExpression(string Registrar, Form CallbackForm = none, ReferenceAlias CallbackAlias = none)
	; Return existing Expression
	if FindByRegistrar(Registrar) != -1
		return GetbyRegistrar(Registrar)
	endIf
	; Get free Expression slot
	int id = Register(Registrar)
	if id != -1
		; Get slot
		sslBaseExpression Slot = GetNthAlias(id) as sslBaseExpression
		Expressions[id] = Slot
		; Init Expression
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
	Registry = new string[40]
	Slots = new sslBaseExpression[40]
	; Init defaults
	RegisterSlots()
	GoToState("")
endFunction

function RegisterSlots()
	; Register default Expressions
	(Quest.GetQuest("SexLabQuestRegistry") as sslExpressionDefaults).LoadExpressions()
	; Send mod event for 3rd party Expressions
	ModEvent.Send(ModEvent.Create("SexLabSlotExpressions"))
	Debug.Notification("$SSL_NotifyExpressionInstall")
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
