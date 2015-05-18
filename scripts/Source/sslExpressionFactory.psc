scriptname sslExpressionFactory extends Quest hidden

sslExpressionSlots property Slots auto hidden

; Gender Types
int property Male = 0 autoreadonly hidden
int property Female = 1 autoreadonly hidden
int property MaleFemale = -1 autoreadonly hidden
; MFG Types
int property Phoneme = 0 autoreadonly hidden
int property Modifier = 16 autoreadonly hidden
int property Expression = 30 autoreadonly hidden

; ------------------------------------------------------- ;
; --- Registering Expressions                         --- ;
; ------------------------------------------------------- ;

; Prepare the factory for use
function PrepareFactory()
	Slots = Game.GetFormFromFile(0x664FB, "SexLab.esm") as sslExpressionSlots
endFunction

; Send callback event to start registration
function RegisterExpression(string Registrar)
	; Get free Expression slot
	int id = Slots.Register(Registrar)
	if id != -1
		; Init slot
		sslBaseExpression Slot = Slots.GetBySlot(id)
		Slot.Initialize()
		Slot.Registry = Registrar
		Slot.Enabled  = true
		; Send load event
		RegisterForModEvent(Registrar, Registrar)
		int handle = ModEvent.Create(Registrar)
		ModEvent.PushInt(handle, id)
		ModEvent.Send(handle)
	endIf
	Utility.WaitMenuMode(0.1)
endFunction

; Gets the Expression resource object for use in the callback, MUST be called at start of callback to get the appropiate resource
sslBaseExpression function Create(int id)
	sslBaseExpression Slot = Slots.GetbySlot(id)
	UnregisterForModEvent(Slot.Registry)
	return Slot
endFunction

function Initialize()
	PrepareFactory()
endfunction
