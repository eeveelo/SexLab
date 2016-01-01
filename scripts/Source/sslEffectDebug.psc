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


	; sslBenchmark Bench = (Quest.GetQuest("SexLabDev") as sslBenchmark)
	; Bench.StartBenchmark(3, 10000, 10, (Config.BackwardsPressed() || Config.AdjustStagePressed()))

	;/ sslAnimationDefaults AnimDefaults = (Game.GetFormFromFile(0x639DF, "SexLab.esm") as sslAnimationDefaults)
	AnimDefaults.CacheAutoLoaders("../SexLab/Animations/")
	AnimDefaults.LoadCategory("Cowgirl")
	Utility.WaitMenuMode(2.0)
	AnimDefaults.LoadCategory("Cowgirl") /;

	;/ Log("Pre Count: "+StorageUtil.CountAllObjPrefix(SexLab, "objtest.")+"/"+StorageUtil.CountAllPrefix("objtest."))
	StorageUtil.SetIntValue(SexLab, "objtest.test", 1)
	StorageUtil.SetStringValue(SexLab, "objtest.test", "var")
	StorageUtil.SetStringValue(SexLab, "objtest.1", "var")
	StorageUtil.SetStringValue(SexLab, "obj.test.2", "var")
	StorageUtil.SetStringValue(none, "objtest.3", "var")
	Log("Set Count: "+StorageUtil.CountObjStringValuePrefix(SexLab, "objtest.")+"/"+StorageUtil.CountAllPrefix("objtest."))
	StorageUtil.ClearObjStringListPrefix(SexLab, "objtest.")
	Log("Integer Count: "+StorageUtil.CountObjIntValuePrefix(SexLab, "objtest.")+"/"+StorageUtil.CountIntValuePrefix("objtest."))
	Log("String Count: "+StorageUtil.CountObjStringValuePrefix(SexLab, "objtest.")+"/"+StorageUtil.CountStringValuePrefix("objtest."))
	StorageUtil.ClearAllObjPrefix(SexLab, "objtest.")
	Log("Integer Count: "+StorageUtil.CountObjIntValuePrefix(SexLab, "objtest.")+"/"+StorageUtil.CountIntValuePrefix("objtest."))
	Log("String Count: "+StorageUtil.CountObjStringValuePrefix(SexLab, "objtest.")+"/"+StorageUtil.CountStringValuePrefix("objtest."))
	StorageUtil.ClearAllObjPrefix(SexLab, "objtest.")
	StorageUtil.ClearAllObjPrefix(SexLab, "obj.test.")
	Log("Integer Count: "+StorageUtil.CountObjIntValuePrefix(SexLab, "objtest.")+"/"+StorageUtil.CountIntValuePrefix("objtest."))
	Log("String Count: "+StorageUtil.CountObjStringValuePrefix(SexLab, "objtest.")+"/"+StorageUtil.CountStringValuePrefix("objtest.")) /;

	; float time = Utility.GetCurrentRealTime()
	; Log("AllTags: "+SexLab.GetAllAnimationTags())
	; Log("Time: "+(Utility.GetCurrentRealTime() - time))
	; time = Utility.GetCurrentRealTime()
	; Log("AllTags2: "+SexLab.GetAllAnimationTags2())
	; Log("Time2: "+(Utility.GetCurrentRealTime() - time))


	; (Game.GetFormFromFile(0x639DF, "SexLab.esm") as sslAnimationDefaults).RegisterAutoLoads()

	;/ Log("\n--- Basic string test ---")
	Log(".test = "+JsonUtil.GetPathStringValue("ResolveTest", ".test", "empty"))
	Log("nested.name2 = "+JsonUtil.GetPathStringValue("ResolveTest", "nested.name2", "empty"))
	Log(".form.sexlab set = "+JsonUtil.GetPathStringValue("ResolveTest", ".form.sexlab set", "empty"))
	Log(".nested.arr[1] = "+JsonUtil.GetPathStringValue("ResolveTest", ".nested.arr[1]", "empty"))

	Log("\n--- Basic float test ---")
	Log(".floater TRUE = "+JsonUtil.IsPathNumber("ResolveTest", ".floater"))
	Log(".whole = "+JsonUtil.GetPathFloatValue("ResolveTest", ".whole", -1.1))
	Log(".floater = "+JsonUtil.GetPathFloatValue("ResolveTest", ".floater", -1.1))
	Log(".nested.nested2.name3 = "+JsonUtil.GetPathFloatValue("ResolveTest", ".nested.nested2.name3", -1.1))

	Log("\n--- Basic int test ---")
	Log(".number TRUE = "+JsonUtil.IsPathNumber("ResolveTest", ".number"))
	Log(".number = "+JsonUtil.GetPathIntValue("ResolveTest", ".number", -1))
	Log(".nested.arr[2] = "+JsonUtil.GetPathIntValue("ResolveTest", ".nested.arr[2]", -1))

	Log("\n--- Basic form test ---")
	Log(".number = "+JsonUtil.GetPathFormValue("ResolveTest", ".sexlab", CasterRef))
	Log(".number = "+JsonUtil.GetPathFormValue("ResolveTest", ".form.sexlab 1", CasterRef))
	
	Log("\n--- Basic cast test ---")
	Log("maybe = "+JsonUtil.GetPathStringValue("ResolveTest", "maybe", "empty"))
	Log(".ornot = "+JsonUtil.GetPathStringValue("ResolveTest", ".ornot", "empty"))
	Log(".number = "+JsonUtil.GetPathStringValue("ResolveTest", ".number", "empty"))
	Log(".whole = "+JsonUtil.GetPathStringValue("ResolveTest", ".whole", "empty"))
	Log(".sexlab = "+JsonUtil.GetPathStringValue("ResolveTest", ".sexlab", "empty"))
	Log(".maybe = "+JsonUtil.GetPathIntValue("ResolveTest", ".maybe", -1))
	Log(".ornot = "+JsonUtil.GetPathIntValue("ResolveTest", ".ornot", -1))
	Log(".maybe = "+JsonUtil.GetPathFloatValue("ResolveTest", ".maybe", -1.1))
	Log(".ornot = "+JsonUtil.GetPathFloatValue("ResolveTest", ".ornot", -1.1))
	Log(".number = "+JsonUtil.GetPathFloatValue("ResolveTest", ".number", -1.1))
	Log(".number = "+JsonUtil.GetPathFloatValue("ResolveTest", ".number", -1.1))
	Log(".test = "+JsonUtil.GetPathIntValue("ResolveTest", ".test", -1))
	Log(".test = "+JsonUtil.GetPathFormValue("ResolveTest", ".test", CasterRef))
	Log(".number = "+JsonUtil.GetPathFormValue("ResolveTest", ".number", CasterRef))
	Log(".maybe = "+JsonUtil.GetPathFormValue("ResolveTest", ".maybe", CasterRef))
	Log(".nested = "+JsonUtil.GetPathIntValue("ResolveTest", ".nested", -1))
	Log(".nested = "+JsonUtil.GetPathStringValue("ResolveTest", ".nested", "empty"))
	Log(".nested.arr = "+JsonUtil.GetPathIntValue("ResolveTest", ".nested.arr", -1))
	Log(".nested.arr = "+JsonUtil.GetPathStringValue("ResolveTest", ".nested.arr", "empty"))

	Log("\n--- Array/Object Test ---")
	Log(".nested TRUE = "+JsonUtil.CanResolvePath("ResolveTest", ".nested"))
	Log(".nested TRUE  = "+JsonUtil.IsPathObject("ResolveTest", ".nested"))
	Log(".nested FALSE = "+JsonUtil.IsPathArray("ResolveTest", ".nested"))
	Log(".nested.arr FALSE = "+JsonUtil.IsPathObject("ResolveTest", ".nested.arr"))
	Log(".nested.arr TRUE = "+JsonUtil.IsPathArray("ResolveTest", ".nested.arr"))
	Log(".nested FALSE = "+JsonUtil.IsPathString("ResolveTest", ".nested"))
	Log(".nested.arr FALSE = "+JsonUtil.IsPathNumber("ResolveTest", ".nested.arr"))
	Log(". TRUE = "+JsonUtil.CanResolvePath("ResolveTest", "."))
	Log(". TRUE  = "+JsonUtil.IsPathObject("ResolveTest", "."))
	Log(". FALSE = "+JsonUtil.IsPathArray("ResolveTest", "."))


	Log(". = "+JsonUtil.PathCount("ResolveTest", "."))
	Log(".nested = "+JsonUtil.PathCount("ResolveTest", ".nested"))
	Log(". = "+JsonUtil.PathMembers("ResolveTest", "."))
	Log(".nested = "+JsonUtil.PathMembers("ResolveTest", ".nested"))

	Log(".nested.arr = "+JsonUtil.PathCount("ResolveTest", ".nested.arr"))
	Log(".nested.arr = "+JsonUtil.PathStringElements("ResolveTest", ".nested.arr", "invalid"))
	Log(".nested.arr = "+JsonUtil.PathIntElements("ResolveTest", ".nested.arr", -10))
	Log(".nested.arr = "+JsonUtil.PathFloatElements("ResolveTest", ".nested.arr", -42.42)) /;

	; Log(".NESTED.name2 = "+JsonUtil.GetPathStringValue("ResolveTest", ".NESTED.name2", "empty"))
	; Log(".nested.nested2.name3 = "+JsonUtil.GetPathFloatValue("ResolveTest", ".nested.nested2.name3", -1.0))
	; Log(".nested.arr[0] = "+JsonUtil.GetPathStringValue("ResolveTest", ".nested.arr[0]", "empty"))
	; Log(".nested.arr[2] = "+JsonUtil.GetPathIntValue("ResolveTest", ".nested.arr[2]", -1))
	; Log("nested.arr[2] = "+JsonUtil.GetPathFloatValue("ResolveTest", "nested.arr[2]", -1.0))

	; Log(".number = "+JsonUtil.GetPathIntValue("ResolveTest", ".number", -1))
	; Log(".number = "+JsonUtil.GetPathStringValue("ResolveTest", ".number", "empty"))
	; Log(".test = "+JsonUtil.GetPathIntValue("ResolveTest", ".test", -1))

	; Log("\n--- Set tests ---")

	; JsonUtil.SetPathStringValue("ResolveTest", ".nested.setting.blah", "oppai")
	; Log(".nested.setting.blah oppai = "+JsonUtil.GetPathStringValue("ResolveTest", ".nested.setting.blah", "empty"))
	; JsonUtil.Save("ResolveTest")

	; JsonUtil.SetPathStringValue("ResolveTest", ".nested.setting.arr2[0]", "var1")
	; Log(".nested.setting.arr2[0] var1 = "+JsonUtil.GetPathStringValue("ResolveTest", ".nested.setting.arr2[0]", "empty"))
	; JsonUtil.Save("ResolveTest")

	;/ JsonUtil.SetPathStringValue("ResolveTest", ".nested.setting.arr2[4]", "var4")
	Log(".nested.setting.arr2[4] var4 = "+JsonUtil.GetPathStringValue("ResolveTest", ".nested.setting.arr2[4]", "empty"))
	JsonUtil.Save("ResolveTest")

	JsonUtil.SetPathStringValue("ResolveTest", ".nested.testarr[4]", "var1")
	Log(".nested.testarr[4] var1 = "+JsonUtil.GetPathStringValue("ResolveTest", ".nested.testarr[4]", "empty"))
	JsonUtil.Save("ResolveTest")
 /;

	;/ Log("\n--- Form types ---")
	JsonUtil.SetFormValue("ResolveTest", "SexLab set", SexLab)
	Log("SexLab 1 = "+JsonUtil.GetFormValue("ResolveTest", "SexLab 1"))
	; Log("SexLab 2 = "+JsonUtil.GetFormValue("ResolveTest", "SexLab 2"))
	JsonUtil.Save("ResolveTest") /;


	;/ sslBaseAnimation[] Anims = SexLab.AnimSlots.GetByTags(2, "Cowgirl")
	string[] Names = sslUtility.GetAnimationNames(Anims)
	Log(Anims)
	Log("Unshuffled("+Anims.Length+"): "+Names)
	Log("FIND NONE: "+Anims.Find(none))

	Log("----------- Shuffle 1 -----------")

	sslBaseAnimation[] Anims1 = sslUtility.ShuffleAnimations(Anims)
	string[] Names1 = sslUtility.GetAnimationNames(Anims1)
	Log("Names1: "+Names1)
	Log("shuffled NONE: "+Anims1.Find(none))
	Log("original NONE: "+Anims.Find(none))

	sslBaseAnimation[] Anims2 = sslUtility.ShuffleAnimations(Anims)
	string[] Names2 = sslUtility.GetAnimationNames(Anims2)
	Log("Names2: "+Names2)
	Log("shuffled NONE: "+Anims2.Find(none))
	Log("original NONE: "+Anims.Find(none))

	sslBaseAnimation[] Anims3 = sslUtility.ShuffleAnimations(Anims)
	string[] Names3 = sslUtility.GetAnimationNames(Anims3)
	Log("Names3: "+Names3)
	Log("shuffled NONE: "+Anims3.Find(none))
	Log("original NONE: "+Anims.Find(none))

	sslBaseAnimation[] Anims4 = sslUtility.ShuffleAnimations(Anims)
	string[] Names4 = sslUtility.GetAnimationNames(Anims4)
	Log("Names4: "+Names4)
	Log("shuffled NONE: "+Anims4.Find(none))
	Log("original NONE: "+Anims.Find(none)) /;

	;/ bool Vaginal = Utility.RandomInt(0, 2) == 2
	bool Oral = Utility.RandomInt(0, 2) == 2
	bool Anal = Utility.RandomInt(0, 2) == 2 /;
	; Log("Applying: Vaginal/"+Vaginal+" - Oral/"+Oral+" - Anal/"+Anal)
	; SexLab.AddCum(TargetRef, Vaginal, Oral, Anal)

	;/ Spell SelectedActor = Game.GetFormFromFile(0x8C5F6, "SexLab.esm") as Spell
	Utility.WaitMenuMode(8.0)
	Log(SelectedActor)
	Log("Cast 1")
	SelectedActor.Cast(TargetRef, TargetRef)
	Utility.WaitMenuMode(8.0)
	Log("Added")
	TargetRef.AddSpell(SelectedActor)
	Utility.WaitMenuMode(8.0)
	Log("Cast 2")
	SelectedActor.Cast(TargetRef, TargetRef) /;

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
