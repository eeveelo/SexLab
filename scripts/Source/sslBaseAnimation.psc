scriptname sslBaseAnimation extends sslBaseObject

; Config
; int property SFX auto hidden
Sound property SoundFX auto hidden

int Actors
int Stages
int Content

; Storage arrays
int[] positions ; = gender, cum
int[] flags ; = silent (bool), openmouth (bool), strapon (bool), schlong offset (int)
float[] Offsets ; = forward, side, up, rotate
float[] timers
float[] CenterAdjust
string[] animations

; StorageUtil legend
; form Key("Creatures") = Valid races for creature animation

; Information
bool property IsSexual hidden
	bool function get()
		return content < 3
	endFunction
endProperty
bool property IsCreature hidden
	bool function get()
		return Genders[2] != 0
	endFunction
endProperty
int property StageCount hidden
	int function get()
		return Stages
	endFunction
endProperty
int property PositionCount hidden
	int function get()
		return Actors
	endFunction
endProperty

int[] property Genders auto hidden
int property Males hidden
	int function get()
		return Genders[0]
	endFunction
endProperty
int property Females hidden
	int function get()
		return Genders[1]
	endFunction
endProperty
int property Creatures hidden
	int function get()
		return Genders[2]
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
;|	Animation Events                             |;
;\-----------------------------------------------/;

string[] function FetchPosition(int position)
	if position > Actors || position < 0
		_Log("Unknown position, '"+stage+"' given", "FetchPosition")
		return none
	endIf
	string[] anims = sslUtility.StringArray(Stages)
	int stage = 0
	while stage <= Stages
		anims[stage] = FetchPositionStage(position, (stage + 1))
		stage += 1
	endWhile
	return anims
endFunction

string function FetchPositionStage(int position, int stage)
	return animations[((position * Stages) + (stage - 1))]
endFunction

string[] function FetchStage(int stage)
	if stage > Stages
		_Log("Unknown stage, '"+stage+"' given", "FetchStage")
		return none
	endIf
	string[] anims = sslUtility.StringArray(Actors)
	int position = 0
	while position < Actors
		anims[position] = FetchPositionStage(position, stage)
		position += 1
	endWhile
	return anims
endFunction

;/-----------------------------------------------\;
;|	Data Accessors                               |;
;\-----------------------------------------------/;

int function DataIndex(int slots, int position, int stage, int slot)
	return ( position * (Stages * slots) ) + ( (stage - 1) * slots ) + slot
endFunction

int function AccessFlag(int position, int stage, int slot)
	return flags[DataIndex(4, position, stage, slot)]
endFunction

int function AccessPosition(int position, int slot)
	return positions[((position * 2) + slot)]
endFunction

bool function HasTimer(int stage)
	return stage > 0 && stage < timers.Length ; && timers[(stage - 1)] != 0.0
endFunction

float function GetTimer(int stage)
	if HasTimer(stage)
		return timers[(stage - 1)]
	endIf
	return 0.0 ; Stage has no timer
endFunction

int[] function GetPositionFlags(int position, int stage)
	int i = DataIndex(4, position, stage, 0)
	int[] Output = new int[5]
	Output[0] = flags[i]
	Output[1] = flags[(i + 1)]
	Output[2] = flags[(i + 2)]
	Output[3] = flags[(i + 3)]
	Output[4] = GetGender(position)
	return Output
endFunction

float[] function GetPositionOffsets(string AdjustKey, int Position, int Stage)
	int i = DataIndex(4, Position, Stage, 0)
	; Get default offsets
	float[] Output = new float[4]
	Output[0] = Offsets[i] + CenterAdjust[(Stage - 1)] ; Forward
	Output[1] = Offsets[(i + 1)] ; Side
	Output[2] = Offsets[(i + 2)] ; Up
	Output[3] = Offsets[(i + 3)] ; Rot
	; Apply adjustments
	if StorageUtil.FloatListCount(Storage, AdjustKey) > i
		Output[0] = Output[0] + StorageUtil.FloatListGet(Storage, AdjustKey, i)
		Output[1] = Output[1] + StorageUtil.FloatListGet(Storage, AdjustKey, (i + 1))
		Output[2] = Output[2] + StorageUtil.FloatListGet(Storage, AdjustKey, (i + 2))
	endIf
	return Output
endFunction

;/-----------------------------------------------\;
;|	Update Offsets                               |;
;\-----------------------------------------------/;

function SetAdjustment(string AdjustKey, int Position, int Stage, int Slot, float Adjustment)
	; Init adjustments
	if StorageUtil.FloatListCount(Storage, AdjustKey) < 1
		int i = Offsets.Length
		while i > StorageUtil.FloatListCount(Storage, AdjustKey)
			StorageUtil.FloatListAdd(Storage, AdjustKey, 0.0)
		endWhile
	endIf
	; Set adjustment at index
	StorageUtil.FloatListSet(Storage, AdjustKey, DataIndex(4, Position, Stage, Slot), Adjustment)
endFunction

float function GetAdjustment(string AdjustKey, int Position, int Stage, int Slot)
	return StorageUtil.FloatListGet(Storage, AdjustKey, DataIndex(4, Position, Stage, Slot))
endFunction

function UpdateAdjustment(string AdjustKey, int Position, int Stage, int Slot, float AdjustBy)
	SetAdjustment(AdjustKey, Position, Stage, Slot, (GetAdjustment(AdjustKey, Position, Stage, Slot) + AdjustBy))
endFunction

function UpdateAdjustmentAll(string AdjustKey, int Position, int Slot, float AdjustBy)
	int Stage = Stages
	while Stage
		SetAdjustment(AdjustKey, Position, Stage, Slot, (GetAdjustment(AdjustKey, Position, Stage, Slot) + AdjustBy))
		Stage -= 1
	endWhile
endFunction

function AdjustForward(string AdjustKey, int Position, int Stage, float AdjustBy, bool AdjustStage = false)
	if AdjustStage
		UpdateAdjustment(AdjustKey, Position, Stage, 0, AdjustBy)
	else
		UpdateAdjustmentAll(AdjustKey, Position, 0, AdjustBy)
	endIf
endFunction

function AdjustSideways(string AdjustKey, int Position, int Stage, float AdjustBy, bool AdjustStage = false)
	if AdjustStage
		UpdateAdjustment(AdjustKey, Position, Stage, 1, AdjustBy)
	else
		UpdateAdjustmentAll(AdjustKey, Position, 1, AdjustBy)
	endIf
endFunction

function AdjustUpward(string AdjustKey, int Position, int Stage, float AdjustBy, bool AdjustStage = false)
	if AdjustStage
		UpdateAdjustment(AdjustKey, Position, Stage, 2, AdjustBy)
	else
		UpdateAdjustmentAll(AdjustKey, Position, 2, AdjustBy)
	endIf
endFunction

function RestoreOffsets(string AdjustKey)
	StorageUtil.FloatListClear(Storage, AdjustKey)
endFunction

;/-----------------------------------------------\;
;|	Animation Info                               |;
;\-----------------------------------------------/;

bool function IsSilent(int position, int stage)
	return AccessFlag(position, stage, 0) as bool
endFunction

bool function UseOpenMouth(int position, int stage)
	return AccessFlag(position, stage, 1) as bool
endFunction

bool function UseStrapon(int position, int stage)
	return AccessFlag(position, stage, 2) as bool
endFunction

int function GetSchlong(int position, int stage)
	return AccessFlag(position, stage, 3)
endFunction

int function ActorCount()
	return Actors
endFunction

int function StageCount()
	return Stages
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
	while i < Actors
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
	while i < Actors
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
	; return sslAnimationLibrary.GetGenderTag(Females, Males, Creatures)
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
;|	Animation Setup                              |;
;\-----------------------------------------------/;

function SetStageTimer(int stage, float timer)
	; Validate stage
	if stage > Stages || stage < 1
		_Log("Unknown animation stage, '"+stage+"' given.", "SetStageTimer")
		return
	endIf
	; Initialize timer array if needed
	if timers.Length != Stages
		timers = sslUtility.FloatArray(Stages)
	endIf
	; Set timer
	timers[(stage - 1)] = timer
endFunction

function Save(int[] posData, string[] animData, float[] offsetData, int[] flagData)
	; Update config data
	positions = posData
	animations = animData
	Offsets = offsetData
	flags = flagData
	Actors = (posData.Length / 2)
	Stages = (animData.Length / Actors)
	; Create and add gender tag
	string GenderTag
	int i
	while i < Actors
		int gender = AccessPosition(i, 0)
		if gender == 0
			GenderTag += "M"
		elseIf gender == 1
			GenderTag += "F"
		elseIf gender == 2
			GenderTag += "C"
		endIf
		i += 1
	endWhile
	AddTag(GenderTag)
	; Init forward offset list
	CenterAdjust = sslUtility.FloatArray(Stages)
	if Actors > 1
		int Stage = Stages
		while Stage
			CenterAdjust[(Stage - 1)] = CalcCenterAdjuster(Stage)
			Stage -= 1
		endWhile
	endIf
endFunction

float function CalcCenterAdjuster(int Stage)
	; Get forward Offsets of all positions + find highest/lowest position
	float Adjuster
	int i = Actors
	while i
		i -= 1
		float Forward = Offsets[DataIndex(4, i, Stage, 0)]
		if Math.Abs(Forward) > Math.Abs(Adjuster)
			Adjuster = Forward
		endIf
	endWhile
	; Get signed half of highest/lowest offset
	Adjuster *= -0.5
	return Adjuster
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
	; StorageUtil.FloatListClear(Storage, Key("Offsets"))
	; StorageUtil.FloatListClear(Storage, Key("Forwards"))
	; StorageUtil.IntListClear(Storage, Key("Positions"))
	; StorageUtil.IntListClear(Storage, Key("Info"))
	StorageUtil.FormListClear(Storage, Key("Creatures"))

	Actors = 0
	Stages = 0
	Content = 0

	Genders = new int[3]
	float[] floatDel1
	timers = floatDel1
	string[] stringDel1
	animations = stringDel1

	parent.Initialize()
endFunction
