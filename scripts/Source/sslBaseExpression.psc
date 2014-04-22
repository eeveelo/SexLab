scriptname sslBaseExpression extends sslBaseObject

import sslUtility
import MfgConsoleFunc

; Gender Types
int property Male = 0 autoreadonly
int property Female = 1 autoreadonly
int property MaleFemale = -1 autoreadonly
; MFG Types
int property Phoneme = 0 autoreadonly
int property Modifier = 16 autoreadonly
int property Mood = 30 autoreadonly

int[] Phases
int property PhasesMale hidden
	int function get()
		return Phases[Male]
	endFunction
endProperty
int property PhasesFemale hidden
	int function get()
		return Phases[Female]
	endFunction
endProperty

int[] Male1
int[] Male2
int[] Male3
int[] Male4
int[] Male5

int[] Female1
int[] Female2
int[] Female3
int[] Female4
int[] Female5

function ApplyPhase(Actor ActorRef, int Phase, int Gender)
	if Phase > Phases[Gender]
		return
	endIf
	int i
	int[] Preset = GetPhase(Phase, Gender)
	; Set Phoneme
	int p
	while p <= 15
		SetPhonemeModifier(ActorRef, 0, p, Preset[i])
		i += 1
		p += 1
	endWhile
	; Set Modifers
	int m
	while m <= 13
		SetPhonemeModifier(ActorRef, 1, m, Preset[i])
		i += 1
		m += 1
	endWhile
	; Set expression
	ActorRef.SetExpressionOverride(Preset[30], Preset[31])
endFunction

function Apply(Actor ActorRef, int Strength, int Gender)
	Log("Phase: "+PickPhase(Strength, Gender), Strength)
	ApplyPhase(ActorRef, PickPhase(Strength, Gender), Gender)
endFunction

int function PickPhase(int Strength, int Gender)
	return ClampInt(((ClampInt(Strength, 1, 100) * Phases[Gender]) / 100), 1, Phases[Gender])
endFunction

int[] function GetPhonemes(int Phase, int Gender)
	int[] Output = new int[16]
	int[] Preset = GetPhase(Phase, Gender)
	int i
	while i < 16
		Output[i] = Preset[Phoneme + i]
		i += 1
	endWhile
	return Output
endFunction

int[] function GetModifiers(int Phase, int Gender)
	int[] Output = new int[14]
	int[] Preset = GetPhase(Phase, Gender)
	int i
	while i < 14
		Output[i] = Preset[Modifier + i]
		i += 1
	endWhile
	return Output
endFunction

int function GetMoodType(int Phase, int Gender)
	return GetPhase(Phase, Gender)[30]
endFunction

int function GetMoodAmount(int Phase, int Gender)
	return GetPhase(Phase, Gender)[31]
endFunction

int function GetIndex(int Phase, int Gender, int Mode, int id)
	return GetPhase(Phase, Gender)[Mode + id]
endFunction

; ------------------------------------------------------- ;
; --- Editing Functions                               --- ;
; ------------------------------------------------------- ;

function SetIndex(int Phase, int Gender, int Mode, int id, int value)
	int[] Preset = GetPhase(Phase, Gender)
	Preset[(Mode + id)] = value
	SetPhase(Phase, Gender, Preset)
endFunction

function SetPreset(int Phase, int Gender, int Mode, int id, int value)
	if Mode == Mood
		SetMood(Phase, Gender, id, value)
	elseif Mode == Modifier
		SetModifier(Phase, Gender, id, value)
	elseif Mode == Phoneme
		SetPhoneme(Phase, Gender, id, value)
	endIf
endFunction

function SetMood(int Phase, int Gender, int id, int value)
	if Gender == Female || Gender == MaleFemale
		SetIndex(Phase, Female, Mood, 0, id)
		SetIndex(Phase, Female, Mood, 1, value)
	endIf
	if Gender == Male || Gender == MaleFemale
		SetIndex(Phase, Male, Mood, 0, id)
		SetIndex(Phase, Male, Mood, 1, value)
	endIf
endFunction

function SetModifier(int Phase, int Gender, int id, int value)
	if Gender == Female || Gender == MaleFemale
		SetIndex(Phase, Female, Modifier, id, value)
	endIf
	if Gender == Male || Gender == MaleFemale
		SetIndex(Phase, Male, Modifier, id, value)
	endIf
endFunction

function SetPhoneme(int Phase, int Gender, int id, int value)
	if Gender == Female || Gender == MaleFemale
		SetIndex(Phase, Female, Phoneme, id, value)
	endIf
	if Gender == Male || Gender == MaleFemale
		SetIndex(Phase, Male, Phoneme, id, value)
	endIf
endFunction

function EmptyPhase(int Phase, int Gender)
	int[] Preset = new int[32]
	SetPhase(Phase, Gender, Preset)
	Phases[Gender] = ClampInt((Phases[Gender] - 1), 0, 5)
	CountPhases()
	if Phases[0] == 0 && Phases[1] == 0
		Enabled = false
	endIf
endFunction

function AddPhase(int Phase, int Gender)
	int[] Preset = GetPhase(Phase, Gender)
	if Preset[30] == 0 || Preset[31] == 0
		Preset[30] = 7
		Preset[31] = 50
	endIf
	SetPhase(Phase, Gender, Preset)
	Phases[Gender] = ClampInt((Phases[Gender] + 1), 0, 5)
	Enabled = true
endFunction

; ------------------------------------------------------- ;
; --- Phase Accessors                                 --- ;
; ------------------------------------------------------- ;

int[] function GetPhase(int Phase, int Gender)
	int[] Preset
	if Gender == Male
		if Phase == 1
			Preset = Male1
		elseIf Phase == 2
			Preset = Male2
		elseIf Phase == 3
			Preset = Male3
		elseIf Phase == 4
			Preset = Male4
		elseIf Phase == 5
			Preset = Male5
		endIf
	else
		if Phase == 1
			Preset = Female1
		elseIf Phase == 2
			Preset = Female2
		elseIf Phase == 3
			Preset = Female3
		elseIf Phase == 4
			Preset = Female4
		elseIf Phase == 5
			Preset = Female5
		endIf
	endIf
	if Preset.Length != 32
		return new int[32]
	endIf
	return Preset
endFunction

function SetPhase(int Phase, int Gender, int[] Preset)
	if Gender == Male
		if Phase == 1
			Male1 = Preset
		elseIf Phase == 2
			Male2 = Preset
		elseIf Phase == 3
			Male3 = Preset
		elseIf Phase == 4
			Male4 = Preset
		elseIf Phase == 5
			Male5 = Preset
		endIf
	else
		if Phase == 1
			Female1 = Preset
		elseIf Phase == 2
			Female2 = Preset
		elseIf Phase == 3
			Female3 = Preset
		elseIf Phase == 4
			Female4 = Preset
		elseIf Phase == 5
			Female5 = Preset
		endIf
	endIf
endFunction

; ------------------------------------------------------- ;
; --- System Use                                      --- ;
; ------------------------------------------------------- ;

function CountPhases()
	Phases = new int[2]
	; Male phases
	Phases[0] = Phases[0] + ((AddValues(Male1) > 0) as int)
	Phases[0] = Phases[0] + ((AddValues(Male2) > 0) as int)
	Phases[0] = Phases[0] + ((AddValues(Male3) > 0) as int)
	Phases[0] = Phases[0] + ((AddValues(Male4) > 0) as int)
	Phases[0] = Phases[0] + ((AddValues(Male5) > 0) as int)
	; Female phases
	Phases[1] = Phases[1] + ((AddValues(Female1) > 0) as int)
	Phases[1] = Phases[1] + ((AddValues(Female2) > 0) as int)
	Phases[1] = Phases[1] + ((AddValues(Female3) > 0) as int)
	Phases[1] = Phases[1] + ((AddValues(Female4) > 0) as int)
	Phases[1] = Phases[1] + ((AddValues(Female5) > 0) as int)
	; Enable it if phases are present
	if Phases[0] > 0 || Phases[1] > 0
		Enabled = true
	else
		Enabled = false
	endIf
endFunction

function Save(int id)
	CountPhases()
	Log(Name, "Expressions["+id+"]")
endFunction

function Initialize()
	; Gender phase counts
	Phases = new int[2]
	; Individual Phases
	Male1   = new int[1]
	Male2   = new int[1]
	Male3   = new int[1]
	Male4   = new int[1]
	Male5   = new int[1]
	Female1 = new int[1]
	Female2 = new int[1]
	Female3 = new int[1]
	Female4 = new int[1]
	Female5 = new int[1]
	parent.Initialize()
endFunction
