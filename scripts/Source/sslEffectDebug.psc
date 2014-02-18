Scriptname sslEffectDebug extends ActiveMagicEffect

SexLabFramework property SexLab Auto
import SexLabUtil
import MiscUtil
import ActorUtil

event OnEffectStart(actor TargetRef, actor CasterRef)


	; sslBaseAnimation[] Anims = SexLab.AnimSlots.GetByTags(2, "Cowgirl")
	; Debug.TraceAndBox("Found: "+Anims.Length)
	; Debug.Trace(Anims)

	SexLab = GetAPI()

	Actor[] Positions = SexLab.MakeActorArray(SexLab.FindAvailableActor(TargetRef), CasterRef)
	PrintConsole("Unsorted: "+Positions)
	Positions = SexLab.SortActors(Positions)
	PrintConsole("Sorted: "+Positions)

	SexLab.QuickStart(Positions[0], Positions[1], VictimRef = TargetRef, Hook = "Test").Log("Started Test!")

	; Thread.Log(Thread.Positions)
	; Thread.Initialize()
endEvent


		; ModEvent.PushForm(eid, self)
		; ModEvent.PushBool(eid, HasPlayer)
		; ModEvent.PushForm(eid, VictimRef)
		; ModEvent.PushFloat(eid, StartedAt)



event OnEffectFinish(Actor TargetRef, Actor CasterRef)
endEvent

;/-----------------------------------------------\;
;|	Debug Utility Functions                      |;
;\-----------------------------------------------/;

; function LockActor(actor ActorRef)
; 	; Start DoNothing package
; 	AddPackageOverride(ActorRef, SexLAb.ActorLib.DoNothing, 100)
; 	ActorRef.SetFactionRank(SexLab.AnimatingFaction, 1)
; 	ActorRef.EvaluatePackage()
; 	; Disable movement
; 	if ActorRef == SexLab.PlayerRef
; 		Game.DisablePlayerControls(false, false, false, false, false, false, true, false, 0)
; 		Game.ForceThirdPerson()
; 		Game.SetPlayerAIDriven()
; 	else
; 		ActorRef.SetRestrained(true)
; 		ActorRef.SetDontMove(true)
; 	endIf
; endFunction

; function UnlockActor(actor ActorRef)
; 	; Enable movement
; 	if ActorRef == SexLab.PlayerRef
; 		Game.EnablePlayerControls(false, false, false, false, false, false, true, false, 0)
; 		Game.SetPlayerAIDriven(false)
; 	else
; 		ActorRef.SetRestrained(false)
; 		ActorRef.SetDontMove(false)
; 	endIf
; 	; Remove from animation faction
; 	RemovePackageOverride(ActorRef, SexLAb.ActorLib.DoNothing)
; 	ActorRef.RemoveFromFaction(SexLab.AnimatingFaction)
; 	ActorRef.EvaluatePackage()
; 	; Detach positioning marker
; 	ActorRef.StopTranslation()
; 	ActorRef.SetVehicle(none)
; endFunction
