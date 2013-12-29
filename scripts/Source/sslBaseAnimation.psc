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
int[] genders

; Data storage
string[] tags
form[] races
float[] timerData
float[] offsetData ; x, y, z, rotation
bool[] switchData ; silence, mouth, strapon
int[] positionData ; gender, cum
int[] schlongData ; bend

bool waiting

; Storage key
Quest Storage

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
		return races.Length > 0
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
	; if IsCreature
	; 	off[0] = CalculateForward(position, stage)
	; else
	; 	off[0] = AccessOffset(position, stage, 0)
	; endIf
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
	RemoveTag(GetGendersTag())
	genders[gender] = (genders[gender] + 1)
	AddTag(GetGendersTag())
	int[] position = new int[2]
	position[0] = gender
	position[1] = addCum
	positionData = sslUtility.MergeIntArray(position, positionData)
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
	float[] offset = new float[4]
	offset[0] = forward
	offset[1] = side
	offset[2] = up
	offset[3] = rotate
	offsetData = sslUtility.MergeFloatArray(offset, offsetData)

	; Set switch information
	bool[] switch = new bool[3]
	switch[0] = silent
	switch[1] = openMouth
	switch[2] = strapon && MalePosition(position)
	switchData = sslUtility.MergeBoolArray(switch, switchData)

	; Set Schlongs of Skyrim bend
	schlongData = sslUtility.PushInt(sos, schlongData)

	waiting = false
	return stage
endFunction

function SetStageTimer(int stage, float timer)
	; Validate stage
	if stage > stages || stage < 1
		_Log("Unknown animation stage, '"+stage+"' given.", "SetStageTimer")
		return
	endIf
	; Initial timer array if needed
	if timerData.Length != stages
		timerData = sslUtility.FloatArray(stages)
	endIf
	; Zeroindex the stage
	stage -= 1
	; Set timer
	timerData[stage] = timer
endFunction

;/-----------------------------------------------\;
;|	Data Accessors                               |;
;\-----------------------------------------------/;

string function KeyStr(int i1, int i2)
	return Name+"["+i1+"-"+i2+"]"
endFunction

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
	return offsetData[DataIndex(4, position, stage, slot)] + StorageUtil.FloatListGet(Storage, KeyStr(position, stage), slot)
endFunction

float function GetAdjustment(int position, int stage, int slot)
	string KeyStr = KeyStr(position, stage)
	if StorageUtil.FloatListCount(Storage, KeyStr) == 0
		return 0.0
	endIf
	return StorageUtil.FloatListGet(Storage, KeyStr, slot)
endFunction

bool function AccessSwitch(int position, int stage, int slot)
	return switchData[DataIndex(3, position, stage, slot)]
endFunction

int function AccessPosition(int position, int slot)
	return positionData[( (position * 2) + slot )]
endFunction

bool[] function GetSwitchSlot(int stage, int slot)
	bool[] switch = sslUtility.BoolArray(actors)
	int i = 0
	while i < actors
		switch[i] = AccessSwitch(i, stage, slot)
		i += 1
	endWhile
	return switch
endFunction

int[] function GetSchlongSlot(int stage)
	int[] schlongs = sslUtility.IntArray(actors)
	int i = 0
	while i < actors
		schlongs[i] = GetSchlong(i, stage)
		i += 1
	endWhile
	return schlongs
endFunction

int function GetSchlong(int position, int stage)
	return schlongData[DataIndex(1, position, stage, 0)]
endFunction

float function GetStageTimer(int stage)
	if stage > timerData.Length || stage < 1 || stage > stages
		return 0.0 ; There is no valid stage timer, skip the rest
	endIf
	; Zero index
	stage -= 1
	; Return timer
	return timerData[stage]
endFunction

;/-----------------------------------------------\;
;|	Update Offsets                               |;
;\-----------------------------------------------/;

function UpdateAllOffsets(int slot, int position, float adjust)
	int stage = stages
	while stage
		UpdateOffset(slot, position, stage, adjust)
		stage -= 1
	endWhile
endFunction

function UpdateOffset(int slot, int position, int stage, float adjust)
	string KeyStr = KeyStr(position, stage)
	while StorageUtil.FloatListCount(Storage, KeyStr) < 4
		StorageUtil.FloatListAdd(Storage, KeyStr, 0.0)
	endWhile
	StorageUtil.FloatListSet(Storage, KeyStr, slot, (StorageUtil.FloatListGet(Storage, KeyStr, slot) + adjust))
endFunction

float[] function UpdateForward(int position, int stage, float adjust, bool adjuststage = false)
	if Exists("UpdateForward", position, stage)
		if adjuststage
			UpdateOffset(0, position, stage, adjust)
		else
			UpdateAllOffsets(0, position, adjust)
		endIf
	endIf
	return GetPositionOffsets(position, stage)
endFunction

float[] function UpdateSide(int position, int stage, float adjust, bool adjuststage = false)
	if Exists("UpdateSide", position, stage)
		if adjuststage
			UpdateOffset(1, position, stage, adjust)
		else
			UpdateAllOffsets(1, position, adjust)
		endIf
	endIf
	return GetPositionOffsets(position, stage)
endFunction

float[] function UpdateUp(int position, int stage, float adjust, bool adjuststage = false)
	if Exists("UpdateUp", position, stage)
		if adjuststage
			UpdateOffset(2, position, stage, adjust)
		else
			UpdateAllOffsets(2, position, adjust)
		endIf
	endIf
	return GetPositionOffsets(position, stage)
endFunction

function RestoreOffsets()
	int position
	while position < actors
		int stage = stages
		while stage
			StorageUtil.FloatListClear(Storage, KeyStr(position, stage))
			stage -= 1
		endWhile
		position += 1
	endWhile
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

bool[] function GetSilence(int stage)
	return GetSwitchSlot(stage, 0)
endFunction

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
	string tag
	int i = Females
	while i
		i -= 1
		tag += "F"
	endWhile
	i = Males
	while i
		i -= 1
		tag += "M"
	endWhile
	i = Creatures
	while i
		i -= 1
		tag += "C"
	endWhile
	return tag
endFunction

bool function AddTag(string tag)
	if HasTag(tag)
		return false
	endIf
	tags = sslUtility.PushString(tag,tags)
	return true
endFunction

bool function RemoveTag(string tag)
	if !HasTag(tag)
		return false
	endIf
	string[] newTags
	int i = 0
	while i < tags.Length
		if tags[i] != tag
			newTags = sslUtility.PushString(tags[i], newTags)
		endIf
		i += 1
	endWhile
	tags = newTags
	return true
endFunction

bool function HasTag(string tag)
	return tag != "" && tags.Find(tag) != -1
endFunction

bool function ToggleTag(string tag)
	if HasTag(tag)
		RemoveTag(tag)
	else
		AddTag(tag)
	endIf
	return HasTag(tag)
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
	return races.Length != 0 && races.Find(creature) != -1
endFunction

function AddRace(Race creature)
	if !HasRace(creature)
		races = sslUtility.PushForm(creature, races)
	endIf
endFunction

;/-----------------------------------------------\;
;|	System Use                                   |;
;\-----------------------------------------------/;

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
	Name = ""
	Enabled = true
	waiting = false
	Actors = 0
	Stages = 0
	SFX = 0
	content = 0

	float[] floatDel1
	timerData = floatDel1
	float[] floatDel2
	offsetData = floatDel2

	genders = new int[3]
	int[] intDel1
	schlongData = intDel1
	int[] intDel2
	positionData = intDel2

	bool[] switchDel
	switchData = switchDel

	string[] stringDel1
	tags = stringDel1
	string[] stringDel2
	animations = stringDel2

	form[] formDel
	races = formDel

	Storage = GetOwningQuest()
endFunction

function _Export()
	string exportkey ="SexLabConfig.Animation["+Name+"]."
	StorageUtil.FileSetIntValue(exportkey+"Enabled", Enabled as int)
	StorageUtil.FileSetIntValue(exportkey+"Aggressive", HasTag("Aggressive") as int)
	StorageUtil.FileSetIntValue(exportkey+"LeadIn", HasTag("LeadIn") as int)
	StorageUtil.FileFloatListClear(exportkey+"Offsets")
	int position
	while position < actors
		int stage = 1
		while stage <= stages
			StorageUtil.FileFloatListAdd(exportkey+"Offsets", StorageUtil.FloatListGet(Storage, KeyStr(position, stage), 0))
			StorageUtil.FileFloatListAdd(exportkey+"Offsets", StorageUtil.FloatListGet(Storage, KeyStr(position, stage), 1))
			StorageUtil.FileFloatListAdd(exportkey+"Offsets", StorageUtil.FloatListGet(Storage, KeyStr(position, stage), 2))
			StorageUtil.FileFloatListAdd(exportkey+"Offsets", StorageUtil.FloatListGet(Storage, KeyStr(position, stage), 3))
			stage += 1
		endWhile
		position += 1
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
	int i
	int position
	while position < actors
		int stage = 1
		while stage <= stages
			float importing = StorageUtil.FileFloatListGet(exportkey+"Offsets", (i))
			if importing != 0.0
				StorageUtil.FloatListSet(Storage, KeyStr(position, stage), 0, importing)
			endIf
			importing = StorageUtil.FileFloatListGet(exportkey+"Offsets", (i + 1))
			if importing != 0.0
				StorageUtil.FloatListSet(Storage, KeyStr(position, stage), 1, importing)
			endIf
			importing = StorageUtil.FileFloatListGet(exportkey+"Offsets", (i + 2))
			if importing != 0.0
				StorageUtil.FloatListSet(Storage, KeyStr(position, stage), 2, importing)
			endIf
			importing = StorageUtil.FileFloatListGet(exportkey+"Offsets", (i + 3))
			if importing != 0.0
				StorageUtil.FloatListSet(Storage, KeyStr(position, stage), 3, importing)
			endIf
			stage += 1
			i += 4
		endWhile
		position += 1
	endWhile

endFunction
