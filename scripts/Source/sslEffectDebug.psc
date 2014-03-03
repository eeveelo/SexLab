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

event OnEffectStart(actor TargetRef, actor CasterRef)


	; sslBaseAnimation[] Anims = SexLab.AnimSlots.GetByTags(2, "Cowgirl")
	; Debug.TraceAndBox("Found: "+Anims.Length)
	; Debug.Trace(Anims)

	SexLab = GetAPI()

	Ref2 = TargetRef
	Ref1 = SexLab.FindAvailableActor(Ref2, 5000.0, 1, SexLab.PlayerRef)

	; Ref1.SetRestrained(true)
	; Ref2.SetRestrained(true)

	; Playing = Game.GetFormFromFile(0x6AB40, "SexLab.esm") as Idle ; Looped
	Playing = Game.GetFormFromFile(0x6AB41, "SexLab.esm") as Idle ; Not Looped

	Ref1.UnequipAll()
	Ref2.UnequipAll()

	Ref1.MoveTo(Ref2)

	Ref1.PlayIdleWithTarget(Playing, Ref2)

	RegisterForSingleUpdate(8.0)

	; Utility.Wait(2.0)


	; LockActor(Ref1)
	; LockActor(Ref2)

	scale1 = Scale(Ref1)
	scale2 = Scale(Ref2)

	Ref1.SetScale(scale1)
	Ref2.SetScale(scale2)

	; DebugLog(CasterRef.GetLeveledActorBase().GetName()+" -> "+TargetRef.GetLeveledActorBase().GetName(), Looped, true)
	; float started = Utility.GetCurrentRealTime()
	; CasterRef.PlayIdleWithTarget(Playing, TargetRef)
	; float ended = (Utility.GetCurrentRealTime() - started)
	; DebugLog("Ended After: "+ended, "Looped", true)

	; UnlockActor(TargetRef)
	; UnlockActor(CasterRef)

	; Actor[] Positions = SexLab.MakeActorArray(SexLab.FindAvailableActor(TargetRef), SexLab.PlayerRef)
	; PrintConsole("Unsorted: "+Positions)
	; Positions = SexLab.SortActors(Positions)
	; PrintConsole("Sorted: "+Positions)

	; SexLab.QuickStart(Positions[0], Positions[1]).Log("Started Test!")

	; Thread.Log(Thread.Positions)
	; Thread.Initialize()
endEvent

float function Scale(actor ActorRef)
	float display = ActorRef.GetScale()
	ActorRef.SetScale(1.0)
	float base = ActorRef.GetScale()
	float ActorScale = ( display / base )
	ActorRef.SetScale(ActorScale)
	float AnimScale = (1.0 / base)
	return AnimScale
endFunction

event OnUpdate()
	PrintConsole("OnUpdate")
	Ref1.PlayIdleWithTarget(Playing, Ref2)
	RegisterForSingleUpdate(8.0)
endEvent

event OnEffectFinish(Actor TargetRef, Actor CasterRef)
	Ref1.SetRestrained(false)
	Ref2.SetRestrained(false)
	debug.traceandbox("effect finish")
endEvent

;/-----------------------------------------------\;
;|	Debug Utility Functions                      |;
;\-----------------------------------------------/;

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
