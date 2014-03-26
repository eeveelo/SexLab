scriptname sslExpressionFactory extends Quest

sslExpressionSlots property Slots auto hidden

; Gender Types
int property Male = 0 autoreadonly hidden
int property Female = 1 autoreadonly hidden
int property MaleFemale = -1 autoreadonly hidden
; MFG Types
int property Modifier = 0 autoreadonly hidden
int property Phoneme = 14 autoreadonly hidden
int property Expression = 30 autoreadonly hidden

; ------------------------------------------------------- ;
; --- Registering Expressions                         --- ;
; ------------------------------------------------------- ;

; Send callback event to start registration
function RegisterExpression(string Registrar)
	; Get free Expression slot
	int id = Slots.Register(Registrar)
	if id != -1
		; Get slot
		sslBaseExpression Slot = Slots.GetNthAlias(id) as sslBaseExpression
		Slots.Expressions[id] = Slot
		; Init Voice
		Slot.Initialize()
		Slot.Registry = Registrar
		Slot.Enabled = true
		; Send load event
		RegisterForModEvent(Registrar, Registrar)
		int handle = ModEvent.Create(Registrar)
		ModEvent.PushInt(handle, id)
		ModEvent.Send(handle)
	endIf
endFunction

; Gets the Expression resource object for use in the callback, MUST be called at start of callback to get the appropiate resource
sslBaseExpression function Create(int id)
	sslBaseExpression Slot = Slots.GetbySlot(id)
	UnregisterForModEvent(Slot.Registry)
	return Slot
endFunction
