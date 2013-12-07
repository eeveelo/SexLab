scriptname SexLabUtil hidden

function SetFreeCameraSpeed(float speed) global native
function ToggleFreeCamera(bool stopTime = false) global native

function EnableFreeCamera(bool enabling = true) global
	bool InFreeCamera = Game.GetCameraState() == 3
	if (enabling && !InFreeCamera) || (!enabling && InFreeCamera)
		ToggleFreeCamera()
	endIf
endFunction

function SetCameraNode(ObjectReference obj, string posNodeName, string rotNodeName = "", bool firstPerson = false) global native
bool function IsCameraNode() global native

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

; Get node rotation
float function GetNodeRotation(ObjectReference obj, string nodeName, bool firstPerson, int rotationIndex) global native





;/
	Storage functions - save game.
/;

; Save int value on an object reference. If object is none then loading will work when passed none as well. These values can be accessed from any mod.
function SetIntValue(ObjectReference obj, string key, int value) global native

; Save float value on an object reference. If object is none then loading will work when passed none as well. These values can be accessed from any mod.
function SetFloatValue(ObjectReference obj, string key, float value) global native

; Save string value on an object reference. If object is none then loading will work when passed none as well. These values can be accessed from any mod.
function SetStringValue(ObjectReference obj, string key, string value) global native

; Remove a int value by key.
function UnsetIntValue(ObjectReference obj, string key) global native

; Remove a float value by key.
function UnsetFloatValue(ObjectReference obj, string key) global native

; Remove a string value by key.
function UnsetStringValue(ObjectReference obj, string key) global native

; Check if a int value is set.
bool function HasIntValue(ObjectReference obj, string key) global native

; Check if a float value is set.
bool function HasFloatValue(ObjectReference obj, string key) global native

; Check if a string value is set.
bool function HasStringValue(ObjectReference obj, string key) global native

; Load previously saved int value on an object reference. These values can be accessed from any mod. If missing value then 0 will be returned.
int function GetIntValue(ObjectReference obj, string key, int missing = 0) global native

; Load previously saved float value on an object reference. These values can be accessed from any mod. If missing value then 0 will be returned.
float function GetFloatValue(ObjectReference obj, string key, float missing = 0.0) global native

; Load previously saved string value on an object reference. These values can be accessed from any mod. If missing value then empty string will be returned.
string function GetStringValue(ObjectReference obj, string key, string missing = "") global native

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

; Delete saved values on object.
function debug_DeleteValues(ObjectReference obj) global native

; Delete all saved values.
function debug_DeleteAllValues() global native


;/
	Storage functions - file. These are shared in all save games. Values are loaded and saved
	when savegame is loaded or saved.
/;

; Save int value.
function FileSetIntValue(ObjectReference obj, string key, int value) global native

; Save float value.
function FileSetFloatValue(ObjectReference obj, string key, float value) global native

; Save string value.
function FileSetStringValue(ObjectReference obj, string key, string value) global native

; Remove a int value by key.
function FileUnsetIntValue(ObjectReference obj, string key) global native

; Remove a float value by key.
function FileUnsetFloatValue(ObjectReference obj, string key) global native

; Remove a string value by key.
function FileUnsetStringValue(ObjectReference obj, string key) global native

; Check if a int value is set.
bool function FileHasIntValue(ObjectReference obj, string key) global native

; Check if a float value is set.
bool function FileHasFloatValue(ObjectReference obj, string key) global native

; Check if a string value is set.
bool function FileHasStringValue(ObjectReference obj, string key) global native

; Load previously saved int value.
int function FileGetIntValue(ObjectReference obj, string key, int missing = 0) global native

; Load previously saved float value.
float function FileGetFloatValue(ObjectReference obj, string key, float missing = 0.0) global native

; Load previously saved string value.
string function FileGetStringValue(ObjectReference obj, string key, string missing = "") global native

; Add a value to an int list.
function FileIntListAdd(ObjectReference obj, string key, int value, bool allowDuplicate = true) global native

; Remove first instance of value from an int list.
function FileIntListRemove(ObjectReference obj, string key, int value, bool allInstances = false) global native

; Clear an int list.
function FileIntListClear(ObjectReference obj, string key) global native

; Remove a value from an int list by index.
function FileIntListRemoveAt(ObjectReference obj, string key, int index) global native

; Count how many values are in an int list.
int function FileIntListCount(ObjectReference obj, string key) global native

; Get a value in an int list by index.
int function FileIntListGet(ObjectReference obj, string key, int index) global native

; Set a value in an int list by index.
function FileIntListSet(ObjectReference obj, string key, int index, int value) global native

; Check if an int list has a specific value.
bool function FileIntListHas(ObjectReference obj, string key, int value) global native

; Add a value to a float list.
function FileFloatListAdd(ObjectReference obj, string key, float value, bool allowDuplicate = true) global native

; Remove first instance of value from a float list.
function FileFloatListRemove(ObjectReference obj, string key, float value, bool allInstances = false) global native

; Clear a float list.
function FileFloatListClear(ObjectReference obj, string key) global native

; Remove a value from a float list by index.
function FileFloatListRemoveAt(ObjectReference obj, string key, int index) global native

; Count how many values are in a float list.
int function FileFloatListCount(ObjectReference obj, string key) global native

; Get a value in a float list by index.
float function FileFloatListGet(ObjectReference obj, string key, int index) global native

; Set a value in a float list by index.
function FileFloatListSet(ObjectReference obj, string key, int index, float value) global native

; Check if a float list has a specific value.
bool function FileFloatListHas(ObjectReference obj, string key, float value) global native

; Add a value to a string list. Not case sensitive if allowDuplicate is set to false.
function FileStringListAdd(ObjectReference obj, string key, string value, bool allowDuplicate = true) global native

; Remove first instance of value from a string list. Not case sensitive.
function FileStringListRemove(ObjectReference obj, string key, string value, bool allInstances = false) global native

; Clear a string list.
function FileStringListClear(ObjectReference obj, string key) global native

; Remove a value from a string list by index.
function FileStringListRemoveAt(ObjectReference obj, string key, int index) global native

; Count how many values are in a string list.
int function FileStringListCount(ObjectReference obj, string key) global native

; Get a value in a string list by index.
string function FileStringListGet(ObjectReference obj, string key, int index) global native

; Set a value in a string list by index.
function FileStringListSet(ObjectReference obj, string key, int index, string value) global native

; Check if a string list has a specific value. Not case sensitive.
bool function FileStringListHas(ObjectReference obj, string key, string value) global native

; Delete all saved values in file.
function debug_FileDeleteAllValues() global native

;/
Write text to a file. File path examples:
"C:/test/abc.txt" <- Absolute path
"abc.txt" <- Skyrim.exe folder
"Data/abc.txt" <- Skyrim/Data folder
This will open and close file in same function, avoid calling many times if you can.
/;
bool function WriteToFile(string filePath, string text, bool append = true, bool timestamp = false) global native

; Read full file as string.
string function ReadFromFile(string filePath) global native

; "bat" console command.
;function Bat(string name) global native


;/
	Misc
/;

; Print text to console.
function PrintConsole(string text) global native

; Get object reference by form id.
ObjectReference function GetReference(int formId) global native
