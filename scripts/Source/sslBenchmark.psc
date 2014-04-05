scriptname sslBenchmark extends sslSystemLibrary

import StorageUtil
import sslUtility

Actor ActorRef
bool[] Strip
form[] Equipment

function PreBenchmarkSetup()
	Setup()

	ActorRef = PlayerRef
	Strip = Config.GetStrip(true, false, false, false)
	ActorLib.CacheStrippable(PlayerRef)
	Debug.Notification("Strip array: "+CountTrue(Strip))

endFunction

function Strip(bool DoAnimate = true)
endFunction

function UnStrip()
endFunction


state Test1

	string function Label()
		return "Form Array"
	endFunction

	string function Proof()
		Strip(true)
		UnStrip()
		Debug.TraceAndBox("Proof: "+Label())
		Utility.Wait(2.0)
		return ""
	endFunction

	function Strip(bool DoAnimate = true)
		; Strip armors
		Form[] Stripped = new Form[34]
		Form ItemRef
		int i = Strip.Find(true)
		while i != -1

			ItemRef = ActorRef.GetWornForm(Armor.GetMaskForSlot(i + 30))
			if ItemRef != none && FormListFind(none, "StripList", ItemRef) != -1
				ActorRef.UnequipItem(ItemRef, false, true)
				Stripped[i] = ItemRef
			endIf

			i += 1
			if i < 32
				i = Strip.Find(true, i)
			else
				i = -1
			endIf
		endWhile
		Equipment = ClearNone(Stripped)
	endFunction

	function UnStrip()
		int i = Equipment.Length
		while i
			i -= 1
			if Equipment[i] != none
				ActorRef.EquipItem(Equipment[i], false, true)
			endIf
		endWhile
	endFunction

	float function Test(int nth = 5000, float baseline = 0.0)
		; START any variable preparions needed


		; END any variable preparions needed
		baseline += Utility.GetCurrentRealTime()
		while nth
			nth -= 1
			; START code to benchmark

			Strip(true)
			UnStrip()

			; END code to benchmark
		endWhile
		return Utility.GetCurrentRealTime() - baseline
	endFunction
endState

state Test2

	string function Label()
		return "Form List"
	endFunction

	string function Proof()
		Strip(true)
		UnStrip()
		Debug.TraceAndBox("Proof: "+Label())
		Utility.Wait(2.0)
		return ""
	endFunction

	function Strip(bool DoAnimate = true)
		; Strip armors
		Form ItemRef
		int i = Strip.Find(true)
		while i != -1

			ItemRef = ActorRef.GetWornForm(Armor.GetMaskForSlot(i + 30))
			if ItemRef != none && FormListFind(none, "StripList", ItemRef) != -1
				ActorRef.UnequipItem(ItemRef, false, true)
				FormListAdd(ActorRef, "SexLab.Stripped", ItemRef)
			endIf

			i += 1
			if i < 32
				i = Strip.Find(true, i)
			else
				i = -1
			endIf
		endWhile
	endFunction

	function UnStrip()
		int i = FormListCount(ActorRef, "SexLab.Stripped")
		while i
			i -= 1
			ActorRef.EquipItem(FormListGet(ActorRef, "SexLab.Stripped", i), false, true)
		endWhile
		FormListClear(ActorRef, "SexLab.Stripped")
	endFunction

	float function Test(int nth = 5000, float baseline = 0.0)
		; START any variable preparions needed


		; END any variable preparions needed
		baseline += Utility.GetCurrentRealTime()
		while nth
			nth -= 1
			; START code to benchmark

			Strip(true)
			UnStrip()

			; END code to benchmark
		endWhile
		return Utility.GetCurrentRealTime() - baseline
	endFunction
endState






function StartBenchmark(int Tests = 2, int Iterations = 5000, int Loops = 10)

	PreBenchmarkSetup()

	int n
	float Total
	float Time
	float Base

	Debug.Notification("Starting benchmark...")
	Utility.WaitMenuMode(1.0)

	int Proof = 1
	while Proof <= Tests
		GoToState("Test"+Proof)
		Log("Functionality Proof: "+Proof(), Label())
		Proof += 1
	endWhile

	int Benchmark = 1
	while Benchmark <= Tests
		GoToState("Test"+Benchmark)
		Utility.WaitMenuMode(0.5)
		Log("Starting Test #"+Benchmark+": "+Label())
		Total = 0.0
		n = 1
		while n <= Loops
			Utility.WaitMenuMode(0.5)
			GoToState("")
			Base = Test(Iterations)
			GoToState("Test"+Benchmark)
			Utility.WaitMenuMode(0.5)
			Time = Test(Iterations, Base)
			Total += Time
			; Log("Result #"+n+": "+Time, Label())
			n += 1
		endWhile
		Log("Average Result: "+(Total / Loops), Label())
		Debug.Notification("Finished "+Label())
		Benchmark += 1
	endWhile
	Debug.TraceAndBox("Benchmark Over, see console or debug log for results")
endFunction

string function Label()
	return ""
endFunction
string function Proof()
	return ""
endFunction
float function Test(int nth = 5000, float baseline = 0.0)
	baseline += Utility.GetCurrentRealTime()
	while nth
		nth -= 1
	endWhile
	return Utility.GetCurrentRealTime() - baseline
endFunction

int Count
int Result
float Delay
float Loop
float Started

int function LatencyTest()
	Result  = 0
	Count   = 0
	Delay   = 0.0
	Started = Utility.GetCurrentRealTime()
	RegisterForSingleUpdate(0)
	while Result == 0
		Utility.Wait(0.01)
	endWhile
	return Result
endFunction

event OnUpdate()
	Delay += (Utility.GetCurrentRealTime() - Started)
	Count += 1
	if Count < 10
		Started = Utility.GetCurrentRealTime()
		RegisterForSingleUpdate(0)
	else
		Result = ((Delay / 10.0) * 1000.0) as int
		Debug.Notification("Latency Test Result: "+Result+"ms")
	endIf
endEvent
