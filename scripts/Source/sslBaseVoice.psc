scriptname sslBaseVoice extends quest

bool property enabled = true auto hidden

int property Male = 0 autoreadonly
int property Female = 1 autoreadonly

string property name = "" auto hidden
int property gender = 1 auto hidden

sound property mild auto
sound property hot auto
sound property medium auto

topic property SexLabMoanMild auto
topic property SexLabMoanMedium auto
topic property SexLabMoanHot auto

VoiceType property SexLabVoiceM auto
VoiceType property SexLabVoiceF auto
FormList property VoicesPlayer auto

string[] tags

;/-----------------------------------------------\;
;|	API Functions                                |;
;\-----------------------------------------------/;

int function PlayMild(actor a)
	ActorBase base = a.GetLeveledActorBase()
	VoiceType type = base.GetVoiceType()
	if type != none && !VoicesPlayer.HasForm(type)
		if base.GetSex() > 0
			base.SetVoiceType(SexLabVoiceF)
		else
			base.SetVoiceType(SexLabVoiceM)
		endIf
		a.Say(SexLabMoanMild)
		base.SetVoiceType(type)
	else
		a.Say(SexLabMoanMild)
	endIf
	return mild.Play(a)
endFunction

int function PlayMedium(actor a)
	ActorBase base = a.GetLeveledActorBase()
	VoiceType type = base.GetVoiceType()
	if type != none && !VoicesPlayer.HasForm(type)
		if base.GetSex() > 0
			base.SetVoiceType(SexLabVoiceF)
		else
			base.SetVoiceType(SexLabVoiceM)
		endIf
		a.Say(SexLabMoanMedium)
		base.SetVoiceType(type)
	else
		a.Say(SexLabMoanMedium)
	endIf
	return medium.Play(a)
endFunction

int function PlayHot(actor a)
	ActorBase base = a.GetLeveledActorBase()
	VoiceType type = base.GetVoiceType()
	if type != none && !VoicesPlayer.HasForm(type)
		if base.GetSex() > 0
			base.SetVoiceType(SexLabVoiceF)
		else
			base.SetVoiceType(SexLabVoiceM)
		endIf
		a.Say(SexLabMoanHot)
		base.SetVoiceType(type)
	else
		a.Say(SexLabMoanHot)
	endIf
	return hot.Play(a)
endFunction

int function Moan(actor a, float strength = 0.3, bool victim = false)
	int seed = ((1.0 - strength) * 100.0) as int
	int randomizer = Utility.RandomInt(0, seed)
	debug.trace("Seed: "+seed+" Randomizer: "+randomizer)
	if randomizer <= 10 && !victim
		return PlayHot(a)
	elseif randomizer <= 20 || victim
		return PlayMedium(a)
	else
		return PlayMild(a)
	endIf
endFunction

;/-----------------------------------------------\;
;|	Tag Functions                                |;
;\-----------------------------------------------/;

bool function AddTag(string tag)
	bool check = HasTag(tag)
	if check
		return false
	else
		int tagCount = tags.Length
		tags = sslUtility.PushString(tag,tags)
		return true
	endIf
endFunction

bool function RemoveTag(string tag)
	if !HasTag(tag)
		return false
	endIf
	string[] newTags
	int i = 0
	while i < tags.Length
		if tags[i] != tag
			newTags = sslUtility.PushString(tags[i],newTags)
		endIf
		i += 1
	endWhile
	tags = newTags
	return true
endFunction

bool function HasTag(string tag)
		return tags.Find(tag) != -1
endFunction

;/-----------------------------------------------\;
;|	Child loaders                                |;
;\-----------------------------------------------/;

function LoadVoice()
	return
endFunction

function UnloadVoice()
	name = ""
	enabled = true
	gender = 1
	mild = none
	hot = none
	medium = none
endFunction
