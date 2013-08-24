scriptname sslActorAlias extends ReferenceAlias

SexLabFramework property SexLab auto
sslSystemResources property Data auto
sslSystemConfig property Config auto

bool Active
actor ActorRef
sslThreadController Controller

; Actor Information
sslBaseVoice property Voice auto hidden
float VoiceDelay
float VoiceStrength
bool IsSilent

int VoiceInstance

bool IsPlayer
bool IsVictim
bool IsScaled

float Scale

sslBaseAnimation Animation
int position
int stage

form[] EquipmentStorage

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
		if Config.bDisablePlayer && IsVictim
			Controller.autoAdvance = true
		else
			SexLab._EnableHotkeys(Controller.tid)
		endIf
		; Toggle TCL if enabled and player present
		if Config.bEnableTCL
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
	ActorRef.SetFactionRank(SexLab.AnimatingFaction, 1)
	TryToEvaluatePackage()
	; Sexual animations only
	if Controller.Animation.IsSexual()
		; Strip Actor
		form[] equipment = SexLab.StripSlots(ActorRef, Controller.GetStrip(ActorRef), true)
		StoreEquipment(equipment)
		; Make Erect
		if SexLab.sosEnabled && Controller.Animation.GetGender(Controller.GetPosition(ActorRef)) < 1
			Debug.SendAnimationEvent(ActorRef, "SOSFastErect")
		endIf
	endIf
	; Scale actor is enabled
	if Controller.ActorCount > 1 && Config.bScaleActors
		IsScaled = true

		float display = ActorRef.GetScale()
		ActorRef.SetScale(1.0)
		float base = ActorRef.GetScale()
		
		Scale = ( display / base )
		ActorRef.SetScale(Scale)
		ActorRef.SetScale(1.0 / base)
	endIf
	; Set into aniamtion ready state
	GoToState("Ready")
endFunction

function ResetActor()
	UnregisterForUpdate()
	GoToState("")
	; Reset to starting scale
	if IsScaled
		ActorRef.SetScale(Scale)
	endIf
	; Remove from animation faction
	ActorRef.RemoveFromFaction(SexLab.AnimatingFaction)
	RemoveExtras()
	; Reset openmouth
	ActorRef.ClearExpressionOverride()
	; Enable movement
	if IsPlayer
		if Config.bEnableTCL
			Debug.ToggleCollisions()
		endIf
		SexLab._DisableHotkeys()
		;Game.ForceThirdPerson()
		;Game.SetInChargen(false, false, false)
		Game.SetPlayerAIDriven(false)
		;Game.EnablePlayerControls()
		SexLab.UpdatePlayerStats(Controller.Animation, Controller.GetTime(), Controller.Positions, Controller.GetVictim())
	else
		ActorRef.SetAnimationVariableBool("bHumanoidFootIKEnable", true)
		ActorRef.SetDontMove(false)
		ActorRef.SetRestrained(false)
	endIf
	
	; Make flaccid
	if SexLab.sosEnabled && Controller.Animation.GetGender(Controller.GetPosition(ActorRef)) < 1
		Debug.SendAnimationEvent(ActorRef, "SOSFlaccid")
	endIf
	; Unstrip
	if !ActorRef.IsDead() && !ActorRef.IsBleedingOut()
		SexLab.UnstripActor(ActorRef, EquipmentStorage, Controller.GetVictim())
	endIf
endFunction

function PlayAnimation()
	; Play Idle
	Debug.SendAnimationEvent(ActorRef, Animation.FetchPositionStage(position, stage))
	; Open Mouth
	ActorRef.ClearExpressionOverride()
	if Animation.UseOpenMouth(position, stage)
		ActorRef.SetExpressionOverride(16, 100)
	endIf
	; Send SOS event
	if SexLab.sosEnabled && Animation.GetGender(position) < 1
		Debug.SendAnimationEvent(ActorRef, "SOSBend"+Animation.GetSchlong(position, stage))
	endif
endfunction

function StopAnimating(bool quick = false)
	; Reset Idle
	if quick || Game.GetCameraState() == 3
		Debug.SendAnimationEvent(ActorRef, "IdleForceDefaultState")
	else
		ActorRef.PushActorAway(ActorRef, 1)
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
	if Animation.GetGender(position) == 0 && Config.bUseStrapons && Animation.UseStrapon(position, stage)
		SexLab.EquipStrapon(ActorRef)
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
	SexLab.UnequipStrapon(ActorRef)
endFunction

function SetAlias(sslThreadController ThreadView)
	if GetReference() != none
		_Init()
		TryToStopCombat()
		ActorRef = GetReference() as actor
		Controller = ThreadView
		IsPlayer = ActorRef == SexLab.PlayerRef
		IsVictim = ActorRef == ThreadView.GetVictim()
	endIf
endFunction

function ClearAlias()
	if GetReference() != none
		Debug.Trace("SexLab: Clearing Actor Slot '"+GetName()+"'' of "+ActorRef)
		TryToClear()
		TryToReset()
		ActorRef.EvaluatePackage()
		_Init()
	endIf
endFunction

;/-----------------------------------------------\;
;|	Storage Functions                             |;
;\-----------------------------------------------/;

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

function ThreadAnimation(sslBaseAnimation toAnimation)
	if !Active || ActorRef == none
		return
	endIf

	RemoveExtras()

	Animation = toAnimation

	EquipExtras()

	if IsPlayer
		Debug.Notification(Animation.name)
	endIf
endFunction

function ThreadPosition(int toPosition)
	if !Active || ActorRef == none
		return
	endIf
	position = toPosition
endFunction

function ThreadStage(int toStage)
	if !Active || ActorRef == none
		return
	endIf

	stage = toStage

	; Update Silence
	IsSilent = Animation.IsSilent(position, stage)

	if !IsSilent
		; Update Strength
		VoiceStrength = (stage as float) / (Animation.StageCount() as float)
		if Animation.StageCount() == 1 && stage == 1
			VoiceStrength = 0.50
		endIf
		; Base Delay
		if SexLab.GetGender(ActorRef) < 1
			VoiceDelay = Config.fMaleVoiceDelay
		else
			VoiceDelay = Config.fFemaleVoiceDelay
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
		ThreadAnimation(Controller.Animation)
		ThreadPosition(Controller.Positions.Find(ActorRef))
		ThreadStage(Controller.Stage)
		GoToState("Animating")
		RegisterForSingleUpdate(Utility.RandomFloat(0.0, 0.8))
	endFunction
endState

state Animating
	event OnUpdate()
		if !Active || ActorRef == none
			return
		endIf

		if ActorRef.IsDead() || ActorRef.IsBleedingOut() || !ActorRef.Is3DLoaded()
			Controller.EndAnimation(true)
			return
		endIf

		if !IsSilent
			if VoiceInstance > 0
				Sound.StopInstance(VoiceInstance)
			endIf
			VoiceInstance = Voice.Moan(ActorRef, VoiceStrength, IsVictim)
			Sound.SetInstanceVolume(VoiceInstance, Config.fVoiceVolume)
		endIf

		RegisterForSingleUpdate(VoiceDelay)
	endEvent
endState

;/-----------------------------------------------\;
;|	Actor Callbacks                              |;
;\-----------------------------------------------/;

function ActorEvent(string callback)
	;Debug.TraceAndBox("Sending Event "+callback+": "+ActorRef)
	RegisterForModEvent(callback, "On"+callback)
	SendModEvent(callback)
	UnregisterForModEvent("On"+callback)
endFunction

event OnStartThread(string eventName, string actorSlot, float argNum, form sender)
	;Debug.TraceAndBox("OnStartThread: "+ActorRef)
	PrepareActor()
endEvent

event OnEndThread(string eventName, string actorSlot, float argNum, form sender)
	ResetActor()
	StopAnimating(!Config.bRagDollEnd)
	Utility.Wait(3.0)
	ClearAlias()
endEvent

event OnQuickEndThread(string eventName, string actorSlot, float argNum, form sender)
	ResetActor()
	StopAnimating(true)
	Utility.Wait(3.0)
	ClearAlias()
endEvent

;/-----------------------------------------------\;
;|	Misc Functions                               |;
;\-----------------------------------------------/;

function _Init()
	ActorRef = none
	Controller = none
	Voice = none
	Animation = none
	IsScaled = false
	form[] formDel
	EquipmentStorage = formDel
endFunction

event OnPackageStart(package newPackage)
	Debug.Trace(GetName()+" evaluated "+GetActorRef()+"'s package to "+newPackage)
endEvent

function StartAnimating()
	Debug.TraceAndbox("Null start: "+ActorRef)
endFunction