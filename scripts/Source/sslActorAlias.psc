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

; Associated systems
sslThreadController Controller
sslBaseExpression Expression
sslBaseAnimation Animation
sslBaseVoice Voice

; Voice
bool IsSilent
float VoiceDelay

; Info
bool IsPlayer
bool IsVictim
bool IsFemale
bool IsCreature

; Storage
int strength
int position
int stage
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
int FemaleBonus
int MaleBonus
int PureBonus
int ImpureBonus
int BaseWeight
int ProficencyWeight
int PurityWeight

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

bool function PrepareAlias(int tid, Actor ProspectRef, bool MakeVictim, sslBaseVoice UseVoice, bool ForceSilence)
	if ProspectRef == none || GetReference() != ProspectRef || !Lib.ValidateActor(ProspectRef)
		return false ; Failed to set prospective actor into alias
	endIf
	Initialize()
	; Register actor as active
	StorageUtil.FormListAdd(Lib, "Registry", ProspectRef, false)
	; Init actor alias information
	Controller = Lib.Threads.GetController(tid)
	ActorRef = GetReference() as actor
	BaseRef = ActorRef.GetLeveledActorBase()
	ActorName = BaseRef.GetName()
	int gender = Lib.GetGender(ActorRef)
	IsFemale = gender == 1
	IsCreature = gender == 2
	IsPlayer = ActorRef == Lib.PlayerRef
	IsVictim = MakeVictim
	IsSilent = ForceSilence
	Voice = UseVoice
	if MakeVictim
		Controller.VictimRef = ActorRef
	endIf
	Debug.Trace("-- SexLab ActorAlias -- Thread["+Controller.tid+"] Slotted '"+ActorName+"' into alias -- "+self)
	return true
endFunction

function ClearAlias()
	TryToClear()
	TryToReset()
	StorageUtil.FormListRemove(Lib, "Registry", ActorRef, true)
	UnlockActor()
	Initialize()
endFunction

bool function IsCreature()
	return IsCreature
endFunction

;/-----------------------------------------------\;
;|	Preparation Functions                        |;
;\-----------------------------------------------/;

function LockActor()
	if ActorRef == none
		return
	endIf
	; Start DoNothing package
	ActorRef.SetFactionRank(Lib.AnimatingFaction, 1)
	ActorUtil.AddPackageOverride(ActorRef, Lib.DoNothing, 100, 1)
	ActorRef.EvaluatePackage()
	; Disable movement
	if IsPlayer
		Game.ForceThirdPerson()
		Game.SetPlayerAIDriven()
		Game.DisablePlayerControls(false, false, false, false, false, false, true, false, 0)
		; Enable hotkeys, if needed
		if IsVictim && Lib.bDisablePlayer
			Controller.AutoAdvance = true
		else
			Lib.ControlLib._HKStart(Controller)
		endIf
	else
		ActorRef.SetRestrained(true)
		ActorRef.SetDontMove(true)
	endIf
endFunction

function UnlockActor()
	if ActorRef == none
		return
	endIf
	; Disable free camera, if in it
	if IsPlayer && Game.GetCameraState() == 3
		MiscUtil.ToggleFreeCamera()
	endIf
	; Enable movement
	if IsPlayer
		Lib.ControlLib._HKClear()
		Game.SetPlayerAIDriven(false)
		Game.EnablePlayerControls(false, false, false, false, false, false, true, false, 0)
	else
		ActorRef.SetRestrained(false)
		ActorRef.SetDontMove(false)
	endIf
	; Remove from animation faction
	ActorRef.RemoveFromFaction(Lib.AnimatingFaction)
	ActorUtil.RemovePackageOverride(ActorRef, Lib.DoNothing)
	ActorRef.EvaluatePackage()
	; Detach positioning marker
	ActorRef.StopTranslation()
	ActorRef.SetVehicle(none)
	if !IsCreature
		; Cleanup
		TryToStopCombat()
		if ActorRef.IsWeaponDrawn()
			ActorRef.SheatheWeapon()
		endIf
		; Clear expression
		ActorRef.ClearExpressionOverride()
		if Expression != none
			sslExpressionLibrary.ClearMFG(ActorRef)
		endIf
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
	; Disable free camera, if in it
	if IsPlayer && Game.GetCameraState() == 3
		MiscUtil.ToggleFreeCamera()
	endIf
	if IsCreature
		; Reset creature idle
		Debug.SendAnimationEvent(ActorRef, "Reset")
		Debug.SendAnimationEvent(ActorRef, "ReturnToDefault")
		Debug.SendAnimationEvent(ActorRef, "FNISDefault")
		Debug.SendAnimationEvent(ActorRef, "IdleReturnToDefault")
		Debug.SendAnimationEvent(ActorRef, "ForceFurnExit")
		ActorRef.PushActorAway(ActorRef, 1.0)
	else
		; Reset NPC/PC Idle Quickly
		Debug.SendAnimationEvent(ActorRef, "IdleForceDefaultState")
		; Ragdoll NPC/PC if enabled and not in TFC
		if !quick && DoRagdoll && (!IsPlayer || (IsPlayer && Game.GetCameraState() != 3))
			ActorRef.StopTranslation()
			ActorRef.PushActorAway(ActorRef, 1.0)
		endIf
	endIf
endFunction

function Strip(bool animate = true)
	if IsCreature
		return
	endIf
	; Get Strip settings or override
	if StripOverride.Length != 33
		Lib.StripActorStorage(ActorRef, Lib.GetStrip(ActorRef, Controller.GetVictim(), Controller.LeadIn), animate)
	else
		Lib.StripActorStorage(ActorRef, StripOverride, animate)
	endIf
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
		; Lock movement
		LockActor()
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
			Purity = Lib.ActorStats.GetPurityLevel(ActorRef)
			IsPure = Lib.ActorStats.IsPure(ActorRef)
			; Get skill levels
			if Controller.HasPlayer
				Vaginal = Lib.ActorStats.GetPlayerSkillLevel("Vaginal")
				Anal = Lib.ActorStats.GetPlayerSkillLevel("Anal")
				Oral = Lib.ActorStats.GetPlayerSkillLevel("Oral")
			else
				Vaginal = Lib.ActorStats.GetSkillLevel(ActorRef, "Vaginal")
				Anal = Lib.ActorStats.GetSkillLevel(ActorRef, "Anal")
				Oral = Lib.ActorStats.GetSkillLevel(ActorRef, "Oral")
			endIf
			; Init stat bases
			; Appropiate bonus = 1.multiplier -- leaving addition intact
			; Inappropiate bonus = 0 -- canceling out the addition
			FemaleBonus = (IsFemale as int)
			MaleBonus = ((!IsFemale) as int)
			PureBonus = (IsPure as int)
			ImpureBonus = ((!IsPure) as int)
			; Pick expression
			if Expression == none
				Expression = Lib.ExpressionLib.PickExpression(ActorRef, Controller.VictimRef)
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
		if Controller == none || ActorRef == none || GetReference() == none || GetReference() != ActorRef
			ClearAlias() ; We shouldn't be here
		endIf
	endEvent
	function SyncThread(bool force = false)
		if ActorRef != none && Controller != none
			GoToState("Animating")
			SyncThread(force)
			RegisterForSingleUpdate(Utility.RandomFloat(0.5, 1.5))
		endIf
	endFunction
endState

state Animating
	; Primary loop
	event OnUpdate()
		if ActorRef.IsDead() || ActorRef.IsDisabled()
			Controller.EndAnimation(true)
			return
		elseIf Voice != none && !IsSilent
			; Clear expression and modifiers before playing
			sslExpressionLibrary.ClearPhoneme(ActorRef)
			Voice.Moan(ActorRef, Strength, IsVictim)
		endIf
		RegisterForSingleUpdate(VoiceDelay)
	endEvent

	; Animating functions
	function SyncThread(bool force = false)
		if Controller == none || ActorRef == none
			return
		endIf
		; Sync from thread
		int toPosition = Controller.Positions.Find(ActorRef)
		int toStage = Controller.Stage
		sslBaseAnimation toAnimation = Controller.Animation
		; Update marker postioning
		AlignTo(toAnimation.GetPositionOffsets(toPosition, toStage), force)
		; Update if needed
		if force || toPosition != position || toStage != stage || toAnimation != Animation
			; Update thread info
			position = toPosition
			stage = toStage
			Animation = toAnimation
			; Update Strength for voice
			strength = ((stage as float) / (Animation.StageCount() as float) * 100) as int
			if Controller.LeadIn
				strength = ((strength as float) * 0.70) as int
			endIf
			if stage == 1 && Animation.StageCount() == 1
				strength = 70
			endIf
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
				; Min 1.2 Ddelay
				if VoiceDelay < 1.2
					VoiceDelay = 1.2
				endIf
			endIf
			; Animation related stuffs
			if !IsCreature
				; Send SOS event
				if Animation.GetGender(position) == 0
					; Debug.SendAnimationEvent(ActorRef, "SOSFastErect")
					Debug.SendAnimationEvent(ActorRef, "SOSBend"+Animation.GetSchlong(position, stage))
				endif
				; Equip Strapon if needed
				if IsFemale && Lib.bUseStrapons && Animation.UseStrapon(position, stage)
					EquipStrapon()
				; Remove strapon if there is one
				elseIf strapon != none
					RemoveStrapon()
				endIf
				; Update animation enjoyment
				UpdateBaseEnjoyment()
			endIf
		endIf
		; Update expression/enjoyment/openmouth
		DoExpression()
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
			return ; OnTranslationComplete() will take over when in place
		endIf
		; Force angle if translation didn't rotate them properly
		if Math.Abs(ActorRef.GetAngleZ() - MarkerRef.GetAngleZ()) > 0.5; || Math.Abs(ActorRef.GetAngleX() - MarkerRef.GetAngleX()) > 0.5
			ActorRef.SetAngle(loc[3], loc[4], loc[5])
			AttachMarker()
		endIf
		; Begin very slowly rotating a small amount to hold position
		ActorRef.SplineTranslateTo(loc[0], loc[1], loc[2], loc[3], loc[4], loc[5]+0.1, 1.0, 10000, 0.0001)
	endFunction

	event OnTranslationComplete()
		Utility.Wait(0.3)
		Snap()
	endEvent
endState

state Reset
	event OnBeginState()
		; Reset to starting scale
		if ActorRef != none && ActorScale != 0.0
			ActorRef.SetScale(ActorScale)
		endIf
		; Reset actor and alias
		if ActorRef == none
			ClearAlias()
		elseIf ActorRef != none && (Controller == none || Animation == none)
			StopAnimating(true)
			UnlockActor()
			ClearAlias()
		else
			RegisterForSingleUpdate(0.1)
		endIf
	endEvent
	event OnUpdate()
		UnregisterForUpdate()
		; Reset the actor
		StopAnimating(Controller.FastEnd)
		; Reapply cum
		int cum = Animation.GetCum(position)
		if !Controller.FastEnd && cum > 0 && Lib.bUseCum && (Lib.bAllowFFCum || Controller.HasCreature || Controller.Males > 0)
			Lib.ApplyCum(ActorRef, cum)
		endIf
		; Non-Creature only
		if !IsCreature
			; Clear OpenMouth
			sslExpressionLibrary.CloseMouth(ActorRef)
			; Clear expression
			if Expression != none
				sslExpressionLibrary.ClearMFG(ActorRef)
			endIf
			; Update diary/journal stats for player + native stats for NPCs
			Lib.ActorStats.UpdateNativeStats(ActorRef, Controller.Males, Controller.Females, Controller.Creatures, Animation, Controller.VictimRef, Controller.TotalTime, Controller.HasPlayer)
			; Make flaccid for SOS
			Debug.SendAnimationEvent(ActorRef, "SOSFlaccid")
			RemoveStrapon()
			; Unstrip
			if !ActorRef.IsDead()
				Lib.UnstripActorStorage(ActorRef, IsVictim)
			endIf
		endIf
		; Unlock their movement
		UnlockActor()
		; Give AnimationEnd hooks some small room to breath
		if !Controller.FastEnd
			SexLabUtil.Wait(1.0)
		endIf
		; Free up alias slot
		ClearAlias()
	endEvent
endState

;/-----------------------------------------------\;
;|	Misc Functions                               |;
;\-----------------------------------------------/;

function OrgasmEffect()
	if Game.GetCameraState() != 3
		; Apply cum
		int cum = Animation.GetCum(position)
		if cum > 0 && Lib.bUseCum && (Lib.bAllowFFCum || Controller.HasCreature || Controller.Males > 0)
			Lib.ApplyCum(ActorRef, cum)
		endIf
		; Shake camera if player and not in free camera
		if IsPlayer
			Game.ShakeCamera(none, 0.75, 1.5)
		endIf
	endIf
	; Voice
	strength = 100
	VoiceDelay = 1.0
endFunction

function DoExpression()
	if IsCreature
		return
	endIf
	; Pick preset from expression and skip if empty in free camera
	if Expression != none
		int expStrength
		if IsVictim
			expStrength = GetPain()
		else
			expStrength = GetEnjoyment()
		endIf
		Expression.ApplyTo(ActorRef, expStrength, IsFemale, Animation.UseOpenMouth(Position, Stage))
	endIf
endFunction

function UpdateBaseEnjoyment()
	if IsCreature
		return
	endIf
	; Init weights
	BaseWeight = 0
	ProficencyWeight = 0
	PurityWeight = 0
	int ActorCount = Controller.ActorCount
	; Scaling purity modifier
	int PurityMod = 1 + (Purity / 2)
	; Adjust bonuses based on type, gender, and purity
	if Controller.Animation.HasTag("Vaginal")
		ProficencyWeight += Vaginal
		BaseWeight   += FemaleBonus  * 2
		BaseWeight   += MaleBonus    * 3
	endIf
	if Controller.Animation.HasTag("Anal")
		ProficencyWeight += Anal
		BaseWeight   += FemaleBonus  * -1
		BaseWeight   += MaleBonus    * 3
		PurityWeight += PureBonus    * -PurityMod
		PurityWeight += ImpureBonus  * PurityMod
	endIf
	if Controller.Animation.HasTag("Oral")
		ProficencyWeight += Oral
		BaseWeight   += FemaleBonus  * -1
		BaseWeight   += MaleBonus    * 3
		PurityWeight += PureBonus    * -PurityMod
		PurityWeight += ImpureBonus  * PurityMod
	endIf
	if Controller.Animation.HasTag("Dirty")
		PurityWeight += PureBonus    * (-PurityMod - 1)
		PurityWeight += ImpureBonus  * PurityMod
	endIf
	if Controller.Animation.HasTag("Aggressive")
		PurityWeight += PureBonus    * (-PurityMod - 3)
	endIf
	if Controller.Animation.HasTag("Loving")
		PurityWeight += PureBonus    * (PurityMod + 1)
	endIf
	if Controller.Animation.IsCreature
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
endFunction

int function GetEnjoyment()
	if IsCreature
		return ((Stage as float / Animation.StageCount as float) * 100.0) as int
	endIf
	; Ramp up with stage and time spent, maxout time bonus at 2.5 minutes (8 seconds * 19 intervals = 152 seconds == ~2.5 minutes)
	; Calculate root enjoyment of the animation, give multipler by progress through the animation stages (1/5 stage = 1.20 multiplier)
	Enjoyment = (((Clamp(((Controller.TotalTime / 8.0) as int), 19) + (4 * Controller.Stage) + BaseWeight + PurityWeight + (ProficencyWeight * 3)) as float) * ((Stage as float / Animation.StageCount as float) + 1.0)) as int
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
	bool[] boolDel
	StripOverride = boolDel
	; Reset state
	GoToState("")
endFunction

function SyncThread(bool force = false)
	Debug.TraceStack("SexLab -- ERROR: ActorAlias -- "+ActorName+" -- SyncThread() called from wrong state, you probably have really bad script lag from a heavily modded game, a slow computer, or something is horribly wrong.")
endFunction
function AttachMarker()
	Debug.TraceStack("SexLab -- ERROR: ActorAlias -- "+ActorName+" -- AttachMarker() called from wrong state, you are either rushing through the animation or something is wrong. This can usually be ignored if seen after animation has recently ended.")
endFunction
function AlignTo(float[] offsets, bool forceTo = false)
	Debug.TraceStack("SexLab -- ERROR: ActorAlias -- "+ActorName+" -- AlignTo() called from wrong state, you are either rushing through the animation or something is wrong. This can usually be ignored if seen after animation has recently ended.")
endfunction
function Snap()
	Debug.TraceStack("SexLab -- ERROR: ActorAlias -- "+ActorName+" -- Snap() called from wrong state, you are either rushing through the animation or something is wrong. This can usually be ignored if seen after animation has recently ended.")
endFunction
event OnTranslationComplete()
	Debug.TraceStack("SexLab -- ERROR: ActorAlias -- "+ActorName+" -- OnTranslationComplete() triggered from wrong state, you have another mod translating the actor or are rushing through the animation, or something is wrong. This can usually be ignored.")
endEvent
