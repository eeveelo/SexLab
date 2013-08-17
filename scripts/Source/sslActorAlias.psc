scriptname sslActorAlias extends ReferenceAlias

SexLabFramework property SexLab auto
sslSystemResources property Data auto
sslSystemConfig property Config auto


actor Position
sslThreadController Controller

; Actor Information
sslBaseVoice property Voice auto hidden

bool IsPlayer
bool IsVictim
bool IsScaled

float Scale

form[] EquipmentStorage

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
		if SexLab.Config.bEnableTCL
			Debug.ToggleCollisions()
		endIf
	else
		Position.SetRestrained()
		Position.SetDontMove()
		Position.SetAnimationVariableBool("bHumanoidFootIKDisable", true)
	endIf
	if Position.IsWeaponDrawn()
		Position.SheatheWeapon()
	endIf
	; Start DoNothing package
	Position.SetFactionRank(SexLab.AnimatingFaction, 1)
	TryToEvaluatePackage()
	; Sexual animations only
	if Controller.Animation.IsSexual()
		; Strip Actor
		form[] equipment = SexLab.StripSlots(position, Controller.GetStrip(Position), true)
		StoreEquipment(equipment)
		; Make Erect
		if SexLab.sosEnabled && Controller.Animation.GetGender(Controller.GetPosition(Position)) < 1
			Debug.SendAnimationEvent(Position, "SOSFastErect")
		endIf
	endIf
	; Scale actor is enabled
	if Controller.ActorCount > 1 && Config.bScaleActors
		IsScaled = true

		float display = Position.GetScale()
		Position.SetScale(1.0)
		float base = Position.GetScale()
		
		Scale = ( display / base )
		Position.SetScale(Scale)
		Position.SetScale(1.0 / base)
	endIf
endFunction

function ResetActor()
	; Reset to starting scale
	if IsScaled
		Position.SetScale(Scale)
	endIf
	; Reset openmouth
	Position.ClearExpressionOverride()
	; Enable movement
	if IsPlayer
		if Config.bEnableTCL
			Debug.ToggleCollisions()
		endIf
		SexLab._DisableHotkeys()
		;Game.SetInChargen(false, false, false)
		Game.SetPlayerAIDriven(false)
		;Game.EnablePlayerControls()
		SexLab.UpdatePlayerStats(Controller.Animation, Controller.GetTime(), Controller.Positions, Controller.GetVictim())
	else
		Position.SetAnimationVariableBool("bHumanoidFootIKEnable", true)
		Position.SetDontMove(false)
		Position.SetRestrained(false)
	endIf
	; Make flaccid
	if SexLab.sosEnabled && Controller.Animation.GetGender(Controller.GetPosition(Position)) < 1
		Debug.SendAnimationEvent(Position, "SOSFlaccid")
	endIf
	; Unstrip
	if !Position.IsDead() && !Position.IsBleedingOut()
		SexLab.UnstripActor(Position, EquipmentStorage, Controller.GetVictim())
	endIf
	; Reset Idle
	if !Config.bRagdollEnd
		Debug.SendAnimationEvent(Position, "IdleForceDefaultState")
	else
		Position.PushActorAway(Position, 1)
	endIf
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

function SetAlias(sslThreadController ThreadView)
	_Init()

	TryToStopCombat()

	Position = GetReference() as actor
	Controller = ThreadView
	IsPlayer = Position == SexLab.PlayerRef
	IsVictim = Position == ThreadView.GetVictim()
endFunction

function _Init()
	Position = none
	Controller = none
	Voice = none

	IsScaled = false

	form[] formDel
	EquipmentStorage = formDel
endFunction

event OnPackageStart(package newPackage)
	Debug.Trace("Evaluated "+GetActorRef().GetName()+"'s package to "+newPackage.GetName())
endEvent