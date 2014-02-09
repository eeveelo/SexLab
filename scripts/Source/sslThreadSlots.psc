scriptname sslThreadSlots extends Quest

sslThreadController[] Slots
sslThreadController[] property Threads hidden
	sslThreadController[] function get()
		return Slots
	endFunction
endProperty

sslThreadModel function PickModel()
	int i
	while i < Slots.Length
		if !Slots[i].IsLocked
			return Slots[i].Make()
		endIf
		i += 1
	endWhile
	return none
endFunction

function _Setup()
	Slots = new sslThreadController[5]
	int i = Slots.Length
	while i
		i -= 1
		if i > 9
			Slots[i] = (Quest.GetQuest("SexLabThread"+i) as sslThreadController)
		else
			Slots[i] = (Quest.GetQuest("SexLabThread0"+i) as sslThreadController)
		endIf
		Slots[i]._SetupThread(i)
	endWhile
endFunction

event OnInit()
	_Setup()
endEvent
