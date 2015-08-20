Scriptname sslEffectDebug extends ActiveMagicEffect

import PapyrusUtil
import StorageUtil

SexLabFramework property SexLab auto
sslSystemConfig property Config auto
Actor property PlayerRef auto

Actor Ref1
Actor Ref2

float scale1
float scale2

string ActorName
ObjectReference MarkerRef

sslBenchmark function Benchmark(int Tests = 1, int Iterations = 5000, int Loops = 10, bool UseBaseLoop = false)
	return (Quest.GetQuest("SexLabDev") as sslBenchmark).StartBenchmark(Tests, Iterations, Loops, UseBaseLoop)
endFunction


event OnEffectStart(Actor TargetRef, Actor CasterRef)

	Benchmark(2, 10000)

	; bool[] arr = Utility.CreateBoolArray(10, false)
	; Log("10: "+arr)
	; arr = Utility.ResizeBoolArray(arr, 15, true)
	; Log("15: "+arr)
	; arr = PapyrusUtil.RemoveBool(arr, false)
	; Log("5: "+arr)
	; arr = Utility.ResizeBoolArray(arr, 10, false)
	; Log("15: "+arr)
	; arr = PapyrusUtil.PushBool(arr, true)
	; Log("11: "+arr)
	; arr = Utility.ResizeBoolArray(arr, (arr.Length + 1), true)
	; Log("12: "+arr)

	;/ Topic Hit1 = Game.GetForm(0xA91F9) as Topic
	if !Hit1
		Log("Is right form")
		Hit1 = Game.GetForm(0xA91FA) as Topic
	endIf
	if Hit1
		Log("Playing...")
		TargetRef.Say(Hit1)
		Utility.Wait(1.2)	
		TargetRef.Say(Hit1)
		Utility.Wait(1.2)
		TargetRef.Say(Hit1)
		Utility.Wait(1.2)
		TargetRef.Say(Hit1)
		Utility.Wait(1.2)
		TargetRef.Say(Hit1)
		Utility.Wait(1.2)
		TargetRef.Say(Hit1)
		Utility.Wait(1.2)
	else
		Log("Failed to find hit topic")
	endIf
 /;

	Dispel()
endEvent

event OnUpdate()
endEvent

event OnEffectFinish(Actor TargetRef, Actor CasterRef)
	if MarkerRef
		TargetRef.SetVehicle(none)
		MarkerRef.Disable()
		MarkerRef.Delete()
		MarkerRef = none
	endIf
	Log("---- FINISHED ----")
endEvent



;/-----------------------------------------------\;
;|	Debug Utility Functions                      |;
;\-----------------------------------------------/;

function Log(string log)
	; Debug.Notification(log)
	MiscUtil.PrintConsole(log)
	Debug.OpenUserLog("SexLabDebug")
	Debug.TraceUser("SexLabDebug", log)
	Debug.Trace(log)
	; MiscUtil.PrintConsole(ActorName+"\n"+log)
endfunction

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
		; Game.SetPlayerAIDriven()
	else
		ActorRef.SetRestrained(true)
		ActorRef.SetDontMove(true)
	endIf
	; Start DoNothing package
	ActorUtil.AddPackageOverride(ActorRef, SexLab.ActorLib.DoNothing, 100)
	ActorRef.SetFactionRank(SexLab.AnimatingFaction, 1)
	ActorRef.EvaluatePackage()
endFunction

function UnlockActor(actor ActorRef)
	; Enable movement
	if ActorRef == SexLab.PlayerRef
		Game.EnablePlayerControls(false, false, false, false, false, false, true, false, 0)
		; Game.SetPlayerAIDriven(false)
	else
		ActorRef.SetRestrained(false)
		ActorRef.SetDontMove(false)
	endIf
	; Remove from animation faction
	ActorUtil.RemovePackageOverride(ActorRef, SexLab.ActorLib.DoNothing)
	ActorRef.RemoveFromFaction(SexLab.AnimatingFaction)
	ActorRef.EvaluatePackage()
	; Detach positioning marker
	ActorRef.StopTranslation()
	ActorRef.SetVehicle(none)
endFunction

function CheckActor(Actor ActorRef, string check)
	Log(check+" -- "+ActorRef.GetLeveledActorBase().GetName()+" SexLabActors: "+StorageUtil.FormListFind(none, "SexLabActors", ActorRef))
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

