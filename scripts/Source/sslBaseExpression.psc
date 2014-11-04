scriptname sslBaseExpression extends sslBaseObject

import PapyrusUtil
import MfgConsoleFunc

; Gender Types
int property Male = 0 autoreadonly
int property Female = 1 autoreadonly
int property MaleFemale = -1 autoreadonly
; MFG Types
int property Phoneme = 0 autoreadonly
int property Modifier = 16 autoreadonly
int property Mood = 30 autoreadonly

string property File hidden
	string function get()
		return "../SexLab/Expression_"+Registry+".json"
	endFunction
endProperty

int[] Phases
int[] property PhaseCounts hidden
	int[] function get()
		return Phases
	endFunction
endProperty
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

; ------------------------------------------------------- ;
; --- Application Functions                           --- ;
; ------------------------------------------------------- ;

function Apply(Actor ActorRef, int Strength, int Gender)
	; Log("Phase: "+PickPhase(Strength, Gender), Strength)
	ApplyPhase(ActorRef, PickPhase(Strength, Gender), Gender)
endFunction

function ApplyPhase(Actor ActorRef, int Phase, int Gender)
	if Phase <= Phases[Gender]
		ApplyPreset(ActorRef, GetPhase(Phase, Gender))
	endIf
endFunction

int function PickPhase(int Strength, int Gender)
	return ClampInt(((ClampInt(Strength, 1, 100) * Phases[Gender]) / 100), 1, Phases[Gender])
endFunction

int[] function SelectPhase(int Strength, int Gender)
	return GetPhase(PickPhase(Strength, Gender), Gender)
endFunction

; ------------------------------------------------------- ;
; --- Global Utilities                                --- ;
; ------------------------------------------------------- ;

function OpenMouth(Actor ActorRef) global
	ClearPhoneme(ActorRef)
	ActorRef.SetExpressionOverride(16, 1)
	ActorRef.SetExpressionPhoneme(1, 0.4)
endFunction

function CloseMouth(Actor ActorRef) global
	ActorRef.ClearExpressionOverride()
	ActorRef.SetExpressionPhoneme(1, 0.0)
endFunction

bool function IsMouthOpen(Actor ActorRef) global
	return (GetExpressionID(ActorRef) == 16 && GetExpressionValue(ActorRef) == 100) || (GetPhonemeModifier(ActorRef, 0, 1) >= 40)
endFunction

function ClearMFG(Actor ActorRef) global
	ActorRef.ResetExpressionOverrides()
	ActorRef.ClearExpressionOverride()
	ResetPhonemeModifier(ActorRef)
endFunction

function ClearPhoneme(Actor ActorRef) global
	int i
	while i <= 15
		ActorRef.SetExpressionPhoneme(i, 0.0)
		i += 1
	endWhile
endFunction

function ClearModifier(Actor ActorRef) global
	int i
	while i <= 13
		ActorRef.SetExpressionModifier(i, 0.0)
		i += 1
	endWhile
endFunction

function ApplyPreset(Actor ActorRef, int[] Preset) global
	int i
	; Set Phoneme
	int p
	while p <= 15
		ActorRef.SetExpressionPhoneme(p, Preset[i] as float / 100.0)
		i += 1
		p += 1
	endWhile
	; Set Modifers
	int m
	while m <= 13
		ActorRef.SetExpressionModifier(m, Preset[i] as float / 100.0)
		i += 1
		m += 1
	endWhile
	; Set expression
	ActorRef.SetExpressionOverride(Preset[30], Preset[31])
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

bool function HasPhase(int Phase, Actor ActorRef)
	if !ActorRef || Phase < 1
		return false
	endIf
	int gender = ActorRef.GetLeveledActorBase().GetSex()
	return (gender == 1 && Phase <= PhasesFemale) || (gender == 0 && Phase <= PhasesMale)
endFunction

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
; --- System Use                                      --- ;
; ------------------------------------------------------- ;

function CountPhases()
	Phases = new int[2]
	; Male phases
	Phases[0] = Phases[0] + ((AddIntValues(Male1) > 0) as int)
	Phases[0] = Phases[0] + ((AddIntValues(Male2) > 0) as int)
	Phases[0] = Phases[0] + ((AddIntValues(Male3) > 0) as int)
	Phases[0] = Phases[0] + ((AddIntValues(Male4) > 0) as int)
	Phases[0] = Phases[0] + ((AddIntValues(Male5) > 0) as int)
	; Female phases
	Phases[1] = Phases[1] + ((AddIntValues(Female1) > 0) as int)
	Phases[1] = Phases[1] + ((AddIntValues(Female2) > 0) as int)
	Phases[1] = Phases[1] + ((AddIntValues(Female3) > 0) as int)
	Phases[1] = Phases[1] + ((AddIntValues(Female4) > 0) as int)
	Phases[1] = Phases[1] + ((AddIntValues(Female5) > 0) as int)
	; Enable it if phases are present
	if Phases[0] > 0 || Phases[1] > 0
		Enabled = true
	else
		Enabled = false
	endIf
endFunction

function Save(int id = -1)
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

bool function ExportJson()
	JsonUtil.ClearAll(File)

	JsonUtil.SetStringValue(File, "Name", Name)
	JsonUtil.SetIntValue(File, "Enabled", Enabled as int)

	JsonUtil.SetIntValue(File, "Normal", HasTag("Normal") as int)
	JsonUtil.SetIntValue(File, "Victim", HasTag("Victim") as int)
	JsonUtil.SetIntValue(File, "Aggressor", HasTag("Aggressor") as int)

	JsonUtil.IntListCopy(File, "Female1", Female1)
	JsonUtil.IntListCopy(File, "Female2", Female2)
	JsonUtil.IntListCopy(File, "Female3", Female3)
	JsonUtil.IntListCopy(File, "Female4", Female4)
	JsonUtil.IntListCopy(File, "Female5", Female5)
	JsonUtil.IntListCopy(File, "Male1", Male1)
	JsonUtil.IntListCopy(File, "Male2", Male2)
	JsonUtil.IntListCopy(File, "Male3", Male3)
	JsonUtil.IntListCopy(File, "Male4", Male4)
	JsonUtil.IntListCopy(File, "Male5", Male5)

	return JsonUtil.Save(File, true)
endFunction

bool function ImportJson()
	if JsonUtil.GetStringValue(File, "Name") == "" || (JsonUtil.IntListCount(File, "Female1") != 32 && JsonUtil.IntListCount(File, "Male1") != 32)
		Log("Failed to import "+File)
		return false
	endIf

	Name = JsonUtil.GetStringValue(File, "Name", Name)
	Enabled = JsonUtil.GetIntValue(File, "Enabled", Enabled as int) as bool

	AddTagConditional("Normal", JsonUtil.GetIntValue(File, "Normal", HasTag("Normal") as int) as bool)
	AddTagConditional("Victim", JsonUtil.GetIntValue(File, "Victim", HasTag("Victim") as int) as bool)
	AddTagConditional("Aggressor", JsonUtil.GetIntValue(File, "Aggressor", HasTag("Aggressor") as int) as bool)

	Female1 = new int[1]
	if JsonUtil.IntListCount(File, "Female1") == 32
		Female1 = new int[32]
		JsonUtil.IntListSlice(File, "Female1", Female1)
	endIf
	Female2 = new int[1]
	if JsonUtil.IntListCount(File, "Female2") == 32
		Female2 = new int[32]
		JsonUtil.IntListSlice(File, "Female2", Female2)
	endIf
	Female3 = new int[1]
	if JsonUtil.IntListCount(File, "Female3") == 32
		Female3 = new int[32]
		JsonUtil.IntListSlice(File, "Female3", Female3)
	endIf
	Female4 = new int[1]
	if JsonUtil.IntListCount(File, "Female4") == 32
		Female4 = new int[32]
		JsonUtil.IntListSlice(File, "Female4", Female4)
	endIf
	Female5 = new int[1]
	if JsonUtil.IntListCount(File, "Female5") == 32
		Female5 = new int[32]
		JsonUtil.IntListSlice(File, "Female5", Female5)
	endIf

	Male1 = new int[1]
	if JsonUtil.IntListCount(File, "Male1") == 32
		Male1 = new int[32]
		JsonUtil.IntListSlice(File, "Male1", Male1)
	endIf
	Male2 = new int[1]
	if JsonUtil.IntListCount(File, "Male2") == 32
		Male2 = new int[32]
		JsonUtil.IntListSlice(File, "Male2", Male2)
	endIf
	Male3 = new int[1]
	if JsonUtil.IntListCount(File, "Male3") == 32
		Male3 = new int[32]
		JsonUtil.IntListSlice(File, "Male3", Male3)
	endIf
	Male4 = new int[1]
	if JsonUtil.IntListCount(File, "Male4") == 32
		Male4 = new int[32]
		JsonUtil.IntListSlice(File, "Male4", Male4)
	endIf
	Male5 = new int[1]
	if JsonUtil.IntListCount(File, "Male5") == 32
		Male5 = new int[32]
		JsonUtil.IntListSlice(File, "Male5", Male5)
	endIf

	CountPhases()

	return true
endFunction

; ------------------------------------------------------- ;
; --- DEPRECATED                                      --- ;
; ------------------------------------------------------- ;

function ApplyTo(Actor ActorRef, int Strength = 50, bool IsFemale = true, bool OpenMouth = false)
	Apply(ActorRef, Strength, IsFemale as int)
	if OpenMouth
		OpenMouth(ActorRef)
	endIf
endFunction

int[] function PickPreset(int Strength, bool IsFemale)
	return GetPhase(CalcPhase(Strength, IsFemale), (IsFemale as int))
endFunction

int function CalcPhase(int Strength, bool IsFemale)
	return PickPhase(Strength, (IsFemale as int))
endFunction



; ------------------------------------------------------- ;
; --- Tagging System                                  --- ;
; ------------------------------------------------------- ;

; bool function AddTag(string Tag) native
; bool function HasTag(string Tag) native
; bool function RemoveTag(string Tag) native
; bool function ToggleTag(string Tag) native
; bool function AddTagConditional(string Tag, bool AddTag) native
; bool function ParseTags(string[] TagList, bool RequireAll = true) native
; bool function CheckTags(string[] CheckTags, bool RequireAll = true, bool Suppress = false) native
; bool function HasOneTag(string[] TagList) native
; bool function HasAllTag(string[] TagList) native

; function AddTags(string[] TagList)
; 	int i = TagList.Length
; 	while i
; 		i -= 1
; 		AddTag(TagList[i])
; 	endWhile
; endFunction

; int function TagCount() native
; string function GetNthTag(int i) native
; function TagSlice(string[] Ouput) native

; string[] function GetTags()
; 	int i = TagCount()
; 	Log(Registry+" - TagCount: "+i)
; 	if i < 1
; 		return sslUtility.StringArray(0)
; 	endIf
; 	string[] Output = sslUtility.StringArray(i)
; 	TagSlice(Output)
; 	Log(Registry+" - SKSE Tags: "+Output)
; 	return Output
; endFunction

; function RevertTags() native

