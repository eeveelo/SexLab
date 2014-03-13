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
	; Ref1 = TargetRef
	; Ref2 = CasterRef
	Ref1 = CasterRef
	Ref2 = TargetRef

	int seed = Utility.RandomInt(TargetRef.GetLevel(), TargetRef.GetLevel() * 4) * 2

	debug.messagebox(SeedSkill(TargetRef, seed, 0.45, 2.5))
	debug.messagebox(SeedSkill(TargetRef, seed, 0.45, 1.5))


	; Idle NextClip = Game.GetForm(0x10EB3C) as Idle
	; Idle PAFull = Game.GetFormFromFile(0x6AB41, "SexLab.esm") as Idle
	; Idle PALoop = Game.GetFormFromFile(0x6AB40, "SexLab.esm") as Idle

	; ObjectUtil.SetReplaceAnimation(Ref1, "NPCKillMoveStart", NextClip)
	; ObjectUtil.SetReplaceAnimation(Ref2, "2_KillMoveStart", NextClip)

	; ObjectUtil.SetReplaceAnimation(Ref2, "NPCKillMoveStart", NextClip)
	; ObjectUtil.SetReplaceAnimation(Ref1, "2_KillMoveStart", NextClip)

	; ; LockActor(Ref1)
	; ; LockActor(Ref2)
	; Ref1.UnequipAll()
	; Ref2.UnequipAll()

	; Ref1.PlayIdleWithTarget(PAFull, Ref2)
	; Game.EnablePlayerControls(false, false, true, true, false, false, false, false)
	; Game.ForceThirdPerson()
	; Debug.SendAnimationEvent(Ref1, "NPCKillMoveEnd")
	; Debug.SendAnimationEvent(Ref2, "NPCKillMoveEnd")

	; Debug.SendAnimationEvent(Ref1, "NPCPairedStop")
	; Debug.SendAnimationEvent(Ref2, "NPCPairedStop")

	; Debug.SendAnimationEvent(Ref1, "PairEnd")
	; Debug.SendAnimationEvent(Ref2, "PairEnd")


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

int function SeedSkill(Actor ActorRef, int seed, float curve = 0.4, float adjuster = 2.2)
	Log("\n\n##############################################################\n\n")
	String ActorName = ActorRef.GetLeveledActorBase().GetName()
	Log(ActorName+" -- Level: "+ActorRef.GetLevel())

	Log(ActorName+" -- Seed: "+seed)

	float speech = ActorRef.GetActorValue("Speechcraft")
	Log(ActorName+" -- Speech: "+speech)

	float conf = ActorRef.GetActorValue("Confidence")
	Log(ActorName+" -- Confidence: "+conf)

	int modifier = (((speech * conf) + 1.0) / adjuster) as int
	Log(ActorName+" -- Speech/Confidence Mod: "+modifier)
	Log(ActorName+" -- Using: "+seed+" + ("+speech+" * "+conf+") / "+adjuster)

	int skill = seed + (((speech * conf) / adjuster) as int)


	Log(ActorName+" -- FINAL SKILL ("+curve+"): "+skill+" -> "+SexLab.CalcLevel(skill, curve))
	Log("\n\n##############################################################")

	return skill
endFunction

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
