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

function UpdatePlayerStats(int males, int females, int creatures, sslBaseAnimation Animation, actor victim, float time)
	if !Animation.IsSexual()
		return
	endIf
	; Update time spent
	fTimeSpent += time
	; Nothing else matters for solo animations
	if Animation.HasTag("Masturbation")
		iMasturbationCount += 1
		AdjustPurity(-1.0)
		return ; Bail
	endIf
	; Update partners
	iMalePartners += males
	iFemalePartners += females
	iCreaturePartners += creatures
	; Don't count players gender in that
	if Lib.GetGender(Lib.PlayerRef) == 1
		iFemalePartners -= 1 ; Female Player
	else
		iMalePartners -= 1 ; Male Player
	endIf
	; Gather information
	bool anal = Animation.HasTag("Anal")
	bool vaginal = Animation.HasTag("Vaginal")
	bool oral = Animation.HasTag("Oral")
	bool isAggressor = victim != Lib.PlayerRef
	bool isVictim = victim == Lib.PlayerRef
	; Vaginal tag but no vaginas present, assume gay male pairing
	if vaginal && females == 0
		vaginal = false
		anal = true
	endIf
	; Update type counts
	iAnalCount += (anal as int)
	iVaginalCount += (vaginal as int)
	iOralCount += (oral as int)
	if victim != none
		iVictimCount += (isVictim as int)
		iAggressorCount += (isAggressor as int)
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
	; Adjuster-ma-jigger.
	; Adjust base purity by present male/females + subtract purity for each creature present
	AdjustPurity(purity * ((males + females) - 1) + (creatures * -0.8))
endFunction

float function AdjustPurity(float amount)
	fSexualPurity += amount
	return fSexualPurity
endFunction

int function GetPlayerPurityLevel()
	return CalcLevel(fSexualPurity, 0.2)
endFunction

bool function IsPure()
	return fSexualPurity >= 0
endFunction

bool function IsImpure()
	return fSexualPurity < 0
endFunction

string function GetPlayerPurityTitle()
	if fSexualPurity < 0
		return sImpureTitles[Clamp(GetPlayerPurityLevel(), 6)]
	else
		return sPureTitles[Clamp(GetPlayerPurityLevel(), 6)]
	endIf
endFunction

string function GetSexualityTitle()
	bool IsFemale = Lib.GetGender(Lib.PlayerRef) == 1
	int ratio = CalcSexuality(IsFemale, iMalePartners, iFemalePartners)
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

int function GetPlayerProficencyLevel(string type)
	if type == "Vaginal"
		return CalcLevel(iVaginalCount, 0.65)
	elseIf type == "Anal"
		return CalcLevel(iAnalCount, 0.65)
	elseIf type == "Oral"
		return CalcLevel(iOralCount, 0.65)
	endIf
	return -1
endFunction

string function GetPlayerProficencyTitle(string type)
	return sStatTitles[Clamp(GetPlayerProficencyLevel(type), 6)]
endFunction

int function GetActorProficencyLevel(actor ActorRef)
	int xp = (ActorRef.GetLevel() * 2) + ((((ActorRef.GetActorValue("Speechcraft")*ActorRef.GetActorValue("Confidence")) + 1) / 2.0) as int)
	return CalcLevel(xp, 0.65)
endFunction

float function GetActorPurityStat(actor ActorRef)
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
	; Sign purity to make impure, based on "bad" traits
	return sslUtility.SignFloat((Morality == 0 || Aggression >= 2 || (Assistance == 0 && Morality == 3)), purity)
endFunction

int function GetActorPurityLevel(actor ActorRef)
	return CalcLevel(GetActorPurityStat(ActorRef), 0.2)
endFunction

bool function IsActorPure(actor ActorRef)
	return GetActorPurityStat(ActorRef) >= 0
endFunction

bool function IsActorImpure(actor ActorRef)
	return GetActorPurityStat(ActorRef) < 0
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
