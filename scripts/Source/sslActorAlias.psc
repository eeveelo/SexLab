scriptname sslActorAlias extends ReferenceAlias

; Framework access
sslSystemConfig Config
sslActorLibrary ActorLib
sslActorStats Stats
Actor PlayerRef

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
string AnimEvent
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
float[] Center
float[] Loc

; Storage
int[] Flags
Form[] Equipment
bool[] StripOverride
float[] SkillBonus
float[] Skills

float StartedAt
float ActorScale
float AnimScale
int HighestRelation
int Enjoyment
int BedTypeID

Form Strapon
Form HadStrapon

Spell HDTHeelSpell
Form HadBoots

; Thread/alias shares
float[] RealTime

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

bool function SetActor(Actor ProspectRef)
	if !ProspectRef || ProspectRef != GetReference()
		return false ; Failed to set prospective actor into alias
	endIf
	; Init actor alias information
	ActorRef   = ProspectRef
	BaseRef    = ActorRef.GetLeveledActorBase()
	ActorName  = BaseRef.GetName()
	ActorVoice = BaseRef.GetVoiceType()
	BaseSex    = BaseRef.GetSex()
	Gender     = ActorLib.GetGender(ActorRef)
	IsMale     = Gender == 0
	IsFemale   = Gender == 1
	IsCreature = Gender >= 2
	IsPlayer   = ActorRef == PlayerRef
	IsTracked  = Config.ThreadLib.IsActorTracked(ActorRef)
	RealTime   = Thread.RealTime
	Thread.Genders[Gender] = Thread.Genders[Gender] + 1
	; Player and creature specific
	if IsCreature
		Thread.CreatureRef = BaseRef.GetRace()
	elseIf !IsPlayer
		Stats.SeedActor(ActorRef)	
	endIf
	; Actor's Adjustment Key
	ActorKey = MiscUtil.GetRaceEditorID(BaseRef.GetRace())
	if IsCreature
		ActorKey += "C"
	elseIf BaseSex == 1
		ActorKey += "F"
	else
		ActorKey += "M"
	endIf
	; Ready
	RegisterEvents()
	TrackedEvent("Added")
	GoToState("Ready")
	Log(self, "SetActor("+ActorRef+")")
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
		; Init variables needed for reset
		ActorRef   = GetReference() as Actor
		BaseRef    = ActorRef.GetLeveledActorBase()
		ActorName  = BaseRef.GetName()
		BaseSex    = BaseRef.GetSex()
		Gender     = ActorLib.GetGender(ActorRef)
		IsMale     = Gender == 0
		IsFemale   = Gender == 1
		IsCreature = Gender >= 2
		IsPlayer   = ActorRef == PlayerRef
		Log("Actor present during alias clear! This is usually harmless as the alias and actor will correct itself, but is usually a sign that a thread did not close cleanly.", "ClearAlias("+ActorRef+" / "+self+")")
		; Reset actor back to default
		ClearEffects()
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

	bool function SetActor(Actor ProspectRef)
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
		BedTypeID  = Thread.BedTypeID
		AnimEvent  = Animation.FetchPositionStage(Position, Stage)
		Flags      = Animation.PositionFlags(Flags, AdjustKey, Position, Stage)
		Offsets    = Animation.PositionOffsets(Offsets, AdjustKey, Position, Stage, BedTypeID)
		Center     = Thread.CenterLocation
		; Calculate scales
		float display = ActorRef.GetScale()
		ActorRef.SetScale(1.0)
		float base = ActorRef.GetScale()
		ActorScale = ( display / base )
		AnimScale  = ActorScale
		ActorRef.SetScale(ActorScale)
		if Thread.ActorCount > 1 && Config.ScaleActors ; FIXME: || IsCreature?
			AnimScale = (1.0 / base)
		endIf
		; Log("display/base/animscale = "+display+"/"+base+"/"+AnimScale)
		; Stop movement
		LockActor()
		; Starting position
		OffsetCoords(Loc, Center, Offsets)
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
				HadStrapon = Config.WornStrapon(ActorRef)
				Strapon    = HadStrapon
				if !HadStrapon
					Strapon = Config.GetStrapon()
				endIf
			endIf
			; Strip actor
			Strip()
			ResolveStrapon()
			Debug.SendAnimationEvent(ActorRef, "SOSFastErect")
			; Find HDT High Heels
			HDTHeelSpell = Config.GetHDTSpell(ActorRef)
			if HDTHeelSpell
				ActorRef.RemoveSpell(HDTHeelSpell)
			endIf
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
			elseIf Thread.ActorCount > 1 && !Thread.HasCreature
				SkilledActor = Thread.Positions[sslUtility.IndexTravel(Position, Thread.ActorCount)]
			endIf
			Skills = Stats.GetSkillLevels(SkilledActor)
			HighestRelation = Thread.GetHighestPresentRelationshipRank(ActorRef)
		endIf
		; Enter animatable state - rest is non vital and can finish as queued
		GoToState("Animating")
		Thread.SyncEventDone("Prepare")
	endFunction
endState

; ------------------------------------------------------- ;
; --- Animation Loop                                  --- ;
; ------------------------------------------------------- ;

function PlayAnimation()
	Debug.SendAnimationEvent(ActorRef, AnimEvent)
endFunction

state Animating

	function StartAnimating()
		; If enabled, start Auto TFC for player
		if IsPlayer && Config.AutoTFC
			SexLabUtil.EnableFreeCamera(true, Config.AutoSUCSM)
		endIf
		; TODO: Add a light source option here. (possibly with frostfall benefit?)
		;
		; Start update loop
		TrackedEvent("Start")
		VoiceDelay = Config.GetVoiceDelay(IsFemale, Stage, IsSilent)
		StartedAt  = RealTime[0]
		RegisterForSingleUpdate(Utility.RandomFloat(1.0, 3.0))
		UnregisterForModEvent(Thread.Key("Start"))
	endFunction

	event OnUpdate()
		; Check if still among the living and able.
		if ActorRef.IsDisabled() || (ActorRef.IsDead() && ActorRef.GetActorValue("Health") < 1.0)
			Log("Actor is disabled or has no health - Unable to continue animating")
			Thread.EndAnimation(true)
			return
		endIf
		; Sync enjoyment level and expression
		GetEnjoyment()
		RefreshExpression()
		if !IsSilent
			Voice.Moan(ActorRef, Enjoyment, IsVictim)
		endIf
		; LoopB
		RegisterForSingleUpdate(VoiceDelay)
	endEvent

	function SyncThread()
		; Sync with thread info
		Animation  = Thread.Animation
		AdjustKey  = Thread.AdjustKey
		Stage      = Thread.Stage
		Position   = Thread.Positions.Find(ActorRef)
		BedTypeID  = Thread.BedTypeID
		AnimEvent  = Animation.FetchPositionStage(Position, Stage)
		Flags      = Animation.PositionFlags(Flags, AdjustKey, Position, Stage)
		Offsets    = Animation.PositionOffsets(Offsets, AdjustKey, Position, Stage, BedTypeID)
		VoiceDelay = Config.GetVoiceDelay(IsFemale, Stage, IsSilent)
		; Update alias info
		GetEnjoyment()
		Debug.SendAnimationEvent(ActorRef, "SOSBend"+Schlong)
		; Log("Enjoyment: "+Enjoyment+" SOS: "+Schlong)
		if !IsCreature
			ResolveStrapon()
			RefreshExpression()
		endIf
	endFunction

	function SyncActor()
		SyncThread()
		SyncLocation(false)
		Thread.SyncEventDone("Sync")
	endFunction

	function RefreshLoc()
		Offsets = Animation.PositionOffsets(Offsets, AdjustKey, Position, Stage, BedTypeID)
		SyncLocation(true)
	endFunction

	function SyncLocation(bool Force = false)
		OffsetCoords(Loc, Center, Offsets)
		MarkerRef.SetPosition(Loc[0], Loc[1], Loc[2])
		MarkerRef.SetAngle(Loc[3], Loc[4], Loc[5])
		; Avoid forcibly setting on player coords if avoidable - causes annoying graphical flickering
		if Force && IsPlayer && IsInPosition(ActorRef, MarkerRef, 40.0)
			ActorRef.SetVehicle(MarkerRef)
			ActorRef.SetScale(AnimScale)
			ActorRef.TranslateTo(Loc[0], Loc[1], Loc[2], Loc[3], Loc[4], Loc[5], 5000, 0)
			return ; OnTranslationComplete() will take over when in place
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
		if !IsInPosition(ActorRef, MarkerRef, 75.0)
			ActorRef.SetPosition(Loc[0], Loc[1], Loc[2])
			ActorRef.SetAngle(Loc[3], Loc[4], Loc[5])
			ActorRef.SetVehicle(MarkerRef)
			ActorRef.SetScale(AnimScale)
		elseIf ActorRef.GetDistance(MarkerRef) > 0.5
			ActorRef.TranslateTo(Loc[0], Loc[1], Loc[2], Loc[3], Loc[4], Loc[5], 5000, 0)
			return ; OnTranslationComplete() will take over when in place
		endIf
		; Begin very slowly rotating a small amount to hold position
		ActorRef.SplineTranslateTo(Loc[0], Loc[1], Loc[2], Loc[3], Loc[4], Loc[5]+0.001, 20.0, 500, 0.00001)
	endFunction

	event OnTranslationComplete()
		; Log(Loc, "OnTranslationComplete()")
		; Utility.Wait(0.3)
		Snap()
	endEvent

	function OrgasmEffect()
		; Apply cum
		int CumID = Animation.GetCumID(Position, Stage)
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
		Thread.SyncEventDone("Orgasm")
		RegisterForSingleUpdate(VoiceDelay)
	endFunction

	event ResetActor()
		ClearEvents()
		GoToState("Resetting")
		Log("Resetting!")
		; Update stats
		if !IsCreature
			Log("Stats BEFORE: "+sslActorStats.GetSkills(ActorRef))
			sslActorStats.RecordThread(ActorRef, Gender, HighestRelation, StartedAt, Utility.GetCurrentRealTime(), Utility.GetCurrentGameTime(), Thread.HasPlayer, Thread.VictimRef, Thread.Genders, Thread.SkillXP)
			Log("Stats AFTER: "+sslActorStats.GetSkills(ActorRef))
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
			; Reapply HDT High Heel if they had it and need it again.
			if HDTHeelSpell && ActorRef.GetWornForm(Armor.GetMaskForSlot(37))
				if ActorRef.HasSpell(HDTHeelSpell)
					Log(HDTHeelSpell+" -> "+Config.GetHDTSpell(ActorRef), "DEV - HDTHighHeels ("+ActorRef.HasSpell(HDTHeelSpell)+")")
				endIf
				Log("HDTHeelSpell re-applying", "DEV - HDTHighHeels")
				ActorRef.AddSpell(HDTHeelSpell)
			endIf
		endIf
		; Free alias slot
		Clear()
		GoToState("")
		Thread.SyncEventDone("Reset")
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
		if Strapon && Strapon != HadStrapon
			ActorRef.RemoveItem(Strapon, 1, true)
		endIf
		; Reset expression
		if Expression
			sslBaseExpression.ClearMFG(ActorRef)
		else
			sslBaseExpression.CloseMouth(ActorRef)
		endIf
	endIf
	; Remove SOS erection
	Debug.SendAnimationEvent(ActorRef, "SOSFlaccid")
endFunction

; ------------------------------------------------------- ;
; --- Data Accessors                                  --- ;
; ------------------------------------------------------- ;

function SetVictim(bool Victimize)
	IsVictim = Victimize
	if Victimize
		Thread.VictimRef    = ActorRef
		Thread.IsAggressive = true
	endIf
endFunction

bool function IsVictim()
	return IsVictim
endFunction

string function GetActorKey()
	return ActorKey
endFunction

int function GetEnjoyment()
	if !ActorRef
		Enjoyment = 0
	elseif IsCreature
		Enjoyment = (PapyrusUtil.ClampFloat((RealTime[0] - StartedAt) / 6.0, 0.0, 40.0) + ((Stage as float / Animation.StageCount as float) * 60.0)) as int
	else
		if Position == 0
			Thread.RecordSkills()
			Thread.SetBonuses()
		endIf
		Enjoyment = CalcEnjoyment(SkillBonus, Skills, Thread.LeadIn, IsFemale, (RealTime[0] - StartedAt), Stage, Animation.StageCount)
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
	if IsCreature
		return
	endIf
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

function ResolveStrapon(bool force = false)
	if Strapon
		if UseStrapon && !ActorRef.IsEquipped(Strapon)
			ActorRef.EquipItem(Strapon, true, true)
		elseIf !UseStrapon && ActorRef.IsEquipped(Strapon)
			ActorRef.UnequipItem(Strapon, true, true)
		endIf
	endIf
endFunction

function EquipStrapon()
	if Strapon && !ActorRef.IsEquipped(Strapon)
		ActorRef.EquipItem(Strapon, true, true)
	endIf
endFunction

function UnequipStrapon()
	if Strapon && ActorRef.IsEquipped(Strapon)
		ActorRef.UnequipItem(Strapon, true, true)
	endIf
endFunction

function SetStrapon(Form ToStrapon)
	if Strapon && !HadStrapon
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
		Thread.Log("Invalid strip override bool[] - Must be length 33 - was "+SetStrip.Length, "OverrideStrip()")
	else
		StripOverride = SetStrip
	endIf
endFunction

bool function IsStrippable(Form ItemRef)
	return ItemRef && (SexLabUtil.HasKeywordSub(ItemRef, "AlwaysStrip") || !SexLabUtil.HasKeywordSub(ItemRef, "NoStrip")) && (StorageUtil.FormListHas(none, "AlwaysStrip", ItemRef) || !StorageUtil.FormListHas(none, "NoStrip", ItemRef))
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
		Strip = Config.GetStrip(IsFemale, Thread.UseLimitedStrip(), Thread.IsAggressive, IsVictim)
	endIf
	; Stripped storage
	Form ItemRef
	Form[] Stripped = new Form[34]
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
	while i >= 0
		; Grab item in slot
		ItemRef = ActorRef.GetWornForm(Armor.GetMaskForSlot(i + 30))
		if ItemRef && (ActorLib.IsAlwaysStrip(ItemRef) || (Strip[i] && IsStrippable(ItemRef)))
			ActorRef.UnequipItem(ItemRef, false, true)
			Stripped[i] = ItemRef
		endIf
		; Move to next slot
		i -= 1
	endWhile
	; Equip the nudesuit
	if Strip[2] && ((Gender == 0 && Config.UseMaleNudeSuit) || (Gender == 1 && Config.UseFemaleNudeSuit))
		ActorRef.EquipItem(Config.NudeSuit, true, true)
	endIf
	; Store stripped items
	Equipment = PapyrusUtil.MergeFormArray(Equipment, PapyrusUtil.ClearNone(Stripped), true)
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
 	; Equip Stripped
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

function RefreshExpression()
	if !ActorRef || IsCreature
		; Do nothing
	elseIf OpenMouth
		sslBaseExpression.OpenMouth(ActorRef)
	elseIf Expression
		Expression.Apply(ActorRef, Enjoyment, BaseSex)
	elseIf sslBaseExpression.IsMouthOpen(ActorRef)
		sslBaseExpression.CloseMouth(ActorRef)
	endIf
endFunction

; ------------------------------------------------------- ;
; --- System Use                                      --- ;
; ------------------------------------------------------- ;

function TrackedEvent(string EventName)
	if IsTracked
		Thread.SendTrackedEvent(ActorRef, EventName)
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
	RegisterForModEvent(e+"Animate", "PlayAnimation")
	RegisterForModEvent(e+"Start", "StartAnimating")
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
	UnregisterForModEvent(e+"Animate")
	UnregisterForModEvent(e+"Start")
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
	HadStrapon     = none
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
	StripOverride  = Utility.CreateBoolArray(0)
	Equipment      = Utility.CreateFormArray(0)
	; Make sure alias is emptied
	TryToClear()
endFunction

function Setup()
	PlayerRef = Game.GetPlayer()
	Thread    = GetOwningQuest() as sslThreadController
	; Reset function Libraries - SexLabQuestFramework
	if !Config || !ActorLib || !Stats
		Form SexLabQuestFramework = Game.GetFormFromFile(0xD62, "SexLab.esm")
		if SexLabQuestFramework
			Config   = SexLabQuestFramework as sslSystemConfig
			ActorLib = SexLabQuestFramework as sslActorLibrary
			Stats    = SexLabQuestFramework as sslActorStats
		endIf
	endIf
endFunction

function Log(string msg, string src = "")
	msg = "ActorAlias["+ActorName+"] "+src+" - "+msg
	Debug.Trace("SEXLAB - " + msg)
	if Config.DebugMode
		SexLabUtil.PrintConsole(msg)
	endIf
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

; function AdjustCoords(float[] Output, float[] CenterCoords, ) global native
; function AdjustOffset(int i, float amount, bool backwards, bool adjustStage)
; 	Animation.
; endFunction

; function OffsetBed(float[] Output, float[] BedOffsets, float CenterRot) global native

; bool function _SetActor(Actor ProspectRef) native
; function _ApplyExpression(Actor ProspectRef, int[] Presets) global native


; function GetVars()
; 	IntShare = Thread.IntShare
; 	FloatShare = Thread.FloatS1hare
; 	StringShare = Thread.StringShare
; 	BoolShare
; endFunction

; int[] property IntShare auto hidden ; Stage, ActorCount, BedTypeID
; float[] property FloatShare auto hidden ; RealTime, StartedAt
; string[] property StringShare auto hidden ; AdjustKey
; bool[] property BoolShare auto hidden ; 
; sslBaseAnimation[] property _Animation auto hidden ; Animation


