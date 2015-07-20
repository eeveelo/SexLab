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
		ResolveTimers()
		UpdateAdjustKey()
		SetAnimation()
		Log(sAdjustKey[0], "Adjustment Profile")
		SyncEvent("Prepare", 30.0)
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
		ResolveTimers()
		SyncEvent("Sync", 10.0)
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
		UnregisterForUpdate()
		Log("Stage: "+Stage, "Animating")
		; Prepare loop
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
		else
			SendThreadEvent("StageStart")
		endIf
		; Begin loop
		RegisterForSingleUpdate(0.2)
	endFunction

	event OnUpdate()
		RealTime[0] = Utility.GetCurrentRealTime()
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
		SetAnimation(sslUtility.IndexTravel(Animations.Find(sAnimation[0]), Animations.Length, backwards))
		SendThreadEvent("AnimationChange")
		RegisterForSingleUpdate(0.2)
	endFunction

	function ChangePositions(bool backwards = false)
		if ActorCount < 2 || HasCreature
			return ; Solo/Creature Animation, nobody to swap with
		endIf
		UnregisterforUpdate()
		GoToState("")
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
		Log(sAdjustKey[0], "Adjustment Profile")
		; Sync new positions
		AdjustPos = NewPos
		GoToState("Animating")
		ResetPositions(true)
		SendThreadEvent("PositionChange")
		RegisterForSingleUpdate(0.2)
	endFunction

	function AdjustForward(bool backwards = false, bool AdjustStage = false)
		UnregisterforUpdate()
		float Amount = SignFloat(backwards, 0.50)
		Adjusted = true
		Animation.AdjustForward(sAdjustKey[0], AdjustPos, Stage, Amount, AdjustStage)
		int k = Config.AdjustForward
		while Input.IsKeyPressed(k)
			Animation.AdjustForward(sAdjustKey[0], AdjustPos, Stage, Amount, AdjustStage)
			AdjustAlias.RefreshLoc()
		endWhile
		RegisterForSingleUpdate(0.1)
	endFunction

	function AdjustSideways(bool backwards = false, bool AdjustStage = false)
		UnregisterforUpdate()
		float Amount = SignFloat(backwards, 0.50)
		Adjusted = true
		Animation.AdjustSideways(sAdjustKey[0], AdjustPos, Stage, Amount, AdjustStage)
		AdjustAlias.RefreshLoc()
		int k = Config.AdjustSideways
		while Input.IsKeyPressed(k)
			Animation.AdjustSideways(sAdjustKey[0], AdjustPos, Stage, Amount, AdjustStage)
			AdjustAlias.RefreshLoc()
		endWhile
		RegisterForSingleUpdate(0.1)
	endFunction

	function AdjustUpward(bool backwards = false, bool AdjustStage = false)
		float Amount = SignFloat(backwards, 0.50)
		UnregisterforUpdate()
		Adjusted = true
		Animation.AdjustUpward(sAdjustKey[0], AdjustPos, Stage, Amount, AdjustStage)
		AdjustAlias.RefreshLoc()
		int k = Config.AdjustUpward
		while Input.IsKeyPressed(k)
			Animation.AdjustUpward(sAdjustKey[0], AdjustPos, Stage, Amount, AdjustStage)
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
		Animation.RestoreOffsets(sAdjustKey[0])
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
		PlayerRef.StopTranslation()
		Debug.SendAnimationEvent(PlayerRef, "IdleForceDefaultState")
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
		; StageTimer = Utility.GetCurrentRealTime() + GetTimer()
		; RegisterForSingleUpdate(0.1)
	endFunction

	event OnKeyDown(int KeyCode)
		if hkReady && !Utility.IsInMenuMode() ; || UI.IsMenuOpen("Console") || UI.IsMenuOpen("Loading Menu")
			hkReady = false
			Config.HotkeyCallback(self, KeyCode)
			hkReady = true
		endIf
	endEvent

	function ClearIdles()
		Utility.Wait(0.1)
		ActorAlias[0].StopAnimating(true)
		ActorAlias[1].StopAnimating(true)
		ActorAlias[2].StopAnimating(true)
		ActorAlias[3].StopAnimating(true)
		ActorAlias[4].StopAnimating(true)
		Utility.Wait(0.5)
	endFunction

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
		Utility.Wait(0.1)
		ActorAlias[0].SyncAll(true)
		ActorAlias[1].SyncAll(true)
		ActorAlias[2].SyncAll(true)
		ActorAlias[3].SyncAll(true)
		ActorAlias[4].SyncAll(true)
		Utility.Wait(0.1)
		PlayStageAnimations()
		RegisterForSingleUpdate(1.0)
	endFunction

	function ResetPositions(bool ClearIdles = true)
		UnregisterForUpdate()
		if ClearIdles
			ClearIdles()
		endIf
		MoveActors()
		RealignActors()
	endFunction

endState

function ResetPositions(bool ClearIdles = true)
endFunction

function TriggerOrgasm()
	UnregisterforUpdate()
	QuickEvent("Orgasm")
	if SoundFX
		SoundFX.Play(CenterRef)
	endIf
	StageTimer += 3.0
	RegisterForSingleUpdate(3.0)
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
	Animations[aid].GetAnimEvents(sAnimEvents, Stage)
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
		PlayStageAnimations()
		ActorAlias[0].SyncAll(false)
		ActorAlias[1].SyncAll(false)
		ActorAlias[2].SyncAll(false)
		ActorAlias[3].SyncAll(false)
		ActorAlias[4].SyncAll(false)
	endIf
endFunction

float function GetTimer()
	; Custom acyclic stage timer
	TimedStage = Animation.HasTimer(Stage)
	if TimedStage
		; Log("Stage has timer: "+Animation.GetTimer(Stage))
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
		RecordSkills()
		DisableHotkeys()
		Config.DisableThreadControl(self)
		SendThreadEvent("AnimationEnding")
		Utility.WaitMenuMode(0.5)
		SyncEvent("Reset", 45.0)
	endEvent
	function ResetDone()
		Log("Reset", "AliasEvent")
		RegisterForSingleUpdate(1.0)
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
		; RegisterForKey(Config.AutoAlign)
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
	Animation.GetAnimEvents(sAnimEvents, Stage)
	ModEvent.Send(ModEvent.Create(Key("Animate")))
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
function ClearIdles()
endFunction
function RealignActors()
endFunction
function MoveActors()
endFunction
function GoToStage(int ToStage)
endFunction

;/ float function GetNodeDistanceZ(float Tolerance, Actor ActorRef1, String Node1, Actor ActorRef2, String Node2) global native
float function GetNodeDistanceX(float Tolerance, Actor ActorRef1, String Node1, Actor ActorRef2, String Node2) global native

function AutoAlign(bool DoMove)
	UnregisterForUpdate()
	; Animation.RestoreOffsets(sAdjustKey[0])
	RealignActors()

	float z
	float x

	string Node0 = "Skirt"
	string Node1 = "Skirt"

	if IsType[3]
		Node0 = "NPC Head [Head]"
	endIf

	float t1 = 0.0
	float t2 = 0.0

	if DoMove
		t1 = Config.DebugVar1.Getvalue()
		t2 = Config.DebugVar2.Getvalue()
	endIf

	int i = 40
	while i
		i -= 1
		z += GetNodeDistanceZ(t2, Positions[0], Node0, Positions[1], Node1)
		Utility.Wait(0.05)
	endWhile
	z = z / 40
	Log(z, Animation.Registry+": Z")
	if DoMove
		Animation.AdjustUpward(sAdjustKey[0],  1, Stage, z, true)
		PositionAlias(1).RefreshLoc()
	endif

	i = 40
	while i
		i -= 1
		x += GetNodeDistanceX(t1, Positions[0], Node0, Positions[1], Node1)
		Utility.Wait(0.05)
	endWhile
	x = x / 40
	Log(x, Animation.Registry+": X")
	if DoMove
		Animation.AdjustForward(sAdjustKey[0], 1, Stage, x, true)
		PositionAlias(1).RefreshLoc()
		Log(GetNodeDistanceX(0.0, Positions[0], Node0, Positions[1], Node1)+" > "+(t1 * 1.5), "Forward")
		if GetNodeDistanceX(0.0, Positions[0], Node0, Positions[1], Node1) > (t1 * 1.5)
			Animation.AdjustForward(sAdjustKey[0], 1, Stage, (x * -2), true)
			PositionAlias(1).RefreshLoc()
			Log((x * -2)+" -> "+GetNodeDistanceX(0.0, Positions[0], Node0, Positions[1], Node1), "Reversed")
		endIf
	endif

	Debug.Notification("Forward: "+x+" - UpDown: "+z)

	; if DoMove
	; 	; Animation.AdjustForward(sAdjustKey[0], 0, Stage, x *  0.50, true)
	; 	; Animation.AdjustUpward(sAdjustKey[0],  0, Stage, z *  0.50, true)

	; 	Animation.AdjustForward(sAdjustKey[0], 1, Stage, x, true)
	; 	Animation.AdjustUpward(sAdjustKey[0],  1, Stage, z, true)

	; 	; PositionAlias(0).RefreshLoc()
	; 	PositionAlias(1).RefreshLoc()
	; endIf

	RegisterForSingleUpdate(0.2)
endFunction
 /;
