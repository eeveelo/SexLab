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
	; Loc[0] = CenterLoc[0] + ( Math.sin(CenterLoc[5]) * Offsets[0] ) + ( Math.cos(CenterLoc[5]) * Offsets[1] )
	; Loc[1] = CenterLoc[1] + ( Math.cos(CenterLoc[5]) * Offsets[0] )

	; float[] fArray = SexLabUtil.FloatArray(2)
	; Log("Float Array: "+fArray)

	; SexLabUtil.PrintConsole("Test Console")

	; Form[] Items = new Form[34]
	; int i
	; while i < 33
	; 	Items[i] = TargetRef.GetWornForm(Armor.GetMaskForSlot(i + 30))
	; 	i += 1
	; endWhile

	; Log("CountNone: "+CountNone(Items))
	; Log("CountNone2: "+CountNone2(Items))

	; SexLabUtil.EnterFreeCamera()
	; float[] Coords = GetCoords(TargetRef)
	; Log("Starting Coords: "+Coords)
	; Utility.Wait(4.0)
	; LockActor(TargetRef)
	; Log("New Coords: "+GetCoords(TargetRef))
	; sslActorAlias.SetLocation(TargetRef, Coords)
	; Log("Moved Coords (SKSE): "+GetCoords(TargetRef))
	; UnlockActor(TargetRef)
	; Utility.Wait(8.0)
	; LockActor(TargetRef)
	; Log("New Coords: "+GetCoords(TargetRef))
	; TargetRef.SetPosition(Coords[0], Coords[1], Coords[2])
	; TargetRef.SetAngle(Coords[3], Coords[4], Coords[5])
	; Log("Moved Coords (Papyrus): "+GetCoords(TargetRef))
	; UnlockActor(TargetRef)
	; Utility.Wait(2.5)

	; sslSystemConfig Config = GetConfig()
	; form[] Test = new form[37]
	; Test[3] = Config.GetStrapon()
	; Test[5] = Config.GetStrapon()
	; Test[6] = Config.GetStrapon()
	; Test[7] = Config.GetStrapon()
	; Test[13] = Config.GetStrapon()
	; Test[15] = Config.GetStrapon()
	; Test[16] = Config.GetStrapon()
	; Test[17] = Config.GetStrapon()
	; Test[23] = Config.GetStrapon()
	; Test[25] = Config.GetStrapon()
	; Test[26] = Config.GetStrapon()
	; Test[36] = Config.GetStrapon()


	; float timer = Utility.GetCurrentRealTime()

	; Log("---")


	; form[] Cleared = sslUtility.ClearNone(Test)
	; Log("Papyrus Output: "+Cleared.Length+" -- "+Cleared)
	; Timer(timer, "-- total time")

	; form[] Cleared2 = sslUtility.ClearNone2(Test)
	; Log("SKSE Output: "+Cleared2.Length+" -- "+Cleared2)
	; Timer(timer, "total time")

	; form[] Copied = sslUtility.FormArray(Test.Length + 3)
	; sslUtility.FormCopyTo(Test, Copied, true)
	; Log("SKSE Copied + 3: "+Copied.Length+" -- "+Copied)
	; Timer(timer, "total time")

	; Log("---")


	string[] Test = new string[30]
	Test[4] = "sdfsd"
	Test[6] = "sdfsd"
	Test[12] = "sdfsd"
	Test[16] = "sdfsd"
	Test[23] = "sdfsd"
	Test[25] = ""

	Test = TrimStringArray(Test, 6)
	Log("String ClearEmpty() "+Test.Length+" -- "+Test)

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
