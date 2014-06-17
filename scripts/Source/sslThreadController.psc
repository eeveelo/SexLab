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
		AutoAdvance = (!HasPlayer || (VictimRef == PlayerRef && Config.DisablePlayer) || Config.AutoAdvance)
		SetAnimation()
		AliasEvent("Prepare", 30.0)
	endFunction

	function PrepareDone()
		RegisterForSingleUpdate(0.01)
	endFunction

	event OnUpdate()
		; Start actor loops
		ActorAlias[0].StartAnimating()
		ActorAlias[1].StartAnimating()
		ActorAlias[2].StartAnimating()
		ActorAlias[3].StartAnimating()
		ActorAlias[4].StartAnimating()
		; Start time trackers
		float CurrentTime = Utility.GetCurrentRealTime()
		StartedAt = CurrentTime
		SkillTime = CurrentTime
		; Send starter events
		SendThreadEvent("AnimationStart")
		if LeadIn
			SendThreadEvent("LeadInStart")
		endIf
		; Begin animating loop
		Action("Advancing")
	endEvent

	function RecordSkills()
	endFunction
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
		SFXDelay   = ClampFloat(Config.SFXDelay - ((Stage * 0.3) * ((Stage != 1) as int)), 0.5, 30.0)
		AliasEvent("Sync", 10.0)
	endFunction
	function SyncDone()
		Action("Animating")
	endFunction
	event OnUpdate()
		Action("Animating")
	endEvent
endState

state Animating

	function FireAction()
		Log("Starting Stage: "+Stage, "Animating")
		PlayAnimation()
		; Send events
		if !LeadIn && Stage >= StageCount
			SendThreadEvent("OrgasmStart")
			if Config.OrgasmEffects
				TriggerOrgasm()
				return
			endIf
		else
			SendThreadEvent("StageStart")
		endIf
		; Begin loop
		StageTimer = Utility.GetCurrentRealTime() + GetTimer()
		RegisterForSingleUpdate(0.5)
	endFunction

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
		RegisterForSingleUpdate(0.5)
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
		UnregisterForUpdate()
		ActorAlias[0].SyncThread()
		ActorAlias[1].SyncThread()
		ActorAlias[2].SyncThread()
		ActorAlias[3].SyncThread()
		ActorAlias[4].SyncThread()
		PlayAnimation()
		ActorAlias[0].RefreshLoc()
		ActorAlias[1].RefreshLoc()
		ActorAlias[2].RefreshLoc()
		ActorAlias[3].RefreshLoc()
		ActorAlias[4].RefreshLoc()
		RegisterForSingleUpdate(0.4)
	endFunction

	function MoveActors()
		UnregisterForUpdate()
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
		RegisterForSingleUpdate(0.4)
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
		UnregisterforUpdate()
		GoToState("")
		; Find position to swap to
		int MovedPos = IndexTravel(AdjustPos, ActorCount, backwards)
		Actor MovedActor = PositionAlias(MovedPos).ActorRef
		Actor ReplacedActor = AdjustAlias.ActorRef
		; Shuffle actor positions
		Positions[AdjustPos] = MovedActor
		Positions[MovedPos] = ReplacedActor
		; Sync new positions
		AdjustPos = MovedPos
		UpdateAdjustKey()
		GoToState("Animating")
		RealignActors()
		MoveActors()
		SendThreadEvent("PositionChange")
		RegisterForSingleUpdate(0.4)
	endFunction

	function AdjustForward(bool backwards = false, bool adjustStage = false)
		Adjusted = true
		Animation.AdjustForward(AdjustKey, AdjustPos, Stage, SignFloat(backwards, 0.75), adjustStage)
		AdjustAlias.SyncLocation()
		while Input.IsKeyPressed(Config.AdjustForward)
			Animation.AdjustForward(AdjustKey, AdjustPos, Stage, SignFloat(backwards, 0.75), adjustStage)
			AdjustAlias.SyncLocation()
		endWhile
	endFunction

	function AdjustSideways(bool backwards = false, bool adjustStage = false)
		Adjusted = true
		Animation.AdjustSideways(AdjustKey, AdjustPos, Stage, SignFloat(backwards, 0.75), adjustStage)
		AdjustAlias.SyncLocation()
		while Input.IsKeyPressed(Config.AdjustSideways)
			Animation.AdjustSideways(AdjustKey, AdjustPos, Stage, SignFloat(backwards, 0.75), adjustStage)
			AdjustAlias.SyncLocation()
		endWhile
	endFunction

	function AdjustUpward(bool backwards = false, bool adjustStage = false)
		Adjusted = true
		Animation.AdjustUpward(AdjustKey, AdjustPos, Stage, SignFloat(backwards, 0.75), adjustStage)
		AdjustAlias.SyncLocation()
		while Input.IsKeyPressed(Config.AdjustSideways)
			Animation.AdjustUpward(AdjustKey, AdjustPos, Stage, SignFloat(backwards, 0.75), adjustStage)
			AdjustAlias.SyncLocation()
		endWhile
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
		StageTimer = Utility.GetCurrentRealTime() + GetTimer()
		RegisterForSingleUpdate(0.05)
	endFunction

	event OnKeyDown(int KeyCode)
		if hkReady && !Utility.IsInMenuMode() ; || UI.IsMenuOpen("Console") || UI.IsMenuOpen("Loading Menu")
			hkReady = false
			UnregisterForUpdate()
			Config.HotkeyCallback(self, KeyCode)
			RegisterForSingleUpdate(0.5)
			hkReady = true
		endIf
	endEvent
endState

function TriggerOrgasm()
	GoToState("Orgasm")
	AliasEvent("Orgasm", 5.0)
endFunction

state Orgasm
	function OrgasmDone()
		GoToState("Animating")
		StageTimer = Utility.GetCurrentRealTime() + GetTimer()
		RegisterForSingleUpdate(0.5)
	endFunction
	event OnUpdate()
		OrgasmDone()
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
	RecordSkills()
	UpdateAdjustKey()
	; Update animation info
	string[] Tags = Animation.GetTags()
	IsVaginal   = Tags.Find("Vaginal") != -1 && Females > 0
	IsAnal      = Tags.Find("Anal") != -1 || (Females == 0 && Tags.Find("Vaginal") != -1)
	IsOral      = Tags.Find("Oral") != -1
	IsLoving    = Tags.Find("Loving") != -1
	IsDirty     = Tags.Find("Dirty") != -1
	StageCount  = Animation.StageCount
	AnimEvents  = Animation.FetchStage(Stage)
	SetBonuses()
	; Inform player of animation being played now
	if HasPlayer
		SexLabUtil.PrintConsole("Playing Animation: " + Animation.Name)
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

function EndLeadIn()
	if LeadIn
		; Swap to non lead in animations
		Stage = 1
		LeadIn = false
		SetAnimation()
		; Add runtime to foreplay skill xp
		AddXP(0, (TotalTime / 14.0))
		; Restrip with new strip options
		AliasEvent("Strip")
		; Start primary animations at stage 1
		SendThreadEvent("LeadInEnd")
		Action("Advancing")
	endIf
endFunction

function EndAnimation(bool Quickly = false)
	UnregisterForUpdate()
	DisableHotkeys()
	RecordSkills()
	; Set fast flag to skip slow ending functions
	FastEnd = Quickly
	Stage = StageCount
	SendThreadEvent("AnimationEnding")
	; Send end event
	GoToState("Ending")
	AliasEvent("Reset", 30.0)
endFunction

state Ending
	function ResetDone()
		Log("Reset", "AliasEvent")
		RegisterForSingleUpdate(1.0)
	endFunction
	event OnUpdate()
		SendThreadEvent("AnimationEnd")
		; Export animations if adjusted
		if Adjusted && !HasCreature
			Config.ExportProfile(Config.AnimProfile)
		endIf
		; Clear thread and make available for new animation
		Initialize()
	endEvent
endState

; ------------------------------------------------------- ;
; --- System Use Only                                 --- ;
; ------------------------------------------------------- ;

function RecordSkills()
	float TimeNow = Utility.GetCurrentRealTime()
	float xp = ((TimeNow - SkillTime) / 15.0)
	AddXP(1, xp, IsVaginal)
	AddXP(2, xp, IsAnal)
	AddXP(3, xp, IsOral)
	AddXP(4, xp, IsLoving)
	AddXP(5, xp, IsDirty)
	SkillTime = TimeNow
endfunction

function SetBonuses()
	SkillBonus = new float[6]
	SkillBonus[0] = SkillXP[0]
	if IsVaginal
		SkillBonus[1] = 1.0 + SkillXP[1]
	endIf
	if IsAnal
		SkillBonus[2] = 1.0 + SkillXP[2]
	endIf
	if IsOral
		SkillBonus[3] = 1.0 + SkillXP[3]
	endIf
	if IsLoving
		SkillBonus[4] = 1.0 + SkillXP[4]
	endIf
	if IsDirty
		SkillBonus[5] = 1.0 + SkillXP[5]
	endIf
endFunction

function AddXP(int i, float Amount, bool Condition = true)
	if Condition && Amount >= 0.375 && SkillXP[i] < 6.0
		SkillXP[i] = SkillXP[i] + Amount
	endIf
endFunction

function EnableHotkeys()
	if HasPlayer
		; RegisterForKey(Config.kBackwards)
		; RegisterForKey(Config.kAdjustStage)
		RegisterForKey(Config.AdvanceAnimation)
		RegisterForKey(Config.ChangeAnimation)
		RegisterForKey(Config.ChangePositions)
		RegisterForKey(Config.AdjustChange)
		RegisterForKey(Config.AdjustForward)
		RegisterForKey(Config.AdjustSideways)
		RegisterForKey(Config.AdjustUpward)
		RegisterForKey(Config.RealignActors)
		RegisterForKey(Config.RestoreOffsets)
		RegisterForKey(Config.MoveScene)
		RegisterForKey(Config.RotateScene)
		RegisterForKey(Config.EndAnimation)
		hkReady = true
	endIf
endFunction

function DisableHotkeys()
	UnregisterForAllKeys()
	hkReady = false
endFunction

function Initialize()
	DisableHotkeys()
	SFXTimer    = 0.0
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
