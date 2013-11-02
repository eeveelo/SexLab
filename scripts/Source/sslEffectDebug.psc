Scriptname sslEffectDebug extends ActiveMagicEffect

SexLabFramework property SexLab Auto
import SexLabUtil

event OnEffectStart(actor target, actor caster)


	sslBaseExpression Expression = SexLab.ExpressionLib.PickExpression(target, caster)
	debug.traceandbox(Expression.Name)

	; Debug.Notification("Phase 1")
	; Expression.ApplyTo(target, 20)
	; Expression.ApplyTo(caster, 20)
	; Utility.Wait(10.0)
	; Debug.Notification("Phase 2")
	; Expression.ApplyTo(target, 66)
	; Expression.ApplyTo(caster, 66)
	; Utility.Wait(10.0)
	; Debug.Notification("Phase 3")
	; Expression.ApplyTo(target, 100)
	; Expression.ApplyTo(caster, 100)
	; Utility.Wait(10.0)
	; Debug.MessageBox("Cleared")
	; Expression.ClearMFG(target)
	; Expression.ClearMFG(caster)
	; sslBaseVoice tvoice = SexLab.PickVoice(target)
	; sslBaseVoice cvoice = SexLab.PickVoice(caster)

	; Utility.Wait(4.0)
	; debug.trace("1: no expression, mild")
	; debug.notification("1: no expression, mild")
	; tvoice.PlayMild(target)
	; cvoice.PlayMild(caster)
	; Utility.Wait(2.0)
	; tvoice.PlayMild(target)
	; cvoice.PlayMild(caster)
	; Utility.Wait(2.0)
	; tvoice.PlayMild(target)
	; cvoice.PlayMild(caster)
	; Utility.Wait(2.0)
	; tvoice.PlayMild(target)
	; cvoice.PlayMild(caster)

	; debug.notification("1: end")

	; Utility.Wait(4.0)
	; debug.trace("2: no expression, medium")
	; debug.notification("2: no expression, medium")
	; tvoice.PlayMedium(target)
	; cvoice.PlayMedium(caster)
	; Utility.Wait(2.0)
	; tvoice.PlayMedium(target)
	; cvoice.PlayMedium(caster)
	; Utility.Wait(2.0)
	; tvoice.PlayMedium(target)
	; cvoice.PlayMedium(caster)
	; Utility.Wait(2.0)
	; tvoice.PlayMedium(target)
	; cvoice.PlayMedium(caster)
	; debug.notification("2: end")


	; Utility.Wait(4.0)
	; debug.trace("3: no expression, Hot")
	; debug.notification("3: no expression, Hot")
	; tvoice.PlayHot(target)
	; cvoice.PlayHot(caster)
	; Utility.Wait(2.0)
	; tvoice.PlayHot(target)
	; cvoice.PlayHot(caster)
	; Utility.Wait(2.0)
	; tvoice.PlayHot(target)
	; cvoice.PlayHot(caster)
	; Utility.Wait(2.0)
	; tvoice.PlayHot(target)
	; cvoice.PlayHot(caster)
	; debug.notification("3: end")


	; Utility.Wait(4.0)
	; debug.trace("1: WITH expression, mild")
	; debug.notification("1: WITH expression, mild")
	; Expression.ApplyTo(target, 20)
	; Expression.ApplyTo(caster, 20)
	; tvoice.PlayMild(target)
	; cvoice.PlayMild(caster)
	; Utility.Wait(2.0)
	; tvoice.PlayMild(target)
	; cvoice.PlayMild(caster)
	; Utility.Wait(2.0)
	; tvoice.PlayMild(target)
	; cvoice.PlayMild(caster)
	; Utility.Wait(2.0)
	; tvoice.PlayMild(target)
	; cvoice.PlayMild(caster)
	; debug.notification("1: end")
	; Utility.Wait(4.0)
	; debug.trace("2: WITH expression, medium")
	; debug.notification("2: WITH expression, medium")
	; Expression.ApplyTo(target, 60)
	; Expression.ApplyTo(caster, 60)
	; tvoice.PlayMedium(target)
	; cvoice.PlayMedium(caster)
	; Utility.Wait(2.0)
	; tvoice.PlayMedium(target)
	; cvoice.PlayMedium(caster)
	; Utility.Wait(2.0)
	; tvoice.PlayMedium(target)
	; cvoice.PlayMedium(caster)
	; Utility.Wait(2.0)
	; tvoice.PlayMedium(target)
	; cvoice.PlayMedium(caster)
	; debug.notification("2: end")
	; Utility.Wait(4.0)
	; debug.trace("3: WITH expression, Hot")
	; debug.notification("3: WITH expression, Hot")
	; Expression.ApplyTo(target, 100)
	; Expression.ApplyTo(caster, 100)
	; tvoice.PlayHot(target)
	; cvoice.PlayHot(caster)
	; Utility.Wait(2.0)
	; tvoice.PlayHot(target)
	; cvoice.PlayHot(caster)
	; Utility.Wait(2.0)
	; tvoice.PlayHot(target)
	; cvoice.PlayHot(caster)
	; Utility.Wait(2.0)
	; tvoice.PlayHot(target)
	; cvoice.PlayHot(caster)
	; debug.notification("3: end")

	; SexLab.ExpressionLib.ClearMFG(target)
	; SexLab.ExpressionLib.ClearMFG(caster)

	; debug.traceandbox("Finish")
	; int count = 1

	; actor[] Positions = SexLab.DebugActor

	; if Positions.Find(target) == -1
	; 	Positions = sslUtility.PushActor(target, Positions)
	; 	SexLab.DebugActor = Positions
	; 	Debug.Notification(Positions.Length)
	; endIf

	; if Positions.Length != count
	; 	return
	; endIf

	; Debug.Notification("SexLab debug scene starting")
	; Utility.Wait(3.0)

	; sslThreadModel Model = SexLab.NewThread()

	; Model.AddActor(caster)

	; int i
	; while i < count
	; 	Model.AddActor(Positions[i])
	; 	i += 1
	; endWhile

	; sslThreadController Controller = Model.StartThread()

	; actor[] aDel
	; SexLab.DebugActor = aDel
endEvent
