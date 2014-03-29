scriptname sslActorCumEffect extends ActiveMagicEffect

float Timer

event OnEffectStart(Actor TargetRef, Actor CasterRef)
	Timer = (Quest.GetQuest("SexLabQuestFramework") as sslSystemConfig).fCumTimer
	RegisterForSingleUpdate(1.0)
endEvent
event OnUpdate()
	if GetTargetActor().IsSwimming() || GetTimeElapsed() > Timer
		Dispel()
		return
	endIf
	RegisterForSingleUpdate(5.0)
endEvent
