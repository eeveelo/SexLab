scriptname SexLabUtil hidden

function SetFreeCameraSpeed(float speed) global native
function ToggleFreeCamera(bool stopTime = false) global native

function EnableFreeCamera(bool enabling = true) global
	bool InFreeCamera = Game.GetCameraState() == 3
	if (enabling && !InFreeCamera) || (!enabling && InFreeCamera)
		ToggleFreeCamera()
	endIf
endFunction

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
	if !SexLabIsActive()
		return none
	endIf
	return (Game.GetFormFromFile(0x0D62, "SexLab.esm") as Quest) as SexLabFramework
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
endFunction





;/
	Animation functions
/;

; Set node position.
function SetNodePosition(ObjectReference obj, string nodeName, bool firstPerson, float newX, float newY, float newZ) global native

; Update node with new position or rotation.
function UpdateNode(ObjectReference obj, string nodeName, bool firstPerson) global native

; Get node rotation
float function GetNodeRotation(ObjectReference obj, string nodeName, bool firstPerson, int rotationIndex) global native

; Set node rotation
function SetNodeRotation(ObjectReference obj, string nodeName, bool firstPerson, int rotationIndex, float newValue) global native


;/
	Storage functions
/;

; Save int value on an object reference. If object is none then loading will work when passed none as well. These values can be accessed from any mod.
function SetIntValue(ObjectReference obj, string key, int value) global native

; Save float value on an object reference. If object is none then loading will work when passed none as well. These values can be accessed from any mod.
function SetFloatValue(ObjectReference obj, string key, float value) global native

; Save string value on an object reference. If object is none then loading will work when passed none as well. These values can be accessed from any mod.
function SetStringValue(ObjectReference obj, string key, string value) global native

; Load previously saved int value on an object reference. These values can be accessed from any mod. If missing value then 0 will be returned.
int function GetIntValue(ObjectReference obj, string key) global native

; Load previously saved float value on an object reference. These values can be accessed from any mod. If missing value then 0 will be returned.
float function GetFloatValue(ObjectReference obj, string key) global native

; Load previously saved string value on an object reference. These values can be accessed from any mod. If missing value then empty string will be returned.
string function GetStringValue(ObjectReference obj, string key) global native

; Add a value to an int list.
function IntListAdd(ObjectReference obj, string key, int value, bool allowDuplicate = true) global native

; Remove first instance of value from an int list.
function IntListRemove(ObjectReference obj, string key, int value, bool allInstances = false) global native

; Clear an int list.
function IntListClear(ObjectReference obj, string key) global native

; Remove a value from an int list by index.
function IntListRemoveAt(ObjectReference obj, string key, int index) global native

; Count how many values are in an int list.
int function IntListCount(ObjectReference obj, string key) global native

; Get a value in an int list by index.
int function IntListGet(ObjectReference obj, string key, int index) global native

; Set a value in an int list by index.
function IntListSet(ObjectReference obj, string key, int index, int value) global native

; Check if an int list has a specific value.
bool function IntListHas(ObjectReference obj, string key, int value) global native

; Add a value to a float list.
function FloatListAdd(ObjectReference obj, string key, float value, bool allowDuplicate = true) global native

; Remove first instance of value from a float list.
function FloatListRemove(ObjectReference obj, string key, float value, bool allInstances = false) global native

; Clear a float list.
function FloatListClear(ObjectReference obj, string key) global native

; Remove a value from a float list by index.
function FloatListRemoveAt(ObjectReference obj, string key, int index) global native

; Count how many values are in a float list.
int function FloatListCount(ObjectReference obj, string key) global native

; Get a value in a float list by index.
float function FloatListGet(ObjectReference obj, string key, int index) global native

; Set a value in a float list by index.
function FloatListSet(ObjectReference obj, string key, int index, float value) global native

; Check if a float list has a specific value.
bool function FloatListHas(ObjectReference obj, string key, float value) global native

; Add a value to a string list. Not case sensitive if allowDuplicate is set to false.
function StringListAdd(ObjectReference obj, string key, string value, bool allowDuplicate = true) global native

; Remove first instance of value from a string list. Not case sensitive.
function StringListRemove(ObjectReference obj, string key, string value, bool allInstances = false) global native

; Clear a string list.
function StringListClear(ObjectReference obj, string key) global native

; Remove a value from a string list by index.
function StringListRemoveAt(ObjectReference obj, string key, int index) global native

; Count how many values are in a string list.
int function StringListCount(ObjectReference obj, string key) global native

; Get a value in a string list by index.
string function StringListGet(ObjectReference obj, string key, int index) global native

; Set a value in a string list by index.
function StringListSet(ObjectReference obj, string key, int index, string value) global native

; Check if a string list has a specific value. Not case sensitive.
bool function StringListHas(ObjectReference obj, string key, string value) global native


;/
	Misc
/;

; Print text to console.
function PrintConsole(string text) global native
