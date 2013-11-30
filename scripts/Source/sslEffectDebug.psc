Scriptname sslEffectDebug extends ActiveMagicEffect

SexLabFramework property SexLab Auto

event OnEffectStart(actor target, actor caster)
	sslExpressionLibrary Lib = SexLab.ExpressionLib

	bool isFemale = target.getleveledactorbase().getsex() == 1
	int[] basepreset = Lib.GetBasePreset(isFemale)

	Utility.Wait(5.0)
	Debug.TraceAndBox(Lib.PresetMixin(Lib.GetBasePreset(isFemale), 2, isFemale, false))
	Lib.ApplyPreset(Lib.PresetMixin(Lib.GetBasePreset(isFemale), 2, isFemale, false), target, false)

	Utility.Wait(5.0)
	Debug.TraceAndBox(Lib.PresetMixin(Lib.GetBasePreset(isFemale), 15, isFemale, false))
	Lib.ApplyPreset(Lib.PresetMixin(Lib.GetBasePreset(isFemale), 15, isFemale, false), target, false)

	Utility.Wait(5.0)
	Debug.TraceAndBox(Lib.PresetMixin(Lib.GetBasePreset(isFemale), 23, isFemale, false))
	Lib.ApplyPreset(Lib.PresetMixin(Lib.GetBasePreset(isFemale), 23, isFemale, false), target, false)

	Utility.Wait(5.0)
	Debug.TraceAndBox(Lib.PresetMixin(Lib.GetBasePreset(isFemale), 50, isFemale, false))
	Lib.ApplyPreset(Lib.PresetMixin(Lib.GetBasePreset(isFemale), 50, isFemale, false), target, false)

	Utility.Wait(5.0)
	Debug.TraceAndBox(Lib.PresetMixin(Lib.GetBasePreset(isFemale), 80, isFemale, false))
	Lib.ApplyPreset(Lib.PresetMixin(Lib.GetBasePreset(isFemale), 80, isFemale, false), target, false)

	Utility.Wait(5.0)
	Debug.TraceAndBox(Lib.PresetMixin(Lib.GetBasePreset(isFemale), 91, isFemale, false))
	Lib.ApplyPreset(Lib.PresetMixin(Lib.GetBasePreset(isFemale), 91, isFemale, false), target, false)

	Utility.Wait(5.0)
	Debug.TraceAndBox(Lib.PresetMixin(Lib.GetBasePreset(isFemale), 100, isFemale, false))
	Lib.ApplyPreset(Lib.PresetMixin(Lib.GetBasePreset(isFemale), 100, isFemale, false), target, false)

	Utility.Wait(5.0)
	Lib.ClearMFG(target)
	debug.traceandbox("End")
endEvent
