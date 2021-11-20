Scriptname sslEffectDebug extends ActiveMagicEffect

import PapyrusUtil

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




; GlobalVariable TimeScale
; float TimeStart
; float TimeEnd
event OnEffectStart(Actor TargetRef, Actor CasterRef)
	SexLab.QuickStart(CasterRef, TargetRef)

	; Log("Result: "+TestList2)

	; TimeScale = Game.GetFormFromFile(0x3A, "Skyrim.esm") as GlobalVariable
	; TimeStart = SexLabUtil.GetCurrentGameRealTime()
	; TimeEnd = TimeStart + 5.0

	; Log("TimeScale: "+(TimeScale.GetValue() as float))
	; Log("TimeStart: "+TimeStart)
	; Log("TimeEnd: "+TimeEnd)

	; Log("Timer Start!")

	; RegisterForSingleUpdate(0.1)


	; Log("GetCurrentRealTime: "+Utility.GetCurrentRealTime())
	; Log("GetCurrentGameTime: "+Utility.GetCurrentGameTime())
	; Log("GetCurrentGameRealTime: "+SexLabUtil.GetCurrentGameRealTime())


	Dispel()
endEvent

event OnUpdate()
	;/ float CurrentTime = SexLabUtil.GetCurrentGameRealTime()
	if CurrentTime < TimeEnd
		; Log("Timer Continues!\n\t - CurrentTime: "+CurrentTime+"\n\t - TimeStart: "+TimeStart+"\n\t - TimeEnd: "+TimeEnd)
		RegisterForSingleUpdate(0.1)
	else
		float Overage = (TimeEnd - CurrentTime)
		Log("Timer End!\n\t - CurrentTime: "+CurrentTime+"\n\t - TimeStart: "+TimeStart+"\n\t - TimeEnd: "+TimeEnd+"\n\t - Overage: "+Overage)
		Debug.MessageBox("Timer End!\nOverage: "+Overage)
		Dispel()
	endIf/;
endEvent

event OnEffectFinish(Actor TargetRef, Actor CasterRef)
	if MarkerRef
		TargetRef.SetVehicle(none)
		MarkerRef.Disable()
		MarkerRef.Delete()
		MarkerRef = none
	endIf
	SexLabUtil.PrintConsole("---- DEBUG EFFECT FINISHED ----")
endEvent

;/-----------------------------------------------\;
;|	Debug Utility Functions                      |;
;\-----------------------------------------------/;

function Log(string log)
	; Debug.Notification(log)
	Debug.Trace(log)
	Debug.TraceUser("SexLabDebug", log)
	SexLabUtil.PrintConsole(log)
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

Actor[] function ObjsToActors(ObjectReference[] Objects)
	int i = Objects.Length
	Actor[] output = PapyrusUtil.ActorArray(i)
	while i
		i -= 1
		output[i] = Objects[i] as Actor
	endWhile
	return output
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

function SpawnMarker(Actor TargetRef)
	if !MarkerRef
		MarkerRef = TargetRef.PlaceAtMe(Config.BaseMarker)
		int cycle
		while !MarkerRef.Is3DLoaded() && cycle < 50
			Utility.Wait(0.1)
			cycle += 1
		endWhile
	endIf
	MarkerRef.Enable()
	MarkerRef.MoveTo(TargetRef)
endFunction
