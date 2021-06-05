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



event OnEffectStart(Actor TargetRef, Actor CasterRef)
	SexLab.QuickStart(CasterRef, TargetRef)


	; Log("CheckFriend(TargetRef) 1: "+CheckFriend(TargetRef))
	; Log("CheckFriend(CasterRef) 1: "+CheckFriend(CasterRef))
	; ; Utility.Wait(1.0)
	; SetFriend(TargetRef, CasterRef)
	; SetFriend(CasterRef, TargetRef)
	; Log("SetFriend")
	; ; Utility.Wait(1.0)
	; Log("CheckFriend(TargetRef) 2: "+CheckFriend(TargetRef))
	; Log("CheckFriend(CasterRef) 2: "+CheckFriend(CasterRef))


	; Spell LightForm = Game.GetFormFromFile(0x88E, "ccqdrsse001-survivalmode.esl") as Spell

	; if Config.BackwardsPressed() || Config.AdjustStagePressed()
	; 	StorageUtil.UnsetFormValue(TargetRef, "Test.LightForm")
	; 	StorageUtil.UnsetFormValue(TargetRef, "Test.SexLab")
	; 	StorageUtil.UnsetFormValue(LightForm, "Test.OnForm")
	; 	Log("---ITEMS CLEARED---\n")
	; endIf

	; Log("Items To Test:")
	; Log("\tLightForm("+LightForm.GetType()+"): "+LightForm)
	; Log("\tSexLab("+SexLab.GetType()+"): "+SexLab)
	; ; Log("\n")

	; Log("StorageUtil (GET 1/2):")
	; Log("\tLightForm("+LightForm.GetType()+"): "+(StorageUtil.GetFormValue(TargetRef, "Test.LightForm") as Spell))
	; Log("\tSexLab("+SexLab.GetType()+"): "+StorageUtil.GetFormValue(TargetRef, "Test.SexLab"))
	; Log("\tOnForm: "+StorageUtil.GetFormValue(LightForm, "Test.OnForm"))
	; ; Log("\n")

	; Log("Setting...")
	; StorageUtil.SetFormValue(TargetRef, "Test.LightForm", LightForm)
	; StorageUtil.SetFormValue(TargetRef, "Test.SexLab", SexLab)

	; Log("StorageUtil (GET 2/2):")
	; Log("\tLightForm("+LightForm.GetType()+"): "+(StorageUtil.GetFormValue(TargetRef, "Test.LightForm") as Spell))
	; Log("\tSexLab("+SexLab.GetType()+"): "+StorageUtil.GetFormValue(TargetRef, "Test.SexLab"))
	; ; Log("\n")


	; Log("Store on ESL:")
	; StorageUtil.SetFormValue(LightForm, "Test.OnForm", SexLab)
	; Log("\tOnForm: "+StorageUtil.GetFormValue(LightForm, "Test.OnForm"))





	; Log("data/skse/plugins: "+MiscUtil.FoldersInFolder("data/skse"))
	; Log("data/skse/plugins: "+MiscUtil.FoldersInFolder("data/skse/plugins"))
	; Log("data/skse/plugins: "+MiscUtil.FilesInFolder("data/skse/plugins"))
	; Log("data/skse/plugins: "+MiscUtil.FilesInFolder("data/skse/plugins",".dll"))
	; Log("data/skse/plugins/sexlab: "+MiscUtil.FilesInFolder("data/skse/plugins/sexlab"))
	; Log("data/skse/plugins/sexlab: "+MiscUtil.FilesInFolder("data/skse/plugins/sexlab", ".json"))


	; Form ItemRef = Game.GetFormFromFile(0xD64, "Dragon Lilly.esp")
	; Log("ItemRef: "+ItemRef)

	; Log("\nGET TEST: ")
	; Log("Form String: "+StorageUtil.GetStringValue(ItemRef, "formtest", "FAIL"))
	; Log("Global form: "+StorageUtil.GetFormValue(none, "globaltest"))
	; Log("Player form: "+StorageUtil.GetFormValue(PlayerRef, "playertest"))

	; Log("\nSET TEST:")
	; StorageUtil.SetStringValue(ItemRef, "formtest", "SUCCESS")
	; StorageUtil.SetFormValue(none, "globaltest", ItemRef)
	; StorageUtil.SetFormValue(PlayerRef, "playertest", ItemRef)


	; Log("\nJSON GET TEST: ")
	; Log("Form String: "+JsonUtil.GetStringValue("formtest.json", "formtest", "FAIL"))
	; Log("Global form: "+JsonUtil.GetFormValue("formtest.json", "globaltest"))
	; Log("Player form: "+JsonUtil.GetFormValue("formtest.json", "playertest"))

	; Log("\nJSON SET TEST:")
	; JsonUtil.SetStringValue("formtest.json", "formtest", "SUCCESS")
	; JsonUtil.SetFormValue("formtest.json", "globaltest", ItemRef)
	; JsonUtil.SetFormValue("formtest.json", "playertest", PlayerRef)

	; Utility.WaitMenuMode(3.0)
	; MiscUtil.ToggleFreeCamera()




	; Benchmark(2, 10, 5)
	; SexLab.QuickStart(CasterRef, TargetRef)

	; CasterRef.SetFactionRank(SexLab.AnimatingFaction, 1)

	; Log("Searching for formtype kNPC, 43...")
	; ObjectReference[] npcs = MiscUtil.ScanCellObjects(43, CasterRef, 0.0)
	; Log("\t kNPC: "+npcs+"\nNames: "+GetActorNames(ObjsToActors(npcs)))
	; Utility.Wait(0.1)

	; Actor[] actors = MiscUtil.ScanCellNPCs(CasterRef, 0)
	; Log("All Actors: "+actors+"\nNames: "+GetActorNames(actors))
	; Utility.Wait(0.1)

	; actors = MiscUtil.ScanCellNPCs(CasterRef, 30.0)
	; Log("Close Actors(30): "+actors+"\nNames: "+GetActorNames(actors))
	; Utility.Wait(0.1)

	; actors = MiscUtil.ScanCellNPCs(CasterRef, 100.0)
	; Log("Close Actors(100): "+actors+"\nNames: "+GetActorNames(actors))
	; Utility.Wait(0.1)

	; actors = MiscUtil.ScanCellNPCs(CasterRef, 500.0)
	; Log("Close Actors(500): "+actors+"\nNames: "+GetActorNames(actors))
	; Utility.Wait(0.1)

	; actors = MiscUtil.ScanCellNPCs(CasterRef, 1000.0)
	; Log("Close Actors(1000): "+actors+"\nNames: "+GetActorNames(actors))
	; Utility.Wait(0.1)

	; actors = MiscUtil.ScanCellNPCs(CasterRef, 5000.0)
	; Log("Close Actors(5000): "+actors+"\nNames: "+GetActorNames(actors))
	; Utility.Wait(0.1)

	; actors = MiscUtil.ScanCellNPCs(CasterRef, 20000.0)
	; Log("Close Actors(20000): "+actors+"\nNames: "+GetActorNames(actors))
	; Utility.Wait(0.1)

	; actors = MiscUtil.ScanCellNPCs(CasterRef, 100000.0)
	; Log("Close Actors(100000): "+actors+"\nNames: "+GetActorNames(actors))
	; Utility.Wait(0.1)

	; actors = MiscUtil.ScanCellNPCs(CasterRef, 0, none, false)
	; Log("All Actors (including dead): "+actors+"\nNames: "+GetActorNames(actors))
	; Utility.Wait(0.1)

	; Log("Keyword: "+Config.ActorTypeNPC+" Has: "+TargetRef.HasKeyword(Keyword.GetKeyword("ActorTypeNPC")))


	; actors = MiscUtil.ScanCellNPCs(CasterRef, 0, Config.ActorTypeNPC)
	; Log("All Actors (ActorTypeNPC): "+actors+"\nNames: "+GetActorNames(actors))
	; Utility.Wait(0.1)

	; actors = MiscUtil.ScanCellNPCs(CasterRef, 0, Keyword.GetKeyword("ActorTypeNPC"))
	; Log("All Actors (ActorTypeNPC2): "+actors+"\nNames: "+GetActorNames(actors))
	; Utility.Wait(0.1)

	; actors = MiscUtil.ScanCellNPCs(CasterRef, 0, Keyword.GetKeyword("TestDemoQuestgiver"))
	; Log("All Actors (TestDemoQuestgiver): "+actors+"\nNames: "+GetActorNames(actors))
	; Utility.Wait(0.1)

	; actors = MiscUtil.ScanCellNPCs(CasterRef, 0, Keyword.GetKeyword("PLAYERKEYWORD"))
	; Log("All Actors (PLAYERKEYWORD): "+actors+"\nNames: "+GetActorNames(actors))
	; Utility.Wait(0.1)



	; if TargetRef != CasterRef
	; 	TargetRef.SetFactionRank(SexLab.AnimatingFaction, 5)
	; 	actors = MiscUtil.ScanCellNPCsByFaction(SexLab.AnimatingFaction, CasterRef, 0.0)
	; 	Log("All Faction Actors: "+actors+"\nNames: "+GetActorNames(actors))
	; 	Utility.Wait(0.1)

	; 	actors = MiscUtil.ScanCellNPCsByFaction(SexLab.AnimatingFaction, CasterRef, 0.0, 1)
	; 	Log("Faction Actors(min: 1): "+actors+"\nNames: "+GetActorNames(actors))
	; 	Utility.Wait(0.1)

	; 	actors = MiscUtil.ScanCellNPCsByFaction(SexLab.AnimatingFaction, CasterRef, 0.0, 6)
	; 	Log("Faction Actors(min: 6): "+actors+"\nNames: "+GetActorNames(actors))
	; 	Utility.Wait(0.1)

	; 	actors = MiscUtil.ScanCellNPCsByFaction(SexLab.AnimatingFaction, CasterRef, 0.0, 0, 1)
	; 	Log("Faction Actors(max: 1): "+actors+"\nNames: "+GetActorNames(actors))
	; 	Utility.Wait(0.1)

	; 	actors = MiscUtil.ScanCellNPCsByFaction(SexLab.AnimatingFaction, CasterRef, 0.0, 0, 6)
	; 	Log("Faction Actors(max: 6): "+actors+"\nNames: "+GetActorNames(actors))
	; 	Utility.Wait(0.1)

	; 	actors = MiscUtil.ScanCellNPCsByFaction(SexLab.AnimatingFaction, CasterRef, 0.0, 1, 4)
	; 	Log("Faction Actors(min: 1, max: 4): "+actors+"\nNames: "+GetActorNames(actors))
	; 	Utility.Wait(0.1)

	; 	actors = MiscUtil.ScanCellNPCsByFaction(SexLab.AnimatingFaction, CasterRef, 0.0, 6, 10)
	; 	Log("Faction Actors(min: 6, max: 10): "+actors+"\nNames: "+GetActorNames(actors))
	; 	Utility.Wait(0.1)

	; 	actors = MiscUtil.ScanCellNPCsByFaction(SexLab.AnimatingFaction, CasterRef, 0.0, 6, 1)
	; 	Log("Faction Actors(min: 6, max: 1): "+actors+"\nNames: "+GetActorNames(actors))
	; 	Utility.Wait(0.1)

	; 	actors = MiscUtil.ScanCellNPCsByFaction(SexLab.AnimatingFaction, CasterRef, 0.0, 5, 1)
	; 	Log("Faction Actors(min: 5, max: 1): "+actors+"\nNames: "+GetActorNames(actors))
	; 	Utility.Wait(0.1)

	; 	actors = MiscUtil.ScanCellNPCsByFaction(SexLab.AnimatingFaction, CasterRef, 0.0, 5, 5)
	; 	Log("Faction Actors(min: 5, max: 5): "+actors+"\nNames: "+GetActorNames(actors))
	; 	Utility.Wait(0.1)
	; endIf




;/ 	SpawnMarker(TargetRef)
	LockActor(TargetRef)

	Log("VehicleFixMode(1)")
	SexLabUtil.VehicleFixMode(1)
	TargetRef.SetVehicle(MarkerRef)
	Utility.Wait(6.0)


	Log("VehicleFixMode(0)")
	SexLabUtil.VehicleFixMode(0)
	TargetRef.SetVehicle(MarkerRef)
	Utility.Wait(6.0)

	UnlockActor(TargetRef)
	SexLabUtil.VehicleFixMode((Config.DisableScale as int))

 /;

;/ 	if TargetRef != PlayerRef
		if StorageUtil.GetIntValue(TargetRef, "DoNothingTest") != 10
			StorageUtil.SetIntValue(TargetRef,"DoNothingTest", 10)

			Log("Adding DoNothing package override to: "+TargetRef)
			ActorUtil.AddPackageOverride(TargetRef, SexLab.ActorLib.DoNothing, 100)
			TargetRef.SetFactionRank(SexLab.AnimatingFaction, 1)
			TargetRef.EvaluatePackage()
		else
			StorageUtil.UnsetIntValue(TargetRef,"DoNothingTest")

			Log("Removing DoNothing package override from: "+TargetRef)
			ActorUtil.RemovePackageOverride(TargetRef, SexLab.ActorLib.DoNothing)
			TargetRef.RemoveFromFaction(SexLab.AnimatingFaction)
			TargetRef.EvaluatePackage()
		endIf
	else
		Utility.Wait(3.0)
		Log("Testing ToggleFreeCamera")
		MiscUtil.ToggleFreeCamera()
		Utility.Wait(5.0)
		MiscUtil.ToggleFreeCamera()
	endIf /;


;/ 	sslAnimationSlots AnimSlots = SexLab.AnimSlots

	AnimSlots.OutputCacheLog()
	AnimSlots.GetByTags(2, "Vaginal")
	AnimSlots.GetByTags(2, "Standing,Default")
	AnimSlots.GetByTags(2, "Anal")
	AnimSlots.GetByTags(2, "MF,Standing")
	AnimSlots.GetByTags(2, "Doggystyle")
	AnimSlots.GetByTags(2, "Aggressive")
	AnimSlots.GetByType(3,2,1)
	AnimSlots.GetByTags(2, "Anal,Standing")
	AnimSlots.GetByTags(2, "Arrok")
	AnimSlots.GetByTags(2, "Vaginal")
	AnimSlots.GetByType(1)
	AnimSlots.GetByTags(2, "Vaginal,Standing")
	AnimSlots.GetByTags(1, "F")
	AnimSlots.GetByTags(2, "Vaginal,Standing")
	AnimSlots.GetByTags(2, "Doggystyle")
	AnimSlots.GetByTags(2, "Aggressive,Standing", "Arrok")
	AnimSlots.GetByTags(2, "Foreplay")
	AnimSlots.GetByTags(2, "Sideways","Aggressive")
	AnimSlots.GetByTags(1, "AP")
	AnimSlots.GetByTags(1, "M")
	AnimSlots.GetByTags(2, "AP")
	AnimSlots.GetByType(5)
	AnimSlots.GetByTags(2, "Standing","Foreplay")
	AnimSlots.GetByTags(2, "Sideways","Aggressive")
	AnimSlots.GetByTags(2, "Anal,MF")
	AnimSlots.GetByTags(2, "Vaginal,Standing")
	AnimSlots.GetByTags(2, "MF,Standing,Arrok")
	AnimSlots.GetByTags(2, "Vaginal,Standing")
	AnimSlots.GetByTags(1, "Solo")
	AnimSlots.GetByTags(2, "Standing","Foreplay")
	AnimSlots.GetByTags(2, "MF,Cowgirl")
	AnimSlots.GetByType(2,1,1)
	AnimSlots.GetByTags(2, "Anal")
	AnimSlots.GetByTags(2, "Aggressive,Standing")
	AnimSlots.GetByType(2,1,1)
	AnimSlots.GetByTags(2, "MF,Cowgirl,Arrok")
	AnimSlots.GetByTags(2, "MF,Cowgirl,Arrok")
	AnimSlots.GetByTags(2, "MF,Standing")
	AnimSlots.GetByTags(2, "MF,Cowgirl")
	AnimSlots.GetByTags(2, "Aggressive,Standing", "Arrok")
	AnimSlots.GetByTags(2, "MF,Cowgirl,Arrok")
	AnimSlots.GetByTags(2, "Standing,Default")
	AnimSlots.GetByTags(2, "Standing","Foreplay")
	AnimSlots.GetByType(3)
	AnimSlots.GetByType(5)
	AnimSlots.GetByTags(2, "Vaginal,Doggystyle")
	AnimSlots.GetByTags(2, "MF,Standing,Arrok")
	AnimSlots.GetByType(3,2,1)
	AnimSlots.GetByTags(2, "MF,Cowgirl,Arrok")
	AnimSlots.OutputCacheLog()
 /;

;/ 	int[] Arr1 = new int[10]
	int i = 0
	while i < 10
		Arr1[i] = Utility.RandomInt(-100, 100)
		i += 1
	endWhile

	float[] Arr2 = new float[10]
	i = 0
	while i < 10
		Arr2[i] = Utility.RandomFloat(-100.0, 100.0)
		i += 1
	endWhile

	Log("Int Array: "+Arr1)
	Log("Highest Int: "+SexLabUtil.IntMinMaxValue(Arr1))
	Log("Highest Int Index: "+SexLabUtil.IntMinMaxIndex(Arr1)+" == "+(SexLabUtil.IntMinMaxValue(Arr1) == Arr1[SexLabUtil.IntMinMaxIndex(Arr1)]))

	Log("Lowest Int: "+SexLabUtil.IntMinMaxValue(Arr1, false))
	Log("Lowest Int Index: "+SexLabUtil.IntMinMaxIndex(Arr1, false)+" == "+(SexLabUtil.IntMinMaxValue(Arr1, false) == Arr1[SexLabUtil.IntMinMaxIndex(Arr1, false)]))
	Log("------")
	Log("Float Array: "+Arr2)
	Log("Highest Float: "+SexLabUtil.FloatMinMaxValue(Arr2))
	Log("Highest Float Index: "+SexLabUtil.FloatMinMaxIndex(Arr2)+" == "+(SexLabUtil.FloatMinMaxValue(Arr2) == Arr2[SexLabUtil.FloatMinMaxIndex(Arr2)]))

	Log("Lowest Float: "+SexLabUtil.FloatMinMaxValue(Arr2, false))
	Log("Lowest Float Index: "+SexLabUtil.FloatMinMaxIndex(Arr2, false)+" == "+(SexLabUtil.FloatMinMaxValue(Arr2, false) == Arr2[SexLabUtil.FloatMinMaxIndex(Arr2, false)]))

	Log("------")

	int[] empty1
	Log("Empty Int Array: "+SexLabUtil.IntMinMaxValue(empty1))
	Log("Empty Int Array Index: "+SexLabUtil.IntMinMaxIndex(empty1))
	
	float[] empty2
	Log("Empty Int Array: "+SexLabUtil.FloatMinMaxValue(empty2))
	Log("Empty Int Array Index: "+SexLabUtil.FloatMinMaxIndex(empty2))
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
