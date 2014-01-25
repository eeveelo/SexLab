scriptname sslBaseVoice extends sslBaseObject

sslVoiceLibrary property Lib auto

int property Gender auto hidden

Sound property Mild auto hidden
Sound property Hot auto hidden
Sound property Medium auto hidden

;/-----------------------------------------------\;
;|	API Functions                                |;
;\-----------------------------------------------/;

int function Moan(actor a, int strength = 30, bool victim = false)
	; Victim always uses medium
	if victim
		return PlayMedium(a)
	endIf
	; Return extremes from clamped values
	if strength > 100
		return PlayHot(a)
	elseIf strength < 1
		return PlayMild(a)
	endIf
	; Randomize slightly
	strength = Utility.RandomInt(0, (100 - strength))
	if strength <= 15
		return PlayHot(a)
	elseif strength <= 18
		return PlayMedium(a)
	else
		return PlayMild(a)
	endIf
endFunction

int function PlaySound(actor a, sound soundset, topic lipsync)
	if Game.GetCameraState() != 3
		ActorBase base = a.GetLeveledActorBase()
		VoiceType type = base.GetVoiceType()
		if Lib.VoicesPlayer.HasForm(type) || type == Lib.SexLabVoiceM || type == Lib.SexLabVoiceF
			a.Say(lipsync)
		else
			if base.GetSex() > 0
				base.SetVoiceType(Lib.SexLabVoiceF)
			else
				base.SetVoiceType(Lib.SexLabVoiceM)
			endIf
			a.Say(lipsync)
			base.SetVoiceType(type)
		endIf
	endIf
	soundset.PlayAndWait(a)
	return 1
endFunction

int function PlayMild(actor a)
	return PlaySound(a, Mild, Lib.SexLabMoanMild)
endFunction

int function PlayMedium(actor a)
	return PlaySound(a, Medium, Lib.SexLabMoanMedium)
endFunction

int function PlayHot(actor a)
	return PlaySound(a, Hot, Lib.SexLabMoanHot)
endFunction

;/-----------------------------------------------\;
;|	System Use                                   |;
;\-----------------------------------------------/;

function Initialize()
	Gender = 0
	parent.Initialize()
endFunction

function _Export()
	string exportkey ="SexLabConfig.Voices["+Name+"]."
	StorageUtil.FileSetIntValue(exportkey+"Enabled", Enabled as int)
endFunction
function _Import()
	string exportkey ="SexLabConfig.Voices["+Name+"]."
	Enabled = StorageUtil.FileGetIntValue(exportkey+"Enabled", Enabled as int) as bool
	StorageUtil.FileUnsetIntValue(exportkey+"Enabled")
endFunction
