scriptname sslThreadSlots extends Quest

; Libs
sslSystemConfig property Config auto

; Slots
sslThreadController[] Slots
sslThreadController[] property Threads hidden
	sslThreadController[] function get()
		return Slots
	endFunction
endProperty

sslThreadModel function PickModel(float TimeOut = 30.0)
	while GetState() == "Locked"
		Utility.WaitMenuMode(0.1)
	endWhile
	GoToState("Locked")
	sslThreadModel Thread
	int i
	while !Thread && i < Slots.Length
		if !Slots[i].IsLocked
			Thread = Slots[i].Make()
		endIf
		i += 1
	endWhile
	GoToState("")
	return Thread
endFunction

sslThreadController function GetController(int tid)
	if tid < 0 || tid >= Slots.Length
		return none
	endIf
	return Slots[tid]
endfunction

int function FindActorController(Actor ActorRef)
	int i
	while i < Slots.Length
		if Slots[i].Positions.Find(ActorRef) != -1
			return i
		endIf
		i += 1
	endWhile
	return -1
endFunction

sslThreadController function GetActorController(Actor ActorRef)
	return GetController(FindActorController(ActorRef))
endFunction

bool function IsRunning()
	int i
	while i < Slots.Length
		if Slots[i].IsLocked
			return true
		endIf
		i += 1
	endwhile
	return false
endfunction

int function ActiveThreads()
	int Count
	int i = Slots.Length
	while i
		i -= 1
		Count += (Slots[i].IsLocked as int)
	endwhile
	return Count
endfunction

function StopAll()
	; End all threads
	int i = Slots.Length
	while i
		i -= 1
		string SlotState = Slots[i].GetState()
		if SlotState == "Making"
			SexLabUtil.DebugLog("Making during StopAll - Initializing.", "Slots["+i+"]", true)
			Slots[i].Initialize()
		elseIf SlotState != "Unlocked"
			SexLabUtil.DebugLog(SlotState+" during StopAll - EndAnimation.", "Slots["+i+"]", true)
			Slots[i].EndAnimation(true)
		endIf
	endWhile
	; Send event
	ModEvent.Send(ModEvent.Create("SexLabStoppedActive"))
endFunction

; ------------------------------------------------------- ;
; --- System Use Only                                 --- ;
; ------------------------------------------------------- ;

function Setup()
	GoToState("Locked")
	StorageUtil.FormListClear(self, "ActiveActors")
	Config = Game.GetFormFromFile(0xD62, "SexLab.esm") as sslSystemConfig

	; Slot Form IDs
	int[] SlotFormID = new int[15]
	SlotFormID[0]  = 0x61EEF
	SlotFormID[1]  = 0x62452
	SlotFormID[2]  = 0x6C62C
	SlotFormID[3]  = 0x6C62D
	SlotFormID[4]  = 0x6C62E
	SlotFormID[5]  = 0x6C62F
	SlotFormID[6]  = 0x6C630
	SlotFormID[7]  = 0x6C631
	SlotFormID[8]  = 0x6C632
	SlotFormID[9]  = 0x6C633
	SlotFormID[10] = 0x6C634
	SlotFormID[11] = 0x6C635
	SlotFormID[12] = 0x6C636
	SlotFormID[13] = 0x6C637
	SlotFormID[14] = 0x6C638

	; Get and stop all thread quest slots
	Slots = new sslThreadController[15]
	int i = Slots.Length
	while i
		i -= 1
		Slots[i] = Game.GetFormFromFile(SlotFormID[i], "SexLab.esm") as sslThreadController
		if !Slots[i].IsStopped() || Slots[i].IsStopping()
			Slots[i].Stop()
			float max = Utility.GetCurrentRealTime() + 5.0
			while Slots[i].IsStopping() && Utility.GetCurrentRealTime() <= max
				Utility.Wait(0.5)
			endwhile
		endIf
	endWhile
	Utility.WaitMenuMode(1.0)
	i = Slots.Length
	while i
		i -= 1
		if Slots[i].Start()
			Slots[i].SetTID(i)
		else
			Config.Log("Failed to start thread quest("+i+"): "+Slots[i])
		endIf
	endWhile
	
	Debug.Trace("SexLab Threads: "+Slots)
	GoToState("")
endFunction

bool function TestSlots()
	return Slots.Length == 15 && Slots.Find(none) == -1
endFunction

state Locked
	function Setup()
	endFunction
endState

function Log(string msg)
	if Config.DebugMode
		MiscUtil.PrintConsole(msg)
	endIf
	Debug.Trace("SEXLAB - "+msg)
endFunction