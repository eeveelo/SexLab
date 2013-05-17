scriptname sslBaseThread extends quest

; quest property sslSys auto
SexLabFramework property SexLab auto
int property tid = -1 auto hidden

; Starters
bool active
bool primed

float total
int sfx
int sfxPlaying

; Thread Variables
bool advance ; Auto Advance
int aid ; Current Animation Index for accessing it from registry 
string hook ; Custom hook for this instance
int stage ; Current animation stage
int stageCount
bool sexual ; For performing functions specific to sex, such as stripping
actor victim ; The actor position treated as a victim of aggressive/roughing/rape
ObjectReference centerRef ; The location of this animation, such as a bed, item, or actor
sslBaseAnimation anim ; Current Animation
sslBaseAnimation[] animations ; List of passed animations we can cycle through
int adjustingPos = 1
int males
int females
int[] voicePlaying
; The participants
int player = -1 ; Which position index the player is in, -1 if player not involved
actor[] pos ; Actors in event
int[] gender ; -1 unknown, 0 male, 1 female
sslBaseVoice[] voice ; Actors voice files
float[] scale ; Actors scale
int[] aliasSlot ; The index of the DoNothing alias for the actor 
bool[] silence
bool bed
float averageScale

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

; Positional actor data:
; [0]PosX [1]PosY [2]PosZ [3]RotX [4]RotY [5]RotZ
float[] centerLoc
float[] locA1
float[] locA2
float[] locA3
float[] locA4
float[] locA5

; Animation info
bool vaginal = false
bool oral = false
bool anal = false

; TODO: allow seperate
; timers per stage
; TEMP: static stage time
float[] timer

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
	advance = true
endFunction

function SetAnimation(sslBaseAnimation animation)
	if !active
		return
	endIf
	anim = animation
	stageCount = anim.StageCount()
	sfx = anim.GetSFX()
	sexual = anim.IsSexual()
	silence = anim.GetSilence()
	if player != -1
		debug.notification(anim.name)
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
	SexLab._SendEventHook("ActorChangeStart",tid,hook)
	i = 0
	; reset current actors
	while i < actorCount
		actor a = pos[i]
		ResetActor(i)
		if changeTo.Find(a) < 0
			if SexLab.PlayerRef == a
				autoAdvance = true
				if SexLab.Config.bEnableTCL
					Debug.ToggleCollisions()
				endIf
			endIf
			a.PushActorAway(a, 0.2)
		endIf
		i += 1
	endWhile
	actorCount = newCount
	pos = changeTo
	PrepareActors()
	;Restart stage
	stage -= 1
	advance = true
	PlayAnimations()
	SexLab._SendEventHook("ActorChangeEnd",tid,hook)
endFunction

actor function GetVictim()
	return victim
endFunction

actor[] function GetActors()
	return pos
endFunction

float function GetTime()
	return total
endFunction

function ResetActor(int position)
	int i = position
	actor a = pos[position]
	; Reset scale if needed
	if actorCount > 1 && SexLab.Config.bScaleActors
		a.SetScale(1.0)
	endIf
	; Enable movement
	if SexLab.PlayerRef == a
		SexLab.UnregisterForAllKeys()
		SexLab.UpdatePlayerStats(anim, total, males, females, victim)
		Game.EnablePlayerControls()
		Game.SetInChargen(false, false, false)
		Game.SetPlayerAIDriven(false)
	else
		a.SetRestrained(false)
		a.SetDontMove(false)
	endIf
	; Clear them out
	SexLab._ClearDoNothing(aliasSlot[i])
	RemoveExtras(i)
	a.ClearExpressionOverride()
	a.RemoveFromFaction(SexLab.AnimatingFaction)
	; Unstrip items
	if !a.IsDead() && !a.IsBleedingOut()
		form[] equipment = GetEquipment(i)
		SexLab.UnstripActor(a, equipment, victim)
	endIf
endFunction

;#---------------------------#
;#                           #
;#     END API FUNCTIONS     #
;#                           #
;#---------------------------#

function SpawnThread(actor[] positions, sslBaseAnimation[] animationList, actor victimPosition = none, ObjectReference centerOn = none, string customHook = "")

	if !active
		self.GoToState("Waiting")
	else
		return
	endIf

	; Lock the thread
	active = true
	; Set Primary Animation Variables
	pos = positions
	animations = animationList
	victim = victimPosition
	hook = customHook

	actorCount = positions.Length
	animCount = animationList.Length

	aid = utility.RandomInt(0, animCount - 1)

	if victim != none
		timer = SexLab.Config.fStageTimerAggr
	else
		timer = SexLab.Config.fStageTimer
	endIf

	centerLoc = GetCoords(centerOn)
	if SexLab.Data.BedsList.HasForm(centerOn.GetBaseObject())
		centerLoc[0] = centerLoc[0] + (35 * Math.sin(centerLoc[5]))
		centerLoc[1] = centerLoc[1] + (35 * Math.cos(centerLoc[5]))
		centerLoc[2] = centerLoc[2] + 35
		bed = true
	endIf

	; Find if player present
	int i = 0
	while i < actorCount
		if pos[i] == SexLab.PlayerRef
			player = i
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
	self.RegisterForSingleUpdate(0.1)
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

function MoveActor(int position)
	; (int position) should be zero indexed
	actor a = pos[position]

	float animOffset = anim.GetOffset(position)
	float[] offset = new float[3]
	offset[0] = (Math.sin(centerLoc[5]) * animOffset + Math.cos(centerLoc[5]) * anim.GetOffsetSide(position))
	offset[1] = (Math.cos(centerLoc[5]) * animOffset + Math.sin(centerLoc[5]) * anim.GetOffsetSide(position))
	offset[2] = anim.GetOffsetUp(position)

	float[] to = new float[3]
	to[0] = centerLoc[0] + offset[0]
	to[1] = centerLoc[1] + offset[1]
	to[2] = centerLoc[2] + offset[2]

	float rotation = centerLoc[5] + anim.GetRotation(position)
	if rotation >= 360
		rotation = rotation - 360
	elseIf rotation < 0
		rotation = rotation + 360
	endIf

	a.SetPosition(to[0], to[1], to[2])
	a.SetAngle(centerLoc[3], centerLoc[4], rotation)
endFunction

function PreparePosition(int position, actor a)
	int i = position
	; store information
	voice[position] = SexLab.PickVoice(a)
	gender[position] = a.GetLeveledActorBase().GetSex()
	; Stop them from doing stuff
	a.StopCombat()
	a.SetFactionRank(SexLab.AnimatingFaction, 0)
	aliasSlot[position] = SexLab._SlotDoNothing(a)
	; Disable their movement
	if SexLab.PlayerRef == a
		; toggle collisions?
		if SexLab.Config.bEnableTCL
			Debug.ToggleCollisions()
		endIf
		; Auto advance?
		if !SexLab.Config.bAutoAdvance
			autoAdvance = false
		endIf
		; Enable hotkeys, if needed
		if a == victim && SexLab.Config.bDisablePlayer
			autoAdvance = true
		else
			SexLab._EnableHotkeys(tid)
		endIf
		; Stop movement
		Game.DisablePlayerControls(true, true, true, false, true, false, false, true, 0)
		Game.SetInChargen(false, true, true)
		Game.ForceThirdPerson()
		Game.SetPlayerAIDriven()
	else
		a.SetRestrained()
		a.SetDontMove()
	endIf
	; Auto strip
	if sexual
		form[] equipment = SexLab.StripActor(a, victim)
		SetEquipment(i, equipment)
	endIf
	; Get animation extras
	EquipExtras(i)
endFunction

function PrepareActors()
	males = 0
	females = 0
	averageScale = 0.0
	int i = 0
	while i < actorCount
		PreparePosition(i, pos[i])
		MoveActor(i)
		if gender[i] < 1
			males += 1
		else
			females += 1
		endIf
		averageScale = averageScale + pos[i].GetScale()
		i += 1
	endWhile
	averageScale = averageScale / actorCount
	; Scale them to average size, if enabled
	if actorCount > 1 && SexLab.Config.bScaleActors
		i = 0
		while i < actorCount
			pos[i].SetScale((averageScale / pos[i].GetScale()))
			i += 1
		endWhile
	endIf
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
	if SexLab.Config.bUseStrapons && anim.UseStrapon(position) && anim.GetGender(position) == 0 && gender[position] == 1
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

function PlayAnimations()
	pos[0].PlayIdle(anim.Fetch(0, stage))
	if actorCount >= 2
		pos[1].PlayIdle(anim.Fetch(1, stage))
	endIf
	if actorCount >= 3
		pos[2].PlayIdle(anim.Fetch(2, stage))
	endIf
	if actorCount >= 4
		pos[3].PlayIdle(anim.Fetch(3, stage))
	endIf
	if actorCount >= 5
		pos[4].PlayIdle(anim.Fetch(4, stage))
	endIf
endFunction

function PlaySFX()
	if sfxPlaying > 0
		Sound.StopInstance(sfxPlaying)
	endIf
	if sfx < 1 ; Silent
		return
	elseIf sfx == 1 ; Squishing
		sfxPlaying = SexLab.Data.sfxSquishing01.Play(pos[0])
	elseIf sfx == 2 ; Sucking
		sfxPlaying = SexLab.Data.sfxSucking01.Play(pos[0])
	elseIf sfx == 3 ; SexMix
		int r = utility.RandomInt(0,1)
		if r == 0
			sfxPlaying = SexLab.Data.sfxSquishing01.Play(pos[0])
		else
			sfxPlaying = SexLab.Data.sfxSucking01.Play(pos[0])
		endIf
	endIf
	Sound.SetInstanceVolume(sfxPlaying, SexLab.Config.fSFXVolume)
endFunction

function PlayVoice(int pid, float strength)
	if voicePlaying[pid] > 0
		Sound.StopInstance(voicePlaying[pid])
	endIf
	voicePlaying[pid] = voice[pid].Moan(pos[pid], strength, victim)
	Sound.SetInstanceVolume(voicePlaying[pid], SexLab.Config.fVoiceVolume)
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
	SexLab._SendEventHook("AnimationEnd",tid,hook)

	int i = 0
	; Apply cum
	if !quick && sexual
		while i < actorCount
			if SexLab.Config.bUseCum && anim.GetCum(i) > 0 && gender[i] == anim.female
				if males > 0
					PlayVoice(i, 1.0)
					SexLab.ApplyCum(pos[i],anim.GetCum(i))
				elseIf SexLab.Config.bAllowFFCum && females > 1
					PlayVoice(i, 1.0)
					SexLab.ApplyCum(pos[i],anim.GetCum(i))
				endIf
			endIf
			i += 1
		endWhile
	endIf

	i = 0
	while i < actorCount
		actor a = pos[i]
		; Reset actor
		SexLab._ClearDoNothing(aliasSlot[i])
		RemoveExtras(i)
		a.RemoveFromFaction(SexLab.AnimatingFaction)
		a.ClearExpressionOverride()

		; Reset scale
		if actorCount > 1 && SexLab.Config.bScaleActors
			a.SetScale(1.0)
		endIf

		; Enable movement
		if SexLab.PlayerRef == a
			SexLab.UnregisterForAllKeys()
			SexLab.UpdatePlayerStats(anim, total, males, females, victim)
			Game.EnablePlayerControls()
			Game.SetInChargen(false, false, false)
			Game.SetPlayerAIDriven(false)
			if SexLab.Config.bEnableTCL
				Debug.ToggleCollisions()
			endIf
		else
			a.SetRestrained(false)
			a.SetDontMove(false)
		endIf
		i += 1
	endWhile

	; Reset Idle
	i = 0
	while i < actorCount
		actor a = pos[i]
		a.PushActorAway(a, 0.1)
		i += 1
	endWhile

	; Wait a couple seconds for them to get up
	if !quick
		utility.Wait(3.0)
	endIf

	; Requip them
	i = 0
	while i < actorCount
		actor a = pos[i]
		if !a.IsDead() && !a.IsBleedingOut()
			form[] equipment = GetEquipment(i)
			SexLab.UnstripActor(a, equipment, victim)
		endIf
		i += 1
	endWhile


	SexLab._EndThread(tid, player)
	self.GoToState("Waiting")
endFunction

function AdvanceStage(bool backwards = false)	
	if backwards && stage == 1
		return
	elseIf backwards
		stage -= 2 ; Account for stage increase on advance
		advance = true
	else
		advance = true
	endIf
endFunction

function ChangeAnimation(bool backwards = false)

	if animCount == 1
		return ; Single animation selected, nothing to change to
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
		SexLab.StripActor(pos[i], victim)
		RemoveExtras(i)
		EquipExtras(i)
		i += 1
	endWhile

	stage -= 1
	if stageCount <= stage
		stage = stageCount - 2
		if stage < 0
			stage = 0
		endIf
	endIf

	RealignActors()

	; Restart the stage with new animation
	advance = true

	SexLab._SendEventHook("AnimationChange",tid,hook)
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
	; Swap Gender
	int adjustedGender = gender[adjustingPos]
	int replacedGender = gender[newPos]
	gender[newPos] = adjustedGender
	gender[adjustingPos] = replacedGender
	; Swap Alias
	int adjustedAlias = aliasSlot[adjustingPos]
	int replacedAlias = aliasSlot[newPos]
	aliasSlot[newPos] = replacedAlias
	aliasSlot[adjustingPos] = adjustedAlias
	; Swap Scales
	float adjustedScale = scale[adjustingPos]
	float replacedScale = scale[newPos]
	scale[newPos] = adjustedScale
	scale[adjustingPos] = replacedScale
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
	SexLab._SendEventHook("PositionChange",tid,hook)
endFunction

function AdjustForward(bool backwards = false)
	float adjustment
	if backwards
		adjustment = -0.5
	else
		adjustment = 0.5
	endIf
	anim.UpdateOffset(adjustingPos, adjustment)
	pos[adjustingPos].MoveTo(pos[adjustingPos], Math.sin(centerLoc[5]) * adjustment, Math.cos(centerLoc[5]) * adjustment, 0.0, true)
endFunction

function AdjustSideways(bool backwards = false)
	float adjustment
	if backwards
		adjustment = -0.5
	else
		adjustment = 0.5
	endIf
	anim.UpdateOffsetSide(adjustingPos, adjustment)
	pos[adjustingPos].MoveTo(pos[adjustingPos], Math.cos(centerLoc[5]) * adjustment, Math.sin(centerLoc[5]) * adjustment, 0.0, true)
endFunction

function AdjustUpward(bool backwards = false)
	float adjustment
	if backwards
		adjustment = -1.0
	else
		adjustment = 1.0
	endIf
	anim.UpdateOffsetUp(adjustingPos, adjustment)
	float[] coords = GetCoords(pos[adjustingPos])
	;MoveActor(adjustingPos)
	pos[adjustingPos].MoveTo(pos[adjustingPos], 0, 0, adjustment, true)
endFunction

function AdjustChange(bool backwards = false)
	adjustingPos += 1
	if adjustingPos >= actorCount
		adjustingPos = 0
	endIf
	SexLab.Data.mAdjustChange.Show(adjustingPos + 1)
endFunction

function RealignActors()
	PlayAnimations()
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

function CheckActive()
	if !active
		self.GoToState("Waiting")
	endIf
endFunction
;#---------------------------#
;#  ANIMATION PROCESS EVENT  #
;#---------------------------#
state Animating
	event OnBeginState()

		CheckActive()

		int i
		bool orgasm

		if stage == stageCount && stageCount >= 2 && sexual
			SexLab._SendEventHook("OrgasmStart",tid,hook)
			if player >= 0
				autoAdvance = true
				SexLab.UnregisterForAllKeys()
			endIf
			orgasm = true
		else
			SexLab._SendEventHook("StageStart",tid,hook)
			orgasm = false
		endIf
		
		; Set the stage
		float sfxDelay = SexLab.Config.fSFXDelay - (stage * 0.75)  
		if sfxDelay < 0.8 || orgasm
			sfxDelay = 0.8
		endIf
		float sfxCheck = 0.0
		float sfxLast = 0.0

		; Moan strength
		float strength = (stage as float) / (stageCount as float)
		if stageCount == 1 && stage == 1
			strength = 0.50
		elseIf orgasm
			strength = 1.0
		endIf

		float[] voiceLast = new float[5]
		float[] voiceDelay = new float[5]
		i = 0
		while i < actorCount
			if gender[i] < 1
				voiceDelay[i] = SexLab.Config.fMaleVoiceDelay - (stage * 0.8) + Utility.RandomFloat(-0.8,0.8)
			else
				voiceDelay[i] = SexLab.Config.fFemaleVoiceDelay - (stage * 0.8) + Utility.RandomFloat(-0.8,0.8)
			endIf

			if voiceDelay[i] < 1.5 || orgasm
				voiceDelay[i] = 1.5
			endIf

			voiceLast[i] = Utility.RandomFloat(-0.8,1.5)
			i += 1
		endWhile 

		; Hold actors here for alloted time
		float stageTimer

		if stage == stageCount
			stageTimer = timer[4]
		elseif stage < 4
			stageTimer = timer[stage - 1]
		else
			stageTimer = timer[3]
		endIf

		; Play idles
		PlayAnimations()

		float stageStart = Utility.GetCurrentRealTime()
		float progress = 0.0
		advance = false
		while !advance

			i = 0
			while i < actorCount

				; Make sure we're all still among the living
				if pos[i].IsDead() || pos[i].IsBleedingOut()
					EndAnimation(quick=true) 
					return
				endIf

				; Play Voice
				if voice[i] != none && (progress - voiceLast[i]) > voiceDelay[i] && !silence[i]
					PlayVoice(i, strength)
					voiceLast[i] = progress
				endIf

				i += 1
			endWhile

			; Play SFX
			sfxCheck = progress - sfxLast
			if sfxCheck > sfxDelay || progress == 0.0
				PlaySFX()
				sfxLast = progress
			endIf

			; Check Advance
			progress = Utility.GetCurrentRealTime() - stageStart
			if (autoAdvance && progress >= stageTimer) || !active
				advance = true
			else
				Utility.Wait(0.2)
			endIf
		endWhile

		total = total + progress

		CheckActive()

		; Stage End hook
		if orgasm
			SexLab._SendEventHook("OrgasmEnd",tid,hook)
		else
			SexLab._SendEventHook("StageEnd",tid,hook)
		endIf

		; Move on
		self.GoToState("SetStage")
	endEvent
endState

state SetStage
	event OnBeginState()

		CheckActive()

		; Increase stage
		stage += 1
		; Make sure stage exists first
		if stage <= stageCount
			self.GoToState("Animating")
		; If it doesn't skip straight to end
		else
			EndAnimation()
		endIf

	endEvent
endState

state Waiting
	event OnBeginState()
		active = false
		primed = false
		aid = -1
		males = 0
		females = 0
		gender = new int[5]
		voice = new sslBaseVoice[5]
		voicePlaying = new int[5]
		scale = new float[5]
		aliasSlot = new int[5]
		averageScale = 0.0
		sfxPlaying = 0
		hook = ""
		total = 0.0
		adjustingPos = 1
		autoAdvance = true
		actorCount = 0
		stageCount = 0
		animCount = 0
		advance = true
		player = -1
		stage = 0
		sexual = false
		victim = none
		centerRef = none
		bed = false
	endEvent
	event OnUpdate()
		if active && primed
			SexLab._SendEventHook("AnimationStart",tid,hook)
			self.GoToState("SetStage")
			primed = false
		endIf
	endEvent
endState
;#---------------------------#
;#    END ANIMATION EVENT    #
;#---------------------------#