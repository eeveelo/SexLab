scriptname sslBaseObject extends ReferenceAlias hidden

; Config accessor
sslSystemConfig property Config auto hidden

; Object base info
int property SlotID auto hidden
string property Name auto hidden
; string property DisplayName auto hidden
bool property Enabled auto hidden

string property Registry auto hidden
bool property Registered hidden
	bool function get()
		return Registry != "" && Storage == none
	endFunction
endProperty

; ------------------------------------------------------- ;
; --- Tagging System                                  --- ;
; ------------------------------------------------------- ;

string[] Tags

string[] function GetRawTags()
	return Tags
endFunction
string[] function GetTags()
	return PapyrusUtil.ClearEmpty(Tags)
endFunction

bool function HasTag(string Tag)
	return Tag != "" && Tags.Find(Tag) != -1
endFunction

bool function AddTag(string Tag)
	if Tag != "" && Tags.Find(Tag) == -1
		int i = Tags.Find("")
		if i != -1
			Tags[i] = Tag
		else
			Tags = PapyrusUtil.PushString(Tags, Tag)
		endIf
		return true
	endIf
	return false
endFunction

bool function RemoveTag(string Tag)
	if Tag != "" && Tags.Find(Tag) != -1
		Tags = PapyrusUtil.RemoveString(Tags, Tag)
		return true
	endIf
	return false
endFunction

function AddTags(string[] TagList)
	int i = TagList.Length
	while i
		i -= 1
		AddTag(TagList[i])
	endWhile
endFunction

function SetTags(string TagList)
	AddTags(StringUtil.Split(TagList, ","))
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
	bool Valid = ParseTags(CheckTags, RequireAll)
	return (Valid && !Suppress) || (!Valid && Suppress)
endFunction

bool function ParseTags(string[] TagList, bool RequireAll = true)
	if RequireAll
		return HasAllTag(TagList)
	else
		return HasOneTag(TagList)
	endIf
endFunction

bool function HasOneTag(string[] TagList)
	int i = TagList.Length
	while i
		i -= 1
		if HasTag(TagList[i])
			return true
		endIf
	endWhile
	return false
endFunction

bool function HasAllTag(string[] TagList)
	int i = TagList.Length
	while i
		i -= 1
		if !HasTag(TagList[i])
			return false
		endIf
	endWhile
	return true
endFunction

; ------------------------------------------------------- ;
; --- Phantom Slots                                   --- ;
; ------------------------------------------------------- ;

; Phantom slots owner
Form property Storage auto hidden
bool property Ephemeral hidden
	bool function get()
		return Storage != none
	endFunction
endProperty

function MakeEphemeral(string Token, Form OwnerForm)
	Initialize()
	Enabled   = true
	Registry  = Token
	Storage   = OwnerForm
	Log("Created Non-Global Object '"+Token+"'", Storage)
endFunction

; ------------------------------------------------------- ;
; --- System Use                                      --- ;
; ------------------------------------------------------- ;

string function Key(string type = "")
	return Registry+"."+type
endFunction

function Log(string Log, string Type = "NOTICE")
	Log = Type+" "+Registry+" - "+Log
	if Config.InDebugMode
		SexLabUtil.PrintConsole(Log)
	endIf
	Debug.Trace("SEXLAB - "+Log)
endFunction

function Save(int id = -1)
	SlotID = id
	; Trim tags
	int i = Tags.Find("")
	if i != -1
		Tags = PapyrusUtil.ResizeStringArray(Tags, i)
	endIf
endFunction

function Initialize()
	if !Config
		Config = Game.GetFormFromFile(0xD62, "SexLab.esm") as sslSystemConfig
	endIf
	Name     = ""
	Registry = ""
	SlotID   = -1
	Enabled  = false
	Storage  = none
	Tags     = new string[16]
endFunction
