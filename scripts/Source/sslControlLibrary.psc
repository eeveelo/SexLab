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
int property kToggle1stCamera auto hidden ; NUM 1
int property kToggleFreeCamera auto hidden ; NUM 1

; Local
bool hkReady
sslThreadController PlayerController

; Dynamic properties
bool property InFirstPerson hidden
	bool function get()
		return ControlCamera.GetState() == "FirstPerson"
	endFunction
endProperty

bool property InFreeCamera hidden
	bool function get()
		return Game.GetCameraState() == 3
	endFunction
endProperty

; Functions
function ResetCamera()
	SexLabUtil.EnableFreeCamera(false)
	ControlCamera.GoToState("")
endFunction

function EnableFirstPerson(bool enabling = true)
	if enabling && !InFirstPerson
		ControlCamera.GoToState("FirstPerson")
	elseIf !enabling && InFirstPerson
		ControlCamera.GoToState("")
	endIf
endFunction

function EnableFreeCamera(bool enabling = true)
	if enabling && !InFreeCamera
		ControlCamera.GoToState("FreeCamera")
	elseIf !enabling && InFreeCamera
		ControlCamera.GoToState("")
	endIf
endFunction

bool function ToggleFirstPerson()
	return ControlCamera.ToggleFirstPerson()
endFunction

bool function ToggleFreeCamera()
	SexLabUtil.ToggleFreeCamera()
	return InFreeCamera
endFunction

function _HKStart(sslThreadController Controller)
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
	RegisterForKey(kToggle1stCamera)
	RegisterForKey(kToggleFreeCamera)
	PlayerController = Controller
	hkReady = true
endFunction

function _HKClear()
	UnregisterForAllKeys()
	PlayerController = none
	hkReady = true
endFunction

event OnKeyDown(int keyCode)
	if PlayerController != none && hkReady && PlayerController.GetState() == "Animating" && !UI.IsMenuOpen("Console") && !UI.IsMenuOpen("Main Menu") && !UI.IsMenuOpen("Loading Menu") && !UI.IsMenuOpen("MessageBoxMenu")
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
		; Toggle First Person
		elseIf keyCode == kToggle1stCamera
			EnableFirstPerson(!InFirstPerson)
		; Toggle TFC
		elseIf keyCode == kToggleFreeCamera
			EnableFreeCamera(!InFreeCamera)
		endIf
		hkReady = true
	endIf
endEvent

function _Defaults()
	_HKClear()
	hkReady = true

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
	kToggle1stCamera = 79 ; NUM 1
	kToggleFreeCamera = 81 ; NUM 3
endFunction
