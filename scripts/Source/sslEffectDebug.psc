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
	SexLabUtil.ToggleFlyCam()
	Utility.Wait(10.0)
	SexLabUtil.ToggleFlyCam()
endEvent
