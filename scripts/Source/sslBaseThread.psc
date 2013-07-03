scriptname sslBaseThread extends quest

; quest property sslSys auto
SexLabFramework property SexLab auto
int function tid()
	return -1
endFunction

; Starters
bool active
bool primed
bool animating

float timer
float progress
int sfxType
float[] sfx

float strength
int[] vfxInstance
float[] vfx

; Thread Variables
bool advance ; Auto Advance
bool leadIn ; If playing leadIn animations.
int aid ; Current Animation Index for accessing it from registry 
string hook ; Custom hook for this instance
int stage ; Current animation stage
int stageCount
bool sexual ; For performing functions specific to sex, such as stripping
actor victim ; The actor position treated as a victim of aggressive/roughing/rape
ObjectReference centerRef ; The location of this animation, such as a bed, item, or actor
sslBaseAnimation anim ; Current Animation
sslBaseAnimation[] animations ; List of passed animations we can cycle through
sslBaseAnimation[] leadInto ; leadIn animations save
int adjustingPos = 1
; The participants
int player = -1 ; Which position index the player is in, -1 if player not involved
actor[] pos ; Actors in event
sslBaseVoice[] voice ; Actors voice files
int[] aliasSlot ; The index of the DoNothing alias for the actor 
bool[] silence
bool bed
float averageScale

float[] centerLoc
; Actor storage
form[] equipmentA1
form[] equipmentA2
form[] equipmentA3
form[] equipmentA4
form[] equipmentA5

form[] extrasA1
form[] extrasA2
form[] extrasA3
form[] extrasA4
form[] extrasA5

float[] locA1
float[] locA2
float[] locA3
float[] locA4
float[] locA5

; TODO: allow seperate
; timers per stage
; TEMP: static stage time
float[] timers

; Configurations
bool autoAdvance
int actorCount
int animCount

;#---------------------------#
;#                           #
;#   API RELATED FUNCTIONS   #
;#                           #
;#---------------------------#

int function GetPlayerPosition()
	return player
endFunction

int function GetStage()
	return stage
endFunction

sslBaseAnimation function GetAnimation()
	return anim
endFunction

function ForceAnimation(sslBaseAnimation animation)
	sslBaseAnimation[] forced = new sslBaseAnimation[1]
	forced[0] = animation
	animations = forced
	SetAnimationList(forced)
	RealignActors()
	stage -= 1
	AdvanceStage()
endFunction

function SetAnimation(sslBaseAnimation animation)
	if !active
		return
	endIf
	anim = animation
	stageCount = anim.StageCount()
	sexual = anim.IsSexual()
	sfxType = anim.GetSFX()
	if anim.tcl
		Debug.ToggleCollisions()
	endIf
	if player != -1
		Debug.Notification(anim.name)
	endIf
endFunction

sslBaseAnimation[] function GetAnimationList()
	return animations
endFunction

function SetAnimationList(sslBaseAnimation[] animationList)
	if !active
		return
	endIf
	animations = animationList
	animCount = animations.Length
	aid = utility.RandomInt(0, animCount - 1)
	SetAnimation(animations[aid])
endFunction

function CenterOnCoords(float LocX = 0.0, float LocY = 0.0, float LocZ = 0.0, float RotX = 0.0, float RotY = 0.0, float RotZ = 0.0, bool resync = true)
	float[] coords = new float[6]
	coords[0] = LocX
	coords[1] = LocY
	coords[2] = LocZ
	coords[3] = RotX
	coords[4] = RotY
	coords[5] = RotZ
	if resync
		RealignActors()
		SexLab._SendEventHook("ActorsRelocated", tid(), hook)
	endIf
endFunction

function CenterOnObject(ObjectReference center, bool resync = true)
	if center == none
		Debug.Trace("-----SEXLAB NOTICE: No valid ObjectReference given for sslBaseThread.MoveToObject()")
		return
	endIf
	bed = false
	centerLoc = GetCoords(center)
	if SexLab.Data.BedsList.HasForm(center.GetBaseObject())
		centerLoc[0] = centerLoc[0] + (35 * Math.sin(centerLoc[5]))
		centerLoc[1] = centerLoc[1] + (35 * Math.cos(centerLoc[5]))
		centerLoc[2] = centerLoc[2] + 35
		bed = true
	endIf
	if resync
		RealignActors()
		SexLab._SendEventHook("ActorsRelocated", tid(), hook)
	endIf
endFunction

function ChangeActors(actor[] changeTo)
	if !active
		return
	endIf
	int newCount = changeTo.Length
	int i = 0
	; Make sure all new actors are vaild.
	while i < newCount
		if pos.Find(changeTo[i]) < 0 && SexLab.ValidateActor(changeTo[i]) < 0
			return 
		endIf
		i += 1
	endWhile
	; Actor count has changed, get new default animation list
	if newCount != actorCount
		sslBaseAnimation[] newList
		; Try aggressive animations first if we need them
		if victim != none
			newList = SexLab.GetAnimationsByType(newCount, aggressive=true)
		endIf
		; Runs if no victim or victim search didn't find any
		if newList.Length == 0
			newList = SexLab.GetAnimationsByType(newCount)
		endIf
		; Still none? We have no animations for this count, bail
		if newList.Length == 0
			return	
		endIf
		; Set our new list
		SetAnimationList(newList)
	endIf
	SexLab._SendEventHook("ActorChangeStart", tid(), hook)
	i = 0
	; reset current actors
	while i < actorCount
		actor a = pos[i]
		ResetActor(i)
		if changeTo.Find(a) < 0
			if SexLab.PlayerRef == a
				autoAdvance = true
				if anim.tcl
					Debug.ToggleCollisions()
				endIf
			endIf
			; Debug.SendAnimationEvent(a, "IdleForceDefaultState")
			; a.PushActorAway(a, 0.2)
		endIf
		i += 1
	endWhile
	actorCount = newCount
	pos = changeTo
	PrepareActors()
	;Restart stage
	stage -= 1
	AdvanceStage()
	SexLab._SendEventHook("ActorChangeEnd", tid(), hook)
endFunction

actor function GetVictim()
	return victim
endFunction

actor[] function GetActors()
	return pos
endFunction

float function GetTime()
	return timer
endFunction

;#---------------------------#
;#                           #
;#     END API FUNCTIONS     #
;#                           #
;#---------------------------#

function SpawnThread(actor[] positions, sslBaseAnimation[] animationList, sslBaseAnimation[] leadInAnimations, actor victimPosition = none, ObjectReference centerOn = none, string customHook = "")
	if !active
		GoToState("Waiting")
	else
		return
	endIf
	; Lock the thread
	active = true
	; Set Primary Animation Variables
	pos = positions
	hook = customHook

	if leadInAnimations.Length == 0
		leadIn = false
		if victimPosition != none
			timers = SexLab.Config.fStageTimerAggr
		else
			timers = SexLab.Config.fStageTimer
		endIf
		SetAnimationList(animationList)
	else
		leadIn = true
		SetAnimationList(leadInAnimations)
		timers = SexLab.Config.fStageTimerLeadIn
		leadInto = animationList
	endIf

	actorCount = positions.Length
	if victimPosition != none
		victim = victimPosition
	endIf

	CenterOnObject(centerOn, false)

	; Find if player present
	int i = 0
	while i < actorCount
		if pos[i] == SexLab.PlayerRef
			player = i
			; Auto advance?
			if !SexLab.Config.bAutoAdvance
				autoAdvance = false
			endIf
			; Enable hotkeys, if needed
			if pos[i] == victim && SexLab.Config.bDisablePlayer
				autoAdvance = true
			else
				SexLab._EnableHotkeys(tid())
			endIf
			; Don't start with them as adjustee
			if i == adjustingPos
				adjustingPos += 1
				if adjustingPos >= actorCount
					adjustingPos = 0
				endIf
			endIf
			i = actorCount
		endIf
		i += 1
	endWhile
	; Start processing
	SetAnimation(animations[aid])
	; Store, Disable, Strip, & Move
	PrepareActors()
	; Begin animating
	primed = true
	RegisterForSingleUpdate(0.1)
endFunction

function SaveLocation(int position, float[] loc)
	if position == 0
		locA1 = loc
	elseIf position == 1
		locA2 = loc
	elseIf position == 2
		locA3 = loc
	elseIf position == 3
		locA4 = loc
	elseIf position == 4
		locA5 = loc
	endIf
endFunction

float[] function GetLocation(int position)
	if position == 0
		return locA1
	elseIf position == 1
		return locA2
	elseIf position == 2
		return locA3
	elseIf position == 3
		return locA4
	elseIf position == 4
		return locA5
	endIf
endFunction

float[] function OffsetCoords(float[] offsets)
	float[] loc = new float[6]
	; Determine offsets coordinates from center
	loc[0] = ( centerLoc[0] + ( Math.sin(centerLoc[5]) * offsets[0] + Math.cos(centerLoc[5]) * offsets[1] ) )
	loc[1] = ( centerLoc[1] + ( Math.cos(centerLoc[5]) * offsets[0] + Math.sin(centerLoc[5]) * offsets[1] ) )
	loc[2] = ( centerLoc[2] + offsets[2] )
	; Determine rotation coordinates from center
	loc[3] = centerLoc[3]
	loc[4] = centerLoc[4]
	loc[5] = ( centerLoc[5] + offsets[3] )
	if loc[5] >= 360
		loc[5] = ( loc[5] - 360 )
	elseIf loc[5] < 0
		loc[5] = ( loc[5] + 360 )
	endIf
	return loc
endFunction

function MoveActor(int position)
	; (int position) should be zero indexed
	float[] loc = OffsetCoords(anim.GetPositionOffsets(position, stage))	
	pos[position].SetPosition(loc[0], loc[1], loc[2])
	pos[position].SetAngle(loc[3], loc[4], loc[5])
	SaveLocation(position, loc)
endFunction

function PrepareActors()
	int i = 0
	while i < actorCount
		actor a = pos[i]
		; store information
		voice[i] = SexLab.PickVoice(a)
		; Stop them from doing stuff
		aliasSlot[i] = SexLab._SlotDoNothing(a)
		; Disable their movement
		a.StopCombat()
		a.SetFactionRank(SexLab.AnimatingFaction, 1)
		if SexLab.PlayerRef == a
			Game.DisablePlayerControls(true, true, true, false, true, false, false, true, 0)
			Game.SetInChargen(false, true, true)
			Game.ForceThirdPerson()
			Game.SetPlayerAIDriven()
		else
			a.SetRestrained()
			a.SetDontMove()
			a.SetAnimationVariableBool("bHumanoidFootIKDisable", true)
		endIf
		; Auto strip
		if sexual
			form[] equipment = SexLab.StripActor(a, victim, true, leadIn)
			SetEquipment(i, equipment)
		endIf
		; Get animation extras
		EquipExtras(i)
		; Position them	
		MoveActor(i)
		i += 1
	endWhile
	utility.wait(1.0)
	; Scale them to average size, if enabled
	if actorCount > 1 && SexLab.Config.bScaleActors
		int count = pos.Length
		float[] scales = sslUtility.FloatArray(count)
		float average = 0.0
		i = 0
		while i < count
			scales[i] = pos[i].GetScale()
			average += scales[i]
			i += 1
		endWhile
		average = ( average / count )
		i = 0
		while i < count
			pos[i].SetScale((average / scales[i]))
			i += 1
		endWhile
	endIf
endFunction

function ResetActor(int i)
	actor a = pos[i]
	; Reset scale if needed
	if actorCount > 1 && SexLab.Config.bScaleActors
		a.SetScale(1.0)
	endIf
	; Enable movement
	if SexLab.PlayerRef == a
		SexLab.UnregisterForAllKeys()
		Game.EnablePlayerControls()
		Game.SetInChargen(false, false, false)
		Game.SetPlayerAIDriven(false)
		SexLab.UpdatePlayerStats(anim, timer, pos, victim)
	else
		a.SetRestrained(false)
		a.SetDontMove(false)
		a.SetAnimationVariableBool("bHumanoidFootIKEnable", true)
	endIf
	; Clear them out
	a.RemoveFromFaction(SexLab.AnimatingFaction)
	SexLab._ClearDoNothing(aliasSlot[i])
	RemoveExtras(i)
	; Reset idle
	if !SexLab.Config.bRagdollEnd
		Debug.SendAnimationEvent(a, "IdleForceDefaultState")
	else
		a.PushActorAway(a, 0.1)
	endIf
endFunction

float[] function GetCoords(ObjectReference loc)
	float[] coords = new float[6]
	coords[0] = loc.GetPositionX()
	coords[1] = loc.GetPositionY()
	coords[2] = loc.GetPositionZ()
	coords[3] = loc.GetAngleX()
	coords[4] = loc.GetAngleY()
	coords[5] = loc.GetAngleZ()
	return coords
endFunction

function RemoveExtras(int position)
	form[] extras
	if position == 0
		 extras = extrasA1
	elseIf position == 1
		 extras = extrasA2
	elseIf position == 2
		 extras = extrasA3
	elseIf position == 3
		 extras = extrasA4
	elseIf position == 4
		 extras = extrasA5
	endIf

	int extrasCount = extras.Length
	if extrasCount > 0
		int i = 0
		while i < extrasCount
			if extras[i] != none
				pos[position].UnequipItem(extras[i], false, true)
				pos[position].RemoveItem(extras[i], 1, true)
			endIf
			i += 1
		endWhile
	endIf
endFunction

function EquipExtras(int position)
	form[] extras = anim.GetExtras(position)
	int extrasCount = extras.Length

	; Animation specific extras
	if extrasCount > 0
		int i = 0
		while i < extrasCount
			if extras[i] != none
				pos[position].EquipItem(extras[i], false, true)
			endIf
			i += 1
		endWhile
	endIf

	; Strapons are enabled for this position, and they are female in a male position
	if SexLab.Config.bUseStrapons && anim.UseStrapon(position, stage) && anim.GetGender(position) == 0 && pos[position].GetLeveledActorBase().GetSex() == 1
		form strapon = SexLab.EquipStrapon(pos[position])
		extras = sslUtility.PushForm(strapon,extras)
	endIf

	if position == 0
		extrasA1 = extras
	elseIf position == 1
		extrasA2 = extras
	elseIf position == 2
		extrasA3 = extras
	elseIf position == 3
		extrasA4 = extras
	elseIf position == 4
		extrasA5 = extras
	endIf
endFunction

function SetEquipment(int position, form[] equipment)
	if position == 0
		equipmentA1 = equipment
	elseIf position == 1
		equipmentA2 = equipment
	elseIf position == 2
		equipmentA3 = equipment
	elseIf position == 3
		equipmentA4 = equipment
	elseIf position == 4
		equipmentA5 = equipment
	endIf
endFunction

form[] function GetEquipment(int position)
	if position == 0
		return equipmentA1
	elseIf position == 1
		return equipmentA2
	elseIf position == 2
		return equipmentA3
	elseIf position == 3
		return equipmentA4
	elseIf position == 4
		return equipmentA5
	endIf
endFunction

function EndAnimation(bool quick = false)
	if !CheckActive()
		return
	endIf

	int i = 0
	; Apply cum
	if !quick && sexual
		while i < actorCount
			if SexLab.Config.bUseCum && anim.GetCum(i) > 0 && pos[i].GetLeveledActorBase().GetSex() == 1
				int[] genders = SexLab.GenderCount(pos)
				if genders[0] > 0
					SexLab.ApplyCum(pos[i], anim.GetCum(i))
				elseIf SexLab.Config.bAllowFFCum && genders[0] > 1
					SexLab.ApplyCum(pos[i], anim.GetCum(i))
				endIf
			endIf
			i += 1
		endWhile
	endIf

	animating = false

	if player >= 0 && anim.tcl
		Debug.ToggleCollisions()
	endIf

	i = 0
	while i < actorCount
		ResetActor(i)
		i += 1
	endWhile
	if !quick
		Utility.Wait(2.0)
	endIf

	; Requip them
	i = 0
	while i < actorCount
		if !pos[i].IsDead() && !pos[i].IsBleedingOut()
			SexLab.UnstripActor(pos[i], GetEquipment(i), victim)
		endIf
		i += 1
	endWhile
	SexLab._SendEventHook("AnimationEnd", tid(), hook)
	Utility.Wait(4.0)
	SexLab._EndThread(tid(), player)
	GoToState("Waiting")
endFunction

function AdvanceStage(bool backwards = false)
	if backwards && stage == 1
		stage = 0
	elseIf backwards
		stage -= 2 ; Account for stage increase on advance
	endIf
	advance = true
endFunction

function ChangeAnimation(bool backwards = false)
	if animCount == 1
		return ; Single animation selected, nothing to change to
	endIf

	if player >= 0 && anim.tcl
		Debug.ToggleCollisions()
	endIf

	if !backwards
		aid += 1
	else
		aid -= 1
	endIf

	if aid >= animCount
		aid = 0
	elseIf aid < 0
		aid = animCount - 1
	endIf

	SetAnimation(animations[aid])
	
	int i = 0
	while i < actorCount
		;SexLab.StripActor(pos[i], victim)
		RemoveExtras(i)
		EquipExtras(i)
		i += 1
	endWhile
	
	RealignActors()

	SexLab._SendEventHook("AnimationChange", tid(), hook)
endFunction

function ChangePositions()
	if actorCount < 2
		return ; Solo Animation, nobody to swap with
	endIf
	int newPos = adjustingPos + 1
	if newPos >= actorCount
		newPos = 0 ; Outside range, wrap to start
	endIf
	; Who are we swapping
	actor adjustedPos = pos[adjustingPos]
	actor replacedPos = pos[newPos]
	if centerRef == adjustedPos
		centerRef = replacedPos
	elseif centerRef == replacedPos
		centerRef = adjustedPos
	endIf
	; Swap Positions
	RemoveExtras(newPos)
	RemoveExtras(adjustingPos)
	pos[newPos] = adjustedPos
	pos[adjustingPos] = replacedPos
	; Swap Alias
	int adjustedAlias = aliasSlot[adjustingPos]
	int replacedAlias = aliasSlot[newPos]
	aliasSlot[newPos] = replacedAlias
	aliasSlot[adjustingPos] = adjustedAlias
	; Swap Voices
	sslBaseVoice adjustedVoice = voice[adjustingPos]
	sslBaseVoice replacedVoice = voice[newPos]
	voice[newPos] = adjustedVoice
	voice[adjustingPos] = replacedVoice
	; Swap equipment saves
	form[] adjustedEquip = GetEquipment(adjustingPos)
	form[] replacedEquip = GetEquipment(newPos)
	SetEquipment(newPos, adjustedEquip)
	SetEquipment(adjustingPos, replacedEquip)
	; Equip new position extras
	EquipExtras(newPos)
	EquipExtras(adjustingPos)
	; Keep adjustment choice
	if adjustingPos == player
		player = newPos
	elseif newPos == player
		player = adjustingPos
	endIf
	adjustingPos = newPos
	; Restart animations
	RealignActors()
	SexLab._SendEventHook("PositionChange", tid(), hook)
endFunction

function AdjustForward(bool backwards = false)
	float adjustment
	if backwards
		adjustment = -0.5
	else
		adjustment = 0.5
	endIf
	anim.UpdateForward(adjustingPos, stage, adjustment)
	pos[adjustingPos].MoveTo(pos[adjustingPos], Math.sin(centerLoc[5]) * adjustment, Math.cos(centerLoc[5]) * adjustment, 0.0, true)
endFunction

function AdjustSideways(bool backwards = false)
	float adjustment
	if backwards
		adjustment = -0.5
	else
		adjustment = 0.5
	endIf
	anim.UpdateSide(adjustingPos, stage, adjustment)
	pos[adjustingPos].MoveTo(pos[adjustingPos], Math.cos(centerLoc[5]) * adjustment, Math.sin(centerLoc[5]) * adjustment, 0.0, true)
endFunction

function AdjustUpward(bool backwards = false)
	if adjustingPos == player
		return
	endIf
	float adjustment
	if backwards
		adjustment = -0.5
	else
		adjustment = 0.5
	endIf
	anim.UpdateUp(adjustingPos, stage, adjustment)
	pos[adjustingPos].MoveTo(pos[adjustingPos], 0, 0, adjustment, true)
endFunction

function AdjustChange(bool backwards = false)
	adjustingPos += 1
	if adjustingPos >= actorCount
		adjustingPos = 0
	endIf
	SexLab.Data.mAdjustChange.Show(adjustingPos + 1)
endFunction

function RotateScene(bool backwards = false)
	; Adjust current center's Z angle
	if backwards
		centerLoc[5] = centerLoc[5] - 45 
	else
		centerLoc[5] = centerLoc[5] + 45
	endIf
	; Clamp rotation to 0 - 360
	if centerLoc[5] >= 360
		centerLoc[5] = ( centerLoc[5] - 360 )
	elseIf centerLoc[5] < 0
		centerLoc[5] = ( centerLoc[5] + 360 )
	endIf
	int i = 0
	while i < actorCount
		MoveActor(i)
		i += 1
	endWhile
endFunction

function MoveScene()
	bool advanceToggle
	; Toggle auto advance off
	if autoAdvance
		autoAdvance = false
		advanceToggle = true
	endIf
	; Enable Controls
	Game.EnablePlayerControls()
	Game.SetPlayerAIDriven(false)
	Debug.SendAnimationEvent(SexLab.PlayerRef, "IdleForceDefaultState")
	; Lock hotkeys here for timer
	SexLab.Data.mMoveScene.Show(6)
	float stopat = Utility.GetCurrentRealTime() + 6
	while stopat > Utility.GetCurrentRealTime()
		Utility.Wait(0.8)
	endWhile
	; Disable Controls
	Game.DisablePlayerControls(true, true, true, false, true, false, false, true, 0)
	Game.ForceThirdPerson()
	Game.SetPlayerAIDriven()
	; Give player time to settle incase airborne
	Utility.Wait(1.0)
	; Recenter + sync
	CenterOnObject(SexLab.PlayerRef)
	; Toggle auto advance back
	if advanceToggle
		autoAdvance = true
	endIf
endFunction

function RealignActors()
	anim.PlayAnimations(pos, stage)
	int i = 0
	while i < actorCount
		MoveActor(i)
		i += 1
	endWhile
endFunction

function RestoreOffsets()
	anim.RestoreOffsets()
	RealignActors()
endFunction

bool function CheckActive()
	if !active
		debug.Trace("SexLab thread["+tid()+"] is not active")
		GoToState("Waiting")
		return false
	else
		return true
	endIf
endFunction

float function GetStageTimer()
	int last = ( timers.Length - 1 )
	if stage == stageCount
		return timers[last]
	elseif stage < last
		return timers[(stage - 1)]
	endIf
	return timers[(last - 1)]
endfunction

;#---------------------------#
;#  ANIMATION PROCESS EVENT  #
;#---------------------------#

state BeginLoop
	event OnUpdate()
		animating = true

		; Set the SFX
		int instance
		float volume = SexLab.Config.fSFXVolume
		sfx = new float[2]

		; Set the voices
		vfx = sslUtility.FloatArray(pos.Length * 2)

		self.GoToState("Advance")
		self.RegisterForSingleUpdate(0.01)

		float started = Utility.GetCurrentRealTime()
		while animating
			; Play SFX
			if sfx[0] <= timer - sfx[1] && sfxType > 0
				if sfxType == 1 ; Squishing
					instance = SexLab.Data.sfxSquishing01.Play(pos[0])
				elseIf sfxType == 2 ; Sucking
					instance = SexLab.Data.sfxSucking01.Play(pos[0])
				elseIf sfxType == 3 ; SexMix
					if utility.RandomInt(0,1)
						instance =  SexLab.Data.sfxSquishing01.Play(pos[0])
					else
						instance =  SexLab.Data.sfxSucking01.Play(pos[0])
					endIf
				endIf
				Sound.SetInstanceVolume(instance, volume)
				sfx[1] = timer
			endIf

			; Play Voices
			int i = 0
			while i < actorCount
				int vid = i * 2
				if voice[i] != none && (timer - vfx[vid + 1]) > vfx[vid] && !silence[i]
					if vfxInstance[i] > 0
						Sound.StopInstance(vfxInstance[i])
					endIf
					vfxInstance[i] = voice[i].Moan(pos[i], strength, victim)
					Sound.SetInstanceVolume(vfxInstance[i], SexLab.Config.fVoiceVolume)
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
	event OnUpdate()
		CheckActive()
		; Increase stage
		stage += 1
		; Make sure stage exists first
		if stage <= stageCount
			anim.PlayAnimations(pos, stage)
			self.GoToState("Animating")
		; End leadIn animations and go into normal animations
		elseIf leadIn && stage > stageCount
			if victim != none
				timers = SexLab.Config.fStageTimerAggr
			else
				timers = SexLab.Config.fStageTimer
			endIf
			stage = 1
			leadIn = false
			SetAnimationList(leadInto)

			if sexual
				int i = 0
				while i < actorCount
					form[] equipment = SexLab.StripActor(pos[i], victim, false, false)
					form[] current = GetEquipment(i)
					int e = 0
					while e < current.Length
						equipment = sslUtility.PushForm(current[e], equipment)
						e += 1
					endWhile
					SetEquipment(i, equipment)
					i += 1
				endWhile
			endIf

			RealignActors()
			self.GoToState("Animating")
		; No valid stages left
		else
			EndAnimation()
		endIf
	endEvent


	event OnEndState()
		; Set SFX
		sfx = new float[2]
		; Base Delay
		sfx[0] = SexLab.Config.fSFXDelay
		; Stage Delay
		if stage > 1
			sfx[0] = sfx[0] - (stage * 0.5)
		endIf
		; min 0.8 delay
		if sfx[0] < 0.8
			sfx[0] = 0.8
		endIf

		; Stage silence
		silence = anim.GetSilence(stage)

		; Set voice strength
		strength = (stage as float) / (stageCount as float)
		if stageCount == 1 && stage == 1
			strength = 0.50		
		endIf

		; Set VFX
		vfxInstance = sslUtility.IntArray(actorCount)
		vfx = sslUtility.FloatArray(actorCount * 2)
		int i = 0
		while i < actorCount
			int index = i * 2
			; Base Delay
			if pos[i].GetLeveledActorBase().GetSex() < 1
				vfx[index] = SexLab.Config.fMaleVoiceDelay + Utility.RandomFloat(-0.8,0.8)
			else
				vfx[index] = SexLab.Config.fFemaleVoiceDelay + Utility.RandomFloat(-0.8,0.8)
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
			vfx[index + 1] = Utility.RandomFloat(-0.5,0.5)
			i += 1
		endWhile
	endEvent
endState

state Animating
	event OnBeginState()
		CheckActive()

		if stage == stageCount && stageCount >= 2 && sexual && !leadIn
			SexLab._SendEventHook("OrgasmStart", tid(), hook)
			strength = 1.0
		elseIf leadIn
			SexLab._SendEventHook("LeadInStageStart", tid(), hook)
			strength = 0.01
		else
			SexLab._SendEventHook("StageStart", tid(), hook)
		endIf
	
		float stageAdvance = Utility.GetCurrentRealTime() + GetStageTimer()

		advance = false
		while !advance && animating
			CheckActive()

			int i = 0
			while i < actorCount
				; Make sure we're all still among the living
				if pos[i].IsDead() || pos[i].IsBleedingOut() || !pos[i].Is3DLoaded()
					EndAnimation(quick=true)
					return
				endIf

				; Check if they've moved.
				; float[] coords = GetCoords(pos[i])
				; float[] saved = GetLocation(i)
				; if (coords[0] - saved[0]) > 0.4 || (coords[0] - saved[0]) < -0.4 || (coords[1] - saved[1]) > 0.4 || (coords[1] - saved[1]) < -0.4 
				; 	MoveActor(i)
				; endIf

				i += 1
			endWhile

			; Delay loop
			Utility.Wait(1.0)

			; Auto Advance
			if autoAdvance && stageAdvance < Utility.GetCurrentRealTime()
				advance = true
			endIf
		endWhile

		if stage == stageCount && stageCount >= 2 && sexual && !leadIn
			SexLab._SendEventHook("OrgasmEnd", tid(), hook)
		elseIf leadIn
			SexLab._SendEventHook("LeadInStageEnd", tid(), hook)
		else
			SexLab._SendEventHook("StageEnd", tid(), hook)
		endIf

		self.GoToState("Advance")
		self.RegisterForSingleUpdate(0.01)
	endEvent

endState

state Waiting
	event OnBeginState()
		active = false
		primed = false
		leadIn = false
		autoAdvance = true
		advance = true
		sexual = false
		bed = false

		centerRef = none
		victim = none

		hook = ""

		voice = new sslBaseVoice[5]
		aliasSlot = new int[5]

		aid = -1

		timer = 0.0
		adjustingPos = 1
		actorCount = 0
		stageCount = 0
		animCount = 0
		player = -1
		stage = 0
	endEvent
	event OnUpdate()
		if active && primed
			SexLab._SendEventHook("AnimationStart", tid(), hook)
			self.GoToState("BeginLoop")
			self.RegisterForSingleUpdate(0.1)
			primed = false
		endIf
	endEvent
endState
;#---------------------------#
;#    END ANIMATION EVENT    #
;#---------------------------#