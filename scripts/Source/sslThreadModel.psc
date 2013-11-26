scriptname sslThreadModel extends ReferenceAlias
{ Animation Thread Model: Runs storage and information about a thread. Access only through functions; NEVER create a property directly to this. }

; Library
sslThreadLibrary property Lib auto

; Locks
bool Active

; Actors
actor[] property Positions auto hidden
sslActorAlias[] ActorSlots

; Animations
int property Stage auto hidden
sslBaseAnimation[] customAnimations
sslBaseAnimation[] primaryAnimations
sslBaseAnimation[] leadAnimations

; Thread Instance settings
string property Logging auto hidden
bool property AutoAdvance auto hidden
bool property LeadIn auto hidden
bool property FastEnd auto hidden

ObjectReference centerObj
float[] centerLoc
float[] customtimers
bool leadInDisabled
actor PlayerRef
actor victim
string hook
int bed ; 0 allow, 1 in use, 2 force, -1 forbid
Race Creature
float started

; Thread Instance Info
sslActorAlias[] property ActorAlias hidden
	sslActorAlias[] function get()
		return ActorSlots
	endFunction
endProperty

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

int property ActorCount hidden
	int function get()
		return Positions.Length
	endFunction
endProperty

bool property HasPlayer hidden
	bool function get()
		return PlayerRef != none
	endFunction
endProperty

bool property HasCreature hidden
	bool function get()
		return Creature != none
	endFunction
endProperty

Race property CreatureRef hidden
	Race function get()
		return Creature
	endFunction
endProperty

bool property IsAggressive hidden
	bool function get()
		return victim != none
	endFunction
endProperty

bool property IsUsingBed hidden
	bool function get()
		return bed == 1
	endFunction
endProperty

ObjectReference property CenterRef hidden
	ObjectReference function get()
		return centerObj
	endFunction
endProperty

float[] property CenterLocation hidden
	float[] function get()
		return centerLoc
	endFunction
endProperty

float[] property Timers hidden
	float[] function get()
		if customtimers.Length > 0
			return customtimers
		elseif leadIn
			return Lib.fStageTimerLeadIn
		elseif IsAggressive
			return Lib.fStageTimerAggr
		else
			return Lib.fStageTimer
		endIf
	endFunction
endProperty

bool property IsLocked hidden
	bool function get()
		return GetState() != "Unlocked"
	endFunction
endProperty

float property StartedAt hidden
	float function get()
		return started
	endFunction
endProperty

float property TotalTime hidden
	float function get()
		return Utility.GetCurrentRealTime() - started
	endFunction
endProperty

;/-----------------------------------------------\;
;|	Preparation Functions                        |;
;\-----------------------------------------------/;
state Unlocked
	sslThreadModel function Make(float timeoutIn = 5.0)
		Initialize()
		ActorSlots = new sslActorAlias[5]
		GoToState("Making")
		RegisterForSingleUpdate((timeoutIn + 5.0))
		return self
	endFunction
endState

state Making
	event OnUpdate()
		if !Active
			_Log("Thread has timed out of the making process; resetting model for selection pool", "Make", "FATAL")
		endIf
	endEvent

	int function AddActor(actor position, bool isVictim = false, sslBaseVoice voice = none, bool forceSilent = false)
		if Positions.Find(position) != -1
			_Log("Duplicate actor", "AddActor")
			return -1
		elseif ActorCount >= 5
			_Log("No available actor positions", "AddActor")
			return -1
		endIf
		; Slot and parse
		int id = -1
		sslActorAlias Slot = Lib.Actors.Slots.SlotActor(position, self as sslThreadController)
		if Slot == none
			_Log("Failed to slot actor '"+position+"'", "AddActor", "FATAL")
			return -1
		elseif Slot.IsCreature()
			Race PosCreature = position.GetLeveledActorBase().GetRace()
			if Creature != none && !Lib.Actors.AnimLib.AllowedCreatureCombination(PosCreature, Creature)
				_Log("Invalid creature race combination '"+Creature.GetName()+"' & '"+PosCreature.GetName()+"'", "AddActor", "FATAL")
				return -1
			endIf
			Creature = PosCreature
		else
			; Set voice
			Slot.SetVoice(voice, forceSilent)
			; Set Player actor
			if position == Lib.PlayerRef
				PlayerRef = position
			endIf
		endIf
		; Set as victim
		if isVictim
			Slot.MakeVictim(true)
			victim = position
		endIf
		; Push actor to positions array
		Positions = sslUtility.PushActor(position, Positions)
		id = ActorCount - 1
		; Save Actor/Alias slot
		ActorSlots[id] = Slot
		return id
	endFunction

	sslThreadController function StartThread()
		if ActorCount == 0
			_Log("No valid actors available for animation", "StartThread", "FATAL")
			return none
		endIf
		int actors = ActorCount
		int i
		while i < actors
			; Check for duplicate actors
			if Positions.Find(Positions[i]) != Positions.RFind(Positions[i])
				_Log("Duplicate actor found in list", "StartThread", "FATAL")
				return none
			endIf
			; Pick expression for actor
			ActorAlias[i].SetExpression(Lib.Expressions.PickExpression(Positions[i], Victim))
			i += 1
		endWhile

		; Check for valid animations
		if HasCreature
			primaryAnimations = Lib.CreatureAnimations.GetByRace(actors, Creature)
			DisableLeadIn(true)
			; Bail if no valid creature animations
			if primaryAnimations.Length == 0
				_Log("Unable to find valid creature animations", "StartThread", "FATAL")
				return none
			endIf
			Positions = Lib.SortCreatures(Positions, primaryAnimations[0])
			CenterOnObject(Positions[0])
		endIf

		if primaryAnimations.Length == 0
			int[] gender = Lib.Actors.GenderCount(Positions)
			; Same sex pairings
			if (gender[1] == 2 && gender[0] == 0) || (gender[0] == 2 && gender[1] == 0)
				sslBaseAnimation[] samesex = Lib.Animations.GetByType(actors, gender[0], gender[1], aggressive = IsAggressive)
				sslBaseAnimation[] couples = Lib.Animations.GetByType(actors, 1, 1, aggressive = IsAggressive)
				primaryAnimations = Lib.Animations.MergeLists(samesex, couples)
			elseif actors < 3
				; Grab animations like normal
				primaryAnimations = Lib.Animations.GetByType(actors, gender[0], gender[1], aggressive = IsAggressive)
			elseif actors >= 3
				; Get 3P + animations ignoring gender
				primaryAnimations = Lib.Animations.GetByType(actors, aggressive = IsAggressive)
			endIf
			; Check for valid animations again
			if primaryAnimations.Length == 0
				_Log("Unable to find valid animations", "StartThread", "FATAL")
				return none
			endIf
		endIf

		; Determine if foreplay lead in should be used
		if Lib.bForeplayStage && !leadInDisabled && leadAnimations.Length == 0 && !HasCreature && !IsAggressive && actors == 2
			SetLeadAnimations(Lib.Animations.GetByTag(2, "LeadIn"))
		endIf

		; Validate Primary animations
		i = primaryAnimations.Length
		while i
			i -= 1
			if actors != primaryAnimations[i].PositionCount
				_Log("Primary animation '"+primaryAnimations[i].Name+"' requires "+primaryAnimations[i].PositionCount+" actors, only "+actors+" present", "StartThread", "FATAL")
				return none
			endIf
		endWhile

		; Validate Leadin Animations
		if !leadInDisabled && !HasCreature && leadAnimations.Length > 0
			i = leadAnimations.Length
			while i
				i -= 1
				if actors != leadAnimations[i].PositionCount
					_Log("Lead in animation '"+leadAnimations[i].Name+"' requires "+leadAnimations[i].PositionCount+" actors, only "+actors+" present", "StartThread", "FATAL")
					return none
				endIf
			endWhile
		endIf

		; Check for center
		if centerObj == none && bed != -1
			ObjectReference BedRef
			; Select a bed
			if PlayerRef != none
				BedRef = Lib.FindBed(PlayerRef, 750.0)
			else
				BedRef = Lib.FindBed(Positions[0], 1000.0)
			endIf
			; A bed was selected, should we use it?
			if BedRef != none
				bool use = bed == 2 || Lib.sNPCBed == "$SSL_Always"
				if PlayerRef != none && !IsVictim(PlayerRef)
					use = Lib.mUseBed.Show() as bool
				elseIf Lib.sNPCBed == "$SSL_Sometimes"
					use = Utility.RandomInt(0, 1) as bool
				endIf
				if use
					CenterOnObject(BedRef)
				endIf
			endIf
		endIf

		; Find a marker near one of our actors and center there
		if centerObj == none
			i = 0
			while i < actors
				ObjectReference marker = Game.FindRandomReferenceOfTypeFromRef(Lib.LocationMarker, Positions[i], 750.0) as ObjectReference
				if marker != none
					CenterOnObject(marker)
					i = 5
				endIf
				i += 1
			endWhile
		endIf

		; Still no center, fallback to something
		if centerLoc.Length == 0
			; Fallback to victim
			if victim != none
				CenterOnObject(victim)
			; Fallback to player
			elseif PlayerRef != none
				CenterOnObject(PlayerRef)
			; Fallback to first position actor
			else
				CenterOnObject(Positions[0])
			endIf
		endIf

		; Enable auto advance
		if PlayerRef != none
			if IsVictim(PlayerRef) && Lib.Actors.bDisablePlayer
				AutoAdvance = true
			else
				AutoAdvance = Lib.bAutoAdvance
			endIf
		else
			AutoAdvance = true
		endIf

		; Start the controller
		sslThreadController Controller = PrimeThread()
		Active = PrimeThread() != none
		started = Utility.GetCurrentRealTime()
		return Controller
	endFunction
endState

;/-----------------------------------------------\;
;|	Setting Functions                            |;
;\-----------------------------------------------/;

function SetHook(string hookName)
	hook = hookName
endFunction

string function GetHook()
	return hook
endFunction

float[] function GetCoords(ObjectReference Object)
	float[] loc = new float[6]
	loc[0] = Object.GetPositionX()
	loc[1] = Object.GetPositionY()
	loc[2] = Object.GetPositionZ()
	loc[3] = Object.GetAngleX()
	loc[4] = Object.GetAngleY()
	loc[5] = Object.GetAngleZ()
	return loc
endFunction

function CenterOnObject(ObjectReference centerOn, bool resync = true)
	if centerOn == none
		return none
	endIf
	centerObj = centerOn
	centerLoc = GetCoords(centerOn)
	if Lib.BedsList.HasForm(centerOn.GetBaseObject())
		bed = 1
		centerLoc = GetCoords(centerOn)
		centerLoc[0] = centerLoc[0] + (33.0 * Math.sin(centerLoc[5]))
		centerLoc[1] = centerLoc[1] + (33.0 * Math.cos(centerLoc[5]))
		centerLoc[2] = centerLoc[2] + 37.0
	endIf
endFunction

function CenterOnCoords(float LocX = 0.0, float LocY = 0.0, float LocZ = 0.0, float RotX = 0.0, float RotY = 0.0, float RotZ = 0.0, bool resync = true)
	centerLoc = new float[6]
	centerLoc[0] = LocX
	centerLoc[1] = LocY
	centerLoc[2] = LocZ
	centerLoc[3] = RotX
	centerLoc[4] = RotY
	centerLoc[5] = RotZ
endFunction

function AdjustRotation(float adjust)
	centerLoc[5] = centerLoc[5] + adjust
	if centerLoc[5] >= 360.0
		centerLoc[5] = centerLoc[5] - 360.0
	elseIf centerLoc[5] < 0.0
		centerLoc[5] = centerLoc[5] + 360.0
	endIf
endFunction

function SetBedding(int set = 0)
	bed = set
endFunction

function SetTimers(float[] timers)
	if timers.Length < 1
		_Log("Empty timers given.", "SetTimers")
		return
	endIf
	customtimers = timers
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

;/-----------------------------------------------\;
;|	Actor Functions                              |;
;\-----------------------------------------------/;

function ChangeActors(actor[] changeTo)
	if !Active || HasCreature
		return
	endIf
	int i
	; Validate new actors
	while i < changeTo.Length
		if Positions.Find(changeTo[i]) == -1 && !Lib.Actors.ValidateActor(changeTo[i])
			_Log("A new actor does not pass validation", "ChangeActors")
			return
		endIf
		i += 1
	endWhile
	; Check if new animations are needed
	if changeTo.Length != ActorCount
		sslBaseAnimation[] newAnims
		newAnims = Lib.Animations.GetByType(changeTo.Length, aggressive=IsAggressive)
		if newAnims.Length == 0
			_Log("No animations found for changed actor count", "ChangeActors")
			return
		endIf
		SetAnimations(newAnims)
		SetAnimation()
	endIf
	; Start changing
	SendThreadEvent("ActorChangeStart")
	; Remove actors no longer present
	i = 0
	while i < ActorCount
		ActorAlias(Positions[i]).UnregisterForUpdate()
		if changeTo.Find(Positions[i]) == -1
			sslActorAlias clearing = ActorAlias(Positions[i])
			clearing.GoToState("Reset")
			clearing.ClearAlias()
			if IsPlayerPosition(i)
				AutoAdvance = true
			endIf
		endIf
		i += 1
	endWhile
	; Prepare/Reset actors as needed
	Positions = changeTo
	sslActorAlias[] newSlots = new sslActorAlias[5]
	i = 0
	while i < changeTo.Length
		int slot = Lib.Actors.Slots.FindActor(changeTo[i])
		if slot != -1
			; Existing actor, retrieve their slot
			newSlots[i] = Lib.Actors.Slots.GetSlot(slot)
			newSlots[i].RegisterForSingleUpdate(0.20)
		else
			; New actor, slot and prepare them
			newSlots[i] = Lib.Actors.Slots.SlotActor(changeTo[i], self as sslThreadController)
			sslActorAlias adding = newSlots[i] as sslActorAlias
			adding.SetVoice(Lib.Voices.PickVoice(changeTo[i]))
			adding.DisableUndressAnim(true)
			; Start preparing actor
			adding.GotoState("Prepare")
			; Wait for ready state
			float failsafe = Utility.GetCurrentRealTime() + 10.0
			while adding.GetState() != "Ready" && failsafe > Utility.GetCurrentRealTime()
				Utility.Wait(0.1)
			endWhile
			; Begin animation state
			adding.StartAnimating()
		endIf
		i += 1
	endWhile
	; Set new actors into thread
	ActorSlots = newSlots
	SyncActors()
	; End changing
	SendThreadEvent("ActorChangeEnd")
endFunction

;/-----------------------------------------------\;
;|	Animation Functions                          |;
;\-----------------------------------------------/;

function SetForcedAnimations(sslBaseAnimation[] animationList)
	if AnimationList.Length == 0 || HasCreature
		return
	endIf
	customAnimations = animationList
	SetAnimation()
endFunction

function SetAnimations(sslBaseAnimation[] animationList)
	if AnimationList.Length == 0 || HasCreature
		return
	endIf
	primaryAnimations = animationList
	SetAnimation()
endFunction

function SetLeadAnimations(sslBaseAnimation[] animationList)
	if AnimationList.Length == 0 || HasCreature
		return
	endIf
	leadIn = true
	leadAnimations = animationList
	SetAnimation()
endFunction

function DisableLeadIn(bool disableIt = true)
	leadInDisabled = disableIt
	if disableIt
		leadIn = false
	endIf
endFunction

function DisableUndressAnimation(actor position, bool disableIt = true)
	ActorAlias(position).DisableUndressAnim(disableIt)
endFunction

function DisableRagdollEnd(actor position, bool disableIt = true)
	ActorAlias(position).DisableRagdollEnd(disableIt)
endFunction

;/-----------------------------------------------\;
;|	Storage Functions                            |;
;\-----------------------------------------------/;

int function GetSlot(actor position)
	int i = ActorCount
	while i
		i -= 1
		if ActorSlots[i].ActorRef == position
			return i
		endIf
	endWhile
	return -1
endFunction

sslActorAlias function ActorSlot(int position)
	return ActorAlias[GetSlot(Positions[position])]
endFunction

sslActorAlias function ActorAlias(actor position)
	return ActorAlias[GetSlot(position)]
endFunction

int function GetPosition(actor position)
	return Positions.Find(position)
endFunction

function SetStrip(actor position, bool[] strip)
	if strip.Length != 33
		_Log("Malformed strip bool[] passed, must be 33 length bool array, "+strip.Length+" given", "SetStrip")
		return
	endIf
	ActorAlias(position).OverrideStrip(strip)
endFunction

function SetVoice(actor position, sslBaseVoice voice)
	ActorAlias(position).SetVoice(voice)
endFunction

sslBaseVoice function GetVoice(actor position)
	return ActorAlias(position).GetVoice()
endFunction

function SetExpression(actor position, sslBaseExpression expression)
	ActorAlias(position).SetExpression(expression)
endFunction

sslBaseExpression function GetExpression(actor position)
	return ActorAlias(position).GetExpression()
endFunction

bool function HasPlayer()
	return PlayerRef != none
endFunction

actor function GetPlayer()
	return PlayerRef
endFunction

int function GetPlayerPosition()
	return Positions.Find(Lib.PlayerRef)
endFunction

bool function IsPlayerActor(actor position)
	return position == Lib.PlayerRef
endFunction

bool function IsPlayerPosition(int position)
	return position == GetPlayerPosition()
endFunction

bool function HasActor(actor position)
	return Positions.Find(position) != -1
endFunction

actor function GetActor(int position)
	return Positions[position]
endFunction

bool function IsVictim(actor a)
	return victim == a
endFunction

actor function GetVictim()
	return victim
endFunction

float function GetTime()
	return started
endfunction

;/-----------------------------------------------\;
;|	Utility Functions                            |;
;\-----------------------------------------------/;

function SyncActors()
	int i = ActorCount
	while i
		i -= 1
		ActorAlias[i].SyncThread()
	endWhile
endFunction

function SendThreadEvent(string eventName, float argNum = 0.0)
	if !Active
		return
	endIf
	string customEvent
	; Send Custom Event
	if hook != ""
		customEvent = eventName+"_"+hook
		SendModEvent(customEvent, (tid as string), argNum)
	endIf
	; Send Global Event
	SendModEvent(eventName, (tid as string), argNum)
	Debug.Trace("SexLab Thread["+_ThreadID+"] ModEvent: "+eventName+" / "+customEvent)
endFunction

function SendActorEvent(string eventName, float argNum = 0.0)
	if !Active
		return
	endIf
	int i = ActorCount
	while i
		i -= 1
		ActorAlias[i].RegisterForModEvent(eventName, "On"+eventName)
	endWhile
	SendModEvent(eventName, (tid as string), argNum)
endFunction

int function ArrayWrap(int value, int max)
	max -= 1
	if value > max
		return 0
	elseif value < 0
		return max
	endIf
	return value
endFunction

float function SignFloat(float value, bool sign)
	if sign
		return value * -1
	endIf
	return value
endFunction

int function SignInt(int value, bool sign)
	if sign
		return value * -1
	endIf
	return value
endFunction

; bool function Locked(string method)
; 	if GetState() == "Unlocked"
; 		_Log("Unsafe attempt to modify unlocked thread["+tid+"]", method, "FATAL")
; 		return false
; 	endIf
; 	return true
; endFunction

function _Log(string log, string method, string type = "ERROR")
	int severity = 0
	if type == "ERROR" || type == "FATAL"
		severity = 2
	elseif type == "NOTICE"
		severity = 1
	endIf

	if Logging == "notification"
		Debug.Notification(type+": "+log)
	elseif Logging == "messagebox"
		Debug.MessageBox(method+"() "+type+": "+log)
	elseif Logging == "trace-minimal"
		Debug.Trace("SexLab "+method+"() "+type+": "+log, severity)
	else
		Debug.Trace("--- SexLab ThreadController["+tid+"] ------------------------------------------------------", severity)
		Debug.Trace(" "+type+": "+method+"()" )
		Debug.Trace("   "+log)
		Debug.Trace("--------------------------------------------------------------------------------------------", severity)
	endIf
	if type == "FATAL"
		UnlockThread()
	endIf
endFunction

;/-----------------------------------------------\;
;|	Ending Functions                             |;
;\-----------------------------------------------/;

function UnlockThread()
	Initialize()
endFunction

function Initialize()
	; Set states
	Active = false
	; Empty Strings
	hook = ""
	Logging = "trace"
	; Empty actors
	actor[] acDel
	Positions = acDel
	victim = none
	; Empty alias slots
	int i = ActorSlots.Length
	while i
		i -= 1
		if ActorSlots[i] != none
			ActorSlots[i].ClearAlias()
		endIf
	endWhile
	sslActorAlias[] aaDel
	ActorSlots = aaDel
	; Empty Floats
	float[] fDel
	centerLoc = fDel
	customtimers = fDel
	started = 0.0
	; Empty bools
	leadIn = false
	leadInDisabled = false
	AutoAdvance = false
	FastEnd = false
	; Empty forms
	; Empty integers
	bed = 0
	stage = 0
	; Empty animations
	sslBaseAnimation[] anDel
	customAnimations = anDel
	primaryAnimations = anDel
	leadAnimations = anDel
	; Clear Forms
	centerObj = none
	PlayerRef = none
	creature = none
	GotoState("Unlocked")
endFunction

;/-----------------------------------------------\;
;| State Permissible Functions                   |;
;\-----------------------------------------------/;

sslThreadModel function Make(float timeoutIn = 5.0)
	_Log("Cannot enter make on a locked thread", "Make")
	return none
endFunction

int function AddActor(actor position, bool isVictim = false, sslBaseVoice voice = none, bool forceSilent = false)
	_Log("Cannot add an actor to a locked thread", "AddActor")
	return -1
endFunction

sslThreadController function StartThread()
	_Log("Cannot start thread while not in a Making state", "StartThread")
	return none
endFunction

;/-----------------------------------------------\;
;|	Child Functions                              |;
;\-----------------------------------------------/;

int _ThreadID
int property tid hidden
	int function get()
		return _ThreadID
	endFunction
endProperty

function _SetThreadID(int threadid)
	_ThreadID = threadid
	UnlockThread()
endFunction
auto state Unlocked
endState

sslThreadController function PrimeThread()
	return none
endFunction
function EquipExtras(actor position)
endFunction
function RemoveExtras(actor position)
endFunction
function UpdateLocations()
endFunction
function ResetActor(actor position)
endFunction
function SetupActor(actor position)
endFunction
function AdvanceStage(bool backwards = false)
endFunction
function SetAnimation(int aid = -1)
endFunction
function GoToStage(int toStage)
endFunction
