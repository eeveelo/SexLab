scriptname sslExpressionSlots extends Quest

; Expression readonly storage
int property Slotted auto hidden
sslBaseExpression[] Slots
sslBaseExpression[] property Expressions hidden
	sslBaseExpression[] function get()
		return Slots
	endFunction
endProperty

; Local use
sslSystemConfig Config

; ------------------------------------------------------- ;
; --- Expression Filtering                            --- ;
; ------------------------------------------------------- ;

sslBaseExpression[] function GetAllGender(int Gender)
endFunction

sslBaseExpression function PickGender(int Gender = 1)
endFunction

sslBaseExpression function PickExpression(Actor ActorRef)
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
	return StorageUtil.StringListFind(self, "Expressions", Registrar)
endFunction

bool function IsRegistered(string Registrar)
	return StorageUtil.StringListFind(self, "Expressions", Registrar) != -1
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

sslBaseExpression function Register(string Registrar)
	if FindByRegistrar(Registrar) == -1 && Slotted < Slots.Length
		sslBaseExpression Slot = GetNthAlias(Slotted) as sslBaseExpression
		Slots[Slotted] = Slot
		StorageUtil.StringListAdd(self, "Expressions", Registrar, false)
		Slotted = StorageUtil.StringListCount(self, "Expressions")
		return Slot
	endIf
	return none
endFunction

function RegisterExpressions()
	; Register default Expressions
	sslExpressionDefaults Defaults = Quest.GetQuest("SexLabQuestRegistry") as sslExpressionDefaults
	Defaults.Slots = self
	Defaults.LoadExpressions()
	; Send mod event for 3rd party Expressions
	ModEvent.Send(ModEvent.Create("SexLabSlotExpressions"))
	Debug.Notification("$SSL_NotifyExpressionsInstall")
endFunction

function Setup()
	; Init variables
	Slotted = 0
	Slots = new sslBaseExpression[40]
	StorageUtil.StringListClear(self, "Expressions")
	Config = Quest.GetQuest("SexLabQuestFramework") as sslSystemConfig
	; Register Expressions
	RegisterExpressions()
endFunction


