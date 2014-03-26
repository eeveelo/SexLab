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

sslBaseExpression function PickExpression(int Flag = 0)
	string Tag = "Consensual"
	if Flag == 1
		Tag = "Victim"
	elseIf Flag == 2
		Tag = "Aggressor"
	endIf
	string Search = "PickExpression["+Utility.RandomFloat(1.0, 10.0)+"]"
	int i = Slotted
	while i
		i -= 1
		if Slots[i].Registered && Slots[i].HasTag(Tag)
			IntListAdd(self, Search, i)
		endIf
	endWhile
	sslBaseExpression Output
	if IntListCount(self, Search) > 0
		Output = GetBySlot(IntListGet(self, Search, Utility.RandomInt(0, IntListCount(self, Search))))
		IntListClear(self, Search)
	endIf
	return Output
endFunction

sslBaseExpression function GetByTags(string Tags, string TagsSuppressed = "", bool RequireAll = true)
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
	return Registry.Find(Registrar)
endFunction

bool function IsRegistered(string Registrar)
	return Registry.Find(Registrar) != -1
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
	sslExpressionDefaults Defaults = Quest.GetQuest("SexLabQuestRegistry") as sslExpressionDefaults
	Defaults.Slots = self
	Defaults.LoadExpressions()
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
