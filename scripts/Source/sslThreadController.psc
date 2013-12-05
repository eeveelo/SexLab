scriptname sslThreadController extends sslThreadModel
{ Animation Thread Controller: Runs manipulation logic of thread based on information from model. Access only through functions; NEVER create a property directly to this. }

; Animation
int aid
sslBaseAnimation property Animation hidden
	sslBaseAnimation function get()
		return Animations[aid]
	endFunction
endProperty

; SFX
Sound sfxType
float[] sfx
int sfxInstance
float sfxVolume

; Processing
int stagePrev
float timer
float advanceAt
bool timedStage

; Hotkeys
int AdjustingPosition

; Locks
bool looping

;/-----------------------------------------------\;
;|	Primary Starter                              |;
;\-----------------------------------------------/;

state Making
	sslThreadController function PrimeThread()
		GotoState("Preparing")
		RegisterForSingleUpdate(0.10)
		return self
	endFunction
endState

bool function ActorWait(string waitfor)
	int i = ActorCount
	while i
		i -= 1
		if ActorAlias[i].GetState() != waitfor
			return false
		endIf
	endWhile
	return true
endFunction

function ActorAction(string stateAction, string stateFinish)
	; Start actor action state
	int i = ActorCount
	while i
		i -= 1
		ActorAlias[i].GoToState(stateAction)
	endWhile
	; Wait for actors ready, or for 15 seconds to pass
	float failsafe = Utility.GetCurrentRealTime() + 15.0
	while !ActorWait(stateFinish) && failsafe > Utility.GetCurrentRealTime()
		Utility.Wait(0.10)
	endWhile
endFunction

state Preparing
	event OnUpdate()
		; Init
		Stage = 1
		sfx = new float[2]
		sfxVolume = Lib.fSFXVolume
		sfxInstance = 0
		; Set random starting animation
		SetAnimation()
		; Set initial positioning actor
		if IsPlayerPosition(AdjustingPosition) && ActorCount > 1 && !HasCreature
			AdjustingPosition = ArrayWrap((AdjustingPosition + 1), ActorCount)
		endIf
		; Setup actors
		ActorAction("Prepare", "Ready")
		; Everything ready, send starting event
		SendThreadEvent("AnimationStart")
		if LeadIn
			SendThreadEvent("LeadInStart")
		endIf
		; Start animation loops
		int i = ActorCount
		while i
			i -= 1
			ActorAlias[i].StartAnimating()
		endWhile
		; Begin first stage
		Stage = 1
		GoToState("Advancing")
		RegisterForSingleUpdate(0.10)
	endEvent
endState

;/-----------------------------------------------\;
;|	Animation Loops/Functions                    |;
;\-----------------------------------------------/;

function UpdateTimer(float toTimer = 0.0)
	if toTimer > 0.0
		advanceAt = Utility.GetCurrentRealTime() + toTimer
		timedStage = true
	else
		advanceAt = Utility.GetCurrentRealTime() + StageTimer()
		timedStage = false
	endIf
endFunction

float function StageTimer()
	int last = ( Timers.Length - 1 )
	if stage < last
		return Timers[(stage - 1)]
	elseif stage >= Animation.StageCount
		return Timers[last]
	endIf
	return Timers[(last - 1)]
endfunction

state Advancing
	event OnUpdate()
		if !LeadIn && Stage > Animation.StageCount
			Stage = Animation.StageCount
			EndAnimation()
			return ; No stage to advance to, end animation
		elseIf LeadIn && Stage > Animation.StageCount
			; Disable free camera now to help prevent CTD
			if HasPlayer
				Lib.ControlLib.EnableFreeCamera(false)
			endIf
			; Swap to non lead in animations
			Stage = 1
			LeadIn = false
			SetAnimation()
			; Restrip with new strip options
			if Animation.IsSexual
				int i
				while i < ActorCount
					ActorAlias[i].Strip(false)
					i += 1
				endWhile
			endIf
			SendThreadEvent("LeadInEnd")
		endIf
		; Stage Delay
		if Stage > 1
			sfx[0] = sfx[0] - (Stage * 0.2)
		endIf
		; min 0.80 delay
		if sfx[0] < 0.80
			sfx[0] = 0.80
		endIf
		; Start Animations loop
		GoToState("Animating")
	endEvent
endState

state Animating
	function GoToStage(int toStage)
		; Stop looping
		looping = false
		UnregisterForUpdate()
		; Set upcoming stage
		stagePrev = Stage
		if toStage < 0
			toStage = 0
		endIf
		Stage = toStage
		; Start advancement
		GoToState("Advancing")
		RegisterForSingleUpdate(0.10)
	endFunction
	event OnBeginState()
		if !LeadIn && Stage >= Animation.StageCount
			; Send orgasm stage specific event
			SendThreadEvent("OrgasmStart")
			; Perform actor orgasm stuff
			ActorAction("Orgasm", "Animating")
			PlayAnimation()
			Sound.SetInstanceVolume(sfxType.Play(Positions[0]), sfxVolume)
			sfx[0] = 0.60
		else
			SendThreadEvent("StageStart")
		endIf
		; Start animation looping
		looping = true
		SyncActors()
		PlayAnimation()
		UpdateTimer(Animation.GetStageTimer(stage))
		RegisterForSingleUpdate(0.10)
	endEvent
	event OnUpdate()
		if !looping
			return
		endIf
		float time = Utility.GetCurrentRealTime()
		if (AutoAdvance || timedStage) && advanceAt < time
			GoToStage((Stage + 1))
			return ; End Stage
		endIf
		; Play SFX
		if sfx[0] <= (time - sfx[1]) && sfxType != none
			Sound.SetInstanceVolume(sfxType.Play(Positions[0]), sfxVolume)
			sfx[1] = time
		endIf
		; Loop
		RegisterForSingleUpdate(0.60)
	endEvent
	event OnEndState()
		if !LeadIn && Stage > Animation.StageCount
			SendThreadEvent("OrgasmEnd")
		else
			SendThreadEvent("StageEnd")
		endIf
	endEvent
endState

;/-----------------------------------------------\;
;|	Hotkey Functions                             |;
;\-----------------------------------------------/;

function AdvanceStage(bool backwards = false)
	if GetState() != "Animating"
		return ; Don't advance while not looping
	elseif !backwards
		GoToStage((Stage + 1))
	elseIf backwards && Stage > 1
		GoToStage((Stage - 1))
	endIf
endFunction

function ChangeAnimation(bool backwards = false)
	if Animations.Length == 1
		return ; Single animation selected, nothing to change to
	endIf
	aid = ArrayWrap((aid + SignInt(1, backwards)), Animations.Length)
	SetAnimation(aid)
	RealignActors()
	SendThreadEvent("AnimationChange")
endFunction

function ChangePositions(bool backwards = false)
	if ActorCount < 2 || HasCreature
		return ; Solo/Creature Animation, nobody to swap with
	endIf
	; Set direction of swapping
	int MovedTo = ArrayWrap((AdjustingPosition + SignInt(1, backwards)), ActorCount)
	; Actors to swap
	actor adjusting = Positions[AdjustingPosition]
	actor moved = Positions[MovedTo]
	; Actor slots
	sslActorAlias AdjustAlias = ActorAlias(adjusting)
	sslActorAlias MovedAlias = ActorAlias(moved)
	; Shuffle
	actor[] NewPositions = Positions
	NewPositions[AdjustingPosition] = moved
	NewPositions[MovedTo] = adjusting
	Positions = NewPositions
	; Sync new positions
	RealignActors()
	AdjustChange(backwards)
	SendThreadEvent("PositionChange")
endFunction

function AdjustForward(bool backwards = false, bool adjuststage = false)
	float[] offsets = Animation.UpdateForward(AdjustingPosition, stage, SignFloat(1.0, backwards), adjuststage)
	sslActorAlias Slot = ActorSlot(AdjustingPosition)
	Slot.AlignTo(offsets, true)
endFunction

function AdjustSideways(bool backwards = false, bool adjuststage = false)
	float[] offsets = Animation.UpdateSide(AdjustingPosition, stage, SignFloat(1.0, backwards), adjuststage)
	sslActorAlias Slot = ActorSlot(AdjustingPosition)
	Slot.AlignTo(offsets, true)
endFunction

function AdjustUpward(bool backwards = false, bool adjuststage = false)
	float[] offsets = Animation.UpdateUp(AdjustingPosition, stage, SignFloat(1.0, backwards), adjuststage)
	sslActorAlias Slot = ActorSlot(AdjustingPosition)
	Slot.AlignTo(offsets, true)
endFunction

function RotateScene(bool backwards = false)
	AdjustRotation(SignFloat(45, backwards))
	SyncActors()
endFunction

function AdjustChange(bool backwards = false)
	AdjustingPosition = ArrayWrap((AdjustingPosition + SignInt(1, backwards)), ActorCount)
	Lib.mAdjustChange.Show((AdjustingPosition + 1))
endFunction

function RestoreOffsets()
	Animation.RestoreOffsets()
	RealignActors()
endFunction

function MoveScene()
	if !looping
		return ; Don't attempt when not looping
	endIf
	; Stop animation loop
	looping = false
	UnregisterForUpdate()
	; Enable Controls
	sslActorAlias Slot = ActorAlias(Lib.PlayerRef)
	Slot.UnlockActor()
	Slot.StopAnimating(true)
	Lib.PlayerRef.StopTranslation()
	; Lock hotkeys and wait 6 seconds
	Lib.mMoveScene.Show(6)
	float stopat = Utility.GetCurrentRealTime() + 6.0
	while stopat > Utility.GetCurrentRealTime()
		Utility.Wait(0.8)
	endWhile
	; Disable Controls
	Slot.LockActor()
	; Give player time to settle incase airborne
	Utility.Wait(1.0)
	; Recenter on coords to avoid stager + resync animations
	CenterOnObject(Lib.PlayerRef, true)
	RealignActors()
	; Return to animation loop
	looping = true
	RegisterForSingleUpdate(0.15)
endFunction

;/-----------------------------------------------\;
;|	Actor Manipulation                           |;
;\-----------------------------------------------/;

function RealignActors()
	SyncActors()
	PlayAnimation()
	MoveActors()
endFunction

function MoveActors()
	int i = ActorCount
	while i
		i -= 1
		ActorAlias[i].Snap()
	endWhile
endFunction

;/-----------------------------------------------\;
;|	Animation Functions                           |;
;\-----------------------------------------------/;

function SetAnimation(int anim = -1)
	; Randomize if -1
	if anim < 0
		anim = Utility.RandomInt(0, Animations.Length - 1)
	endIf
	aid = anim
	; Set SFX Marker
	sfxType = Lib.GetSFX(Animation.SFX)
	; Check for animation specific stage timer
	float stagetimer = Animation.GetStageTimer(stage)
	if stagetimer > 0.0
		UpdateTimer(stagetimer)
	endIf
endFunction

function PlayAnimation()
	; Send with as little overhead as possible to improve syncing
	string[] events = Animation.FetchStage(Stage)
	if ActorCount == 1
		Debug.SendAnimationEvent(Positions[0], events[0])
	elseIf ActorCount == 2
		Debug.SendAnimationEvent(Positions[0], events[0])
		Debug.SendAnimationEvent(Positions[1], events[1])
	elseIf ActorCount == 3
		Debug.SendAnimationEvent(Positions[0], events[0])
		Debug.SendAnimationEvent(Positions[1], events[1])
		Debug.SendAnimationEvent(Positions[2], events[2])
	elseIf ActorCount == 4
		Debug.SendAnimationEvent(Positions[0], events[0])
		Debug.SendAnimationEvent(Positions[1], events[1])
		Debug.SendAnimationEvent(Positions[2], events[2])
		Debug.SendAnimationEvent(Positions[3], events[3])
	elseIf ActorCount == 5
		Debug.SendAnimationEvent(Positions[0], events[0])
		Debug.SendAnimationEvent(Positions[1], events[1])
		Debug.SendAnimationEvent(Positions[2], events[2])
		Debug.SendAnimationEvent(Positions[3], events[3])
		Debug.SendAnimationEvent(Positions[4], events[4])
	endIf
endFunction

;/-----------------------------------------------\;
;|	Ending Functions                             |;
;\-----------------------------------------------/;

function EndAnimation(bool quick = false)
	UnregisterForUpdate()
	GoToState("")

	; TEMP DEBUG INFO
	; Animation.Enabled = false
	; Debug.Trace("########################################")
	; Debug.Trace("####  "+Animation.Name)
	; Debug.Trace("########################################")
	; int i
	; while i < ActorCount
	; 	Debug.Trace("###### POSITION: "+ i + " IsFemale: "+Animation.GetGender(i) == 1)
	; 	int stages = 1
	; 	while stages <= Animation.StageCount()
	; 		float[] offsets = Animation.GetPositionOffsets(i, stages)
	; 		string curStage = "Stage ["+stages+"/"+Animation.StageCount()+"]"
	; 		Debug.Trace(curStage+" "+Animation.FetchPositionStage(i, stages))
	; 		Debug.Trace(curStage+" Calculated Forward: "+Animation.CalculateForward(i, stages))
	; 		Debug.Trace(curStage+" Raw Forward: "+offsets[0])
	; 		Debug.Trace(curStage+" Side: "+offsets[1])
	; 		Debug.Trace(curStage+" Up: "+offsets[2])
	; 		Debug.Trace(curStage+" Rotate: "+offsets[3])
	; 		Debug.Trace(curStage+" Mouth: "+Animation.UseOpenMouth(i, stages))
	; 		Debug.Trace(curStage+" SOS: "+Animation.GetSchlong(i, stages))
	; 		stages += 1
	; 	endWhile
	; 	i += 1
	; endWhile

	; Set fast flag to skip slow ending functions
	FastEnd = quick
	Stage = Animation.StageCount
	if HasPlayer
		; Force camera to default state for ending
		Lib.ControlLib.ResetCamera()
		; Stop hotkeys to prevent further stage advancing
		Lib.ControlLib._HKClear()
	endIf
	; Send end event
	SendThreadEvent("AnimationEnd")
	; Reset actors & wait for clear state
	ActorAction("Reset", "")
	; Clear & Reset animation thread
	Initialize()
endFunction

function Initialize()
	UnregisterForUpdate()
	; Clear model
	parent.Initialize()
	; Set states
	looping = false
	; Empty Strings
	; Empty actors
	actor[] acDel
	; Empty Floats
	float[] fDel
	sfx = fDel
	timer = 0.0
	; Empty bools
	bool[] bDel
	; Empty integers
	int[] iDel
	AdjustingPosition = 0
	stagePrev = 0
	aid = 0
	; Empty forms
	sfxType = none
	GoToState("Unlocked")
endFunction

sslThreadController function PrimeThread()
	return none
endFunction

;/-----------------------------------------------\;
;|	Scene Manipulation                           |;
;\-----------------------------------------------/;

function CenterOnObject(ObjectReference centerOn, bool resync = true)
	parent.CenterOnObject(centerOn, resync)
	if resync && GetState() == "Animating"
		RealignActors()
		SendThreadEvent("ActorsRelocated")
	endIf
endFunction

function CenterOnCoords(float LocX = 0.0, float LocY = 0.0, float LocZ = 0.0, float RotX = 0.0, float RotY = 0.0, float RotZ = 0.0, bool resync = true)
	parent.CenterOnCoords(LocX, LocY, LocZ, RotX, RotY, RotZ, resync)
	if resync && GetState() == "Animating"
		RealignActors()
		SendThreadEvent("ActorsRelocated")
	endIf
endFunction
