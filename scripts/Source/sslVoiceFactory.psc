scriptname sslVoiceFactory extends Quest

sslVoiceRegistry property Registry auto
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
	int check = Registry.FindByRegistrar(registrar)
	if check != -1
		return check ; Duplicate
	elseif Registry.GetFreeSlot() < 0
		return -1 ; No free slots
	endIf
	; Wait for factory to be free
	_FactoryWait()
	; Get free animation slot
	slot = Registry.GetFreeSlot()
	Voice = Registry.GetBySlot(slot)
	; Make sure it's cleared out before loading
	Voice.InitializeVoice()
	; Set Registrar
	Voice.Registrar = registrar
	; Send load event
	RegisterForModEvent("RegisterVoice", registrar)
	SendModEvent("RegisterVoice", registrar, 1)
	UnregisterForAllModEvents()
	return slot
endFunction

; Unlocks factory for next callback, MUST be called at end of callback
function Save()
	Debug.Trace("SexLabVoiceFactory: Registered voice slot SexLabFramework.Voice["+slot+"] to '"+Voice.Name+"' ")
	slot = -1
	Voice = none
endfunction

; System use only, makes factory wait for free callback closure
function _FactoryWait()
	while Voice != none
		Utility.Wait(0.12)
	endWhile
endFunction

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