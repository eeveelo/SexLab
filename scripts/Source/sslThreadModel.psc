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
string[] property AnimEvents auto hidden

sslBaseAnimation property Animation auto hidden
sslBaseAnimation property StartingAnimation auto hidden
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

bool[] property IsType auto hidden ; [0] IsAggressive, [1] IsVaginal, [2] IsAnal, [3] IsOral, [4] IsLoving, [5] IsDirty, [6] HadVaginal, [7] HadAnal, [8] HadOral
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
	;	if UseCustomTimers
	;		CustomTimers = value
	;	else
	;		ConfigTimers = value
	;	endIf
	if !value || value.Length < 1
		Log("Set() - Empty timers given for property Timers.", "ERROR")
	else
		CustomTimers    = value
		UseCustomTimers = true
	endIf
	endFunction
endProperty

; Thread info
float[] property CenterLocation auto hidden
ObjectReference property CenterRef auto hidden
ReferenceAlias property CenterAlias auto hidden

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
		if Victims
			return Victims[0]
		endIf
		return none
	endFunction
	function set(Actor ActorRef)
		if ActorRef && (!Victims || Victims.Find(ActorRef) == -1)
			Victims = PapyrusUtil.PushActor(Victims, ActorRef)
		endIf
		IsAggressive = ActorRef != none && Victims
	endFunction
endProperty

bool property DisableOrgasms auto hidden

; Beds
int[] property BedStatus auto hidden
; BedStatus[0] = -1 forbid, 0 allow, 1 force
; BedStatus[1] = 0 none, 1 bedroll, 2 single, 3 double
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
bool property UseNPCBed hidden
	bool function get()
		int NPCBed = Config.NPCBed
		return NPCBed == 2 || (NPCBed == 1 && (Utility.RandomInt(0, 1) as bool))
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
		RegisterForModEvent(Key("RealignActors"), "RealignActors") ; To be used by the ConfigMenu without the CloseConfig issue
		RegisterForModEvent(Key(EventTypes[0]+"Done"), EventTypes[0]+"Done")
		RegisterForModEvent(Key(EventTypes[1]+"Done"), EventTypes[1]+"Done")
		RegisterForModEvent(Key(EventTypes[2]+"Done"), EventTypes[2]+"Done")
		RegisterForModEvent(Key(EventTypes[3]+"Done"), EventTypes[3]+"Done")
		RegisterForModEvent(Key(EventTypes[4]+"Done"), EventTypes[4]+"Done")
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

		ThreadHooks = Config.GetThreadHooks()
		HookAnimationStarting()
		SendThreadEvent("AnimationStarting")

		; ------------------------- ;
		; --   Validate Thread   -- ;
		; ------------------------- ;

		if Positions.Find(none) != -1 || ActorCount != Positions.Length
			Positions  = PapyrusUtil.RemoveActor(Positions, none)
			ActorCount = Positions.Length
			Genders    = ActorLib.GenderCount(Positions)
			HasPlayer  = Positions.Find(PlayerRef) != -1
		endIf

		if ActorCount < 1 || Positions.Length < 1
			Fatal("No valid actors available for animation")
			return none
		endIf

		; ------------------------- ;
		; -- Validate Animations -- ;
		; ------------------------- ;

		; Define common tags
		string[] CommonTag = new String[7]
		CommonTag[0] = "Aggressive"
		CommonTag[1] = "Oral"
		CommonTag[2] = "Anal"
		CommonTag[3] = "Vaginal"
		CommonTag[4] = "Pussy"
		CommonTag[5] = "Cunnilingus"
		CommonTag[6] = "Furniture"

		; primary animations
		i = PrimaryAnimations.Length
		if i
			; Add the most commond tags to the thread to check for it on the animation list
			int tagid = 0
			while tagid < CommonTag.length
				AddTag(CommonTag[tagid])
				tagid += 1
			endWhile
			;validate animations
			bool[] Valid = Utility.CreateBoolArray(i)
			while i
				i -= 1
				Valid[i] = PrimaryAnimations[i] && PrimaryAnimations[i].PositionCount == ActorCount && (!HasCreature || (PrimaryAnimations[i].HasRace(CreatureRef) && PrimaryAnimations[i].Creatures == Creatures))
				; update the thread tags
				if Valid[i]
					tagid = 0
					while tagid < CommonTag.length
						if HasTag(CommonTag[tagid]) && !PrimaryAnimations[i].HasTag(CommonTag[tagid])
							RemoveTag(CommonTag[tagid])
						endIf
						tagid += 1
					endWhile
				endIf
			endWhile
			; Check results
			if Valid.Find(true) == -1
				Log("Invalid animation list")
				PrimaryAnimations = sslUtility.AnimationArray(0) ; No valid animations
			elseIf Valid.Find(false) >= 0
				; Filter output
				i = PrimaryAnimations.Length
				int n = PapyrusUtil.CountBool(Valid, true)
				sslBaseAnimation[] Output = sslUtility.AnimationArray(n)
				while i && n
					i -= 1
					if Valid[i]
						n -= 1
						Output[n] = PrimaryAnimations[i]
					else
						Log("Invalid animation added - "+PrimaryAnimations[i])
					endIf
				endWhile
				PrimaryAnimations = Output
			endIf
		endIf
		; custom animations
		i = CustomAnimations.Length
		if i
			; Add the most commond tags to the thread to check for it on the animation list
			int tagid = 0
			while tagid < CommonTag.length
				AddTag(CommonTag[tagid])
				tagid += 1
			endWhile
			;validate animations
			bool[] Valid = Utility.CreateBoolArray(i)
			while i
				i -= 1
				Valid[i] = CustomAnimations[i] && CustomAnimations[i].PositionCount == ActorCount && (!HasCreature || (CustomAnimations[i].HasRace(CreatureRef) && CustomAnimations[i].Creatures == Creatures))
				; update the thread tags
				if Valid[i]
					tagid = 0
					while tagid < CommonTag.length
						if HasTag(CommonTag[tagid]) && !CustomAnimations[i].HasTag(CommonTag[tagid])
							RemoveTag(CommonTag[tagid])
						endIf
						tagid += 1
					endWhile
				endIf
			endWhile
			; Check results
			if Valid.Find(true) == -1
				Log("Invalid custom animation list")
				CustomAnimations = sslUtility.AnimationArray(0) ; No valid animations
			elseIf Valid.Find(false) >= 0
				; Filter output
				i = CustomAnimations.Length
				int n = PapyrusUtil.CountBool(Valid, true)
				sslBaseAnimation[] Output = sslUtility.AnimationArray(n)
				while i && n
					i -= 1
					if Valid[i]
						n -= 1
						Output[n] = CustomAnimations[i]
					else
						Log("Invalid custom animation added - "+CustomAnimations[i])
					endIf
				endWhile
				CustomAnimations = Output
			endIf
		endIf

		; Check LeadIn CoolDown and if LeadIn is allowed to prevent compatibility issues
		float LeadInCoolDown = Math.Abs(SexLabUtil.GetCurrentGameRealTime() - StorageUtil.GetFloatValue(Config,"SexLab.LastLeadInEnd",0))
		if CustomAnimations.Length
			NoLeadIn = true
			if LeadIn
				Log("WARNING: LeadIn detected on Forced Animations. Disabling LeadIn")
				LeadIn = false
			endIf
		elseIf LeadIn
			; leadin animations
			i = LeadAnimations.Length
			if i
				bool[] Valid = Utility.CreateBoolArray(i)
				while i
					i -= 1
					Valid[i] = LeadAnimations[i] && LeadAnimations[i].PositionCount == ActorCount && (!HasCreature || (LeadAnimations[i].HasRace(CreatureRef) && LeadAnimations[i].Creatures == Creatures))
				endWhile
				; Check results
				if Valid.Find(true) == -1
					Log("Invalid lead in animation list")
					LeadAnimations = sslUtility.AnimationArray(0) ; No valid animations
					LeadIn = false
				elseIf Valid.Find(false) >= 0
					; Filter output
					i = LeadAnimations.Length
					int n = PapyrusUtil.CountBool(Valid, true)
					sslBaseAnimation[] Output = sslUtility.AnimationArray(n)
					while i && n
						i -= 1
						if Valid[i]
							n -= 1
							Output[n] = LeadAnimations[i]
						else
							Log("Invalid lead in animation added - "+LeadAnimations[i])
						endIf
					endWhile
					LeadAnimations = Output
				endIf
			endIf
		elseIf LeadInCoolDown < Config.LeadInCoolDown
			Log("LeadIn CoolDown "+LeadInCoolDown+"::"+Config.LeadInCoolDown)
			DisableLeadIn(True)
		elseIf Config.LeadInCoolDown > 0 && PrimaryAnimations && PrimaryAnimations.Length && AnimSlots.CountTag(PrimaryAnimations, "Anal,Vaginal") < 1
			Log("None of the PrimaryAnimations have 'Anal' or 'Vaginal' tags. Disabling LeadIn")
			DisableLeadIn(True)
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
		if !CenterRef && BedStatus[0] != -1 && ActorCount != Creatures && !HasTag("Furniture")
			CenterOnBed(HasPlayer, 750.0)
		endIf
		; Center on fallback choices
		if !CenterRef
			if IsAggressive && !(VictimRef.GetFurnitureReference() || VictimRef.IsSwimming() || VictimRef.IsFlying())
				CenterOnObject(VictimRef)
			elseIf HasPlayer && !(PlayerRef.GetFurnitureReference() || PlayerRef.IsSwimming() || PlayerRef.IsFlying())
				CenterOnObject(PlayerRef)
			else
				i = 0
				while i < ActorCount
					if !(Positions[i].GetFurnitureReference() || Positions[i].IsSwimming() || Positions[i].IsFlying())
						CenterOnObject(Positions[i])
						i = ActorCount
					endIf
					i += 1
				endWhile
			endIf
		endIf
		
		; Center on first actor as last choice
		if !CenterRef
			CenterOnObject(Positions[0])
		endIf
		
		if HasCreature
			Log("CreatureRef: "+CreatureRef)
			if ActorCount != Creatures
				Positions = ThreadLib.SortCreatures(Positions)
			endIf
		endIf
		
		if Config.ShowInMap && !HasPlayer && PlayerRef.GetDistance(CenterRef) > 750
			SetObjectiveDisplayed(0, True)
		endIf

		; Get default foreplay if none and enabled
		if Config.ForeplayStage && !NoLeadIn && LeadAnimations.Length == 0 && ActorCount > 1 ; && !IsAggressive 
			if !HasCreature
				SetLeadAnimations(AnimSlots.GetByType(ActorCount, Males, Females, -1, IsAggressive, False))
			else
				SetLeadAnimations(CreatureSlots.GetByCreatureActorsTags(ActorCount, Positions, SexLabUtil.StringIfElse(IsAggressive,"Aggressive,LeadIn","LeadIn")))
			endIf
		endIf
		
		; Filter animations based on user settings and scene
		if FilterAnimations() < 0
			return none
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
	bool LeadInNoBody = !(Config.StripLeadInMale[2] || Config.StripLeadInFemale[2])
	return (LeadIn && (!LeadInNoBody || AnimSlots.CountTag(Animations, "LimitedStrip") == Animations.Length)) || (Config.LimitedStrip && ((!LeadInNoBody && AnimSlots.CountTag(Animations, "Kissing,Foreplay,LeadIn,LimitedStrip") == Animations.Length) || (LeadInNoBody && AnimSlots.CountTag(Animations, "LimitedStrip") == Animations.Length)))
endFunction

; Actor Overrides
function SetStrip(Actor ActorRef, bool[] StripSlots)
	if StripSlots && StripSlots.Length == 33
		ActorAlias(ActorRef).OverrideStrip(StripSlots)
	else
		Log("Malformed StripSlots bool[] passed, must be 33 length bool array, "+StripSlots.Length+" given", "ERROR")
	endIf
endFunction

function SetNoStripping(Actor ActorRef)
	if ActorRef
		bool[] StripSlots = new bool[33]
		sslActorAlias Slot = ActorAlias(ActorRef)
		if Slot
			Slot.OverrideStrip(StripSlots)
			Slot.DoUndress = false
		endIf
	endIf
endFunction

function DisableUndressAnimation(Actor ActorRef = none, bool disabling = true)
	if ActorRef && Positions.Find(ActorRef) != -1
		ActorAlias(ActorRef).DoUndress = !disabling
	else
		ActorAlias[0].DoUndress = !disabling
		ActorAlias[1].DoUndress = !disabling
		ActorAlias[2].DoUndress = !disabling
		ActorAlias[3].DoUndress = !disabling
		ActorAlias[4].DoUndress = !disabling
	endIf
endFunction

function DisableRedress(Actor ActorRef = none, bool disabling = true)
	if ActorRef && Positions.Find(ActorRef) != -1
		ActorAlias(ActorRef).DoRedress = !disabling
	else
		ActorAlias[0].DoRedress = !disabling
		ActorAlias[1].DoRedress = !disabling
		ActorAlias[2].DoRedress = !disabling
		ActorAlias[3].DoRedress = !disabling
		ActorAlias[4].DoRedress = !disabling
	endIf
endFunction

function DisableRagdollEnd(Actor ActorRef = none, bool disabling = true)
	if ActorRef && Positions.Find(ActorRef) != -1
		ActorAlias(ActorRef).DoRagdoll = !disabling
	else
		ActorAlias[0].DoRagdoll = !disabling
		ActorAlias[1].DoRagdoll = !disabling
		ActorAlias[2].DoRagdoll = !disabling
		ActorAlias[3].DoRagdoll = !disabling
		ActorAlias[4].DoRagdoll = !disabling
	endIf
endFunction

function DisablePathToCenter(Actor ActorRef = none, bool disabling = true)
	if ActorRef && Positions.Find(ActorRef) != -1
		ActorAlias(ActorRef).DisablePathToCenter(disabling)
	else
		ActorAlias[0].DisablePathToCenter(disabling)
		ActorAlias[1].DisablePathToCenter(disabling)
		ActorAlias[2].DisablePathToCenter(disabling)
		ActorAlias[3].DisablePathToCenter(disabling)
		ActorAlias[4].DisablePathToCenter(disabling)
	endIf
endFunction

function ForcePathToCenter(Actor ActorRef = none, bool forced = true)
	if ActorRef && Positions.Find(ActorRef) != -1
		ActorAlias(ActorRef).ForcePathToCenter(forced)
	else
		ActorAlias[0].ForcePathToCenter(forced)
		ActorAlias[1].ForcePathToCenter(forced)
		ActorAlias[2].ForcePathToCenter(forced)
		ActorAlias[3].ForcePathToCenter(forced)
		ActorAlias[4].ForcePathToCenter(forced)
	endIf
endFunction

function SetStartAnimationEvent(Actor ActorRef, string EventName = "IdleForceDefaultState", float PlayTime = 0.1)
	ActorAlias(ActorRef).SetStartAnimationEvent(EventName, PlayTime)
endFunction

function SetEndAnimationEvent(Actor ActorRef, string EventName = "IdleForceDefaultState")
	ActorAlias(ActorRef).SetEndAnimationEvent(EventName)
endFunction

; Orgasms
function DisableAllOrgasms(bool OrgasmsDisabled = true)
	DisableOrgasms = OrgasmsDisabled
endFunction

function DisableOrgasm(Actor ActorRef, bool OrgasmDisabled = true)
	if ActorRef
		ActorAlias(ActorRef).DisableOrgasm(OrgasmDisabled)
	endIf
endFunction

bool function IsOrgasmAllowed(Actor ActorRef)
	return ActorAlias(ActorRef).IsOrgasmAllowed()
endFunction

bool function NeedsOrgasm(Actor ActorRef)
	return ActorAlias(ActorRef).NeedsOrgasm()
endFunction

function ForceOrgasm(Actor ActorRef)
	if ActorRef
		ActorAlias(ActorRef).DoOrgasm(true)
	endIf
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
	return ActorAlias(ActorRef).GetStrapon()
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
	return HasActor(ActorRef) && Victims && Victims.Find(ActorRef) != -1
endFunction

bool function IsAggressor(Actor ActorRef)
	return HasActor(ActorRef) && Victims && Victims.Find(ActorRef) == -1
endFunction

int function GetHighestPresentRelationshipRank(Actor ActorRef)
	if ActorCount == 1
		return SexLabUtil.IntIfElse(ActorRef == Positions[0], 0, ActorRef.GetRelationshipRank(Positions[0]))
	endIf
	int out = -4 ; lowest possible
	int i = ActorCount
	while i > 0 && out < 4
		i -= 1
		if Positions[i] != ActorRef
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
	int out = 4 ; highest possible
	int i = ActorCount
	while i > 0 && out > -4
		i -= 1
		if Positions[i] != ActorRef
			int rank = ActorRef.GetRelationshipRank(Positions[i])
			if rank < out
				out = rank
			endIf
		endIf
	endWhile
	return out
endFunction

function ChangeActors(Actor[] NewPositions)
	NewPositions = PapyrusUtil.RemoveActor(NewPositions, none)
	if NewPositions.Length < 1 || NewPositions.Length > 5 || GetState() == "Ending" || GetState() == "Frozen" ; || Positions == NewPositions
		return
	endIf
	int[] NewGenders = ActorLib.GenderCount(NewPositions)
	if PapyrusUtil.AddIntValues(NewGenders) == 0 ; || HasCreature || NewGenders[2] > 0
		return
	endIf
	int NewCreatures = NewGenders[2] + NewGenders[3]
	; Enter making state for alterations
	UnregisterforUpdate()
	GoToState("Frozen")
	SendThreadEvent("ActorChangeStart")
	
	; Remove actors no longer present
	int i = ActorCount
	while i > 0
		i -= 1
		sslActorAlias Slot = ActorAlias(Positions[i])
		if Slot
			if NewPositions.Find(Positions[i]) == -1
				if Slot.GetState() == "Prepare" || Slot.GetState() == "Animating"
					Slot.ResetActor()
				else
					Slot.ClearAlias()
				endIf
			else
				Slot.StopAnimating(true)
				Slot.UnlockActor()
			endIf
			UnregisterforUpdate()
		endIf
	endWhile
	int aid = -1
	; Select new animations for changed actor count
	if CustomAnimations && CustomAnimations.Length > 0
		if CustomAnimations[0].PositionCount != NewPositions.Length
			Log("ChangeActors("+NewPositions+") -- Failed to force valid animation for the actors and now is trying to revert the changes if possible", "ERROR")
			NewPositions = Positions
			NewGenders = ActorLib.GenderCount(NewPositions)
			NewCreatures = NewGenders[2] + NewGenders[3]
		else
			Actor[] OldPositions = Positions
			int[] OldGenders = Genders
			if Positions != NewPositions ; Temporaly changin the values to help FilterAnimations()
				Positions  = NewPositions
				ActorCount = Positions.Length
				Genders    = NewGenders
				HasPlayer  = Positions.Find(PlayerRef) != -1
			endIf
			if Positions != OldPositions ; Temporaly changin the values to help FilterAnimations()
				Positions  = OldPositions
				ActorCount = Positions.Length
				Genders    = OldGenders
				HasPlayer  = Positions.Find(PlayerRef) != -1
			endIf
			aid = Utility.RandomInt(0, (CustomAnimations.Length - 1))
			Animation = CustomAnimations[aid]
			if NewCreatures > 0
				NewPositions = ThreadLib.SortCreatures(NewPositions) ; required even if is already on the SetAnimation fuction but just the general one
		;	else ; not longer needed since is already on the SetAnimation fuction
		;		NewPositions = ThreadLib.SortActorsByAnimation(NewPositions, Animation)
			endIf
		endIf
	elseIf !PrimaryAnimations || PrimaryAnimations.Length < 1 || PrimaryAnimations[0].PositionCount != NewPositions.Length
		if PrimaryAnimations.Length > 0
			PrimaryAnimations[0].PositionCount
		endIf
		if NewCreatures > 0
			SetAnimations(CreatureSlots.GetByCreatureActors(NewPositions.Length, NewPositions))
		else
			SetAnimations(AnimSlots.GetByDefault(NewGenders[0], NewGenders[1], IsAggressive, (BedRef != none), Config.RestrictAggressive))
		endIf
		if !PrimaryAnimations || PrimaryAnimations.Length < 1
			Log("ChangeActors("+NewPositions+") -- Failed to find valid animation for the actors", "FATAL")
			Stage   = Animation.StageCount
			FastEnd = true
			if HasPlayer
				MiscUtil.SetFreeCameraState(false)
				if Game.GetCameraState() == 0
					Game.ForceThirdPerson()
				endIf
			endIf
			Utility.WaitMenuMode(0.5)
			GoToState("Ending")
			return
		elseIf PrimaryAnimations[0].PositionCount != NewPositions.Length
			Log("ChangeActors("+NewPositions+") -- Failed to find valid animation for the actors and now is trying to revert the changes if possible", "ERROR")
			NewPositions = Positions
			NewGenders = ActorLib.GenderCount(NewPositions)
			NewCreatures = NewGenders[2] + NewGenders[3]
		else
			Actor[] OldPositions = Positions
			int[] OldGenders = Genders
			if Positions != NewPositions ; Temporaly changin the values to help FilterAnimations()
				Positions  = NewPositions
				ActorCount = Positions.Length
				Genders    = NewGenders
				HasPlayer  = Positions.Find(PlayerRef) != -1
			endIf
			if FilterAnimations() < 0
				Log("ChangeActors("+NewPositions+") -- Failed to filter the animations for the actors", "ERROR")
				if Positions != OldPositions
					Positions  = OldPositions
					ActorCount = Positions.Length
					Genders    = OldGenders
					HasPlayer  = Positions.Find(PlayerRef) != -1
					if FilterAnimations() < 0
						Log("ChangeActors("+NewPositions+") -- Failed to revert the changes", "FATAL")
						Stage   = Animation.StageCount
						FastEnd = true
						if HasPlayer
							MiscUtil.SetFreeCameraState(false)
							if Game.GetCameraState() == 0
								Game.ForceThirdPerson()
							endIf
						endIf
						Utility.WaitMenuMode(0.5)
						GoToState("Ending")
						return
					else
						NewPositions  = OldPositions
						NewGenders    = OldGenders
					endIf
				endIf
			endIf
			if Positions != OldPositions ; Temporaly changin the values to help FilterAnimations()
				Positions  = OldPositions
				ActorCount = Positions.Length
				Genders    = OldGenders
				HasPlayer  = Positions.Find(PlayerRef) != -1
			endIf
			aid = Utility.RandomInt(0, (PrimaryAnimations.Length - 1))
			Animation = PrimaryAnimations[aid]
			if NewCreatures > 0
				NewPositions = ThreadLib.SortCreatures(NewPositions) ; required even if is already on the SetAnimation fuction but just the general one
		;	else ; not longer needed since is already on the SetAnimation fuction
		;		NewPositions = ThreadLib.SortActorsByAnimation(NewPositions, Animation)
			endIf
		endIf
	endIf
	; Prepare actors who weren't present before
	i = NewPositions.Length
	while i > 0
		i -= 1
		int SlotID = FindSlot(NewPositions[i])
		if SlotID == -1
			if ActorLib.ValidateActor(NewPositions[i]) < 0
				Log("ChangeActors("+NewPositions+") -- Failed to add new actor '"+NewPositions[i].GetLeveledActorBase().GetName()+"' -- The actor is not valid", "ERROR")
				NewPositions = PapyrusUtil.RemoveActor(NewPositions, NewPositions[i])
				int g      = ActorLib.GetGender(NewPositions[i])
				NewGenders[g] = NewGenders[g] - 1
			else
				; Slot into alias
				sslActorAlias Slot = PickAlias(NewPositions[i])
				if !Slot || !Slot.SetActor(NewPositions[i])
					Log("ChangeActors("+NewPositions+") -- Failed to add new actor '"+NewPositions[i].GetLeveledActorBase().GetName()+"' -- They were unable to fill an actor alias", "ERROR")
					NewPositions = PapyrusUtil.RemoveActor(NewPositions, NewPositions[i])
					int g      = Slot.GetGender()
					NewGenders[g] = NewGenders[g] - 1
				else
					; Update position info
					Positions  = PapyrusUtil.PushActor(Positions, NewPositions[i])
					ActorCount = Positions.Length
					; Update gender counts
					int g      = Slot.GetGender()
					Genders[g] = Genders[g] + 1
					; Flag as victim
					Slot.SetVictim(False)
					Slot.DoUndress = false
					Slot.PrepareActor()
					UnregisterforUpdate()
				;	Slot.StartAnimating()
				endIf
			endIf
		else
			sslActorAlias Slot = ActorAlias[SlotID]
			if Slot
				Slot.LockActor()
			endIf
		endIf
	endWhile
	; Save new positions information
	Positions  = NewPositions
	; Double Checking the Positions for actors without Slots
	i = NewPositions.Length
	while i > 0
		i -= 1
		if FindSlot(NewPositions[i]) == -1
			Positions = PapyrusUtil.RemoveActor(Positions, NewPositions[i])
			Log("ChangeActors("+NewPositions+") -- Failed to add new actor '"+NewPositions[i].GetLeveledActorBase().GetName()+"' -- They were unable to fill an actor alias", "WARNING")
		endIf
	endWhile
	
	ActorCount = Positions.Length
	Genders    = NewGenders
	HasPlayer  = Positions.Find(PlayerRef) != -1
	UpdateAdjustKey()
	Log(AdjustKey, "Adjustment Profile")
	; Reset the animation for changed actor count
	GoToState("Animating")
	if aid >= 0
		; End lead in if thread was in it and can't be now
		if LeadIn && Positions.Length != 2
			UnregisterForUpdate()
			Stage  = 1
			LeadIn = false
			QuickEvent("Strip")
			StorageUtil.SetFloatValue(Config,"SexLab.LastLeadInEnd", SexLabUtil.GetCurrentGameRealTime())
			SendThreadEvent("LeadInEnd")
			SetAnimation(aid)
		;	Action("Advancing")
		else
			Stage  = 1
			SetAnimation(aid)
		;	Action("Advancing")
		endIf
	else
		; Reposition actors
		RealignActors()
	endIf
;	RegisterForSingleUpdate(0.1)
	SendThreadEvent("ActorChangeEnd")
endFunction

; ------------------------------------------------------- ;
; --- Animation Setup                                 --- ;
; ------------------------------------------------------- ;

function SetForcedAnimations(sslBaseAnimation[] AnimationList)
	if AnimationList && AnimationList.Length > 0
		CustomAnimations = AnimationList
	endIf
endFunction

sslBaseAnimation[] function GetForcedAnimations()
	sslBaseAnimation[] Output = sslUtility.AnimationArray(CustomAnimations.Length)
	int i = CustomAnimations.Length
	while i > 0
		i -= 1
		Output[i] = CustomAnimations[i]
	endWhile
	return Output
endFunction

function ClearForcedAnimations()
	CustomAnimations = sslUtility.AnimationArray(0)
endFunction

function SetAnimations(sslBaseAnimation[] AnimationList)
	if AnimationList && AnimationList.Length > 0
		PrimaryAnimations = AnimationList
	endIf
endFunction

sslBaseAnimation[] function GetAnimations()
	sslBaseAnimation[] Output = sslUtility.AnimationArray(PrimaryAnimations.Length)
	int i = PrimaryAnimations.Length
	while i > 0
		i -= 1
		Output[i] = PrimaryAnimations[i]
	endWhile
	return Output
endFunction

function ClearAnimations()
	PrimaryAnimations = sslUtility.AnimationArray(0)
endFunction

function SetLeadAnimations(sslBaseAnimation[] AnimationList)
	if AnimationList && AnimationList.Length > 0
		LeadIn = true
		LeadAnimations = AnimationList
	endIf
endFunction

sslBaseAnimation[] function GetLeadAnimations()
	sslBaseAnimation[] Output = sslUtility.AnimationArray(LeadAnimations.Length)
	int i = LeadAnimations.Length
	while i > 0
		i -= 1
		Output[i] = LeadAnimations[i]
	endWhile
	return Output
endFunction

function ClearLeadAnimations()
	LeadAnimations = sslUtility.AnimationArray(0)
endFunction

function AddAnimation(sslBaseAnimation AddAnimation, bool ForceTo = false)
	if AddAnimation
		sslBaseAnimation[] Adding = new sslBaseAnimation[1]
		Adding[0] = AddAnimation
		PrimaryAnimations = sslUtility.MergeAnimationLists(PrimaryAnimations, Adding)
	endIf
endFunction

function SetStartingAnimation(sslBaseAnimation FirstAnimation)
	StartingAnimation = FirstAnimation
endFunction

int function FilterAnimations()
	; Filter animations based on user settings and scene
	if !CustomAnimations || CustomAnimations.Length < 1
		Log("FilterAnimations() BEGIN - LeadAnimations="+LeadAnimations.Length+", PrimaryAnimations="+PrimaryAnimations.Length)
		string[] Filters
		string[] BasicFilters
		string[] BedFilters
		sslBaseAnimation[] FilteredPrimary
		sslBaseAnimation[] FilteredLead
		int i

		; Filter tags for Male Vaginal restrictions
		if (!Config.UseCreatureGender && ActorCount == Males) || (Config.UseCreatureGender && ActorCount == (Males + MaleCreatures))
			BasicFilters = AddString(BasicFilters, "Vaginal")
		elseIf (HasTag("Vaginal") || HasTag("Pussy") || HasTag("Cunnilingus"))
			if FemaleCreatures <= 0
				Filters = AddString(Filters, "CreatureSub")
			endIf
		endIf

		if IsAggressive && Config.FixVictimPos
			if VictimRef == Positions[0] && ActorLib.GetGender(VictimRef) == 0
				BasicFilters = AddString(BasicFilters, "Vaginal")
			endIf
			if Males > 0 && ActorLib.GetGender(VictimRef) == 1
				Filters = AddString(Filters, "FemDom")
			elseIf Creatures > 0 && !ActorLib.IsCreature(VictimRef) && Males <= 0 && (!Config.UseCreatureGender || (Males + MaleCreatures) <= 0)
				Filters = AddString(Filters, "CreatureSub")
			endIf
		endIf
		
		; Filter tags for same sex restrictions
		if ActorCount == 2 && Creatures == 0 && (Males == 0 || Females == 0) && Config.RestrictSameSex
			BasicFilters = AddString(BasicFilters, SexLabUtil.StringIfElse(Females == 2, "FM", "Breast"))
		endIf
		if Config.UseStrapons && Config.RestrictStrapons && (ActorCount - Creatures) == Females && Females > 0
			Filters = AddString(Filters, "Straight")
			Filters = AddString(Filters, "Gay")
		endIf
		if BasicFilters.Find("Breast") >= 0
			Filters = AddString(Filters, "Boobjob")
		endIf

		;Remove filtered basic tags from primary
		FilteredPrimary = sslUtility.FilterTaggedAnimations(PrimaryAnimations, BasicFilters, false)
		if PrimaryAnimations.Length > FilteredPrimary.Length
			Log("Filtered out '"+(PrimaryAnimations.Length - FilteredPrimary.Length)+"' primary animations with tags: "+BasicFilters)
			PrimaryAnimations = FilteredPrimary
		endIf

		; Filter tags for non-bed friendly animations
		if BedRef
			BedFilters = AddString(BedFilters, "Furniture")
			BedFilters = AddString(BedFilters, "NoBed")
			if Config.BedRemoveStanding
				BedFilters = AddString(BedFilters, "Standing")
			endIf
			if UsingBedRoll
				BedFilters = AddString(BedFilters, "BedOnly")
			elseIf UsingSingleBed
				BedFilters = AddString(BedFilters, "DoubleBed") ; For bed animations made specific for DoubleBed or requiring too mush space to use single beds
			elseIf UsingDoubleBed
				BedFilters = AddString(BedFilters, "SingleBed") ; For bed animations made specific for SingleBed
			endIf
		else
			BedFilters = AddString(BedFilters, "BedOnly")
		endIf

		; Remove any animations with filtered tags
		Filters = PapyrusUtil.RemoveString(Filters, "")
		BasicFilters = PapyrusUtil.RemoveString(BasicFilters, "")
		BedFilters = PapyrusUtil.RemoveString(BedFilters, "")
		
		; Get default creature animations if none
		if HasCreature
			if Config.UseCreatureGender
				if ActorCount != Creatures 
					PrimaryAnimations = CreatureSlots.FilterCreatureGenders(PrimaryAnimations, Genders[2], Genders[3])
				else
					;TODO: Find bether solution instead of Exclude CC animations from filter  
				endIf
			endIf
			; Pick default creature animations if currently empty (none or failed above check)
			if PrimaryAnimations.Length == 0 ; || (BasicFilters.Length > 1 && PrimaryAnimations[0].CheckTags(BasicFilters, False))
				Log("Selecting new creature animations - "+PrimaryAnimations)
				Log("Creature Genders: "+Genders)
				SetAnimations(CreatureSlots.GetByCreatureActorsTags(ActorCount, Positions, "", PapyrusUtil.StringJoin(BasicFilters, ",")))
				if PrimaryAnimations.Length == 0
					SetAnimations(CreatureSlots.GetByCreatureActors(ActorCount, Positions))
					if PrimaryAnimations.Length == 0
						Fatal("Failed to find valid creature animations.")
						return -1
					endIf
				endIf
			endIf
			; Sort the actors to creature order
		;	Positions = ThreadLib.SortCreatures(Positions, Animations[0]) ; not longer needed since is already on the SetAnimation fuction

		; Get default primary animations if none
		elseIf PrimaryAnimations.Length == 0 ; || (BasicFilters.Length > 1 && PrimaryAnimations[0].CheckTags(BasicFilters, False))
			SetAnimations(AnimSlots.GetByDefaultTags(Males, Females, IsAggressive, (BedRef != none), Config.RestrictAggressive, "", PapyrusUtil.StringJoin(BasicFilters, ",")))
			if PrimaryAnimations.Length == 0
				SetAnimations(AnimSlots.GetByDefault(Males, Females, IsAggressive, (BedRef != none), Config.RestrictAggressive))
				if PrimaryAnimations.Length == 0
					Fatal("Unable to find valid default animations")
					return -1
				endIf
			endIf
		endIf

		; Remove any animations without filtered gender tags
		if Config.RestrictGenderTag
			string DefGenderTag = ""
			i = ActorCount
			int[] GendersAll = ActorLib.GetGendersAll(Positions)
			int[] Futas = ActorLib.TransCount(Positions)
			int[] FutasAll = ActorLib.GetTransAll(Positions)
			while i ;Make Position Gender Tag
				i -= 1
				if GendersAll[i] == 0
					DefGenderTag = "M" + DefGenderTag
				elseIf GendersAll[i] == 1
					DefGenderTag = "F" + DefGenderTag
				elseIf GendersAll[i] >= 2
					DefGenderTag = "C" + DefGenderTag
				endIf
			endWhile
			if DefGenderTag != ""
				string[] GenderTag = Utility.CreateStringArray(1, DefGenderTag)
				;Filtering Futa animations
				if (Futas[0] + Futas[1]) < 1
					BasicFilters = AddString(BasicFilters, "Futa")
				elseIf (Futas[0] + Futas[1]) != (Genders[0] + Genders[1])
					Filters = AddString(Filters, "AllFuta")
				endIf
				;Make Extra Position Gender Tag if actor is Futanari or female use strapon
				i = ActorCount
				while i
					i -= 1
					if (Config.UseStrapons && GendersAll[i] == 1) || (FutasAll[i] == 1)
						if StringUtil.GetNthChar(DefGenderTag, ActorCount - i) == "F"
							GenderTag = AddString(GenderTag, StringUtil.Substring(DefGenderTag, 0, ActorCount - i) + "M" + StringUtil.Substring(DefGenderTag, (ActorCount - i) + 1))
						endIf
					elseIf (FutasAll[i] == 0)
						if StringUtil.GetNthChar(DefGenderTag, ActorCount - i) == "M"
							GenderTag = AddString(GenderTag, StringUtil.Substring(DefGenderTag, 0, ActorCount - i) + "F" + StringUtil.Substring(DefGenderTag, (ActorCount - i) + 1))
						endIf
					endIf
				endWhile
				if Config.UseStrapons
					DefGenderTag = ActorLib.GetGenderTag(0, Males + Females, Creatures)
					GenderTag = AddString(GenderTag, DefGenderTag)
				endIf
				DefGenderTag = ActorLib.GetGenderTag(Females, Males, Creatures)
				GenderTag = AddString(GenderTag, DefGenderTag)
				
				DefGenderTag = ActorLib.GetGenderTag(Females + Futas[0] - Futas[1], Males - Futas[0] + Futas[1], Creatures)
				GenderTag = AddString(GenderTag, DefGenderTag)
				; Remove filtered gender tags from primary
				FilteredPrimary = sslUtility.FilterTaggedAnimations(PrimaryAnimations, GenderTag, true)
				if FilteredPrimary.Length > 0 && PrimaryAnimations.Length > FilteredPrimary.Length
					Log("Filtered out '"+(PrimaryAnimations.Length - FilteredPrimary.Length)+"' primary animations without tags: "+GenderTag)
					PrimaryAnimations = FilteredPrimary
				endIf
				; Remove filtered gender tags from lead in
				if LeadAnimations && LeadAnimations.Length > 0
					FilteredLead = sslUtility.FilterTaggedAnimations(LeadAnimations, GenderTag, true)
					if LeadAnimations.Length > FilteredLead.Length
						Log("Filtered out '"+(LeadAnimations.Length - FilteredLead.Length)+"' lead in animations without tags: "+GenderTag)
						LeadAnimations = FilteredLead
					endIf
				endIf
			endIf
		endIf
		
		; Remove filtered tags from primary step by step
		FilteredPrimary = sslUtility.FilterTaggedAnimations(PrimaryAnimations, BedFilters, false)
		if FilteredPrimary.Length > 0 && PrimaryAnimations.Length > FilteredPrimary.Length
			Log("Filtered out '"+(PrimaryAnimations.Length - FilteredPrimary.Length)+"' primary animations with tags: "+BedFilters)
			PrimaryAnimations = FilteredPrimary
		endIf
		FilteredPrimary = sslUtility.FilterTaggedAnimations(PrimaryAnimations, BasicFilters, false)
		if FilteredPrimary.Length > 0 && PrimaryAnimations.Length > FilteredPrimary.Length
			Log("Filtered out '"+(PrimaryAnimations.Length - FilteredPrimary.Length)+"' primary animations with tags: "+BasicFilters)
			PrimaryAnimations = FilteredPrimary
		endIf
		FilteredPrimary = sslUtility.FilterTaggedAnimations(PrimaryAnimations, Filters, false)
		if FilteredPrimary.Length > 0 && PrimaryAnimations.Length > FilteredPrimary.Length
			Log("Filtered out '"+(PrimaryAnimations.Length - FilteredPrimary.Length)+"' primary animations with tags: "+Filters)
			PrimaryAnimations = FilteredPrimary
		endIf
		; Remove filtered tags from lead in
		if LeadAnimations && LeadAnimations.Length > 0
			Filters = PapyrusUtil.MergeStringArray(Filters, BasicFilters, true)
			Filters = PapyrusUtil.MergeStringArray(Filters, BedFilters, true)
			FilteredLead = sslUtility.FilterTaggedAnimations(LeadAnimations, Filters, false)
			if LeadAnimations.Length > FilteredLead.Length
				Log("Filtered out '"+(LeadAnimations.Length - FilteredLead.Length)+"' lead in animations with tags: "+Filters)
				LeadAnimations = FilteredLead
			endIf
		endIf
		; Remove Dupes
		if LeadAnimations && PrimaryAnimations && PrimaryAnimations.Length > LeadAnimations.Length
			PrimaryAnimations = sslUtility.RemoveDupesFromList(PrimaryAnimations, LeadAnimations)
		endIf
		; Make sure we are still good to start after all the filters
		if !LeadAnimations || LeadAnimations.Length < 1
			LeadIn = false
		endIf
		if !PrimaryAnimations || PrimaryAnimations.Length < 1
			Fatal("Empty primary animations after filters")
			return -1
		endIf
		Log("FilterAnimations() END - LeadAnimations="+LeadAnimations.Length+", PrimaryAnimations="+PrimaryAnimations.Length)
		return 1
	endIf
	return 0
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

function SetFurnitureIgnored(bool disabling = true)
	if !CenterRef || CenterRef == none
		return
	endIf
	CenterRef.SetDestroyed(disabling)
;	CenterRef.ClearDestruction()
	CenterRef.BlockActivation(disabling)
	CenterRef.SetNoFavorAllowed(disabling)
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
	elseIf stage < last
		return Timers[(stage - 1)]
	endIf
	return Timers[(last - 1)]
endfunction

int function AreUsingFurniture(Actor[] ActorList)
	if !ActorList || ActorList.Length < 1
		return -1
	endIf
	
	int i = ActorList.Length
	ObjectReference TempFurnitureRef
	while i > 0
		i -= 1
		TempFurnitureRef = ActorList[i].GetFurnitureReference()
		if TempFurnitureRef && TempFurnitureRef != none
			int FurnitureType = ThreadLib.GetBedType(TempFurnitureRef)
			if FurnitureType > 0
				return FurnitureType
			endIf
		endIf
	endWhile
	return -1
endFunction

function CenterOnObject(ObjectReference CenterOn, bool resync = true)
	if CenterOn
		CenterRef = CenterOn
		; Check if it's a bed
		BedRef  = none
		BedStatus[1] = 0
		int Pos = Positions.Find(CenterOn as Actor)
		if Pos >= 0
			int SlotID = FindSlot(Positions[Pos])
			if SlotID != -1
				ActorAlias[SlotID].LockActor()
			endIf
			if CenterOn == VictimRef as ObjectReference
				Log("CenterRef == VictimRef: "+VictimRef)
			elseIf CenterOn == PlayerRef as ObjectReference
				Log("CenterRef == PlayerRef: "+PlayerRef)
			else
				Log("CenterRef == Positions["+Pos+"]: "+CenterRef)
			endIf
		elseIf CenterOn.GetBaseObject() != Config.LocationMarker
			BedStatus[1] = ThreadLib.GetBedType(CenterOn)
		endIf
		; Get Position after Lock the Actor to aviod unwanted teleport.
		CenterLocation[0] = CenterOn.GetPositionX()
		CenterLocation[1] = CenterOn.GetPositionY()
		CenterLocation[2] = CenterOn.GetPositionZ()
		CenterLocation[3] = CenterOn.GetAngleX()
		CenterLocation[4] = CenterOn.GetAngleY()
		CenterLocation[5] = CenterOn.GetAngleZ()
		if BedStatus[1] > 0
			BedRef = CenterOn
			Log("CenterRef == BedRef: "+BedRef)
			float[] BedOffsets = Config.GetBedOffsets(BedRef.GetBaseObject())
			if BedStatus[1] == 1 && BedOffsets == Config.BedOffset
				BedOffsets[2] = 7.5 ; Most common BedRolls Up offset
				BedOffsets[3] = 180 ; Most BedRolls meshes are rotated
			endIf
			Log("Using Bed Type: "+BedStatus[1])
			Log("Bed Location[PosX:"+CenterLocation[0]+",PosY:"+CenterLocation[1]+",PosZ:"+CenterLocation[2]+",AngX:"+CenterLocation[3]+",AngY:"+CenterLocation[4]+",AngZ:"+CenterLocation[5]+"]")
			Log("Bed Offset[Forward:"+BedOffsets[0]+",Sideward:"+BedOffsets[1]+",Upward:"+BedOffsets[2]+",Rotation:"+BedOffsets[3]+"]")
			float Scale = CenterOn.GetScale()
			if Scale != 1.0
				BedOffsets[0] = BedOffsets[0] * Scale ; (((2-Scale)*((Math.ABS(BedOffsets[0])-BedOffsets[0])/(2*Math.ABS(BedOffsets[0]))))+(Scale*((BedOffsets[0]+Math.ABS(BedOffsets[0]))/(2*BedOffsets[0]))))
				BedOffsets[1] = BedOffsets[1] * Scale ; (((2-Scale)*((Math.ABS(BedOffsets[1])-BedOffsets[1])/(2*Math.ABS(BedOffsets[1]))))+(Scale*((BedOffsets[1]+Math.ABS(BedOffsets[1]))/(2*BedOffsets[1]))))
				BedOffsets[2] = BedOffsets[2] * (((2-Scale)*((Math.ABS(BedOffsets[2])-BedOffsets[2])/(2*Math.ABS(BedOffsets[2]))))+(Scale*((BedOffsets[2]+Math.ABS(BedOffsets[2]))/(2*BedOffsets[2]))))
				BedOffsets[3] = BedOffsets[3]
				Log("Scaled Bed Offset[Forward:"+BedOffsets[0]+",Sideward:"+BedOffsets[1]+",Upward:"+BedOffsets[2]+",Rotation:"+BedOffsets[3]+"]")
			endIf
			CenterLocation[0] = CenterLocation[0] + ((BedOffsets[0] * Math.sin(CenterLocation[5])) + (BedOffsets[1] * Math.cos(CenterLocation[5])))
			CenterLocation[1] = CenterLocation[1] + ((BedOffsets[0] * Math.cos(CenterLocation[5])) - (BedOffsets[1] * Math.sin(CenterLocation[5])))
			CenterLocation[2] = CenterLocation[2] + BedOffsets[2]
			CenterLocation[5] = CenterLocation[5] + BedOffsets[3]
			SetFurnitureIgnored(true)
		endIf
		if CenterAlias.GetReference() != CenterRef
			CenterAlias.TryToClear()
			CenterAlias.ForceRefTo(CenterRef)
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
	bool InStart = GetState() == "Starting" || GetState() == "Making"
	int AskBed = Config.AskBed
	if BedStatus[0] == -1 || (InStart && (!HasPlayer && Config.NPCBed == 0) || (HasPlayer && AskBed == 0))
		return false ; Beds forbidden by flag or starting bed check/prompt disabled
	endIf
	bool BedScene = BedStatus[0] == 1
 	ObjectReference FoundBed
	int i = ActorCount
	while i > 0
		i -= 1
		FoundBed = Positions[i].GetFurnitureReference()
		if FoundBed
			int BedType = ThreadLib.GetBedType(FoundBed)
			if BedType > 0 && (ActorCount < 4 || BedType != 2)
				CenterOnObject(FoundBed)
				return true ; Bed found and approved for use
			endIf
		endIf
	endWhile
	if HasPlayer && (!InStart || AskBed == 1 || (AskBed == 2 && (!IsVictim(PlayerRef) || UseNPCBed)))
		if BedScene
			FoundBed  = ThreadLib.FindBed(PlayerRef, Radius * 2) ; Check within radius of player
		else
			FoundBed  = ThreadLib.FindBed(PlayerRef, Radius) ; Check within radius of player
			; Same Floor only
		;	if FoundBed && !ThreadLib.SameFloor(FoundBed, PlayerRef.GetPositionZ(), 200)
		;		Log("FoundBed: "+FoundBed+" is not in the same floor")
		;		FoundBed = none
		;	endIf
		endIf
		AskPlayer = AskPlayer && (!InStart || !(AskBed == 2 && IsVictim(PlayerRef))) ; Disable prompt if bed found but shouldn't ask
	elseIf !HasPlayer && UseNPCBed
		if BedScene
			FoundBed = ThreadLib.FindBed(Positions[0], Radius * 2) ; Check within radius of first position, if NPC beds are allowed
		else
			FoundBed = ThreadLib.FindBed(Positions[0], Radius) ; Check within radius of first position, if NPC beds are allowed
			; Same Floor only
		;	if FoundBed && !ThreadLib.SameFloor(FoundBed, PlayerRef.GetPositionZ(), 200)
		;		Log("FoundBed: "+FoundBed+" is not in the same floor")
		;		FoundBed = none
		;	endIf
		endIf
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

; Because PapyrusUtil don't Remove Dupes from the Array
string[] function AddString(string[] ArrayValues, string ToAdd, bool RemoveDupes = true)
	if ToAdd != ""
		string[] Output = ArrayValues
		if !RemoveDupes || Output.length < 1
			return PapyrusUtil.PushString(Output, ToAdd)
		elseIf Output.Find(ToAdd) == -1
			int i = Output.Find("")
			if i != -1
				Output[i] = ToAdd
			else
				Output = PapyrusUtil.PushString(Output, ToAdd)
			endIf
		endIf
		return Output
	endIf
	return ArrayValues
endFunction

bool function CheckTags(string[] CheckTags, bool RequireAll = true, bool Suppress = false)
	int i = CheckTags.Length
	while i
		i -= 1
		if CheckTags[i] != ""
			bool Check = Tags.Find(CheckTags[i]) != -1
			if (Suppress && Check) || (!Suppress && RequireAll && !Check)
				return false ; Stop if we need all and don't have it, or are supressing the found tag
			elseIf !Suppress && !RequireAll && Check
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
	if !ActorRef
		return -1
	endIf
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
	int SlotID = FindSlot(ActorRef)
	if SlotID != -1
		return ActorAlias[SlotID]
	endIf
	return none
endFunction

sslActorAlias function PositionAlias(int Position)
	if Position < 0 || !(Position < Positions.Length)
		return none
	endIf
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

sslThreadHook[] ThreadHooks
function HookAnimationStarting()
	; Log("HookAnimationStarting() - "+ThreadHooks)
	int i = Config.GetThreadHookCount()
	while i > 0
		i -= 1
		if ThreadHooks[i] && ThreadHooks[i].CanRunHook(Positions, Tags) && ThreadHooks[i].AnimationStarting(self)
			Log("Global Hook AnimationStarting("+self+") - "+ThreadHooks[i])
		; else
		; 	Log("HookAnimationStarting() - Skipping["+i+"]: "+ThreadHooks[i])
		endIf
	endWhile
endFunction

function HookAnimationPrepare()
	; Log("HookAnimationPrepare() - "+ThreadHooks)
	int i = Config.GetThreadHookCount()
	while i > 0
		i -= 1
		if ThreadHooks[i] && ThreadHooks[i].CanRunHook(Positions, Tags) && ThreadHooks[i].AnimationPrepare(self as sslThreadController)
			Log("Global Hook AnimationPrepare("+self+") - "+ThreadHooks[i])
		; else
		; 	Log("HookAnimationPrepare() - Skipping["+i+"]: "+ThreadHooks[i])
		endIf
	endWhile
endFunction

function HookStageStart()
	int i = Config.GetThreadHookCount()
	while i > 0
		i -= 1
		if ThreadHooks[i] && ThreadHooks[i].CanRunHook(Positions, Tags) && ThreadHooks[i].StageStart(self as sslThreadController)
			Log("Global Hook StageStart("+self+") - "+ThreadHooks[i])
		; else
		; 	Log("HookStageStart() - Skipping["+i+"]: "+ThreadHooks[i])
		endIf
	endWhile
endFunction

function HookStageEnd()
	int i = Config.GetThreadHookCount()
	while i > 0
		i -= 1
		if ThreadHooks[i] && ThreadHooks[i].CanRunHook(Positions, Tags) && ThreadHooks[i].StageEnd(self as sslThreadController)
			Log("Global Hook StageEnd("+self+") - "+ThreadHooks[i])
		; else
		; 	Log("HookStageEnd() - Skipping["+i+"]: "+ThreadHooks[i])
		endIf
	endWhile
endFunction

function HookAnimationEnding()
	int i = Config.GetThreadHookCount()
	while i > 0
		i -= 1
		if ThreadHooks[i] && ThreadHooks[i].CanRunHook(Positions, Tags) && ThreadHooks[i].AnimationEnding(self as sslThreadController)
			Log("Global Hook AnimationEnding("+self+") - "+ThreadHooks[i])
		; else
		; 	Log("HookAnimationEnding() - Skipping["+i+"]: "+ThreadHooks[i])
		endIf
	endWhile
endFunction

function HookAnimationEnd()
	int i = Config.GetThreadHookCount()
	while i > 0
		i -= 1
		if ThreadHooks[i] && ThreadHooks[i].CanRunHook(Positions, Tags) && ThreadHooks[i].AnimationEnd(self as sslThreadController)
			Log("Global Hook AnimationEnd("+self+") - "+ThreadHooks[i])
		; else
		; 	Log("HookAnimationEnd() - Skipping["+i+"]: "+ThreadHooks[i])
		endIf
	endWhile
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
int property kStartup      = 4 autoreadonly hidden

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
	endWhile
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
			if id >= kSyncActor && id <= kRefreshActor
				RemoveFade()
			endIf
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
		Debug.TraceUser("SexLabDebug", msg)
	endIf
endFunction

function Fatal(string msg, string src = "", bool halt = true)
	msg = "FATAL - Thread["+thread_id+"] "+src+" - "+msg
	Debug.TraceStack("SEXLAB - " + msg)
	if DebugMode
		SexLabUtil.PrintConsole(msg)
		Debug.TraceUser("SexLabDebug", msg)
	endIf
	if halt
		Initialize()
	endIf
endFunction

function UpdateAdjustKey()
	if !Config.RaceAdjustments && Config.ScaleActors
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

function RemoveFade()
	if HasPlayer
		Config.RemoveFade()
	endIf
endFunction

function ApplyFade()
	if HasPlayer
		Config.ApplyFade()
	endIf
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
		elseIf IsAggressive
			ConfigTimers = Config.StageTimerAggr
		else
			ConfigTimers = Config.StageTimer
		endIf
	endIf
endFunction

function SetTID(int id)
	thread_id = id
	PlayerRef = Game.GetPlayer()
	DebugMode = Config.DebugMode

	Log(self, "Setup")
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

	
	; Init thread info
	EventTypes = new string[5]
	EventTypes[0] = "Prepare"
	EventTypes[1] = "Sync"
	EventTypes[2] = "Reset"
	EventTypes[3] = "Refresh"
	EventTypes[4] = "Startup"

	CenterAlias = GetNthAlias(5) as ReferenceAlias

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
endFunction

function InitShares()
	DebugMode      = Config.DebugMode
	AnimEvents     = new string[5]
	IsType         = new bool[9]
	BedStatus      = new int[2]
	AliasDone      = new int[6]
	RealTime       = new float[1]
	AliasTimer     = new float[6]
	SkillXP        = new float[6]
	SkillBonus     = new float[6]
	CenterLocation = new float[6]
	if EventTypes.Length != 5 || EventTypes.Find("") != -1
		EventTypes = new string[5]
		EventTypes[0] = "Prepare"
		EventTypes[1] = "Sync"
		EventTypes[2] = "Reset"
		EventTypes[3] = "Refresh"
		EventTypes[4] = "Startup"
	endIf
	if !CenterAlias
		CenterAlias = GetAliasByName("CenterAlias") as ReferenceAlias
	endIf
endFunction

bool Initialized
function Initialize()
	UnregisterForUpdate()
	; Clear aliases
	ActorAlias[0].ClearAlias()
	ActorAlias[1].ClearAlias()
	ActorAlias[2].ClearAlias()
	ActorAlias[3].ClearAlias()
	ActorAlias[4].ClearAlias()
	if CenterAlias
	;	SetObjectiveDisplayed(0, False)
		CenterAlias.Clear()
	endIf
	; Forms
	Animation      = none
	CenterRef      = none
	SoundFX        = none
	BedRef         = none
	StartingAnimation = none
	; Boolean
	AutoAdvance    = true
	HasPlayer      = false
	LeadIn         = false
	NoLeadIn       = false
	FastEnd        = false
	UseCustomTimers= false
	DisableOrgasms = false
	; Floats
	SyncTimer      = 0.0
	StartedAt      = 0.0
	; Integers
	SyncDone       = 0
	Stage          = 1
	ActorCount     = 0
	; StartAID       = -1
	; Storage Data
	Genders           = new int[4]
	Victims           = PapyrusUtil.ActorArray(0)
	Positions         = PapyrusUtil.ActorArray(0)
	CustomAnimations  = sslUtility.AnimationArray(0)
	PrimaryAnimations = sslUtility.AnimationArray(0)
	LeadAnimations    = sslUtility.AnimationArray(0)
	Hooks             = Utility.CreateStringArray(0)
	Tags              = Utility.CreateStringArray(0)
	CustomTimers      = Utility.CreateFloatArray(0)
	; Enter thread selection pool
	GoToState("Unlocked")
	Initialized = true
endFunction

; ------------------------------------------------------- ;
; --- State Restricted                                --- ;
; ------------------------------------------------------- ;

state Unlocked
	sslThreadModel function Make()
		InitShares()
		if !Initialized
			Initialize()
		endIf
		Initialized = false
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
function StartupDone()
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
