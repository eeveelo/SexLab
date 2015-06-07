scriptname sslBaseAnimation extends sslBaseObject

; import sslUtility
; import PapyrusUtil
; import Utility

; Config
int Actors
int Stages

string[] Animations
string[] LastKeys
string[] RaceTypes

int[] Positions   ; = gender
int[] CumIDs      ; = per stage cumIDs
int[] Schlongs    ; = per stage schlong offset

bool[] Silences
bool[] OpenMouths
bool[] Strapons

; int[] Flags

float[] Timers
float[] CenterAdjust

; float[] Offsets   ; = forward, side, up, rotate
float[] BedOffset ; = forward, side, up, rotate

; ------------------------------------------------------- ;
; --- Array Indexers                                  --- ;
; ------------------------------------------------------- ;

int function DataIndex(int Slots, int Position, int Stage, int Slot = 0)
	return ( Position * (Stages * Slots) ) + ( (PapyrusUtil.ClampInt(Stage, 1, Stages) - 1) * Slots ) + Slot
endFunction

int function StageIndex(int Position, int Stage)
	return ((Position * Stages) + (PapyrusUtil.ClampInt(Stage, 1, Stages) - 1))
endFunction

int function AdjIndex(int Stage, int Slot = 0, int Slots = 4)
	return ((PapyrusUtil.ClampInt(Stage, 1, Stages) - 1) * Slots) + Slot
endfunction

int function OffsetIndex(int Stage, int Slot)
	return ((PapyrusUtil.ClampInt(Stage, 1, Stages) - 1) * 4) + Slot
endfunction

int function FlagIndex(int Stage, int Slot)
	return ((PapyrusUtil.ClampInt(Stage, 1, Stages) - 1) * 5) + Slot
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

string[] function FetchStage(int Stage)
	if Stage > Stages
		Log("Unknown Stage, '"+Stage+"' given", "FetchStage")
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

function GetAnimEvents(string[] AnimEvents, int Stage)
	if AnimEvents.Length != 5 || Stage > Stages
		Log("Invalid Call("+AnimEvents+", "+Stage+"/"+Stages+")", "GetanimEvents")
	else
		int Position
		while Position < Actors
			AnimEvents[Position] = Animations[StageIndex(Position, Stage)]
			Position += 1
		endWhile
	endIf
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

function SetStageTimer(int Stage, float Timer)
	; Validate stage
	if Stage > Stages || Stage < 1
		Log("Unknown animation stage, '"+Stage+"' given.", "SetStageTimer")
		return
	endIf
	; Initialize timer array if needed
	if Timers.Length != Stages
		Timers = Utility.CreateFloatArray(Stages)
	endIf
	; Set timer
	Timers[(Stage - 1)] = Timer
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
 			seconds += StageTimers[PapyrusUtil.ClampInt(Stage, 0, (LastTimer - 1))]
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
		StageSoundFX = PapyrusUtil.ResizeFormArray(StageSoundFX, Stages, SoundFX)
	endIf
	; Set Stage fx
	StageSoundFX[(stage - 1)] = StageFX
endFunction

; ------------------------------------------------------- ;
; --- Offsets                                         --- ;
; ------------------------------------------------------- ;

float[] function GetPositionOffsets(string AdjustKey, int Position, int Stage)
	float[] Output = new float[4]
	return PositionOffsets(Output, AdjustKey, Position, Stage)
endFunction

float[] function GetRawOffsets(int Position, int Stage)
	float[] Output = new float[4]
	return RawOffsets(Output, Position, Stage)
endFunction

float[] function _GetStageAdjustments(string Registrar, string AdjustKey, int Stage) global native
float[] function GetPositionAdjustments(string AdjustKey, int Position, int Stage)
	return _GetStageAdjustments(Registry, InitAdjustments(AdjustKey, Position), Stage)
endFunction

;float[] function _GetAllAdjustments(string sProfile, string sRegistry, string sAdjustKey) global native
float[] function _GetAllAdjustments(string Registrar, string AdjustKey) global native
float[] function GetAllAdjustments(string AdjustKey)
	return _GetAllAdjustments(Registry, Adjustkey)
endFunction

bool function HasAdjustments(string Registrar, string AdjustKey, int Stage) global native

function _PositionOffsets(string Registrar, string AdjustKey, string LastKey, int Stage, float[] RawOffsets) global native
float[] function PositionOffsets(float[] Output, string AdjustKey, int Position, int Stage, int BedTypeID = 0)
	int i = OffsetIndex(Stage, 0)
	float[] Offsets = OffsetsArray(Position)
	Output[0] = Offsets[i] + CenterAdjust[(Stage - 1)] ; Forward
	Output[1] = Offsets[(i + 1)] ; Side
	Output[2] = Offsets[(i + 2)] ; Up
	Output[3] = Offsets[(i + 3)] ; Rot - no offset
	if BedTypeID > 0
		if BedOffset.Length == 4
			Output[0] = Output[0] + BedOffset[0]
			Output[1] = Output[1] + BedOffset[1]
			Output[3] = Output[3] + BedOffset[3]
			if BedTypeID == 1
				Output[2] = Output[2] + BedOffset[2] ; Only on non-bedrolls
			endIf
		else
			Output[0] = Output[0] + 30.0
			if BedTypeID == 1
				Output[2] = Output[2] + 37.0 ; Only on non-bedrolls
			endIf
		endIf
	endIf
	_PositionOffsets(Registry, AdjustKey+"."+Position, LastKeys[Position], Stage, Output)
	return Output
endFunction

float[] function RawOffsets(float[] Output, int Position, int Stage)
	int i = OffsetIndex(Stage, 0)
	float[] Offsets = OffsetsArray(Position)
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
		LastKeys[Position] = InitAdjustments(AdjustKey, Position)
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
		LastKeys[Position] = InitAdjustments(AdjustKey, Position)
		sslBaseAnimation._UpdateAdjustment(Registry, AdjustKey+"."+Position, Stage, Slot, AdjustBy)
	endIf
endFunction
function UpdateAdjustmentAll(string AdjustKey, int Position, int Slot, float AdjustBy)
	if Position < Actors
		LastKeys[Position] = InitAdjustments(AdjustKey, Position)
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
string function InitAdjustments(string AdjustKey, int Position)
	AdjustKey += "."+Position
	if !HasAdjustments(Registry, AdjustKey, Stages)
		; Pick key to copy from
		string CopyKey = LastKeys[Position]
		if CopyKey == "" || CopyKey == "Global."+Position || !HasAdjustments(Registry, CopyKey, Stages)
			CopyKey = "Global."+Position
		endIf
		; Get adjustments from lastkey or default global
		float[] List = _GetAllAdjustments(Registry, CopyKey)
		if List.Length != (Stages * 4)
			List = GetEmptyAdjustments(Position)
			Log(List, "InitAdjustments("+AdjustKey+")")
		else
			Log(List, "CopyAdjustments("+CopyKey+", "+AdjustKey+")")
		endIf
		; Copy list to profile
		_CopyAdjustments(Registry, AdjustKey, List)
	endIf
	return AdjustKey
endFunction

float[] function GetEmptyAdjustments(int Position)
	float[] Output = Utility.CreateFloatArray((Stages * 4))
	int[] Flags = FlagsArray(Position)
	int Stage = Stages
	while Stage > 0
		Output[AdjIndex(Stage, kSchlong)] = Flags[FlagIndex(Stage, kSchlong)]
		Stage -= 1
	endWhile
	return Output
endFunction

string[] function _GetAdjustKeys(string Registrar) global native
string[] function GetAdjustKeys()
	return _GetAdjustKeys(Registry)
endFunction

;/ string function GetLastKey()
	return StorageUtil.GetStringValue(Config, Key("LastKey"), "Global")
endFunction

string function PickKey(string AdjustKey, int Position)

endFunction
 /;
; ------------------------------------------------------- ;
; --- Flags                                           --- ;
; ------------------------------------------------------- ;

int[] function GetPositionFlags(string AdjustKey, int Position, int Stage)
	int[] Output = new int[5]
	return PositionFlags(Output, AdjustKey, Position, Stage)
endFunction

int[] function PositionFlags(int[] Output, string AdjustKey, int Position, int Stage)
	int i = FlagIndex(Stage, 0)
	int[] Flags = FlagsArray(Position)
	Output[0] = Flags[i]
	Output[1] = Flags[i + 1]
	Output[2] = Flags[i + 2]
	Output[3] = GetSchlong(AdjustKey, Position, Stage)
	Output[4] = GetGender(Position)
	return Output
endFunction

; ------------------------------------------------------- ;
; --- Animation Info                                  --- ;
; ------------------------------------------------------- ;

bool function IsSilent(int Position, int Stage)
	return FlagsArray(Position)[FlagIndex(Stage, kSilent)] as bool
endFunction

bool function UseOpenMouth(int Position, int Stage)
	return FlagsArray(Position)[FlagIndex(Stage, kOpenMouth)] as bool
endFunction

bool function UseStrapon(int Position, int Stage)
	return FlagsArray(Position)[FlagIndex(Stage, kStrapon)] as bool
endFunction

; int function _GetSchlong(string ProfileName, string Registry, string AdjustKey, string LastKey, int Stage, int retDefault) global native
int function GetSchlong(string AdjustKey, int Position, int Stage)
	if HasAdjustments(Registry, AdjustKey+"."+Position, Stage)
		return _GetAdjustment(Registry, AdjustKey+"."+Position, Stage, 3) as int
	elseIf LastKeys[Position] != "" && HasAdjustments(Registry, LastKeys[Position], Stage)
		return _GetAdjustment(Registry, LastKeys[Position], Stage, 3) as int
	endIf
	return FlagsArray(Position)[FlagIndex(Stage, kSchlong)]
endFunction

int function GetCumID(int Position, int Stage = 1)
	return FlagsArray(Position)[FlagIndex(Stage, kCumID)]
endFunction

function SetStageCumID(int Position, int Stage, int CumID)
	FlagsArray(Position)[FlagIndex(Stage, kCumID)] = CumID
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
int oid
int fid

bool Locked
int function AddPosition(int Gender = 0, int AddCum = -1)
	if Actors >= 5
		return -1
	endIf
	while Locked
		Utility.WaitMenuMode(0.1)
		Debug.Trace(Registry+" AddPosition Lock! -- Adding Actor: "+Actors)
	endWhile
	Locked = true
	
	oid = 0
	fid = 0

	Genders[Gender]   = Genders[Gender] + 1
	Positions[Actors] = Gender

	InitArrays(Actors)
	FlagsArray(Actors)[kCumID] = AddCum

	string[] TagList = GetTags()
	TagList[0] = TagList[0]+GetGenderString(Gender)
	TagList[1] = GetGenderString(Gender)+TagList[1]

	if Gender >= 2
		if RaceTypes.Length == 0
			RaceTypes = new string[5]
		endIf
		if RaceType != ""
			RaceTypes[Actors] = RaceType
		endIf
	endIf

	Actors += 1
	Locked = false
	return (Actors - 1)
endFunction

int function AddCreaturePosition(string RaceKey, int Gender = 2, int AddCum = -1)
	if Actors >= 5
		return -1
	elseIf Gender <= 0 || Gender > 3
		Gender = 2
	elseIf Gender == 1
		Gender = 3
	endIf
	
	int pid = AddPosition(Gender, AddCum)
	if pid != -1 && RaceKey != ""
		RaceTypes[pid] = RaceKey
	endIf

	return pid
endFunction

function AddPositionStage(int Position, string AnimationEvent, float forward = 0.0, float side = 0.0, float up = 0.0, float rotate = 0.0, bool silent = false, bool openmouth = false, bool strapon = true, int sos = 0)
	; Out of range position or empty animation event
	if Position == -1 || Position >= 5 || AnimationEvent == ""
		Log("FATAL: Invalid arguments!", "AddPositionStage("+Position+", "+AnimationEvent+")")
		return
	endIf

	; First position dictates stage count and sizes
	if Position == 0
		Stages += 1
		; Flag stage overflow
		if (fid + kFlagEnd) >= Flags0.Length
			Log("WARNING: Flags position overflow, resizing! - Current flags: "+Flags0, "AddPositionStage("+Position+", "+AnimationEvent+")")
			Flags0 = PapyrusUtil.ResizeIntArray(Flags0, (Flags0.Length + 32))
		endIf
		; Offset stage overflow
		if (oid + kOffsetEnd) >= Offsets0.Length
			Log("WARNING: Offsets position overflow, resizing! - Current offsets: "+Offsets0, "AddPositionStage("+Position+", "+AnimationEvent+")")
			Offsets0 = PapyrusUtil.ResizeFloatArray(Offsets0, (Offsets0.Length + 32))
		endIf
	endIf

	; Save stage animation event
	if aid < 128
		Animations[aid] = AnimationEvent
	else
		if aid == 128
			Log("WARNING: Animation stage overflow, resorting to push! - Current events: "+Animations, "AddPositionStage("+Position+", "+AnimationEvent+")")
		endIf
		Animations = PapyrusUtil.PushString(Animations, AnimationEvent)
	endIf
	aid += 1

	; Save position flags
	int[] Flags = FlagsArray(Position)
	Flags[fid + 0] = silent as int
	Flags[fid + 1] = openmouth as int
	Flags[fid + 2] = strapon as int
	Flags[fid + 3] = sos
	Flags[fid + 4] = Flags[kCumID]
	fid += kFlagEnd

	; Save position offsets
	float[] Offsets = OffsetsArray(Position)
	Offsets[oid + 0] = forward
	Offsets[oid + 1] = side
	Offsets[oid + 2] = up
	Offsets[oid + 3] = rotate
	oid += kOffsetEnd
endFunction

function Save(int id = -1)
	parent.Save(id)	
	; Finalize config data
	Flags0     = Utility.ResizeIntArray(Flags0, (Stages * kFlagEnd))
	Offsets0   = Utility.ResizeFloatArray(Offsets0, (Stages * kOffsetEnd))
	Animations = Utility.ResizeStringArray(Animations, aid)
	; Positions  = Utility.ResizeIntArray(Positions, Actors)
	; LastKeys   = Utility.ResizeStringArray(LastKeys, Actors)
	; Init forward offset list
	CenterAdjust = Utility.CreateFloatArray(Stages)
	if Actors > 1
		int Stage = Stages
		while Stage
			CenterAdjust[(Stage - 1)] = CalcCenterAdjuster(Stage)
			Stage -= 1
		endWhile
	endIf
	; Remove duplicate gender tags
	string[] TagList = GetTags()
	if TagList[0] == TagList[1]
		TagList[1] = ""
	endIf
	; Log the new animation
	if IsCreature
		; RaceTypes = PapyrusUtil.ResizeStringArray(RaceTypes, Actors)
		Log(Name, "Creatures["+id+"] ("+Females+", "+Males+", "+Creatures+")")
	else
		Log(Name, "Animations["+id+"] ("+Females+", "+Males+")")
	endIf
endFunction

float function CalcCenterAdjuster(int Stage)
	; Get forward Offsets of all Positions + find highest/lowest position
	float Adjuster
	int Position = Actors
	while Position
		Position -= 1
		float Forward = OffsetsArray(Position)[OffsetIndex(Stage, 0)]
		if Math.Abs(Forward) > Math.Abs(Adjuster)
			Adjuster = Forward
		endIf
	endWhile
	; Get signed half of highest/lowest offset
	return Adjuster * -0.5
endFunction

string function GenderTag(int count, string gender)
	if count == 0
		return ""
	elseIf count == 1
		return gender
	elseIf count == 2
		return gender+gender
	elseIf count == 3
		return gender+gender+gender
	elseIf count == 4
		return gender+gender+gender+gender
	elseIf count == 5
		return gender+gender+gender+gender+gender
	endIf
	return ""
endFunction

string function GetGenderString(int Gender)
	if Gender == 0
		return "M"
	elseIf Gender == 1
		return "F"
	elseIf Gender >= 2
		return "C"
	endIf
	return ""
endFunction

; ------------------------------------------------------- ;
; --- System Use                                      --- ;
; ------------------------------------------------------- ;

function Initialize()
	aid       = 0
	oid       = 0
	fid       = 0
	Actors    = 0
	Stages    = 0
	RaceType  = ""
	Genders   = new int[4]
	Positions = new int[5]
	StageSoundFX = new Form[1]

	; Only init if needed to keep between registry resets.
	if LastKeys.Length != 5
		LastKeys  = new string[5]
	endIf

	RaceTypes  = Utility.CreateStringArray(0)
	Animations = Utility.CreateStringArray(0)
	BedOffset  = Utility.CreateFloatArray(0)
	Timers     = Utility.CreateFloatArray(0)

	Flags0 = Utility.CreateIntArray(0)
	Flags1 = Utility.CreateIntArray(0)
	Flags2 = Utility.CreateIntArray(0)
	Flags3 = Utility.CreateIntArray(0)
	Flags4 = Utility.CreateIntArray(0)

	Offsets0 = Utility.CreateFloatArray(0)
	Offsets1 = Utility.CreateFloatArray(0)
	Offsets2 = Utility.CreateFloatArray(0)
	Offsets3 = Utility.CreateFloatArray(0)
	Offsets4 = Utility.CreateFloatArray(0)

	Locked = false

	parent.Initialize()
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
		return PapyrusUtil.ClearNone(RaceRefs)
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
		return Genders[2] + Genders[3]
	endFunction
endProperty
int property MaleCreatures hidden
	int function get()
		return Genders[2]
	endFunction
endProperty
int property FemaleCreatures hidden
	int function get()
		return Genders[3]
	endFunction
endProperty

;/ string property Profile hidden
	string function get()
		return "../SexLab/AnimationProfile_"+Config.AnimProfile+".json"
	endFunction
endProperty /;

bool function CheckByTags(int ActorCount, string[] Search, string[] Suppress, bool RequireAll)
	return Enabled && ActorCount == PositionCount && CheckTags(Search, RequireAll) && (Suppress.Length < 1 || !HasOneTag(Suppress))
endFunction

int[] Flags0
int[] Flags1
int[] Flags2
int[] Flags3
int[] Flags4

int property kSilent    = 0 autoreadonly hidden
int property kOpenMouth = 1 autoreadonly hidden
int property kStrapon   = 2 autoreadonly hidden
int property kSchlong   = 3 autoreadonly hidden
int property kCumID     = 4 autoreadonly hidden
int property kFlagEnd hidden
	int function get()
		return 5
	endFunction
endProperty

int[] function FlagsArray(int Position)
	if Position == 0
		return Flags0
	elseIf Position == 1
		return Flags1
	elseIf Position == 2
		return Flags2
	elseIf Position == 3
		return Flags3
	elseIf Position == 4
		return Flags4
	endIf
	return Utility.CreateIntArray(0)
endFunction

function FlagsSave(int Position, int[] Flags)
	if Position == 0
		Flags0 = Flags
	elseIf Position == 1
		Flags1 = Flags
	elseIf Position == 2
		Flags2 = Flags
	elseIf Position == 3
		Flags3 = Flags
	elseIf Position == 4
		Flags4 = Flags
	endIf
endFunction

float[] Offsets0
float[] Offsets1
float[] Offsets2
float[] Offsets3
float[] Offsets4

int property kForward  = 0 autoreadonly hidden
int property kSideways = 1 autoreadonly hidden
int property kUpward   = 2 autoreadonly hidden
int property kRotate   = 3 autoreadonly hidden
int property kOffsetEnd hidden
	int function get()
		return 4
	endFunction
endProperty

float[] function OffsetsArray(int Position)
	if Position == 0
		return Offsets0
	elseIf Position == 1
		return Offsets1
	elseIf Position == 2
		return Offsets2
	elseIf Position == 3
		return Offsets3
	elseIf Position == 4
		return Offsets4
	endIf
	return Utility.CreateFloatArray(0)
endFunction

function OffsetsSave(int Position, float[] Offsets)
	if Position == 0
		Offsets0 = Offsets
	elseIf Position == 1
		Offsets1 = Offsets
	elseIf Position == 2
		Offsets2 = Offsets
	elseIf Position == 3
		Offsets3 = Offsets
	elseIf Position == 4
		Offsets4 = Offsets
	endIf
endFunction

function InitArrays(int Position)
	if Position == 0
		Flags0     = new int[128]
		Offsets0   = new float[128]
		Animations = new string[128]
	elseIf Position == 1
		Flags1   = Utility.CreateIntArray((Stages * kFlagEnd))
		Offsets1 = Utility.CreateFloatArray((Stages * kOffsetEnd))
	elseIf Position == 2
		Flags2   = Utility.CreateIntArray((Stages * kFlagEnd))
		Offsets2 = Utility.CreateFloatArray((Stages * kOffsetEnd))
	elseIf Position == 3
		Flags3   = Utility.CreateIntArray((Stages * kFlagEnd))
		Offsets3 = Utility.CreateFloatArray((Stages * kOffsetEnd))
	elseIf Position == 4
		Flags4   = Utility.CreateIntArray((Stages * kFlagEnd))
		Offsets4 = Utility.CreateFloatArray((Stages * kOffsetEnd))
	endIf
endFunction
