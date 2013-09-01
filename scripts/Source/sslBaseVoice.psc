scriptname sslBaseVoice extends ReferenceAlias

sslVoiceRegistry property Registry auto

string property Name = "" auto hidden
string property Registrar = "" auto hidden
bool property Enabled = true auto hidden
int property Gender auto hidden

bool property Slotted hidden
	bool function get()
		return Registrar != "" && Name != ""
	endFunction
endProperty

Sound property Mild auto hidden
Sound property Hot auto hidden
Sound property Medium auto hidden

string[] tags

;/-----------------------------------------------\;
;|	API Functions                                |;
;\-----------------------------------------------/;

int function Moan(actor a, float strength = 0.3, bool victim = false)
	int seed = ((1.0 - strength) * 100.0) as int
	int randomizer = Utility.RandomInt(0, seed)
	if randomizer <= 10 && !victim
		return PlayHot(a)
	elseif randomizer <= 20 || victim
		return PlayMedium(a)
	else
		return PlayMild(a)
	endIf
endFunction

int function PlaySound(actor a, sound soundset, topic lipsync)
	ActorBase base = a.GetLeveledActorBase()
	VoiceType type = base.GetVoiceType()
	if Registry.VoicesPlayer.HasForm(type) || type == Registry.SexLabVoiceM || type == Registry.SexLabVoiceF
		a.Say(lipsync)
	else
		if base.GetSex() > 0
			base.SetVoiceType(Registry.SexLabVoiceF)
		else
			base.SetVoiceType(Registry.SexLabVoiceM)
		endIf
		a.Say(lipsync)
		base.SetVoiceType(type)
	endIf
	return soundset.Play(a)
endFunction

int function PlayMild(actor a)
	return PlaySound(a, Mild, Registry.SexLabMoanMild)
endFunction

int function PlayMedium(actor a)
	return PlaySound(a, Medium, Registry.SexLabMoanMedium)
endFunction

int function PlayHot(actor a)
	return PlaySound(a, Hot, Registry.SexLabMoanHot)
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
		return tags.Find(tag) >= 0
endFunction

;/-----------------------------------------------\;
;|	Child loaders                                |;
;\-----------------------------------------------/;

function LoadVoice()
	return
endFunction

function InitializeVoice()
	name = ""
	enabled = true
	gender = 1
	string[] tagsDel
	tags = tagsDel
endFunction
