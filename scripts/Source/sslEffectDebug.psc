Scriptname sslEffectDebug extends ActiveMagicEffect

SexLabFramework property SexLab Auto
import SexLabUtil
import MiscUtil
import ActorUtil

string function Key(string type)
	return "Missionary."+type
endFunction

event OnEffectStart(actor TargetRef, actor CasterRef)
	StorageUtil.FormListAdd(SexLab.ActorLib, "Registry", TargetRef, false)
	Debug.TraceAndBox("[1] Tags: "+StorageUtil.FormListCount(SexLab.ActorLib, "Registry")+" HasActor: "+StorageUtil.FormListFind(SexLab.ActorLib, "Registry", TargetRef))
	Wait(5.0)
	StorageUtil.FormListRemove(SexLab.ActorLib, "Registry", TargetRef, true)
	Debug.TraceAndBox("[2] Tags: "+StorageUtil.FormListCount(SexLab.ActorLib, "Registry")+" HasActor: "+StorageUtil.FormListFind(SexLab.ActorLib, "Registry", TargetRef))

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
