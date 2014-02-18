scriptname sslActorAlias extends ReferenceAlias

; Necessary libraries
sslActorLibrary property Lib auto
sslSystemConfig property Config auto

; Actor Info
Actor property ActorRef auto hidden
int property Gender auto hidden
bool IsMale
bool IsFemale
bool IsCreature
bool IsPlayer
bool IsVictim
string ActorName
ActorBase BaseRef

; Current Thread state
int Stage
int Position
int Strength
sslBaseAnimation Animation
sslThreadController Thread

; Voice
bool IsForcedSilent
float VoiceDelay
sslBaseVoice Voice

; Positioning
ObjectReference MarkerRef
float[] Loc

; Storage
int[] Flags
float[] Offsets
bool[] StripOverride
float ActorScale
float AnimScale
form strapon

; Animation Position/Stage flags
bool property OpenMouth hidden
	bool function get()
		return Flags[0] == 0
	endFunction
endProperty
bool property IsSilent hidden
	bool function get()
		return (Voice == none || IsForcedSilent || IsCreature || Flags[0] == 1)
	endFunction
endProperty
bool property UseStrapon hidden
	bool function get()
		return Flags[0] == 1
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

bool function PrepareAlias(Actor ProspectRef, bool MakeVictim = false, sslBaseVoice UseVoice = none, bool ForceSilence = false)
	if ProspectRef == none || GetReference() != ProspectRef || !Lib.ValidateActor(ProspectRef)
		return false ; Failed to set prospective actor into alias
	endIf
	; Register actor as active
	StorageUtil.FormListAdd(Lib, "Registry", ProspectRef, false)
	; Init actor alias information
	ActorRef = ProspectRef
	BaseRef = ActorRef.GetLeveledActorBase()
	ActorName = BaseRef.GetName()
	Gender = Lib.GetGender(ActorRef)
	IsMale = Gender == 0
	IsFemale = Gender == 1
	IsCreature = Gender == 2
	IsPlayer = ActorRef == Lib.PlayerRef
	IsForcedSilent = ForceSilence
	Voice = UseVoice
	IsVictim = MakeVictim
	if MakeVictim
		Thread.VictimRef = ActorRef
		Thread.IsAggressive = true
	endIf
	Thread.Log("Slotted '"+ActorName+"'", self)
	GoToState("")
	return true
endFunction

function Clear()
	if GetReference() != none
		StorageUtil.FormListRemove(Lib, "Registry", GetReference(), true)
		UnlockActor()
	endIf
	parent.Clear()
	Initialize()
endFunction

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
			ActorRef.SetPosition(loc[0], loc[1], loc[2])
			ActorRef.SetAngle(loc[3], loc[4], loc[5])
			ActorRef.PushActorAway(ActorRef, 0.75)
		endIf
	endIf
endFunction

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
	; Disable free camera, if in it
	if IsPlayer && Game.GetCameraState() == 3
		MiscUtil.ToggleFreeCamera()
	endIf
	; Enable movement
	if IsPlayer
		Thread.DisableHotkeys()
		Game.SetPlayerAIDriven(false)
		Game.EnablePlayerControls(false, false, false, false, false, false, true, false, 0)
	else
		; ActorRef.SetRestrained(false)
		ActorRef.SetDontMove(false)
	endIf
	; Remove from animation faction
	ActorRef.RemoveFromFaction(Lib.AnimatingFaction)
	ActorUtil.RemovePackageOverride(ActorRef, Lib.DoNothing)
	ActorRef.EvaluatePackage()
	; Detach positioning marker
	ActorRef.StopTranslation()
	ActorRef.SetVehicle(none)
	; Cleanup
	if !IsCreature
		TryToStopCombat()
		if ActorRef.IsWeaponDrawn()
			ActorRef.SheatheWeapon()
		endIf
	endIf
endFunction

; ------------------------------------------------------- ;
; --- Actor Prepartion                                --- ;
; ------------------------------------------------------- ;

state Prepare
	function FireAction()
		RegisterForSingleUpdate(0.05)
	endFunction
	event OnUpdate()
		; TryToStopCombat()
		if ActorRef.IsWeaponDrawn()
			ActorRef.SheatheWeapon()
		endIf
		LockActor()
		; Init alias info
		Loc = new float[6]
		; Update info
		Animation = Thread.Animation
		Stage     = Thread.Stage
		Position  = Thread.Positions.Find(ActorRef)
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
			Strip(DoUndress)
		endIf
		; Make SOS erect
		Debug.SendAnimationEvent(ActorRef, "SOSFastErect")
		GoToState("Ready")
	endEvent
endState

state Ready
	function StartAnimating()
		Thread.Log(ActorName+" -- Starting Animation")
		Action("Animating")
	endFunction
endState

; ------------------------------------------------------- ;
; --- Animation Loop                                  --- ;
; ------------------------------------------------------- ;

state Animating
	function FireAction()
		RegisterForSingleUpdate(Utility.RandomFloat(0.50,1.80))
		SyncThread(Thread.Animation, Thread.Stage, true)
	endFunction

	event OnUpdate()
		if ActorRef.IsDead() || ActorRef.IsDisabled()
			Debug.TraceAndBox(ActorName+" is dead or some shit happened.")
			return
		endIf
		Moan()
		RegisterForSingleUpdate(VoiceDelay)
	endEvent

	function SyncThread(sslBaseAnimation ToAnimation, int ToStage, bool force = false)
		; Sync info
		Animation = ToAnimation
		Stage     = ToStage
		Position  = Thread.Positions.Find(ActorRef)
		Flags     = Animation.GetPositionFlags(Position, Stage)
		Offsets   = Animation.GetPositionOffsets(Position, Stage)
		; Update positioning marker
		UpdateLocation(force)
		; Voice loop delay
		VoiceDelay = 3.0
		if !IsSilent
			VoiceDelay = Config.GetVoiceDelay(IsFemale, Stage)
		endIf
		; Voice strength
		if Stage == 1 && Animation.StageCount == 1
			Strength = 75
		else
			Strength = ((Stage as float) / (Animation.StageCount as float) * 100.0) as int
			if Thread.LeadIn
				Strength = ((Strength as float) * 0.70) as int
			endIf
		endIf
		; Send schlong offset
		if MalePosition
			Debug.SendAnimationEvent(ActorRef, "SOSBend"+Schlong)
		endIf
	endFunction

	function UpdateLocation(bool force = false)
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
		if force
			ActorRef.SetPosition(loc[0], loc[1], loc[2])
			ActorRef.SetAngle(loc[3], loc[4], loc[5])
		endIf
		ActorRef.SetVehicle(MarkerRef)
		ActorRef.SetScale(AnimScale)
		Snap()
	endFunction

	function Snap()
		Thread.Log(ActorName+" - Snapping")
		; Quickly move into place if actor isn't positioned right
		if ActorRef.GetDistance(MarkerRef) > 0.60
			Thread.Log(ActorName+" - Is out of position by "+ActorRef.GetDistance(MarkerRef))
			ActorRef.SplineTranslateTo(loc[0], loc[1], loc[2], loc[3], loc[4], loc[5], 1.0, 50000, 0)
			return ; OnTranslationComplete() will take over when in place
		endIf
		; Force angle if translation didn't rotate them properly
		if Math.Abs(ActorRef.GetAngleZ() - MarkerRef.GetAngleZ()) > 0.50; || Math.Abs(ActorRef.GetAngleX() - MarkerRef.GetAngleX()) > 0.5
			ActorRef.SetAngle(loc[3], loc[4], loc[5])
			ActorRef.SetVehicle(MarkerRef)
			ActorRef.SetScale(AnimScale)
		endIf
		; Begin very slowly rotating a small amount to hold position
		ActorRef.SplineTranslateTo(loc[0], loc[1], loc[2], loc[3], loc[4], loc[5]+0.1, 1.0, 10000, 0.0001)
	endFunction

	event OnTranslationComplete()
		Utility.Wait(0.50)
		Thread.Log(ActorName+" - Completed Translation")
		Snap()
	endEvent

	function Moan()
		if !IsSilent
			Thread.Log(ActorName+" - MOANING")
			; Voice.Moan(ActorRef, Strength)
		endIf
	endFunction

endState

state Reset
	function FireAction()
		RegisterForSingleUpdate(0.05)
	endFunction
	event OnUpdate()
		; Reset to starting scale
		if ActorScale != 0.0
			ActorRef.SetScale(ActorScale)
		endIf
		; Apply cum
		int cum = Animation.GetCum(position)
		if !Thread.FastEnd && cum > 0 && Config.bUseCum && (Thread.Males > 0 || Config.bAllowFFCum || Thread.HasCreature)
			Lib.ApplyCum(ActorRef, cum)
		endIf
		; Stop animating
		StopAnimating(Thread.FastEnd)
		Debug.SendAnimationEvent(ActorRef, "SOSFlaccid")
		; Unstrip
		if !ActorRef.IsDead()
			Lib.UnstripStored(ActorRef, IsVictim)
		endIf
		; Unlock the actor and alias
		Clear()
	endEvent
endState

; ------------------------------------------------------- ;
; --- Data Accessors                                  --- ;
; ------------------------------------------------------- ;

function OverrideStrip(bool[] SetStrip)
	if SetStrip.Length != 33
		Thread.Log(ActorName+" -- Invalid strip bool override array given. Must be length 33; was given "+SetStrip.Length, "ERROR")
	else
		StripOverride = SetStrip
	endIf
endFunction

function Strip(bool DoAnimate = true)
	if !IsCreature
		if StripOverride.Length != 33
			Lib.StoreStripped(ActorRef, Config.GetStrip(IsFemale, Thread.LeadIn, Thread.IsAggressive, IsVictim), DoAnimate)
		else
			Lib.StoreStripped(ActorRef, StripOverride, DoAnimate)
		endIf
	endIf
endFunction

bool DisableRagdoll
bool property DoRagdoll hidden
	bool function get()
		if DisableRagdoll
			return false
		endIf
		return Config.bRagDollEnd
	endFunction
	function set(bool value)
		DisableRagdoll = !value
	endFunction
endProperty

bool DisableUndressAnim
bool property DoUndress hidden
	bool function get()
		if DisableUndressAnim
			return false
		endIf
		return Config.bUndressAnimation
	endFunction
	function set(bool value)
		DisableUndressAnim = !value
	endFunction
endProperty

; ------------------------------------------------------- ;
; --- System Use                                      --- ;
; ------------------------------------------------------- ;

function Initialize()
	UnregisterForUpdate()
	GoToState("")
	Thread = (GetOwningQuest() as sslThreadController)
	Lib = (Quest.GetQuest("SexLabQuestFramework") as sslActorLibrary)
	Config = (Quest.GetQuest("SexLabQuestFramework") as sslSystemConfig)
	if MarkerRef
		MarkerRef.Disable()
		MarkerRef.Delete()
	endIf
	; Forms
	MarkerRef = none
	ActorRef = none
	IsForcedSilent = false
endFunction

; event OnInit()
; 	Thread = (GetOwningQuest() as sslThreadController)
; 	Lib = (Quest.GetQuest("SexLabQuestFramework") as sslActorLibrary)
; 	Config = (Quest.GetQuest("SexLabQuestFramework") as sslSystemConfig)
; endEvent

function Action(string FireState)
	UnregisterForUpdate()
	if ActorRef != none
		GoToState(FireState)
		FireAction()
	endIf
endFunction

; ------------------------------------------------------- ;
; --- State Restricted                                --- ;
; ------------------------------------------------------- ;

; Ready
function StartAnimating()
endFunction
; Animating
function SyncThread(sslBaseAnimation ToAnimation, int ToStage, bool force = false)
endFunction
function UpdateLocation(bool force = false)
endFunction
function Snap()
endFunction
event OnTranslationComplete()
endEvent
function Moan()
endFunction
; Varied
function FireAction()
endFunction
