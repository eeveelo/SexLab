Scriptname sslEffectDebug extends ActiveMagicEffect

SexLabFramework property SexLab Auto
import SexLabUtil
import MiscUtil
import ActorUtil

string function Key(string type)
	return "Missionary."+type
endFunction

event OnEffectStart(actor TargetRef, actor CasterRef)
	sslActorLibrary Lib = SexLab.ActorLib

	Lib.StripActorStorage(TargetRef, Lib.GetStrip(TargetRef, none, false), true)
	Wait(6.0)
	Lib.UnstripActorStorage(TargetRef)
	Debug.TraceAndBox("Normal Done")

	Lib.StripActorStorage(TargetRef, Lib.GetStrip(TargetRef, none, true), true)
	Wait(6.0)
	Lib.UnstripActorStorage(TargetRef)
	Debug.TraceAndBox("LeadIn Done")

	Lib.StripActorStorage(TargetRef, Lib.GetStrip(TargetRef, none, true), true)
	Wait(4.0)
	Lib.StripActorStorage(TargetRef, Lib.GetStrip(TargetRef, none, false), false)
	Wait(5.0)
	Lib.UnstripActorStorage(TargetRef)
	Debug.TraceAndBox("LeadIn->Normal Done")

	Lib.StripActorStorage(TargetRef, Lib.GetStrip(TargetRef, TargetRef, false), false)
	Wait(6.0)
	Lib.UnstripActorStorage(TargetRef)
	Debug.TraceAndBox("Victim Done")


	Dispel()
endEvent

event OnEffectFinish(Actor TargetRef, Actor CasterRef)
endEvent

;/-----------------------------------------------\;
;|	Debug Utility Functions                      |;
;\-----------------------------------------------/;

function LockActor(actor ActorRef)
	; Start DoNothing package
	AddPackageOverride(ActorRef, (Game.GetFormFromFile(0x0E50E, "SexLab.esm") as Package), 100)
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
	RemovePackageOverride(ActorRef, (Game.GetFormFromFile(0x0E50E, "SexLab.esm") as Package))
	ActorRef.RemoveFromFaction(SexLab.AnimatingFaction)
	ActorRef.EvaluatePackage()
	; Detach positioning marker
	ActorRef.StopTranslation()
	ActorRef.SetVehicle(none)
endFunction
