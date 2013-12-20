Scriptname sslEffectDebug extends ActiveMagicEffect

SexLabFramework property SexLab Auto

event OnEffectStart(actor target, actor caster)
	sslBaseAnimation Anim = SexLab.GetAnimationByName("Arrok Blowjob")
	Debug.TraceAndBox("[0] Before: "+Anim.GetPositionOffsets(1, 2))
	Utility.Wait(1.0)
	Anim.UpdateAllOffsets(2, 1, 50.0)
	Debug.TraceAndBox("[1] Before: "+Anim.GetPositionOffsets(1, 2))
	Utility.Wait(1.0)
	Anim.UpdateAllOffsets(2, 1, 50.0)
	Debug.TraceAndBox("[2] Adjusted: "+Anim.GetPositionOffsets(1, 2))
	Utility.Wait(1.0)
	Anim.RestoreOffsets()
	Debug.TraceAndBox("[3] Reset: "+Anim.GetPositionOffsets(1, 2))
	Utility.Wait(1.0)
	Anim.UpdateAllOffsets(2, 1, 75.0)
	Debug.TraceAndBox("[4] Re-Adjusted: "+Anim.GetPositionOffsets(1, 2))
	Utility.Wait(1.0)
	Anim.RestoreOffsets()
	Debug.TraceAndBox("[5] Reset: "+Anim.GetPositionOffsets(1, 2))
endEvent
