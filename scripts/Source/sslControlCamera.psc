scriptname sslControlCamera extends ReferenceAlias

; Scripts
sslControlLibrary property Lib auto
sslActorSlots property ActorSlots auto

ReferenceAlias property CloneAlias auto
Actor property PlayerRef auto
Race property CameraRace auto

ImageSpaceModifier property FadeToBlack auto
ImageSpaceModifier property FadeToBlackBack auto
ImageSpaceModifier property FadeToBlackHold auto

Armor property CameraHead auto
VoiceType property SexLabVoiceM auto
VoiceType property SexLabVoiceF auto

sslActorAlias PlayerAlias
Race PlayerRace
Actor CloneRef
bool TFC
float NifScale
float Scale
ObjectReference MarkerRef

event OnTranslationAlmostComplete()
endEvent

state FirstPerson
	event OnTranslationAlmostComplete()
		PlayerRef.SplineTranslateToRefNode(CloneRef, "NPCEyeBone", 1, 300, 0)
	endEvent
	event OnBeginState()
		Debug.ToggleCollisions()
		Debug.Notification("Entering First Person")
		FadeToBlackHold.ApplyCrossFade(0.5)

		; Get existing clone or make new one
		if CloneAlias.GetReference() != none
			actor tmp = CloneAlias.GetReference() as Actor
			CloneAlias.Clear()
			tmp.Disable()
			tmp.Delete()
		endIf
		CloneRef = PlayerRef.PlaceAtMe(PlayerRef.GetLeveledActorBase(), 1) as Actor
		Utility.Wait(0.1)
		CloneRef.MoveTo(PlayerRef)
		CloneAlias.ForceRefTo(CloneRef)

		; ; Give an empty voice type
		; ActorBase CloneBase = CloneRef.GetLeveledActorBase()
		; if CloneBase.GetSex() == 1
		; 	CloneBase.SetVoiceType(SexLabVoiceF)
		; else
		; 	CloneBase.SetVoiceType(SexLabVoiceM)
		; endIf

		; PlayerRef.SetMotionType(PlayerRef.Motion_Keyframed)

		; Make clone match player
		CloneRef.RemoveAllItems()
		int i
		while i < 32
			form item = PlayerRef.GetWornForm(Armor.GetMaskForSlot(i + 30))
			if item != none
				CloneRef.EquipItem(item, false, true)
			endIf
			i += 1
		endWhile
		CloneRef.EquipItem(CameraHead, true, true)

		CloneRef.SetHeadTracking(false)
		CloneRef.EvaluatePackage()
		NetImmerse.SetNodeScale(CloneRef, "NPCEyeBone", 0.5, false)
		NetImmerse.SetNodeScale(CloneRef, "NPC Head [Head]", 0.5, false)
		CloneRef.QueueNiNodeUpdate()

		; CloneRef.SetVehicle(PlayerRef)
		PlayerAlias = ActorSlots.GetActorAlias(PlayerRef)
		PlayerAlias.SetCloned(CloneRef)

		; Shrink player down
		NifScale = NetImmerse.GetNodeScale(PlayerRef, "NPC", true)
		NetImmerse.SetNodeScale(PlayerRef, "NPC", 0.05, true)
		NetImmerse.SetNodeScale(PlayerRef, "NPCEyeBone", 0.01, true)
		NetImmerse.SetNodeScale(PlayerRef, "Camera1st [Cam1]", 0.01, true)
		NetImmerse.SetNodeScale(PlayerRef, "NPC Head [Head]", 0.01, true)
		NetImmerse.SetNodeScale(PlayerRef, "Camera Control", 0.01, true)
		NetImmerse.SetNodeScale(PlayerRef, "NPC LookNode [Look]", 0.01, true)
		; Lib.PlayerRef.SetScale(0.01)
		PlayerRef.QueueNiNodeUpdate()
		PlayerRef.SetGhost(true)
		PlayerRef.SetVehicle(CloneRef)
		; Force into first person camera and hide body
		Game.ForceFirstPerson()
		Game.DisablePlayerControls(false, false, true, false, false, false, true, false, 0)
		Game.ShowFirstPersonGeometry(false)

		; Poistion and loop
		PlayerRef.SplineTranslateToRefNode(CloneRef, "NPCEyeBone", 1, 50000, 0)
		RegisterForSingleUpdate(2.5)

		; Return to view
		ImageSpaceModifier.RemoveCrossFade()
	endEvent

	event OnUpdate()
		; Renforce translation loop every so often
		PlayerRef.SplineTranslateToRefNode(CloneRef, "NPCEyeBone", 1, 1000, 0)
		RegisterForSingleUpdate(2.5)
	endEvent

	event OnEndState()
		UnregisterForUpdate()
		Debug.ToggleCollisions()
		FadeToBlackHold.ApplyCrossFade(0.5)

		PlayerRef.StopTranslation()
		PlayerRef.SetVehicle(none)
		PlayerRef.SetGhost(false)

		Game.EnablePlayerControls(false, false, true, false, false, false, true, false, 0)

		Game.ShowFirstPersonGeometry(true)
		Game.ForceThirdPerson()
		; Reset player scale
		NetImmerse.SetNodeScale(PlayerRef, "NPC", NifScale, true)
		NetImmerse.SetNodeScale(PlayerRef, "NPCEyeBone", 1.0, true)
		NetImmerse.SetNodeScale(PlayerRef, "Camera1st [Cam1]", 1.0, true)
		NetImmerse.SetNodeScale(PlayerRef, "NPC Head [Head]", 1.0, true)
		NetImmerse.SetNodeScale(PlayerRef, "Camera Control", 1.0, true)
		NetImmerse.SetNodeScale(PlayerRef, "NPC LookNode [Look]", 1.0, true)
		PlayerRef.QueueNiNodeUpdate()
		PlayerAlias.RemoveClone()


		CloneAlias.Clear()
		CloneRef.Disable()
		CloneRef.Delete()
		CloneRef = none

		ImageSpaceModifier.RemoveCrossFade()
	endEvent
endState

state FreeCamera
	event OnBeginState()
		if Game.GetCameraState() != 3
			Game.ForceThirdPerson()
			ToggleFreeCamera()
		endIf
	endEvent
	event OnEndState()
		if Game.GetCameraState() == 3
			ToggleFreeCamera()
			Game.ForceThirdPerson()
		endIf
	endEvent
endState

bool function ToggleFreeCamera()
	FadeToBlackHold.ApplyCrossFade(0.5)
	TFC = true
	RegisterForMenu("Console")
	Input.Tapkey(Input.GetMappedKey("Console", 0))
	Utility.Wait(0.01)
	ImageSpaceModifier.RemoveCrossFade()
	; Return current TFC state
	return Game.GetCameraState() == 3
endFunction

event OnMenuOpen(string menu)
	if menu == "Console" && TFC == true
		UnregisterForMenu("Console")
		TFC = false
		Input.TapKey(20) ; T
		Utility.WaitMenuMode(0.05)
		Input.TapKey(33) ; F
		Utility.WaitMenuMode(0.05)
		Input.TapKey(46) ; C
		Utility.WaitMenuMode(0.05)
		Input.TapKey(28) ; Enter
		Utility.WaitMenuMode(0.05)
		; Close console
		Input.TapKey(Input.GetMappedKey("Console", 0))
	endIf
endEvent
