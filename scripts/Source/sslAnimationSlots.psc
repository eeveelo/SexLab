scriptname sslAnimationSlots extends Quest

import PapyrusUtil

; Animation storage
string[] Registry
Alias[] AliasSlots
int property Slotted auto hidden
sslBaseAnimation[] property Animations hidden
	sslBaseAnimation[] function get()
		return GetSlots(1, 128)
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
	bool[] Valid      = Utility.CreateBoolArray(Slotted)
	string[] Suppress = StringSplit(TagsSuppressed)
	string[] Search   = StringSplit(Tags)
	int i = Slotted
	while i
		i -= 1
		sslBaseAnimation Slot = GetBySlot(i)
		Valid[i] = Slot.Enabled && ActorCount == Slot.PositionCount && Slot.CheckTags(Search, RequireAll) && (TagsSuppressed == "" || !Slot.HasOneTag(Suppress))
		; Valid[i] = Slots[i].Enabled && ActorCount == Slots[i].PositionCount && (TagsSuppressed == "" || Slots[i].CheckTags(Suppress, false, true)) && Slots[i].CheckTags(Search, RequireAll)
	endWhile
	return GetList(valid)
endFunction

sslBaseAnimation[] function GetByType(int ActorCount, int Males = -1, int Females = -1, int StageCount = -1, bool Aggressive = false, bool Sexual = true)
	; Search
	bool[] Valid = Utility.CreateBoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		sslBaseAnimation Slot = GetBySlot(i)
		Valid[i] = Slot.Enabled && ActorCount == Slot.PositionCount && (Aggressive == Slot.HasTag("Aggressive") || !Config.RestrictAggressive) \
		&& (Males == -1 || Males == Slot.Males) && (Females == -1 || Females == Slot.Females) && (StageCount == -1 || StageCount == Slot.StageCount)
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
	bool[] Valid = Utility.CreateBoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		sslBaseAnimation Slot = GetBySlot(i)
		; Check for appropiate enabled aniamtion
		Valid[i] = Slot.Enabled && ActorCount == Slot.PositionCount
		; Suppress standing animations if on a bed
		Valid[i] = Valid[i] && (!UsingBed || (UsingBed && !Slot.HasTag("Standing")))
		; Suppress or ignore aggressive animation tags
		Valid[i] = Valid[i] && (!RestrictAggressive || IsAggressive == Slot.HasTag("Aggressive"))
		; Get SameSex + Non-SameSex
		if SameSex
			Valid[i] = Valid[i] && (Slot.HasTag("FM") || (Males == Slot.Males && Females == Slot.Females))
		; Ignore genders for 3P+
		elseIf ActorCount < 3
			Valid[i] = Valid[i] && Males == Slot.Males && Females == Slot.Females
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

int function PageCount(int perpage = 125)
	return (Slotted / perpage) + 1
endFunction

int function FindPage(string Registrar, int perpage = 125)
	int i = Registry.Find(Registrar)
	if i != -1
		return (i / perpage) + 1
	endIf
	return -1
endFunction

int function FindByName(string FindName)
	int i = Slotted
	while i
		i -= 1
		if GetBySlot(i).Name == FindName
			return i
		endIf
	endWhile
	return -1
endFunction

sslBaseAnimation function GetByName(string FindName)
	return GetBySlot(FindByName(FindName))
endFunction

sslBaseAnimation function GetBySlot(int index)
	if index >= 0 && index < Slotted
		return AliasSlots[index] as sslBaseAnimation
	endIf
	return none
endFunction

sslBaseAnimation[] function GetSlots(int page = 1, int perpage = 125)
	if (page * perpage) > AliasSlots.Length
		return sslUtility.AnimationArray(0)
	endIf
	sslBaseAnimation[] PageSlots = sslUtility.AnimationArray(perpage)
	int i = perpage
	int n = page * perpage
	while i
		i -= 1
		n -= 1
		if AliasSlots[n]
			PageSlots[i] = AliasSlots[n] as sslBaseAnimation
		endIf
	endWhile
	return PageSlots
endFunction

; sslBaseAnimation function GetEmpty()
; 	if Slotted < Slots.Length
; 		return Slots[Slotted]
; 	endIf
; 	return none
; endFunction

; ------------------------------------------------------- ;
; --- Misc API functions                              --- ;
; ------------------------------------------------------- ;

int function CountTag(sslBaseAnimation[] Anims, string Tags)
	string[] Checking = StringSplit(Tags)
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
		return Utility.CreateBoolArray(0)
	endIf
	bool[] Output     = Utility.CreateBoolArray(i)
	string[] Checking = StringSplit(Tags)
	int i = Anims.Length
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
		Count += (GetBySlot(i).Enabled as int)
	endWhile
	return Count
endFunction

int function FindByRegistrar(string Registrar)
	if Registrar != ""
		return Registry.Find(Registrar)
	endIf
	return -1
endFunction

sslBaseAnimation function GetbyRegistrar(string Registrar)
	return GetBySlot(FindByRegistrar(Registrar))
endFunction

bool function IsRegistered(string Registrar)
	return FindByRegistrar(Registrar) != -1
endFunction

sslBaseAnimation[] function GetList(bool[] Valid)
	sslBaseAnimation[] Output
	if Valid.Length > 0 && Valid.Find(true) != -1
		int n = Valid.Find(true)
		int i = CountBool(Valid, true)
		Output = sslUtility.AnimationArray(i)
		while n != -1
			i -= 1
			Output[i] = GetBySlot(n)
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
	endIf
	return Output
endFunction

string[] function GetSlotNames(int page = 1, int perpage = 125)
	return GetNames(GetSlots(page, perpage))
endfunction

string[] function GetNames(sslBaseAnimation[] SlotList)
	int i = SlotList.Length
	string[] Names = Utility.CreateStringArray(i)
	while i
		i -= 1
		if SlotList[i]
			Names[i] = SlotList[i].Name
		endIf
	endWhile
	if Names.Find("") != -1
		Names = PapyrusUtil.RemoveString(Names, "")
	endIf
	return Names
endFunction

sslBaseAnimation function RegisterAnimation(string Registrar, Form CallbackForm = none, ReferenceAlias CallbackAlias = none)
	; Return existing Animation
	if FindByRegistrar(Registrar) != -1
		return GetbyRegistrar(Registrar)
	endIf
	; Get free Animation slot
	int id = Register(Registrar)
	sslBaseAnimation Slot = GetBySlot(id)
	if id != -1 && Slot != none
		Slot.Initialize()
		Slot.Registry = Registrar
		Slot.Enabled  = true
		sslObjectFactory.SendCallback(Registrar, id, CallbackForm, CallbackAlias)
	endIf
	return Slot
endFunction

; ------------------------------------------------------- ;
; --- System Use Only                                 --- ;
; ------------------------------------------------------- ;

function Setup()
	GoToState("Locked")
	; Init slots
	Slotted    = 0	
	Registry   = Utility.CreateStringArray(375)
	AliasSlots = Utility.CreateAliasArray(375, GetNthAlias(0))

	; DEV TEMP: SKSE Beta workaround - clear used dummy aliases
	int i = AliasSlots.Length
	while i
		i -= 1
		AliasSlots[i] = none
	endWhile

	; Init Libraries
	PlayerRef = Game.GetPlayer()
	Form SexLabQuestFramework = Game.GetFormFromFile(0xD62, "SexLab.esm")
	if SexLabQuestFramework
		Config    = SexLabQuestFramework as sslSystemConfig
		ThreadLib = SexLabQuestFramework as sslThreadLibrary
		ActorLib  = SexLabQuestFramework as sslActorLibrary
	endIf
	; Init sslAnimationDefaults
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
	if Registry.Find(Registrar) != -1 || Slotted >= Registry.Length
		return -1
	endIf
	Slotted += 1
	int i = Registry.Find("")
	Registry[i]   = Registrar
	AliasSlots[i] = GetNthAlias(i)
	return i
endFunction

;/int function Register(string Registrar)
	int Slot = -1
	if Slotted < 384 && Registry.Find(Registrar) == -1
		Registry = PushString(Registry, Registrar)
		Slot     = Registry.Find(Registrar)
		Slotted  = Registry.Length
		Objects  = PushAlias(Objects, GetNthAlias(Slot))
		if Slot < 128
			Slots[Slot] = Objects[Slot] as sslBaseAnimation
		endIf
		GetBySlot(Slot).Prepare(Registrar)
	endIf
	return Slot
endFunction /;

bool function TestSlots()
	return true;PlayerRef && Config && ActorLib && ThreadLib && Slotted > 0 && Registry.Length == 375 && AliasSlots.Length == 375 && AliasSlots.Find(none) > 0 && Registry.Find("") > 0
endFunction

state Locked
	function Setup()
	endFunction
endState
