scriptname sslActorStats extends sslSystemLibrary


import StorageUtil
import PapyrusUtil
import Utility
import Math

; Titles
string[] StatTitles
string[] PureTitlesMale
string[] PureTitlesFemale
string[] LewdTitlesMale
string[] LewdTitlesFemale

string[] SkillNames

; ------------------------------------------------------- ;
; --- Manipulate Custom Stats                         --- ;
; ------------------------------------------------------- ;

int function FindStat(string Stat)
	return StringListFind(self, "Custom", Stat)
endFunction

int function RegisterStat(string Stat, string Value, string Prepend = "", string Append = "")
	if FindStat(Stat) == -1
		StringListAdd(self, "Custom", Stat, false)
		SetStringValue(self, "Custom.Default."+Stat, Value)
		SetStringValue(self, "Custom.Prepend."+Stat, Prepend)
		SetStringValue(self, "Custom.Append."+Stat, Append)
		SetStat(PlayerRef, Stat, Value)
	endIf
	return FindStat(Stat)
endFunction

int function GetNumStats()
	return StringListCount(self, "Custom")
endFunction

string function GetNthStat(int i)
	return StringListGet(self, "Custom", i)
endFunction

function Alter(string Name, string NewName = "", string Value = "", string Prepend = "", string Append = "")
	int i = FindStat(Name)
	if i != -1
		if NewName != ""
			StringListSet(self, "Custom", i, NewName)
			SetStringValue(self, "Custom.Default."+NewName, GetStringValue(self, "Custom.Default."+Name))
			SetStringValue(self, "Custom.Prepend."+NewName, GetStringValue(self, "Custom.Prepend."+Name))
			SetStringValue(self, "Custom.Append."+NewName, GetStringValue(self, "Custom.Append."+Name))
			UnsetStringValue(self, "Custom.Default."+Name)
			UnsetStringValue(self, "Custom.Prepend."+Name)
			UnsetStringValue(self, "Custom.Append."+Name)
			Name = NewName
		endIf
		if Value != ""
			SetStringValue(self, "Custom.Default."+Name, Value)
		endIf
		if Prepend != ""
			SetStringValue(self, "Custom.Prepend."+Name, Prepend)
		endIf
		if Append != ""
			SetStringValue(self, "Custom.Append."+Name, Append)
		endIf
	endIf
endFunction

bool function ClearStat(Actor ActorRef, string Stat)
	if HasStat(ActorRef, Stat)
		UnsetStringValue(ActorRef, "sslActorStats.Custom."+Stat)
		return true
	endIf
	return false
endFunction

function SetStat(Actor ActorRef, string Stat, string Value)
	if FindStat(Stat) != -1
		SetStringValue(ActorRef, "sslActorStats.Custom."+Stat, Value)
	endIf
endFunction

int function AdjustBy(Actor ActorRef, string Stat, int Adjust)
	if FindStat(Stat) == -1
		return 0
	endIf
	int Value = GetStatInt(ActorRef, Stat)
	Value += Adjust
	SetStat(ActorRef, Stat, (Value as string))
	return Value
endFunction

bool function HasStat(Actor ActorRef, string Stat)
	return HasStringValue(ActorRef, "sslActorStats.Custom."+Stat)
endFunction

string function GetStat(Actor ActorRef, string Stat)
	if !HasStat(ActorRef, Stat)
		return GetStatDefault(Stat)
	endIf
	return GetStringValue(ActorRef, "sslActorStats.Custom."+Stat)
endFunction

string function GetStatString(Actor ActorRef, string Stat)
	return GetStat(ActorRef, Stat)
endFunction

float function GetStatFloat(Actor ActorRef, string Stat)
	return GetStat(ActorRef, Stat) as float
endFunction

int function GetStatInt(Actor ActorRef, string Stat)
	return GetStat(ActorRef, Stat) as int
endFunction

int function GetStatLevel(Actor ActorRef, string Stat, float Curve = 0.85)
	return CalcLevel(GetStatInt(ActorRef, Stat), Curve)
endFunction

string function GetStatTitle(Actor ActorRef, string Stat, float Curve = 0.85)
	return StatTitles[ClampInt(CalcLevel(GetStatFloat(ActorRef, Stat), Curve), 0, 6)]
endFunction

string function GetStatDefault(string Stat)
	return GetStringValue(self, "Custom.Default."+Stat, "0")
endFunction

string function GetStatPrepend(string Stat)
	return GetStringValue(self, "Custom.Prepend."+Stat, "")
endFunction

string function GetStatAppend(string Stat)
	return GetStringValue(self, "Custom.Append."+Stat, "")
endFunction

string function GetStatFull(Actor ActorRef, string Stat)
	return GetStatPrepend(Stat) + GetStat(ActorRef, Stat) + GetStatAppend(Stat)
endFunction

; ------------------------------------------------------- ;
; --- Calculators & Parsers                           --- ;
; ------------------------------------------------------- ;

int function CalcSexuality(bool IsFemale, int Males, int Females)
	; Calculate "sexuality ratio" 0 = full homosexual, 100 = full heterosexual
	if IsFemale
		return (((Males + 1.0) / ((Males + Females + 1) as float)) * 100.0) as int
	else
		return (((Females + 1.0) / ((Males + Females + 1) as float)) * 100.0) as int
	endIf
endFunction

float function CalcLevelFloat(float Total, float Curve = 0.85)
	if Total < 0.0
		return 0.0
	endIf
	return Math.Sqrt((Math.Abs(Total) / 2.0) * Curve)
endFunction

int function CalcLevel(float Total, float Curve = 0.85)
	return CalcLevelFloat(Total, Curve) as int
endFunction

string function ZeroFill(string num)
	if StringUtil.GetLength(num) == 1
		return "0"+num
	endIf
	return num
endFunction

string function ParseTime(int time)
	if time > 0
		return ZeroFill(((time / 3600) as int))+":"+ZeroFill((((time / 60) % 60) as int))+":"+ZeroFill((time % 60 as int))
	endIf
	return "--:--:--"
endFunction

; ------------------------------------------------------- ;
; --- Sex Skills                                      --- ;
; ------------------------------------------------------- ;

bool function IsSkilled(Actor ActorRef) global native

function _SeedActor(Actor ActorRef, float RealTime, float GameTime) global native
function SeedActor(Actor ActorRef)
	if ActorRef != PlayerRef && !IsSkilled(ActorRef) && ActorRef.HasKeyword(Config.ActorTypeNPC)
		_SeedActor(ActorRef, Utility.GetCurrentRealTime(), Utility.GetCurrentGameTime())
		Log(ActorRef.GetLeveledActorBase().GetName()+" Seeded: "+GetSkills(ActorRef))
	endIf
endFunction

float function _GetSkill(Actor ActorRef, int Stat) global native
int function GetSkill(Actor ActorRef, string Skill)
	SeedActor(ActorRef)
	return _GetSkill(ActorRef, SkillNames.Find(Skill)) as int
endFunction
float function GetSkillFloat(Actor ActorRef, string Skill)
	SeedActor(ActorRef)
	return _GetSkill(ActorRef, SkillNames.Find(Skill))
endFunction

function _SetSkill(Actor ActorRef, int Stat, float Value) global native
function SetSkill(Actor ActorRef, string Skill, int Amount)
	SeedActor(ActorRef)
	_SetSkill(ActorRef, SkillNames.Find(Skill), Amount as float)
endFunction
function SetSkillFloat(Actor ActorRef, string Skill, float Amount)
	SeedActor(ActorRef)
	_SetSkill(ActorRef, SkillNames.Find(Skill), Amount)
endFunction

float function _AdjustSkill(Actor ActorRef, int Stat, float By) global native
function AdjustSkill(Actor ActorRef, string Skill, int Amount)
	SeedActor(ActorRef)
	_AdjustSkill(ActorRef, SkillNames.Find(Skill), Amount as float)
endfunction
function AdjustSkillFloat(Actor ActorRef, string Skill, float Amount)
	SeedActor(ActorRef)
	_AdjustSkill(ActorRef, SkillNames.Find(Skill), Amount)
endFunction

int function GetSkillLevel(Actor ActorRef, string Skill, float Curve = 0.85)
	return CalcLevel(GetSkill(ActorRef, Skill), Curve)
endFunction

string function GetSkillTitle(Actor ActorRef, string Skill, float Curve = 0.85)
	return StatTitles[ClampInt(GetSkillLevel(ActorRef, Skill, Curve), 0, 6)]
endFunction

string function GetTitle(int Level)
	return StatTitles[ClampInt(Level, 0, 6)]
endFunction

function _GetSkills(Actor ActorRef, float[] Output) global native
float[] function GetSkills(Actor ActorRef) global
	float[] Output = FloatArray(18)
	_GetSkills(ActorRef, Output)
	return Output
endFunction

float[] function GetSkillLevels(Actor ActorRef)
	float[] Skills = GetSkills(ActorRef)
	float[] Output = new float[6]
	Output[0] = CalcLevelFloat(Skills[0], 0.85)
	Output[1] = CalcLevelFloat(Skills[1], 0.85)
	Output[2] = CalcLevelFloat(Skills[2], 0.85)
	Output[3] = CalcLevelFloat(Skills[3], 0.85)
	Output[4] = CalcLevelFloat(Skills[4], 0.30)
	Output[5] = CalcLevelFloat(Skills[5], 0.30)
	return Output
endFunction

function AddSkillXP(Actor ActorRef, float Foreplay = 0.0, float Vaginal = 0.0, float Anal = 0.0, float Oral = 0.0)
	_AdjustSkill(ActorRef, kForeplay, Foreplay)
	_AdjustSkill(ActorRef, kVaginal, Vaginal)
	_AdjustSkill(ActorRef, kAnal, Anal)
	_AdjustSkill(ActorRef, kOral, Oral)
endFunction

; ------------------------------------------------------- ;
; --- Purity/Impurty Stat                             --- ;
; ------------------------------------------------------- ;

int function GetPure(Actor ActorRef)
	return _GetSkill(ActorRef, kPure) as int
endFunction

int function GetPureLevel(Actor ActorRef)
	return CalcLevel(GetPure(ActorRef), 0.3)
endFunction

string function GetPureTitle(Actor ActorRef)
	if ActorRef.GetLeveledActorBase().GetSex() == 1
		return PureTitlesFemale[ClampInt(GetPureLevel(ActorRef), 0, 6)]
	else
		return PureTitlesMale[ClampInt(GetPureLevel(ActorRef), 0, 6)]
	endIf
endFunction

int function GetLewd(Actor ActorRef)
	return _GetSkill(ActorRef, kLewd) as int
endFunction

int function GetLewdLevel(Actor ActorRef)
	return CalcLevel(GetLewd(ActorRef), 0.3)
endFunction

string function GetLewdTitle(Actor ActorRef)
	if ActorRef.GetLeveledActorBase().GetSex() == 1
		return LewdTitlesFemale[ClampInt(GetLewdLevel(ActorRef), 0, 6)]
	else
		return LewdTitlesMale[ClampInt(GetLewdLevel(ActorRef), 0, 6)]
	endIf
endFunction

bool function IsPure(Actor ActorRef)
	return GetPurity(ActorRef) >= 0.0;GetPure(ActorRef) >= GetLewd(ActorRef)
endFunction

bool function IsLewd(Actor ActorRef)
	return GetPurity(ActorRef) < 0.0 ;GetPure(ActorRef) < GetLewd(ActorRef)
endFunction

float function GetPurity(Actor ActorRef)
	return ((GetPure(ActorRef) - GetLewd(ActorRef)) as float) * 1.5
endFunction

float function AdjustPurity(Actor ActorRef, float Adjust)
	string type = "Pure"
	if Adjust < 0.0
		type = "Lewd"
	endIf
	AdjustSkillFloat(ActorRef, type, Math.Abs(Adjust))
	return GetSkillFloat(ActorRef, type)
endFunction

string function GetPurityTitle(Actor ActorRef)
	if IsLewd(ActorRef)
		return GetLewdTitle(ActorRef)
	else
		return GetPureTitle(ActorRef)
	endIf
endFunction

int function GetPurityLevel(Actor ActorRef)
	return CalcLevel(Math.Abs(GetPurity(ActorRef)), 0.3)
endFunction

function AddPurityXP(Actor ActorRef, float Pure, float Lewd, bool IsAggressive, bool IsVictim, bool WithCreature, int ActorCount, int HadRelation)
	; Aggressive modifier for victim/aggressor
	if IsAggressive && IsVictim
		_AdjustSkill(ActorRef, kVictim, 1)
		Pure -= 1.0
		Lewd += 1.0
	elseIf IsAggressive
		_AdjustSkill(ActorRef, kAggressor, 1)
		Pure -= 2.0
		Lewd += 2.0
	endIf
	; Creature modifier
	if WithCreature
		Pure -= 1.0
		Lewd += 2.0
	endIf
	; Actor count modifier
	if ActorCount == 1
		Lewd += 1.0
	elseIf ActorCount > 2
		Pure -= (ActorCount - 1) * 2.0
		Lewd += (ActorCount - 1) * 2.0
	endIf
	; Relationship modifier
	int HighestRelation = ActorRef.GetHighestRelationshipRank()
	if HighestRelation == 4 && HadRelation == 4
		Pure += 4.0
	elseIf HighestRelation == 4 && !IsVictim
		Pure -= 2.0
		Lewd += 2.0
	endIf
	; Save adjustments
	_AdjustSkill(ActorRef, kPure, Pure)
	_AdjustSkill(ActorRef, kLewd, Lewd)
endFunction

; ------------------------------------------------------- ;
; --- Sex Counters                                    --- ;
; ------------------------------------------------------- ;

function AddSex(Actor ActorRef, float TimeSpent = 0.0, bool WithPlayer = false, bool IsAggressive = false, int Males = 0, int Females = 0, int Creatures = 0)
	_AdjustSkill(ActorRef, kTimeSpent, TimeSpent)
	_SetSkill(ActorRef, kLastGameTime, Utility.GetCurrentGameTime())
	_SetSkill(ActorRef, kLastRealTime, Utility.GetCurrentRealTime())

	int ActorCount = (Males + Females + Creatures)
	if ActorCount > 1
		int Gender = GetGender(ActorRef)
		Males -= (Gender == 0) as int
		Females -= (Gender == 1) as int
		_AdjustSkill(ActorRef, kMales, Males)
		_AdjustSkill(ActorRef, kFemales, Females)
		_AdjustSkill(ActorRef, kCreatures, Creatures)
		_AdjustSkill(ActorRef, kSexCount, 1)
		if ActorRef != PlayerRef
			if !IsAggressive
				AdjustSexuality(ActorRef, Males * 2, Females * 2)
			else
				AdjustSexuality(ActorRef, Males, Females)
			endIf
		endIf
	else
		_AdjustSkill(ActorRef, kMasturbation, 1)
	endIf
	if WithPlayer && ActorRef != PlayerRef
		_AdjustSkill(ActorRef, kPlayerSex, 1)
		; FormListAdd(PlayerRef, "SexPartners", ActorRef, false)
	endIf
endFunction

int function SexCount(Actor ActorRef)
	return _GetSkill(ActorRef, kSexCount) as int
endFunction

bool function HadSex(Actor ActorRef)
	return _GetSkill(ActorRef, kSexCount) >= 1.0
endFunction

int function PlayerSexCount(Actor ActorRef)
	return _GetSkill(ActorRef, kPlayerSex) as int
endFunction

bool function HadPlayerSex(Actor ActorRef)
	return _GetSkill(ActorRef, kPlayerSex) >= 1.0
endFunction

; ------------------------------------------------------- ;
; --- Sexuality Stats                                 --- ;
; ------------------------------------------------------- ;

function AdjustSexuality(Actor ActorRef, int Males, int Females)
	bool IsFemale = GetGender(ActorRef) == 1
	float Ratio = _GetSkill(ActorRef, kSexuality)
	if Ratio == 0.0
		Ratio = 80.0
	endIf
	if IsFemale
		Ratio += (Males - Females)
	else
		Ratio += (Females - Males)
	endIf
	_SetSkill(ActorRef, kSexuality, ClampFloat(Ratio, 1.0, 100.0) as float)
endFunction

int function GetSexuality(Actor ActorRef)
	float Ratio = _GetSkill(ActorRef, kSexuality)
	if Ratio > 0.0
		return Ratio as int
	else
		return 100
	endIf
endFunction

string function GetSexualityTitle(Actor ActorRef)
	float ratio = _GetSkill(ActorRef, kSexuality)
	; Return sexuality title
	if ratio >= 65.0 || ratio == 0.0
		return "$SSL_Heterosexual"
	elseif ratio < 65.0 && ratio > 35.0
		return "$SSL_Bisexual"
	elseif GetGender(ActorRef) == 1
		return "$SSL_Lesbian"
	else
		return "$SSL_Gay"
	endIf
endFunction

bool function IsStraight(Actor ActorRef)
	return _GetSkill(ActorRef, kSexuality) >= 65.0
endFunction

bool function IsBisexual(Actor ActorRef)
	float ratio = _GetSkill(ActorRef, kSexuality)
	return ratio < 65.0 && ratio > 35.0
endFunction

bool function IsGay(Actor ActorRef)
	return _GetSkill(ActorRef, kSexuality) <= 35.0
endFunction

; ------------------------------------------------------- ;
; --- Time Based Stats                                --- ;
; ------------------------------------------------------- ;

; Last sex - Game time1 - float days
float function LastSexGameTime(Actor ActorRef)
	return _GetSkill(ActorRef, kLastGameTime)
endFunction

float function DaysSinceLastSex(Actor ActorRef)
	return Utility.GetCurrentGameTime() - LastSexGameTime(ActorRef)
endFunction

float function HoursSinceLastSex(Actor ActorRef)
	return DaysSinceLastSex(ActorRef) * 24.0
endFunction

float function MinutesSinceLastSex(Actor ActorRef)
	return DaysSinceLastSex(ActorRef) * 1440.0
endFunction

float function SecondsSinceLastSex(Actor ActorRef)
	return DaysSinceLastSex(ActorRef) * 86400.0
endFunction

string function LastSexTimerString(Actor ActorRef)
	return ParseTime(SecondsSinceLastSex(ActorRef) as int)
endFunction

; Last sex - Real Time - float seconds
float function LastSexRealTime(Actor ActorRef)
	return _GetSkill(ActorRef, kLastRealTime)
endFunction

float function SecondsSinceLastSexRealTime(Actor ActorRef)
	float LastSex = LastSexRealTime(ActorRef)
	if LastSex > 0.0
		return Utility.GetCurrentRealTime() - LastSex
	endIf
	return 0.0
endFunction

float function MinutesSinceLastSexRealTime(Actor ActorRef)
	return SecondsSinceLastSexRealTime(ActorRef) / 60.0
endFunction

float function HoursSinceLastSexRealTime(Actor ActorRef)
	return SecondsSinceLastSexRealTime(ActorRef) / 3600.0
endFunction

float function DaysSinceLastSexRealTime(Actor ActorRef)
	return SecondsSinceLastSexRealTime(ActorRef) / 86400.0
endFunction

string function LastSexTimerStringRealTime(Actor ActorRef)
	return ParseTime(SecondsSinceLastSexRealTime(ActorRef) as int)
endFunction

; ------------------------------------------------------- ;
; --- System Use                                      --- ;
; ------------------------------------------------------- ;


function RecordThread(Actor ActorRef, int Gender, int HadRelation, float StartedAt, float RealTime, float GameTime, bool WithPlayer, Actor VictimRef, int[] Genders, float[] SkillXP) global native
;/ function RecordThread(Actor ActorRef, bool HasPlayer, int Positions, int HighestRelation, float TotalTime, Actor VictimRef, float[] SkillXP, int[] Genders)
	AddSkillXP(ActorRef, SkillXP[0], SkillXP[1], SkillXP[2], SkillXP[3])
	AddPurityXP(ActorRef, SkillXP[4], SkillXP[5], VictimRef != none, VictimRef == ActorRef, Genders[2] > 0, Positions, HighestRelation)
	AddSex(ActorRef, TotalTime, HasPlayer, VictimRef != none, Genders[0], Genders[1], Genders[2])
endFunction /;

function ResetStats(Actor ActorRef)
	FloatListClear(ActorRef, "SexLabSkills")
	FormListClear(ActorRef, "SexPartners")
	ClearCustomStats(ActorRef)
	ClearLegacyStats(ActorRef)
endFunction

function Setup()
	parent.Setup()

	StatTitles = new string[7]
	StatTitles[0] = "$SSL_Unskilled"
	StatTitles[1] = "$SSL_Novice"
	StatTitles[2] = "$SSL_Apprentice"
	StatTitles[3] = "$SSL_Journeyman"
	StatTitles[4] = "$SSL_Expert"
	StatTitles[5] = "$SSL_Master"
	StatTitles[6] = "$SSL_GrandMaster"

	PureTitlesMale = new string[7]
	PureTitlesMale[0] = "$SSL_Neutral"
	PureTitlesMale[1] = "$SSL_Unsullied"
	PureTitlesMale[2] = "$SSL_CleanCut"
	PureTitlesMale[3] = "$SSL_Virtuous"
	PureTitlesMale[4] = "$SSL_EverFaithful"
	PureTitlesMale[5] = "$SSL_Lordly"
	PureTitlesMale[6] = "$SSL_Saintly"

	LewdTitlesMale = new string[7]
	LewdTitlesMale[0] = "$SSL_Neutral"
	LewdTitlesMale[1] = "$SSL_Experimenting"
	LewdTitlesMale[2] = "$SSL_UnusuallyHorny"
	LewdTitlesMale[3] = "$SSL_Promiscuous"
	LewdTitlesMale[4] = "$SSL_SexualDeviant"
	LewdTitlesMale[5] = "$SSL_Depraved"
	LewdTitlesMale[6] = "$SSL_Hypersexual"

	PureTitlesFemale = new string[7]
	PureTitlesFemale[0] = "$SSL_Neutral"
	PureTitlesFemale[1] = "$SSL_Unsullied"
	PureTitlesFemale[2] = "$SSL_PrimProper"
	PureTitlesFemale[3] = "$SSL_Virtuous"
	PureTitlesFemale[4] = "$SSL_EverFaithful"
	PureTitlesFemale[5] = "$SSL_Ladylike"
	PureTitlesFemale[6] = "$SSL_Saintly"

	LewdTitlesFemale = new string[7]
	LewdTitlesFemale[0] = "$SSL_Neutral"
	LewdTitlesFemale[1] = "$SSL_Experimenting"
	LewdTitlesFemale[2] = "$SSL_UnusuallyHorny"
	LewdTitlesFemale[3] = "$SSL_Promiscuous"
	LewdTitlesFemale[4] = "$SSL_SexualDeviant"
	LewdTitlesFemale[5] = "$SSL_Debaucherous"
	LewdTitlesFemale[6] = "$SSL_Nymphomaniac"

	SkillNames = new string[18]
	SkillNames[0] = "Foreplay"
	SkillNames[1] = "Vaginal"
	SkillNames[2] = "Anal"
	SkillNames[3] = "Oral"
	SkillNames[4] = "Pure"
	SkillNames[5] = "Lewd"
	SkillNames[6] = "Males"
	SkillNames[7] = "Females"
	SkillNames[8] = "Creatures"
	SkillNames[9] = "Masturbation"
	SkillNames[10] = "Aggressor"
	SkillNames[11] = "Victim"
	SkillNames[12] = "SexCount"
	SkillNames[13] = "PlayerSex"
	SkillNames[14] = "Sexuality"
	SkillNames[15] = "TimeSpent"
	SkillNames[16] = "LastSex.RealTime"
	SkillNames[17] = "LastSex.GameTime"

	; v1.59b - Converted stats to use float lists instead of individual values
	UpgradeLegacyStats(PlayerRef)
	int i = FormListCount(none, "SexLab.SeededActors")
	if i > 0
		; Log(i, "SeededActors")
		while i
			i -= 1
			if FormListGet(none, "SexLab.SeededActors", i) != none
				UpgradeLegacyStats(FormListGet(none, "SexLab.SeededActors", i) as Actor)
			endIf
			FormListRemoveAt(none, "SexLab.SeededActors", i)
		endWhile
	endIf
endFunction

function ClearCustomStats(Actor ActorRef)
	int i = StringListCount(self, "Custom")
	while i
		i -= 1
		UnsetStringValue(ActorRef, "sslActorStats.Custom."+StringListGet(self, "Custom", i))
	endWhile
endFunction

bool function IsImportant(Actor ActorRef)
	if !ActorRef || ActorRef.IsDead() || ActorRef.IsDisabled()
		return false
	endIf
	ActorBase BaseRef = ActorRef.GetLeveledActorBase()
	return BaseRef.IsUnique() || BaseRef.IsEssential() || BaseRef.IsInvulnerable() || BaseRef.IsProtected() || ActorRef == PlayerRef
endFunction

function UpgradeLegacyStats(Actor ActorRef)
	if !ActorRef
		return
	elseIf !IsImportant(ActorRef)
		ClearLegacyStats(ActorRef)
		ClearCustomStats(ActorRef)
		FloatListClear(ActorRef, "SexLabSkills")
		Log("Skills Removed", ActorRef.GetLeveledActorBase().GetName())
	elseIf ActorRef && FloatListCount(ActorRef, "SexLabSkills") != SkillNames.Length
		FloatListClear(ActorRef, "SexLabSkills")
		FloatListAdd(ActorRef, "SexLabSkills", GetIntValue(ActorRef, "sslActorStats."+SkillNames[0]) as float)
		FloatListAdd(ActorRef, "SexLabSkills", GetIntValue(ActorRef, "sslActorStats."+SkillNames[1]) as float)
		FloatListAdd(ActorRef, "SexLabSkills", GetIntValue(ActorRef, "sslActorStats."+SkillNames[2]) as float)
		FloatListAdd(ActorRef, "SexLabSkills", GetIntValue(ActorRef, "sslActorStats."+SkillNames[3]) as float)
		FloatListAdd(ActorRef, "SexLabSkills", GetIntValue(ActorRef, "sslActorStats."+SkillNames[4]) as float)
		FloatListAdd(ActorRef, "SexLabSkills", GetIntValue(ActorRef, "sslActorStats."+SkillNames[5]) as float)
		FloatListAdd(ActorRef, "SexLabSkills", GetIntValue(ActorRef, "sslActorStats."+SkillNames[6]) as float)
		FloatListAdd(ActorRef, "SexLabSkills", GetIntValue(ActorRef, "sslActorStats."+SkillNames[7]) as float)
		FloatListAdd(ActorRef, "SexLabSkills", GetIntValue(ActorRef, "sslActorStats."+SkillNames[8]) as float)
		FloatListAdd(ActorRef, "SexLabSkills", GetIntValue(ActorRef, "sslActorStats."+SkillNames[9]) as float)
		FloatListAdd(ActorRef, "SexLabSkills", GetIntValue(ActorRef, "sslActorStats."+SkillNames[10]) as float)
		FloatListAdd(ActorRef, "SexLabSkills", GetIntValue(ActorRef, "sslActorStats."+SkillNames[11]) as float)
		FloatListAdd(ActorRef, "SexLabSkills", GetIntValue(ActorRef, "sslActorStats."+SkillNames[12]) as float)
		FloatListAdd(ActorRef, "SexLabSkills", GetIntValue(ActorRef, "sslActorStats."+SkillNames[13]) as float)
		FloatListAdd(ActorRef, "SexLabSkills", GetIntValue(ActorRef, "sslActorStats."+SkillNames[14]) as float)

		FloatListAdd(ActorRef, "SexLabSkills", GetFloatValue(ActorRef, "sslActorStats."+SkillNames[15]))
		FloatListAdd(ActorRef, "SexLabSkills", GetFloatValue(ActorRef, "sslActorStats."+SkillNames[16]))
		FloatListAdd(ActorRef, "SexLabSkills", GetFloatValue(ActorRef, "sslActorStats."+SkillNames[17]))

		ClearLegacyStats(ActorRef)
		FormListAdd(none, "SexLab.SkilledActors", ActorRef, false)
		Log("Skills Upgraded", ActorRef.GetLeveledActorBase().GetName())
	endIf
endFunction

function ClearLegacyStats(Actor ActorRef)
	UnsetIntValue(ActorRef, "sslActorStats."+SkillNames[0])
	UnsetIntValue(ActorRef, "sslActorStats."+SkillNames[1])
	UnsetIntValue(ActorRef, "sslActorStats."+SkillNames[2])
	UnsetIntValue(ActorRef, "sslActorStats."+SkillNames[3])
	UnsetIntValue(ActorRef, "sslActorStats."+SkillNames[4])
	UnsetIntValue(ActorRef, "sslActorStats."+SkillNames[5])
	UnsetIntValue(ActorRef, "sslActorStats."+SkillNames[6])
	UnsetIntValue(ActorRef, "sslActorStats."+SkillNames[7])
	UnsetIntValue(ActorRef, "sslActorStats."+SkillNames[8])
	UnsetIntValue(ActorRef, "sslActorStats."+SkillNames[9])
	UnsetIntValue(ActorRef, "sslActorStats."+SkillNames[10])
	UnsetIntValue(ActorRef, "sslActorStats."+SkillNames[11])
	UnsetIntValue(ActorRef, "sslActorStats."+SkillNames[12])
	UnsetIntValue(ActorRef, "sslActorStats."+SkillNames[13])
	UnsetIntValue(ActorRef, "sslActorStats."+SkillNames[14])

	UnsetFloatValue(ActorRef, "sslActorStats."+SkillNames[15])
	UnsetFloatValue(ActorRef, "sslActorStats."+SkillNames[16])
	UnsetFloatValue(ActorRef, "sslActorStats."+SkillNames[17])
	UnsetFloatValue(ActorRef, "sslActorStats.Purity")
endFunction

function CleanDeadStats()
	int i = FormListCount(none, "SexLab.SkilledActors")
	while i
		i -= 1
		if FormListGet(none, "SexLab.SkilledActors", i) != none
			Actor ActorRef = FormListGet(none, "SexLab.SkilledActors", i) as Actor
			if ActorRef && ActorRef != PlayerRef && ActorRef.IsDead()
				ResetStats(ActorRef)
				FormListRemove(none, "SexLab.SkilledActors", ActorRef)
				Log("Skills Removed", ActorRef.GetLeveledActorBase().GetName())
			endIf
		else
			FormListRemoveAt(none, "SexLab.SkilledActors", i)
		endIf
	endWhile
endFunction


function ConvertStats()
	CleanDeadStats()

	int i = FormListCount(none, "SexLab.SkilledActors")
	while i
		i -= 1
		if FormListGet(none, "SexLab.SkilledActors", i) != none
			Actor ActorRef = FormListGet(none, "SexLab.SkilledActors", i) as Actor
			_SetSkill(ActorRef, 0, FloatListGet(ActorRef, "SexLabSkills", 0))
			_SetSkill(ActorRef, 1, FloatListGet(ActorRef, "SexLabSkills", 1))
			_SetSkill(ActorRef, 2, FloatListGet(ActorRef, "SexLabSkills", 2))
			_SetSkill(ActorRef, 3, FloatListGet(ActorRef, "SexLabSkills", 3))
			_SetSkill(ActorRef, 4, FloatListGet(ActorRef, "SexLabSkills", 4))
			_SetSkill(ActorRef, 5, FloatListGet(ActorRef, "SexLabSkills", 5))
			_SetSkill(ActorRef, 6, FloatListGet(ActorRef, "SexLabSkills", 6))
			_SetSkill(ActorRef, 7, FloatListGet(ActorRef, "SexLabSkills", 7))
			_SetSkill(ActorRef, 8, FloatListGet(ActorRef, "SexLabSkills", 8))
			_SetSkill(ActorRef, 9, FloatListGet(ActorRef, "SexLabSkills", 9))
			_SetSkill(ActorRef, 10, FloatListGet(ActorRef, "SexLabSkills", 10))
			_SetSkill(ActorRef, 11, FloatListGet(ActorRef, "SexLabSkills", 11))
			_SetSkill(ActorRef, 12, FloatListGet(ActorRef, "SexLabSkills", 12))
			_SetSkill(ActorRef, 13, FloatListGet(ActorRef, "SexLabSkills", 13))
			_SetSkill(ActorRef, 14, FloatListGet(ActorRef, "SexLabSkills", 14))
			_SetSkill(ActorRef, 15, FloatListGet(ActorRef, "SexLabSkills", 15))
			_SetSkill(ActorRef, 16, FloatListGet(ActorRef, "SexLabSkills", 16))
			_SetSkill(ActorRef, 17, FloatListGet(ActorRef, "SexLabSkills", 17))
			FloatListClear(ActorRef, "SexLabSkills")
			Log("Convert: ", ActorRef.GetLeveledActorBase().GetName()+" - "+GetSkills(ActorRef))
		endif
		FormListRemoveAt(none, "SexLab.SkilledActors", i)
	endwhile
endFunction

int function GetGender(Actor ActorRef)
	ActorBase BaseRef = ActorRef.GetLeveledActorBase()
	if SexLabUtil.HasRace(BaseRef.GetRace())
		return 2 ; Creature
	elseIf ActorRef.IsInFaction(config.GenderFaction)
		return ActorRef.GetFactionRank(config.GenderFaction) ; Override
	endIf
	return BaseRef.GetSex() ; Default
endFunction


; ------------------------------------------------------- ;
; --- Skill Type IDs
; ------------------------------------------------------- ;

int function StatID(string Name)
	return SkillNames.Find(Name)
endFunction
int property kForeplay hidden
	int function get()
		return 0
	endFunction
endProperty
int property kVaginal hidden
	int function get()
		return 1
	endFunction
endProperty
int property kAnal hidden
	int function get()
		return 2
	endFunction
endProperty
int property kOral hidden
	int function get()
		return 3
	endFunction
endProperty
int property kPure hidden
	int function get()
		return 4
	endFunction
endProperty
int property kLewd hidden
	int function get()
		return 5
	endFunction
endProperty
int property kMales hidden
	int function get()
		return 6
	endFunction
endProperty
int property kFemales hidden
	int function get()
		return 7
	endFunction
endProperty
int property kCreatures hidden
	int function get()
		return 8
	endFunction
endProperty
int property kMasturbation hidden
	int function get()
		return 9
	endFunction
endProperty
int property kAggressor hidden
	int function get()
		return 10
	endFunction
endProperty
int property kVictim hidden
	int function get()
		return 11
	endFunction
endProperty
int property kSexCount hidden
	int function get()
		return 12
	endFunction
endProperty
int property kPlayerSex hidden
	int function get()
		return 13
	endFunction
endProperty
int property kSexuality hidden
	int function get()
		return 14
	endFunction
endProperty
int property kTimeSpent hidden
	int function get()
		return 15
	endFunction
endProperty
int property kLastRealTime hidden
	int function get()
		return 16
	endFunction
endProperty
int property kLastGameTime hidden
	int function get()
		return 17
	endFunction
endProperty


; ------------------------------------------------------- ;
; --- DEPRECATED - DO NOT USE                         --- ;
; ------------------------------------------------------- ;

; v1.59b NOTICE:
; SexLab native skills storage has changed to use lists for storage
; instead of values. This allows for faster access internally and
; significantly shrinks the amount of data StorageUtil has to store.

; These functions will now reroute to their appropiate new/updated functions if
; they are used to attempt to access the native skills. If accessing if they
; are not used for native skills they will resort to old functionality

bool function HasInt(Actor ActorRef, string Stat)
	return HasIntValue(ActorRef, "sslActorStats."+Stat) || (IsSkilled(ActorRef) && _GetSkill(ActorRef, SkillNames.Find(Stat)) != 0.0)
endFunction
bool function HasFloat(Actor ActorRef, string Stat)
	return HasFloatValue(ActorRef, "sslActorStats."+Stat) || (IsSkilled(ActorRef) && _GetSkill(ActorRef, SkillNames.Find(Stat)) != 0.0)
endFunction
bool function HasStr(Actor ActorRef, string Stat)
	return HasStringValue(ActorRef, "sslActorStats."+Stat)
endFunction

int function GetInt(Actor ActorRef, string Stat)
	if SkillNames.Find(Stat) == -1
		return GetIntValue(ActorRef, "sslActorStats."+Stat)
	endIf
	return GetSkill(ActorRef, Stat)
endFunction
float function GetFloat(Actor ActorRef, string Stat)
	if SkillNames.Find(Stat) == -1
		return GetFloatValue(ActorRef, "sslActorStats."+Stat)
	endIf
	return GetSkillFloat(ActorRef, Stat)
endFunction
string function GetStr(Actor ActorRef, string Stat)
	return GetStringValue(ActorRef, "sslActorStats."+Stat)
endFunction

function SetInt(Actor ActorRef, string Stat, int Value)
	if SkillNames.Find(Stat) != -1
		_SetSkill(ActorRef, SkillNames.Find(Stat), value as int)
	else
		SetIntValue(ActorRef, "sslActorStats."+Stat, Value)
	endIf
endFunction
function SetFloat(Actor ActorRef, string Stat, float Value)
	if SkillNames.Find(Stat) != -1
		_SetSkill(ActorRef, SkillNames.Find(Stat), 0.0)
	else
		SetFloatValue(ActorRef, "sslActorStats."+Stat, Value)
	endIf
endFunction
function SetStr(Actor ActorRef, string Stat, string Value)
	SetStringValue(ActorRef, "sslActorStats."+Stat, Value)
endFunction

function ClearInt(Actor ActorRef, string Stat)
	_SetSkill(ActorRef, SkillNames.Find(Stat), 0.0)
	UnsetIntValue(ActorRef, "sslActorStats."+Stat)
endFunction
function ClearFloat(Actor ActorRef, string Stat)
	_SetSkill(ActorRef, SkillNames.Find(Stat), 0.0)
	UnsetFloatValue(ActorRef, "sslActorStats."+Stat)
endFunction
function ClearStr(Actor ActorRef, string Stat)
	UnsetStringValue(ActorRef, "sslActorStats."+Stat)
endFunction

function AdjustInt(Actor ActorRef, string Stat, int Amount)
	if Amount != 0 && ActorRef && Stat != ""
		if SkillNames.Find(stat) != -1
			AdjustSkill(ActorRef, Stat, Amount)
		else
			AdjustIntValue(ActorRef, "sslActorStats."+Stat, Amount)
		endIf
	endIf
endfunction
function AdjustFloat(Actor ActorRef, string Stat, float Amount)
	if Amount != 0.0 && ActorRef && Stat != ""
		if SkillNames.Find(stat) != -1
			AdjustSkillFloat(ActorRef, Stat, Amount)
		else
			AdjustFloatValue(ActorRef, "sslActorStats."+Stat, Amount)
		endIf
	endIf
endfunction



bool locked = false
state Testing
	event OnUpdate()
		Tester()
	endEvent
	function Tester()
		while locked
			utility.wait(0.5)
			Log("ActorStats Locked...")
		endWhile
		locked = true

		int i = 500
		while i
			i -= 1
			Debug.Trace("ACTORSTATSb Lock Spin: "+i)
			Utility.WaitMenuMode(0.5)
		endWhile

		locked = false
	endFunction
endState
function Tester()
endFunction
