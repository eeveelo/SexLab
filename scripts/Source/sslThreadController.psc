scriptname sslThreadController extends sslThreadModel
{ Animation Thread Controller: Runs manipulation logic of thread based on information from model. Access only through functions; NEVER create a property directly to this. }

; Animation
string[] AnimEvents

; SFX
float SFXDelay
float SFXTimer

; Processing
bool hkReady
bool TimedStage
float StageTimer
int StageCount
int AdjustPos
int aid

; ------------------------------------------------------- ;
; --- Thread Starter                                  --- ;
; ------------------------------------------------------- ;

state Preparing
	function FireAction()
		RegisterForSingleUpdate(0.05)
	endFunction
	event OnUpdate()
		; Init loop info
		Stage = 1
		SetAnimation()
		AutoAdvance = (!HasPlayer || (VictimRef == PlayerRef && Config.bDisablePlayer) || Config.bAutoAdvance)
		AliasAction("Prepare", "Ready")
		; Begin loop
		ActorAlias[0].StartAnimating()
		ActorAlias[1].StartAnimating()
		ActorAlias[2].StartAnimating()
		ActorAlias[3].StartAnimating()
		ActorAlias[4].StartAnimating()
		SendThreadEvent("AnimationStart")
		if LeadIn
			SendThreadEvent("LeadInStart")
		endIf
		StartedAt = Utility.GetCurrentRealTime()
		Action("Advancing")
	endEvent
endState

; ------------------------------------------------------- ;
; --- Animation Loop                                  --- ;
; ------------------------------------------------------- ;

state Advancing
	function FireAction()
		; End animation/leadin
		if Stage > StageCount
			if LeadIn
				return EndLeadIn()
			else
				return EndAnimation()
			endIf
		endIf
		; Stage SFX Delay
		SFXDelay = Config.fSFXDelay
		if Stage != 1
			SFXDelay -= (Stage * 0.2)
		endIf
		; min 0.60 delay
		if SFXDelay < 0.60
			SFXDelay = 0.60
		endIf
		; Start Animations loop
		Action("Animating")
	endFunction
endState

state Animating

	function FireAction()
		; Get animation events for stage
		AnimEvents = Animation.FetchStage(Stage)
		; Play animations
		SyncActors()
		PlayAnimation()
		; Send events
		if !LeadIn && Stage >= StageCount
			SendThreadEvent("OrgasmStart")
			; if Config.bOrgasmEffects
		; 		TriggerOrgasm()
		; 	endIf
		else
			SendThreadEvent("StageStart")
		endIf
		; Begin loop
		Log("Thread Animating Start Loop Stage: "+Stage)
		StageTimer = Utility.GetCurrentRealTime() + GetTimer()
		RegisterForSingleUpdate(0.05)
	endFunction

	event OnUpdate()
		; Advance stage on timer
		if (AutoAdvance || TimedStage) && StageTimer < Utility.GetCurrentRealTime()
			GoToStage((Stage + 1))
			return
		endIf
		; Play SFX
		SFXTimer -= 0.60
		if SFXTimer <= 0.0 && Animation.SoundFX != none
			Animation.SoundFX.Play(CenterRef)
			SFXTimer = SFXDelay
		endIf
		; Loop
		RegisterForSingleUpdate(0.60)
	endEvent

	function EndAction()
		if !LeadIn && Stage > StageCount
			SendThreadEvent("OrgasmEnd")
		else
			SendThreadEvent("StageEnd")
		endIf
	endFunction

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
		Action("Advancing")
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
		UpdateAdjustKey()
		SendThreadEvent("PositionChange")
	endFunction

	function AdjustForward(bool backwards = false, bool adjustStage = false)
		Animation.AdjustForward(AdjustKey, AdjustPos, Stage, sslUtility.SignFloat(backwards, 1.0), adjustStage)
		PositionAlias(AdjustPos).UpdateOffsets()
	endFunction

	function AdjustSideways(bool backwards = false, bool adjustStage = false)
		Animation.AdjustSideways(AdjustKey, AdjustPos, Stage, sslUtility.SignFloat(backwards, 1.0), adjustStage)
		PositionAlias(AdjustPos).UpdateOffsets()
	endFunction

	function AdjustUpward(bool backwards = false, bool adjustStage = false)
		Animation.AdjustUpward(AdjustKey, AdjustPos, Stage, sslUtility.SignFloat(backwards, 1.0), adjustStage)
		PositionAlias(AdjustPos).UpdateOffsets()
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
		Debug.Notification("Adjusting Position For: "+Positions[AdjustPos].GetLeveledActorBase().GetName())
	endFunction

	function RestoreOffsets()
		Animation.RestoreOffsets(AdjustKey)
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
		Debug.Notification("Player movement unlocked - repositioning scene in 7 seconds...")
		SexLabUtil.Wait(7.0)
		; Disable Controls
		Slot.LockActor()
		; Give player time to settle incase airborne
		Utility.Wait(1.0)
		; Recenter on coords to avoid stager + resync animations
		if !CenterOnBed(true, 400.0)
			CenterOnObject(PlayerRef, true)
		endIf
		; Return to animation loop
		StageTimer += 8.0
		RegisterForSingleUpdate(0.05)
	endFunction

	event OnKeyDown(int keyCode)
		if hkReady && !(Utility.IsInMenuMode() || UI.IsMenuOpen("Console") || UI.IsMenuOpen("Loading Menu"))
			hkReady = false
			Config.HotkeyCallback(self, keyCode)
			hkReady = true
		endIf
	endEvent

endState

; ------------------------------------------------------- ;
; --- Context Sensitive Info                          --- ;
; ------------------------------------------------------- ;

function SetAnimation(int AnimID = -1)
	; Randomize if -1
	aid = AnimID
	if AnimID < 0 || AnimID >= Animations.Length
		aid = Utility.RandomInt(0, (Animations.Length - 1))
	endIf
	if Animations[aid] == Animation
		return ; Nothings changed.
	endIf
	; Set active animation
	Animation = Animations[aid]
	if HasPlayer
		MiscUtil.PrintConsole("Playing Animation: " + Animation.Name)
	endIf
	; Update animation info
	UpdateAdjustKey()
	StageCount = Animation.StageCount
	IsVaginal = Animation.HasTag("Vaginal")
	IsAnal = Animation.HasTag("Anal")
	IsOral = Animation.HasTag("Oral")
	IsDirty = Animation.HasTag("Dirty")
	IsLoving = Animation.HasTag("Loving")
	AnimationStarted = Utility.GetCurrentRealTime()
	; Check for out of range stage
	if Stage >= StageCount
		GoToStage((StageCount - 1))
	else
		AnimEvents = Animation.FetchStage(Stage)
		SyncActors(false)
		PlayAnimation()
		StageTimer = Utility.GetCurrentRealTime() + GetTimer()
		MoveActors()
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
	elseIf Stage >= StageCount
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
	ThreadLib.OrgasmFX.PlayAndWait(Positions[0])
	if Animation.SoundFX != none
		Animation.SoundFX.PlayAndWait(Positions[0])
	endIf
	ThreadLib.OrgasmFX.PlayAndWait(Positions[0])
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
	Action("Advancing")
endFunction

function EndAnimation(bool Quickly = false)
	UnregisterForUpdate()
	GoToState("Ending")
	; Set fast flag to skip slow ending functions
	FastEnd = Quickly
	Stage = StageCount
	; Reset actors & wait for clear state
	AliasAction("Reset", "")
	; Send end event
	SendThreadEvent("AnimationEnd")
	if !Quickly
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

function EnableHotkeys()
	if HasPlayer
		RegisterForKey(Config.kBackwards)
		RegisterForKey(Config.kAdjustStage)
		RegisterForKey(Config.kAdvanceAnimation)
		RegisterForKey(Config.kChangeAnimation)
		RegisterForKey(Config.kChangePositions)
		RegisterForKey(Config.kAdjustChange)
		RegisterForKey(Config.kAdjustForward)
		RegisterForKey(Config.kAdjustSideways)
		RegisterForKey(Config.kAdjustUpward)
		RegisterForKey(Config.kRealignActors)
		RegisterForKey(Config.kRestoreOffsets)
		RegisterForKey(Config.kMoveScene)
		RegisterForKey(Config.kRotateScene)
		hkReady = true
		; RegisterForKey(Config.kToggleFreeCamera)
	endIf
endFunction

function DisableHotkeys()
	UnregisterForAllKeys()
	hkReady = false
endFunction

function Initialize()
	DisableHotkeys()
	aid        = 0
	AdjustPos  = 0
	TimedStage = false
	parent.Initialize()
endFunction

state Making
	sslThreadController function PrimeThread()
		Log("Thread Primed")
		Action("Preparing")
		return self
	endFunction
	function SetAnimation(int AnimID = -1)
	endFunction
	function EnableHotkeys()
	endFunction
endState

auto state Unlocked
	function EndAnimation(bool Quickly = false)
	endFunction
endState

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
; State varied
function FireAction()
endFunction
function EndAction()
endFunction
