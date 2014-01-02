scriptname sslExpressionLibrary extends sslSystemLibrary

; Scripts
sslExpressionSlots property Slots auto
import MfgConsoleFunc

; Data

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


function MFG(actor ActorRef, int mode, int id, int value) global
	if mode == 2
		ActorRef.SetExpressionOverride(id, value)
	else
		SetPhonemeModifier(ActorRef, mode, id, value)
	endIf
endFunction

function ApplyPreset(int[] presets, actor ActorRef, bool openmouth = false) global
	if ActorRef == none
		return ; Nobody to express with!
	endIf
	; Clear existing mfg from actor
	; ActorRef.ClearExpressionOverride()
	ResetPhonemeModifier(ActorRef)
	; Apply preset, [n + 0] = mode, [n + 1] = id, [n + 2] = value
	int i = presets.Length
	while i
		i -= 3
		if presets[i] == 2 && !openmouth
			ActorRef.SetExpressionOverride(presets[(i + 1)], presets[(i + 2)])
		else
			SetPhonemeModifier(ActorRef, presets[i], presets[(i + 1)], presets[(i + 2)])
		endIf
	endWhile
	; Apply open mouth
	if openmouth
		OpenMouth(ActorRef)
	endIf
endFunction

function OpenMouth(actor ActorRef) global
	MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, 1, 100)
	ActorRef.SetExpressionOverride(16, 100)
endFunction

function CloseMouth(actor ActorRef) global
	MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, 1, 0)
	ActorRef.ClearExpressionOverride()
endFunction

bool function IsMouthOpen(actor ActorRef) global
	return (GetExpressionID(ActorRef) == 16 && GetExpressionValue(ActorRef) == 100) || (MfgConsoleFunc.GetPhonemeModifier(ActorRef, 0, 1) == 100)
endFunction

function ClearMFG(actor ActorRef) global
	ActorRef.ClearExpressionOverride()
	ResetPhonemeModifier(ActorRef)
endFunction

function ClearPhoneme(actor ActorRef) global
	int i
	while i <= 15
		SetPhonemeModifier(ActorRef, 0, i, 0)
		i += 1
	endWhile
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

function _Defaults()
endFunction
function _Export()
	int i = Expressions.Slotted
	while i
		i -= 1
		Expressions.Expression[i]._Export()
	endWhile
endFunction
function _Import()
	_Defaults()
	int i = Expressions.Slotted
	while i
		i -= 1
		Expressions.Expression[i]._Import()
	endWhile
endFunction
