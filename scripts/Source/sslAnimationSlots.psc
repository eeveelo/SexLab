scriptname sslAnimationSlots extends Quest

; Animation readonly storage
sslBaseAnimation[] Slots
sslBaseAnimation[] property Animations hidden
	sslBaseAnimation[] function get()
		return Slots
	endFunction
endProperty

function Setup()
	Slots = new sslBaseAnimation[125]
	int i = Slots.Length
	while i
		i -= 1
		Slots[i] = GetNthAlias(i) as sslBaseAnimation
		Slots[i].Clear()
	endWhile
	(Quest.GetQuest("SexLabQuestAnimations") as sslAnimationDefaults).LoadAnimations()
endFunction

event OnInit()
	Setup()
endEvent
