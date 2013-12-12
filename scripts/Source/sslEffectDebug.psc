Scriptname sslEffectDebug extends ActiveMagicEffect

SexLabFramework property SexLab Auto

event OnEffectStart(actor target, actor caster)
	SexLab.Stats.UpdateNativeStats(target, 1, 1, 0, SexLab.GetAnimationByName("Arrok Cowgirl"), caster, 52.0)
	SexLab.Stats.UpdateNativeStats(caster, 1, 1, 0, SexLab.GetAnimationByName("Arrok Cowgirl"), caster, 52.0)
	Debug.TraceAndBox(caster.GetLeveledActorBase().GetName()+" : "+SexLab.GetPurityTitle(caster)+"/"+SexLab.GetSkill(caster, "Vaginal"))
	Debug.TraceAndBox(target.GetLeveledActorBase().GetName()+" : "+SexLab.GetPurityTitle(target)+"/"+SexLab.GetSkill(target, "Vaginal"))
	Debug.TraceAndBox(target.GetLeveledActorBase().GetName()+" Sexuality["+SexLab.GetSexuality(target)+"]: "+SexLab.GetSexualityTitle(target)+"/"+SexLab.GetSkill(target, "Males")+"/"+SexLab.GetSkill(target, "Females"))
endEvent
