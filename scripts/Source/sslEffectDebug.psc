Scriptname sslEffectDebug extends ActiveMagicEffect

SexLabFramework property SexLab Auto

event OnEffectStart(actor target, actor caster)

	sslBaseAnimation Anim = SexLab.GetAnimationByName("Test Override")
	Debug.TraceAndBox(Anim+" / "+Anim.Name+" : "+Anim.FetchStage(0))
endEvent
