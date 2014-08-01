scriptname sslBaseAnimation extends sslBaseObject

import sslUtility

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
string[] RaceIDs
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
		int i = RaceIDs.Length
		form[] RaceRefs = FormArray(i)
		while i
			i -= 1
			RaceRefs[i] = Race.GetRace(RaceIDs[i])
		endWhile
		return ClearNone(RaceRefs)
	endFunction
endProperty

string property Profile hidden
	string function get()
		return "AdjustmentProfile_"+Config.AnimProfile+".json"
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

float[] function GetRawOffsets(int Position, int Stage)
	int i = DataIndex(4, Position, Stage, 0)
	float[] Output = new float[4]
	Output[0] = Offsets[i] ; Forward
	Output[1] = Offsets[(i + 1)] ; Side
	Output[2] = Offsets[(i + 2)] ; Up
	Output[3] = Offsets[(i + 3)] ; Rot
	return Output
endFunction

float[] function GetPositionOffsets(string AdjustKey, int Position, int Stage)
	int i = DataIndex(4, Position, Stage, 0)
	float[] Output = new float[4]
	; Use global adjustments if none for adjustkey
	if JsonUtil.FloatListCount(Profile, AdjustKey) < i
		AdjustKey = Key("Adjust.Global")
	endIf
	; Get adjustments
	JsonUtil.FloatListSlice(Profile, AdjustKey, Output, i)
	; Add default offsets ontop.
	Output[0] = Output[0] + Offsets[i] + CenterAdjust[(Stage - 1)] ; Forward
	Output[1] = Output[1] + Offsets[(i + 1)] ; Side
	Output[2] = Output[2] + Offsets[(i + 2)] ; Up
	Output[3] = Offsets[(i + 3)] ; Rot - no offset
	return Output
endFunction

float[] function GetPositionAdjustments(string AdjustKey, int Position, int Stage)
	int i = DataIndex(4, Position, Stage, 0)
	float[] Output = new float[4]
	JsonUtil.FloatListSlice(Profile, AdjustKey, Output, i)
	return Output
endFunction

; ------------------------------------------------------- ;
; --- Update Offsets                                  --- ;
; ------------------------------------------------------- ;

function SetAdjustment(string AdjustKey, int Position, int Stage, int Slot, float Adjustment)
	JsonUtil.FloatListSet(Profile, AdjustKey, DataIndex(4, Position, Stage, Slot), Adjustment)
endFunction

float function GetAdjustment(string AdjustKey, int Position, int Stage, int Slot)
	return JsonUtil.FloatListGet(Profile, AdjustKey, DataIndex(4, Position, Stage, Slot))
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
	JsonUtil.FloatListClear(Profile, AdjustKey)
endFunction

function InitAdjustments(string AdjustKey)
	int i
	; Init empty Global list - if needed
	string AdjustGlobal = Key("Adjust.Global")
	; Empty sized list for slicing/copying to profile
	float[] Globals = sslUtility.FloatArray(Offsets.Length)
	if JsonUtil.FloatListCount(Profile, AdjustGlobal) < Offsets.Length
		; Set global sos adjustments
		int Stage = 1
		while Stage <= Stages
			int Position = Actors
			while Position
				Position -= 1
				Globals[DataIndex(4, Position, Stage, 3)] = AccessFlag(Position, Stage, 3)
			endWhile
			Stage += 1
		endWhile
		; Copy to list
		JsonUtil.FloatListCopy(Profile, AdjustGlobal, Globals)
	endIf
	; Init AdjustKey list - copied from global list
	string KeyPart = sslUtility.RemoveString(AdjustKey, Key("Adjust."))
	if KeyPart != "Global" && (JsonUtil.StringListFind(Profile, Key("AdjustKeys"), KeyPart) == -1 || JsonUtil.FloatListCount(Profile, AdjustKey) < JsonUtil.FloatListCount(Profile, AdjustGlobal))
		JsonUtil.StringListAdd(Profile, Key("AdjustKeys"), KeyPart, false)
		JsonUtil.FloatListSlice(Profile, AdjustGlobal, Globals)
		JsonUtil.FloatListCopy(Profile, AdjustKey, Globals)
	endIf
endFunction

string function MakeAdjustKey(Actor[] ActorList, bool RaceKey = true)
	if !RaceKey || ActorList.Length != Actors
		return Key("Adjust.Global")
	endIf
	string AdjustKey = Key("Adjust")
	int i
	while i < Actors
		ActorBase BaseRef = ActorList[i].GetLeveledActorBase()
		string RaceID = MiscUtil.GetRaceEditorID(BaseRef.GetRace())
		if IsCreature && GetGender(i) == 2
			AdjustKey += "."+RaceID+"C"
		elseIf BaseRef.GetSex() == 1
			AdjustKey += "."+RaceID+"F"
		else
			AdjustKey += "."+RaceID+"M"
		endIf
		i += 1
	endWhile
	return AdjustKey
endFunction

string[] function GetAdjustKeys()
	int i = JsonUtil.StringListCount(Profile, Key("AdjustKeys"))
	string[] Output = sslUtility.StringArray(i + 1)
	Output[i] = "Global"
	while i
		i -= 1
		Output[i] = JsonUtil.StringListGet(Profile, Key("AdjustKeys"), i)
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
	if i < JsonUtil.FloatListCount(Profile, AdjustKey)
		return JsonUtil.FloatListGet(Profile, AdjustKey, i) as int
	elseIf i < JsonUtil.FloatListCount(Profile, Key("Adjust.Global"))
		return JsonUtil.FloatListGet(Profile, Key("Adjust.Global"), i) as int
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

bool function HasRace(Race RaceRef)
	return HasRaceID(MiscUtil.GetRaceEditorID(RaceRef)) ; FormListFind(Profile, Key("Creatures"), RaceRef) != -1
endFunction

function AddRace(Race RaceRef)
	AddRaceID(MiscUtil.GetRaceEditorID(RaceRef))
endFunction

bool function HasRaceID(string RaceID)
	return RaceID != "" && RaceIDs.Find(RaceID) != -1
endFunction

function AddRaceID(string RaceID)
	if HasRaceID(RaceID) || Race.GetRace(RaceID) == none
		return ; Invalid race form or already added
	endIf
	; Init ID storage
	if RaceIDs.Length < 1
		RaceIDs = new string[5]
	endIf
	; Add to animation
	int i = RaceIDs.Find("")
	if i != -1
		RaceIDs[i] = RaceID
	else
		RaceIDs = sslUtility.PushString(RaceID, RaceIDs)
	endIf
	; Add global
	StorageUtil.StringListAdd(Config, "SexLabCreatures", RaceID, false)
endFunction

function SetRaceIDs(string[] RaceList)
	int i
	while i < RaceList.Length
		if StorageUtil.StringListFind(Config, "SexLabCreatures", RaceList[i]) == -1
			StorageUtil.StringListAdd(Config, "SexLabCreatures", RaceList[i], false)
		endIf
		i += 1
	endWhile
	RaceIDs = RaceList
endFunction

string[] function GetRaceIDs()
	return RaceIDs
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
		RaceIDs = ClearEmpty(RaceIDs)
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
	RaceIDs = StringArray(0)
	Timers  = FloatArray(0)
	parent.Initialize()
endFunction


; JContainers testing

;/int jc
function InitJC()
	; Create SexLab JContainer
	if !JDB.HasPath(".SexLab")
		JDB.SetObj("SexLab", JMap.Object())
		Log("Creating SexLab")
	endIf

	; Create animations JContainer
	int SexLab = JDB.SolveObj(".SexLab")
	Log("SexLab: "+SexLab)
	if !JMap.HasKey(SexLab, Registry)
		JMap.SetObj(SexLab, Registry, JMap.Object())
		Log("Creating "+Registry+" under "+jc, Registry)
	endIf
	jc = JMap.GetObj(SexLab, Registry)
	Log("Got SexLab."+Registry+" under "+jc, Registry)
endFunction

function SetAdjustmentJC(int AdjustKey, int Position, int Stage, int Slot, float Adjustment)
	JArray.SetFlt(AdjustKey, DataIndex(4, Position, Stage, Slot), Adjustment)
endFunction

float function GetAdjustmentJC(int AdjustKey, int Position, int Stage, int Slot)
	return JArray.GetFlt(AdjustKey, DataIndex(4, Position, Stage, Slot))
endFunction

function UpdateAdjustmentJC(int AdjustKey, int Position, int Stage, int Slot, float AdjustBy)
	SetAdjustmentJC(AdjustKey, Position, Stage, Slot, (GetAdjustmentJC(AdjustKey, Position, Stage, Slot) + AdjustBy))
endFunction

function AdjustForwardJC(int AdjustKey, int Position, int Stage, float AdjustBy, bool AdjustStage = false)
	UpdateAdjustmentJC(AdjustKey, Position, Stage, 0, AdjustBy)
endFunction

float[] function GetPositionOffsetsJC(int AdjustKey, int Position, int Stage)
	int i = DataIndex(4, Position, Stage, 0)
	; Get default offsets
	float[] Output = new float[4]
	Output[0] = Offsets[i] + CenterAdjust[(Stage - 1)] ; Forward
	Output[1] = Offsets[(i + 1)] ; Side
	Output[2] = Offsets[(i + 2)] ; Up
	Output[3] = Offsets[(i + 3)] ; Rot
	; Apply adjustments
	Output[0] = Output[0] + JArray.GetFlt(AdjustKey, i)
	Output[1] = Output[1] + JArray.GetFlt(AdjustKey, i + 1)
	Output[2] = Output[2] + JArray.GetFlt(AdjustKey, i + 2)
	return Output
endFunction

string function MakeAdjustKeyJC(Actor[] ActorList, bool RaceKey = true)
	if RaceKey == false || ActorList.Length != Actors
		return "Global"
	endIf
	string AdjustKey = ""
	int i
	while i < Actors
		ActorBase BaseRef = ActorList[i].GetLeveledActorBase()
		string RaceID = MiscUtil.GetRaceEditorID(BaseRef.GetRace())
		if IsCreature && GetGender(i) == 2
			AdjustKey += RaceID+"C"
		elseIf BaseRef.GetSex() == 1
			AdjustKey += RaceID+"F"
		else
			AdjustKey += RaceID+"M"
		endIf
		i += 1
		if i < Actors
			AdjustKey += ";"
		endIf
	endWhile
	return AdjustKey
endFunction

int function GetKey(string RaceKey)
	if !JMap.HasKey(jc, RaceKey)
		JMap.SetObj(jc, RaceKey, JArray.ObjectWithSize(Offsets.Length))
		Log("Creating "+RaceKey+" under "+JMap.GetObj(jc, RaceKey), Name)
	endIf
	return JMap.GetObj(jc, RaceKey)
	; string Path = "."+Registry+"."+RaceKey
	; if !JDB.HasPath(Path)
	; 	JDB.SetObj(Path, JArray.ObjectWithSize(Offsets.Length))
	; 	Log("Creating "+RaceKey+" under "+JDB.SolveObj(Path), Name)
	; endIf
	; return JMap.GetObj(jc, RaceKey)
endFunction/;

