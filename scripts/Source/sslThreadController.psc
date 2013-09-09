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

; Hotkeys
int AdjustingPosition
bool MovingScene

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
		if ActorAlias(i).GetState() != "Ready"
			return false
		endIf
		i += 1
	endWhile
	return true
endFunction

state Preparing
	event OnUpdate()
		Debug.TraceAndBox("ThreadView["+tid+"]: "+GetState()+" :: Preparing")
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
			AdjustingPosition = PositionWrap((AdjustingPosition + 1))
		endIf
		GotoState("BeginLoop")
	endEvent
endState

;/-----------------------------------------------\;
;|	Animation Loops                              |;
;\-----------------------------------------------/;

state BeginLoop
	event OnBeginState()
		Debug.TraceAndBox("ThreadView["+tid+"]: "+GetState()+" :: BeginLoop")

		SendThreadEvent("AnimationStart")
		if LeadIn
			SendThreadEvent("LeadInStart")
		endIf

		int i
		while i < ActorCount
			ActorAlias(i).StartAnimating()
			i += 1
		endWhile

		started = Utility.GetCurrentRealTime()
		MoveActors()
		GoToStage(1)
	endEvent
endState

state Advance
	event OnUpdate()
		UnregisterForUpdate()
		if !LeadIn && Stage > Animation.StageCount
			EndAnimation()
			return ; Stop
		elseIf LeadIn && Stage > Animation.StageCount
			; Swap to non lead in animations
			Stage = 1
			LeadIn = false
			SetAnimation()
			; Restrip with new strip options
			if Animation.IsSexual
				int i
				while i < ActorCount
					form[] equipment = Lib.Actors.StripSlots(Positions[i], GetStrip(Positions[i]), false)
					ActorAlias(i).StoreEquipment(equipment)
					i += 1
				endWhile
			endIf
			RealignActors()
			SendThreadEvent("LeadInEnd")			
		endIf
		; Inform ActorAlias of stage
		int i
		while i < ActorCount
			ActorAlias(i).ToStage(Stage)
			i += 1
		endWhile
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
		; Start animation looping
		PlayAnimation()
		looping = true
		advanceAt = Utility.GetCurrentRealTime() + StageTimer()
		RegisterForSingleUpdate(0.10)
	endEvent
	event OnUpdate()
		if !looping
			return
		endIf
		timer = Utility.GetCurrentRealTime() - started
		if autoAdvance && advanceAt < Utility.GetCurrentRealTime()
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
	if !backwards
		GoToStage((Stage + 1))
	elseIf backwards && stage > 1
		GoToStage((Stage - 1))
	endIf
endFunction

function ChangeAnimation(bool backwards = false)
	if !looping || Animations.Length == 1
		return ; Single animation selected, nothing to change to
	endIf
	if !backwards
		aid += 1
	else
		aid -= 1
	endIf
	if aid >= Animations.Length
		aid = 0
	elseIf aid < 0
		aid = Animations.Length - 1
	endIf

	SetAnimation(aid)

	RealignActors()

	SendThreadEvent("AnimationChange")
endFunction

function ChangePositions(bool backwards = false)
	if !looping || ActorCount < 2
		return ; Solo Animation, nobody to swap with
	endIf
	; Set direction of swapping
	int MovedTo
	if backwards
		MovedTo = PositionWrap((AdjustingPosition - 1))
	else
		MovedTo = PositionWrap((AdjustingPosition + 1))
	endIf
	; Actors to swap
	actor adjusting = Positions[AdjustingPosition]
	actor moved = Positions[MovedTo]
	; Actor slots
	sslActorAlias AdjustAlias = GetActorAlias(adjusting)
	sslActorAlias MovedAlias = GetActorAlias(moved)
	; Shuffle
	actor[] NewPositions = Positions
	NewPositions[AdjustingPosition] = moved
	NewPositions[MovedTo] = adjusting
	Positions = NewPositions
	; Removed extras/strapons
	AdjustAlias.RemoveExtras()
	MovedAlias.RemoveExtras()
	; Update positions
	AdjustAlias.ToPosition(GetPosition(adjusting))
	MovedAlias.ToPosition(GetPosition(moved))
	; Equip new extras
	AdjustAlias.EquipExtras()
	MovedAlias.EquipExtras()
	; Restart animations
	RealignActors()
	AdjustChange(backwards)
	SendThreadEvent("PositionChange")
endFunction

function AdjustForward(bool backwards = false, bool adjuststage = false)
	if !looping
		return
	endIf
	float adjustment = 0.75
	if backwards
		adjustment = adjustment * -1
	endIf
	if adjuststage
		Animation.UpdateForward(AdjustingPosition, stage, adjustment)
	else
		Animation.UpdateAllForward(AdjustingPosition, adjustment)
	endIf
	MoveActor(AdjustingPosition)
endFunction

function AdjustSideways(bool backwards = false, bool adjuststage = false)
	if !looping
		return
	endIf
	float adjustment = 0.75
	if backwards
		adjustment = adjustment * -1
	endIf
	if adjuststage
		Animation.UpdateSide(AdjustingPosition, stage, adjustment)
	else
		Animation.UpdateAllSide(AdjustingPosition, adjustment)
	endIf
	MoveActor(AdjustingPosition)
endFunction

function AdjustUpward(bool backwards = false, bool adjuststage = false)
	if !looping || IsPlayerPosition(AdjustingPosition)
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
	MoveActor(AdjustingPosition)
endFunction

function RotateScene(bool backwards = false)
	if !looping
		return
	endIf
	; Adjust current center's Z angle
	float adjustment = 45
	if backwards
		adjustment = adjustment * -1
	endIf
	UpdateRotation(adjustment) 
	MoveActors()
endFunction

function AdjustChange(bool backwards = false)
	if !looping
		return
	endIf
	if backwards
		AdjustingPosition -= 1 
	else
		AdjustingPosition += 1
	endIf
	AdjustingPosition = PositionWrap(AdjustingPosition)
	Lib.mAdjustChange.Show((AdjustingPosition + 1))
endFunction

function RestoreOffsets()
	if !looping
		return
	endIf
	Animation.RestoreOffsets()
	RealignActors()
endFunction

function MoveScene()
	if !looping
		return
	endIf
	bool advanceToggle
	; Toggle auto advance off
	if autoAdvance
		started -= 8.0
		autoAdvance = false
		advanceToggle = true
	endIf
	; Enable Controls
	MovingScene = true
	Game.SetPlayerAIDriven(false)
	;Game.EnablePlayerControls()
	Debug.SendAnimationEvent(Lib.PlayerRef, "IdleForceDefaultState")
	; Lock hotkeys here for timer
	Lib.mMoveScene.Show(6)
	float stopat = Utility.GetCurrentRealTime() + 6
	while stopat > Utility.GetCurrentRealTime()
		Utility.Wait(0.8)
	endWhile
	; Disable Controls
	;Game.DisablePlayerControls(true, true, true, false, true, false, false, true, 0)
	Game.SetPlayerAIDriven()
	; Give player time to settle incase airborne
	Utility.Wait(1.0)
	; Recenter + sync
	CenterOnObject(GetPlayer(), true)
	; Toggle auto advance back
	if advanceToggle
		autoAdvance = true
	endIf
	MovingScene = false
endFunction

function RealignActors()
	PlayAnimation()
	MoveActors()
endFunction

;/-----------------------------------------------\;
;|	Actor Manipulation                           |;
;\-----------------------------------------------/;

function GoToStage(int toStage)
	looping = false
	stagePrev = stage
	if toStage < 0
		toStage = 0
	endIf
	Stage = toStage
	GoToState("Advance")
	RegisterForSingleUpdate(0.10)
endFunction

; TODO: add check for animation async timer here
float function StageTimer()
	int last = ( Timers.Length - 1 )
	if stage < last
		return Timers[(stage - 1)]
	elseif stage >= Animation.StageCount
		return Timers[last]
	endIf
	return Timers[(last - 1)]
endfunction

function MoveActor(int position)
	actor a = Positions[position]
	float[] offsets = Animation.GetPositionOffsets(position, stage)
	float[] center = CenterLocation
	float[] loc = new float[6]

	; Determine offsets coordinates from center
	loc[0] = ( center[0] + ( Math.sin(center[5]) * offsets[0] + Math.cos(center[5]) * offsets[1] ) )
	loc[1] = ( center[1] + ( Math.cos(center[5]) * offsets[0] + Math.sin(center[5]) * offsets[1] ) )
	loc[2] = ( center[2] + offsets[2] )
	; Determine rotation coordinates from center
	loc[3] = center[3]
	loc[4] = center[4]
	loc[5] = ( center[5] + offsets[3] )
	if loc[5] >= 360
		loc[5] = ( loc[5] - 360 )
	elseIf loc[5] < 0
		loc[5] = ( loc[5] + 360 )
	endIf
	a.SetPosition(loc[0], loc[1], loc[2])
	a.SetAngle(loc[3], loc[4], loc[5])
endFunction

function MoveActors()
	int i
	while i < actorCount
		MoveActor(i)
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
		sslActorAlias Slot = GetActorAlias(Positions[i])
		Slot.ToStage(Stage)
		Slot.ToPosition(i)
		Slot.ToAnimation(Animation)
		i += 1
	endWhile

endFunction

function PlayAnimation()
	int i
	while i < ActorCount
		ActorAlias(i).PlayAnimation()
		i += 1
	endWhile
endFunction

;/-----------------------------------------------\;
;|	Ending Functions                             |;
;\-----------------------------------------------/;


function EndAnimation(bool quick = false)
	UnregisterForUpdate()
	looping = false

	SendThreadEvent("AnimationEnd")

	if !quick
		; Apply Cum
		; if Animation.IsSexual && Lib.Actors.bUseCum
		; 	int[] genders = Lib.Actors.GenderCount(positions)
		; 	if genders[0] > 0 || Lib.Actors.bAllowFFCum
		; 		int i
		; 		while i < ActorCount
		; 			Lib.Actors.ApplyCum(Positions[i], Animation.GetCum(i))
		; 			i += 1
		; 		endWhile
		; 	endIf
		; endIf
		; Reset Actor & Clear Alias
		SendActorEvent("EndThread")
		Utility.Wait(2.0)
	else
		; Reset Actor & Clear Alias (Quickly)
		SendActorEvent("QuickEndThread")
	endIf

	UnlockThread()
	SendThreadEvent("ThreadClear")
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
;|	Chain Events                                 |;
;\-----------------------------------------------/;

function SendActorEvent(string callback)
	int i
	while i < ActorCount
		ActorAlias(i).ActorEvent(callback)
		i += 1
	endWhile
endFunction

;/-----------------------------------------------\;
;|	API Functions                                |;
;\-----------------------------------------------/;

float function GetTime()
	return timer
endfunction