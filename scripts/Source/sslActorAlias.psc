scriptname sslActorAlias extends sslSystemAlias

import sslUtility
import sslActorLibrary
import StorageUtil

; Actor Info
Actor property ActorRef auto hidden
int property Gender auto hidden
bool IsMale
bool IsFemale
bool IsCreature
bool IsVictim
bool IsPlayer
string ActorName
ActorBase BaseRef
int BaseSex

; Current Thread state
sslThreadController Thread
int Position
int Stage

; Animation
sslBaseAnimation Animation
string AdjustKey

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
form[] Equipment
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

bool function SetActor(Actor ProspectRef, bool Victimize = false, sslBaseVoice UseVoice = none, bool ForceSilent = false)
	if ProspectRef == none || ProspectRef != GetReference()
		return false ; Failed to set prospective actor into alias
	endIf
	; Init actor alias information
	ActorRef   = ProspectRef
	BaseRef    = ActorRef.GetLeveledActorBase()
	ActorName  = BaseRef.GetName()
	BaseSex    = BaseRef.GetSex()
	Gender     = ActorLib.GetGender(ActorRef)
	IsMale     = Gender == 0
	IsFemale   = Gender == 1
	IsCreature = Gender == 2
	IsVictim   = Victimize
	IsPlayer   = ActorRef == PlayerRef
	ActorVoice = BaseRef.GetVoiceType()
	Loc        = new float[6]
	if !IsCreature
		SetVoice(UseVoice, ForceSilent)
		if !IsPlayer
			Stats.SeedActor(ActorRef)
		endIf
	endIf
	; Get ready for mod events
	string e = Thread.Key("")
	RegisterForModEvent(e+"Prepare", "PrepareActor")
	RegisterForModEvent(e+"Reset", "ResetActor")
	RegisterForModEvent(e+"Sync", "SyncActor")
	RegisterForModEvent(e+"Orgasm", "OrgasmEffect")
	RegisterForModEvent(e+"Strip", "Strip")
	; Ready
	Log("Slotted '"+ActorName+"'", self)
	GoToState("Ready")
	return true
endFunction

function ClearAlias()
	; Maybe got here prematurely, give it 10 seconds before forcing the clear
	float Failsafe = Utility.GetCurrentRealTime() + 10.0
	while GetState() == "Resetting" && Utility.GetCurrentRealTime() < Failsafe
		Utility.Wait(0.2)
	endWhile
	; Remove events
	ClearEvents()
	; Make sure actor is reset
	if GetReference() != none
		; Init variables needed for reset
		ActorRef   = GetReference() as Actor
		BaseRef    = ActorRef.GetLeveledActorBase()
		ActorName  = BaseRef.GetName()
		BaseSex    = BaseRef.GetSex()
		Gender     = ActorLib.GetGender(ActorRef)
		IsMale     = Gender == 0
		IsFemale   = Gender == 1
		IsCreature = Gender == 2
		IsPlayer   = ActorRef == PlayerRef
		Log("'"+ActorName+"' / '"+ActorRef+"' present during alias clear! This is usually harmless as the alias and actor will correct itself, but is usually a sign that a thread did not close cleanly.", self)
		; Reset actor back to default
		RestoreActorDefaults()
		StopAnimating(true)
		UnlockActor()
		Unstrip()
	endIf
	TryToClear()
	Initialize()
endFunction

function ClearEvents()
	GoToState("")
	UnregisterForUpdate()
	string e = Thread.Key("")
	UnregisterForModEvent(e+"Prepare")
	UnregisterForModEvent(e+"Reset")
	UnregisterForModEvent(e+"Sync")
	UnregisterForModEvent(e+"Orgasm")
	UnregisterForModEvent(e+"Strip")
endFunction

; ------------------------------------------------------- ;
; --- Actor Prepartion                                --- ;
; ------------------------------------------------------- ;

state Ready

	bool function SetActor(Actor ProspectRef, bool MakeVictim = false, sslBaseVoice UseVoice = none, bool ForceSilent = false)
		return false
	endFunction

	function PrepareActor()
		; Thread.Log("Preparing", ActorName)
		; Remove any unwanted combat effects
		ActorRef.StopCombat()
		if ActorRef.IsWeaponDrawn()
			ActorRef.SheatheWeapon()
		endIf
		; Calculate scales
		float display = ActorRef.GetScale()
		ActorRef.SetScale(1.0)
		float base = ActorRef.GetScale()
		ActorScale = ( display / base )
		AnimScale = ActorScale
		ActorRef.SetScale(ActorScale)
		if Thread.ActorCount > 1 && Config.ScaleActors
			AnimScale = (1.0 / base)
		endIf
		; Stop movement
		LockActor()
		; Strip non creatures
		if !IsCreature
			; Pick a strapon on females to use
			if IsFemale && Config.UseStrapons && Config.Strapons.Length > 0
				Strapon = Config.GetStrapon()
				ActorRef.AddItem(Strapon, 1, true)
			endIf
			; Strip actor
			Strip()
			; Pick a voice if needed
			if Voice == none && !IsForcedSilent
				SetVoice(VoiceSlots.PickVoice(ActorRef), IsForcedSilent)
			endIf
			; Pick an expression if needed
			if Expression == none && Config.UseExpressions
				Expression = ExpressionSlots.PickExpression(ActorRef, Thread.VictimRef)
			endIf
			; Always use players stats if present, so players stats mean something more for npcs
			Actor SkilledActor = ActorRef
			if !IsPlayer && Thread.HasPlayer
				SkilledActor = PlayerRef
			; If a non-creature couple, base skills off partner
			elseIf Thread.ActorCount == 2 && !Thread.HasCreature
				SkilledActor = Thread.Positions[IndexTravel(Thread.Positions.Find(ActorRef), Thread.ActorCount)]
			endIf
			Skills = Stats.GetSkillLevels(SkilledActor)
			; Thread.Log(SkilledActor.GetLeveledActorBase().GetName()+" Skills: "+Skills, ActorName)
			; Start Auto TFC if enabled
			if IsPlayer && Config.AutoTFC && Game.GetCameraState() != 3
				Config.ToggleFreeCamera()
			endIf
		endIf
		; Enter animatable state - rest is non vital and can finish as queued
		Debug.SendAnimationEvent(ActorRef, "IdleForceDefaultState")
		Debug.SendAnimationEvent(ActorRef, "SOSFastErect")
		GoToState("Animating")
		Thread.AliasEventDone("Prepare")
	endFunction
endState

; ------------------------------------------------------- ;
; --- Animation Loop                                  --- ;
; ------------------------------------------------------- ;

state Animating

	function StartAnimating()
		; Position / fix SOS side bend
		Utility.Wait(0.2)
		SyncThread()
		SyncLocation(true)
		ActorRef.StopTranslation()
		ActorRef.SplineTranslateTo(Loc[0], Loc[1], Loc[2], Loc[3], Loc[4], Loc[5], 1.0, 50000, 0)
		; Start update loop
		RegisterForSingleUpdate(Utility.RandomFloat(1.5, 3.0))
	endFunction

	event OnUpdate()
		; Check if still amonst the living and able.
		if ActorRef.IsDead() || ActorRef.IsDisabled()
			Thread.EndAnimation(true)
			return
		endIf
		; Ping thread to update skill xp
		if Position == 0
			Thread.RecordSkills()
		endIf
		; Sync enjoyment level
		GetEnjoyment()
		; Apply Expression / sync enjoyment
		if !IsCreature && Expression != none && !OpenMouth
			Expression.Apply(ActorRef, Enjoyment, BaseSex)
		endIf
		; Moan if not silent
		if !IsSilent
			Voice.Moan(ActorRef, Enjoyment, IsVictim)
		endIf
		; Loop
		RegisterForSingleUpdate(VoiceDelay)
	endEvent

	function SyncActor()
		SyncThread()
		SyncLocation(false)
		Thread.AliasEventDone("Sync")
	endFunction

	function SyncThread()
		; Sync thread information
		Animation  = Thread.Animation
		Stage      = Thread.Stage
		Position   = Thread.Positions.Find(ActorRef)
		AdjustKey  = Thread.AdjustKey
		Flags      = Animation.GetPositionFlags(AdjustKey, Position, Stage)
		VoiceDelay = Config.GetVoiceDelay(IsFemale, Stage, IsSilent)
		; Creature skipped
		if !IsCreature
			; Sync enjoyment level
			GetEnjoyment()
			; Equip Strapon if needed and enabled
			if Strapon != none
				if UseStrapon && !ActorRef.IsEquipped(Strapon)
					ActorRef.EquipItem(Strapon, true, true)
				elseif !UseStrapon && ActorRef.IsEquipped(Strapon)
					ActorRef.UnequipItem(Strapon, true, true)
				endIf
			endIf
			; Clear any existing expression as a default - to remove open mouth
			ActorRef.ClearExpressionOverride()
			if OpenMouth
				; Open mouth if needed
				sslBaseExpression.OpenMouth(ActorRef)
			elseIf Expression != none
				; Apply expression otherwise - overrides open mouth
				Expression.Apply(ActorRef, Enjoyment, BaseSex)
			else
				; No expression to override but mouth might be open - close it
				sslBaseExpression.CloseMouth(ActorRef)
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
		Offsets = Animation.GetPositionOffsets(AdjustKey, Position, Stage)
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
		ActorRef.SplineTranslateTo(Loc[0], Loc[1], Loc[2], Loc[3], Loc[4], Loc[5]+0.001, 1.0, 10000, 0.0001)
	endFunction

	event OnTranslationComplete()
		; Thread.Log(ActorName+" - Completed Translation")
		Utility.Wait(0.50)
		Snap()
	endEvent

	function OrgasmEffect()
		; Apply cum
		int CumID = Animation.GetCum(Position)
		if CumID > 0 && Config.UseCum && (Thread.Males > 0 || Config.AllowFFCum || Thread.HasCreature)
			ActorLib.ApplyCum(ActorRef, CumID)
		endIf
		; Moan if not silent
		if !IsSilent
			Voice.Moan(ActorRef, 100, IsVictim)
		endIf
		; Shake camera for player
		if IsPlayer && Game.GetCameraState() != 3
			Game.ShakeCamera(none, 0.75, 1.5)
		endIf
		; Play OrgasmSFX
		Config.OrgasmFX.Play(ActorRef)
		; Voice
		VoiceDelay = 0.8
	endFunction

	event ResetActor()
		GoToState("Resetting")
		UnregisterForUpdate()
		string e = Thread.Key("")
		UnregisterForModEvent(e+"Prepare")
		UnregisterForModEvent(e+"Reset")
		UnregisterForModEvent(e+"Sync")
		UnregisterForModEvent(e+"Orgasm")
		UnregisterForModEvent(e+"Strip")
		; Update stats
		if !IsCreature
			int[] Genders = Thread.Genders
			float[] SkillXP = Thread.SkillXP
			Stats.AddSkillXP(ActorRef, SkillXP[0], SkillXP[1], SkillXP[2], SkillXP[3])
			Stats.AddPurityXP(ActorRef, Skills[4], SkillXP[5], Thread.IsAggressive, IsVictim, Genders[2] > 0, Thread.ActorCount, Thread.GetHighestPresentRelationshipRank(ActorRef))
			Stats.AddSex(ActorRef, Thread.TotalTime, Thread.HasPlayer, Thread.IsAggressive, Genders[0], Genders[1], Genders[2])
		endIf
		if IsPlayer && Game.GetCameraState() == 3
			Config.ToggleFreeCamera()
		endIf
		; Apply cum
		int CumID = Animation.GetCum(Position)
		if !Thread.FastEnd && CumID > 0 && Config.UseCum && (Thread.Males > 0 || Config.AllowFFCum || Thread.HasCreature)
			ActorLib.ApplyCum(ActorRef, CumID)
		endIf
		; Restore actor to starting point
		RestoreActorDefaults()
		StopAnimating(Thread.FastEnd)
		UnlockActor()
		; Unstrip items in storage, if any
		if !ActorRef.IsDead()
			Unstrip()
		endIf
		; Reset alias
		TryToClear()
		Initialize()
		Thread.AliasEventDone("Reset")
	endEvent

	int function GetEnjoyment()
		if IsCreature
			Enjoyment = (ClampFloat(Thread.TotalTime / 6.0, 0.0, 40.0) + ((Stage as float / Animation.StageCount as float) * 60.0)) as int
			return Enjoyment
		endIf
		; First actor pings thread to update skill xp
		float[] XP = Thread.GetSkillBonus()
		; Gender skill bonuses
		if IsFemale
			XP[0] = ((XP[0] > 0.0) as int) * (XP[0] + (Skills[0] * 1.3)) ; Foreplay
			XP[1] = ((XP[1] > 0.0) as int) * (XP[1] + (Skills[1] * 1.6)) ; Vaginal
			XP[2] = ((XP[2] > 0.0) as int) * (XP[2] + (Skills[2] * 1.3)) ; Anal
			XP[3] = ((XP[3] > 0.0) as int) * (XP[3] + (Skills[3] * 1.2)) ; Oral
		else
			XP[0] = ((XP[0] > 0.0) as int) * (XP[0] + (Skills[0] * 1.1)) ; Foreplay
			XP[1] = ((XP[1] > 0.0) as int) * (XP[1] + (Skills[1] * 1.5)) ; Vaginal
			XP[2] = ((XP[2] > 0.0) as int) * (XP[2] + (Skills[2] * 1.5)) ; Anal
			XP[3] = ((XP[3] > 0.0) as int) * (XP[3] + (Skills[3] * 1.5)) ; Oral
		endIf
		; Purity Bonuses
		XP[4] = XP[4] + (Skills[4] * 1.5)
		XP[5] = XP[5] + (Skills[5] * 1.5)
		; Get base totals
		float SkillBonus  = ClampFloat((XP[0] + XP[1] + XP[2] + XP[3]), 0, 35.0)
		float PurityBonus = ClampFloat((XP[4] + XP[5]), 0.0, 15.0)
		float TimeBonus   = ClampFloat(Thread.TotalTime / 9.0, 0.0, 20.0)
		float StageBonus  = (Stage as float / Animation.StageCount as float) * 45.0
		; Actor is victim/agressor
		if Thread.IsAggressive
			if IsVictim
				StageBonus = 0.0
				SkillBonus *= 1.1
			else
				StageBonus *= 1.3
				SkillBonus *= 0.5
			endIf
		endIf
		; Keep leadin numbers lower
		if Thread.LeadIn
			SkillBonus  *= 0.5
			TimeBonus   *= 0.8
			StageBonus  *= 0.8
		endIf
		; Set final enjoyment
		Enjoyment = (SkillBonus + PurityBonus + StageBonus + TimeBonus) as int
		; Log("Skill: "+SkillBonus+" PurityBonus: "+PurityBonus+" Stage: "+StageBonus+" Time: "+TimeBonus+" -- Enjoyment: "+Enjoyment, ActorName)
		return Enjoyment
	endFunction

	int function GetPain()
		float Pain = Math.Abs(100.0 - ClampFloat(GetEnjoyment() as float, 1.0, 99.0))
		if IsVictim
			return (Pain * 1.5) as int
		endIf
		return (Pain * 0.5) as int
	endFunction

endState

state Resetting
	event OnUpdate()
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
		Config.ToggleFreeCamera()
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
			ActorRef.PushActorAway(ActorRef, 0.1)
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
	ActorRef.SetFactionRank(Config.AnimatingFaction, 1)
	ActorUtil.AddPackageOverride(ActorRef, Config.DoNothing, 100, 1)
	ActorRef.EvaluatePackage()
	; Disable movement
	if IsPlayer
		Game.ForceThirdPerson()
		Game.DisablePlayerControls(false, false, false, false, false, false, true, false, 0)
		Game.SetPlayerAIDriven()
		; Enable hotkeys, if needed
		if !(IsVictim && Config.DisablePlayer)
			Thread.EnableHotkeys()
		endIf
	else
		; ActorRef.SetRestrained(true)
		ActorRef.SetDontMove(true)
	endIf
	; Attach positioning marker
	if !MarkerRef
		MarkerRef = ActorRef.PlaceAtMe(Config.BaseMarker)
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
	ActorRef.RemoveFromFaction(Config.AnimatingFaction)
	ActorUtil.RemovePackageOverride(ActorRef, Config.DoNothing)
	ActorRef.EvaluatePackage()
	; Enable movement
	if IsPlayer
		Thread.DisableHotkeys()
		Game.EnablePlayerControls()
		Game.SetPlayerAIDriven(false)
		; Disable free camera, if in it
		if Game.GetCameraState() == 3
			Config.ToggleFreeCamera()
		endIf
	else
		ActorRef.SetDontMove(false)
	endIf
endFunction

function RestoreActorDefaults()
	if GetReference() == none && ActorRef == none
		return
	endIf
	; Make sure we have actor, can't afford to miss this block
	ActorRef = GetReference() as Actor
	; Reset to starting scale
	if ActorScale != 0.0
		ActorRef.SetScale(ActorScale)
	endIf
	if !IsCreature
		; Reset expression
		ActorRef.ClearExpressionOverride()
		MfgConsoleFunc.ResetPhonemeModifier(ActorRef)
		if ActorVoice != none && ActorVoice != BaseRef.GetVoiceType()
			BaseRef.SetVoiceType(ActorVoice)
		endIf
		; Remove strapon
		if Strapon != none
			ActorRef.UnequipItem(Strapon, true, true)
			ActorRef.RemoveItem(Strapon, 1, true)
		endIf
	endIf
	; Remove SOS erection
	Debug.SendAnimationEvent(ActorRef, "SOSFlaccid")
endFunction

; ------------------------------------------------------- ;
; --- Data Accessors                                  --- ;
; ------------------------------------------------------- ;

function SetVoice(sslBaseVoice ToVoice = none, bool ForceSilence = false)
	IsForcedSilent = ForceSilence
	if ToVoice != none
		Voice = ToVoice
		; Set voicetype if unreconized
		if Config.UseLipSync && !Config.SexLabVoices.HasForm(ActorVoice)
			if BaseSex == 1
				BaseRef.SetVoiceType(Config.SexLabVoiceF)
			else
				BaseRef.SetVoiceType(Config.SexLabVoiceM)
			endIf
		endIf
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

function Strip()
	if ActorRef == none || IsCreature
		return
	endIf
	; Start stripping animation
	if DoUndress
		Debug.SendAnimationEvent(ActorRef, "Arrok_Undress_G"+BaseSex)
		NoUndress = true
	endIf
	; Select stripping array
	bool[] Strip
	if StripOverride.Length == 33
		Strip = StripOverride
	else
		Strip = Config.GetStrip(IsFemale, Thread.LeadIn, Thread.IsAggressive, IsVictim)
	endIf
	; Get Nudesuit
	bool UseNudeSuit = Strip[2] && ((Gender == 0 && Config.UseMaleNudeSuit) || (Gender == 1 && Config.UseFemaleNudeSuit))
	if UseNudeSuit && ActorRef.GetItemCount(Config.NudeSuit) < 1
		ActorRef.AddItem(Config.NudeSuit, 1, true)
	endIf
	; Stripped storage
	Form[] Stripped = new Form[34]
	Form ItemRef
	; Strip Weapon
	if Strip[32]
		; Right hand
		ItemRef = ActorRef.GetEquippedWeapon(false)
		if IsStrippable(ItemRef)
			ActorRef.UnequipItemEX(ItemRef, 1, false)
			Stripped[33] = ItemRef
		endIf
		; Left hand
		ItemRef = ActorRef.GetEquippedWeapon(true)
		if IsStrippable(ItemRef)
			ActorRef.UnequipItemEX(ItemRef, 2, false)
			Stripped[32] = ItemRef
		endIf
	endIf
	; Strip armor slots
	int i = Strip.RFind(true, 31)
	Log("strip start: "+i)
	while i
		if Strip[i]
			; Grab item in slot
			ItemRef = ActorRef.GetWornForm(Armor.GetMaskForSlot(i + 30))
			if IsStrippable(ItemRef)
				ActorRef.UnequipItem(ItemRef, false, true)
				Stripped[i] = ItemRef
			endIf
		endIf
		; Move to next slot
		i -= 1
	endWhile
	; Equip the nudesuit
	if UseNudeSuit
		ActorRef.EquipItem(Config.NudeSuit, true, true)
	endIf
	; Store stripped items
	Equipment = MergeFormArray(ClearNone(Stripped), Equipment)
endFunction

bool function IsStrippable(Form ItemRef)
	; Check previous validations
	if ItemRef != none && FormListFind(Config, "StripList", ItemRef) != -1
		return true
	elseIf ItemRef == none || FormListFind(Config, "NoStripList", ItemRef) != -1
		return false
	endIf
	; Check keywords
	int i = ItemRef.GetNumKeywords()
	while i
		i -= 1
		string kw = ItemRef.GetNthKeyword(i).GetString()
		if StringUtil.Find(kw, "NoStrip") != -1 || StringUtil.Find(kw, "Bound") != -1
			FormListAdd(Config, "NoStripList", ItemRef, true)
			return false
		endIf
	endWhile
	FormListAdd(Config, "StripList", ItemRef, true)
	return true
endFunction

function UnStrip()
 	if ActorRef == none || IsCreature || Equipment.Length == 0
 		return
 	endIf
	; Remove nudesuit if present
	if ActorRef.GetItemCount(Config.NudeSuit) > 0
		ActorRef.UnequipItem(Config.NudeSuit, true, true)
		ActorRef.RemoveItem(Config.NudeSuit, ActorRef.GetItemCount(Config.NudeSuit), true)
	endIf
	; Continue with undress, or am I disabled?
 	if !DoRedress
 		return ; Fuck clothes, bitch.
 	endIf
 	; Equip Stripped
 	int hand = 1
 	int i = Equipment.Length
 	while i
 		i -= 1
 		if Equipment[i] != none
 			int type = Equipment[i].GetType()
 			if type == 22 || type == 82
 				ActorRef.EquipSpell((Equipment[i] as Spell), hand)
 			else
 				ActorRef.EquipItem(Equipment[i], false, true)
 			endIf
 			; Move to other hand if weapon, light, spell, or leveledspell
 			hand -= ((hand == 1 && (type == 41 || type == 31 || type == 22 || type == 82)) as int)
  		endIf
 	endWhile
endFunction

bool NoRagdoll
bool property DoRagdoll hidden
	bool function get()
		if NoRagdoll
			return false
		endIf
		return !NoRagdoll && Config.RagdollEnd
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
		return Config.UndressAnimation
	endFunction
	function set(bool value)
		NoUndress = !value
	endFunction
endProperty

bool NoRedress
bool property DoRedress hidden
	bool function get()
		if NoRedress || (IsVictim && !Config.RedressVictim)
			return false
		endIf
		return !IsVictim || (IsVictim && Config.RedressVictim)
	endFunction
	function set(bool value)
		NoRedress = !value
	endFunction
endProperty

; ------------------------------------------------------- ;
; --- System Use                                      --- ;
; ------------------------------------------------------- ;

function Initialize()
	; Clean script of events
	ClearEvents()
	; Clear actor
	if ActorRef != none
		; Remove nudesuit if present
		if ActorRef.GetItemCount(Config.NudeSuit) > 0
			ActorRef.UnequipItem(Config.NudeSuit, true, true)
			ActorRef.RemoveItem(Config.NudeSuit, ActorRef.GetItemCount(Config.NudeSuit), true)
		endIf
	endIf
	; Delete positioning marker
	if MarkerRef != none
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
	NoRedress      = false
	; Floats
	ActorScale     = 0.0
	AnimScale      = 0.0
	; Storage
	StripOverride  = BoolArray(0)
	Equipment      = FormArray(0)
	; Make sure alias is emptied
	TryToClear()
endFunction

function Setup()
	; init libraries
	parent.Setup()
	; init alias settings
	Thread = GetOwningQuest() as sslThreadController
	Initialize()
	GoToState("")
endFunction
; ------------------------------------------------------- ;
; --- State Restricted                                --- ;
; ------------------------------------------------------- ;

; Ready
function PrepareActor()
endFunction
; Animating
function StartAnimating()
endFunction
function SyncActor()
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
int function GetEnjoyment()
	return 0
endFunction
int function GetPain()
	return 0
endFunction
