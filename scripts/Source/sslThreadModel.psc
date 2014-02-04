scriptname sslThreadModel extends sslBaseObject
{ Animation Thread Model: Runs storage and information about a thread. Access only through functions; NEVER create a property directly to this. }

; Library
sslThreadLibrary property Lib auto

; Thread status
bool property HasPlayer auto hidden
bool property AutoAdvance auto hidden
bool property LeadIn auto hidden
bool property FastEnd auto hidden
bool property IsAggressive auto hidden

bool property IsLocked hidden
	bool function get()
		return GetState() != "Unlocked"
	endFunction
endProperty

; Actor Storage
Actor property PlayerRef auto hidden
Actor[] property Positions auto hidden
sslActorAlias[] property ActorAlias auto hidden

; Animation Info
int property Stage auto hidden
sslBaseAnimation[] CustomAnimations
sslBaseAnimation[] PrimaryAnimations
sslBaseAnimation[] LeadAnimations
sslBaseAnimation[] property Animations hidden
	sslBaseAnimation[] function get()
		if customAnimations.Length > 0
			return customAnimations
		elseIf leadIn
			return leadAnimations
		else
			return primaryAnimations
		endIf
	endFunction
endProperty

; Timer Info
float[] CustomTimers
float[] property Timers hidden
	float[] function get()
		if CustomTimers.Length != 0
			return CustomTimers
		elseif LeadIn
			return Lib.fStageTimerLeadIn
		elseif IsAggressive
			return Lib.fStageTimerAggr
		else
			return Lib.fStageTimer
		endIf
	endFunction
endProperty

; Thread info
int property ActorCount auto hidden
Actor property VictimRef auto hidden
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
		return Creatures != 0
	endFunction
endProperty

; Local readonly
bool Active
bool LeadInDisabled
string[] Hooks
int bedding ; 0 allow, 1 force, -1 forbid

; ------------------------------------------------------- ;
; --- Thread Making API                               --- ;
; ------------------------------------------------------- ;

state Making

	int function AddActor(Actor ActorRef, bool IsVictim = false, sslBaseVoice Voice = none, bool ForceSilent = false)
		; Ensure we have roomf or actor
		if ActorCount >= 5
			Log("AddActor() - Failed to add actor '"+ActorRef.GetLeveledActorBase().GetName()+"' -- Thread has reached actor limit", "FATAL")
			return -1
		endIf
		; Attempt to claim a slot
		sslActorAlias Slot = SlotActor(ActorRef)
		if !Slot || !Slot.PrepareAlias(tid, ActorRef, IsVictim, Voice, ForceSilent)
			Log("AddActor() - Failed to add actor '"+ActorRef.GetLeveledActorBase().GetName()+"' -- They were unable to fill an actor slot", "FATAL")
			return -1
		endIf
		; Add to thread Positions and return position location.
		Positions[ActorCount] = ActorRef
		ActorCount += 1
		return Positions.Find(ActorRef)
	endFunction

	sslThreadController function StartThread()
		if ActorCount == 0
			Log("StartThread() - No valid actors available for animation", "FATAL")
			return none
		endIf
		Active = true

		; Check for duplicate actors
		int i = ActorCount
		while i
			i -= 1
			if Positions.Find(Positions[i]) != Positions.RFind(Positions[i])
				Log("StartThread() - Duplicate actor found in list", "FATAL")
				return none
			endIf
		endWhile

		; Remember present genders
		Genders = Lib.ActorLib.GenderCount(Positions)

		; Validate Animations

		; Search for nearby bed
		if CenterRef == none && bedding != -1
			LocateBed(HasPlayer, 750.0)
		endIf
		; Find a location marker near one of our actors and center there
		i = ActorCount
		while CenterRef == none && i
			i -= 1
			CenterOnObject(Game.FindClosestReferenceOfTypeFromRef(Lib.LocationMarker, Positions[i], 750.0))
		endWhile
		; Still no center, fallback to something
		if CenterRef == none
			if IsAggressive ; Fallback to victim
				CenterOnObject(VictimRef)
			elseif HasPlayer ; Fallback to player
				CenterOnObject(PlayerRef)
			else
				CenterOnObject(Positions[0]) ; Fallback to first position actor
			endIf
		endIf

		; Start the controller
		sslThreadController Controller = PrimeThread()
		if Controller == none
			Log("StartThread() - Failed to start, controller is null", "FATAL")
			return none
		endIf
		StartedAt = Utility.GetCurrentRealTime()
		return Controller
	endFunction

	event OnUpdate()
		Log("Thread has timed out of the making process; resetting model for selection pool", "FATAL")
		Initialize()
	endEvent

endState

; ------------------------------------------------------- ;
; --- Actor Setup                                     --- ;
; ------------------------------------------------------- ;

; Actor Overrides
function SetStrip(Actor ActorRef, bool[] StripSlots)
	if StripSlots.Length == 33
		ActorAlias(ActorRef).OverrideStrip(StripSlots)
	else
		Log("Malformed StripSlots bool[] passed, must be 33 length bool array, "+StripSlots.Length+" given", "ERROR")
	endIf
endFunction

function DisableUndressAnimation(Actor ActorRef, bool disabling = true)
	ActorAlias(ActorRef).DisableUndressAnim(disabling)
endFunction

function DisableRagdollEnd(Actor ActorRef, bool disabling = true)
	ActorAlias(ActorRef).DisableRagdollEnd(disabling)
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
	ActorAlias(ActorRef).GetEnjoyment()
endFunction
int function GetPain(Actor ActorRef)
	ActorAlias(ActorRef).GetPain()
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

; ------------------------------------------------------- ;
; --- Animation Setup                                 --- ;
; ------------------------------------------------------- ;

function SetForcedAnimations(sslBaseAnimation[] AnimationList)
	if AnimationList.Length != 0
		CustomAnimations = AnimationList
		SetAnimation()
	endIf
endFunction

function SetAnimations(sslBaseAnimation[] AnimationList)
	if AnimationList.Length != 0
		PrimaryAnimations = AnimationList
		SetAnimation()
	endIf
endFunction

function SetLeadAnimations(sslBaseAnimation[] AnimationList)
	if AnimationList.Length != 0
		LeadIn = true
		LeadAnimations = AnimationList
		SetAnimation()
	endIf
endFunction

 bool function LocateBed(bool askPlayer = true, float radius = 750.0)
	if bedding != -1
		ObjectReference FoundBed
		; Select a bed
		if PlayerRef != none
			FoundBed = Lib.FindBed(PlayerRef, radius)
			; A bed was selected, should we use it?
			if FoundBed != none && (bedding == 1 || askPlayer == false || (Lib.mUseBed.Show() as bool))
				CenterOnObject(FoundBed)
				return true
			endIf
		elseIf Lib.sNPCBed == "$SSL_Always" || (Lib.sNPCBed == "$SSL_Sometimes" && (Utility.RandomInt(0, 1) as bool)) || bedding == 1
			FoundBed = Lib.FindBed(Positions[0], radius)
			; A bed was selected, use it
			if FoundBed != none
				CenterOnObject(FoundBed)
				return true
			endIf
		endIf
	endIf
	return false
endFunction

; ------------------------------------------------------- ;
; --- Thread Settings                                 --- ;
; ------------------------------------------------------- ;

function DisableLeadIn(bool disabling = true)
	LeadInDisabled = disabling
	if disabling
		LeadIn = false
	endIf
endFunction

function SetBedding(int flag = 0)
	bedding = flag
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
		if Lib.BedsList.HasForm(CenterOn.GetBaseObject())
			BedRef = CenterOn
			CenterLocation[0] = CenterLocation[0] + (33.0 * Math.sin(CenterLocation[5]))
			CenterLocation[1] = CenterLocation[1] + (33.0 * Math.cos(CenterLocation[5]))
			if !Lib.BedRollsList.HasForm(CenterOn.GetBaseObject())
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

; ------------------------------------------------------- ;
; --- Event Hooks                                     --- ;
; ------------------------------------------------------- ;

function SetHook(string addHooks)
	string[] Setting = sslUtility.ArgString(addHooks)
	int i = Setting.Length
	while i
		i -= 1
		if Setting[i] != "" && Hooks.Find(Setting[i]) == -1
			AddTag(Setting[i])
			Hooks = sslUtility.PushString(Setting[i], Hooks)
		endIf
	endWhile
endFunction

string function GetHook()
	return Hooks[0] ; v1.35 Legacy support, pre multiple hooks
endFunction

string[] function GetHooks()
	return Hooks
endFunction

function RemoveHook(string delHooks)
	string[] Removing = sslUtility.ArgString(delHooks)
	string[] NewHooks
	int i = Hooks.Length
	while i
		i -= 1
		if Removing.Find(Hooks[i]) == -1
			NewHooks = sslUtility.PushString(Hooks[i], NewHooks)
		endIf
	endWhile
	Hooks = NewHooks
endFunction

function SendThreadEvent(string eventName)
	SetupThreadEvent(eventName)
	int i = Hooks.Length
	while i
		i -= 1
		SetupThreadEvent(eventName+"_"+Hooks[i])
	endWhile
endFunction

function SetupThreadEvent(string eventName)
	int eid = ModEvent.Create(eventName)
	if eid
		ModEvent.PushInt(eid, thread_id)
		ModEvent.PushBool(eid, HasPlayer)
		ModEvent.Send(eid)
	endIf
endFunction

; ------------------------------------------------------- ;
; --- Actor Alias                                     --- ;
; ------------------------------------------------------- ;

int function FindSlot(Actor ActorRef)
	return StorageUtil.GetIntValue(ActorRef, "SexLab.Position", -1)
endFunction

sslActorAlias function ActorAlias(Actor ActorRef)
	return ActorAlias[FindSlot(ActorRef)]
endFunction

sslActorAlias function PositionAlias(int Position)
	return ActorAlias[FindSlot(Positions[Position])]
endFunction

sslActorAlias function SlotActor(Actor ActorRef)
	int i
	while i < 5 && !ActorAlias[i].ForceRefIfEmpty(ActorRef)
		i += 1
	endWhile
	if i < 5 && ActorAlias[i].GetReference() == ActorRef
		return ActorAlias[i]
	endIf
	return none
endFunction

; ------------------------------------------------------- ;
; --- System Use Only                                 --- ;
; ------------------------------------------------------- ;

function SyncActors(bool force = false)
	int i = ActorCount
	while i
		i -= 1
		ActorAlias[i].SyncThread(force)
	endWhile
endFunction

function Log(string message, string type = "NOTICE")

endFunction

function Initialize()
	UnregisterForUpdate()
	; Objects
	Positions = new Actor[5]
	; Bools
	Active = false
	HasPlayer = false
	AutoAdvance = false
	LeadIn = false
	FastEnd = false
	; Integers
	ActorCount = 0
	; Strings
	string[] strDel1
	Hooks = strDel1

	parent.Initialize()
	Registry = "Thread["+thread_id+"]"
	GotoState("Unlocked")
endFunction

int thread_id
int property tid hidden
	int function get()
		return thread_id
	endFunction
endProperty
function _SetThreadID(int threadid)
	thread_id = threadid
	ActorAlias = (Quest.GetQuest("SexLabQuestActorSlots") as sslActorSlots).GetActorSlots(threadid)
	GoToState("Unlocked")
endFunction

; ------------------------------------------------------- ;
; --- State Restricted                                --- ;
; ------------------------------------------------------- ;

auto state Unlocked
	function SendThreadEvent(string eventName)
	endFunction
	sslThreadModel function Make(float TimeOut = 30.0)
		Initialize()
		GoToState("Making")
		RegisterForSingleUpdate(TimeOut)
		return self
	endFunction
endState

sslThreadModel function Make(float timeoutIn = 30.0)
	Log("Cannot enter make on a locked thread", "FATAL")
	return none
endFunction
sslThreadController function StartThread()
	Log("Cannot start thread while not in a Making state", "FATAL")
	return none
endFunction
sslThreadController function PrimeThread()
	return none
endFunction
int function AddActor(Actor ActorRef, bool IsVictim = false, sslBaseVoice Voice = none, bool ForceSilent = false)
	Log("Cannot add an actor to a locked thread", "FATAL")
	return -1
endFunction
function SetAnimation(int aid = -1)
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
