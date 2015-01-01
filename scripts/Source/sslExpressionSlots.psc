scriptname sslExpressionSlots extends Quest

import PapyrusUtil
import StorageUtil

; Expression storage
string[] Registry
int property Slotted auto hidden
sslBaseExpression[] Slots
sslBaseExpression[] Slots2
sslBaseExpression[] Slots3
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
	elseIf VictimRef && ActorRef != VictimRef
		Tag = "Aggressor"
	else
		Tag = "Normal"
	endIf
	bool IsFemale = ActorRef.GetLeveledActorBase().GetSex() == 1
	bool[] Valid = Utility.CreateBoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		sslBaseExpression Slot = GetBySlot(i)
		Valid[i] = Slot.Registered && Slot.HasTag(Tag) && ((IsFemale && Slot.PhasesFemale > 0) || (!IsFemale && Slot.PhasesMale > 0))
	endWhile
	return SelectRandom(Valid)
endFunction

sslBaseExpression function RandomByTag(string Tag)
	bool[] Valid = Utility.CreateBoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		sslBaseExpression Slot = GetBySlot(i)
		Valid[i] = Slot.Registered && Slot.HasTag(Tag)
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
	sslBaseExpression[] Output
	if Valid.Length > 0 && Valid.Find(true) != -1
		int n = Valid.Find(true)
		int i = CountBool(Valid, true)
		Output = sslUtility.ExpressionArray(i)
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

sslBaseExpression function GetByRegistrar(string Registrar)
	return GetBySlot(FindByRegistrar(Registrar))
endFunction

sslBaseExpression function GetByName(string FindName)
	return GetBySlot(FindByName(FindName))
endFunction

sslBaseExpression function GetBySlot(int index)
	if index < 0 || index >= Slotted
		return none
	elseif index < 125
		return Slots[index]
	elseif index < 250
		return Slots2[(index - 125)]
	elseif index < 375
		return Slots3[(index - 250)]
	endIf
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
		if Slotted < 125
			return 1
		elseIf Slotted < 250
			return 2
		elseIf Slotted < 375
			return 3
		endIf
		return 1
	endFunction
endProperty

int function FindPage(string Registrar)
	int i = Registry.Find(Registrar)
	if i < 0
		return -1
	elseIf i < 125
		return 1
	elseIf i < 250
		return 2
	elseIf i < 375
		return 3
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

string[] function GetSlotNames(int SlotsPage)
	if SlotsPage == 2
		return GetNames(Slots2)
	elseIf SlotsPage == 3
		return GetNames(Slots3)
	endIf
	return GetNames(Slots)
endfunction

string[] function GetNames(sslBaseExpression[] SlotList)
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

sslBaseExpression function RegisterExpression(string Registrar, Form CallbackForm = none, ReferenceAlias CallbackAlias = none)
	; Return existing Expression
	if FindByRegistrar(Registrar) != -1
		return GetbyRegistrar(Registrar)
	endIf
	; Get free Expression slot
	int id = Register(Registrar)
	sslBaseExpression Slot = GetBySlot(id)
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
	Slotted  = 0
	Registry = Utility.CreateStringArray(350)
	Slots    = new sslBaseExpression[125]
	Slots2   = new sslBaseExpression[1]
	Slots3   = new sslBaseExpression[1]
	; Init defaults
	RegisterSlots()
	GoToState("")
endFunction

function RegisterSlots()
	; Register default Expressions
	(Game.GetFormFromFile(0x664FB, "SexLab.esm") as sslExpressionDefaults).LoadExpressions()
	; Send mod event for 3rd party Expressions
	ModEvent.Send(ModEvent.Create("SexLabSlotExpressions"))
	Debug.Notification("$SSL_NotifyExpressionInstall")
endFunction

int function Register(string Registrar)
	int i = Registry.Find("")
	if i != -1 && Registry.Find(Registrar) == -1
		Registry[i] = Registrar
		Slotted = i + 1
		if i < 125
			Slots[i]  = GetNthAlias(i) as sslBaseExpression
		elseIf i < 250
			if Slots2.Length != 125
				Slots2 = new sslBaseExpression[125]
			endIf
			Slots2[(i - 125)] = GetNthAlias(i) as sslBaseExpression
		elseIf i < 375
			if Slots3.Length != 125
				Slots3 = new sslBaseExpression[125]
			endIf
			Slots3[(i - 250)] = GetNthAlias(i) as sslBaseExpression
		endIf
		return i
	endIf
	return -1
endFunction

bool function TestSlots()
	return Slotted > 0 && Registry.Length == 100 && Slots.Length == 100 && Slots.Find(none) > 0 && Registry.Find("") > 0
endFunction

state Locked
	function Setup()
	endFunction
endState
