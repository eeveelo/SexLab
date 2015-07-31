scriptname sslThreadModel extends Quest hidden
{ Animation Thread Model: Runs storage and information about a thread. Access only through functions; NEVER create a property directly to this. }

; import sslUtility
; import StorageUtil
; import SexLabUtil

int thread_id
int property tid hidden
	int function get()
		return thread_id
	endFunction
endProperty

bool property IsLocked hidden
	bool function get()
		return GetState() != "Unlocked"
	endFunction
endProperty

; Library & Data
sslSystemConfig property Config auto
sslActorLibrary property ActorLib auto
sslThreadLibrary property ThreadLib auto
sslAnimationSlots property AnimSlots auto
sslCreatureAnimationSlots property CreatureSlots auto

; Actor Info
sslActorAlias[] property ActorAlias auto hidden
Actor[] property Positions auto hidden
Actor property PlayerRef auto hidden

; Thread status
; bool[] property Status auto hidden
bool property HasPlayer auto hidden
bool property AutoAdvance auto hidden
bool property LeadIn auto hidden
bool property FastEnd auto hidden

; Creature animation
Race property CreatureRef auto hidden

; Animation Info
int property Stage auto hidden
int property ActorCount auto hidden
Sound property SoundFX auto hidden
string property AdjustKey auto hidden

sslBaseAnimation property Animation auto hidden
sslBaseAnimation[] CustomAnimations
sslBaseAnimation[] PrimaryAnimations
sslBaseAnimation[] LeadAnimations
sslBaseAnimation[] property Animations hidden
	sslBaseAnimation[] function get()
		if CustomAnimations.Length > 0
			return CustomAnimations
		elseIf LeadIn
			return LeadAnimations
		else
			return PrimaryAnimations
		endIf
	endFunction
endProperty

; Stat Tracking Info
float[] property SkillBonus auto hidden ; [0] Foreplay, [1] Vaginal, [2] Anal, [3] Oral, [4] Pure, [5] Lewd
float[] property SkillXP auto hidden    ; [0] Foreplay, [1] Vaginal, [2] Anal, [3] Oral, [4] Pure, [5] Lewd

bool[] property IsType auto hidden ; [0] IsAggressive, [1] IsVaginal, [2] IsAnal, [3] IsOral, [4] IsLoving, [5] IsDirty
bool property IsAggressive hidden
	bool function get()
		return IsType[0]
	endfunction
	function set(bool value)
		IsType[0] = value
	endFunction
endProperty
bool property IsVaginal hidden
	bool function get()
		return IsType[1]
	endfunction
	function set(bool value)
		IsType[1] = value
	endFunction
endProperty
bool property IsAnal hidden
	bool function get()
		return IsType[2]
	endfunction
	function set(bool value)
		IsType[2] = value
	endFunction
endProperty
bool property IsOral hidden
	bool function get()
		return IsType[3]
	endfunction
	function set(bool value)
		IsType[3] = value
	endFunction
endProperty
bool property IsLoving hidden
	bool function get()
		return IsType[4]
	endfunction
	function set(bool value)
		IsType[4] = value
	endFunction
endProperty
bool property IsDirty hidden
	bool function get()
		return IsType[5]
	endfunction
	function set(bool value)
		IsType[5] = value
	endFunction
endProperty

; Timer Info
bool UseCustomTimers
float[] CustomTimers
float[] ConfigTimers
float[] property Timers hidden
	float[] function get()
		if UseCustomTimers
			return CustomTimers
		endIf
		return ConfigTimers
	endFunction
	function set(float[] value)
		if UseCustomTimers
			CustomTimers = value
		else
			ConfigTimers = value
		endIf
	endFunction
endProperty

; Thread info
float[] property CenterLocation auto hidden
ObjectReference property CenterRef auto hidden

float[] property RealTime auto hidden
float property StartedAt auto hidden
float property TotalTime hidden
	float function get()
		return RealTime[0] - StartedAt
	endFunction
endProperty

Actor[] property Victims auto hidden
Actor property VictimRef hidden
	Actor function get()
		if !Victims || Victims.Length < 1
			return none
		endIf
		return Victims[(Victims.Length - 1)]
	endFunction
	function set(Actor ActorRef)
		if ActorRef
			if !Victims || Victims.Find(ActorRef) == -1
				Victims = PapyrusUtil.PushActor(Victims, ActorRef)
			endIf
			IsAggressive = true
		else
			Victims = PapyrusUtil.ActorArray(0)
			IsAggressive = false
		endIf
	endFunction
endProperty

; Beds
int[] property BedStatus auto hidden
; BedStatus[0] = -1 forbid, 0 allow, 1 force
; BedStatus[1] = -1 none, 0 bedroll, 1 single, 2 double
ObjectReference property BedRef auto hidden
int property BedTypeID hidden
	int function get()
		return BedStatus[1]
	endFunction
endProperty
bool property UsingBed hidden
	bool function get()
		return BedStatus[1] > 0
	endFunction
endProperty
bool property UsingBedRoll hidden
	bool function get()
		return BedStatus[1] == 1
	endFunction
endProperty
bool property UsingSingleBed hidden
	bool function get()
		return BedStatus[1] == 2
	endFunction
endProperty
bool property UsingDoubleBed hidden
	bool function get()
		return BedStatus[1] == 3
	endFunction
endProperty

; Genders
int[] property Genders auto hidden
int property Males hidden
	int function get()
		return Genders[0]
	endFunction
endProperty
int property Females hidden
	int function get()
		return Genders[1]
	endFunction
endProperty
int property MaleCreatures hidden
	int function get()
		return Genders[2]
	endFunction
endProperty
int property FemaleCreatures hidden
	int function get()
		return Genders[3]
	endFunction
endProperty
int property Creatures hidden
	int function get()
		return Genders[2] + Genders[3]
	endFunction
endProperty
bool property HasCreature hidden
	bool function get()
		return Creatures > 0
	endFunction
endProperty

; Local readonly
bool NoLeadIn
string[] Hooks
string[] Tags
string ActorKeys

; Debug testing
bool property DebugMode auto hidden
float property t auto hidden

; ------------------------------------------------------- ;
; --- Thread Making API                               --- ;
; ------------------------------------------------------- ;

state Making
	event OnUpdate()
		Fatal("Thread has timed out of the making process; resetting model for selection pool")
	endEvent
	event OnBeginState()
		Log("Entering Making State")
		; Action Events
		RegisterForModEvent(Key(EventTypes[0]+"Done"), EventTypes[0]+"Done")
		RegisterForModEvent(Key(EventTypes[1]+"Done"), EventTypes[1]+"Done")
		RegisterForModEvent(Key(EventTypes[2]+"Done"), EventTypes[2]+"Done")
		RegisterForModEvent(Key(EventTypes[3]+"Done"), EventTypes[3]+"Done")
	endEvent

	int function AddActor(Actor ActorRef, bool IsVictim = false, sslBaseVoice Voice = none, bool ForceSilent = false)
		; Ensure we can add actor to thread
		if !ActorRef
			Fatal("Failed to add actor -- Actor is a figment of your imagination", "AddActor(NONE)")
			return -1
		elseIf ActorCount >= 5
			Fatal("Failed to add actor -- Thread has reached actor limit", "AddActor("+ActorRef.GetLeveledActorBase().GetName()+")")
			return -1
		elseIf Positions.Find(ActorRef) != -1
			Fatal("AddActor("+ActorRef.GetLeveledActorBase().GetName()+") -- Failed to add actor -- They have been already added to this thread", "AddActor("+ActorRef.GetLeveledActorBase().GetName()+")")
			return -1
		elseIf ActorLib.ValidateActor(ActorRef) < 0
			Fatal("AddActor("+ActorRef.GetLeveledActorBase().GetName()+") -- Failed to add actor -- They are not a valid target for animation", "AddActor("+ActorRef.GetLeveledActorBase().GetName()+")")
			return -1
		endIf
		sslActorAlias Slot = PickAlias(ActorRef)
		if !Slot || !Slot.SetActor(ActorRef)
			Fatal("AddActor("+ActorRef.GetLeveledActorBase().GetName()+") -- Failed to add actor -- They were unable to fill an actor alias", "AddActor("+ActorRef.GetLeveledActorBase().GetName()+")")
			return -1
		endIf
		; Update position info
		Positions  = PapyrusUtil.PushActor(Positions, ActorRef)
		ActorCount = Positions.Length
		; Update gender counts
		int g      = Slot.GetGender()
		Genders[g] = Genders[g] + 1
		; Flag as victim
		Slot.SetVictim(IsVictim)
		Slot.SetVoice(Voice, ForceSilent)
		; Return position
		return Positions.Find(ActorRef)
	endFunction

	bool function AddActors(Actor[] ActorList, Actor VictimActor = none)
		int Count = ActorList.Length
		if Count < 1 || ((Positions.Length + Count) > 5) || ActorList.Find(none) != -1
			Fatal("Failed to add actor list as it either contains to many actors placing the thread over it's limit, none at all, or an invalid 'None' entry -- "+ActorList, "AddActors()")
			return false
		endIf
		int i
		while i < Count
			if AddActor(ActorList[i], (ActorList[i] == VictimActor)) == -1
				return false
			endIf
			i += 1
		endWhile
		return true
	endFunction

	sslThreadController function StartThread()
		GoToState("Starting")
		UnregisterForUpdate()
		int i

		; ------------------------- ;
		; --   Validate Thread   -- ;
		; ------------------------- ;

		if ActorCount < 1 || Positions.Length == 0
			Fatal("No valid actors available for animation")
			return none
		endIf

		; ------------------------- ;
		; --    Locate Center    -- ;
		; ------------------------- ;

		; Search location marker near player or first position
		if !CenterRef
			if HasPlayer
				CenterOnObject(Game.FindClosestReferenceOfTypeFromRef(Config.LocationMarker, PlayerRef, 750.0))
			else
				CenterOnObject(Game.FindClosestReferenceOfTypeFromRef(Config.LocationMarker, Positions[0], 750.0))
			endIf
		endIf
		; Search for nearby bed
		if !CenterRef && BedStatus[0] != -1
			CenterOnBed(HasPlayer, 750.0)
		endIf
		; Center on fallback choices
		if !CenterRef
			if IsType[0]
				CenterOnObject(Victims[0])
			elseIf HasPlayer
				CenterOnObject(PlayerRef)
			else
				CenterOnObject(Positions[0])
			endIf
		endIf

		; ------------------------- ;
		; -- Validate Animations -- ;
		; ------------------------- ;

		; Validate and grab creature animations
		if HasCreature
			Log("CreatureRef: "+CreatureRef)
			; primary creature animations
			i = PrimaryAnimations.Length
			while i
				i -= 1
				if !PrimaryAnimations[i].HasRace(CreatureRef) || PrimaryAnimations[i].PositionCount != ActorCount
					Log("Invalid creture animation added - "+PrimaryAnimations[i].Name)
					PrimaryAnimations = sslUtility.AnimationArray(0)
					i = 0
				endIf
			endWhile
			; leadin creature animations
			i = LeadAnimations.Length
			while i
				i -= 1
				if !LeadAnimations[i].HasRace(CreatureRef) || LeadAnimations[i].PositionCount != ActorCount
					Log("Invalid creature lead in animation added - "+PrimaryAnimations[i].Name)

					LeadAnimations = sslUtility.AnimationArray(0)
					LeadIn = false
					i = 0
				endIf
			endWhile
			if Config.UseCreatureGender
				PrimaryAnimations = CreatureSlots.FilterCreatureGenders(PrimaryAnimations, Genders[2], Genders[3])
			endIf
			; Pick default creature animations if currently empty (none or failed above check)
			if PrimaryAnimations.Length == 0
				Log("Selecting new creature animations - "+PrimaryAnimations)
				; sslBaseAnimation[] CreatureAnimations = CreatureSlots.GetByRace(ActorCount, CreatureRef)
				; CreatureSlots.FilterCreatureGenders(CreatureAnimations, Genders[2], Genders[3])
				Log("Creature Genders: "+Genders)
				sslBaseAnimation[] CreatureAnimations = CreatureSlots.GetByRaceGenders(ActorCount, CreatureRef, Genders[2], Genders[3])
				SetAnimations(CreatureAnimations)
				if PrimaryAnimations.Length == 0
					Fatal("Failed to find valid creature animations.")
					return none
				endIf
			endIf
			; Sort the actors to creature order
			Positions = ThreadLib.SortCreatures(Positions, PrimaryAnimations[0])

		; Get default primary animations if none
		elseIf PrimaryAnimations.Length == 0
			SetAnimations(AnimSlots.GetByDefault(Males, Females, IsType[0], (BedRef != none), Config.RestrictAggressive))
			if PrimaryAnimations.Length == 0
				Fatal("Unable to find valid default animations")
				return none
			endIf
		endIf

		; Get default foreplay if none and enabled
		if !HasCreature && !IsType[0] && ActorCount == 2 && !NoLeadIn && LeadAnimations.Length == 0 && Config.ForeplayStage
			if BedRef
				SetLeadAnimations(AnimSlots.GetByTags(2, "LeadIn", SexLabUtil.StringIfElse(Config.BedRemoveStanding, "Furniture,Standing", "Furniture")))
			else
				SetLeadAnimations(AnimSlots.GetByTags(2, "LeadIn"))
			endIf
		endIf

		if CustomAnimations || CustomAnimations.Length < 1
			
			; Filter animations based on user settings and scene
			string[] Filters
			sslBaseAnimation[] FilteredPrimary
			sslBaseAnimation[] FilteredLead

			; Remove non same sex animations per user settings
			if ActorCount > 1 && Creatures == 0 && (Males == 0 || Females == 0) && Config.RestrictSameSex
				Filters    = new string[1]
				Filters[0] = SexLabUtil.GetGenderTag(Females, Males)
				; Remove non-tagged from primary
				FilteredPrimary = sslUtility.FilterTaggedAnimations(PrimaryAnimations, Filters, true)
				if FilteredPrimary.Length > 0
					Log("Filtered out '"+(PrimaryAnimations.Length - FilteredPrimary.Length)+"' Non Same Sex Primary Animations with tags: "+Filters)
					PrimaryAnimations = FilteredPrimary
				endIf
				; Remove furniture/standing animations from lead in
				if LeadIn && LeadAnimations.Length > 0
					FilteredLead = sslUtility.FilterTaggedAnimations(LeadAnimations, Filters, true)
					if FilteredLead.Length > 0
						Log("Filtered out '"+(LeadAnimations.Length - FilteredLead.Length)+"' Non Same Sex Lead In Animations with tags: "+Filters)
						LeadAnimations = FilteredLead
					endIf
				endIf
			endIf

			; Filter non-bed friendly animations
			if BedRef
				Filters = new string[1]
				Filters[0] = "Furniture"
				if Config.BedRemoveStanding
					Filters = PapyrusUtil.PushString(Filters, "Standing")
				endIf
				; Remove furniture/standing animations from primary
				FilteredPrimary = sslUtility.FilterTaggedAnimations(PrimaryAnimations, Filters, false)
				if FilteredPrimary.Length > 0
					Log("Filtered out '"+(PrimaryAnimations.Length - FilteredPrimary.Length)+"' Primary Animations with tags: "+Filters)
					PrimaryAnimations = FilteredPrimary
				endIf
				; Remove furniture/standing animations from lead in
				if LeadIn && LeadAnimations.Length > 0
					FilteredLead = sslUtility.FilterTaggedAnimations(LeadAnimations, Filters, false)
					if FilteredLead.Length > 0
						Log("Filtered out '"+(LeadAnimations.Length - FilteredLead.Length)+"' Lead In Animations with tags: "+Filters)
						LeadAnimations = FilteredLead
					endIf
				endIf
			endIf

			; Make sure we are still good to start after all the filters
			if LeadAnimations.Length < 1
				LeadIn = false
			endIf
			if PrimaryAnimations.Length < 1
				Fatal("Empty primary animations after filters")
				return none
			endIf

		endIf
		
		; ------------------------- ;
		; --  Start Controller   -- ;
		; ------------------------- ;

		Action("Prepare")
		return self as sslThreadController
	endFunction

endState

; ------------------------------------------------------- ;
; --- Actor Setup                                     --- ;
; ------------------------------------------------------- ;

bool function UseLimitedStrip()
	return LeadIn || (Config.LimitedStrip && AnimSlots.CountTag(Animations, "Oral,Foreplay,LimitedStrip") == Animations.Length)
endFunction

; Actor Overrides
function SetStrip(Actor ActorRef, bool[] StripSlots)
	if StripSlots.Length == 33
		ActorAlias(ActorRef).OverrideStrip(StripSlots)
	else
		Log("Malformed StripSlots bool[] passed, must be 33 length bool array, "+StripSlots.Length+" given", "ERROR")
	endIf
endFunction

function DisableUndressAnimation(Actor ActorRef, bool disabling = true)
	ActorAlias(ActorRef).DoUndress = !disabling
endFunction

function DisableRedress(Actor ActorRef, bool disabling = true)
	ActorAlias(ActorRef).DoRedress = !disabling
endFunction

function DisableRagdollEnd(Actor ActorRef, bool disabling = true)
	ActorAlias(ActorRef).DoRagdoll = !disabling
endFunction

function SetStartAnimationEvent(Actor ActorRef, string EventName = "", float PlayTime = 0.1)
	ActorAlias(ActorRef).SetStartAnimationEvent(EventName, PlayTime)
endFunction

function SetEndAnimationEvent(Actor ActorRef, string EventName = "IdleForceDefaultState")
	ActorAlias(ActorRef).SetEndAnimationEvent(EventName)
endFunction

; Voice
function SetVoice(Actor ActorRef, sslBaseVoice Voice, bool ForceSilent = false)
	ActorAlias(ActorRef).SetVoice(Voice, ForceSilent)
endFunction

sslBaseVoice function GetVoice(Actor ActorRef)
	return ActorAlias(ActorRef).GetVoice()
endFunction

; Actor Strapons
bool function IsUsingStrapon(Actor ActorRef)
	return ActorAlias(ActorRef).IsUsingStrapon()
endFunction

function EquipStrapon(Actor ActorRef)
	ActorAlias(ActorRef).EquipStrapon()
endFunction

function UnequipStrapon(Actor ActorRef)
	ActorAlias(ActorRef).UnequipStrapon()
endFunction

function SetStrapon(Actor ActorRef, Form ToStrapon)
	ActorAlias(ActorRef).SetStrapon(ToStrapon)
endfunction

Form function GetStrapon(Actor ActorRef)
	ActorAlias(ActorRef).GetStrapon()
endfunction

; Expressions
function SetExpression(Actor ActorRef, sslBaseExpression Expression)
	ActorAlias(ActorRef).SetExpression(Expression)
endFunction
sslBaseExpression function GetExpression(Actor ActorRef)
	return ActorAlias(ActorRef).GetExpression()
endFunction

; Enjoyment/Pain
int function GetEnjoyment(Actor ActorRef)
	return ActorAlias(ActorRef).GetEnjoyment()
endFunction
int function GetPain(Actor ActorRef)
	return ActorAlias(ActorRef).GetPain()
endFunction

; Actor Information
int function GetPlayerPosition()
	return Positions.Find(PlayerRef)
endFunction

int function GetPosition(Actor ActorRef)
	return Positions.Find(ActorRef)
endFunction

bool function IsPlayerActor(Actor ActorRef)
	return ActorRef == PlayerRef
endFunction

bool function IsPlayerPosition(int Position)
	return Position == Positions.Find(PlayerRef)
endFunction

bool function HasActor(Actor ActorRef)
	return ActorRef && Positions.Find(ActorRef) != -1
endFunction

bool function PregnancyRisk(Actor ActorRef, bool AllowFemaleCum = false, bool AllowCreatureCum = false)
	return ActorRef && HasActor(ActorRef) && ActorCount > 1 && ActorAlias(ActorRef).PregnancyRisk() \
		&& (Males > 0 || (AllowFemaleCum && Females > 1 && Config.AllowFFCum) || (AllowCreatureCum && MaleCreatures > 0))
endFunction

; Aggressive/Victim Setup
function SetVictim(Actor ActorRef, bool Victimize = true)
	ActorAlias(ActorRef).SetVictim(Victimize)
endFunction

bool function IsVictim(Actor ActorRef)
	return HasActor(ActorRef) && VictimRef && Victims.Find(ActorRef) != -1
endFunction

bool function IsAggressor(Actor ActorRef)
	return HasActor(ActorRef) && VictimRef && Victims.Find(ActorRef) == -1
endFunction

int function GetHighestPresentRelationshipRank(Actor ActorRef)
	if ActorCount == 1
		return SexLabUtil.IntIfElse(ActorRef == Positions[0], 0, ActorRef.GetRelationshipRank(Positions[0]))
	endIf
	int out = -4 ; lowest possible
	int i = ActorCount
	while i > 0
		i -= 1
		if Positions[i] != ActorRef && out < 4
			int rank = ActorRef.GetRelationshipRank(Positions[i])
			if rank > out
				out = rank
			endIf
		endIf
	endWhile
	return out
endFunction

int function GetLowestPresentRelationshipRank(Actor ActorRef)
	if ActorCount == 1
		return SexLabUtil.IntIfElse(ActorRef == Positions[0], 0, ActorRef.GetRelationshipRank(Positions[0]))
	endIf
	int out = 4 ; lowest possible
	int i = ActorCount
	while i > 0
		i -= 1
		if Positions[i] != ActorRef && out > -4
			int rank = ActorRef.GetRelationshipRank(Positions[i])
			if rank < out
				out = rank
			endIf
		endIf
	endWhile
	return out
endFunction

function ChangeActors(Actor[] NewPositions)
	int[] NewGenders = ActorLib.GenderCount(NewPositions)
	if HasCreature || NewGenders[2] > 0 || PapyrusUtil.AddIntValues(NewGenders) == 0
		return
	endIf
	; Enter making state for alterations
	SendThreadEvent("ActorChangeStart")
	UnregisterforUpdate()
	; Remove actors no longer present
	int i = ActorCount
	while i
		i -= 1
		if NewPositions.Find(Positions[i]) == -1
			ActorAlias(Positions[i]).ClearAlias()
		else
			ActorAlias(Positions[i]).StopAnimating(true)
		endIf
	endWhile
	; Save new positions information
	Genders    = NewGenders
	Positions  = NewPositions
	ActorCount = NewPositions.Length
	HasPlayer  = NewPositions.Find(PlayerRef) != -1
	ActorAlias[0].GetPositionInfo()
	ActorAlias[1].GetPositionInfo()
	ActorAlias[2].GetPositionInfo()
	ActorAlias[3].GetPositionInfo()
	ActorAlias[4].GetPositionInfo()
	; Select new animations for changed actor count
	if PrimaryAnimations[0].PositionCount != ActorCount
		SetAnimations(AnimSlots.GetByDefault(NewGenders[0], NewGenders[1], IsType[0], (BedRef != none), Config.RestrictAggressive))
		SetAnimation()
	endIf
	; End lead in if thread was in it and can't be now
	if LeadIn && NewPositions.Length != 2
		Stage  = 1
		LeadIn = false
		QuickEvent("Strip")
		SendThreadEvent("LeadInEnd")
	endIf
	; Prepare actors who weren't present before
	i = ActorCount
	while i
		i -= 1
		if FindSlot(Positions[i]) == -1
			; Slot into alias
			sslActorAlias Slot = PickAlias(Positions[i])
			if !Slot || !Slot.SetActor(Positions[i])
				Log("ChangeActors("+NewPositions+") -- Failed to add new actor '"+Positions[i].GetLeveledActorBase().GetName()+"' -- They were unable to fill an actor alias", "FATAL")
				return
			endIf
			Slot.DoUndress = false
			Slot.PrepareActor()
			Slot.StartAnimating()
		endIf
	endWhile
	; Reposition actors
	RealignActors()
	RegisterForSingleUpdate(0.1)
	SendThreadEvent("ActorChangeEnd")
endFunction

; ------------------------------------------------------- ;
; --- Animation Setup                                 --- ;
; ------------------------------------------------------- ;

function SetForcedAnimations(sslBaseAnimation[] AnimationList)
	CustomAnimations = AnimationList
endFunction

function SetAnimations(sslBaseAnimation[] AnimationList)
	if AnimationList.Length != 0
		PrimaryAnimations = AnimationList
	endIf
endFunction

function SetLeadAnimations(sslBaseAnimation[] AnimationList)
	if AnimationList.Length != 0
		LeadIn = true
		LeadAnimations = AnimationList
	endIf
endFunction

function AddAnimation(sslBaseAnimation AddAnimation, bool ForceTo = false)
	if AddAnimation
		sslBaseAnimation[] Adding = new sslBaseAnimation[1]
		Adding[0] = AddAnimation
		PrimaryAnimations = sslUtility.MergeAnimationLists(PrimaryAnimations, Adding)
	endIf
endFunction

; ------------------------------------------------------- ;
; --- Thread Settings                                 --- ;
; ------------------------------------------------------- ;

function DisableLeadIn(bool disabling = true)
	NoLeadIn = disabling
	if disabling
		LeadIn = false
	endIf
endFunction

function DisableBedUse(bool disabling = true)
	BedStatus[0] = 0
	if disabling
		BedStatus[0] = -1
	endIf
endFunction

function SetBedFlag(int flag = 0)
	BedStatus[0] = flag
endFunction

function SetTimers(float[] SetTimers)
	if !SetTimers || SetTimers.Length < 1
		Log("SetTimers() - Empty timers given.", "ERROR")
	else
		CustomTimers    = SetTimers
		UseCustomTimers = true
	endIf
endFunction

float function GetStageTimer(int maxstage)
	int last = ( Timers.Length - 1 )
	if stage == maxstage
		return Timers[last]
	elseif stage < last
		return Timers[(stage - 1)]
	endIf
	return Timers[(last - 1)]
endfunction

function CenterOnObject(ObjectReference CenterOn, bool resync = true)
	if CenterOn
		CenterRef = CenterOn
		CenterLocation[0] = CenterOn.GetPositionX()
		CenterLocation[1] = CenterOn.GetPositionY()
		CenterLocation[2] = CenterOn.GetPositionZ()
		CenterLocation[3] = CenterOn.GetAngleX()
		CenterLocation[4] = CenterOn.GetAngleY()
		CenterLocation[5] = CenterOn.GetAngleZ()
		; Check if it's a bed
		BedRef  = none
		BedStatus[1] = ThreadLib.GetBedType(CenterOn)
		if BedStatus[1] > 0
			BedRef = CenterOn
			float[] BedOffset = Config.BedOffset
			CenterLocation[0] = CenterLocation[0] + (BedOffset[0] * Math.sin(CenterLocation[5]))
			CenterLocation[1] = CenterLocation[1] + (BedOffset[0] * Math.cos(CenterLocation[5]))
			if BedStatus[1] > 0
				CenterLocation[2] = CenterLocation[2] + BedOffset[2]
			else
				CenterLocation[2] = CenterLocation[2] + 7.0
			endIf
		endIf
	endIf
endFunction

function CenterOnCoords(float LocX = 0.0, float LocY = 0.0, float LocZ = 0.0, float RotX = 0.0, float RotY = 0.0, float RotZ = 0.0, bool resync = true)
	CenterLocation[0] = LocX
	CenterLocation[1] = LocY
	CenterLocation[2] = LocZ
	CenterLocation[3] = RotX
	CenterLocation[4] = RotY
	CenterLocation[5] = RotZ
endFunction

 bool function CenterOnBed(bool AskPlayer = true, float Radius = 750.0)
 	ObjectReference FoundBed
	if BedStatus[0] == -1
		return false ; Beds forbidden by flag
	elseIf HasPlayer
		FoundBed = ThreadLib.FindBed(PlayerRef, Radius) ; Check within radius of player
	elseIf Config.NPCBed == 2 || (Config.NPCBed == 1 && (Utility.RandomInt(0, 1) as bool))
		FoundBed = ThreadLib.FindBed(Positions[0], Radius) ; Check within radius of first position, if NPC beds are allowed
	endIf
	; Found a bed AND EITHER forced use OR don't care about players choice OR or player approved
	if FoundBed && (BedStatus[0] == 1 || (!AskPlayer || (AskPlayer && (Config.UseBed.Show() as bool))))
		CenterOnObject(FoundBed)
		return true ; Bed found and approved for use
	endIf
	return false ; No bed found
endFunction

; ------------------------------------------------------- ;
; --- Event Hooks                                     --- ;
; ------------------------------------------------------- ;

function SetHook(string AddHooks)
	string[] Setting = PapyrusUtil.StringSplit(AddHooks)
	int i = Setting.Length
	while i
		i -= 1
		if Setting[i] != "" && Hooks.Find(Setting[i]) == -1
			AddTag(Setting[i])
			Hooks = PapyrusUtil.PushString(Hooks, Setting[i])
		endIf
	endWhile
endFunction

string function GetHook()
	return Hooks[0] ; v1.35 Legacy support, pre multiple hooks
endFunction

string[] function GetHooks()
	return Hooks
endFunction

function RemoveHook(string DelHooks)
	string[] Removing = PapyrusUtil.StringSplit(DelHooks)
	string[] NewHooks
	int i = Hooks.Length
	while i
		i -= 1
		if Removing.Find(Hooks[i]) != -1
			RemoveTag(Hooks[i])
		else
			NewHooks = PapyrusUtil.PushString(NewHooks, Hooks[i])
		endIf
	endWhile
	Hooks = NewHooks
endFunction

; ------------------------------------------------------- ;
; --- Tagging System                                  --- ;
; ------------------------------------------------------- ;

bool function HasTag(string Tag)
	return Tag != "" && Tags.Find(Tag) != -1
endFunction

bool function AddTag(string Tag)
	if Tag != "" && Tags.Find(Tag) == -1
		Tags = PapyrusUtil.PushString(Tags, Tag)
		return true
	endIf
	return false
endFunction

bool function RemoveTag(string Tag)
	if Tag != "" && Tags.Find(Tag) != -1
		Tags = PapyrusUtil.RemoveString(Tags, Tag)
		return true
	endIf
	return false
endFunction

bool function ToggleTag(string Tag)
	return (RemoveTag(Tag) || AddTag(Tag)) && HasTag(Tag)
endFunction

bool function AddTagConditional(string Tag, bool AddTag)
	if Tag != ""
		if AddTag
			AddTag(Tag)
		elseIf !AddTag
			RemoveTag(Tag)
		endIf
	endIf
	return AddTag
endFunction

bool function CheckTags(string[] CheckTags, bool RequireAll = true, bool Suppress = false)
	int i = CheckTags.Length
	while i
		i -= 1
		if CheckTags[i] != ""
			bool Check = Tags.Find(CheckTags[i]) != -1
			if (Suppress && Check) || (!Suppress && RequireAll && !Check)
				return false ; Stop if we need all and don't have it, or are supressing the found tag
			elseif !Suppress && !RequireAll && Check
				return true ; Stop if we don't need all and have one
			endIf
		endIf
	endWhile
	; If still here than we require all and had all
	return true
endFunction

string[] function GetTags()
	return Tags
endFunction

; ------------------------------------------------------- ;
; --- Actor Alias                                     --- ;
; ------------------------------------------------------- ;

int function FindSlot(Actor ActorRef)
	int i
	while i < 5
		if ActorAlias[i].ActorRef == ActorRef
			return i
		endIf
		i += 1
	endWhile
	return -1
endFunction

sslActorAlias function ActorAlias(Actor ActorRef)
	return ActorAlias[FindSlot(ActorRef)]
endFunction

sslActorAlias function PositionAlias(int Position)
	return ActorAlias[FindSlot(Positions[Position])]
endFunction

; ------------------------------------------------------- ;
; --- Thread Events - SYSTEM USE ONLY                 --- ;
; ------------------------------------------------------- ;

function Action(string FireState)
	UnregisterForUpdate()
	EndAction()
	GoToState(FireState)
	FireAction()
endfunction

function SendThreadEvent(string HookEvent)
	Log(HookEvent, "Event Hook")
	SetupThreadEvent(HookEvent)
	int i = Hooks.Length
	while i
		i -= 1
		SetupThreadEvent(HookEvent+"_"+Hooks[i])
	endWhile
	; Legacy support for < v1.50 - To be removed eventually
	if HasPlayer
		SendModEvent("Player"+HookEvent, thread_id)
	endIf
endFunction

function SetupThreadEvent(string HookEvent)
	int eid = ModEvent.Create("Hook"+HookEvent)
	if eid
		ModEvent.PushInt(eid, thread_id)
		ModEvent.PushBool(eid, HasPlayer)
		ModEvent.Send(eid)
		; Log("Thread Hook Sent: "+HookEvent)
	endIf
	SendModEvent(HookEvent, thread_id)
endFunction

; ------------------------------------------------------- ;
; --- Alias Events - SYSTEM USE ONLY                  --- ;
; ------------------------------------------------------- ;

string[] EventTypes
float[] AliasTimer
int[] AliasDone
float SyncTimer
int SyncDone

int property kPrepareActor = 0 autoreadonly hidden
int property kSyncActor    = 1 autoreadonly hidden
int property kResetActor   = 2 autoreadonly hidden
int property kRefreshActor = 3 autoreadonly hidden

string function Key(string Callback)
	return "SSL_"+thread_id+"_"+Callback
endFunction

function QuickEvent(string Callback)
	ModEvent.Send(ModEvent.Create(Key(Callback)))
endfunction

function SyncEvent(int id, float WaitTime)
	if AliasTimer[id] <= 0 || AliasTimer[id] < Utility.GetCurrentRealTime()
		AliasDone[id]  = 0
		AliasTimer[id] = Utility.GetCurrentRealTime() + WaitTime
		RegisterForSingleUpdate(WaitTime)
 		ModEvent.Send(ModEvent.Create(Key(EventTypes[id])))
	else
		Log(EventTypes[id]+" sync event attempting to start during previous wait sync")
		RegisterForSingleUpdate(WaitTime * 0.25)
	endIf
endFunction

bool SyncLock
function SyncEventDone(int id)
	while SyncLock
		Log("SyncLock("+id+")")
		Utility.WaitMenuMode(0.01)
	endwhile
	SyncLock = true
	float TimeNow = Utility.GetCurrentRealTime()
	if AliasTimer[id] != 0.0 || AliasTimer[id] < TimeNow
		AliasDone[id] = AliasDone[id] + 1
		if AliasDone[id] >= ActorCount
			UnregisterforUpdate()
			if DebugMode
				Log("Lag Timer: " + (AliasTimer[id] - TimeNow), "SyncDone("+EventTypes[id]+")")
			endIf
			AliasDone[id]  = 0
			AliasTimer[id] = 0.0
			ModEvent.Send(ModEvent.Create(Key(EventTypes[id]+"Done")))
		endIf
	else
		Log("WARNING: SyncEventDone("+id+") OUT OF TURN")
	endIf
	SyncLock = false
endFunction

function SendTrackedEvent(Actor ActorRef, string Hook = "")
	; Append hook type, global if empty
	if Hook != ""
		Hook = "_"+Hook
	endIf
	; Send generic player callback event
	if ActorRef == PlayerRef
		SetupActorEvent(PlayerRef, "PlayerTrack"+Hook)
	endIf
	; Send actor callback events
	int i = StorageUtil.StringListCount(ActorRef, "SexLabEvents")
	while i
		i -= 1
		SetupActorEvent(ActorRef, StorageUtil.StringListGet(ActorRef, "SexLabEvents", i)+Hook)
	endWhile
	; Send faction callback events
	i = StorageUtil.FormListCount(Config, "TrackedFactions")
	while i
		i -= 1
		Faction FactionRef = StorageUtil.FormListGet(Config, "TrackedFactions", i) as Faction
		if FactionRef && ActorRef.IsInFaction(FactionRef)
			int n = StorageUtil.StringListCount(FactionRef, "SexLabEvents")
			while n
				n -= 1
				SetupActorEvent(ActorRef, StorageUtil.StringListGet(FactionRef, "SexLabEvents", n)+Hook)
			endwhile
		endIf
	endWhile
endFunction

function SetupActorEvent(Actor ActorRef, string Callback)
	int eid = ModEvent.Create(Callback)
	ModEvent.PushForm(eid, ActorRef)
	ModEvent.PushInt(eid, thread_id)
	ModEvent.Send(eid)
endFunction

; ------------------------------------------------------- ;
; --- Thread Setup - SYSTEM USE ONLY                  --- ;
; ------------------------------------------------------- ;

function Log(string msg, string src = "")
	msg = "Thread["+thread_id+"] "+src+" - "+msg
	Debug.Trace("SEXLAB - " + msg)
	if DebugMode
		SexLabUtil.PrintConsole(msg)
	endIf
endFunction

function Fatal(string msg, string src = "", bool halt = true)
	msg = "FATAL - Thread["+thread_id+"] "+src+" - "+msg
	Debug.TraceStack("SEXLAB - " + msg)
	if DebugMode
		SexLabUtil.PrintConsole(msg)
	endIf
	if halt
		Initialize()
	endIf
endFunction

function UpdateAdjustKey()
	if !Config.RaceAdjustments
		AdjustKey = "Global"
	else
		int i
		string NewKey
		while i < ActorCount
			NewKey += PositionAlias(i).GetActorKey()
			i += 1
			if i < ActorCount
				NewKey += "."
			endIf
		endWhile
		AdjustKey = NewKey
	endIf
	ActorAlias[0].SetAdjustKey(AdjustKey)
	ActorAlias[1].SetAdjustKey(AdjustKey)
	ActorAlias[2].SetAdjustKey(AdjustKey)
	ActorAlias[3].SetAdjustKey(AdjustKey)
	ActorAlias[4].SetAdjustKey(AdjustKey)
endFunction

sslActorAlias function PickAlias(Actor ActorRef)
	int i
	while i < 5
		if ActorAlias[i].ForceRefIfEmpty(ActorRef)
			return ActorAlias[i]
		endIf
		i += 1
	endWhile
	return none
endFunction

function ResolveTimers()
	if !UseCustomTimers
		if LeadIn
			ConfigTimers = Config.StageTimerLeadIn
		elseIf IsType[0]
			ConfigTimers = Config.StageTimerAggr
		else
			ConfigTimers = Config.StageTimer
		endIf
	endIf
endFunction

function SetTID(int id)
	; Reset function Libraries - SexLabQuestFramework
	if !Config || !ThreadLib || !ActorLib
		Form SexLabQuestFramework = Game.GetFormFromFile(0xD62, "SexLab.esm")
		if SexLabQuestFramework
			Config    = SexLabQuestFramework as sslSystemConfig
			ThreadLib = SexLabQuestFramework as sslThreadLibrary
			ActorLib  = SexLabQuestFramework as sslActorLibrary
		endIf
	endIf
	; Reset secondary object registry - SexLabQuestRegistry
	if !CreatureSlots
		Form SexLabQuestRegistry = Game.GetFormFromFile(0x664FB, "SexLab.esm")
		if SexLabQuestRegistry
			CreatureSlots = SexLabQuestRegistry as sslCreatureAnimationSlots
		endIf
	endIf
	; Reset animation registry - SexLabQuestAnimations
	if !AnimSlots
		Form SexLabQuestAnimations = Game.GetFormFromFile(0x639DF, "SexLab.esm")
		if SexLabQuestAnimations
			AnimSlots = SexLabQuestAnimations as sslAnimationSlots
		endIf
	endIf

	thread_id = id
	PlayerRef = Game.GetPlayer()
	DebugMode = Config.DebugMode
	
	; Init thread info
	EventTypes = new string[4]
	EventTypes[0] = "Prepare"
	EventTypes[1] = "Sync"
	EventTypes[2] = "Reset"
	EventTypes[3] = "Refresh"

	ActorAlias = new sslActorAlias[5]
	ActorAlias[0] = GetNthAlias(0) as sslActorAlias
	ActorAlias[1] = GetNthAlias(1) as sslActorAlias
	ActorAlias[2] = GetNthAlias(2) as sslActorAlias
	ActorAlias[3] = GetNthAlias(3) as sslActorAlias
	ActorAlias[4] = GetNthAlias(4) as sslActorAlias

	ActorAlias[0].Setup()
	ActorAlias[1].Setup()
	ActorAlias[2].Setup()
	ActorAlias[3].Setup()
	ActorAlias[4].Setup()
	
	InitShares()
	Initialize()
	Log(self, "Setup")
endFunction

function InitShares()
	DebugMode      = Config.DebugMode
	; sAnimation     = new sslBaseAnimation[1]
	; sAnimEvents    = new string[5]
	; sStage         = new int[1]
	BedStatus      = new int[2]
	AliasDone      = new int[4]
	RealTime       = new float[1]
	AliasTimer     = new float[6]
	SkillXP        = new float[6]
	SkillBonus     = new float[6]
	CenterLocation = new float[6]
	IsType         = new bool[6]

	if EventTypes.Length != 4 || EventTypes.Find("") != -1
		EventTypes = new string[4]
		EventTypes[0] = "Prepare"
		EventTypes[1] = "Sync"
		EventTypes[2] = "Reset"
		EventTypes[3] = "Refresh"
	endIf
endFunction
function Initialize()
	UnregisterForUpdate()
	; Clear aliases
	ActorAlias[0].ClearAlias()
	ActorAlias[1].ClearAlias()
	ActorAlias[2].ClearAlias()
	ActorAlias[3].ClearAlias()
	ActorAlias[4].ClearAlias()
	; Forms
	CenterRef      = none
	SoundFX        = none
	BedRef         = none
	; Boolean
	AutoAdvance    = true
	HasPlayer      = false
	LeadIn         = false
	NoLeadIn       = false
	FastEnd        = false
	UseCustomTimers= false
	; Floats
	SyncTimer      = 0.0
	StartedAt      = 0.0
	SyncDone       = 0
	; Integers
	Stage          = 1
	ActorCount     = 0
	; Storage Data
	Animation         = none
	Genders           = new int[4]
	Positions         = PapyrusUtil.ActorArray(0)
	Victims           = PapyrusUtil.ActorArray(0)
	CustomAnimations  = sslUtility.AnimationArray(0)
	PrimaryAnimations = sslUtility.AnimationArray(0)
	LeadAnimations    = sslUtility.AnimationArray(0)
	Hooks             = Utility.CreateStringArray(0)
	Tags              = Utility.CreateStringArray(0)
	CustomTimers      = Utility.CreateFloatArray(0)
	; Enter thread selection pool
	GoToState("Unlocked")
endFunction

; ------------------------------------------------------- ;
; --- State Restricted                                --- ;
; ------------------------------------------------------- ;

state Unlocked
	sslThreadModel function Make()
		InitShares()
		Initialize()
		GoToState("Making")
		RegisterForSingleUpdate(60.0)
		return self
	endFunction
endState

; Making
sslThreadModel function Make()
	Log("Cannot enter make on a locked thread", "Make() ERROR")
	return none
endFunction
sslThreadController function StartThread()
	Log("Cannot start thread while not in a Making state", "StartThread() ERROR")
	return none
endFunction
int function AddActor(Actor ActorRef, bool IsVictim = false, sslBaseVoice Voice = none, bool ForceSilent = false)
	Log("Cannot add an actor to a locked thread", "AddActor() ERROR")
	return -1
endFunction
bool function AddActors(Actor[] ActorList, Actor VictimActor = none)
	Log("Cannot add a list of actors to a locked thread", "AddActors() ERROR")
	return false
endFunction
; State varied
function FireAction()
endFunction
function EndAction()
endFunction
function SyncDone()
endFunction
function RefreshDone()
endFunction
function PrepareDone()
endFunction
function ResetDone()
endFunction
function StripDone()
endFunction
function OrgasmDone()
endFunction
function SetAnimation(int aid = -1)
endFunction
; Animating
event OnKeyDown(int keyCode)
endEvent
function EnableHotkeys(bool forced = false)
endFunction
function RealignActors()
endFunction

; ------------------------------------------------------- ;
; --- Legacy; do not use these functions anymore!     --- ;
; ------------------------------------------------------- ;

bool function HasPlayer()
	return HasPlayer
endFunction
Actor function GetPlayer()
	return PlayerRef
endFunction
Actor function GetVictim()
	return VictimRef
endFunction
float function GetTime()
	return StartedAt
endfunction
function SetBedding(int flag = 0)
	SetBedFlag(flag)
endFunction
