Scriptname sslEffectDebug extends ActiveMagicEffect

SexLabFramework property SexLab Auto
import SexLabUtil
import MiscUtil
import ActorUtil
import StorageUtil
import sslUtility

Actor Ref1
Actor Ref2

float scale1
float scale2

string ActorName
ObjectReference MarkerRef


event OnEffectStart(Actor TargetRef, Actor CasterRef)

	; sslBenchmark Dev = Quest.GetQuest("SexLabDev") as sslBenchmark
	; Dev.RegisterForModEvent("HookAnimationChange_DevTest", "Hook")
	; SexLab.QuickStart(CasterRef, TargetRef, Hook = "DevTest")

	; sslBaseAnimation[] Standing = SexLab.GetAnimationsByTags(2, "Cowgirl,Standing", RequireAll = false)
	; Log("With Standing("+Standing.Length+"): "+Standing)

	; sslBaseAnimation[] Cleaned = SexLab.AnimSlots.RemoveTagged(Standing, "Standing")
	; Log("Standing Removed("+Cleaned.Length+") - Removed ("+SexLab.AnimSlots.CountTag(Standing, "Standing")+"): "+Cleaned)

	; Actor ActorRef = TargetRef

	; ; Calculate scales
	; float display = ActorRef.GetScale()
	; Log("display "+ display)

	; ActorRef.SetScale(1.0)
	; float base = ActorRef.GetScale()
	; Log("base "+ base)

	; float ActorScale = ( display / base )
	; Log("ActorScale "+ ActorScale)

	; ActorRef.SetScale(ActorScale)

	; Log("current scale "+ActorRef.GetScale())

	; Log("skeleton.nif " +NetImmerse.GetNodeScale(ActorRef, "skeleton.nif", false))
	; Log("NPC " +NetImmerse.GetNodeScale(ActorRef, "NPC", false))
	; Log("NPC Root [Root] " +NetImmerse.GetNodeScale(ActorRef, "NPC Root [Root]", false))
	; Log("NPC COM [COM ] " +NetImmerse.GetNodeScale(ActorRef, "NPC COM [COM ]", false))

	; Log("------------")

	; float AnimScale = (1.0 / base)
	; ActorRef.SetScale(AnimScale)
	; Log("AnimScale "+ AnimScale)

	; Log("skeleton.nif " +NetImmerse.GetNodeScale(ActorRef, "skeleton.nif", false))
	; Log("NPC " +NetImmerse.GetNodeScale(ActorRef, "NPC", false))
	; Log("NPC Root [Root] " +NetImmerse.GetNodeScale(ActorRef, "NPC Root [Root]", false))
	; Log("NPC COM [COM ] " +NetImmerse.GetNodeScale(ActorRef, "NPC COM [COM ]", false))

	; ActorRef.SetScale(ActorScale)
	; Log("end scale "+ActorRef.GetScale())

	; float com = NetImmerse.GetNodeScale(ActorRef, "NPC COM [COM ]", false)


	; NetImmerse.SetNodeScale(ActorRef, "NPC COM [COM ]", 1.0, false)
	; Log("NPC COM [COM ] ALTERED " +NetImmerse.GetNodeScale(ActorRef, "NPC COM [COM ]", false))

	; Utility.Wait(10.0)

	; float display2 = ActorRef.GetScale()
	; Log("ALT display "+ display2)

	; ActorRef.SetScale(1.0)
	; float base2 = ActorRef.GetScale()
	; Log("ALT base "+ base)

	; Log("ALT ActorScale "+ ( display2 / base2 ))




	; NetImmerse.SetNodeScale(ActorRef, "NPC COM [COM ]", com, false)
	; Log("NPC COM [COM ] returned " +NetImmerse.GetNodeScale(ActorRef, "NPC COM [COM ]", false))



	Dispel()
endEvent

event OnUpdate()

endEvent

event OnEffectFinish(Actor TargetRef, Actor CasterRef)
	; Log("Debug effect spell expired("+TargetRef+", "+CasterRef+")")
endEvent


function CheckActor(Actor ActorRef, string check)
	Log(check+" -- "+ActorRef.GetLeveledActorBase().GetName()+" SexLabActors: "+FormListFind(none, "SexLabActors", ActorRef))
endFunction

;/-----------------------------------------------\;
;|	Debug Utility Functions                      |;
;\-----------------------------------------------/;

float[] function GetCoords(Actor ActorRef)
	float[] coords = new float[6]
	coords[0] = ActorRef.GetPositionX()
	coords[1] = ActorRef.GetPositionY()
	coords[2] = ActorRef.GetPositionZ()
	coords[3] = ActorRef.GetAngleX()
	coords[4] = ActorRef.GetAngleY()
	coords[5] = ActorRef.GetAngleZ()
	return coords
endFunction

float[] function OffsetCoords(float[] Loc, float[] CenterLoc, float[] Offsets)
	Loc[0] = CenterLoc[0] + ( Math.sin(CenterLoc[5]) * Offsets[0] ) + ( Math.cos(CenterLoc[5]) * Offsets[1] )
	Loc[1] = CenterLoc[1] + ( Math.cos(CenterLoc[5]) * Offsets[0] ) + ( Math.sin(CenterLoc[5]) * Offsets[1] )
	Loc[2] = CenterLoc[2] + Offsets[2]
	Loc[3] = CenterLoc[3]
	Loc[4] = CenterLoc[4]
	Loc[5] = CenterLoc[5] + Offsets[3]
	if Loc[5] >= 360.0
		Loc[5] = Loc[5] - 360.0
	elseIf Loc[5] < 0.0
		Loc[5] = Loc[5] + 360.0
	endIf
	return Loc
endFunction

function Log(string log)
	Debug.Notification(log)
	Debug.Trace(log)
	; MiscUtil.PrintConsole(ActorName+"\n"+log)
	SexLabUtil.PrintConsole(log)
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
	ActorRef.StopCombat()
	; Disable movement
	if ActorRef == SexLab.PlayerRef
		Game.DisablePlayerControls(false, false, false, false, false, false, true, false, 0)
		Game.ForceThirdPerson()
		Game.SetPlayerAIDriven()
	else
		ActorRef.SetRestrained(true)
		ActorRef.SetDontMove(true)
	endIf
	; Start DoNothing package
	AddPackageOverride(ActorRef, SexLab.ActorLib.DoNothing, 100)
	ActorRef.SetFactionRank(SexLab.AnimatingFaction, 1)
	ActorRef.EvaluatePackage()
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

bool function IsStrippable(form ItemRef)
	int i = ItemRef.GetNumKeywords()
	while i
		i -= 1
		if StringUtil.Find(ItemRef.GetNthKeyword(i).GetString(), "NoStrip") != -1 ;|| StringUtil.Find(kw, "Bound") != -1
			return false
		endIf
	endWhile
	return true
endFunction
