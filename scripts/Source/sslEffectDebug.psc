Scriptname sslEffectDebug extends ActiveMagicEffect

import PapyrusUtil

SexLabFramework property SexLab Auto

Actor Ref1
Actor Ref2

float scale1
float scale2

string ActorName
ObjectReference MarkerRef

event OnEffectStart(Actor TargetRef, Actor CasterRef)


	; Benchmark().StartBenchmark(4, 10000)

	; Form PlayerRef = Game.GetPlayer()
	; Form[] Array   = Utility.CreateFormArray(5)
	; Log("Array("+Array.Length+"): "+Array)
	; Array[1] = PlayerRef
	; PapyrusUtil._SetFormValue(Array, 3, PlayerRef)
	; Log("Array("+Array.Length+"): "+Array)

	; sslBaseAnimation Animation = SexLab.GetAnimationByName("Bleagh Female Masturbation")

	; string AdjustKey = Animation.MakeAdjustKey(sslUtility.MakeActorArray(TargetRef))
	; string RaceKey = sslUtility.RemoveString(AdjustKey+".0", Animation.Key(""))

	; Log("AdjustKey: "+AdjustKey)
	; Log("RaceKey: "+RaceKey)

	; Animation.UpdateAdjustmentAll(AdjustKey, 0, 1, 0.1)
	; Animation.UpdateAdjustmentAll(AdjustKey, 0, 2, 1.5)
	; Animation.UpdateAdjustmentAll(AdjustKey, 1, 1, 0.2)
	; Animation.UpdateAdjustmentAll(AdjustKey, 1, 2, 0.25)
	; Animation.UpdateAdjustmentAll(AdjustKey, 1, 3, 0.66)
	; Animation.UpdateAdjustment(AdjustKey, 0, 1, 3, 0.33)

	; Log("JsonUtil Save(): "+JsonUtil.Save(Animation.Profile))
	; Log("SexLabUtil Save(): "+sslBaseAnimation._SaveProfile("DevProfile_1.json"))

	; float[] ppu = Animation.GetPositionAdjustments(AdjustKey, 0, 1)
	; float[] slu = sslBaseAnimation._GetStageAdjustments("DevProfile_1.json", Animation.Registry, RaceKey, 1)

	; Log("JsonUtil: "+ppu)
	; Log("SexLabUtil: "+slu)

	; string Tag = "Tag1"
	; Log("String Test: "+Tag)
	; String[] Tags = Utility.CreateStringArray(5)
	; Log("Array Init: "+Tags)
	; Tags[0] = Tag
	; Tags[1] = "Tag2"
	; Tags[2] = "Tag3"
	; Log("Array Set: "+Tags)

	; Tags = PapyrusUtil.RemoveString(Tags, "Tag2")
	; Log("RemoveString: "+Tags)
	
	; Tags[3] = "Tag4"
	; Log("Array Set 2: "+Tags)


	; Tags = Utility.CreateStringArray(0)
	; Log("Empty Init: "+Tags)
	; Log("Empty Length: "+Tags.Length)

	; Log("--------")

	; Form PlayerRef = Game.GetPlayer() as Form
	; Log("Form Test: "+PlayerRef)

	; Form[] TestArray = Utility.CreateFormArray(5)
	; Log("Array Init: "+TestArray)

	; TestArray[0] = PlayerRef
	; Log("Array Set: "+TestArray)

	; Form[] FilledArray = Utility.CreateFormArray(5, PlayerRef)
	; Log("Fill Test: "+FilledArray)
	
	; FilledArray[0] = None
	; Log("None Test: "+FilledArray)


	; sslBaseAnimation Animation = SexLab.GetAnimationByName("Bleagh Female Masturbation")
	; string racekey = MiscUtil.GetRaceEditorID(SexLab.PlayerRef.GetLeveledActorBase().GetRace())+"F.0"

	; Log("Anim: "+Animation.Name+" RaceKey: "+racekey)

	; Log("Adjust 1(-0.33) : "+sslBaseAnimation._AdjustOffset("ProfileTest1.json", Animation.Registry, racekey, 1, 0, -0.33))
	; Log("Adjust 2(0.21)  : "+sslBaseAnimation._AdjustOffset("ProfileTest1.json", Animation.Registry, racekey, 1, 1, 0.21))
	; Log("Adjust 3(1.0)   : "+sslBaseAnimation._AdjustOffset("ProfileTest1.json", Animation.Registry, racekey, 2, 0, 1.0))
	; Log("Adjust 4(-1.0)  : "+sslBaseAnimation._AdjustOffset("ProfileTest1.json", Animation.Registry, racekey, 3, 3, -1.0))
	; sslBaseAnimation._SetAdjustment("ProfileTest1.json", Animation.Registry, racekey, 3, 0, 8008.135)
	; if sslBaseAnimation._SaveProfile("ProfileTest1.json")
	; 	Log("-- Saved Profile --")
	; endIf


	; Log("Keys: "+Animation.GetAdjustKeys())


	; sslAnimationSlots AnimSlots = Game.GetFormFromFile(0x639DF, "SexLab.esm") as sslAnimationSlots

	; Alias[] Objects = AliasArray(64)
	; Log(Objects.Length+" : "+Objects)


	; Log(AnimSlots+" Alias Count: "+AnimSlots.GetNumAliases())

	; Alias Object = AnimSlots.GetNthAlias(0) as Alias
	; Log("Object: "+Object)

	; Objects = PushAlias(Objects, Object)
	; Objects[0] = Object as Alias

	; Log("Objects[0]: "+Objects[0])

	; Log(Objects.Length+" : "+Objects)

	; Log("--------")

	; Objects = new Alias[128]
	; Log(Objects.Length+" : "+Objects)


	; Log(AnimSlots+" Alias Count: "+AnimSlots.GetNumAliases())

	; Object = AnimSlots.GetNthAlias(0) as Alias
	; Log("Object: "+Object)

	; Objects[0] = Object as Alias

	; Log("Objects[0]: "+Objects[0])

	; Log(Objects.Length+" : "+Objects)

	; Log("--------")

	; string[] args = StringArray(10, "arg")
	; Log("Join(,): "+StringJoin(args))
	; Log("Join(-): "+StringJoin(args, "-"))
	; Log("Join(-D-): "+StringJoin(args, "-D-"))

	; string argstring = StringJoin(args)
	; args = StringSplit(argstring)
	; Log("Split(,): "+args.Length+" - "+args)

	; argstring = StringJoin(args, "-D-")
	; args = StringSplit(argstring, "-D-")
	; Log("Split(-D-): "+args.Length+" - "+args)


	; int[] TestArray = IntArray(30, 7)
	; Log("TestArray: "+TestArray)

	; int i = TestArray.Length
	; while i
	; 	i -= 1
	; 	TestArray[i] = i
	; endWhile


	; Log("Indexed: "+TestArray)

	; int[] SlicedArray = SliceIntArray(TestArray, 5, 10)
	; Log("Slice 5-10: "+SlicedArray)

	; SlicedArray = SliceIntArray(TestArray, 0, 10)
	; Log("Slice 0-10: "+SlicedArray)

	; SlicedArray = SliceIntArray(TestArray, 15)
	; Log("Slice 15+: "+SlicedArray)

	; SlicedArray = SliceIntArray(TestArray, 15, 40)
	; Log("Slice 15-40: "+SlicedArray)

	; SlicedArray = SliceIntArray(TestArray, 28)
	; Log("Slice 28+: "+SlicedArray)

	; SlicedArray = SliceIntArray(TestArray, 29)
	; Log("Slice 29+: "+SlicedArray)

	; SlicedArray = SliceIntArray(TestArray, 30)
	; Log("Slice 30+: "+SlicedArray)

	; SlicedArray = SliceIntArray(TestArray, 31)
	; Log("Slice 31+: "+SlicedArray)

	; SlicedArray = SliceIntArray(TestArray, 40, 20)
	; Log("Slice 40-20: "+SlicedArray)


	; Log("Count 5: "+CountInt(TestArray, 5))

	; TestArray = PushInt(TestArray, 5)
	; Log("Pushed/Count 5: "+CountInt(TestArray, 5))

	; TestArray = RemoveInt(TestArray, 5)
	; Log("Remove/Count 5: "+CountInt(TestArray, 5)+" -- "+TestArray)


	; int[] TestArray2 = IntArray(30, 5)
	; Log("TestArray: "+TestArray)
	; Log("TestArray2: "+TestArray)

	; int[] MergeArray = MergeIntArray(TestArray, TestArray2)
	; Log("MergeArray(dupes): "+MergeArray)

	; MergeArray = MergeIntArray(TestArray, TestArray2, true)
	; Log("MergeArray(remove): "+MergeArray)

	; float[] Arr = PapyrusUtil._FloatArray(6, 6.666)
	; Log(Arr.Length + " - "+Arr)
	; Arr = PapyrusUtil._PushFloat(Arr, 80085.0)
	; Log("Pushed: "+ Arr.Length + " - "+Arr)
	; Arr = PapyrusUtil._ResizeFloatArray(Arr, 10)
	; Log("Resized(10): "+ Arr.Length + " - "+Arr)
	; Arr = PapyrusUtil._ResizeFloatArray(Arr, 2)
	; Log("Resized(2): "+ Arr.Length + " - "+Arr)
	; Arr = PapyrusUtil._ResizeFloatArray(Arr, 200, 13.37)
	; Log("Resized(200): "+ Arr.Length + " - "+Arr)

	; string   str
	; string[] args

	; Log(" --- ")
	; str  = "test,te;st2,TEST3,test4;test5"
	; Log("string: "+str)
	; args = PapyrusUtil.StringExplode(str)
	; Log(" array: "+args)
	; Log(" count: "+args.Length)


	; Log(" --- ")
	; str  = "test,te;st2,TEST3,test4;test5"
	; Log("string: "+str)
	; args = PapyrusUtil.StringExplode(str, ";")
	; Log(" array: "+args)
	; Log(" count: "+args.Length)

	; Log(" --- ")
	; str  = "test,te;st2,TEST3,test4;test5"
	; Log("string: "+str)
	; args = PapyrusUtil.StringExplode(str, "TEST3")
	; Log(" array: "+args)
	; Log(" count: "+args.Length)


	; Log(" --- ")
	; str  = "test,te;st2,TEST3,test4;test5"
	; Log("string: "+str)
	; args = PapyrusUtil.StringExplode(str, ",test3,")
	; Log(" array: "+args)
	; Log(" count: "+args.Length)


	; Log(" --- ")
	; str  = "test,te;st2,TEST3,test4;test5"
	; Log("string: "+str)
	; args = PapyrusUtil.StringExplode(str, "------")
	; Log(" array: "+args)
	; Log(" count: "+args.Length)

	; Benchmark().StartBenchmark(3, 7500)

	; ; JsonUtil.Load("StringTest")
	; int i
	; string tags

	; sslBaseAnimation Anim1 = SexLab.Animations[0]

	; Log(" -- "+Anim1.Registry+" / "+Anim1.name+" -- ")

	; Anim1._Init(Anim1.Registry)
	; Anim1._SetInfo("name", Anim1.name)

	; Anim1._AddTag("Anim1TestTag_boob")
	; Anim1._AddTag("Anim1TestTag_BOOB")
	; Anim1._AddTag("Anim1TestTag_penis")
	; Anim1._AddTag("Anim1TestTag_ass")

	; Log("HasTag(Anim1TestTag_ass) == "+Anim1._HasTag("Anim1TestTag_ass")+" | "+Anim1._FindTag("Anim1TestTag_ass"))
	; Log("HasTag(Anim1TestTag_boob) == "+Anim1._HasTag("Anim1TestTag_boob")+" | "+Anim1._FindTag("Anim1TestTag_boob"))
	; Log("HasTag(Anim1TestTag_penis) == "+Anim1._HasTag("Anim1TestTag_penis")+" | "+Anim1._FindTag("Anim1TestTag_penis"))
	; Log("HasTag(Anim1TestTag_shit) == "+Anim1._HasTag("Anim1TestTag_shit")+" | "+Anim1._FindTag("Anim1TestTag_shit"))

	; Log("GetInfo(name) == "+Anim1._GetInfo("name"))
	; Log("GetInfo(fuck) == "+Anim1._GetInfo("fuck"))


	; Log("Anim1 SaveFile() == "+sslBaseAnimation._SaveFile())


	; sslBaseAnimation Anim2 = SexLab.Animations[1]

	; Log(" -- "+Anim2.Registry+" / "+Anim2.name+" -- ")

	; Anim2._Init(Anim2.Registry)
	; Anim2._SetInfo("name", Anim2.name)

	; Anim2._AddTag("Anim2TestTag_boob")
	; Anim2._AddTag("Anim2TestTag_BOOB")
	; Anim2._AddTag("Anim2TestTag_penis")
	; Anim2._AddTag("Anim2TestTag_ass")

	; Log("HasTag(Anim2TestTag_ass) == "+Anim2._HasTag("Anim2TestTag_ass")+" | "+Anim2._FindTag("Anim2TestTag_ass"))
	; Log("HasTag(Anim2TestTag_boob) == "+Anim2._HasTag("Anim2TestTag_boob")+" | "+Anim2._FindTag("Anim2TestTag_boob"))
	; Log("HasTag(Anim2TestTag_penis) == "+Anim2._HasTag("Anim2TestTag_penis")+" | "+Anim2._FindTag("Anim2TestTag_penis"))
	; Log("HasTag(Anim2TestTag_shit) == "+Anim2._HasTag("Anim2TestTag_shit")+" | "+Anim2._FindTag("Anim2TestTag_shit"))

	; Log("GetInfo(name) == "+Anim2._GetInfo("name"))
	; Log("GetInfo(fuck) == "+Anim2._GetInfo("fuck"))


	; Log("Anim2 SaveFile() == "+sslBaseAnimation._SaveFile())




	; sslBaseAnimation Anim3 = SexLab.Animations[2]

	; Log(" -- "+Anim3.Registry+" / "+Anim3.name+" -- ")

	; Anim3._Init(Anim3.Registry)
	; Anim3._SetInfo("name", Anim3.name)

	; Anim3._AddTag("Anim3TestTag_boob")
	; Anim3._AddTag("Anim3TestTag_BOOB")
	; Anim3._AddTag("Anim3TestTag_penis")
	; Anim3._AddTag("Anim3TestTag_ass")

	; Log("HasTag(Anim3TestTag_ass) == "+Anim3._HasTag("Anim3TestTag_ass")+" | "+Anim3._FindTag("Anim3TestTag_ass"))
	; Log("HasTag(Anim3TestTag_boob) == "+Anim3._HasTag("Anim3TestTag_boob")+" | "+Anim3._FindTag("Anim3TestTag_boob"))
	; Log("HasTag(Anim3TestTag_penis) == "+Anim3._HasTag("Anim3TestTag_penis")+" | "+Anim3._FindTag("Anim3TestTag_penis"))
	; Log("HasTag(Anim3TestTag_shit) == "+Anim3._HasTag("Anim3TestTag_shit")+" | "+Anim3._FindTag("Anim3TestTag_shit"))

	; Log("GetInfo(name) == "+Anim3._GetInfo("name"))
	; Log("GetInfo(fuck) == "+Anim3._GetInfo("fuck"))


	; Log("Anim3 SaveFile() == "+sslBaseAnimation._SaveFile())


	; Log("Count: "+JsonUtil.StringListCount("StringTest", "StringKey"))
	; Log("lower case=>6 - "+JsonUtil.StringListFind("StringTest", "StringKey", "case=>6"))
	; Log("upper CASE=>6 - "+JsonUtil.StringListFind("StringTest", "StringKey", "CASE=>6"))
	; Log("lower case=>15 - "+JsonUtil.StringListFind("StringTest", "StringKey", "case=>15"))
	; Log("upper CASE=>15 - "+JsonUtil.StringListFind("StringTest", "StringKey", "CASE=>15"))
	; Log("upper cASe=>18 - "+JsonUtil.StringListFind("StringTest", "StringKey", "cASe=>18"))
	; Log("upper case=>18 - "+JsonUtil.StringListFind("StringTest", "StringKey", "case=>18"))
	; Log("lower case=>29 - "+JsonUtil.StringListFind("StringTest", "StringKey", "case=>29"))
	; Log("lower case=>30 - "+JsonUtil.StringListFind("StringTest", "StringKey", "case=>30"))
	; Log("lower case=>31 - "+JsonUtil.StringListFind("StringTest", "StringKey", "case=>31"))

	; string d = " - "
	; Log("case=>6"+d+" - "+JsonUtil.StringListHas("StringTest", "StringKey", "case=>6"))
	; Log("case=>18"+d+" - "+JsonUtil.StringListHas("StringTest", "StringKey", "case=>18"))

	; int i
	; while i < 30
	; 	JsonUtil.StringListAdd("StringTest", "StringKey", "case=>"+i, false)
	; 	i += 1
	; endWhile

	; Log("Count: "+JsonUtil.StringListCount("StringTest", "StringKey"))
	; Log("upper CASE=>6 - "+JsonUtil.StringListFind("StringTest", "StringKey", "CASE=>6"))
	; Log("lower case=>6 - "+JsonUtil.StringListFind("StringTest", "StringKey", "case=>6"))
	; Log("lower case=>15 - "+JsonUtil.StringListFind("StringTest", "StringKey", "case=>15"))
	; Log("upper CASE=>15 - "+JsonUtil.StringListFind("StringTest", "StringKey", "CASE=>15"))
	; Log("upper cASe=>18 - "+JsonUtil.StringListFind("StringTest", "StringKey", "cASe=>18"))
	; Log("lower case=>29 - "+JsonUtil.StringListFind("StringTest", "StringKey", "case=>29"))
	; Log("lower case=>30 - "+JsonUtil.StringListFind("StringTest", "StringKey", "case=>30"))
	; Log("lower case=>31 - "+JsonUtil.StringListFind("StringTest", "StringKey", "case=>31"))

	; Log("case=>6"+d+" - "+JsonUtil.StringListHas("StringTest", "StringKey", "case=>6"))


	; JsonUtil.Save("StringTest")

	; JsonUtil.FormListClear("FormTest", "TestList")
	; int i = 30
	; while i < 60
	; 	Form WornForm = CasterRef.GetWornForm(Armor.GetMaskForSlot(i))
	; 	JsonUtil.FormListAdd("FormTest", "TestList", WornForm)
	; 	if WornForm
	; 		Log(WornForm+" - "+WornForm.GetFormID())
	; 	endIf
	; 	i += 1
	; endWhile

	; i = JsonUtil.FormListCount("FormTest", "TestList")
	; while i
	; 	i -= 1
	; 	Form FormRef = JsonUtil.FormListGet("FormTest", "TestList", i)
	; 	if FormRef
	; 		Log("["+i+"] "+FormRef+" - "+JsonUtil.FormListHas("FormTest", "TestList", FormRef)+"|"+JsonUtil.FormListFind("FormTest", "TestList", FormRef))
	; 	endIf
	; endWhile
	; JsonUtil.Save("FormTest")


	; Log("BigAh Before: "+SexLabUtil.GetPhoneme(TargetRef, 1))
	; Utility.WaitMenuMode(1.0)
	; TargetRef.SetExpressionPhoneme(1, 0.8)
	; Utility.WaitMenuMode(1.0)
	; Log("BigAh After: "+SexLabUtil.GetPhoneme(TargetRef, 1))

	; Utility.Wait(10.0)

	; TargetRef.SetExpressionPhoneme(1, 0.0)
	; Utility.WaitMenuMode(1.0)
	; Log("BigAh Reset: "+SexLabUtil.GetPhoneme(TargetRef, 1))


	; Benchmark().StartBenchmark(4, 20000, 10, false)
	; Benchmark().StartBenchmark(4, 20000, 10, true)


	; SexLab.RegisterForModEvent("BoobsAreKewl", "TestHook")
	; sslThreadController Thread = SexLab.GetController(2)
	; if !Thread
	; 	Debug.TraceAndBox("Failed to get thread..."+Thread)
	; else
	; 	Log("Testing with thread["+Thread.tid+"]: "+Thread)
	; 	Thread._SetupID(Thread.tid)
	; 	Thread._SendThreadEvent("BoobsAreKewl", true)
	; endIf


	; Package DoNothing = SexLab.Config.DoNothing

	; if(TargetRef == SexLab.PlayerRef)
	; 	Log("Removed Packges: "+ActorUtil.RemoveAllPackageOverride(DoNothing))

	; 	int i = SexLab.TestActors.Length
	; 	while i
	; 		i -= 1
	; 		Log("Extra Removed: "+ActorUtil.ClearPackageOverride(SexLab.TestActors[i]))
	; 		SexLab.TestActors[i].RemoveFromFaction(SexLab.AnimatingFaction)
	; 		SexLab.TestActors[i].EvaluatePackage()
	; 	endWhile

	; else

	; 	if SexLab.TestActors.find(TargetRef) == -1
	; 		PushActor(SexLab.TestActors, TargetRef)
	; 	endIf
	; 	TargetRef.StopCombat()
	; 	Log(TargetRef.GetLeveledActorBase().GetName()+" Packages["+ActorUtil.CountPackageOverride(TargetRef)+"] BEFORE")

	; 	int Priority = Utility.RandomInt(95, 100)

	; 	; if Utility.RandomInt(0, 1) == 1
	; 		ActorUtil.AddPackageOverride(TargetRef, DoNothing, Priority)
	; 		Log("Added["+Priority+"] - "+DoNothing)
	; 	; else
	; 	; 	Form TempClone = DoNothing.TempClone() as Package
	; 	; 	ActorUtil.AddPackageOverride(TargetRef, DoNothing, Priority)
	; 	; 	Log("Added["+Priority+"] - "+TempClone)
	; 	; endif
	; 	TargetRef.SetFactionRank(SexLab.AnimatingFaction, 1)
	; 	TargetRef.EvaluatePackage()

	; 	Log(TargetRef.GetLeveledActorBase().GetName()+" Packages["+ActorUtil.CountPackageOverride(TargetRef)+"]")

	; endIf


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
	; Debug.Notification(log)
	MiscUtil.PrintConsole(log)
	Debug.OpenUserLog("SexLabDebug")
	Debug.TraceUser("SexLabDebug", log)
	Debug.Trace(log)
	; MiscUtil.PrintConsole(ActorName+"\n"+log)
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
