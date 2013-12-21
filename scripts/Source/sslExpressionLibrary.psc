scriptname sslExpressionLibrary extends Quest

; Scripts
sslExpressionSlots property Slots auto
import MfgConsoleFunc

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
		SetPhonemeModifier(ActorRef, mode, id, value)
	endIf
endFunction

function ApplyPreset(int[] presets, actor ActorRef, bool openmouth = false)
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
	if !IsMouthOpen(ActorRef)
		ActorRef.ClearExpressionOverride()
		ActorRef.SetExpressionOverride(16, 100)
	endIf
endFunction

bool function IsMouthOpen(actor ActorRef) global
	return GetExpressionID(ActorRef) == 16 && GetExpressionValue(ActorRef) == 100
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
