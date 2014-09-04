scriptname sslBenchmark extends sslSystemLibrary

import SexLabUtil

function PreBenchmarkSetup()
	Setup()
	Stats.Setup()
endFunction

state Test1
	string function Label()
		return "Values"
	endFunction

	string function Proof()
		return "Vaginal: "+Stats.GetSkill(PlayerRef, "Vaginal")+" Lewd: "+Stats.GetLewd(PlayerRef)+" List: "+Stats.GetSkills(PlayerRef)
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
				Stats.GetSkill(PlayerRef, "Vaginal")
				Stats.GetLewd(PlayerRef)
				Stats.GetSkills(PlayerRef)
			endWhile
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
