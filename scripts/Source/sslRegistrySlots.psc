scriptname sslRegistrySlots extends Quest

import StorageUtil

string Objects
string[] Registry

int property Slotted auto hidden
sslBaseObject[] Slots


Alias function Register(string Registrar)
	if StringListFind(self, Key("Registry"), Registrar) == -1 && Slotted < 125
		StringListAdd(self, Key("Registry"), Registrar, false)
		Slotted += 1
		return GetNthAlias(Slotted - 1)
	endIf
	return none
endFunction

bool function IsRegistered(string Registrar)
	return FindByRegistrar(Registrar) != -1
endFunction

int function FindByRegistrar(string Registrar)
	return StringListFind(self, Key("Registry"), Registrar)
endFunction

string function Key(string type = "")
	return Objects+"."+type
endFunction

function Initialize(string RegistrySlots)
	Objects = RegistrySlots
	StringListClear(self, Key("Registry"))
	Slots = new sslBaseObject[125]
	Slotted = 0
endFunction
