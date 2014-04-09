scriptname sslBaseExpression extends sslBaseObject

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

int[] Phase1
int[] Phase2
int[] Phase3
int[] Phase4
int[] Phase5

int function PickPhase(int Amount, int Gender)
	return sslUtility.ClampInt(((sslUtility.ClampInt(Amount, 1, 100) * Phases[Gender]) / 100), 1, Phases[Gender])
endFunction

function Apply(Actor ActorRef, int Amount, int Gender)
	int Phase = PickPhase(Amount, Gender)
	Log("Phase: "+Phase, Amount)
	ApplyPhase(ActorRef, Phase, Gender)
endFunction

function ApplyPhase(Actor ActorRef, int Phase, int Gender)
	if Phase > Phases[Gender]
		return
	endIf
	int[] Preset = GetPhase(Phase)
	int i = 32 * ((Gender == Male) as int)
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
	ActorRef.SetExpressionOverride(Preset[i], Preset[(i + 1)])
endFunction

int[] function GetPhase(int Phase)
	int[] Preset
	if Phase == 1
		Preset = Phase1
	elseIf Phase == 2
		Preset = Phase2
	elseIf Phase == 3
		Preset = Phase3
	elseIf Phase == 4
		Preset = Phase4
	elseIf Phase == 5
		Preset = Phase5
	else
		return none
	endIf
	if Preset.Length == 64
		return Preset
	endIf
	return new int[64]
endFunction

int[] function GetGenderPhase(int Phase, int Gender)
	if Phase > Phases[Gender]
		return none
	endIf
	int[] Output = new int[32]
	int[] Preset = GetPhase(Phase)
	int g = GI(Gender)
	int i
	while i < 32
		Output[i] = Preset[i + g]
		i += 1
	endWhile
	return Output
endFunction

int[] function GetPhonemes(int Phase, int Gender)
	int[] Output = new int[16]
	int[] Preset = GetPhase(Phase)
	int g = GI(Gender) + Phoneme
	int i
	while i < 16
		Output[i] = Preset[i + g]
		i += 1
	endWhile
	return Output
endFunction

int[] function GetModifiers(int Phase, int Gender)
	int[] Output = new int[14]
	int[] Preset = GetPhase(Phase)
	int g = GI(Gender) + Modifier
	int i
	while i < 14
		Output[i] = Preset[i + g]
		i += 1
	endWhile
	return Output
endFunction

int function GetMoodType(int Phase, int Gender)
	return GetPhase(Phase)[GI(Gender) + 30]
endFunction
int function GetMoodAmount(int Phase, int Gender)
	return GetPhase(Phase)[GI(Gender) + 31]
endFunction

;/-----------------------------------------------\;
;|	Editing Functions                            |;
;\-----------------------------------------------/;

int function GI(int Gender)
	if Gender == 0
		return 32
	endIf
	return 0
endFunction

function SetIndex(int Phase, int Gender, int Mode, int id, int value)
	int[] Preset = GetPhase(Phase)
	id += GI(Gender) + Mode
	; Set index of phase
	Preset[id] = value
	; Save new array
	SetPhase(Phase, Preset)
endFunction

int function GetIndex(int Phase, int Gender, int Mode, int id)
	int[] Preset = GetPhase(Phase)
	id += GI(Gender) + Mode
	return Preset[id]
endFunction

function SetPhase(int Phase, int[] Preset)
	if Phase == 1
		Phase1 = Preset
	elseIf Phase == 2
		Phase2 = Preset
	elseIf Phase == 3
		Phase3 = Preset
	elseIf Phase == 4
		Phase4 = Preset
	elseIf Phase == 5
		Phase5 = Preset
	endIf
endFunction

function CountPhases()
	Phases = new int[2]
	int Phase
	while Phase < 5
		Phase += 1
		int[] Preset = GetPhase(Phase)
		Phases[1] = Phases[1] + ((sslUtility.AddValues(sslUtility.SliceIntArray(Preset, 0, 29)) > 0) as int)
		Phases[0] = Phases[0] + ((sslUtility.AddValues(sslUtility.SliceIntArray(Preset, 32, 61)) > 0) as int)
	endWhile
endFunction

function AddPreset(int Phase, int Gender, int Mode, int id, int value)
	if Mode == Mood
		AddMood(Phase, Gender, id, value)
	elseif Mode == Modifier
		AddModifier(Phase, Gender, id, value)
	elseif Mode == Phoneme
		AddPhoneme(Phase, Gender, id, value)
	endIf
endFunction

function AddMood(int Phase, int Gender, int id, int value)
	if Gender == Female || Gender == MaleFemale
		SetIndex(Phase, Female, Mood, 0, id)
		SetIndex(Phase, Female, Mood, 1, value)
	endIf
	if Gender == Male || Gender == MaleFemale
		SetIndex(Phase, Male, Mood, 0, id)
		SetIndex(Phase, Male, Mood, 1, value)
	endIf
	if Phases[Gender] < Phase
		Phases[Gender] = Phase
	endIf
endFunction

function AddModifier(int Phase, int Gender, int id, int value)
	if Gender == Female || Gender == MaleFemale
		SetIndex(Phase, Female, Modifier, id, value)
	endIf
	if Gender == Male || Gender == MaleFemale
		SetIndex(Phase, Male, Modifier, id, value)
	endIf
	if Phases[Gender] < Phase
		Phases[Gender] = Phase
	endIf
endFunction

function AddPhoneme(int Phase, int Gender, int id, int value)
	if Gender == Female || Gender == MaleFemale
		SetIndex(Phase, Female, Phoneme, id, value)
	endIf
	if Gender == Male || Gender == MaleFemale
		SetIndex(Phase, Male, Phoneme, id, value)
	endIf
	if Phases[Gender] < Phase
		Phases[Gender] = Phase
	endIf
endFunction

function Save(int id)
	; Calculate how many phases have presets
	CountPhases()
	; Make sure we have a Gender tag
	if PhasesMale > 0
		AddTag("Male")
	endIf
	if PhasesFemale > 0
		AddTag("Female")
	endIf
	; Log
	Log(Name, "Expressions["+id+"]")
endFunction

function Initialize()
	; Gender phase counts
	Phases = new int[2]
	; Individual Phases
	int[] dPhase1
	int[] dPhase2
	int[] dPhase3
	int[] dPhase4
	int[] dPhase5
	Phase1 = dPhase1
	Phase2 = dPhase2
	Phase3 = dPhase3
	Phase4 = dPhase4
	Phase5 = dPhase5
	parent.Initialize()
endFunction
