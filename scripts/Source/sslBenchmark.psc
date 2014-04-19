scriptname sslBenchmark extends sslSystemLibrary

function PreBenchmarkSetup()
	Setup()
endFunction

state Test1
	string function Label()
		return ""
	endFunction

	string function Proof()
		return ""
	endFunction

	float function Test(int nth = 5000, float baseline = 0.0)
		; START any variable preparions needed

		; END any variable preparions needed
		baseline += Utility.GetCurrentRealTime()
		while nth
			nth -= 1
			; START code to benchmark

			; END code to benchmark
		endWhile
		return Utility.GetCurrentRealTime() - baseline
	endFunction
endState

state Test2
	string function Label()
		return ""
	endFunction

	string function Proof()
		return ""
	endFunction

	float function Test(int nth = 5000, float baseline = 0.0)
		; START any variable preparions needed

		; END any variable preparions needed
		baseline += Utility.GetCurrentRealTime()
		while nth
			nth -= 1
			; START code to benchmark

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
