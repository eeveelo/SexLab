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
ObjectReference bedObj
float[] centerLoc
float[] customtimers
int[] gendercounts
bool leadInDisabled
actor PlayerRef
actor victim
string[] hooks
int bedding ; 0 allow, 1 force, -1 forbid
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
		return BedObj != none
	endFunction
endProperty

ObjectReference property BedRef hidden
	ObjectReference function get()
		return BedObj
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
		if customtimers.Length != 0
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

actor property VictimRef hidden
	actor function get()
		return victim
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

int[] property Genders hidden
	int[] function get()
		return gendercounts
	endFunction
endProperty

int property Males hidden
	int function get()
		return gendercounts[0]
	endFunction
endProperty

int property Females hidden
	int function get()
		return gendercounts[1]
	endFunction
endProperty

int property Creatures hidden
	int function get()
		return gendercounts[2]
	endFunction
endProperty

;/-----------------------------------------------\;
;|	Preparation Functions                        |;
;\-----------------------------------------------/;

sslActorAlias function SlotActor(actor position)
	int i
	; Fill first available slot
	while i < 5 && !ActorSlots[i].ForceRefIfEmpty(position)
		i += 1
	endWhile
	; Return used alias
	if i < 5 && (ActorSlots[i].GetReference() as actor) == position
		return ActorSlots[i]
	endIf
	return none
endFunction

state Making
	event OnBeginState()
		SendThreadEvent("ThreadOpened")
	endEvent
	event OnUpdate()
		if !Active
			SendThreadEvent("ThreadExpired")
			_Log("Thread has timed out of the making process; resetting model for selection pool", "Make", "FATAL")
		endIf
	endEvent

	int function AddActor(actor position, bool isVictim = false, sslBaseVoice voice = none, bool forceSilent = false)
		; Validate actor being added
		if ActorCount >= 5
			_Log("Failed to add actor' "+position.GetLeveledActorBase().GetName()+"' -- thread has reached actor limit", "AddActor", "FATAL")
			return -1
		elseIf Lib.ActorLib.ValidateActor(position) != 1
			_Log("Failed to add actor' "+position.GetLeveledActorBase().GetName()+"' -- failed validation check", "AddActor", "FATAL")
			return -1
		endIf
		; Attempt to claim a slot
		sslActorAlias Slot = SlotActor(position)
		if Slot == none || !Slot.SetAlias(position, self as sslThreadController)
			_Log("Failed to add actor' "+position.GetLeveledActorBase().GetName()+"' -- they were unable to fill an actor slot", "AddActor", "FATAL")
			return -1
		endIf
		Positions = sslUtility.PushActor(position, Positions)
		; Check creature race combination
		if Slot.IsCreature()
			if Creature != none && !Lib.AnimLib.AllowedCreatureCombination(Slot.ActorRace, Creature)
				Slot.ClearAlias()
				_Log("Invalid creature race combination '"+Creature.GetName()+"' & '"+Slot.ActorRace.GetName()+"'", "AddActor", "FATAL")
				return -1
			endIf
			Creature = Slot.ActorRace
		; Non-Creature prep
		else
			Slot.SetVoice(voice, forceSilent)
			if position == Lib.PlayerRef
				SendThreadEvent("PlayerAdded")
				PlayerRef = position
			endIf
		endIf
		; Set as victim
		if isVictim
			Slot.MakeVictim(true)
			victim = position
		endIf
		; Return position index
		return Positions.Find(position)
	endFunction

	sslThreadController function StartThread()
		if ActorCount == 0
			_Log("No valid actors available for animation", "StartThread", "FATAL")
			return none
		endIf

		Active = true

		int actors = ActorCount
		int i

		; Check for duplicate actors
		while i < actors
			if Positions.Find(Positions[i]) != Positions.RFind(Positions[i])
				_Log("Duplicate actor found in list", "StartThread", "FATAL")
				return none
			endIf
			i += 1
		endWhile

		; Check for valid creature animations
		if HasCreature
			primaryAnimations = Lib.CreatureAnimations.GetByRace(actors, Creature)
			; Bail if no valid creature animations
			if primaryAnimations.Length == 0
				_Log("Unable to find valid creature animations", "StartThread", "FATAL")
				return none
			endIf
			Positions = Lib.SortCreatures(Positions, primaryAnimations[0])
			CenterOnObject(Positions[0])
			DisableLeadIn(true)
		endIf

		; Remember present genders
		gendercounts = Lib.ActorLib.GenderCount(Positions)

		; Search for nearby bed
		if centerObj == none && bedding != -1
			if PlayerRef != none
				LocateBed(true, 750.0)
			else
				LocateBed(false, 1000.0)
			endIf
		endIf

		; Find a marker near one of our actors and center there
		if centerObj == none
			i = 0
			while i < actors
				ObjectReference marker = Game.FindClosestReferenceOfTypeFromRef(Lib.LocationMarker, Positions[i], 750.0)
				if marker != none
					CenterOnObject(marker)
					i = 5
				endIf
				i += 1
			endWhile
		endIf

		; Still no center, fallback to something
		if centerObj == none
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

		if primaryAnimations.Length == 0
			; Get default animation selection
			primaryAnimations = Lib.Animations.GetByDefault(Males, Females, IsAggressive, IsUsingBed)
			; Check for valid animations again
			if primaryAnimations.Length == 0
				_Log("Unable to find valid animations", "StartThread", "FATAL")
				return none
			endIf
		endIf

		; Determine if foreplay lead in should be used
		if !HasCreature && !IsAggressive && actors == 2 && Lib.bForeplayStage && !leadInDisabled && leadAnimations.Length == 0
			if IsUsingBed
				SetLeadAnimations(Lib.Animations.GetByTags(2, "LeadIn", "Standing"))
			else
				SetLeadAnimations(Lib.Animations.GetByTags(2, "LeadIn"))
			endIf
		endIf

		; Validate Primary animations
		i = primaryAnimations.Length
		while i
			i -= 1
			if !primaryAnimations[i].Registered || actors != primaryAnimations[i].PositionCount
				_Log("Primary animation '"+primaryAnimations[i].Name+"' requires "+primaryAnimations[i].PositionCount+" actors, only "+actors+" present", "StartThread", "FATAL")
				return none
			endIf
		endWhile

		; Validate Leadin Animations
		if !leadInDisabled && leadAnimations.Length > 0
			i = leadAnimations.Length
			while i
				i -= 1
				if !leadAnimations[i].Registered || actors != leadAnimations[i].PositionCount
					_Log("Lead in animation '"+leadAnimations[i].Name+"' requires "+leadAnimations[i].PositionCount+" actors, only "+actors+" present", "StartThread", "FATAL")
					return none
				endIf
			endWhile
		endIf

		; Enable auto advance
		if PlayerRef != none
			if IsVictim(PlayerRef) && Lib.ActorLib.bDisablePlayer
				AutoAdvance = true
			else
				AutoAdvance = Lib.bAutoAdvance
			endIf
		else
			AutoAdvance = true
		endIf

		; Start the controller
		sslThreadController Controller = PrimeThread()
		started = Utility.GetCurrentRealTime()
		if Controller == none
			_Log("Failed to start, controller is null", "StartThread", "FATAL")
			return none
		endIf
		return Controller
	endFunction
endState

;/-----------------------------------------------\;
;|	Setting Functions                            |;
;\-----------------------------------------------/;

function SetHook(string hookName)
	string[] newhooks = sslUtility.ArgString(hookName)
	int i = newhooks.Length
	while i
		i -= 1
		if newhooks[i] != ""
			AddTag(newhooks[i])
			if hooks.Find(newhooks[i]) == -1
				hooks = sslUtility.PushString(newhooks[i], hooks)
			endIf
		endIf
	endWhile
endFunction

bool function RemoveHook(string hookName)
	if hooks.Find(hookName) == -1
		return false
	endIf
	string[] newhooks
	int i = hooks.Length
	while i
		i -= 1
		if hooks[i] != hookName
			newhooks = sslUtility.PushString(hooks[i], newhooks)
		endIf
	endWhile
	hooks = newhooks
	return true
endFunction

string function GetHook()
	return hooks[0]
endFunction

string[] function GetHooks()
	return hooks
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
		bedObj = centerOn
		centerLoc[0] = centerLoc[0] + (33.0 * Math.sin(centerLoc[5]))
		centerLoc[1] = centerLoc[1] + (33.0 * Math.cos(centerLoc[5]))
		if !Lib.BedRollsList.HasForm(centerOn.GetBaseObject())
			centerLoc[2] = centerLoc[2] + 37.0
		endIf
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
	bedding = set
endFunction

function SetTimers(float[] settingTimers)
	if settingTimers.Length < 1
		_Log("Empty timers given.", "SetTimers")
		return
	endIf
	customtimers = settingTimers
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
		if Positions.Find(changeTo[i]) == -1 && !Lib.ActorLib.ValidateActor(changeTo[i])
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
	; Toggle FastEnd to quickly clear out removed actors
	bool togglefast = FastEnd
	FastEnd = true
	; Remove actors no longer present
	i = ActorCount
	while i
		i -= 1
		sslActorAlias CheckAlias = ActorAlias(Positions[i])
		CheckAlias.GoToState("Ready")
		if changeTo.Find(Positions[i]) == -1
			if IsPlayerPosition(i)
				AutoAdvance = true
			endIf
			CheckAlias.GoToState("Reset")
			while CheckAlias.GetState() != ""
				Utility.Wait(0.1)
			endWhile
			CheckAlias.ClearAlias()
		endIf
	endWhile
	; Return FastEnd to it's original bool
	FastEnd = togglefast
	; Update positions
	Positions = changeTo
	; Prepare/Reset actors as needed
	i = changeTo.Length
	while i
		i -= 1
		; New actor, slot and prepare them
		if GetSlot(changeTo[i]) == -1
			actor AddRef = changeTo[i]
			sslActorAlias Slot = SlotActor(AddRef)
			if Slot == none || !Slot.SetAlias(AddRef, self as sslThreadController)
				_Log("Failed to add actor' "+AddRef.GetLeveledActorBase().GetName()+"' -- they were unable to fill an actor slot", "ChangeActors", "FATAL")
				return
			endIf
			Slot.SetVoice(Lib.VoiceLib.PickVoice(AddRef))
			Slot.DisableUndressAnim(true)
			; Start preparing actor
			Slot.GotoState("Prepare")
			; Wait for ready state
			float failsafe = 25.0
			while Slot.GetState() != "Ready" && failsafe > 0.0
				Utility.Wait(0.10)
				failsafe -= 0.10
			endWhile
		endIf
	endWhile
	; Remember new genders
	gendercounts = Lib.ActorLib.GenderCount(Positions)
	; Start animating new actors
	SyncActors(true)
	(self as sslThreadController).RealignActors()
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
	int i
	while i < 5
		if ActorSlots[i].ActorRef == position
			return i
		endIf
		i += 1
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

int function GetEnjoyment(actor position)
	ActorAlias(position).GetEnjoyment()
endFunction

int function GetPain(actor position)
	ActorAlias(position).GetPain()
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
;|	Tagging Functions                            |;
;\-----------------------------------------------/;

string function Key(string type = "")
	return _ThreadID+"."+type
endFunction

bool function HasTag(string tag)
	return tag != "" && StorageUtil.StringListFind(Lib, Key("Tags"), tag) != -1
endFunction

bool function AddTag(string tag)
	if HasTag(tag)
		return false
	endIf
	StorageUtil.StringListAdd(Lib, Key("Tags"), tag, false)
	return true
endFunction

bool function RemoveTag(string tag)
	if !HasTag(tag)
		return false
	endIf
	StorageUtil.StringListRemove(Lib, Key("Tags"), tag, true)
	return true
endFunction

bool function ToggleTag(string tag)
	return (RemoveTag(tag) || AddTag(tag)) && HasTag(tag)
endFunction

bool function CheckTags(string[] find, bool requireAll = true)
	int i = find.Length
	while i
		i -= 1
		if find[i] != ""
			bool check = HasTag(find[i])
			if requireAll && !check
				return false ; Stop if we need all and don't have it
			elseif !requireAll && check
				return true ; Stop if we don't need all and have one
			endIf
		endIf
	endWhile
	; If still here than we require all and had all
	return true
endFunction

;/-----------------------------------------------\;
;|	System Functions                             |;
;\-----------------------------------------------/;

function SyncActors(bool force = false)
	int i = ActorCount
	while i
		i -= 1
		ActorAlias[i].SyncThread(force)
	endWhile
endFunction

function SendThreadEvent(string eventName, float argNum = 0.0)
	string threadid = (tid as string)
	string events = eventName
	; Send Custom Event
	int i = hooks.Length
	while i
		i -= 1
		SendModEvent(eventName+"_"+hooks[i], threadid, argNum)
		events += " // "+eventName+"_"+hooks[i]
	endWhile
	; Send Global Event
	SendModEvent(eventName, threadid, argNum)
	; Send Player Global Event
	if HasPlayer
		SendModEvent("Player"+eventName, threadid, argNum)
		events += " // Player"+eventName
	endIf
	Debug.Trace("SexLab Thread["+_ThreadID+"] ModEvent: "+events)
endFunction

int function ArrayWrap(int value, int max)
	if value >= max
		return 0
	elseif value < 0
		return max - 1
	endIf
	return value
endFunction

float function SignFloat(float value, bool sign)
	if sign
		return -value
	endIf
	return value
endFunction

int function SignInt(int value, bool sign)
	if sign
		return -value
	endIf
	return value
endFunction

function _Log(string log, string method, string type = "ERROR")
	if Logging == "notification"
		Debug.Notification(type+": "+log)
	elseif Logging == "messagebox"
		Debug.MessageBox(method+"() "+type+": "+log)
	elseif Logging == "trace-minimal"
		Debug.Trace("SexLab "+method+"() "+type+": "+log)
	else
		Debug.Trace("--- SexLab ThreadController["+tid+"] ------------------------------------------------------")
		Debug.Trace(" "+type+": "+method+"()" )
		Debug.Trace("   "+log)
		Debug.Trace("--------------------------------------------------------------------------------------------")
	endIf
	if type == "FATAL"
		Initialize()
		GoToState("Unlocked")
	endIf
endFunction

function ClearActors()
	FastEnd = true
	int i = ActorSlots.Length
	while i
		i -= 1
		if ActorSlots[i] != none && ActorSlots[i].ActorRef != none
			ActorSlots[i].UnlockActor()
			ActorSlots[i].StopAnimating(true)
			ActorSlots[i].GoToState("Reset")
		else
			ActorSlots[i].ClearAlias()
		endIf
	endWhile
	FastEnd = false
endFunction

function Initialize()
	UnregisterForUpdate()
	if GetState() != "Unlocked"
		SendThreadEvent("ThreadClosed")
	endIf
	; Empty alias slots
	ClearActors()
	; Set states
	Active = false
	; Clear tags
	StorageUtil.StringListClear(Lib, Key("Tags"))
	; Empty Strings
	string[] strDel1
	hooks = strDel1
	Logging = "trace"
	; Empty actors
	actor[] acDel
	Positions = acDel
	victim = none
	; Empty Floats
	float[] fDel1
	centerLoc = fDel1
	float[] fDel2
	customtimers = fDel2
	started = 0.0
	; Empty bools
	leadIn = false
	leadInDisabled = false
	AutoAdvance = false
	; Empty forms
	; Empty integers
	int[] iDel
	gendercounts = iDel
	bedding = 0
	stage = 0
	; Empty animations
	sslBaseAnimation[] anDel1
	customAnimations = anDel1
	sslBaseAnimation[] anDel2
	primaryAnimations = anDel2
	sslBaseAnimation[] anDel3
	leadAnimations = anDel3
	; Clear Forms
	centerObj = none
	bedObj = none
	PlayerRef = none
	creature = none
	GotoState("Unlocked")
endFunction

;/-----------------------------------------------\;
;| State Permissible Functions                   |;
;\-----------------------------------------------/;

sslThreadModel function Make(float timeoutIn = 30.0)
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

auto state Unlocked
	function SendThreadEvent(string eventName, float argNum = 0.0)
	endFunction
	sslThreadModel function Make(float timeoutIn = 30.0)
		Initialize()
		GoToState("Making")
		RegisterForSingleUpdate(timeoutIn)
		return self
	endFunction
endState

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
	ActorSlots = Lib.Actors.GetActorSlots(threadid)
	ClearActors()
	GoToState("Unlocked")
endFunction

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
