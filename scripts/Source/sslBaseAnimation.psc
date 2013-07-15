scriptname sslBaseAnimation extends quest

string property name = "" auto hidden
bool property enabled = true auto hidden
bool property tcl = false auto hidden

; Gender Types
int property Male = 0 autoreadonly hidden
int property Female = 1 autoreadonly hidden
; Cum Types
int property Vaginal = 1 autoreadonly hidden
int property Oral = 2 autoreadonly hidden
int property Anal = 3 autoreadonly hidden
int property VaginalOral = 4 autoreadonly hidden
int property VaginalAnal = 5 autoreadonly hidden
int property OralAnal = 6 autoreadonly hidden
int property VaginalOralAnal = 7 autoreadonly hidden
; SFX Types
int property Squishing = 1 autoreadonly hidden
int property Sucking = 2 autoreadonly hidden
int property SexMix = 3 autoreadonly hidden
; Content Types
int property Misc = 0 autoreadonly hidden
int property Sexual = 1 autoreadonly hidden
int property Foreplay = 2 autoreadonly hidden

; Animation Information
int content = 0
int actors = 0
int stages = 0
int sfx = 0

; Animation Events
string[] actor1
string[] actor2
string[] actor3
string[] actor4
string[] actor5

; Data storage
float[] offsetData
float[] offsetDefaults
bool[] switchData
int[] schlongData


int[] genders
int[] cum

string[] tags

form[] extras1
form[] extras2
form[] extras3
form[] extras4
form[] extras5

bool waiting

;/-----------------------------------------------
	Data Accessor Functions
------------------------------------------------/;

int function DataIndex(int slots, int position, int stage, int slot)
	; Zeroindex the stage
	stage -= 1
	if stage < 0
		stage = 0
	endIf
	; Return calculated index
	return ( position * (stages * slots) ) + ( stage * slots ) + slot
endFunction

float function AccessOffset(int position, int stage, int slot)
	return offsetData[DataIndex(4, position, stage, slot)]
endFunction

bool function AccessSwitch(int position, int stage, int slot)
	return switchData[DataIndex(3, position, stage, slot)]
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
		schlongs[i] = schlongData[DataIndex(1, i, stage, 0)]
		i += 1
	endWhile
	return schlongs
endFunction

;/-----------------------------------------------
	Animation Position Functions
------------------------------------------------/;

int function AddPosition(int gender = 0, int addCum = -1)
	if actors >= 5
		debug.trace("----SLAB ERROR sslBaseAnimation AddPosition() "+name+"--- Over max actor limit of 5")
		return -1
	endIf
	_WaitLock()
	genders = sslUtility.PushInt(gender, genders)
	cum = sslUtility.PushInt(addCum, cum)
	int aid = actors
	actors += 1
	waiting = false
	return aid
endFunction

int function AddPositionStage(int position, string animation, float forward = 0.0, float side = 0.0, float up = 0.0, float rotate = 0.0, bool silent = false, bool openMouth = false, bool strapon = true, int sos = 0)
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
	else
		debug.trace("----SLAB ERROR sslBaseAnimation AddPositionStage() "+name+"--- Unknown actor or stage in "+position)
		waiting = false
		return -1
	endIf
	if stage > stages
		stages = stage
	endIf
	offsetData = sslUtility.PushFloat(forward, offsetData)
	offsetData = sslUtility.PushFloat(side, offsetData)
	offsetData = sslUtility.PushFloat(up, offsetData)
	offsetData = sslUtility.PushFloat(rotate, offsetData)
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
	else
		debug.trace("----SLAB ERROR sslBaseAnimation "+name+" GetOffset(position="+position+") --- Unknown position")
	endIf
endFunction

;/-----------------------------------------------
	Animation Offset Functions
------------------------------------------------/;

float[] function GetPositionOffsets(int position, int stage)
	if position > actors || position < 0
		debug.trace("----SexLab ERROR sslBaseAnimation--- Unknown "+name+" position ["+position+"]")
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
	if position > actors || position < 0
		debug.trace("----SexLab ERROR sslBaseAnimation--- Unknown "+name+" position ["+position+"]")
		return 0.0
	endIf
	; Just get single actors raw forward offset
	if actors == 1
		return AccessOffset(position, stage, 0)
	endIf
	; Get all actors forwad offset
	float[] offsets = sslUtility.FloatArray(actors)
	int i = 0
	while i < actors
		;debug.trace(name+" getting forward for position "+i+" stage "+stage+ " actorcount "+actorcount())
		offsets[i] = AccessOffset(i, stage, 0)
		i += 1
	endWhile
	; Determine highest or lowest offset
	float highest
	float lowest
	i = 0
	while i < actors
		if offsets[i] > highest
			highest = offsets[i]
		elseif offsets[i] < lowest
			lowest = offsets[i]
		endIf
		i += 1
	endWhile
	; Adjust offset by highest or lowest
	float adjust
	float offset
	if highest > -lowest && highest > 50
		return (offsets[position] - (highest * 0.5))
	elseif -lowest > highest && lowest < -50
		return (offsets[position] + (lowest * -0.5))
	elseif highest > -lowest
		return (offsets[position] - highest)
	else
		return (offsets[position] + lowest)
	endIf
	; Return Adjusted offset
	return offsets[position]
endFunction

function UpdateForward(int position, int stage, float adjust)
	int index = DataIndex(4, position, stage, 0)
	offsetData[index] = ( offsetData[index] + adjust )
endFunction

function UpdateAllForward(int position, float adjust)
	int stage = 1
	while stage <= StageCount()
		UpdateForward(position, stage, adjust)
		stage += 1
	endWhile
endFunction

function UpdateSide(int position, int stage, float adjust)
	int index = DataIndex(4, position, stage, 1)
	offsetData[index] = ( offsetData[index] + adjust )
endFunction

function UpdateAllSide(int position, float adjust)
	int stage = 1
	while stage <= StageCount()
		UpdateSide(position, stage, adjust)
		stage += 1
	endWhile
endFunction

function UpdateUp(int position, int stage, float adjust)
	int index = DataIndex(4, position, stage, 2)
	offsetData[index] = ( offsetData[index] + adjust )
endFunction

function UpdateAllUp(int position, float adjust)
	int stage = 1
	while stage <= StageCount()
		UpdateUp(position, stage, adjust)
		stage += 1
	endWhile
endFunction

function RestoreOffsets()
	float[] defaults = offsetDefaults
	offsetData = defaults
endFunction

;/-----------------------------------------------
	Animation Event Functions
------------------------------------------------/;

string[] function FetchStage(int stage)
	; Zeroindex the stage
	stage -= 1
	if stage < 0
		stage = 0
	endIf
	string[] anims = sslUtility.StringArray(actors)
	anims[0] = actor1[stage]
	if actors == 1
		return anims
	endIf
	anims[1] = actor2[stage]
	if actors == 2
		return anims
	endIf
	anims[2] = actor3[stage]
	if actors == 3
		return anims
	endIf
	anims[3] = actor4[stage]
	if actors == 4
		return anims
	endIf
	anims[4] = actor5[stage]
	return anims
endFunction

;/-----------------------------------------------
	Animation Configuration Functions
------------------------------------------------/;

bool[] function GetSilence(int stage)
	return GetSwitchSlot(stage, 0)
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
	return genders[position]
endFunction

int function GetCum(int position)
	return cum[position]
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

;/-----------------------------------------------
	Animation Tag Functions
------------------------------------------------/;

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

;/-----------------------------------------------
	Animation System Functions
------------------------------------------------/;

function _WaitLock()
	while waiting
	endWhile
	waiting = true
endFunction


function LoadAnimation()
	return
endFunction

function UnloadAnimation()
	name = ""
	enabled = true
	content = 0
	actors = 0
	stages = 0
	sfx = 0

	float[] floatDel
	offsetData = floatDel
	offsetDefaults = floatDel

	int[] gendersDel
	genders = gendersDel
	int[] cumDel
	cum = cumDel

	int[] schlongDel
	schlongData = schlongDel

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