scriptname SexLabUtil hidden

; ------------------------------------------------------- ;
; --- SexLab Accessors                                --- ;
; ------------------------------------------------------- ;

int function GetVersion() global
	return 15300
endFunction

string function GetStringVer() global
	return StringUtil.Substring(((GetVersion() as float / 10000.0) as string), 0, 4)
endFunction

bool function SexLabIsActive() global
	return GetAPI() != none
endFunction

SexLabFramework function GetAPI() global
	return Game.GetFormFromFile(0xD62, "SexLab.esm") as SexLabFramework
endFunction

sslSystemConfig function GetConfig() global
	return Game.GetFormFromFile(0xD62, "SexLab.esm") as sslSystemConfig
endFunction

; ------------------------------------------------------- ;
; --- Animation Starters                              --- ;
; ------------------------------------------------------- ;

int function StartSex(actor[] sexActors, sslBaseAnimation[] anims, actor victim = none, ObjectReference centerOn = none, bool allowBed = true, string hook = "") global
	SexLabFramework SexLab = GetAPI()
	if SexLab == none
		return -1
	endIf
	return SexLab.StartSex(sexActors, anims, victim, centerOn, allowBed, hook)
endFunction

sslThreadModel function NewThread(float timeout = 30.0) global
	SexLabFramework SexLab = GetAPI()
	if SexLab == none
		return none
	endIf
	return SexLab.NewThread(timeout)
endFunction

sslThreadController function QuickStart(actor a1, actor a2 = none, actor a3 = none, actor a4 = none, actor a5 = none, actor victim = none, string hook = "", string animationTags = "") global
	SexLabFramework SexLab = GetAPI()
	if SexLab == none
		return none
	endIf
	return SexLab.QuickStart(a1, a2, a3, a4, a5, victim, hook, animationTags)
endFunction

; ------------------------------------------------------- ;
; --- Common Utilities                                --- ;
; ------------------------------------------------------- ;

int function GetGender(Actor ActorRef) global
	return (Game.GetFormFromFile(0xD62, "SexLab.esm") as sslActorLibrary).GetGender(ActorRef)
endFunction

bool function IsActorActive(Actor ActorRef) global
	return StorageUtil.FormListFind(none, "SexLabActors", ActorRef) != -1
endFunction

bool function HasCreature(Actor ActorRef) global
	return HasRace(ActorRef.GetLeveledActorBase().GetRace())
endFunction

bool function HasRace(Race RaceRef) global
	return StorageUtil.StringListFind(none, "SexLabCreatures", MiscUtil.GetRaceEditorID(RaceRef)) != -1
endFunction

string function MakeGenderTag(Actor[] Positions) global
	int[] Genders = GetAPI().ActorLib.GenderCount(Positions)
	return GetGenderTag(Genders[1], Genders[0], Genders[2])
endFunction

string function GetGenderTag(int Females = 0, int Males = 0, int Creatures = 0) global
	string Tag
	while Females
		Females -= 1
		Tag += "F"
	endWhile
	while Males
		Males -= 1
		Tag += "M"
	endWhile
	while Creatures
		Creatures -= 1
		Tag += "C"
	endWhile
	return Tag
endFunction

; ------------------------------------------------------- ;
; --- Developer Utilities                             --- ;
; ------------------------------------------------------- ;

function Wait(float seconds) global
	float timer = Utility.GetCurrentRealTime() + seconds
	while Utility.GetCurrentRealTime() < timer
		Utility.Wait(0.50)
	endWhile
endFunction

function Log(string msg, string source, string type = "NOTICE", string display = "trace", bool minimal = true) global
	if StringUtil.Find(display, "trace") != -1
		if minimal
			Debug.Trace("-- SexLab "+type+"-- "+source+": "+msg)
		else
			Debug.Trace("--- SexLab "+source+" --------------------------------")
			Debug.Trace(" "+type+":")
			Debug.Trace("   "+msg)
			Debug.Trace("-----------------------------------------------------------")
		endIf
	endIf
	if StringUtil.Find(display, "box") != -1
		Debug.MessageBox(type+" "+source+": "+msg)
	endIf
	if StringUtil.Find(display, "notif") != -1
		Debug.Notification(type+": "+msg)
	endIf
	if StringUtil.Find(display, "stack") != -1
		Debug.TraceStack("-- SexLab "+type+"-- "+source+": "+msg)
	endIf
	if StringUtil.Find(display, "console") != -1
		MiscUtil.PrintConsole(type+" SexLab "+source+": "+msg)
	endIf
endFunction

function DebugLog(string Log, string Type = "NOTICE", bool DebugMode = false) global
	Log = Type+": "+Log
	if DebugMode
		MiscUtil.PrintConsole(Log)
	endIf
	if Type == "FATAL" || Type == "ERROR" || Type == "DEPRECATED"
		Debug.TraceStack("-- SexLab -- "+Log)
	else
		Debug.Trace("-- SexLab -- "+Log)
	endIf
endFunction

float function Timer(float Timestamp, string Log) global
	DebugLog(Log, "["+(Utility.GetCurrentRealTime() - Timestamp)+"]", true)
	return Utility.GetCurrentRealTime()
endFunction

;#------------------------------#
;#  SKSE Bound functions        #
;#        by h38fh2mf           #
;#------------------------------#

function EnableFreeCamera(bool Enabling = true, float sucsm = 5.0) global
	bool InFreeCamera = Game.GetCameraState() == 3
	if Enabling && !InFreeCamera
		MiscUtil.SetFreeCameraSpeed(sucsm)
		MiscUtil.ToggleFreeCamera()
	elseIf !Enabling && InFreeCamera
		MiscUtil.ToggleFreeCamera()
	endIf
endFunction
