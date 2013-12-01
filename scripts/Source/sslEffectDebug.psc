Scriptname sslEffectDebug extends ActiveMagicEffect

SexLabFramework property SexLab Auto

event OnEffectStart(actor target, actor caster)
	Debug.TraceAndBox(target.GetLeveledActorBase().GetName()+" proficency: "+SexLab.Stats.GetActorProficencyLevel(target))
	Debug.TraceAndBox(target.GetLeveledActorBase().GetName()+" purity: "+SexLab.Stats.GetActorPurityStat(target))
	Debug.TraceAndBox(target.GetLeveledActorBase().GetName()+" purity level: "+SexLab.Stats.GetActorPurityLevel(target))
endEvent
