scriptname sslRegistrySlots extends Quest

string Objects
string[] Registry
Alias[] Slots
int property Slotted auto hidden

Alias function GetEmpty()

	; if StringListFind(self, Key("Registry"), Registrar) == -1 && Slotted < 125
	; 	StringListAdd(self, Key("Registry"), Registrar, false)
	; 	Slotted += 1
	; 	return GetNthAlias(Slotted - 1)
	; endIf
	; return none
endFunction

bool function IsRegistered(string Registrar)
	return FindByRegistrar(Registrar) != -1
endFunction

int function FindByRegistrar(string Registrar)
	if Registrar != ""
		return Registry.find(Registrar)
	endIf
	return -1
endFunction

Alias function GetAlias(int index)
	return Slots[index]
endFunction

string function Key(string type = "")
	return Objects+"."+type
endFunction

function Log(string log)
	Debug.Trace(log)
	MiscUtil.PrintConsole(log)
endFunction

function Initialize(string RegistrySlots)
	Objects = RegistrySlots
	; StringListClear(self, Key("Registry"))
	Registry = new string[125]
	Slots = new Alias[125]
	; Slots = new sslBaseObject[75]
	Slotted = 0
endFunction

