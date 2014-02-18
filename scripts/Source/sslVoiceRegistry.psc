scriptname sslVoiceRegistry extends Quest

; Library for animation
sslVoiceLibrary property Lib auto hidden
int property Slotted auto hidden

; ------------------------------------------------------- ;
; --- Create Voice                                    --- ;
; ------------------------------------------------------- ;

string function CreateVoice(string Registrar, string Name)
	if FindByRegistrar(Registrar) != -1 && Slotted < 100
		return "" ; Voice already exists
	endIf
	Slotted = StorageUtil.StringListCount(self, "Registry")
	StorageUtil.StringListAdd(self, "Registry", Registrar, false)
	return FindByRegistrar(Registrar)
endFunction

function SetName(string Registrar, string Name)
	if FindByRegistrar(Registrar) == -1
		return ; invalid id
	endIf
	StorageUtil.SetStringValue(self, Key(VoiceID,"Name"), Name)
endFunction

; ------------------------------------------------------- ;
; --- Find single animation object                    --- ;
; ------------------------------------------------------- ;



int function FindByRegistrar(string Registrar)
	return StorageUtil.StringListFind(self, "Registry", Registrar)
endFunction

; ------------------------------------------------------- ;
; --- System Use Only                                 --- ;
; ------------------------------------------------------- ;

function Setup()
	Initialize()
endFunction

function Initialize()
	Slotted = 0
	StorageUtil.StringListClear(self, "Registry")
	StorageUtil.StringListClear(self, "Names")
endFunction

function Key(string Registrar, string type)
	return StorageUtil.StringListGet(self, "Registry", VoiceID)+"."+type
endFunction
