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

; Data storage
float[] timerData
float[] offsetData ; x, y, z, rotation
float[] offsetDefaults ; x, y, z, rotation
bool[] switchData ; silence, mouth, strapon
int[] positionData ; gender, cum
int[] schlongData ; bend

string[] tags

form[] extras1
form[] extras2
form[] extras3
form[] extras4
form[] extras5

Form[] creatures

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
		return creatures.Length > 0
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
;/-----------------------------------------------\;
;|	Animation Offsets                            |;
;\-----------------------------------------------/;

float[] function GetPositionOffsets(int position, int stage, bool adjust = true)
	if !Exists("GetPositionOffsets", position, stage)
		return none
	endIf

	float[] off = new float[4]
	if adjust
		off[0] = CalculateForward(position, stage)
	else
		off[0] = AccessOffset(position, stage, 0)
	endIf
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
	positionData = sslUtility.PushInt(gender, positionData)
	positionData = sslUtility.PushInt(addCum, positionData)
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

	animations = sslUtility.PushString(animation, animations)

	int stage
	if position == 0
		stage = ( stages + 1 )
		stages = stage
	else
		stage = ( animations.Length - (position * stages) )
	endIf
	; Set current
	offsetData = sslUtility.PushFloat(forward, offsetData)
	offsetData = sslUtility.PushFloat(side, offsetData)
	offsetData = sslUtility.PushFloat(up, offsetData)
	offsetData = sslUtility.PushFloat(rotate, offsetData)
	; Copy for defaults
	offsetDefaults = sslUtility.PushFloat(forward, offsetDefaults)
	offsetDefaults = sslUtility.PushFloat(side, offsetDefaults)
	offsetDefaults = sslUtility.PushFloat(up, offsetDefaults)
	offsetDefaults = sslUtility.PushFloat(rotate, offsetDefaults)
	if !IsSexual()
		strapon = false
	endIf
	switchData = sslUtility.PushBool(silent, switchData)
	switchData = sslUtility.PushBool(openMouth, switchData)
	switchData = sslUtility.PushBool(strapon, switchData)
	schlongData = sslUtility.PushInt(sos, schlongData)
	waiting = false
	return stage
endFunction

function AddExtra(int position, form extra)
	if !Exists("AddExtra", position)
		return
	endIf

	if position == 0
		extras1 = sslUtility.PushForm(extra, extras1)
	elseIf position == 1
		extras2 = sslUtility.PushForm(extra, extras2)
	elseIf position == 2
		extras3 = sslUtility.PushForm(extra, extras3)
	elseIf position == 3
		extras4 = sslUtility.PushForm(extra, extras4)
	elseIf position == 4
		extras5 = sslUtility.PushForm(extra, extras5)
	endIf
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
	; Zeroindex the stage
	stage -= 1
	; Return calculated index
	return ( position * (stages * slots) ) + ( stage * slots ) + slot
endFunction

float function AccessOffset(int position, int stage, int slot)
	return offsetData[DataIndex(4, position, stage, slot)]
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
	int index = DataIndex(4, position, stage, slot)
	offsetData[index] = offsetData[index] + adjust
endFunction

function UpdateForward(int position, int stage, float adjust, bool adjuststage = false)
	if Exists("UpdateForward", position, stage)
		if adjuststage
			UpdateOffset(0, position, stage, adjust)
		else
			UpdateAllOffsets(0, position, adjust)
		endIf
	endIf
endFunction

function UpdateSide(int position, int stage, float adjust, bool adjuststage = false)
	if Exists("UpdateSide", position, stage)
		if adjuststage
			UpdateOffset(1, position, stage, adjust)
		else
			UpdateAllOffsets(1, position, adjust)
		endIf
	endIf
endFunction

function UpdateUp(int position, int stage, float adjust, bool adjuststage = false)
	if Exists("UpdateUp", position, stage)
		if adjuststage
			UpdateOffset(2, position, stage, adjust)
		else
			UpdateAllOffsets(2, position, adjust)
		endIf
	endIf
endFunction

function RestoreOffsets()
	;float[] defaults = offsetDefaults
	float[] fDel
	offsetData = fDel
	debug.trace(offsetData) 
	offsetData = offsetDefaults
	debug.trace(offsetData)
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

form[] function GetExtras(int position)
	if position == 0
		return extras1
	elseIf position == 1
		return extras2
	elseIf position == 2
		return extras3
	elseIf position == 3
		return extras1
	elseIf position == 4
		return extras5
	else
		form[] null
		return null
	endIf
endFunction

function EquipExtras(int position, actor a)
	form[] extras = GetExtras(position)
	if extras.Length > 0
		int i = extras.Length
		while i
			i -= 1
			if extras[i] != none
				a.EquipItem(extras[i], false, true)
			endIf
		endWhile
	endIf
endFunction

function RemoveExtras(int position, actor a)
	form[] extras = GetExtras(position)
	if extras.Length > 0
		int i = extras.Length
		while i
			i -= 1
			if extras[i] != none
				a.UnequipItem(extras[i], false, true)
				a.RemoveItem(extras[i], 1, true)
			endIf
		endWhile
	endIf
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

bool function AddTag(string tag)
	if HasTag(tag)
		return false
	endIf
	int tagCount = tags.Length
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
	return tags.Find(tag) != -1
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
;|	Creature Use                                 |;
;\-----------------------------------------------/;

bool function HasRace(Race creature)
	bool output = creatures.Find(creature) != -1
	return output
endFunction

function AddRace(Race creature)
	if !HasRace(creature)
		creatures = sslUtility.PushForm(creature, creatures)
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

	float[] floatDel
	timerData = floatDel
	offsetData = floatDel
	offsetDefaults = floatDel

	int[] intDel
	schlongData = intDel
	positionData = intDel

	bool[] switchDel
	switchData = switchDel

	string[] stringDel
	tags = stringDel
	animations = stringDel

	form[] formDel
	extras1 = formDel
	extras2 = formDel
	extras3 = formDel
	extras4 = formDel
	extras5 = formDel
	creatures = formDel
endFunction