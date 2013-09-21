Scriptname sslEffectDebug extends ActiveMagicEffect  

SexLabFramework property SexLab Auto




event OnEffectStart(actor target, actor caster)


	sslThreadModel Model = SexLab.NewThread()

	Model.AddActor(caster)
	Model.AddActor(target)

	sslThreadController Controller = Model.StartThread()

	; string args = "test1, test2,test3,test4,test5"
	; string[] argArray = sslUtility.ArgString(args)

	; debug.traceandbox("args: "+argArray)

	; string[] tags = new string[2]
	; tags[0] = "Vaginal"
	; tags[1] = "Dirty"

	; string[] suppress = new string[1]
	; suppress[0] = "Aggressive"

	; sslBaseAnimation[] anims = SexLab.AnimSlots.GetByTags(2, tags, "Aggressive")

	; debug.traceandbox("1 Found: "+anims.Length)

	; anims = SexLab.AnimSlots.GetByTags(2, tags)

	; debug.traceandbox("2 Found: "+anims.Length)

	; anims = SexLab.AnimSlots.GetByTag(2, "Vaginal", tagSuppress = "Aggressive")

	; debug.traceandbox("3 Found: "+anims.Length)

	; anims = SexLab.AnimSlots.GetByTag(2, "Vaginal")

	; debug.traceandbox("4 Found: "+anims.Length)

	; anims = SexLab.AnimSlots.GetByType(2, 0, 2)

	; debug.traceandbox("5 Found: "+anims.Length)


	;caster.SetVehicle(Marker)
	;Marker.Activate(caster)

	; Debug.SendAnimationEvent(caster, "Arrok_Blowjob_A1_S2")

	; Utility.Wait(5.0)


	; float angle = target.GetAngleZ()

	; float[] loc = new float[5]
	; loc[0] = target.GetPositionX() + ( Math.sin(angle) * Utility.RandomFloat(25, 100))
	; loc[1] = target.GetPositionY() + ( Math.cos(angle) * Utility.RandomFloat(25, 100))
	; loc[2] = target.GetPositionZ()
	; loc[3] = target.GetAngleX()
	; loc[4] = target.GetAngleY()

	; Marker.SetPosition(loc[0], loc[1], loc[2])
	; Marker.SetAngle(loc[3], loc[4], angle)
	; caster.MoveTo(Marker)

	; Utility.Wait(5.0)

	; ObjectReference Found = Game.FindRandomReferenceOfTypeFromRef(SexLab.ActorLib.StageMarker, caster, 2000)
	; Debug.TraceAndBox(Marker + "Found: "+Found)

	; Marker.Disable()
	; Marker.Delete()
	; Marker = none

	; Debug.TraceAndBox(Marker)
	; Utility.Wait(4.0)
	; Found = Game.FindRandomReferenceOfTypeFromRef(SexLab.ActorLib.StageMarker, caster, 2000)
	; Debug.TraceAndBox("Found: "+Found)
	; Utility.Wait(4.0)



endEvent