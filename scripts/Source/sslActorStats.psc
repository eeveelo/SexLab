scriptname sslActorStats extends sslSystemLibrary

; Titles
string[] StatTitles
string[] PureTitlesMale
string[] PureTitlesFemale
string[] ImpureTitlesMale
string[] ImpureTitlesFemale

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

int function AdjustBy(actor ActorRef, string Stat, int adjust)
	if FindStat(Stat) == -1
		return 0
	endIf
	int Value = GetStatInt(ActorRef, Stat)
	Value += adjust
	SetStat(ActorRef, Stat, (Value as string))
	return Value
endFunction

bool function HasStat(actor ActorRef, string Stat)
	return HasStr(ActorRef, "Custom."+Stat)
endFunction

string function GetStat(actor ActorRef, string Stat)
	if !HasStat(ActorRef, Stat)
		return GetStatDefault(Stat)
	endIf
	return GetStr(ActorRef, "Custom."+Stat)
endFunction

string function GetStatString(actor ActorRef, string Stat)
	return GetStat(ActorRef, Stat)
endFunction

float function GetStatFloat(actor ActorRef, string Stat)
	return GetStat(ActorRef, Stat) as float
endFunction

int function GetStatInt(actor ActorRef, string Stat)
	return GetStat(ActorRef, Stat) as int
endFunction

int function GetStatLevel(actor ActorRef, string Stat, float curve = 0.65)
	return CalcLevel(GetStatInt(ActorRef, Stat), curve)
endFunction

string function GetStatTitle(actor ActorRef, string Stat, float curve = 0.65)
	return StatTitles[sslUtility.ClampInt(CalcLevel(GetStatInt(ActorRef, Stat), curve), 0, 6)]
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

string function GetStatFull(actor ActorRef, string Stat)
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

int function CalcLevel(float total, float curve = 0.65)
	return Math.Sqrt(((Math.Abs(total) + 1.0) / 2.0) * Math.Abs(curve)) as int
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
	if ActorRef != PlayerRef && !HasInt(ActorRef, Skill)
		if Skill == "Vaginal" || Skill == "Anal" || Skill == "Oral"
			SetInt(ActorRef, Skill, (Utility.RandomInt(ActorRef.GetLevel(), (ActorRef.GetLevel() * 2)) + ((((ActorRef.GetActorValue("Speechcraft")*ActorRef.GetActorValue("Confidence")) + 1) / 2.3) as int)))
		elseIf Skill == "Males" || Skill == "Females"
			bool IsFemale = ActorLib.GetGender(ActorRef) == 1
			int Seed = Utility.RandomInt(0, ActorRef.GetLevel())
			; Same sex
			if (IsFemale && Skill == "Females") || (!IsFemale && Skill == "Males")
				Seed += ((Math.Abs(ActorRef.GetLowestRelationshipRank() as float) + 1) as int)*(((ActorRef.GetActorValue("Energy") + 1) / 3) as int)
			else
				Seed *= 2
				Seed += ((Math.Abs(ActorRef.GetLowestRelationshipRank() as float) + 1) as int)*(((ActorRef.GetActorValue("Energy") + ActorRef.GetActorValue("Assistance")) / 3) as int) + (ActorRef.GetActorValue("Assistance") as int)
			endIf
			SetInt(ActorRef, Skill, Seed)
		endIf
	endIf
	return GetInt(ActorRef, Skill)
endFunction

function AdjustSkill(actor ActorRef, string Skill, int AdjustBy)
	if AdjustBy != 0 && ActorRef != none && Skill != ""
		SetInt(ActorRef, Skill, (GetSkill(ActorRef, Skill) + AdjustBy))
	endIf
endFunction

int function GetSkillLevel(Actor ActorRef, string Skill)
	return CalcLevel(GetSkill(ActorRef, Skill), 0.65)
endFunction

string function GetSkillTitle(Actor ActorRef, string Skill)
	return StatTitles[sslUtility.ClampInt(GetSkillLevel(ActorRef, Skill), 0, 6)]
endFunction

; ------------------------------------------------------- ;
; --- Purity/Impurty Stat                             --- ;
; ------------------------------------------------------- ;

function SeedPurityStat(Actor ActorRef)
	if ActorRef != PlayerRef
		; Get relevant-ish AI data
		int Aggression = ActorRef.GetActorValue("Aggression") as int
		int Morality = ActorRef.GetActorValue("Morality") as int
		int Assistance = ActorRef.GetActorValue("Assistance") as int
		; Init base purity based on level and how aggressive they are
		float seed = ((ActorRef.GetLevel() / 2 ) * 9)
		float impurity = (Aggression * 0.40)
		float purity = ((Morality + 1) * 0.40)
		; Doesn't care about crime
		if Morality == 0
			purity -= 0.10
			impurity += 0.15
		; Actor refuses crime
		elseIf Morality == 3
			purity += 0.07
			impurity -= 0.10
		endIf
		; Actor is a morale pacifist
		if Aggression == 0 && Morality != 0
			purity += 0.15
			impurity -= 0.20
		; Aggressive only towards enemies
		elseIf Aggression == 1
			purity += 0.01
		endIf
		; 0 = Actor won't help anybody, make more impure
		; 2 = Actor helps friends+allies, make more pure
		if Assistance == 0
			purity -= 0.05
			impurity += 0.05
		elseIf Assistance == 2
			purity += 0.05
			impurity -= 0.05
		endIf
		; Actor is immorale but helps friends+allies, make more pure
		if Assistance == 2 && Morality == 0
			purity += 0.07
			impurity -= 0.04
		endIf
		; Generate largish amount with seed and base purity/impurity
		purity += ((Math.Abs(purity) * seed) * 1.75) * 1.5
		impurity += ((Math.Abs(impurity) * seed) * 1.75) * 1.5
		if !HasFloat(ActorRef, "Pure")
			SetFloat(ActorRef, "Pure", Math.Abs(purity))
		endIf
		if !HasFloat(ActorRef, "Impure")
			SetFloat(ActorRef, "Impure", Math.Abs(purity))
		endIf
	endIf
endFunction

float function GetPure(Actor ActorRef)
	if ActorRef != PlayerRef && !HasFloat(ActorRef, "Pure")
		SeedPurityStat(ActorRef)
	endIf
	return GetFloat(ActorRef, "Pure")
endFunction

int function GetPureLevel(Actor ActorRef)
	return CalcLevel(GetPure(ActorRef), 0.2)
endFunction

string function GetPureTitle(actor ActorRef)
	if ActorRef.GetLeveledActorBase().GetSex() == 1
		return PureTitlesFemale[sslUtility.ClampInt(GetPureLevel(ActorRef), 0, 6)]
	else
		return PureTitlesMale[sslUtility.ClampInt(GetPureLevel(ActorRef), 0, 6)]
	endIf
endFunction

float function GetImpure(Actor ActorRef)
	if ActorRef != PlayerRef && !HasFloat(ActorRef, "Impure")
		SeedPurityStat(ActorRef)
	endIf
	return GetFloat(ActorRef, "Impure")
endFunction

int function GetImpureLevel(Actor ActorRef)
	return CalcLevel(GetImpure(ActorRef), 0.2)
endFunction

string function GetImpureTitle(Actor ActorRef)
	if ActorRef.GetLeveledActorBase().GetSex() == 1
		return ImpureTitlesFemale[sslUtility.ClampInt(GetImpureLevel(ActorRef), 0, 6)]
	else
		return ImpureTitlesMale[sslUtility.ClampInt(GetImpureLevel(ActorRef), 0, 6)]
	endIf
endFunction

float function GetPurity(Actor ActorRef)
	float pure = GetPure(ActorRef)
	float impure = GetImpure(ActorRef)
	if pure >= impure
		return pure
	else
		return -impure
	endIf
endFunction

float function AdjustPurity(Actor ActorRef, float adjust)
	string type = "Pure"
	if adjust < 0
		type = "Impure"
	endIf
	AdjustFloat(ActorRef, type, Math.Abs(adjust))
	return GetFloat(ActorRef, type)
endFunction

bool function IsPure(Actor ActorRef)
	return GetPure(ActorRef) >= GetImpure(ActorRef)
endFunction

bool function IsImpure(Actor ActorRef)
	return GetPure(ActorRef) < GetImpure(ActorRef)
endFunction

int function GetPurityLevel(Actor ActorRef)
	if IsImpure(ActorRef)
		return GetImpureLevel(ActorRef)
	else
		return GetPureLevel(ActorRef)
	endIf
endFunction

string function GetPurityTitle(Actor ActorRef)
	bool IsFemale = ActorRef.GetLeveledActorBase().GetSex() == 1
	if IsImpure(ActorRef)
		return GetImpureTitle(ActorRef)
	else
		return GetPureTitle(ActorRef)
	endIf
endFunction

; ------------------------------------------------------- ;
; --- Sex Counters                                    --- ;
; ------------------------------------------------------- ;

function AddSex(Actor ActorRef, float TimeSpent = 0.0, bool WithPlayer = false, int Males = 0, int Females = 0, int Creatures = 0)
	AdjustFloat(ActorRef, "TimeSpent", TimeSpent)
	SetFloat(ActorRef, "LastSex.GameTime", Utility.GetCurrentGameTime())
	SetFloat(ActorRef, "LastSex.RealTime", Utility.GetCurrentRealTime())
	if (Males + Females + Creatures) > 1
		int Gender = ActorRef.GetLeveledActorBase().GetSex()
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
	ClearInt(ActorRef, "SexCount")
	ClearInt(ActorRef, "PlayerSex")
	ClearFloat(ActorRef, "LastSex.RealTime")
	ClearFloat(ActorRef, "LastSex.GameTime")
	ClearFloat(ActorRef, "TimeSpent")
	ClearFloat(ActorRef, "Pure")
	ClearFloat(ActorRef, "Impure")
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

	ImpureTitlesMale = new string[7]
	ImpureTitlesMale[0] = "$SSL_Neutral"
	ImpureTitlesMale[1] = "$SSL_Experimenting"
	ImpureTitlesMale[2] = "$SSL_UnusuallyHorny"
	ImpureTitlesMale[3] = "$SSL_Promiscuous"
	ImpureTitlesMale[4] = "$SSL_SexualDeviant"
	ImpureTitlesMale[5] = "$SSL_Depraved"
	ImpureTitlesMale[6] = "$SSL_Hypersexual"

	PureTitlesFemale = new string[7]
	PureTitlesFemale[0] = "$SSL_Neutral"
	PureTitlesFemale[1] = "$SSL_Unsullied"
	PureTitlesFemale[2] = "$SSL_PrimProper"
	PureTitlesFemale[3] = "$SSL_Virtuous"
	PureTitlesFemale[4] = "$SSL_EverFaithful"
	PureTitlesFemale[5] = "$SSL_Ladylike"
	PureTitlesFemale[6] = "$SSL_Saintly"

	ImpureTitlesFemale = new string[7]
	ImpureTitlesFemale[0] = "$SSL_Neutral"
	ImpureTitlesFemale[1] = "$SSL_Experimenting"
	ImpureTitlesFemale[2] = "$SSL_UnusuallyHorny"
	ImpureTitlesFemale[3] = "$SSL_Promiscuous"
	ImpureTitlesFemale[4] = "$SSL_SexualDeviant"
	ImpureTitlesFemale[5] = "$SSL_Debaucherous"
	ImpureTitlesFemale[6] = "$SSL_Nymphomaniac"

	parent.Setup()
endFunction

bool function HasInt(actor ActorRef, string stat)
	return StorageUtil.HasIntValue(ActorRef, "sslActorStats."+stat)
endFunction
bool function HasFloat(actor ActorRef, string stat)
	return StorageUtil.HasFloatValue(ActorRef, "sslActorStats."+stat)
endFunction
bool function HasStr(actor ActorRef, string stat)
	return StorageUtil.HasStringValue(ActorRef, "sslActorStats."+stat)
endFunction

int function GetInt(actor ActorRef, string stat)
	return StorageUtil.GetIntValue(ActorRef, "sslActorStats."+stat)
endFunction
float function GetFloat(actor ActorRef, string stat)
	return StorageUtil.GetFloatValue(ActorRef, "sslActorStats."+stat)
endFunction
string function GetStr(actor ActorRef, string stat)
	return StorageUtil.GetStringValue(ActorRef, "sslActorStats."+stat)
endFunction

function ClearInt(actor ActorRef, string stat)
	StorageUtil.UnsetIntValue(ActorRef, "sslActorStats."+stat)
endFunction
function ClearFloat(actor ActorRef, string stat)
	StorageUtil.UnsetFloatValue(ActorRef, "sslActorStats."+stat)
endFunction
function ClearStr(actor ActorRef, string stat)
	StorageUtil.UnsetStringValue(ActorRef, "sslActorStats."+stat)
endFunction

function SetInt(actor ActorRef, string stat, int value)
	StorageUtil.SetIntValue(ActorRef, "sslActorStats."+stat, value)
endFunction
function SetFloat(actor ActorRef, string stat, float value)
	StorageUtil.SetFloatValue(ActorRef, "sslActorStats."+stat, value)
endFunction
function SetStr(actor ActorRef, string stat, string value)
	StorageUtil.SetStringValue(ActorRef, "sslActorStats."+stat, value)
endFunction

function AdjustInt(actor ActorRef, string stat, int amount)
	if amount != 0
		StorageUtil.SetIntValue(ActorRef, "sslActorStats."+stat, (StorageUtil.GetIntValue(ActorRef, "sslActorStats."+stat) + amount))
	endIF
endFunction
function AdjustFloat(actor ActorRef, string stat, float amount)
	if amount != 0.0
		StorageUtil.SetFloatValue(ActorRef, "sslActorStats."+stat, (StorageUtil.GetFloatValue(ActorRef, "sslActorStats."+stat) + amount))
	endIf
endFunction

