scriptname sslBaseObject extends ReferenceAlias

bool property Enabled auto hidden

string property Name auto hidden
string property Registry auto hidden
bool property Registered hidden
	bool function get()
		return Registry != ""
	endFunction
endProperty

; Config accessor
sslSystemConfig property Config auto hidden

; Storage key
Quest property Storage auto hidden

; Search tags
string[] Tags

; ------------------------------------------------------- ;
; --- Tagging System                                  --- ;
; ------------------------------------------------------- ;

bool function HasTag(string Tag)
	return Tag != "" && Tags.Find(Tag) != -1
endFunction

bool function AddTag(string Tag)
	if HasTag(Tag) || Tag == ""
		return false
	endIf
	int i = Tags.Find(Tag)
	if i == -1
		Tags = sslUtility.PushString(Tag, Tags)
	else
		Tags[i] = Tag
	endIf
	return true
endFunction

bool function RemoveTag(string Tag)
	if !HasTag(Tag) || Tag == ""
		return false
	endIf
	Tags[Tags.Find(Tag)] = ""
	return true
endFunction

bool function ToggleTag(string Tag)
	return (RemoveTag(Tag) || AddTag(Tag)) && HasTag(Tag)
endFunction

bool function AddTagConditional(string Tag, bool AddTag)
	if Tag != ""
		if AddTag
			AddTag(Tag)
		elseIf !AddTag
			RemoveTag(Tag)
		endIf
	endIf
	return AddTag
endFunction

bool function CheckTags(string[] CheckTags, bool RequireAll = true, bool Suppress = false)
	int i = CheckTags.Length
	while i
		i -= 1
		if CheckTags[i] != ""
			bool Check = Tags.Find(CheckTags[i]) != -1
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
	return Tags
endFunction

; ------------------------------------------------------- ;
; --- System Use                                      --- ;
; ------------------------------------------------------- ;

string function Key(string type = "")
	return Registry+"."+type
endFunction

function Log(string Log, string Type = "NOTICE")
	SexLabUtil.DebugLog(Log, Type, Config.DebugMode)
endFunction

function Initialize()
	Name = ""
	Registry = ""
	Enabled = false
	Storage = GetOwningQuest()
	Config = Quest.GetQuest("SexLabQuestFramework") as sslSystemConfig
	Tags = new string[5]
endFunction
