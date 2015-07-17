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
bool IsSkilled

; Current Thread state
sslThreadController Thread
int Position

; string AnimEvent
string ActorKey

; Voice
sslBaseVoice Voice
VoiceType ActorVoice
bool IsForcedSilent
float BaseDelay
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
float[] Skills

float StartedAt
float ActorScale
float AnimScale
int BestRelation
int BaseEnjoyment
int Enjoyment
int Orgasms

Form Strapon
Form HadStrapon

Sound OrgasmFX

Spell HDTHeelSpell
Form HadBoots

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
	LoadShares()
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
	IsTracked  = Config.ThreadLib.IsActorTracked(ActorRef)
	IsPlayer   = ActorRef == PlayerRef
	; Player and creature specific
	if IsCreature
		Thread.CreatureRef = BaseRef.GetRace()
	elseIf !IsPlayer
		Stats.SeedActor(ActorRef)
	else
		Thread.HasPlayer = true
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
	; Set base voice/loop delay
	if IsCreature
		BaseDelay  = 3.0
	elseIf IsFemale
		BaseDelay  = Config.FemaleVoiceDelay
	else
		BaseDelay  = Config.MaleVoiceDelay
	endIf
	VoiceDelay = BaseDelay
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


; Thread/alias shares
bool DebugMode

int[] BedStatus
float[] RealTime
float[] SkillBonus
string[] AnimEvents
string[] AdjustKey
bool[] IsType
sslBaseAnimation[] sAnimation
sslBaseAnimation property Animation hidden
	sslBaseAnimation function get()
		return sAnimation[0]
	endFunction
endProperty
int[] sStage
int property Stage hidden
	int function get()
		return sStage[0]
	endFunction
endProperty


function LoadShares()
	DebugMode  = Config.DebugMode

	Center     = Thread.CenterLocation
	BedStatus  = Thread.BedStatus
	RealTime   = Thread.RealTime
	SkillBonus = Thread.SkillBonus
	AnimEvents = Thread.sAnimEvents
	IsType     = Thread.IsType

	AdjustKey  = Thread.sAdjustKey
	sAnimation = Thread.sAnimation
	sStage     = Thread.sStage

	Flags      = new int[5]
	Offsets    = new float[4]
	Loc        = new float[6]
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
		LoadShares()
		GetPosition()
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
		Log("display/base/animscale = "+display+"/"+base+"/"+AnimScale)
		; Stop movement
		LockActor()
		; Starting position
		OffsetCoords(Loc, Center, Offsets)
		MarkerRef.SetPosition(Loc[0], Loc[1], Loc[2])
		MarkerRef.SetAngle(Loc[3], Loc[4], Loc[5])
		ActorRef.SetPosition(Loc[0], Loc[1], Loc[2])
		ActorRef.SetAngle(Loc[3], Loc[4], Loc[5])
		AttachMarker()
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
			if Config.RemoveHeelEffect 
				HDTHeelSpell = Config.GetHDTSpell(ActorRef)
				if HDTHeelSpell
					Log(HDTHeelSpell, "HDTHeelSpell")
					ActorRef.RemoveSpell(HDTHeelSpell)
				endIf
			endIf
			; Pick a voice if needed
			if !Voice && !IsForcedSilent
				SetVoice(Config.VoiceSlots.PickVoice(ActorRef), IsForcedSilent)
			endIf
			; Pick an expression if needed
			if !Expression && Config.UseExpressions
				Expression = Config.ExpressionSlots.PickByStatus(ActorRef, IsVictim, IsType[0] && !IsVictim)
			endIf
		endIf
		IsSkilled = !IsCreature || sslActorStats.IsSkilled(ActorRef)
		if IsSkilled
			; Always use players stats for NPCS if present, so players stats mean something more
			Actor SkilledActor = ActorRef
			if !IsPlayer && Thread.HasPlayer 
				SkilledActor = PlayerRef
			; If a non-creature couple, base skills off partner
			elseIf Thread.ActorCount > 1 && !Thread.HasCreature
				SkilledActor = Thread.Positions[sslUtility.IndexTravel(Position, Thread.ActorCount)]
			endIf
			; Get sex skills of partner/player
			Skills       = Stats.GetSkillLevels(SkilledActor)
			BestRelation = Thread.GetHighestPresentRelationshipRank(ActorRef)
			if !IsVictim
				BaseEnjoyment = Utility.RandomInt(BestRelation, ((Skills[Stats.kLewd]*2) as int) + (BestRelation + 1))
			endIf
			Log("BaseEnjoyment: "+BaseEnjoyment)
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
	; Log("PlayAnimation("+Position+") - "+AnimEvents[Position])
	Debug.SendAnimationEvent(ActorRef, AnimEvents[Position])
endFunction

state Animating

	function StartAnimating()
		; TODO: Add a light source option here. (possibly with frostfall benefit?)
		; Remove from bard audience if in one
		Config.CheckBardAudience(ActorRef, true)
		; If enabled, start Auto TFC for player
		if IsPlayer && Config.AutoTFC
			SexLabUtil.EnableFreeCamera(true, Config.AutoSUCSM)
		endIf
		; Prepare for loop
		TrackedEvent("Start")
		StartedAt = RealTime[0]
		SyncAll(true)
		; Start update loop		
		UnregisterForModEvent(Thread.Key("Start"))
		RegisterForSingleUpdate(Utility.RandomFloat(1.0, 3.0))
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
		; Loop
		RegisterForSingleUpdate(VoiceDelay)
	endEvent

	function SyncThread()
		; Sync with thread info
		GetPosition()
		VoiceDelay = BaseDelay
		if !IsSilent && Stage > 1
			VoiceDelay -= (Stage * 0.8) + Utility.RandomFloat(-0.2, 0.4)
			if VoiceDelay < 0.8
				VoiceDelay = Utility.RandomFloat(0.8, 1.3) ; Can't have delay shorter than animation update loop
			endIf
		endIf

		; Sync status		
		if !IsCreature
			ResolveStrapon()
			RefreshExpression()
		endIf

		; Update alias info
		GetEnjoyment()
		Debug.SendAnimationEvent(ActorRef, "SOSBend"+Schlong)
		Log("Enjoyment: "+Enjoyment+" SOS: "+Schlong)

		; SyncLocation(false)
	endFunction

	function SyncActor()
		SyncThread()
		SyncLocation(false)
		Thread.SyncEventDone("Sync")
	endFunction

	function RefreshLoc()
		Offsets = Animation.PositionOffsets(Offsets, AdjustKey[0], Position, Stage, BedStatus[1])
		SyncLocation(true)
	endFunction

	function SyncLocation(bool Force = false)
		OffsetCoords(Loc, Center, Offsets)
		MarkerRef.SetPosition(Loc[0], Loc[1], Loc[2])
		MarkerRef.SetAngle(Loc[3], Loc[4], Loc[5])
		; Avoid forcibly setting on player coords if avoidable - causes annoying graphical flickering
		if Force && IsPlayer && IsInPosition(ActorRef, MarkerRef, 40.0)
			AttachMarker()
			ActorRef.TranslateTo(Loc[0], Loc[1], Loc[2], Loc[3], Loc[4], Loc[5], 5000, 0)
			return ; OnTranslationComplete() will take over when in place
		elseIf Force
			ActorRef.SetPosition(Loc[0], Loc[1], Loc[2])
			ActorRef.SetAngle(Loc[3], Loc[4], Loc[5])
		endIf
		AttachMarker()
		Snap()
	endFunction

	function Snap()
		; Quickly move into place and angle if actor is off by a lot
		if !IsInPosition(ActorRef, MarkerRef, 75.0)
			ActorRef.SetPosition(Loc[0], Loc[1], Loc[2])
			ActorRef.SetAngle(Loc[3], Loc[4], Loc[5])
			AttachMarker()
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

	function OnOrgasm()
		Enjoyment += 100
		OrgasmEffect()
		Thread.SyncEventDone("Orgasm")
	endfunction

	function OrgasmEffect()
		Orgasms += 1
		BaseEnjoyment -= Enjoyment
		Log("Orgasms: "+Orgasms+" Enjoyment: "+Enjoyment+" BaseEnjoyment: "+BaseEnjoyment)

		; Apply cum to female positions from male position orgasm
		int i = Thread.ActorCount
		if i > 1 && MalePosition && Config.UseCum && (IsMale || (Config.AllowFFCum && IsFemale))
			if i == 2
				Thread.PositionAlias(SexLabUtil.IntIfElse(Position == 1, 0, 1)).ApplyCum()
			else
				while i > 0
					i -= 1
					if Position != i && Animation.IsCumSource(Position, i, Stage)
						Thread.PositionAlias(i).ApplyCum()
					endIf
				endWhile
			endIf
		endIf

		; Send an orgasm event hook with actor and orgasm count
		int eid = ModEvent.Create("SexLabOrgasm")
		ModEvent.PushForm(eid, ActorRef)
		ModEvent.PushInt(eid, Orgasms)
		ModEvent.Send(eid)

		; Shake camera for player
		if IsPlayer && Game.GetCameraState() != 3
			Game.ShakeCamera(none, 1.00, 2.0)
		endIf

		; Play SFX/Voice
		if !IsSilent
			Voice.Moan(ActorRef, 100, false)
			OrgasmFX.Play(ActorRef)
			Voice.Moan(ActorRef, 100, false)
		else
			OrgasmFX.Play(ActorRef)
		endIf

		; VoiceDelay = 0.8
		RegisterForSingleUpdate(0.8)
	endFunction

	event ResetActor()
		ClearEvents()
		GoToState("Resetting")
		Log("Resetting!")
		; Update stats
		if !IsCreature
			Log("Stats BEFORE: "+sslActorStats.GetSkills(ActorRef))
			sslActorStats.RecordThread(ActorRef, Gender, BestRelation, StartedAt, Utility.GetCurrentRealTime(), Utility.GetCurrentGameTime(), Thread.HasPlayer, Thread.VictimRef, Thread.Genders, Thread.SkillXP)
			Log("Stats AFTER: "+sslActorStats.GetSkills(ActorRef))
			; Stats.RecordThread(ActorRef, (IsPlayer || Thread.HasPlayer), Thread.ActorCount, BestRelation, (Utility.GetCurrentRealTime() - StartedAt), Thread.VictimRef, Thread.SkillXP, Thread.Genders)
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

function SyncAll(bool Force = false)
	SyncThread()
	SyncLocation(Force)
endFunction

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
	; Clear possibly troublesome effects
	ActorRef.StopTranslation()
	ActorRef.SetVehicle(none)
	; Stop animevent
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

function AttachMarker()
	ActorRef.SetVehicle(MarkerRef)
	if AnimScale != 1.0
		ActorRef.SetScale(AnimScale)
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
	AttachMarker()
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
		; ActorRef.SetDontMove(false)
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
		ActorRef.ClearExpressionOverride()
		ActorRef.ResetExpressionOverrides()
	endIf
	; Remove SOS erection
	Debug.SendAnimationEvent(ActorRef, "SOSFlaccid")
endFunction

; ------------------------------------------------------- ;
; --- Data Accessors                                  --- ;
; ------------------------------------------------------- ;

int function GetGender()
	return Gender
endFunction

function SetVictim(bool Victimize)
	; Make victim
	if Victimize && Thread.Victims.Find(ActorRef) == -1
		IsType[0]        = true
		Thread.VictimRef = ActorRef
		Thread.Victims   = PapyrusUtil.PushActor(Thread.Victims, ActorRef)
	; Was victim but now isn't, update thread
	elseIf IsVictim && !Victimize
		Actor[] Victims = Thread.Victims
		if Victims.Length > 1
			Thread.VictimRef  = Thread.Victims[0]
			Thread.Victims    = PapyrusUtil.RemoveActor(Thread.Victims, ActorRef)
		else
			IsType[0]         = false
			Thread.VictimRef  = none
			Thread.Victims[0] = none
		endIf
	endIf
	IsVictim = Victimize
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
	elseif !IsSkilled
		Enjoyment = (PapyrusUtil.ClampFloat(((RealTime[0] - StartedAt) + 1.0) / 7.0, 0.0, 40.0) + ((Stage as float / Animation.StageCount as float) * 60.0)) as int
	else
		if Position == 0
			Thread.RecordSkills()
			Thread.SetBonuses()
		endIf
		Enjoyment = BaseEnjoyment + CalcEnjoyment(SkillBonus, Skills, Thread.LeadIn, IsFemale, (RealTime[0] - StartedAt), Stage, Animation.StageCount)
		if Enjoyment < 0
			Enjoyment = 0
		elseIf Enjoyment >= 100
			if Config.SeparateOrgasms
				OrgasmEffect()
			else
				Enjoyment = 100
			endIf
		endIf
	endIf
	return Enjoyment
endFunction

function ApplyCum()
	if ActorRef
		int CumID = Animation.GetCumID(Position, Stage)
		if CumID > 0
			ActorLib.ApplyCum(ActorRef, CumID)
		endIf
	endIf
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

bool function PregnancyRisk()
	int cumID = Animation.GetCumID(Position, Stage)
	return cumID > 0 && (cumID == 1 || cumID == 4 || cumID == 5 || cumID == 7) && IsFemale && !MalePosition && Thread.IsVaginal
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
		Strip = Config.GetStrip(IsFemale, Thread.UseLimitedStrip(), IsType[0], IsVictim)
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
	else
		sslBaseExpression.CloseMouth(ActorRef)
		if Expression
			Expression.Apply(ActorRef, Enjoyment, BaseSex)
		endIf
	endIf
endFunction

function GetPosition()
	if ActorRef
		Position = Thread.Positions.Find(ActorRef)
		Flags    = Animation.PositionFlags(Flags, AdjustKey[0], Position, Stage)
		Offsets  = Animation.PositionOffsets(Offsets, AdjustKey[0], Position, Stage, BedStatus[1])
		AnimEvents[Position] = Animation.FetchPositionStage(Position, Stage)
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
	RegisterForModEvent(e+"Orgasm", "OnOrgasm")
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
	HDTHeelSpell   = none
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
	BestRelation   = 0
	BaseEnjoyment  = 0
	; Strings
	ActorKey       = ""
	; Storage
	StripOverride  = Utility.CreateBoolArray(0)
	Equipment      = Utility.CreateFormArray(0)
	; Make sure alias is emptied
	TryToClear()
endFunction

function Setup()
	; Reset function Libraries - SexLabQuestFramework
	if !Config || !ActorLib || !Stats
		Form SexLabQuestFramework = Game.GetFormFromFile(0xD62, "SexLab.esm")
		if SexLabQuestFramework
			Config   = SexLabQuestFramework as sslSystemConfig
			ActorLib = SexLabQuestFramework as sslActorLibrary
			Stats    = SexLabQuestFramework as sslActorStats
		endIf
	endIf
	PlayerRef = Game.GetPlayer()
	Thread    = GetOwningQuest() as sslThreadController
	OrgasmFX  = Config.OrgasmFX
endFunction

function Log(string msg, string src = "")
	msg = "ActorAlias["+ActorName+"] "+src+" - "+msg
	Debug.Trace("SEXLAB - " + msg)
	if DebugMode
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
	OrgasmEffect()
	Thread.SyncEventDone("Orgasm")
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

; int[] property IntShare auto hidden ; Stage, ActorCount, BedStatus[1]
; float[] property FloatShare auto hidden ; RealTime, StartedAt
; string[] property StringShare auto hidden ; AdjustKey
; bool[] property BoolShare auto hidden ; 
; sslBaseAnimation[] property _Animation auto hidden ; Animation

