Scriptname sslEffectDebug extends ActiveMagicEffect  

SexLabFramework property SexLab Auto

event OnEffectStart(actor target, actor caster)




	ObjectReference Stager = caster.PlaceAtMe(SexLab.Data.SexLabStager)
	utility.wait(2.0)
	Stager.SetScale((caster.GetScale() / Stager.GetScale()))
	utility.wait(2.0)
	Stager.MoveTo(caster)
	utility.wait(2.0)

	float[] center = new float[6]
	center[0] = Stager.GetPositionX()
	center[1] = Stager.GetPositionY()
	center[2] = Stager.GetPositionZ()
	center[3] = Stager.GetAngleX()
	center[4] = Stager.GetAngleY()
	center[5] = Stager.GetAngleZ()

	Stager.Disable()
	Stager.Delete()

	float[] loc = new float[6]
	loc[0] = ( center[0] + ( Math.sin(center[5]) * -105) )
	loc[1] = ( center[1] + ( Math.cos(center[5]) * -105) )
	loc[2] = ( center[2] + 0 )
	loc[3] = center[3]
	loc[4] = center[4]
	loc[5] = ( center[5] + 0 )

	target.SetPosition(loc[0], loc[1], loc[2])
	target.SetAngle(loc[3], loc[4], loc[5])

	Debug.SendAnimationEvent(caster, "Arrok_Missionary_A1_S2")
	Debug.SendAnimationEvent(target, "Arrok_Missionary_A2_S2")

	; sslBaseVoice voice = SexLab.GetVoiceByTag("Female", "Loud")
	; sslThreadModel make = SexLab.NewThread()
	; make.AddActor(SexLab.PlayerRef)
	; make.AddActor(target, false, none, true)
	; make.SetVoice(SexLab.PlayerRef, voice)
	; ;make.SetForcedAnimations(SexLab.GetAnimationsByTag(2, "Foreplay"))
	; ;make.AllowLeadIn(true)
	; sslThreadController Thread = make.StartThread()
	;debug.traceandbox("Aggressive: "+Thread.IsAggressive)
	;debug.traceandbox("Lead: "+Thread.leadIn)
	; sslThreadModel make = SexLab.NewThread()
	; make.AddActor(target)
	; make.AddActor(SexLab.PlayerRef)
	; sslThreadController thread = make.StartThread()
	; Utility.Wait(4.0)
	; sslThreadModel make2 = SexLab.NewThread()
	; make2.AddActor(SexLab.PlayerRef)
	; sslThreadController thread2 = make2.StartThread()
	; Utility.Wait(4.0)
	; debug.messagebox("Thread["+thread.tid()+"]"+thread.GetActors())
	; debug.messagebox("Thread["+thread2.tid()+"]"+thread2.GetActors())


	; sslThreadModel make = SexLab.NewThread()
	; debug.messagebox(make.tid() + " in state "+make.GetState())
	; debug.messagebox(SexLab.Controller[1].tid()+ " in state "+SexLab.Controller[1].GetState())
	; utility.wait(5.0)
	; sslThreadModel make2 = SexLab.NewThread()
	; debug.messagebox(make.tid() + " in state "+make.GetState())
	; debug.messagebox(make2.tid() + " in state "+make2.GetState())
 	; actor position = target
	; debug.messagebox("effect "+position)
	; int a1 = make.AddActor(position)
	; int a2 = make.AddActor(SexLab.PlayerRef)
	; debug.trace("effect: actor["+a1+"] - actor["+a2+"]")
	; sslThreadController thread = make.StartThread()
	; debug.messagebox(thread+" "+thread.tid()+" "+thread.GetPlayer())
	; debug.messagebox(target.GetPositionZ() +" " + caster.GetPositionZ())

	; Voice Test
	; SexLab.voice[0].PlayMild(target)
	; utility.wait(4.0)
	; SexLab.voice[0].PlayMedium(target)
	; utility.wait(4.0)
	; SexLab.voice[0].PlayHot(target)
	; utility.wait(4.0)


	; Strip Test
	; bool[] strip = new bool[33]
	; ; strip[2] = true
	; ; strip[4] = true
	; strip[2] = true
	; form[] stripped = SexLab.StripSlots(target, strip)
	; utility.wait(5.0)
	; SexLab.UnstripActor(target, stripped)
	;Expression Test
	; debug.notification("7")
	; target.SetExpressionOverride(7,100)
	; utility.wait(4.0)
	; debug.notification("8")
	; target.SetExpressionOverride(8,100)
	; utility.wait(4.0)
	; debug.notification("9")
	; target.SetExpressionOverride(9,100)
	; utility.wait(4.0)
	; debug.notification("10")
	; target.SetExpressionOverride(10,100)
	; utility.wait(4.0)
	; debug.notification("11")
	; target.SetExpressionOverride(11,100)
	; utility.wait(4.0)
	; debug.notification("12")
	; target.SetExpressionOverride(12,100)
	; utility.wait(4.0)
	; debug.notification("13")
	; target.SetExpressionOverride(13,100)
	; utility.wait(4.0)
	; debug.notification("14")
	; target.SetExpressionOverride(14,100)
	; utility.wait(4.0)
	; Solo Test
	; actor[] activeActors
	; activeActors = sslUtility.PushActor(target,activeActors)
	; sslBaseAnimation[] anims = SexLab.GetAnimationsByType(actors=1)
	; ; sslBaseAnimation[] anims = SexLab.GetAnimationsByTag("Solo","F")
	; SexLab.StartSex(activeActors, anims)
	
	; Duo Test
	; actor[] activeActors = new actor[2]
	; if SexLab.DebugActor != none
	; 	activeActors[0] = target
	; 	activeActors[1] = SexLab.DebugActor
	; 	sslBaseAnimation[] anims
	; 	SexLab.StartSex(activeActors, anims, target)
	; 	SexLab.DebugActor = none
	; else
	; 	SexLab.DebugActor = target
	; endIf
	; activeActors[0] = SexLab.PlayerRef
	; activeActors[1] = target
	; sslBaseAnimation anim = SexLab.GetAnimationByName("Arrok Blowjob")
	; bool[] silence = anim.GetSilence(1)
	; debug.messagebox(silence)

	; SexLab.StartSex(activeActors, anims)

	; Threeway Test
	; actor[] activeActors = new actor[3]
	; if SexLab.DebugActor != none
	; 	activeActors[0] = target
	; 	activeActors[1] = SexLab.PlayerRef
	; 	activeActors[2] = SexLab.DebugActor
	; 	sslBaseAnimation[] anims = SexLab.GetAnimationsByType(actors=3)
	; 	SexLab.StartSex(activeActors, anims)
	; else
	; 	SexLab.DebugActor = target
	; endIf

	; Actor Change Test
	; actor[] activeActors = new actor[2]
	; if SexLab.DebugActor != none
	; 	activeActors[0] = SexLab.PlayerRef
	; 	activeActors[1] = target
	; 	sslBaseAnimation[] anims
	; 	SexLab.StartSex(activeActors, anims, hook="debug")
	; 	utility.Wait(4.0)
	; 	debug.trace("Swapping ACTOR NOW")
	; 	sslBaseThread thread = SexLab.GetPlayerThread()
	; 	;activeActors = sslUtility.PushActor(SexLab.DebugActor, activeActors)
	; 	actor[] newActors = new actor[1]
	; 	newActors[0] = SexLab.PlayerRef
	; 	thread.ChangeActors(newActors)
	; 	;thread.ForceAnimation(newAnim)
	; 	;debug.messagebox(thread.GetAnimationList())
	; else
	; 	SexLab.DebugActor = target
	; endIf

	;form[] equipment = SexLab.StripActor(target)
	;utility.wait(5.0)
	;SexLab.UnstripActor(target, equipment)
	;Dispel()
endEvent