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

function ApplyTo(actor ActorRef, int strength = 50, bool isFemale, bool openmouth = false)
	if ActorRef == none
		return ; Nobody to express with!
	endIf
	; Clear existing mfg from actor
	Lib.ClearMFG(ActorRef)
	; Get phase presets, [n + 0] = mode, [n + 1] = id, [n + 2] = value
	int[] presets = GetPhase(CalcPhase(strength, isFemale), isFemale)
	; Apply phase presets to actor
	int i = presets.Length
	while i
		i -= 3
		if presets[i] != 2 && presets[i] != 0
			MfgConsoleFunc.SetPhonemeModifier(ActorRef, presets[i], presets[(i + 1)], presets[(i + 2)])
		elseIf !openmouth
			ActorRef.SetExpressionOverride(presets[(i + 1)], presets[(i + 2)])
		endIf
	endWhile
	; Apply open mouth
	if openmouth
		ActorRef.ClearExpressionOverride()
		ActorRef.SetExpressionOverride(16, 100)
	endIf
endFunction

function ClearMFG(actor ActorRef)
	ActorRef.ClearExpressionOverride()
	MfgConsoleFunc.ResetPhonemeModifier(ActorRef)
endFunction

function ClearPhoneme(actor ActorRef)
	int[] phonemes = new int[32]

endFunction

int[] function GetPreset(int[] presets, int n)
	int slot = ( n * 3 )
	int[] output = new int[3]
	output[0] = presets[slot]
	output[1] = presets[slot + 1]
	output[2] = presets[slot + 2]
	return output
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
		else
			return female5
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
		else
			return male5
		endIf
	endIf
endFunction


;/-----------------------------------------------\;
;|	Editing Functions                            |;
;\-----------------------------------------------/;

function SetPhase(int phase, bool female, int[] presets)
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

function AddPreset(int phase, bool female, int mode, int id, int value)
	if phase < 1 || phase > 5
		return ; Invalid phase
	endIf
	int[] presets = sslUtility.IncreaseInt(3, GetPhase(phase, female))
	int index = (presets.Length - 3)
	presets[index] = mode
	presets[index + 1] = id
	presets[index + 2] = value
	SetPhase(phase, female, presets)
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

bool function ToggleTag(string tag)
	if HasTag(tag)
		RemoveTag(tag)
	else
		AddTag(tag)
	endIf
	return HasTag(tag)
endFunction

;/-----------------------------------------------\;
;|	System Use                                   |;
;\-----------------------------------------------/;

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
	return Math.Floor(((strength as float) / 100.0) * count)
endFunction

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
