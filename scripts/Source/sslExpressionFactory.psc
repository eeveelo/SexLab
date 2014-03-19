scriptname sslExpressionFactory extends Quest

sslExpressionSlots property Slots auto hidden
sslBaseExpression property Registering auto hidden

; Gender Types
int property Male = 0 autoreadonly hidden
int property Female = 1 autoreadonly hidden
int property MaleFemale = -1 autoreadonly hidden
; MFG Types
int property Phoneme = 0 autoreadonly hidden
int property Modifier = 1 autoreadonly hidden
int property Expression = 2 autoreadonly hidden

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
	while Locked || Registering != none
		Utility.WaitMenuMode(0.15)
	endWhile
	Locked = true
	; Get free Expression slot
	Registering = Slots.Register(Registrar)
	if Registering != none
		; Init Expression
		Registering.Initialize()
		Registering.Registry = Registrar
		Registering.Enabled = true
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
	; Make sure we have a gender tag
	if Registering.Gender == 0
		Registering.AddTag("Male")
	elseIf Registering.Gender == 1
		Registering.AddTag("Female")
	elseIf Registering.Gender == -1
		Registering.AddTag("Male")
		Registering.AddTag("Female")
	endIf
	; Free up factory for use
	SexLabUtil.Log("'"+Registering.Name+"'", "Slot["+Slots.Expressions.Find(Registering)+"]", "REGISTER Expression", "trace,console", true)
	FreeFactory()
endfunction

; ------------------------------------------------------- ;
; --- Registering Callbacks                           --- ;
; ------------------------------------------------------- ;

bool function AddTag(string tag)
	return Registering.AddTag(tag)
endFunction

string property Name hidden
	function set(string value)
		Registering.Name = value
	endFunction
endProperty

bool property Enabled hidden
	function set(bool value)
		Registering.Enabled = value
	endFunction
endProperty

int property Gender hidden
	function set(int value)
		Registering.Gender = value
	endFunction
endProperty

function AddPreset(int phase, int gender, int mode, int id, int value)
	if mode == Expression
		; AddExpression(phase, gender, id, value)
	elseif mode == Modifier
		; AddModifier(phase, gender, id, value)
	elseif mode == Phoneme
		; AddPhoneme(phase, gender, id, value)
	endIf
endFunction

function AddExpression(int phase, int gender, int id, int value)
	; Registering.AddExpression(phase, gender, id, value)
endFunction

function AddModifier(int phase, int gender, int id, int value)
	; Registering.AddModifier(phase, gender, id, value)
endFunction

function AddPhoneme(int phase, int gender, int id, int value)
	; Registering.AddPhoneme(phase, gender, id, value)
endFunction

function FreeFactory()
	; Clear wait lock
	Registering = none
	Locked = false
endFunction
