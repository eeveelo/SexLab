scriptname sslBaseAnimation extends sslBaseObject

; import sslUtility
import PapyrusUtil

; Config
; int property SFX auto hidden
Sound property SoundFX hidden
	Sound function get()
		return StageSoundFX[0] as Sound
	endFunction
	function set(Sound var)
		StageSoundFX[0] = var as Form
	endFunction
endProperty
Form[] StageSoundFX

int Actors
int Stages

; Storage arrays
string LastKey
string[] Animations
string[] RaceIDs
float[] Timers
float[] CenterAdjust
float[] Offsets   ; = forward, side, up, rotate
float[] BedOffset ; = forward, side, up, rotate
int[] Positions   ; = gender, cum
int[] Flags       ; = silent (bool), openmouth (bool), strapon (bool), schlong offset (int)

int[] Flags0
int[] Flags1
int[] Flags2
int[] Flags3
int[] Flags4

int sid
int aid

; Information
bool property IsSexual hidden
	bool function get()
		return HasTag("Sex") || HasTag("Vaginal") || HasTag("Anal") || HasTag("Oral")
	endFunction
endProperty
bool property IsCreature hidden
	bool function get()
		return Genders[2] != 0
	endFunction
endProperty

bool property IsVaginal hidden
	bool function get()
		return HasTag("Vaginal")
	endFunction
endProperty
bool property IsAnal hidden
	bool function get()
		return HasTag("Anal")
	endFunction
endProperty
bool property IsOral hidden
	bool function get()
		return HasTag("Oral")
	endFunction
endProperty
bool property IsDirty hidden
	bool function get()
		return HasTag("Dirty")
	endFunction
endProperty
bool property IsLoving hidden
	bool function get()
		return HasTag("Loving")
	endFunction
endProperty

; Animation handling tags
bool property IsBedOnly hidden
	bool function get()
		return HasTag("BedOnly")
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
		form[] RaceRefs
		while i
			i -= 1
			RaceRefs = PushForm(RaceRefs, Race.GetRace(RaceIDs[i]))
		endWhile
		return ClearNone(RaceRefs)
	endFunction
endProperty

string property Profile hidden
	string function get()
		return "../SexLab/AnimationProfile_"+Config.AnimProfile+".json"
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
	string[] anims = Utility.CreateStringArray(Stages)
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
	string[] anims = Utility.CreateStringArray(Actors)
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

int function DataIndex(int Slots, int Position, int Stage, int Slot = 0)
	return ( Position * (Stages * Slots) ) + ( (Stage - 1) * Slots ) + Slot
endFunction

int function AdjIndex(int Stage, int Slot = 0, int Slots = 4)
	return ((Stage - 1) * Slots) + Slot
endfunction

int function AccessFlag(int Position, int Stage, int Slot)
	return Flags[DataIndex(4, Position, Stage, Slot)]
endFunction

int function AccessPosition(int Position, int Slot)
	return Positions[((Position * 2) + Slot)]
endFunction

bool function HasTimer(int Stage)
	return Stage > 0 && Stage <= Timers.Length && Timers[(Stage - 1)] != 0.0
endFunction

float function GetTimer(int Stage)
	if !HasTimer(Stage)
		return 0.0 ; Stage has no timer
	endIf
	return Timers[(Stage - 1)]
endFunction

Sound function GetSoundFX(int Stage)
	if Stage < 1 || Stage > StageSoundFX.Length
		return StageSoundFX[0] as Sound
	endIf
	return StageSoundFX[(Stage - 1)] as Sound
endFunction

int[] function GetPositionFlags(string AdjustKey, int Position, int Stage)
	int[] Output = new int[5]
	return PositionFlags(Output, AdjustKey, Position, Stage)
endFunction

float[] function GetPositionOffsets(string AdjustKey, int Position, int Stage)
	float[] Output = new float[4]
	return PositionOffsets(Output, AdjustKey, Position, Stage)
endFunction

float[] function GetRawOffsets(int Position, int Stage)
	float[] Output = new float[4]
	return RawOffsets(Output, Position, Stage)
endFunction

float[] function GetPositionAdjustments(string AdjustKey, int Position, int Stage)
	float[] Output = new float[4]
	return PositionAdjustments(Output, AdjustKey, Position, Stage)
endFunction

;float[] function _GetAllAdjustments(string sProfile, string sRegistry, string sAdjustKey) global native
float[] function GetAllAdjustments(string AdjustKey)
	float[] Output = Utility.CreateFloatArray((Stages * 4))
	JsonUtil.FloatListSlice(Profile, AdjustKey, Output)
	return Output
endFunction

; ------------------------------------------------------- ;
; --- Data Copy To                                    --- ;
; ------------------------------------------------------- ;

int[] function PositionFlags(int[] Output, string AdjustKey, int Position, int Stage)
	AdjustKey += "."+Position
	int i = DataIndex(4, Position, Stage)
	Output[0] = Flags[i]
	Output[1] = Flags[(i + 1)]
	Output[2] = Flags[(i + 2)]
	Output[3] = GetSchlong(AdjustKey, Position, Stage)
	Output[4] = GetGender(Position)
	return Output
endFunction

float[] function PositionOffsets(float[] Output, string AdjustKey, int Position, int Stage)
	int i = DataIndex(4, Position, Stage)
	int n = AdjIndex(Stage)
	; Check if we have any offsets
	AdjustKey += "."+Position
	if JsonUtil.FloatListCount(Profile, AdjustKey) < n
		AdjustKey = LastKey+"."+Position
	endIf
	; Reset the array values
	Output[0] = 0.0
	Output[1] = 0.0
	Output[2] = 0.0
	Output[3] = 0.0
	; Get adjustkey's adjustments
	JsonUtil.FloatListSlice(Profile, AdjustKey, Output, n)
	Output[0] = Output[0] + Offsets[i] + CenterAdjust[(Stage - 1)] ; Forward
	Output[1] = Output[1] + Offsets[(i + 1)] ; Side
	Output[2] = Output[2] + Offsets[(i + 2)] ; Up
	Output[3] = Offsets[(i + 3)] ; Rot - no offset
	return Output
endFunction

float[] function RawOffsets(float[] Output, int Position, int Stage)
	int i = DataIndex(4, Position, Stage)
	Output[0] = Offsets[i] ; Forward
	Output[1] = Offsets[(i + 1)] ; Side
	Output[2] = Offsets[(i + 2)] ; Up
	Output[3] = Offsets[(i + 3)] ; Rot
	return Output
endFunction

float[] function PositionAdjustments(float[] Output, string AdjustKey, int Position, int Stage)
	if JsonUtil.FloatListCount(Profile, AdjustKey+"."+Position) > AdjIndex(Stage, 3)
		JsonUtil.FloatListSlice(Profile, AdjustKey+"."+Position, Output, AdjIndex(Stage))
	else
		Output[3] = GetSchlong(AdjustKey, Position, Stage)
	endIf
	return Output
endFunction

; ------------------------------------------------------- ;
; --- Update Offsets                                  --- ;
; ------------------------------------------------------- ;

function SetAdjustment(string AdjustKey, int Position, int Stage, int Slot, float Adjustment)
	if Position < Actors
		InitAdjustments(AdjustKey, Position)
		JsonUtil.FloatListSet(Profile, AdjustKey+"."+Position, AdjIndex(Stage, Slot), Adjustment)
	endIf
endFunction

float function GetAdjustment(string AdjustKey, int Position, int Stage, int Slot)
	return JsonUtil.FloatListGet(Profile, AdjustKey+"."+Position, AdjIndex(Stage, Slot))
endFunction

function UpdateAdjustment(string AdjustKey, int Position, int Stage, int Slot, float AdjustBy)
	if Position < Actors
		InitAdjustments(AdjustKey, Position)
		JsonUtil.FloatListAdjust(Profile, AdjustKey+"."+Position, AdjIndex(Stage, Slot), AdjustBy)
		sslBaseAnimation._AdjustOffset("DevProfile_1.json", Registry, sslUtility.RemoveString(AdjustKey+"."+Position, Key("")), Stage, Slot, AdjustBy)
	endIf
endFunction

function UpdateAdjustmentAll(string AdjustKey, int Position, int Slot, float AdjustBy)
	if Position < Actors
		InitAdjustments(AdjustKey, Position)
		int Stage = Stages
		while Stage
			JsonUtil.FloatListAdjust(Profile, AdjustKey+"."+Position, AdjIndex(Stage, Slot), AdjustBy)
			sslBaseAnimation._AdjustOffset("DevProfile_1.json", Registry, sslUtility.RemoveString(AdjustKey+"."+Position, Key("")), Stage, Slot, AdjustBy)
			Stage -= 1
		endWhile
	endIf
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
	JsonUtil.FloatListClear(Profile, AdjustKey+".0")
	JsonUtil.FloatListClear(Profile, AdjustKey+".1")
	JsonUtil.FloatListClear(Profile, AdjustKey+".2")
	JsonUtil.FloatListClear(Profile, AdjustKey+".3")
	JsonUtil.FloatListClear(Profile, AdjustKey+".4")
endFunction

function InitAdjustments(string AdjustKey, int Position)
	int i = AdjIndex(Stages, 3)
	if JsonUtil.FloatListCount(Profile, AdjustKey+"."+Position) <= i
		float[] Adjusts = Utility.CreateFloatArray((Stages * 4))
		if JsonUtil.FloatListCount(Profile, LastKey+"."+Position) == Adjusts.Length; && JsonUtil.StringListCount(Profile, Registry) > 0
			Log("CopyKey ["+LastKey+"] -> ["+AdjustKey+"]")
			JsonUtil.FloatListSlice(Profile, LastKey+"."+Position, Adjusts)
		else
			int n = Stages
			while n > 0
				Adjusts[AdjIndex(n, 3)] = AccessFlag(Position, n, 3)
				n -= 1
			endWhile
		endIf
		; Save initialized array.
		string KeyPart = sslUtility.RemoveString(AdjustKey, Key(""))
		JsonUtil.FloatListCopy(Profile, AdjustKey+"."+Position, Adjusts)
		if KeyPart != "Global"
			JsonUtil.StringListAdd(Profile, "Adjusted", Registry, false)
			JsonUtil.StringListAdd(Profile, Registry, KeyPart, false)
		endIf
	endIf
	LastKey = AdjustKey
endFunction

string function MakeAdjustKey(Actor[] ActorList, bool RaceKey = true)
	if !RaceKey || ActorList.Length != Actors
		return Key("Global")
	endIf
	string AdjustKey = Registry
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
	string[] Output = new string[1]
	Output[0] = "Global"
	string[] AdjustKeys = JsonUtil.StringListToArray(Profile, Registry)
	if(AdjustKeys.Length > 0)
		Output = PapyrusUtil.MergeStringArray(Output, AdjustKeys)
	endIf
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
	int i = AdjIndex(Stage, 3)
	if i < JsonUtil.FloatListCount(Profile, AdjustKey)
		return JsonUtil.FloatListGet(Profile, AdjustKey, i) as int
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
	; No longer used
endFunction

float function GetTimersRunTime(float[] StageTimers)
	if StageTimers.Length < 2
		return -1.0
	endIf
	float seconds  = 0.0
	int LastTimer  = (StageTimers.Length - 1)
	int LastStage  = (StageCount - 1)
	int Stage = StageCount
	while Stage > 0
 		Stage -= 1
 		if HasTimer(Stage)
 			seconds += GetTimer(Stage)
 		elseIf Stage < LastStage
 			seconds += StageTimers[ClampInt(Stage, 0, (LastTimer - 1))]
 		elseIf Stage >= LastStage
 			seconds += StageTimers[LastTimer]
 		endIf
	endWhile
	return seconds
endFunction

float function GetRunTime()
	return GetTimersRunTime(Config.StageTimer)
endFunction

float function GetRunTimeLeadIn()
	return GetTimersRunTime(Config.StageTimerLeadIn)
endFunction

float function GetRunTimeAggressive()
	return GetTimersRunTime(Config.StageTimerAggr)
endFunction

function SetBedOffsets(float forward, float sideward, float upward, float rotate)
	BedOffset = new float[4]
	BedOffset[0] = forward
	BedOffset[1] = sideward
	BedOffset[2] = upward
	BedOffset[3] = rotate
endFunction

float[] function GetBedOffsets()
	return BedOffset
endFunction

; ------------------------------------------------------- ;
; --- Creature Use                                    --- ;
; ------------------------------------------------------- ;

bool function HasActorRace(Actor ActorRef)
	return HasRaceID(MiscUtil.GetActorRaceEditorID(ActorRef))
endFunction

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
		RaceIDs = PushString(RaceIDs, RaceID)
	endIf
	; Add global
	StorageUtil.StringListAdd(Config, "SexLabCreatures", RaceID, false)
endFunction

function SetRaceIDs(string[] RaceList)
	int i
	while i < RaceList.Length
		StorageUtil.StringListAdd(Config, "SexLabCreatures", RaceList[i], false)
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

function SetStageSoundFX(int stage, Sound StageFX)
	; Validate stage
	if stage > Stages || stage < 1
		Log("Unknown animation stage, '"+stage+"' given.", "SetStageSound")
		return
	endIf
	; Initialize fx array if needed
	if StageSoundFX.Length != Stages
		StageSoundFX = ResizeFormArray(StageSoundFX, Stages, SoundFX)
	endIf
	; Set Stage fx
	StageSoundFX[(stage - 1)] = StageFX
endFunction

function SetStageTimer(int stage, float timer)
	; Validate stage
	if stage > Stages || stage < 1
		Log("Unknown animation stage, '"+stage+"' given.", "SetStageTimer")
		return
	endIf
	; Initialize timer array if needed
	if Timers.Length != Stages
		Timers = Utility.CreateFloatArray(Stages)
	endIf
	; Set timer
	Timers[(stage - 1)] = timer
endFunction

int function AddPosition(int Gender = 0, int AddCum = -1)
	Genders[Gender] = Genders[Gender] + 1
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

	Flags[sid + 0]   = silent as int
	Flags[sid + 1]   = openMouth as int
	Flags[sid + 2]   = strapon as int
	Flags[sid + 3]   = sos
	sid += 4

	Stages += (Position == 0) as int
endFunction

function Save(int id = -1)
	; Finalize config data
	Flags      = ResizeIntArray(Flags, sid)
	Offsets    = ResizeFloatArray(Offsets, sid)
	Positions  = ResizeIntArray(Positions, (Actors * 2))
	Animations = ResizeStringArray(Animations, aid)
	RaceIDs    = ClearEmpty(RaceIDs)
	LastKey    = Key("Global")
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
	CenterAdjust = Utility.CreateFloatArray(Stages)
	if Actors > 1
		int Stage = Stages
		while Stage
			CenterAdjust[(Stage - 1)] = CalcCenterAdjuster(Stage)
			Stage -= 1
		endWhile
	endIf
	; Log the new animation
	SlotID = id
	if IsCreature
		Log(Name, "Creatures["+id+"]")
	else
		Log(Name, "Animations["+id+"]")
	endIf
endFunction

float function CalcCenterAdjuster(int Stage)
	; Get forward Offsets of all Positions + find highest/lowest position
	float Adjuster
	int Position = Actors
	while Position
		Position -= 1
		float Forward = Offsets[DataIndex(4, Position, Stage)]
		if Math.Abs(Forward) > Math.Abs(Adjuster)
			Adjuster = Forward
		endIf
	endWhile
	; Get signed half of highest/lowest offset
	return Adjuster * -0.5
endFunction

; ------------------------------------------------------- ;
; --- System Use                                      --- ;
; ------------------------------------------------------- ;

function Initialize()
	sid          = 0
	aid          = 0
	Actors       = 0
	Stages       = 0
	LastKey      = ""
	Genders      = new int[3]
	Positions    = new int[10]
	Flags        = new int[120]
	Animations   = new string[30]
	Offsets      = new float[120]

	BedOffset    = new float[4]
	BedOffset[0] = 33.0
	BedOffset[2] = 37.0

	Timers       = new float[1]
	RaceIDs      = new string[1]
	StageSoundFX = new Form[1]

	parent.Initialize()
endFunction

function _Update_Profile_159c(string ProfilePath)
	_Update_AdjustKey_159c(ProfilePath, "Global")
	JsonUtil.FloatListClear(ProfilePath, Key("Adjust.Global"))
	string KeysList = Key("AdjustKeys")
	int i = JsonUtil.StringListCount(ProfilePath, KeysList)
	while i
		i -= 1
		string AdjustKey = JsonUtil.StringListGet(ProfilePath, KeysList, i)
		if AdjustKey != "" && _Update_AdjustKey_159c(ProfilePath, AdjustKey)
			float[] OldAdjust = new float[4]
			float[] NewAdjust = new float[4]
			JsonUtil.FloatListSlice(ProfilePath, Key("Adjust."+AdjustKey), OldAdjust, DataIndex(4, 0, 2, 0))
			JsonUtil.FloatListSlice(ProfilePath, Key(AdjustKey+".0"), NewAdjust, DataIndex(4, 0, 2, 0))
			if OldAdjust[0] != NewAdjust[0] || OldAdjust[1] != NewAdjust[1] || OldAdjust[2] != NewAdjust[2] || OldAdjust[3] != NewAdjust[3]
				Log(OldAdjust+" != "+NewAdjust, Registry+"."+AdjustKey+" - ERROR")
			endIf
		endIf
		JsonUtil.FloatListClear(ProfilePath, Key("Adjust."+AdjustKey))
	endWhile
	JsonUtil.StringListClear(ProfilePath, KeysList)
endFunction

bool function _Update_AdjustKey_159c(string ProfilePath, string AdjustKey)
	bool Adjusted = false
	if JsonUtil.FloatListCount(ProfilePath, Key("Adjust."+AdjustKey)) > 0
		string OldKey = Key("Adjust."+AdjustKey)
		int Position
		while Position < Actors
			bool HasAdjustments = false
			float[] Adjustments = Utility.CreateFloatArray((Stages*4))
			int Stage = 0
			while Stage < Stages
				Stage += 1
				int i = (Stage - 1) * 4
				int old_i = DataIndex(4, Position, Stage, 0)
				Adjustments[(i+0)] = JsonUtil.FloatListGet(ProfilePath, OldKey, (old_i+0))
				Adjustments[(i+1)] = JsonUtil.FloatListGet(ProfilePath, OldKey, (old_i+1))
				Adjustments[(i+2)] = JsonUtil.FloatListGet(ProfilePath, OldKey, (old_i+2))
				Adjustments[(i+3)] = JsonUtil.FloatListGet(ProfilePath, OldKey, (old_i+3))
				if Adjustments[(i+0)] != 0.0 || Adjustments[(i+1)] != 0.0 || Adjustments[(i+2)] != 0.0 || Adjustments[(i+3)] != AccessFlag(Position, Stage, 3)
					HasAdjustments = true
				endIf
			endWhile
			string NewKey = Key(AdjustKey+"."+Position)
			if !HasAdjustments
				JsonUtil.FloatListClear(ProfilePath, NewKey)
			else
				Adjusted = true
				JsonUtil.FloatListCopy(ProfilePath, NewKey, Adjustments)
			endIf
			Position += 1
		endWhile
	endIf
	if Adjusted && AdjustKey != "Global"
		JsonUtil.StringListAdd(ProfilePath, "Adjusted", Registry, false)
		JsonUtil.StringListAdd(ProfilePath, Registry, AdjustKey, false)
	endIf
	return Adjusted
endFunction

function _SetAdjustment(string profile, string registry, string racekey, int stage, int nth, float value) global native
float function _AdjustOffset(string profile, string registry, string racekey, int stage, int nth, float by) global native
bool function _SaveProfile(string profile) global native
float[] function _GetStageAdjustments(string profile, string registry, string racekey, int stage) global native
float[] function _GetAllAdjustments(string profile, string registry, string racekey) global native

; float[] function GetAllOffsets(string AdjustKey, int Position)
; 	float[] Output = FloatArray((Stages * 4))
; 	AdjustKey += "."+Position
; 	if JsonUtil.FloatListCount(Profile, AdjustKey) < Output.Length
; 		AdjustKey = StorageUtil.GetStringValue(Storage, Key("LastKey"), Key("Global"))+"."+Position
; 	endIf
; 	JsonUtil.FloatListSlice(Profile, AdjustKey, Output)
; 	GetAllPositionOffsets(Output, Offsets, CenterAdjust, Position, Stages)
; 	return Output
; endfunction
; function GetAllPositionOffsets(float[] Adjusts, float[] Offset, float[] Forward, int Position, int StageCount) global native

; ; ------------------------------------------------------- ;
; ; --- Tagging System                                  --- ;
; ; ------------------------------------------------------- ;

; bool function AddTag(string Tag) native
; bool function HasTag(string Tag) native
; bool function RemoveTag(string Tag) native
; bool function ToggleTag(string Tag) native
; bool function AddTagConditional(string Tag, bool AddTag) native
; bool function ParseTags(string[] TagList, bool RequireAll = true) native
; bool function CheckTags(string[] CheckTags, bool RequireAll = true, bool Suppress = false) native
; bool function HasOneTag(string[] TagList) native
; bool function HasAllTag(string[] TagList) native

; function AddTags(string[] TagList)
; 	int i = TagList.Length
; 	while i
; 		i -= 1
; 		AddTag(TagList[i])
; 	endWhile
; endFunction

; int function TagCount() native
; string function GetNthTag(int i) native
; function TagSlice(string[] Ouput) native

; string[] function GetTags()
; 	int i = TagCount()
; 	Log(Registry+" - TagCount: "+i)
; 	if i < 1
; 		return sslUtility.StringArray(0)
; 	endIf
; 	string[] Output = sslUtility.StringArray(i)
; 	TagSlice(Output)
; 	Log(Registry+" - SKSE Tags: "+Output)
; 	return Output
; endFunction

; function RevertTags() native



; function LoadObj(string kReg, string kName) native global
; function SaveObj(string kReg) native global
; function _AddTag(string kReg, string kTag) native global
; function _AddTags(string kReg, string[] kTags) native global
; function _RemoveTag(string kReg, string kTag) native global
; int function _FindTag(string kReg, string kTag) native global
; bool function _HasTag(string kReg, string kTag) native global

; bool function HasTag(string Tag)
; 	return _HasTag(Registry, Tag)
; endFunction

; bool function AddTag(string Tag)
; 	_AddTag(Registry, Tag)
; 	return parent.AddTag(Tag)
; endFunction

; function AddTags(string[] TagList)
; 	_AddTags(Registry, TagList)
; 	parent.AddTags(TagList)
; endFunction

; bool function RemoveTag(string Tag)
; 	_RemoveTag(Registry, Tag)
; 	return parent.RemoveTag(Tag)
; endFunction

; bool function ToggleTag(string Tag)
; 	return (RemoveTag(Tag) || AddTag(Tag)) && HasTag(Tag)
; endFunction

; bool function AddTagConditional(string Tag, bool AddTag)
; 	if Tag != ""
; 		if AddTag
; 			AddTag(Tag)
; 		elseIf !AddTag
; 			RemoveTag(Tag)
; 		endIf
; 	endIf
; 	return AddTag
; endFunction

; bool function CheckTags(string[] CheckTags, bool RequireAll = true, bool Suppress = false)
; 	bool Valid = ParseTags(CheckTags, RequireAll)
; 	return (Valid && !Suppress) || (!Valid && Suppress)
; endFunction

; bool function ParseTags(string[] TagList, bool RequireAll = true)
; 	if RequireAll
; 		return HasAllTag(TagList)
; 	else
; 		return HasOneTag(TagList)
; 	endIf
; endFunction

; bool function HasOneTag(string[] TagList)
; 	int i = TagList.Length
; 	while i
; 		i -= 1
; 		if HasTag(TagList[i])
; 			return true
; 		endIf
; 	endWhile
; 	return false
; endFunction

; bool function HasAllTag(string[] TagList)
; 	int i = TagList.Length
; 	while i
; 		i -= 1
; 		if !HasTag(TagList[i])
; 			return false
; 		endIf
; 	endWhile
; 	return true
; endFunction
