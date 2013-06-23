Scriptname sslEffectDebug extends ActiveMagicEffect  

SexLabFramework property SexLab Auto
actor a2

event OnEffectStart(actor target, actor caster)

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
	actor[] activeActors = new actor[2]
	; if SexLab.DebugActor != none
	; 	activeActors[0] = target
	; 	activeActors[1] = SexLab.DebugActor
	; 	sslBaseAnimation[] anims
	; 	SexLab.StartSex(activeActors, anims, target)
	; 	SexLab.DebugActor = none
	; else
	; 	SexLab.DebugActor = target
	; endIf
	activeActors[0] = SexLab.PlayerRef
	activeActors[1] = target
	sslBaseAnimation[] anims
	SexLab.StartSex(activeActors, anims)

	; Threeway Test
	; actor[] activeActors = new actor[3]
	; if SexLab.DebugActor != none
	; 	activeActors[0] = target
	; 	activeActors[1] = SexLab.PlayerRef
	; 	activeActors[2] = SexLab.DebugActor
	; 	sslBaseAnimation[] anims = SexLab.GetAnimationsByType(actors=3,males=2,females=1)
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