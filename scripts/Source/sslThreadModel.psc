scriptname sslThreadModel extends ReferenceAlias
{ Animation Thread Model: Runs storage and information about a thread. Access only through functions; NEVER create a property directly to this. }

; Library
sslThreadLibrary property Lib auto

; Locks
bool active

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

ObjectReference centerObj
float[] centerLoc
float[] customtimers
bool leadInDisabled
actor PlayerRef
actor victim
string hook
int bed ; 0 allow, 1 in use, 2 force, -1 forbid
float timeout
Race Creature

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

;/-----------------------------------------------\;
;|	Preparation Functions                        |;
;\-----------------------------------------------/;

sslThreadModel function Make(float timeoutIn = 5.0)
	if GetState() != "Unlocked"
		return none
	endIf
	Initialize()
	timeout = timeoutIn
	ActorSlots = new sslActorAlias[5]
	GoToState("Making")
	RegisterForSingleUpdate(timeoutIn)
	return self
endFunction

state Making
	event OnUpdate()
		if !active
			_Log("Thread has timed out of the making process; resetting model for selection pool", "Make", "FATAL")
		endIf
	endEvent

	sslThreadController function StartThread()
		if !Locked("StartThread")
			return none
		elseif ActorCount == 0
			_Log("No valid actors available for animation", "StartThread", "FATAL")
			return none
		endIf

		int i
		int actors = ActorCount

		; Check for duplicate actors
		while i < actors
			if Positions.Find(Positions[i]) != Positions.RFind(Positions[i])
				_Log("Duplicate actor found in list", "StartThread", "FATAL")
				return none
			endIf
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
		i = 0
		while i < primaryAnimations.Length
			if actors != primaryAnimations[i].PositionCount
				_Log("Primary animation '"+primaryAnimations[i].Name+"' requires "+primaryAnimations[i].PositionCount+" actors, only "+actors+" present", "StartThread", "FATAL")
				return none
			endIf
			i += 1
		endWhile

		; Validate Leadin Animations
		i = 0
		while i < leadAnimations.Length
			if actors != leadAnimations[i].PositionCount
				_Log("Lead in animation '"+leadAnimations[i].Name+"' requires "+leadAnimations[i].PositionCount+" actors, only "+actors+" present", "StartThread", "FATAL")
				return none
			endIf
			i += 1
		endWhile

		; Check for center
		if centerObj == none && bed != -1
			ObjectReference BedRef
			; Select a bed
			if PlayerRef != none
				BedRef = Game.FindClosestReferenceOfAnyTypeInListFromRef(Lib.BedsList, PlayerRef, 600.0)
			else
				BedRef = Game.FindClosestReferenceOfAnyTypeInListFromRef(Lib.BedsList, Positions[0], 600.0)
			endIf
			; A bed was selected, should we use it?
			if BedRef != none && !BedRef.IsFurnitureInUse(true)
				int useBed = 0
				if bed == 2 || Lib.sNPCBed == "$SSL_Always"
					useBed = 1
				elseIf PlayerRef != none && !IsVictim(PlayerRef) 
					useBed = Lib.mUseBed.Show()
				elseIf Lib.sNPCBed == "$SSL_Sometimes"
					useBed = utility.RandomInt(0, 1)
				endIf
				if useBed == 1
					CenterOnObject(BedRef)
				endIf
			endIf
		endIf

		; Find a marker near one of our actors and center there
		if centerObj == none 
			i = actors
			while i < actors
				i -= 1
				ObjectReference marker = Game.FindRandomReferenceOfTypeFromRef(Lib.LocationMarker, Positions[i], 750.0) as ObjectReference
				if marker != none
					CenterOnObject(marker)
					i = 0
				endIf
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
		if Controller != none
			active = true
			return Controller
		endIf
		return none
	endFunction
endState


sslThreadController function StartThread()
	Debug.Trace("Cannot start thread while not in a Making state")
	return none
endFunction

;/-----------------------------------------------\;
;|	Setting Functions                            |;
;\-----------------------------------------------/;

function SetHook(string hookName)
	if !Locked("SetHook")
		return
	endIf
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
	if !Locked("CenterOnObject") || centerOn == none
		return none
	endIf
	
	centerObj = centerOn
	if Lib.BedsList.HasForm(centerOn.GetBaseObject())
		bed = 1
		centerLoc = GetCoords(centerOn)
		centerLoc[0] = centerLoc[0] + (35 * Math.sin(centerLoc[5]))
		centerLoc[1] = centerLoc[1] + (35 * Math.cos(centerLoc[5]))
		centerLoc[2] = centerLoc[2] + 35
	elseif centerOn == Lib.PlayerRef || centerOn.HasKeyWordString("ActorTypeNPC")
		ObjectReference Stager = centerOn.PlaceAtMe(Lib.SexLabStager)
		if centerOn.GetDistance(Stager) < 600
			centerLoc = GetCoords(Stager)
		else
			centerLoc = GetCoords(centerOn)
		endIf
		Stager.Disable()
		Stager.Delete()
	else
		centerLoc = GetCoords(centerOn)
	endIf

	if active && resync
		SyncActors()
		SendThreadEvent("ActorsRelocated")
	endIf
endFunction

function CenterOnCoords(float LocX = 0.0, float LocY = 0.0, float LocZ = 0.0, float RotX = 0.0, float RotY = 0.0, float RotZ = 0.0, bool resync = true)
	if !Locked("CenterOnCoords")
		return none
	endIf
	centerLoc = new float[6]
	centerLoc[0] = LocX
	centerLoc[1] = LocY
	centerLoc[2] = LocZ
	centerLoc[3] = RotX
	centerLoc[4] = RotY
	centerLoc[5] = RotZ
	if active && resync
		SyncActors()
		SendThreadEvent("ActorsRelocated")
	endIf
endFunction

function AdjustRotation(float adjust)
	if !Locked("AdjustRotation")
		return none
	endIf
	centerLoc[5] = centerLoc[5] + adjust
	if centerLoc[5] >= 360
		centerLoc[5] = ( centerLoc[5] - 360 )
	elseIf centerLoc[5] < 0
		centerLoc[5] = ( centerLoc[5] + 360 )
	endIf
endFunction

function SetBedding(int set = 0)
	if !Locked("SetBedding")
		return
	endIf
	bed = set
endFunction

function SetTimers(float[] timers)
	if !Locked("SetTimers")
		return
	elseif timers.Length < 1
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

int function AddActor(actor position, bool isVictim = false, sslBaseVoice voice = none, bool forceSilent = false)
	if !Locked("AddActor")
		return -1
	elseIf ActorCount >= 5
		_Log("No available actor positions", "AddActor")
		return -1
	elseif Positions.Find(position) != -1
		_Log("Duplicate actor", "AddActor")
		return -1
	endIf

	int id = -1
	sslActorAlias slot = Lib.Actors.Slots.SlotActor(position, self as sslThreadController)
	if slot == none
		_Log("Failed to slot actor '"+position+"'", "AddActor", "FATAL")
		return -1
	elseif slot.IsCreature()
		Race PosCreature = position.GetLeveledActorBase().GetRace()
		if Creature != none && !Lib.Actors.AnimLib.AllowedCreatureCombination(PosCreature, Creature)
			_Log("Invalid creature race combination '"+Creature.GetName()+"' & '"+PosCreature.GetName()+"'", "AddActor", "FATAL")
			return -1
		endIf
		Creature = PosCreature
	else
		; Check for player
		if position == Lib.PlayerRef
			PlayerRef = position
		endIf
		; Pick voice for non creatures
		if voice == none && !forceSilent
			voice = Lib.Voices.PickVoice(position)
		endIf
		slot.SetVoice(voice)
	endIf
	; Push actor to positions array
	Positions = sslUtility.PushActor(position, Positions)
	id = ActorCount - 1
	; Save Actor/Alias slot
	ActorSlots[id] = slot
	; Set as victim
	if isVictim
		victim = position
	endIf

	return id
endFunction

function ChangeActors(actor[] changeTo)
	if !active || HasCreature
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
			clearing.StopAnimating(true)
			clearing.UnlockActor()
			clearing.ResetActor()
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
			adding.LockActor()
			adding.PrepareActor()
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
	if !Locked("SetActor")
		return
	elseif strip.Length != 33
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
	return position == PlayerRef
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
	if !active
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
	if !active
		return
	endIf
	int position
	while position < ActorCount
		ActorAlias[position].RegisterForModEvent(eventName, "On"+eventName)
		position += 1
	endWhile
	SendModEvent(eventName, (position as string), argNum)
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

bool function Locked(string method)
	if GetState() == "Unlocked"
		_Log("Unsafe attempt to modify unlocked thread["+tid+"]", method, "FATAL")
		return false
	endIf
	return true
endFunction

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
	GotoState("Unlocked")
endFunction

function Initialize()
	; Set states
	active = false
	; Empty Strings
	hook = ""
	Logging = "trace"
	; Empty actors
	actor[] acDel
	Positions = acDel
	victim = none
	; Empty alias slots
	int i = 0
	while i < ActorSlots.Length
		if ActorSlots[i] != none && ActorSlots[i].GetState() != ""
			ActorSlots[i].ClearAlias()
		endIf
		i += 1
	endWhile
	sslActorAlias[] aaDel
	ActorSlots = aaDel
	; Empty Floats
	float[] fDel
	centerLoc = fDel
	customtimers = fDel
	timeout = 0
	; Empty bools
	leadIn = false
	leadInDisabled = false
	AutoAdvance = false
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