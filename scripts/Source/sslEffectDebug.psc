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

float function TestCos(float value) global native
float function TestSin(float value) global native

event OnEffectStart(Actor TargetRef, Actor CasterRef)

	float[] Skills = SexLab.Stats.GetSkillLevels(TargetRef)
	float[] XP = new float[6]
	XP[0] = 0.0
	XP[1] = 0.0
	XP[2] = 5.0
	XP[3] = 0.0
	XP[4] = 0.0
	XP[5] = 0.0

	Log(TargetRef.GetLeveledActorBase().GetName()+" ------ ")
	Log("Skills: "+Skills)
	Log("Female Stage 1/5: "+sslActorAlias.CalcEnjoyment(XP, Skills, false, true, 10.0, 1, 5))
	Log("Female Stage 3/5: "+sslActorAlias.CalcEnjoyment(XP, Skills, false, true, 30.0, 3, 5))
	Log("Female Stage 5/5: "+sslActorAlias.CalcEnjoyment(XP, Skills, false, true, 50.0, 5, 5))

	Log("Male Stage 1/5: "+sslActorAlias.CalcEnjoyment(XP, Skills, false, false, 10.0, 1, 5))
	Log("Male Stage 3/5: "+sslActorAlias.CalcEnjoyment(XP, Skills, false, false, 30.0, 3, 5))
	Log("Male Stage 5/5: "+sslActorAlias.CalcEnjoyment(XP, Skills, false, false, 50.0, 5, 5))



	; sslBenchMark Dev = Quest.GetQuest("SexLabDev") as sslBenchmark
	; Dev.StartBenchmark(2)
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

function Log(string log)
	; Debug.TraceAndBox(ActorName+"\n"+log)
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
