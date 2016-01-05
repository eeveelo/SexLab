scriptname MiscUtil Hidden


; Get an array of files in a given parent directory that have the given extension.
; directory is relative to the root Skyrim folder (where skyrim.exe is) and is non-recursive.
; extension=".nif" to get all .nif mesh files.
; (default) extension="*" to get all files
string[] function FilesInFolder(string directory, string extension="*") global native

; Scans the current cell of the given CenterOn for an actor within the given radius and returns an array for all actors that are
; currently alive and (optionally) has the given keyword if changed from default none. Setting radius to 0.0 will return all in cell.
; NOTE: This function is fairly untested beyond simply checking if it works as expected. 
Actor[] function ScanCellActors(ObjectReference CenterOn, float radius = 5000.0, Keyword HasKeyword = none) global native

; Scans the current cell of the given CenterOn for an object of the given form type ID within radius and returns an array for all that
; and (optionally) also has the given keyword if changed from default none. Setting radius to 0.0 will return all matches in cell.
; NOTE: This function is fairly untested beyond simply checking if it works as expected. 
ObjectReference[] function ScanCellObjects(int formType, ObjectReference CenterOn, float radius = 5000.0, Keyword HasKeyword = none) global native



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

; Read string from file. Do not read large files!
string function ReadFromFile(string fileName) global native

; Write string to file.
bool function WriteToFile(string fileName, string text, bool append = true, bool timestamp = false) global native

; Get node rotation
; REMOVED v2.9: Useless, only does a part of the job.
; float function GetNodeRotation(ObjectReference obj, string nodeName, bool firstPerson, int rotationIndex) global native
float function GetNodeRotation(ObjectReference obj, string nodeName, bool firstPerson, int rotationIndex) global
	Debug.TraceStack("MiscUtil.GetNodeRotation("+obj+", "+nodeName+") - REMOVED FUNCTION")
	return 0.0
endFunction
; Bat console command.
; REMOVED v2.9: Unused.
; function ExecuteBat(string fileName) global native
function ExecuteBat(string fileName) global
	Debug.TraceStack("MiscUtil.ExecuteBat("+fileName+") - REMOVED FUNCTION")
endFunction
