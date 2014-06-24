scriptname sslBaseObject extends ReferenceAlias hidden

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
Form property Storage auto hidden

; Phantom slots claim/touch time
bool property Ephemeral auto hidden

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

function AddTags(string[] TagList)
	int i = TagList.Length
	while i
		i -= 1
		AddTag(TagList[i])
	endWhile
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

string[] function GetTags()
	return Tags
endFunction

; ------------------------------------------------------- ;
; --- System Use                                      --- ;
; ------------------------------------------------------- ;

function MakeEphemeral(string Token, Form OwnerForm)
	Initialize()
	Ephemeral = true
	Enabled   = true
	Registry  = Token
	Storage   = OwnerForm
	Log("Created Non-Global Object '"+Token+"''", Storage)
endFunction

string function Key(string type = "")
	return Registry+"."+type
endFunction

function Log(string Log, string Type = "NOTICE")
	SexLabUtil.DebugLog(Log, Type, Config.DebugMode)
endFunction

function Initialize()
	Name      = ""
	Registry  = ""
	Enabled   = false
	Ephemeral = false
	Storage   = GetOwningQuest()
	Config    = Game.GetFormFromFile(0xD62, "SexLab.esm") as sslSystemConfig
	Tags      = new string[3]
endFunction

function Save(int id)
endFunction

; function Finalize()
; 	if Ephemeral
; 		sslObjectFactory Factory = GetOwningQuest() as sslObjectFactory
; 		if self as sslBaseAnimation != none
; 			Save(Factory.FindAnimation(Registry))
; 		elseIf self as sslBaseVoice != none
; 			Save(Factory.FindVoice(Registry))
; 		elseIf self as sslBaseExpression != none
; 			Save(Factory.FindExpression(Registry))
; 		endIf
; 	else
; 		Quest Owner = GetOwningQuest()
; 		if self as sslBaseAnimation != none && (Owner as sslAnimationSlots) != none
; 			Save((Owner as sslAnimationSlots).Animations.Find(self))
; 		elseIf self as sslBaseAnimation != none && (Owner as sslCreatureAnimationSlots) != none
; 			Save((Owner as sslCreatureAnimationSlots).Animations.Find(self))
; 		elseIf self as sslBaseVoice != none
; 			Save((Owner as sslVoiceSlots).Voices.Find(self))
; 		elseIf self as sslBaseExpression != none
; 			Save((Owner as sslExpressionSlots).Expressions.Find(self))
; 		endIf
; 	endIf
; endFunction

