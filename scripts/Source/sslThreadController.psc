scriptname sslThreadController extends sslThreadModel
{ Animation Thread Controller: Runs manipulation logic of thread based on information from model. Access only through functions; NEVER create a property directly to this. }

; Animation
sslBaseAnimation property Animation auto hidden
string[] AnimEvents

; SFX
float SFXDelay
float SFXTimer

; Processing
float StageTimer
bool TimedStage
int AdjustPos
int aid


; ------------------------------------------------------- ;
; --- Thread Starter                                  --- ;
; ------------------------------------------------------- ;

state Making
	sslThreadController function PrimeThread()
		Stage = 1
		GotoState("Preparing")
		RegisterForSingleUpdate(0.05)
		return self
	endFunction
endState

state Preparing
	event OnUpdate()
		SetAnimation()
		SendThreadEvent("AnimationStart")
		ActorAction("Prepare", "Ready")
		; Start ActorAlias animation loops from Ready state
		SyncActors(true)
		; Auto TFC
		if HasPlayer && Config.bAutoTFC
			;ControlLib.EnableFreeCamera(true)
		endIf
		; Send leadin start if doing one
		if LeadIn
			SendThreadEvent("LeadInStart")
		endIf
		; Begin first stage
		GoToState("Advancing")
		RegisterForSingleUpdate(0.10)
	endEvent
endState

; ------------------------------------------------------- ;
; --- Animation Loop                                  --- ;
; ------------------------------------------------------- ;

state Advancing
	event OnUpdate()
		; End animation
		if !LeadIn && Stage > Animation.StageCount
			EndAnimation()
		; End LeadIn stages
		elseIf LeadIn && Stage > Animation.StageCount
			EndLeadIn()
		else
			; Stage SFX Delay
			SFXDelay = Config.fSFXDelay
			if Stage > 1
				SFXDelay -= (Stage * 0.2)
			endIf
			; min 0.60 delay
			if SFXDelay < 0.60
				SFXDelay = 0.60
			endIf
			; Start Animations loop
			GoToState("Animating")
		endIf
	endEvent
endState

state Animating
	event OnBeginState()
		; Get animation events for stage
		AnimEvents = Animation.FetchStage(Stage)
		; Play animations
		SyncActors()
		PlayAnimation()
		; Send events
		if !LeadIn && Stage >= Animation.StageCount
			SendThreadEvent("OrgasmStart")
			if Config.bOrgasmEffects
				TriggerOrgasm()
			endIf
		else
			SendThreadEvent("StageStart")
		endIf
		; Begin loop
		StageTimer = Utility.GetCurrentRealTime() + GetTimer()
		RegisterForSingleUpdate(0.10)
	endEvent
	event OnUpdate()
		; Advance stage on timer
		if (AutoAdvance || TimedStage) && StageTimer < Utility.GetCurrentRealTime()
			GoToStage((Stage + 1))
			return
		endIf
		; Play SFX
		SFXTimer -= 0.60
		if SFXTimer <= 0.0 && Animation.SoundFX != none
			Animation.SoundFX.Play(Positions[0])
			SFXTimer = SFXDelay
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

	; ------------------------------------------------------- ;
	; --- Loop functions                                  --- ;
	; ------------------------------------------------------- ;

	function PlayAnimation()
		; Send with as little overhead as possible to improve syncing
		if ActorCount == 1
			Debug.SendAnimationEvent(Positions[0], AnimEvents[0])
		elseIf ActorCount == 2
			Debug.SendAnimationEvent(Positions[0], AnimEvents[0])
			Debug.SendAnimationEvent(Positions[1], AnimEvents[1])
		elseIf ActorCount == 3
			Debug.SendAnimationEvent(Positions[0], AnimEvents[0])
			Debug.SendAnimationEvent(Positions[1], AnimEvents[1])
			Debug.SendAnimationEvent(Positions[2], AnimEvents[2])
		elseIf ActorCount == 4
			Debug.SendAnimationEvent(Positions[0], AnimEvents[0])
			Debug.SendAnimationEvent(Positions[1], AnimEvents[1])
			Debug.SendAnimationEvent(Positions[2], AnimEvents[2])
			Debug.SendAnimationEvent(Positions[3], AnimEvents[3])
		elseIf ActorCount == 5
			Debug.SendAnimationEvent(Positions[0], AnimEvents[0])
			Debug.SendAnimationEvent(Positions[1], AnimEvents[1])
			Debug.SendAnimationEvent(Positions[2], AnimEvents[2])
			Debug.SendAnimationEvent(Positions[3], AnimEvents[3])
			Debug.SendAnimationEvent(Positions[4], AnimEvents[4])
		endIf
	endFunction

	function GoToStage(int toStage)
		Stage = toStage
		if Stage < 1
			Stage = 1
		endIf
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
			; ActorAlias[i].Snap()
		endWhile
	endFunction

	; ------------------------------------------------------- ;
	; --- Hotkey functions                                  --- ;
	; ------------------------------------------------------- ;

	function AdvanceStage(bool backwards = false)
		if !backwards
			GoToStage((Stage + 1))
		elseIf backwards && Stage > 1
			GoToStage((Stage - 1))
		endIf
	endFunction

	function ChangeAnimation(bool backwards = false)
		SetAnimation(sslUtility.WrapIndex((aid + sslUtility.SignInt(backwards, 1)), Animations.Length))
		SendThreadEvent("AnimationChange")
		RealignActors()
	endFunction

	function ChangePositions(bool backwards = false)
		if ActorCount < 2 || HasCreature
			return ; Solo/Creature Animation, nobody to swap with
		endIf
		; Set direction of swapping
		int MovedTo = sslUtility.WrapIndex((AdjustPos + sslUtility.SignInt(backwards, 1)), ActorCount)
		; Shuffle
		actor adjusting = Positions[AdjustPos]
		actor moved = Positions[MovedTo]
		Positions[AdjustPos] = moved
		Positions[MovedTo] = adjusting
		; Sync new positions
		RealignActors()
		AdjustChange(backwards)
		SendThreadEvent("PositionChange")
	endFunction

	function AdjustForward(bool backwards = false, bool adjuststage = false)
		; ActorAlias[AdjustPos].AlignTo(Animation.UpdateForward(AdjustPos, stage, sslUtility.SignFloat(backwards, 1.0), adjuststage), true)
	endFunction

	function AdjustSideways(bool backwards = false, bool adjuststage = false)
		; ActorAlias[AdjustPos].AlignTo(Animation.UpdateSide(AdjustPos, stage, sslUtility.SignFloat(backwards, 1.0), adjuststage), true)
	endFunction

	function AdjustUpward(bool backwards = false, bool adjuststage = false)
		; ActorAlias[AdjustPos].AlignTo(Animation.UpdateUp(AdjustPos, stage, sslUtility.SignFloat(backwards, 1.0), adjuststage), true)
	endFunction

	function RotateScene(bool backwards = false)
		CenterLocation[5] = CenterLocation[5] + sslUtility.SignFloat(backwards, 45.0)
		if CenterLocation[5] >= 360.0
			CenterLocation[5] = CenterLocation[5] - 360.0
		elseIf CenterLocation[5] < 0.0
			CenterLocation[5] = CenterLocation[5] + 360.0
		endIf
		SyncActors(true)
	endFunction

	function AdjustChange(bool backwards = false)
		AdjustPos = sslUtility.WrapIndex((AdjustPos + sslUtility.SignInt(backwards, 1)), ActorCount)
		ThreadLib.mAdjustChange.Show((AdjustPos + 1))
	endFunction

	function RestoreOffsets()
		Animation.RestoreOffsets()
		RealignActors()
	endFunction

	function MoveScene()
		; Stop animation loop
		UnregisterForUpdate()
		; Enable Controls
		sslActorAlias Slot = ActorAlias(PlayerRef)
		Slot.UnlockActor()
		; Slot.StopAnimating(true)
		PlayerRef.StopTranslation()
		; Lock hotkeys and wait 7 seconds
		ThreadLib.mMoveScene.Show(7.0)
		SexLabUtil.Wait(7.0)
		; Disable Controls
		Slot.LockActor()
		; Give player time to settle incase airborne
		Utility.Wait(1.0)
		; Recenter on coords to avoid stager + resync animations
		if !LocateBed(true, 400.0)
			CenterOnObject(PlayerRef, true)
		endIf
		; Return to animation loop
		StageTimer += 8.0
		RegisterForSingleUpdate(0.05)
	endFunction

endState

; ------------------------------------------------------- ;
; --- Context Sensitive Info                          --- ;
; ------------------------------------------------------- ;

function SetAnimation(int anim = -1)
	; Randomize if -1
	aid = anim
	if anim < 0 || anim >= Animations.Length
		aid = Utility.RandomInt(0, (Animations.Length - 1))
	endIf
	Animation = Animations[aid]
	; Print name of animation to console
	if HasPlayer
		MiscUtil.PrintConsole("Playing Animation: " + Animation.Name)
	endIf
	; Check for out of range stage
	if Stage >= Animation.StageCount
		GoToStage((Animation.StageCount - 1))
	else
		AnimEvents = Animation.FetchStage(Stage)
		StageTimer = Utility.GetCurrentRealTime() + GetTimer()
	endIf
endFunction

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

function TriggerOrgasm()
	; Perform actor orgasm stuff
	int i = ActorCount
	while i
		i -= 1
		; ActorAlias[i].OrgasmEffect()
	endWhile
	; Play Orgasm SFX
	ThreadLib.OrgasmEffect.PlayAndWait(Positions[0])
	if Animation.SoundFX != none
		Animation.SoundFX.PlayAndWait(Positions[0])
	endIf
	ThreadLib.OrgasmEffect.PlayAndWait(Positions[0])
	if Animation.SoundFX != none
		Animation.SoundFX.PlayAndWait(Positions[0])
	endIf
endFunction

function EndLeadIn()
	; Swap to non lead in animations
	Stage = 1
	LeadIn = false
	SetAnimation()
	if Animation.IsSexual
		; Restrip with new strip options
		int i = ActorCount
		while i
			i -= 1
			; ActorAlias[i].Strip(false)
		endWhile
	endIf
	; Start primary animations at stage 1
	SendThreadEvent("LeadInEnd")
	GoToState("Advancing")
	RegisterForSingleUpdate(0.10)
endFunction

function EndAnimation(bool quick = false)
	UnregisterForUpdate()
	GoToState("Ending")
	; Set fast flag to skip slow ending functions
	FastEnd = quick
	Stage = Animation.StageCount
	; Stop hotkeys to prevent further stage advancing + Leave TFC
	if HasPlayer
		; Lib.ControlLib._HKClear()
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

function CenterOnObject(ObjectReference CenterOn, bool resync = true)
	parent.CenterOnObject(CenterOn, resync)
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

; ------------------------------------------------------- ;
; --- System Use Only                                 --- ;
; ------------------------------------------------------- ;

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
	int failsafe = 30
	while !ActorWait(stateFinish) && failsafe
		Utility.Wait(1.0)
		failsafe -= 1
	endWhile
endFunction

function SyncActors(bool force = false)
endFunction

function Initialize()
	UnregisterForUpdate()
	aid = 0
	AdjustPos = 0
	parent.Initialize()
endFunction

; ------------------------------------------------------- ;
; --- State Restricted                                --- ;
; ------------------------------------------------------- ;

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
function GoToStage(int toStage)
endFunction
