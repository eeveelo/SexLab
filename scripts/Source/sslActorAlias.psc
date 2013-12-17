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
bool IsMouthOpen

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
ActorBase BaseRef
string ActorName
int[] ExpressionPreset
bool toggle

; Stats
bool IsPure
int Purity
int Vaginal
int Anal
int Oral

int property Enjoyment auto hidden

race property ActorRace hidden
	race function get()
		return BaseRef.GetRace()
	endFunction
endProperty

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

bool function SetAlias(actor prospect, sslThreadController ThreadView)
	if prospect == none || GetReference() != prospect || Lib.ValidateActor(prospect) != 1
		return false ; Failed to set prospective actor into alias
	endIf
	Initialize()
	Controller = ThreadView
	; Init actor information
	ActorRef = GetReference() as actor
	BaseRef = ActorRef.GetLeveledActorBase()
	ActorName = BaseRef.GetName()
	int gender = Lib.GetGender(ActorRef)
	IsFemale = gender == 1
	IsCreature = gender == 2
	IsPlayer = ActorRef == Lib.PlayerRef
	IsVictim = ActorRef == Controller.VictimRef
	Debug.Trace("-- SexLab ActorAlias -- Thread["+Controller.tid+"] Slotting '"+ActorName+"' into alias -- "+self)
	return true
endFunction

function ClearAlias()
	TryToClear()
	TryToReset()
	if ActorRef != none
		ActorRef.EvaluatePackage()
		Debug.Trace("-- SexLab ActorAlias -- Clearing '"+ActorName+"' from alias -- "+self)
	endIf
	Initialize()
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
		Game.DisablePlayerControls(false, false, false, false, false, false, true, false, 0)
		Game.ForceThirdPerson()
		Game.SetPlayerAIDriven()
		; Game.SetInChargen(true, true, true)
		; Enable hotkeys, if needed
		if IsVictim && Lib.bDisablePlayer
			Controller.AutoAdvance = true
		else
			Lib.ControlLib._HKStart(Controller)
		endIf
	else
		ActorRef.SetRestrained(true)
		ActorRef.SetDontMove(true)
		; ActorRef.SetAnimationVariableBool("bHumanoidFootIKDisable", true)
	endIf
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
	; Clear expression
	if Expression != none
		Expression.ClearMFG(ActorRef)
	endIf
endFunction


function EquipStrapon()
	if strapon == none && Lib.HasStrapon(ActorRef)
		return
	elseIf strapon == none
		strapon = Lib.PickStrapon(ActorRef)
	endIf
	if strapon != none && !ActorRef.IsEquipped(strapon)
		;ActorRef.AddItem(strapon, 1, true)
		bool toggled = Lib.ControlLib.TempToggleFreeCamera(Controller.HasPlayer, "EquipStrapon")
		ActorRef.EquipItem(strapon, false, true)
		Lib.ControlLib.TempToggleFreeCamera(toggled, "EquipStrapon")
	endIf
endFunction

function RemoveStrapon()
	if strapon == none || (strapon != none && !ActorRef.IsEquipped(strapon))
		return ; Nothing to remove
	endIf
	bool toggled = Lib.ControlLib.TempToggleFreeCamera(Controller.HasPlayer, "RemoveStrapon")
	ActorRef.UnequipItem(strapon, false, true)
	ActorRef.RemoveItem(strapon, 1, true)
	Lib.ControlLib.TempToggleFreeCamera(toggled, "RemoveStrapon")
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
	; Nothing to add
	if equipment.Length == 0
		return
	; Nothing to add on to
	elseIf EquipmentStorage.Length == 0
		EquipmentStorage = equipment
	; Add onto existing storage
	else
		EquipmentStorage = sslUtility.MergeFormArray(equipment, EquipmentStorage)
	endIf
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
			; Calculate current enjoyment level
			GetEnjoyment()
			; Send expression
			IsMouthOpen = Animation.UseOpenMouth(position, stage)
			DoExpression()
			; Send SOS event
			if Lib.SOSEnabled && Animation.GetGender(position) == 0
				Debug.SendAnimationEvent(ActorRef, "SOSFastErect")
				int offset = Animation.GetSchlong(position, stage)
				Debug.SendAnimationEvent(ActorRef, "SOSBend"+offset)
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
		RegisterForSingleUpdate(0.1)
	endEvent
	event OnUpdate()
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
		; Lock movement
		LockActor()
		; Creatures need none of this
		if !IsCreature
			; Cleanup
			TryToStopCombat()
			if ActorRef.IsWeaponDrawn()
				ActorRef.SheatheWeapon()
			endIf
			; Sexual animations only
			if Controller.Animation.IsSexual()
				Strip(DoUndress)
			endIf
			; Get purity
			Purity = Lib.Stats.GetPurityLevel(ActorRef)
			IsPure = Lib.Stats.IsPure(ActorRef)
			; Get skill levels
			if Controller.HasPlayer
				Vaginal = Lib.Stats.GetPlayerSkillLevel("Vaginal")
				Anal = Lib.Stats.GetPlayerSkillLevel("Anal")
				Oral = Lib.Stats.GetPlayerSkillLevel("Oral")
			else
				Vaginal = Lib.Stats.GetSkillLevel(ActorRef, "Vaginal")
				Anal = Lib.Stats.GetSkillLevel(ActorRef, "Anal")
				Oral = Lib.Stats.GetSkillLevel(ActorRef, "Oral")
			endIf
			; Make erect for SOS
			Debug.SendAnimationEvent(ActorRef, "SOSFastErect")
		endIf
		GoToState("Ready")
	endEvent
endState

state Ready
	event OnBeginState()
		UnregisterForUpdate()
	endEvent
	function StartAnimating()
		if ActorRef != none && Controller != none
			SyncThread()
			GoToState("Animating")
			RegisterForSingleUpdate(Utility.RandomFloat(0.1, 0.8))
			; Auto TFC
			if IsPlayer && Lib.ControlLib.bAutoTFC
				Lib.ControlLib.EnableFreeCamera(true)
			endIf
		endIf
	endFunction
endState

state Animating
	event OnUpdate()
		if ActorRef.IsDead() || ActorRef.IsDisabled()
			Controller.EndAnimation(true)
			return
		endIf
		if Voice != none && !IsSilent
			if Expression != none
				Expression.ClearPhoneme(ActorRef)
			endIf
			if VoiceInstance
				Sound.StopInstance(VoiceInstance)
			endIf
			VoiceInstance = Voice.Moan(ActorRef, Strength, IsVictim)
			Sound.SetInstanceVolume(VoiceInstance, Lib.fVoiceVolume)
		endIf
		toggle = !toggle
		if toggle
			GetEnjoyment()
			DoExpression()
		endIf
		RegisterForSingleUpdate(VoiceDelay)
	endEvent
endState

state Orgasm
	event OnBeginState()
		RegisterForSingleUpdate(0.1)
	endEvent
	event OnUpdate()
		; Disable Free camera, if in it
		if IsPlayer
			Lib.ControlLib.EnableFreeCamera(false)
		endIf
		; Apply cum
		int cum = Animation.GetCum(position)
		if cum > 0 && Lib.bUseCum && (Lib.bAllowFFCum || Controller.HasCreature || Controller.Males > 0)
			Lib.ApplyCum(ActorRef, cum)
		endIf
		; Shake camera if player and not in free camera
		if IsPlayer && Game.GetCameraState() != 3
			Game.ShakeCamera(none, 0.75, 1.5)
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
		; Disable free camera, if in it
		if IsPlayer
			Lib.ControlLib.EnableFreeCamera(false)
		; Increase player sex for NPC
		elseIf Controller.HasPlayer
			Lib.Stats.AddPlayerSex(ActorRef)
		endIf
		; Update diary/journal stats for player + native stats for NPCs
		Lib.Stats.UpdateNativeStats(ActorRef, Controller.Males, Controller.Females, Controller.Creatures, Animation, Controller.VictimRef, Controller.TotalTime)
		; Reset to starting scale
		ActorRef.SetScale(ActorScale)
		; Reapply cum
		int cum = Animation.GetCum(position)
		if !Controller.FastEnd && cum > 0 && Lib.bUseCum && (Lib.bAllowFFCum || Controller.HasCreature || Controller.Males > 0)
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

function DoExpression()
	if Expression == none || IsCreature
		; Nothing
	elseIf IsVictim
		Expression.ApplyTo(ActorRef, GetPain(), IsFemale, IsMouthOpen)
	else
		Expression.ApplyTo(ActorRef, Enjoyment, IsFemale, IsMouthOpen)
	endIf
endFunction

int function GetEnjoyment()
	; Init weights
	int BaseWeight
	int ProficencyWeight
	int PurityWeight
	int ActorCount = Controller.ActorCount
	; Appropiate bonus = 1.multiplier -- leaving addition intact
	; Inappropiate bonus = 0 -- canceling out the addition
	int FemaleBonus = (IsFemale as int)
	int MaleBonus = ((!IsFemale) as int)
	int PureBonus = (IsPure as int)
	int ImpureBonus = ((!IsPure) as int)
	; Scaling purity modifier
	int PurityMod = 1 + (Purity / 2)
	; Adjust bonuses based on type, gender, and purity
	if Animation.HasTag("Vaginal")
		ProficencyWeight += Vaginal
		BaseWeight   += FemaleBonus  * 2
		BaseWeight   += MaleBonus    * 3
	endIf
	if Animation.HasTag("Anal")
		ProficencyWeight += Anal
		BaseWeight   += FemaleBonus  * -1
		BaseWeight   += MaleBonus    * 3
		PurityWeight += PureBonus    * -PurityMod
		PurityWeight += ImpureBonus  * PurityMod
	endIf
	if Animation.HasTag("Oral")
		ProficencyWeight += Oral
		BaseWeight   += FemaleBonus  * -1
		BaseWeight   += MaleBonus    * 3
		PurityWeight += PureBonus    * -PurityMod
		PurityWeight += ImpureBonus  * PurityMod
	endIf
	if Animation.HasTag("Dirty")
		PurityWeight += PureBonus    * (-PurityMod - 1)
		PurityWeight += ImpureBonus  * PurityMod
	endIf
	if Animation.HasTag("Aggressive")
		PurityWeight += PureBonus    * (-PurityMod - 3)
	endIf
	if Animation.HasTag("Loving")
		PurityWeight += PureBonus    * (PurityMod + 1)
	endIf
	if Animation.IsCreature
		PurityWeight += PureBonus    * (-PurityMod - 6)
	endIf
	if ActorCount > 2
		PurityWeight += PureBonus    * ((-PurityMod - 3) * (ActorCount - 2))
		PurityWeight += ImpureBonus  * ((PurityMod + 2) * (ActorCount - 2))
	endIf
	if ActorCount == 1
		ProficencyWeight += Purity
		PurityWeight += ImpureBonus  * (PurityMod + (ActorRef.GetActorValue("Confidence") as int))
	endIf
	; Ramp up with stage and time spent, maxout time bonus at 2.5 minutes (8 seconds * 19 intervals = 152 seconds == ~2.5 minutes)
	BaseWeight += (4 * Stage) + Clamp(((Controller.TotalTime / 8.0) as int), 19)
	; Calculate root enjoyment of the animation, give multipler by progress through the animation stages (1/5 stage = 1.20 multiplier)
	Enjoyment = (((BaseWeight + PurityWeight + (ProficencyWeight * 3)) as float) * ((Stage as float / Animation.StageCount as float) + 1.0)) as int
	; Cap victim at 50 after halving
	if IsVictim
		Enjoyment = Clamp((Enjoyment / 2), 50)
	endIf
	; Return enjoyment, clamped to max value of 100
	Enjoyment = Clamp(Enjoyment)
	return Enjoyment
endFunction

int function GetPain()
	if IsVictim
		return 100 - Clamp(Enjoyment)
	endIf
	return 50 - Clamp((Enjoyment / 3), 50)
endFunction

int function Clamp(int value, int max = 100)
	if value < 0
		return 0
	elseIf value >= max
		return max
	endIf
	return value
endFunction

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
	Debug.Trace("Null StartAnimating(): "+ActorName)
endFunction
