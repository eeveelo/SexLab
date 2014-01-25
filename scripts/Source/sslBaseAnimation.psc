scriptname sslBaseAnimation extends sslBaseObject

; Config
; int property SFX auto hidden
Sound property SoundFX auto hidden

int actors = 0
int stages = 0
int content = 0

; Animation Events
string[] animations
float[] timers
int[] genders

; Storage legend
; int Key("Positions") = gender, cum
; int Key("Info") = silent (bool), openmouth (bool), strapon (bool), schlong offset (int)
; form Key("Creatures") = Valid races for creature animation
; float Key("Offsets") = forward, side, up, rotate
; string Key("Tags") = tags applied to animation
; float Name = forward, side, up, rotate

; Information
bool property IsSexual hidden
	bool function get()
		return content < 3
	endFunction
endProperty
bool property IsCreature hidden
	bool function get()
		return StorageUtil.FormListCount(Storage, Key("Creatures")) != 0
	endFunction
endProperty
int property StageCount hidden
	int function get()
		return stages
	endFunction
endProperty
int property PositionCount hidden
	int function get()
		return actors
	endFunction
endProperty
int property Males hidden
	int function get()
		return genders[0]
	endFunction
endProperty
int property Females hidden
	int function get()
		return genders[1]
	endFunction
endProperty
int property Creatures hidden
	int function get()
		return genders[2]
	endFunction
endProperty
form[] property CreatureRaces hidden
	form[] function get()
		int i = StorageUtil.FormListCount(Storage, Key("Creatures"))
		form[] races = sslUtility.FormArray(i)
		while i
			i -= 1
			races[i] = StorageUtil.FormListGet(Storage, Key("Creatures"), i)
		endWhile
		return races
	endFunction
endProperty

;/-----------------------------------------------\;
;|	Animation Offsets                            |;
;\-----------------------------------------------/;

float[] function GetPositionOffsets(int position, int stage)
	if !Exists("GetPositionOffsets", position, stage)
		return none
	endIf
	float[] off = new float[4]
	off[0] = GetForward(position, stage)
	off[1] = AccessOffset(position, stage, 1)
	off[2] = AccessOffset(position, stage, 2)
	off[3] = AccessOffset(position, stage, 3)
	return off
endFunction

float function GetForward(int position, int stage)
	; Just return single actors raw forward offset
	if actors == 1
		return AccessOffset(position, stage, 0)
	endIf
	; Check for stored forward calculation
	return StorageUtil.FloatListGet(Storage, Key("Forwards"), DataIndex(1, position, stage, 0))
endFunction

float function CacheForwards(int stage, int returnPosition = 0)
	; Get forward offsets of all positions + find highest/lowest position
	float adjuster
	float[] forwards = new float[5]
	int i = actors
	while i
		i -= 1
		forwards[i] = AccessOffset(i, stage, 0)
		if Math.Abs(forwards[i]) > Math.Abs(adjuster)
			adjuster = forwards[i]
		endIf
	endWhile
	; Get signed half of highest/lowest offset
	adjuster *= -0.5
	; Cache forward offset adjusted by half of highest denomination
	i = actors
	while i
		i -= 1
		forwards[i] = (forwards[i] + adjuster)
		StorageUtil.FloatListSet(Storage, Key("Forwards"), DataIndex(1, i, stage, 0), forwards[i])
	endWhile
	; Return position forward
	return forwards[i]
endFunction

function CacheAllForwards()
	int stage = stages
	while stage
		CacheForwards(stage)
		stage -= 1
	endWhile
endFunction

;/-----------------------------------------------\;
;|	Animation Setup                              |;
;\-----------------------------------------------/;

int function AddPosition(int gender = 0, int addCum = -1)
	if actors >= 5
		_Log("Already at max actor limit of 5, can not add more.", "AddPosition")
		return -1
	endIf
	_WaitLock()
	; Update F/M/C gender tag
	RemoveTag(GetGendersTag())
	genders[gender] = (genders[gender] + 1)
	AddTag(GetGendersTag())
	; Save position data
	StorageUtil.IntListAdd(Storage, Key("Positions"), gender)
	StorageUtil.IntListAdd(Storage, Key("Positions"), addCum)
	; Update actor count
	int aid = actors
	actors += 1
	_Unlock()
	return aid
endFunction

int function AddPositionStage(int position, string animation, float forward = 0.0, float side = 0.0, float up = 0.0, float rotate = 0.0, bool silent = false, bool openMouth = false, bool strapon = true, int sos = 0)
	if !Exists("AddPositionStage", position)
		return -1
	endif
	_WaitLock()
	; Add animation event
	animations = sslUtility.PushString(animation, animations)
	; Figure out what stage this is
	int stage
	if position == 0
		stage = stages + 1
		stages = stage
	else
		stage = ( animations.Length - (position * stages) )
	endIf
	; Set offsets
	StorageUtil.FloatListAdd(Storage, Key("Offsets"), forward)
	StorageUtil.FloatListAdd(Storage, Key("Offsets"), side)
	StorageUtil.FloatListAdd(Storage, Key("Offsets"), up)
	StorageUtil.FloatListAdd(Storage, Key("Offsets"), rotate)
	; Init forward cache
	StorageUtil.FloatListAdd(Storage, Key("Forwards"), 0.0)
	; Set switch information
	StorageUtil.IntListAdd(Storage, Key("Info"), (silent as int))
	StorageUtil.IntListAdd(Storage, Key("Info"), (openMouth as int))
	StorageUtil.IntListAdd(Storage, Key("Info"), ((strapon && MalePosition(position)) as int))
	StorageUtil.IntListAdd(Storage, Key("Info"), sos)
	_Unlock()
	return stage
endFunction

function SetStageTimer(int stage, float timer)
	; Validate stage
	if stage > stages || stage < 1
		_Log("Unknown animation stage, '"+stage+"' given.", "SetStageTimer")
		return
	endIf
	; Initialize timer array if needed
	if timers.Length != stages
		timers = sslUtility.FloatArray(stages)
	endIf
	; Set timer
	timers[(stage - 1)] = timer
endFunction

;/-----------------------------------------------\;
;|	Data Accessors                               |;
;\-----------------------------------------------/;

bool function Exists(string method, int position, int stage = -99)
	if position > actors || position < 0
		_Log("Unknown actor position, '"+position+"' given.", method)
		return false
	elseif stage != -99 && ( stage > stages || stage < 0 )
		_Log("Unknown animation stage, '"+stage+"' given.", method)
		return false
	endIf
	return true
endFunction

int function DataIndex(int slots, int position, int stage, int slot)
	return ( position * (stages * slots) ) + ( (stage - 1) * slots ) + slot
endFunction

float function AccessOffset(int position, int stage, int slot)
	int i = DataIndex(4, position, stage, slot)
	return StorageUtil.FloatListGet(Storage, Key("Offsets"), i) + StorageUtil.FloatListGet(Storage, Name, i)
endFunction

bool function AccessSwitch(int position, int stage, int slot)
	return StorageUtil.IntListGet(Storage, Key("Info"), DataIndex(4, position, stage, slot)) as bool
endFunction

int function AccessPosition(int position, int slot)
	return StorageUtil.IntListGet(Storage, Key("Positions"), ((position * 2) + slot))
endFunction

int function GetSchlong(int position, int stage)
	return StorageUtil.IntListGet(Storage, Key("Info"), DataIndex(4, position, stage, 3))
endFunction

bool function HasTimer(int stage)
	return stage > 0 && stage < timers.Length && timers[(stage - 1)] != 0.0
endFunction

float function GetTimer(int stage)
	if HasTimer(stage)
		return timers[(stage - 1)]
	endIf
	return 0.0 ; Stage has no timer
endFunction

;/-----------------------------------------------\;
;|	Update Offsets                               |;
;\-----------------------------------------------/;

function SetAdjustment(int position, int stage, int slot, float to)
	; Init adjustments
	if StorageUtil.FloatListCount(Storage, Name) < 1
		int i = StorageUtil.FloatListCount(Storage, Key("Offsets"))
		while i > StorageUtil.FloatListCount(Storage, Name)
			StorageUtil.FloatListAdd(Storage, Name, 0.0)
		endWhile
	endIf
	; Set adjustment at index
	StorageUtil.FloatListSet(Storage, Name, DataIndex(4, position, stage, slot), to)
endFunction

float function GetAdjustment(int position, int stage, int slot)
	return StorageUtil.FloatListGet(Storage, Name, DataIndex(4, position, stage, slot))
endFunction

function UpdateOffset(int position, int stage, int slot, float adjust)
	SetAdjustment(position, stage, slot, (GetAdjustment(position, stage, slot) + adjust))
endFunction

function UpdateAllOffsets(int position, int slot, float adjust)
	int stage = stages
	while stage
		UpdateOffset(position, stage, slot, adjust)
		stage -= 1
	endWhile
endFunction

float[] function UpdateForward(int position, int stage, float adjust, bool adjuststage = false)
	if Exists("UpdateForward", position, stage)
		if adjuststage
			UpdateOffset(position, stage, 0, adjust)
			CacheForwards(stage)
		else
			UpdateAllOffsets(position, 0, adjust)
			CacheAllForwards()
		endIf
	endIf
	return GetPositionOffsets(position, stage)
endFunction

float[] function UpdateSide(int position, int stage, float adjust, bool adjuststage = false)
	if Exists("UpdateSide", position, stage)
		if adjuststage
			UpdateOffset(position, stage, 1, adjust)
		else
			UpdateAllOffsets(position, 1, adjust)
		endIf
	endIf
	return GetPositionOffsets(position, stage)
endFunction

float[] function UpdateUp(int position, int stage, float adjust, bool adjuststage = false)
	if Exists("UpdateUp", position, stage)
		if adjuststage
			UpdateOffset(position, stage, 2, adjust)
		else
			UpdateAllOffsets(position, 2, adjust)
		endIf
	endIf
	return GetPositionOffsets(position, stage)
endFunction

function RestoreOffsets()
	StorageUtil.FloatListClear(Storage, Name)
endFunction

;/-----------------------------------------------\;
;|	Animation Events                             |;
;\-----------------------------------------------/;

string[] function FetchPosition(int position)
	if position > actors || position < 0
		_Log("Unknown position, '"+stage+"' given", "FetchPosition")
		return none
	endIf
	string[] anims = sslUtility.StringArray(stages)
	int stage = 0
	while stage <= stages
		anims[stage] = FetchPositionStage(position, (stage + 1))
		stage += 1
	endWhile
	return anims
endFunction

string function FetchPositionStage(int position, int stage)
	return animations[((position * stages) + (stage - 1))]
endFunction

string[] function FetchStage(int stage)
	if stage > stages
		_Log("Unknown stage, '"+stage+"' given", "FetchStage")
		return none
	endIf
	string[] anims = sslUtility.StringArray(actors)
	int position = 0
	while position < actors
		anims[position] = FetchPositionStage(position, stage)
		position += 1
	endWhile
	return anims
endFunction

;/-----------------------------------------------\;
;|	Animation Info                               |;
;\-----------------------------------------------/;

bool function IsSilent(int position, int stage)
	return AccessSwitch(position, stage, 0)
endFunction

bool function UseOpenMouth(int position, int stage)
	return AccessSwitch(position, stage, 1)
endFunction

bool function UseStrapon(int position, int stage)
	return AccessSwitch(position, stage, 2)
endFunction

int function ActorCount()
	return actors
endFunction

int function StageCount()
	return stages
endFunction

int function GetGender(int position)
	return AccessPosition(position, 0)
endFunction

bool function MalePosition(int position)
	return AccessPosition(position, 0) == 0
endFunction

bool function FemalePosition(int position)
	return AccessPosition(position, 0) == 1
endFunction

bool function CreaturePosition(int position)
	return AccessPosition(position, 0) == 2
endFunction

int function FemaleCount()
	int count = 0
	int i = 0
	while i < actors
		if AccessPosition(i, 0) == 1
			count += 1
		endIf
		i += 1
	endWhile
	return count
endFunction

int function MaleCount()
	int count = 0
	int i = 0
	while i < actors
		if AccessPosition(i, 0) == 0
			count += 1
		endIf
		i += 1
	endWhile
	return count
endFunction

int function GetCum(int position)
	return AccessPosition(position, 1)
endFunction

bool function IsSexual()
	return IsSexual
endFunction

function SetContent(int contentType)
	content = contentType
endFunction

;/-----------------------------------------------\;
;|	Animation Tags                               |;
;\-----------------------------------------------/;

string function GetGendersTag()
	return sslAnimationLibrary.GetGenderTag(Females, Males, Creatures)
endFunction

;/-----------------------------------------------\;
;|	Creature Use                                 |;
;\-----------------------------------------------/;

bool function HasRace(Race creature)
	return StorageUtil.FormListFind(Storage, Key("Creatures"), creature) != -1
endFunction

function AddRace(Race creature)
	StorageUtil.FormListAdd(Storage, Key("Creatures"), creature, false)
endFunction

;/-----------------------------------------------\;
;|	System Use                                   |;
;\-----------------------------------------------/;

function _Log(string log, string method, string type = "NOTICE")
	Debug.Trace("--------------------------------------------------------------------------------------------")
	Debug.Trace("--- SexLab BaseAnimation '"+Name+"' ---")
	Debug.Trace("--------------------------------------------------------------------------------------------")
	Debug.Trace(" "+type+": "+method+"()" )
	Debug.Trace("   "+log)
	Debug.Trace("--------------------------------------------------------------------------------------------")
endFunction

function Initialize()
	StorageUtil.FloatListClear(Storage, Key("Offsets"))
	StorageUtil.FloatListClear(Storage, Key("Forwards"))
	StorageUtil.IntListClear(Storage, Key("Positions"))
	StorageUtil.IntListClear(Storage, Key("Info"))
	StorageUtil.FormListClear(Storage, Key("Creatures"))

	Actors = 0
	Stages = 0
	content = 0

	genders = new int[3]
	float[] floatDel1
	timers = floatDel1
	string[] stringDel1
	animations = stringDel1

	parent.Initialize()
endFunction

function _Export()
	string exportkey ="SexLabConfig.Animation["+Name+"]."
	StorageUtil.FileSetIntValue(exportkey+"Enabled", Enabled as int)
	StorageUtil.FileSetIntValue(exportkey+"Aggressive", HasTag("Aggressive") as int)
	StorageUtil.FileSetIntValue(exportkey+"LeadIn", HasTag("LeadIn") as int)

	StorageUtil.FileFloatListClear(exportkey+"Adjustments")
	int i
	int len = StorageUtil.FloatListCount(Storage, Name)
	while i < len
		StorageUtil.FileFloatListAdd(exportkey+"Adjustments", StorageUtil.FloatListGet(Storage, Name, i))
		i += 1
	endWhile
endFunction
function _Import()
	string exportkey ="SexLabConfig.Animation["+Name+"]."
	Enabled = StorageUtil.FileGetIntValue(exportkey+"Enabled", Enabled as int) as bool
	if StorageUtil.FileGetIntValue(exportkey+"Aggressive", HasTag("Aggressive") as int) == 1
		AddTag("Aggressive")
	else
		RemoveTag("Aggressive")
	endIf
	if StorageUtil.FileGetIntValue(exportkey+"LeadIn", HasTag("LeadIn") as int) == 1
		AddTag("LeadIn")
	else
		RemoveTag("LeadIn")
	endIf

	StorageUtil.FloatListClear(Storage, Name)
	int i
	int len = StorageUtil.FileFloatListCount(exportkey+"Adjustments")
	while i < len
		StorageUtil.FloatListAdd(Storage, Name, StorageUtil.FileFloatListGet(exportkey+"Adjustments", i))
		i += 1
	endWhile

	StorageUtil.FileUnsetIntValue(exportkey+"Enabled")
	StorageUtil.FileUnsetIntValue(exportkey+"Aggressive")
	StorageUtil.FileUnsetIntValue(exportkey+"LeadIn")
	StorageUtil.FileFloatListClear(exportkey+"Adjustments")
endFunction

; DEPRECATED: to be removed in 1.5
string[] tags
string[] function _DeprecatedTags()
	return tags
endFunction
