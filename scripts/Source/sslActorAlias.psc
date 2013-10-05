scriptname sslActorAlias extends ReferenceAlias

sslActorLibrary property Lib auto

actor property ActorRef auto hidden

ObjectReference MarkerObj
ObjectReference property MarkerRef hidden
	ObjectReference function get()
		if MarkerObj == none && ActorRef != none
			MarkerObj = ActorRef.PlaceAtMe(Lib.BaseMarker)
		endIf
		return MarkerObj
	endFunction
endProperty

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
bool IsCreature

; Storage
sslBaseAnimation Animation
int position
int stage
form[] EquipmentStorage
bool[] StripOverride
form strapon
float scale
float[] loc

; Switches
bool disableRagdoll
bool property DoRagdoll hidden
	bool function get()
		if disableRagdoll
			return false
		endIf
		return Lib.bRagDollEnd
	endFunction
endProperty

bool disableundress
bool property DoUndress hidden
	bool function get()
		if disableundress
			return false
		endIf
		return Lib.bUndressAnimation
	endFunction
	function set(bool value)
		disableundress = !value
	endFunction
endProperty

;/-----------------------------------------------\;
;|	Alias Functions                              |;
;\-----------------------------------------------/;

function SetAlias(sslThreadController ThreadView)
	if GetReference() != none
		Initialize()
		TryToStopCombat()
		Controller = ThreadView
		ActorRef = GetReference() as actor
		int gender = Lib.GetGender(ActorRef)
		IsFemale = gender == 1
		IsCreature = gender == 2
		IsPlayer = ActorRef == Lib.PlayerRef
		IsVictim = ActorRef == ThreadView.GetVictim()
	endIf
endFunction

function ClearAlias()
	if GetReference() != none
		TryToClear()
		TryToReset()
		Debug.Trace("SexLab: Clearing Actor Slot of "+ActorRef.GetLeveledActorBase().GetName())
		ActorRef.EvaluatePackage()
		Initialize()
	endIf
endFunction

bool function IsCreature()
	return IsCreature
endFunction

;/-----------------------------------------------\;
;|	Preparation Functions                        |;
;\-----------------------------------------------/;

function LockActor()
	; Start DoNothing package
	ActorRef.AddToFaction(Lib.AnimatingFaction)
	ActorRef.SetFactionRank(Lib.AnimatingFaction, 1)
	ActorRef.EvaluatePackage()
	; Disable movement
	if IsPlayer
		Game.ForceThirdPerson()
		Game.SetPlayerAIDriven()
		; Enable hotkeys, if needed
		if IsVictim && Lib.bDisablePlayer
			Controller.AutoAdvance = true
		else
			Lib._HKStart(Controller)
		endIf
	else
		ActorRef.SetRestrained(true)
		ActorRef.SetDontMove(true)
		ActorRef.SetAnimationVariableBool("bHumanoidFootIKDisable", true)
	endIf
	; Attach Marker
	ActorRef.SetVehicle(MarkerRef)
endFunction

function UnlockActor()
	; Enable movement
	if IsPlayer
		Lib._HKClear()
		Game.SetPlayerAIDriven(false)
		int[] genders = Lib.GenderCount(Controller.Positions)
		Lib.Stats.UpdatePlayerStats(genders[0], genders[1], genders[2], Controller.Animation, Controller.GetVictim(), Controller.GetTime())
	else
		ActorRef.SetRestrained(false)
		ActorRef.SetDontMove(false)
		ActorRef.SetAnimationVariableBool("bHumanoidFootIKEnable", true)
	endIf
	; Remove from animation faction
	ActorRef.RemoveFromFaction(Lib.AnimatingFaction)
	ActorRef.EvaluatePackage()
	; Detach Marker
	ActorRef.SetVehicle(none)
endFunction

function PrepareActor()
	if IsCreature
		GoToState("Ready")
		return ; Creatures need none of this
	endIf
	; Cleanup
	if ActorRef.IsWeaponDrawn()
		ActorRef.SheatheWeapon()
	endIf
	; Sexual animations only
	if Controller.Animation.IsSexual()
		Strip(DoUndress)
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
	; Make erect for SOS
	Debug.SendAnimationEvent(ActorRef, "SOSFastErect")
	GoToState("Ready")
endFunction

function ResetActor()
	UnregisterForUpdate()
	if IsCreature
		return ; Creatures need none of this
	endIf
	; Cleanup Actors
	RemoveExtras()
	RemoveStrapon()
	; Reset openmouth
	;ActorRef.SetExpressionOverride(7, 50)
	ActorRef.ClearExpressionOverride()
	; Reset to starting scale
	if scale > 0.0
		ActorRef.SetScale(scale)
	endIf
	; Make flaccid for SOS
	Debug.SendAnimationEvent(ActorRef, "SOSFlaccid")
	; Unstrip
	if !ActorRef.IsDead()
		Lib.UnstripActor(ActorRef, EquipmentStorage, Controller.GetVictim())
	endIf
endFunction

function EquipExtras()
	if Animation == none || IsCreature
		return
	endIf
	; Equip Animation Extras
	Animation.EquipExtras(position, ActorRef)
endFunction

function RemoveExtras()
	if Animation == none || IsCreature
		return
	endIf
	; Remove Animation Extras
	Animation.RemoveExtras(position, ActorRef)
endFunction

function EquipStrapon()
	if strapon == none
		strapon = Lib.PickStrapon()
	endIf
	if strapon != none && !ActorRef.IsEquipped(strapon)
		ActorRef.EquipItem(strapon, false, true)
	endIf
endFunction

function RemoveStrapon()
	if strapon == none || (strapon != none && !ActorRef.IsEquipped(strapon))
		return ; Nothing to remove
	endIf
	ActorRef.UnequipItem(strapon, false, true)
	ActorRef.RemoveItem(strapon, 1, true)
endFunction

;/-----------------------------------------------\;
;|	Manipulation Functions                       |;
;\-----------------------------------------------/;

function AnimationExtras()
	if IsCreature
		return
	endIf
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
		; Debug.SendAnimationEvent(ActorRef, "SOSBend"+offset)
	endif
	; Equip Strapon if needed
	If IsFemale
		bool MalePosition = Animation.GetGender(position) == 0
		bool StraponPosition = Animation.UseStrapon(position, stage)
		if MalePosition && StraponPosition && Lib.bUseStrapons
			EquipStrapon()
		; Remove strapon if not needed and is equipped
		elseIf !MalePosition || (MalePosition && !StraponPosition)
			RemoveStrapon()
		endIf
	endIf
endfunction

function StopAnimating(bool quick = false)
	; Detach from marker
	ActorRef.StopTranslation()
	ActorRef.SetVehicle(none)
	; Reset Idle
	if IsCreature
		; Reset Creature Idle
		Debug.SendAnimationEvent(ActorRef, "Reset")
		Debug.SendAnimationEvent(ActorRef, "ReturnToDefault")
		Debug.SendAnimationEvent(ActorRef, "FNISDefault")
		Debug.SendAnimationEvent(ActorRef, "IdleReturnToDefault")
		Debug.SendAnimationEvent(ActorRef, "ForceFurnExit")
		ActorRef.PushActorAway(ActorRef, 0.1)
	else
		; Reset NPC/PC Idle Quickly
		Debug.SendAnimationEvent(ActorRef, "JumpLand")
		Debug.SendAnimationEvent(ActorRef, "IdleForceDefaultState")
		; Ragdoll NPC/PC if enabled and not in TFC
		if !quick && DoRagdoll && (!IsPlayer || (IsPlayer && Game.GetCameraState() != 3))
			ActorRef.PushActorAway(ActorRef, 0.1)
		endIf
	endIf
endFunction

function AlignTo(float[] offsets)
	float[] centerLoc = Controller.CenterLocation
	loc = new float[6]
	; Determine offsets coordinates from center
	loc[0] = centerLoc[0] + ( Math.sin(centerLoc[5]) * offsets[0] ) + ( Math.cos(centerLoc[5]) * offsets[1] )
	loc[1] = centerLoc[1] + ( Math.cos(centerLoc[5]) * offsets[0] ) + ( Math.sin(centerLoc[5]) * offsets[1] )
	loc[2] = centerLoc[2] + offsets[2]
	loc[3] = centerLoc[3]
	loc[4] = centerLoc[4]
	loc[5] = centerLoc[5] + offsets[3]
	if loc[5] >= 360
		loc[5] = loc[5] - 360
	elseIf loc[5] < 0
		loc[5] = loc[5] + 360
	endIf
	MarkerRef.SetPosition(loc[0], loc[1], loc[2])
	MarkerRef.SetAngle(loc[3], loc[4], loc[5])
	ActorRef.SetVehicle(MarkerRef)
	Snap()
endfunction

function Snap(float tolerance = 0.70)
	if ActorRef.GetDistance(MarkerRef) > tolerance
		ActorRef.MoveTo(MarkerRef)
		ActorRef.SetVehicle(MarkerRef)
		ActorRef.StopTranslation()
		ActorRef.TranslateTo((loc[0] + 0.1), (loc[1] + 0.1), loc[2], loc[3], loc[4], loc[5], 0.1, 0.1)
	endIf	
endFunction

function Strip(bool animate = true)
	if IsCreature
		return
	endIf
	bool[] strip
	; Get Strip settings or override
	if StripOverride.Length != 33
		strip = Lib.GetStrip(ActorRef, Controller.GetVictim(), Controller.LeadIn)
	else
		strip = StripOverride
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

function DisableUndressAnim(bool disableIt = true)
	disableundress = disableIt
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

function SyncThread()
	if !Active || Controller == none || ActorRef == none
		return
	endIf
	; Update Position
	position = Controller.GetPosition(ActorRef)
	; Current stage + animation
	int toStage = Controller.Stage
	sslBaseAnimation toAnimation = Controller.Animation
	; Update Stage
	if stage != toStage
		; Set Stage
		stage = toStage
		; Update Silence
		IsSilent = toAnimation.IsSilent(position, stage)
		if IsSilent || IsCreature
			; VoiceDelay is used as loop timer, must be set even if silent.
			VoiceDelay = 2.5
		else
			; Update Strength
			VoiceStrength = (stage as float) / (toAnimation.StageCount() as float)
			if toAnimation.StageCount() == 1 && stage == 1
				VoiceStrength = 0.50
			endIf
			; Base Delay
			if !IsFemale
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
	; Update Change
	if Animation != toAnimation
		; Update animation
		RemoveExtras()
		Animation = toAnimation
		EquipExtras()
	endIf
	; Update marker postioning
	AlignTo(Animation.GetPositionOffsets(position, stage))
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
		SyncThread()
		GoToState("Animating")
		RegisterForSingleUpdate(Utility.RandomFloat(0.0, 0.8))
	endFunction
endState

state Animating
	event OnUpdate()
		if ActorRef.IsDead() || ActorRef.IsDisabled()
			Controller.EndAnimation(true)
			return
		endIf
		RegisterForSingleUpdate(VoiceDelay)
		if IsCreature || IsSilent 
			return
		endIf
		if VoiceInstance > 0
			Sound.StopInstance(VoiceInstance)
		endIf
		VoiceInstance = Voice.Moan(ActorRef, VoiceStrength, IsVictim)
		Sound.SetInstanceVolume(VoiceInstance, Lib.fVoiceVolume)
	endEvent
endState

;/-----------------------------------------------\;
;|	Actor Callbacks                              |;
;\-----------------------------------------------/;

event OnStartThread(string eventName, string actorSlot, float argNum, form sender)
	UnregisterForModEvent("StartThread")
	LockActor()
	PrepareActor()
endEvent

event OnEndThread(string eventName, string actorSlot, float argNum, form sender)
	UnregisterForModEvent("EndThread")
	UnregisterForUpdate()
	bool quick = (argNum as bool)
	; Reset actor
	StopAnimating(quick)
	ResetActor()
	UnlockActor()
	; Apply cum
	int cum = Animation.GetCum(position)
	if !quick && cum > 0 && Lib.bUseCum && (Lib.bAllowFFCum || Controller.HasCreature || Lib.MaleCount(Controller.Positions) > 0)
		Lib.ApplyCum(ActorRef, cum)
	endIf
	; Free up alias slot
	ClearAlias()
	Utility.Wait(0.5)
	Initialize()
endEvent

;/-----------------------------------------------\;
;|	Misc Functions                               |;
;\-----------------------------------------------/;

function Initialize()
	; Clear events
	UnregisterForUpdate()
	UnregisterForAllModEvents()
	GoToState("")
	; Clear marker snapping
	if ActorRef != none
		ActorRef.StopTranslation()
		ActorRef.SetVehicle(none)
	endIf
	if MarkerObj != none
		MarkerObj.Disable()
		MarkerObj.Delete()
	endIf
	; Clear storage
	MarkerObj = none
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
	;Debug.TraceAndbox("Null start: "+ActorRef)
endFunction

event OnTranslationComplete()
	Debug.Notification("Move compltete")
endEvent