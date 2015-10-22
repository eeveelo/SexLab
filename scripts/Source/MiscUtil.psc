scriptname MiscUtil Hidden

Actor[] function ScanCellActors(ObjectReference CenterOn, float radius = 5000.0, Keyword HasKeyword = none) global native
ObjectReference[] function ScanCellObjects(int formType, ObjectReference CenterOn, float radius = 5000.0, Keyword HasKeyword = none) global native


; Get an array of files in a given parent directory that have the given extension.
; directory is relative to the root Skyrim folder (where skyrim.exe is) and is non-recursive.
; extension=".nif" to get all .nif mesh files.
; (default) extension="*" to get all files
string[] function FilesInFolder(string directory, string extension="*") global native

;/
	Camera functions
/;

; Toggle freefly camera.
function ToggleFreeCamera(bool stopTime = false) global native

; Set freefly cam speed.
function SetFreeCameraSpeed(float speed) global native

; Set current freefly cam state & set the speed if enabling
function SetFreeCameraState(bool enable, float speed = 10.0) global native


;/
	Misc
/;

; Print text to console.
function PrintConsole(string text) global native

; Get race's editor ID.
string function GetRaceEditorID(Race raceForm) global native

; Get race's editor ID.
string function GetActorRaceEditorID(Actor actorRef) global native

; Set HUD on / off
function SetMenus(bool enabled) global native


; Get node rotation
; REMOVED v2.9: Useless, only does a part of the job.
; float function GetNodeRotation(ObjectReference obj, string nodeName, bool firstPerson, int rotationIndex) global native

; Bat console command.
; REMOVED v2.9: Unused.
; function ExecuteBat(string fileName) global native

; Read string from file. Do not read large files!
; REMOVED v2.9: Unused.
; string function ReadFromFile(string fileName) global native

; Write string to file.
; REMOVED v2.9: Unused.
; bool function WriteToFile(string fileName, string text, bool append = true, bool timestamp = false) global native


float function GetNodeRotation(ObjectReference obj, string nodeName, bool firstPerson, int rotationIndex) global
	Debug.TraceStack("MiscUtil.GetNodeRotation("+obj+", "+nodeName+") - REMOVED FUNCTION")
	return 0.0
endFunction
bool function WriteToFile(string fileName, string text, bool append = true, bool timestamp = false) global
	Debug.TraceStack("MiscUtil.WriteToFile("+fileName+") - REMOVED FUNCTION")
	return false
endFunction
string function ReadFromFile(string fileName) global
	Debug.TraceStack("MiscUtil.ReadFromFile("+fileName+") - REMOVED FUNCTION")
	return ""
endFunction
function ExecuteBat(string fileName) global
	Debug.TraceStack("MiscUtil.ExecuteBat("+fileName+") - REMOVED FUNCTION")
endFunction
