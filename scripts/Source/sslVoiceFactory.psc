scriptname sslVoiceFactory extends Quest

sslVoiceSlots property Slots auto hidden
sslBaseVoice property Slot auto hidden

; Gender Types
int property Male = 0 autoreadonly hidden
int property Female = 1 autoreadonly hidden
int property MaleFemale = -1 autoreadonly hidden

bool Locked

; ------------------------------------------------------- ;
; --- Registering Voices                              --- ;
; ------------------------------------------------------- ;

; Send callback event to start registration
function RegisterVoice(string Registrar)
	; Check duplicate
	if Slots.IsRegistered(Registrar)
		return
	endIf
	; Wait for factory to be free
	FactoryWait()
	; Get free voice slot
	Slot = Slots.Register(Registrar)
	if Slot != none
		; Init voice
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
	; Make sure we have a gender tag
	if Slot.Gender == 0
		Slot.AddTag("Male")
	elseIf Slot.Gender == 1
		Slot.AddTag("Female")
	elseIf Slot.Gender == -1
		Slot.AddTag("Male")
		Slot.AddTag("Female")
	endIf
	; Free up factory for use
	SexLabUtil.Log("'"+Slot.Name+"'", "Voices["+Slots.Voices.Find(Slot)+"]", "REGISTER", "trace,console", true)
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

int property Gender hidden
	function set(int value)
		Slot.Gender = value
	endFunction
endProperty

Sound property Mild hidden
	function set(Sound value)
		Slot.Mild = value
	endFunction
endProperty

Sound property Medium hidden
	function set(Sound value)
		Slot.Medium = value
	endFunction
endProperty

Sound property Hot hidden
	function set(Sound value)
		Slot.Hot = value
	endFunction
endProperty

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
