scriptname sslBaseAnimation extends ReferenceAlias

; Config
string property Name = "" auto hidden
bool property Enabled = true auto hidden
int property SFX auto hidden

int actors = 0
int stages = 0
int content = 0

; Animation Events
string[] animations
float[] timers
int[] genders

; Storage key
Quest Storage
; Storage legend
; int Key("Positions") = gender, cum
; int Key("Info") = silent (bool), openmouth (bool), strapon (bool), schlong offset (int)
; form Key("Creatures") = Valid races for creature animation
; float Key("Offsets") = forward, side, up, rotate
; string Key("Tags") = tags applied to animation
; float Name = forward, side, up, rotate

bool waiting

; Information
bool property Registered hidden
	bool function get()
		return Name != ""
	endFunction
endProperty
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
	off[0] = CalculateForward(position, stage)
	off[1] = AccessOffset(position, stage, 1)
	off[2] = AccessOffset(position, stage, 2)
	off[3] = AccessOffset(position, stage, 3)
	return off
endFunction

float function CalculateForward(int position, int stage)
	; raw offset
	float offset = AccessOffset(position, stage, 0)
	; Just return single actors raw forward offset
	if actors == 1
		return offset
	endIf
	; Find highest/lowest offset denomination
	float adjust
	int i = 0
	while i < actors
		float pos = AccessOffset(i, stage, 0)
		if pos > adjust || -pos > adjust
			adjust = pos
		endIf
		i += 1
	endWhile
	; Return offset adjusted by half of highest denomination
	if adjust < 0
		return ( offset + ( adjust * -0.5 ) )
	else
		return ( offset - ( adjust * 0.5 ) )
	endIf
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
	waiting = false
	return aid
endFunction

int function AddPositionStage(int position, string animation, float forward = 0.0, float side = 0.0, float up = 0.0, float rotate = 0.0, bool silent = false, bool openMouth = false, bool strapon = true, int sos = 0)
	if !Exists("AddPositionStage", position)
		return -1
	endIf
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
	; Set switch information
	StorageUtil.IntListAdd(Storage, Key("Info"), (silent as int))
	StorageUtil.IntListAdd(Storage, Key("Info"), (openMouth as int))
	StorageUtil.IntListAdd(Storage, Key("Info"), ((strapon && MalePosition(position)) as int))
	StorageUtil.IntListAdd(Storage, Key("Info"), sos)
	waiting = false
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

float function GetStageTimer(int stage)
	if stage > timers.Length || stage < 1 || stage > stages
		return 0.0 ; There is no valid stage timer, skip the rest
	endIf
	return timers[(stage - 1)]
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
		else
			UpdateAllOffsets(position, 0, adjust)
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

bool function HasTag(string tag)
	return tag != "" && StorageUtil.StringListFind(Storage, Key("Tags"), tag) != -1
endFunction

bool function AddTag(string tag)
	if HasTag(tag)
		return false
	endIf
	StorageUtil.StringListAdd(Storage, Key("Tags"), tag, false)
	return true
endFunction

bool function RemoveTag(string tag)
	if !HasTag(tag)
		return false
	endIf
	StorageUtil.StringListRemove(Storage, Key("Tags"), tag, true)
	return true
endFunction

bool function ToggleTag(string tag)
	return (RemoveTag(tag) || AddTag(tag)) && HasTag(tag)
endFunction

bool function CheckTags(string[] find, bool requireAll = true, bool suppress = false)
	int i = find.Length
	while i
		i -= 1
		if find[i] != ""
			bool check = HasTag(find[i])
			if requireAll && !check && !suppress
				return false ; Stop if we need all and don't have it
			elseif !requireAll && check && !suppress
				return true ; Stop if we don't need all and have one
			elseif check && suppress
				return false
			endIf
		endIf
	endWhile
	; If still here than we require all and had all
	return true
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

string function Key(string type = "")
	return Name+"."+type
endFunction

function _WaitLock()
	while waiting
		Utility.Wait(0.1)
	endWhile
	waiting = true
endFunction

function _Log(string log, string method, string type = "NOTICE")
	Debug.Trace("--------------------------------------------------------------------------------------------")
	Debug.Trace("--- SexLab BaseAnimation '"+Name+"' ---")
	Debug.Trace("--------------------------------------------------------------------------------------------")
	Debug.Trace(" "+type+": "+method+"()" )
	Debug.Trace("   "+log)
	Debug.Trace("--------------------------------------------------------------------------------------------")
endFunction

function Initialize()
	Storage = GetOwningQuest()

	StorageUtil.FloatListClear(Storage, Key("Offsets"))
	StorageUtil.IntListClear(Storage, Key("Positions"))
	StorageUtil.IntListClear(Storage, Key("Info"))
	StorageUtil.StringListClear(Storage, Key("Tags"))
	StorageUtil.FormListClear(Storage, Key("Creatures"))

	Name = ""
	Enabled = true
	waiting = false
	Actors = 0
	Stages = 0
	SFX = 0
	content = 0

	genders = new int[3]
	float[] floatDel1
	timers = floatDel1
	string[] stringDel1
	animations = stringDel1
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

string[] tags
string[] function _DeprecatedTags()
	return tags
endFunction

function PrintTags()
	int i = StorageUtil.StringListCount(Storage, Key("Tags"))
	string[] output = sslUtility.StringArray(i)
	while i
		i -= 1
		output[i] = StorageUtil.StringListGet(Storage, Key("Tags"), i)
	endWhile
	Debug.Trace(Name+" Tags["+StorageUtil.StringListCount(Storage, Key("Tags"))+"]: "+output)
endFunction

function _Update140()
	; int old = StorageUtil.FloatListCount(Storage, Name)
	; if old < 1
	; 	return ; Already updated
	; endIf
	; ; Clear adjustments list, just in case, should already be empty
	; StorageUtil.FloatListClear(Storage, Name)
	; ; Set adjustments list from old list
	; int i
	; while i < old
	; 	StorageUtil.FloatListAdd(Storage, Name, StorageUtil.FloatListGet(Storage, Name, i))
	; 	i += 1
	; endWhile
	; ; Clear old list
	; StorageUtil.FloatListClear(Storage, Name)
endFunction
