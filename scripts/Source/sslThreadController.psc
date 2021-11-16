scriptname sslThreadController extends sslThreadModel
{ Animation Thread Controller: Runs manipulation logic of thread based on information from model. Access only through functions; NEVER create a property directly to this. }

; TODO: SetFirstAnimation() - allow custom defined starter anims instead of random

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

bool Prepared
state Prepare
	function FireAction()
		Prepared = false

		HookAnimationPrepare()

		; Ensure center is set
		if !CenterRef
			CenterOnObject(Positions[0], false)
		endIf
		if CenterAlias.GetReference() != CenterRef
			CenterAlias.TryToClear()
			CenterAlias.ForceRefTo(CenterRef)
		endIf
		; Set important vars needed for actor prep
		UpdateAdjustKey()
		if StartingAnimation && Animations.Find(StartingAnimation) != -1
			SetAnimation(Animations.Find(StartingAnimation))
		else
			SetAnimation()
			StartingAnimation = none
		endIf
		Log(AdjustKey, "Adjustment Profile")
		; Begin actor prep
		SyncEvent(kPrepareActor, 40.0)
	endFunction

	function PrepareDone()
		RegisterForSingleUpdate(0.1)
	endFunction

	function StartupDone()
		RegisterForSingleUpdate(0.1)
	endFunction

	event OnUpdate()
		if !Prepared
			Prepared = true
			; Reset loc, incase actor type center has moved during prep
			;/ if CenterRef && CenterRef.Is3DLoaded() && SexLabUtil.IsActor(CenterRef) && Positions.Find(CenterRef as Actor) != -1
				CenterLocation[0] = CenterRef.GetPositionX()
				CenterLocation[1] = CenterRef.GetPositionY()
				; CenterLocation[2] = CenterRef.GetPositionZ()
				CenterLocation[3] = CenterRef.GetAngleX()
				CenterLocation[4] = CenterRef.GetAngleY()
				CenterLocation[5] = CenterRef.GetAngleZ()
			endIf /;
			; Set starting adjusted actor
			AdjustPos   = FindSlot(Config.TargetRef)
			if AdjustPos == -1
				AdjustPos   = (ActorCount > 1) as int
				if FindSlot(PlayerRef) >= 0 && Positions[AdjustPos] != PlayerRef
					Config.TargetRef = Positions[AdjustPos]
				endIf
			endIf
			AdjustAlias = PositionAlias(AdjustPos)
			; Get localized config options
			BaseDelay = Config.SFXDelay
			; Send starter events
			SendThreadEvent("AnimationStart")
			if LeadIn
				SendThreadEvent("LeadInStart")
			endIf
			; Start time trackers
			RealTime[0] = SexLabUtil.GetCurrentGameRealTime()
			SkillTime = RealTime[0]
			StartedAt = RealTime[0]
			; Start actor loops
			SyncEvent(kStartup, 10.0)
		else
			; Start animating
			Action("Advancing")
		endIf
	endEvent

	function PlayStageAnimations()
	endFunction
	function ResetPositions()
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
		SyncEvent(kSyncActor, 15.0)
	endFunction
	function SyncDone()
		if Stage > 1 && Stage > (StageCount * 0.5)
			string[] Tags = Animation.GetRawTags()
			IsType[6]  = IsType[6] || Females > 0 && Tags.Find("Vaginal") != -1
			IsType[7]  = IsType[7] || Tags.Find("Anal")   != -1 || (Females == 0 && Tags.Find("Vaginal") != -1)
			IsType[8]  = IsType[8] || Tags.Find("Oral")   != -1
		endIf
		RegisterForSingleUpdate(0.1)
	endFunction
	event OnUpdate()
		HookStageStart()
		Action("Animating")
		SendThreadEvent("StageStart")
	endEvent
endState

state Animating

	function FireAction()
		UnregisterForUpdate()
		; Prepare loop
		RealTime[0] = SexLabUtil.GetCurrentGameRealTime()
		SoundFX  = Animation.GetSoundFX(Stage)
		SFXDelay = ClampFloat(BaseDelay - ((Stage * 0.3) * ((Stage != 1) as int)), 0.5, 30.0)
		ResolveTimers()
		PlayStageAnimations()
		; Send events
		if !LeadIn && Stage >= StageCount && !DisableOrgasms
			SendThreadEvent("OrgasmStart")
			TriggerOrgasm()
		endIf
		; Begin loop
		RegisterForSingleUpdate(0.5)
	endFunction

	event OnUpdate()
		; Debug.Trace("(thread update)")
		; Update timer share
		RealTime[0] = SexLabUtil.GetCurrentGameRealTime()
		; Pause further updates if in menu
		if HasPlayer && Utility.IsInMenuMode()
			while Utility.IsInMenuMode()
				Utility.WaitMenuMode(1.5)
				StageTimer += 1.2
			endWhile
		endIf
		; Advance stage on timer
		if (AutoAdvance || TimedStage) && StageTimer < RealTime[0]
			GoToStage((Stage + 1))
			return
		endIf
		; Play SFX
		if SoundFX && SFXTimer < RealTime[0]
			SoundFX.Play(GetCenterFX())
			SFXTimer = RealTime[0] + SFXDelay
		endIf
		; Loop
		RegisterForSingleUpdate(0.5)
	endEvent

	function EndAction()
		HookStageEnd()
		if !LeadIn && Stage >= StageCount && !DisableOrgasms
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
			if Config.IsAdjustStagePressed()
				GoToStage(1)
			else
				GoToStage((Stage - 1))
			endIf
		endIf
	endFunction

	function ChangeAnimation(bool backwards = false)
		if Animations.Length < 2
			return ; Nothing to change
		endIf
		UnregisterForUpdate()
		
		if !Config.AdjustStagePressed()
			; Forward/Backward
			SetAnimation(sslUtility.IndexTravel(Animations.Find(Animation), Animations.Length, backwards))
		else
			; Random
			int current = Animations.Find(Animation)
			int r = Utility.RandomInt(0, (Animations.Length - 1))
			; Try to get something other than the current animation
			if r == current
				int tries = 10
				while r == current && tries > 0
					tries -= 1
					r = Utility.RandomInt(0, (Animations.Length - 1))
				endWhile
			endIf
			SetAnimation(r)
		endIf

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
			Log("MovedActor["+NewPos+"] == AdjustActor["+AdjustPos+"] -- "+Positions, "ChangePositions() Error")
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
		ResetPositions()
		SendThreadEvent("PositionChange")
		RegisterForSingleUpdate(1.0)
	endFunction

	function AdjustForward(bool backwards = false, bool AdjustStage = false)
		UnregisterforUpdate()
		float Amount = SignFloat(backwards, 0.50)
		Adjusted = true
		PlayHotkeyFX(0, backwards)
		Animation.AdjustForward(AdjustKey, AdjustPos, Stage, Amount, AdjustStage)
		int k = Config.AdjustForward
		while Input.IsKeyPressed(k)
			PlayHotkeyFX(0, backwards)
			Animation.AdjustForward(AdjustKey, AdjustPos, Stage, Amount, Config.AdjustStagePressed())
			AdjustAlias.RefreshLoc()
		endWhile
		RegisterForSingleUpdate(0.1)
	endFunction

	function AdjustSideways(bool backwards = false, bool AdjustStage = false)
		UnregisterforUpdate()
		float Amount = SignFloat(backwards, 0.50)
		Adjusted = true
		PlayHotkeyFX(0, backwards)
		Animation.AdjustSideways(AdjustKey, AdjustPos, Stage, Amount, AdjustStage)
		AdjustAlias.RefreshLoc()
		int k = Config.AdjustSideways
		while Input.IsKeyPressed(k)
			PlayHotkeyFX(0, backwards)
			Animation.AdjustSideways(AdjustKey, AdjustPos, Stage, Amount, Config.AdjustStagePressed())
			AdjustAlias.RefreshLoc()
		endWhile
		RegisterForSingleUpdate(0.1)
	endFunction

	function AdjustUpward(bool backwards = false, bool AdjustStage = false)
		float Amount = SignFloat(backwards, 0.50)
		UnregisterforUpdate()
		Adjusted = true
		PlayHotkeyFX(2, backwards)
		Animation.AdjustUpward(AdjustKey, AdjustPos, Stage, Amount, AdjustStage)
		AdjustAlias.RefreshLoc()
		int k = Config.AdjustUpward
		while Input.IsKeyPressed(k)
			PlayHotkeyFX(2, backwards)
			Animation.AdjustUpward(AdjustKey, AdjustPos, Stage, Amount, Config.AdjustStagePressed())
			AdjustAlias.RefreshLoc()
		endWhile
		RegisterForSingleUpdate(0.1)
	endFunction

	function RotateScene(bool backwards = false)
		UnregisterForUpdate()
		float Amount = 15.0
		if Config.IsAdjustStagePressed()
			Amount = 180.0
		endIf
		Amount = SignFloat(backwards, Amount)
		PlayHotkeyFX(1, !backwards)
		CenterLocation[5] = CenterLocation[5] + Amount
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
		int k = Config.RotateScene
		while Input.IsKeyPressed(k)
			PlayHotkeyFX(1, !backwards)
			if Config.IsAdjustStagePressed()
				Amount = 180.0
			else
				Amount = 15.0
			endIf
			Amount = SignFloat(backwards, Amount)
			CenterLocation[5] = CenterLocation[5] + Amount
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
		endWhile
		RegisterForSingleUpdate(0.2)
	endFunction

	function AdjustSchlong(bool backwards = false)
		int Amount  = SignInt(backwards, 1)
		int Schlong = Animation.GetSchlong(AdjustKey, AdjustPos, Stage) + Amount
		if Math.Abs(Schlong) <= 9
			Adjusted = true
			Animation.AdjustSchlong(AdjustKey, AdjustPos, Stage, Amount)
			AdjustAlias.GetPositionInfo()
			Debug.SendAnimationEvent(Positions[AdjustPos], "SOSBend"+Schlong)
			PlayHotkeyFX(2, !backwards)
		endIf
	endFunction

	function AdjustChange(bool backwards = false)
		UnregisterForUpdate()
		if ActorCount > 1
			AdjustPos = sslUtility.IndexTravel(Positions.Find(AdjustAlias.ActorRef), ActorCount, backwards)
			AdjustAlias = ActorAlias(Positions[AdjustPos])
			Actor AdjustActor = AdjustAlias.ActorRef
			if AdjustActor != PlayerRef
				Config.TargetRef = AdjustActor
			endIf
			Config.SelectedSpell.Cast(AdjustActor, AdjustActor)
			PlayHotkeyFX(0, !backwards)
			string msg = "Adjusting Position For: "+AdjustActor.GetLeveledActorBase().GetName()
			Debug.Notification(msg)
			SexLabUtil.PrintConsole(msg)
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
		; Processing Furnitures
		int PreFurnitureStatus = BedTypeID
		if UsingBed && CenterRef.IsActivationBlocked()
			SetFurnitureIgnored(false)
		endIf
		; Enable Controls
		sslActorAlias PlayerSlot = ActorAlias(PlayerRef)
		if Config.GetThreadControlled() == self || PlayerRef.IsInFaction(Config.AnimatingFaction) && PlayerRef.GetFactionRank(Config.AnimatingFaction) != 0
			if PlayerSlot && PlayerSlot != none
				PlayerSlot.UnlockActor()
				PlayerSlot.StopAnimating(true)
				PlayerRef.StopTranslation()
			else
				Config.DisableThreadControl(self)
				PlayerRef.SetFactionRank(Config.AnimatingFaction, 0)
			endIf
			Debug.Notification("Player movement unlocked - repositioning scene in 30 seconds...")
			UnregisterForUpdate()
			int i
			while i < ActorCount
				sslActorAlias ActorSlot = ActorAlias[i]
				if ActorSlot != none && ActorSlot != PlayerSlot
					ActorSlot.UnlockActor()
					ActorSlot.StopAnimating(true)
					ActorSlot.ActorRef.SetFactionRank(Config.AnimatingFaction, 2)
				endIf
				i += 1
			endWhile
			
			CenterAlias.TryToClear()
			CenterAlias.ForceRefTo(PlayerRef) ; Make them follow me

			UnregisterForUpdate()
			
			; Lock hotkeys and wait 30 seconds
			Utility.WaitMenuMode(1.0)
			RegisterForKey(Hotkeys[kMoveScene])
			; Ready
			hkReady = true
			i = 28 ; Time to wait
			while i && hkReady
				i -= 1
				Utility.Wait(1.0)
				if !PlayerRef.IsInFaction(Config.AnimatingFaction)
					PlayerRef.SetFactionRank(Config.AnimatingFaction, 0) ; In case some mod call ValidateActor function.
				endIf
			endWhile
		endIf
		if GetState() == "Animating" && PlayerRef.GetFactionRank(Config.AnimatingFaction) == 0
			Debug.Notification("Player movement locked - repositioning scene...")
			ApplyFade()
			; Disable Controls
			if PlayerSlot != none
				if PlayerRef.GetFurnitureReference() == none
					PlayerSlot.SendDefaultAnimEvent() ; Seems like the CenterRef don't change if PlayerRef is running
				endIf
				PlayerSlot.LockActor()
			else
				Config.GetThreadControl(self)
			endIf
			int i
			while i < ActorCount
				sslActorAlias ActorSlot = ActorAlias[i]
				if ActorSlot != none && ActorSlot != PlayerSlot
					ActorSlot.LockActor()
				endIf
				i += 1
			endWhile
			; Clear CenterAlias to avoid player repositioning to previous position
			if CenterAlias.GetReference() != none
				CenterAlias.TryToClear()
			endIf
			UnregisterForUpdate()
			; Give player time to settle incase airborne
			Utility.Wait(1.0)
			; Recenter on coords to avoid stager + resync animations
			if AreUsingFurniture(Positions) > 0
				CenterOnBed(false, 300.0)
			endIf
			Log("PreFurnitureStatus:"+PreFurnitureStatus+" BedTypeID:"+BedTypeID)
			if PreFurnitureStatus != BedTypeID || (PreFurnitureStatus > 0 && CenterAlias.GetReference() == none)
				ClearAnimations()
				if CenterAlias.GetReference() == none ;Is not longer using Furniture
					; Center on fallback choices
					if HasPlayer && !(PlayerRef.GetFurnitureReference() || PlayerRef.IsSwimming() || PlayerRef.IsFlying())
						CenterOnObject(PlayerRef, false)
					elseIf IsAggressive && !(VictimRef.GetFurnitureReference() || VictimRef.IsSwimming() || VictimRef.IsFlying())
						CenterOnObject(VictimRef, false)
					else
						i = 0
						while i < ActorCount
							if !(Positions[i].GetFurnitureReference() || Positions[i].IsSwimming() || Positions[i].IsFlying())
								CenterOnObject(Positions[i], false)
								i = ActorCount
							endIf
							i += 1
						endWhile
					endIf
					CenterOnObject(PlayerRef, false)
				endIf
				ChangeActors(Positions)
				SendThreadEvent("ActorsRelocated")
			elseIf CenterAlias.GetReference() != none ;Is using Furniture
				RealignActors()
				SendThreadEvent("ActorsRelocated")
			else
				CenterOnObject(PlayerRef, true)
			endIf
			; Return to animation loop
			ResetPositions()
		endIf
	endFunction

	event OnKeyDown(int KeyCode)
		; StateCheck()
		if hkReady && !Utility.IsInMenuMode() ; || UI.IsMenuOpen("Console") || UI.IsMenuOpen("Loading Menu")
			hkReady = false
			int i = Hotkeys.Find(KeyCode)
			; Advance Stage
			if i == kAdvanceAnimation
				AdvanceStage(Config.BackwardsPressed())

			; Change Animation
			elseIf i == kChangeAnimation
				ChangeAnimation(Config.BackwardsPressed())

			; Forward / Backward adjustments
			elseIf i == kAdjustForward
				AdjustForward(Config.BackwardsPressed(), Config.AdjustStagePressed())

			; Up / Down adjustments
			elseIf i == kAdjustUpward
				AdjustUpward(Config.BackwardsPressed(), Config.AdjustStagePressed())

			; Left / Right adjustments
			elseIf i == kAdjustSideways
				AdjustSideways(Config.BackwardsPressed(), Config.AdjustStagePressed())

			; Rotate Scene
			elseIf i == kRotateScene
				RotateScene(Config.BackwardsPressed())

			; Adjust schlong bend
			elseIf i == kAdjustSchlong
				AdjustSchlong(Config.BackwardsPressed())

			; Change Adjusted Actor
			elseIf i == kAdjustChange
				AdjustChange(Config.BackwardsPressed())

			; RePosition Actors
			elseIf i == kRealignActors
				ResetPositions()

			; Change Positions
			elseIf i == kChangePositions
				ChangePositions(Config.BackwardsPressed())

			; Restore animation offsets
			elseIf i == kRestoreOffsets
				RestoreOffsets()

			; Move Scene
			elseIf i == kMoveScene
				MoveScene()

			; EndAnimation
			elseIf i == kEndAnimation
				if Config.BackwardsPressed()
					; End all threads
					Config.ThreadSlots.StopAll()
				else
					; End only current thread
					EndAnimation(true)
				endIf

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
		ActorAlias[0].SyncAll(true)
		ActorAlias[1].SyncAll(true)
		ActorAlias[2].SyncAll(true)
		ActorAlias[3].SyncAll(true)
		ActorAlias[4].SyncAll(true)
		Utility.Wait(0.1)
		RegisterForSingleUpdate(0.5)
	endFunction

	function TriggerOrgasm()
		UnregisterForUpdate()
		if SoundFX
			SoundFX.Play(GetCenterFX())
		endIf
		QuickEvent("Orgasm")
		RegisterForSingleUpdate(0.5)
	endFunction

	function ResetPositions()
		UnregisterForUpdate()
		ApplyFade()
		GoToState("Refresh")
		SyncEvent(kRefreshActor, 15.0)
	endFunction
endState

state Refresh
	function RefreshDone()
		RegisterForSingleUpdate(0.5)
	endFunction
	function ResetPositions()
		RegisterForSingleUpdate(0.5)
	endFunction
	event OnUpdate()
		GoToState("Animating")
		FireAction()
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
	; Sort actors positions if needed
	int VictimPos = Positions.Find(VictimRef)
	if Config.FixVictimPos && IsAggressive && ActorCount > 1 && VictimPos >= 0
		if Animation.HasTag("FemDom") && VictimPos == 0
			; Shuffle actor positions
			Positions[VictimPos] = Positions[1]
			Positions[1] = VictimRef
		elseIf !Animation.HasTag("FemDom") && VictimPos != 0
			; Shuffle actor positions
			Positions[VictimPos] = Positions[0]
			Positions[0] = VictimRef
		endIf
	endIf
	Positions = ThreadLib.SortActorsByAnimation(Positions, Animation)
	UpdateAdjustKey()
	int i = ActorCount
	
	; Inform player of animation being played now
	if HasPlayer
		string msg = "Playing Animation: " + Animation.Name
		SexLabUtil.PrintConsole(msg)
		if DebugMode
			Debug.Notification(msg)
		endIf
	endIf
	; Update animation info
	RecordSkills()
	string[] Tags = Animation.GetRawTags()
	; IsType = [1] IsVaginal, [2] IsAnal, [3] IsOral, [4] IsLoving, [5] IsDirty, [6] HadVaginal, [7] HadAnal, [8] HadOral
	IsType[1]  = Females > 0 && (Tags.Find("Vaginal") != -1 || Tags.Find("Pussy") != -1)
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
		if Stage == 1
			ResetPositions()
		else
			ActorAlias[0].SyncAll(true)
			ActorAlias[1].SyncAll(true)
			ActorAlias[2].SyncAll(true)
			ActorAlias[3].SyncAll(true)
			ActorAlias[4].SyncAll(true)
			Utility.WaitMenuMode(0.2)
			PlayStageAnimations()
		endIf
	endIf
endFunction

ObjectReference function GetCenterFX()
	if CenterRef != none && CenterRef.Is3DLoaded()
		return CenterRef
	else
		int i = 0
		while i < ActorCount
			if Positions[i] != none && Positions[i].Is3DLoaded()
				return Positions[i]
			endIf
			i += 1
		endWhile
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
	if Animation
		TimedStage = Animation.HasTimer(Stage)
		if TimedStage
			Log("Stage has timer: "+Animation.GetTimer(Stage))
		endIf
	else
		TimedStage = false
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
		StorageUtil.SetFloatValue(Config,"SexLab.LastLeadInEnd", SexLabUtil.GetCurrentGameRealTime())
		SendThreadEvent("LeadInEnd")
		Action("Advancing")
	endIf
endFunction

function EndAnimation(bool Quickly = false)
	UnregisterForUpdate()
	Stage   = StageCount
	FastEnd = Quickly
	if HasPlayer
		MiscUtil.SetFreeCameraState(false)
		if Game.GetCameraState() == 0
			Game.ForceThirdPerson()
		endIf
	endIf
	Utility.WaitMenuMode(0.5)
	GoToState("Ending")
endFunction

state Ending
	event OnBeginState()
		UnregisterForUpdate()
		if UsingBed && CenterRef.IsActivationBlocked()
			SetFurnitureIgnored(false)
		endIf
		HookAnimationEnding()
		SendThreadEvent("AnimationEnding")
		if IsObjectiveDisplayed(0)
			SetObjectiveDisplayed(0, False)
		endIf
		RecordSkills()
		DisableHotkeys()
		Config.DisableThreadControl(self)
		SyncEvent(kResetActor, 15.0)
	endEvent
	event OnUpdate()
		ResetDone()
	endEvent
	function ResetDone()
		UnregisterforUpdate()
		HookAnimationEnd()
		SendThreadEvent("AnimationEnd")
		if Adjusted
			Log("Auto saving adjustments...")
			sslSystemConfig.SaveAdjustmentProfile()
		endIf
		GoToState("Frozen")
	endFunction
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
	float xp = ((TimeNow - SkillTime) / 8.0)
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
		; Prepare bound keys
		Hotkeys = new int[13]
		Hotkeys[kAdvanceAnimation] = Config.AdvanceAnimation
		Hotkeys[kChangeAnimation]  = Config.ChangeAnimation
		Hotkeys[kChangePositions]  = Config.ChangePositions
		Hotkeys[kAdjustChange]     = Config.AdjustChange
		Hotkeys[kAdjustForward]    = Config.AdjustForward
		Hotkeys[kAdjustSideways]   = Config.AdjustSideways
		Hotkeys[kAdjustUpward]     = Config.AdjustUpward
		Hotkeys[kRealignActors]    = Config.RealignActors
		Hotkeys[kRestoreOffsets]   = Config.RestoreOffsets
		Hotkeys[kMoveScene]        = Config.MoveScene
		Hotkeys[kRotateScene]      = Config.RotateScene
		Hotkeys[kEndAnimation]     = Config.EndAnimation
		Hotkeys[kAdjustSchlong]    = Config.AdjustSchlong
		int i
		while i < Hotkeys.Length
			RegisterForKey(Hotkeys[i])
			i += 1
		endwhile
		; Prepare soundfx
		HotkeyUp   = Config.HotkeyUp
		HotkeyDown = Config.HotkeyDown
		; Ready
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
	Prepared    = false
	AdjustPos   = 0
	AdjustAlias = ActorAlias[0]
	parent.Initialize()
endFunction

int function GetAdjustPos()
	return AdjustPos
endFunction

function PlayStageAnimations()
	if Stage <= StageCount
		Animation.GetAnimEvents(AnimEvents, Stage)
		QuickEvent("Animate")
		StageTimer = RealTime[0] + GetTimer()
	endIf
endFunction

; ------------------------------------------------------- ;
; --- Thread Events - SYSTEM USE ONLY                 --- ;
; ------------------------------------------------------- ;



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
function AdjustSchlong(bool backwards = false)
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
function ResetPositions()
endFunction
function TriggerOrgasm()
endFunction

int[] Hotkeys
int property kAdvanceAnimation = 0  autoreadonly hidden
int property kChangeAnimation  = 1  autoreadonly hidden
int property kChangePositions  = 2  autoreadonly hidden
int property kAdjustChange     = 3  autoreadonly hidden
int property kAdjustForward    = 4  autoreadonly hidden
int property kAdjustSideways   = 5  autoreadonly hidden
int property kAdjustUpward     = 6  autoreadonly hidden
int property kRealignActors    = 7  autoreadonly hidden
int property kRestoreOffsets   = 8  autoreadonly hidden
int property kMoveScene        = 9  autoreadonly hidden
int property kRotateScene      = 10 autoreadonly hidden
int property kEndAnimation     = 11 autoreadonly hidden
int property kAdjustSchlong    = 12 autoreadonly hidden

Sound[] HotkeyDown
Sound[] HotkeyUp
function PlayHotkeyFX(int i, bool backwards)
	if backwards
		HotkeyDown[i].Play(Positions[AdjustPos])
	else
		HotkeyUp[i].Play(Positions[AdjustPos])
	endIf
endFunction

event OnKeyDown(int keyCode)
	; StateCheck()
endEvent

;/ function StateCheck()
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
endFunction /;
