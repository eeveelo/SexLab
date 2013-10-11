scriptname sslCreatureAnimationSlots extends sslAnimationSlots

sslCreatureAnimationDefaults property CreatureDefaults auto

form[] ValidRaces
form[] property CreatureRaces hidden
	form[] function get()
		return ValidRaces
	endFunction
endProperty

sslBaseAnimation[] function GetByRace(int actors, Race creature)
	sslBaseAnimation[] output
	int i
	while i < Slotted
		sslBaseAnimation Anim = Slots[i]
		if Searchable(anim) && Anim.HasRace(creature) && actors == Anim.ActorCount()
			output = sslUtility.PushAnimation(anim, output)
		endIf
		i += 1
	endWhile
	_LogFound("GetByRace", actors+", "+creature.GetName(), output)
	return output
endFunction

bool function HasAnimation(Race creature, Race creature2 = none)
	int i
	while i < Slotted
		sslBaseAnimation Anim = Slots[i]
		if Anim.Registered && Anim.HasRace(creature) && (creature2 == none || Anim.HasRace(creature2))
			return true
		endIf
		i += 1
	endWhile
	return false
endFunction

bool function HasRace(Race creature)
	return ValidRaces.Length != 0 && ValidRaces.Find(creature) != -1
endFunction

function AddRace(Race creature)
	if !HasRace(creature)
		ValidRaces = sslUtility.PushForm(creature, ValidRaces)
	endIf
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
	Debug.Notification("$SSL_NotifyCreatureAnimationInstall")
endFunction

function Initialize()
	parent.Initialize()
	form[] fDel
	ValidRaces = fDel
endFunction