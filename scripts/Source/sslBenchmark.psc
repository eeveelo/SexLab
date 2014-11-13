scriptname sslBenchmark extends sslSystemLibrary

import SexLabUtil

function PreBenchmarkSetup()
	Setup()
	FormOne = Game.GetFormFromFile(0xD62, "SexLab.esm")
	FormTwo = Game.GetFormFromFile(0x639DF, "SexLab.esm")
endFunction

Form FormOne
Form FormTwo

float function IfElse(bool isTrue, float returnTrue, float returnFalse = 0.0)
	if isTrue
		return returnTrue
	else
		return returnFalse
	endIf
endFunction


state Test1
	string function Label()
		return "Local"
	endFunction

	string function Proof()
		float TrueVar  = 0.0
		float FalseVar = 0.0
		if FormOne != FormTwo
			TrueVar = 5.0
		else
			TrueVar = 1.0
		endIf
		if FormOne == FormTwo
			FalseVar = 5.0
		else
			FalseVar = 1.0
		endIf

		string Output
		Output += "True: "+TrueVar+"=="+5.0+" = "+(TrueVar == 5.0)
		Output += " -- "
		Output += "False: "+FalseVar+"=="+1.0+" = "+(FalseVar == 1.0)
		return Output
	endFunction

	float function RunTest(int nth = 5000, float baseline = 0.0)
		; START any variable preparions needed
		float TrueVar  = 0.0
		float FalseVar = 0.0
		; END any variable preparions needed
		baseline += Utility.GetCurrentRealTime()
		while nth
			nth -= 1
			; START code to benchmark
			if FormOne != FormTwo
				TrueVar = 5.0
			else
				TrueVar = 1.0
			endIf
			if FormOne == FormTwo
				FalseVar = 5.0
			else
				FalseVar = 1.0
			endIf
			; END code to benchmark
		endWhile
		return Utility.GetCurrentRealTime() - baseline
	endFunction
endState


state Test2
	string function Label()
		return "IfElse"
	endFunction

	string function Proof()
		string Output
		Output += "True: "+IfElse(FormOne != FormTwo, 5.0, 1.0)+"=="+5.0+" = "+(IfElse(FormOne != FormTwo, 5.0, 1.0) == 5.0)
		Output += " -- "
		Output += "False: "+IfElse(FormOne == FormTwo, 5.0, 1.0)+"=="+1.0+" = "+(IfElse(FormOne == FormTwo, 5.0, 1.0) == 1.0)
		return Output
	endFunction

	float function RunTest(int nth = 5000, float baseline = 0.0)
		; START any variable preparions needed
		float TrueVar  = 0.0
		float FalseVar = 0.0
		; END any variable preparions needed
		baseline += Utility.GetCurrentRealTime()
		while nth
			nth -= 1
			; START code to benchmark
			TrueVar   = IfElse(FormOne != FormTwo, 5.0, 1.0)
			FalseVar  = IfElse(FormOne == FormTwo, 5.0, 1.0)
			; END code to benchmark
		endWhile
		return Utility.GetCurrentRealTime() - baseline
	endFunction
endState

state Test3
	string function Label()
		return "sslUtility"
	endFunction

	string function Proof()
		string Output
		Output += "True: "+sslUtility.FloatIfElse(FormOne != FormTwo, 5.0, 1.0)+"=="+5.0+" = "+(sslUtility.FloatIfElse(FormOne != FormTwo, 5.0, 1.0) == 5.0)
		Output += " -- "
		Output += "False: "+sslUtility.FloatIfElse(FormOne == FormTwo, 5.0, 1.0)+"=="+1.0+" = "+(sslUtility.FloatIfElse(FormOne == FormTwo, 5.0, 1.0) == 1.0)
		return Output
	endFunction

	float function RunTest(int nth = 5000, float baseline = 0.0)
		; START any variable preparions needed
		float TrueVar  = 0.0
		float FalseVar = 0.0
		; END any variable preparions needed
		baseline += Utility.GetCurrentRealTime()
		while nth
			nth -= 1
			; START code to benchmark
			TrueVar   = sslUtility.FloatIfElse(FormOne != FormTwo, 5.0, 1.0)
			FalseVar  = sslUtility.FloatIfElse(FormOne == FormTwo, 5.0, 1.0)
			; END code to benchmark
		endWhile
		return Utility.GetCurrentRealTime() - baseline
	endFunction
endState

state Test4
	string function Label()
		return "sslSystemLibrary"
	endFunction

	string function Proof()
		string Output
		Output += "True: "+FloatIfElse(FormOne != FormTwo, 5.0, 1.0)+"=="+5.0+" = "+(FloatIfElse(FormOne != FormTwo, 5.0, 1.0) == 5.0)
		Output += " -- "
		Output += "False: "+FloatIfElse(FormOne == FormTwo, 5.0, 1.0)+"=="+1.0+" = "+(FloatIfElse(FormOne == FormTwo, 5.0, 1.0) == 1.0)
		return Output
	endFunction

	float function RunTest(int nth = 5000, float baseline = 0.0)
		; START any variable preparions needed
		float TrueVar  = 0.0
		float FalseVar = 0.0
		; END any variable preparions needed
		baseline += Utility.GetCurrentRealTime()
		while nth
			nth -= 1
			; START code to benchmark
			TrueVar   = FloatIfElse(FormOne != FormTwo, 5.0, 1.0)
			FalseVar  = FloatIfElse(FormOne == FormTwo, 5.0, 1.0)
			; END code to benchmark
		endWhile
		return Utility.GetCurrentRealTime() - baseline
	endFunction
endState





function StartBenchmark(int Tests = 1, int Iterations = 5000, int Loops = 10, bool UseBaseLoop = false)

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
			Utility.WaitMenuMode(0.5)

			if UseBaseLoop
				GoToState("")
				Base = RunTest(Iterations)
				GoToState("Test"+Benchmark)
			endIf

			float Time = RunTest(Iterations, Base)
			Total += Time
			if UseBaseLoop
				Log("Result #"+n+": "+Time+" -- EmptyLoop: "+Base, Label())
			else
				Log("Result #"+n+": "+Time, Label())
			endIf
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
