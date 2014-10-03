Scriptname sslEffectDebug extends ActiveMagicEffect

SexLabFramework property SexLab Auto

Actor Ref1
Actor Ref2

float scale1
float scale2

string ActorName
ObjectReference MarkerRef

event OnEffectStart(Actor TargetRef, Actor CasterRef)
	; Benchmark().StartBenchmark(2, 5000, 10)
	Log("---- START ----")

	SexLab.ClearCum(TargetRef)
	SexLab.ApplyCum(TargetRef, 1)
	Utility.Wait(3.0)
	SexLab.ClearCum(TargetRef)
	SexLab.ApplyCum(TargetRef, 2)
	Utility.Wait(3.0)
	SexLab.ClearCum(TargetRef)
	SexLab.ApplyCum(TargetRef, 3)
	Utility.Wait(3.0)
	SexLab.ClearCum(TargetRef)
	SexLab.ApplyCum(TargetRef, 4)
	Utility.Wait(3.0)
	SexLab.ClearCum(TargetRef)
	SexLab.ApplyCum(TargetRef, 5)
	Utility.Wait(3.0)
	SexLab.ClearCum(TargetRef)
	SexLab.ApplyCum(TargetRef, 6)
	Utility.Wait(3.0)
	SexLab.ClearCum(TargetRef)
	SexLab.ApplyCum(TargetRef, 7)


	; int i = SexLab.Animations.Length
	; while i
	; 	i -= 1
	; 	if SexLab.Animations[i].Registered
	; 		SexLab.Animations[i].Update_159c()
	; 	endIf
	; endWhile
	; JsonUtil.Save("../SexLab/AnimationProfile_"+SexLab.Config.AnimProfile+".json")

	; Log("---- INT ----")

	; JsonUtil.IntListAdd("AdjustTest.json", "test1", 1)
	; JsonUtil.IntListAdd("AdjustTest.json", "test1", 1)
	; Log("1+3 adjust: "+JsonUtil.IntListAdjust("AdjustTest.json", "test1", 1, 3))
	; int[] test1 = sslUtility.IntArray(JsonUtil.IntListCount("AdjustTest.json", "test1"))
	; JsonUtil.IntListSlice("AdjustTest.json", "test1", test1)
	; Log("test1: "+test1)

	; Log("---- Float ----")

	; JsonUtil.FloatListAdd("AdjustTest.json", "test2", 1)
	; JsonUtil.FloatListAdd("AdjustTest.json", "test2", 1)
	; Log("1+3 adjust: "+JsonUtil.FloatListAdjust("AdjustTest.json", "test2", 1, 3))
	; float[] test2 = sslUtility.FloatArray(JsonUtil.FloatListCount("AdjustTest.json", "test2"))
	; JsonUtil.FloatListSlice("AdjustTest.json", "test2", test2)
	; Log("test2: "+test2)

	; JsonUtil.Save("ArchiveTest.json")


	; Log(JsonUtil.GetIntValue("ArchiveTest.json", "test1"))
	; Log(JsonUtil.GetIntValue("ArchiveTest.json", "test2"))
	; Log(JsonUtil.GetFloatValue("ArchiveTest.json", "test2"))
	; Log(JsonUtil.GetFormValue("ArchiveTest.json", "TEST2"))
	; Log("strtest"+JsonUtil.GetStringValue("ArchiveTest.json", "strtest"))
	; Log("empty: "+JsonUtil.GetStringValue("ArchiveTest.json", "dfdf"))
	; Log("AdjustInt: "+JsonUtil.AdjustIntValue("ArchiveTest.json", "AdjustInt", -1))
	; Log("Adjustfloat: "+JsonUtil.AdjustFloatValue("ArchiveTest.json", "Adjustfloat", 1.5))


	; Log("CLEAR # "+JsonUtil.FloatListClear("ArchiveTest.json", "floatdeltest"))
	; Log("# "+JsonUtil.FloatListAdd("ArchiveTest.json", "floatdeltest", 8008.5))
	; Log("# "+JsonUtil.FloatListAdd("ArchiveTest.json", "floatdeltest", 8008.5))
	; Log("# "+JsonUtil.FloatListAdd("ArchiveTest.json", "floatdeltest", 8008.5))
	; Log("# "+JsonUtil.FloatListAdd("ArchiveTest.json", "floatdeltest", 13.37))
	; Log("# "+JsonUtil.FloatListAdd("ArchiveTest.json", "floatdeltest", 13.37))
	; Log("# "+JsonUtil.FloatListAdd("ArchiveTest.json", "floatdeltest", 13.37))
	; Log("# "+JsonUtil.FloatListAdd("ArchiveTest.json", "floatdeltest", 13.37))
	; Log("# "+JsonUtil.FloatListAdd("ArchiveTest.json", "floatdeltest", 8008.5))
	; Log("# "+JsonUtil.FloatListAdd("ArchiveTest.json", "floatdeltest", 13.37))
	; Log("# "+JsonUtil.FloatListAdd("ArchiveTest.json", "floatdeltest", 8008.5))
	; Log("# "+JsonUtil.FloatListAdd("ArchiveTest.json", "floatdeltest", 13.37))
	; Log("# "+JsonUtil.FloatListAdd("ArchiveTest.json", "floatdeltest", 8008.5))
	; Log("# "+JsonUtil.FloatListAdd("ArchiveTest.json", "floatdeltest", 13.37))
	; Log("# "+JsonUtil.FloatListAdd("ArchiveTest.json", "floatdeltest", 13.37))
	; Log("# "+JsonUtil.FloatListAdd("ArchiveTest.json", "floatdeltest", 8008.5))
	; Log("# "+JsonUtil.FloatListAdd("ArchiveTest.json", "floatdeltest", 8008.5))
	; Log("# "+JsonUtil.FloatListAdd("ArchiveTest.json", "floatdeltest", 8008.5))
	; Log("# "+JsonUtil.FloatListAdd("ArchiveTest.json", "floatdeltest", 8008.5))
	; Log("# "+JsonUtil.FloatListAdd("ArchiveTest.json", "floatdeltest", 13.37))
	; Log("# "+JsonUtil.FloatListAdd("ArchiveTest.json", "floatdeltest", 13.37))
	; Log("# "+JsonUtil.FloatListAdd("ArchiveTest.json", "floatdeltest", 13.37))

	; Log("floatdeltest[3]: "+JsonUtil.FloatListGet("ArchiveTest.json", "floatdeltest", 3))
	; Log("floatdeltest[3] adjust: "+JsonUtil.FloatListAdjust("ArchiveTest.json", "floatdeltest", 3, 1.33))
	; Log("floatdeltest[3]: "+JsonUtil.FloatListGet("ArchiveTest.json", "floatdeltest", 3))
	; Log("floatdeltest[3] find: "+JsonUtil.FloatListFind("ArchiveTest.json", "floatdeltest", JsonUtil.FloatListGet("ArchiveTest.json", "floatdeltest", 3)))

	; float[] stringdeltest1 = sslUtility.FloatArray(JsonUtil.FloatListCount("ArchiveTest.json", "floatdeltest"))
	; JsonUtil.FloatListSlice("ArchiveTest.json", "floatdeltest", stringdeltest1)
	; Log("Pre Delete: "+stringdeltest1)

	; Log("Deleted Single # "+JsonUtil.FloatListRemove("ArchiveTest.json", "floatdeltest", 13.37, false))
	; Log("Deleted All    # "+JsonUtil.FloatListRemove("ArchiveTest.json", "floatdeltest", 13.37, true))

	; float[] stringdeltest2 = sslUtility.FloatArray(JsonUtil.FloatListCount("ArchiveTest.json", "floatdeltest"))
	; JsonUtil.FloatListSlice("ArchiveTest.json", "floatdeltest", stringdeltest2)
	; Log("Post Delete: "+stringdeltest2)

	; JsonUtil.Save("ArchiveTest.json")

	; SexLabUtil.QuickStart(TargetRef)

	; sslBaseAnimation Anim1 = SexLab.Animations[0]
	; Log("Anim1: "+Anim1.Name)
	; Log("AddTag2(test): "+Anim1.AddTag2("test"))
	; Log("HasTag2(test): "+Anim1.HasTag2("test"))
	; Log("HasTag2(testsdf): "+Anim1.HasTag2("testsdf"))
	; Log("RemoveTag2(testsdf): "+Anim1.RemoveTag2("testsdf"))
	; Log("AddTag2(testsdf): "+Anim1.AddTag2("testsdf"))
	; Log("HasTag2(testsdf): "+Anim1.HasTag2("testsdf"))
	; Log("RemoveTag2(testsdf): "+Anim1.RemoveTag2("testsdf"))

	; sslBaseAnimation Anim2 = SexLab.Animations[1]
	; Log("Anim2: "+Anim2.Name)
	; Log("AddTag2(test): "+Anim2.AddTag2("test"))
	; Log("HasTag2(test): "+Anim2.HasTag2("test"))
	; Log("HasTag2(testsdf): "+Anim2.HasTag2("testsdf"))
	; Log("RemoveTag2(testsdf): "+Anim2.RemoveTag2("testsdf"))
	; Log("AddTag2(testsdf): "+Anim2.AddTag2("testsdf"))
	; Log("HasTag2(testsdf): "+Anim2.HasTag2("testsdf"))
	; Log("RemoveTag2(testsdf): "+Anim2.RemoveTag2("testsdf"))

	Log("---- FINISHED ----")
	Dispel()
endEvent

event OnUpdate()

endEvent

event OnEffectFinish(Actor TargetRef, Actor CasterRef)
	; Log("Debug effect spell expired("+TargetRef+", "+CasterRef+")")
endEvent


function CheckActor(Actor ActorRef, string check)
	Log(check+" -- "+ActorRef.GetLeveledActorBase().GetName()+" SexLabActors: "+StorageUtil.FormListFind(none, "SexLabActors", ActorRef))
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
	; Debug.TraceUser("SexLab", log)
	; MiscUtil.PrintConsole(ActorName+"\n"+log)
	MiscUtil.PrintConsole(log)
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

sslBenchmark function Benchmark()
	return Quest.GetQuest("SexLabDev") as sslBenchmark
endFunction
