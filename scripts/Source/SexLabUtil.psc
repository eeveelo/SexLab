scriptname SexLabUtil hidden

; ------------------------------------------------------- ;
; --- SexLab Accessors                                --- ;
; ------------------------------------------------------- ;

int function GetVersion() global
	return 14800
endFunction

string function GetStringVer() global
	return StringUtil.Substring(((GetVersion() as float / 10000.0) as string), 0, 4)+" Beta 4"
endFunction

bool function SexLabIsActive() global
	return GetAPI() != none
endFunction

SexLabFramework function GetAPI() global
	Quest API = Game.GetFormFromFile(0xD62, "SexLab.esm") as Quest
	if API != none
		return (API as SexLabFramework)
	endIf
	return none
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

bool function IsActorActive(Actor ActorRef) global
	return StorageUtil.FormListFind(none, "SexLabActors", ActorRef) != -1
endFunction

string function SlotLabel(int id) global
	if id == 0
		return "$SSL_Head"
	elseIf id == 1
		return "$SSL_Hair"
	elseIf id == 2
		return "$SSL_Torso"
	elseIf id == 3
		return "$SSL_Hands"
	elseIf id == 4
		return "$SSL_Forearms"
	elseIf id == 5
		return "$SSL_Amulet"
	elseIf id == 6
		return "$SSL_Ring"
	elseIf id == 7
		return "$SSL_Feet"
	elseIf id == 8
		return "$SSL_Calves"
	elseIf id == 9
		return "$SSL_Shield"
	elseIf id == 10
		return "$SSL_Tail"
	elseIf id == 11
		return "$SSL_LongHair"
	elseIf id == 12
		return "$SSL_Circlet"
	elseIf id == 13
		return "$SSL_Ears"
	elseIf id == 14
		return "$SSL_FaceMouth"
	elseIf id == 15
		return "$SSL_Neck"
	elseIf id == 16
		return "$SSL_Chest"
	elseIf id == 17
		return "$SSL_Back"
	elseIf id == 18
		return "$SSL_MiscSlot48"
	elseIf id == 19
		return "$SSL_PelvisOutergarnments"
	elseIf id == 20
		return "" ; decapitated head [NordRace]
	elseIf id == 21
		return "" ; decapitate [NordRace]
	elseIf id == 22
		return "$SSL_PelvisUndergarnments"
	elseIf id == 23
		return "$SSL_LegsRightLeg"
	elseIf id == 24
		return "$SSL_LegsLeftLeg"
	elseIf id == 25
		return "$SSL_FaceJewelry"
	elseIf id == 26
		return "$SSL_ChestUndergarnments"
	elseIf id == 27
		return "$SSL_Shoulders"
	elseIf id == 28
		return "$SSL_ArmsLeftArmUndergarnments"
	elseIf id == 29
		return "$SSL_ArmsRightArmOutergarnments"
	elseIf id == 30
		return "$SSL_MiscSlot60"
	elseIf id == 31
		return "$SSL_MiscSlot61"
	elseIf id == 32
		return "$SSL_Weapons"
	endIf
	return ""
endFunction

string function PhonemeLabel(int id) global
	if id == 0
		return "0: Aah"
	elseIf id == 1
		return "1: BigAah"
	elseIf id == 2
		return "2: BMP"
	elseIf id == 3
		return "3: ChjSh"
	elseIf id == 4
		return "4: DST"
	elseIf id == 5
		return "5: Eee"
	elseIf id == 6
		return "6: Eh"
	elseIf id == 7
		return "7: FV"
	elseIf id == 8
		return "8: i"
	elseIf id == 9
		return "9: k"
	elseIf id == 10
		return "10: N"
	elseIf id == 11
		return "11: Oh"
	elseIf id == 12
		return "12: OohQ"
	elseIf id == 13
		return "13: R"
	elseIf id == 14
		return "14: Th"
	elseIf id == 15
		return "15: W"
	endIf
	return ""
endFunction

string function ModifierLabel(int id) global
	if id == 0
		return "0: BlinkL"
	elseIf id == 1
		return "1: BlinkR"
	elseIf id == 2
		return "2: BrowDownL"
	elseIf id == 3
		return "3: BrownDownR"
	elseIf id == 4
		return "4: BrowInL"
	elseIf id == 5
		return "5: BrowInR"
	elseIf id == 6
		return "6: BrowUpL"
	elseIf id == 7
		return "7: BrowUpR"
	elseIf id == 8
		return "8: LookDown"
	elseIf id == 9
		return "9: LookLeft"
	elseIf id == 10
		return "10: LookRight"
	elseIf id == 11
		return "11: LookUp"
	elseIf id == 12
		return "12: SquintL"
	elseIf id == 13
		return "13: SquintR"
	endIf
	return ""
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
	if Type == "FATAL" || Type == "ERROR"
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
