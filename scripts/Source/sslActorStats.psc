scriptname sslActorStats extends sslActorLibrary

import StorageUtil
import sslUtility
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

function SetSeed(float[] Skills, string Skill, float Amount)
	int i = SkillNames.Find(Skill)
	if i != -1
		Skills[i] = Amount
	endIf
endFunction

; I'm no math-wizard, this is mostly just throwing random shit at the walls in attempt to generate somewhat consistent skills based on info about the actor.
; If anybody who doesn't suck at math like I do wants to help me improve this - feel free to contact me. - Ashal
function SeedActor(Actor ActorRef)
	if ActorRef == PlayerRef || !ActorRef.HasKeyword(ActorTypeNPC) || FormListFind(none, "SexLab.SkilledActors", ActorRef) != -1
		return
	endIf
	; Added to seeded list so they skip this in future
	; FormListAdd(none, "SexLab.SeededActors", ActorRef, false)
	FormListAdd(none, "SexLab.SkilledActors", ActorRef, false) ; v1.59b - changed storage method; use new list
	float[] Skills = FloatArray(SkillNames.Length)

	float Level       = ActorRef.GetLevel() as float + (ActorRef.GetActorValue("Speechcraft") * 0.1)
	float Energy      = ActorRef.GetActorValue("Energy")
	float Assistance  = ActorRef.GetActorValue("Assistance")
	float Aggression  = ActorRef.GetActorValue("Aggression")
	float Confidence  = ActorRef.GetActorValue("Confidence")
	float Morality    = ActorRef.GetActorValue("Morality")
	int HighestRelation = ActorRef.GetHighestRelationshipRank()
	int LowestRelation  = ActorRef.GetLowestRelationshipRank()
	bool IsFemale = GetGender(ActorRef) == 1

	; Seed Sexuality
	float Straight = RandomFloat(Level * 0.1, Level * 0.5) + Abs(HighestRelation) + Sqrt(Energy * Utility.RandomFloat(0.3, 0.6)) + (Assistance * 1.5)
	float Gay      = RandomFloat(Level * 0.1, Level * 0.5) + Abs(LowestRelation)  + Sqrt(Energy * Utility.RandomFloat(0.1, 0.5)) + (Assistance * 1.5)
	; Very aggressive / frenzied - make more likely to have had more
	if Aggression > 1.0
		Straight *= RandomFloat(1.13, 1.45)
		Gay      *= RandomFloat(1.13, 1.45)
	endIf
	; Cowardly - less likely to have had partners
	if Confidence == 0.0
		Straight *= RandomFloat(0.3, 0.7)
		Gay      *= RandomFloat(0.3, 0.7)
	endIf
	; Chance for never having had a certain type
	Straight *= ((RandomInt(1, 10) != 1) as float)
	Gay      *= ((RandomInt(1, 3) != 1) as float)

	; Seed time spent
	float TimeSpent = ((Straight + Gay) * RandomFloat(6.0, 13.0))
	SetSeed(Skills, "TimeSpent", TimeSpent)
	SetSeed(Skills, "LastSex.GameTime", Utility.GetCurrentGameTime())
	SetSeed(Skills, "LastSex.RealTime", Utility.GetCurrentRealTime())
	if IsFemale
		SetSeed(Skills, "Sexuality", 60.0)
		SetSeed(Skills, "Males", (Straight as int) as float)
		SetSeed(Skills, "Females", (Gay as int) as float)
		SetSeed(Skills, "SexCount", ((Straight as int) + (Gay as int)) as float)
	else
		SetSeed(Skills, "Sexuality", 80.0)
		SetSeed(Skills, "Sexuality", 60.0)
		SetSeed(Skills, "Females", (Straight as int) as float)
		SetSeed(Skills, "Males", (Gay as int) as float)
		SetSeed(Skills, "SexCount", ((Straight as int) + (Gay as int)) as float)
	endIf

	; Sex Skills
	float Vaginal  = 1.3 * (((TimeSpent * 0.6) + RandomFloat(1.0, Level)) / RandomFloat(4.0, 13.69))
	float Anal     = 1.1 * (((TimeSpent * 0.6) + RandomFloat(1.0, Level)) / RandomFloat(4.0, 13.69))
	float Oral     = 1.2 * (((TimeSpent * 0.6) + RandomFloat(1.0, Level)) / RandomFloat(4.0, 13.69))
	float Foreplay = 0.9 * (((TimeSpent * 0.6) + RandomFloat(1.0, Level)) / RandomFloat(4.0, 13.69))

	; float Vaginal  =  1.5 * ((TimeSpent * 0.69) + RandomFloat(0.1, Level * Level)) / RandomFloat(4.0, 13.6)
	; float Anal     =  1.3 * ((TimeSpent * 0.69) + RandomFloat(0.1, Level)) / RandomFloat(4.0, 13.6)
	; float Oral     =  1.4 * ((TimeSpent * 0.69) + RandomFloat(0.1, Level)) / RandomFloat(4.0, 13.6)
	; float Foreplay =  1.1 * ((TimeSpent * 0.69) + RandomFloat(0.1, Level)) / RandomFloat(4.0, 13.6)

	; Alter by sexuality
	if Gay > Straight
		if IsFemale
			Vaginal *= 1.5
			Anal    *= 0.5
			Oral    *= 1.1
		else
			Vaginal *= 0.4
			Anal    *= 1.5
			Oral    *= 1.1
		endIf
	endIf

	SetSeed(Skills, "Vaginal", Vaginal)
	SetSeed(Skills, "Anal", Anal)
	SetSeed(Skills, "Oral", Oral)
	SetSeed(Skills, "Foreplay", Foreplay)

	; Seed Pure
	float Pure = (Morality * 1.25) - (Aggression * 0.75)
	Pure +=  1.0 * Abs(HighestRelation)
	Pure += -1.5 * ((Morality == 0.0) as float)
	Pure +=  3.1 * ((Morality == 3.0) as float)
	Pure +=  2.5 * ((Aggression == 0 && Morality != 0) as float)
	Pure += -1.5 * ((Assistance == 0.0) as float)
	Pure +=  3.0 * ((Assistance == 2.0) as float)
	Pure +=  1.2 * ((Assistance == 2.0 && Morality == 0.0) as float)
	if Pure < 0.0
		Pure = RandomFloat(0.0, Abs(Pure) * 0.6)
	endIf
	; Seed Lewd
	float Lewd = (Aggression * 1.5)
	Lewd +=  1.0 * Abs(LowestRelation)
	Lewd +=  2.2 * ((LowestRelation < 0) as float)
	Lewd +=  2.5 * ((Morality == 0.0) as float)
	Lewd += -1.5 * ((Morality == 3.0) as float)
	Lewd +=  2.3 * ((Assistance == 0.0) as float)
	Lewd += -1.5 * ((Assistance == 2.0) as float)
	Lewd +=  3.1 * ((Morality == 0.0 && Aggression > 1.0) as float)
	if Lewd < 0.0
		Lewd = RandomFloat(0.0, Abs(Lewd) * 0.6)
	endIf

	; Curved increase with actor level and slight randomness
	float Curve = Abs(Sqrt(((Level * Level) / 2.3 ) * (5.0 + RandomFloat(-1.0, 1.8))))
	Pure = Abs(Pure * Curve)
	Lewd = Abs(Lewd * Curve)

	SetSeed(Skills, "Pure", Pure)
	SetSeed(Skills, "Lewd", Lewd)

	FloatListCopy(ActorRef, "SexLabSkills", Skills)
	Log("Sexuality["+GetSexuality(ActorRef)+"] Foreplay["+GetSkill(ActorRef, "Foreplay")+"] Vaginal["+GetSkill(ActorRef, "Vaginal")+"] Anal["+GetSkill(ActorRef, "Anal")+"] Oral["+GetSkill(ActorRef, "Oral")+"] Pure["+GetPure(ActorRef)+"] Lewd["+GetLewd(ActorRef)+"]", ActorRef.GetLeveledActorBase().GetName()+" Stats Seed")
endFunction

function InitSkills(Actor ActorRef, bool InitList = true)
	if ActorRef == none
		return
	elseIf InitList && FloatListCount(ActorRef, "SexLabSkills") != SkillNames.Length
		float[] Skills = FloatArray(SkillNames.Length)
		FloatListCopy(ActorRef, "SexLabSkills", Skills)
	endIf
	SeedActor(ActorRef)
endFunction

int function GetSkill(Actor ActorRef, string Skill)
	InitSkills(ActorRef, false)
	return FloatListGet(ActorRef, "SexLabSkills", SkillNames.Find(Skill)) as int
endFunction

float function GetSkillFloat(Actor ActorRef, string Skill)
	InitSkills(ActorRef, false)
	return FloatListGet(ActorRef, "SexLabSkills", SkillNames.Find(Skill))
endFunction

function SetSkill(Actor ActorRef, string Skill, int Amount)
	InitSkills(ActorRef)
	FloatListSet(ActorRef, "SexLabSkills", SkillNames.Find(Skill), Amount as float)
endFunction

function SetSkillFloat(Actor ActorRef, string Skill, float Amount)
	InitSkills(ActorRef)
	FloatListSet(ActorRef, "SexLabSkills", SkillNames.Find(Skill), Amount)
endFunction

function AdjustSkill(Actor ActorRef, string Skill, int Amount)
	int i = SkillNames.Find(Skill)
	if Amount != 0 && i != -1 && ActorRef != none && Skill != ""
		InitSkills(ActorRef)
		FloatListSet(ActorRef, "SexLabSkills", i, (FloatListGet(ActorRef, "SexLabSkills", i) + (Amount as float)))
	endIf
endfunction

function AdjustSkillFloat(Actor ActorRef, string Skill, float Amount)
	int i = SkillNames.Find(Skill)
	if Amount != 0.0 && i != -1 && ActorRef != none && Skill != ""
		InitSkills(ActorRef)
		FloatListSet(ActorRef, "SexLabSkills", i, (FloatListGet(ActorRef, "SexLabSkills", i) + Amount))
	endIf
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

float[] function GetSkills(Actor ActorRef)
	float[] Output = new float[6]
	FloatListSlice(ActorRef, "SexLabSkills", Output)
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
	AdjustSkill(ActorRef, "Foreplay", Foreplay as int)
	AdjustSkill(ActorRef, "Vaginal", Vaginal as int)
	AdjustSkill(ActorRef, "Anal", Anal as int)
	AdjustSkill(ActorRef, "Oral", Oral as int)
endFunction

; ------------------------------------------------------- ;
; --- Purity/Impurty Stat                             --- ;
; ------------------------------------------------------- ;

int function GetPure(Actor ActorRef)
	return GetSkill(ActorRef, "Pure")
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
	return GetSkill(ActorRef, "Lewd")
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
	AdjustSkillFloat(ActorRef, type, Math.Abs(Adjust) as int)
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
		AdjustSkill(ActorRef, "Victim", 1)
		Pure -= 1.0
		Lewd += 1.0
	elseIf IsAggressive
		AdjustSkill(ActorRef, "Aggressor", 1)
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
	AdjustSkill(ActorRef, "Pure", ClampInt(Pure as int, 0, 20))
	AdjustSkill(ActorRef, "Lewd", ClampInt(Lewd as int, 0, 20))
endFunction

; ------------------------------------------------------- ;
; --- Sex Counters                                    --- ;
; ------------------------------------------------------- ;

function AddSex(Actor ActorRef, float TimeSpent = 0.0, bool WithPlayer = false, bool IsAggressive = false, int Males = 0, int Females = 0, int Creatures = 0)
	AdjustSkillFloat(ActorRef, "TimeSpent", TimeSpent)
	SetSkillFloat(ActorRef, "LastSex.GameTime", Utility.GetCurrentGameTime())
	SetSkillFloat(ActorRef, "LastSex.RealTime", Utility.GetCurrentRealTime())

	int ActorCount = (Males + Females + Creatures)
	if ActorCount > 1
		int Gender = GetGender(ActorRef)
		Males -= (Gender == 0) as int
		Females -= (Gender == 1) as int
		AdjustSkill(ActorRef, "Males", Males)
		AdjustSkill(ActorRef, "Females", Females)
		AdjustSkill(ActorRef, "Creatures", Creatures)
		AdjustSkill(ActorRef, "SexCount", 1)
		if ActorRef != PlayerRef
			if !IsAggressive
				AdjustSexuality(ActorRef, Males * 2, Females * 2)
			else
				AdjustSexuality(ActorRef, Males, Females)
			endIf
		endIf
	else
		AdjustSkill(ActorRef, "Masturbation", 1)
	endIf
	if WithPlayer && ActorRef != PlayerRef
		AdjustSkill(ActorRef, "PlayerSex", 1)
		FormListAdd(PlayerRef, "SexPartners", ActorRef, false)
	endIf
endFunction

int function SexCount(Actor ActorRef)
	return GetSkill(ActorRef, "SexCount")
endFunction

bool function HadSex(Actor ActorRef)
	return GetSkillFloat(ActorRef, "SexCount") >= 1.0
endFunction

int function PlayerSexCount(Actor ActorRef)
	return GetSkill(ActorRef, "PlayerSex")
endFunction

bool function HadPlayerSex(Actor ActorRef)
	return GetSkillFloat(ActorRef, "PlayerSex") >= 1.0
endFunction

; ------------------------------------------------------- ;
; --- Sexuality Stats                                 --- ;
; ------------------------------------------------------- ;

function AdjustSexuality(Actor ActorRef, int Males, int Females)
	bool IsFemale = GetGender(ActorRef) == 1
	int Ratio = GetSkill(ActorRef, "Sexuality")
	if Ratio == 0
		Ratio = 85
	endIf
	if IsFemale
		Ratio += (Males - Females)
	else
		Ratio += (Females - Males)
	endIf
	SetSkill(ActorRef, "Sexuality", ClampInt(Ratio, 1, 100))
endFunction

int function GetSexuality(Actor ActorRef)
	int Ratio = GetSkill(ActorRef, "Sexuality")
	if Ratio > 0
		return Ratio
	else
		return 100
	endIf
endFunction

string function GetSexualityTitle(Actor ActorRef)
	int ratio = GetSkill(ActorRef, "Sexuality")
	; Return sexuality title
	if ratio >= 65 || ratio == 0
		return "$SSL_Heterosexual"
	elseif ratio < 65 && ratio > 35
		return "$SSL_Bisexual"
	elseif GetGender(ActorRef) == 1
		return "$SSL_Lesbian"
	else
		return "$SSL_Gay"
	endIf
endFunction

bool function IsStraight(Actor ActorRef)
	return GetSkill(ActorRef, "Sexuality") >= 65
endFunction

bool function IsBisexual(Actor ActorRef)
	int ratio = GetSkill(ActorRef, "Sexuality")
	return ratio < 65 && ratio > 35
endFunction

bool function IsGay(Actor ActorRef)
	return GetSkill(ActorRef, "Sexuality") <= 35
endFunction

; ------------------------------------------------------- ;
; --- Time Based Stats                                --- ;
; ------------------------------------------------------- ;

; Last sex - Game time1 - float days
float function LastSexGameTime(Actor ActorRef)
	return GetSkillFloat(ActorRef, "LastSex.GameTime")
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
	return GetSkillFloat(ActorRef, "LastSex.RealTime")
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

function RecordThread(Actor ActorRef, bool HasPlayer, int Positions, int HighestRelation, float TotalTime, Actor VictimRef, float[] SkillXP, int[] Genders)
	AddSkillXP(ActorRef, SkillXP[0], SkillXP[1], SkillXP[2], SkillXP[3])
	AddPurityXP(ActorRef, SkillXP[4], SkillXP[5], VictimRef != none, VictimRef == ActorRef, Genders[2] > 0, Positions, HighestRelation)
	AddSex(ActorRef, TotalTime, HasPlayer, VictimRef != none, Genders[0], Genders[1], Genders[2])
endFunction

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
		Log(i, "SeededActors")
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
	if ActorRef == none || ActorRef.IsDead() || ActorRef.IsDisabled()
		return false
	endIf
	ActorBase BaseRef = ActorRef.GetLeveledActorBase()
	return BaseRef.IsUnique() || BaseRef.IsEssential() || BaseRef.IsInvulnerable() || BaseRef.IsProtected() || ActorRef == PlayerRef
endFunction

function UpgradeLegacyStats(Actor ActorRef)
	if ActorRef == none
		return
	elseIf !IsImportant(ActorRef)
		ClearLegacyStats(ActorRef)
		ClearCustomStats(ActorRef)
		FloatListClear(ActorRef, "SexLabSkills")
		Log("Skills Removed", ActorRef.GetLeveledActorBase().GetName())
	elseIf ActorRef != none && FloatListCount(ActorRef, "SexLabSkills") != SkillNames.Length
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
			if ActorRef != PlayerRef && ActorRef.IsDead()
				ResetStats(ActorRef)
				FormListRemoveAt(none, "SexLab.SkilledActors", i)
				Log("Skills Removed", ActorRef.GetLeveledActorBase().GetName())
			endIf
		else
			FormListRemoveAt(none, "SexLab.SkilledActors", i)
		endIf
	endWhile
endFunction

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
	return HasIntValue(ActorRef, "sslActorStats."+Stat) || FloatListGet(ActorRef, "SexLabSkills", SkillNames.Find(Stat)) > 0.0
endFunction
bool function HasFloat(Actor ActorRef, string Stat)
	return HasFloatValue(ActorRef, "sslActorStats."+Stat) || FloatListGet(ActorRef, "SexLabSkills", SkillNames.Find(Stat)) > 0.0
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
		SetSkill(ActorRef, Stat, Value)
	else
		SetIntValue(ActorRef, "sslActorStats."+Stat, Value)
	endIf
endFunction
function SetFloat(Actor ActorRef, string Stat, float Value)
	if SkillNames.Find(Stat) != -1
		SetSkillFloat(ActorRef, Stat, Value)
	else
		SetFloatValue(ActorRef, "sslActorStats."+Stat, Value)
	endIf
endFunction
function SetStr(Actor ActorRef, string Stat, string Value)
	SetStringValue(ActorRef, "sslActorStats."+Stat, Value)
endFunction

function ClearInt(Actor ActorRef, string Stat)
	FloatListSet(ActorRef, "SexLabSkills", SkillNames.Find(Stat), 0.0)
	UnsetIntValue(ActorRef, "sslActorStats."+Stat)
endFunction
function ClearFloat(Actor ActorRef, string Stat)
	FloatListSet(ActorRef, "SexLabSkills", SkillNames.Find(Stat), 0.0)
	UnsetFloatValue(ActorRef, "sslActorStats."+Stat)
endFunction
function ClearStr(Actor ActorRef, string Stat)
	UnsetStringValue(ActorRef, "sslActorStats."+Stat)
endFunction

function AdjustInt(Actor ActorRef, string Stat, int Amount)
	if Amount != 0 && ActorRef != none && Stat != ""
		if SkillNames.Find(stat) != -1
			AdjustSkill(ActorRef, Stat, Amount)
		else
			SetIntValue(ActorRef, "sslActorStats."+Stat, (GetIntValue(ActorRef, "sslActorStats."+Stat) + Amount))
		endIf
	endIf
endfunction
function AdjustFloat(Actor ActorRef, string Stat, float Amount)
	if Amount != 0.0 && ActorRef != none && Stat != ""
		if SkillNames.Find(stat) != -1
			AdjustSkillFloat(ActorRef, Stat, Amount)
		else
			SetFloatValue(ActorRef, "sslActorStats."+Stat, (GetFloatValue(ActorRef, "sslActorStats."+Stat) + Amount))
		endIf
	endIf
endfunction
