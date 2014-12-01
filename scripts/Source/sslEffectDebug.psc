Scriptname sslEffectDebug extends ActiveMagicEffect

SexLabFramework property SexLab Auto

Actor Ref1
Actor Ref2

float scale1
float scale2

string ActorName
ObjectReference MarkerRef

event OnEffectStart(Actor TargetRef, Actor CasterRef)

	; JsonUtil.Load("StringTest")


	SexLab.Expressions[0].Apply(TargetRef, 100, TargetRef.GetLeveledActorBase().GetSex())


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
