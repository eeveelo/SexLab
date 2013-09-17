Scriptname sslEffectDebug extends ActiveMagicEffect  

SexLabFramework property SexLab Auto

event OnEffectStart(actor target, actor caster)


	if SexLab.debugActor != none
		sslThreadModel Model = SexLab.NewThread()
		Model.AddActor(caster)
		Model.AddActor(target)
		Model.DisableLeadIn(true)

		sslThreadController Controller = Model.StartThread()

		Utility.Wait(10.0)
		Debug.TraceAndBox("Adding Actor Shortly")
		Utility.Wait(4.0)

		actor[] changeTo = new actor[2]
		changeTo[0] = SexLab.debugActor
		changeTo[1] = target

		Controller.ChangeActors(changeTo)
	else
		SexLab.debugActor = target
	endIf

endEvent