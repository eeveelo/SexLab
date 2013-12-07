scriptname sslControlCamera extends ReferenceAlias

; Scripts
sslControlLibrary property Lib auto
sslActorSlots property ActorSlots auto

Actor property PlayerRef auto
ReferenceAlias property CloneAlias auto
Armor property CameraHead auto
Furniture property CameraMarker auto
ImageSpaceModifier property FadeToBlackHold auto


sslActorAlias PlayerAlias
Race PlayerRace
Actor CloneRef
bool TFC
float NifScale
float Scale
float[] distance
ObjectReference MarkerRef

event OnTranslationAlmostComplete()
endEvent

state FirstPerson
	event OnTranslationAlmostComplete()
		; PlayerRef.SplineTranslateToRefNode(CloneRef, "NPCEyeBone", 1, 300, 0)

		; debug.trace("translation complete"+PlayerRef+" - "+MarkerRef+" - "+CloneRef)
		; MarkerRef.MoveToNode(CloneRef, "NPCEyeBone")
		; PlayerRef.Activate(MarkerRef)
		; PlayerRef.SetVehicle(MarkerRef)
		; PlayerRef.SetVehicle(CloneRef)
		; PlayerRef.SetScale(0.0001)
		; Utility.Wait(0.5)
		PlayerRef.SplineTranslateToRefNode(CloneRef, "NPCEyeBone", 1, 300, 0)
	endEvent
	event OnBeginState()
		Debug.ToggleCollisions()
		Debug.Notification("Entering First Person")
		; FadeToBlackHold.ApplyCrossFade(0.5)

		; Get existing clone or make new one
		if CloneAlias.GetReference() != none
			actor tmp = CloneAlias.GetReference() as Actor
			CloneAlias.Clear()
			tmp.Disable()
			tmp.Delete()
		endIf
		CloneRef = PlayerRef.PlaceAtMe(PlayerRef.GetLeveledActorBase(), 1) as Actor
		Utility.Wait(0.5)
		CloneRef.Enable()
		CloneRef.MoveTo(PlayerRef)
		CloneAlias.ForceRefTo(CloneRef)
		CloneAlias.TryToEnable()
		while !CloneRef.Is3DLoaded()
			Utility.Wait(0.5)
		endWhile

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
		PlayerAlias = Lib.ThreadLib.Slots.GetPlayerController().ActorAlias(PlayerRef)
		; debug.traceandbox(PlayerAlias)
		PlayerAlias.SetCloned(CloneRef)

		NetImmerse.SetNodeScale(CloneRef, "NPC Head [Head]", 0.5, false)
		CloneRef.QueueNiNodeUpdate()
		CloneRef.SetVehicle(PlayerRef)

		; Shrink player down
		NifScale = NetImmerse.GetNodeScale(PlayerRef, "NPC", true)
		NetImmerse.SetNodeScale(PlayerRef, "NPC", 0.05, true)
		; NetImmerse.SetNodeScale(PlayerRef, "NPC Head [Head]", 0.01, true)
		; NetImmerse.SetNodeScale(PlayerRef, "NPC LookNode [Look]", 0.01, true)
		; Lib.PlayerRef.SetScale(0.01)
		PlayerRef.QueueNiNodeUpdate()


		; MarkerRef = PlayerRef.PlaceAtMe(Game.GetForm(0x0B9C04), 1)
		Utility.Wait(0.5)
		; MarkerRef.SetScale(0.0001)
		; MarkerRef.MoveToNode(CloneRef, "NPCEyeBone")
		; PlayerRef.Activate(MarkerRef)
		; PlayerRef.SetVehicle(MarkerRef)
		; PlayerRef.SetVehicle(CloneRef)

		distance = new float[2]
		distance[0] = Utility.GetINIFloat("fNearDistance:Display")
		distance[1] = Utility.GetINIFloat("fNear1stPersonDistance:Display")
		Utility.SetINIFloat("fNearDistance:Display", 0.1)
		Utility.SetINIFloat("fNear1stPersonDistance:Display", 0.0)

		; Force into first person camera and hide body
		Game.DisablePlayerControls(false, false, true, false, false, false, true, false, 0)
		Game.ShowFirstPersonGeometry(false)
		Game.ForceFirstPerson()
		PlayerRef.SetGhost(true)

		; Poistion and loop
		PlayerRef.SplineTranslateToRefNode(CloneRef, "NPCEyeBone", 1, 50000, 0)
		RegisterForSingleUpdate(2.5)
		; Return to view
		; ImageSpaceModifier.RemoveCrossFade()
	endEvent

	event OnUpdate()
		; Renforce translation loop every so often
		PlayerRef.SplineTranslateToRefNode(CloneRef, "NPCEyeBone", 1, 1000, 0)
		RegisterForSingleUpdate(2.5)
	endEvent

	event OnEndState()
		UnregisterForUpdate()
		FadeToBlackHold.ApplyCrossFade(0.5)

		PlayerRef.StopTranslation()
		PlayerRef.SetVehicle(none)
		PlayerRef.SetGhost(false)
		Game.EnablePlayerControls(false, false, true, false, false, false, true, false, 0)

		; Reset player scale
		NetImmerse.SetNodeScale(PlayerRef, "NPC", NifScale, true)
		; NetImmerse.SetNodeScale(PlayerRef, "NPC Head [Head]", 1.0, true)
		; NetImmerse.SetNodeScale(PlayerRef, "NPC LookNode [Look]", 1.0, true)
		PlayerRef.QueueNiNodeUpdate()
		Game.ShowFirstPersonGeometry(true)
		PlayerAlias.RemoveClone()

		CloneAlias.Clear()
		CloneRef.Disable()
		CloneRef.Delete()
		CloneRef = none

		Utility.SetINIFloat("fNearDistance:Display", distance[0])
		Utility.SetINIFloat("fNear1stPersonDistance:Display", distance[1])
		ImageSpaceModifier.RemoveCrossFade()
		Debug.ToggleCollisions()
		Game.ForceThirdPerson()
	endEvent
endState

bool function ToggleFirstPerson()
	if GetState() == "FirstPerson"
		GoToState("")
	else
		GoToState("FirstPerson")
	endIf
	return GetState() == "FirstPerson"
endFunction

state FreeCamera
	event OnBeginState()
		SexLabUtil.EnableFreeCamera(true)
		SexLabUtil.SetFreeCameraSpeed(Lib.fAutoSUCSM)
	endEvent
	event OnEndState()
		SexLabUtil.EnableFreeCamera(false)
	endEvent
endState
