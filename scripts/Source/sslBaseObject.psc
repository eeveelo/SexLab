scriptname sslBaseObject extends ReferenceAlias

bool property Enabled auto hidden

string property Name auto hidden
string property Registry auto hidden
bool property Registered hidden
	bool function get()
		return Registry != ""
	endFunction
endProperty

; Storage key
Quest property Storage auto hidden



;/-----------------------------------------------\;
;|	Tagging System                               |;
;\-----------------------------------------------/;

bool function HasTag(string tag)
	return tag != "" && StorageUtil.StringListFind(Storage, Key("Tags"), tag) != -1
endFunction

bool function AddTag(string tag)
	if HasTag(tag)
		return false
	endIf
	StorageUtil.StringListAdd(Storage, Key("Tags"), tag, false)
	return true
endFunction

bool function RemoveTag(string tag)
	if !HasTag(tag)
		return false
	endIf
	StorageUtil.StringListRemove(Storage, Key("Tags"), tag, true)
	return true
endFunction

bool function ToggleTag(string tag)
	return (RemoveTag(tag) || AddTag(tag)) && HasTag(tag)
endFunction

bool function CheckTags(string[] find, bool requireAll = true, bool suppress = false)
	int i = find.Length
	while i
		i -= 1
		if find[i] != ""
			bool check = HasTag(find[i])
			if requireAll && !check && !suppress
				return false ; Stop if we need all and don't have it
			elseif !requireAll && check && !suppress
				return true ; Stop if we don't need all and have one
			elseif check && suppress
				return false
			endIf
		endIf
	endWhile
	; If still here than we require all and had all
	return true
endFunction

string[] function GetTags()
	int i = StorageUtil.StringListCount(Storage, Key("Tags"))
	string[] tags = sslUtility.StringArray(i)
	while i
		i -= 1
		tags[i] = StorageUtil.StringListGet(Storage, Key("Tags"), i)
	endWhile
	return tags
endFunction

;/-----------------------------------------------\;
;|	System Use                                   |;
;\-----------------------------------------------/;

string function Key(string type = "")
	return Registry+"."+type
endFunction

bool Locked
function _WaitLock()
	while Locked
		Utility.WaitMenuMode(0.10)
	endWhile
	Locked = true
endFunction

function _Unlock()
	Locked = false
endFunction

bool function _IsLocked()
	return Locked
endFunction

function Initialize()
	Storage = GetOwningQuest()
	StorageUtil.StringListClear(Storage, Key("Tags"))
	Clear()
endFunction

function Clear()
	Name = ""
	Registry = ""
	Enabled = false
	Locked = false
	parent.Clear()
endFunction
