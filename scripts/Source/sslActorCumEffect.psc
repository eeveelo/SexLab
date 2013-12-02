scriptname sslActorCumEffect extends ActiveMagicEffect

sslActorLibrary property Lib auto
float timer

event OnEffectStart(actor target, actor caster)
	timer = Lib.fCumTimer
	RegisterForSingleUpdate(5.0)
endEvent
event OnUpdate()
	if GetTargetActor().IsSwimming() || GetTimeElapsed() > timer
		Dispel()
		return
	endIf
	RegisterForSingleUpdate(5.0)
endEvent
