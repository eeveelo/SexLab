scriptname sslActorStats extends Quest

; Scripts
sslActorLibrary property Lib auto

; Data
float property fTimeSpent = 0.0 auto hidden
float property fSexualPurity = 0.0 auto hidden
int property iMalePartners = 0 auto hidden
int property iFemalePartners = 0 auto hidden
int property iMasturbationCount = 0 auto hidden
int property iAnalCount = 0 auto hidden
int property iVaginalCount = 0 auto hidden
int property iOralCount = 0 auto hidden
int property iVictimCount = 0 auto hidden
int property iAggressorCount = 0 auto hidden
string[] property sCustomStatName auto hidden
string[] property sCustomStatValue auto hidden

; Titles
string[] sStatTitles
string[] sPureTitles
string[] sImpureTitles

function UpdatePlayerStats(sslBaseAnimation anim, float time, actor[] pos, actor victim)
	if !anim.IsSexual()
		return
	endIf
	; Update time spent
	fTimeSpent = fTimeSpent + time

	int[] genders = Lib.GenderCount(pos)
	int males = genders[0]
	int females = genders[1]

	if Lib.GetGender(Lib.PlayerRef) > 0
		iMalePartners = iMalePartners + males
		iFemalePartners = iFemalePartners + (females - 1)
	else
		iMalePartners = iMalePartners + (males - 1)
		iFemalePartners = iFemalePartners + females
	endIf

	int partners = (males + females) - 1
	bool anal = anim.HasTag("Anal")
	bool vaginal = anim.HasTag("Vaginal")
	bool oral = anim.HasTag("Oral")
	bool solo = anim.HasTag("Masturbation")
	; Vaginal tag but no vaginas present, gay male pairing?
	if vaginal && females == 0 && !solo
		vaginal = false
		anal = true
	endIf
	; Update type counts
	if anal
		iAnalCount = iAnalCount + 1
	endIf
	if vaginal
		iVaginalCount = iVaginalCount + 1
	endIf
	if oral
		iOralCount = iOralCount + 1
	endIf
	if solo
		iMasturbationCount = iMasturbationCount + 1
		AdjustPlayerPurity(-1.0)
		return ; masturbation does it's own pervert/purity, don't continue
	endIf
	; Update perversion
	bool dirty = anim.HasTag("Dirty")
	bool loving = anim.HasTag("Loving")
	if dirty
		AdjustPlayerPurity(-2.5 * partners)
	endIf
	if loving
		AdjustPlayerPurity(2.5 * partners)
	elseIf !loving && !dirty
		AdjustPlayerPurity(Utility.RandomFloat(-1.0, 1.0) * partners)
	endIf
	; Victim/Aggressor
	if victim != none
		if victim == Lib.PlayerRef
			; Victim
			iVictimCount = iVictimCount + 1
			AdjustPlayerPurity(-1.2 * partners)
		else 
			; Aggressor
			iAggressorCount = iAggressorCount + 1
			AdjustPlayerPurity(-2.5 * partners)
		endIf
	endIf
endFunction

float function AdjustPlayerPurity(float amount)
	float current = (fSexualPurity + amount)
	fSexualPurity = current
	return current
endFunction

int function GetPlayerPurityLevel()
	float level = (fSexualPurity * 1)
	if level < 0
		; Flip float signing for impure, but return to signed for level number
		level = (Math.Sqrt((((fSexualPurity * -1.0) + 1.0) / 2.0) * 0.2) * -1.0) 
	else
		level = Math.Sqrt(((fSexualPurity + 1.0) / 2.0) * 0.2)
	endIf
	return level as int ; Return as int to floor value for level number
endFunction

string function GetPlayerPurityTitle()
	int level = GetPlayerPurityLevel()
	string[] titles
	if level < 0
		level = level * -1
		titles = sImpureTitles
	else
		titles = sPureTitles
	endIf
	; Clamp levels to titles array
	string title
	if level > 6
		return titles[6]
	elseif level < 0
		return titles[0]
	else
		return titles[level]
	endIf
endFunction

string function GetPlayerSexuality()
	int males = iMalePartners
	int females = iFemalePartners
	int partners = 1 + (males + females)
	int gender = Lib.GetGender(Lib.PlayerRef)
	float ratio
	if gender > 0
		ratio = ((males + 1.0) / partners as float) * 100.0
	else
		ratio = ((females + 1.0) / partners as float) * 100.0
	endIf
	if ratio <= 35 && gender > 0
		return "$SSL_Lesbian"
	elseIf ratio <= 35 && gender < 1
		return "$SSL_Gay"
	elseIf ratio > 35 && ratio < 65
		return "$SSL_Bisexual"
	else
		return "$SSL_Heterosexual"
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
	float level = Math.Sqrt(((val + 1.0) / 2.0) * 0.65)
	return level as int ; Return as int to floor value for level number
endFunction

string function GetPlayerStatTitle(string type)
	int level = GetPlayerStatLevel(type)
	; Clamp levels to titles array
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
endFunction