scriptname sslBaseExpression extends sslBaseObject

import MfgConsoleFunc

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

; Gender Types
int Male = 0
int Female = 1
int MaleFemale = -1
; MFG Types
int Modifier = 0
int Phoneme = 14
int Expression = 30

int function PickPhase(int Amount, int Gender)
	return sslUtility.ClampInt(((sslUtility.ClampInt(Amount, 1, 100) * Phases[Gender]) / 100), 1, Phases[Gender])
endFunction

function ApplyPhase(Actor ActorRef, int Phase, int Gender)
	if Phase > Phases[Gender]
		return
	endIf
	int[] Preset = GetPhase(Phase)
	int g = 32 * ((Gender == Male) as int)
	; Set Modifers
	int i
	while i <= 13
		SetPhonemeModifier(ActorRef, 1, i, Preset[g])
		g += 1
		i += 1
	endWhile
	; Set Phoneme
	i = 0
	while i <= 15
		SetPhonemeModifier(ActorRef, 0, i, Preset[g])
		g += 1
		i += 1
	endWhile
	; Set expression
	ActorRef.SetExpressionOverride(Preset[g], Preset[(g + 1)])
endFunction

function Log(string Log)
	Debug.Trace(Name+" -- "+Log)
	MiscUtil.PrintConsole(Name+" -- "+Log)
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
	; Gender Types
	Male = 0
	Female = 1
	MaleFemale = -1
	; MFG Types
	Phoneme = 0
	Modifier = 14
	Expression = 30
	parent.Initialize()
endFunction
