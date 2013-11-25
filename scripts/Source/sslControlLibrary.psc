scriptname sslControlLibrary extends Quest

; Scripts
sslActorLibrary property ActorLib auto
sslThreadLibrary property ThreadLib auto

; Data
Actor property PlayerRef auto
Furniture property BaseMarker auto
sslControlCamera property ControlCamera auto

; Settings
int property kBackwards auto hidden ; Right Shift
int property kAdjustStage auto hidden; Right Ctrl
int property kAdvanceAnimation auto hidden ; Space
int property kChangeAnimation auto hidden ; O
int property kChangePositions auto hidden ; =
int property kAdjustChange auto hidden ; K
int property kAdjustForward auto hidden ; L
int property kAdjustSideways auto hidden ; '
int property kAdjustUpward auto hidden ; ;
int property kRealignActors auto hidden ; [
int property kMoveScene auto hidden ; ]
int property kRestoreOffsets auto hidden ; -
int property kRotateScene auto hidden ; U
int property kToggleCamera auto hidden ; NUM 1

; Local
bool hkReady
sslThreadController PlayerController

function ToggleFirstPerson()
endFunction

function EnableFreeCamera(bool enableIt = true)
	if enableIt && !InFreeCamera()
		ControlCamera.GoToState("FreeCamera")
	elseIf !enableIt && InFreeCamera()
		ControlCamera.GoToState("")
	endIf
endFunction

bool function InFreeCamera()
	return Game.GetCameraState() == 3
endFunction

function _HKStart(sslThreadController Controller)
	; CameraControl = GetAliasByName("CameraControl") as sslHotkeyCamera

	RegisterForKey(kBackwards)
	RegisterForKey(kAdjustStage)
	RegisterForKey(kAdvanceAnimation)
	RegisterForKey(kChangeAnimation)
	RegisterForKey(kChangePositions)
	RegisterForKey(kAdjustChange)
	RegisterForKey(kAdjustForward)
	RegisterForKey(kAdjustSideways)
	RegisterForKey(kAdjustUpward)
	RegisterForKey(kRealignActors)
	RegisterForKey(kRestoreOffsets)
	RegisterForKey(kMoveScene)
	RegisterForKey(kRotateScene)
	RegisterForKey(kToggleCamera)
	PlayerController = Controller
	hkReady = true
endFunction

function _HKClear()
	UnregisterForAllKeys()
	PlayerController = none
	hkReady = true
	; DEBUG: Keep enabled
	RegisterForKey(kToggleCamera)
endFunction

event OnKeyDown(int keyCode)
	debug.trace("HotkeyLib: "+keyCode)
	if keyCode == kToggleCamera
		string current = ControlCamera.GetState()
		if current == ""
			ControlCamera.GoToState("FirstPerson")
		;elseIf current == "FirstPerson"
		;	ControlCamera.GoToState("FreeCamera")
		else
			ControlCamera.GoToState("")
		endIf
	endIf


	if PlayerController != none && hkReady && !UI.IsMenuOpen("Console") && !UI.IsMenuOpen("Main Menu") && !UI.IsMenuOpen("Loading Menu") && !UI.IsMenuOpen("MessageBoxMenu")
		hkReady = false
		Utility.Wait(0.001)

		bool backwards
		if kBackwards == 42 || kBackwards == 54
			; Check both shift keys
			backwards = ( Input.IsKeyPressed(42) || Input.IsKeyPressed(54) )
		else
			backwards = Input.IsKeyPressed(kBackwards)
		endIf

		bool adjustingstage
		if kAdjustStage == 157 || kAdjustStage == 29
			; Check both ctrl keys
			adjustingstage = ( Input.IsKeyPressed(157) || Input.IsKeyPressed(29) )
		else
			adjustingstage = Input.IsKeyPressed(kBackwards)
		endIf

		; Advance Stage
		if keyCode == kAdvanceAnimation
			PlayerController.AdvanceStage(backwards)
		; Change Animation
		elseIf keyCode == kChangeAnimation
			PlayerController.ChangeAnimation(backwards)
		; Change Positions
		elseIf keyCode == kChangePositions
			PlayerController.ChangePositions(backwards)
		; Forward / Backward adjustments
		elseIf keyCode == kAdjustForward
			PlayerController.AdjustForward(backwards, adjustingstage)
		; Left / Right adjustments
		elseIf keyCode == kAdjustSideways
			PlayerController.AdjustSideways(backwards, adjustingstage)
		; Up / Down adjustments
		elseIf keyCode == kAdjustUpward
			PlayerController.AdjustUpward(backwards, adjustingstage)
		; Change Adjusted Actor
		elseIf keyCode == kAdjustChange
			PlayerController.AdjustChange(backwards)
		; RePosition Actors
		elseIf keyCode == kRealignActors
			PlayerController.RealignActors()
		; Restore animation offsets
		elseIf keyCode == kRestoreOffsets
			PlayerController.RestoreOffsets()
		; Move Scene
		elseIf keyCode == kMoveScene
			PlayerController.MoveScene()
		; Rotate Scene
		elseIf keyCode == kRotateScene
			PlayerController.RotateScene(backwards)
		endIf
		hkReady = true
	endIf
endEvent

function _Defaults()
	; CameraControl = GetAliasByName("CameraControl") as sslHotkeyCamera
	; debug.traceandbox("CameraControl: "+CameraControl)
	; Config Hotkeys
	kBackwards = 54 ; Right Shift
	kAdjustStage = 157; Right Ctrl
	kAdvanceAnimation = 57 ; Space
	kChangeAnimation =  24 ; O
	kChangePositions = 13 ; =
	kAdjustChange = 37 ; K
	kAdjustForward = 38 ; L
	kAdjustSideways = 40 ; '
	kAdjustUpward = 39 ; ;
	kRealignActors = 26 ; [
	kMoveScene = 27 ; ]
	kRestoreOffsets = 12 ; -
	kRotateScene = 22 ; U
	kToggleCamera = 79 ; NUM 1
endFunction
