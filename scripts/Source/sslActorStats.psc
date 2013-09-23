scriptname sslActorStats extends Quest

; Scripts
sslActorLibrary property Lib auto

; Data
float property fTimeSpent auto hidden
float property fSexualPurity auto hidden
int property iMalePartners auto hidden
int property iFemalePartners auto hidden
int property iMasturbationCount auto hidden
int property iAnalCount auto hidden
int property iVaginalCount auto hidden
int property iOralCount auto hidden
int property iVictimCount auto hidden
int property iAggressorCount auto hidden
int property iCreatureCount auto hidden

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
;|	Custom Stats                                 |;
;\-----------------------------------------------/;

int function FindStat(string name)
	return StatName.Find(name)
endFunction

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

string function GetValue(string name)
	int index = FindStat(name)
	if index == -1
		return ""
	endIf
	return StatValue[index]
endFunction

int function GetValueInt(string name)
	return GetValue(name) as int
endFunction

string function SetValue(string name, string value)
	int index = FindStat(name)
	if index == -1
		return ""
	endIf
	StatValue[index] = value
	return StatValue[index]
endFunction

int function AdjustBy(string name, int adjust)
	int value = GetValueInt(name)
	value += adjust
	return SetValue(name, (value as string)) as int
endFunction

string function GetStat(string name)
	string[] info = GetInfo(name)
	if info == none
		return ""
	endIf 
	return info[1]+info[0]+info[2]
endFunction

string function GetIndex(int index)
	return GetStat(StatName[index])
endFunction

;/-----------------------------------------------\;
;|	Native Player Stats                          |;
;\-----------------------------------------------/;

function UpdatePlayerStats(int males, int females, sslBaseAnimation Animation, actor victim, float time)
	if !Animation.IsSexual()
		return
	endIf
	; Update time spent
	fTimeSpent += time
	; Nothing else matters for solo animations
	if Animation.HasTag("Masturbation")
		iMasturbationCount += 1
		AdjustPlayerPurity(-1.0)
		return ; Bail
	endIf
	; Update partners
	iMalePartners += males
	iFemalePartners += females
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
	AdjustPlayerPurity(purity * ((males + females) - 1))
endFunction

float function AdjustPlayerPurity(float amount)
	fSexualPurity += amount
	return fSexualPurity
endFunction

int function GetPlayerPurityLevel()
	; Calculate level
	int level = Math.Sqrt(((Math.Abs(fSexualPurity) + 1.0) / 2.0) * 0.2) as int
	; Return signed if impure
	if fSexualPurity < 0
		return -level
	else
		return level
	endif
endFunction

string function GetPlayerPurityTitle()
	; Get titles
	string[] titles
	if fSexualPurity < 0
		titles = sImpureTitles
	else
		titles = sPureTitles
	endIf
	; Clamp levels to titles array
	int level = Math.Abs(GetPlayerPurityLevel()) as int
	if level > 6
		return titles[6]
	elseif level < 0
		return titles[0]
	else
		return titles[level]
	endIf
endFunction

string function GetPlayerSexuality()
	; Check gender
	bool IsFemale = Lib.GetGender(Lib.PlayerRef) == 1
	; Calculate "straightness ratio" 0 = full gay, 1 = full straight
	float ratio
	if IsFemale
		ratio = ((iMalePartners + 1.0) / ((iMalePartners + iFemalePartners + 1) as float)) * 100.0
	else
		ratio = ((iFemalePartners + 1.0) / ((iMalePartners + iFemalePartners + 1) as float)) * 100.0
	endIf
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

int function GetPlayerStatLevel(string type)
	float val
	if type == "Vaginal"
		val = iVaginalCount as float
	elseIf type == "Anal"
		val = iAnalCount as float
	elseIf type == "Oral"
		val = iOralCount as float
	else
		return -1
	endIf
	return Math.Sqrt(((val + 1.0) / 2.0) * 0.65) as int ; Return as int to floor value for level number
endFunction

string function GetPlayerStatTitle(string type)
	int level = GetPlayerStatLevel(type)
	; Clamp levels to stat titles array
	string title
	if level > 6
		return sStatTitles[6]
	elseif level < 0
		return sStatTitles[0]
	else
		return sStatTitles[level]
	endIf
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
	iMasturbationCount = 0
	iAnalCount = 0
	iVaginalCount = 0
	iOralCount = 0
	iVictimCount = 0
	iAggressorCount = 0
	iCreatureCount = 0

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