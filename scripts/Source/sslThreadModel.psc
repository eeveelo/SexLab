scriptname sslThreadModel extends sslThreadLibrary hidden
{ Animation Thread Model: Runs storage and information about a thread. Access only through functions; NEVER create a property directly to this. }

import sslUtility
import StorageUtil

bool property IsLocked hidden
	bool function get()
		return GetState() != "Unlocked"
	endFunction
endProperty

; Actor Storage
Actor[] property Positions auto hidden
Actor property VictimRef auto hidden
int property ActorCount auto hidden
string property AdjustKey auto hidden
sslActorAlias[] property ActorAlias auto hidden

; Thread status
bool property HasPlayer auto hidden
bool property AutoAdvance auto hidden
bool property LeadIn auto hidden
bool property FastEnd auto hidden
bool property IsAggressive auto hidden

; Creature animation
Race property CreatureRef auto hidden

; Animation Info
int property Stage auto hidden
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
float[] property SkillXP auto hidden ; [0] Foreplay, [1] Vaginal, [2] Anal, [3] Oral, [4] Pure, [5] Lewd
bool property IsVaginal auto hidden
bool property IsAnal auto hidden
bool property IsOral auto hidden
bool property IsDirty auto hidden
bool property IsLoving auto hidden

; Timer Info
float[] CustomTimers
float[] property Timers hidden
	float[] function get()
		if CustomTimers.Length != 0
			return CustomTimers
		elseif LeadIn
			return Config.fStageTimerLeadIn
		elseif IsAggressive
			return Config.fStageTimerAggr
		else
			return Config.fStageTimer
		endIf
	endFunction
endProperty

; Thread info
float[] property CenterLocation auto hidden
ObjectReference property CenterRef auto hidden
ObjectReference property BedRef auto hidden

float property StartedAt auto hidden
float property TotalTime hidden
	float function get()
		return Utility.GetCurrentRealTime() - StartedAt
	endFunction
endProperty

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
int property Creatures hidden
	int function get()
		return Genders[2]
	endFunction
endProperty
bool property HasCreature hidden
	bool function get()
		return Creatures > 0
	endFunction
endProperty

; Local readonly
int BedFlag ; 0 = allow, 1 = force, -1 = forbid
bool NoLeadIn
string[] Hooks
string[] Tags

; Debug testing
float property t auto hidden

; ------------------------------------------------------- ;
; --- Thread Making API                               --- ;
; ------------------------------------------------------- ;

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

state Making
	int function AddActor(Actor ActorRef, bool IsVictim = false, sslBaseVoice Voice = none, bool ForceSilent = false)
		; Ensure we have room for actor
		if ActorRef == none
			Log("AddActor() - Failed to add actor -- Actor is a figment of your imagination", "FATAL")
			return -1
		elseIf ActorCount >= 5
			Log("AddActor() - Failed to add actor '"+ActorRef.GetLeveledActorBase().GetName()+"' -- Thread has reached actor limit", "FATAL")
			return -1
		elseIf Positions.Find(ActorRef) != -1
			Log("AddActor() - Failed to add actor '"+ActorRef.GetLeveledActorBase().GetName()+"' -- They have been already added to this thread", "FATAL")
			return -1
		elseIf !ActorLib.ValidateActor(ActorRef)
			Log("AddActor() - Failed to add actor '"+ActorRef.GetLeveledActorBase().GetName()+"' -- They are not a valid target for animation", "FATAL")
			return -1
		; elseIf ActorRef == PlayerRef && !CheckFNIS()
		; 	Log("AddActor() - Failed to start animation -- Game was unable to verify that you have a properly installed and up to date version of FNIS", "FATAL")
		; 	return -1
		endIf
		sslActorAlias Slot = PickAlias(ActorRef)
		if Slot == none || !Slot.SetupAlias(ActorRef, IsVictim, Voice, ForceSilent)
			Log("AddActor() - Failed to add actor '"+ActorRef.GetLeveledActorBase().GetName()+"' -- They were unable to fill an actor alias", "FATAL")
			return -1
		endIf
		; Update thread info
		Positions  = PushActor(ActorRef, Positions)
		ActorCount = Positions.Length
		HasPlayer  = Positions.Find(PlayerRef) != -1
		; Update gender count
		int g = Slot.Gender
		Genders[g] = Genders[g] + 1
		if g == 2
			CreatureRef = ActorRef.GetLeveledActorBase().GetRace()
		endIf
		; Flag as victim
		if IsVictim
			VictimRef = ActorRef
			IsAggressive = true
		endIf
		; Return position
		return Positions.Find(ActorRef)
	endFunction

	bool function AddActors(Actor[] ActorList, Actor VictimActor = none)
		int Count = ActorList.Length
		if Count < 1 || ((Positions.Length + Count) > 5) || ActorList.Find(none) != -1
			Log("AddActors() - Failed to add actor list as it either contains to many actors placing the thread over it's limit, none at all, or an invalid 'None' entry -- "+ActorList, "FATAL")
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

		; ------------------------- ;
		; --   Validate Thread   -- ;
		; ------------------------- ;

		if ActorCount < 1 || Positions.Length == 0
			Log("StartThread() - No valid actors available for animation", "FATAL")
			return none
		endIf

		; ------------------------- ;
		; --    Locate Center    -- ;
		; ------------------------- ;

		; Search location marker near player or first position
		if CenterRef == none
			if HasPlayer
				CenterOnObject(Game.FindClosestReferenceOfTypeFromRef(LocationMarker, PlayerRef, 750.0))
			else
				CenterOnObject(Game.FindClosestReferenceOfTypeFromRef(LocationMarker, Positions[0], 750.0))
			endIf
		endIf
		; Search for nearby bed
		if CenterRef == none && BedFlag != -1
			CenterOnBed(HasPlayer, 750.0)
		endIf
		; Center on fallback choices
		if CenterRef == none
			if IsAggressive
				CenterOnObject(VictimRef)
			elseIf HasPlayer
				CenterOnObject(PlayerRef)
			else
				CenterOnObject(Positions[0])
			endIf
		endIf

		; ------------------------- ;
		; -- Validate Animations -- ;
		; ------------------------- ;

		; Get creature animations
		if HasCreature
			LeadIn = false
			PrimaryAnimations = CreatureSlots.GetByRace(ActorCount, CreatureRef)
			if PrimaryAnimations.Length == 0
				Log("StartThread() - Failed to find valid creature animations.", "FATAL")
				return none
			endIf
			Positions = SortCreatures(Positions, PrimaryAnimations[0])
		; Get default primary animations if none
		elseIf PrimaryAnimations.Length == 0
			SetAnimations(AnimSlots.GetByDefault(Males, Females, IsAggressive, (BedRef != none), Config.bRestrictAggressive))
			if PrimaryAnimations.Length == 0
				Log("StartThread() - Unable to find valid default animations", "FATAL")
				return none
			endIf
		endIf
		; Get default foreplay if none and enabled
		if !HasCreature && !IsAggressive && ActorCount == 2 && !NoLeadIn && LeadAnimations.Length == 0 && Config.bForeplayStage
			if BedRef != none
				SetLeadAnimations(AnimSlots.GetByTags(2, "LeadIn", "Standing"))
			else
				SetLeadAnimations(AnimSlots.GetByTags(2, "LeadIn"))
			endIf
		endIf

		; ------------------------- ;
		; --  Prepare Events     -- ;
		; ------------------------- ;

		RegisterForModEvent(Key(EventTypes[0]+"Done"), EventTypes[0]+"Done")
		RegisterForModEvent(Key(EventTypes[1]+"Done"), EventTypes[1]+"Done")
		RegisterForModEvent(Key(EventTypes[2]+"Done"), EventTypes[2]+"Done")
		RegisterForModEvent(Key(EventTypes[3]+"Done"), EventTypes[3]+"Done")
		RegisterForModEvent(Key(EventTypes[4]+"Done"), EventTypes[4]+"Done")

		; ------------------------- ;
		; --  Start Controller   -- ;
		; ------------------------- ;

		Action("Prepare")
		return self as sslThreadController
	endFunction

	event OnUpdate()
		Log("Thread has timed out of the making process; resetting model for selection pool", "FATAL")
		Initialize()
	endEvent
	event OnBeginState()
		t = Utility.GetCurrentRealTime()
		Log("Entering Making State", "Thread["+thread_id+"]")
	endEvent
endState

; ------------------------------------------------------- ;
; --- Actor Setup                                     --- ;
; ------------------------------------------------------- ;

; Actor Overrides
function SetStrip(Actor ActorRef, bool[] StripSlots)
	ActorAlias(ActorRef).OverrideStrip(StripSlots)
	if StripSlots.Length == 33
		ActorAlias(ActorRef).OverrideStrip(StripSlots)
	else
		Log("Malformed StripSlots bool[] passed, must be 33 length bool array, "+StripSlots.Length+" given", "ERROR")
	endIf
endFunction

function DisableUndressAnimation(Actor ActorRef, bool disabling = true)
	ActorAlias(ActorRef).DoUndress = !disabling
endFunction

function DisableRagdollEnd(Actor ActorRef, bool disabling = true)
	ActorAlias(ActorRef).DoRagdoll = !disabling
endFunction

; Voice
function SetVoice(Actor ActorRef, sslBaseVoice Voice, bool ForceSilent = false)
	ActorAlias(ActorRef).SetVoice(Voice, ForceSilent)
endFunction

sslBaseVoice function GetVoice(Actor ActorRef)
	return ActorAlias(ActorRef).GetVoice()
endFunction

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
	return Positions.Find(ActorRef) != -1
endFunction

bool function IsVictim(Actor ActorRef)
	return VictimRef == ActorRef
endFunction

bool function IsAggressor(Actor ActorRef)
	return VictimRef != none && VictimRef != ActorRef
endFunction

int function GetHighestPresentRelationshipRank(Actor ActorRef)
	if ActorCount == 1
		return 0 ; No special relationship with yourself...
	elseIf ActorCount == 2
		return ActorRef.GetRelationshipRank(Positions[IndexTravel(Positions.Find(ActorRef), ActorCount)]) ; Get opposing actors relationship rank
	endIf
	; int Highest
	; int i = ActorCount
	; while i
	; 	i -= 1
	; 	if Positions[i] != ActorRef && ActorRef.GetRelationshipRank(Positions[i]) > Highest
	; 		Highest = ActorRef.GetRelationshipRank(Positions[i])
	; 	endIf
	; endWhile
	; return Highest
	; Next position
	Actor NextActor = Positions[IndexTravel(Positions.Find(ActorRef), ActorCount)]
	int Highest = ActorRef.GetRelationshipRank(NextActor)
	; loop through each position until reaching ActorRef
	while NextActor != ActorRef
		NextActor = Positions[IndexTravel(Positions.Find(NextActor), ActorCount)]
		if NextActor != ActorRef && ActorRef.GetRelationshipRank(NextActor) > Highest
			Highest = ActorRef.GetRelationshipRank(NextActor)
		endIf
	endWhile
	return Highest
endFunction

int function GetLowestPresentRelationshipRank(Actor ActorRef)
	if ActorCount < 3
		return GetHighestPresentRelationshipRank(ActorRef) ; Results will be same for 1 and 2 actors
	endIf
	; Next position
	Actor NextActor = Positions[IndexTravel(Positions.Find(ActorRef), ActorCount)]
	int Lowest = ActorRef.GetRelationshipRank(NextActor)
	; loop through each position until reaching ActorRef
	while NextActor != ActorRef
		NextActor = Positions[IndexTravel(Positions.Find(NextActor), ActorCount)]
		if NextActor != ActorRef && ActorRef.GetRelationshipRank(NextActor) < Lowest
			Lowest = ActorRef.GetRelationshipRank(NextActor)
		endIf
	endWhile
	return Lowest
endFunction

; ------------------------------------------------------- ;
; --- Animation Setup                                 --- ;
; ------------------------------------------------------- ;

function SetForcedAnimations(sslBaseAnimation[] AnimationList)
	if AnimationList.Length != 0
		CustomAnimations = AnimationList
	endIf
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
	BedFlag = 0
	if disabling
		BedFlag = -1
	endIf
endFunction

function SetBedFlag(int flag = 0)
	BedFlag = flag
endFunction

function SetTimers(float[] setTimers)
	if setTimers.Length < 1
		Log("SetTimers() - Empty timers given.", "ERROR")
		return
	endIf
	CustomTimers = setTimers
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
	if CenterOn != none
		CenterRef = CenterOn
		CenterOnCoords(CenterOn.GetPositionX(), CenterOn.GetPositionY(), CenterOn.GetPositionZ(), CenterOn.GetAngleX(), CenterOn.GetAngleY(), CenterOn.GetAngleZ(), false)
		if BedsList.HasForm(CenterOn.GetBaseObject())
			BedRef = CenterOn
			CenterLocation[0] = CenterLocation[0] + (33.0 * Math.sin(CenterLocation[5]))
			CenterLocation[1] = CenterLocation[1] + (33.0 * Math.cos(CenterLocation[5]))
			if !BedRollsList.HasForm(CenterOn.GetBaseObject())
				CenterLocation[2] = CenterLocation[2] + 37.0
			endIf
		endIf
	endIf
endFunction

function CenterOnCoords(float LocX = 0.0, float LocY = 0.0, float LocZ = 0.0, float RotX = 0.0, float RotY = 0.0, float RotZ = 0.0, bool resync = true)
	CenterLocation = new float[6]
	CenterLocation[0] = LocX
	CenterLocation[1] = LocY
	CenterLocation[2] = LocZ
	CenterLocation[3] = RotX
	CenterLocation[4] = RotY
	CenterLocation[5] = RotZ
endFunction

 bool function CenterOnBed(bool AskPlayer = true, float Radius = 750.0)
 	ObjectReference FoundBed
	if BedFlag == -1
		return false ; Beds forbidden by flag
	elseIf HasPlayer
		FoundBed = FindBed(PlayerRef, Radius) ; Check within radius of player
	elseIf Config.sNPCBed == "$SSL_Always" || (Config.sNPCBed == "$SSL_Sometimes" && (Utility.RandomInt(0, 1) as bool))
		FoundBed = FindBed(Positions[0], Radius) ; Check within radius of first position, if NPC beds are allowed
	endIf
	; Found a bed AND EITHER forced use OR don't care about players choice OR or player approved
	if FoundBed != none && (BedFlag == 1 || (!AskPlayer || (AskPlayer && (UseBed.Show() as bool))))
		CenterOnObject(FoundBed)
		return true ; Bed found and approved for use
	endIf
	return false ; No bed found
endFunction

; ------------------------------------------------------- ;
; --- Event Hooks                                     --- ;
; ------------------------------------------------------- ;

function SetHook(string AddHooks)
	string[] Setting = ArgString(AddHooks)
	int i = Setting.Length
	while i
		i -= 1
		if Setting[i] != "" && Hooks.Find(Setting[i]) == -1
			AddTag(Setting[i])
			Hooks = PushString(Setting[i], Hooks)
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
	string[] Removing = ArgString(DelHooks)
	string[] NewHooks
	int i = Hooks.Length
	while i
		i -= 1
		if Removing.Find(Hooks[i]) != -1
			RemoveTag(Hooks[i])
		else
			NewHooks = PushString(Hooks[i], NewHooks)
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
	if HasTag(Tag) || Tag == ""
		return false
	endIf
	int i = Tags.Find(Tag)
	if i == -1
		Tags = PushString(Tag, Tags)
	else
		Tags[i] = Tag
	endIf
	return true
endFunction

bool function RemoveTag(string Tag)
	if !HasTag(Tag) || Tag == ""
		return false
	endIf
	Tags[Tags.Find(Tag)] = ""
	return true
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
; --- System Use Only                                 --- ;
; ------------------------------------------------------- ;

function Initialize()
	UnregisterForUpdate()
	; Clear aliases
	ActorAlias[0].ClearAlias()
	ActorAlias[1].ClearAlias()
	ActorAlias[2].ClearAlias()
	ActorAlias[3].ClearAlias()
	ActorAlias[4].ClearAlias()
	; Forms
	VictimRef      = none
	CenterRef      = none
	BedRef         = none
	; Boolean
	AutoAdvance    = true
	HasPlayer      = false
	LeadIn         = false
	NoLeadIn       = false
	FastEnd        = false
	IsAggressive   = false
	IsVaginal      = false
	IsAnal         = false
	IsOral         = false
	; Floats
	StartedAt      = 0.0
	; Integers
	BedFlag        = 0
	ActorCount     = 0
	Stage          = 1
	; Strings
	AdjustKey      = ""
	; Storage
	Actor[] aDel
	string[] sDel1
	float[] fDel1
	Positions      = aDel
	Hooks          = sDel1
	CustomTimers   = fDel1
	Genders        = new int[3]
	AliasDone      = new int[5]
	SkillXP        = new float[6]
	Tags           = new string[5]
	; Animations
	sslBaseAnimation[] anDel1
	sslBaseAnimation[] anDel2
	sslBaseAnimation[] anDel3
	CustomAnimations  = anDel1
	PrimaryAnimations = anDel2
	LeadAnimations    = anDel3
	Animation         = none
	; Enter thread selection pool
	GoToState("Unlocked")
endFunction

function Log(string Log, string Type = "NOTICE")
	SexLabUtil.DebugLog(Log, "Thread["+thread_id+"] - "+Type, Config.DebugMode)
	if Type == "FATAL"
		Initialize()
	endIf
endFunction

function SendThreadEvent(string HookEvent)
	; Log(HookEvent, "Event Hook")
	SetupThreadEvent(HookEvent)
	int i = Hooks.Length
	while i
		i -= 1
		SetupThreadEvent(HookEvent+"_"+Hooks[i])
	endWhile
	if HasPlayer
		SendModEvent("Player"+HookEvent, thread_id)
	endIf
endFunction

function SetupThreadEvent(string HookEvent)
	int eid = ModEvent.Create(HookEvent)
	if eid
		ModEvent.PushString(eid, HookEvent)
		ModEvent.PushInt(eid, thread_id)
		ModEvent.PushInt(eid, HasPlayer as int)
		ModEvent.PushForm(eid, self)
		ModEvent.Send(eid)
		; Log("Thread Hook Sent: "+HookEvent)
	endIf
	SendModEvent(HookEvent, thread_id)
endFunction

int function GetXP(int i)
	return SkillXP[i] as int
endFunction

float[] function GetSkillBonus()
	float[] Bonus = new float[6]
	Bonus[0] = SkillXP[0] as float
	if IsVaginal
		Bonus[1] = SkillXP[1] as float
	endIf
	if IsAnal
		Bonus[2] = SkillXP[2] as float
	endIf
	if IsOral
		Bonus[3] = SkillXP[3] as float
	endIf
	if IsLoving
		Bonus[4] = SkillXP[4] as float
	endIf
	if IsDirty
		Bonus[5] = SkillXP[5] as float
	endIf
	return Bonus
endFunction

function AddXP(int i, float Amount, bool Condition = true)
	if Condition && Amount >= 0.375 && SkillXP[i] < 5
		SkillXP[i] = SkillXP[i] + Amount
	endIf
endFunction

string function Key(string Callback)
	return "SSL_"+thread_id+"_"+Callback
endFunction

int[] AliasDone
string[] EventTypes
function AliasEvent(string Callback, bool AliasWait = true)
	if AliasWait
		int i = EventTypes.Find(Callback)
		if AliasDone[i] != 0
			Log(Callback+" attempting to start during previous event")
			return
		endIf
		AliasDone[i] = 0
	endIf
	ModEvent.Send(ModEvent.Create(Key(Callback)))
endFunction

function AliasEventDone(string Callback = "Alias")
	int i = EventTypes.Find(Callback)
	AliasDone[i] = AliasDone[i] + 1
	if AliasDone[i] >= ActorCount
		AliasDone[i] = 0
		ModEvent.Send(ModEvent.Create(Key(Callback+"Done")))
	endIf
endFunction

function Action(string FireState)
	UnregisterForUpdate()
	EndAction()
	GoToState(FireState)
	FireAction()
endfunction

function UpdateAdjustKey()
	AdjustKey = Animation.Key("Adjust")
	if ActorCount > 1 && Config.bRaceAdjustments
		int i
		while i < ActorCount
			ActorBase BaseRef = Positions[i].GetLeveledActorBase()
			AdjustKey += "."+MiscUtil.GetRaceEditorID(BaseRef.GetRace())
			if Genders[2] > 0 && PositionAlias(i).Gender == 2
				; No gender preference for creatures
			elseIf BaseRef.GetSex() == 1
				AdjustKey += "F"
			else
				AdjustKey += "M"
			endIf
			i += 1
		endWhile
	else
		AdjustKey += ".Global"
	endIf
	MiscUtil.PrintConsole(AdjustKey)
endFunction


function ThreadInit(int value)
	thread_id = value
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

	EventTypes = new string[5]
	EventTypes[0] = "Sync"
	EventTypes[1] = "Prepare"
	EventTypes[2] = "Reset"
	EventTypes[3] = "Strip"
	EventTypes[4] = "Orgasm"

	Setup()
	Initialize()
endFunction

int thread_id
int property tid hidden
	int function get()
		return thread_id
	endFunction
endProperty

; ------------------------------------------------------- ;
; --- State Restricted                                --- ;
; ------------------------------------------------------- ;

auto state Unlocked
	sslThreadModel function Make()
		Initialize()
		GoToState("Making")
		RegisterForSingleUpdate(30.0)
		return self
	endFunction
	function EnableHotkeys()
	endFunction
endState

; Making
sslThreadModel function Make()
	Log("Make() - Cannot enter make on a locked thread", "FATAL")
	return none
endFunction
sslThreadController function StartThread()
	Log("StartThread() - Cannot start thread while not in a Making state", "FATAL")
	return none
endFunction
int function AddActor(Actor ActorRef, bool IsVictim = false, sslBaseVoice Voice = none, bool ForceSilent = false)
	Log("AddActor() - Cannot add an actor to a locked thread", "FATAL")
	return -1
endFunction
bool function AddActors(Actor[] ActorList, Actor VictimActor = none)
	Log("AddActors() - Cannot add a list of actors to a locked thread", "FATAL")
	return false
endFunction
; State varied
function FireAction()
endFunction
function EndAction()
endFunction
function SyncDone()
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
function EnableHotkeys()
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
