scriptname sslExpressionFactory extends Quest

sslExpressionSlots property Slots auto hidden
sslBaseExpression property Expression auto hidden

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
; --- Registering Voices                              --- ;
; ------------------------------------------------------- ;

; Send callback event to start registration
function RegisterEmotion(string Registrar)
	; Check duplicate
	if Slots.IsRegistered(Registrar)
		return
	endIf
	; Wait for factory to be free
	while Locked || Expression != none
		Utility.WaitMenuMode(0.15)
	endWhile
	Locked = true
	; Get free Expression slot
	Expression = Slots.Register(Registrar)
	if Expression != none
		; Init Expression
		Expression.Initialize()
		Expression.Registry = Registrar
		Expression.Enabled = true
		; Send load event
		RegisterForModEvent("Register"+Registrar, Registrar)
		ModEvent.Send(ModEvent.Create("Register"+Registrar))
		UnregisterForAllModEvents()
	else
		FreeFactory()
	endIf
endFunction

function RegisterEmotion(string Name, string Tags)
	StorageUtil.
endFunction

function Setup()
	SetModifiers(i0 = 30, i1 = 30, i4 = 100, i5 = 100, i12 = 70, i13 = 70)
	parent.Setup()
endFunction

