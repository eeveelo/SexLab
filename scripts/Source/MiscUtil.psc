scriptname MiscUtil Hidden

;/
	Camera functions
/;

; Toggle freefly camera.
function ToggleFreeCamera(bool stopTime = false) global native

; Set freefly cam speed.
function SetFreeCameraSpeed(float speed) global native

; Set current freefly cam state.
function SetFreeCameraState(bool enable, float speed = 10.0) global native


;/
	Animation functions
/;

; Get node rotation
float function GetNodeRotation(ObjectReference obj, string nodeName, bool firstPerson, int rotationIndex) global native



;/
	Misc
/;

; Print text to console.
function PrintConsole(string text) global native

; Set HUD on / off
function SetMenus(bool enabled) global native

; Bat console command.
function ExecuteBat(string fileName) global native

; Read string from file. Do not read large files!
string function ReadFromFile(string fileName) global native

; Write string to file.
bool function WriteToFile(string fileName, string text, bool append = true, bool timestamp = false) global native

; Get race's editor ID.
string function GetRaceEditorID(Race raceForm) global native

; Get race's editor ID.
string function GetActorRaceEditorID(Actor actorRef) global native
