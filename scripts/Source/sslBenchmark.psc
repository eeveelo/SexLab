scriptname sslBenchmark extends sslSystemLibrary

import SexLabUtil

function PreBenchmarkSetup()
	Setup()
	; Animation = AnimSlots.GetbyRegistrar("bleaghfemalesolo")
	; Registry = Animation.Registry
	; AdjustKey = Animation.MakeAdjustKey(sslUtility.MakeActorArray(PlayerRef))
	; RaceKey = sslUtility.RemoveString(AdjustKey, Animation.Key(""))+".0"
	; Profile = Animation.Profile
	; AdjIndex = Animation.AdjIndex(1, 3)

	; Animation.UpdateAdjustmentAll(AdjustKey, 0, 1, 0.1)
	; Animation.UpdateAdjustmentAll(AdjustKey, 0, 2, 1.5)
	; Animation.UpdateAdjustmentAll(AdjustKey, 0, 1, 0.1)
	; Animation.UpdateAdjustmentAll(AdjustKey, 0, 2, 1.5)
	; Animation.UpdateAdjustmentAll(AdjustKey, 0, 1, 0.1)
	; Animation.UpdateAdjustmentAll(AdjustKey, 0, 2, 1.5)
	; Animation.UpdateAdjustmentAll(AdjustKey, 0, 1, 0.1)
	; Animation.UpdateAdjustment(AdjustKey, 0, 2, 0, 1.2)
	; Animation.UpdateAdjustment(AdjustKey, 0, 2, 0, 1.2)
	; Animation.UpdateAdjustment(AdjustKey, 0, 2, 0, 1.2)
	; Animation.UpdateAdjustment(AdjustKey, 0, 2, 0, 1.2)
	; Animation.UpdateAdjustment(AdjustKey, 0, 2, 0, 1.2)
	; Animation.UpdateAdjustment(AdjustKey, 0, 2, 0, 1.2)
	; Animation.UpdateAdjustment(AdjustKey, 0, 3, 0, 1.3)
	; Animation.UpdateAdjustment(AdjustKey, 0, 3, 0, 1.3)
	; Animation.UpdateAdjustment(AdjustKey, 0, 3, 0, 1.3)
	; Animation.UpdateAdjustment(AdjustKey, 0, 3, 0, 1.3)
	; Log("JsonUtil Save(): "+JsonUtil.Save(Animation.Profile))
	; Log("SexLabUtil Save(): "+sslBaseAnimation._SaveProfile("DevProfile_1.json"))

endFunction


state Test1
	string function Label()
		return "VoiceSlots"
	endFunction

	string function Proof()
		return "Voice[10]: "+VoiceSlots.GetBySlot(10).Name
	endFunction

	float function RunTest(int nth = 5000, float baseline = 0.0)
		; START any variable preparions needed
		sslBaseVoice Slot
		; END any variable preparions needed
		baseline += Utility.GetCurrentRealTime()
		while nth
			nth -= 1
			; START code to benchmark
			Slot = VoiceSlots.GetBySlot(10)
			; END code to benchmark
		endWhile
		return Utility.GetCurrentRealTime() - baseline
	endFunction
endState

state Test2
	string function Label()
		return "ExpressionSlots"
	endFunction

	string function Proof()
		return "Expression[10]: "+ExpressionSlots.GetBySlot(10).Name
	endFunction

	float function RunTest(int nth = 5000, float baseline = 0.0)
		; START any variable preparions needed
		sslBaseExpression Slot
		; END any variable preparions needed
		baseline += Utility.GetCurrentRealTime()
		while nth
			nth -= 1
			; START code to benchmark
			Slot = ExpressionSlots.GetBySlot(10)
			; END code to benchmark
		endWhile
		return Utility.GetCurrentRealTime() - baseline
	endFunction
endState

state Test3
	string function Label()
		return "AnimationSlots"
	endFunction

	string function Proof()
		return "Animation[132]: "+AnimSlots.GetBySlot(132).Name
	endFunction

	float function RunTest(int nth = 5000, float baseline = 0.0)
		; START any variable preparions needed
		sslBaseAnimation Slot
		; END any variable preparions needed
		baseline += Utility.GetCurrentRealTime()
		while nth
			nth -= 1
			; START code to benchmark
			Slot = AnimSlots.GetBySlot(10)
			; END code to benchmark
		endWhile
		return Utility.GetCurrentRealTime() - baseline
	endFunction
endState


state Test4
	string function Label()
		return "CreatureSlots"
	endFunction

	string function Proof()
		return "Creature[10]: "+CreatureSlots.GetBySlot(10).Name
	endFunction

	float function RunTest(int nth = 5000, float baseline = 0.0)
		; START any variable preparions needed
		sslBaseAnimation Slot
		; END any variable preparions needed
		baseline += Utility.GetCurrentRealTime()
		while nth
			nth -= 1
			; START code to benchmark
			Slot = CreatureSlots.GetBySlot(10)
			; END code to benchmark
		endWhile
		return Utility.GetCurrentRealTime() - baseline
	endFunction
endState



;/
sslBaseAnimation Animation
string AdjustKey
string RaceKey
string Registry
string Profile
int AdjIndex
state Test1
	string function Label()
		return "JsonUtil"
	endFunction

	string function Proof()
		float[] All   = Animation.GetAllAdjustments(AdjustKey)
		float[] Stage = Animation.GetPositionAdjustments(AdjustKey, 0, 2)
		return AdjustKey+"\n - All("+All.Length+") - Stage("+Stage.Length+"):\n"+All+"\n"+Stage
	endFunction

	float function RunTest(int nth = 5000, float baseline = 0.0)
		; START any variable preparions needed
		float[] Offsets = Animation.GetPositionAdjustments(AdjustKey, 0, 2)
		Log(Label()+" - Offsets: "+Offsets)
		; END any variable preparions needed
		baseline += Utility.GetCurrentRealTime()
		while nth
			nth -= 1
			; START code to benchmark
			JsonUtil.FloatListAdjust(Profile, AdjustKey, AdjIndex, 0.1)
			Offsets = Animation.GetPositionAdjustments(AdjustKey, 0, 2)
			; END code to benchmark
		endWhile
		return Utility.GetCurrentRealTime() - baseline
	endFunction
endState


state Test2
	string function Label()
		return "SexLabUtil"
	endFunction

	string function Proof()
		float[] All   = sslBaseAnimation._GetAllAdjustments("DevProfile_1.json", Registry, RaceKey)
		float[] Stage = sslBaseAnimation._GetStageAdjustments("DevProfile_1.json", Registry, RaceKey, 1)
		return RaceKey+"\n - All("+All.Length+") - Stage("+Stage.Length+"):\n"+All+"\n"+Stage
	endFunction

	float function RunTest(int nth = 5000, float baseline = 0.0)
		; START any variable preparions needed
		float[] Offsets = sslBaseAnimation._GetStageAdjustments("DevProfile_1.json", Registry, RaceKey, 1)
		Log(Label()+" - Offsets: "+Offsets)
		; END any variable preparions needed
		baseline += Utility.GetCurrentRealTime()
		while nth
			nth -= 1
			; START code to benchmark
			sslBaseAnimation._AdjustOffset("DevProfile_1.json", Registry, RaceKey, 1, 3, 0.1)
			Offsets = sslBaseAnimation._GetStageAdjustments("DevProfile_1.json", Registry, RaceKey, 1)
			; END code to benchmark
		endWhile
		return Utility.GetCurrentRealTime() - baseline
	endFunction
endState
/;






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
