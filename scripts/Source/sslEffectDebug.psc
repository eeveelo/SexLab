Scriptname sslEffectDebug extends ActiveMagicEffect

SexLabFramework property SexLab Auto

Actor Ref1
Actor Ref2

float scale1
float scale2

string ActorName
ObjectReference MarkerRef


event OnEffectStart(Actor TargetRef, Actor CasterRef)
	Log("---- START ----")

	; JsonUtil.SetIntValue("SexLab/TestDir/TestDir2/Test.json", "TestValue", Utility.RandomInt(1,100))
	; Log("Test: "+JsonUtil.GetIntValue("SexLab/TestDir/TestDir2/Test.json", "TestValue"))
	; Log("Save: "+JsonUtil.Save("SexLab/TestDir/TestDir2/Test.json", true))

	; int i

	; string[] copy = new string[10]
	; copy[0] = "string-"+Utility.RandomInt()
	; copy[1] = "string-"+Utility.RandomInt()
	; copy[2] = "string-"+Utility.RandomInt()
	; copy[3] = "string-"+Utility.RandomInt()
	; copy[4] = "string-"+Utility.RandomInt()
	; copy[5] = "string-"+Utility.RandomInt()
	; copy[6] = "string-"+Utility.RandomInt()
	; copy[7] = "string-"+Utility.RandomInt()
	; copy[8] = "string-"+Utility.RandomInt()
	; copy[9] = "string-"+Utility.RandomInt()
	; Log("Copy: "+JsonUtil.StringListCopy("TestCopy.json", "CopyTest", copy))
	; Log("Size: "+JsonUtil.StringListCount("TestCopy.json", "CopyTest"))

	; i = 0
	; while i < 10
	; 	Log(copy[i]+" => "+JsonUtil.StringListGet("TestCopy.json", "CopyTest", i)+" = " + (copy[i] == JsonUtil.StringListGet("TestCopy.json", "CopyTest", i)))
	; 	i += 1
	; endWHile

	; Log("Change: "+JsonUtil.StringListResize("TestCopy.json", "CopyTest", 5, "NULL"))

	; i = 0
	; while i < 10
	; 	Log(copy[i]+" => "+JsonUtil.StringListGet("TestCopy.json", "CopyTest", i)+" = " + (copy[i] == JsonUtil.StringListGet("TestCopy.json", "CopyTest", i)))
	; 	i += 1
	; endWHile

	; Log("Change: "+JsonUtil.StringListResize("TestCopy.json", "CopyTest", 10, "NULL"))
	; i = 0
	; while i < 10
	; 	Log(copy[i]+" => "+JsonUtil.StringListGet("TestCopy.json", "CopyTest", i)+" = " + (copy[i] == JsonUtil.StringListGet("TestCopy.json", "CopyTest", i)))
	; 	i += 1
	; endWHile

	; Log("Cleared: "+StorageUtil.FormListClear(SexLab.PlayerRef, "Slice Test"))
	; i = 0
	; while i < 100
	; 	StorageUtil.FormListAdd(SexLab.PlayerRef, "Slice Test", SexLab)
	; 	i += 1
	; endWhile

	; Log("Slice Count: "+ StorageUtil.FormListCount(SexLab.PlayerRef, "Slice Test"))
	; form[] fslice = new form[10]
	; StorageUtil.FormListSlice(SexLab.PlayerRef, "Slice Test", fslice, 29)
	; Log("Slice: "+fslice)


	; Log("File Cleared: "+StorageUtil.FileFormListClear("File Test"))
	; i = 0
	; while i < 40
	; 	StorageUtil.FileFormListAdd("File Test", SexLab)
	; 	i += 1
	; endWhile

	; Log("File Slice Count: "+ StorageUtil.FileFormListCount("File Test"))
	; form[] islice = new form[10]
	; StorageUtil.FileFormListSlice("File Test", islice, 19)
	; Log("File Slice: "+islice)


	; Log("JSON Cleared: "+JsonUtil.FormListClear("SliceTest.json", "Slice Test"))
	; i = 0
	; while i < 40
	; 	JsonUtil.FormListAdd("SliceTest.json", "Slice Test", SexLab.PlayerRef)
	; 	i += 1
	; endWhile

	; Log("JSON Slice Count: "+ JsonUtil.FormListCount("SliceTest.json", "Slice Test"))
	; form[] fjslice = new form[10]
	; JsonUtil.FormListSlice("SliceTest.json", "Slice Test", fjslice, 9)
	; Log("JSON Slice: "+fslice)
	; string objString = PapyrusUtil.ToString(SexLab)
	; Log(SexLab + " => "+ objString)
	; form obj = PapyrusUtil.ToForm(objString)
	; Log(obj + " => "+(obj == SexLab))

	; objString = PapyrusUtil.ToString(SexLab.Config.CumVaginalSpell)
	; Log(SexLab.Config.CumVaginalSpell + " => "+ objString)
	; obj = PapyrusUtil.ToForm(objString)
	; Log(obj + " => "+(obj == SexLab.Config.CumVaginalSpell))

	; objString = PapyrusUtil.ToString(SexLab.PlayerRef)
	; Log(SexLab.PlayerRef + " => "+ objString)
	; obj = PapyrusUtil.ToForm(objString)
	; Log(obj + " => "+(obj == SexLab.PlayerRef))

	; objString = PapyrusUtil.ToString(none)
	; Log(none + " => "+ objString)
	; obj = PapyrusUtil.ToForm(objString)
	; Log(obj + " => "+(obj == none))

	; Log("-- String Test ---")
	; Log("Count: "+StorageUtil.StringListCount(SexLab, "TESTADD"))
	; Log("Index: "+StorageUtil.StringListFind(SexLab, "TESTADD", "FGD"))
	; Log("Has: "+StorageUtil.StringListHas(SexLab, "TESTADD", "FgD"))

	; Log("Unique: " + StorageUtil.StringListAdd(SexLab, "TestAdd", "fgd"+Utility.RandomInt(), true))
	; Log("Unique: " + StorageUtil.StringListAdd(SexLab, "TestAdd", "fgd"+Utility.RandomInt(), true))
	; Log("Unique: " + StorageUtil.StringListAdd(SexLab, "TestAdd", "fgd"+Utility.RandomInt(), true))
	; Log("Unique: " + StorageUtil.StringListAdd(SexLab, "TestAdd", "fgd"+Utility.RandomInt(), true))
	; Log("Unique: " + StorageUtil.StringListAdd(SexLab, "TestAdd", "fgd"+Utility.RandomInt(), true))
	; Log("Unique: " + StorageUtil.StringListAdd(SexLab, "TestAdd", "fgd"+Utility.RandomInt(), true))
	; Log("DUPE: " + StorageUtil.StringListAdd(SexLab, "TestAdd", "fgd", false))
	; Log("DUPE: " + StorageUtil.StringListAdd(SexLab, "TestAdd", "fgd", false))
	; Log("DUPE: " + StorageUtil.StringListAdd(SexLab, "TestAdd", "fgd", false))
	; Log("Unique: " + StorageUtil.StringListAdd(SexLab, "TestAdd", "fgd"+Utility.RandomInt(), true))

	; Log("-- Form Test ---")
	; form uniqef = SexLab
	; form dupef = SexLab.Config.ActorTypeNPC
	; Log("Count: "+StorageUtil.FormListCount(SexLab, "TESTADD"))
	; Log("Index: "+StorageUtil.FormListFind(SexLab, "TESTADD", dupef))
	; Log("Has: "+StorageUtil.FormListHas(SexLab, "TESTADD", dupef))

	; Log("Unique: " + StorageUtil.FormListAdd(SexLab, "TestAdd", uniqef, true))
	; Log("Unique: " + StorageUtil.FormListAdd(SexLab, "TestAdd", uniqef, true))
	; Log("Unique: " + StorageUtil.FormListAdd(SexLab, "TestAdd", uniqef, true))
	; Log("Unique: " + StorageUtil.FormListAdd(SexLab, "TestAdd", uniqef, true))
	; Log("Unique: " + StorageUtil.FormListAdd(SexLab, "TestAdd", uniqef, true))
	; Log("Unique: " + StorageUtil.FormListAdd(SexLab, "TestAdd", uniqef, true))
	; Log("DUPE: " + StorageUtil.FormListAdd(SexLab, "TestAdd", dupef, false))
	; Log("DUPE: " + StorageUtil.FormListAdd(SexLab, "TestAdd", dupef, false))
	; Log("DUPE: " + StorageUtil.FormListAdd(SexLab, "TestAdd", dupef, false))
	; Log("Unique: " + StorageUtil.FormListAdd(SexLab, "TestAdd", uniqef, true))

	; Log("-- int Test ---")
	; int uniqei = 69
	; int dupei = -521
	; Log("Count: "+StorageUtil.IntListCount(SexLab, "TESTADD"))
	; Log("Index: "+StorageUtil.IntListFind(SexLab, "TESTADD", dupei))
	; Log("Has: "+StorageUtil.IntListHas(SexLab, "TESTADD", dupei))

	; Log("Unique: " + StorageUtil.IntListAdd(SexLab, "TestAdd", uniqei, true))
	; Log("Unique: " + StorageUtil.IntListAdd(SexLab, "TestAdd", uniqei, true))
	; Log("Unique: " + StorageUtil.IntListAdd(SexLab, "TestAdd", uniqei, true))
	; Log("Unique: " + StorageUtil.IntListAdd(SexLab, "TestAdd", uniqei, true))
	; Log("Unique: " + StorageUtil.IntListAdd(SexLab, "TestAdd", uniqei, true))
	; Log("Unique: " + StorageUtil.IntListAdd(SexLab, "TestAdd", uniqei, true))
	; Log("DUPE: " + StorageUtil.IntListAdd(SexLab, "TestAdd", dupei, false))
	; Log("DUPE: " + StorageUtil.IntListAdd(SexLab, "TestAdd", dupei, false))
	; Log("DUPE: " + StorageUtil.IntListAdd(SexLab, "TestAdd", dupei, false))
	; Log("Unique: " + StorageUtil.IntListAdd(SexLab, "TestAdd", uniqei, true))




	; Log("-- File String Test ---")
	; Log("Count: "+StorageUtil.FileStringListCount("TESTADD"))
	; Log("Index: "+StorageUtil.FileStringListFind("TESTADD", "FGD"))
	; Log("Has: "+StorageUtil.FileStringListHas("TESTADD", "FgD"))

	; Log("Unique: " + StorageUtil.FileStringListAdd("TestAdd", "fgd"+Utility.RandomInt(), true))
	; Log("Unique: " + StorageUtil.FileStringListAdd("TestAdd", "fgd"+Utility.RandomInt(), true))
	; Log("Unique: " + StorageUtil.FileStringListAdd("TestAdd", "fgd"+Utility.RandomInt(), true))
	; Log("Unique: " + StorageUtil.FileStringListAdd("TestAdd", "fgd"+Utility.RandomInt(), true))
	; Log("Unique: " + StorageUtil.FileStringListAdd("TestAdd", "fgd"+Utility.RandomInt(), true))
	; Log("Unique: " + StorageUtil.FileStringListAdd("TestAdd", "fgd"+Utility.RandomInt(), true))
	; Log("DUPE: " + StorageUtil.FileStringListAdd("TestAdd", "fgd", false))
	; Log("DUPE: " + StorageUtil.FileStringListAdd("TestAdd", "fgd", false))
	; Log("DUPE: " + StorageUtil.FileStringListAdd("TestAdd", "fgd", false))
	; Log("Unique: " + StorageUtil.FileStringListAdd("TestAdd", "fgd"+Utility.RandomInt(), true))

	; Log("-- File Form Test ---")
	; Log("Count: "+StorageUtil.FileFormListCount("TESTADD"))
	; Log("Index: "+StorageUtil.FileFormListFind("TESTADD", dupef))
	; Log("Has: "+StorageUtil.FileFormListHas("TESTADD", dupef))

	; Log("Unique: " + StorageUtil.FileFormListAdd("TestAdd", uniqef, true))
	; Log("Unique: " + StorageUtil.FileFormListAdd("TestAdd", uniqef, true))
	; Log("Unique: " + StorageUtil.FileFormListAdd("TestAdd", uniqef, true))
	; Log("Unique: " + StorageUtil.FileFormListAdd("TestAdd", uniqef, true))
	; Log("Unique: " + StorageUtil.FileFormListAdd("TestAdd", uniqef, true))
	; Log("Unique: " + StorageUtil.FileFormListAdd("TestAdd", uniqef, true))
	; Log("DUPE: " + StorageUtil.FileFormListAdd("TestAdd", dupef, false))
	; Log("DUPE: " + StorageUtil.FileFormListAdd("TestAdd", dupef, false))
	; Log("DUPE: " + StorageUtil.FileFormListAdd("TestAdd", dupef, false))
	; Log("Unique: " + StorageUtil.FileFormListAdd("TestAdd", uniqef, true))

	; Log("-- File int Test ---")
	; Log("Count: "+StorageUtil.FileIntListCount("TESTADD"))
	; Log("Index: "+StorageUtil.FileIntListFind("TESTADD", dupei))
	; Log("Has: "+StorageUtil.FileIntListHas("TESTADD", dupei))

	; Log("Unique: " + StorageUtil.FileIntListAdd("TestAdd", uniqei, true))
	; Log("Unique: " + StorageUtil.FileIntListAdd("TestAdd", uniqei, true))
	; Log("Unique: " + StorageUtil.FileIntListAdd("TestAdd", uniqei, true))
	; Log("Unique: " + StorageUtil.FileIntListAdd("TestAdd", uniqei, true))
	; Log("Unique: " + StorageUtil.FileIntListAdd("TestAdd", uniqei, true))
	; Log("Unique: " + StorageUtil.FileIntListAdd("TestAdd", uniqei, true))
	; Log("DUPE: " + StorageUtil.FileIntListAdd("TestAdd", dupei, false))
	; Log("DUPE: " + StorageUtil.FileIntListAdd("TestAdd", dupei, false))
	; Log("DUPE: " + StorageUtil.FileIntListAdd("TestAdd", dupei, false))
	; Log("Unique: " + StorageUtil.FileIntListAdd("TestAdd", uniqei, true))



	; Idle IdleRef1 = Game.GetForm(0xD8730) as Idle
	; Idle IdleRef2 = Game.GetForm(0xD8731) as Idle

	; Log("Idle: "+IdleRef1)
	; Log("Idle: "+IdleRef2)

	; ObjectUtil.SetReplaceAnimation(CasterRef, "JumpStandingStart", IdleRef1)
	; ObjectUtil.SetReplaceAnimation(CasterRef, "Missionary_A2_S1", IdleRef2)


	; int i = ObjectUtil.CountReplaceAnimation(CasterRef)
	; Log("Count: "+i)
	; while i
	; 	i -= 1
	; 	Log(ObjectUtil.GetKeyReplaceAnimation(CasterRef, i)+" -> "+ObjectUtil.GetValueReplaceAnimation(CasterRef, ObjectUtil.GetKeyReplaceAnimation(CasterRef, i)))
	; endWhile

	; Utility.Wait(15.0)
	; Log("Removing: "+ObjectUtil.RemoveReplaceAnimation(CasterRef, "Missionary_A2_S1"))
	; Log("Removing: "+ObjectUtil.RemoveReplaceAnimation(CasterRef, "Missionary_A2_S56"))
	; Log("Count: "+ObjectUtil.CountReplaceAnimation(CasterRef))
	; Utility.Wait(5.0)
	; Log("Clearing: "+ObjectUtil.ClearReplaceAnimation(CasterRef))
	; Log("Count: "+ObjectUtil.CountReplaceAnimation(CasterRef))
	; ObjectUtil.SetReplaceAnimation(CasterRef, "Missionary_A2_S1", IdleRef2)
	; Log("Clearing: "+ObjectUtil.ClearReplaceAnimation(CasterRef))
	; Log("Count: "+ObjectUtil.CountReplaceAnimation(CasterRef))


	; Utility.Wait(2.0)
	; CasterRef.PlayIdle(IdleRef)
	; Utility.Wait(6.0)
	; Log("Replacing")
	; ObjectUtil.SetReplaceAnimation(CasterRef, "JumpStandingStart", IdleRef)
	; Utility.Wait(10.0)
	; Log("Removing Replacer: "+ObjectUtil.RemoveReplaceAnimation(CasterRef, "JumpStandingStart"))


	; ActorUtil.AddPackageOverride(TargetRef, SexLab.ActorLib.DoNothing, 100)
	; TargetRef.SetFactionRank(SexLab.AnimatingFaction, 1)
	; TargetRef.EvaluatePackage()

	; Utility.Wait(6.0)
	; ActorUtil.ClearPackageOverride(TargetRef)
	; TargetRef.RemoveFromFaction(SexLab.AnimatingFaction)
	; TargetRef.EvaluatePackage()


	; ActorUtil.AddPackageOverride(TargetRef, SexLab.ActorLib.DoNothing, 100, 1)
	; TargetRef.EvaluatePackage()
	; Utility.Wait(6.0)
	; ActorUtil.RemovePackageOverride(TargetRef, SexLab.ActorLib.DoNothing)
	; TargetRef.EvaluatePackage()

	; Log("Unlocked")

	; Log("adding")

	; JsonUtil.FloatListAdd("AnimationProfile_Test1.json", "BlahtestBNlah", Utility.RandomFloat(-5.0, 5.0))
	; JsonUtil.FloatListAdd("AnimationProfile_Test1.json", "BlahtestBNlah", Utility.RandomFloat(-5.0, 5.0))
	; JsonUtil.FloatListAdd("AnimationProfile_Test1.json", "BlahtestBNlah", Utility.RandomFloat(-5.0, 5.0))
	; JsonUtil.FloatListAdd("AnimationProfile_Test1.json", "BlahtestBNlah", Utility.RandomFloat(-5.0, 5.0))
	; JsonUtil.FloatListAdd("AnimationProfile_Test1.json", "BlahtestBNlah", Utility.RandomFloat(-5.0, 5.0))
	; JsonUtil.FloatListAdd("AnimationProfile_Test1.json", "BlahtestBNlah", Utility.RandomFloat(-5.0, 5.0))
	; JsonUtil.FloatListAdd("AnimationProfile_Test1.json", "BlahtestBNlah", Utility.RandomFloat(-5.0, 5.0))
	; JsonUtil.FloatListAdd("AnimationProfile_Test1.json", "BlahtestBNlah", Utility.RandomFloat(-5.0, 5.0))

	; Log("1")

	; JsonUtil.FloatListAdd("AnimationProfile_Test2", "BlahtestBNlah", Utility.RandomFloat(10.0, 20.0))
	; JsonUtil.FloatListAdd("AnimationProfile_Test2", "BlahtestBNlah", Utility.RandomFloat(10.0, 20.0))
	; JsonUtil.FloatListAdd("AnimationProfile_Test2", "BlahtestBNlah", Utility.RandomFloat(10.0, 20.0))

	; Log("2")

	; JsonUtil.FloatListAdd("AnimationProfile_Test1.json", "BlahtestBNlah", Utility.RandomFloat(-5.0, 5.0))
	; JsonUtil.FloatListAdd("AnimationProfile_Test1.json", "BlahtestBNlah", Utility.RandomFloat(-5.0, 5.0))
	; JsonUtil.FloatListAdd("AnimationProfile_Test1.json", "BlahtestBNlah", Utility.RandomFloat(-5.0, 5.0))
	; JsonUtil.FloatListAdd("AnimationProfile_Test1.json", "BlahtestBNlah", Utility.RandomFloat(-5.0, 5.0))
	; JsonUtil.FloatListAdd("AnimationProfile_Test1.json", "BlahtestBNlah", Utility.RandomFloat(-5.0, 5.0))

	; Log("3")

	; JsonUtil.FloatListAdd("AnimationProfile_Test2", "BlahtestBNlah", Utility.RandomFloat(10.0, 20.0))
	; JsonUtil.FloatListAdd("AnimationProfile_Test2", "BlahtestBNlah", Utility.RandomFloat(10.0, 20.0))
	; JsonUtil.FloatListAdd("AnimationProfile_Test2", "BlahtestBNlah", Utility.RandomFloat(10.0, 20.0))
	; JsonUtil.FloatListAdd("AnimationProfile_Test2", "BlahtestBNlah", Utility.RandomFloat(10.0, 20.0))
	; JsonUtil.FloatListAdd("AnimationProfile_Test2", "BlahtestBNlah", Utility.RandomFloat(10.0, 20.0))
	; JsonUtil.FloatListAdd("AnimationProfile_Test2", "BlahtestBNlah", Utility.RandomFloat(10.0, 20.0))
	; JsonUtil.FloatListAdd("AnimationProfile_Test2", "BlahtestBNlah", Utility.RandomFloat(10.0, 20.0))
	; JsonUtil.FloatListAdd("AnimationProfile_Test2", "BlahtestBNlah", Utility.RandomFloat(10.0, 20.0))
	; JsonUtil.FloatListAdd("AnimationProfile_Test2", "BlahtestBNlah", Utility.RandomFloat(10.0, 20.0))
	; JsonUtil.FloatListAdd("AnimationProfile_Test2", "BlahtestBNlah", Utility.RandomFloat(10.0, 20.0))

	; Log("4")


	; JsonUtil.FloatListAdd("AnimationProfile_Test1.json", "BlahtestBNlah", Utility.RandomFloat(-5.0, 5.0))
	; JsonUtil.FloatListAdd("AnimationProfile_Test1.json", "BlahtestBNlah", Utility.RandomFloat(-5.0, 5.0))
	; JsonUtil.FloatListAdd("AnimationProfile_Test1.json", "BlahtestBNlah", Utility.RandomFloat(-5.0, 5.0))
	; JsonUtil.FloatListAdd("AnimationProfile_Test1.json", "BlahtestBNlah", Utility.RandomFloat(-5.0, 5.0))
	; JsonUtil.FloatListAdd("AnimationProfile_Test1.json", "BlahtestBNlah", Utility.RandomFloat(-5.0, 5.0))

	; Log("5")

	; JsonUtil.FormListAdd("AnimationProfile_Test1.json", "fuckekr", SexLab.PlayerRef)
	; JsonUtil.FormListAdd("AnimationProfile_Test1.json", "fuckekr", SexLab)
	; JsonUtil.FormListAdd("AnimationProfile_Test1.json", "fuckekr", SexLab.PlayerRef)
	; JsonUtil.FormListAdd("AnimationProfile_Test1.json", "fuckekr", SexLab)
	; JsonUtil.FormListAdd("AnimationProfile_Test1.json", "fuckekr", SexLab.PlayerRef)
	; Log("Values Added")



	; Log("Profile 1: " + JsonUtil.FloatListCount("AnimationProfile_Test1.json", "BlahtestBNlah"))
	; Log("Profile 2: " + JsonUtil.FloatListCount("AnimationProfile_Test2", "BlahtestBNlah"))
	; Log("Profile NOSAVE: " + JsonUtil.FloatListGet("AnimationProfile_NOSAVE.json", "BlahtestBNlah", 0))
	; Log("Profile NOSAVE: " + JsonUtil.FloatListGet("AnimationProfile_NOSAVE.json", "BlahtestBNlah", 1))
	; Log("Profile NOSAVE: " + JsonUtil.FloatListGet("AnimationProfile_NOSAVE.json", "BlahtestBNlah", 2))
	; Log("Profile NOSAVE: " + JsonUtil.FloatListGet("AnimationProfile_NOSAVE.json", "BlahtestBNlah", 3))

	; ; JsonUtil.Save("AnimationProfile_Test1.json", true)
	; JsonUtil.Save("AnimationProfile_Test2", false)

	; ; Debug.OpenUserLog("SexLab")
	; ; Quest Monitor = Quest.GetQuest("sla_Monitor")
	; ; Dev.RegisterForModEvent("HookAnimationChange_DevTest", "Hook")
	; ; SexLab.QuickStart(CasterRef, TargetRef, Hook = "DevTest")
	; Log("----------")

	; Log("Previous IntTest: "+SexLabUtil.GetIntValue(none, "IntTest"))
	; Log("Previous FloatTest: "+SexLabUtil.GetFloatValue(SexLab, "FloatTest"))
	; Log("Previous StringTest: "+SexLabUtil.GetStringValue(SexLab, "StringTest"))
	; Log("Previous FormTest: "+SexLabUtil.GetFormValue(none, "FormTest"))


	; SexLabUtil.SetIntValue(none, "IntTest", Utility.RandomInt())
	; SexLabUtil.SetFloatValue(SexLab, "FloatTest", Utility.RandomFloat())
	; SexLabUtil.SetStringValue(SexLab, "StringTest", "fuck-"+Utility.RandomInt())
	; SexLabUtil.SetFormValue(none, "FormTest", SexLab.Config.CumVaginalKeyword)

	; Log("Current IntTest: "+SexLabUtil.GetIntValue(none, "IntTest"))
	; Log("Current FloatTest: "+SexLabUtil.GetFloatValue(SexLab, "FloatTest"))
	; Log("Current StringTest: "+SexLabUtil.GetStringValue(SexLab, "StringTest"))
	; Log("Current FormTest: "+SexLabUtil.GetFormValue(none, "FormTest"))

	; Log("Value Test Previous: "+SexLabUtil.GetIntValue(TargetRef, "TestValue"))
	; Log("Value Test Set: "+SexLabUtil.SetIntValue(TargetRef, "TestValue", Utility.RandomInt()))
	; Log("Value Test Get: "+SexLabUtil.GetIntValue(TargetRef, "TestValue"))

	; sslSystemConfig Config = SexLabUtil.GetConfig()
	; Actor PlayerRef = Game.GetPlayer()


	; Log("------- Setting -------")

	; int[] index = new int[3]
	; index[0] = SexLabUtil.IntListAdd(SexLab, "fuck", Utility.RandomInt())
	; index[1] = SexLabUtil.IntListAdd(SexLab, "fuck", Utility.RandomInt())
	; index[2] = SexLabUtil.IntListAdd(SexLab, "fuck", Utility.RandomInt())
	; Log("Add: "+index[0])
	; Log("Add: "+index[1])
	; Log("Add: "+index[2])
	; Log("Get: "+SexLabUtil.IntListGet(SexLab, "fuck", index[0]))
	; Log("Get: "+SexLabUtil.IntListGet(SexLab, "fuck", index[1]))
	; Log("Get: "+SexLabUtil.IntListGet(SexLab, "fuck", index[2]))

	; Log("EMPTY FLOAT GET" + SexLabUtil.FloatListGet(SexLab, "empty float", 2))
	; Log("EMPTY STRING GET" + SexLabUtil.StringListGet(SexLab, "empty string", 0))

	; SexLabUtil.FormListAdd(SexLab, "FormTest", SexLab)
	; SexLabUtil.FormListAdd(SexLab, "FormTest", SexLab)
	; SexLabUtil.FormListAdd(SexLab, "FormTest", PlayerRef)
	; SexLabUtil.FormListAdd(SexLab, "FormTest", PlayerRef)
	; SexLabUtil.FormListAdd(SexLab, "FormTest", SexLab)
	; SexLabUtil.FormListAdd(SexLab, "FormTest", SexLab)
	; SexLabUtil.FormListAdd(SexLab, "FormTest", SexLab)
	; SexLabUtil.FormListAdd(SexLab, "FormTest", SexLab)
	; SexLabUtil.FormListAdd(SexLab, "FormTest", PlayerRef)
	; SexLabUtil.FormListAdd(SexLab, "FormTest", SexLab)


	; SexLabUtil.StringListAdd(SexLab, "rEMOVEtEST", "CAPS")
	; SexLabUtil.StringListAdd(SexLab, "rEMOVEtEST", "caps")
	; SexLabUtil.StringListAdd(SexLab, "rEMOVEtEST", "CAPS")
	; SexLabUtil.StringListAdd(SexLab, "rEMOVEtEST", "CAPS")
	; SexLabUtil.StringListAdd(SexLab, "rEMOVEtEST", "CAPS")
	; SexLabUtil.StringListAdd(SexLab, "rEMOVEtEST", "CAPS")
	; SexLabUtil.StringListAdd(SexLab, "rEMOVEtEST", "CAPS")
	; SexLabUtil.StringListAdd(SexLab, "rEMOVEtEST", "caps")
	; SexLabUtil.StringListAdd(SexLab, "rEMOVEtEST", "caps")
	; SexLabUtil.StringListAdd(SexLab, "rEMOVEtEST", "CAPS")
	; SexLabUtil.StringListAdd(SexLab, "rEMOVEtEST", "caps")
	; SexLabUtil.StringListAdd(SexLab, "rEMOVEtEST", "CAPS")
	; SexLabUtil.StringListAdd(SexLab, "rEMOVEtEST", "caps")
	; SexLabUtil.StringListAdd(SexLab, "rEMOVEtEST", "CAPS")
	; SexLabUtil.StringListAdd(SexLab, "rEMOVEtEST", "CAPS")
	; SexLabUtil.StringListAdd(SexLab, "rEMOVEtEST", "CAPS")
	; SexLabUtil.StringListAdd(SexLab, "rEMOVEtEST", "caps")
	; SexLabUtil.StringListAdd(SexLab, "rEMOVEtEST", "CAPS")
	; SexLabUtil.StringListAdd(SexLab, "rEMOVEtEST", "caps")
	; SexLabUtil.StringListAdd(SexLab, "rEMOVEtEST", "caps")
	; Log("String CAPS removed" + SexLabUtil.StringListRemove(SexLab, "rEMOVEtEST", "CAPS", true))

	; Log("Form REMOVED SexLab" + SexLabUtil.FormListRemove(SexLab, "FormTest", SexLab, true))
	; Log("Form REMOVED PlayerRef" + SexLabUtil.FormListRemove(SexLab, "FormTest", PlayerRef, false))


	; Log("------- Global File -------")

	; index = new int[3]
	; index[0] = SexLabUtil.FileIntListAdd("fuck", Utility.RandomInt())
	; index[1] = SexLabUtil.FileIntListAdd("fuck", Utility.RandomInt())
	; index[2] = SexLabUtil.FileIntListAdd("fuck", Utility.RandomInt())
	; Log("Add: "+index[0])
	; Log("Add: "+index[1])
	; Log("Add: "+index[2])
	; Log("Get: "+SexLabUtil.FileIntListGet("fuck", index[0]))
	; Log("Get: "+SexLabUtil.FileIntListGet("fuck", index[1]))
	; Log("Get: "+SexLabUtil.FileIntListGet("fuck", index[2]))

	; Log("EMPTY FLOAT GET" + SexLabUtil.FileFloatListGet("empty float", 2))
	; Log("EMPTY STRING GET" + SexLabUtil.FileStringListGet("empty string", 0))

	; SexLabUtil.FileFormListAdd("FormTest", SexLab)
	; SexLabUtil.FileFormListAdd("FormTest", SexLab)
	; SexLabUtil.FileFormListAdd("FormTest", PlayerRef)
	; SexLabUtil.FileFormListAdd("FormTest", PlayerRef)
	; SexLabUtil.FileFormListAdd("FormTest", SexLab)
	; SexLabUtil.FileFormListAdd("FormTest", SexLab)
	; SexLabUtil.FileFormListAdd("FormTest", SexLab)
	; SexLabUtil.FileFormListAdd("FormTest", SexLab)
	; SexLabUtil.FileFormListAdd("FormTest", PlayerRef)
	; SexLabUtil.FileFormListAdd("FormTest", SexLab)


	; SexLabUtil.FileStringListAdd("rEMOVEtEST", "CAPS")
	; SexLabUtil.FileStringListAdd("rEMOVEtEST", "caps")
	; SexLabUtil.FileStringListAdd("rEMOVEtEST", "CAPS")
	; SexLabUtil.FileStringListAdd("rEMOVEtEST", "CAPS")
	; SexLabUtil.FileStringListAdd("rEMOVEtEST", "CAPS")
	; SexLabUtil.FileStringListAdd("rEMOVEtEST", "CAPS")
	; SexLabUtil.FileStringListAdd("rEMOVEtEST", "CAPS")
	; SexLabUtil.FileStringListAdd("rEMOVEtEST", "caps")
	; SexLabUtil.FileStringListAdd("rEMOVEtEST", "caps")
	; SexLabUtil.FileStringListAdd("rEMOVEtEST", "CAPS")
	; SexLabUtil.FileStringListAdd("rEMOVEtEST", "caps")
	; SexLabUtil.FileStringListAdd("rEMOVEtEST", "CAPS")
	; SexLabUtil.FileStringListAdd("rEMOVEtEST", "caps")
	; SexLabUtil.FileStringListAdd("rEMOVEtEST", "CAPS")
	; SexLabUtil.FileStringListAdd("rEMOVEtEST", "CAPS")
	; SexLabUtil.FileStringListAdd("rEMOVEtEST", "CAPS")
	; SexLabUtil.FileStringListAdd("rEMOVEtEST", "caps")
	; SexLabUtil.FileStringListAdd("rEMOVEtEST", "CAPS")
	; SexLabUtil.FileStringListAdd("rEMOVEtEST", "caps")
	; SexLabUtil.FileStringListAdd("rEMOVEtEST", "caps")
	; Log("String CAPS removed" + SexLabUtil.FileStringListRemove("rEMOVEtEST", "CAPS", true))

	; Log("Form REMOVED SexLab" + SexLabUtil.FileFormListRemove("FormTest", SexLab, true))
	; Log("Form REMOVED PlayerRef" + SexLabUtil.FileFormListRemove("FormTest", PlayerRef, false))


	; Utility.Wait(10.0)
	; (Quest.GetQuest("SexLabDev") as sslBenchmark).StartBenchmark(2, 500)

	; Utility.Wait(10.0)

	; Log("Form REMOVED PlayerRef ALL" + SexLabUtil.FileFormListRemove("FormTest", PlayerRef, true))

	; Log("Int Signed - "+SexLabUtil.FileSetInt("Int Signed", Utility.RandomInt(-300,-1)))
	; Log("Int Unsigned - "+SexLabUtil.FileSetInt("Int Unsigned", Utility.RandomInt()))
	; Log("FormID - "+SexLabUtil.FileSetInt("FormID", SexLab.GetFormID()))

	; Log("Float Signed - "+SexLabUtil.FileSetFloat("Float Signed", Utility.RandomFloat(-300,-1)))
	; Log("Float Unsigned - "+SexLabUtil.FileSetFloat("Float Unsigned", Utility.RandomInt()))

	; Log("StringTest - "+SexLabUtil.FileSetString("StringTest", "Title Case"))
	; Log("stringtest - "+SexLabUtil.FileSetString("stringtest", "lower case"))

	; Log("Form SexLab - "+SexLabUtil.FileSetForm("Form SexLab", SexLab))
	; Log("Form Config - "+SexLabUtil.FileSetForm("Form Config", SexLab.Config))
	; Log("Form PlayerRef - "+SexLabUtil.FileSetForm("Form PlayerRef", SexLab.PlayerRef))
	; Log("Form ActorTypeNPC - "+SexLabUtil.FileSetForm("Form ActorTypeNPC", SexLab.Config.ActorTypeNPC))
	; Log("Form none - "+SexLabUtil.FileSetForm("Form none", none))

	; Log("------- GET -------")
	; Log("Int Signed - "+SexLabUtil.FileGetInt("Int Signed"))
	; Log("Int Unsigned - "+SexLabUtil.FileGetInt("Int Unsigned"))
	; Log("FormID - "+SexLabUtil.FileGetInt("FormID"))

	; Log("Float Signed - "+SexLabUtil.FileGetFloat("Float Signed"))
	; Log("Float Unsigned - "+SexLabUtil.FileGetFloat("Float Unsigned"))

	; Log("StringTest - "+SexLabUtil.FileGetString("StringTest"))
	; Log("stringtest - "+SexLabUtil.FileGetString("stringtest"))

	; Log("Form SexLab - "+SexLabUtil.FileGetForm("Form SexLab"))
	; Log("Form Config - "+SexLabUtil.FileGetForm("Form Config"))
	; Log("Form PlayerRef - "+SexLabUtil.FileGetForm("Form PlayerRef"))
	; Log("Form ActorTypeNPC - "+SexLabUtil.FileGetForm("Form ActorTypeNPC"))
	; Log("Form none - "+SexLabUtil.FileGetForm("Form none"))

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
