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
float SFXDelay
float SFXTimer

; Processing
float StageTimer
bool TimedStage

; Hotkeys
int AdjustingPosition

;/-----------------------------------------------\;
;|	Primary Starter                              |;
;\-----------------------------------------------/;

state Making
	sslThreadController function PrimeThread()
		Stage = 1
		GotoState("Preparing")
		RegisterForSingleUpdate(0.05)
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
	; Wait for actors ready, or for ~30 seconds to pass
	float failsafe = 30.0
	while !ActorWait(stateFinish) && failsafe > 0.0
		Utility.Wait(0.50)
		failsafe -= 0.50
	endWhile
endFunction

state Preparing
	event OnUpdate()
		; Everything ready, send starting event
		SendThreadEvent("AnimationStart")
		; Set random starting animation
		SetAnimation()
		; Setup actors
		ActorAction("Prepare", "Ready")
		; Start ActorAlias animation loops from Ready state
		SyncActors(true)
		; Auto TFC
		if HasPlayer && Lib.ControlLib.bAutoTFC
			Lib.ControlLib.EnableFreeCamera(true)
		endIf
		; Send leadin start if doing one
		if LeadIn
			SendThreadEvent("LeadInStart")
		endIf
		; Begin first stage
		GoToState("Advancing")
		RegisterForSingleUpdate(0.05)
	endEvent
endState

;/-----------------------------------------------\;
;|	Animation Loops/Functions                    |;
;\-----------------------------------------------/;

float function GetTimer()
	; Custom acyclic stage timer
	if Animation.HasTimer(Stage)
		TimedStage = true
		return Animation.GetTimer(Stage)
	endIf
	; Default stage timers
	TimedStage = false
	int last = ( Timers.Length - 1 )
	if Stage < last
		return Timers[(Stage - 1)]
	elseIf Stage >= Animation.StageCount
		return Timers[last]
	endIf
	return Timers[(last - 1)]
endFunction

state Advancing
	event OnUpdate()
		; Stage start events
		; End animation
		if !LeadIn && Stage > Animation.StageCount
			Stage = Animation.StageCount
			EndAnimation()
			return ; No stage to advance to, end animation
		; End LeadIn stages
		elseIf LeadIn && Stage > Animation.StageCount
			; Disable free camera now to help prevent CTD
			bool toggled = Lib.ControlLib.TempToggleFreeCamera(HasPlayer, "LeadInEnd")
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
			; Renable free camera
			Lib.ControlLib.TempToggleFreeCamera(toggled, "LeadInEnd")
			SendThreadEvent("LeadInEnd")
			GoToStage(1)
			return ; Restart outisde of leadin
		; Orgasm stage begin
		elseIf !LeadIn && Stage >= Animation.StageCount
			; Play optional orgasm effects
			if Lib.bOrgasmEffects
				; Perform actor orgasm stuff
				PlayAnimation()
				int i = ActorCount
				while i
					i -= 1
					ActorAlias[i].OrgasmEffect()
				endWhile
				; Play Orgasm SFX
				Lib.OrgasmEffect.PlayAndWait(Positions[0])
				if Animation.SoundFX != none
					Sound.SetInstanceVolume(Animation.SoundFX.Play(Positions[0]), Lib.fSFXVolume)
				endIf
				Lib.OrgasmEffect.PlayAndWait(Positions[0])
				Sound.SetInstanceVolume(Lib.OrgasmEffect.Play(Positions[0]), Lib.fSFXVolume)
				SFXDelay = 0.50
			endIf
			; Send orgasm stage specific event
			SendThreadEvent("OrgasmStart")
		; Regular stage advance
		else
			SendThreadEvent("StageStart")
		endIf
		; Stage SFX Delay
		SFXDelay = Lib.fSFXDelay
		if Stage > 1
			SFXDelay -= (Stage * 0.2)
		endIf
		; min 0.50 delay
		if SFXDelay < 0.50
			SFXDelay = 0.50
		endIf
		; Start Animations loop
		GoToState("Animating")
	endEvent
endState

state Animating

	;/-----------------------------------------------\;
	;|	Primary Animation Loop                       |;
	;\-----------------------------------------------/;

	event OnBeginState()
		SyncActors()
		PlayAnimation()
		StageTimer = Utility.GetCurrentRealTime() + GetTimer()
		RegisterForSingleUpdate(0.05)
	endEvent

	event OnUpdate()
		; Advance stage on timer
		if (AutoAdvance || TimedStage) && StageTimer < Utility.GetCurrentRealTime()
			GoToStage((Stage + 1))
			return
		endIf
		; Play SFX
		SFXTimer -= 0.50
		if SFXTimer <= 0.0 && Animation.SoundFX != none
			Sound.SetInstanceVolume(Animation.SoundFX.Play(Positions[0]), Lib.fSFXVolume)
			SFXTimer = SFXDelay
		endIf
		; Loop
		RegisterForSingleUpdate(0.50)
	endEvent

	event OnEndState()
		if !LeadIn && Stage > Animation.StageCount
			SendThreadEvent("OrgasmEnd")
		else
			SendThreadEvent("StageEnd")
		endIf
	endEvent

	;/-----------------------------------------------\;
	;|	Hotkey Functions                             |;
	;\-----------------------------------------------/;

	function AdvanceStage(bool backwards = false)
		if !backwards
			GoToStage((Stage + 1))
		elseIf backwards && Stage > 1
			GoToStage((Stage - 1))
		endIf
	endFunction

	function ChangeAnimation(bool backwards = false)
		if Animations.Length == 1
			return ; Single animation selected, nothing to change to
		endIf
		SetAnimation(ArrayWrap((aid + SignInt(1, backwards)), Animations.Length))
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
		SyncActors(true)
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
		; Stop animation loop
		UnregisterForUpdate()
		; Enable Controls
		sslActorAlias Slot = ActorAlias(Lib.PlayerRef)
		Slot.UnlockActor()
		Slot.StopAnimating(true)
		Lib.PlayerRef.StopTranslation()
		; Lock hotkeys and wait 7 seconds
		Lib.mMoveScene.Show(7.0)
		StageTimer += 7.0
		SexLabUtil.Wait(7.0)
		; Disable Controls
		Slot.LockActor()
		; Give player time to settle incase airborne
		Utility.Wait(1.0)
		; Recenter on coords to avoid stager + resync animations
		if !LocateBed(true, 400.0)
			CenterOnObject(Lib.PlayerRef, true)
		endIf
		; Return to animation loop
		RegisterForSingleUpdate(0.05)
	endFunction

	;/-----------------------------------------------\;
	;|	Actor Manipulation                           |;
	;\-----------------------------------------------/;

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

	function GoToStage(int toStage)
		Stage = toStage
		GoToState("Advancing")
		RegisterForSingleUpdate(0.05)
	endFunction

	function RealignActors()
		SyncActors(true)
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

endState

;/-----------------------------------------------\;
;|	Animation Functions                           |;
;\-----------------------------------------------/;

function SetAnimation(int anim = -1)
	; Randomize if -1
	if anim < 0 || anim >= Animations.Length
		anim = Utility.RandomInt(0, Animations.Length - 1)
	endIf
	aid = anim
	; Print name of animation to console
	if HasPlayer
		MiscUtil.PrintConsole("Playing Animation: " + Animation.Name)
	endIf
	; Update stage timer for new animation
	StageTimer = Utility.GetCurrentRealTime() + GetTimer()
endFunction

;/-----------------------------------------------\;
;|	Ending Functions                             |;
;\-----------------------------------------------/;

function EndAnimation(bool quick = false)
	UnregisterForUpdate()
	GoToState("Ending")
	; Set fast flag to skip slow ending functions
	FastEnd = quick
	Stage = Animation.StageCount
	; Stop hotkeys to prevent further stage advancing + Leave TFC
	if HasPlayer
		Lib.ControlLib._HKClear()
	endIf
	; Reset actors & wait for clear state
	ActorAction("Reset", "")
	; Send end event
	SendThreadEvent("AnimationEnd")
	; Give AnimationEnd hooks some small room to breath
	if !FastEnd
		SexLabUtil.Wait(2.0)
	endIf
	; Clear & Reset animation thread
	Initialize()
endFunction

function Initialize()
	UnregisterForUpdate()
	; Empty integers
	AdjustingPosition = 0
	aid = 0
	; Clear model
	parent.Initialize()
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

;/-----------------------------------------------\;
;|	Empty state dependent functions              |;
;\-----------------------------------------------/;

; State Making
sslThreadController function PrimeThread()
	return none
endFunction
; State Animating
function PlayAnimation()
endFunction
function AdvanceStage(bool backwards = false)
endFunction
function ChangeAnimation(bool backwards = false)
endFunction
function ChangePositions(bool backwards = false)
endFunction
function AdjustForward(bool backwards = false, bool adjuststage = false)
endFunction
function AdjustSideways(bool backwards = false, bool adjuststage = false)
endFunction
function AdjustUpward(bool backwards = false, bool adjuststage = false)
endFunction
function RotateScene(bool backwards = false)
endFunction
function AdjustChange(bool backwards = false)
endFunction
function RestoreOffsets()
endFunction
function MoveScene()
endFunction
function RealignActors()
endFunction
function MoveActors()
endFunction
