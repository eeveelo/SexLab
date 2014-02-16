Scriptname sslEffectDebug extends ActiveMagicEffect

SexLabFramework property SexLab Auto
import SexLabUtil
import MiscUtil
import ActorUtil

event OnEffectStart(actor TargetRef, actor CasterRef)


	sslThreadModel Thread = NewThread()
	Debug.TraceAndBox(Thread)

	Thread.AddActor(TargetRef)
	Thread.AddActor(CasterRef)
	Thread.StartThread()

	Thread.Log(Thread.Positions)
	; Thread.Initialize()
	Dispel()
endEvent

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
