scriptname sslActorCumEffect extends ActiveMagicEffect

float timer

event OnEffectStart(actor TargetRef, actor CasterRef)
	timer = (Quest.GetQuest("SexLabQuestFramework") as sslSystemConfig).fCumTimer
	RegisterForSingleUpdate(1.0)
endEvent
event OnUpdate()
	if GetTargetActor().IsSwimming() || GetTimeElapsed() > timer
		Dispel()
		return
	endIf
	RegisterForSingleUpdate(5.0)
endEvent
