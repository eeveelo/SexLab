scriptname sslThreadModel extends Quest
{Animation Thread Model: Runs storage and information about a thread}

SexLabFramework property SexLab auto

int property tid hidden
	int function get()
		return _ThreadID()
	endFunction
endProperty

bool waiting = false
bool locked = false
bool active = false

bool property IsLocked hidden
	bool function get()
		return locked
	endFunction
endProperty

string logtype = "trace"
string property Logging hidden
	string function get()
		return logtype
	endFunction
	function set(string value)
		logtype = value
	endFunction
endProperty

int property ActorCount hidden
	int function get()
		return Positions.Length
	endFunction
endProperty

;/-----------------------------------------------\;
;|	Preparation Functions                        |;
;\-----------------------------------------------/;

float timeout
bool making

sslThreadModel function Make(float timeoutIn = 5.0)
	if locked || !SexLab.Enabled
		return none
	endIf
	InitializeThread()
	locked = true
	making = true
	timeout = timeoutIn
	voices = new sslBaseVoice[5]
	storageslots = new actor[5]
	GoToState("Making")
	RegisterForSingleUpdate(0.01)
	return self
endFunction

state Making
	event OnUpdate()
		if !making
			return
		endIf
		making = false
		; Make timer
		float expire = Utility.GetCurrentRealTime() + timeout
		while expire > Utility.GetCurrentRealTime()
			if active || !locked
				return
			endIf
		  Utility.wait(0.5)
		endwhile
		; Check if need to reset
		if !active
			_Log("ThreadController["+tid+"] has timed out; resetting model for selection pool", "Make", "NOTICE")
			GoToState("Idle")
			return
		endIf
	endEvent
endState

sslThreadController function StartThread()
	if !_MakeWait("StartThread")
		return none
	elseif ActorCount == 0
		_Log("No valid actors available for animation", "StartThread", "FATAL")
		return none
	endIf

	int actors = ActorCount

	int i = 0
	; Check for duplicate actors
	while i < actors
		if Positions.Find(Positions[i]) != Positions.RFind(Positions[i])
			_Log("Duplicate actor found in list", "StartThread", "FATAL")
			return none
		endIf
		i += 1
	endWhile

	; Check for valid animations
	if primaryAnimations.Length == 0
		int[] gender = SexLab.GenderCount(Positions)
		; Same sex pairings
		if (gender[1] == 2 && gender[0] == 0) || (gender[0] == 2 && gender[1] == 0)
			sslBaseAnimation[] samesex = SexLab.GetAnimationsByType(actors, gender[0], gender[1], aggressive = IsAggressive)
			sslBaseAnimation[] couples = SexLab.GetAnimationsByType(actors, 1, 1, aggressive = IsAggressive)
			primaryAnimations = SexLab.MergeAnimationLists(samesex, couples)
		elseif actors < 3
			; Grab animations like normal
			primaryAnimations = SexLab.GetAnimationsByType(actors, gender[0], gender[1], aggressive = IsAggressive)
		elseif actors >= 3
			; Get 3P + animations ignoring gender
			primaryAnimations = SexLab.GetAnimationsByType(actors, aggressive = IsAggressive)
		endIf
		; Check for valid animations again
		if primaryAnimations.Length == 0
			_Log("Unable to find valid animations", "StartThread", "FATAL")
			return none
		endIf
	endIf

	i = 0
	while i < primaryAnimations.Length
		if actors != primaryAnimations[i].ActorCount()
			_Log("Primary animation '"+primaryAnimations[i].name+"' requires "+primaryAnimations[i].ActorCount()+" actors, only "+actors+" present", "StartThread", "FATAL")
			return none
		endIf
		i += 1
	endWhile

	i = 0
	while i < leadAnimations.Length
		if actors != leadAnimations[i].ActorCount()
			_Log("Lead in animation '"+leadAnimations[i].name+"' requires "+leadAnimations[i].ActorCount()+" actors, only "+actors+" present", "StartThread", "FATAL")
			return none
		endIf
		i += 1
	endWhile

	; Determine if foreplay lead in should be used
	if leadAnimations.Length == 0 && !IsAggressive && ActorCount > 1 && SexLab.Config.bForeplayStage
		SetLeadAnimations(SexLab.GetAnimationsByTag(ActorCount, "LeadIn"))
	endIf

	; Check for center
	if CenterRef == none && bed != -1
		ObjectReference BedRef
		; Select a bed
		if PlayerRef != none
			BedRef = Game.FindClosestReferenceOfAnyTypeInListFromRef(SexLab.Data.BedsList, PlayerRef, 500.0)
		else
			BedRef = Game.FindClosestReferenceOfAnyTypeInListFromRef(SexLab.Data.BedsList, Positions[0], 500.0)
		endIf
		; A bed was selected, should we use it?
		if BedRef != none
			int useBed = 0
			if bed == 2 || SexLab.Config.sNPCBed == "$SSL_Always"
				useBed = 1
			elseIf PlayerRef != none && !IsVictim(PlayerRef) 
				useBed = SexLab.Data.mUseBed.Show()
			elseIf SexLab.Config.sNPCBed == "$SSL_Sometimes"
				useBed = utility.RandomInt(0,1)
			endIf
			if useBed == 1
				CenterOnObject(BedRef)
			endIf
		endIf
	endIf

	; Find a marker near one of our actors and center there
	if CenterRef == none 
		i = 0
		while i < ActorCount
			ObjectReference marker = Game.FindRandomReferenceOfTypeFromRef(SexLab.Data.LocationMarker, Positions[i], 750.0) as ObjectReference
			if marker != none
				CenterOnObject(marker)
				i = ActorCount
			endIf
			i += 1
		endWhile
	endIf

	; Still no center, fallback to something
	if CenterRef == none || centerLoc == none
		; Fallback to victim
		if victim != none
			CenterOnObject(victim)
		; Fallback to player
		elseif PlayerRef != none
			CenterOnObject(GetPlayer())
		; Fallback to first position actor
		else
			CenterOnObject(Positions[0])
		endIf
	endIf

	; Enable auto advance
	if PlayerRef != none
		if IsVictim(PlayerRef) && SexLab.Config.bDisablePlayer
			autoAdvance = true
		else
			autoAdvance = SexLab.Config.bAutoAdvance
		endIf
	else
		autoAdvance = true
	endIf

	; Start the controller
	sslThreadController controller = PrimeThread()
	if controller != none	
		active = true
		return controller
	endIf
	return none
endFunction

;/-----------------------------------------------\;
;|	Setting Functions                            |;
;\-----------------------------------------------/;

string hook
int property stage auto hidden
ObjectReference CenterRef
float[] centerLoc
float[] property CenterLocation hidden
	float[] function get()
		return centerLoc
	endFunction
endProperty

bool property IsAggressive hidden
	bool function get()
		return victim != none
	endFunction
endProperty

float[] customtimers
float[] property Timers hidden
	float[] function get()
		if customtimers.Length > 0
			return customtimers
		elseif leadIn
			return SexLab.Config.fStageTimerLeadIn
		elseif IsAggressive
			return SexLab.Config.fStageTimerAggr
		else
			return SexLab.Config.fStageTimer
		endIf
	endFunction
endProperty

int bed ; 0 allow, 1 in use, 2 force, -1 forbid

function SetHook(string hookName)
	if !_MakeWait("SetHook")
		return
	endIf
	hook = hookName
endFunction

float[] function GetCoords(ObjectReference Object)
	float[] loc = new float[6]
	loc[0] = CenterRef.GetPositionX()
	loc[1] = CenterRef.GetPositionY()
	loc[2] = CenterRef.GetPositionZ()
	loc[3] = CenterRef.GetAngleX()
	loc[4] = CenterRef.GetAngleY()
	loc[5] = CenterRef.GetAngleZ()
	return loc
endFunction

function CenterOnObject(ObjectReference centerOn, bool resync = true)
	if !_MakeWait("CenterOnObject")
		return none
	elseIf centerOn == none
		return none
	endIf
	CenterRef = centerOn
	centerLoc = GetCoords(centerOn)
	if SexLab.Data.BedsList.HasForm(CenterRef.GetBaseObject())
		bed = 1
		centerLoc[0] = centerLoc[0] + (35 * Math.sin(centerLoc[5]))
		centerLoc[1] = centerLoc[1] + (35 * Math.cos(centerLoc[5]))
		centerLoc[2] = centerLoc[2] + 35
	endIf
	if active && resync
		RealignActors()
		SendThreadEvent("ActorsRelocated")
	endIf
endFunction

function CenterOnCoords(float LocX = 0.0, float LocY = 0.0, float LocZ = 0.0, float RotX = 0.0, float RotY = 0.0, float RotZ = 0.0, bool resync = true)
	float[] coords = new float[6]
	coords[0] = LocX
	coords[1] = LocY
	coords[2] = LocZ
	coords[3] = RotX
	coords[4] = RotY
	coords[5] = RotZ
	if active && resync
		RealignActors()
		SendThreadEvent("ActorsRelocated")
	endIf
endFunction

function UpdateRotation(float adjust)
	centerLoc[5] = centerLoc[5] + adjust
	if centerLoc[5] >= 360
		centerLoc[5] = ( centerLoc[5] - 360 )
	elseIf centerLoc[5] < 0
		centerLoc[5] = ( centerLoc[5] + 360 )
	endIf
endFunction

function SetBedding(int set = 0)
	if !_MakeWait("SetBedding")
		return
	endIf
	bed = set
endFunction

function SetTimers(float[] timers)
	if !_MakeWait("SetTimers")
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

actor[] property Positions auto hidden 
actor[] storageslots
actor PlayerRef

actor victim
sslBaseVoice[] voices

bool[] strip0
bool[] strip1
bool[] strip2
bool[] strip3
bool[] strip4

form[] equipment0
form[] equipment1
form[] equipment2
form[] equipment3
form[] equipment4

int function AddActor(actor position, bool isVictim = false, sslBaseVoice voice = none, bool forceSilent = false)
	if !_MakeWait("AddActor")
		return -1
	elseIf ActorCount >= 5
		_Log("No available actor positions", "AddActor")
		return -1
	elseIf SexLab.ValidateActor(position) < 1
		_Log("Actor has failed validation", "AddActor", "FATAL")
		return -1
	elseIf SexLab.FindActorController(position) != -1
		_Log("Actor already claimed by a pending thread", "AddActor", "FATAL")
		return -1
	endIf
	waiting = true
	; Set as victim
	if isVictim
		victim = position
	endIf
	; Push actor to positions array
	Positions = sslUtility.PushActor(position, Positions)
	int id = ActorCount - 1
	; Save static storage slot
	storageslots[id] = position
	; Check for player
	if position == SexLab.PlayerRef
		PlayerRef = position
	endIf
	; Find voice or use given voice
	if voice == none && !forceSilent
		voice = SexLab.PickVoice(position)
	endIf
	voices[id] = voice
	; Return position index
	waiting = false
	return id
endFunction

function ChangeActors(actor[] changeTo)
	if !active
		return
	endIf
	; Make sure all new actors are vaild.
	int i = 0
	while i < changeTo.Length
		if Positions.Find(changeTo[i]) < 0 && SexLab.ValidateActor(changeTo[i]) < 0
			return 
		endIf
		i += 1
	endWhile
	; Actor count has changed, get new default animation list
	if changeTo.Length != ActorCount
		sslBaseAnimation[] newList
		; Try aggressive animations first if we need them
		if victim != none
			newList = SexLab.GetAnimationsByType(changeTo.Length, aggressive=true)
		endIf
		; Runs if no victim or victim search didn't find any
		if newList.Length == 0
			newList = SexLab.GetAnimationsByType(changeTo.Length)
		endIf
		; Still none? We have no animations for this count, bail
		if newList.Length == 0
			return	
		endIf
		; Set our new list
		SetAnimations(newList)
		SetAnimation()
	endIf
	SendThreadEvent("ActorChangeStart")
	i = 0
	while i < ActorCount
		actor a = Positions[i]
		ResetActor(a)
		if !a.IsDead() && !a.IsBleedingOut()
			SexLab.UnstripActor(a, GetEquipment(a), GetVictim())
		endIf
		if changeTo.Find(a) < 0
			if IsPlayerActor(a)
				autoAdvance = true
			endIf
		endIf
		i += 1
	endWhile
	Positions = changeTo
	storageslots = changeTo
	form[] foDel
	equipment0 = foDel
	equipment1 = foDel
	equipment2 = foDel
	equipment3 = foDel
	equipment4 = foDel
	i = 0
	while i < ActorCount
		SetupActor(Positions[i])
		i += 1
	endWhile
	stage -= 1
	AdvanceStage()
	SendThreadEvent("ActorChangeEnd")
endFunction

;/-----------------------------------------------\;
;|	Animation Functions                          |;
;\-----------------------------------------------/;

bool property autoAdvance auto hidden
bool property leadIn auto hidden

sslBaseAnimation[] primaryAnimations
sslBaseAnimation[] leadAnimations
sslBaseAnimation[] property animations hidden
	sslBaseAnimation[] function get()
		if leadIn
			return leadAnimations
		else
			return primaryAnimations
		endIf
	endFunction
endProperty

function SetAnimations(sslBaseAnimation[] animationList)
	if !_MakeWait("SetAnimations") || animationList.Length == 0
		return
	endIf
	primaryAnimations = animationList
endFunction

function SetLeadAnimations(sslBaseAnimation[] animationList)
	if !_MakeWait("SetLeadAnimations") || animationList.Length == 0
		return
	endIf
	leadIn = true
	leadAnimations = animationList	
endFunction

;/-----------------------------------------------\;
;|	Storage Functions                            |;
;\-----------------------------------------------/;

int function GetSlot(actor position)
	return storageslots.Find(position)
endFunction

int function GetPosition(actor position)
	return Positions.Find(position)
endFunction

function SetStrip(actor position, bool[] strip)
	if !_MakeWait("SetActor")
		return
	elseif strip.Length != 33
		_Log("Malformed strip bool[] passed, must be 33 length bool array, "+strip.Length+" given", "SetStrip")
		return
	endIf
	int slot = GetSlot(position)
	if slot == 0
		strip0 = strip
	elseIf slot == 1
		strip1 = strip
	elseIf slot == 2
		strip2 = strip
	elseIf slot == 3
		strip3 = strip
	elseIf slot == 4
		strip4 = strip
	else
		_Log("Unknown position given, '"+position+"' ", "SetStrip")
	endIf
endFunction

bool[] function GetStrip(actor position)
	bool[] strip
	int slot = GetSlot(position)
	; Check for custom
	if slot == 0
		strip = strip0
	elseIf slot == 1
		strip = strip1
	elseIf slot == 2
		strip = strip2
	elseIf slot == 3
		strip = strip3
	elseIf slot == 4
		strip = strip4
	endIf
	; Return customized strip options
	if strip.Length == 33
		return strip
	endIf
	; Fallback to default
	int gender = position.GetLeveledActorBase().GetSex()
	if leadIn && gender < 1
		strip = SexLab.Config.bStripLeadInMale
	elseif leadIn && gender > 0
		strip = SexLab.Config.bStripLeadInFemale
	elseif IsAggressive && position == victim
		strip = SexLab.Config.bStripVictim
	elseif IsAggressive && position != victim
		strip = SexLab.Config.bStripAggressor
	elseif !IsAggressive && gender < 1
		strip = SexLab.Config.bStripMale
	else
		strip = SexLab.Config.bstripFemale
	endIf
	return strip
endFunction

function StoreEquipment(actor position, form[] equipment)
	; Check for current equipment
	form[] current = GetEquipment(position)
	; Merge with current storage
	int i
	while i < current.Length
		equipment = sslUtility.PushForm(current[i], equipment)
		i += 1
	endWhile
	; Put in storage
	int slot = GetSlot(position)
	if slot == 0
		equipment0 = equipment
	elseIf slot == 1
		equipment1 = equipment
	elseIf slot == 2
		equipment2 = equipment
	elseIf slot == 3
		equipment3 = equipment
	elseIf slot == 4
		equipment4 = equipment
	endIf
endFunction

form[] function GetEquipment(actor position)
	int slot = GetSlot(position)
	if slot == 0
		return equipment0
	elseIf slot == 1
		return equipment1
	elseIf slot == 2
		return equipment2
	elseIf slot == 3
		return equipment3
	elseIf slot == 4
		return equipment4
	endIf
endFunction

sslBaseVoice function GetVoice(actor position)
	return voices[GetSlot(position)]
endFunction


bool function HasPlayer()
	return PlayerRef != none
endFunction

actor function GetPlayer()
	return PlayerRef
endFunction

int function GetPlayerPosition()
	return Positions.Find(SexLab.PlayerRef)
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

bool function _MakeWait(string method)
	; Ready wait
	while waiting && locked
		debug.trace("MakeWait on "+method+"()")
		Utility.Wait(0.1)
	endWhile
	; Not spooled, bail.
	if !locked
		_Log("Unsafe attempt to modify unlocked thread "+self, method, "FATAL")
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

	if logType == "notification"
		Debug.Notification(type+": "+log)
	elseif logType == "messagebox"
		Debug.MessageBox(method+"() "+type+": "+log)
	elseif logType == "trace-minimal"
		Debug.Trace("SexLab "+method+"() "+type+": "+log, severity)
	else
		Debug.Trace("--------------------------------------------------------------------------------------------", severity)
		Debug.Trace("--- SexLab ThreadController["+tid+"] --------------------------------------------------------------", severity)
		Debug.Trace("--------------------------------------------------------------------------------------------", severity)
		Debug.Trace(" "+type+": "+method+"()" )
		Debug.Trace("   "+log)
		Debug.Trace("--------------------------------------------------------------------------------------------", severity)
	endIf
	if type == "FATAL"
		UnlockThread()
	endIf
endFunction

function SendThreadEvent(string eventName)
	; Send Custom Event
	if hook != ""
		string customEvent = eventName+"_"+hook
		Debug.Trace("SexLab ThreadController["+tid+"]: Sending custom event hook '"+customEvent+"'")
		SexLab.SendModEvent(customEvent, (tid as string), 1)
	endIf
	; Send Global Event
	SexLab.SendModEvent(eventName, (tid as string), 1)
endFunction

int function PositionClamp(int value)
	if value < 0
		return 0
	elseif value > (ActorCount - 1)
		return (ActorCount - 1)
	endIf
	return value
endFunction

;/-----------------------------------------------\;
;|	Ending Functions                             |;
;\-----------------------------------------------/;

auto state Idle
	event OnBeginState()
		InitializeThread()
		locked = false
	endEvent
endState

function UnlockThread()
	InitializeThread()
	GoToState("Idle")
endFunction

function InitializeThread()
	; Set states
	waiting = false
	active = false
	making = false
	; Empty Strings
	hook = ""
	logtype = "trace"
	; Empty actors
	actor[] acDel
	Positions = acDel
	storageslots = acDel
	victim = none
	; Empty Floats
	float[] fDel
	centerLoc = fDel
	customtimers = fDel
	timeout = 0
	; Empty bools
	bool[] bDel
	strip0 = bDel
	strip1 = bDel
	strip2 = bDel
	strip3 = bDel
	strip4 = bDel
	leadIn = false
	autoAdvance = false
	; Empty forms
	form[] foDel
	equipment0 = foDel
	equipment1 = foDel
	equipment2 = foDel
	equipment3 = foDel
	equipment4 = foDel
	; Empty integers
	bed = 0
	stage = 0
	; Empty voice slots
	sslBaseVoice[] voDel
	voices = voDel
	; Empty animations
	sslBaseAnimation[] anDel
	primaryAnimations = anDel
	leadAnimations = anDel
	; Clear Forms
	CenterRef = none
	PlayerRef = none
endFunction

;/-----------------------------------------------\;
;|	Child Functions                              |;
;\-----------------------------------------------/;
int function _ThreadID()
	return -1
endFunction
sslThreadController function PrimeThread()
	return none
endFunction
function EquipExtras(actor position)
endFunction
function RemoveExtras(actor position)
endFunction
function RealignActors()
endFunction
function ResetActor(actor position)
endFunction
function SetupActor(actor position)
endFunction
function AdvanceStage(bool backwards = false)
endFunction
function SetAnimation(int aid = -1)
endFunction