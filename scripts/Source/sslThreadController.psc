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
float started
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

sslThreadController function PrimeThread()
	if GetState() != "Making"
		return none
	endIf
	GotoState("Preparing")
	RegisterForSingleUpdate(0.12)
	return self
endFunction

bool function ActorWait(string waitfor)
	int i
	while i < ActorCount
		if ActorAlias[i].GetState() != waitfor
			return false
		endIf
		i += 1
	endWhile
	return true
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
		; Setup actors
		SendActorEvent("StartThread")
		; Wait for actors ready, or for 7 seconds to pass
		float failsafe = Utility.GetCurrentRealTime() + 7.0
		while !ActorWait("Ready") && failsafe > Utility.GetCurrentRealTime()
			Utility.Wait(0.20)
		endWhile
		if IsPlayerPosition(AdjustingPosition) && ActorCount > 1 && !HasCreature
			AdjustingPosition = ArrayWrap((AdjustingPosition + 1), ActorCount)
		endIf
		GotoState("Starting")
	endEvent
endState

;/-----------------------------------------------\;
;|	Animation Loops/Functions                    |;
;\-----------------------------------------------/;

function GoToStage(int toStage)
	; Stop looping
	looping = false
	UnregisterForUpdate()
	; Set upcoming stage
	stagePrev = stage
	if toStage < 0
		toStage = 0
	endIf
	Stage = toStage
	; Start advancement
	GoToState("Advancing")
	RegisterForSingleUpdate(0.10)
endFunction


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

state Starting
	event OnBeginState()
		SendThreadEvent("AnimationStart")
		if LeadIn
			SendThreadEvent("LeadInStart")
		endIf
		int i
		while i < ActorCount
			ActorAlias[i].StartAnimating()
			i += 1
		endWhile
		started = Utility.GetCurrentRealTime()
		GoToStage(1)
	endEvent
endState

state Advancing
	event OnUpdate()
		if !LeadIn && Stage > Animation.StageCount
			Stage = Animation.StageCount
			EndAnimation()
			return ; No stage to advance to, end animation
		elseIf LeadIn && Stage > Animation.StageCount
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
		; Start Animations loop
		GoToState("Animating")
	endEvent
endState

state Animating
	event OnBeginState()
		if !LeadIn && Stage >= Animation.StageCount
			SendThreadEvent("OrgasmStart")
		else
			SendThreadEvent("StageStart")
		endIf
		; Stage Delay
		if stage > 1
			sfx[0] = sfx[0] - (Stage * 0.2)
		endIf
		; min 0.80 delay
		if sfx[0] < 0.80
			sfx[0] = 0.80
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
		timer = Utility.GetCurrentRealTime() - started
		if (AutoAdvance || timedStage) && advanceAt < Utility.GetCurrentRealTime()
			GoToStage((Stage + 1))
			return ; End Stage
		endIf
		; Play SFX
		if sfx[0] <= timer - sfx[1] && sfxType != none
			Sound.SetInstanceVolume(sfxType.Play(Positions[0]), sfxVolume)
			sfx[1] = timer
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
	if !looping
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
	Slot.AlignTo(offsets)
	Slot.Snap(0.0)
endFunction

function AdjustSideways(bool backwards = false, bool adjuststage = false)
	float[] offsets = Animation.UpdateSide(AdjustingPosition, stage, SignFloat(1.0, backwards), adjuststage)
	sslActorAlias Slot = ActorSlot(AdjustingPosition)
	Slot.AlignTo(offsets)
	Slot.Snap(0.0)
endFunction

function AdjustUpward(bool backwards = false, bool adjuststage = false)
	float[] offsets = Animation.UpdateUp(AdjustingPosition, stage, SignFloat(1.0, backwards), adjuststage)
	sslActorAlias Slot = ActorSlot(AdjustingPosition)
	Slot.AlignTo(offsets)
	Slot.Snap(0.0)
endFunction

function RotateScene(bool backwards = false)
	AdjustRotation(SignFloat(45, backwards))
	UpdateLocations()
endFunction

function AdjustChange(bool backwards = false)
	AdjustingPosition = ArrayWrap((AdjustingPosition + SignInt(1, backwards)), ActorCount)
	Lib.mAdjustChange.Show((AdjustingPosition + 1))
endFunction

function RestoreOffsets()
	Animation.RestoreOffsets()
	RealignActors()
	MoveActors()
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
	; Lock hotkeys and wait 6 seconds
	Lib.mMoveScene.Show(6)
	float stopat = Utility.GetCurrentRealTime() + 6
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
	int i
	while i < ActorCount
		ActorAlias[i].Snap(0.0)
		i += 1
	endWhile
endFunction

function UpdateLocations()
	int i
	while i < ActorCount
		ActorSlot(i).AlignTo(Animation.GetPositionOffsets(i, stage))
		i += 1
	endWhile
	MoveActors()
endFunction

;/-----------------------------------------------\;
;|	Animation Functions                           |;
;\-----------------------------------------------/;

function SetAnimation(int anim = -1)
	if anim < 0 ; randomize if -1
		aid = utility.RandomInt(0, Animations.Length - 1)
	else
		aid = anim
	endIf
	; Set SFX Marker
	sfxType = Lib.GetSFX(Animation.SFX)
	; Check for animation specific stage timer
	float stagetimer = Animation.GetStageTimer(stage)
	if stagetimer > 0.0
		UpdateTimer(stagetimer)
	endIf
endFunction

function PlayAnimation()
	; Send extra settings, open mouth, silence, and sos
	int i = ActorCount
	while i
		i -= 1
		ActorAlias[i].AnimationExtras()
	endWhile
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
	; Reposition actors
	UpdateLocations()
endFunction

;/-----------------------------------------------\;
;|	Ending Functions                             |;
;\-----------------------------------------------/;

function EndAnimation(bool quick = false)
	SendThreadEvent("AnimationEnd")
	SendActorEvent("EndThread", (quick as float))
	; Wait for actors to clear, or for 5 seconds to pass
	float failsafe = Utility.GetCurrentRealTime() + 5.0
	while !ActorWait("") && failsafe > Utility.GetCurrentRealTime()
		Utility.Wait(0.20)
	endWhile
	UnlockThread()
endFunction

function Initialize()
	; Set states
	looping = false
	; Empty Strings
	; Empty actors
	actor[] acDel
	; Empty Floats
	float[] fDel
	sfx = fDel
	timer = 0.0
	started = 0.0
	; Empty bools
	bool[] bDel
	; Empty integers
	int[] iDel
	AdjustingPosition = 0
	stagePrev = 0
	aid = 0
	; Empty forms
	sfxType = none
	; Clear model
	parent.Initialize()
endFunction

;/-----------------------------------------------\;
;|	API Functions                                |;
;\-----------------------------------------------/;

float function GetTime()
	return timer
endfunction