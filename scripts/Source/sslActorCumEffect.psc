scriptname sslActorCumEffect extends ActiveMagicEffect

Actor ActorRef
float Timer

event OnEffectStart(Actor TargetRef, Actor CasterRef)
	ActorRef = TargetRef
	Timer    = (Game.GetFormFromFile(0xD62, "SexLab.esm") as sslSystemConfig).CumTimer
	RegisterForSingleUpdate(3.0)
endEvent
event OnUpdate()
	if ActorRef.IsSwimming() || GetTimeElapsed() > Timer
		Dispel()
	else
		RegisterForSingleUpdate(5.0)
	endIf
endEvent
