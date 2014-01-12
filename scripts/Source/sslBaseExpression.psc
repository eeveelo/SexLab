
scriptname sslBaseExpression extends ReferenceAlias

sslExpressionLibrary property Lib auto
import sslExpressionLibrary
import MfgConsoleFunc

string property Name = "" auto hidden

bool property Registered hidden
	bool function get()
		return Name != ""
	endFunction
endProperty

; Storage key
Quest Storage
; Storage legend
; string Key("Tags") = tags applied to animation

int[] male1
int[] male2
int[] male3
int[] male4
int[] male5

int[] female1
int[] female2
int[] female3
int[] female4
int[] female5

;/-----------------------------------------------\;
;|	API Functions                                |;
;\-----------------------------------------------/;

function ApplyTo(actor ActorRef, int strength = 50, bool isFemale = true, bool openmouth = false)
	if ActorRef == none
		return ; Nobody to express and doesn't update in free camera!
	endIf
	int[] preset = PickPreset(strength, isFemale)
	int i
	while i < 16
		MfgConsoleFunc.SetPhonemeModifier(ActorRef, 1, i, preset[i])
		i += 1
	endWhile
	int p
	while i < 31
		MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, p, preset[i])
		p += 1
		i += 1
	endWhile
	; Apply open mouth
	if openmouth
		OpenMouth(ActorRef)
	else
		ActorRef.SetExpressionOverride(preset[31], preset[32])
	endIf
endFunction

int[] function PickPreset(int strength, bool isFemale)
	return GetPhase(CalcPhase(strength, isFemale), isFemale)
endFunction

int[] function GetPhase(int phase, bool female)
	; Female presets
	if female
		if phase == 1
			return female1
		elseIf phase == 2
			return female2
		elseIf phase == 3
			return female3
		elseIf phase == 4
			return female4
		elseIf phase == 5
			return female5
		else
			return female1
		endIf
	; Male presets
	else
		if phase == 1
			return male1
		elseIf phase == 2
			return male2
		elseIf phase == 3
			return male3
		elseIf phase == 4
			return male4
		elseIf phase == 5
			return male5
		else
			return male1
		endIf
	endIf
endFunction

;/-----------------------------------------------\;
;|	Editing Functions                            |;
;\-----------------------------------------------/;

function SetIndex(int phase, bool female, int index, int value)
	if phase < 1 || phase > 5
		return ; Invalid phase
	endIf
	; Get phase preset
	int[] presets = GetPhase(phase, female)
	; Init if empty
	if presets.Length != 33
		presets = new int[33]
	endIf
	; Set the given index
	presets[index] = value
	; Female presets
	if female
		if phase == 1
			female1 = presets
		elseIf phase == 2
			female2 = presets
		elseIf phase == 3
			female3 = presets
		elseIf phase == 4
			female4 = presets
		elseIf phase == 5
			female5 = presets
		endIf
	; Male presets
	else
		if phase == 1
			male1 = presets
		elseIf phase == 2
			male2 = presets
		elseIf phase == 3
			male3 = presets
		elseIf phase == 4
			male4 = presets
		elseIf phase == 5
			male5 = presets
		endIf
	endIf
endFunction

function AddModifier(int phase, bool female, int id, int value)
	SetIndex(phase, female, id, value)
endFunction

function AddPhoneme(int phase, bool female, int id, int value)
	SetIndex(phase, female, (id + 15), value)
endFunction

function AddExpression(int phase, bool female, int id, int value)
	SetIndex(phase, female, 31, id)
	SetIndex(phase, female, 32, value)
endFunction

;/-----------------------------------------------\;
;|	Tag Functions                                |;
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

;/-----------------------------------------------\;
;|	System Use                                   |;
;\-----------------------------------------------/;

function InitList(string sKey, int phase, int slots)
	phase *= slots
	while phase > StorageUtil.IntListCount(Storage, sKey)
		StorageUtil.IntListAdd(Storage, sKey, 0)
	endWhile
endFunction

string function Key(string type = "")
	return Name+"."+type
endFunction

int function CalcPhase(int strength, bool female)
	; Count number of phases gender has
	int count = 1
	count += ((female && female2.Length != 0) || (!female && male2.Length != 0)) as int
	count += ((female && female3.Length != 0) || (!female && male3.Length != 0)) as int
	count += ((female && female4.Length != 0) || (!female && male4.Length != 0)) as int
	count += ((female && female5.Length != 0) || (!female && male5.Length != 0)) as int
	; Return clamped phase
	if strength > 100
		return count
	elseif strength < 1
		return 1
	endIf
	; Return calculated phase
	int phase =  Math.Floor((((strength as float) / 100.0) + 0.50) * count)
	if phase > count
		return count
	endIf
	return phase
endFunction

function Initialize()
	Storage = GetOwningQuest()
	StorageUtil.StringListClear(Storage, Key("Tags"))

	Name = ""
	int[] intDel1
	male1 = intDel1
	int[] intDel2
	male2 = intDel2
	int[] intDel3
	male3 = intDel3
	int[] intDel4
	male4 = intDel4
	int[] intDel5
	male5 = intDel5

	int[] intDel6
	female1 = intDel6
	int[] intDel7
	female2 = intDel7
	int[] intDel8
	female3 = intDel8
	int[] intDel9
	female4 = intDel9
	int[] intDel10
	female5 = intDel10
endFunction

function _Export()
	string exportkey ="SexLabConfig.Expressions["+Name+"]."
	StorageUtil.FileSetIntValue(exportkey+"Consensual", HasTag("Consensual") as int)
	StorageUtil.FileSetIntValue(exportkey+"Victim", HasTag("Victim") as int)
	StorageUtil.FileSetIntValue(exportkey+"Aggressor", HasTag("Aggressor") as int)
endFunction
function _Import()
	string exportkey ="SexLabConfig.Expressions["+Name+"]."
	if StorageUtil.FileGetIntValue(exportkey+"Consensual", HasTag("Consensual") as int) == 1
		AddTag("Consensual")
	else
		RemoveTag("Consensual")
	endIf
	if StorageUtil.FileGetIntValue(exportkey+"Victim", HasTag("Victim") as int) == 1
		AddTag("Victim")
	else
		RemoveTag("Victim")
	endIf
	if StorageUtil.FileGetIntValue(exportkey+"Aggressor", HasTag("Aggressor") as int) == 1
		AddTag("Aggressor")
	else
		RemoveTag("Aggressor")
	endIf
	StorageUtil.FileUnsetIntValue(exportkey+"Consensual")
	StorageUtil.FileUnsetIntValue(exportkey+"Victim")
	StorageUtil.FileUnsetIntValue(exportkey+"Aggressor")
endFunction

; DEPRECATED: to be removed in 1.5
string[] tags
string[] function _DeprecatedTags()
	return tags
endFunction
