Scriptname sslEffectDebug extends ActiveMagicEffect

SexLabFramework property SexLab Auto

event OnEffectStart(actor target, actor caster)
	SexLab.GetActorPurity(target)

	; Actor Obj = SexLab.PlayerRef.PlaceAtMe(SexLab.ThreadLib.SexLabStager, 1) as Actor

	; Debug.TraceAndBox(Obj + ": "+SexLab.GetSkillLevel(Obj, "Vaginal"))
	; Obj.Disable()
	; Obj.Delete()

	; Obj = none
endEvent
