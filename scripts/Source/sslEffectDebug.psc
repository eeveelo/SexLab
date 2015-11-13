Scriptname sslEffectDebug extends ActiveMagicEffect

import PapyrusUtil
import JsonUtil

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

	Spell SelectedActor = Game.GetFormFromFile(0x8C5F6, "SexLab.esm") as Spell
	Utility.WaitMenuMode(8.0)
	Log(SelectedActor)
	Log("Cast 1")
	SelectedActor.Cast(TargetRef, TargetRef)
	Utility.WaitMenuMode(8.0)
	Log("Added")
	TargetRef.AddSpell(SelectedActor)
	Utility.WaitMenuMode(8.0)
	Log("Cast 2")
	SelectedActor.Cast(TargetRef, TargetRef)

	; Log(CasterRef+" BEFORE: "+SexLabUtil.HasKeywordSub(CasterRef, "Crafting"))
	; Utility.WaitMenuMode(20.0)
	; Log(CasterRef+" AFTER: "+SexLabUtil.HasKeywordSub(CasterRef, "Crafting"))
	; Benchmark(1, 50, 5, false)

	;/ if TargetRef == CasterRef
		string[] FileList = JsonUtil.JsonInFolder("../SexLab/")
		Log("FileList: "+FileList)
		string[] EsmList = MiscUtil.FilesInFolder("data", ".esm")
		Log("EsmList: "+EsmList)
		string[] TxtList = MiscUtil.FilesInFolder("data/", "txt")
		Log("TxtList: "+TxtList)
		string[] RootList1 = MiscUtil.FilesInFolder("./", ".ini")
		Log("RootList1: "+RootList1)
		string[] RootList2 = MiscUtil.FilesInFolder("/", ".ini")
		Log("RootList2: "+RootList2)
		string[] SKSEList = MiscUtil.FilesInFolder("data/SKSE/plugins/")
		Log("SKSEList: "+SKSEList)
	else
		sslThreadModel Thread = SexLab.NewThread()
		Thread.AddActor(CasterRef)
		Thread.AddActor(TargetRef, true)
		sslBaseAnimation[] Anims = new sslBaseAnimation[1]
		Anims[0] = SexLab.GetAnimationByRegistry("ArrokRape")
		Thread.SetAnimations(Anims)
		Thread.DisableLeadIn(true)
		Thread.StartThread()
		Utility.Wait(1.0)
		Log("IsAggressive: "+Thread.IsAggressive)
		Log("VictimRef: "+Thread.VictimRef)
		Log("Victims: "+Thread.Victims)
	endIf /;

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
	; Log("---- FINISHED ----")
endEvent



;/-----------------------------------------------\;
;|	Debug Utility Functions                      |;
;\-----------------------------------------------/;

function Log(string log)
	Debug.Notification(log)
	MiscUtil.PrintConsole(log)
	Debug.OpenUserLog("SexLabDebug")
	Debug.TraceUser("SexLabDebug", log)
	Debug.Trace(log)
	; MiscUtil.PrintConsole(ActorName+"\n"+log)
endfunction

string function GetActorNames(Actor[] Actors)
	string names
	int i = Actors.Length
	while i
		i -= 1
		names += "["+Actors[i].GetLeveledActorBase().GetName()+"]"
	endWhile
	return names
endFunction

string function GetObjNames(ObjectReference[] Objects)
	string names
	int i = Objects.Length
	while i
		i -= 1
		names += "["+Objects[i].GetName()+"]"
	endWhile
	return names
endFunction

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
