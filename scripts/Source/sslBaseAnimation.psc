scriptname sslBaseAnimation extends sslBaseObject

; import sslUtility
import PapyrusUtil

; Config
int Actors
int Stages

string[] Animations
string[] LastKeys

int[] Positions   ; = gender
int[] CumIDs      ; = per stage cumIDs
int[] Schlongs    ; = per stage schlong offset

bool[] Silences
bool[] OpenMouths
bool[] Strapons

float[] Timers
float[] CenterAdjust

float[] Offsets   ; = forward, side, up, rotate
float[] BedOffset ; = forward, side, up, rotate

; ------------------------------------------------------- ;
; --- Array Indexers                                  --- ;
; ------------------------------------------------------- ;

int function DataIndex(int Slots, int Position, int Stage, int Slot = 0)
	return ( Position * (Stages * Slots) ) + ( (Stage - 1) * Slots ) + Slot
endFunction

int function StageIndex(int Position, int Stage)
	return ((Position * Stages) + (Stage - 1))
endFunction

int function AdjIndex(int Stage, int Slot = 0, int Slots = 4)
	return ((Stage - 1) * Slots) + Slot
endfunction

; ------------------------------------------------------- ;
; --- Animation Events                                --- ;
; ------------------------------------------------------- ;

string[] function FetchPosition(int Position)
	if Position >= Actors || Position < 0
		Log("Unknown Position, '"+Position+"' given", "FetchPosition")
		return none
	endIf
	int Stage
	string[] Anims = Utility.CreateStringArray(Stages)
	while Stage <= Stages
		Stage += 1
		Anims[Stage] = Animations[StageIndex(Position, Stage)]
	endWhile
	return Anims
endFunction

string[] function FetchStage(int stage)
	if stage > Stages
		Log("Unknown stage, '"+stage+"' given", "FetchStage")
		return none
	endIf
	int Position
	string[] Anims = Utility.CreateStringArray(Actors)
	while Position < Actors
		Anims[Position] = Animations[StageIndex(Position, Stage)]
		Position += 1
	endWhile
	return Anims
endFunction

string function FetchPositionStage(int position, int Stage)
	return Animations[StageIndex(Position, Stage)]
endFunction

; ------------------------------------------------------- ;
; --- Stage Timer                                     --- ;
; ------------------------------------------------------- ;

bool function HasTimer(int Stage)
	return Stage > 0 && Stage <= Timers.Length && Timers[(Stage - 1)] != 0.0
endFunction

float function GetTimer(int Stage)
	if !HasTimer(Stage)
		return 0.0 ; Stage has no timer
	endIf
	return Timers[(Stage - 1)]
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

; ------------------------------------------------------- ;
; --- SoundFX                                         --- ;
; ------------------------------------------------------- ;

Form[] StageSoundFX
Sound property SoundFX hidden
	Sound function get()
		if StageSoundFX[0]
			return StageSoundFX[0] as Sound
		endIf
		return none
	endFunction
	function set(Sound var)
		if var
			StageSoundFX[0] = var as Form
		else
			StageSoundFX[0] = none
		endIf
	endFunction
endProperty

Sound function GetSoundFX(int Stage)
	if Stage < 1 || Stage > StageSoundFX.Length
		return StageSoundFX[0] as Sound
	endIf
	return StageSoundFX[(Stage - 1)] as Sound
endFunction

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

; ------------------------------------------------------- ;
; --- Offsets                                         --- ;
; ------------------------------------------------------- ;

float[] function GetPositionOffsets(string AdjustKey, int Position, int Stage, int BedTypeID = -1)
	float[] Output = new float[4]
	return PositionOffsets(Output, AdjustKey, Position, Stage)
endFunction

float[] function GetRawOffsets(int Position, int Stage)
	float[] Output = new float[4]
	return RawOffsets(Output, Position, Stage)
endFunction

float[] function _GetStageAdjustments(string Registrar, string AdjustKey, int Stage) global native
float[] function GetPositionAdjustments(string AdjustKey, int Position, int Stage)
	return _GetStageAdjustments(Registry, AdjustKey+"."+Position, Stage)
endFunction

;float[] function _GetAllAdjustments(string sProfile, string sRegistry, string sAdjustKey) global native
float[] function _GetAllAdjustments(string Registrar, string AdjustKey) global native
float[] function GetAllAdjustments(string AdjustKey)
	return _GetAllAdjustments(Registry, Adjustkey)
endFunction

bool function _HasAdjustments(string Registrar, string AdjustKey, int Stage) global native

function _PositionOffsets(string Registrar, string AdjustKey, string LastKey, int Stage, float[] RawOffsets) global native
float[] function PositionOffsets(float[] Output, string AdjustKey, int Position, int Stage, int BedTypeID = -1)
	int i = DataIndex(4, Position, Stage)
	Output[0] = Offsets[i] + CenterAdjust[(Stage - 1)] ; Forward
	Output[1] = Offsets[(i + 1)] ; Side
	Output[2] = Offsets[(i + 2)] ; Up
	Output[3] = Offsets[(i + 3)] ; Rot - no offset
	if BedTypeID != -1 && BedOffset.Length == 4
		; float[] Bed = GetBedOffsets()
		Output[0] = Output[0] + BedOffset[0]
		Output[1] = Output[1] + BedOffset[1]
		Output[2] = Output[2] + BedOffset[2]
		Output[3] = Output[3] + BedOffset[3]
	endIf
	_PositionOffsets(Registry, AdjustKey+"."+Position, LastKeys[Position], Stage, Output)
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

function SetBedOffsets(float forward, float sideward, float upward, float rotate)
	; Reverse defaults if setting to 0
	if forward == 0
		forward -= Config.BedOffset[0]
	endIf
	if upward == 0
		upward  -= Config.BedOffset[2]
	endIf

	BedOffset = new float[4]
	BedOffset[0] = forward
	BedOffset[1] = sideward
	BedOffset[2] = upward
	BedOffset[3] = rotate
endFunction

float[] function GetBedOffsets()
	if BedOffset.Length > 0
		return BedOffset
	endIf
	return Config.BedOffset
endFunction

; ------------------------------------------------------- ;
; --- Adjustments                                     --- ;
; ------------------------------------------------------- ;

function _SetAdjustment(string Registrar, string AdjustKey, int Stage, int Slot, float Adjustment) global native
function SetAdjustment(string AdjustKey, int Position, int Stage, int Slot, float Adjustment)
	if Position < Actors
		InitAdjustments(AdjustKey, Position)
		sslBaseAnimation._SetAdjustment(Registry, AdjustKey+"."+Position, Stage, Slot, Adjustment)
	endIf
endFunction

float function _GetAdjustment(string Registrar, string AdjustKey, int Stage, int nth) global native
float function GetAdjustment(string AdjustKey, int Position, int Stage, int Slot)
	return sslBaseAnimation._GetAdjustment(Registry, AdjustKey+"."+Position, Stage, Slot)
endFunction

float function _UpdateAdjustment(string Registrar, string AdjustKey, int Stage, int nth, float by) global native
function UpdateAdjustment(string AdjustKey, int Position, int Stage, int Slot, float AdjustBy)
	if Position < Actors
		InitAdjustments(AdjustKey, Position)
		sslBaseAnimation._UpdateAdjustment(Registry, AdjustKey+"."+Position, Stage, Slot, AdjustBy)
	endIf
endFunction
function UpdateAdjustmentAll(string AdjustKey, int Position, int Slot, float AdjustBy)
	if Position < Actors
		InitAdjustments(AdjustKey, Position)
		int Stage = Stages
		while Stage
			sslBaseAnimation._UpdateAdjustment(Registry, AdjustKey+"."+Position, Stage, Slot, AdjustBy)
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

function _ClearAdjustments(string Registrar, string AdjustKey) global native
function RestoreOffsets(string AdjustKey)
	_ClearAdjustments(Registry, AdjustKey+".0")
	_ClearAdjustments(Registry, AdjustKey+".1")
	_ClearAdjustments(Registry, AdjustKey+".2")
	_ClearAdjustments(Registry, AdjustKey+".3")
	_ClearAdjustments(Registry, AdjustKey+".4")
endFunction

bool function _CopyAdjustments(string Registrar, string AdjustKey, float[] Array) global native
function InitAdjustments(string AdjustKey, int Position)
	AdjustKey += "."+Position
	if !_HasAdjustments(Registry, AdjustKey, Stages)
		float[] List
		string CopyKey = LastKeys[Position]
		if CopyKey == "" || !_HasAdjustments(Registry, CopyKey, Stages)
			CopyKey = "Global."+Position
		endIf
		List = _GetAllAdjustments(Registry, CopyKey)
		if List.Length != (Stages * 4)
			List = PapyrusUtil.ResizeFloatArray(List, (Stages * 4))
			int Stage = Stages
			while Stage > 0
				List[AdjIndex(Stage, 3)] = Schlongs[StageIndex(Position, Stage)]
				Stage -= 1
			endWhile
			Log(List, "Initialized("+AdjustKey+")")
		else
			Log(List, "CopyAdjustments("+CopyKey+", "+AdjustKey+")")
		endIf
		_CopyAdjustments(Registry, AdjustKey, List)
	endIf
	LastKeys[Position] = AdjustKey
endFunction

string[] function _GetAdjustKeys(string Registrar) global native
string[] function GetAdjustKeys()
	return _GetAdjustKeys(Registry)
endFunction


; ------------------------------------------------------- ;
; --- Flags                                           --- ;
; ------------------------------------------------------- ;

int[] function GetPositionFlags(string AdjustKey, int Position, int Stage)
	int[] Output = new int[6]
	return PositionFlags(Output, AdjustKey, Position, Stage)
endFunction

int[] function PositionFlags(int[] Output, string AdjustKey, int Position, int Stage)
	AdjustKey += "."+Position
	; int i = DataIndex(4, Position, Stage)
	int i = StageIndex(Position, Stage)
	Output[0] = Silences[i] as int
	Output[1] = OpenMouths[i] as int
	Output[2] = Strapons[i] as int
	Output[3] = GetSchlong(AdjustKey, Position, Stage)
	Output[4] = GetGender(Position)
	Output[5] = CumIDs[i]
	return Output
endFunction

; ------------------------------------------------------- ;
; --- Animation Info                                  --- ;
; ------------------------------------------------------- ;

bool function IsSilent(int Position, int Stage)
	return Silences[StageIndex(Position, Stage)]
endFunction

bool function UseOpenMouth(int Position, int Stage)
	return OpenMouths[StageIndex(Position, Stage)]
endFunction

bool function UseStrapon(int Position, int Stage)
	return Strapons[StageIndex(Position, Stage)]
endFunction

; int function _GetSchlong(string ProfileName, string Registry, string AdjustKey, string LastKey, int Stage, int retDefault) global native
int function GetSchlong(string AdjustKey, int Position, int Stage)
	if _HasAdjustments(Registry, AdjustKey, Stage)
		return _GetAdjustment(Registry, AdjustKey, Stage, 3) as int
	elseIf LastKeys[Position] != "" && _HasAdjustments(Registry, LastKeys[Position], Stage)
		return _GetAdjustment(Registry, LastKeys[Position], Stage, 3) as int
	endIf
	return Schlongs[StageIndex(Position, Stage)]
endFunction

int function GetCumID(int Position, int Stage = 1)
	return CumIDs[StageIndex(Position, Stage)]
endFunction

function SetStageCumID(int Position, int Stage, int CumID)
	CumIDs[StageIndex(Position, Stage)] = CumID
endFunction

int function GetCum(int Position)
	return GetCumID(Position, Stages)
endFunction

int function ActorCount()
	return Actors
endFunction

int function StageCount()
	return Stages
endFunction

int function GetGender(int Position)
	return Positions[Position]
endFunction

bool function MalePosition(int Position)
	return Positions[Position] == 0
endFunction

bool function FemalePosition(int Position)
	return Positions[Position] == 1
endFunction

bool function CreaturePosition(int Position)
	return Positions[Position] >= 2
endFunction

int function FemaleCount()
	return Genders[1]
endFunction

int function MaleCount()
	return Genders[0]
endFunction

bool function IsSexual()
	return IsSexual
endFunction

function SetContent(int contentType)
	; No longer used
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
	return RaceType != "" && RaceID != "" && sslCreatureAnimationSlots.HasRaceID(RaceType, RaceID)
endFunction

function AddRaceID(string RaceID)
	if !HasRaceID(RaceID)
		sslCreatureAnimationSlots.AddRaceID(RaceType, RaceID)
	endIf
endFunction

function SetRaceKey(string RaceKey)
	if sslCreatureAnimationSlots.HasRaceKey(RaceKey)
		RaceType = RaceKey
	else
		Log("Unknown or empty RaceKey!", "SetRaceKey("+RaceKey+")")
	endIf
endFunction

function SetRaceIDs(string[] RaceList)
	RaceType = ""
	int i = RaceList.Length
	while i
		i -= 1
		string RaceKey = sslCreatureAnimationSlots.GetRaceKeyByID(RaceList[i])
		if RaceKey != "" && RaceType != RaceKey
			RaceType = RaceKey
			i = 0
		endIf
	endWhile
endFunction

string[] function GetRaceIDs()
	return sslCreatureAnimationSlots.GetAllRaceIDs(RaceType)
endFunction

; ------------------------------------------------------- ;
; --- Animation Setup                                 --- ;
; ------------------------------------------------------- ;

int aid
int sid

bool Locked
int function AddPosition(int Gender = 0, int AddCum = -1)
	if Actors >= 5
		return -1
	endIf
	while Locked
		Utility.WaitMenuMode(0.05)
		Debug.Trace(Registry+" AddPosition Lock! -- Adding Actor: "+Actors)
	endWhile
	Locked = true

	int pid = Actors
	Genders[Gender] = Genders[Gender] + 1
	Positions[pid]  = Gender
	if pid > 0
		; Single item / per stage containers
		int idx    = (pid + 1) * Stages
		Animations = PapyrusUtil.ResizeStringArray(Animations, idx)
		Silences   = PapyrusUtil.ResizeBoolArray(Silences, idx)
		OpenMouths = PapyrusUtil.ResizeBoolArray(OpenMouths, idx)
		Strapons   = PapyrusUtil.ResizeBoolArray(Strapons, idx)
		Schlongs   = PapyrusUtil.ResizeIntArray(Schlongs, idx)
		if pid == 1
			CumIDs = PapyrusUtil.ResizeIntArray(CumIDs, Stages)
		endIf
		CumIDs     = PapyrusUtil.ResizeIntArray(CumIDs, idx, AddCum)
		Offsets    = PapyrusUtil.ResizeFloatArray(Offsets, (pid + 1) * (Stages * 4))
	else
		Offsets    = new float[128]
		Animations = new string[32]
		Silences   = new bool[32]
		OpenMouths = new bool[32]
		Strapons   = new bool[32]
		Schlongs   = new int[32]
		CumIDs     = Utility.CreateIntArray(32, AddCum)
	endIf
	Actors += 1
	
	Locked = false
	return pid
endFunction

function AddPositionStage(int Position, string AnimationEvent, float forward = 0.0, float side = 0.0, float up = 0.0, float rotate = 0.0, bool silent = false, bool openMouth = false, bool strapon = true, int sos = 0)
	Animations[aid] = AnimationEvent
	Silences[aid]   = silent
	OpenMouths[aid] = openMouth
	Strapons[aid]   = strapon
	Schlongs[aid]   = sos
	aid += 1

	Offsets[sid + 0] = forward
	Offsets[sid + 1] = side
	Offsets[sid + 2] = up
	Offsets[sid + 3] = rotate
	sid += 4

	Stages += (Position == 0) as int
endFunction

function Save(int id = -1)
	parent.Save(id)
	; Finalize config data
	Positions = PapyrusUtil.ResizeIntArray(Positions, Actors)
	LastKeys  = PapyrusUtil.ResizeStringArray(LastKeys, Actors)
	if Actors == 1
		Animations = PapyrusUtil.ResizeStringArray(Animations, Stages)
		Silences   = PapyrusUtil.ResizeBoolArray(Silences, Stages)
		OpenMouths = PapyrusUtil.ResizeBoolArray(OpenMouths, Stages)
		Strapons   = PapyrusUtil.ResizeBoolArray(Strapons, Stages)
		Schlongs   = PapyrusUtil.ResizeIntArray(Schlongs, Stages)
		CumIDs     = PapyrusUtil.ResizeIntArray(CumIDs, Stages)
		Offsets    = PapyrusUtil.ResizeFloatArray(Offsets, (Stages * 4))
	endIf
	; Create and add gender tag
	int i
	string Tag
	while i < Actors
		int Gender = Positions[i]
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
	aid        = 0
	sid        = 0
	Actors     = 0
	Stages     = 0
	RaceType   = ""
	Genders    = new int[4]
	Positions  = new int[5]
	Offsets    = new float[1]
	LastKeys   = new string[5]
	Animations = new string[1]
	Silences   = new bool[1]
	OpenMouths = new bool[1]
	Strapons   = new bool[1]
	Schlongs   = new int[1]

	; SingleBed    = Utility.CreateFloatArray(0)
	; DoubleBed    = Utility.CreateFloatArray(0)

	BedOffset = Utility.CreateFloatArray(0)
	; BedOffset[0] = 33.0
	; BedOffset[2] = 37.0

	Timers       = new float[1]
	StageSoundFX = new Form[1]

	Locked = false

	parent.Initialize()
endFunction

bool function CheckByTags(int ActorCount, string[] Search, string[] Suppress, bool RequireAll)
	return Enabled && ActorCount == PositionCount && CheckTags(Search, RequireAll) && (Suppress.Length < 1 || !HasOneTag(Suppress))
endFunction

; ------------------------------------------------------- ;
; --- Properties                                      --- ;
; ------------------------------------------------------- ;

; Creature Use
string property RaceType auto hidden
Form[] property CreatureRaces hidden
	form[] function get()
		string[] Races = sslCreatureAnimationSlots.GetAllRaceIDs(RaceType)
		int i = Races.Length
		Form[] RaceRefs = Utility.CreateFormArray(i)
		while i
			i -= 1
			RaceRefs[i] = Race.GetRace(Races[i])
		endWhile
		return ClearNone(RaceRefs)
	endFunction
endProperty

; Information
bool property IsSexual hidden
	bool function get()
		return HasTag("Sex") || HasTag("Vaginal") || HasTag("Anal") || HasTag("Oral")
	endFunction
endProperty
bool property IsCreature hidden
	bool function get()
		return Genders[2] > 0 || Genders[3] > 0
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

; Position Genders
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


;/ string property Profile hidden
	string function get()
		return "../SexLab/AnimationProfile_"+Config.AnimProfile+".json"
	endFunction
endProperty /;