scriptname sslBenchmark extends sslSystemLibrary


function PreBenchmarkSetup()
	Setup()

endFunction

state RunTest1
	string function Label()
		return ""
	endFunction

	string function Proof()
		return ""
	endFunction

	float function Test(int nth = 5000, float baseline = 0.0)
		; START any variable preparions needed

		; END any variable preparions needed
		Utility.WaitMenuMode(1.0)
		baseline += Utility.GetCurrentRealTime()
		while nth
			nth -= 1
			; START code to benchmark


			; END code to benchmark
		endWhile
		return Utility.GetCurrentRealTime() - baseline
	endFunction
endState

state RunTest2
	string function Label()
		return "4"
	endFunction

	string function Proof()
		return ""
	endFunction

	float function Test(int nth = 5000, float baseline = 0.0)
		; START any variable preparions needed

		; END any variable preparions needed
		Utility.WaitMenuMode(1.0)
		baseline += Utility.GetCurrentRealTime()
		while nth
			nth -= 1
			; START code to benchmark


			; END code to benchmark
		endWhile
		return Utility.GetCurrentRealTime() - baseline
	endFunction
endState

function StartBenchmark(int Tests = 1, int Iterations = 5000, int Loops = 10)

	PreBenchmarkSetup()

	int n
	float Total
	float Time
	float Base

	Debug.Notification("Starting benchmark...")
	Utility.WaitMenuMode(1.0)

	int Proof = 1
	while Proof <= Tests
		GoToState("RunTest"+Proof)
		Log("Functionality Proof: "+Proof(), Label())
		Proof += 1
	endWhile

	int Benchmark = 1
	while Benchmark <= Tests
		GoToState("")
		Base = Test(Iterations)
		GoToState("RunTest"+Benchmark)
		Utility.WaitMenuMode(1.0)
		; Log("Starting Test #"+Benchmark+": "+Label())
		Total = 0.0
		n = 1
		while n <= Loops
			Utility.WaitMenuMode(1.0)
			Time = Test(Iterations, Base)
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
float function Test(int nth = 5000, float baseline = 0.0)
	Utility.WaitMenuMode(1.0)
	baseline += Utility.GetCurrentRealTime()
	while nth
		nth -= 1
	endWhile
	return Utility.GetCurrentRealTime() - baseline
endFunction


