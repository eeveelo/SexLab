Scriptname sslEffectDebug extends ActiveMagicEffect

SexLabFramework property SexLab Auto
import SexLabUtil

event OnEffectStart(actor TargetRef, actor CasterRef)
	sslBaseAnimation Anim = SexLab.GetAnimationByName("Arrok Cowgirl")
	Quest Storage = Anim.GetOwningQuest()
	int slot = 1
	int position = 1
	int stage = 2

	string KeyStr = Anim.Name+"["+position+"-"+stage+"]"
	Anim.OLDUpdateOffset(slot, position, stage, 20)
	Anim.SetAdjustment(position, stage, slot, 133)
	Log("Old Offset: "+StorageUtil.FloatListGet(Storage, KeyStr, slot)+" New Offset: "+Anim.GetAdjustment(position, stage, slot), Anim.Name, "[1]", "trace,console")
	Anim._Upgrade()
	Log("Old Offset: "+StorageUtil.FloatListGet(Storage, KeyStr, slot)+" New Offset: "+Anim.GetAdjustment(position, stage, slot), Anim.Name, "[2]", "trace,console")
	Anim.SetAdjustment(position, stage, slot, 50)
	Log("Old Offset: "+StorageUtil.FloatListGet(Storage, KeyStr, slot)+" New Offset: "+Anim.GetAdjustment(position, stage, slot), Anim.Name, "[3]", "trace,console")

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
