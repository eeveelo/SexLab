scriptname sslAnimationFactory extends Quest

sslAnimationSlots property Slots auto
sslBaseAnimation property Animation auto hidden
int slot

; Gender Types
int property Male = 0 autoreadonly hidden
int property Female = 1 autoreadonly hidden
int property Creature = 2 autoreadonly hidden
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

; ------------------------------------------------------- ;
; --- Registering Animations                          --- ;
; ------------------------------------------------------- ;

; Send callback event to start registration
int function RegisterAnimation(string registrar)
	; if Slots.FindByRegistrar(registrar) != -1
	; 	return Slots.FindByRegistrar(registrar) ; Duplicate
	; elseif !Slots.FreeSlots
	; 	return -1 ; No free slots
	; endIf
	; ; Wait for factory to be free
	; while Animation != none
	; 	Utility.WaitMenuMode(0.10)
	; endWhile
	; ; Get free animation slot
	; Animation = Slots.GetFree()
	; slot = Slots.Register(Animation, registrar)
	; ; Send load event
	; RegisterForModEvent("RegisterAnimation", registrar)
	; SendModEvent("RegisterAnimation", registrar, 1)
	; UnregisterForAllModEvents()
	; return slot
endFunction

; Unlocks factory for next callback, MUST be called at end of callback
function Save()
	; Run animation caches
	; Animation.CacheAllForwards()
	; Free up factory
	Debug.Trace("SexLabAnimationFactory: Registered animation slot SexLabFramework.Animation["+slot+"] to '"+Animation.Name+"' ")
	Animation = none
	slot = -1
endfunction

; ------------------------------------------------------- ;
; --- Animation Setup Callbacks                       --- ;
; ------------------------------------------------------- ;

int function AddPosition(int gender = 0, int addCum = -1)
	posData[((actors * 2) + 0)] = gender
	posData[((actors * 2) + 1)] = addCum
	actors += 1
	return (actors - 1)
endFunction

function AddPositionStage(int position, string animationEvent, float forward = 0.0, float side = 0.0, float up = 0.0, float rotate = 0.0, bool silent = false, bool openMouth = false, bool strapon = true, int sos = 0)
	animData[index] = animationEvent
	schlongData[index] = sos
	index += 1

	offsetData[(offsetIndex + 0)] = forward
	offsetData[(offsetIndex + 1)] = side
	offsetData[(offsetIndex + 2)] = up
	offsetData[(offsetIndex + 3)] = rotate
	offsetIndex += 4

	flagData[(flagIndex + 0)] = silent
	flagData[(flagIndex + 1)] = openMouth
	flagData[(flagIndex + 2)] = strapon && posData[(position * 2)] == Male
	flagIndex += 3
endFunction

function SetContent(int contentType)
	Animation.SetContent(contentType)
endFunction

function SetSFX(int iSFX)
	if iSFX == Squishing
		; Animation.SoundFX = Slots.Lib.ThreadLib.sfxSquishing01
	elseIf iSFX == Sucking
		; Animation.SoundFX = Slots.Lib.ThreadLib.sfxSucking01
	elseIf iSFX == SexMix
		; Animation.SoundFX = Slots.Lib.ThreadLib.sfxSexMix01
	endIf
endFunction

function SetSound(Sound SoundFX)
	Animation.SoundFX = SoundFX
endFunction

function SetStageTimer(int stage, float timer)
	Animation.SetStageTimer(stage, timer)
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
		; No longer used
	endFunction
endProperty

bool property Enabled hidden
	function set(bool value)
		Animation.Enabled = value
	endFunction
endProperty

; ------------------------------------------------------- ;
; --- Callback Data Handling - SYSTEM USE ONLY        --- ;
; ------------------------------------------------------- ;

int actors
int[] posData

int index
string[] animData
int[] schlongData

int offsetIndex
float[] offsetData

int flagIndex
bool[] flagData

function InitCallbacks()
	actors = 0
	index = 0
	offsetIndex = 0
	flagIndex = 0
	animData = new string[128]
	offsetData = new float[128]
	flagData = new bool[128]
	schlongData = new int[128]
	posData = new int[10]
endFunction
