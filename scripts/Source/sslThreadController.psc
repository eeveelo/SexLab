scriptname sslThreadController extends sslThreadModel
{ Animation Thread Controller: Runs manipulation logic of thread based on information from model. Access only through functions; NEVER create a property directly to this. }

import PapyrusUtil

; Animation
float SkillTime

; SFX
float BaseDelay
float SFXDelay
float SFXTimer

; Processing
bool TimedStage
float StageTimer
int StageCount

; Adjustment hotkeys
sslActorAlias AdjustAlias
int AdjustPos
bool Adjusted
bool hkReady

; ------------------------------------------------------- ;
; --- Thread Starter                                  --- ;
; ------------------------------------------------------- ;

state Prepare
	function FireAction()
		; UpdateActorKey()
		; ResolveTimers()
		UpdateAdjustKey()
		SetAnimation()
		Log(AdjustKey, "Adjustment Profile")
		SyncEvent(kPrepareActor, 30.0)
	endFunction

	function PrepareDone()
		RegisterForSingleUpdate(0.1)
	endFunction

	event OnUpdate()
		; Set starting adjusted actor
		AdjustPos   = (ActorCount > 1) as int
		AdjustAlias = PositionAlias(AdjustPos)
		; Get localized config options
		BaseDelay = Config.SFXDelay
		; Send starter events
		SendThreadEvent("AnimationStart")
		if LeadIn
			SendThreadEvent("LeadInStart")
		endIf
		; Start time trackers
		RealTime[0] = Utility.GetCurrentRealTime()
		SkillTime = RealTime[0]
		StartedAt = RealTime[0]
		; Start actor loops
		QuickEvent("Start")
		; Begin animating loop
		Action("Advancing")
	endEvent

	function PlayStageAnimations()
	endFunction
	function RecordSkills()
	endFunction
	function SetBonuses()
	endFunction
endState

; ------------------------------------------------------- ;
; --- Animation Loop                                  --- ;
; ------------------------------------------------------- ;

state Advancing
	function FireAction()
		; Log("Stage: "+Stage, "Advancing")
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
		SyncEvent(kSyncActor, 10.0)
	endFunction
	function SyncDone()
		RegisterForSingleUpdate(0.1)
	endFunction
	event OnUpdate()
		Action("Animating")
		SendThreadEvent("StageStart")
	endEvent
endState

state Animating

	function FireAction()
		UnregisterForUpdate()
		; Prepare loop
		ResolveTimers()
		SoundFX  = Animation.GetSoundFX(Stage)
		SFXDelay = ClampFloat(BaseDelay - ((Stage * 0.3) * ((Stage != 1) as int)), 0.5, 30.0)
		PlayStageAnimations()
		; Send events
		if !LeadIn && Stage >= StageCount
			SendThreadEvent("OrgasmStart")
			if Config.OrgasmEffects
				TriggerOrgasm()
				return
			endIf		
		endIf
		; Begin loop
		RegisterForSingleUpdate(0.5)
	endFunction

	event OnUpdate()
		; Debug.Trace("(thread update)")
		; Update timer share
		RealTime[0] = Utility.GetCurrentRealTime()
		; Pause further updates if in menu
		if HasPlayer && Utility.IsInMenuMode()
			while Utility.IsInMenuMode()
				StageTimer += 1.0
				Utility.WaitMenuMode(1.5)
				; Log("Thread menu pause...")
			endWhile
		endIf
		; Advance stage on timer
		if (AutoAdvance || TimedStage) && StageTimer < RealTime[0]
			GoToStage((Stage + 1))
			return
		endIf
		; Play SFX
		if SoundFX && SFXTimer < RealTime[0]
			SoundFX.Play(CenterRef)
			SFXTimer = RealTime[0] + SFXDelay
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

	function GoToStage(int ToStage)
		UnregisterForUpdate()
		Stage = ToStage
		Action("Advancing")
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
		UnregisterForUpdate()
		SetAnimation(sslUtility.IndexTravel(Animations.Find(Animation), Animations.Length, backwards))
		SendThreadEvent("AnimationChange")
		RegisterForSingleUpdate(0.2)
	endFunction

	function ChangePositions(bool backwards = false)
		if ActorCount < 2 || HasCreature
			return ; Solo/Creature Animation, nobody to swap with
		endIf
		UnregisterforUpdate()
		; GoToState("")
		; Find position to swap to
		int NewPos = sslUtility.IndexTravel(AdjustPos, ActorCount, backwards)
		Actor AdjustActor = Positions[AdjustPos]
		Actor MovedActor  = Positions[NewPos]
		if MovedActor == AdjustActor
			Log("MovedActor["+NewPos+"] == AdjustActor["+AdjustPos+"] -- "+Positions, "ChangePositions() Errror")
			RegisterForSingleUpdate(0.2)
			return
		endIf
		; Shuffle actor positions
		Positions[AdjustPos] = MovedActor
		Positions[NewPos] = AdjustActor
		; New adjustment profile
		; UpdateActorKey()
		UpdateAdjustKey()
		Log(AdjustKey, "Adjustment Profile")
		; Sync new positions
		AdjustPos = NewPos
		; GoToState("Animating")
		ResetPositions(true)
		SendThreadEvent("PositionChange")
		RegisterForSingleUpdate(1.0)
	endFunction

	function AdjustForward(bool backwards = false, bool AdjustStage = false)
		UnregisterforUpdate()
		float Amount = SignFloat(backwards, 0.50)
		Adjusted = true
		Animation.AdjustForward(AdjustKey, AdjustPos, Stage, Amount, AdjustStage)
		int k = Config.AdjustForward
		while Input.IsKeyPressed(k)
			Animation.AdjustForward(AdjustKey, AdjustPos, Stage, Amount, AdjustStage)
			AdjustAlias.RefreshLoc()
		endWhile
		RegisterForSingleUpdate(0.1)
	endFunction

	function AdjustSideways(bool backwards = false, bool AdjustStage = false)
		UnregisterforUpdate()
		float Amount = SignFloat(backwards, 0.50)
		Adjusted = true
		Animation.AdjustSideways(AdjustKey, AdjustPos, Stage, Amount, AdjustStage)
		AdjustAlias.RefreshLoc()
		int k = Config.AdjustSideways
		while Input.IsKeyPressed(k)
			Animation.AdjustSideways(AdjustKey, AdjustPos, Stage, Amount, AdjustStage)
			AdjustAlias.RefreshLoc()
		endWhile
		RegisterForSingleUpdate(0.1)
	endFunction

	function AdjustUpward(bool backwards = false, bool AdjustStage = false)
		float Amount = SignFloat(backwards, 0.50)
		UnregisterforUpdate()
		Adjusted = true
		Animation.AdjustUpward(AdjustKey, AdjustPos, Stage, Amount, AdjustStage)
		AdjustAlias.RefreshLoc()
		int k = Config.AdjustUpward
		while Input.IsKeyPressed(k)
			Animation.AdjustUpward(AdjustKey, AdjustPos, Stage, Amount, AdjustStage)
			AdjustAlias.RefreshLoc()
		endWhile
		RegisterForSingleUpdate(0.1)
	endFunction

	function RotateScene(bool backwards = false)
		UnregisterForUpdate()
		CenterLocation[5] = CenterLocation[5] + SignFloat(backwards, 15.0)
		if CenterLocation[5] >= 360.0
			CenterLocation[5] = CenterLocation[5] - 360.0
		elseIf CenterLocation[5] < 0.0
			CenterLocation[5] = CenterLocation[5] + 360.0
		endIf
		ActorAlias[0].RefreshLoc()
		ActorAlias[1].RefreshLoc()
		ActorAlias[2].RefreshLoc()
		ActorAlias[3].RefreshLoc()
		ActorAlias[4].RefreshLoc()
		RegisterForSingleUpdate(0.2)
	endFunction

	function AdjustChange(bool backwards = false)
		UnregisterForUpdate()
		if ActorCount > 1
			AdjustPos = sslUtility.IndexTravel(Positions.Find(AdjustAlias.ActorRef), ActorCount, backwards)
			AdjustAlias = ActorAlias(Positions[AdjustPos])
			Debug.Notification("Adjusting Position For: "+AdjustAlias.ActorRef.GetLeveledActorBase().GetName())
		endIf
		RegisterForSingleUpdate(0.2)
	endFunction

	function RestoreOffsets()
		UnregisterForUpdate()
		Animation.RestoreOffsets(AdjustKey)
		RealignActors()
		RegisterForSingleUpdate(0.2)
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
		Slot.StopAnimating(true)
		; Debug.SendAnimationEvent(PlayerRef, "IdleForceDefaultState")
		; Lock hotkeys and wait 7 seconds
		Debug.Notification("Player movement unlocked - repositioning scene in 7 seconds...")
		Utility.Wait(7.0)
		; Disable Controls
		Slot.LockActor()
		; Give player time to settle incase airborne
		Utility.Wait(1.0)
		; Recenter on coords to avoid stager + resync animations
		if !CenterOnBed(true, 300.0)
			CenterOnObject(PlayerRef, true)
		endIf
		; Return to animation loop
		; ClearIdles()
		RealignActors()
		StageTimer = Utility.GetCurrentRealTime() + GetTimer()
		RegisterForSingleUpdate(0.1)
	endFunction

	event OnKeyDown(int KeyCode)
		StateCheck()
		if hkReady && !Utility.IsInMenuMode() ; || UI.IsMenuOpen("Console") || UI.IsMenuOpen("Loading Menu")
			hkReady = false
			int i = Hotkeys.Find(KeyCode)
			; Advance Stage
			if i == AdvanceAnimation
				AdvanceStage(Config.BackwardsPressed())

			; Change Animation
			elseIf i == ChangeAnimation
				ChangeAnimation(Config.BackwardsPressed())

			; Forward / Backward adjustments
			elseIf i == AdjustForward
				AdjustForward(Config.BackwardsPressed(), Config.AdjustStagePressed())

			; Up / Down adjustments
			elseIf i == AdjustUpward
				AdjustUpward(Config.BackwardsPressed(), Config.AdjustStagePressed())

			; Left / Right adjustments
			elseIf i == AdjustSideways
				AdjustSideways(Config.BackwardsPressed(), Config.AdjustStagePressed())

			; Rotate Scene
			elseIf i == RotateScene
				RotateScene(Config.BackwardsPressed())

			; Change Adjusted Actor
			elseIf i == AdjustChange
				AdjustChange(Config.BackwardsPressed())

			; RePosition Actors
			elseIf i == RealignActors
				ResetPositions(Config.BackwardsPressed())

			; Change Positions
			elseIf i == ChangePositions
				ChangePositions(Config.BackwardsPressed())

			; Restore animation offsets
			elseIf i == RestoreOffsets
				RestoreOffsets()

			; Move Scene
			elseIf i == MoveScene
				MoveScene()

			; EndAnimation
			elseIf i == EndAnimation
				EndAnimation(true)

			endIf
			hkReady = true
		endIf
	endEvent

	function MoveActors()
		Utility.Wait(0.1)
		ActorAlias[0].RefreshLoc()
		ActorAlias[1].RefreshLoc()
		ActorAlias[2].RefreshLoc()
		ActorAlias[3].RefreshLoc()
		ActorAlias[4].RefreshLoc()
		Utility.Wait(0.1)
	endFunction

	function RealignActors()
		UnregisterForUpdate()
		GoToState("Refresh")
	endFunction

	function ResetPositions(bool ClearIdles = true)
		UnregisterForUpdate()
		if ClearIdles
			ClearIdles()
		endIf
		GoToState("Refresh")
	endFunction

endState

state Refresh
	event OnBeginState()
		SyncEvent(kSyncActor, 10.0)
	endEvent
	function SyncDone()
		RegisterForSingleUpdate(0.1)
	endFunction
	event OnUpdate()
		Action("Animating")
	endEvent
	function ResetPositions(bool ClearIdles = true)
	endFunction
endState

function ClearIdles()
	Utility.Wait(0.1)
	if ActorCount == 1
		Debug.SendAnimationEvent(Positions[0], "IdleForceDefaultState")
	elseIf ActorCount == 2
		Debug.SendAnimationEvent(Positions[0], "IdleForceDefaultState")
		Debug.SendAnimationEvent(Positions[1], "IdleForceDefaultState")
	elseIf ActorCount == 3
		Debug.SendAnimationEvent(Positions[0], "IdleForceDefaultState")
		Debug.SendAnimationEvent(Positions[1], "IdleForceDefaultState")
		Debug.SendAnimationEvent(Positions[2], "IdleForceDefaultState")
	elseIf ActorCount == 4
		Debug.SendAnimationEvent(Positions[0], "IdleForceDefaultState")
		Debug.SendAnimationEvent(Positions[1], "IdleForceDefaultState")
		Debug.SendAnimationEvent(Positions[2], "IdleForceDefaultState")
		Debug.SendAnimationEvent(Positions[3], "IdleForceDefaultState")
	elseIf ActorCount == 5
		Debug.SendAnimationEvent(Positions[0], "IdleForceDefaultState")
		Debug.SendAnimationEvent(Positions[1], "IdleForceDefaultState")
		Debug.SendAnimationEvent(Positions[2], "IdleForceDefaultState")
		Debug.SendAnimationEvent(Positions[3], "IdleForceDefaultState")
		Debug.SendAnimationEvent(Positions[4], "IdleForceDefaultState")
	endIf
	;/ if ActorCount == 1
		PositionAlias(0).StopAnimating(true)
	elseIf ActorCount == 2
		PositionAlias(0).StopAnimating(true)
		PositionAlias(1).StopAnimating(true)
	elseIf ActorCount == 3
		PositionAlias(0).StopAnimating(true)
		PositionAlias(1).StopAnimating(true)
		PositionAlias(2).StopAnimating(true)
	elseIf ActorCount == 4
		PositionAlias(0).StopAnimating(true)
		PositionAlias(1).StopAnimating(true)
		PositionAlias(2).StopAnimating(true)
		PositionAlias(3).StopAnimating(true)
	elseIf ActorCount == 5
		PositionAlias(0).StopAnimating(true)
		PositionAlias(1).StopAnimating(true)
		PositionAlias(2).StopAnimating(true)
		PositionAlias(3).StopAnimating(true)
		PositionAlias(4).StopAnimating(true)
	endIf /;
	; Utility.Wait(0.3)
endFunction

function TriggerOrgasm()
	UnregisterforUpdate()
	QuickEvent("Orgasm")
	StageTimer += 3.0
	RegisterForSingleUpdate(3.0)
endFunction

function ResetPositions(bool ClearIdles = true)
endFunction

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
	; Inform player of animation being played now
	if HasPlayer
		SexLabUtil.PrintConsole("Playing Animation: " + Animation.Name)
	endIf
	; Update animation info
	RecordSkills()
	string[] Tags = Animation.GetRawTags()
	; IsType = [1] IsVaginal, [2] IsAnal, [3] IsOral, [4] IsLoving, [5] IsDirty
	IsType[1]  = Females > 0 && Tags.Find("Vaginal") != -1
	IsType[2]  = Tags.Find("Anal")   != -1 || (Females == 0 && Tags.Find("Vaginal") != -1)
	IsType[3]  = Tags.Find("Oral")   != -1
	IsType[4]  = Tags.Find("Loving") != -1
	IsType[5]  = Tags.Find("Dirty")  != -1
	StageCount = Animation.StageCount
	SoundFX    = Animation.GetSoundFX(Stage)
	SetBonuses()
	; Check for out of range stage
	if Stage >= StageCount
		GoToStage((StageCount - 1))
	else
		TimedStage = Animation.HasTimer(Stage)
		ActorAlias[0].SyncAll(false)
		ActorAlias[1].SyncAll(false)
		ActorAlias[2].SyncAll(false)
		ActorAlias[3].SyncAll(false)
		ActorAlias[4].SyncAll(false)
		PlayStageAnimations()
	endIf
endFunction

float function GetTimer()
	; Custom acyclic stage timer
	if TimedStage
		return Animation.GetTimer(Stage)
	endIf
	; Default stage timers
	int last = ( Timers.Length - 1 )
	if Stage < last
		return Timers[(Stage - 1)]
	elseIf Stage >= StageCount
		return Timers[last]
	endIf
	return Timers[(last - 1)]
endFunction

function ResolveTimers()
	parent.ResolveTimers()
	TimedStage = Animation.HasTimer(Stage)
	if TimedStage
		Log("Stage has timer: "+Animation.GetTimer(Stage))
	endIf
endFunction

float function GetAnimationRunTime()
	return Animation.GetTimersRunTime(Timers)
endFunction

function UpdateTimer(float AddSeconds = 0.0)
	TimedStage = true
	StageTimer += AddSeconds
endFunction

function EndLeadIn()
	if LeadIn
		UnregisterForUpdate()
		; Swap to non lead in animations
		Stage  = 1
		LeadIn = false
		SetAnimation()
		; Add runtime to foreplay skill xp
		SkillXP[0] = SkillXP[0] + (TotalTime / 10.0)
		; Restrip with new strip options
		QuickEvent("Strip")
		; Start primary animations at stage 1
		SendThreadEvent("LeadInEnd")
		Action("Advancing")
	endIf
endFunction

function EndAnimation(bool Quickly = false)
	UnregisterForUpdate()
	Utility.WaitMenuMode(0.2)
	FastEnd = Quickly
	Stage   = StageCount
	GoToState("Ending")
endFunction

state Ending
	event OnBeginState()
		UnregisterForUpdate()
		SendThreadEvent("AnimationEnding")
		RecordSkills()
		DisableHotkeys()
		Config.DisableThreadControl(self)
		SyncEvent(kResetActor, 45.0)
	endEvent
	function ResetDone()
		; Log("Reset", "AliasEvent")
		RegisterForSingleUpdate(0.1)
	endFunction
	event OnUpdate()
		SendThreadEvent("AnimationEnd")
		if Adjusted
			Log("Auto saving adjustments...")
			sslSystemConfig.SaveAdjustmentProfile()
		endIf
		GoToState("Frozen")
	endEvent
	; Don't allow to be called twice
	function EndAnimation(bool Quickly = false)
	endFunction
endState

state Frozen
	; Hold before full reset so hook events can finish
	event OnBeginState()
		RegisterForSingleUpdate(10.0)
	endEvent
	event OnEndState()
		Log("Returning to thread pool...")
	endEvent
	event OnUpdate()
		Initialize()
	endEvent
	function EndAnimation(bool Quickly = false)
	endFunction
endState

; ------------------------------------------------------- ;
; --- System Use Only                                 --- ;
; ------------------------------------------------------- ;

function RecordSkills()
	float TimeNow = RealTime[0]
	float xp = ((TimeNow - SkillTime) / 10.0)
	if xp >= 0.5
		if IsType[1]
			SkillXP[1] = SkillXP[1] + xp
		endIf
		if IsType[2]
			SkillXP[2] = SkillXP[2] + xp
		endIf
		if IsType[3]
			SkillXP[3] = SkillXP[3] + xp
		endIf
		if IsType[4]
			SkillXP[4] = SkillXP[4] + xp
		endIf
		if IsType[5]
			SkillXP[5] = SkillXP[5] + xp
		endIf
	endIf
	SkillTime = TimeNow
endfunction

function SetBonuses()
	SkillBonus[0] = SkillXP[0]
	if IsType[1]
		SkillBonus[1] = SkillXP[1]
	endIf
	if IsType[2]
		SkillBonus[2] = SkillXP[2]
	endIf
	if IsType[3]
		SkillBonus[3] = SkillXP[3]
	endIf
	if IsType[4]
		SkillBonus[4] = SkillXP[4]
	endIf
	if IsType[5]
		SkillBonus[5] = SkillXP[5]
	endIf
endFunction

function EnableHotkeys(bool forced = false)
	if HasPlayer || forced
		Hotkeys = new int[12]
		Hotkeys[AdvanceAnimation] = Config.AdvanceAnimation
		Hotkeys[ChangeAnimation]  = Config.ChangeAnimation
		Hotkeys[ChangePositions]  = Config.ChangePositions
		Hotkeys[AdjustChange]     = Config.AdjustChange
		Hotkeys[AdjustForward]    = Config.AdjustForward
		Hotkeys[AdjustSideways]   = Config.AdjustSideways
		Hotkeys[AdjustUpward]     = Config.AdjustUpward
		Hotkeys[RealignActors]    = Config.RealignActors
		Hotkeys[RestoreOffsets]   = Config.RestoreOffsets
		Hotkeys[MoveScene]        = Config.MoveScene
		Hotkeys[RotateScene]      = Config.RotateScene
		Hotkeys[EndAnimation]     = Config.EndAnimation
		int i
		while i < Hotkeys.Length
			RegisterForKey(Hotkeys[i])
			i += 1
		endwhile
		hkReady = true
	endIf
endFunction

function DisableHotkeys()
	UnregisterForAllKeys()
	hkReady = false
endFunction

function Initialize()
	Config.DisableThreadControl(self)
	DisableHotkeys()
	SFXTimer    = 0.0
	SkillTime   = 0.0
	TimedStage  = false
	Adjusted    = false
	AdjustPos   = 0
	AdjustAlias = ActorAlias[0]
	parent.Initialize()
endFunction

int function GetAdjustPos()
	return AdjustPos
endFunction

function PlayStageAnimations()
	QuickEvent("Animate")
	StageTimer = RealTime[0] + GetTimer()
endFunction

; ------------------------------------------------------- ;
; --- State Restricted                                --- ;
; ------------------------------------------------------- ;

auto state Unlocked
	function EndAnimation(bool Quickly = false)
	endFunction
endState

; State Animating
function AdvanceStage(bool backwards = false)
endFunction
function ChangeAnimation(bool backwards = false)
endFunction
function ChangePositions(bool backwards = false)
endFunction
function AdjustForward(bool backwards = false, bool AdjustStage = false)
endFunction
function AdjustSideways(bool backwards = false, bool AdjustStage = false)
endFunction
function AdjustUpward(bool backwards = false, bool AdjustStage = false)
endFunction
function RotateScene(bool backwards = false)
endFunction
function AdjustChange(bool backwards = false)
endFunction
function RestoreOffsets()
endFunction
function MoveScene()
endFunction
; function ClearIdles()
; endFunction
function RealignActors()
endFunction
function MoveActors()
endFunction
function GoToStage(int ToStage)
endFunction

int[] Hotkeys
int property AdvanceAnimation = 0  autoreadonly hidden
int property ChangeAnimation  = 1  autoreadonly hidden
int property ChangePositions  = 2  autoreadonly hidden
int property AdjustChange     = 3  autoreadonly hidden
int property AdjustForward    = 4  autoreadonly hidden
int property AdjustSideways   = 5  autoreadonly hidden
int property AdjustUpward     = 6  autoreadonly hidden
int property RealignActors    = 7  autoreadonly hidden
int property RestoreOffsets   = 8  autoreadonly hidden
int property MoveScene        = 9  autoreadonly hidden
int property RotateScene      = 10 autoreadonly hidden
int property EndAnimation     = 11 autoreadonly hidden


event OnKeyDown(int keyCode)
	StateCheck()
endEvent

function StateCheck()
	Log("THREAD STATE: "+GetState())
	if ActorCount == 1
		ActorAlias[0].Log("State: "+ActorAlias[0].GetState())
	elseIf ActorCount == 2
		ActorAlias[0].Log("State: "+ActorAlias[0].GetState())
		ActorAlias[1].Log("State: "+ActorAlias[1].GetState())
	elseIf ActorCount == 3
		ActorAlias[0].Log("State: "+ActorAlias[0].GetState())
		ActorAlias[1].Log("State: "+ActorAlias[1].GetState())
		ActorAlias[2].Log("State: "+ActorAlias[2].GetState())
	elseIf ActorCount == 4
		ActorAlias[0].Log("State: "+ActorAlias[0].GetState())
		ActorAlias[1].Log("State: "+ActorAlias[1].GetState())
		ActorAlias[2].Log("State: "+ActorAlias[2].GetState())
		ActorAlias[3].Log("State: "+ActorAlias[3].GetState())
	elseIf ActorCount == 5
		ActorAlias[0].Log("State: "+ActorAlias[0].GetState())
		ActorAlias[1].Log("State: "+ActorAlias[1].GetState())
		ActorAlias[2].Log("State: "+ActorAlias[2].GetState())
		ActorAlias[3].Log("State: "+ActorAlias[3].GetState())
		ActorAlias[4].Log("State: "+ActorAlias[4].GetState())
	endIf
endFunction