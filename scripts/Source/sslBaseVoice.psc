scriptname sslBaseVoice extends ReferenceAlias

sslVoiceLibrary property Lib auto

string property Name = "" auto hidden
bool property Enabled = true auto hidden
int property Gender auto hidden

bool property Registered hidden
	bool function get()
		return Name != ""
	endFunction
endProperty

Sound property Mild auto hidden
Sound property Hot auto hidden
Sound property Medium auto hidden

string[] tags

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
	ActorBase base = a.GetLeveledActorBase()
	VoiceType type = base.GetVoiceType()
	; debug.trace(type)
	if Lib.VoicesPlayer.HasForm(type) || type == Lib.SexLabVoiceM || type == Lib.SexLabVoiceF
		a.Say(lipsync)
		; debug.trace(base.GetName()+" playing "+lipsync+" from playervoice: "+type)
	else
		if base.GetSex() > 0
			base.SetVoiceType(Lib.SexLabVoiceF)
		else
			base.SetVoiceType(Lib.SexLabVoiceM)
		endIf
		; debug.trace(base.GetName()+" playing "+lipsync+" from SEXLABVOICE: "+type+" -> "+base.GetVoiceType())
		a.Say(lipsync)
		base.SetVoiceType(type)
		; debug.trace(base.GetName()+" returned to "+base.GetVoiceType())
	endIf
	return soundset.Play(a)
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

function Initialize()
	Name = ""
	Enabled = true
	Gender = 0
	string[] tagsDel
	tags = tagsDel
endFunction
