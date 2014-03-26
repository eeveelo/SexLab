scriptname sslVoiceFactory extends Quest

sslVoiceSlots property Slots auto hidden

; Gender Types
int property Male = 0 autoreadonly hidden
int property Female = 1 autoreadonly hidden
int property MaleFemale = -1 autoreadonly hidden

; ------------------------------------------------------- ;
; --- Registering Voices                              --- ;
; ------------------------------------------------------- ;

; Send callback event to start registration
function RegisterVoice(string Registrar)
	; Get free voice slot
	int id = Slots.Register(Registrar)
	if id != -1
		; Get slot
		sslBaseVoice Slot = Slots.GetNthAlias(id) as sslBaseVoice
		Slots.Voices[id] = Slot
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

; Gets the voice resource object for use in the callback, MUST be called at start of callback to get the appropiate resource
sslBaseVoice function Create(int id)
	sslBaseVoice Slot = Slots.GetbySlot(id)
	UnregisterForModEvent(Slot.Registry)
	return Slot
endFunction
