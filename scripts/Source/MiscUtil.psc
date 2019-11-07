scriptname MiscUtil Hidden

;/
	Cell scanning functions
/;

; Scans the current cell of the given CenterOn for an object of the given form type ID within radius and returns an array for all that
; and (optionally) also has the given keyword if changed from default none. Setting radius higher than 0.0 will restrict the 
; search distance from around CenterOn, 0.0 will search entire cell the object is in.
; NOTE: Keyword searches seem a little unpredictable so be sure to test if your usage of it works before using the results.
ObjectReference[] function ScanCellObjects(int formType, ObjectReference CenterOn, float radius = 0.0, Keyword HasKeyword = none) global native


; Scans the current cell of the given CenterOn for an actor within the given radius and returns an array for all actors that are
; currently alive and (optionally) has the given keyword if changed from default none. Setting radius higher than 0.0 will restrict the 
; search distance from around CenterOn, 0.0 will search entire cell the object is in.
; NOTE: Keyword searches seem a little unpredictable so be sure to test if your usage of it works before using the results.
Actor[] function ScanCellNPCs(ObjectReference CenterOn, float radius = 0.0, Keyword HasKeyword = none, bool IgnoreDead = true) global native


; Same as ScanCellNPCs(), however it filters the return by a given faction and (optionally) their rank in that faction.
Actor[] function ScanCellNPCsByFaction(Faction FindFaction, ObjectReference CenterOn, float radius = 0.0, int minRank = 0, int maxRank = 127, bool IgnoreDead = true) global native


;/
	Camera functions - NOT CURRENT WORKING IN SKYRIM SPECIAL EDITION
/;

; Toggle freefly camera.
function ToggleFreeCamera(bool stopTime = false) global native
; Set freefly cam speed.
function SetFreeCameraSpeed(float speed) global native

; Set current freefly cam state & set the speed if enabling
function SetFreeCameraState(bool enable, float speed = 10.0) global native

;/
	File related functions
/;

; Get an array of files in a given parent directory that have the given extension.
; directory is relative to the root Skyrim folder (where skyrim.exe is) and is non-recursive.
; directory = "." to get all files in root Skyrim folder
; directory = "data/meshes" to get all files in the <root>/data/meshes folder
; extension = ".nif" to get all .nif mesh files.
; (default) extension="*" to get all files
string[] function FilesInFolder(string directory, string extension="*") global native

; Get an array of folders in a given parent directory
; Same rules and examples as above FilesInFolder apply to the directory rule here.
string[] function FoldersInFolder(string directory) global native

; Check if a given file exists relative to root Skyrim directory. Example: FileExists("data/meshes/example.nif")
bool function FileExists(string fileName) global native


; Read string from file. Do not read large files!
string function ReadFromFile(string fileName) global native

; Write string to file.
bool function WriteToFile(string fileName, string text, bool append = true, bool timestamp = false) global native


;/
	Misc
/;

; Print text to console.
function PrintConsole(string text) global native

; Get race's editor ID.
string function GetRaceEditorID(Race raceForm) global native

; Get race's editor ID.
string function GetActorRaceEditorID(Actor actorRef) global native

; Set HUD on / off - NOT CURRENT WORKING IN SKYRIM SPECIAL EDITION
function SetMenus(bool enabled) global native



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

; LEGACY v3.3 - Added Ignoredead parameter to function, aliased for backwards compatability with v3.2.
Actor[] function ScanCellActors(ObjectReference CenterOn, float radius = 5000.0, Keyword HasKeyword = none) global
	return ScanCellNPCs(CenterOn, radius, HasKeyword, true)
endFunction


