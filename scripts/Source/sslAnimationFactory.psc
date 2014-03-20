scriptname sslAnimationFactory extends Quest

sslAnimationSlots property Slots auto hidden
sslBaseAnimation property Slot auto hidden

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
Sound property Squishing auto hidden
Sound property Sucking auto hidden
Sound property SexMix auto hidden

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
	FactoryWait()
	; Get free animation slot
	Slot = Slots.Register(Registrar)
	if Slot != none
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
	SexLabUtil.Log("'"+Slot.Name+"'", "Animation["+Slots.Animations.Find(Slot)+"]", "REGISTER", "trace,console", true)
	Slot.Save(sslUtility.TrimIntArray(positionData, positionID), sslUtility.TrimStringArray(animData, animID), sslUtility.TrimFloatArray(offsetData, offsetID), sslUtility.TrimIntArray(infoData, infoID))
	FreeFactory()
endfunction

; ------------------------------------------------------- ;
; --- Registering Callbacks                           --- ;
; ------------------------------------------------------- ;

int function AddPosition(int gender = 0, int addCum = -1)
	Slot.Genders[gender] = Slot.Genders[gender] + 1
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
	infoData[(infoID + 2)] = (strapon as int)
	infoData[(infoID + 3)] = sos
	infoID += 4
endFunction

function SetContent(int contentType)
	Slot.SetContent(contentType)
endFunction

function SetStageTimer(int stage, float timer)
	Slot.SetStageTimer(stage, timer)
endFunction

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

Sound property SoundFX hidden
	function set(Sound value)
		Slot.SoundFX = value
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
	; Init SFX if needed
	if Squishing == none || Sucking == none || SexMix == none
		sslThreadLibrary Lib = Quest.GetQuest("SexLabQuestFramework") as sslThreadLibrary
		Squishing = Lib.SquishingFX
		Sucking = Lib.SuckingFX
		SexMix = Lib.SexMixedFX
	endIf
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
