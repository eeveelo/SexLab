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
	Utility.Wait(4.0)
	actor PlayerRef = SexLab.PlayerRef


	Debug.TraceAndBox("HasNode: "+NetImmerse.HasNode(PlayerRef, "NPC Rotate [Rot ]", true))
	Utility.Wait(4.0)

	float[] rot = new float[9]
	rot[0] = SexLabUtil.GetNodeRotation(PlayerRef, "NPC Rotate [Rot ]", true, 0)
	rot[1] = SexLabUtil.GetNodeRotation(PlayerRef, "NPC Rotate [Rot ]", true, 1)
	rot[2] = SexLabUtil.GetNodeRotation(PlayerRef, "NPC Rotate [Rot ]", true, 2)
	rot[3] = SexLabUtil.GetNodeRotation(PlayerRef, "NPC Rotate [Rot ]", true, 3)
	rot[4] = SexLabUtil.GetNodeRotation(PlayerRef, "NPC Rotate [Rot ]", true, 4)
	rot[5] = SexLabUtil.GetNodeRotation(PlayerRef, "NPC Rotate [Rot ]", true, 5)
	rot[6] = SexLabUtil.GetNodeRotation(PlayerRef, "NPC Rotate [Rot ]", true, 6)
	rot[7] = SexLabUtil.GetNodeRotation(PlayerRef, "NPC Rotate [Rot ]", true, 7)
	rot[8] = SexLabUtil.GetNodeRotation(PlayerRef, "NPC Rotate [Rot ]", true, 8)
	Debug.TraceAndBox("Before: "+rot)
	Utility.Wait(1.0)

	SexLabUtil.SetNodeRotation(PlayerRef, "NPC Rotate [Rot ]", true, 0, 1.0)
	SexLabUtil.SetNodeRotation(PlayerRef, "NPC Rotate [Rot ]", true, 1, 0.0)
	SexLabUtil.SetNodeRotation(PlayerRef, "NPC Rotate [Rot ]", true, 2, 0.0)
	SexLabUtil.SetNodeRotation(PlayerRef, "NPC Rotate [Rot ]", true, 3, 0.0)
	SexLabUtil.SetNodeRotation(PlayerRef, "NPC Rotate [Rot ]", true, 4, -1.0)
	SexLabUtil.SetNodeRotation(PlayerRef, "NPC Rotate [Rot ]", true, 5, 0.0)
	SexLabUtil.SetNodeRotation(PlayerRef, "NPC Rotate [Rot ]", true, 6, 0.0)
	SexLabUtil.SetNodeRotation(PlayerRef, "NPC Rotate [Rot ]", true, 7, 0.0)
	SexLabUtil.SetNodeRotation(PlayerRef, "NPC Rotate [Rot ]", true, 8, -1.0)
	SexLabUtil.UpdateNode(PlayerRef, "NPC Rotate [Rot ]", true)
	Utility.Wait(1.0)

	rot[0] = SexLabUtil.GetNodeRotation(PlayerRef, "NPC Rotate [Rot ]", true, 0)
	rot[1] = SexLabUtil.GetNodeRotation(PlayerRef, "NPC Rotate [Rot ]", true, 1)
	rot[2] = SexLabUtil.GetNodeRotation(PlayerRef, "NPC Rotate [Rot ]", true, 2)
	rot[3] = SexLabUtil.GetNodeRotation(PlayerRef, "NPC Rotate [Rot ]", true, 3)
	rot[4] = SexLabUtil.GetNodeRotation(PlayerRef, "NPC Rotate [Rot ]", true, 4)
	rot[5] = SexLabUtil.GetNodeRotation(PlayerRef, "NPC Rotate [Rot ]", true, 5)
	rot[6] = SexLabUtil.GetNodeRotation(PlayerRef, "NPC Rotate [Rot ]", true, 6)
	rot[7] = SexLabUtil.GetNodeRotation(PlayerRef, "NPC Rotate [Rot ]", true, 7)
	rot[8] = SexLabUtil.GetNodeRotation(PlayerRef, "NPC Rotate [Rot ]", true, 8)
	Debug.TraceAndBox("After: "+rot)

	; float[] loc = loc(PlayerRef)
	; Utility.Wait(5.0)
	; SexLabUtil.SetNodePosition(PlayerRef, "NPC LookNode [Look]", true, Utility.RandomFloat(200, 400), Utility.RandomFloat(200, 400), Utility.RandomFloat(200, 400))
	; SexLabUtil.UpdateNode(PlayerRef, "NPC LookNode [Look]", true)
	; loc = loc(PlayerRef)
	; Utility.Wait(5.0)
	; SexLabUtil.SetNodePosition(PlayerRef, "NPC LookNode [Look]", true, loc[0]+Utility.RandomFloat(200, 400), loc[0]+Utility.RandomFloat(200, 400), loc[0]+Utility.RandomFloat(200, 400))
	; SexLabUtil.UpdateNode(PlayerRef, "NPC LookNode [Look]", true)
	; loc = loc(PlayerRef)
	; Utility.Wait(5.0)
	; SexLabUtil.SetNodePosition(PlayerRef, "NPC LookNode [Look]", true, 0, 0, 0)
	; SexLabUtil.UpdateNode(PlayerRef, "NPC LookNode [Look]", true)

endEvent

float[] function loc(actor target)
	float[] loc = new float[3]
	loc[0] = NetImmerse.GetNodePositionX(target, "NPC LookNode [Look]", true)
	loc[1] = NetImmerse.GetNodePositionY(target, "NPC LookNode [Look]", true)
	loc[2] = NetImmerse.GetNodePositionZ(target, "NPC LookNode [Look]", true)
	debug.traceandbox(loc)
	return loc
endFunction


function GetStrings(actor target)
	Debug.TraceAndBox(target+": "+SexLabUtil.GetStringValue(target, "target-key"))
	Debug.TraceAndBox(SexLab.PlayerRef+": "+SexLabUtil.GetStringValue(SexLab.PlayerRef, "player-key"))
	Debug.TraceAndBox(SexLab.PlayerRef+": "+SexLabUtil.GetIntValue(SexLab.PlayerRef, "other key"))
endFunction
