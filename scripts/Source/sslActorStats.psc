scriptname sslActorStats extends sslSystemLibrary

; Titles
string[] StatTitles
string[] PureTitlesMale
string[] PureTitlesFemale
string[] LewdTitlesMale
string[] LewdTitlesFemale

; ------------------------------------------------------- ;
; --- Manipulate Custom Stats                         --- ;
; ------------------------------------------------------- ;

int function FindStat(string Stat)
	return StorageUtil.StringListFind(self, "Custom", Stat)
endFunction

int function RegisterStat(string Stat, string Value, string Prepend = "", string Append = "")
	if FindStat(Stat) == -1
		StorageUtil.StringListAdd(self, "Custom", Stat, false)
		StorageUtil.SetStringValue(self, "Custom.Default."+Stat, Value)
		StorageUtil.SetStringValue(self, "Custom.Prepend."+Stat, Prepend)
		StorageUtil.SetStringValue(self, "Custom.Append."+Stat, Append)
		SetStat(PlayerRef, Stat, Value)
	endIf
	return FindStat(Stat)
endFunction

function Alter(string Name, string NewName = "", string Value = "", string Prepend = "", string Append = "")
	int i = FindStat(Name)
	if i != -1
		if NewName != ""
			StorageUtil.StringListSet(self, "Custom", i, NewName)
			StorageUtil.SetStringValue(self, "Custom.Default."+NewName, StorageUtil.GetStringValue(self, "Custom.Default."+Name))
			StorageUtil.SetStringValue(self, "Custom.Prepend."+NewName, StorageUtil.GetStringValue(self, "Custom.Prepend."+Name))
			StorageUtil.SetStringValue(self, "Custom.Append."+NewName, StorageUtil.GetStringValue(self, "Custom.Append."+Name))
			StorageUtil.UnsetStringValue(self, "Custom.Default."+Name)
			StorageUtil.UnsetStringValue(self, "Custom.Prepend."+Name)
			StorageUtil.UnsetStringValue(self, "Custom.Append."+Name)
			Name = NewName
		endIf
		if Value != ""
			StorageUtil.SetStringValue(self, "Custom.Default."+Name, Value)
		endIf
		if Prepend != ""
			StorageUtil.SetStringValue(self, "Custom.Prepend."+Name, Prepend)
		endIf
		if Append != ""
			StorageUtil.SetStringValue(self, "Custom.Append."+Name, Append)
		endIf
	endIf
endFunction

bool function ClearStat(Actor ActorRef, string Stat)
	if HasStat(ActorRef, Stat)
		ClearStr(ActorRef, "Custom."+Stat)
		return true
	endIf
	return false
endFunction

function SetStat(Actor ActorRef, string Stat, string Value)
	if FindStat(Stat) != -1
		SetStr(ActorRef, "Custom."+Stat, Value)
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
	return HasStr(ActorRef, "Custom."+Stat)
endFunction

string function GetStat(Actor ActorRef, string Stat)
	if !HasStat(ActorRef, Stat)
		return GetStatDefault(Stat)
	endIf
	return GetStr(ActorRef, "Custom."+Stat)
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
	return StatTitles[sslUtility.ClampInt(CalcLevel(GetStatFloat(ActorRef, Stat), Curve), 0, 6)]
endFunction

string function GetStatDefault(string Stat)
	return StorageUtil.GetStringValue(self, "Custom.Default."+Stat, "0")
endFunction

string function GetStatPrepend(string Stat)
	return StorageUtil.GetStringValue(self, "Custom.Prepend."+Stat, "")
endFunction

string function GetStatAppend(string Stat)
	return StorageUtil.GetStringValue(self, "Custom.Append."+Stat, "")
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

int function CalcLevel(float Total, float Curve = 0.85)
	if Total < 0.0
		return 0
	endIf
	return Math.Sqrt((Math.Abs(Total) / 2.0) * Curve) as int
endFunction

string function ZeroFill(string num)
	if StringUtil.GetLength(num) == 1
		return "0"+num
	endIf
	return num
endFunction

string function ParseTime(int time)
	return ZeroFill(((time / 3600) as int))+":"+ZeroFill((((time / 60) % 60) as int))+":"+ZeroFill((time % 60 as int))
endFunction

; ------------------------------------------------------- ;
; --- Sex Skills                                      --- ;
; ------------------------------------------------------- ;

int function GetSkill(Actor ActorRef, string Skill)
	; Seed for NPC native skills
	if ActorRef != PlayerRef && !HasInt(ActorRef, Skill) && !CreatureSlots.HasRace(ActorRef.GetLeveledActorBase().GetRace())
		float Seed
		if Skill == "Vaginal" || Skill == "Anal" || Skill == "Oral" || Skill == "Foreplay"
			Seed  = Utility.RandomFloat(0.0, (ActorRef.GetLevel() as float) * 2.5) * Utility.RandomFloat(0.5, 2.5)
			Seed  = sslUtility.ClampFloat(Seed, 0.0, 80.0)
			Seed += (ActorRef.GetActorValue("Speechcraft") / 2.0) * ((ActorRef.GetActorValue("Confidence") + 0.5) / 1.5)
		elseIf Skill == "Males" || Skill == "Females"
			bool IsFemale = ActorLib.GetGender(ActorRef) == 1
			Seed = Utility.RandomFloat(0.0, (ActorRef.GetLevel() as float) / 2.0)
			; Same sex count
			if ((IsFemale && Skill == "Females") || (!IsFemale && Skill == "Males"))
				if Utility.RandomInt(0, 4) < 2
					SetInt(ActorRef, Skill, 0)
					return 0 ; 40% chance to have never had
				endIf
				Seed += (Math.Abs(ActorRef.GetLowestRelationshipRank() as float) + 1.0)
				Seed *= Math.Sqrt((ActorRef.GetActorValue("Energy") + 1.0) / 3.0)
			else
				Seed += (Math.Abs(ActorRef.GetHighestRelationshipRank() as float) + 1.0) + Seed
				Seed *= Math.Sqrt(((ActorRef.GetActorValue("Energy") + 1.0) / 3.0) + (ActorRef.GetActorValue("Assistance") * 1.5) + 1.0)
			endIf
			; Cowardly - less likely to have had partners
			if ActorRef.GetActorValue("Confidence") == 0.0
				Seed = Seed / 2.0
			endIf
			; Very aggressive / frenzied - make more likely to have had more
			if ActorRef.GetActorValue("Aggression") > 1.0
				Seed *= 1.25
			endIf
		elseIf Skill == "Pure" || Skill == "Lewd"
			; Get relevant-ish AI data
			float Aggression = ActorRef.GetActorValue("Aggression")
			float Morality = ActorRef.GetActorValue("Morality")
			float Assistance = ActorRef.GetActorValue("Assistance")
			; Seed Pure
			float Pure = (Morality * 1.25) - (Aggression * 0.5)
			Pure +=  1.0 * Math.Abs(ActorRef.GetHighestRelationshipRank())
			Pure += -1.5 * ((Morality == 0.0) as float)
			Pure +=  3.0 * ((Morality == 3.0) as float)
			Pure +=  2.5 * ((Aggression == 0 && Morality != 0) as float)
			Pure += -1.5 * ((Assistance == 0.0) as float)
			Pure +=  2.0 * ((Assistance == 2.0) as float)
			Pure +=  1.2 * ((Assistance == 2.0 && Morality == 0.0) as float)
			; Seed Lewd
			float Lewd = (Aggression * 2.0)
			Lewd +=  1.0 * Math.Abs(ActorRef.GetLowestRelationshipRank())
			Lewd +=  1.8 * ((ActorRef.GetLowestRelationshipRank() < 0) as float)
			Lewd +=  2.0 * ((Morality == 0.0) as float)
			Lewd += -1.5 * ((Morality == 3.0) as float)
			Lewd +=  2.2 * ((Assistance == 0.0) as float)
			Lewd += -1.5 * ((Assistance == 2.0) as float)
			Lewd +=  3.0 * ((Morality == 0.0 && Aggression > 1.0) as float)
			; If one is signed, add it to it's oppoiste and get a random amount to avoid having none
			if Pure < 0.0
				Lewd += Math.Abs(Pure)
				Pure = Utility.RandomFloat(0.0, Math.Abs(Pure))
			endIf
			if Lewd < 0.0
				Pure += Math.Abs(Lewd)
				Lewd = Utility.RandomFloat(0.0, Math.Abs(Lewd))
			endIf
			; Curved increase with actor level and slight randomness
			float Curve = Math.Abs(Math.Sqrt(((Math.Pow(ActorRef.GetLevel() as float, 2.0)) / 2.0 ) * (8.5 + Utility.RandomFloat(-1.0, 1.8))))
			Pure = Math.Abs(Pure * Curve)
			Lewd = Math.Abs(Lewd * Curve)
			; Save Purity stats
			SetInt(ActorRef, "Pure", Pure as int)
			SetInt(ActorRef, "Lewd", Lewd as int)
			if Skill == "Pure"
				return Pure as int
			else
				return Lewd as int
			endIf
		endIf
		SetInt(ActorRef, Skill, Seed as int)
		return Seed as int
	endIf
	return GetInt(ActorRef, Skill)
endFunction

function AdjustSkill(Actor ActorRef, string Skill, int Amount)
	if Amount != 0 && ActorRef != none && Skill != ""
		SetInt(ActorRef, Skill, (GetSkill(ActorRef, Skill) + Amount))
	endIf
endFunction

int function GetSkillLevel(Actor ActorRef, string Skill, float Curve = 0.85)
	return CalcLevel(GetSkill(ActorRef, Skill), Curve)
endFunction

string function GetSkillTitle(Actor ActorRef, string Skill, float Curve = 0.85)
	return StatTitles[sslUtility.ClampInt(GetSkillLevel(ActorRef, Skill, Curve), 0, 6)]
endFunction

; float function GetProficiencyLevel(Actor ActorRef, string Skill, float Increments = 21.0)
	; return (GetSkill(actorRef, Skill) as float) / Increments
; endFunction
;
; string function GetProficiencyTitle(Actor ActorRef, string Skill, float Increments = 21.0)
	; return StatTitles[sslUtility.ClampInt((GetProficiencyLevel(ActorRef, Skill, Increments) as int), 0, 6)]
; endFunction

string function GetTitle(int Level)
	return StatTitles[sslUtility.ClampInt(Level, 0, 6)]
endFunction

float[] function GetSkills(Actor ActorRef)
	float[] Output = new float[6]
	Output[0] = GetSkill(ActorRef, "Foreplay") as float
	Output[1] = GetSkill(ActorRef, "Vaginal") as float
	Output[2] = GetSkill(ActorRef, "Anal") as float
	Output[3] = GetSkill(ActorRef, "Oral") as float
	Output[4] = GetPure(ActorRef) as float
	Output[5] = GetLewd(ActorRef) as float
	return Output
endFunction

float[] function GetSkillLevels(Actor ActorRef)
	float[] Output = new float[6]
	Output[0] = GetSkillLevel(ActorRef, "Foreplay") as float
	Output[1] = GetSkillLevel(ActorRef, "Vaginal") as float
	Output[2] = GetSkillLevel(ActorRef, "Anal") as float
	Output[3] = GetSkillLevel(ActorRef, "Oral") as float
	Output[4] = GetPureLevel(ActorRef) as float
	Output[5] = GetLewdLevel(ActorRef) as float
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
	return CalcLevel(GetPure(ActorRef), 0.4)
endFunction

string function GetPureTitle(Actor ActorRef)
	if ActorRef.GetLeveledActorBase().GetSex() == 1
		return PureTitlesFemale[sslUtility.ClampInt(GetPureLevel(ActorRef), 0, 6)]
	else
		return PureTitlesMale[sslUtility.ClampInt(GetPureLevel(ActorRef), 0, 6)]
	endIf
endFunction

int function GetLewd(Actor ActorRef)
	return GetSkill(ActorRef, "Lewd")
endFunction

int function GetLewdLevel(Actor ActorRef)
	return CalcLevel(GetLewd(ActorRef), 0.4)
endFunction

string function GetLewdTitle(Actor ActorRef)
	if ActorRef.GetLeveledActorBase().GetSex() == 1
		return LewdTitlesFemale[sslUtility.ClampInt(GetLewdLevel(ActorRef), 0, 6)]
	else
		return LewdTitlesMale[sslUtility.ClampInt(GetLewdLevel(ActorRef), 0, 6)]
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
	AdjustInt(ActorRef, type, Math.Abs(Adjust) as int)
	return GetInt(ActorRef, type) as float
endFunction

string function GetPurityTitle(Actor ActorRef)
	if IsLewd(ActorRef)
		return GetLewdTitle(ActorRef)
	else
		return GetPureTitle(ActorRef)
	endIf
endFunction

int function GetPurityLevel(Actor ActorRef)
	return CalcLevel(Math.Abs(GetPurity(ActorRef)), 0.4)
endFunction

function AddPurityXP(Actor ActorRef, float Pure, float Lewd, bool IsAggressive, bool IsVictim, bool WithCreature, int ActorCount, int HadRelation)
	; Aggressive modifier for victim/aggressor
	if IsAggressive && IsVictim
		AdjustInt(ActorRef, "Victim", 1)
		Pure -= 1.0
		Lewd += 1.0
	elseIf IsAggressive
		AdjustInt(ActorRef, "Aggressor", 1)
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
	AdjustSkill(ActorRef, "Pure", sslUtility.ClampInt(Pure as int, 0, 20))
	AdjustSkill(ActorRef, "Lewd", sslUtility.ClampInt(Lewd as int, 0, 20))
endFunction

; ------------------------------------------------------- ;
; --- Sex Counters                                    --- ;
; ------------------------------------------------------- ;

function AddSex(Actor ActorRef, float TimeSpent = 0.0, bool WithPlayer = false, int Males = 0, int Females = 0, int Creatures = 0)
	AdjustFloat(ActorRef, "TimeSpent", TimeSpent)
	SetFloat(ActorRef, "LastSex.GameTime", Utility.GetCurrentGameTime())
	SetFloat(ActorRef, "LastSex.RealTime", Utility.GetCurrentRealTime())

	int ActorCount = (Males + Females + Creatures)
	if ActorCount > 1
		int Gender = Actorlib.GetGender(ActorRef)
		Males -= (Gender == 0) as int
		Females -= (Gender == 1) as int
		AdjustInt(ActorRef, "Males", Males)
		AdjustInt(ActorRef, "Females", Females)
		AdjustInt(ActorRef, "Creatures", Creatures)
		AdjustInt(ActorRef, "SexCount", 1)
	else
		AdjustInt(ActorRef, "Masturbation", 1)
	endIf
	if WithPlayer && ActorRef != PlayerRef
		AdjustInt(ActorRef, "PlayerSex", 1)
		StorageUtil.FormListAdd(PlayerRef, "SexPartners", ActorRef, false)
	endIf
endFunction

int function SexCount(Actor ActorRef)
	return GetInt(ActorRef, "SexCount")
endFunction

bool function HadSex(Actor ActorRef)
	return GetInt(ActorRef, "SexCount") > 0
endFunction

int function PlayerSexCount(Actor ActorRef)
	return GetInt(ActorRef, "PlayerSex")
endFunction

bool function HadPlayerSex(Actor ActorRef)
	return GetInt(ActorRef, "PlayerSex") > 0
endFunction

; ------------------------------------------------------- ;
; --- Sexuality Stats                                 --- ;
; ------------------------------------------------------- ;

int function GetSexuality(Actor ActorRef)
	return CalcSexuality((ActorLib.GetGender(ActorRef) == 1), GetSkill(ActorRef, "Males"), GetSkill(ActorRef, "Females"))
endFunction

string function GetSexualityTitle(Actor ActorRef)
	bool IsFemale = ActorLib.GetGender(ActorRef) == 1
	int ratio = CalcSexuality(IsFemale, GetSkill(ActorRef, "Males"), GetSkill(ActorRef, "Females"))
	; Return sexuality title
	if ratio >= 65
		return "$SSL_Heterosexual"
	elseif ratio < 65 && ratio > 35
		return "$SSL_Bisexual"
	elseif IsFemale
		return "$SSL_Lesbian"
	else
		return "$SSL_Gay"
	endIf
endFunction

bool function IsStraight(Actor ActorRef)
	return GetSexuality(ActorRef) >= 65
endFunction

bool function IsBisexual(Actor ActorRef)
	int ratio = GetSexuality(ActorRef)
	return ratio < 65 && ratio > 35
endFunction

bool function IsGay(Actor ActorRef)
	return GetSexuality(ActorRef) <= 35
endFunction


; ------------------------------------------------------- ;
; --- Time Based Stats                                --- ;
; ------------------------------------------------------- ;

; Last sex - Game time1 - float days
float function LastSexGameTime(Actor ActorRef)
	return GetFloat(ActorRef, "LastSex.GameTime")
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
	return GetFloat(ActorRef, "LastSex.RealTime")
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


function ResetActor(Actor ActorRef)
	; Native stats
	ClearInt(ActorRef, "Males")
	ClearInt(ActorRef, "Females")
	ClearInt(ActorRef, "Creatures")
	ClearInt(ActorRef, "Vaginal")
	ClearInt(ActorRef, "Oral")
	ClearInt(ActorRef, "Anal")
	ClearInt(ActorRef, "Foreplay")
	ClearInt(ActorRef, "Pure")
	ClearInt(ActorRef, "Lewd")

	ClearInt(ActorRef, "SexCount")
	ClearInt(ActorRef, "PlayerSex")
	ClearFloat(ActorRef, "LastSex.RealTime")
	ClearFloat(ActorRef, "LastSex.GameTime")
	ClearFloat(ActorRef, "TimeSpent")
	ClearFloat(ActorRef, "Purity")
	; Custom stats
	int i = StorageUtil.StringListCount(self, "Custom")
	while i
		i -= 1
		ClearStr(ActorRef, "Custom."+StorageUtil.StringListGet(self, "Custom", i))
	endWhile
	; Clear Partners
	if ActorRef == PlayerRef
		i = Storageutil.FormListCount(ActorRef, "SexPartners")
		while i
			i -= 1
			ClearInt((StorageUtil.FormListGet(ActorRef, "SexPartners", i) as Actor), "PlayerSex")
		endWhile
	endIf
	StorageUtil.FormListClear(ActorRef, "SexPartners")
endFunction

function Setup()
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

	parent.Setup()
endFunction

bool function HasInt(Actor ActorRef, string Stat)
	return StorageUtil.HasIntValue(ActorRef, "sslActorStats."+Stat)
endFunction
bool function HasFloat(Actor ActorRef, string Stat)
	return StorageUtil.HasFloatValue(ActorRef, "sslActorStats."+Stat)
endFunction
bool function HasStr(Actor ActorRef, string Stat)
	return StorageUtil.HasStringValue(ActorRef, "sslActorStats."+Stat)
endFunction

int function GetInt(Actor ActorRef, string Stat)
	return StorageUtil.GetIntValue(ActorRef, "sslActorStats."+Stat)
endFunction
float function GetFloat(Actor ActorRef, string Stat)
	return StorageUtil.GetFloatValue(ActorRef, "sslActorStats."+Stat)
endFunction
string function GetStr(Actor ActorRef, string Stat)
	return StorageUtil.GetStringValue(ActorRef, "sslActorStats."+Stat)
endFunction

function ClearInt(Actor ActorRef, string Stat)
	StorageUtil.UnsetIntValue(ActorRef, "sslActorStats."+Stat)
endFunction
function ClearFloat(Actor ActorRef, string Stat)
	StorageUtil.UnsetFloatValue(ActorRef, "sslActorStats."+Stat)
endFunction
function ClearStr(Actor ActorRef, string Stat)
	StorageUtil.UnsetStringValue(ActorRef, "sslActorStats."+Stat)
endFunction

function SetInt(Actor ActorRef, string Stat, int Value)
	StorageUtil.SetIntValue(ActorRef, "sslActorStats."+Stat, Value)
endFunction
function SetFloat(Actor ActorRef, string Stat, float Value)
	StorageUtil.SetFloatValue(ActorRef, "sslActorStats."+Stat, Value)
endFunction
function SetStr(Actor ActorRef, string Stat, string Value)
	StorageUtil.SetStringValue(ActorRef, "sslActorStats."+Stat, Value)
endFunction

function AdjustInt(Actor ActorRef, string Stat, int Amount)
	if Amount != 0
		StorageUtil.SetIntValue(ActorRef, "sslActorStats."+Stat, (StorageUtil.GetIntValue(ActorRef, "sslActorStats."+Stat) + Amount))
	endIF
endFunction
function AdjustFloat(Actor ActorRef, string Stat, float Amount)
	if Amount != 0.0
		StorageUtil.SetFloatValue(ActorRef, "sslActorStats."+Stat, (StorageUtil.GetFloatValue(ActorRef, "sslActorStats."+Stat) + Amount))
	endIf
endFunction

