scriptname sslExpressionLibrary extends Quest

; Scripts
sslExpressionSlots property Slots auto

; Data
actor property PlayerRef auto

; Gender Types
bool property Male = false autoreadonly hidden
bool property Female = true autoreadonly hidden
; MFG Types
int property Phoneme = 0 autoreadonly hidden
int property Modifier = 1 autoreadonly hidden
int property Expression = 2 autoreadonly hidden

; Config
int[] BasePresetMale
int[] BasePresetFemale


function MFG(actor ActorRef, int mode, int id, int value)
	if mode == 2
		ActorRef.SetExpressionOverride(id, value)
	else
		MfgConsoleFunc.SetPhonemeModifier(ActorRef, mode, id, value)
	endIf
endFunction

function ApplyPreset(int[] presets, actor ActorRef, bool openmouth = false)
	if ActorRef == none
		return ; Nobody to express with!
	endIf
	; Clear existing mfg from actor
	; ActorRef.ClearExpressionOverride()
	MfgConsoleFunc.ResetPhonemeModifier(ActorRef)
	; Apply preset, [n + 0] = mode, [n + 1] = id, [n + 2] = value
	int i = presets.Length
	while i
		i -= 3
		if presets[i] == 2 && !openmouth
			ActorRef.SetExpressionOverride(presets[(i + 1)], presets[(i + 2)])
		else
			MfgConsoleFunc.SetPhonemeModifier(ActorRef, presets[i], presets[(i + 1)], presets[(i + 2)])
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

sslBaseExpression function PickExpression(actor ActorRef, actor VictimRef = none)
	if VictimRef != none && ActorRef == VictimRef
		; Return random victim
		return Slots.RandomByTag("Victim")
	elseif VictimRef != none && ActorRef != VictimRef
		; Return random aggressor
		return Slots.RandomByTag("Aggressor")
	endIf
	; Return random consensual
	return Slots.RandomByTag("Consensual")
endFunction

int[] function PresetMixin(int[] basepreset, int enjoyment, bool female, bool victim = false)
	float amount = (enjoyment as float / 100.0)
	debug.trace("base: "+basepreset+ " enjoyment: "+ enjoyment +" amount: "+amount)

	int i = basepreset.Length
	while i
		i -= 1
		debug.trace("was "+basepreset[i])
		basepreset[i] = (amount * basepreset[i] as float) as int
		debug.trace("altering to "+basepreset[i])
		i -= 2
	endWhile
	return basepreset
endFunction

int[] function GetBasePreset(bool gender)
	if gender == Male
		return BasePresetMale
	endIf
	return BasePresetFemale
endFunction

int[] function AddBasePreset(bool gender, int mode, int id, int value)
	int[] presets = sslUtility.IncreaseInt(3, GetBasePreset(gender))
	int index = (presets.Length - 3)
	presets[index] = mode
	presets[index + 1] = id
	presets[index + 2] = value
	return presets
endFunction

function _Defaults()
	int[] iDel
	BasePresetMale = iDel
	BasePresetFemale = iDel

	BasePresetMale = AddBasePreset(Male, Expression, 13, 40)
	BasePresetMale = AddBasePreset(Male, Modifier, 6, 80)
	BasePresetMale = AddBasePreset(Male, Modifier, 7, 80)
	BasePresetMale = AddBasePreset(Male, Modifier, 12, 30)
	BasePresetMale = AddBasePreset(Male, Modifier, 13, 30)
	BasePresetMale = AddBasePreset(Male, Phoneme, 0, 30)
	BasePresetMale = AddBasePreset(Male, Phoneme, 5, 20)
	BasePresetMale = AddBasePreset(Male, Phoneme, 2, 50)
	BasePresetMale = AddBasePreset(Male, Phoneme, 13, 20)

	BasePresetFemale = AddBasePreset(Female, Expression, 10, 100)
	BasePresetFemale = AddBasePreset(Female, Modifier, 0, 10)
	BasePresetFemale = AddBasePreset(Female, Modifier, 1, 10)
	BasePresetFemale = AddBasePreset(Female, Modifier, 2, 25)
	BasePresetFemale = AddBasePreset(Female, Modifier, 3, 25)
	BasePresetFemale = AddBasePreset(Female, Modifier, 6, 100)
	BasePresetFemale = AddBasePreset(Female, Modifier, 7, 100)
	BasePresetFemale = AddBasePreset(Female, Modifier, 12, 30)
	BasePresetFemale = AddBasePreset(Female, Modifier, 13, 30)
	BasePresetFemale = AddBasePreset(Female, Phoneme, 4, 35)
	BasePresetFemale = AddBasePreset(Female, Phoneme, 10, 20)
	BasePresetFemale = AddBasePreset(Female, Phoneme, 12, 30)

	debug.notification("BasePresetMale: "+BasePresetMale.Length)
endFunction
