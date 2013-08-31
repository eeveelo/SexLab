scriptname sslBaseAnimation extends Scene

string property Name = "" auto hidden
string property Registrar = "" auto hidden
bool property Enabled = true auto hidden
bool property TCL = false auto hidden
int property Timer = -1 auto hidden

; Gender Types
int property Male = 0 autoreadonly hidden
int property Female = 1 autoreadonly hidden

; Animation Information
int actors = 0
int stages = 0
int sfx = 0
int content = 0

; Animation Events
string[] actor1
string[] actor2
string[] actor3
string[] actor4
string[] actor5

; Data storage
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

bool waiting

;/-----------------------------------------------\;
;|	Animation Offsets                            |;
;\-----------------------------------------------/;

float[] function GetPositionOffsets(int position, int stage)
	if !Exists("GetPositionOffsets", position, stage)
		return none
	endIf

	float[] off = new float[4]
	off[0] = CalculateForward(position, stage)
	;off[0] = AccessOffset(position, stage, 0)
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
	int stage
	if position == 0
		actor1 = sslUtility.PushString(animation, actor1)
		stage = actor1.Length
	elseIf position == 1
		actor2 = sslUtility.PushString(animation, actor2)
		stage = actor2.Length
	elseIf position == 2
		actor3 = sslUtility.PushString(animation, actor3)
		stage = actor3.Length
	elseIf position == 3
		actor4 = sslUtility.PushString(animation, actor4)
		stage = actor4.Length
	elseIf position == 4
		actor5 = sslUtility.PushString(animation, actor5)
		stage = actor5.Length
	endIf
	if stage > stages
		stages = stage
	endIf

	offsetData = sslUtility.PushFloat(forward, offsetData)
	offsetData = sslUtility.PushFloat(side, offsetData)
	offsetData = sslUtility.PushFloat(up, offsetData)
	offsetData = sslUtility.PushFloat(rotate, offsetData)
	offsetDefaults = offsetData
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

;/-----------------------------------------------\;
;|	Data Accessors                               |;
;\-----------------------------------------------/;

int function Zero(int stage)
	stage -= 1
	if stage < 0
		stage = 0
	endIf
	return stage
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
	; Zeroindex the stage
	stage = Zero(stage)
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
	return positionData[(position * slot)]
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

;/-----------------------------------------------\;
;|	Update Offsets                               |;
;\-----------------------------------------------/;

function UpdateForward(int position, int stage, float adjust)
	if !Exists("UpdateForward", position, stage)
		return
	endIf
	int index = DataIndex(4, position, stage, 0)
	offsetData[index] = ( offsetData[index] + adjust )
endFunction

function UpdateAllForward(int position, float adjust)
	if !Exists("UpdateAllForward", position)
		return
	endIf
	int stage = 1
	while stage <= stages
		UpdateForward(position, stage, adjust)
		stage += 1
	endWhile
endFunction

function UpdateSide(int position, int stage, float adjust)
	if !Exists("UpdateSide", position, stage)
		return
	endIf
	int index = DataIndex(4, position, stage, 1)
	offsetData[index] = ( offsetData[index] + adjust )
endFunction

function UpdateAllSide(int position, float adjust)
	if !Exists("UpdateAllSide", position)
		return
	endIf
	int stage = 1
	while stage <= stages
		UpdateSide(position, stage, adjust)
		stage += 1
	endWhile
endFunction

function UpdateUp(int position, int stage, float adjust)
	if !Exists("UpdateUp", position, stage)
		return
	endIf
	int index = DataIndex(4, position, stage, 2)
	offsetData[index] = ( offsetData[index] + adjust )
endFunction

function UpdateAllUp(int position, float adjust)
	if !Exists("UpdateAllUp", position)
		return
	endIf
	int stage = 1
	while stage <= stages
		UpdateUp(position, stage, adjust)
		stage += 1
	endWhile
endFunction

function RestoreOffsets()
	float[] defaults = offsetDefaults
	offsetData = defaults
endFunction

;/-----------------------------------------------\;
;|	Animation Events                             |;
;\-----------------------------------------------/;

string[] function FetchPosition(int position)
	if !Exists("FetchPosition", position)
		return none
	endIf
	if position == 0
		return actor1
	elseif position == 1
		return actor2
	elseif position == 2
		return actor3
	elseif position == 3
		return actor4
	elseif position == 4
		return actor5
	endIf
endFunction

string function FetchPositionStage(int position, int stage)
	; Zeroindex the stage
	stage = Zero(stage)
	string[] events = FetchPosition(position)
	return events[stage]
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

int function GetSFX()
	return sfx
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
		return none
		debug.trace("----SLAB ERROR sslBaseAnimation GetExtras() "+name+"--- Unknown position "+position)
	endIf
endFunction


bool function IsSexual()
	if content == 1 || content == 2
		return true
	else
		return false
	endIf
endFunction

function SetSFX(int iSFX)
	sfx = iSFX
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
	return tags.Find(tag) >= 0
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
	Debug.Trace("--- SexLab BaseAnimation["+Registrar+"] ----------------------------------------------------------")
	Debug.Trace("--------------------------------------------------------------------------------------------")
	Debug.Trace(" "+type+": "+method+"()" )
	Debug.Trace("   "+log)
	Debug.Trace("--------------------------------------------------------------------------------------------")
endFunction

function UnloadAnimation()
	Name = ""
	Registrar = ""
	Enabled = true
	content = 0
	actors = 0
	stages = 0
	sfx = 0

	float[] floatDel
	offsetData = floatDel
	offsetDefaults = floatDel

	int[] intDel
	schlongData = intDel
	positionData = intDel

	bool[] switchDel
	switchData = switchDel

	string[] tagsDel
	tags = tagsDel
	string[] actor1Del
	actor1 = actor1Del
	string[] actor2Del
	actor2 = actor2Del
	string[] actor3Del
	actor3 = actor3Del
	string[] actor4Del
	actor4 = actor4Del
	string[] actor5Del
	actor5 = actor5Del

	form[] extras1Del
	extras1 = extras1Del
	form[] extras2Del
	extras2 = extras2Del
	form[] extras3Del
	extras3 = extras3Del
	form[] extras4Del
	extras4 = extras4Del
	form[] extras5Del
	extras5 = extras5Del
endFunction