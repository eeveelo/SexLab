scriptname sslCreatureAnimationSlots extends sslAnimationSlots

sslCreatureAnimationDefaults property CreatureDefaults auto

form[] ValidRaces
form[] property CreatureRaces hidden
	form[] function get()
		return ValidRaces
	endFunction
endProperty

sslBaseAnimation[] function GetByRace(int actors, Race creature)
	bool[] valid = sslUtility.BoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		valid[i] = Searchable(Slots[i]) && Slots[i].HasRace(creature) && actors == Slots[i].ActorCount()
	endWhile
	sslBaseAnimation[] output = GetList(valid)
	_LogFound("GetByRace", actors+", "+creature.GetName(), output)
	return output
endFunction

bool function HasAnimation(Race creature, Race creature2 = none)
	int i = Slotted
	while i
		i -= 1
		if Searchable(Slots[i]) && Slots[i].HasRace(creature) && (creature2 == none || Slots[i].HasRace(creature2))
			return true
		endIf
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
	int i = 50
	while i
		i -= 1
		Slots[i] = GetNthAlias(i) as sslBaseAnimation
		Slots[i].Initialize()
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
