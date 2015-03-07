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
	; Debug.Trace("GetByTags("+ActorCount+", "+Tags+", "+TagsSuppressed+", "+RequireAll+")")
	bool[] Valid      = Utility.CreateBoolArray(Slotted)
	string[] Suppress = StringSplit(TagsSuppressed)
	string[] Search   = StringSplit(Tags)
	int i = Slotted
	while i
		i -= 1
		sslBaseAnimation Slot = Objects[i] as sslBaseAnimation
		Valid[i] = Slot.Enabled && ActorCount == Slot.PositionCount && Slot.CheckTags(Search, RequireAll) && (TagsSuppressed == "" || !Slot.HasOneTag(Suppress))
	endWhile
	return GetList(valid)
endFunction

sslBaseAnimation[] function GetByType(int ActorCount, int Males = -1, int Females = -1, int StageCount = -1, bool Aggressive = false, bool Sexual = true)
	; Debug.Trace("GetByType("+ActorCount+", "+Males+", "+Females+", "+StageCount+", "+Aggressive+", "+Sexual+")")
	; Search
	bool[] Valid = Utility.CreateBoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		sslBaseAnimation Slot = Objects[i] as sslBaseAnimation
		Valid[i] = Slot.Enabled && ActorCount == Slot.PositionCount && (Aggressive == Slot.HasTag("Aggressive") || !Config.RestrictAggressive) \
		&& (Males == -1 || Males == Slot.Males) && (Females == -1 || Females == Slot.Females) && (StageCount == -1 || StageCount == Slot.StageCount)
	endWhile
	return GetList(Valid)
endFunction

sslBaseAnimation[] function PickByActors(Actor[] Positions, int Limit = 64, bool Aggressive = false)
	; Debug.Trace("PickByActors("+Positions+", "+Limit+", "+Aggressive+")")
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
	; Debug.Trace("GetByDefault("+Males+", "+Females+", "+IsAggressive+", "+UsingBed+", "+RestrictAggressive+")")
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
		sslBaseAnimation Slot = Objects[i] as sslBaseAnimation
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
	if Valid.Length > 0 && Valid.Find(true) != -1
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
		while n != -1
			i -= 1
			Output[i] = Objects[n] as sslBaseAnimation
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
			Debug.trace(List)
			MiscUtil.PrintConsole(List)
		endIf
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
	if page > PageCount(perpage) || page < 1
		return sslUtility.AnimationArray(0)
	endIf
	perpage = PapyrusUtil.ClampInt(perpage, 1, 128) 
	sslBaseAnimation[] PageSlots = sslUtility.AnimationArray(perpage)
	int i = perpage
	int n = page * perpage
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
	if Registry.Find(Registrar) != -1 || Slotted >= Registry.Length
		return -1
	endIf
	Slotted += 1
	int i = Registry.Find("")
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

; ------------------------------------------------------- ;
; --- System Use Only                                 --- ;
; ------------------------------------------------------- ;

function Setup()
	GoToState("Locked")
	Slotted  = 0
	Registry = Utility.CreateStringArray(375)
	Objects  = Utility.CreateAliasArray(375, GetNthAlias(0))
	; DEVTEMP: SKSE Beta workaround - clear used dummy aliases
	int i = Objects.Length
	while i
		i -= 1
		Objects[i] = none
	endWhile
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
; --- D Use Only                                 --- ;
; ------------------------------------------------------- ;

sslBaseAnimation[] function RemoveTagged(sslBaseAnimation[] Anims, string Tags)
	return sslUtility.RemoveTaggedAnimations(Anims, Tags)
endFunction

sslBaseAnimation[] function MergeLists(sslBaseAnimation[] List1, sslBaseAnimation[] List2)
	return sslUtility.MergeAnimationLists(List1, List2)
endFunction

bool[] function FindTagged(sslBaseAnimation[] Anims, string Tags)
	return sslUtility.FindTaggedAnimations(Anims, Tags)
endFunction