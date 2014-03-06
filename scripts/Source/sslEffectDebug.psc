Scriptname sslEffectDebug extends ActiveMagicEffect

SexLabFramework property SexLab Auto
import SexLabUtil
import MiscUtil
import ActorUtil

Idle Playing

actor Ref1
actor Ref2

float scale1
float scale2

event OnEffectStart(Actor TargetRef, Actor CasterRef)
	Ref1 = TargetRef
	Ref2 = CasterRef


	sslBaseVoice Voice = GetAPI().PickVoice(TargetRef)
	Log(TargetRef.GetLeveledActorBase().GetName()+" Selected: "+Voice.Name)


	Utility.Wait(1.0)
	Dispel()
endEvent

event OnUpdate()
	; PrintConsole("OnUpdate")
	; Ref1.PlayIdleWithTarget(Playing, Ref2)
	; RegisterForSingleUpdate(8.0)
endEvent

event OnEffectFinish(Actor TargetRef, Actor CasterRef)
	Log("Debug effect spell expired("+TargetRef+", "+CasterRef+")")
endEvent

;/-----------------------------------------------\;
;|	Debug Utility Functions                      |;
;\-----------------------------------------------/;

function Benchmark(int iterations = 100000, float started = 0.0, float finished = 0.0)
	Debug.Notification("Starting benchmark...")

	; Benchmark prep


	started = Utility.GetCurrentRealTime()
	while iterations
		iterations -= 1
		; Code to benchmark


	endWhile
	finished = Utility.GetCurrentRealTime()

	Utility.Wait(1.0)
	Log(" Started: " + started)
	Log("Finished: " + finished)
	Log("Total Time: " + (finished - started))

	Debug.Notification("Benchmark end...")
endFunction

function Log(string log)
	Debug.Trace(log)
	MiscUtil.PrintConsole(log)
endfunction

float function Scale(Actor ActorRef)
	float display = ActorRef.GetScale()
	ActorRef.SetScale(1.0)
	float base = ActorRef.GetScale()
	float ActorScale = ( display / base )
	ActorRef.SetScale(ActorScale)
	float AnimScale = (1.0 / base)
	return AnimScale
endFunction

function LockActor(actor ActorRef)
	; Start DoNothing package
	AddPackageOverride(ActorRef, SexLab.ActorLib.DoNothing, 100)
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
	endIf
endFunction

function UnlockActor(actor ActorRef)
	; Enable movement
	if ActorRef == SexLab.PlayerRef
		Game.EnablePlayerControls(false, false, false, false, false, false, true, false, 0)
		Game.SetPlayerAIDriven(false)
	else
		ActorRef.SetRestrained(false)
		ActorRef.SetDontMove(false)
	endIf
	; Remove from animation faction
	RemovePackageOverride(ActorRef, SexLab.ActorLib.DoNothing)
	ActorRef.RemoveFromFaction(SexLab.AnimatingFaction)
	ActorRef.EvaluatePackage()
	; Detach positioning marker
	ActorRef.StopTranslation()
	ActorRef.SetVehicle(none)
endFunction
