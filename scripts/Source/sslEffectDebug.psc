Scriptname sslEffectDebug extends ActiveMagicEffect

SexLabFramework property SexLab Auto
import SexLabUtil

event OnEffectStart(actor TargetRef, actor CasterRef)
	actor[] Found = SexLab.FindAvailablePartners(SexLab.MakeActorArray(CasterRef), Utility.RandomInt(2,5))
	Debug.TraceAndBox("MALE\nUnsorted Actors: "+Genders(Found)+"\n  Sorted Actors: "+Genders(SexLab.SortActors(Found, false)))

	actor[] Found2 = SexLab.FindAvailablePartners(SexLab.MakeActorArray(CasterRef), Utility.RandomInt(2,5))
	Debug.TraceAndBox("FEMALE\nUnsorted Actors: "+Genders(Found2)+"\n  Sorted Actors: "+Genders(SexLab.SortActors(Found2, true)))

	Dispel()
endEvent

event OnEffectFinish(Actor TargetRef, Actor CasterRef)
endEvent


bool function DupeCheck(actor[] Positions)
	int i
	while i < Positions.Length
		if Positions[i] == none
			Debug.TraceAndBox("Empty element found: "+i)
			return false
		elseIf Positions.Find(Positions[i]) != Positions.RFind(Positions[i])
			Debug.TraceAndBox("Duplicate found: "+Positions.Find(Positions[i]) + " - " + Positions.RFind(Positions[i]))
			return false
		endIf
		i += 1
	endWhile
	return true
endFunction

string function Genders(actor[] Positions)
	DupeCheck(Positions)
	string output
	int i
	while i < Positions.Length
		int Gender = SexLab.GetGender(Positions[i])
		if Gender == 0
			output +=  "Male, "
		elseIf Gender == 1
			output += "Female, "
		else
			output += "Misc, "
		endIf
		i += 1
	endWhile
	return output
endFunction

;/-----------------------------------------------\;
;|	Debug Utility Functions                      |;
;\-----------------------------------------------/;

function LockActor(actor ActorRef)
	; Start DoNothing package
	ActorUtil.AddPackageOverride(ActorRef, (Game.GetFormFromFile(0x0E50E, "SexLab.esm") as Package), 100)
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
	ActorUtil.RemovePackageOverride(ActorRef, (Game.GetFormFromFile(0x0E50E, "SexLab.esm") as Package))
	ActorRef.RemoveFromFaction(SexLab.AnimatingFaction)
	ActorRef.EvaluatePackage()
	; Detach positioning marker
	ActorRef.StopTranslation()
	ActorRef.SetVehicle(none)
endFunction
