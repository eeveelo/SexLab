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
	int i
	while i < Slots.Length
		if !Slots[i].IsLocked
			return Slots[i].Make()
		endIf
		i += 1
	endWhile
	return none
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
		if Slots[i]
			while Slots[i].IsStarting()
				Log("Slots["+i+"] - "+Slots[i], "IsStarting()")
				Utility.Wait(0.1)
			endWhile
			Slots[i].Stop()
		else
			Log("Slots["+i+"] - Failed to get form - "+SlotFormID[i]+" - "+Game.GetFormFromFile(SlotFormID[i], "SexLab.esm"), "FATAL")
		endIf
	endWhile

	; Start and setup threads + actoraliases
	i = Slots.Length
	while i
		i -= 1
		if Slots[i]
			; Ensure quest isn't still stopping
			while Slots[i].IsStopping()
				Log("Slots["+i+"] - "+Slots[i], "IsStopping()")
				Utility.Wait(0.1)
			endWhile
			; Setup thread once quest has started up
			if Slots[i].Start()
				Slots[i].SetTID(i)
			else
				Log("Slots["+i+"] - Failed to start thread - "+Slots[i], "FATAL")
			endIf
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

function Log(string Log, string Type = "NOTICE")
	Log = Type+": "+Log
	if Config.DebugMode
		SexLabUtil.PrintConsole(Log)
	endIf
	if Type == "FATAL"
		Debug.TraceStack("SEXLAB - "+Log)
	else
		Debug.Trace("SEXLAB - "+Log)
	endIf
endFunction
