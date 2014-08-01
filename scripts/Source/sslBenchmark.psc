scriptname sslBenchmark extends sslSystemLibrary

import SexLabUtil

function PreBenchmarkSetup()
	Setup()
endFunction

state Test3x
	string function Label()
		return "StorageUtil List"
	endFunction

	string function Proof()
		string proof = "[ "
		int i = 100
		while i
			i -= 1
			StorageUtil.IntListAdd(self, "Test", i)
			proof += StorageUtil.IntListGet(self, "Test", StorageUtil.IntListFind(self, "Test", i))+", "
		endWhile
		proof += " ] "+StorageUtil.IntListCount(self, "Test")+" => "
		StorageUtil.IntListClear(self, "Test")
		return proof + StorageUtil.IntListCount(self, "Test")
	endFunction

	float function RunTest(int nth = 5000, float baseline = 0.0)
		; START any variable preparions needed
		int i
		; END any variable preparions needed
		baseline += Utility.GetCurrentRealTime()
		while nth
			nth -= 1
			; START code to benchmark
			i = 100
			while i
				i -= 1
				StorageUtil.IntListAdd(self, "Benchmark"+nth, i)
				StorageUtil.IntListGet(self, "Benchmark"+nth, StorageUtil.IntListFind(self, "Benchmark"+nth, i))
			endWhile
			; END code to benchmark
		endWhile
		return Utility.GetCurrentRealTime() - baseline
	endFunction
endState


state Test4x
	string function Label()
		return "StorageUtil Value"
	endFunction

	string function Proof()
		StorageUtil.SetIntValue(self, "Test", 10)
		StorageUtil.SetFloatValue(self, "Test", 10.0)
		StorageUtil.SetStringValue(self, "Test", "Ten")
		StorageUtil.SetFormValue(self, "Test", PlayerRef)
		return StorageUtil.GetIntValue(self, "Test")+" - "+StorageUtil.GetFloatValue(self, "Test")+" - "+StorageUtil.GetStringValue(self, "Test")+" - "+StorageUtil.GetFormValue(self, "Test")
	endFunction

	float function RunTest(int nth = 5000, float baseline = 0.0)
		; START any variable preparions needed
		; END any variable preparions needed
		baseline += Utility.GetCurrentRealTime()
		while nth
			nth -= 1
			; START code to benchmark
			StorageUtil.SetIntValue(self, "Benchmark"+nth, 10)
			StorageUtil.SetFloatValue(self, "Benchmark"+nth, 10.0)
			StorageUtil.SetStringValue(self, "Benchmark"+nth, "Ten")
			StorageUtil.SetFormValue(self, "Benchmark"+nth, PlayerRef)
			StorageUtil.GetIntValue(self, "Benchmark"+nth)
			StorageUtil.GetFloatValue(self, "Benchmark"+nth)
			StorageUtil.GetStringValue(self, "Benchmark"+nth)
			StorageUtil.GetFormValue(self, "Benchmark"+nth)
			; END code to benchmark
		endWhile
		return Utility.GetCurrentRealTime() - baseline
	endFunction
endState

state Test1x
	string function Label()
		return "SexLabUtil List"
	endFunction

	string function Proof()
		string proof = "[ "
		int i = 100
		while i
			i -= 1
			SexLabUtil.IntListAdd(self, "Test", i)
			proof += SexLabUtil.IntListGet(self, "Test", SexLabUtil.IntListFind(self, "Test", i))+", "
		endWhile
		proof += " ] "+SexLabUtil.IntListCount(self, "Test")+" => "
		SexLabUtil.IntListClear(self, "Test")
		return proof + SexLabUtil.IntListCount(self, "Test")
	endFunction

	float function RunTest(int nth = 5000, float baseline = 0.0)
		; START any variable preparions needed
		int i
		; END any variable preparions needed
		baseline += Utility.GetCurrentRealTime()
		while nth
			nth -= 1
			; START code to benchmark
			i = 100
			while i
				i -= 1
				SexLabUtil.IntListAdd(self, "Benchmark"+nth, i)
				SexLabUtil.IntListGet(self, "Benchmark"+nth, SexLabUtil.IntListFind(self, "Benchmark"+nth, i))
			endWhile
			; END code to benchmark
		endWhile
		return Utility.GetCurrentRealTime() - baseline
	endFunction
endState

state Test1
	string function Label()
		return "SexLabUtil Value"
	endFunction

	string function Proof()
		SexLabUtil.SetIntValue(self, "Test", 10)
		SexLabUtil.SetFloatValue(self, "Test", 10.0)
		SexLabUtil.SetStringValue(self, "Test", "Ten")
		SexLabUtil.SetFormValue(self, "Test", PlayerRef)
		return SexLabUtil.GetIntValue(self, "Test")+" - "+SexLabUtil.GetFloatValue(self, "Test")+" - "+SexLabUtil.GetStringValue(self, "Test")+" - "+SexLabUtil.GetFormValue(self, "Test")
	endFunction

	float function RunTest(int nth = 5000, float baseline = 0.0)
		; START any variable preparions needed
		int i = 100
		; END any variable preparions needed
		baseline += Utility.GetCurrentRealTime()
		while nth
			nth -= 1
			; START code to benchmark
			SexLabUtil.SetIntValue(self, "Benchmark"+nth, 10)
			SexLabUtil.SetFloatValue(self, "Benchmark"+nth, 5.123)
			SexLabUtil.GetIntValue(self, "Benchmark"+nth)
			SexLabUtil.GetFloatValue(self, "Benchmark"+nth)
			; END code to benchmark
		endWhile
		return Utility.GetCurrentRealTime() - baseline
	endFunction
endState

state Test2
	string function Label()
		return "SexLabUtil FileValue"
	endFunction

	string function Proof()
		SexLabUtil.FileSetInt("Test", 10)
		SexLabUtil.FileSetFloat("Test", 5.123)
		SexLabUtil.FileSetString("Test", "Ten")
		SexLabUtil.FileSetForm("Test", PlayerRef)
		return SexLabUtil.FileGetInt("Test")+" - "+SexLabUtil.FileGetFloat("Test")+" - "+SexLabUtil.FileGetString("Test")+" - "+SexLabUtil.FileGetForm("Test")
	endFunction

	float function RunTest(int nth = 5000, float baseline = 0.0)
		; START any variable preparions needed
		int i = 100
		; END any variable preparions needed
		baseline += Utility.GetCurrentRealTime()
		while nth
			nth -= 1
			; START code to benchmark
			SexLabUtil.FileSetInt("Benchmark"+nth, 10)
			SexLabUtil.FileSetFloat("Benchmark"+nth, 10.0)
			SexLabUtil.FileGetInt("Benchmark"+nth)
			SexLabUtil.FileGetFloat("Benchmark"+nth)
			; END code to benchmark
		endWhile
		return Utility.GetCurrentRealTime() - baseline
	endFunction
endState



function StartBenchmark(int Tests = 1, int Iterations = 5000, int Loops = 10)

	PreBenchmarkSetup()

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
		Log("Starting Test #"+Benchmark+"/"+Tests+": "+Label())

		float Total = 0.0
		float Base  = 0.0

		int n = 1
		while n <= Loops
			; Utility.WaitMenuMode(0.5)
			; GoToState("")
			; Base = Test(Iterations)
			; GoToState("Test"+Benchmark)
			; Utility.WaitMenuMode(0.5)
			float Time = RunTest(Iterations)
			Total += Time
			Log("Result #"+n+": "+Time, Label())
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
float function RunTest(int nth = 5000, float baseline = 0.0)
	baseline += Utility.GetCurrentRealTime()
	while nth
		nth -= 1
	endWhile
	return Utility.GetCurrentRealTime() - baseline
endFunction

; int Count
; int Result
; float Delay
; float Loop
; float Started

int function LatencyTest()
	return 0
	; Result  = 0
	; Count   = 0
	; Delay   = 0.0
	; Started = Utility.GetCurrentRealTime()
	; RegisterForSingleUpdate(0)
	; while Result == 0
	; 	Utility.Wait(0.1)
	; endWhile
	; return Result
endFunction

event OnUpdate()
	return
	; Delay += (Utility.GetCurrentRealTime() - Started)
	; Count += 1
	; if Count < 10
	; 	Started = Utility.GetCurrentRealTime()
	; 	RegisterForSingleUpdate(0.0)
	; else
	; 	Result = ((Delay / 10.0) * 1000.0) as int
	; 	Debug.Notification("Latency Test Result: "+Result+"ms")
	; endIf
endEvent


event Hook(int tid, bool HasPlayer)
endEvent
