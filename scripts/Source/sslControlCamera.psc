scriptname sslControlCamera extends ReferenceAlias

; Scripts
sslControlLibrary property Lib auto
sslActorSlots property ActorSlots auto

ReferenceAlias property CloneAlias auto
Actor property PlayerRef auto
Race property CameraRace auto

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
		MarkerRef.MoveToNode(CloneRef, "NPCEyeBone")
		; Game.ForceThirdPerson()
		; PlayerRef.SetAngle(MarkerRef.GetAngleX(), MarkerRef.GetAngleY(), MarkerRef.GetAngleZ())
		; PlayerRef.SetVehicle(CloneRef)
		; Game.ForceFirstPerson()
		Debug.Trace("Marker: "+MarkerRef.GetAngleX()+", "+MarkerRef.GetAngleY()+", "+MarkerRef.GetAngleZ())
		Debug.Trace("Player: "+Playerref.GetAngleX()+", "+Playerref.GetAngleY()+", "+Playerref.GetAngleZ())
		; float Z = MarkerRef.GetAngleZ()
		; PlayerRef.SplineTranslateTo(MarkerRef.X + (Math.sin(Z) * -5.0), MarkerRef.Y + (Math.cos(Z) * -5.0), MarkerRef.Z + 1.0, 0, 0, 0, 1, 500, 0)
		PlayerRef.SplineTranslateToRefNode(CloneRef, "NPCEyeBone", 1, 300, 0)
	endEvent
	event OnBeginState()
		Debug.ToggleCollisions()
		Debug.Notification("Entering First Person")
		; Clear out existing clone
		if CloneAlias.GetReference() != none
			CloneRef = CloneAlias.GetReference() as Actor
			CloneAlias.Clear()
		endIf
		if Cloneref != none
			CloneRef.Disable()
			CloneRef.Delete()
			CloneRef = none
		endIf

		; Place clone
		CloneRef = PlayerRef.PlaceAtMe(PlayerRef.GetLeveledActorBase(), 1) as Actor
		CloneRef.MoveTo(PlayerRef)
		Utility.Wait(0.1)

		; Fill clone alias
		CloneAlias.ForceRefTo(CloneRef)

		; Give an empty voice type
		ActorBase CloneBase = CloneRef.GetLeveledActorBase()
		if CloneBase.GetSex() == 1
			CloneBase.SetVoiceType(SexLabVoiceF)
		else
			CloneBase.SetVoiceType(SexLabVoiceM)
		endIf

		PlayerRef.SetMotionType(PlayerRef.Motion_Keyframed)

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
		; CloneRef.QueueNiNodeUpdate()

		; CloneRef.SetVehicle(PlayerRef)
		PlayerAlias = ActorSlots.GetActorAlias(PlayerRef)
		if PlayerAlias != none
			PlayerAlias.SetCloned(CloneRef)
		endIf

		; PlayerRace = PlayerRef.GetRace()
		;PlayerRef.SetRace(CameraRace)
		; CloneRef.SetRace(PlayerRace)

		PlayerRef.SetVehicle(CloneRef)
		PlayerRef.SetGhost(true)

		NifScale = NetImmerse.GetNodeScale(PlayerRef, "NPC Root [Root]", true)
		debug.trace("Before: "+NifScale+"/"+PlayerRef.GetScale())
		NetImmerse.SetNodeScale(PlayerRef, "NPC Root [Root]", 0.01, true)
		debug.trace("After:"+NifScale+"/"+PlayerRef.GetScale())

		; Lib.PlayerRef.SetScale(0.01)
		PlayerRef.QueueNiNodeUpdate()
		Game.ForceFirstPerson()
		Game.DisablePlayerControls(false, false, true, false, false, false, true, false, 0)
		Game.ShowFirstPersonGeometry(false)
		PlayerRef.ForceAddRagdollToWorld()

		if MarkerRef == none && CloneRef != none
			MarkerRef = CloneRef.PlaceAtMe(Lib.BaseMarker)
		endIf
		; MarkerRef.MoveToNode(CloneRef, "NPCEyeBone")
		; float Z = MarkerRef.GetAngleZ()
		; PlayerRef.SplineTranslateTo(MarkerRef.X + (Math.sin(Z) * -5.0), MarkerRef.Y + (Math.cos(Z) * -5.0), MarkerRef.Z + 1.0, 0, 0, 0, 1, 50000, 0)
		PlayerRef.SplineTranslateToRefNode(CloneRef, "NPCEyeBone", 1, 50000, 0)
		Utility.Wait(0.1)
		RegisterForSingleUpdate(0.1)

	endEvent

	event OnUpdate()
		; if Math.Abs(PlayerRef.GetAngleZ() - CloneRef.GetAngleZ()) > 100
		; 	PlayerRef.SetAngle(CloneRef.GetAngleX(), CloneRef.GetAngleY(), CloneRef.GetAngleZ())
		; 	PlayerRef.SetVehicle(CloneRef)
		; 	PlayerRef.SetScale(0.15)
		; endIfw
		PlayerRef.SplineTranslateToRefNode(CloneRef, "NPCEyeBone", 1, 1000, 0)
		; MarkerRef.MoveToNode(CloneRef, "NPCEyeBone")
		; float Z = MarkerRef.GetAngleZ()
		; PlayerRef.SplineTranslateTo(MarkerRef.X + (Math.sin(Z) * -5.0), MarkerRef.Y + (Math.cos(Z) * -5.0), MarkerRef.Z + 1.0, 0, 0, 0, 1, 1000, 0)
		RegisterForSingleUpdate(1.0)
	endEvent

	event OnEndState()
		UnregisterForUpdate()
		Debug.ToggleCollisions()

		if PlayerAlias != none
			PlayerAlias.RemoveClone()
		endIf

		NetImmerse.SetNodeScale(PlayerRef, "NPC Root [Root]", NifScale, true)
		debug.trace("Finish:"+NifScale+"/"+PlayerRef.GetScale())

		PlayerRef.SetVehicle(none)
		PlayerRef.SetGhost(false)

		Game.EnablePlayerControls(false, false, true, false, false, false, true, false, 0)

		Game.ShowFirstPersonGeometry(true)
		Game.ForceThirdPerson()

		CloneRef.Disable()
		CloneRef.Delete()
		CloneRef = none
	endEvent
endState

state FreeCamera
	event OnBeginState()
		if Game.GetCameraState() != 3
			ToggleFreeCamera()
		endIf
	endEvent
	event OnEndState()
		if Game.GetCameraState() == 3
			ToggleFreeCamera()
		endIf
	endEvent
endState


bool function ToggleFreeCamera()
	TFC = true
	RegisterForMenu("Console")
	Input.Tapkey(Input.GetMappedKey("Console", 0))
	Utility.Wait(0.01)
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
