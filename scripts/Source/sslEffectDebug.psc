Scriptname sslEffectDebug extends ActiveMagicEffect

SexLabFramework property SexLab Auto
import SexLabUtil

event OnEffectStart(actor target, actor caster)
	int count = 1

	actor[] Positions = SexLab.DebugActor

	if Positions.Find(target) == -1
		Positions = sslUtility.PushActor(target, Positions)
		SexLab.DebugActor = Positions
		Debug.Notification(Positions.Length)
	endIf

	if Positions.Length != count
		return
	endIf

	Debug.Notification("SexLab debug scene starting")
	Utility.Wait(3.0)

	sslThreadModel Model = SexLab.NewThread()

	Model.AddActor(caster)

	int i
	while i < count
		Model.AddActor(Positions[i])
		i += 1
	endWhile

	sslThreadController Controller = Model.StartThread()

	actor[] aDel
	SexLab.DebugActor = aDel
endEvent
