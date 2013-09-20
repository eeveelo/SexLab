scriptname sslAnimationSlots extends Quest

sslAnimationDefaults property Defaults auto
sslAnimationLibrary property Lib auto

sslBaseAnimation[] property Slots auto hidden
sslBaseAnimation[] property Animations hidden
	sslBaseAnimation[] function get()
		return Slots
	endFunction
endProperty

string[] registry
int property Slotted auto hidden

bool property FreeSlots hidden
	bool function get()
		return Slotted < Slots.Length
	endFunction
endProperty

;/-----------------------------------------------\;
;|	Search Animations                            |;
;\-----------------------------------------------/;

sslBaseAnimation function GetByName(string findName)
	int i = 0
	while i < Slotted
		if Slots[i].Registered && Slots[i].Name == findName
			return Slots[i]
		endIf
		i += 1
	endWhile
	return none
endFunction

sslBaseAnimation[] function GetByTags(int actors, string[] tags, string tagSuppress = "", bool requireAll = true)
	if tags.Length == 0
		_Log("No tags given.", "GetByTags", "ERROR")
		return none
	endIf
	sslBaseAnimation[] output
	int i = Slotted
	while i
		i -= 1
		sslBaseAnimation anim = Slots[i]
		if Searchable(anim) && actors == anim.ActorCount() && (tagSuppress == "" || !anim.HasTag(tagSuppress)) && anim.CheckTags(tags, requireAll)
			output = sslUtility.PushAnimation(anim, output)
		endIf
	endWhile
	_LogFound("GetByTags", actors+", "+tags+", "+tagSuppress+", "+requireAll, output)
	return output
endFunction

sslBaseAnimation[] function GetByTag(int actors, string tag1, string tag2 = "", string tag3 = "", string tagSuppress = "", bool requireAll = true)
	string[] tags = new string[3]
	tags[0] = tag1
	tags[1] = tag2
	tags[2] = tag3
	return GetByTags(actors, tags, tagSuppress, requireAll)
endFunction

sslBaseAnimation[] function GetByType(int actors, int males = -1, int females = -1, int stages = -1, bool aggressive = false, bool sexual = true)
	sslBaseAnimation[] output
	int i = Slotted
	while i
		i -= 1
		if Searchable(Slots[i])
			sslBaseAnimation anim = Slots[i]
			if (actors == anim.ActorCount()) && (males == -1 || males == anim.MaleCount()) && (females == -1 || females == anim.FemaleCount()) \
			&& (stages == -1 || stages == anim.StageCount()) && (aggressive == anim.HasTag("Aggressive") || !Lib.bRestrictAggressive) && (sexual == anim.IsSexual)
				output = sslUtility.PushAnimation(anim, output)
			endIf
		endIf
	endWhile
	_LogFound("GetByType", actors+", "+males+", "+females+", "+stages+", "+aggressive+", "+sexual, output)
	return output
endFunction

sslBaseAnimation function GetBySlot(int slot)
	return Slots[slot]
endFunction

;/-----------------------------------------------\;
;|	Locate Animations                            |;
;\-----------------------------------------------/;

int function FindByName(string findName)
	int i = 0
	while i < Slotted
		if Slots[i].Registered && Slots[i].Name == findName
			return i
		endIf
		i += 1
	endWhile
	return -1
endFunction

int function FindByRegistrar(string registrar)
	return registry.Find(registrar)
endFunction

int function Find(sslBaseAnimation findAnim)
	return Slots.Find(findAnim)
endFunction

;/-----------------------------------------------\;
;|	Manage Animations                            |;
;\-----------------------------------------------/;

sslBaseAnimation function GetFree()
	return Slots[Slotted]
endFunction

int function Register(sslBaseAnimation Claiming, string registrar)
	registry = sslUtility.PushString(registrar, registry)
	Slotted = registry.Length
	Claiming.Initialize()
	return Slots.Find(Claiming)
endFunction

int function GetCount(bool ignoreDisabled = true)
	if !ignoreDisabled
		return Slotted
	endIf
	int count = 0
	int i = 0
	while i < Slotted
		if Searchable(Slots[i])
			count += 1
		endIf
		i += 1
	endWhile
	return count
endFunction

sslBaseAnimation[] function MergeLists(sslBaseAnimation[] list1, sslBaseAnimation[] list2)
	int i = 0
	while i < list2.Length
		list1 = sslUtility.PushAnimation(list2[i], list1)
		i += 1
	endWhile
	return list1
endFunction

bool function Searchable(sslBaseAnimation anim)
	return anim.Registered && anim.Enabled
endFunction

;/-----------------------------------------------\;
;|	System Animations                            |;
;\-----------------------------------------------/;

function _Log(string log, string method, string type = "NOTICE", string arguments = "")
	Debug.Trace("--------------------------------------------------------------------------------------------")
	Debug.Trace("--- sslAnimationSlots: SexLab Animation Slots---")
	Debug.Trace("--------------------------------------------------------------------------------------------")
	Debug.Trace(" "+type+": "+method+"("+arguments+")" )
	Debug.Trace("   "+log)
	Debug.Trace("--------------------------------------------------------------------------------------------")
endFunction

function _LogFound(string method, string arguments, sslBaseAnimation[] results)
	string log = "Found ["+results.Length+"] Animations: "
	int i = results.Length
	while i
		i -= 1
		log += results[i].Name
		if i > 0
			log += ", "
		endIf
	endWhile
	_Log(log, method, "NOTICE", arguments)
endFunction

function _Setup()
	Slots = new sslBaseAnimation[100]

	int i
	while i < 100
		if i < 10
			Slots[i] = GetAliasByName("AnimationSlot00"+i) as sslBaseAnimation
		else
			Slots[i] = GetAliasByName("AnimationSlot0"+i) as sslBaseAnimation
		endIf
		Slots[i].Initialize()
		i += 1
	endWhile

	Initialize()

	Defaults.LoadAnimations()

	SendModEvent("SexLabSlotAnimations")
endFunction

function Initialize()
	string[] init
	registry = init
	Slotted = 0
endFunction