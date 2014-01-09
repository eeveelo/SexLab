scriptname sslExpressionSlots extends Quest

sslExpressionDefaults property Defaults auto
sslExpressionLibrary property Lib auto

sslBaseExpression[] Slots
sslBaseExpression[] property Expression hidden
	sslBaseExpression[] function get()
		return Slots
	endFunction
endProperty

int property Slotted auto hidden
bool property FreeSlots hidden
	bool function get()
		return slotted < 40
	endFunction
endProperty

;/-----------------------------------------------\;
;|	Search Expression                            |;
;\-----------------------------------------------/;

sslBaseExpression function RandomByTag(string tag)
	bool[] valid = sslUtility.BoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		valid[i] = Slots[i].Registered && Slots[i].HasTag(tag)
	endWhile
	; No valid voices found
	if valid.Find(true) == -1
		return none
	endIf
	; Pick random index within range of valid
	int rand = Utility.RandomInt(valid.Find(true), valid.RFind(true))
	int pos = valid.Find(true, rand)
	if pos == -1
		pos = valid.RFind(true, rand)
	endIf
	if pos != -1
		return Slots[pos]
	endIf
	return none
endFunction

sslBaseExpression function GetByName(string findName)
	int i
	while i < slotted
		if Slots[i].Registered && Slots[i].name == findName
			return Slots[i]
		endIf
		i += 1
	endWhile
	return none
endFunction

sslBaseExpression function GetByTag(string tag1, string tag2 = "", string tagSuppress = "", bool requireAll = true)
	int i
	while i < slotted
		bool check1 = Slots[i].HasTag(tag1)
		bool check2 = Slots[i].HasTag(tag2)
		bool supress = Slots[i].HasTag(tagSuppress)
		if requireAll && check1 && (check2 || tag2 == "") && !(supress && tagSuppress != "")
			return Slots[i]
		elseif !requireAll && (check1 || check2) && !(supress && tagSuppress != "")
			return Slots[i]
		endIf
		i += 1
	endWhile
	return none
endFunction

sslBaseExpression function GetBySlot(int slot)
	return Slots[slot]
endFunction

;/-----------------------------------------------\;
;|	Locate Expressions                           |;
;\-----------------------------------------------/;

int function FindByName(string findName)
	int i
	while i < slotted
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

int function Find(sslBaseExpression findExpression)
	return Slots.Find(findExpression)
endFunction

;/-----------------------------------------------\;
;|	Manage Expressions                           |;
;\-----------------------------------------------/;

sslBaseExpression function GetFree()
	return Slots[slotted]
endFunction

int function Register(sslBaseExpression Claiming, string registrar)
	StorageUtil.StringListAdd(self, "Registry", registrar, false)
	Slotted = StorageUtil.StringListCount(self, "Registry")
	Claiming.Initialize()
	return Slots.Find(Claiming)
endFunction

int function GetCount()
	return StorageUtil.StringListCount(self, "Registry")
endFunction

;/-----------------------------------------------\;
;|	System Expressions                           |;
;\-----------------------------------------------/;

function _Setup()
	Slots = new sslBaseExpression[40]
	int i = 40
	while i
		i -= 1
		Slots[i] = GetNthAlias(i) as sslBaseExpression
		Slots[i].Initialize()
	endWhile
	Initialize()
	Defaults.LoadExpressions()
	SendModEvent("SexLabSlotExpressions")
	Debug.Notification("$SSL_NotifyExpressionInstall")
endFunction

function Initialize()
	Slotted = 0
	StorageUtil.StringListClear(self, "Registry")
endFunction
