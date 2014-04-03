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

;/
function ExportFloat(string Var, float Value)
	SetFloatValue(none, Var, Value)
	ExportFile(Registry+".json", Var, 2, none, true, false, true)
	UnsetFloatValue(none, Var)
endFunction
float function ImportFloat(string Var, float Value)
	ImportFile(Registry+".json", Var, 2, none, true, false)
	Value = GetFloatValue(none, Var, Value)
	UnsetFloatValue(none, Var)
	return Value
endFunction

function ExportInt(string Var, int Value)
	SetIntValue(none, Var, Value)
	ExportFile(Registry+".json", Var, 1, none, true, false, true)
	UnsetIntValue(none, Var)
endFunction
int function ImportInt(string Var, int Value)
	ImportFile(Registry+".json", Var, 1, none, true, false)
	Value = GetIntValue(none, Var, Value)
	UnsetIntValue(none, Var)
	return Value
endFunction

function ExportBool(string Var, bool Value)
	SetIntValue(none, Var, Value as int)
	ExportFile(Registry+".json", Var, 1, none, true, false, true)
	UnsetIntValue(none, Var)
endFunction
bool function ImportBool(string Var, bool Value)
	ImportFile(Registry+".json", Var, 1, none, true, false)
	Value = GetIntValue(none, Var, Value as int) as bool
	UnsetIntValue(none, Var)
	return Value
endFunction

function ExportString(string Var, string Value)
	SetStringValue(none, Var, Value as int)
	ExportFile(Registry+".json", Var, 4, none, true, false, true)
	UnsetStringValue(none, Var)
endFunction
string function ImportString(string Var, string Value)
	ImportFile(Registry+".json", Var, 4, none, true, false)
	Value = GetStringValue(none, Var, Value)
	UnsetStringValue(none, Var)
	return Value
endFunction


function ExportFloatList(string Var, float[] Values, int len)
	FloatListClear(none, Var)
	int i
	while i < len
		FloatListAdd(none, Var, Values[i])
		i += 1
	endWhile
	ExportFile(Registry+".json", Var, 32, none, true, false, true)
	FloatListClear(none, Var)
endFunction
float[] function ImportFloatList(string Var, float[] Values, int len)
	ImportFile(Registry+".json", Var, 32, none, true, false)
	if FloatListCount(none, Var) == len
		int i
		while i < len
			Values[i] = FloatListGet(none, Var, i)
			i += 1
		endWhile
	endIf
	FloatListClear(none, Var)
	return Values
endFunction

function ExportBoolList(string Var, bool[] Values, int len)
	IntListClear(none, Var)
	int i
	while i < len
		IntListAdd(none, Var, Values[i] as int)
		i += 1
	endWhile
	ExportFile(Registry+".json", Var, 16, none, true, false, true)
	IntListClear(none, Var)
endFunction
bool[] function ImportBoolList(string Var, bool[] Values, int len)
	ImportFile(Registry+".json", Var, 32, none, true, false)
	if IntListCount(none, Var) == len
		int i
		while i < len
			Values[i] = IntListGet(none, Var, i) as bool
			i += 1
		endWhile
	endIf
	IntListClear(none, Var)
	return Values
endFunction

 /;
