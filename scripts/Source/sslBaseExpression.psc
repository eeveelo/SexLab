scriptname sslBaseExpression extends ReferenceAlias

sslExpressionLibrary property Lib auto

string property Name = "" auto hidden

bool property Registered hidden
	bool function get()
		return Name != ""
	endFunction
endProperty

string[] tags

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

function ApplyTo(actor ActorRef, int phase)
	if ActorRef == none
		return ; Nobody to express with!
	endIf
	; Clamp phase to 1-5
	if phase < 1
		phase = 1
	elseIf phase > 5
		phase = 5
	endIf
	; Get phase presets
	int[] presets = GetPhase(ActorRef.GetLeveledActorBase().GetSex(), phase)
	; Apply phase presets to actor
	int i = presets.Length / 3
	while i
		i -= 1
		int[] mfg = GetPreset(presets, i)
		MfgConsoleFunc.SetPhonemeModifier(ActorRef, mfg[0], mfg[1], mfg[2])
	endWhile
endFunction

function ClearFrom(actor ActorRef)
	; Clears current mfg phoneme/modifier/expression from actor
	MfgConsoleFunc.ResetPhonemeModifier(ActorRef)
	ActorRef.ClearExpressionOverride()
endFunction

int[] function GetPreset(int[] presets, int n)
	int slot = presets.Length * 3
	int[] output = new int[3]
	output[0] = presets[slot]
	output[1] = presets[slot + 1]
	output[2] = presets[slot + 2]
	return output
endFunction

function AddPreset(int phase, int gender, int mode, int id, int value)
	int[] presets = sslUtility.IncreaseInt(3, GetPhase(gender, phase))
	int index = (presets.Length - 3)
	presets[index] = mode
	presets[index + 1] = id
	presets[index + 2] = value
	SetPhase(gender, phase, presets)
endFunction

int[] function GetPhase(int phase, int gender)
	; Male presets
	if gender == 0
		if phase == 1
			return male1
		elseIf phase == 2
			return male2
		elseIf phase == 3
			return male3
		elseIf phase == 4
			return male4
		else
			return male5
		endIf
	; Female presets
	else
		if phase == 1
			return female1
		elseIf phase == 2
			return female2
		elseIf phase == 3
			return female3
		elseIf phase == 4
			return female4
		else
			return female5
		endIf
	endIf
endFunction

function SetPhase(int gender, int phase, int[] presets)
	; Male presets
	if gender == 0
		if phase == 1
			male1 = presets
		elseIf phase == 2
			male2 = presets
		elseIf phase == 3
			male3 = presets
		elseIf phase == 4
			male4 = presets
		else
			male5 = presets
		endIf
	; Female presets
	else
		if phase == 1
			female1 = presets
		elseIf phase == 2
			female2 = presets
		elseIf phase == 3
			female3 = presets
		elseIf phase == 4
			female4 = presets
		else
			female5 = presets
		endIf
	endIf
endFunction

;/-----------------------------------------------\;
;|	Tag Functions                                |;
;\-----------------------------------------------/;

bool function AddTag(string tag)
	if HasTag(tag)
		return false
	endIf
	tags = sslUtility.PushString(tag,tags)
	return true
endFunction

bool function RemoveTag(string tag)
	if !HasTag(tag)
		return false
	endIf
	string[] newTags
	int i = 0
	while i < tags.Length
		if tags[i] != tag
			newTags = sslUtility.PushString(tags[i], newTags)
		endIf
		i += 1
	endWhile
	tags = newTags
	return true
endFunction

bool function HasTag(string tag)
	return tags.Find(tag) != -1
endFunction

;/-----------------------------------------------\;
;|	System Use                                   |;
;\-----------------------------------------------/;

function Initialize()
	Name = ""
	string[] tagsDel
	tags = tagsDel
	int[] intDel
	male1 = intDel
	male2 = intDel
	male3 = intDel
	male4 = intDel
	male5 = intDel
	female1 = intDel
	female2 = intDel
	female3 = intDel
	female4 = intDel
	female5 = intDel
endFunction
