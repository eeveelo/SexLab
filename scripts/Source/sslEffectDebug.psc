Scriptname sslEffectDebug extends ActiveMagicEffect

SexLabFramework property SexLab Auto

event OnEffectStart(actor target, actor caster)
	sslBaseAnimation[] anims = SexLab.GetAnimationsByTags(2, "Arrok,Oral","",true)
	debug.traceandbox(anims)
endEvent
