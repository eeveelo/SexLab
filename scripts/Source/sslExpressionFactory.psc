scriptname sslExpressionFactory extends Quest

sslExpressionSlots property Slots auto hidden
sslBaseExpression property Slot auto hidden

; Gender Types
int property Male = 0 autoreadonly hidden
int property Female = 1 autoreadonly hidden
int property MaleFemale = -1 autoreadonly hidden
; MFG Types
int property Modifier = 0 autoreadonly hidden
int property Phoneme = 14 autoreadonly hidden
int property Expression = 30 autoreadonly hidden

bool Locked

; ------------------------------------------------------- ;
; --- Registering Expressions                         --- ;
; ------------------------------------------------------- ;

; Send callback event to start registration
function RegisterExpression(string Registrar)
	; Check duplicate
	if Slots.IsRegistered(Registrar)
		return
	endIf
	; Wait for factory to be free
	FactoryWait()
	; Get free Expression slot
	Slot = Slots.Register(Registrar)
	if Slot != none
		; Init Expression
		Slot.Initialize()
		Slot.Registry = Registrar
		Slot.Enabled = true
		; Send load event
		RegisterForModEvent("Register"+Registrar, Registrar)
		ModEvent.Send(ModEvent.Create("Register"+Registrar))
		UnregisterForAllModEvents()
	else
		FreeFactory()
	endIf
endFunction

; Unlocks factory for next callback, MUST be called at end of callback
function Save()
	; Make sure we have a Gender tag
	if Slot.PhasesMale > 0
		Slot.AddTag("Male")
	endIf
	if Slot.PhasesFemale > 0
		Slot.AddTag("Female")
	endIf
	; Free up factory for use
	SexLabUtil.Log("'"+Slot.Name+"'", "Expressions["+Slots.Expressions.Find(Slot)+"]", "REGISTER", "trace,console", true)
	FreeFactory()
endfunction

; ------------------------------------------------------- ;
; --- Registering Callbacks                           --- ;
; ------------------------------------------------------- ;

bool function AddTag(string tag)
	return Slot.AddTag(tag)
endFunction

string property Name hidden
	function set(string value)
		Slot.Name = value
	endFunction
endProperty

bool property Enabled hidden
	function set(bool value)
		Slot.Enabled = value
	endFunction
endProperty

function AddPreset(int Phase, int Gender, int Mode, int id, int value)
	if Mode == Expression
		AddExpression(Phase, Gender, id, value)
	elseif Mode == Modifier
		AddModifier(Phase, Gender, id, value)
	elseif Mode == Phoneme
		AddPhoneme(Phase, Gender, id, value)
	endIf
endFunction

function AddExpression(int Phase, int Gender, int id, int value)
	if Gender == Female || Gender == MaleFemale
		Slot.SetIndex(Phase, Female, Expression, 0, value)
		Slot.SetIndex(Phase, Female, Expression, 1, value)
	endIf
	if Gender == Male || Gender == MaleFemale
		Slot.SetIndex(Phase, Male, Expression, 0, value)
		Slot.SetIndex(Phase, Male, Expression, 1, value)
	endIf
endFunction

function AddModifier(int Phase, int Gender, int id, int value)
	if Gender == Female || Gender == MaleFemale
		Slot.SetIndex(Phase, Female, Modifier, id, value)
	endIf
	if Gender == Male || Gender == MaleFemale
		Slot.SetIndex(Phase, Male, Modifier, id, value)
	endIf
endFunction

function AddPhoneme(int Phase, int Gender, int id, int value)
	if Gender == Female || Gender == MaleFemale
		Slot.SetIndex(Phase, Female, Phoneme, id, value)
	endIf
	if Gender == Male || Gender == MaleFemale
		Slot.SetIndex(Phase, Male, Phoneme, id, value)
	endIf
endFunction

; ------------------------------------------------------- ;
; --- Callback Data Handling - SYSTEM USE ONLY        --- ;
; ------------------------------------------------------- ;

function FreeFactory()
	; Clear wait lock
	Slot = none
	Locked = false
endFunction

function FactoryWait()
	Utility.WaitMenuMode(0.30)
	while Locked
		Utility.WaitMenuMode(0.30)
	endWhile
	Locked = true
endFunction
