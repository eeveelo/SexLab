scriptname sslThreadController extends sslThreadModel
{ Animation Thread Controller: Runs manipulation logic of thread based on information from model. Access only through functions; NEVER create a property directly to this. }

; Animation
int aid
sslBaseAnimation AnimCurrent
sslBaseAnimation property Animation hidden
	sslBaseAnimation function get()
		return AnimCurrent
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

bool function ActorsReady()
	int i
	while i < ActorCount
		if GetAlias(i).GetState() != "Ready"
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
		; Wait for actors ready, or for 5 seconds to pass
		float failsafe = Utility.GetCurrentRealTime() + 5.0
		while !ActorsReady() && failsafe > Utility.GetCurrentRealTime()
			Utility.Wait(0.20)
		endWhile
		if IsPlayerPosition(AdjustingPosition) && ActorCount > 1
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
			GetAlias(i).StartAnimating()
			i += 1
		endWhile
		started = Utility.GetCurrentRealTime()
		MoveActors()
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
					GetAlias(i).Strip(false)
					i += 1
				endWhile
			endIf
			RealignActors()
			SendThreadEvent("LeadInEnd")			
		endIf
		; Start Animations loop
		GoToState("Animating")
	endEvent
endState

state Animating
	event OnBeginState()
		if !LeadIn && Stage == Animation.StageCount
			SendThreadEvent("OrgasmStart")
		else
			SendThreadEvent("StageStart")
		endIf
		; Stage Delay
		if stage > 1
			sfx[0] = sfx[0] - (Stage * 0.2)
		endIf
		; min 0.75 delay
		if sfx[0] < 0.80
			sfx[0] = 0.80
		endIf
		; Inform ActorAlias of stage
		int i
		while i < ActorCount
			GetAlias(i).SyncThread(i)
			i += 1
		endWhile
		; Start animation looping
		PlayAnimation()
		looping = true
		UpdateTimer(Animation.GetStageTimer(stage))
		RegisterForSingleUpdate(0.10)
		; Check if realignment is needed
		if stagePrev != 0
			i = 0
			while i < ActorCount
				float[] prev = Animation.GetPositionOffsets(i, stagePrev)
				float[] next = Animation.GetPositionOffsets(i, stage)
				if (prev[0] != next[0]) || (prev[1] != next[1]) || (prev[2] != next[2])
					MoveActors()
					return
				endIf
				i += 1
			endWhile
		endIf
	endEvent
	event OnUpdate()
		if !looping
			return
		endIf
		timer = Utility.GetCurrentRealTime() - started
		if (autoAdvance || timedStage) && advanceAt < Utility.GetCurrentRealTime()
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
		if !LeadIn && Stage == Animation.StageCount
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
	if backwards
		aid = ArrayWrap((aid - 1), Animations.Length)
	else
		aid = ArrayWrap((aid + 1), Animations.Length)
	endIf
	SetAnimation(aid)
	RealignActors()
	SendThreadEvent("AnimationChange")
endFunction

function ChangePositions(bool backwards = false)
	if ActorCount < 2
		return ; Solo Animation, nobody to swap with
	endIf
	; Set direction of swapping
	int MovedTo
	if backwards
		MovedTo = ArrayWrap((AdjustingPosition - 1), ActorCount)
	else
		MovedTo = ArrayWrap((AdjustingPosition + 1), ActorCount)
	endIf
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
	AdjustAlias.SyncThread(GetPosition(adjusting))
	MovedAlias.SyncThread(GetPosition(moved))
	; Restart animations
	RealignActors()
	AdjustChange(backwards)
	SendThreadEvent("PositionChange")
endFunction

function AdjustForward(bool backwards = false, bool adjuststage = false)
	float adjustment = 0.75
	if backwards
		adjustment = adjustment * -1
	endIf
	if adjuststage
		Animation.UpdateForward(AdjustingPosition, stage, adjustment)
	else
		Animation.UpdateAllForward(AdjustingPosition, adjustment)
	endIf
	ActorAlias(Positions[AdjustingPosition]).AlignTo(CenterLocation)
endFunction

function AdjustSideways(bool backwards = false, bool adjuststage = false)
	float adjustment = 0.75
	if backwards
		adjustment = adjustment * -1
	endIf
	if adjuststage
		Animation.UpdateSide(AdjustingPosition, stage, adjustment)
	else
		Animation.UpdateAllSide(AdjustingPosition, adjustment)
	endIf
	ActorAlias(Positions[AdjustingPosition]).AlignTo(CenterLocation)
endFunction

function AdjustUpward(bool backwards = false, bool adjuststage = false)
	if IsPlayerPosition(AdjustingPosition)
		return
	endIf
	float adjustment = 0.75
	if backwards
		adjustment = adjustment * -1
	endIf
	if adjuststage
		Animation.UpdateUp(AdjustingPosition, stage, adjustment)
	else
		Animation.UpdateAllUp(AdjustingPosition, adjustment)
	endIf
	ActorAlias(Positions[AdjustingPosition]).AlignTo(CenterLocation)
endFunction

function RotateScene(bool backwards = false)
	; Adjust current center's Z angle
	float adjustment = 45
	if backwards
		adjustment = adjustment * -1
	endIf
	AdjustRotation(adjustment) 
	MoveActors()
endFunction

function AdjustChange(bool backwards = false)
	if backwards
		AdjustingPosition = ArrayWrap((AdjustingPosition - 1), ActorCount)
	else
		AdjustingPosition = ArrayWrap((AdjustingPosition + 1), ActorCount)
	endIf
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
	Game.SetPlayerAIDriven(false)
	; Renable clipping if TCL option on
	if Lib.Actors.bEnableTCL
		Debug.ToggleCollisions()
	endIf
	Debug.SendAnimationEvent(Lib.PlayerRef, "IdleForceDefaultState")
	; Lock hotkeys and wait 6 seconds
	Lib.mMoveScene.Show(6)
	float stopat = Utility.GetCurrentRealTime() + 6
	while stopat > Utility.GetCurrentRealTime()
		Utility.Wait(0.8)
	endWhile
	; Disable Controls
	Game.SetPlayerAIDriven(true)
	; Give player time to settle incase airborne
	Utility.Wait(1.0)
	; Disable clipping if TCL option on
	if Lib.Actors.bEnableTCL
		Debug.ToggleCollisions()
	endIf
	; Recenter on coords to avoid stager + resync animations
	float[] coords = GetCoords(GetPlayer())
	CenterOnCoords(coords[0], coords[1], coords[2], coords[3], coords[4], coords[5], true)
	; Return to animation loop
	looping = true
	RegisterForSingleUpdate(0.15)
endFunction

;/-----------------------------------------------\;
;|	Actor Manipulation                           |;
;\-----------------------------------------------/;

function RealignActors()
	int i
	while i < ActorCount
		GetAlias(i).AlignTo(CenterLocation)
		GetAlias(i).PlayAnimation()
		i += 1
	endWhile
endFunction

function MoveActors()
	int i
	while i < ActorCount
		GetAlias(i).AlignTo(CenterLocation)
		i += 1
	endWhile
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
	; Set current animation to play
	AnimCurrent = Animations[aid]
	; Set SFX Marker
	sfxType = Lib.GetSFX(Animation.SFX)
	; Update with new animation
	int i = 0
	while i < ActorCount
		GetAlias(i).SyncThread(i)
		i += 1
	endWhile
	; Check for animation specific stage timer
	float stagetimer = AnimCurrent.GetStageTimer(stage)
	if stagetimer > 0.0
		UpdateTimer(stagetimer)
	endIf
	; Notify play of animation name
	if HasPlayer()
		Debug.Notification(Animation.Name)
	endIf
endFunction

function PlayAnimation()
	int i
	while i < ActorCount
		GetAlias(i).PlayAnimation()
		i += 1
	endWhile
endFunction

;/-----------------------------------------------\;
;|	Ending Functions                             |;
;\-----------------------------------------------/;

function EndAnimation(bool quick = false)
	SendThreadEvent("AnimationEnd")
	SendActorEvent("EndThread", (quick as float))
	Utility.Wait(2.0)
	UnlockThread()
endFunction

function Initialize()
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
	started = 0.0
	; Empty bools
	bool[] bDel
	; Empty integers
	int[] iDel
	AdjustingPosition = 0
	stagePrev = 0
	aid = 0
	; Empty voice slots
	; Empty AnimationS
	AnimCurrent = none
	; Empty forms
	sfxType = none
endFunction

;/-----------------------------------------------\;
;|	API Functions                                |;
;\-----------------------------------------------/;

float function GetTime()
	return timer
endfunction