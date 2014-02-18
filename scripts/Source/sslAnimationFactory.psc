scriptname sslAnimationFactory extends Quest

sslAnimationSlots property Slots auto hidden
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
; Content Types
int property Misc = 0 autoreadonly hidden
int property Sexual = 1 autoreadonly hidden
int property Foreplay = 2 autoreadonly hidden
; SFX Types
Sound property Squishing hidden
	Sound function get()
		return Slots.Lib.SquishingFX
	endFunction
endProperty
Sound property Sucking hidden
	Sound function get()
		return Slots.Lib.SuckingFX
	endFunction
endProperty
Sound property SexMix hidden
	Sound function get()
		return Slots.Lib.SexMixedFX
	endFunction
endProperty

bool Locked

; ------------------------------------------------------- ;
; --- Registering Animations                          --- ;
; ------------------------------------------------------- ;

; Send callback event to start registration
function RegisterAnimation(string Registrar)
	; Check duplicate
	if Slots.IsRegistered(Registrar)
		return
	endIf
	; Wait for factory to be free
	while Locked || Animation != none
		Utility.WaitMenuMode(0.10)
	endWhile
	; Get free animation slot
	Locked = true
	Animation = Slots.Register(Registrar)
	if Animation != none
		Animation.Initialize()
		Animation.Registry = Registrar
		Animation.Enabled = true
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
	SexLabUtil.Log("'"+Animation.Name+"'", "sslAnimationSlots["+Slots.Animations.Find(Animation)+"]", "REGISTER ANIMATION ", "trace,console", true)
	Animation.Save(sslUtility.TrimIntArray(positionData, positionID), sslUtility.TrimStringArray(animData, animID), sslUtility.TrimFloatArray(offsetData, offsetID), sslUtility.TrimIntArray(infoData, infoID))
	FreeFactory()
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

bool property Enabled hidden
	function set(bool value)
		Animation.Enabled = value
	endFunction
endProperty

Sound property SoundFX hidden
	function set(Sound value)
		Animation.SoundFX = value
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
function FreeFactory()
	; Reset callback storage
	positionID = 0
	positionData = new int[10]
	animID = 0
	animData = new string[128]
	offsetID = 0
	offsetData = new float[128]
	infoID = 0
	infoData = new int[128]
	; Init slots property if empty
	if Slots == none
		Slots = (Quest.GetQuest("SexLabQuestAnimations") as sslAnimationSlots)
	endIf
	; Clear wait lock
	Animation = none
	Locked = false
endFunction

