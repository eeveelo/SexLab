scriptname sslThreadController extends sslThreadModel
{Animation Thread Controller: Runs manipulation logic of thread based on information from model}

;/-----------------------------------------------\;
;|	Primary Starter                              |;
;\-----------------------------------------------/;

bool primed
bool scaled
float[] displayScales
float[] bases

sslThreadController function PrimeThread()
	if GetState() != "Making"
		return none
	endIf
	stage = 0
	sfx = new float[2]
	vfx = new float[10]
	vfxInstance = new int[5]
	GotoState("Preparing")
	return self
endFunction

state Preparing
	event OnBeginState()
		primed = true
		RegisterForSingleUpdate(0.01)
	endEvent
	event OnUpdate()
		if !primed
			return
		endIf
		primed = false

		; Set random starting animation
		SetAnimation()

		; Setup actors
		ActorChain("Prepare")

		int i
		; Perform scaling
		if ActorCount > 1 && SexLab.Config.bScaleActors
			; Setup scaling for actors
			displayScales = sslUtility.FloatArray(ActorCount)
			bases = sslUtility.FloatArray(ActorCount)
			scaled = true
			; Get current scales
			i = 0
			while i < ActorCount
				; Actor size equation: D (display size) = S (SetScale size) * B (base size)
				; GetScale (papyrus) returns D, SetScale sets S part.
				; GetScale (console) returns S and D (not S and B as the text implies).
				displayScales[i] = Positions[i].GetScale()
				Positions[i].SetScale(1.0)
				bases[i] = Positions[i].GetScale()
				Positions[i].SetScale(displayScales[i] / bases[i])
				i += 1
			endWhile
			; Scale actors to D = 1.0
			i = 0
			while i < ActorCount
				Positions[i].SetScale(1.0 / bases[i])
				; Reset center coords if actor is center object
				; center actor Z axis likely changed from scaling
				if Positions[i] == CenterRef
					CenterOnObject(CenterRef, false)
				endIf
				i += 1
			endWhile
		endIf

		if IsPlayerPosition(AdjustingPosition) && ActorCount > 1
			AdjustingPosition = PositionWrap((AdjustingPosition + 1))
		endIf

		RealignActors()

		SendThreadEvent("AnimationStart")
		if leadIn
			SendThreadEvent("LeadInStart")
		endIf
		primed = true
		GotoState("BeginLoop")
	endEvent
endState

event Prepare_Actor(string eventName, string actorSlot, float argNum, form sender)
	if ValidateThread(eventName)
		int slot = (actorSlot as int)
		if slot < ActorCount
			SetupActor(Positions[slot])
		endIf
		linkready[slot] = true
	endIf
endEvent

;/-----------------------------------------------\;
;|	Animation Loops                              |;
;\-----------------------------------------------/;

bool beginLoop
bool beginStage
bool animating
bool stageBack
bool advance
bool orgasm
float advanceTimer
int previousStage

float[] sfx
float[] vfx
float vfxStrength
int[] vfxInstance
float started
float timer

state BeginLoop
	event OnBeginState()
		beginLoop = true
		RegisterForSingleUpdate(0.01)
	endEvent
	event OnUpdate()
		if !beginLoop
			return
		endIf
		beginLoop = false

		animating = true
		advance = true
		GoToState("Advance")

		; Set the SFX
		int sfxInstance
		float sfxVolume = SexLab.Config.fSFXVolume
		float vfxVolume = SexLab.Config.fVoiceVolume

		started = Utility.GetCurrentRealTime()
		while animating
			; Play SFX
			if sfx[0] <= timer - sfx[1] && sfxType != none
				sfxInstance = sfxType.Play(Positions[0])
					Sound.SetInstanceVolume(sfxInstance, sfxVolume)
					sfx[1] = timer
			endIf

			; Play Voices
			int i = 0
			while i < ActorCount
				actor a = Positions[i]
				sslBaseVoice voice = GetVoice(a)
				int vid = GetSlot(a) * 2

				if (timer - vfx[vid + 1]) > vfx[vid] && !silence[i] && voice != none
					if vfxInstance[i] > 0
						Sound.StopInstance(vfxInstance[i])
					endIf
					vfxInstance[i] = voice.Moan(a, vfxStrength, IsVictim(a))
					Sound.SetInstanceVolume(vfxInstance[i], vfxVolume)
					vfx[vid + 1] = timer
				endIf
				i += 1
			endWhile

			timer = Utility.GetCurrentRealTime() - started
			Utility.Wait(0.4)
		endWhile
	endEvent
endState

state Advance
	event OnBeginState()
		if advance == true
			RegisterForSingleUpdate(0.01)
		else
			EndAnimation(true)
		endIf
	endEvent

	event OnUpdate()
		if !advance
			return
		endIf
		advance = false

		previousStage = stage

		; Next stage
		if stageBack
			stage -= 1
		else
			stage += 1
		endIf
		if stage < 1
			stage = 1
		endIf

		stageBack = false

		if leadIn && stage > Animation.StageCount()
			; End leadIn animations and go into normal animations
			stage = 1
			leadIn = false
			SetAnimation()
			SendThreadEvent("LeadInEnd")
			; Restrip with new strip options
			if Animation.IsSexual()
				int i = 0
				while i < ActorCount
					actor position = GetActor(i)
					form[] equipment = SexLab.StripSlots(position, GetStrip(position), false)
					if equipment.Length > 0
						StoreEquipment(position, equipment)
					endIf
					i += 1
				endWhile
			endIf
			; Start Animations loop
			RealignActors()
			GoToState("Animating")
		elseIf stage <= Animation.StageCount()
			; Make sure stage exists first
			if !leadIn && stage == Animation.StageCount()
				orgasm = true
			else
				orgasm = false
			endIf
			; Start Animations loop
			GoToState("Animating")
		else
			; No valid stages left
			EndAnimation()
		endIf
	endEvent

	event OnEndState()
		if !animating
			return
		endIf
		; Stage Delay
		if stage > 1
			sfx[0] = sfx[0] - (stage * 0.2)
		endIf
		; min 1.0 delay
		if sfx[0] < 1.0
			sfx[0] = 1.0
		endIf

		; Stage silence
		silence = Animation.GetSilence(stage)
		vfxStrength = (stage as float) / (Animation.StageCount() as float)
		if Animation.StageCount() == 1 && stage == 1
			vfxStrength = 0.50		
		endIf

		; Set VFX
		int i = 0
		while i < ActorCount
			SetVFX(GetActor(i))
			i += 1
		endWhile
	endEvent
endState

state Animating
	event OnBeginState()
		if animating
			beginStage = true
			RegisterForSingleUpdate(0.01)
		endIf
	endEvent

	event OnUpdate()
		if !beginStage
			return
		endIf
		beginStage = false

		if orgasm
			SendThreadEvent("OrgasmStart")
		else
			SendThreadEvent("StageStart")
		endIf

		PlayAnimation()

		; Check if actor needs to be realigned for stage
		if previousStage != 0
			int position = 0
			while position < ActorCount
				float[] current = Animation.GetPositionOffsets(position, stage)
				float[] previous = Animation.GetPositionOffsets(position, previousStage)
				int offset = 0
				while offset < 4
					if current[offset] != previous[offset]
						MoveActor(position)
						offset = 4
					endIf
					offset += 1
				endWhile
				position += 1
			endWhile
		endIf

		advanceTimer = Utility.GetCurrentRealTime() + GetStageTimer(Animation.StageCount())

		advance = false
		while !advance && animating
			; Check actors
			int i = 0
			while i < actorCount
				actor a = GetActor(i)
				if a.IsDead() || a.IsBleedingOut() || !a.Is3DLoaded()
					EndAnimation(true)
					return
				endIf
				i += 1
			endWhile

			; Delay loop
			Utility.Wait(1.0)

			; Auto Advance
			if autoAdvance && advanceTimer < Utility.GetCurrentRealTime()
				advance = true
			endIf
		endWhile

		if orgasm
			SendThreadEvent("OrgasmEnd")
		else
			SendThreadEvent("StageEnd")
		endIf

		; stage == Animation.StageCount() && Animation.StageCount() >= 2 && Animation.IsSexual() && !leadIn
		GoToState("Advance")
	endEvent
endState

;/-----------------------------------------------\;
;|	Hotkey Functions                             |;
;\-----------------------------------------------/;

int AdjustingPosition
bool MovingScene

function AdvanceStage(bool backwards = false)
	if backwards && stage == 1
		return
	elseif backwards && stage > 1
		stageBack = true
	endIf
	advance = true
endFunction

function ChangeAnimation(bool backwards = false)
	if animations.Length == 1
		return ; Single animation selected, nothing to change to
	endIf
	if !backwards
		aid += 1
	else
		aid -= 1
	endIf
	if aid >= animations.Length
		aid = 0
	elseIf aid < 0
		aid = animations.Length - 1
	endIf

	int i = 0
	while i < ActorCount
		RemoveExtras(GetActor(i))
		i += 1
	endWhile

	SetAnimation(aid)
	RealignActors()

	i = 0
	while i < ActorCount
		;SexLab.StripActor(pos[i], victim)
		EquipExtras(GetActor(i))
		i += 1
	endWhile
	SendThreadEvent("AnimationChange")
endFunction

function ChangePositions(bool backwards = false)
	if ActorCount < 2
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
	; Removed extras/strapons
	RemoveExtras(adjusting)
	RemoveExtras(moved)
	; Shuffle
	actor[] NewPositions = Positions
	NewPositions[AdjustingPosition] = moved
	NewPositions[MovedTo] = adjusting
	Positions = NewPositions
	; Equip new extras
	EquipExtras(adjusting)
	EquipExtras(moved)
	AdjustChange(backwards)
	; Restart animations
	RealignActors()
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
	MoveActor(AdjustingPosition)
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
	MoveActor(AdjustingPosition)
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
	MoveActor(AdjustingPosition)
endFunction

function RotateScene(bool backwards = false)
	; Adjust current center's Z angle
	float adjustment = 45
	if backwards
		adjustment = adjustment * -1
	endIf
	UpdateRotation(adjustment) 
	MoveActors()
endFunction

function AdjustChange(bool backwards = false)
	if backwards
		AdjustingPosition -= 1 
	else
		AdjustingPosition += 1
	endIf
	AdjustingPosition = PositionWrap(AdjustingPosition)
	SexLab.Data.mAdjustChange.Show((AdjustingPosition + 1))
endFunction

function RestoreOffsets()
	Animation.RestoreOffsets()
	RealignActors()
endFunction

function MoveScene()
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
	Game.EnablePlayerControls()
	Debug.SendAnimationEvent(SexLab.PlayerRef, "IdleForceDefaultState")
	; Lock hotkeys here for timer
	SexLab.Data.mMoveScene.Show(6)
	float stopat = Utility.GetCurrentRealTime() + 6
	while stopat > Utility.GetCurrentRealTime()
		Utility.Wait(0.8)
	endWhile
	; Disable Controls
	Game.DisablePlayerControls(true, true, true, false, true, false, false, true, 0)
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

function SetupActor(actor position)
	if position.IsWeaponDrawn()
		position.SheatheWeapon()
	endIf
	if position.IsInCombat()
		position.StopCombat()
	endIf

	position.SetFactionRank(SexLab.AnimatingFaction, 1)
	ActorAlias.SlotActor(position)

	if IsPlayerActor(position)
		; Enable hotkeys, if needed
		if SexLab.Config.bDisablePlayer && IsVictim(position)
			autoAdvance = true
		else
			SexLab._EnableHotkeys(tid)
		endIf
		if SexLab.Config.bEnableTCL
			Debug.ToggleCollisions()
		endIf
		Game.ForceThirdPerson()
		Game.DisablePlayerControls(true, true, false, false, true, false, false, true, 0)
		Game.SetInChargen(false, true, true)
		Game.SetPlayerAIDriven()
	else
		position.SetRestrained()
		position.SetDontMove()
		position.SetAnimationVariableBool("bHumanoidFootIKDisable", true)
	endIf
	; Auto strip
	if Animation.IsSexual()
		form[] equipment = SexLab.StripSlots(position, GetStrip(position), true)
		if equipment.Length > 0
			StoreEquipment(position, equipment)
		endIf
		if SexLab.sosEnabled && Animation.GetGender(GetPosition(position)) < 1
			Debug.SendAnimationEvent(position, "SOSFastErect")
		endIf
	endIf
	EquipExtras(position)
endFunction

function ResetActor(actor position)
	; Clear slot
	ActorAlias.ClearActor(position)
	; Reset scale if needed
	if scaled
		position.SetScale(displayScales[GetPosition(position)] / bases[GetPosition(position)])
	endIf
	; Clear them out
	position.RemoveFromFaction(SexLab.AnimatingFaction)
	RemoveExtras(position)
	; Reset openmouth
	Position.ClearExpressionOverride()
	; Enable movement
	if IsPlayerActor(position)
		SexLab._DisableHotkeys()
		Game.SetInChargen(false, false, false)
		Game.SetPlayerAIDriven(false)
		Game.EnablePlayerControls()
		SexLab.UpdatePlayerStats(Animation, timer, Positions, GetVictim())
		if SexLab.Config.bEnableTCL
			Debug.ToggleCollisions()
		endIf
	else
		position.SetAnimationVariableBool("bHumanoidFootIKEnable", true)
		position.SetRestrained(false)
		position.SetDontMove(false)
	endIf
	; SOS flaccid
	if SexLab.sosEnabled && Animation.GetGender(GetPosition(position)) < 1
		Debug.SendAnimationEvent(position, "SOSFlaccid")
	endIf
	if !position.IsDead() && !position.IsBleedingOut()
		SexLab.UnstripActor(position, GetEquipment(position), GetVictim())
	endIf
	; Reset idle
	if !SexLab.Config.bRagdollEnd

		Debug.SendAnimationEvent(position, "IdleForceDefaultState")
	else
		position.PushActorAway(Positions[PositionWrap(GetPosition(position) + 1)], 1)
	endIf
endFunction

function SetVFX(actor position)
	int index = GetSlot(position) * 2
	; Base Delay
	if SexLab.GetGender(position) < 1
		vfx[index] = SexLab.Config.fMaleVoiceDelay + Utility.RandomFloat(-0.5, 0.5)
	else
		vfx[index] = SexLab.Config.fFemaleVoiceDelay + Utility.RandomFloat(-0.5, 0.5)
	endIf
	; Stage Delay
	if stage > 1
		vfx[index] = vfx[index] - (stage * 0.8)
	endIf
	; Min 1.3 delay
	if vfx[index] < 1.3
		vfx[index] = 1.3
	endIf
	; Randomize starting points
	vfx[index + 1] = Utility.RandomFloat(-0.5, 0.6)
endFunction

function EquipExtras(actor position)
	int slot = GetPosition(position)
	form[] extras = Animation.GetExtras(slot)
	if extras.Length > 0
		int i = 0
		while i < extras.Length
			if extras[i] != none
				position.EquipItem(extras[i], true, true)
			endIf
			i += 1
		endWhile
	endIf
	; Strapons are enabled for this position, and they are female in a male position
	if SexLab.GetGender(position) == 1 && Animation.GetGender(slot) == 0 && SexLab.Config.bUseStrapons && Animation.UseStrapon(slot, stage)
		SexLab.EquipStrapon(position)
	endIf
endFunction

function RemoveExtras(actor position)
	int slot = GetPosition(position)
	form[] extras = Animation.GetExtras(slot)
	if extras.Length > 0
		int i = 0
		while i < extras.Length
			if extras[i] != none
				position.UnequipItem(extras[i], true, true)
				position.RemoveItem(extras[i], 1, true)
			endIf
			i += 1
		endWhile
	endIf
	; Strapons are enabled for this position, and they are female in a male position
	SexLab.UnequipStrapon(position)
endFunction

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
	int i = 0
	while i < actorCount
		MoveActor(i)
		i += 1
	endWhile
endFunction

;/-----------------------------------------------\;
;|	Animation Functions                           |;
;\-----------------------------------------------/;

sslBaseAnimation animationCurrent
sslBaseAnimation property Animation hidden
	sslBaseAnimation function get()
		return animationCurrent
	endFunction
endProperty

int aid
Sound sfxType
bool[] silence

function SetAnimation(int anim = -1)
	if !_MakeWait("SetAnimation")
		return
	endIf
	aid = anim
	if aid < 0 ; randomize if -1
		aid = utility.RandomInt(0, animations.Length - 1)
	endIf
	animationCurrent = animations[aid]
	silence = Animation.GetSilence(stage)
	if Animation.GetSFX() == 1 ; Squishing
		sfxType = SexLab.Data.sfxSquishing01
	elseIf Animation.GetSFX() == 2 ; Sucking
		sfxType = SexLab.Data.sfxSucking01
	elseIf Animation.GetSFX() == 3 ; SexMix
		sfxType = SexLab.Data.sfxSexMix01
	else
		sfxType = none
	endIf
	if HasPlayer() && animating
		Debug.Notification(Animation.name)
	endIf
endFunction

function PlayAnimation()
	string[] events = Animation.FetchStage(stage)
	if actorCount == 1
		Debug.SendAnimationEvent(Positions[0], events[0])
	elseif actorCount == 2
		Debug.SendAnimationEvent(Positions[0], events[0])
		Debug.SendAnimationEvent(Positions[1], events[1])
	elseif actorCount == 3
		Debug.SendAnimationEvent(Positions[0], events[0])
		Debug.SendAnimationEvent(Positions[1], events[1])
		Debug.SendAnimationEvent(Positions[2], events[2])
	elseif actorCount == 4
		Debug.SendAnimationEvent(Positions[0], events[0])
		Debug.SendAnimationEvent(Positions[1], events[1])
		Debug.SendAnimationEvent(Positions[2], events[2])
		Debug.SendAnimationEvent(Positions[3], events[3])
	elseif actorCount == 5
		Debug.SendAnimationEvent(Positions[0], events[0])
		Debug.SendAnimationEvent(Positions[1], events[1])
		Debug.SendAnimationEvent(Positions[2], events[2])
		Debug.SendAnimationEvent(Positions[3], events[3])
		Debug.SendAnimationEvent(Positions[4], events[4])
	endIf

	bool[] openMouth = Animation.GetSwitchSlot(stage, 1)
	int[] sos = Animation.GetSchlongSlot(stage)
	int i = 0
	while i < actorCount
		; Open mouth, if needed
		Positions[i].ClearExpressionOverride()
		if openMouth[i]
			Positions[i].SetExpressionOverride(16, 100)
		endIf
		; Send SOS event
		if SexLab.sosEnabled && Animation.GetGender(i) < 1
			Debug.SendAnimationEvent(Positions[i], "SOSFastErect")
			Debug.SendAnimationEvent(Positions[i], "SOSBend"+sos[i])
		endIf
		i += 1
	endWhile
endFunction

event Animate_Actor(string eventName, string actorSlot, float argNum, form sender)
	if animating && ValidateThread(eventName)
		int slot = (actorSlot as int)
		if slot < ActorCount
			; Sex animation
			Debug.SendAnimationEvent(Positions[slot], Animation.FetchPositionStage(slot, stage))
			; Open mouth
			Positions[slot].ClearExpressionOverride()
			if Animation.UseOpenMouth(slot, stage)
				Positions[slot].SetExpressionOverride(16, 100)
			endIf
			; Schlongs of Skyrim integration
			if SexLab.sosEnabled && Animation.GetGender(slot) < 1
				Debug.SendAnimationEvent(Positions[slot], "SOSBend"+Animation.GetSchlong(slot, stage))
			endIf
		endIf
		linkready[slot] = true
	endIf
endEvent

;/-----------------------------------------------\;
;|	Ending Functions                             |;
;\-----------------------------------------------/;

bool[] ending

function EndAnimation(bool quick = false)
	if !animating
		UnlockThread()
		return
	endIf
	animating = false
	SendThreadEvent("AnimationEnd")

	int i = 0

	; Apply cum
	if !quick && Animation.IsSexual() && SexLab.Config.bUseCum
		int[] genders = SexLab.GenderCount(positions)
		if genders[0] > 0 || SexLab.Config.bAllowFFCum
			while i < ActorCount
				SexLab.ApplyCum(Positions[i], Animation.GetCum(i))
				i += 1
			endWhile
		endIf
	endIf

	ActorChain("Reset")

	if !quick
		Utility.Wait(2.0)
	endIf

	UnlockThread()
endFunction

event Reset_Actor(string eventName, string actorSlot, float argNum, form sender)
	if ValidateThread(eventName)
		int slot = (actorSlot as int)
		if slot < ActorCount
			ResetActor(Positions[slot])
		endIf
		linkready[slot] = true
	endIf
endEvent

function InitializeThread()
	; Clear model
	parent.InitializeThread()
	; Set states
	animating = false
	stageBack = false
	primed = false
	scaled = false
	advance = false
	orgasm = false
	; Empty Strings
	; Empty actors
	actor[] acDel
	; Empty Floats
	float[] fDel
	sfx = fDel
	vfx = fDel
	vfxStrength = 0.0
	timer = 0.0
	started = 0.0
	advanceTimer = 0.0
	; Empty bools
	bool[] bDel
	silence = bDel
	; Empty integers
	int[] iDel
	vfxInstance = iDel
	AdjustingPosition = 0
	previousStage = 0
	aid = 0
	; Empty voice slots
	; Empty animations
	animationCurrent = none
	; Empty forms
	sfxType = none
endFunction

;/-----------------------------------------------\;
;|	Chain Events                                 |;
;\-----------------------------------------------/;

bool padlock
bool[] linkready

function ActorChain(string callback)
	while padlock
		Utility.Wait(0.1)
	endWhile
	padlock = true
	linkready = new bool[5]
	string ChainLinkActor = "ChainLinkActor"+tid
	RegisterForModEvent(ChainLinkActor, callback+"_Actor")
	int i
	while i < 5
		SendModEvent(ChainLinkActor, (i as string), 1)
		i += 1
	endWhile
	UnregisterForModEvent(ChainLinkActor)
	; Wait for ready signals from all chain links
	while !linkready[0] || !linkready[1] || !linkready[2] || !linkready[3] || !linkready[4]
		Utility.Wait(0.1)
	endWhile
	padlock = false
endFunction

bool function ValidateThread(string eventName)
	return eventName == "ChainLinkActor"+tid
endFunction

;/-----------------------------------------------\;
;|	API Functions                                |;
;\-----------------------------------------------/;

float function GetTime()
	return timer
endfunction