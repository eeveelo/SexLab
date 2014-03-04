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

bool function HasTag(string Tag)
	return Tag != "" && StorageUtil.StringListFind(Storage, Key("Tags"), Tag) != -1
endFunction

bool function AddTag(string Tag)
	if HasTag(Tag)
		return false
	endIf
	StorageUtil.StringListAdd(Storage, Key("Tags"), Tag, false)
	return true
endFunction

bool function RemoveTag(string Tag)
	if !HasTag(Tag)
		return false
	endIf
	StorageUtil.StringListRemove(Storage, Key("Tags"), Tag, true)
	return true
endFunction

bool function ToggleTag(string Tag)
	return (RemoveTag(Tag) || AddTag(Tag)) && HasTag(Tag)
endFunction

bool function AddTagConditional(string Tag, bool AddTag)
	if Tag != ""
		int i = StorageUtil.StringListFind(Storage, Key("Tags"), Tag)
		if AddTag && i == -1
			StorageUtil.StringListAdd(Storage, Key("Tags"), Tag, false)
		elseIf !AddTag && i != -1
			StorageUtil.StringListRemove(Storage, Key("Tags"), Tag, true)
		endIf
	endIf
	return AddTag
endFunction

bool function CheckTags(string[] CheckTags, bool RequireAll = true, bool Suppress = false)
	int i = CheckTags.Length
	while i
		i -= 1
		if CheckTags[i] != ""
			bool Check = HasTag(CheckTags[i])
			if (Suppress && Check) || (!Suppress && RequireAll && !Check)
				return false ; Stop if we need all and don't have it, or are supressing the found tag
			elseif !Suppress && !RequireAll && Check
				return true ; Stop if we don't need all and have one
			endIf
		endIf
	endWhile
	; If still here than we require all and had all
	return true
endFunction

string[] function GetTags()
	int i = StorageUtil.StringListCount(Storage, Key("Tags"))
	string[] Tags = sslUtility.StringArray(i)
	while i
		i -= 1
		Tags[i] = StorageUtil.StringListGet(Storage, Key("Tags"), i)
	endWhile
	return Tags
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
