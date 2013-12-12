scriptname sslActorStats extends Quest

; Scripts
sslActorLibrary property Lib auto

; Data
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

string[] property CustomStats hidden
	string[] function get()
		return StatName
	endFunction
endProperty

;/-----------------------------------------------\;
;|	Manipulate Custom Stats                      |;
;\-----------------------------------------------/;

int function RegisterStat(string name, string value, string prepend = "", string append = "")
	int index = FindStat(name)
	if index == -1
		StatName = sslUtility.PushString(name, StatName)
		StatValue = sslUtility.PushString(value, StatValue)
		StatPrepend = sslUtility.PushString(prepend, StatPrepend)
		StatAppend = sslUtility.PushString(append, StatAppend)
		return (StatName.Length - 1)
	endIf
	return index
endFunction

function Alter(string name, string newName = "", string value = "", string prepend = "", string append = "")
	int index = FindStat(name)
	if index == -1
		return
	endIf
	if newName != ""
		StatName[index] = newName
	endIf
	if value != ""
		StatValue[index] = value
	endIf
	if prepend != ""
		StatPrepend[index] = prepend
	endIf
	if append != ""
		StatAppend[index] = append
	endIf
endFunction

string function SetStat(string name, string value)
	int index = FindStat(name)
	if index == -1
		return ""
	endIf
	StatValue[index] = value
	return StatValue[index]
endFunction

int function AdjustBy(string name, int adjust)
	int value = GetStatInt(name)
	value += adjust
	return SetStat(name, (value as string)) as int
endFunction

;/-----------------------------------------------\;
;|	Stat Custom Stat Lookup                      |;
;\-----------------------------------------------/;

string function GetStat(string name)
	int index = FindStat(name)
	if index == -1
		return ""
	endIf
	return StatValue[index]
endFunction

float function GetStatFloat(string name)
	return GetStat(name) as float
endFunction

int function GetStatInt(string name)
	return GetStat(name) as int
endFunction

int function GetStatLevel(string name, float curve = 0.65)
	return CalcLevel(GetStatInt(name), curve)
endFunction

string function GetStatTitle(string name, float curve = 0.65)
	return sStatTitles[Clamp(CalcLevel(GetStatInt(name), curve), 6)]
endFunction

string function GetStatFull(string name)
	string[] info = GetInfo(name)
	if info == none
		return ""
	endIf
	return info[1]+info[0]+info[2]
endFunction

int function FindStat(string name)
	return StatName.Find(name)
endFunction

string[] function GetInfo(string name)
	int index = FindStat(name)
	if index == -1
		return none
	endIf
	string[] info = new string[3]
	info[0] = StatValue[index]
	info[1] = StatPrepend[index]
	info[2] = StatAppend[index]
	return info
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

string function ParseTime(int time)
	return ((time / 3600) as int)+":"+(((time / 60) % 60) as int)+":"+(time % 60 as int)
endFunction

;/-----------------------------------------------\;
;|	Native NPC Stats                             |;
;\-----------------------------------------------/;

int function GetSkill(actor ActorRef, string skill)
	; Native Player skills
	if ActorRef == Lib.PlayerRef
		if skill == "Vaginal"
			return iVaginalCount
		elseIf skill == "Anal"
			return iAnalCount
		elseIf skill == "Oral"
			return iOralCount
		elseIf skill == "Males"
			return iMalePartners
		elseIf skill == "Females"
			return iFemalePartners
		endIf
	endIf
	; Seed for NPC native skills
	if ActorRef != Lib.PlayerRef && !HasInt(ActorRef, skill)
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
	; Get Player purity
	if ActorRef == Lib.PlayerRef
		return fSexualPurity
	endIf
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

function AdjustPurity(actor ActorRef, float amount)
	if ActorRef == Lib.PlayerRef
		fSexualPurity += amount
	else
		SetFloat(ActorRef, "Purity", (GetFloat(ActorRef, "Purity") + amount))
	endIf
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
	return GetSkillLevel(Lib.PlayerRef, skill)
endFunction

string function GetPlayerSkillTitle(string skill)
	return sStatTitles[Clamp(GetPlayerSkillLevel(skill), 6)]
endFunction

int function GetPlayerPurityLevel()
	return CalcLevel(fSexualPurity, 0.2)
endFunction

string function GetPlayerPurityTitle()
	if fSexualPurity < 0
		return sImpureTitles[Clamp(GetPlayerPurityLevel(), 6)]
	else
		return sPureTitles[Clamp(GetPlayerPurityLevel(), 6)]
	endIf
endFunction

string function GetPlayerSexualityTitle()
	return GetSexualityTitle(Lib.PlayerRef)
endFunction

;/-----------------------------------------------\;
;|	System Functions                             |;
;\-----------------------------------------------/;

function UpdateNativeStats(actor ActorRef, int males, int females, int creatures, sslBaseAnimation Animation, actor victim, float time)
	if !Animation.IsSexual()
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
	; Player tracked skills
	if ActorRef == Lib.PlayerRef
		iAnalCount += (anal as int)
		iVaginalCount += (vaginal as int)
		iOralCount += (oral as int)
		iVictimCount += (isVictim as int)
		iAggressorCount += (isAggressor as int)
		; Update time spent
		fTimeSpent += time
		; Update player partners
		iMalePartners += males
		iFemalePartners += females
		iCreaturePartners += creatures
		if Lib.GetGender(ActorRef) == 1
			iFemalePartners -= 1 ; Female Player
		else
			iMalePartners -= 1 ; Male Player
		endIf
	; NPC tracked skills
	else
		AdjustSkill(ActorRef, "Anal", (anal as int))
		AdjustSkill(ActorRef, "Vaginal", (vaginal as int))
		AdjustSkill(ActorRef, "Oral", (oral as int))
		AdjustSkill(ActorRef, "Victim", (isVictim as int))
		AdjustSkill(ActorRef, "Aggressor", (isAggressor as int))
		if Lib.GetGender(ActorRef) == 1
			AdjustSkill(ActorRef, "Females", (females - 1))
			AdjustSkill(ActorRef, "Males", males)
		else
			AdjustSkill(ActorRef, "Females", females)
			AdjustSkill(ActorRef, "Males", (males - 1))
		endIf
	endIf
	; Update perversion/purity
	float purity
	if isVictim
		purity = -1.2
	elseif isAggressor || Animation.HasTag("Dirty")
		purity = -2.5
	elseif !isVictim && Animation.HasTag("Loving")
		purity = 2.5
	else
		purity = Utility.RandomFloat(-0.8, 0.8)
	endIf
	purity *= ((males + females) - 1) + (creatures * -0.8)
	; Adjuster-ma-jigger.
	; Adjust base purity by present male/females + subtract purity for each creature present
	AdjustPurity(ActorRef, purity)
endFunction

int function Clamp(int value, int max)
	if value > max
		return max
	elseif value < 0
		return 0
	endif
	return value
endFunction

function _Setup()
	string[] sDel
	StatName = sDel
	StatValue = sDel
	StatPrepend = sDel
	StatAppend = sDel

	fTimeSpent = 0.0
	fSexualPurity = 0.0
	iMalePartners = 0
	iFemalePartners = 0
	iCreaturePartners = 0
	iMasturbationCount = 0
	iAnalCount = 0
	iVaginalCount = 0
	iOralCount = 0
	iVictimCount = 0
	iAggressorCount = 0

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

	if Lib.PlayerRef.GetLeveledActorBase().GetSex() > 0
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

	SendModEvent("SexLabRegisterStats")
endFunction

bool function HasInt(actor ActorRef, string stat)
	return StorageUtil.HasIntValue(ActorRef, "sslActorStats."+stat)
endFunction
bool function HasFloat(actor ActorRef, string stat)
	return StorageUtil.HasFloatValue(ActorRef, "sslActorStats."+stat)
endFunction
bool function HasString(actor ActorRef, string stat)
	return StorageUtil.HasStringValue(ActorRef, "sslActorStats."+stat)
endFunction

int function GetInt(actor ActorRef, string stat)
	return StorageUtil.GetIntValue(ActorRef, "sslActorStats."+stat)
endFunction
float function GetFloat(actor ActorRef, string stat)
	return StorageUtil.GetFloatValue(ActorRef, "sslActorStats."+stat)
endFunction
string function GetString(actor ActorRef, string stat)
	return StorageUtil.GetStringValue(ActorRef, "sslActorStats."+stat)
endFunction

function SetInt(actor ActorRef, string stat, int value)
	StorageUtil.SetIntValue(ActorRef, "sslActorStats."+stat, value)
endFunction
function SetFloat(actor ActorRef, string stat, float value)
	StorageUtil.SetFloatValue(ActorRef, "sslActorStats."+stat, value)
endFunction
function SetString(actor ActorRef, string stat, string value)
	StorageUtil.SetStringValue(ActorRef, "sslActorStats."+stat, value)
endFunction
