scriptname sslCreatureAnimationSlots extends sslAnimationSlots

sslCreatureAnimationDefaults property CreatureDefaults auto

sslBaseAnimation[] function GetByRace(int actors, Race creature)
	sslBaseAnimation[] output
	int i
	while i < Slotted
		sslBaseAnimation anim = Slots[i]
		if Searchable(anim) && anim.HasRace(creature) && actors == anim.ActorCount()
			output = sslUtility.PushAnimation(anim, output)
		endIf
		i += 1
	endWhile
	_LogFound("GetByRace", actors+", "+creature.GetName(), output)
	return output
endFunction

bool function HasAnimation(Race creature)
	int i
	while i < Slotted
		if Slots[i].Registered && Slots[i].HasRace(creature) && Slots[i].Enabled
			return true
		endIf
		i += 1
	endWhile
	return false
endFunction

function _Setup()
	Slots = new sslBaseAnimation[50]

	int i
	while i < 50
		if i < 10
			Slots[i] = GetAliasByName("CreatureAnimationSlot00"+i) as sslBaseAnimation
		else
			Slots[i] = GetAliasByName("CreatureAnimationSlot0"+i) as sslBaseAnimation
		endIf
		Slots[i].Initialize()
		i += 1
	endWhile

	Initialize()

	CreatureDefaults.LoadAnimations()

	SendModEvent("SexLabSlotCreatureAnimations")
endFunction