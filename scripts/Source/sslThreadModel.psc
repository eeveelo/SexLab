scriptname sslThreadModel extends sslSystemLibrary

bool property IsLocked hidden
	bool function get()
		return GetState() != "Unlocked"
	endFunction
endProperty

; Actor Storage
Actor[] property Positions auto hidden
Actor property VictimRef auto hidden
int property ActorCount auto hidden
sslActorAlias[] property ActorAlias auto hidden

; Thread status
bool property HasPlayer auto hidden
bool property AutoAdvance auto hidden
bool property LeadIn auto hidden
bool property FastEnd auto hidden
bool property IsAggressive auto hidden

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
		; Ensure we have room for actor
		if ActorCount >= 5
			Log("AddActor() - Failed to add actor '"+ActorRef.GetLeveledActorBase().GetName()+"' -- Thread has reached actor limit", "FATAL")
			return -1
		elseIf Positions.Find(ActorRef) != -1 || ActorLib.IsActorActive(ActorRef)
			Log("AddActor() - Failed to add actor '"+ActorRef.GetLeveledActorBase().GetName()+"' -- They are already slotted into this thread", "FATAL")
			return -1
		endIf
		; Attempt to claim a slot
		sslActorAlias Slot = SlotActor(ActorRef)
		if !Slot || !Slot.PrepareAlias(ActorRef, IsVictim, Voice, ForceSilent)
			Log("AddActor() - Failed to add actor '"+ActorRef.GetLeveledActorBase().GetName()+"' -- They were unable to fill an actor alias", "FATAL")
			return -1
		endIf
		; Add to thread Positions and return position location.
		Positions = sslUtility.PushActor(ActorRef, Positions)
		Genders[Slot.Gender] = Genders[Slot.Gender] + 1
		ActorCount += 1
		return Positions.Find(ActorRef)
	endFunction

	sslThreadController function StartThread()
		if ActorCount < 1
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

		; ; Validate Animations

		; ; Search for nearby bed
		; if CenterRef == none && bedding != -1
		; 	LocateBed(HasPlayer, 750.0)
		; endIf
		; ; Find a location marker near one of our actors and center there
		; i = ActorCount
		; while CenterRef == none && i
		; 	i -= 1
		; 	CenterOnObject(Game.FindClosestReferenceOfTypeFromRef(Lib.LocationMarker, Positions[i], 750.0))
		; endWhile
		; ; Still no center, fallback to something
		; if CenterRef == none
		; 	if IsAggressive ; Fallback to victim
		; 		CenterOnObject(VictimRef)
		; 	elseif HasPlayer ; Fallback to player
		; 		CenterOnObject(PlayerRef)
		; 	else
		; 		CenterOnObject(Positions[0]) ; Fallback to first position actor
		; 	endIf
		; endIf

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
; --- Event Hooks                                     --- ;
; ------------------------------------------------------- ;

function SetHook(string addHooks)
	string[] Setting = sslUtility.ArgString(addHooks)
	int i = Setting.Length
	while i
		i -= 1
		if Setting[i] != "" && Hooks.Find(Setting[i]) == -1
			; AddTag(Setting[i])
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

; ------------------------------------------------------- ;
; --- System Use Only                                 --- ;
; ------------------------------------------------------- ;

function Initialize()
	UnregisterForUpdate()
	GoToState("Unlocked")

	Actor[] aDel
	Positions = aDel
	ActorCount = 0
	Genders = new int[3]
endFunction

function Log(string log, string type = "NOTICE")
	MiscUtil.PrintConsole("Thread["+thread_id+"]"+type+": "+log)
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
		ModEvent.PushForm(eid, self)
		ModEvent.PushBool(eid, HasPlayer)
		ModEvent.PushForm(eid, VictimRef)
		ModEvent.PushFloat(eid, StartedAt)
		ModEvent.Send(eid)
	endIf
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

int thread_id
int property tid hidden
	int function get()
		return thread_id
	endFunction
endProperty

function _SetupThread(int id)
	Initialize()
	thread_id = id
	ActorAlias = new sslActorAlias[5]
	ActorAlias[0] = GetNthAlias(0) as sslActorAlias
	ActorAlias[1] = GetNthAlias(1) as sslActorAlias
	ActorAlias[2] = GetNthAlias(2) as sslActorAlias
	ActorAlias[3] = GetNthAlias(3) as sslActorAlias
	ActorAlias[4] = GetNthAlias(4) as sslActorAlias
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
