scriptname sslActorStats extends Quest

; Scripts
sslActorLibrary property Lib auto

; Data
actor property PlayerRef auto
faction property PlayerSexPartners auto

float property fTimeSpent auto hidden
float property fSexualPurity auto hidden
int property iMalePartners auto hidden
int property iFemalePartners auto hidden
int property iCreaturePartners auto hidden
int property iMasturbationCount auto hidden
int property iAnalCount auto hidden
int property iVaginalCount auto hidden
int property iOralCount auto hidden
int property iVictimCount auto hidden
int property iAggressorCount auto hidden

; Titles
string[] sStatTitles
string[] sPureTitles
string[] sImpureTitles

; Local
string[] StatName
string[] StatValue
string[] StatPrepend
string[] StatAppend
bool updated

string[] property CustomStats hidden
	string[] function get()
		return StatName
	endFunction
endProperty

;/-----------------------------------------------\;
;|	Manipulate Custom Stats                      |;
;\-----------------------------------------------/;

int function FindStat(string stat)
	return StatName.Find(stat)
endFunction

int function RegisterStat(string stat, string value, string prepend = "", string append = "")
	if FindStat(stat) == -1
		StatName = sslUtility.PushString(stat, StatName)
		StatValue = sslUtility.PushString(value, StatValue)
		StatPrepend = sslUtility.PushString(prepend, StatPrepend)
		StatAppend = sslUtility.PushString(append, StatAppend)
		SetStat(PlayerRef, stat, value)
	endIf
	return FindStat(stat)
endFunction

function Alter(string name, string newName = "", string value = "", string prepend = "", string append = "")
	int i = FindStat(name)
	if i == -1
		return
	endIf
	if newName != ""
		StatName[i] = newName
	endIf
	if value != ""
		StatValue[i] =  value
	endIf
	if prepend != ""
		StatPrepend[i] =  prepend
	endIf
	if append != ""
		StatAppend[i] =  append
	endIf
endFunction

bool function ClearStat(actor ActorRef, string stat)
	if HasStat(ActorRef, stat)
		ClearString(ActorRef, "Custom."+stat)
		return true
	endIf
	return false
endFunction

function SetStat(actor ActorRef, string stat, string value)
	if FindStat(stat) != -1
		SetStr(ActorRef, "Custom."+stat, value)
	endIf
endFunction

int function AdjustBy(actor ActorRef, string stat, int adjust)
	if FindStat(stat) == -1
		return 0
	endIf
	int value = GetStatInt(ActorRef, stat)
	value += adjust
	SetStat(ActorRef, stat, (value as string))
	return value
endFunction

;/-----------------------------------------------\;
;|	Stat Custom Stat Lookup                      |;
;\-----------------------------------------------/;

bool function HasStat(actor ActorRef, string stat)
	return HasStr(ActorRef, "Custom."+stat)
endFunction

string function GetStat(actor ActorRef, string stat)
	if !HasStat(ActorRef, stat)
		return GetStatDefault(stat)
	endIf
	return GetStr(ActorRef, "Custom."+stat)
endFunction

string function GetStatString(actor ActorRef, string stat)
	return GetStat(ActorRef, stat)
endFunction

float function GetStatFloat(actor ActorRef, string stat)
	return GetStat(ActorRef, stat) as float
endFunction

int function GetStatInt(actor ActorRef, string stat)
	return GetStat(ActorRef, stat) as int
endFunction

int function GetStatLevel(actor ActorRef, string stat, float curve = 0.65)
	return CalcLevel(GetStatInt(ActorRef, stat), curve)
endFunction

string function GetStatTitle(actor ActorRef, string stat, float curve = 0.65)
	return sStatTitles[Clamp(CalcLevel(GetStatInt(ActorRef, stat), curve), 6)]
endFunction

string function GetStatDefault(string stat)
	int i = FindStat(stat)
	if i != -1 && i < StatValue.Length
		return StatValue[i]
	endIf
	return ""
endFunction

string function GetStatPrepend(string stat)
	int i = FindStat(stat)
	if i != -1 && i < StatPrepend.Length
		return StatPrepend[i]
	endIf
	return ""
endFunction

string function GetStatAppend(string stat)
	int i = FindStat(stat)
	if i != -1 && i < StatAppend.Length
		return StatAppend[i]
	endIf
	return ""
endFunction

string function GetStatFull(actor ActorRef, string stat)
	int i = FindStat(stat)
	if i != -1 && i < StatName.Length
		return StatPrepend[i] + GetStat(ActorRef, stat) + StatAppend[i]
	endIf
	return ""
endFunction

;/-----------------------------------------------\;
;|	Calculate/Parse Stats                        |;
;\-----------------------------------------------/;

int function CalcSexuality(bool IsFemale, int males, int females)
	; Calculate "sexuality ratio" 0 = full homosexual, 100 = full heterosexual
	if IsFemale
		return (((males + 1.0) / ((males + females + 1) as float)) * 100.0) as int
	else
		return (((females + 1.0) / ((males + females + 1) as float)) * 100.0) as int
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

;/-----------------------------------------------\;
;|	Native NPC Stats                             |;
;\-----------------------------------------------/;

int function GetSkill(actor ActorRef, string skill)
	; Seed for NPC native skills
	if ActorRef != PlayerRef && !HasInt(ActorRef, skill)
		if skill == "Vaginal" || skill == "Anal" || skill == "Oral"
			SetInt(ActorRef, skill, (Utility.RandomInt(ActorRef.GetLevel(), (ActorRef.GetLevel() * 2)) + ((((ActorRef.GetActorValue("Speechcraft")*ActorRef.GetActorValue("Confidence")) + 1) / 2.3) as int)))
		elseIf skill == "Males" || skill == "Females"
			bool IsFemale = Lib.GetGender(ActorRef) == 1
			int amount = Utility.RandomInt(0, ActorRef.GetLevel())
			; Same sex
			if (IsFemale && skill == "Females") || (!IsFemale && skill == "Males")
				amount += ((Math.Abs(ActorRef.GetLowestRelationshipRank() as float) + 1) as int)*(((ActorRef.GetActorValue("Energy") + 1) / 3) as int)
			else
				amount *= 2
				amount += ((Math.Abs(ActorRef.GetLowestRelationshipRank() as float) + 1) as int)*(((ActorRef.GetActorValue("Energy") + ActorRef.GetActorValue("Assistance")) / 3) as int) + (ActorRef.GetActorValue("Assistance") as int)
			endIf
			SetInt(ActorRef, skill, amount)
		endIf
	endIf
	return GetInt(ActorRef, skill)
endFunction

function AdjustSkill(actor ActorRef, string skill, int amount)
	if amount != 0 && ActorRef != none && skill != ""
		SetInt(ActorRef, skill, (GetSkill(ActorRef, skill) + amount))
	endIf
endFunction

int function GetSkillLevel(actor ActorRef, string skill)
	return CalcLevel(GetSkill(ActorRef, skill), 0.65)
endFunction

string function GetSkillTitle(actor ActorRef, string skill)
	return sStatTitles[Clamp(GetSkillLevel(ActorRef, skill), 6)]
endFunction

float function GetPurity(actor ActorRef)
	; Seed NPC purity stat if empty
	if !HasFloat(ActorRef, "Purity")
		; Get relevant-ish AI data
		int Aggression = ActorRef.GetActorValue("Aggression") as int
		int Morality = ActorRef.GetActorValue("Morality") as int
		int Assistance = ActorRef.GetActorValue("Assistance") as int
		; Init base purity based on level and how aggressive they are
		float purity = ((ActorRef.GetLevel() / 2 ) * 9)
		float seed = ((((Aggression+1) as float) / 5.0) * 0.40)
		; Actor doesn't care about crime, make more impure
		if Morality == 0
			seed += 0.10
		; Actor refuses crime
		elseIf Morality == 3
			seed += 0.07
		endIf
		; Actor is a morale pacifist, make more pure
		if Aggression == 0 && Morality != 0
			seed += 0.06
		; Non aggessive, add small bit
		elseIf Aggression == 0
			seed += 0.02
		; Aggressive only towards enemies
		elseIf Aggression == 1
			seed += 0.01
		endIf
		; 0 = Actor won't help anybody, make more impure
		; 2 = Actor helps friends+allies, make more pure
		if Assistance != 1
			seed += 0.05
		endIf
		; Actor is immorale but helps friends+allies, make more pure
		if Assistance == 2 && Morality == 0
			seed -= 0.04
		endIf
		; Generate largish purity with seed and base purity
		purity += ((purity * seed) * 1.75) * 1.5
		; Save & Sign purity to make impure, based on "bad" traits
		SetFloat(ActorRef, "Purity", sslUtility.SignFloat((Morality == 0 || Aggression >= 2 || (Assistance == 0 && Morality == 3)), purity))
	endIf
	; Return saved stat
	return GetFloat(ActorRef, "Purity")
endFunction

int function GetPurityLevel(actor ActorRef)
	return CalcLevel(GetPurity(ActorRef), 0.2)
endFunction

string function GetPurityTitle(actor ActorRef)
	if IsImpure(ActorRef)
		return sImpureTitles[Clamp(GetPurityLevel(ActorRef), 6)]
	else
		return sPureTitles[Clamp(GetPurityLevel(ActorRef), 6)]
	endIf
endFunction

bool function IsPure(actor ActorRef)
	return GetPurity(ActorRef) >= 0
endFunction

bool function IsImpure(actor ActorRef)
	return GetPurity(ActorRef) < 0
endFunction

int function GetSexuality(actor ActorRef)
	return CalcSexuality((Lib.GetGender(ActorRef) == 1), GetSkill(ActorRef, "Males"), GetSkill(ActorRef, "Females"))
endFunction

string function GetSexualityTitle(actor ActorRef)
	bool IsFemale = Lib.GetGender(ActorRef) == 1
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

bool function IsStraight(actor ActorRef)
	return GetSexuality(ActorRef) >= 65
endFunction

bool function IsBisexual(actor ActorRef)
	int ratio = GetSexuality(ActorRef)
	return ratio < 65 && ratio > 35
endFunction

bool function IsGay(actor ActorRef)
	return GetSexuality(ActorRef) <= 35
endFunction

int function SexCount(actor a)
	return GetInt(a, "SexCount")
endFunction

bool function HadSex(actor a)
	return SexCount(a) > 0
endFunction

function AddSex(actor a, float TimeSpent = 0.0, bool WithPlayer = false)
	AdjustInt(a, "SexCount", 1)
	AdjustFloat(a, "TimeSpent", TimeSpent)
	SetFloat(a, "LastSex.GameTime", Utility.GetCurrentGameTime())
	SetFloat(a, "LastSex.RealTime", Utility.GetCurrentRealTime())
	if WithPlayer && a != PlayerRef
		AddPlayerSex(a)
	endIf
endFunction

; Last sex - Game time - float days
float function LastSexGameTime(actor a)
	return GetFloat(a, "LastSex.GameTime")
endFunction

float function DaysSinceLastSex(actor a)
	return Utility.GetCurrentGameTime() - LastSexGameTime(a)
endFunction

float function HoursSinceLastSex(actor a)
	return DaysSinceLastSex(a) * 24.0
endFunction

float function MinutesSinceLastSex(actor a)
	return DaysSinceLastSex(a) * 1440.0
endFunction

float function SecondsSinceLastSex(actor a)
	return DaysSinceLastSex(a) * 86400.0
endFunction

string function LastSexTimerString(actor a)
	return ParseTime(SecondsSinceLastSex(a) as int)
endFunction

; Last sex - Real Time - float seconds
float function LastSexRealTime(actor a)
	if !HasFloat(a, "LastSex.RealTime")
		return 0.0001 ; Prevent division by zero
	endIf
	return GetFloat(a, "LastSex.RealTime")
endFunction

float function SecondsSinceLastSexRealTime(actor a)
	return Utility.GetCurrentRealTime() - LastSexRealTime(a)
endFunction

float function MinutesSinceLastSexRealTime(actor a)
	return SecondsSinceLastSexRealTime(a) / 60.0
endFunction

float function HoursSinceLastSexRealTime(actor a)
	return SecondsSinceLastSexRealTime(a) / 3600.0
endFunction

float function DaysSinceLastSexRealTime(actor a)
	return SecondsSinceLastSexRealTime(a) / 86400.0
endFunction

string function LastSexTimerStringRealTime(actor a)
	return ParseTime(SecondsSinceLastSexRealTime(a) as int)
endFunction

;/-----------------------------------------------\;
;|	Native Player Stats                          |;
;\-----------------------------------------------/;

int function PlayerSexCount(actor a)
	return a.GetFactionRank(PlayerSexPartners)
endFunction

bool function HadPlayerSex(actor a)
	return a.IsInFaction(PlayerSexPartners)
endFunction

function AddPlayerSex(actor a)
	if a.IsInFaction(PlayerSexPartners)
		a.ModFactionRank(PlayerSexPartners, 1)
	else
		a.SetFactionRank(PlayerSexPartners, 1)
	endIf
endFunction

int function GetPlayerSkillLevel(string skill)
	return GetSkillLevel(PlayerRef, skill)
endFunction

string function GetPlayerSkillTitle(string skill)
	return sStatTitles[Clamp(GetSkillLevel(PlayerRef, skill), 6)]
endFunction

int function GetPlayerPurityLevel()
	return GetPurityLevel(PlayerRef)
endFunction

string function GetPlayerPurityTitle()
	if fSexualPurity < 0
		return sImpureTitles[Clamp(GetPurityLevel(PlayerRef), 6)]
	else
		return sPureTitles[Clamp(GetPurityLevel(PlayerRef), 6)]
	endIf
endFunction

string function GetPlayerSexualityTitle()
	return GetSexualityTitle(PlayerRef)
endFunction

;/-----------------------------------------------\;
;|	System Functions                             |;
;\-----------------------------------------------/;

function UpdateNativeStats(actor ActorRef, int males, int females, int creatures, sslBaseAnimation Animation, actor victim, float time, bool WithPlayer)
	if ActorRef == none || !Animation.IsSexual() || (males + females + creatures) == 0
		return
	endIf
	; Gather information
	bool anal = Animation.HasTag("Anal")
	bool vaginal = Animation.HasTag("Vaginal")
	bool oral = Animation.HasTag("Oral")
	bool isAggressor = victim != none && victim != ActorRef
	bool isVictim = victim != none && victim == ActorRef
	; Vaginal tag but no vaginas present, assume gay male pairing
	if vaginal && females == 0
		vaginal = false
		anal = true
	endIf
	; Record sex act
	AddSex(ActorRef, time, WithPlayer)
	; Adjust tracked stats/skills
	AdjustSkill(ActorRef, "Anal", (anal as int))
	AdjustSkill(ActorRef, "Vaginal", (vaginal as int))
	AdjustSkill(ActorRef, "Oral", (oral as int))
	AdjustSkill(ActorRef, "Victim", (isVictim as int))
	AdjustSkill(ActorRef, "Aggressor", (isAggressor as int))
	if Animation.ActorCount() == 1
		AdjustSkill(ActorRef, "Masturbation", 1)
	elseIf Lib.GetGender(ActorRef) == 1
		AdjustSkill(ActorRef, "Females", (females - 1))
		AdjustSkill(ActorRef, "Males", males)
		AdjustSkill(ActorRef, "Creatures", Creatures)
	else
		AdjustSkill(ActorRef, "Females", females)
		AdjustSkill(ActorRef, "Males", (males - 1))
		AdjustSkill(ActorRef, "Creatures", Creatures)
	endIf
	; Update perversion/purity
	bool isDirty = Animation.HasTag("Dirty")
	bool isLoving = Animation.HasTag("Loving")
	; Get base purity weight
	float purity = Utility.RandomFloat(0.0, 0.8)
	if isVictim
		purity += 1.0
	elseif isAggressor
		purity += 2.5
	elseIf isDirty || IsLoving
		purity += 2.0
	endIf
	; Scale up with each additional actor beyond 2
	if (males + females + creatures) > 2
		purity += (purity * ((males + females + creatures) - 1))
	endIf
	; Make signed if impure, or 1 in 4 chance otherwise
	if victim != none || creatures != 0 || isDirty || (!isLoving && Utility.RandomInt(1, 4) == 1)
		purity = -purity
	endIf
	; Adjuster-ma-jigger.
	; Adjust base purity by present male/females + subtract purity for each creature present
	AdjustFloat(ActorRef, "Purity", purity)
endFunction

int function Clamp(int value, int max)
	if value > max
		return max
	elseif value < 0
		return 0
	endif
	return value
endFunction

function _ClearStats()
	SetFloat(PlayerRef, "TimeSpent", 0.0)
	SetFloat(PlayerRef, "Purity", 0.0)
	SetInt(PlayerRef, "Males", 0)
	SetInt(PlayerRef, "Females", 0)
	SetInt(PlayerRef, "Creatures", 0)
	SetInt(PlayerRef, "Masturbation", 0)
	SetInt(PlayerRef, "Anal", 0)
	SetInt(PlayerRef, "Vaginal", 0)
	SetInt(PlayerRef, "Oral", 0)
	SetInt(PlayerRef, "Victim", 0)
	SetInt(PlayerRef, "Aggressor", 0)

	string[] StrDel1
	StatName = StrDel1
	string[] StrDel2
	StatValue = StrDel2
	string[] StrDel3
	StatPrepend = StrDel3
	string[] StrDel4
	StatAppend = StrDel4

	SendModEvent("SexLabRegisterStats")
endFunction

function _Setup()
	sPureTitles = new string[7]
	sPureTitles[0] = "$SSL_Neutral"
	sPureTitles[1] = "$SSL_Unsullied"
	sPureTitles[3] = "$SSL_Virtuous"
	sPureTitles[4] = "$SSL_EverFaithful"
	sPureTitles[6] = "$SSL_Saintly"

	sImpureTitles = new string[7]
	sImpureTitles[0] = "$SSL_Neutral"
	sImpureTitles[1] = "$SSL_Experimenting"
	sImpureTitles[2] = "$SSL_UnusuallyHorny"
	sImpureTitles[3] = "$SSL_Promiscuous"
	sImpureTitles[4] = "$SSL_SexualDeviant"

	sStatTitles = new string[7]
	sStatTitles[0] = "$SSL_Unskilled"
	sStatTitles[1] = "$SSL_Novice"
	sStatTitles[2] = "$SSL_Apprentice"
	sStatTitles[3] = "$SSL_Journeyman"
	sStatTitles[4] = "$SSL_Expert"
	sStatTitles[5] = "$SSL_Master"
	sStatTitles[6] = "$SSL_GrandMaster"

	if PlayerRef.GetLeveledActorBase().GetSex() > 0
		sPureTitles[2] = "$SSL_PrimProper"
		sPureTitles[5] = "$SSL_Ladylike"
		sImpureTitles[5] = "$SSL_Debaucherous"
		sImpureTitles[6] = "$SSL_Nymphomaniac"
	else
		sPureTitles[2] = "$SSL_CleanCut"
		sPureTitles[5] = "$SSL_Lordly"
		sImpureTitles[5] = "$SSL_Depraved"
		sImpureTitles[6] = "$SSL_Hypersexual"
	endIf
endFunction

function _Upgrade132()
	PlayerRef = Lib.PlayerRef
	; Native Stats
	SetFloat(PlayerRef, "TimeSpent", fTimeSpent)
	SetFloat(PlayerRef, "Purity", fSexualPurity)
	SetInt(PlayerRef, "Males", iMalePartners)
	SetInt(PlayerRef, "Females", iFemalePartners)
	SetInt(PlayerRef, "Creatures", iCreaturePartners)
	SetInt(PlayerRef, "Masturbation", iMasturbationCount)
	SetInt(PlayerRef, "Anal", iAnalCount)
	SetInt(PlayerRef, "Vaginal", iVaginalCount)
	SetInt(PlayerRef, "Oral", iOralCount)
	SetInt(PlayerRef, "Victim", iVictimCount)
	SetInt(PlayerRef, "Aggressor", iAggressorCount)
	; Custom Stats
	StorageUtil.StringListClear(none, "sslActorStats.CustomStats")
endFunction

function _Upgrade134()
	; v1.34 - Clean out unneeded stat storage
	int i = StorageUtil.StringListCount(none, "sslActorStats.CustomStats")
	while i
		i -= 1
		StorageUtil.UnsetStringValue(PlayerRef, "sslActorStats.Custom."+StorageUtil.StringListGet(none, "sslActorStats.CustomStats", i))
	endWhile
	StorageUtil.StringListClear(none, "sslActorStats.CustomStats")
	string[] StrDel1
	StatName = StrDel1
	string[] StrDel2
	StatValue = StrDel2
	string[] StrDel3
	StatPrepend = StrDel3
	string[] StrDel4
	StatAppend = StrDel4
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

function ClearInt(actor ActorRef, int stat)
	StorageUtil.UnsetIntValue(ActorRef, "sslActorStats."+stat)
endFunction
function ClearFloat(actor ActorRef, float stat)
	StorageUtil.UnsetFloatValue(ActorRef, "sslActorStats."+stat)
endFunction
function ClearString(actor ActorRef, string stat)
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
	StorageUtil.SetIntValue(ActorRef, "sslActorStats."+stat, (StorageUtil.GetIntValue(ActorRef, "sslActorStats."+stat) + amount))
endFunction
function AdjustFloat(actor ActorRef, string stat, float amount)
	StorageUtil.SetFloatValue(ActorRef, "sslActorStats."+stat, (StorageUtil.GetFloatValue(ActorRef, "sslActorStats."+stat) + amount))
endFunction

