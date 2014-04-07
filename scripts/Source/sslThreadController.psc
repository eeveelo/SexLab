scriptname sslThreadController extends sslThreadModel
{ Animation Thread Controller: Runs manipulation logic of thread based on information from model. Access only through functions; NEVER create a property directly to this. }

import sslUtility

; Animation
string[] AnimEvents
float SkillTime

; SFX
float SFXDelay
float SFXTimer

; Processing
bool hkReady
bool TimedStage
bool Adjusted
float StageTimer
int StageCount
int AdjustPos
sslActorAlias AdjustAlias

int Primed

; ------------------------------------------------------- ;
; --- Thread Starter                                  --- ;
; ------------------------------------------------------- ;

state Prepare
	function FireAction()
		AutoAdvance = (!HasPlayer || (VictimRef == PlayerRef && Config.bDisablePlayer) || Config.bAutoAdvance)
		SetAnimation()
		RegisterForSingleUpdate(30.0)
		AliasEvent("Prepare")
	endFunction

	function PrepareDone()
		RegisterForSingleUpdate(0.01)
	endFunction

	event OnUpdate()
		; Send starter events
		StartedAt = Utility.GetCurrentRealTime()
		SendThreadEvent("AnimationStart")
		if LeadIn
			SendThreadEvent("LeadInStart")
		endIf
		; Begin animating loop
		Action("Advancing")
	endEvent
endState

; ------------------------------------------------------- ;
; --- Animation Loop                                  --- ;
; ------------------------------------------------------- ;

state Advancing
	function FireAction()
		if Stage < 1
			Stage = 1
		elseIf Stage > StageCount
			if LeadIn
				EndLeadIn()
			else
				EndAnimation()
			endIf
			return
		endIf
		AnimEvents = Animation.FetchStage(Stage)
		SFXDelay   = ClampFloat(Config.fSFXDelay - ((Stage * 0.3) * ((Stage != 1) as int)), 0.5, 30.0)
		RegisterForSingleUpdate(10.0)
		AliasEvent("Sync")
	endFunction

	function SyncDone()
		; Log("Sync", "AliasDone")
		RegisterForSingleUpdate(0.01)
	endFunction

	event OnUpdate()
		GoToState("Animating")
		PlayAnimation()
		; Send events
		if !LeadIn && Stage >= StageCount
			SendThreadEvent("OrgasmStart")
			if Config.bOrgasmEffects
				AliasEvent("Orgasm", false)
			endIf
		else
			SendThreadEvent("StageStart")
		endIf
		; Begin loop
		Log("Starting Stage: "+Stage, "Advancing")
		StageTimer = Utility.GetCurrentRealTime() + GetTimer()
		RegisterForSingleUpdate(0.5)
	endEvent
endState

state Animating

	event OnUpdate()
		float CurrentTime = Utility.GetCurrentRealTime()
		; Advance stage on timer
		if (AutoAdvance || TimedStage) && StageTimer < CurrentTime
			GoToStage((Stage + 1))
			return
		endIf
		; Play SFX
		if SFXTimer < CurrentTime && Animation.SoundFX != none
			Animation.SoundFX.Play(CenterRef)
			SFXTimer = CurrentTime + SFXDelay
		endIf
		; Loop
		RegisterForSingleUpdate(0.2)
	endEvent

	function EndAction()
		if !LeadIn && Stage == StageCount
			SendThreadEvent("OrgasmEnd")
		else
			SendThreadEvent("StageEnd")
		endIf
	endFunction

	; ------------------------------------------------------- ;
	; --- Loop functions                                  --- ;
	; ------------------------------------------------------- ;

	function GoToStage(int ToStage)
		Stage = ToStage
		Action("Advancing")
	endFunction

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

	function RealignActors()
		ActorAlias[0].SyncThread()
		ActorAlias[1].SyncThread()
		ActorAlias[2].SyncThread()
		ActorAlias[3].SyncThread()
		ActorAlias[4].SyncThread()
		ActorAlias[0].SyncLocation(true)
		ActorAlias[1].SyncLocation(true)
		ActorAlias[2].SyncLocation(true)
		ActorAlias[3].SyncLocation(true)
		ActorAlias[4].SyncLocation(true)
		PlayAnimation()
	endFunction

	function MoveActors()
		ActorAlias[0].SyncThread()
		ActorAlias[1].SyncThread()
		ActorAlias[2].SyncThread()
		ActorAlias[3].SyncThread()
		ActorAlias[4].SyncThread()
		ActorAlias[0].SyncLocation(false)
		ActorAlias[1].SyncLocation(false)
		ActorAlias[2].SyncLocation(false)
		ActorAlias[3].SyncLocation(false)
		ActorAlias[4].SyncLocation(false)
	endFunction

	; ------------------------------------------------------- ;
	; --- Hotkey functions                                --- ;
	; ------------------------------------------------------- ;

	function AdvanceStage(bool backwards = false)
		if !backwards
			GoToStage((Stage + 1))
		elseIf backwards && Stage > 1
			GoToStage((Stage - 1))
		endIf
	endFunction

	function ChangeAnimation(bool backwards = false)
		SetAnimation(IndexTravel(Animations.Find(Animation), Animations.Length, backwards))
		SendThreadEvent("AnimationChange")
	endFunction

	function ChangePositions(bool backwards = false)
		if ActorCount < 2 || HasCreature
			return ; Solo/Creature Animation, nobody to swap with
		endIf
		; Find position to swap to
		int MovedPos = IndexTravel(AdjustPos, ActorCount, backwards)
		; Shuffle actor positions
		Positions[AdjustPos] = PositionAlias(MovedPos).ActorRef
		Positions[MovedPos] = AdjustAlias.ActorRef
		; Sync new positions
		AdjustPos = MovedPos
		UpdateAdjustKey()
		RealignActors()
		SendThreadEvent("PositionChange")
	endFunction

	function AdjustForward(bool backwards = false, bool adjustStage = false)
		Animation.AdjustForward(AdjustKey, AdjustPos, Stage, SignFloat(backwards, 0.75), adjustStage)
		AdjustAlias.SyncLocation()
		Adjusted = true
	endFunction

	function AdjustSideways(bool backwards = false, bool adjustStage = false)
		Animation.AdjustSideways(AdjustKey, AdjustPos, Stage, SignFloat(backwards, 0.75), adjustStage)
		AdjustAlias.SyncLocation()
		Adjusted = true
	endFunction

	function AdjustUpward(bool backwards = false, bool adjustStage = false)
		Animation.AdjustUpward(AdjustKey, AdjustPos, Stage, SignFloat(backwards, 0.75), adjustStage)
		AdjustAlias.SyncLocation()
		Adjusted = true
	endFunction

	function RotateScene(bool backwards = false)
		CenterLocation[5] = CenterLocation[5] + SignFloat(backwards, 45.0)
		if CenterLocation[5] >= 360.0
			CenterLocation[5] = CenterLocation[5] - 360.0
		elseIf CenterLocation[5] < 0.0
			CenterLocation[5] = CenterLocation[5] + 360.0
		endIf
		RealignActors()
	endFunction

	function AdjustChange(bool backwards = false)
		if ActorCount > 1
			AdjustPos = IndexTravel(Positions.Find(AdjustAlias.ActorRef), ActorCount, backwards)
			AdjustAlias = PositionAlias(AdjustPos)
			Debug.Notification("Adjusting Position For: "+AdjustAlias.ActorRef.GetLeveledActorBase().GetName())
		endIf
	endFunction

	function RestoreOffsets()
		Animation.RestoreOffsets(AdjustKey)
		RealignActors()
	endFunction

	function CenterOnObject(ObjectReference CenterOn, bool resync = true)
		parent.CenterOnObject(CenterOn, resync)
		if resync
			RealignActors()
			SendThreadEvent("ActorsRelocated")
		endIf
	endFunction

	function CenterOnCoords(float LocX = 0.0, float LocY = 0.0, float LocZ = 0.0, float RotX = 0.0, float RotY = 0.0, float RotZ = 0.0, bool resync = true)
		parent.CenterOnCoords(LocX, LocY, LocZ, RotX, RotY, RotZ, resync)
		if resync
			RealignActors()
			SendThreadEvent("ActorsRelocated")
		endIf
	endFunction

	function MoveScene()
		; Stop animation loop
		UnregisterForUpdate()
		; Enable Controls
		sslActorAlias Slot = ActorAlias(PlayerRef)
		Slot.UnlockActor()
		Debug.SendAnimationEvent(PlayerRef, "IdleForceDefaultState")
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

	event OnKeyDown(int KeyCode)
		if hkReady && !Utility.IsInMenuMode() ; || UI.IsMenuOpen("Console") || UI.IsMenuOpen("Loading Menu")
			hkReady = false
			Config.HotkeyCallback(self, KeyCode)
			hkReady = true
		endIf
	endEvent
endState

; ------------------------------------------------------- ;
; --- Context Sensitive Info                          --- ;
; ------------------------------------------------------- ;

function SetAnimation(int aid = -1)
	; Randomize if -1
	if aid < 0 || aid >= Animations.Length
		aid = Utility.RandomInt(0, (Animations.Length - 1))
	endIf
	; Set active animation
	Animation = Animations[aid]
	UpdateAdjustKey()
	RecordSkills()
	; Update animation info
	string[] Tags = Animation.GetTags()
	IsVaginal   = Tags.Find("Vaginal") != -1 && Females > 0
	IsAnal      = Tags.Find("Anal") != -1 || (Females == 0 && Tags.Find("Vaginal") != -1)
	IsOral      = Tags.Find("Oral") != -1
	IsLoving    = Tags.Find("Loving") != -1
	IsDirty     = Tags.Find("Dirty") != -1
	StageCount  = Animation.StageCount
	AnimEvents  = Animation.FetchStage(Stage)
	; Inform player of animation being played now
	if HasPlayer
		MiscUtil.PrintConsole("Playing Animation: " + Animation.Name)
	endIf
	; Check for out of range stage
	if Stage >= StageCount
		GoToStage((StageCount - 1))
	else
		StageTimer = Utility.GetCurrentRealTime() + GetTimer()
		PlayAnimation()
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

function UpdateTimer(float AddSeconds = 0.0)
	TimedStage = true
	StageTimer += AddSeconds
endFunction

function TriggerOrgasm()
	AliasEvent("Orgasm", false)
endFunction

function EndLeadIn()
	if LeadIn
		; Swap to non lead in animations
		Stage = 1
		LeadIn = false
		SetAnimation()
		; Add runtime to foreplay skill xp
		AddXP(0, (TotalTime / 11.0))
		; Restrip with new strip options
		AliasEvent("Strip", false)
		; Start primary animations at stage 1
		SendThreadEvent("LeadInEnd")
		Action("Advancing")
	endIf
endFunction

function EndAnimation(bool Quickly = false)
	UnregisterForUpdate()
	GoToState("Ending")
	DisableHotkeys()
	RecordSkills()
	; Set fast flag to skip slow ending functions
	FastEnd = Quickly
	Stage = StageCount
	; Send end event
	RegisterForSingleUpdate(15.0)
	SendThreadEvent("AnimationEnd")
	AliasEvent("Reset")
endFunction

state Ending
	function ResetDone()
		Log("Reset", "AliasEvent")
		RegisterForSingleUpdate(1.0)
	endFunction
	event OnUpdate()
		Initialize()
	endEvent
endState

; ------------------------------------------------------- ;
; --- System Use Only                                 --- ;
; ------------------------------------------------------- ;

function RecordSkills()
	float xp = ((Utility.GetCurrentRealTime() - SkillTime) / 15.0)
	AddXP(1, xp, IsVaginal)
	AddXP(2, xp, IsAnal)
	AddXP(3, xp, IsOral)
	AddXP(4, xp, IsLoving)
	AddXP(5, xp, IsDirty)
	; Log("ADDING XP: "+xp+" -- Foreplay: "+GetXP(0)+" Vaginal: "+GetXP(1)+" Anal: "+GetXP(2)+" Oral: "+GetXP(3))
	SkillTime = Utility.GetCurrentRealTime()
endfunction

function EnableHotkeys()
	if HasPlayer
		; RegisterForKey(Config.kBackwards)
		; RegisterForKey(Config.kAdjustStage)
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
		RegisterForKey(Config.kEndAnimation)
		hkReady = true
	endIf
endFunction

function DisableHotkeys()
	UnregisterForAllKeys()
	hkReady = false
endFunction

function Initialize()
	DisableHotkeys()
	SkillTime   = 0.0
	TimedStage  = false
	Adjusted    = false
	AdjustAlias = ActorAlias[0]
	parent.Initialize()
endFunction


auto state Unlocked
	function EndAnimation(bool Quickly = false)
	endFunction
endState

; ------------------------------------------------------- ;
; --- State Restricted                                --- ;
; ------------------------------------------------------- ;

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
function GoToStage(int ToStage)
endFunction
