scriptname sslAnimationSlots extends Quest

import PapyrusUtil

; Animation storage
string[] Registry
int property Slotted auto hidden
sslBaseAnimation[] property Slots auto hidden
sslBaseAnimation[] property Animations hidden
	sslBaseAnimation[] function get()
		return Slots
	endFunction
endProperty

; Properties for creature script access
sslSystemConfig property Config auto
sslActorLibrary property ActorLib auto
sslThreadLibrary property ThreadLib auto
Actor property PlayerRef auto

; ------------------------------------------------------- ;
; --- Animation Filtering                             --- ;
; ------------------------------------------------------- ;

sslBaseAnimation[] function GetByTags(int ActorCount, string Tags, string TagsSuppressed = "", bool RequireAll = true)
	string[] Suppress = StringSplit(TagsSuppressed)
	string[] Search   = StringSplit(Tags)
	bool[] Valid      = BoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		Valid[i] = Slots[i].Enabled && ActorCount == Slots[i].PositionCount && Slots[i].CheckTags(Search, RequireAll) && (TagsSuppressed == "" || !Slots[i].HasOneTag(Suppress))
		; Valid[i] = Slots[i].Enabled && ActorCount == Slots[i].PositionCount && (TagsSuppressed == "" || Slots[i].CheckTags(Suppress, false, true)) && Slots[i].CheckTags(Search, RequireAll)
	endWhile
	return GetList(valid)
endFunction

sslBaseAnimation[] function GetByType(int ActorCount, int Males = -1, int Females = -1, int StageCount = -1, bool Aggressive = false, bool Sexual = true)
	; Search
	bool[] Valid = BoolArray(Slotted)
	int i = Slotted
	while i
		i -=1
		Valid[i] = Slots[i].Enabled && ActorCount == Slots[i].PositionCount && (Aggressive == Slots[i].HasTag("Aggressive") || !Config.RestrictAggressive) \
		&& (Males == -1 || Males == Slots[i].Males) && (Females == -1 || Females == Slots[i].Females) && (StageCount == -1 || StageCount == Slots[i].StageCount) && Sexual == Slots[i].IsSexual
	endWhile
	return GetList(Valid)
endFunction

sslBaseAnimation[] function PickByActors(Actor[] Positions, int Limit = 64, bool Aggressive = false)
	int[] Genders = ActorLib.GenderCount(Positions)
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
	bool[] Valid = BoolArray(Slotted)
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

sslBaseAnimation[] function RemoveTagged(sslBaseAnimation[] Anims, string Tags)
	bool[] Valid  = FindTagged(Anims, Tags)
	int found = CountBool(Valid, true)
	if found == 0
		return Anims
	endIf
	int i = Valid.Length
	int n = (i - found)
	sslBaseAnimation[] Output = sslUtility.AnimationArray(n)
	while i && n
		i -= 1
		if !Valid[i]
			n -= 1
			Output[n] = Anims[i]
		endIf
	endwhile
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

int function CountTag(sslBaseAnimation[] Anims, string Tags)
	string[] Checking = PapyrusUtil.StringSplit(Tags)
	if Tags == "" || Checking.Length == 0
		return 0
	endIf
	int count
	int i = Anims.Length
	while i
		i -= 1
		count += Anims[i].HasOneTag(Checking) as int
	endWhile
	return count
endFunction

bool[] function FindTagged(sslBaseAnimation[] Anims, string Tags)
	if Anims.Length < 1 || Tags == ""
		return BoolArray(0)
	endIf
	int i = Anims.Length
	bool[] Output = BoolArray(i)
	string[] Checking = PapyrusUtil.StringSplit(Tags)
	while i
		i -= 1
		Output[i] = Anims[i].HasOneTag(Checking)
	endWhile
	return Output
endFunction

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

int function FindByRegistrar(string Registrar)
	if Registrar == ""
		return -1
	endIf
	return Registry.Find(Registrar)
endFunction

sslBaseAnimation function GetbyRegistrar(string Registrar)
	return GetBySlot(FindByRegistrar(Registrar))
endFunction

bool function IsRegistered(string Registrar)
	return FindByRegistrar(Registrar) != -1
endFunction

sslBaseAnimation[] function GetList(bool[] Valid)
	if !Valid || Valid.Length < 1 || Valid.Find(true) == -1
		return none ; OR empty array?
	endIf
	int i = CountBool(Valid, true)
	int n = Valid.Find(true)
	sslBaseAnimation[] Output = sslUtility.AnimationArray(i)
	; Load out array with valid animation slots
	while n != -1
		i -= 1
		Output[i] = Slots[n]
		n += 1
		if n < Slotted
			n = Valid.Find(true, n)
		else
			n = -1
		endIf
	endWhile
	; Only bother with logging the selected animations if debug mode enabled.
	if Config.DebugMode
		string List = "SEXLAB - Found Animations - "
		i = Output.Length
		while i
			i -= 1
			List += "["+Output[i].Name+"] "
		endWhile
		Debug.Trace(List)
		MiscUtil.PrintConsole(List)
	endIf
	return Output
endFunction

string[] function GetNames()
	string[] Output = StringArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		Output[i] = Slots[i].Name
	endWhile
	return Output
endFunction

sslBaseAnimation function RegisterAnimation(string Registrar, Form CallbackForm = none, ReferenceAlias CallbackAlias = none)
	; Return existing Animation
	if FindByRegistrar(Registrar) != -1
		return GetbyRegistrar(Registrar)
	endIf
	; Get free Animation slot
	int id = Register(Registrar)
	if id != -1
		; Get slot
		sslBaseAnimation Slot = GetNthAlias(id) as sslBaseAnimation
		Animations[id] = Slot
		; Init Animation
		Slot.Initialize()
		Slot.Registry = Registrar
		Slot.Enabled = true
		; Send load event
		sslObjectFactory.SendCallback(Registrar, id, CallbackForm, CallbackAlias)
	endIf
endFunction

; ------------------------------------------------------- ;
; --- System Use Only                                 --- ;
; ------------------------------------------------------- ;

function Setup()
	GoToState("Locked")
	; Init slots
	Slotted  = 0
	Registry = new string[125]
	Slots    = new sslBaseAnimation[125]
	; Init Libraries
	PlayerRef = Game.GetPlayer()
	Form SexLabQuestFramework = Game.GetFormFromFile(0xD62, "SexLab.esm")
	if SexLabQuestFramework
		Config    = SexLabQuestFramework as sslSystemConfig
		ThreadLib = SexLabQuestFramework as sslThreadLibrary
		ActorLib  = SexLabQuestFramework as sslActorLibrary
	endIf
	; Init defaults
	RegisterSlots()
	GoToState("")
endFunction

function RegisterSlots()
	; Register default animation
	(Game.GetFormFromFile(0x639DF, "SexLab.esm") as sslAnimationDefaults).LoadAnimations()
	; Send mod event for 3rd party animation
	ModEvent.Send(ModEvent.Create("SexLabSlotAnimations"))
	Debug.Notification("$SSL_NotifyAnimationInstall")
endFunction

int function Register(string Registrar)
	int i = Registry.Find("")
	if Registry.Find(Registrar) == -1 && i != -1
		Registry[i] = Registrar
		Slotted = i + 1
		return i
	endIf
	return -1
endFunction

bool function TestSlots()
	return PlayerRef && Config && ActorLib && ThreadLib && Slotted > 0 && Registry.Length == 125 && Slots.Length == 125 && Slots.Find(none) > 0 && Registry.Find("") > 0
endFunction

state Locked
	function Setup()
	endFunction
endState
