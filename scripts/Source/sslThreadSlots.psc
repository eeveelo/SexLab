scriptname sslThreadSlots extends Quest

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
			SexLabUtil.DebugLog("Making during StopAll - Initializing.", "Slot["+i+"]", true)
			Slots[i].Initialize()
		elseIf SlotState != "Unlocked"
			SexLabUtil.DebugLog(SlotState+" during StopAll - EndAnimation.", "Slot["+i+"]", true)
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

	; Init variables
	Slots = new sslThreadController[15]
	Slots[0]  = Game.GetFormFromFile(0x61EEF, "SexLab.esm") as sslThreadController
	Slots[1]  = Game.GetFormFromFile(0x62452, "SexLab.esm") as sslThreadController
	Slots[2]  = Game.GetFormFromFile(0x6C62C, "SexLab.esm") as sslThreadController
	Slots[3]  = Game.GetFormFromFile(0x6C62D, "SexLab.esm") as sslThreadController
	Slots[4]  = Game.GetFormFromFile(0x6C62E, "SexLab.esm") as sslThreadController
	Slots[5]  = Game.GetFormFromFile(0x6C62F, "SexLab.esm") as sslThreadController
	Slots[6]  = Game.GetFormFromFile(0x6C630, "SexLab.esm") as sslThreadController
	Slots[7]  = Game.GetFormFromFile(0x6C631, "SexLab.esm") as sslThreadController
	Slots[8]  = Game.GetFormFromFile(0x6C632, "SexLab.esm") as sslThreadController
	Slots[9]  = Game.GetFormFromFile(0x6C633, "SexLab.esm") as sslThreadController
	Slots[10] = Game.GetFormFromFile(0x6C634, "SexLab.esm") as sslThreadController
	Slots[11] = Game.GetFormFromFile(0x6C635, "SexLab.esm") as sslThreadController
	Slots[12] = Game.GetFormFromFile(0x6C636, "SexLab.esm") as sslThreadController
	Slots[13] = Game.GetFormFromFile(0x6C637, "SexLab.esm") as sslThreadController
	Slots[14] = Game.GetFormFromFile(0x6C638, "SexLab.esm") as sslThreadController

	; Reset quests so they re-init scripts/variables
	; Quests seem picky about being in menu mode during stop/start, so force menu wait between each
	int i = Slots.Length
	while i
		i -= 1
		Slots[i].Stop()
		Utility.Wait(0.1)
		Slots[i].Start()
		Utility.Wait(0.1)
	endWhile
	; Setup threads + actoraliases
	i = Slots.Length
	while i
		i -= 1
		Slots[i].SetTID(i)
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
