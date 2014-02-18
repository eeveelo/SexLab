scriptname sslAnimationSlots extends Quest

; Library for animation
sslAnimationLibrary property Lib auto hidden

int property Slotted auto hidden
; Animation readonly storage
sslBaseAnimation[] Slots
sslBaseAnimation[] property Animations hidden
	sslBaseAnimation[] function get()
		return Slots
	endFunction
endProperty

; ------------------------------------------------------- ;
; --- Animation Filtering                             --- ;
; ------------------------------------------------------- ;

sslBaseAnimation[] function GetByDefault(int Males, int Females, bool IsAggressive = false, bool UsingBed = false, bool RestrictAggressive = true)
	if Males == 0 && Females == 0
		return none ; No actors passed or creatures present
	endIf
	; Info
	int Actors = (Males + Females)
	bool SameSex = (Females == 2 && Males == 0) || (Males == 2 && Females == 0)
	; Search
	bool[] Valid = sslUtility.BoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		; Check for appropiate enabled aniamtion
		Valid[i] = Slots[i].Registered && Slots[i].Enabled && actors == Slots[i].PositionCount
		; Suppress standing animations if on a bed
		Valid[i] = Valid[i] && (!UsingBed || (UsingBed && !Slots[i].HasTag("Standing")))
		; Suppress or ignore aggressive animation tags
		Valid[i] = Valid[i] && (!RestrictAggressive || IsAggressive == Slots[i].HasTag("Aggressive"))
		; Get SameSex + Non-SameSex
		if SameSex
			Valid[i] = Valid[i] && (Slots[i].HasTag("FM") || (Males == Slots[i].Males && Females == Slots[i].Females))
		; Ignore genders for 3P+
		elseIf Actors < 3
			Valid[i] = Valid[i] && Males == Slots[i].Males && Females == Slots[i].Females
		endIf
	endWhile
	return GetList(Valid)
endFunction

sslBaseAnimation[] function GetByTags(int actors, string tags, string tagsSuppressed = "", bool requireAll = true)
	string[] Search = sslUtility.ArgString(tags)
	if Search.Length == 0
		; _Log("No tags given.", "GetByTags", "ERROR")
		return none
	endIf
	string[] Suppress = sslUtility.ArgString(tagsSuppressed)
	bool[] Valid = sslUtility.BoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		Valid[i] = Slots[i].Registered && Slots[i].Enabled && actors == Slots[i].PositionCount && (tagsSuppressed == "" || Slots[i].CheckTags(Suppress, false, true)) && Slots[i].CheckTags(Search, requireAll)
	endWhile
	return GetList(valid)
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

; ------------------------------------------------------- ;
; --- Find single animation object                    --- ;
; ------------------------------------------------------- ;

sslBaseAnimation function GetByName(string name)
	int i
	while i < Slotted
		if Slots[i].Name == name
			return Slots[i]
		endIf
		i += 1
	endWhile
	return none
endFunction

sslBaseAnimation function GetBySlot(int index)
	return Slots[index]
endFunction

int function FindByRegistrar(string Registrar)
	return StorageUtil.StringListFind(self, "Registry", Registrar)
endFunction

sslBaseAnimation function GetEmpty()
	if Slotted < Slots.Length
		return Slots[Slotted]
	endIf
	return none
endFunction

; ------------------------------------------------------- ;
; --- System Use Only                                 --- ;
; ------------------------------------------------------- ;

sslBaseAnimation function Register(string Registrar)
	if FindByRegistrar(Registrar) == -1 && Slotted < Slots.Length
		StorageUtil.StringListAdd(self, "Registry", Registrar, false)
		sslBaseAnimation Claiming = Slots[Slotted]
		Claiming.Initialize()
		Claiming.Registry = Registrar
		Slotted = StorageUtil.StringListCount(self, "Registry")
		return Claiming
	endIf
	return none
endFunction

sslBaseAnimation[] function GetList(bool[] Valid)
	int i = sslUtility.CountTrue(Valid)
	if i == 0
		return none ; OR empty array?
	endIf
	string Anims
	sslBaseAnimation[] output = sslUtility.AnimationArray(i)
	int pos = valid.Find(true)
	while pos != -1 && pos < Slotted
		i -= 1
		output[i] = Slots[pos]
		pos = valid.Find(true, (pos + 1))
		Anims += output[i].Name+", "
	endWhile
	MiscUtil.PrintConsole("Found Animations("+output.Length+"): "+Anims)
	return output
endFunction

function Setup()
	Initialize()
	(Quest.GetQuest("SexLabQuestAnimations") as sslAnimationDefaults).LoadAnimations()
	ModEvent.Send(ModEvent.Create("SexLabSlotAnimations"))
	Debug.Notification("$SSL_NotifyAnimationInstall")
endFunction

function Initialize()
	Slots = new sslBaseAnimation[125]
	int i = Slots.Length
	while i
		i -= 1
		Slots[i] = (GetNthAlias(i) as sslBaseAnimation)
		Slots[i].Clear()
	endWhile
	Slotted = 0
	StorageUtil.StringListClear(self, "Registry")
	Lib = (Quest.GetQuest("SexLabQuestFramework") as sslAnimationLibrary)
endFunction

