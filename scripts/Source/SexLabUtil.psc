scriptname SexLabUtil hidden

bool function SexLabIsActive() global
	bool active
	int i
	while i < Game.GetModCount() && !active
		active = Game.GetModName(i) == "SexLab.esm"
		i += 1
	endWhile
	return active
endFunction

SexLabFramework function GetAPI() global
	Quest API = Quest.GetQuest("SexLabQuestFramework")
	if API != none
		return (API as SexLabFramework)
	endIf
	return none
endFunction

int function StartSex(actor[] sexActors, sslBaseAnimation[] anims, actor victim = none, ObjectReference centerOn = none, bool allowBed = true, string hook = "") global
	SexLabFramework SexLab = GetAPI()
	if SexLab == none
		return -1
	endIf
	return SexLab.StartSex(sexActors, anims, victim, centerOn, allowBed, hook)
endFunction

sslThreadModel function NewThread(float timeout = 10.0) global
	SexLabFramework SexLab = GetAPI()
	if SexLab == none
		return none
	endIf
	return SexLab.NewThread(timeout)
endFunction

sslThreadController function QuickStart(actor a1, actor a2 = none, actor a3 = none, actor a4 = none, actor a5 = none, actor victim = none, string hook = "") global
	SexLabFramework SexLab = GetAPI()
	if SexLab == none
		return none
	endIf
	return SexLab.QuickStart(a1, a2, a3, a4, a5, victim, hook)
endFunction

function Wait(float seconds) global
	float timer = Utility.GetCurrentRealTime() + seconds
	while Utility.GetCurrentRealTime() < timer
		Utility.Wait(0.4)
	endWhile
endFunction

function Log(string msg, string source, string type = "NOTICE", string display = "trace", bool minimal = false) global
	int severity = 0
	if type == "ERROR" || type == "FATAL"
		severity = 2
	elseif type == "NOTICE" || type == "DEBUG"
		severity = 1
	endIf
	if StringUtil.Find(display, "trace") != -1
		if minimal
			Debug.Trace("-- SexLab "+type+"-- "+source+": "+msg, severity)
		else
			Debug.Trace("--- SexLab "+source+" --------------------------------", severity)
			Debug.Trace(" "+type+":", severity)
			Debug.Trace("   "+msg, severity)
			Debug.Trace("-----------------------------------------------------------", severity)
		endIf
	endIf
	if StringUtil.Find(display, "box") != -1
		Debug.MessageBox(type+" "+source+": "+msg)
	endIf
	if StringUtil.Find(display, "notif") != -1
		Debug.Notification(type+": "+msg)
	endIf
	if StringUtil.Find(display, "stack") != -1
		Debug.TraceStack("-- SexLab "+type+"-- "+source+": "+msg, severity)
	endIf
	if StringUtil.Find(display, "console") != -1
		MiscUtil.PrintConsole(type+" SexLab "+source+": "+msg)
	endIf
endFunction

;#------------------------------#
;#  SKSE Bound functions        #
;#        by h38fh2mf           #
;#------------------------------#

function EnableFreeCamera(bool enabling = true, float sucsm = 5.0) global
	bool InFreeCamera = Game.GetCameraState() == 3
	if enabling && !InFreeCamera
		MiscUtil.SetFreeCameraSpeed(sucsm)
		MiscUtil.ToggleFreeCamera()
	elseIf !enabling && InFreeCamera
		MiscUtil.ToggleFreeCamera()
	endIf
endFunction
