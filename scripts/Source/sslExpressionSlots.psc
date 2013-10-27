scriptname sslExpressionSlots extends Quest

sslExpressionDefaults property Defaults auto
sslExpressionLibrary property Lib auto

sslBaseExpression[] Slots
sslBaseExpression[] property Expression hidden
	sslBaseExpression[] function get()
		return Slots
	endFunction
endProperty

string[] registry
int slotted

bool property FreeSlots hidden
	bool function get()
		return slotted < 50
	endFunction
endProperty

;/-----------------------------------------------\;
;|	Search Expression                            |;
;\-----------------------------------------------/;

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
	return registry.Find(registrar)
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
	registry = sslUtility.PushString(registrar, registry)
	slotted = registry.Length
	Claiming.Initialize()
	return Slots.Find(Claiming)
endFunction

int function GetCount()
	return registry.Length
endFunction

;/-----------------------------------------------\;
;|	System Expressions                           |;
;\-----------------------------------------------/;

function _Setup()
	Slots = new sslBaseExpression[30]
	int i
	while i < 30
		if i < 10
			Slots[i] = GetAliasByName("ExpressionSlot00"+i) as sslBaseExpression
		else
			Slots[i] = GetAliasByName("ExpressionSlot0"+i) as sslBaseExpression
		endIf
		Slots[i].Initialize()
		i += 1
	endWhile
	Initialize()
	Defaults.LoadExpressions()
	SendModEvent("SexLabSlotExpressions")
	Debug.Notification("$SSL_NotifyExpressionInstall")
endFunction

function Initialize()
	string[] init
	registry = init
	Slotted = 0
endFunction
