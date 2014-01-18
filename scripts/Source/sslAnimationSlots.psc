scriptname sslAnimationSlots extends Quest

sslAnimationDefaults property Defaults auto
sslAnimationLibrary property Lib auto

sslBaseAnimation[] property Slots auto hidden
sslBaseAnimation[] property Animations hidden
	sslBaseAnimation[] function get()
		return Slots
	endFunction
endProperty

int property Slotted auto hidden
bool property FreeSlots hidden
	bool function get()
		return Slotted < Slots.Length
	endFunction
endProperty

;/-----------------------------------------------\;
;|	Search Animations                            |;
;\-----------------------------------------------/;

sslBaseAnimation[] function PickByActors(actor[] Positions, int limit = 64, bool aggressive = false)
	int[] genders = Lib.ActorLib.GenderCount(Positions)
	sslBaseAnimation[] Matches = GetByType(Positions.Length, genders[0], genders[1], -1, aggressive)
	if Matches.Length <= limit
		return Matches
	endIf

	int count = Matches.Length - 1
	sslBaseAnimation[] Picked = sslUtility.AnimationArray(limit)

	while limit
		int rand = Utility.RandomInt(0, count)
		if Picked.Find(Matches[rand]) == -1
			limit -= 1
			Picked[limit] = Matches[rand]
		endIf
		debug.trace(Picked)
	endWhile

	return Picked
endFunction

sslBaseAnimation[] function GetByDefault(int Males, int Females, bool IsAggressive = false, bool UsingBed = false)
	if Males == 0 && Females == 0
		return none ; No actors passed or creatures present
	endIf
	; Info
	int Actors = (Males + Females)
	bool SameSex = (Females == 2 && Males == 0) || (Males == 2 && Females == 0)
	; Search
	bool[] valid = sslUtility.BoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		; Check for appropiate enabled aniamtion
		valid[i] = Searchable(Slots[i]) && Actors == Slots[i].PositionCount
		; Suppress or ignore aggressive animation tags
		valid[i] = valid[i] && (IsAggressive == Slots[i].HasTag("Aggressive") || !Lib.bRestrictAggressive)
		; Suppress standing animations if on a bed
		valid[i] = valid[i] && (!UsingBed || (usingbed && !Slots[i].HasTag("Standing")))
		; Get SameSex + Non-SameSex
		if SameSex
			valid[i] = valid[i] && (Slots[i].HasTag("FM") || (Males == Slots[i].Males && Females == Slots[i].Females))
		; Ignore genders for 3P+
		elseIf Actors < 3
			valid[i] = valid[i] && Males == Slots[i].Males && Females == Slots[i].Females
		endIf
	endWhile
	sslBaseAnimation[] output = GetList(valid)
	_LogFound("GetByDefault", Males+", "+Females+", "+IsAggressive+", "+UsingBed, output)
	return output
endFunction

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

sslBaseAnimation[] function GetByTags(int actors, string tags, string tagsSuppressed = "", bool requireAll = true)
	string[] finding = sslUtility.ArgString(tags)
	if finding.Length == 0
		_Log("No tags given.", "GetByTags", "ERROR")
		return none
	endIf
	string[] suppressed = sslUtility.ArgString(tagsSuppressed)
	bool[] valid = sslUtility.BoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		valid[i] = Searchable(Slots[i]) && actors == Slots[i].PositionCount && (tagsSuppressed == "" || Slots[i].CheckTags(suppressed, false, true)) && Slots[i].CheckTags(finding, requireAll)
	endWhile
	sslBaseAnimation[] output = GetList(valid)
	_LogFound("GetByTags", actors+", "+finding+", "+suppressed+", "+requireAll, output)
	return output
endFunction

sslBaseAnimation[] function GetByTag(int actors, string tag1, string tag2 = "", string tag3 = "", string tagSuppress = "", bool requireAll = true)
	string tags = tag1
	if tag2 != ""
		tags += ","+tag2
	endIf
	if tag3 != ""
		tags += ","+tag3
	endIf
	return GetByTags(actors, tags, tagSuppress, requireAll)
endFunction

sslBaseAnimation[] function GetByType(int actors, int males = -1, int females = -1, int stages = -1, bool aggressive = false, bool sexual = true)
	bool[] valid = sslUtility.BoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		valid[i] = Searchable(Slots[i]) && actors == Slots[i].PositionCount && (males == -1 || males == Slots[i].Males) && (females == -1 || females == Slots[i].Females) \
		&& (stages == -1 || stages == Slots[i].StageCount) && (aggressive == Slots[i].HasTag("Aggressive") || !Lib.bRestrictAggressive) && (sexual == Slots[i].IsSexual)
	endWhile
	sslBaseAnimation[] output = GetList(valid)
	_LogFound("GetByType", actors+", "+males+", "+females+", "+stages+", "+aggressive+", "+sexual, output)
	return output
endFunction

sslBaseAnimation function GetBySlot(int slot)
	return Slots[slot]
endFunction

sslBaseAnimation[] function GetList(bool[] valid)
	int count = sslUtility.CountTrue(valid)
	if count < 1
		sslBaseAnimation[] empty
		return empty
	endIf
	sslBaseAnimation[] output = sslUtility.AnimationArray(count)
	int len = valid.Length
	int pos = valid.Find(true)
	while pos != -1
		count -= 1
		output[count] = Slots[pos]
		pos += 1
		if pos < len
			pos = valid.Find(true, pos)
		else
			pos = -1
		endIf
	endWhile
	return output
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
	return StorageUtil.StringListFind(self, "Registry", registrar)
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
	Claiming.Initialize()
	Claiming.Registry = registrar
	StorageUtil.StringListAdd(self, "Registry", registrar, false)
	Slotted = StorageUtil.StringListCount(self, "Registry")
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
;|	System Functions                             |;
;\-----------------------------------------------/;

function _Log(string log, string method, string type = "NOTICE", string arguments = "")
	Debug.Trace("--- sslAnimationSlots: SexLab Animation Slots ------------------------------")
	Debug.Trace(" "+type+": "+method+"("+arguments+")" )
	Debug.Trace("   "+log)
endFunction

function _LogFound(string method, string arguments, sslBaseAnimation[] results)
	string found = "Found ["+results.Length+"] Animations: "
	int i = results.Length
	while i
		i -= 1
		found += results[i].Name+", "
	endWhile
	Debug.Trace("--- SexLab Animation Search ------------------------------")
	Debug.Trace(" "+method+"("+arguments+")")
	Debug.Trace("   "+found)
	Debug.Trace("----------------------------------------------------------")
endFunction

function _Setup()
	Slots = new sslBaseAnimation[100]
	int i = 100
	while i
		i -= 1
		Slots[i] = GetNthAlias(i) as sslBaseAnimation
		Slots[i].Initialize()
	endWhile
	Initialize()
	Defaults.LoadAnimations()
	SendModEvent("SexLabSlotAnimations")
	Debug.Notification("$SSL_NotifyAnimationInstall")
endFunction

function Initialize()
	Slotted = 0
	StorageUtil.StringListClear(self, "Registry")
endFunction

function AddRace(Race creature)
endFunction
bool function HasRace(Race creature)
	return false
endFunction

; DEPRECATED: to be removed in 1.5
function _Upgrade140()
	int i = Slotted
	while i
		i -= 1
		sslBaseAnimation Anim = Slots[i]
		; Update tags
		string[] tags = Anim._DeprecatedTags()
		int n = tags.Length
		while n
			n -= 1
			Anim.AddTag(tags[n])
		endWhile
	endWhile
endFunction
