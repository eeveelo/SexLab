scriptname sslControlLibrary extends sslSystemLibrary

; Data

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
int property kToggleFreeCamera auto hidden ; NUM 3

bool property bAutoTFC auto hidden
float property fAutoSUCSM auto hidden

; Local
string toggled
bool hkReady
sslThreadController PlayerController

; Dynamic properties
bool property InFreeCamera hidden
	bool function get()
		return Game.GetCameraState() == 3
	endFunction
endProperty

; Functions
bool function TempToggleFreeCamera(bool condition, string toggledBy)
	if condition && toggled == "" && InFreeCamera
		MiscUtil.ToggleFreeCamera()
		toggled = toggledBy
		return true
	elseIf condition && toggled == toggledBy && !InFreeCamera
		MiscUtil.ToggleFreeCamera()
		toggled = ""
		return false
	endIf
	return false
endFunction

function EnableFreeCamera(bool enabling = true)
	SexLabUtil.EnableFreeCamera(enabling, fAutoSUCSM)
endFunction

;/-----------------------------------------------\;
;|	System Use Only                              |;
;\-----------------------------------------------/;

function _HKStart(sslThreadController Controller)
	if Controller != none
		; Register hotkeys
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
		RegisterForKey(kToggleFreeCamera)
		; Ready
		PlayerController = Controller
		hkReady = true
	endIf
endFunction

function _HKClear()
	; Clear hotkeys
	UnregisterForAllKeys()
	PlayerController = none
	hkReady = true
	; Keep TFC key enabled
	RegisterForKey(kToggleFreeCamera)
endFunction

event OnKeyDown(int keyCode)
	; Check for open menus
	bool OpenMenu = Utility.IsInMenuMode() || UI.IsMenuOpen("Console") || UI.IsMenuOpen("Loading Menu")
	; TFC toggle is always available
	if keyCode == kToggleFreeCamera && hkReady && !OpenMenu
		SexLabUtil.EnableFreeCamera(!InFreeCamera, fAutoSUCSM)
	; Player animation restricted hotkeys
	elseIf PlayerController != none && hkReady && !OpenMenu && PlayerController.GetState() == "Animating"
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
	kToggleFreeCamera = 81 ; NUM 3
	; MCM TFC settings
	bAutoTFC = false
	fAutoSUCSM = 5.0
	; Config other
	toggled = ""
	hkReady = true
	_HKClear()
endFunction
function _Export()
	_ExportInt("kBackwards", kBackwards)
	_ExportInt("kAdjustStage", kAdjustStage)
	_ExportInt("kAdvanceAnimation", kAdvanceAnimation)
	_ExportInt("kChangeAnimation", kChangeAnimation)
	_ExportInt("kChangePositions", kChangePositions)
	_ExportInt("kAdjustChange", kAdjustChange)
	_ExportInt("kAdjustForward", kAdjustForward)
	_ExportInt("kAdjustSideways", kAdjustSideways)
	_ExportInt("kAdjustUpward", kAdjustUpward)
	_ExportInt("kRealignActors", kRealignActors)
	_ExportInt("kMoveScene", kMoveScene)
	_ExportInt("kRestoreOffsets", kRestoreOffsets)
	_ExportInt("kRotateScene", kRotateScene)
	_ExportInt("kToggleFreeCamera", kToggleFreeCamera)
	_ExportBool("bAutoTFC", bAutoTFC)
	_ExportFloat("fAutoSUCSM", fAutoSUCSM)
endFunction
function _Import()
	_Defaults()
	kBackwards = _ImportInt("kBackwards", kBackwards)
	kAdjustStage = _ImportInt("kAdjustStage", kAdjustStage)
	kAdvanceAnimation = _ImportInt("kAdvanceAnimation", kAdvanceAnimation)
	kChangeAnimation = _ImportInt("kChangeAnimation", kChangeAnimation)
	kChangePositions = _ImportInt("kChangePositions", kChangePositions)
	kAdjustChange = _ImportInt("kAdjustChange", kAdjustChange)
	kAdjustForward = _ImportInt("kAdjustForward", kAdjustForward)
	kAdjustSideways = _ImportInt("kAdjustSideways", kAdjustSideways)
	kAdjustUpward = _ImportInt("kAdjustUpward", kAdjustUpward)
	kRealignActors = _ImportInt("kRealignActors", kRealignActors)
	kMoveScene = _ImportInt("kMoveScene", kMoveScene)
	kRestoreOffsets = _ImportInt("kRestoreOffsets", kRestoreOffsets)
	kRotateScene = _ImportInt("kRotateScene", kRotateScene)
	kToggleFreeCamera = _ImportInt("kToggleFreeCamera", kToggleFreeCamera)
	bAutoTFC = _ImportBool("bAutoTFC", bAutoTFC)
	fAutoSUCSM = _ImportFloat("fAutoSUCSM", fAutoSUCSM)
endFunction
