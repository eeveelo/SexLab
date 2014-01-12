scriptname sslExpressionFactory extends Quest

sslExpressionSlots property Slots auto
sslBaseExpression property Registering auto hidden
int slot

; Gender Types
bool property Male = false autoreadonly hidden
bool property Female = true autoreadonly hidden
; MFG Types
int property Phoneme = 0 autoreadonly hidden
int property Modifier = 1 autoreadonly hidden
int property Expression = 2 autoreadonly hidden

;/-----------------------------------------------\;
;|	Registering Expression                       |;
;\-----------------------------------------------/;

; Send callback event to start registration
int function RegisterExpression(string registrar)
	int check = Slots.FindByRegistrar(registrar)
	if check != -1
		return check ; Duplicate
	elseif !Slots.FreeSlots
		return -1 ; No free slots
	endIf
	; Wait for factory to be free
	while Registering != none
		Utility.Wait(0.10)
	endWhile
	; Get free animation slot
	Registering = Slots.GetFree()
	slot = Slots.Register(Registering, registrar)
	; Send load event
	RegisterForModEvent("RegisterExpression", registrar)
	SendModEvent("RegisterExpression", registrar, 1)
	UnregisterForAllModEvents()
	return slot
endFunction

; Unlocks factory for next callback, MUST be called at end of callback
function Save()
	Debug.Trace("SexLabExpressionFactory: Registered expression slot SexLabFramework.Expression["+slot+"] to '"+Registering.Name+"' ")
	Registering = none
	slot = -1
endfunction

;/-----------------------------------------------\;
;|	Callback Expression Shortcuts                |;
;\-----------------------------------------------/;

bool function AddTag(string tag)
	return Registering.AddTag(tag)
endFunction

function AddPreset(int phase, bool isFemale, int mode, int id, int value)
	if mode == Expression
		AddExpression(phase, isFemale, id, value)
	elseif mode == Modifier
		AddModifier(phase, isFemale, id, value)
	elseif mode == Phoneme
		AddPhoneme(phase, isFemale, id, value)
	endIf
endFunction

function AddExpression(int phase, bool isFemale, int id, int value)
	Registering.AddExpression(phase, isFemale, id, value)
endFunction

function AddModifier(int phase, bool isFemale, int id, int value)
	Registering.AddModifier(phase, isFemale, id, value)
endFunction

function AddPhoneme(int phase, bool isFemale, int id, int value)
	Registering.AddPhoneme(phase, isFemale, id, value)
endFunction

string property Name hidden
	function set(string value)
		Registering.Name = value
	endFunction
endProperty

