scriptname sslBenchmark extends sslSystemLibrary

import SexLabUtil

function PreBenchmarkSetup()
	Setup()
	Expression = SexLabUtil.GetAPI().Expressions[0]
	Presets = Expression.SelectPhase(100, 1)
	Log(Presets)
endFunction

sslBaseExpression Expression
int[] Presets
function ApplyPreset(Actor ActorRef, int[] Preset)
endFunction
function ClearMFG()
	PlayerRef.ResetExpressionOverrides()
	PlayerRef.ClearExpressionOverride()
	MfgConsoleFunc.ResetPhonemeModifier(PlayerRef)
endFunction

state Test2
	string function Label()
		return "SKSE"
	endFunction

	string function Proof()
		ClearMFG()
		ApplyPreset(PlayerRef, Presets)
		Utility.Wait(4.0)
		return "End 1"
	endFunction

	float function RunTest(int nth = 5000, float baseline = 0.0)
		; START any variable preparions needed
		ClearMFG()
		; END any variable preparions needed
		baseline += Utility.GetCurrentRealTime()
		while nth
			nth -= 1
			; START code to benchmark
			ApplyPreset(PlayerRef, Presets)
			; END code to benchmark
		endWhile
		return Utility.GetCurrentRealTime() - baseline
	endFunction


	function ApplyPreset(Actor ActorRef, int[] Preset)
		int i
		; Set Phoneme
		int p
		while p <= 15
			ActorRef.SetExpressionPhoneme(p, (Preset[i] / 100))
			i += 1
			p += 1
		endWhile
		; Set Modifers
		int m
		while m <= 13
			ActorRef.SetExpressionModifier(m, (Preset[i] / 100))
			i += 1
			m += 1
		endWhile
		; Set expression
		ActorRef.SetExpressionOverride(Preset[30], Preset[31])
	endFunction
endState

state Test1
	string function Label()
		return "MfgConsoleFunc"
	endFunction

	string function Proof()
		ClearMFG()
		ApplyPreset(PlayerRef, Presets)
		Utility.Wait(4.0)
		return "End 2"
	endFunction

	float function RunTest(int nth = 5000, float baseline = 0.0)
		; START any variable preparions needed
		ClearMFG()
		; END any variable preparions needed
		baseline += Utility.GetCurrentRealTime()
		while nth
			nth -= 1
			; START code to benchmark
			ApplyPreset(PlayerRef, Presets)
			; END code to benchmark
		endWhile
		return Utility.GetCurrentRealTime() - baseline
	endFunction


	function ApplyPreset(Actor ActorRef, int[] Preset)
		int i
		; Set Phoneme
		int p
		while p <= 15
			MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, p, Preset[i])
			i += 1
			p += 1
		endWhile
		; Set Modifers
		int m
		while m <= 13
			MfgConsoleFunc.SetPhonemeModifier(ActorRef, 1, m, Preset[i])
			i += 1
			m += 1
		endWhile
		; Set expression
		ActorRef.SetExpressionOverride(Preset[30], Preset[31])
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
