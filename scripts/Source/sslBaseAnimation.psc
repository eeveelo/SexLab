scriptname sslBaseAnimation extends sslBaseObject

import sslUtility
import StorageUtil

; Config
; int property SFX auto hidden
Sound property SoundFX auto hidden

int Actors
int Stages
int Content

; Storage arrays
int[] Positions ; = gender, cum
int[] Flags ; = silent (bool), openmouth (bool), strapon (bool), schlong offset (int)
float[] Offsets ; = forward, side, up, rotate
float[] Timers
float[] CenterAdjust
string[] Animations
int sid
int aid

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
		int i = FormListCount(Storage, Key("Creatures"))
		form[] races = FormArray(i)
		while i
			i -= 1
			races[i] = FormListGet(Storage, Key("Creatures"), i)
		endWhile
		return races
	endFunction
endProperty

; ------------------------------------------------------- ;
; --- Animation Events                                --- ;
; ------------------------------------------------------- ;

string[] function FetchPosition(int position)
	if position > Actors || position < 0
		Log("Unknown position, '"+stage+"' given", "FetchPosition")
		return none
	endIf
	string[] anims = StringArray(Stages)
	int stage = 0
	while stage <= Stages
		anims[stage] = FetchPositionStage(position, (stage + 1))
		stage += 1
	endWhile
	return anims
endFunction

string function FetchPositionStage(int position, int stage)
	return Animations[((position * Stages) + (stage - 1))]
endFunction

string[] function FetchStage(int stage)
	if stage > Stages
		Log("Unknown stage, '"+stage+"' given", "FetchStage")
		return none
	endIf
	string[] anims = StringArray(Actors)
	int position = 0
	while position < Actors
		anims[position] = FetchPositionStage(position, stage)
		position += 1
	endWhile
	return anims
endFunction

; ------------------------------------------------------- ;
; --- Data Accessors                                  --- ;
; ------------------------------------------------------- ;

int function DataIndex(int Slots, int Position, int Stage, int Slot)
	return ( Position * (Stages * Slots) ) + ( (Stage - 1) * Slots ) + Slot
endFunction

int function AccessFlag(int Position, int Stage, int Slot)
	return Flags[DataIndex(4, Position, Stage, Slot)]
endFunction

int function AccessPosition(int Position, int Slot)
	return Positions[((Position * 2) + Slot)]
endFunction

bool function HasTimer(int Stage)
	return Stage > 0 && Stage < Timers.Length ; && Timers[(Stage - 1)] != 0.0
endFunction

float function GetTimer(int Stage)
	if HasTimer(Stage)
		return Timers[(Stage - 1)]
	endIf
	return 0.0 ; Stage has no timer
endFunction

int[] function GetPositionFlags(string AdjustKey, int Position, int Stage)
	int i = DataIndex(4, Position, Stage, 0)
	int[] Output = new int[5]
	Output[0] = Flags[i]
	Output[1] = Flags[(i + 1)]
	Output[2] = Flags[(i + 2)]
	Output[3] = GetSchlong(AdjustKey, Position, Stage)
	Output[4] = GetGender(Position)
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
	; Use global adjustments if none for adjustkey
	if FloatListCount(Storage, AdjustKey) < i
		AdjustKey = Key("Adjust.Global")
	endIf
	; Apply adjustments
	Output[0] = Output[0] + FloatListGet(Storage, AdjustKey, i)
	Output[1] = Output[1] + FloatListGet(Storage, AdjustKey, (i + 1))
	Output[2] = Output[2] + FloatListGet(Storage, AdjustKey, (i + 2))
	return Output
endFunction

float[] function GetPositionAdjustments(string AdjustKey, int Position, int Stage)
	int i = DataIndex(4, Position, Stage, 0)
	float[] Output = new float[4]
	Output[0] = FloatListGet(Storage, AdjustKey, i) ; Forward
	Output[1] = FloatListGet(Storage, AdjustKey, (i + 1)) ; Side
	Output[2] = FloatListGet(Storage, AdjustKey, (i + 2)) ; Up
	Output[3] = FloatListGet(Storage, AdjustKey, (i + 3)) ; SOS
	return Output
endFunction

; ------------------------------------------------------- ;
; --- Update Offsets                                  --- ;
; ------------------------------------------------------- ;

function SetAdjustment(string AdjustKey, int Position, int Stage, int Slot, float Adjustment)
	FloatListSet(Storage, AdjustKey, DataIndex(4, Position, Stage, Slot), Adjustment)
endFunction

float function GetAdjustment(string AdjustKey, int Position, int Stage, int Slot)
	return FloatListGet(Storage, AdjustKey, DataIndex(4, Position, Stage, Slot))
endFunction

function UpdateAdjustment(string AdjustKey, int Position, int Stage, int Slot, float AdjustBy)
	InitAdjustments(AdjustKey)
	SetAdjustment(AdjustKey, Position, Stage, Slot, (GetAdjustment(AdjustKey, Position, Stage, Slot) + AdjustBy))
endFunction

function UpdateAdjustmentAll(string AdjustKey, int Position, int Slot, float AdjustBy)
	InitAdjustments(AdjustKey)
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
	FloatListClear(Storage, AdjustKey)
endFunction

function InitAdjustments(string AdjustKey)
	int i
	; Init empty Global list - if needed
	string AdjustGlobal = Key("Adjust.Global")
	if FloatListCount(Storage, AdjustGlobal) < Offsets.Length
		; Empty existing global as precaution and zero fill it
		FloatListClear(Storage, AdjustGlobal)
		i = Offsets.Length
		while i
			i -= 1
			FloatListAdd(Storage, AdjustGlobal, 0.0)
		endWhile
		; Set global sos adjustments
		int Stage = 1
		while Stage <= Stages
			int Position = Actors
			while Position
				Position -= 1
				FloatListSet(Storage, AdjustGlobal, DataIndex(4, Position, Stage, 3), AccessFlag(Position, Stage, 3))
				Log(Position+" / "+Stage+" -> "+DataIndex(4, Position, Stage, 3)+" == "+AccessFlag(Position, Stage, 3))
			endWhile
			Stage += 1
		endWhile
	endIf
	; Init AdjustKey list - copied from global list
	string KeyPart = sslUtility.RemoveString(AdjustKey, Key("Adjust."))
	if KeyPart != "Global" && (StringListFind(Storage, Key("AdjustKeys"), KeyPart) == -1 || FloatListCount(Storage, AdjustKey) < FloatListCount(Storage, AdjustGlobal))
		FloatListClear(Storage, AdjustKey)
		StringListAdd(Storage, Key("AdjustKeys"), KeyPart, false)
		i = 0
		while i < FloatListCount(Storage, AdjustGlobal)
			FloatListAdd(Storage, AdjustKey, FloatListGet(Storage, AdjustGlobal, i))
			i += 1
		endWhile
		Log("Init Adjustments for: "+KeyPart, AdjustKey)
	endIf
	Log(AdjustKey+" Length: "+FloatListCount(Storage, AdjustKey), AdjustGlobal+" Length: "+FloatListCount(Storage, AdjustGlobal))
endFunction

string function MakeAdjustKey(Actor[] ACtorList, bool RaceKey = true)
	if RaceKey == false || ActorList.Length != Actors
		return Key("Adjust.Global")
	endIf
	string AdjustKey = Key("Adjust")
	int i
	while i < Actors
		ActorBase BaseRef = ACtorList[i].GetLeveledActorBase()
		Race RaceRef = BaseRef.GetRace()
		AdjustKey += "."+MiscUtil.GetRaceEditorID(RaceRef)
		if HasRace(RaceRef)
			; No gender preference for creatures
		elseIf BaseRef.GetSex() == 1
			AdjustKey += "F"
		else
			AdjustKey += "M"
		endIf
		i += 1
	endWhile
	return AdjustKey
endFunction

string[] function GetAdjustKeys()
	int i = StringListCount(Storage, Key("AdjustKeys"))
	string[] Output = sslUtility.StringArray(i + 1)
	Output[i] = "Global"
	while i
		i -= 1
		Output[i] = StringListGet(Storage, Key("AdjustKeys"), i)
	endWhile
	return Output
endFunction

; ------------------------------------------------------- ;
; --- Animation Info                                  --- ;
; ------------------------------------------------------- ;

bool function IsSilent(int Position, int Stage)
	return AccessFlag(Position, Stage, 0) as bool
endFunction

bool function UseOpenMouth(int Position, int Stage)
	return AccessFlag(Position, Stage, 1) as bool
endFunction

bool function UseStrapon(int Position, int Stage)
	return AccessFlag(Position, Stage, 2) as bool
endFunction

int function GetSchlong(string AdjustKey, int Position, int Stage)
	int i = DataIndex(4, Position, Stage, 3)
	if i < FloatListCount(Storage, AdjustKey)
		return FloatListGet(Storage, AdjustKey, i) as int
	elseIf i < FloatListCount(Storage, Key("Adjust.Global"))
		return FloatListGet(Storage, Key("Adjust.Global"), i) as int
	endIf
	return AccessFlag(Position, Stage, 3)
endFunction

int function ActorCount()
	return Actors
endFunction

int function StageCount()
	return Stages
endFunction

int function GetGender(int Position)
	return AccessPosition(Position, 0)
endFunction

bool function MalePosition(int Position)
	return AccessPosition(Position, 0) == 0
endFunction

bool function FemalePosition(int Position)
	return AccessPosition(Position, 0) == 1
endFunction

bool function CreaturePosition(int Position)
	return AccessPosition(Position, 0) == 2
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

int function GetCum(int Position)
	return AccessPosition(Position, 1)
endFunction

bool function IsSexual()
	return IsSexual
endFunction

function SetContent(int contentType)
	content = contentType
endFunction

; ------------------------------------------------------- ;
; --- Creature Use                                    --- ;
; ------------------------------------------------------- ;

bool function HasRace(Race CreatureRace)
	return FormListFind(Storage, Key("Creatures"), CreatureRace) != -1
endFunction

function AddRace(Race CreatureRace)
	FormListAdd(Storage, Key("Creatures"), CreatureRace, false)
	SetIntValue(CreatureRace, "SexLab.HasCreature", 1)
	if Enabled
		FormListAdd(none, "SexLab.CreatureRaces", CreatureRace, true)
	endIf
endFunction

; ------------------------------------------------------- ;
; --- Animation Setup                                 --- ;
; ------------------------------------------------------- ;

function SetStageTimer(int stage, float timer)
	; Validate stage
	if stage > Stages || stage < 1
		Log("Unknown animation stage, '"+stage+"' given.", "SetStageTimer")
		return
	endIf
	; Initialize timer array if needed
	if Timers.Length != Stages
		Timers = FloatArray(Stages)
	endIf
	; Set timer
	Timers[(stage - 1)] = timer
endFunction

int function AddPosition(int Gender = 0, int AddCum = -1)
	; Record gender
	Genders[Gender] = Genders[Gender] + 1
	; Save position data
	int pid = (Actors * 2)
	Positions[pid + 0] = Gender
	Positions[pid + 1] = AddCum
	Actors += 1
	return (Actors - 1)
endFunction

function AddPositionStage(int Position, string AnimationEvent, float forward = 0.0, float side = 0.0, float up = 0.0, float rotate = 0.0, bool silent = false, bool openMouth = false, bool strapon = true, int sos = 0)
	Animations[aid] = AnimationEvent
	aid += 1

	Offsets[sid + 0] = forward
	Offsets[sid + 1] = side
	Offsets[sid + 2] = up
	Offsets[sid + 3] = rotate

	Flags[sid + 0] = silent as int
	Flags[sid + 1] = openMouth as int
	Flags[sid + 2] = strapon as int
	Flags[sid + 3] = sos

	sid += 4
endFunction

function Save(int id)
	; Finalize config data
	Flags      = TrimIntArray(Flags, sid)
	Offsets    = TrimFloatArray(Offsets, sid)
	Positions  = TrimIntArray(Positions, (Actors * 2))
	Animations = TrimStringArray(Animations, aid)
	Stages     = Animations.Length / Actors
	; Create and add gender tag
	string Tag
	int i
	while i < Actors
		int Gender = AccessPosition(i, 0)
		if Gender == 0
			Tag += "M"
		elseIf Gender == 1
			Tag += "F"
		elseIf Gender == 2
			Tag += "C"
		endIf
		i += 1
	endWhile
	AddTag(Tag)
	; Init forward offset list
	CenterAdjust = FloatArray(Stages)
	if Actors > 1
		int Stage = Stages
		while Stage
			CenterAdjust[(Stage - 1)] = CalcCenterAdjuster(Stage)
			Stage -= 1
		endWhile
	endIf
	; Log the new animation
	if IsCreature
		Log(Name, "Creatures["+id+"]")
	else
		Log(Name, "Animations["+id+"]")
	endIf
endFunction

float function CalcCenterAdjuster(int Stage)
	; Get forward Offsets of all Positions + find highest/lowest position
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

; ------------------------------------------------------- ;
; --- System Use                                      --- ;
; ------------------------------------------------------- ;

function Initialize()
	Actors  = 0
	Stages  = 0
	Content = 0
	sid     = 0
	aid     = 0
	Genders    = new int[3]
	Positions  = new int[10]
	Flags      = new int[128]
	Offsets    = new float[128]
	Animations = new string[128]
	float[] floatDel1
	Timers = floatDel1
	FormListClear(Storage, Key("Creatures"))
	parent.Initialize()
endFunction

function SaveProfile(int SaveTo = 1)
	if Registered
		SaveTo = ClampInt(SaveTo, 1, 5)
		if FloatListCount(Storage, Key("Adjust.Global")) > 0 || StringListCount(Storage, Key("AdjustKeys")) > 0
			ExportFile("AnimationProfile_"+SaveTo+".json", Key("AdjustKeys"), 64)
			ExportFile("AnimationProfile_"+SaveTo+".json", Key("Adjust."), 32, keyContains = true)
		endIf
	endIf
endFunction

function LoadProfile(int Profile = 1)
	if Registered
		Profile = ClampInt(Profile, 1, 5)
		; Clear current global
		if FloatListCount(Storage, Key("Adjust.Global")) > 0
			FloatListClear(Storage, Key("Adjust.Global"))
		endIf
		; Clear current race/gender adjustments
		int i = StringListCount(Storage, Key("AdjustKeys"))
		while i
			i -= 1
			FloatListClear(Storage, Key("Adjust."+StringListGet(Storage, Key("AdjustKeys"), i)))
		endwhile
		FloatListClear(Storage, Key("AdjustKeys"))
		; Load the profile
		ImportFile("AnimationProfile_"+Profile+".json", Key("AdjustKeys"), 64)
		ImportFile("AnimationProfile_"+Profile+".json", Key("Adjust."), 32, keyContains = true)
	endIf
endFunction

