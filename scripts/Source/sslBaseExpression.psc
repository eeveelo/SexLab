scriptname sslBaseExpression extends sslBaseObject

import MfgConsoleFunc

; Gender Types
int property Male = 0 autoreadonly
int property Female = 1 autoreadonly
int property MaleFemale = -1 autoreadonly
; MFG Types
int property Phoneme = 0 autoreadonly
int property Modifier = 16 autoreadonly
int property Expression = 30 autoreadonly

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
	ApplyPhase(ActorRef, PickPhase(Amount, Gender), Gender)
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
	if Phase == 2
		Preset = Phase2
	elseIf Phase == 3
		Preset = Phase3
	elseIf Phase == 4
		Preset = Phase4
	elseIf Phase == 5
		Preset = Phase5
	else
		Preset = Phase1
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
	int[] Preset = GetPhase(Phase)
	int[] Output = new int[32]
	int g = 32 * ((Gender == Male) as int)
	int i
	while i < 32
		Output[i] = Preset[g]
		i += 1
		g += 1
	endWhile
	return Output
endFunction

;/-----------------------------------------------\;
;|	Editing Functions                            |;
;\-----------------------------------------------/;

function SetIndex(int Phase, int Gender, int Mode, int id, int value)
	; Get current phase array
	int[] Preset = GetPhase(Phase)
	; Set index of array to genders mode id number
	id += Mode
	id += 32 * ((Gender == Male) as int) ; Jump to male range 32-63
	Preset[id] = value
	; Save new array
	SetPhase(Phase, Preset)
	; Increase genders phase count if something was set on unknown phase
	if Phase > Phases[Gender]
		Phases[Gender] = Phases[Gender] + 1
	endIf
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

function AddPreset(int Phase, int Gender, int Mode, int id, int value)
	if Mode == Expression
		AddExpression(Phase, Gender, id, value)
	elseif Mode == Modifier
		AddModifier(Phase, Gender, id, value)
	elseif Mode == Phoneme
		AddPhoneme(Phase, Gender, id, value)
	endIf
endFunction

function AddExpression(int Phase, int Gender, int id, int value)
	if Gender == Female || Gender == MaleFemale
		SetIndex(Phase, Female, Expression, 0, id)
		SetIndex(Phase, Female, Expression, 1, value)
	endIf
	if Gender == Male || Gender == MaleFemale
		SetIndex(Phase, Male, Expression, 0, id)
		SetIndex(Phase, Male, Expression, 1, value)
	endIf
endFunction

function AddModifier(int Phase, int Gender, int id, int value)
	if Gender == Female || Gender == MaleFemale
		SetIndex(Phase, Female, Modifier, id, value)
	endIf
	if Gender == Male || Gender == MaleFemale
		SetIndex(Phase, Male, Modifier, id, value)
	endIf
endFunction

function AddPhoneme(int Phase, int Gender, int id, int value)
	if Gender == Female || Gender == MaleFemale
		SetIndex(Phase, Female, Phoneme, id, value)
	endIf
	if Gender == Male || Gender == MaleFemale
		SetIndex(Phase, Male, Phoneme, id, value)
	endIf
endFunction

function Save(int id)
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
