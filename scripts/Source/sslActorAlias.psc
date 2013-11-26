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

sslThreadController Controller
sslBaseExpression Expression
sslBaseAnimation Animation
sslBaseVoice Voice

; Voice
float VoiceDelay
bool IsSilent
int VoiceInstance

; Info
bool IsPlayer
bool IsVictim
bool IsFemale
bool IsCreature

; Storage
int strength
int position
int stage
form[] EquipmentStorage
bool[] StripOverride
form strapon
float ActorScale
float AnimScale
float[] loc
actor ClonedRef
ActorBase BaseRef
string ActorName

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
		; Init actor information
		ActorRef = GetReference() as actor
		BaseRef = ActorRef.GetLeveledActorBase()
		ActorName = BaseRef.GetName()
		int gender = Lib.GetGender(ActorRef)
		IsFemale = gender == 1
		IsCreature = gender == 2
		IsPlayer = ActorRef == Lib.PlayerRef
		; Calculate scales
		float display = ActorRef.GetScale()
		ActorRef.SetScale(1.0)
		float base = ActorRef.GetScale()
		; Starting scale
		ActorScale = ( display / base )
		; Reset back to starting scale
		ActorRef.SetScale(ActorScale)
		; Pick animation scale
		if Controller.ActorCount > 1 && Lib.bScaleActors
			AnimScale = (1.0 / base)
		else
			AnimScale = ActorScale
		endIf
	endIf
endFunction

function ClearAlias()
	TryToClear()
	TryToReset()
	if GetReference() != none
		ActorRef.EvaluatePackage()
		Debug.Trace("SexLab: Clearing Actor Slot of "+ActorName)
	endIf
	Initialize()
endFunction

bool function IsCreature()
	return IsCreature
endFunction

function SetCloned(actor CloneRef)
	if ClonedRef == none && CloneRef != none
		StopAnimating(true)
		UnlockActor()
		Clear()
		ForceRefTo(CloneRef)
		ClonedRef = ActorRef
		actor[] Positions = Controller.Positions
		Positions[Positions.Find(ActorRef)] = CloneRef
		Controller.Positions = Positions
		ActorRef = CloneRef
		IsPlayer = false
		LockActor()
		if GetState() == "Animating"
			Controller.RealignActors()
		endIf
		Lib.ControlLib._HKStart(Controller)
	endIf
endFunction

function RemoveClone()
	if ClonedRef != none
		actor[] Positions = Controller.Positions
		Positions[Positions.Find(ActorRef)] = ClonedRef
		Controller.Positions = Positions
		ActorRef = ClonedRef
		IsPlayer = true
		Clear()
		ForceRefTo(ActorRef)
		ClonedRef = none
		LockActor()
		Snap()
		if GetState() == "Animating"
			Controller.RealignActors()
		endIf
	endIf
endFunction

;/-----------------------------------------------\;
;|	Preparation Functions                        |;
;\-----------------------------------------------/;

function LockActor()
	Debug.Trace(ActorName+" DEBUG, LockActor() - START")
	; Start DoNothing package
	ActorRef.AddToFaction(Lib.AnimatingFaction)
	Debug.Trace(ActorName+" DEBUG, LockActor() - 1")
	ActorRef.SetFactionRank(Lib.AnimatingFaction, 1)
	Debug.Trace(ActorName+" DEBUG, LockActor() - 2")
	ActorRef.EvaluatePackage()
	Debug.Trace(ActorName+" DEBUG, LockActor() - 3")
	; Disable movement
	if IsPlayer
		Debug.Trace(ActorName+" DEBUG, LockActor() - 4 - Player 1")
		Game.DisablePlayerControls(false, false, false, false, false, false, true, false, 0)
		Debug.Trace(ActorName+" DEBUG, LockActor() - 4 - Player 2")
		Game.ForceThirdPerson()
		Debug.Trace(ActorName+" DEBUG, LockActor() - 4 - Player 3")
		Game.SetPlayerAIDriven()
		Debug.Trace(ActorName+" DEBUG, LockActor() - 4 - Player 4")
		; Game.SetInChargen(true, true, true)
		; Enable hotkeys, if needed
		if IsVictim && Lib.bDisablePlayer
			Debug.Trace(ActorName+" DEBUG, LockActor() - 4 - Player 5")
			Controller.AutoAdvance = true
		else
			Debug.Trace(ActorName+" DEBUG, LockActor() - 4 - Player 6")
			Lib.ControlLib._HKStart(Controller)
		endIf
	else
		Debug.Trace(ActorName+" DEBUG, LockActor() - 4 - NPC 1")
		ActorRef.SetRestrained(true)
		Debug.Trace(ActorName+" DEBUG, LockActor() - 4 - NPC 2")
		ActorRef.SetDontMove(true)
		Debug.Trace(ActorName+" DEBUG, LockActor() - 4 - NPC 3")
		; ActorRef.SetAnimationVariableBool("bHumanoidFootIKDisable", true)
	endIf
	Debug.Trace(ActorName+" DEBUG, LockActor() - END")
endFunction

function UnlockActor()
	; Enable movement
	if IsPlayer
		Lib.ControlLib._HKClear()
		Game.EnablePlayerControls(false, false, false, false, false, false, true, false, 0)
		Game.SetPlayerAIDriven(false)
		; Game.SetInChargen(false, false, false)
	else
		ActorRef.SetRestrained(false)
		ActorRef.SetDontMove(false)
		; ActorRef.SetAnimationVariableBool("bHumanoidFootIKEnable", true)
	endIf
	; Remove from animation faction
	ActorRef.RemoveFromFaction(Lib.AnimatingFaction)
	ActorRef.EvaluatePackage()
	; Detach positioning marker
	ActorRef.StopTranslation()
	ActorRef.SetVehicle(none)
endFunction


function EquipStrapon()
	if strapon == none && Lib.HasStrapon(ActorRef)
		return
	elseIf strapon == none
		strapon = Lib.PickStrapon(ActorRef)
	endIf
	if strapon != none && !ActorRef.IsEquipped(strapon)
		;ActorRef.AddItem(strapon, 1, true)
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

function MakeVictim(bool victimize = true)
	IsVictim = victimize
endFunction

;/-----------------------------------------------\;
;|	Manipulation Functions                       |;
;\-----------------------------------------------/;

function StopAnimating(bool quick = false)
	; Reset Idle
	if IsCreature
		; Reset Creature Idle
		Debug.SendAnimationEvent(ActorRef, "Reset")
		Debug.SendAnimationEvent(ActorRef, "ReturnToDefault")
		Debug.SendAnimationEvent(ActorRef, "FNISDefault")
		Debug.SendAnimationEvent(ActorRef, "IdleReturnToDefault")
		Debug.SendAnimationEvent(ActorRef, "ForceFurnExit")
		ActorRef.PushActorAway(ActorRef, 1.0)
	else
		; Reset NPC/PC Idle Quickly
		Debug.SendAnimationEvent(ActorRef, "JumpLand")
		Debug.SendAnimationEvent(ActorRef, "IdleForceDefaultState")
		; Ragdoll NPC/PC if enabled and not in TFC
		if !quick && DoRagdoll && (!IsPlayer || (IsPlayer && Game.GetCameraState() != 3))
			ActorRef.PushActorAway(ActorRef, 1.0)
		endIf
	endIf
endFunction

function AttachMarker()
	ActorRef.SetVehicle(MarkerRef)
	ActorRef.SetScale(AnimScale)
	if ClonedRef != none
		ClonedRef.SetVehicle(ActorRef)
	endIf
endFunction

function AlignTo(float[] offsets, bool forceTo = false)
	float[] centerLoc = Controller.CenterLocation
	loc = new float[6]
	; Determine offsets coordinates from center
	loc[0] = centerLoc[0] + ( Math.sin(centerLoc[5]) * offsets[0] ) + ( Math.cos(centerLoc[5]) * offsets[1] )
	loc[1] = centerLoc[1] + ( Math.cos(centerLoc[5]) * offsets[0] ) + ( Math.sin(centerLoc[5]) * offsets[1] )
	loc[2] = centerLoc[2] + offsets[2]
	loc[3] = centerLoc[3]
	loc[4] = centerLoc[4]
	loc[5] = centerLoc[5] + offsets[3]
	if loc[5] >= 360.0
		loc[5] = loc[5] - 360.0
	elseIf loc[5] < 0.0
		loc[5] = loc[5] + 360.0
	endIf
	; Set Marker Position
	MarkerRef.SetPosition(loc[0], loc[1], loc[2])
	MarkerRef.SetAngle(loc[3], loc[4], loc[5])
	AttachMarker()
	; Force actor location
	if forceTo
		ActorRef.SetPosition(loc[0], loc[1], loc[2])
		ActorRef.SetAngle(loc[3], loc[4], loc[5])
		AttachMarker()
	endIf
	; Soft snap actor location
	Snap()
endfunction

function Snap()
	if ActorRef == none || MarkerObj == none
		return
	endIf
	; Quickly move into place if actor isn't positioned right
	if ActorRef.GetDistance(MarkerRef) > 0.5
		ActorRef.SplineTranslateTo(loc[0], loc[1], loc[2], loc[3], loc[4], loc[5], 1.0, 50000, 0)
		AttachMarker()
		Utility.Wait(0.1)
	endIf
	; Force position if translation didn't move them properly
	if ActorRef.GetDistance(MarkerRef) > 1.0
		ActorRef.StopTranslation()
		ActorRef.SetPosition(loc[0], loc[1], loc[2])
		AttachMarker()
	endIf
	; Force angle if translation didn't rotate them properly
	if Math.Abs(ActorRef.GetAngleZ() - MarkerRef.GetAngleZ()) > 0.5; || Math.Abs(ActorRef.GetAngleX() - MarkerRef.GetAngleX()) > 0.5
		ActorRef.StopTranslation()
		ActorRef.SetAngle(loc[3], loc[4], loc[5])
		AttachMarker()
	endIf
	; Begin very slowly rotating a small amount to hold position
	ActorRef.SplineTranslateTo(loc[0], loc[1], loc[2], loc[3], loc[4], loc[5]+0.1, 1.0, 10000, 0.0001)
endFunction

event OnTranslationComplete()
	; debug.trace(ActorRef+ " Translation Complete")
	Utility.Wait(0.25)
	Snap()
endEvent

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
	if Controller == none || ActorRef == none
		return
	endIf
	; Sync from thread
	int toPosition = Controller.GetPosition(ActorRef)
	int toStage = Controller.Stage
	sslBaseAnimation toAnimation = Controller.Animation
	; Update marker postioning
	AlignTo(toAnimation.GetPositionOffsets(toPosition, toStage))
	; Update if needed
	if toPosition != position || toStage != stage || toAnimation != Animation
		; Update thread info
		position = toPosition
		stage = toStage
		Animation = toAnimation
		; Update Strength for voice & expression
		strength = ((stage as float) / (Animation.StageCount() as float) * 100) as int
		if Controller.LeadIn
			strength = ((strength as float) * 0.70) as int
		endIf
		if stage == 1 && Animation.StageCount() == 1
			strength = 70
		endIf
		; Update Silence
		IsSilent = Animation.IsSilent(position, stage)
		if IsSilent || IsCreature
			; VoiceDelay is used as loop timer, must be set even if silent.
			VoiceDelay = 2.5
		else
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
			; Min 1.2 delay
			if VoiceDelay < 1.2
				VoiceDelay = 1.2
			endIf
		endIf
		; Animation related stuffs
		if !IsCreature
			; Send expression
			Expression.ApplyTo(ActorRef, strength, Animation.UseOpenMouth(position, stage))
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
				string name = ActorRef.GetLeveledActorBase().GetName()
				;Debug.Notification(name+" Offset["+offset+"]: "+bend)
				;Debug.Trace(name+" Offset: SOSBend"+offset+ ": Sent -> "+bend)
				; Debug.SendAnimationEvent(ActorRef, "SOSBend"+offset)
			endif
			; Equip Strapon if needed
			if IsFemale && Lib.bUseStrapons && Animation.UseStrapon(position, stage)
				EquipStrapon()
			; Remove strapon if there is one
			elseIf strapon != none
				RemoveStrapon()
			endIf
		endIf
	endIf
endFunction

function OverrideStrip(bool[] setStrip)
	if setStrip.Length != 33
		return
	endIf
	StripOverride = setStrip
endFunction

function SetVoice(sslBaseVoice toVoice, bool forceSilent = false)
	if IsCreature
		return
	endIf
	Voice = toVoice
	if toVoice == none
		Voice = Lib.VoiceLib.PickVoice(ActorRef)
	endIf
	IsSilent = forceSilent || IsSilent
endFunction

sslBaseVoice function GetVoice()
	return Voice
endFunction

function SetExpression(sslBaseExpression toExpression)
	Expression = toExpression
endFunction

sslBaseExpression function GetExpression()
	return Expression
endFunction

;/-----------------------------------------------\;
;|	Animation/Voice Loop                         |;
;\-----------------------------------------------/;
state Prepare
	event OnBeginState()
		Debug.Trace(ActorName+" DEBUG, Prepare OnBeginState()")
		RegisterForSingleUpdate(0.1)
	endEvent
	event OnUpdate()
		Debug.Trace(ActorName+" DEBUG, Prepare OnUpdate() - START")
		Debug.Trace(ActorName+" DEBUG, Prepare OnUpdate() - 1")
		; Lock movement
		LockActor()
		Debug.Trace(ActorName+" DEBUG, Prepare OnUpdate() - 2")
		; Creatures need none of this
		if !IsCreature
			Debug.Trace(ActorName+" DEBUG, Prepare OnUpdate() - 3")
			; Cleanup
			if ActorRef.IsWeaponDrawn()
				ActorRef.SheatheWeapon()
				Debug.Trace(ActorName+" DEBUG, Prepare OnUpdate() - 4")
			endIf
			Debug.Trace(ActorName+" DEBUG, Prepare OnUpdate() - 5")
			; Sexual animations only
			if Controller.Animation.IsSexual()
				Debug.Trace(ActorName+" DEBUG, Prepare OnUpdate() - 6")
				Strip(DoUndress)
				Debug.Trace(ActorName+" DEBUG, Prepare OnUpdate() - 7")
			endIf
			Debug.Trace(ActorName+" DEBUG, Prepare OnUpdate() - 8")
			; Make erect for SOS
			Debug.SendAnimationEvent(ActorRef, "SOSFastErect")
		endIf
		Debug.Trace(ActorName+" DEBUG, Prepare OnUpdate() - 9")
		GoToState("Ready")
		Debug.Trace(ActorName+" DEBUG, Prepare OnUpdate() - END")
	endEvent
endState

state Ready
	event OnBeginState()
		Debug.Trace(ActorName+" DEBUG, Ready OnBeginState()")
		UnregisterForUpdate()
	endEvent
	function StartAnimating()
		Debug.Trace(ActorName+" DEBUG, Ready StartAnimating() - START")
		Debug.Trace(ActorName+" DEBUG, Ready StartAnimating() - 1")
		if ActorRef != none && Controller != none
			Debug.Trace(ActorName+" DEBUG, Ready StartAnimating() - 2")
			SyncThread()
			Debug.Trace(ActorName+" DEBUG, Ready StartAnimating() - 3")
			GoToState("Animating")
			Debug.Trace(ActorName+" DEBUG, Ready StartAnimating() - 4")
			RegisterForSingleUpdate(Utility.RandomFloat(0.1, 0.8))
		endIf
		Debug.Trace(ActorName+" DEBUG, Ready StartAnimating() - END")
	endFunction
endState

state Animating
	event OnUpdate()
		Debug.Trace(ActorName+" DEBUG, Animating OnUpdate()")
		if ActorRef.IsDead() || ActorRef.IsDisabled()
			Controller.EndAnimation(true)
			return
		endIf
		if Expression != none
			Expression.ClearMFG(ActorRef)
		endIf
		if Voice != none
			if VoiceInstance > 0
				Sound.StopInstance(VoiceInstance)
			endIf
			VoiceInstance = Voice.Moan(ActorRef, strength, IsVictim)
			Sound.SetInstanceVolume(VoiceInstance, Lib.fVoiceVolume)
		endIf
		if Expression != none
			Expression.ApplyTo(ActorRef, strength)
		endIf
		RegisterForSingleUpdate(VoiceDelay)
	endEvent
endState

state Orgasm
	event OnBeginState()
		if IsPlayer
			Lib.UnregisterForKey(Lib.ControlLib.kAdvanceAnimation)
		endIf
		RegisterForSingleUpdate(0.1)
	endEvent
	event OnUpdate()
		; Apply cum
		int cum = Animation.GetCum(position)
		if cum > 0 && Lib.bUseCum && (Lib.bAllowFFCum || Controller.HasCreature || Lib.MaleCount(Controller.Positions) > 0)
			Lib.ApplyCum(ActorRef, cum)
		endIf
		; Voice
		strength = 100
		VoiceDelay = 1.0
		GoToState("Animating")
		RegisterForSingleUpdate(0.1)
	endEvent
endState

state Reset
	event OnBeginState()
		RegisterForSingleUpdate(0.1)
	endEvent
	event OnUpdate()
		UnregisterForUpdate()
		if IsPlayer
			RemoveClone()
			; Update diary/journal stats for player
			int[] genders = Lib.GenderCount(Controller.Positions)
			Lib.Stats.UpdatePlayerStats(genders[0], genders[1], genders[2], Animation, Controller.GetVictim(), Controller.GetTime())
		elseIf Controller.HasPlayer
			; Increase player sex for NPC
			Lib.Stats.AddPlayerSex(ActorRef)
		endIf
		; Reset to starting scale
		ActorRef.SetScale(ActorScale)
		; Reapply cum
		int cum = Animation.GetCum(position)
		if !Controller.FastEnd && cum > 0 && Lib.bUseCum && (Lib.bAllowFFCum || Controller.HasCreature || Lib.MaleCount(Controller.Positions) > 0)
			Lib.ApplyCum(ActorRef, cum)
		endIf
		; Make flaccid for SOS
		Debug.SendAnimationEvent(ActorRef, "SOSFlaccid")
		; Reset the actor
		StopAnimating(Controller.FastEnd)
		if !IsCreature
			; Cleanup extras
			RemoveStrapon()
			; Reset openmouth/mfg
			ActorRef.ClearExpressionOverride()
			MfgConsoleFunc.ResetPhonemeModifier(ActorRef)
		endIf
		; Unstrip
		if !ActorRef.IsDead()
			Lib.UnstripActor(ActorRef, EquipmentStorage, Controller.GetVictim())
		endIf
		; Unlock their movement
		UnlockActor()
		; Free up alias slot
		ClearAlias()
		GoToState("")
	endEvent
endState

;/-----------------------------------------------\;
;|	Misc Functions                               |;
;\-----------------------------------------------/;

function Initialize()
	; Clear events
	UnregisterForUpdate()
	UnregisterForAllModEvents()
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
	ClonedRef = none
	Controller = none
	Voice = none
	Animation = none
	Expression = none
	strapon = none
	ActorScale = 0.0
	AnimScale = 0.0
	position = 0
	stage = 0
	form[] formDel
	EquipmentStorage = formDel
	bool[] boolDel
	StripOverride = boolDel
	; Reset state
	GoToState("")
endFunction

function StartAnimating()
	Debug.TraceAndBox("Null StartAnimating(): "+BaseRef.GetName())
endFunction
