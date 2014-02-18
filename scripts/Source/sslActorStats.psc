scriptname sslActorStats extends sslSystemLibrary

; Titles
string[] StatTitles
string[] PureTitlesMale
string[] PureTitlesFemale
string[] ImpureTitlesMale
string[] ImpureTitlesFemale


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
	endIf
	if WithPlayer && ActorRef != PlayerRef
		AdjustInt(ActorRef, "PlayerSex", 1)
		StorageUtil.FormListAdd(PlayerRef, "SexPartners", ActorRef, false)
	endIf
endFunction

; ------------------------------------------------------- ;
; --- System Use                                      --- ;
; ------------------------------------------------------- ;


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
	if amount != 0
		StorageUtil.SetIntValue(ActorRef, "sslActorStats."+stat, (StorageUtil.GetIntValue(ActorRef, "sslActorStats."+stat) + amount))
	endIF
endFunction
function AdjustFloat(actor ActorRef, string stat, float amount)
	if amount != 0.0
		StorageUtil.SetFloatValue(ActorRef, "sslActorStats."+stat, (StorageUtil.GetFloatValue(ActorRef, "sslActorStats."+stat) + amount))
	endIf
endFunction

