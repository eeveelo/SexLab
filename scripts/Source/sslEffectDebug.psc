Scriptname sslEffectDebug extends ActiveMagicEffect

SexLabFramework property SexLab Auto

actor Camera
actor PlayerRef


function PositionCamera()
	float[] eyes = new float[6]
	eyes[0] = NetImmerse.GetNodePositionX(PlayerRef, "NPCEyeBone", false)
	eyes[1] = NetImmerse.GetNodePositionY(PlayerRef, "NPCEyeBone", false)
	eyes[2] = NetImmerse.GetNodePositionZ(PlayerRef, "NPCEyeBone", false)
	; Camera.MoveToNode(PlayerRef, "NPCEyeBone")
	; Camera.TranslateTo(eyes[0],eyes[1],eyes[2],Camera.GetAngleX(), Camera.GetAngleY(), Camera.GetAngleZ(), 10000, 0.01)
	Debug.SendAnimationEvent(Camera, "IdleForceDefaultState")
	Game.SetCameraTarget(Camera)
	Game.ForceThirdPerson()
	debug.setgodmode(true)
	Camera.MoveToNode(PlayerRef, "NPCEyeBone")
	Camera.SetVehicle(PlayerRef)
	Game.ForceFirstPerson()

	; Debug.SendAnimationEvent(Camera, "IdleForceDefaultState")
	; Game.SetCameraTarget(Camera)
	; Game.ForceThirdPerson()
	; debug.setgodmode(true)
	; Camera.SplineTranslateToRefNode(PlayerRef, "NPCEyeBone", 100, 10000, 0.0001)
	; Camera.SetVehicle(PlayerRef)
	; Game.ForceFirstPerson()


	; Game.SetCameraTarget(Camera)
	; Game.ForceThirdPerson()
	; Camera.SplineTranslateToRefNode(PlayerRef, "NPCEyeBone", 100, 10000, 0)
	; Game.ForceFirstPerson()
	; ; Camera.SetVehicle(PlayerRef)
	; Utility.Wait(0.1)
	; Game.SetCameraTarget(Camera)
	; Game.ForceThirdPerson()
	; Game.ForceFirstPerson()
endFunction

event OnUpdate()
	Debug.Trace("SSL: Positioning camera")
	PositionCamera()
endEvent

event OnEffectStart(actor target, actor caster)
	Utility.SetIniFloat("fOverShoulderPosZ:Camera", 0)
	Utility.SetIniFloat("fOverShoulderPosX:Camera", 0)
	Utility.SetIniFloat("fOverShoulderPosY:Camera", 0)
	Utility.SetIniFloat("fOverShoulderCombatPosZ:Camera", 0)
	Utility.SetIniFloat("fOverShoulderCombatPosX:Camera", 0)
	Utility.SetIniFloat("fOverShoulderCombatPosY:Camera", 0)
	Utility.SetIniFloat("fActorFadeOutLimit:Camera", 0)
	Game.UpdateThirdPerson()
	; ; debug.togglecollisions()
	; PlayerRef = caster
	; Camera = PlayerRef.PlaceAtMe(SexLab.ActorLib.CameraActor, 1) as actor
	; ; Game.SetPlayerAIDriven(true)
	; ; Game.ForceFirstPerson()
	; Game.DisablePlayerControls(false, true, false, false, false, false, false, false, 0)
	; Camera.SetPlayerControls(true)
	; PlayerRef.SetPlayerControls(false)
	; Camera.EnableAI(true)
	; Debug.SendAnimationEvent(Camera, "IdleForceDefaultState")
	; ; Camera.SetScale(0.15)
	; Camera.SetGhost(true)
	; Game.SetCameraTarget(Camera)

	; PositionCamera()

	; ; Game.SetCameraTarget(Camera)

	; ; Game.SetCameraTarget(none)
	; ; Camera.SetVehicle(PlayerRef)

	; ; Game.ForceThirdPerson()
	; ;debug.messagebox(Camera + " Controlled")
	; Utility.Wait(6.0)

	; PositionCamera()
	; Utility.Wait(5.0)
	; Debug.SendAnimationEvent(PlayerRef, "Missionary_A1_S3")
	; Utility.Wait(1.0)
	; PositionCamera()
	; Utility.Wait(10.0)

	; Game.SetCameraTarget(PlayerRef)
	; Game.SetPlayerAIDriven(false)
	; PlayerRef.SetPlayerControls(true)
	; Camera.SetPlayerControls(false)
	; Camera.SetScale(1.0)
	; Camera.SetVehicle(none)
	; ; Camera.Disable()
	; ; Camera.Delete()
	; ; Debug.ToggleCollisions()
	; Debug.MessageBox("End!")
endEvent
