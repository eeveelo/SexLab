scriptname sslAnimationSlots extends Quest

import PapyrusUtil

Alias[] Objects
string[] Registry
int property Slotted auto hidden
sslBaseAnimation[] property Animations hidden
	sslBaseAnimation[] function get()
		return GetSlots(1, 128)
	endFunction
endProperty

Actor property PlayerRef auto
sslSystemConfig property Config auto
sslActorLibrary property ActorLib auto
sslThreadLibrary property ThreadLib auto

; ------------------------------------------------------- ;
; --- Animation Filtering                             --- ;
; ------------------------------------------------------- ;

sslBaseAnimation[] function GetByTags(int ActorCount, string Tags, string TagsSuppressed = "", bool RequireAll = true)
	Log("GetByTags(ActorCount="+ActorCount+", Tags="+Tags+", TagsSuppressed="+TagsSuppressed+", RequireAll="+RequireAll+")")
	bool[] Valid      = Utility.CreateBoolArray(Slotted)
	string[] Suppress = StringSplit(TagsSuppressed)
	string[] Search   = StringSplit(Tags)
	int i = Slotted
	while i
		i -= 1
		sslBaseAnimation Slot = Objects[i] as sslBaseAnimation
		Valid[i] = Slot.Enabled && ActorCount == Slot.PositionCount && Slot.TagSearch(Search, Suppress, RequireAll)
	endWhile
	return GetList(valid)
endFunction

sslBaseAnimation[] function GetByType(int ActorCount, int Males = -1, int Females = -1, int StageCount = -1, bool Aggressive = false, bool Sexual = true)
	Log("GetByType(ActorCount="+ActorCount+", Males="+Males+", Females="+Females+", StageCount="+StageCount+", Aggressive="+Aggressive+")")
	; Search
	bool[] Valid = Utility.CreateBoolArray(Slotted)
	bool RestrictAggressive = Config.RestrictAggressive
	int i = Slotted
	while i
		i -= 1
		sslBaseAnimation Slot = Objects[i] as sslBaseAnimation
		Valid[i] = Slot.Enabled && ActorCount == Slot.PositionCount && (!RestrictAggressive || Aggressive == Slot.HasTag("Aggressive")) \
		&& (Males == -1 || Males == Slot.Males) && (Females == -1 || Females == Slot.Females) && (StageCount == -1 || StageCount == Slot.StageCount)
	endWhile
	return GetList(Valid)
endFunction

sslBaseAnimation[] function PickByActors(Actor[] Positions, int Limit = 64, bool Aggressive = false)
	Log("PickByActors(Positions="+Positions+", Limit="+Limit+", Aggressive="+Aggressive+")")
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
	Log("GetByDefault(Males="+Males+", Females="+Females+", IsAggressive="+IsAggressive+", UsingBed="+UsingBed+", RestrictAggressive="+RestrictAggressive+")")
	if Males == 0 && Females == 0
		return none ; No actors passed or creatures present
	endIf
	; Info
	int ActorCount = (Males + Females)
	bool SameSex = (Females == 2 && Males == 0) || (Males == 2 && Females == 0)
	bool BedRemoveStanding = Config.BedRemoveStanding

	; Search
	bool[] Valid = Utility.CreateBoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		sslBaseAnimation Slot = Objects[i] as sslBaseAnimation
		; Check for appropiate enabled aniamtion
		Valid[i] = Slot.Enabled && ActorCount == Slot.PositionCount
		if Valid[i]
			string[] Tags = Slot.GetRawTags()
			int[] Genders = Slot.Genders
			; Suppress standing animations if on a bed
			Valid[i] = Valid[i] && (!UsingBed || (UsingBed && BedRemoveStanding && Tags.Find("Standing") == -1))
			; Suppress or ignore aggressive animation tags
			Valid[i] = Valid[i] && (!RestrictAggressive || IsAggressive == Tags.Find("Aggressive") != -1)
			; Get SameSex + Non-SameSex
			if SameSex
				Valid[i] = Valid[i] && (Tags.Find("FM") != -1 || (Males == Genders[0] && Females == Genders[1]))
			; Ignore genders for 3P+
			elseIf ActorCount < 3
				Valid[i] = Valid[i] && Males == Genders[0] && Females == Genders[1]
			endIf
		endIf
	endWhile
	return GetList(Valid)
endFunction

; ------------------------------------------------------- ;
; --- Registry Access                                     ;
; ------------------------------------------------------- ;

sslBaseAnimation function GetBySlot(int index)
	if index >= 0 && index < Slotted
		return Objects[index] as sslBaseAnimation
	endIf
	return none
endFunction

sslBaseAnimation function GetByName(string FindName)
	return GetBySlot(FindByName(FindName))
endFunction

sslBaseAnimation function GetbyRegistrar(string Registrar)
	return GetBySlot(FindByRegistrar(Registrar))
endFunction

int function FindByRegistrar(string Registrar)
	if Registrar != ""
		return Registry.Find(Registrar)
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

bool function IsRegistered(string Registrar)
	return FindByRegistrar(Registrar) != -1
endFunction

; ------------------------------------------------------- ;
; --- Object Utilities                                --- ;
; ------------------------------------------------------- ;

sslBaseAnimation[] function GetList(bool[] Valid)
	; Debug.Trace("GetList() - "+Valid)
	sslBaseAnimation[] Output
	if Valid && Valid.Length > 0 && Valid.Find(true) != -1
		int n = Valid.Find(true)
		int i = CountBool(Valid, true)
		; Trim over 100 to random selection
		if i > 100
			int end = Valid.RFind(true) - 1
			while i > 100
				int rand = Valid.Find(true, Utility.RandomInt(n, end))
				if rand != -1 && Valid[rand]
					Valid[rand] = false
					i -= 1
				endIf
			endWhile
		endIf
		; Get list
		Output = sslUtility.AnimationArray(i)
		while n != -1 && i > 0
			i -= 1
			Output[i] = Objects[n] as sslBaseAnimation
			n += 1
			if n < Slotted
				n = Valid.Find(true, n)
			else
				n = -1
			endIf
		endWhile
		; Only bother with logging the selected animation names if debug mode enabled.
		string List = "Found Animations("+Output.Length+")"
		if Config.DebugMode
			List +=  " "
			i = Output.Length
			while i
				i -= 1
				List += "["+Output[i].Name+"]"
			endWhile
		endIf
		Log(List)
	else
		Log("No Animations Found")
	endIf
	return Output
endFunction

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

; ------------------------------------------------------- ;
; --- Object MCM Pagination                               ;
; ------------------------------------------------------- ;

int function PageCount(int perpage = 125)
	return ((Slotted as float / perpage as float) as int) + 1
endFunction

int function FindPage(string Registrar, int perpage = 125)
	int i = Registry.Find(Registrar)
	if i != -1
		return ((i as float / perpage as float) as int) + 1
	endIf
	return -1
endFunction

string[] function GetSlotNames(int page = 1, int perpage = 125)
	return GetNames(GetSlots(page, perpage))
endfunction

sslBaseAnimation[] function GetSlots(int page = 1, int perpage = 125)
	perpage = PapyrusUtil.ClampInt(perpage, 1, 128)
	if page > PageCount(perpage) || page < 1
		return sslUtility.AnimationArray(0)
	endIf
	int n
	sslBaseAnimation[] PageSlots
	if page == PageCount(perpage)
		n = Slotted
		PageSlots = sslUtility.AnimationArray((Slotted - ((page - 1) * perpage)))
	else
		n = page * perpage
		PageSlots = sslUtility.AnimationArray(perpage)
	endIf
	int i = PageSlots.Length
	while i
		i -= 1
		n -= 1
		if Objects[n]
			PageSlots[i] = Objects[n] as sslBaseAnimation
		endIf
	endWhile
	return PageSlots
endFunction

; ------------------------------------------------------- ;
; --- Object Registration                                 ;
; ------------------------------------------------------- ;

function RegisterSlots()
	; Register default animation
	(Game.GetFormFromFile(0x639DF, "SexLab.esm") as sslAnimationDefaults).LoadAnimations()
	; Send mod event for 3rd party animation
	ModEvent.Send(ModEvent.Create("SexLabSlotAnimations"))
	Debug.Notification("$SSL_NotifyAnimationInstall")
endFunction

int function Register(string Registrar)
	if Registry.Find(Registrar) != -1 || Slotted >= 375
		return -1
	endIf
	int i = Slotted
	Slotted += 1
	if i >= Registry.Length
		int n = Registry.Length + 32
		if n > 375
			n = 375
		endIf
		Log("Resizing animation registry slots: "+Registry.Length+" -> "+n)
		Registry = Utility.ResizeStringArray(Registry, n)
		Objects  = Utility.ResizeAliasArray(Objects, n, GetNthAlias(0))
		while n
			n -= 1
			if Registry[n] == ""
				Objects[n] = none
			endIf
		endWhile
		i = Registry.Find("")
	endIf
	Registry[i] = Registrar
	Objects[i]  = GetNthAlias(i)
	return i
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

bool function UnregisterAnimation(string Registrar)
	if Registrar != "" && Registry.Find(Registrar) != -1
		int Slot = Registry.Find(Registrar)
		(Objects[Slot] as sslBaseAnimation).Initialize()
		Objects[Slot] = none
		Registry[Slot] = ""
		Config.Log("Animation["+Slot+"] "+Registrar, "UnregisterAnimation()")
		return true	
	endIf
	return false
endFunction

; ------------------------------------------------------- ;
; --- System Use Only                                 --- ;
; ------------------------------------------------------- ;

function Setup()
	GoToState("Locked")
	Slotted  = 0
	Registry = new string[128] ; Utility.CreateStringArray(164)
	Objects  = new Alias[128] ; Utility.CreateAliasArray(164, GetNthAlias(0))
	; DEVTEMP: SKSE Beta workaround - clear used dummy aliases
	;/ int i = Objects.Length
	while i
		i -= 1
		Objects[i] = none
	endWhile /;
	; /DEVTEMP
	PlayerRef = Game.GetPlayer()
	if !Config || !ActorLib || !ThreadLib
		Form SexLabQuestFramework = Game.GetFormFromFile(0xD62, "SexLab.esm")
		if SexLabQuestFramework
			Config    = SexLabQuestFramework as sslSystemConfig
			ThreadLib = SexLabQuestFramework as sslThreadLibrary
			ActorLib  = SexLabQuestFramework as sslActorLibrary
		endIf
	endIf
	RegisterSlots()
	GoToState("")
endFunction

function Log(string msg)
	if Config.DebugMode
		MiscUtil.PrintConsole(msg)
	endIf
	Debug.Trace("SEXLAB - "+msg)
endFunction

state Locked
	function Setup()
	endFunction
endState

bool function TestSlots()
	return true
endFunction

; ------------------------------------------------------- ;
; --- Legacy Use Only                                 --- ;
; ------------------------------------------------------- ;

sslBaseAnimation[] function RemoveTagged(sslBaseAnimation[] Anims, string Tags)
	return sslUtility.FilterTaggedAnimations(Anims, PapyrusUtil.StringSplit(Tags), false)
endFunction

sslBaseAnimation[] function MergeLists(sslBaseAnimation[] List1, sslBaseAnimation[] List2)
	return sslUtility.MergeAnimationLists(List1, List2)
endFunction

bool[] function FindTagged(sslBaseAnimation[] Anims, string Tags)
	return sslUtility.FindTaggedAnimations(Anims, PapyrusUtil.StringSplit(Tags))
endFunction