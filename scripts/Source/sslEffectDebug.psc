Scriptname sslEffectDebug extends ActiveMagicEffect

SexLabFramework property SexLab Auto

event OnEffectStart(actor TargetRef, actor CasterRef)
	Debug.TraceAndBox(TargetRef.GetLeveledActorBase().GetName()+" LastSex \n GameTime: "+SexLab.MinutesSinceLastSex(TargetRef) + " -- "+SexLab.LastSexTimerString(TargetRef)  +" \n RealTime: "+SexLab.SecondsSinceLastSexRealTime(TargetRef) + " -- "+SexLab.LastSexTimerStringRealTime(TargetRef) )
	Debug.TraceAndBox(CasterRef.GetLeveledActorBase().GetName()+" LastSex \n GameTime: "+SexLab.MinutesSinceLastSex(CasterRef) + " -- "+SexLab.LastSexTimerString(CasterRef)  +" \n RealTime: "+SexLab.SecondsSinceLastSexRealTime(CasterRef) + " -- "+SexLab.LastSexTimerStringRealTime(CasterRef) )
endEvent

event OnEffectFinish(Actor TargetRef, Actor CasterRef)
endEvent



;/-----------------------------------------------\;
;|	Debug Utility Functions                      |;
;\-----------------------------------------------/;

function LockActor(actor ActorRef)
	; Start DoNothing package
	ActorRef.SetFactionRank(SexLab.AnimatingFaction, 1)
	ActorRef.EvaluatePackage()
	; Disable movement
	if ActorRef == SexLab.PlayerRef
		Game.DisablePlayerControls(false, false, false, false, false, false, true, false, 0)
		Game.ForceThirdPerson()
		Game.SetPlayerAIDriven()
	else
		ActorRef.SetRestrained(true)
		ActorRef.SetDontMove(true)
		; ActorRef.SetAnimationVariableBool("bHumanoidFootIKDisable", true)
	endIf
endFunction

function UnlockActor(actor ActorRef)
	; Enable movement
	if ActorRef == SexLab.PlayerRef
		Game.EnablePlayerControls(false, false, false, false, false, false, true, false, 0)
		Game.SetPlayerAIDriven(false)
		; Game.SetInChargen(false, false, false)
	else
		ActorRef.SetRestrained(false)
		ActorRef.SetDontMove(false)
		; ActorRef.SetAnimationVariableBool("bHumanoidFootIKEnable", true)
	endIf
	; Remove from animation faction
	ActorRef.RemoveFromFaction(SexLab.AnimatingFaction)
	ActorRef.EvaluatePackage()
	; Detach positioning marker
	ActorRef.StopTranslation()
	ActorRef.SetVehicle(none)
endFunction

function WaitFor(float seconds)
	float timer = Utility.GetCurrentRealTime() + seconds
	while Utility.GetCurrentRealTime() < timer
		Utility.Wait(0.5)
	endWhile
endFunction
