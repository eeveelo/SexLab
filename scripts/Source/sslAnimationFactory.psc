scriptname sslAnimationFactory extends Quest

sslAnimationRegistry property Registry auto
sslBaseAnimation property Animation auto hidden
int slot

; Gender Types
int property Male = 0 autoreadonly hidden
int property Female = 1 autoreadonly hidden
; Cum Types
int property Vaginal = 1 autoreadonly hidden
int property Oral = 2 autoreadonly hidden
int property Anal = 3 autoreadonly hidden
int property VaginalOral = 4 autoreadonly hidden
int property VaginalAnal = 5 autoreadonly hidden
int property OralAnal = 6 autoreadonly hidden
int property VaginalOralAnal = 7 autoreadonly hidden
; SFX Types
int property Squishing = 1 autoreadonly hidden
int property Sucking = 2 autoreadonly hidden
int property SexMix = 3 autoreadonly hidden
; Content Types
int property Misc = 0 autoreadonly hidden
int property Sexual = 1 autoreadonly hidden
int property Foreplay = 2 autoreadonly hidden
int property Creature = 3 autoreadonly hidden

;/-----------------------------------------------\;
;|	Registering Animations                       |;
;\-----------------------------------------------/;

; Send callback event to start registration
int function RegisterAnimation(string registrar)
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
	Animation = Registry.GetBySlot(slot)
	; Make sure it's cleared out before loading
	Animation.InitializeAnimation()
	; Set Registrar
	Animation.Registrar = registrar
	; Send load event
	RegisterForModEvent("RegisterAnimation", registrar)
	SendModEvent("RegisterAnimation", registrar, 1)
	UnregisterForAllModEvents()
	return slot
endFunction

; Unlocks factory for next callback, MUST be called at end of callback
function Save()
	Debug.Trace("SexLabAnimationFactory: Registered animation slot SexLabFramework.Animation["+slot+"] to '"+Animation.Name+"' ")
	slot = -1
	Animation = none
endfunction

; System use only, makes factory wait for free callback closure
function _FactoryWait()
	while Animation != none
		Utility.Wait(0.12)
	endWhile
endFunction

;/-----------------------------------------------\;
;|	Callback Animation Property Shortcuts        |;
;\-----------------------------------------------/;

int function AddPosition(int gender = 0, int addCum = -1)
	return Animation.AddPosition(gender, addCum)
endFunction

int function AddPositionStage(int position, string animationEvent, float forward = 0.0, float side = 0.0, float up = 0.0, float rotate = 0.0, bool silent = false, bool openMouth = false, bool strapon = true, int sos = 0)
	return Animation.AddPositionStage(position, animationEvent, forward, side, up, rotate, silent, openMouth, strapon, sos)
endFunction

function SetContent(int contentType)
	return Animation.SetContent(contentType)
endFunction

function SetSFX(int iSFX)
	return Animation.SetSFX(iSFX)
endFunction

bool function AddTag(string tag)
	return Animation.AddTag(tag)
endFunction

string property Name hidden
	function set(string value)
		Animation.Name = value
	endFunction
endProperty

bool property TCL hidden
	function set(bool value)
		Animation.TCL = value
	endFunction
endProperty

bool property Enabled hidden
	function set(bool value)
		Animation.Enabled = value
	endFunction
endProperty