scriptname sslAnimationFactory extends Quest

sslAnimationSlots property Slots auto
sslBaseAnimation property Animation auto hidden

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
function RegisterAnimation(string Registrar)
	if Slots.FindByRegistrar(Registrar) != -1
		return ; Duplicate
	endIf
	; Wait for factory to be free
	while Animation != none
		Utility.WaitMenuMode(0.10)
	endWhile
	; Get free animation slot
	Animation = Slots.Register(Registrar)
	if Animation == none
		return ; No available slot or duplicate
	endIf
	; Clear callback storage
	InitCallbacks()
	; Send load event
	RegisterForModEvent("Register"+Registrar, Registrar)
	ModEvent.Send(ModEvent.Create("Register"+Registrar))
	UnregisterForAllModEvents()
endFunction

; Unlocks factory for next callback, MUST be called at end of callback
function Save()
	; Save animations stage+position data
	SexLabUtil.Log("Setup animation '"+Animation.Name+"'", "SexLabAnimationFactory["+Slots.Animations.Find(Animation)+"]", "REGISTER ", "trace,console", true)
	Animation._Save(sslUtility.TrimIntArray(positionData, positionID), sslUtility.TrimStringArray(animData, animID), sslUtility.TrimFloatArray(offsetData, offsetID), sslUtility.TrimIntArray(infoData, infoID))
	; Free up factory
	Animation = none
endfunction

; ------------------------------------------------------- ;
; --- Animation Setup Callbacks                       --- ;
; ------------------------------------------------------- ;

int function AddPosition(int gender = 0, int addCum = -1)
	Animation.Genders[gender] = Animation.Genders[gender] + 1
	positionData[(positionID + 0)] = gender
	positionData[(positionID + 1)] = addCum
	positionID += 2
	return (positionID / 2)
endFunction

function AddPositionStage(int position, string animationEvent, float forward = 0.0, float side = 0.0, float up = 0.0, float rotate = 0.0, bool silent = false, bool openMouth = false, bool strapon = true, int sos = 0)
	animData[animID] = animationEvent
	animID += 1

	offsetData[(offsetID + 0)] = forward
	offsetData[(offsetID + 1)] = side
	offsetData[(offsetID + 2)] = up
	offsetData[(offsetID + 3)] = rotate
	offsetID += 4

	infoData[(infoID + 0)] = (silent as int)
	infoData[(infoID + 1)] = (openMouth as int)
	infoData[(infoID + 2)] = ((strapon && positionData[(position * 2)] == Male) as int)
	infoData[(infoID + 3)] = sos
	infoID += 4
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

int positionID
int[] positionData

int animID
string[] animData

int offsetID
float[] offsetData

int infoID
int[] infoData

function InitCallbacks()
	positionID = 0
	positionData = new int[10]

	animID = 0
	animData = new string[128]

	offsetID = 0
	offsetData = new float[128]

	infoID = 0
	infoData = new int[128]
endFunction
