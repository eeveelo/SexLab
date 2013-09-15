scriptname sslActorAlias extends ReferenceAlias

sslActorLibrary property Lib auto

actor ActorRef
bool Active
sslThreadController Controller
sslBaseVoice Voice

; Voice
float VoiceDelay
float VoiceStrength
bool IsSilent
int VoiceInstance

; Info
bool IsPlayer
bool IsVictim
bool IsFemale

; Storage
sslBaseAnimation Animation
int position
int stage
form[] EquipmentStorage
bool[] StripOverride
bool disableUndress
bool disableRagdoll
form strapon
float scale


;/-----------------------------------------------\;
;|	Alias Functions                              |;
;\-----------------------------------------------/;

function SetAlias(sslThreadController ThreadView)
	if GetReference() != none
		_Init()
		TryToStopCombat()
		ActorRef = GetReference() as actor
		Controller = ThreadView
		IsPlayer = ActorRef == Lib.PlayerRef
		IsVictim = ActorRef == ThreadView.GetVictim()
		IsFemale = Lib.GetGender(ActorRef) == 1
	endIf
endFunction

function ClearAlias()
	if GetReference() != none
		Debug.Trace("SexLab: Clearing Actor Slot of "+ActorRef)
		TryToClear()
		TryToReset()
		ActorRef.EvaluatePackage()
		_Init()
	endIf
endFunction

;/-----------------------------------------------\;
;|	Preparation Functions                        |;
;\-----------------------------------------------/;

function PrepareActor()

	if IsPlayer
		Game.ForceThirdPerson()
		;Game.DisablePlayerControls(true, true, false, false, true, false, false, true, 0)
		;Game.SetInChargen(false, true, true)
		Game.SetPlayerAIDriven()
		; Enable hotkeys, if needed
		if Lib.bDisablePlayer && IsVictim
			Controller.autoAdvance = true
		else
			Lib._HKStart(Controller)
		endIf
		; Toggle TCL if enabled and player present
		if Lib.bEnableTCL
			Debug.ToggleCollisions()
		endIf
	else
		ActorRef.SetRestrained()
		ActorRef.SetDontMove()
		ActorRef.SetAnimationVariableBool("bHumanoidFootIKDisable", true)
	endIf
	if ActorRef.IsWeaponDrawn()
		ActorRef.SheatheWeapon()
	endIf
	; Start DoNothing package
	ActorRef.SetFactionRank(Lib.AnimatingFaction, 1)
	TryToEvaluatePackage()
	; Sexual animations only
	if Controller.Animation.IsSexual()
		; Strip Actor
		Strip()
	endIf
	; Scale actor is enabled
	if Controller.ActorCount > 1 && Lib.bScaleActors
		float display = ActorRef.GetScale()
		ActorRef.SetScale(1.0)
		float base = ActorRef.GetScale()
		
		scale = ( display / base )
		ActorRef.SetScale(scale)
		ActorRef.SetScale(1.0 / base)
	endIf
	; Set into aniamtion ready state
	GoToState("Ready")
endFunction

function ResetActor()
	UnregisterForUpdate()
	GoToState("")
	; Reset to starting scale
	if scale > 0.0
		ActorRef.SetScale(scale)
	endIf
	; Remove from animation faction
	ActorRef.RemoveFromFaction(Lib.AnimatingFaction)
	RemoveExtras()
	; Reset openmouth
	ActorRef.SetExpressionOverride(7, 50)
	ActorRef.ClearExpressionOverride()
	; Enable movement
	if IsPlayer
		if Lib.bEnableTCL
			Debug.ToggleCollisions()
		endIf
		Lib._HKClear()
		;Game.ForceThirdPerson()
		;Game.SetInChargen(false, false, false)
		Game.SetPlayerAIDriven(false)
		;Game.EnablePlayerControls()
		int[] genders = Lib.GenderCount(Controller.Positions)
		Lib.Stats.UpdatePlayerStats(genders[0], genders[1], Controller.Animation, Controller.GetVictim(), Controller.GetTime())
	else
		ActorRef.SetAnimationVariableBool("bHumanoidFootIKEnable", true)
		ActorRef.SetDontMove(false)
		ActorRef.SetRestrained(false)
	endIf
	; Make flaccid for SOS
	Debug.SendAnimationEvent(ActorRef, "SOSFlaccid")
	; Unstrip
	if !ActorRef.IsDead() && !ActorRef.IsBleedingOut()
		Lib.UnstripActor(ActorRef, EquipmentStorage, Controller.GetVictim())
	endIf
endFunction

function EquipExtras()
	if Animation == none
		return
	endIf
	
	form[] extras = Animation.GetExtras(position)
	if extras.Length > 0
		int i
		while i < extras.Length
			if extras[i] != none
				ActorRef.EquipItem(extras[i], false, true)
			endIf
			i += 1
		endWhile
	endIf
	; Strapons are enabled for this position, and they are female in a male position
	if Animation.GetGender(position) == 0 && Lib.bUseStrapons && Animation.UseStrapon(position, stage)
		Lib.EquipStrapon(ActorRef)
	endIf
endFunction

function RemoveExtras()
	if Animation == none
		return
	endIf

	form[] extras = Animation.GetExtras(position)
	if extras.Length > 0
		int i
		while i < extras.Length
			if extras[i] != none
				ActorRef.UnequipItem(extras[i], false, true)
				ActorRef.RemoveItem(extras[i], 1, true)
			endIf
			i += 1
		endWhile
	endIf
	; Strapons are enabled for this position, and they are female in a male position
	Lib.UnequipStrapon(ActorRef)
endFunction

;/-----------------------------------------------\;
;|	Manipulation Functions                       |;
;\-----------------------------------------------/;

function PlayAnimation()
	; Play Idle
	Debug.SendAnimationEvent(ActorRef, Animation.FetchPositionStage(position, stage))
	; Open Mouth
	if Animation.UseOpenMouth(position, stage)
		ActorRef.SetExpressionOverride(16, 100)
	else
		ActorRef.SetExpressionOverride(7, 50)
		ActorRef.ClearExpressionOverride()
	endIf
	; Send SOS event
	if Lib.SOSEnabled && Animation.GetGender(position) == 0
		Debug.SendAnimationEvent(ActorRef, "SOSFastErect")
		int offset = Animation.GetSchlong(position, stage)
		string bend
		if offset < 0
			bend = "SOSBendDown0"+((Math.Abs(offset) / 2) as int)
		elseif offset > 0
			bend = "SOSBendUp0"+((Math.Abs(offset) / 2) as int)
		else
			bend = "SOSNoBend"
		endIf
		Debug.SendAnimationEvent(ActorRef, bend)
		Debug.SendAnimationEvent(ActorRef, "SOSBend"+offset)
	endif
endfunction

function StopAnimating(bool quick = false)
	if !quick && Animation.IsSexual && Lib.bUseCum
		int[] genders = Lib.GenderCount(Controller.Positions)
		if genders[0] > 0 || (genders[0] == 0 && genders[1] > 1 && Lib.bAllowFFCum)
			Lib.ApplyCum(ActorRef, Animation.GetCum(position))
		endIf
	endIf
	; Reset Idle
	if quick || Game.GetCameraState() == 3 || !DoRagdollEnd()
		Debug.SendAnimationEvent(ActorRef, "IdleForceDefaultState")
	else
		ActorRef.PushActorAway(ActorRef, 1)
	endIf
endFunction

function AlignTo(float[] center)
	float[] offsets = Animation.GetPositionOffsets(position, stage)
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
	; Set Coords
	ActorRef.SetPosition(loc[0], loc[1], loc[2])
	ActorRef.SetAngle(loc[3], loc[4], loc[5])
endFunction

function Strip(bool animate = true)
	bool[] strip
	; Get Strip settings or override
	if StripOverride.Length != 33
		strip = Lib.GetStrip(ActorRef, Controller.GetVictim(), Controller.LeadIn)
	else
		strip = StripOverride
	endIf
	; No animation override, get thread/user setting
	if animate 
		animate = DoUndressAnim()
	endIf
	; Strip slots and store removed equipment
	form[] equipment = Lib.StripSlots(ActorRef, strip, animate)
	StoreEquipment(equipment)
endFunction

;/-----------------------------------------------\;
;|	Storage Functions                            |;
;\-----------------------------------------------/;

function DisableRagdollEnd(bool disableIt = true)
	disableragdoll = disableIt
endFunction
bool function DoRagdollEnd()
	if disableundress
		return false
	endif
	return Lib.bRagDollEnd
endFunction

function DisableUndressAnim(bool disableIt = true)
	disableundress = disableIt
endFunction
bool function DoUndressAnim()
	if disableundress
		return false
	endif
	return Lib.bUndressAnimation
endFunction

function StoreEquipment(form[] equipment)
	if equipment.Length < 1
		return
	endIf
	; Addon existing storage
	int i
	while i < EquipmentStorage.Length
		equipment = sslUtility.PushForm(EquipmentStorage[i], equipment)
		i += 1
	endWhile
	; Save new storage
	EquipmentStorage = equipment
endFunction

function SyncThread(int toPosition)
	if !Active || ActorRef == none
		return
	endIf
	; Update Position
	position = toPosition
	; Current stage + animation
	int toStage = Controller.Stage
	sslBaseAnimation toAnimation = Controller.Animation
	; Update Stage
	if stage != toStage
		; Set Stage
		stage = toStage
		; Update Silence
		IsSilent = toAnimation.IsSilent(position, stage)
		if IsSilent
			; VoiceDelay is used as loop timer, must be set even if silent.
			VoiceDelay = 4.0
		else
			; Update Strength
			VoiceStrength = (stage as float) / (toAnimation.StageCount() as float)
			if toAnimation.StageCount() == 1 && stage == 1
				VoiceStrength = 0.50
			endIf
			; Base Delay
			if Lib.GetGender(ActorRef) < 1
				VoiceDelay = Lib.fMaleVoiceDelay
			else
				VoiceDelay = Lib.fFemaleVoiceDelay
			endIf
			; Stage Delay
			if stage > 1
				VoiceDelay = (VoiceDelay - (stage * 0.8)) + Utility.RandomFloat(-0.3, 0.3)
			endIf
			; Min 1.3 delay
			if VoiceDelay < 1.3
				VoiceDelay = 1.3
			endIf
		endIf
	endIf
	; Update Animation
	if Animation != toAnimation
		RemoveExtras()
		Animation = toAnimation
		EquipExtras()
	endIf
endFunction

function OverrideStrip(bool[] setStrip)
	if setStrip.Length != 33
		return
	endIf
	StripOverride = setStrip
endFunction
function SetVoice(sslBaseVoice toVoice)
	Voice = toVoice
endFunction
sslBaseVoice function GetVoice()
	return Voice
endFunction

;/-----------------------------------------------\;
;|	Animation/Voice Loop                         |;
;\-----------------------------------------------/;

state Ready
	event OnBeginState()
		UnregisterForUpdate()
	endEvent
	function StartAnimating()
		Active = true
		SyncThread(Controller.GetPosition(ActorRef))
		GoToState("Animating")
		RegisterForSingleUpdate(Utility.RandomFloat(0.0, 0.8))
	endFunction
endState

state Animating
	event OnUpdate()
		if ActorRef.IsDead() || ActorRef.IsBleedingOut() || !ActorRef.Is3DLoaded()
			Controller.EndAnimation(true)
			return
		endIf

		if !IsSilent
			if VoiceInstance > 0
				Sound.StopInstance(VoiceInstance)
			endIf
			VoiceInstance = Voice.Moan(ActorRef, VoiceStrength, IsVictim)
			Sound.SetInstanceVolume(VoiceInstance, Lib.fVoiceVolume)
		endIf

		RegisterForSingleUpdate(VoiceDelay)
	endEvent
endState

;/-----------------------------------------------\;
;|	Actor Callbacks                              |;
;\-----------------------------------------------/;

; TODO check mod events for eventname or callback
event OnStartThread(string eventName, string actorSlot, float argNum, form sender)
	UnregisterForModEvent("OnStartThread")
	PrepareActor()
endEvent

event OnEndThread(string eventName, string actorSlot, float quick, form sender)
	UnregisterForModEvent("OnEndThread")
	ResetActor()
	StopAnimating((quick as bool))
	ClearAlias()
endEvent

;/-----------------------------------------------\;
;|	Misc Functions                               |;
;\-----------------------------------------------/;

function _Init()
	UnregisterForAllModEvents()
	ActorRef = none
	Active = false
	Controller = none
	Voice = none
	Animation = none
	strapon = none
	scale = 0.0
	form[] formDel
	EquipmentStorage = formDel
	bool[] boolDel
	StripOverride = boolDel
endFunction

function StartAnimating()
	Debug.TraceAndbox("Null start: "+ActorRef)
endFunction