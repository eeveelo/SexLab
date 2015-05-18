scriptname sslExpressionSlots extends Quest

import PapyrusUtil
import StorageUtil

; Expression storage
Alias[] Objects
string[] Registry
int property Slotted auto hidden
sslBaseExpression[] property Expressions hidden
	sslBaseExpression[] function get()
		return GetSlots(1)
	endFunction
endProperty


; Libraries
sslSystemConfig property Config auto
Actor property PlayerRef auto

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
	bool[] Valid  = Utility.CreateBoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		sslBaseExpression Slot = Objects[i] as sslBaseExpression
		Valid[i] = Slot.Registered && Slot.HasTag(Tag) && ((IsFemale && Slot.PhasesFemale > 0) || (!IsFemale && Slot.PhasesMale > 0))
	endWhile
	return SelectRandom(Valid)
endFunction

sslBaseExpression function RandomByTag(string Tag)
	bool[] Valid = Utility.CreateBoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		sslBaseExpression Slot = Objects[i] as sslBaseExpression
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
		; Trim over 100 to random selection
		if i > 100
			int end = Valid.RFind(true) - 1
			while i > 100
				int rand = Valid.Find(true, Utility.RandomInt(n, end))
				if rand != -1 && Valid[rand]
					Valid[rand] = false
					i -= 1
				endIf
			endWhile
		endIf
		; Get list
		Output = sslUtility.ExpressionArray(i)
		while n != -1
			i -= 1
			Output[i] = Objects[n] as sslBaseExpression
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

; ------------------------------------------------------- ;
; --- Registry Access                                     ;
; ------------------------------------------------------- ;

sslBaseExpression function GetBySlot(int index)
	if index >= 0 && index < Slotted
		return Objects[index] as sslBaseExpression
	endIf
	return none
endFunction

bool function IsRegistered(string Registrar)
	return FindByRegistrar(Registrar) != -1
endFunction

int function FindByRegistrar(string Registrar)
	if Registrar != ""
		return Registry.Find(Registrar)
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

sslBaseExpression function GetByName(string FindName)
	return GetBySlot(FindByName(FindName))
endFunction

sslBaseExpression function GetbyRegistrar(string Registrar)
	return GetBySlot(FindByRegistrar(Registrar))
endFunction

; ------------------------------------------------------- ;
; --- Object MCM Pagination                               ;
; ------------------------------------------------------- ;

int function PageCount(int perpage = 125)
	return ((Slotted as float / perpage as float) as int) + 1
endFunction

int function FindPage(string Registrar, int perpage = 125)
	int i = Registry.Find(Registrar)
	if i != -1
		return (i / perpage) + 1
	endIf
	return -1
endFunction

string[] function GetSlotNames(int page = 1, int perpage = 125)
	return GetNames(GetSlots(page, perpage))
endfunction

sslBaseExpression[] function GetSlots(int page = 1, int perpage = 125)
	if page > PageCount(perpage) || page < 1
		return sslUtility.ExpressionArray(0)
	endIf
	perpage = PapyrusUtil.ClampInt(perpage, 1, 128) 
	sslBaseExpression[] PageSlots = sslUtility.ExpressionArray(perpage)
	int i = perpage
	int n = page * perpage
	while i
		i -= 1
		n -= 1
		if Objects[n]
			PageSlots[i] = Objects[n] as sslBaseExpression
		endIf
	endWhile
	return PageSlots
endFunction

; ------------------------------------------------------- ;
; --- Object Registration                                 ;
; ------------------------------------------------------- ;

function RegisterSlots()
	; Register default Expressions
	(Game.GetFormFromFile(0x664FB, "SexLab.esm") as sslExpressionDefaults).LoadExpressions()
	; Send mod event for 3rd party Expressions
	ModEvent.Send(ModEvent.Create("SexLabSlotExpressions"))
	Debug.Notification("$SSL_NotifyExpressionInstall")
endFunction

int function Register(string Registrar)
	if Registry.Find(Registrar) != -1 || Slotted >= 375
		return -1
	endIf
	Slotted += 1
	int i = Registry.Find("")
	if i == -1
		int n = Registry.Length + 32
		if n > 375
			n = 375
		endIf
		Config.Log("Resizing expression registry slots: "+Registry.Length+" -> "+n, "Register")
		Registry = PapyrusUtil.ResizeStringArray(Registry, n)
		Objects  = PapyrusUtil.ResizeAliasArray(Objects, n)
		i = Registry.Find("")
	endIf
	Registry[i] = Registrar
	Objects[i]  = GetNthAlias(i)
	return i
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
	Registry = Utility.CreateStringArray(32)
	Objects  = Utility.CreateAliasArray(32, GetNthAlias(0))
	; DEVTEMP: SKSE Beta workaround - clear used dummy aliases
	int i = Objects.Length
	while i
		i -= 1
		Objects[i] = none
	endWhile
	; /DEVTEMP
	; Init defaults
	RegisterSlots()
	GoToState("Locked")
endFunction

state Locked
	function Setup()
	endFunction
endState

bool function TestSlots()
	return true;Slotted > 0 && Registry.Length == 100 && Slots1.Length == 100 && Slots1.Find(none) > 0 && Registry.Find("") > 0
endFunction