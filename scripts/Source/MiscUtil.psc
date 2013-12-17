scriptname MiscUtil Hidden

;/
	Camera functions
/;

; Toggle freefly camera.
function ToggleFreeCamera(bool stopTime = false) global native

; Set freefly cam speed.
function SetFreeCameraSpeed(float speed) global native



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
