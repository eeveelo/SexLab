Scriptname sslEffectDebug extends ActiveMagicEffect

import PapyrusUtil

SexLabFramework property SexLab Auto
Actor property PlayerRef auto

Actor Ref1
Actor Ref2

float scale1
float scale2

string ActorName
ObjectReference MarkerRef

event OnEffectStart(Actor TargetRef, Actor CasterRef)

	if TargetRef == PlayerRef
		SexLab.QuickStart(CasterRef, AnimationTags = "FalloutBoy2,Mitos,4uDIK,3jiou,Leito")
	else
		SexLab.QuickStart(CasterRef, TargetRef, AnimationTags = "FalloutBoy2,Mitos,4uDIK,3jiou,Leito")
	endIf

	; if StorageUtil.HasFormValue(none, "TestObj")
	; 	Form ObjForm = StorageUtil.GetFormValue(none, "TestObj")
	; 	Log("Obj Saved ["+ObjForm.GetFormID()+"]: "+ObjForm)
	; 	Log("Value Del(1)"+StorageUtil.GetIntValue(ObjForm, "Test"))
	; 	Utility.Wait(2.0)
	; endIf
 
	; sslSystemConfig Config = SexLab.Config
	; ObjectReference Obj = TargetRef.PlaceAtMe(Config.BaseMarker, 1)
	; Utility.Wait(2.0)

	; Log("Obj New ["+Obj.GetFormID()+"]: "+Obj)
	; StorageUtil.SetIntValue(Obj, "Test", 42)
	; StorageUtil.SetFormValue(none, "TestObj", Obj)
	; Log("Value Set: "+StorageUtil.GetIntValue(Obj, "Test"))

	; Utility.Wait(2.0)

	; Obj.Disable()
	; Obj.Delete()
	; Obj = none

	; Utility.Wait(2.0)

	; Log("Value Del(2)"+StorageUtil.GetIntValue(Obj, "Test"))
	; Utility.Wait(1.0)

	; ; int[] Array = new int[20]
	; int i = Array.Length
	; while i
	; 	i -= 1
	; 	Array[i] = i
	; endWhile

	; Log("Array: "+Array)

	; Log("9-15: "+PapyrusUtil.SliceIntArray(Array, 9, 15))
	; Log("0-9: "+PapyrusUtil.SliceIntArray(Array, 0, 9))
	; Log("15-end: "+PapyrusUtil.SliceIntArray(Array, 15))
	; Log("0-end: "+PapyrusUtil.SliceIntArray(Array, 0))
	; Log("10-10: "+PapyrusUtil.SliceIntArray(Array, 10, 10))
	; Log("15-25: "+PapyrusUtil.SliceIntArray(Array, 15, 25))

	; Log("--- Slice ---")

	; string[] Strs = Utility.CreateStringArray(20, "dsfsdf")
	; Strs[0] = "test1"
	; Strs[1] = "test1"
	; Strs[3] = "test3"
	; Strs[4] = "test1"
	; Strs[6] = "test3"
	; Strs[7] = "test1"
	; Strs[11] = ""
	; Strs[12] = "test1"
	; Strs[13] = ""
	; Strs[18] = "test1"
	; Strs[19] = "test2"
	; Log("Strs: "+Strs)

	; Log("test1: "+PapyrusUtil.RemoveString(Strs, "test1"))
	; Log("test2: "+PapyrusUtil.RemoveString(Strs, "test2"))
	; Log("EMPTY: "+PapyrusUtil.ClearEmpty(Strs))

	; Log("--- Forms ---")

	; Form[] Forms
	; Log("UNINIT: "+PapyrusUtil.RemoveForm(Forms, none))
	; Forms = new form[3]
	; Forms[0] = TargetRef
	; Forms[1] = TargetRef
	; Forms[2] = SexLab
	; Log("SexLab: "+PapyrusUtil.RemoveForm(Forms, SexLab))
	; Log("TargetRef: "+PapyrusUtil.RemoveForm(Forms, TargetRef))
	; Log("missing: "+PapyrusUtil.RemoveForm(Forms, SexLab.Config.CalypsStrapon))
	; Forms[0] = none
	; Forms[1] = none
	; Log("none: "+PapyrusUtil.ClearNone(Forms))
	; Forms[0] = TargetRef
	; Forms[1] = TargetRef
	; Forms[2] = TargetRef
	; Log("all: "+PapyrusUtil.RemoveForm(Forms, TargetRef))


	; float RealTime = Utility.GetCurrentRealTime()
	; float GameTime = Utility.GetCurrentGameTime()
	; sslActorStats._SeedActor(TargetRef, RealTime, GameTime)
	; Log("Ashal Seed:")
	; Log(SexLab.Stats.PrintSkills(TargetRef))

	; sslActorStats._SeedActor2(TargetRef, RealTime, GameTime)
	; Log("CPU Seed:")
	; Log(SexLab.Stats.PrintSkills(TargetRef))


	; Log("Waiting: "+CasterRef)
	; Utility.Wait(15.0)
	; Log("Starting")
	; SexLab.QuickStart(TargetRef, CasterRef)

	; Benchmark(3, 50, 5)

	; sslAnimationSlots AnimSlots = SexLab.AnimSlots
	; Log("Filter: "+AnimSlots.Filter)
	; Utility.Wait(2.0)

	; sslBaseAnimation[] GetByTags       = AnimSlots.GetbyTags(2, "FM,Oral")
	; Log("GetByTags("+GetByTags.Length+") - "+GetbyTags)
	; Utility.Wait(2.0)

	; sslBaseAnimation[] GetByTagsCall   = AnimSlots.GetByTagsCall(2, "FM,Oral")
	; Log("GetByTagsCall("+GetByTagsCall.Length+") - "+GetByTagsCall)
	; Utility.Wait(2.0)

	; sslBaseAnimation[] GetByTagsFilter = AnimSlots.GetByTagsFilter(2, "FM,Oral")
	; Log("GetByTagsFilter("+GetByTagsFilter.Length+") - "+GetByTagsFilter)
	; Utility.Wait(2.0)



	; SexLab.QuickStart(CasterRef, TargetRef, AnimationTags="Oral")
	; Furniture BaseMarker = SexLab.Config.BaseMarker
	; MiscObject BaseMarker = SexLab.Config.IdleMarker

	; if TargetRef != Game.GetPlayer() && Input.IsKeyPressed(29)
	; 	TargetRef.SetRestrained(false)
	; 	TargetRef.SetDontMove(false)
	; endIf

	; MarkerRef = TargetRef.PlaceAtMe(BaseMarker)
	; Utility.Wait(0.5)
	; ; while !MarkerRef.Is3DLoaded() || MarkerRef.IsDisabled()
	; ; endwhile
	; Log(MarkerRef)
	; TargetRef.SetVehicle(MarkerRef)

	; Utility.Wait(3.0)
	; Dispel()
endEvent

event OnUpdate()
endEvent

event OnEffectFinish(Actor TargetRef, Actor CasterRef)
	TargetRef.SetVehicle(none)
	MarkerRef.Disable()
	MarkerRef.Delete()
	MarkerRef = none
	Log("---- FINISHED ----")
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
		Game.SetPlayerAIDriven()
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
		Game.SetPlayerAIDriven(false)
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

sslBenchmark function Benchmark(int Tests = 1, int Iterations = 5000, int Loops = 10, bool UseBaseLoop = false)
	return (Quest.GetQuest("SexLabDev") as sslBenchmark).StartBenchmark(Tests, Iterations, Loops, UseBaseLoop)
endFunction
