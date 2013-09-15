scriptname sslAnimationSlots extends Quest

sslAnimationDefaults property Defaults auto
sslAnimationLibrary property Lib auto

sslBaseAnimation[] Slots
sslBaseAnimation[] property Animations hidden
	sslBaseAnimation[] function get()
		return Slots
	endFunction
endProperty

string[] registry
int slotted

bool property FreeSlots hidden
	bool function get()
		return slotted < 100
	endFunction
endProperty

;/-----------------------------------------------\;
;|	Search Animations                            |;
;\-----------------------------------------------/;

sslBaseAnimation function GetByName(string findName)
	int i = 0
	while i < slotted
		if Slots[i].Registered && Slots[i].Name == findName
			return Slots[i]
		endIf
		i += 1
	endWhile
	return none
endFunction

sslBaseAnimation[] function GetByTag(int actors, string tag1, string tag2 = "", string tag3 = "", string tagSuppress = "", bool requireAll = true)
	sslBaseAnimation[] animReturn
	int i = 0
	while i < slotted
		if Slots[i].Registered && Slots[i].Enabled && Slots[i].ActorCount() == actors
			bool check1 = Slots[i].HasTag(tag1)
			bool check2 = Slots[i].HasTag(tag2)
			bool check3 = Slots[i].HasTag(tag3)
			bool supress = Slots[i].HasTag(tagSuppress)
			if requireAll && check1 && (check2 || tag2 == "") && (check3 || tag3 == "") && !(supress && tagSuppress != "")
				animReturn = sslUtility.PushAnimation(Slots[i], animReturn)
			elseif !requireAll && (check1 || check2 || check3) && !(supress && tagSuppress != "")
				animReturn = sslUtility.PushAnimation(Slots[i], animReturn)
			; else
				; debug.trace("Rejecting "+Slots[i].Name+" based on "+check1+check2+check3+supress)
			endIf
		endIf
		i += 1
	endWhile
	; Debug.Trace("SexLab Get Animations By Tag Count: "+animReturn.Length)
	; Debug.Trace("SexLab Get Animations By Tag: "+animReturn)
	return animReturn
endFunction

sslBaseAnimation[] function GetByType(int actors, int males = -1, int females = -1, int stages = -1, bool aggressive = false, bool sexual = true)
	sslBaseAnimation[] animReturn
	int i = 0
	while i < slotted
		if Slots[i].Registered && Slots[i].Enabled
			bool accepted = true
			if actors != Slots[i].ActorCount()
				accepted = false
			endIf
			if accepted && males != -1 && males != Slots[i].MaleCount()
				accepted = false
			endIf
			if accepted && females != -1 && females != Slots[i].FemaleCount()
				accepted = false
			endIf
			if accepted && stages != -1 && stages != Slots[i].StageCount()
				accepted = false
			endIf
			if accepted && (aggressive != Slots[i].HasTag("Aggressive") && Lib.bRestrictAggressive)
				accepted = false
			endIf
			if accepted && sexual != Slots[i].IsSexual()
				accepted = false
			endIf
			; Still accepted? Push it's return
			if accepted
				animReturn = sslUtility.PushAnimation(Slots[i], animReturn)
			endIf
		endIf
		i += 1
	endWhile
	; Debug.Trace("SexLab Get Animations By Type Count: "+animReturn.Length)
	; Debug.Trace("SexLab Get Animations By Type: "+animReturn)
	return animReturn
endFunction

sslBaseAnimation function GetBySlot(int slot)
	return Slots[slot]
endFunction

;/-----------------------------------------------\;
;|	Locate Animations                            |;
;\-----------------------------------------------/;

int function FindByName(string findName)
	int i = 0
	while i < slotted
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
	return Slots[slotted]
endFunction

int function Register(sslBaseAnimation Claiming, string registrar)
	registry = sslUtility.PushString(registrar, registry)
	slotted = registry.Length
	Claiming.Initialize()
	return Slots.Find(Claiming)
endFunction

int function GetCount(bool ignoreDisabled = true)
	if !ignoreDisabled
		return slotted
	endIf
	int count = 0
	int i = 0
	while i < slotted
		if Slots[i].Registered && Slots[i].Enabled
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

;/-----------------------------------------------\;
;|	System Animations                            |;
;\-----------------------------------------------/;

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

	string[] init
	registry = init
	slotted = 0

	Defaults.LoadAnimations()

	SendModEvent("SexLabSlotAnimations")
endFunction