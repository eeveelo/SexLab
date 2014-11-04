scriptname sslActorAlias extends ReferenceAlias

; Settings access
sslSystemConfig Config

; Framework access
Actor PlayerRef
sslActorStats Stats
sslActorLibrary ActorLib

; Actor Info
Actor property ActorRef auto hidden
ActorBase BaseRef
string ActorName
int BaseSex
int Gender
bool IsMale
bool IsFemale
bool IsCreature
bool IsVictim
bool IsPlayer
bool IsTracked

; Current Thread state
sslThreadController Thread
int Position
int Stage

; Animation
sslBaseAnimation Animation
string AdjustKey
string ActorKey

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
form[] Equipment
float[] Skills
float[] SkillBonus
bool[] StripOverride
float StartedAt
float ActorScale
float AnimScale
form Strapon
int HighestRelation
int Enjoyment

; Animation Position/Stage flags
bool property OpenMouth hidden
	bool function get()
		return Flags[1] == 1
	endFunction
endProperty
bool property IsSilent hidden
	bool function get()
		return !Voice || IsForcedSilent || Flags[0] == 1 || Flags[1] == 1
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
	if !ProspectRef || ProspectRef != GetReference()
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
	IsTracked  = Config.ThreadLib.IsActorTracked(ActorRef)
	TrackedEvent("Added")
	if !IsCreature
		SetVoice(UseVoice, ForceSilent)
		if !IsPlayer
			Stats.SeedActor(ActorRef)
		endIf
	else
		Thread.CreatureRef = BaseRef.GetRace()
	endIf
	; Actor's Adjustment Key
	if Config.RaceAdjustments
		ActorKey = MiscUtil.GetRaceEditorID(BaseRef.GetRace())
		if IsCreature
			ActorKey += "C"
		elseIf BaseSex == 1
			ActorKey += "F"
		else
			ActorKey += "M"
		endIf
	endIf
	; Update threads gender
	Thread.Genders[Gender] = Thread.Genders[Gender] + 1
	; Get ready for mod events
	RegisterEvents()
	; Ready
	Log("Slotted '"+ActorName+"'", self)
	GoToState("Ready")
	return true
endFunction

function ClearAlias()
	; Maybe got here prematurely, give it 10 seconds before forcing the clear
	if GetState() == "Resetting"
		float Failsafe = Utility.GetCurrentRealTime() + 10.0
		while GetState() == "Resetting" && Utility.GetCurrentRealTime() < Failsafe
			Utility.WaitMenuMode(0.2)
		endWhile
	endIf
	; Make sure actor is reset
	if GetReference()
		; Get actor incase variable initialized
		ActorRef   = GetReference() as Actor
		; Remove any unwanted combat effects
		ClearEffects()
		; Init variables needed for reset
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
	Initialize()
endFunction

; ------------------------------------------------------- ;
; --- Actor Prepartion                                --- ;
; ------------------------------------------------------- ;

state Ready

	bool function SetActor(Actor ProspectRef, bool MakeVictim = false, sslBaseVoice UseVoice = none, bool ForceSilent = false)
		return false
	endFunction

	function PrepareActor()
		; Remove any unwanted combat effects
		ClearEffects()
		; Starting Information
		Flags      = new int[5]
		Offsets    = new float[4]
		Loc        = new float[6]
		SkillBonus = Thread.SkillBonus
		Stage      = Thread.Stage
		Animation  = Thread.Animation
		AdjustKey  = Thread.AdjustKey
		Position   = Thread.Positions.Find(ActorRef)
		Flags      = Animation.PositionFlags(Flags, AdjustKey, Position, Stage)
		Offsets    = Animation.PositionOffsets(Offsets, AdjustKey, Position, Stage)
		; Calculate scales
		float display = ActorRef.GetScale()
		ActorRef.SetScale(1.0)
		float base = ActorRef.GetScale()
		ActorScale = ( display / base )
		AnimScale  = ActorScale
		ActorRef.SetScale(ActorScale)
		if Thread.ActorCount > 1 && Config.ScaleActors
			AnimScale = (1.0 / base)
		endIf
		; Stop movement
		LockActor()
		; Starting position
		OffsetCoords(Loc, Thread.CenterLocation, Offsets)
		MarkerRef.SetPosition(Loc[0], Loc[1], Loc[2])
		MarkerRef.SetAngle(Loc[3], Loc[4], Loc[5])
		ActorRef.SetPosition(Loc[0], Loc[1], Loc[2])
		ActorRef.SetAngle(Loc[3], Loc[4], Loc[5])
		ActorRef.SetVehicle(MarkerRef)
		ActorRef.SetScale(AnimScale)
		; Disable autoadvance if disabled for player
		if IsPlayer
			if IsVictim && Config.DisablePlayer
				Thread.AutoAdvance = true
			elseIf !Config.AutoAdvance
				Thread.AutoAdvance = false
			endIf
		endIf
		; Extras for non creatures
		if !IsCreature
			; Decide on strapon for female, default to worn, otherwise pick random.
			if IsFemale && Config.UseStrapons
				Strapon = Config.WornStrapon(ActorRef)
				if !Strapon
					Strapon = Config.GetStrapon()
				endIf
			endIf
			; Strip actor
			Strip()
			Debug.SendAnimationEvent(ActorRef, "SOSFastErect")
			; Pick a voice if needed
			if !Voice && !IsForcedSilent
				SetVoice(Config.VoiceSlots.PickVoice(ActorRef), IsForcedSilent)
			endIf
			; Pick an expression if needed
			if !Expression && Config.UseExpressions
				Expression = Config.ExpressionSlots.PickExpression(ActorRef, Thread.VictimRef)
			endIf
			; Always use players stats if present, so players stats mean something more for npcs
			Actor SkilledActor = ActorRef
			if Thread.HasPlayer
				SkilledActor = PlayerRef
			; If a non-creature couple, base skills off partner
			elseIf Thread.ActorCount == 2 && !Thread.HasCreature
				SkilledActor = Thread.Positions[PapyrusUtil.IndexTravel(Position, Thread.ActorCount)]
			endIf
			Skills = Stats.GetSkillLevels(SkilledActor)
			; Get highest relationship ahead of time
			HighestRelation = Thread.GetHighestPresentRelationshipRank(ActorRef)
		endIf
		GoToState("Animating")
		; Enter animatable state - rest is non vital and can finish as queued
		Thread.AliasEventDone("Prepare")
	endFunction
endState

; ------------------------------------------------------- ;
; --- Animation Loop                                  --- ;
; ------------------------------------------------------- ;

state Animating

	function StartAnimating()
		; If enabled, start Auto TFC for player
		if IsPlayer && Config.AutoTFC
			SexLabUtil.EnableFreeCamera(true, Config.AutoSUCSM)
		endIf
		; Start update loop
		TrackedEvent("Start")
		StartedAt = Utility.GetCurrentRealTime()
		RegisterForSingleUpdate(Utility.RandomFloat(1.5, 3.0))
	endFunction

	event OnUpdate()
		; Check if still among the living and able.
		if ActorRef.IsDisabled() || (ActorRef.IsDead() && ActorRef.GetActorValue("Health") < 1.0)
			Log("Actor is disabled or has no health, unable to continue animating", ActorName)
			Thread.EndAnimation(true)
			return
		endIf
		; Ping thread to update skill xp
		if Position == 0
			Thread.RecordSkills()
			Thread.SetBonuses()
		endIf
		; Sync enjoyment level
		GetEnjoyment()
		; Apply Expression / sync enjoyment
		if !OpenMouth
			RefreshExpression()
		endIf
		; Moan if not silent
		if !IsSilent
			Voice.Moan(ActorRef, Enjoyment, IsVictim)
		endIf
		; Loop
		RegisterForSingleUpdate(VoiceDelay)
	endEvent

	function SyncThread()
		; Sync with thread info
		Animation  = Thread.Animation
		AdjustKey  = Thread.AdjustKey
		Stage      = Thread.Stage
		Position   = Thread.Positions.Find(ActorRef)
		VoiceDelay = Config.GetVoiceDelay(IsFemale, Stage, IsSilent)
		Flags      = Animation.PositionFlags(Flags, AdjustKey, Position, Stage)
		Offsets    = Animation.PositionOffsets(Offsets, AdjustKey, Position, Stage)
		; Update alias info
		GetEnjoyment()
		Debug.SendAnimationEvent(ActorRef, "SOSBend"+Schlong)
		if !IsCreature
			; Equip Strapon if needed and enabled
			if Strapon
				if UseStrapon && !ActorRef.IsEquipped(Strapon)
					ActorRef.EquipItem(Strapon, true, true)
				elseif !UseStrapon && ActorRef.IsEquipped(Strapon)
					ActorRef.UnequipItem(Strapon, true, true)
				endIf
			endIf
			; Clear any existing expression as a default - to remove open mouth
			; ActorRef.ClearExpressionOverride()
			if OpenMouth
				OpenMouth()
			elseIf Expression
				RefreshExpression()
			elseIf IsMouthOpen()
				CloseMouth()
			endIf
		endIf
	endFunction

	function SyncActor()
		SyncThread()
		SyncLocation(false)
		Thread.AliasEventDone("Sync")
	endFunction

	function RefreshLoc()
		Offsets = Animation.PositionOffsets(Offsets, AdjustKey, Position, Stage)
		SyncLocation(false)
	endFunction

	function SyncLocation(bool Force = false)
		; Set Loc Array to offset coordinates
		OffsetCoords(Loc, Thread.CenterLocation, Offsets)
		MarkerRef.SetPosition(Loc[0], Loc[1], Loc[2])
		MarkerRef.SetAngle(Loc[3], Loc[4], Loc[5])
		; Avoid forcibly setting on player coords if avoidable - causes annoying graphical flickering
		if Force && IsPlayer && IsInPosition(ActorRef, MarkerRef, 40.0)
			ActorRef.SplineTranslateTo(Loc[0], Loc[1], Loc[2], Loc[3], Loc[4], Loc[5], 1.0, 10000, 0)
		elseIf Force
			ActorRef.SetPosition(Loc[0], Loc[1], Loc[2])
			ActorRef.SetAngle(Loc[3], Loc[4], Loc[5])
		endIf
		ActorRef.SetVehicle(MarkerRef)
		ActorRef.SetScale(AnimScale)
		Snap()
	endFunction

	function Snap()
		; Quickly move into place and angle if actor is off by a lot
		if !IsInPosition(ActorRef, MarkerRef, 40.0)
			ActorRef.SetPosition(Loc[0], Loc[1], Loc[2])
			ActorRef.SetAngle(Loc[3], Loc[4], Loc[5])
			ActorRef.SetVehicle(MarkerRef)
			ActorRef.SetScale(AnimScale)
		elseIf ActorRef.GetDistance(MarkerRef) > 0.2
			ActorRef.SplineTranslateTo(Loc[0], Loc[1], Loc[2], Loc[3], Loc[4], Loc[5], 1.0, 5000, 0)
			return ; OnTranslationComplete() will take over when in place
		endIf
		; Begin very slowly rotating a small amount to hold position
		ActorRef.SplineTranslateTo(Loc[0], Loc[1], Loc[2], Loc[3], Loc[4], Loc[5]+0.01, 1.0, 500, 0.001)
	endFunction

	event OnTranslationComplete()
		Utility.Wait(0.5)
		Snap()
	endEvent

	function OrgasmEffect()
		; Apply cum
		int CumID = Animation.GetCum(Position)
		if CumID > 0 && Config.UseCum && (Thread.Males > 0 || Config.AllowFFCum || Thread.HasCreature)
			ActorLib.ApplyCum(ActorRef, CumID)
		endIf
		; Shake camera for player
		if IsPlayer && Game.GetCameraState() != 3
			Game.ShakeCamera(none, 0.75, 1.5)
		endIf
		; Play
		Config.OrgasmFX.Play(ActorRef)
		VoiceDelay = 0.8
		; Notify thread of finish
		Thread.AliasEventDone("Orgasm")
		RegisterForSingleUpdate(VoiceDelay)
	endFunction

	event ResetActor()
		ClearEvents()
		GoToState("Resetting")
		Log("-- Resetting! -- ", ActorName)
		; Update stats
		if !IsCreature
			Log(ActorName+" -- BEFORE: "+sslActorStats.GetSkills(ActorRef))
			sslActorStats._SetSkill(ActorRef, Stats.kLastRealTime, Utility.GetCurrentRealTime())
			sslActorStats._SetSkill(ActorRef, Stats.kLastGameTime, Utility.GetCurrentGameTime())
			sslActorStats.RecordThread(ActorRef, Gender, HighestRelation, (Utility.GetCurrentRealTime() - StartedAt), Thread.HasPlayer, Thread.VictimRef, Thread.Genders, Thread.SkillXP)
			Log(ActorName+" -- AFTER: "+sslActorStats.GetSkills(ActorRef))
			; Stats.RecordThread(ActorRef, (IsPlayer || Thread.HasPlayer), Thread.ActorCount, HighestRelation, (Utility.GetCurrentRealTime() - StartedAt), Thread.VictimRef, Thread.SkillXP, Thread.Genders)
		endIf
		; Apply cum
		int CumID = Animation.GetCum(Position)
		if CumID > 0 && !Thread.FastEnd && Config.UseCum && (Thread.Males > 0 || Config.AllowFFCum || Thread.HasCreature)
			ActorLib.ApplyCum(ActorRef, CumID)
		endIf
		; Clear TFC
		if IsPlayer && Game.GetCameraState() == 3
			MiscUtil.ToggleFreeCamera()
		endIf
		; Tracked events
		TrackedEvent("End")
		StopAnimating(Thread.FastEnd)
		RestoreActorDefaults()
		UnlockActor()
		; Unstrip items in storage, if any
		if !ActorRef.IsDead()
			Unstrip()
		endIf
		; Free alias slot
		Clear()
		GoToState("")
		Thread.AliasEventDone("Reset")
		Initialize()
	endEvent
endState

state Resetting
	function ClearAlias()
	endFunction
	event OnUpdate()
	endEvent
	function Initialize()
	endFunction
endState

; ------------------------------------------------------- ;
; --- Actor Manipulation                              --- ;
; ------------------------------------------------------- ;

function StopAnimating(bool Quick = false)
	if !ActorRef
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
		ActorRef.Moveto(ActorRef)
		ActorRef.PushActorAway(ActorRef, 0.75)
	else
		; Reset NPC/PC Idle Quickly
		Debug.SendAnimationEvent(ActorRef, "IdleForceDefaultState")
		; Ragdoll NPC/PC if enabled and not in TFC
		if !Quick && DoRagdoll && (!IsPlayer || (IsPlayer && Game.GetCameraState() != 3))
			ActorRef.Moveto(ActorRef)
			ActorRef.PushActorAway(ActorRef, 0.1)
		endIf
	endIf
endFunction

function LockActor()
	if !ActorRef
		return
	endIf
	; Remove any unwanted combat effects
	ClearEffects()
	; Stop whatever they are doing
	; Debug.SendAnimationEvent(ActorRef, "IdleForceDefaultState")
	; Start DoNothing package
	ActorRef.SetFactionRank(Config.AnimatingFaction, 1)
	ActorUtil.AddPackageOverride(ActorRef, Config.DoNothing, 100, 1)
	ActorRef.EvaluatePackage()
	; Disable movement
	if IsPlayer
		if Game.GetCameraState() == 0
			Game.ForceThirdPerson()
		endIf
		; abMovement = true, abFighting = true, abCamSwitch = false, abLooking = false, abSneaking = false, abMenu = true, abActivate = true, abJournalTabs = false, aiDisablePOVType = 0
		Game.DisablePlayerControls(true, true, false, false, false, false, false, false, 0)
		; Game.SetPlayerAIDriven()
		; Enable hotkeys, if needed
		if !(IsVictim && Config.DisablePlayer)
			Thread.EnableHotkeys()
		endIf
	else
		ActorRef.SetRestrained(true)
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
	ActorRef.SetScale(AnimScale)
endFunction

function UnlockActor()
	if !ActorRef
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
		; Disable free camera, if in it
		if Game.GetCameraState() == 3
			Config.ToggleFreeCamera()
		endIf
		Thread.DisableHotkeys()
		Game.EnablePlayerControls(true, true, false, false, false, false, false, false, 0)
		; Game.SetPlayerAIDriven(false)
	else
		ActorRef.SetRestrained(false)
		ActorRef.SetDontMove(false)
	endIf
endFunction

function RestoreActorDefaults()
	; Make sure  have actor, can't afford to miss this block
	if !ActorRef
		ActorRef = GetReference() as Actor
		if !ActorRef
			return ; No actor, reset prematurely or bad call to alias
		endIf
	endIf
	; Reset to starting scale
	if ActorScale != 0.0
		ActorRef.SetScale(ActorScale)
	endIf
	if !IsCreature
		; Reset voicetype
		if ActorVoice && ActorVoice != BaseRef.GetVoiceType()
			BaseRef.SetVoiceType(ActorVoice)
		endIf
		; Remove strapon
		if Strapon
			ActorRef.RemoveItem(Strapon, 1, true)
		endIf
		; Reset expression
		ClearMFG()
	endIf
	; Remove SOS erection
	Debug.SendAnimationEvent(ActorRef, "SOSFlaccid")
endFunction

; ------------------------------------------------------- ;
; --- Data Accessors                                  --- ;
; ------------------------------------------------------- ;

string function GetActorKey()
	return ActorKey
endFunction

int function GetEnjoyment()
	if !ActorRef
		Enjoyment = 0
	elseif IsCreature
		Enjoyment = (PapyrusUtil.ClampFloat((Utility.GetCurrentRealTime() - StartedAt) / 6.0, 0.0, 40.0) + ((Stage as float / Animation.StageCount as float) * 60.0)) as int
	else
		Enjoyment = CalcEnjoyment(SkillBonus, Skills, Thread.LeadIn, IsFemale, (Utility.GetCurrentRealTime() - StartedAt), Stage, Animation.StageCount)
	endIf
	return Enjoyment
endFunction

int function GetPain()
	if !ActorRef
		return 0
	endIf
	float Pain = Math.Abs(100.0 - PapyrusUtil.ClampFloat(GetEnjoyment() as float, 1.0, 99.0))
	if IsVictim
		Pain *= 1.5
	elseIf Animation.HasTag("Aggressive") || Animation.HasTag("Rough")
		Pain *= 0.8
	else
		Pain *= 0.3
	endIf
	return PapyrusUtil.ClampInt(Pain as int, 0, 100)
endFunction

function SetVoice(sslBaseVoice ToVoice = none, bool ForceSilence = false)
	IsForcedSilent = ForceSilence
	if ToVoice
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
	if ToExpression
		Expression = ToExpression
	endIf
endFunction

sslBaseExpression function GetExpression()
	return Expression
endFunction

bool function IsUsingStrapon()
	return Strapon && ActorRef.IsEquipped(Strapon)
endFunction

function EquipStrapon()
	if IsUsingStrapon()
		ActorRef.EquipItem(Strapon, true, true)
	endIf
endFunction

function UnequipStrapon()
	if IsUsingStrapon()
		ActorRef.UnequipItem(Strapon, true, true)
	endIf
endFunction

function SetStrapon(Form ToStrapon)
	if Strapon
		ActorRef.RemoveItem(Strapon, 1, true)
	endIf
	Strapon = ToStrapon
	if GetState() == "Animating"
		SyncThread()
	endIf
endFunction

Form function GetStrapon()
	return Strapon
endFunction

function OverrideStrip(bool[] SetStrip)
	if SetStrip.Length != 33
		Thread.Log(ActorName+" -- Invalid strip bool override array given. Must be length 33; was given "+SetStrip.Length, "ERROR")
	else
		StripOverride = SetStrip
	endIf
endFunction

function Strip()
	if !ActorRef || IsCreature
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
	; Stripped storage
	Form[] Stripped = new Form[34]
	Form ItemRef
	; Strip Weapon
	if Strip[32]
		; Right hand
		ItemRef = ActorRef.GetEquippedWeapon(false)
		if ItemRef && !SexLabUtil.HasKeywordSub(ItemRef, "NoStrip")
			ActorRef.UnequipItemEX(ItemRef, 1, false)
			Stripped[33] = ItemRef
		endIf
		; Left hand
		ItemRef = ActorRef.GetEquippedWeapon(true)
		if ItemRef && !SexLabUtil.HasKeywordSub(ItemRef, "NoStrip")
			ActorRef.UnequipItemEX(ItemRef, 2, false)
			Stripped[32] = ItemRef
		endIf
	endIf
	; Strip armor slots
	int i = Strip.RFind(true, 31)
	while i >= 0
		if Strip[i]
			; Grab item in slot
			ItemRef = ActorRef.GetWornForm(Armor.GetMaskForSlot(i + 30))
			if ItemRef && !SexLabUtil.HasKeywordSub(ItemRef, "NoStrip")
				ActorRef.UnequipItem(ItemRef, false, true)
				Stripped[i] = ItemRef
			endIf
		endIf
		; Move to next slot
		i -= 1
	endWhile
	; Equip the nudesuit
	if Strip[2] && ((Gender == 0 && Config.UseMaleNudeSuit) || (Gender == 1 && Config.UseFemaleNudeSuit))
		ActorRef.EquipItem(Config.NudeSuit, true, true)
	endIf
	; Store stripped items
	Equipment = PapyrusUtil.MergeFormArray(Equipment, PapyrusUtil.ClearNone(Stripped))
endFunction

function UnStrip()
 	if !ActorRef || IsCreature || Equipment.Length == 0
 		return
 	endIf
	; Remove nudesuit if present
	if ActorRef.GetItemCount(Config.NudeSuit) > 0
		ActorRef.RemoveItem(Config.NudeSuit, ActorRef.GetItemCount(Config.NudeSuit), true)
	endIf
	; Continue with undress, or am I disabled?
 	if !DoRedress
 		return ; Fuck clothes, bitch.
 	endIf
 	; Equip Strippedb
 	int hand = 1
 	int i = Equipment.Length
 	while i
 		i -= 1
 		if Equipment[i]
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
; --- Expression handling                             --- ;
; ---    Mirrored from sslBaseExpression to avoid     --- ;
; ---    problems with thread locking                 --- ;
; ------------------------------------------------------- ;

function ClearPhoneme()
	; A bit quicker than a loop
	ActorRef.SetExpressionPhoneme(0, 0.0)
	ActorRef.SetExpressionPhoneme(1, 0.0)
	ActorRef.SetExpressionPhoneme(2, 0.0)
	ActorRef.SetExpressionPhoneme(3, 0.0)
	ActorRef.SetExpressionPhoneme(4, 0.0)
	ActorRef.SetExpressionPhoneme(5, 0.0)
	ActorRef.SetExpressionPhoneme(6, 0.0)
	ActorRef.SetExpressionPhoneme(7, 0.0)
	ActorRef.SetExpressionPhoneme(8, 0.0)
	ActorRef.SetExpressionPhoneme(9, 0.0)
	ActorRef.SetExpressionPhoneme(10, 0.0)
	ActorRef.SetExpressionPhoneme(11, 0.0)
	ActorRef.SetExpressionPhoneme(12, 0.0)
	ActorRef.SetExpressionPhoneme(13, 0.0)
	ActorRef.SetExpressionPhoneme(14, 0.0)
	ActorRef.SetExpressionPhoneme(15, 0.0)
endFunction

function ClearModifier()
	ActorRef.SetExpressionModifier(0, 0.0)
	ActorRef.SetExpressionModifier(1, 0.0)
	ActorRef.SetExpressionModifier(2, 0.0)
	ActorRef.SetExpressionModifier(3, 0.0)
	ActorRef.SetExpressionModifier(4, 0.0)
	ActorRef.SetExpressionModifier(5, 0.0)
	ActorRef.SetExpressionModifier(6, 0.0)
	ActorRef.SetExpressionModifier(7, 0.0)
	ActorRef.SetExpressionModifier(8, 0.0)
	ActorRef.SetExpressionModifier(9, 0.0)
	ActorRef.SetExpressionModifier(10, 0.0)
	ActorRef.SetExpressionModifier(11, 0.0)
	ActorRef.SetExpressionModifier(12, 0.0)
	ActorRef.SetExpressionModifier(13, 0.0)
endFunction

function ClearMFG()
	ActorRef.ResetExpressionOverrides()
	ActorRef.ClearExpressionOverride()
	MfgConsoleFunc.ResetPhonemeModifier(ActorRef)
	ClearModifier()
	ClearPhoneme()
endFunction

function OpenMouth()
	ClearPhoneme()
	ActorRef.SetExpressionOverride(16, 100)
	ActorRef.SetExpressionPhoneme(1, 0.4)
endFunction

function CloseMouth()
	ActorRef.ClearExpressionOverride()
	ActorRef.SetExpressionPhoneme(1, 0)
endFunction

bool function IsMouthOpen()
	return (MfgConsoleFunc.GetExpressionID(ActorRef) == 16 && MfgConsoleFunc.GetExpressionValue(ActorRef) == 100) || (MfgConsoleFunc.GetPhonemeModifier(ActorRef, 0, 1) >= 40)
endFunction

function RefreshExpression()
	if !Expression || IsCreature || !ActorRef
		return
	endIf
	int[] Preset = Expression.GetPhase(Expression.PickPhase(Enjoyment, BaseSex), BaseSex)
	int i
	; Set Phoneme
	int p
	while p <= 15
		ActorRef.SetExpressionPhoneme(p, Preset[i] as float / 100.0)
		i += 1
		p += 1
	endWhile
	; Set Modifers
	int m
	while m <= 13
		ActorRef.SetExpressionModifier(m, Preset[i] as float / 100.0)
		i += 1
		m += 1
	endWhile
	; Set expression
	ActorRef.SetExpressionOverride(Preset[30], Preset[31])
endFunction

; ------------------------------------------------------- ;
; --- System Use                                      --- ;
; ------------------------------------------------------- ;

function TrackedEvent(string eventName)
	if IsTracked
		Thread.SendTrackedEvent(ActorRef, eventName, Thread.tid)
	endif
endFunction

function ClearEffects()
	if ActorRef.IsInCombat()
		ActorRef.StopCombat()
	endIf
	if ActorRef.IsWeaponDrawn()
		ActorRef.SheatheWeapon()
	endIf
	if ActorRef.IsSneaking()
		ActorRef.StartSneaking()
	endIf
endFunction

function RegisterEvents()
	string e = Thread.Key("")
	RegisterForModEvent(e+"Prepare", "PrepareActor")
	RegisterForModEvent(e+"Reset", "ResetActor")
	RegisterForModEvent(e+"Sync", "SyncActor")
	RegisterForModEvent(e+"Orgasm", "OrgasmEffect")
	RegisterForModEvent(e+"Strip", "Strip")
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

function Initialize()
	; Stop events
	ClearEvents()
	; Clear actor
	if ActorRef
		; Remove nudesuit if present
		if ActorRef.GetItemCount(Config.NudeSuit) > 0
			ActorRef.RemoveItem(Config.NudeSuit, ActorRef.GetItemCount(Config.NudeSuit), true)
		endIf
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
	NoRedress      = false
	; Floats
	ActorScale     = 0.0
	AnimScale      = 0.0
	; Strings
	ActorKey       = ""
	; Storage
	StripOverride  = PapyrusUtil.BoolArray(0)
	Equipment      = PapyrusUtil.FormArray(0)
	; Make sure alias is emptied
	TryToClear()
endFunction

function Setup()
	; Sync Player
	if !PlayerRef
		PlayerRef = Game.GetPlayer()
	endIf
	; Sync function Libraries - SexLabQuestFramework
	if !Config || ActorLib || !Stats
		Quest SexLabQuestFramework = Game.GetFormFromFile(0xD62, "SexLab.esm") as Quest
		if SexLabQuestFramework
			Config   = SexLabQuestFramework as sslSystemConfig
			ActorLib = SexLabQuestFramework as sslActorLibrary
			Stats    = SexLabQuestFramework as sslActorStats
		endIf
	endIf
	; Sync thread owner
	if !Thread
		Thread = GetOwningQuest() as sslThreadController
	endIf
	; init alias settings
	Initialize()
endFunction

function Log(string Log, string Type = "NOTICE")
	SexLabUtil.DebugLog(Log, Type, Config.DebugMode)
endFunction

bool function TestAlias()
	return PlayerRef && Config && ActorLib && Stats; && VoiceSlots && ExpressionSlots && Thread
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
function SyncLocation(bool Force = false)
endFunction
function RefreshLoc()
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

function OffsetCoords(float[] Output, float[] CenterCoords, float[] OffsetBy) global native
bool function IsInPosition(Actor CheckActor, ObjectReference CheckMarker, float maxdistance = 30.0) global native
int function CalcEnjoyment(float[] XP, float[] SkillsAmounts, bool IsLeadin, bool IsFemaleActor, float Timer, int OnStage, int MaxStage) global native

bool function _SetActor(Actor ProspectRef) native
function _ApplyExpression(Actor ProspectRef, int[] Presets) global native
