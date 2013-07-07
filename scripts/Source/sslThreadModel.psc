scriptname sslThreadModel extends Quest

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
		return positionslots.Length
	endFunction
endProperty

;/-----------------------------------------------\;
;|	Preparation Functions                        |;
;\-----------------------------------------------/;

float timeout
bool making

sslThreadModel function Make(float timeoutIn = 25.0)
	if locked
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
		while expire > Utility.GetCurrentRealTime() && locked
			if active
				return
			endIf
		  Utility.wait(0.5)
		endwhile
		; Check if need to reset
		if !active || !locked
			Debug.MessageBox("Thread["+tid+"] Timer Expire")
			_Log("Thread["+tid+"] has timed out; resetting model and reentering selection pool", "Make", "NOTICE")
			GoToState("Idle")
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
		if positionslots.Find(positionslots[i]) != positionslots.RFind(positionslots[i])
			_Log("Duplicate actor found in list", "StartThread", "FATAL")
			return none
		endIf
		i += 1
	endWhile

	; Check for valid animations
	if primaryAnimations.Length == 0
		int[] gender = SexLab.GenderCount(positionslots)
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
		SetLeadAnimations(SexLab.GetAnimationsByTag(ActorCount, "Foreplay"))
	endIf

	; Check for center
	if centerRef == none && bed != -1
		ObjectReference BedRef
		; Select a bed
		if player > 0
			BedRef = Game.FindClosestReferenceOfAnyTypeInListFromRef(SexLab.Data.BedsList, SexLab.PlayerRef, 500.0)
		else
			BedRef = Game.FindClosestReferenceOfAnyTypeInListFromRef(SexLab.Data.BedsList, positionslots[0], 500.0)
		endIf
		; A bed was selected, should we use it?
		if BedRef != none
			int useBed = 0
			if bed == 2 || SexLab.Config.sNPCBed == "$SSL_Always"
				useBed = 1
			elseIf player > 0 && victim != GetPlayer() 
				useBed = SexLab.Data.mUseBed.Show()
			elseIf SexLab.Config.sNPCBed == "$SSL_Sometimes"
				useBed = utility.RandomInt(0,1)
			endIf
			if useBed == 1
				SetCenterReference(BedRef)
			endIf
		endIf
	endIf

	; Find a marker near one of our actors and center there
	if centerRef == none 
		i = 0
		while i < ActorCount
			ObjectReference marker = Game.FindRandomReferenceOfTypeFromRef(SexLab.Data.LocationMarker, positionslots[i], 750.0) as ObjectReference
			if marker != none
				SetCenterReference(marker)
				i = ActorCount
			endIf
			i += 1
		endWhile
	endIf

	; Still no center, fallback to something
	if centerRef == none || centerLoc == none
		; Fallback to victim
		if victim != none
			SetCenterReference(victim)
		; Fallback to player
		elseif player > 0
			SetCenterReference(GetPlayer())
		; Fallback to first position actor
		else
			SetCenterReference(positionslots[0])
		endIf
	endIf

	; Enable auto advance
	autoAdvance = SexLab.Config.bAutoAdvance
	if player > 0 && GetPlayer() == victim && SexLab.Config.bDisablePlayer
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
ObjectReference centerRef
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

float[] function SetCenterReference(ObjectReference centerOn)
	if !_MakeWait("SetCenterReference")
		return none
	endIf
	centerRef = centerOn
	centerLoc = new float[6]
	centerLoc[0] = centerRef.GetPositionX()
	centerLoc[1] = centerRef.GetPositionY()
	centerLoc[2] = centerRef.GetPositionZ()
	centerLoc[3] = centerRef.GetAngleX()
	centerLoc[4] = centerRef.GetAngleY()
	centerLoc[5] = centerRef.GetAngleZ()
	if SexLab.Data.BedsList.HasForm(centerRef.GetBaseObject())
		bed = 1
		centerLoc[0] = centerLoc[0] + (35 * Math.sin(centerLoc[5]))
		centerLoc[1] = centerLoc[1] + (35 * Math.cos(centerLoc[5]))
		centerLoc[2] = centerLoc[2] + 35
	endIf

	return centerLoc
endFunction

float function UpdateRotation(float adjust)
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

actor[] positionslots
actor[] property Positions hidden
	actor[] function get()
		return positionslots
	endFunction
endProperty 
actor[] storageslots

actor victim
sslBaseVoice[] voices
int player

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
		return -1
	elseIf SexLab.FindActorController(position) != -1
		_Log("Actor already claimed by a making thread", "AddActor")
		return -1
	endIf
	waiting = true
	; Set as victim
	if isVictim
		victim = position
	endIf
	; Push actor to positions array
	positionslots = sslUtility.PushActor(position, positionslots)
	int id = ActorCount - 1
	; Save static storage slot
	storageslots[id] = position
	; Check for player
	if position == SexLab.PlayerRef
		player = ActorCount
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

function SwapPositions(actor adjusting, actor moved)
	; Swap Positions
	RemoveExtras(adjusting)
	RemoveExtras(moved)
	; Move in array
	positionslots[GetPosition(adjusting)] = moved
	positionslots[GetPosition(moved)] = adjusting
	; Equip new extras
	EquipExtras(adjusting)
	EquipExtras(moved)
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
	if !_MakeWait("SetAnimations")
		return
	elseIf animationList.Length == 0
		_Log("No animations available in given list", "SetAnimations")
		return
	endIf
	primaryAnimations = animationList
endFunction

function SetLeadAnimations(sslBaseAnimation[] animationList)
	if !_MakeWait("SetLeadAnimations")
		return
	elseIf animationList.Length == 0
		_Log("No animations available in given animation list", "SetLeadAnimations")
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
	return positionslots.Find(position)
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
	return player > 0
endFunction

actor function GetPlayer()
	if player > 0
		return positionslots[(player - 1)]
	else
		return none
	endIf
endFunction

bool function IsPlayerActor(actor position)
	return position == GetPlayer()
endFunction
bool function IsPlayerPosition(int position)
	return position == (player - 1) 
endFunction

bool function HasActor(actor position)
	return positionslots.Find(position) != -1
endFunction

actor function GetActor(int position)
	return positionslots[position]
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
	if logType == "notification"
		Debug.Notification(type+": "+log)
	elseif logType == "messagebox"
		Debug.MessageBox(method+"() "+type+": "+log)
	elseif logType == "trace-minimal"
		Debug.Trace("SexLab "+method+"() "+type+": "+log)
	else
		Debug.Trace("--------------------------------------------------------------------------------------------")
		Debug.Trace("--- SexLab Thread["+tid+"] -----------------------------------------------------------------------")
		Debug.Trace("--------------------------------------------------------------------------------------------")
		Debug.Trace(" "+type+": "+method+"()" )
		Debug.Trace("   "+log)
		Debug.Trace("--------------------------------------------------------------------------------------------")
	endIf
	if type == "FATAL"
		GoToState("Idle")
	endIf
endFunction

function SendThreadEvent(string eventName)
	; Send Custom Event
	if hook != ""
		string customEvent = eventName+"_"+hook
		Debug.Trace("SexLab Thread["+tid+"]: Sending custom event hook '"+customEvent+"'")
		SendModEvent(customEvent, tid, 1)
	endIf
	; Send Global Event
	SendModEvent(eventName, tid, 1)
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
	positionslots = acDel
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
	player = 0
	stage = 0
	; Empty voice slots
	sslBaseVoice[] voDel
	voices = voDel
	; Empty animations
	sslBaseAnimation[] anDel
	primaryAnimations = anDel
	leadAnimations = anDel
	; Clear Forms
	centerRef = none
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