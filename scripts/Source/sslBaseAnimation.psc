scriptname sslBaseAnimation extends sslBaseObject

; TODO: ADD CUSTOM ORGASM STAGE SETTINGS
; [4:36 PM] Ashal: I could add custom orgasm stage settings in the next update
; [4:36 PM] Ashal: it's not a bad idea
; [4:36 PM] Seijin: That'd be awesome
; [4:36 PM] Seijin: Maybe a tag system that says when the O should actually happen?
; [4:37 PM] Seijin: for instance: "EarlyO1" meaning one stage before the end, "EarlyO2" for 2, etc.
; [4:37 PM] Seijin: (Just spitballing)
; [4:37 PM] Ashal: Something like Anim.AddOrgasmStage(3) when settings up an animation. Would allow for multiple stages to be set for it as well
; [4:37 PM] Ashal: and if animation setup never calls that function, just default to using the last stage for orgasm like normal
; [4:41 PM] Ashal: I could add an option for it in the animation editor
; [4:41 PM] Ashal: the page where you can edit alignment settings
; [4:41 PM] Seijin: I'm comfortable with any option you would provide, just having flashbacks of a couple years ago when I knew fuck-all about scripting and couldn't understand how to make anything work.
; [4:41 PM] Seijin: That would work perfectly!
; [4:41 PM] Ashal: just a toggle box for whether the stage being edited is orgasm or not

; import sslUtility
; import PapyrusUtil
; import Utility

; Config
int Actors
int Stages

string[] Animations
string[] RaceTypes
string[] LastKeys
string LastKeyReg

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

bool property GenderedCreatures auto hidden

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
	return ((PapyrusUtil.ClampInt(Stage, 1, Stages) - 1) * 6) + Slot
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
		Log("Invalid Call("+AnimEvents+", "+Stage+"/"+Stages+")", "GetAnimEvents")
	else
		int Position
		while Position < Actors
			AnimEvents[Position] = Animations[StageIndex(Position, Stage)]
			Position += 1
		endWhile
	endIf
endFunction

string function FetchPositionStage(int Position, int Stage)
	return Animations[StageIndex(Position, Stage)]
endFunction

function SetPositionStage(int Position, int Stage, string AnimationEvent)
	Animations[StageIndex(Position, Stage)] = AnimationEvent
endFunction


; ------------------------------------------------------- ;
; --- Stage Timer                                     --- ;
; ------------------------------------------------------- ;

bool function HasTimer(int Stage)
	return Timers && Stage > 0 && Stage <= Timers.Length && Timers[(Stage - 1)] != 0.0
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
	int LastStage  = (Stages - 1)
	int Stage = Stages
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

bool function _HasAdjustments(string Registrar, string AdjustKey, int Stage) global native
bool function HasAdjustments(string AdjustKey, int Stage)
	return _HasAdjustments(Registry, AdjustKey, Stage)
endFunction

function _PositionOffsets(string Registrar, string AdjustKey, string LastKey, int Stage, float[] RawOffsets) global native
float[] function PositionOffsets(float[] Output, string AdjustKey, int Position, int Stage, int BedTypeID = 0)
	if !Output || Output.Length < 4
		Output = new float[4]
	endIf
	int i = OffsetIndex(Stage, 0)
	float[] Offsets = OffsetsArray(Position)
	Output[0] = Offsets[i] + CenterAdjust[(Stage - 1)] ; Forward
	Output[1] = Offsets[(i + 1)] ; Side
	Output[2] = Offsets[(i + 2)] ; Up
	Output[3] = Offsets[(i + 3)] ; Rot - no offset
	
	_PositionOffsets(Registry, AdjustKey+"."+Position, LastKeys[Position], Stage, Output)
	
	float Forward = Output[0]
	float Side = Output[1]
	if BedTypeID > 0 && BedOffset.Length == 4
		Output[0] = ((Forward * Math.cos(BedOffset[3])) - (Side * Math.sin(BedOffset[3])))
		Output[1] = ((Forward * Math.sin(BedOffset[3])) + (Side * Math.cos(BedOffset[3])))

		Output[0] = Output[0] + BedOffset[0]
		Output[1] = Output[1] + BedOffset[1]
		Output[2] = Output[2] + BedOffset[2]
		Output[3] = Output[3] + BedOffset[3]
	endIf
	if Output[3] >= 360.0
		Output[3] = Output[3] - 360.0
	elseIf Output[3] < 0.0
		Output[3] = Output[3] + 360.0
	endIf
	
	Log("PositionOffsets()[Forward:"+Output[0]+",Sideward:"+Output[1]+",Upward:"+Output[2]+",Rotation:"+Output[3]+"]")
	return Output
endFunction

float[] function RawOffsets(float[] Output, int Position, int Stage)
	if !Output || Output.Length < 4
		Output = new float[4]
	endIf
	int i = OffsetIndex(Stage, 0)
	float[] Offsets = OffsetsArray(Position)
	Output[0] = Offsets[i] ; Forward
	Output[1] = Offsets[(i + 1)] ; Side
	Output[2] = Offsets[(i + 2)] ; Up
	Output[3] = Offsets[(i + 3)] ; Rot
	return Output
endFunction

function SetBedOffsets(float forward, float sideward, float upward, float rotate)
	; Reverse defaults if setting to 0 have nothing to do with the Config.BedOffset
	;if forward == 0.0
	;	forward -= Config.BedOffset[0]
	;endIf
	;if upward == 0.0
	;	upward  -= Config.BedOffset[2]
	;endIf

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
	return Utility.CreateFloatArray(4)
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

function AdjustSchlong(string AdjustKey, int Position, int Stage, int AdjustBy)
	UpdateAdjustment(AdjustKey, Position, Stage, 3, AdjustBy as float)
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

function CopyAdjustmentsFrom(string AdjustKey, string CopyKey, int Position)
	CopyKey   = CopyKey+"."+Position
	AdjustKey = AdjustKey+"."+Position
	float[] List
	if _HasAdjustments(Registry, CopyKey, Stages)
		List = _GetAllAdjustments(Registry, CopyKey)
	else
		List = GetEmptyAdjustments(Position)
	endIf
	_ClearAdjustments(Registry, AdjustKey)
	_CopyAdjustments(Registry, AdjustKey, List)
endFunction

string function GetLastKey(int Position)
	string LastKey = LastKeys[Position]
	if LastKey != "" && LastKey != "Global."+Position && _HasAdjustments(Registry, LastKey, Stages)
		return LastKey
	endIf
	return "Global."+Position
endFunction

string function InitAdjustments(string AdjustKey, int Position)
	if !AdjustKey || Position >= Actors || Position < 0
		Log("Unknown Position, '"+Position+"' given", "InitAdjustments")
		return LastKeys[Position]
	endIf
	
	AdjustKey += "."+Position
	if !_HasAdjustments(Registry, AdjustKey, Stages)
		; Pick key to copy from
		string CopyKey = LastKeys[Position]
		if AdjustKey == "Global."+Position || CopyKey == "" || CopyKey == "Global."+Position || !_HasAdjustments(Registry, CopyKey, Stages)
			CopyKey = "Global."+Position
		endIf
		if CopyKey != "Global."+Position
			string[] RaceIDs = PapyrusUtil.StringSplit(AdjustKey, ".")
			string[] LastRaceIDs = PapyrusUtil.StringSplit(LastKeys[Position], ".")
			if RaceIDs && RaceIDs.length > Position && (!LastRaceIDs || LastRaceIDs.length < Actors || RaceIDs[Position] != LastRaceIDs[Position])
				string id = RaceIDs[Position]
				Race RaceRef = Race.GetRace(id)
				string Gender = ""
				if !(RaceRef || id == "Humanoid" || sslCreatureAnimationSlots.HasRaceKey(id))
					int i = 0
					while i < 6
						i += 1
						id = StringUtil.Substring(RaceIDs[Position], 0, (StringUtil.GetLength(RaceIDs[Position]) - i))
						RaceRef = Race.GetRace(id)
						if RaceRef || id == "Humanoid" || sslCreatureAnimationSlots.HasRaceKey(id)
							Gender = StringUtil.GetNthChar(RaceIDs[Position], (StringUtil.GetLength(RaceIDs[Position]) - i))
							i = 6
						endIf
					endWhile
				endIf
				if Gender && (Gender != "M") && (Gender != "F") && (Gender != "C")
					Gender = ""
				endIf
				if id+Gender == RaceIDs[Position] || id+Gender+"M" == RaceIDs[Position] || id+Gender+"F" == RaceIDs[Position]
					CopyKey = "Global."+Position
				endIf
			endIf
		endIf
		if AdjustKey != "Global."+Position && CopyKey == "Global."+Position && !_HasAdjustments(Registry, CopyKey, Stages)
			; Initialize Global profile
			_CopyAdjustments(Registry, "Global."+Position, GetEmptyAdjustments(Position))
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
	if !Output || Output.Length < 5
		Output = new int[5]
	endIf
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

int function _GetSchlong(string Registrar, string AdjustKey, string LastKey, int Stage) global native
int function GetSchlong(string AdjustKey, int Position, int Stage)
	int var = sslBaseAnimation._GetSchlong(Registry, AdjustKey+"."+Position, LastKeys[Position], Stage)
	if var == -99
		var = FlagsArray(Position)[FlagIndex(Stage, kSchlong)]
	endIf
	return var
endFunction

; 	if HasAdjustments(Registry, AdjustKey+"."+Position, Stage)
; 		return _GetAdjustment(Registry, AdjustKey+"."+Position, Stage, 3) as int
; 	elseIf LastKeys[Position] != "" && HasAdjustments(Registry, LastKeys[Position], Stage)
; 		return _GetAdjustment(Registry, LastKeys[Position], Stage, 3) as int
; 	endIf
; 	return FlagsArray(Position)[FlagIndex(Stage, kSchlong)]
; endFunction

int function GetCumID(int Position, int Stage = 1)
	return FlagsArray(Position)[FlagIndex(Stage, kCumID)]
endFunction

int function GetCumSource(int Position, int Stage = 1)
	return FlagsArray(Position)[FlagIndex(Stage, kCumSrc)]
endFunction

bool function IsCumSource(int SourcePosition, int TargetPosition, int Stage = 1)
	int CumSrc = GetCumSource(TargetPosition, Stage)
	return CumSrc == -1 || CumSrc == SourcePosition 
endFunction

function SetStageCumID(int Position, int Stage, int CumID, int CumSource = -1)
	FlagsArray(Position)[FlagIndex(Stage, kCumID)]  = CumID
	FlagsArray(Position)[FlagIndex(Stage, kCumSrc)] = CumSource
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

bool function MatchGender(int Gender, int Position)
	return Gender == GetGender(Position) || (!GenderedCreatures && Gender > 1)
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

bool function HasValidRaceKey(string[] RaceKeys)
	int i = RaceKeys.Length
	while i
		i -= 1
		if RaceKeys[i] != "" && RaceTypes.Find(RaceKeys[i]) != -1
			return true
		endIf
	endWhile
	return false
endFunction

int function CountValidRaceKey(string[] RaceKeys)
	int i = RaceKeys.Length
	int out = 0
	while i
		i -= 1
		if RaceKeys[i] != "" && RaceTypes.Find(RaceKeys[i]) != -1
			out += PapyrusUtil.CountString(RaceTypes, RaceKeys[i])
		endIf
	endWhile
	return out
endFunction

bool function IsPositionRace(int Position, string RaceKey)
	return RaceTypes && RaceTypes[Position] == RaceKey
endFunction

bool function HasPostionRace(int Position, string[] RaceKeys)
	return RaceTypes && RaceKeys.Find(RaceTypes[Position]) != -1
endFunction

string[] function GetRaceTypes()
	int i = RaceTypes.Length
	string[] out = Utility.CreateStringArray(i)
	while i
		i -= 1
		out[i] = RaceTypes[i]
	endWhile
	return out
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

function SetPositionRaceKey(int Position, string RaceKey)
	if GetGender(Position) >= 2
		if !RaceTypes || RaceTypes.Length
			RaceTypes = new string[5]
		endIf
		RaceTypes[Position] = RaceKey
		RaceType            = RaceKey
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
string[] GenderTags

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

	string GenderString = GetGenderString(Gender)
	GenderTags[0] = GenderTags[0]+GenderString
	GenderTags[1] = GenderString+GenderTags[1]

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
		if !RaceTypes || RaceTypes.Length < 1
			RaceTypes = new string[5]
		endIf
		RaceType       = RaceKey
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
	Flags[fid + 5] = -1
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
	; Add gender tags
	AddTag(GenderTags[0])
	if GenderTags[0] != GenderTags[1]
		AddTag(GenderTags[1])
	endIf
	; Compensate for custom 3P+ animations that mix gender order, such as FMF
	if PositionCount > 2
		AddTag(GetGenderTag(false))
		AddTag(GetGenderTag(true))
	endIf

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
	; Import Offsets
	ImportOffsetsDefault("BedOffset")
	ImportOffsets("BedOffset")
	; Reset saved keys if they no longer match
	if LastKeyReg != Registry
		LastKeys = new string[5]
	endIf
	LastKeyReg = Registry
	; Log the new animation
	if IsCreature
		; RaceTypes = PapyrusUtil.ResizeStringArray(RaceTypes, Actors)
		if IsInterspecies()
			AddTag("Interspecies")
		else
			RemoveTag("Interspecies")
		endIf
		Log(Name, "Creatures["+id+"]")
	else
		Log(Name, "Animations["+id+"]")
	endIf
	; Finalize tags and registry slot id
	parent.Save(id)
endFunction

bool function IsInterspecies()
	if IsCreature
		int Position = PositionCount
		while Position > 1
			Position -= 1
			if RaceTypes[(Position - 1)] != "" && RaceTypes[Position] != ""
				string[] Keys1 = sslCreatureAnimationSlots.GetAllRaceIDs(RaceTypes[(Position - 1)])
				string[] Keys2 = sslCreatureAnimationSlots.GetAllRaceIDs(RaceTypes[Position])
				if Keys1 && Keys2 && Keys1.Length > 0 && Keys2.Length > 0 && Keys1 != Keys2
					int k1 = Keys1.Length
					int k2 = Keys2.Length
					if k1 == 1 && k2 == 1 && Keys1[0] != Keys2[0] 
						return true ; Simple single key mismatch
					elseIf (k1 == 1 && k2 > 1 && Keys2.Find(Keys1[0]) < 0) && \
						   (k2 == 1 && k1 > 1 && Keys1.Find(Keys2[0]) < 0)
					   return true ; Single key to multikey mismatch
					endIf
					bool Matched = false
					while k1
						k1 -= 1
						if Keys2.Find(Keys1[k1]) != -1
							Matched = true ; Matched between multikey arrays
						endIf
					endWhile
					if !Matched
					   return true ; Mismatch between multikey arrays
					endIf
				endIf
			endIf
		endWhile
	endIf
	return false
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

string function GetGenderTag(bool Reverse = false)
	if Reverse
		return GenderTag(Creatures, "C")+GenderTag(Males, "M")+GenderTag(Females, "F")
	endIf
	return GenderTag(Females, "F")+GenderTag(Males, "M")+GenderTag(Creatures, "C")
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
	GenderedCreatures = false

	Genders      = new int[4]
	Positions    = new int[5]
	StageSoundFX = new Form[1]
	GenderTags   = new string[2]

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
int property kCumSrc    = 5 autoreadonly hidden
int property kFlagEnd hidden
	int function get()
		return 6
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

;Animation Offsets
function ExportOffsets(string Type = "BedOffset")
	float[] Values
	if Type == "BedOffset"
		Values = GetBedOffsets()
	else
		return
	endIf
	string File = "../SexLab/SexLabOffsets.json"

	; Set label of export
	JsonUtil.SetStringValue(File, "ExportLabel", "User Defined Offsets " + Utility.GetCurrentRealTime())

	JsonUtil.FloatListClear(File, Registry+"."+Type)
	if PapyrusUtil.CountFloat(Values, 0.0) != Values.Length
		JsonUtil.FloatListCopy(File, Registry+"."+Type, Values)
	endIf

	; Save to JSON file
	JsonUtil.Save(File, true)
endFunction

function ImportOffsets(string Type = "BedOffset")
	float[] Values
	if Type == "BedOffset"
		Values = GetBedOffsets()
	else
		return
	endIf
	string File = "../SexLab/SexLabOffsets.json"
	int len = 4
	if JsonUtil.FloatListCount(File, Registry+"."+Type) == len || JsonUtil.IntListCount(File, Registry+"."+Type) == len
		if Values.Length != len
			Values = Utility.CreateFloatArray(len)
		endIf
		int i = 0
		while i < len
			Values[i] = JsonUtil.FloatListGet(File, Registry+"."+Type, i)
			i += 1
		endWhile
		if Type == "BedOffset"
			BedOffset = Values
		endIf
	endIf
endFunction

function ImportOffsetsDefault(string Type = "BedOffset")
	float[] Values
	if Type == "BedOffset"
		Values = GetBedOffsets()
	else
		return
	endIf
	string File = "../SexLab/SexLabOffsetsDefault.json"
	int len = 4
	if JsonUtil.FloatListCount(File, Registry+"."+Type) == len || JsonUtil.IntListCount(File, Registry+"."+Type) == len
		if Values.Length != len
			Values = Utility.CreateFloatArray(len)
		endIf
		int i = 0
		while i < len
			Values[i] = JsonUtil.FloatListGet(File, Registry+"."+Type, i)
			i += 1
		endWhile
		if Type == "BedOffset"
			BedOffset = Values
		endIf
	endIf
endFunction

function ExportJSON()
	string Folder = "../SexLab/Animations/"
	if IsCreature
		Folder += "Creatures/"
	endIf
	string Filename = Folder+Registry+".json"

	JsonUtil.ClearAll(Filename)

	JsonUtil.SetPathStringValue(Filename, ".name", Name)
	JsonUtil.SetPathIntValue(Filename, ".enabled", Enabled as int)
	JsonUtil.SetPathStringArray(Filename, ".tags", GetTags())

	; JsonUtil.SetRawPathValue(Filename, ".tags", "[\""+PapyrusUtil.StringJoin(GetTags(), "\",\"")+"\"]")
	if StageSoundFX
		JsonUtil.SetPathFormArray(Filename, ".sfx", StageSoundFX)
	endIf
	if Timers
		JsonUtil.SetPathFloatArray(Filename, ".timers", Timers)
	endIf
	; if IsCreature
	; 	JsonUtil.SetPathStringArray(Filename, ".racetypes", Utility.ResizeStringArray(RaceTypes, PositionCount))
	; endIf

	int Position
	while Position < PositionCount

		int stg = 0
		while stg < StageCount
			string Path = ".positions["+Position+"]"
			int Stage = stg + 1

			JsonUtil.SetPathStringValue(Filename, Path+".animation["+stg+"]", Animations[StageIndex(Position, Stage)])
			JsonUtil.SetPathFloatArray(Filename, Path+".offset["+stg+"]", GetRawOffsets(Position, Stage))

			int[] Flags = FlagsArray(Position)
			int fi = FlagIndex(Stage, 0)

			JsonUtil.SetPathIntValue(Filename, Path+".flag.schlong["+stg+"]", Flags[(fi + 3)])
			JsonUtil.SetPathIntValue(Filename, Path+".flag.cum["+stg+"]", Flags[(fi + 4)])
			JsonUtil.SetPathIntValue(Filename, Path+".flag.cumsrc["+stg+"]", Flags[(fi + 5)])
			JsonUtil.SetPathIntValue(Filename, Path+".flag.openmouth["+stg+"]", Flags[(fi + 1)])
			JsonUtil.SetPathIntValue(Filename, Path+".flag.silent["+stg+"]", Flags[(fi + 0)])
			JsonUtil.SetPathIntValue(Filename, Path+".flag.strapon["+stg+"]", Flags[(fi + 2)])

			stg += 1
		endWhile

		JsonUtil.SetPathIntValue(Filename, ".positions["+Position+"].gender", GetGender(Position))

		if IsCreature && CreaturePosition(Position)
			if RaceTypes[Position] == ""
				JsonUtil.SetPathStringValue(Filename, ".positions["+Position+"].creature", RaceType)
			else
				JsonUtil.SetPathStringValue(Filename, ".positions["+Position+"].creature", RaceTypes[Position])
			endIf
		endIf

		Position += 1

	endWhile

	JsonUtil.Save(Filename)
	JsonUtil.Unload(Filename)
endFunction
