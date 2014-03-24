scriptname sslAnimationSlots extends Quest

int property Slotted auto hidden
; Animation readonly storage
sslBaseAnimation[] property Slots auto hidden
sslBaseAnimation[] property Animations hidden
	sslBaseAnimation[] function get()
		return Slots
	endFunction
endProperty

; Local use
sslSystemConfig Config
sslThreadLibrary Lib

; ------------------------------------------------------- ;
; --- Animation Filtering                             --- ;
; ------------------------------------------------------- ;

sslBaseAnimation[] function GetByTags(int ActorCount, string Tags, string TagsSuppressed = "", bool RequireAll = true)
	string[] Search = sslUtility.ArgString(Tags)
	if Search.Length == 0
		return none
	endIf
	string[] Suppress = sslUtility.ArgString(TagsSuppressed)
	bool[] Valid = new bool[125]
	int i = Slotted
	while i
		i -= 1
		Valid[i] = Slots[i].Enabled && ActorCount == Slots[i].PositionCount && (TagsSuppressed == "" || Slots[i].CheckTags(Suppress, false, true)) && Slots[i].CheckTags(Search, RequireAll)
	endWhile
	return GetList(valid)
endFunction

sslBaseAnimation[] function GetByType(int ActorCount, int Males = -1, int Females = -1, int StageCount = -1, bool Aggressive = false, bool Sexual = true)
	; Search
	bool[] Valid = new bool[125]
	int i = Slotted
	while i
		i -=1
		Valid[i] = Slots[i].Enabled && ActorCount == Slots[i].PositionCount && (Aggressive == Slots[i].HasTag("Aggressive") || !Config.bRestrictAggressive) \
		&& (Males == -1 || Males == Slots[i].Males) && (Females == -1 || Females == Slots[i].Females) && (StageCount == -1 || StageCount == Slots[i].StageCount) && Sexual == Slots[i].IsSexual
	endWhile
	return GetList(Valid)
endFunction

sslBaseAnimation[] function PickByActors(Actor[] Positions, int Limit = 64, bool Aggressive = false)
	int[] Genders = Lib.ActorLib.GenderCount(Positions)
	sslBaseAnimation[] Matches = GetByDefault(Genders[0], Genders[1], Aggressive)
	if Matches.Length <= Limit
		return Matches
	endIf
	; Select random from within limit
	sslBaseAnimation[] Picked = sslUtility.AnimationArray(Limit)
	int i = Matches.Length
	while i && Limit
		i -= 1
		Limit -= 1
		; Check random index between 0 and before current
		int r = Utility.RandomInt(0, (i - 1))
		if Picked.Find(Matches[r]) == -1
			Picked[Limit] = Matches[r] ; Use random index
		else
			Picked[Limit] = Matches[i] ; Random index was used, use current index
		endIf
	endWhile
	return Matches
endFunction

sslBaseAnimation[] function GetByDefault(int Males, int Females, bool IsAggressive = false, bool UsingBed = false, bool RestrictAggressive = true)
	if Males == 0 && Females == 0
		return none ; No actors passed or creatures present
	endIf
	; Info
	int ActorCount = (Males + Females)
	bool SameSex = (Females == 2 && Males == 0) || (Males == 2 && Females == 0)
	; Search
	bool[] Valid = new bool[125]
	int i = Slotted
	while i
		i -= 1
		; Check for appropiate enabled aniamtion
		Valid[i] = Slots[i].Enabled && ActorCount == Slots[i].PositionCount
		; Suppress standing animations if on a bed
		Valid[i] = Valid[i] && (!UsingBed || (UsingBed && !Slots[i].HasTag("Standing")))
		; Suppress or ignore aggressive animation tags
		Valid[i] = Valid[i] && (!RestrictAggressive || IsAggressive == Slots[i].HasTag("Aggressive"))
		; Get SameSex + Non-SameSex
		if SameSex
			Valid[i] = Valid[i] && (Slots[i].HasTag("FM") || (Males == Slots[i].Males && Females == Slots[i].Females))
		; Ignore genders for 3P+
		elseIf ActorCount < 3
			Valid[i] = Valid[i] && Males == Slots[i].Males && Females == Slots[i].Females
		endIf
	endWhile
	return GetList(Valid)
endFunction

sslBaseAnimation[] function MergeLists(sslBaseAnimation[] List1, sslBaseAnimation[] List2)
	int Count = List2.Length
	int i = List2.Length
	while i
		i -= 1
		Count -= ((List1.Find(List2[i]) != -1) as int)
	endWhile
	sslBaseAnimation[] Output = sslUtility.IncreaseAnimation(Count, List1)
	i = List2.Length
	while i && Count
		i -= 1
		if List1.Find(List2[i]) == -1
			Count -= 1
			Output[Count] = List2[i]
		endIf
	endWhile
	return Output
endFunction

; ------------------------------------------------------- ;
; --- Find single animation object                    --- ;
; ------------------------------------------------------- ;

int function FindByName(string FindName)
	int i = Slotted
	while i
		i -= 1
		if Slots[i].Name == FindName
			return i
		endIf
	endWhile
	return -1
endFunction

sslBaseAnimation function GetByName(string FindName)
	return GetBySlot(FindByName(FindName))
endFunction

sslBaseAnimation function GetBySlot(int index)
	if index < 0 || index >= Slotted
		return none
	endIf
	return Slots[index]
endFunction

sslBaseAnimation function GetEmpty()
	if Slotted < Slots.Length
		return Slots[Slotted]
	endIf
	return none
endFunction

; ------------------------------------------------------- ;
; --- Misc API functions                              --- ;
; ------------------------------------------------------- ;

int function GetCount(bool IgnoreDisabled = true)
	if !IgnoreDisabled
		return Slotted
	endIf
	int Count
	int i = Slotted
	while i < Slotted
		i -= 1
		Count += (Slots[i].Enabled as int)
	endWhile
	return Count
endFunction

; ------------------------------------------------------- ;
; --- System Use Only                                 --- ;
; ------------------------------------------------------- ;

int function FindByRegistrar(string Registrar)
	return StorageUtil.StringListFind(self, "Animations", Registrar)
endFunction

bool function IsRegistered(string Registrar)
	return StorageUtil.StringListFind(self, "Animations", Registrar) != -1
endFunction

sslBaseAnimation function Register(string Registrar)
	if FindByRegistrar(Registrar) == -1 && Slotted < Slots.Length
		sslBaseAnimation Slot = GetNthAlias(Slotted) as sslBaseAnimation
		Slots[Slotted] = Slot
		StorageUtil.StringListAdd(self, "Animations", Registrar, false)
		Slotted = StorageUtil.StringListCount(self, "Animations")
		return Slots[(Slotted - 1)]
	endIf
	return none
endFunction

sslBaseAnimation[] function GetList(bool[] Valid)
	int i = sslUtility.CountTrue(Valid)
	if i == 0
		return none ; OR empty array?
	endIf
	string Anims
	sslBaseAnimation[] Output = sslUtility.AnimationArray(i)
	int pos = Valid.Find(true)
	while pos != -1 && pos < Slotted
		i -= 1
		Output[i] = Slots[pos]
		pos = Valid.Find(true, (pos + 1))
		Anims += Output[i].Name+", "
	endWhile
	Lib.Log("Found Animations("+Output.Length+"): "+Anims)
	return Output
endFunction

function Setup()
	GoToState("Setup")
endFunction

state Setup
	event OnBeginState()
		RegisterForSingleUpdate(0.5)
	endEvent
	event OnUpdate()
		; Init variables
		Slotted = 0
		Slots = new sslBaseAnimation[125]
		StorageUtil.StringListClear(self, "Animations")
		Lib = Quest.GetQuest("SexLabQuestFramework") as sslThreadLibrary
		Config = Quest.GetQuest("SexLabQuestFramework") as sslSystemConfig
		; Register default animations
		sslAnimationDefaults Defaults = Quest.GetQuest("SexLabQuestAnimations") as sslAnimationDefaults
		Defaults.Slots = self
		Defaults.LoadAnimations()
		; Send mod event for 3rd party animations
		ModEvent.Send(ModEvent.Create("SexLabSlotAnimations"))
		Debug.Notification("$SSL_NotifyAnimationInstall")
		GoToState("")
	endEvent
endState
