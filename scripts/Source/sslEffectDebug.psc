Scriptname sslEffectDebug extends ActiveMagicEffect

SexLabFramework property SexLab Auto

event OnEffectStart(actor target, actor caster)
	; Debug.TraceAndBox(target.GetLeveledActorBase().GetName()+" proficency: "+SexLab.Stats.GetActorProficencyLevel(target))
	; Debug.TraceAndBox(target.GetLeveledActorBase().GetName()+" purity: "+SexLab.Stats.GetActorPurityStat(target))
	; Debug.TraceAndBox(target.GetLeveledActorBase().GetName()+" purity level: "+SexLab.Stats.GetActorPurityLevel(target))

	; Sound orgasmfx = Game.GetFormFromFile(0x0DAB82, "Skyrim.esm") as Sound
	; debug.traceandbox(orgasmfx)
	; utility.wait(3.0)
	; Sound.SetInstanceVolume(orgasmfx.play(target), 1.0)
	; Utility.Wait(4.0)
	actor PlayerRef = SexLab.PlayerRef

	target.RemoveAllItems()
	SexLab.ApplyCum(target, 2)
	SexLAb.ApplyCum(caster, 2)
	; ObjectReference Marker = PlayerRef.PlaceAtMe(SexLab.ActorLib.BaseMarker, 1)
	; Marker.MoveToNode(caster, "NPCEyeBone")

	; float[] rot = new float[9]
	; rot[0] = SexLabUtil.GetNodeRotation(PlayerRef, "NPC Head [Head]", false, 0)
	; rot[1] = SexLabUtil.GetNodeRotation(PlayerRef, "NPC Head [Head]", false, 1)
	; rot[2] = SexLabUtil.GetNodeRotation(PlayerRef, "NPC Head [Head]", false, 2)
	; rot[3] = SexLabUtil.GetNodeRotation(PlayerRef, "NPC Head [Head]", false, 3)
	; rot[4] = SexLabUtil.GetNodeRotation(PlayerRef, "NPC Head [Head]", false, 4)
	; rot[5] = SexLabUtil.GetNodeRotation(PlayerRef, "NPC Head [Head]", false, 5)
	; rot[6] = SexLabUtil.GetNodeRotation(PlayerRef, "NPC Head [Head]", false, 6)
	; rot[7] = SexLabUtil.GetNodeRotation(PlayerRef, "NPC Head [Head]", false, 7)
	; rot[8] = SexLabUtil.GetNodeRotation(PlayerRef, "NPC Head [Head]", false, 8)

	; float[] xyz = new float[3]
	; xyz[0] = Marker.GetAngleX()
	; xyz[1] = Marker.GetAngleY()
	; xyz[2] = Marker.GetAngleZ()

	; Debug.TraceAndBox(xyz)
	; Debug.TraceAndBox(rot)

	; SexLabUtil.SetCameraNode(caster, "NPCEyeBone", "NPC Head [Head]")
	; Utility.Wait(10.0)
	; SexLabUtil.SetCameraNode(none, "", "")

	; Marker.Disable()
	; Marker.Delete()
endEvent

float[] function loc(actor target)
	float[] loc = new float[3]
	loc[0] = NetImmerse.GetNodePositionX(target, "NPC Head [Head]", false)
	loc[1] = NetImmerse.GetNodePositionY(target, "NPC Head [Head]", false)
	loc[2] = NetImmerse.GetNodePositionZ(target, "NPC Head [Head]", false)
	debug.traceandbox(loc)
	return loc
endFunction


function GetStrings(actor target)
	Debug.TraceAndBox(target+": "+SexLabUtil.GetStringValue(target, "target-key"))
	Debug.TraceAndBox(SexLab.PlayerRef+": "+SexLabUtil.GetStringValue(SexLab.PlayerRef, "player-key"))
	Debug.TraceAndBox(SexLab.PlayerRef+": "+SexLabUtil.GetIntValue(SexLab.PlayerRef, "other key"))
endFunction
