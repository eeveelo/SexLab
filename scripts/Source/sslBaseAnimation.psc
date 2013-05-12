scriptname sslBaseAnimation extends quest

string property name = "" auto hidden
bool property enabled = true auto hidden

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
int property Silent = 0 autoreadonly hidden
int property Squishing = 1 autoreadonly hidden
int property Sucking = 2 autoreadonly hidden
int property SexMix = 3 autoreadonly hidden
; Content Types
int property Misc = 0 autoreadonly hidden
int property Sexual = 1 autoreadonly hidden
int property Foreplay = 2 autoreadonly hidden

int content = 0
int actors = 0
int stages = 0
int sfx = 0

float[] offsets
float[] offsetsUp
float[] offsetsSide
float[] offsetsDefault
float[] offsetsUpDefault
float[] offsetsSideDefault
float[] rotations
bool[] silence
int[] genders
bool[] noStrapons

int[] cum

string[] tags

idle[] actor1
idle[] actor2
idle[] actor3
idle[] actor4
idle[] actor5

form[] extras1
form[] extras2
form[] extras3
form[] extras4
form[] extras5

float function GetOffset(int position, float adjust = 0.0)
	if adjust > 0.0
		int i = 0
		while i < offsets.Length
			if offsets[i] <= -adjust
				return offsets[position] + adjust
			elseif offsets[i] >= adjust
				return offsets[position] - adjust
			endIf
			i += 1
		endWhile
	endIf
	return offsets[position]
endFunction

float function GetOffsetSide(int position)
	if position == 0
		return offsetsSide[position]
	elseIf position == 1
		return offsetsSide[position]
	elseIf position == 2
		return offsetsSide[position]
	elseIf position == 3
		return offsetsSide[position]
	elseIf position == 4
		return offsetsSide[position]
	else
		debug.trace("----SLAB ERROR sslBaseAnimation "+name+" GetOffset(position="+position+") --- Unknown position")
	endIf
endFunction


float function GetOffsetUp(int position)
	if position == 0
		return offsetsUp[position]
	elseIf position == 1
		return offsetsUp[position]
	elseIf position == 2
		return offsetsUp[position]
	elseIf position == 3
		return offsetsUp[position]
	elseIf position == 4
		return offsetsUp[position]
	else
		debug.trace("----SLAB ERROR sslBaseAnimation "+name+" GetOffsetZ(position="+position+") --- Unknown position")
	endIf
endFunction

float function GetRotation(int position)
	if position == 0
		return rotations[position]
	elseIf position == 1
		return rotations[position]
	elseIf position == 2
		return rotations[position]
	elseIf position == 3
		return rotations[position]
	elseIf position == 4
		return rotations[position]
	else
		debug.trace("----SLAB ERROR sslBaseAnimation "+name+" GetRotation(position="+position+") --- Unknown position")
	endIf
endFunction

idle function Fetch(int position, int stage)
	; Zeroindex the stage
	if stage > 0
		stage -= 1
	endIf
	; Get position stage idle
	if position == 0
		return actor1[stage]
	elseIf position == 1
		return actor2[stage]
	elseIf position == 2
		return actor3[stage]
	elseIf position == 3
		return actor4[stage]
	elseIf position == 4
		return actor5[stage]
	else
		debug.trace("----SLAB ERROR sslBaseAnimation "+name+" Fetch(position="+position+", stage="+Stage+") --- Unknown position")
	endIf
endFunction

function SetSFX(int iSFX)
	sfx = iSFX
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

bool[] function GetSilence()
	return silence
endFunction

int function GetGender(int position)
	return genders[position]
endFunction

int function GetCum(int position)
	return cum[position]
endFunction

bool function IsSexual()
	if content == 1 || content == 2
		return true
	else
		return false
	endIf
endFunction

function SetContent(int contentType)
	content = contentType
endFunction

int function AddPosition(int gender = 0, float offset = 0.0, float offsetUp = 0.0, float offsetSide = 0.0, float rotation = 0.0,  bool noStrapon = false, bool noVoice = false, int addCum = -1)
	if actors >= 6
		debug.trace("----SLAB ERROR sslBaseAnimation AddPosition() "+name+"--- Over max actor limit of 5")
		return -1
	endIf
	genders = sslUtility.PushInt(gender,genders)

	offsets = sslUtility.PushFloat(offset,offsets)
	offsetsDefault = offsets

	offsetsUp = sslUtility.PushFloat(offsetUp,offsetsUp)
	offsetsUpDefault = offsetsUp

	offsetsSide = sslUtility.PushFloat(offsetSide,offsetsSide)
	offsetsSideDefault = offsetsSide

	rotations = sslUtility.PushFloat(rotation,rotations)
	noStrapons = sslUtility.PushBool(noStrapon,noStrapons)
	silence = sslUtility.PushBool(noVoice,silence)
	cum = sslUtility.PushInt(addCum,cum)
	int aid = actors
	actors += 1
	return aid
endFunction

int function AddPositionStage(int position, idle animation)
	int stage = 0
	if position == 0
		actor1 = sslUtility.PushIdle(animation,actor1)
		stage = actor1.Length
	elseIf position == 1
		actor2 = sslUtility.PushIdle(animation,actor2)
		stage = actor2.Length
	elseIf position == 2
		actor3 = sslUtility.PushIdle(animation,actor3)
		stage = actor3.Length
	elseIf position == 3
		actor4 = sslUtility.PushIdle(animation,actor4)
		stage = actor4.Length
	elseIf position == 4
		actor5 = sslUtility.PushIdle(animation,actor5)
		stage = actor5.Length
	else
		debug.trace("----SLAB ERROR sslBaseAnimation AddPositionAnimation() "+name+"--- Unknown actor or stage in "+position)
		return -1
	endIf
	if stage > stages
		stages = stage
	endIf
	return stage
endFunction

function AddExtra(int position, form extra)
	if position == 0
		extras1 = sslUtility.PushForm(extra,extras1)
	elseIf position == 1
		extras2 = sslUtility.PushForm(extra,extras2)
	elseIf position == 2
		extras3 = sslUtility.PushForm(extra,extras3)
	elseIf position == 3
		extras4 = sslUtility.PushForm(extra,extras4)
	elseIf position == 4
		extras5 = sslUtility.PushForm(extra,extras5)
	else
		debug.trace("----SLAB ERROR sslBaseAnimation "+name+" GetOffset(position="+position+") --- Unknown position")
	endIf
endFunction

bool function UseStrapon(int position)
	return !noStrapons[position]
endFunction

function UpdateOffset(int position, float adjust)
	float offset = offsets[position] + adjust
	offsets[position] = offset
endFunction

function UpdateOffsetSide(int position, float adjust)
	float offsetSide = offsetsSide[position] + adjust
	offsetsSide[position] = offsetSide
	debug.trace("Side Adjust "+adjust+" to "+offsetSide)
endFunction

function UpdateOffsetUp(int position, float adjust)
	float offsetUp = offsetsUp[position] + adjust
	offsetsUp[position] = offsetUp
	debug.trace("Up Adjust "+adjust+" to "+offsetUp)
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

bool function AddTag(string tag)
	bool check = HasTag(tag)
	if check
		return false
	else
		int tagCount = tags.Length
		tags = sslUtility.PushString(tag,tags)
		return true
	endIf
endFunction

bool function RemoveTag(string tag)
	bool check = HasTag(tag)
	if !check
		return false
	else
		string[] newTags
		int i = 0
		while i < tags.Length
			if tags[i] != tag
				newTags = sslUtility.PushString(tags[i],newTags)
			endIf
			i += 1
		endWhile
		tags = newTags
		return true
	endIf
endFunction

bool function HasTag(string tag)
	if tags.Find(tag) >= 0 || tag == ""
		return true
	else
		return false
	endIf
endFunction

function RestoreOffsets()
	offsets = offsetsDefault
	offsetsSide = offsetsSideDefault
	offsetsUp = offsetsUpDefault
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
	offsets = none
	offsetsUp = none
	offsetsSide = none
	offsetsDefault = none
	offsetsUpDefault = none
	offsetsSideDefault = none
	rotations = none
	silence = none
	genders = none
	noStrapons = none
	cum = none
	tags = none
	actor1 = none
	actor2 = none
	actor3 = none
	actor4 = none
	actor5 = none
	extras1 = none
	extras2 = none
	extras3 = none
	extras4 = none
	extras5 = none
endFunction