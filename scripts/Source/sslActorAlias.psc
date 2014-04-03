scriptname sslActorAlias extends ReferenceAlias

; Libraries
sslActorLibrary Lib
sslActorStats Stats
sslSystemConfig Config

; Actor Info
Actor property ActorRef auto hidden
int property Gender auto hidden
bool IsMale
bool IsFemale
bool IsCreature
bool IsVictim
bool IsPlayer
bool IsStraight
string ActorName
ActorBase BaseRef
int BaseSex

; Current Thread state
sslThreadController Thread
int Position
int Stage

; Animation
sslBaseAnimation Animation

; Voice
sslBaseVoice Voice
VoiceType ActorVoice
bool IsForcedSilent
float VoiceDelay

; Expression
sslBaseExpression Expression

; Positioning
ObjectReference MarkerRef
float[] Offsets
float[] Loc

; Storage
int[] Flags
bool[] StripOverride
float ActorScale
float AnimScale
form Strapon

; Stats
float[] Skills
int Enjoyment

; Animation Position/Stage flags
bool property OpenMouth hidden
	bool function get()
		return Flags[1] == 1
	endFunction
endProperty
bool property IsSilent hidden
	bool function get()
		return Voice == none || IsForcedSilent || IsCreature || Flags[0] == 1 || Flags[1] == 1
	endFunction
endProperty
bool property UseStrapon hidden
	bool function get()
		return Flags[2] == 1 && Flags[4] == 0
	endFunction
endProperty
int property Schlong hidden
	int function get()
		return Flags[3]
	endFunction
endProperty
bool property MalePosition hidden
	bool function get()
		return Flags[4] == 0
	endFunction
endProperty

; ------------------------------------------------------- ;
; --- Load/Clear Alias For Use                        --- ;
; ------------------------------------------------------- ;

function ClearAlias()
	; Set libraries
	Thread = GetOwningQuest() as sslThreadController
	Lib    = Thread.ActorLib
	Stats  = Thread.Stats
	Config = Thread.Config
	; Make sure actor is reset
	if GetReference() != none
		Thread.Log("Had actor '"+GetReference()+"' during clear!", self)
		; Init variables needed for reset
		ActorRef   = GetReference() as Actor
		BaseRef    = ActorRef.GetLeveledActorBase()
		IsPlayer   = ActorRef == Game.GetPlayer()
		IsCreature = Gender == Lib.GetGender(ActorRef)
		; Reset actor back to default
		RestoreActorDefaults()
		StopAnimating(true)
		UnlockActor()
	endIf
	Initialize()
endFunction

bool function SlotActor(Actor ProspectRef)
	if ProspectRef == none || !ForceRefIfEmpty(ProspectRef)
		return false ; Failed to set prospective actor into alias
	endIf
	; Register actor as active
	StorageUtil.FormListAdd(none, "SexLab.ActiveActors", ActorRef, false)
	; Init actor alias information
	ActorRef   = ProspectRef
	BaseRef    = ActorRef.GetLeveledActorBase()
	ActorName  = BaseRef.GetName()
	BaseSex    = BaseRef.GetSex()
	Gender     = Lib.GetGender(ActorRef)
	IsMale     = Gender == 0
	IsFemale   = Gender == 1
	IsCreature = Gender == 2
	IsPlayer   = ActorRef == Lib.PlayerRef
	ActorVoice = ActorRef.GetVoiceType()
	; Notify thread of actors genders
	Thread.Genders[Gender] = Thread.Genders[Gender] + 1
	; Get ready for mod events
	string eid = "SSL_"+Thread.tid+"_"
	RegisterForModEvent(eid+"Prepare", "PrepareActor")
	RegisterForModEvent(eid+"Reset", "ResetActor")
	RegisterForModEvent(eid+"Orgasm", "OrgasmEffect")
	; Ready
	Thread.Log("Slotted '"+ActorName+"'", self)
	GoToState("Ready")
	return true
endFunction

; ------------------------------------------------------- ;
; --- Actor Prepartion                                --- ;
; ------------------------------------------------------- ;

state Ready
	function PrepareActor()
		; Remove any unwanted combat effects
		ActorRef.StopCombat()
		if ActorRef.IsWeaponDrawn()
			ActorRef.SheatheWeapon()
		endIf
		LockActor()
		; Sync thread information
		Animation  = Thread.Animation
		Stage      = Thread.Stage
		Position   = Thread.Positions.Find(ActorRef)
		Flags      = Animation.GetPositionFlags(Position, Stage)
		VoiceDelay = Config.GetVoiceDelay(IsFemale, Stage, IsSilent)
		; Calculate scales
		float display = ActorRef.GetScale()
		ActorRef.SetScale(1.0)
		float base = ActorRef.GetScale()
		ActorScale = ( display / base )
		AnimScale = ActorScale
		ActorRef.SetScale(ActorScale)
		if Thread.ActorCount > 1 && Config.bScaleActors
			AnimScale = (1.0 / base)
		endIf
		; Non Creatures
		if !IsCreature
			; Pick a strapon on females to use
			if IsFemale && Config.bUseStrapons && Lib.Strapons.Length > 0
				Strapon = Lib.Strapons[Utility.RandomInt(0, (Lib.Strapons.Length - 1))]
				ActorRef.AddItem(Strapon, 1, true)
			endIf
			; Strip actor
			Lib.CacheStrippable(ActorRef)
			Strip(DoUndress)
			; Pick a voice if needed
			if Voice == none && !IsForcedSilent
				SetVoice(Lib.VoiceSlots.PickGender(BaseSex), IsForcedSilent)
			endIf
			; Pick an expression if needed
			if Expression == none && Config.bUseExpressions
				Expression = Lib.ExpressionSlots.PickExpression(((IsVictim as int) + (Thread.IsAggressive as int)))
			endIf
			; Check for heterosexual preference
			IsStraight = Stats.IsStraight(ActorRef)
			Actor SkilledActor = ActorRef
			; Always use players stats if present, so players stats mean something more for npcs
			if !IsPlayer && Thread.HasPlayer
				SkilledActor = Thread.PlayerRef
			; If a non-creature couple, base skills off partner
			elseIf Thread.ActorCount == 2 && !Thread.HasCreature
				SkilledActor = Thread.Positions[sslUtility.IndexTravel(Position, Thread.ActorCount)]
			endIf
			Skills = Stats.GetSkillLevels(SkilledActor)
		endIf
		; Start Auto TFC if enabled
		if IsPlayer && Config.bAutoTFC
			Config.ToggleFreeCamera()
		endIf
		; Make SOS erect
		; Debug.SendAnimationEvent(ActorRef, "SOSFastErect")
		; Enter animatable state
		GoToState("Animating")
	endFunction

	bool function SlotActor(Actor ProspectRef)
		return false
	endFunction
endState

; ------------------------------------------------------- ;
; --- Animation Loop                                  --- ;
; ------------------------------------------------------- ;

state Animating

	function StartAnimating()
		RegisterForSingleUpdate(Utility.RandomFloat(1.0, 6.0))
	endFunction

	event OnUpdate()
		; Check if still amonst the living and able.
		if ActorRef.IsDead() || ActorRef.IsDisabled()
			Thread.EndAnimation(true)
			return
		endIf
		; Sync enjoyment level
		GetEnjoyment()
		; Apply Expression / sync enjoyment
		if !IsCreature && Expression != none && !OpenMouth
			Expression.Apply(ActorRef, Enjoyment, BaseSex)
		endIf
		; Moan if not silent
		if !IsSilent
			Voice.Moan(ActorRef, Enjoyment, IsVictim, Config.bUseLipSync)
		endIf
		; Loop
		RegisterForSingleUpdate(VoiceDelay)
	endEvent

	function SyncThread()
		; Sync thread information
		Animation  = Thread.Animation
		Stage      = Thread.Stage
		Position   = Thread.Positions.Find(ActorRef)
		Flags      = Animation.GetPositionFlags(Position, Stage)
		VoiceDelay = Config.GetVoiceDelay(IsFemale, Stage, IsSilent)
		; Creature skipped
		if !IsCreature
			; Equip Strapon if needed and enabled
			if Strapon != none
				if UseStrapon && !ActorRef.IsEquipped(Strapon)
					ActorRef.EquipItem(Strapon, true, true)
				elseif !UseStrapon && ActorRef.IsEquipped(Strapon)
					ActorRef.UnequipItem(Strapon, true, true)
				endIf
			endIf
			; Open mouth if needed
			if OpenMouth
				if Expression != none
					MfgConsoleFunc.ResetPhonemeModifier(ActorRef)
				endIf
				ActorRef.SetExpressionOverride(16, 100)
			endIf
		endIf
		; Send schlong offset
		if MalePosition
			Debug.SendAnimationEvent(ActorRef, "SOSBend"+Schlong)
		endIf
	endFunction

	function UpdateOffsets()
		SyncLocation(true)
	endFunction

	function SyncLocation(bool Force = false)
		Offsets = Animation.GetPositionOffsets(Thread.AdjustKey, Position, Stage)
		float[] CenterLoc = Thread.CenterLocation
		Loc[0] = CenterLoc[0] + ( Math.sin(CenterLoc[5]) * Offsets[0] ) + ( Math.cos(CenterLoc[5]) * Offsets[1] )
		Loc[1] = CenterLoc[1] + ( Math.cos(CenterLoc[5]) * Offsets[0] ) + ( Math.sin(CenterLoc[5]) * Offsets[1] )
		Loc[2] = CenterLoc[2] + Offsets[2]
		Loc[3] = CenterLoc[3]
		Loc[4] = CenterLoc[4]
		Loc[5] = CenterLoc[5] + Offsets[3]
		if Loc[5] >= 360.0
			Loc[5] = Loc[5] - 360.0
		elseIf Loc[5] < 0.0
			Loc[5] = Loc[5] + 360.0
		endIf
		MarkerRef.SetPosition(Loc[0], Loc[1], Loc[2])
		MarkerRef.SetAngle(Loc[3], Loc[4], Loc[5])
		if Force
			ActorRef.SetPosition(Loc[0], Loc[1], Loc[2])
			ActorRef.SetAngle(Loc[3], Loc[4], Loc[5])
		endIf
		ActorRef.SetVehicle(MarkerRef)
		ActorRef.SetScale(AnimScale)
		Snap()
	endFunction

	function Snap()
		; Quickly move into place and angle if actor is off by a lot
		float distance = ActorRef.GetDistance(MarkerRef)
		if distance > 9.0 || ((Math.Abs(ActorRef.GetAngleZ() - MarkerRef.GetAngleZ())) > 0.50)
			ActorRef.SetPosition(Loc[0], Loc[1], Loc[2])
			ActorRef.SetAngle(Loc[3], Loc[4], Loc[5])
			ActorRef.SetVehicle(MarkerRef)
			ActorRef.SetScale(AnimScale)
		elseIf distance > 0.8
			ActorRef.SplineTranslateTo(Loc[0], Loc[1], Loc[2], Loc[3], Loc[4], Loc[5], 1.0, 50000, 0)
			return ; OnTranslationComplete() will take over when in place
		endIf
		; Begin very slowly rotating a small amount to hold position
		ActorRef.SplineTranslateTo(Loc[0], Loc[1], Loc[2], Loc[3], Loc[4], Loc[5]+0.01, 1.0, 10000, 0.0001)
	endFunction

	event OnTranslationComplete()
		; Thread.Log(ActorName+" - Completed Translation")
		Utility.Wait(0.50)
		Snap()
	endEvent

	function OrgasmEffect()
		; Apply cum
		int CumID = Animation.GetCum(Position)
		if CumID > 0 && Config.bUseCum && (Thread.Males > 0 || Config.bAllowFFCum || Thread.HasCreature)
			Lib.ApplyCum(ActorRef, CumID)
		endIf
		; Play OrgasmSFX
		Lib.ThreadLib.OrgasmFX.Play(ActorRef)
		; Shake camera for player
		if IsPlayer && Game.GetCameraState() != 3
			Game.ShakeCamera(none, 0.75, 1.5)
		endIf
		; Voice
		VoiceDelay = 0.8
	endFunction

	event ResetActor()
		bool Quick = Thread.FastEnd
		; Restore scale and voicetype
		RestoreActorDefaults()
		; Apply cum
		int CumID = Animation.GetCum(Position)
		if !Quick && CumID > 0 && Config.bUseCum && (Thread.Males > 0 || Config.bAllowFFCum || Thread.HasCreature)
			Lib.ApplyCum(ActorRef, CumID)
		endIf
		; Stop animating
		StopAnimating(Quick)
		Debug.SendAnimationEvent(ActorRef, "SOSFlaccid")
		; Unstrip
		if !ActorRef.IsDead()
			Lib.UnstripStored(ActorRef, IsVictim)
		endIf
		; Remove strapon
		if Strapon != none
			ActorRef.UnequipItem(Strapon, true, true)
			ActorRef.RemoveItem(Strapon, 1, true)
		endIf
		; Unlock movements
		UnlockActor()
		; Update stats
		if !IsCreature
			int[] Genders = Thread.Genders
			Stats.AddSex(ActorRef, Thread.TotalTime, Thread.HasPlayer, Genders[0], Genders[1], Genders[2])
			float[] SkillXP = Thread.SkillXP
			Stats.AddSkillXP(ActorRef, SkillXP[0], SkillXP[1], SkillXP[2], SkillXP[3])
			Stats.AddPurityXP(ActorRef, Skills[4], SkillXP[5], Thread.IsAggressive, IsVictim, Genders[2] > 0, Thread.ActorCount, Thread.GetHighestPresentRelationshipRank(ActorRef))
		endIf
		; Reset alias
		Initialize()
		TryToClear()
	endEvent

endState

; ------------------------------------------------------- ;
; --- Actor Manipulation                              --- ;
; ------------------------------------------------------- ;

function StopAnimating(bool Quick = false)
	if ActorRef == none
		return
	endIf
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
		ActorRef.PushActorAway(ActorRef, 0.75)
	else
		; Reset NPC/PC Idle Quickly
		Debug.SendAnimationEvent(ActorRef, "IdleForceDefaultState")
		; Ragdoll NPC/PC if enabled and not in TFC
		if !Quick && DoRagdoll && (!IsPlayer || (IsPlayer && Game.GetCameraState() != 3))
			ActorRef.StopTranslation()
			ActorRef.SetPosition(Loc[0], Loc[1], Loc[2])
			ActorRef.SetAngle(Loc[3], Loc[4], Loc[5])
			ActorRef.PushActorAway(ActorRef, 0.75)
		endIf
	endIf
endFunction

function LockActor()
	if ActorRef == none
		return
	endIf
	; Stop whatever they are doing
	Debug.SendAnimationEvent(ActorRef, "IdleForceDefaultState")
	; Start DoNothing package
	ActorRef.SetFactionRank(Lib.AnimatingFaction, 1)
	ActorUtil.AddPackageOverride(ActorRef, Lib.DoNothing, 100, 1)
	ActorRef.EvaluatePackage()
	; Disable movement
	if IsPlayer
		Game.ForceThirdPerson()
		Game.DisablePlayerControls(false, false, false, false, false, false, true, false, 0)
		Game.SetPlayerAIDriven()
		; Enable hotkeys, if needed
		if IsVictim && Config.bDisablePlayer
			Thread.AutoAdvance = true
		else
			Thread.EnableHotkeys()
		endIf
	else
		; ActorRef.SetRestrained(true)
		ActorRef.SetDontMove(true)
	endIf
	; Attach positioning marker
	if !MarkerRef
		MarkerRef = ActorRef.PlaceAtMe(Lib.BaseMarker)
	endIf
	MarkerRef.Enable()
	MarkerRef.MoveTo(ActorRef)
	ActorRef.StopTranslation()
	ActorRef.SetVehicle(MarkerRef)
endFunction

function UnlockActor()
	if ActorRef == none
		return
	endIf
	; Detach positioning marker
	ActorRef.StopTranslation()
	ActorRef.SetVehicle(none)
	; Remove from animation faction
	ActorRef.RemoveFromFaction(Lib.AnimatingFaction)
	ActorUtil.RemovePackageOverride(ActorRef, Lib.DoNothing)
	ActorRef.EvaluatePackage()
	; Enable movement
	if IsPlayer
		Thread.DisableHotkeys()
		Game.EnablePlayerControls()
		Game.SetPlayerAIDriven(false)
		; Disable free camera, if in it
		if Game.GetCameraState() == 3
			MiscUtil.ToggleFreeCamera()
		endIf
	else
		ActorRef.SetDontMove(false)
	endIf
endFunction

function RestoreActorDefaults()
	if ActorRef == none
		return
	endIf
	; Reset to starting scale
	if ActorScale != 0.0
		ActorRef.SetScale(ActorScale)
	endIf
	; Reset voice type
	if ActorVoice != none
		BaseRef.SetVoiceType(ActorVoice)
	endIf
	; Enable player controls
	if ActorRef == Lib.PlayerRef
		Thread.DisableHotkeys()
	endIf
	; Reset expression
	ActorRef.ClearExpressionOverride()
	if Expression != none
		MfgConsoleFunc.ResetPhonemeModifier(ActorRef)
	endIf
endFunction

; ------------------------------------------------------- ;
; --- Data Accessors                                  --- ;
; ------------------------------------------------------- ;

function MakeVictim(bool Victimize = true)
	IsVictim = Victimize
	if Victimize
		Thread.VictimRef    = ActorRef
		Thread.IsAggressive = true
	endIf
endFunction

function SetVoice(sslBaseVoice ToVoice = none, bool ForceSilence = false)
	IsForcedSilent = ForceSilence
	if ToVoice != none
		Voice = ToVoice
		Voice.SetVoice(BaseRef)
	endIf
endFunction

sslBaseVoice function GetVoice()
	return Voice
endFunction

function SetExpression(sslBaseExpression ToExpression)
	if ToExpression != none
		Expression = ToExpression
	endIf
endFunction

sslBaseExpression function GetExpression()
	return Expression
endFunction

int function GetEnjoyment()
	; First actor pings thread to update skill xp
	if Position == 0
		Thread.RecordSkills()
	endIf
	; Base enjoyment from sex skills and total runtime
	Enjoyment = Thread.GetSkillBonus(Skills) as int
	; Gender bonuses
	if IsFemale
		Enjoyment += 9 * (Thread.IsVaginal as int)
		Enjoyment += 6 * (Thread.IsAnal as int)
		Enjoyment += 7 * (Thread.IsOral as int)
	else
		Enjoyment += 8 * (Thread.IsVaginal as int)
		Enjoyment += 8 * (Thread.IsAnal as int)
		Enjoyment += 7 * (Thread.IsOral as int)
	endIf
	; Actor is outside sexuality comfort zone
	if IsStraight
		if (IsFemale && Thread.Females > 1) || (!IsFemale && Thread.Males > 1)
			Enjoyment -= 7
		elseIf (IsFemale && MalePosition) || (!IsFemale && !MalePosition)
			Enjoyment -= 5
		endIf
	endIf
	; Actor is victim/agressor
	if Thread.IsAggressive
		if IsVictim
			Enjoyment = Enjoyment / 2
		else
			Enjoyment += 8
		endIf
	endIf
	; Set final enjoyment
	Enjoyment = ((Enjoyment as float) * (Stage as float / Animation.StageCount as float)) as int
	Thread.Log("Enjoyment = "+Enjoyment, ActorName)
	return Enjoyment
endFunction

int function GetPain()
	float Pain = Math.Abs(100.0 - sslUtility.ClampFloat(GetEnjoyment() as float, 1.0, 99.0))
	if IsVictim
		return (Pain * 1.5) as int
	endIf
	return (Pain * 0.5) as int
endFunction

function EquipStrapon()
	if Strapon != none && !ActorRef.IsEquipped(Strapon)
		ActorRef.EquipItem(Strapon, true, true)
	endIf
endFunction

function UnequipStrapon()
	if Strapon != none && ActorRef.IsEquipped(Strapon)
		ActorRef.UnequipItem(Strapon, true, true)
	endIf
endFunction

function OverrideStrip(bool[] SetStrip)
	if SetStrip.Length != 33
		Thread.Log(ActorName+" -- Invalid strip bool override array given. Must be length 33; was given "+SetStrip.Length, "ERROR")
	else
		StripOverride = SetStrip
	endIf
endFunction

function Strip(bool DoAnimate = true)
	if ActorRef != none && !IsCreature
		if StripOverride.Length != 33
			; Default slots
			Lib.StripSlots(ActorRef, Config.GetStrip(IsFemale, Thread.LeadIn, Thread.IsAggressive, IsVictim), DoAnimate)
		else
			; Custom slots
			Lib.StripSlots(ActorRef, StripOverride, DoAnimate)
		endIf
		; Only allow once, unless overwritten
		NoUndress = true
	endIf
endFunction

bool NoRagdoll
bool property DoRagdoll hidden
	bool function get()
		if NoRagdoll
			return false
		endIf
		return !NoRagdoll && Config.bRagDollEnd
	endFunction
	function set(bool value)
		NoRagdoll = !value
	endFunction
endProperty

bool NoUndress
bool property DoUndress hidden
	bool function get()
		if NoUndress
			return false
		endIf
		return Config.bUndressAnimation
	endFunction
	function set(bool value)
		NoUndress = !value
	endFunction
endProperty

; ------------------------------------------------------- ;
; --- System Use                                      --- ;
; ------------------------------------------------------- ;

function Initialize()
	GoToState("")
	UnregisterForUpdate()
	; Clear the alias of actor
	TryToClear()
	; Free actor for selection
	if ActorRef != none
		StorageUtil.FormListRemove(none, "SexLab.ActiveActors", ActorRef, true)
	endIf
	; Delete positioning marker
	if MarkerRef
		MarkerRef.Disable()
		MarkerRef.Delete()
	endIf
	; Forms
	ActorRef       = none
	MarkerRef      = none
	Strapon        = none
	; Voice
	Voice          = none
	ActorVoice     = none
	IsForcedSilent = false
	; Expression
	Expression     = none
	; Flags
	NoRagdoll      = false
	NoUndress      = false
	; Floats
	ActorScale     = 0.0
	AnimScale      = 0.0
	; Storage
	bool[] bDel1
	StripOverride  = bDel1
	Loc            = new float[6]
endFunction

; event OnInit()
; 	Thread = (GetOwningQuest() as sslThreadController)
; 	Lib = (Quest.GetQuest("SexLabQuestFramework") as sslActorLibrary)
; 	Config = (Quest.GetQuest("SexLabQuestFramework") as sslSystemConfig)
; endEvent

; ------------------------------------------------------- ;
; --- State Restricted                                --- ;
; ------------------------------------------------------- ;

; Ready
function PrepareActor()
endFunction
; Animating
function StartAnimating()
endFunction

function SyncThread()
endFunction
function UpdateOffsets()
endFunction
function SyncLocation(bool Force = false)
endFunction
function Snap()
endFunction
event OnTranslationComplete()
endEvent
function OrgasmEffect()
endFunction
event ResetActor()
endEvent
event OnOrgasm()
endEvent
