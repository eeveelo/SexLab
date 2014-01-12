scriptname sslVoiceFactory extends Quest

sslVoiceSlots property Slots auto
sslBaseVoice property Voice auto hidden
int slot

; Gender Types
int property Male = 0 autoreadonly hidden
int property Female = 1 autoreadonly hidden

;/-----------------------------------------------\;
;|	Registering Voices                           |;
;\-----------------------------------------------/;

; Send callback event to start registration
int function RegisterVoice(string registrar)
	int check = Slots.FindByRegistrar(registrar)
	if check != -1
		return check ; Duplicate
	elseif !Slots.FreeSlots
		return -1 ; No free slots
	endIf
	; Wait for factory to be free
	while Voice != none
		Utility.WaitMenuMode(0.10)
	endWhile
	; Get free animation slot
	Voice = Slots.GetFree()
	slot = Slots.Register(Voice, registrar)
	; Send load event
	RegisterForModEvent("RegisterVoice", registrar)
	SendModEvent("RegisterVoice", registrar, 1)
	UnregisterForAllModEvents()
	return slot
endFunction

; Unlocks factory for next callback, MUST be called at end of callback
function Save()
	Debug.Trace("SexLabVoiceFactory: Registered voice slot SexLabFramework.Voice["+slot+"] to '"+Voice.Name+"' ")
	Voice = none
	slot = -1
endfunction

;/-----------------------------------------------\;
;|	Callback Voice Property Shortcuts            |;
;\-----------------------------------------------/;

bool function AddTag(string tag)
	return Voice.AddTag(tag)
endFunction

string property Name hidden
	function set(string value)
		Voice.Name = value
	endFunction
endProperty

int property Gender hidden
	function set(int value)
		Voice.Gender = value
	endFunction
endProperty

bool property Enabled hidden
	function set(bool value)
		Voice.Enabled = value
	endFunction
endProperty


Sound property Mild hidden
	function set(Sound value)
		Voice.Mild = value
	endFunction
endProperty

Sound property Medium hidden
	function set(Sound value)
		Voice.Medium = value
	endFunction
endProperty

Sound property Hot hidden
	function set(Sound value)
		Voice.Hot = value
	endFunction
endProperty
