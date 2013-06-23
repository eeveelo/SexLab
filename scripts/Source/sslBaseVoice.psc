scriptname sslBaseVoice extends quest

bool property enabled = true auto

int property Male = 0 autoreadonly
int property Female = 1 autoreadonly

string property name = "" auto
int property gender = 1 auto

sound property mild auto
sound property hot auto
sound property medium auto

topic property SexLabMoanMild auto
topic property SexLabMoanMedium auto
topic property SexLabMoanHot auto

VoiceType property SexLabVoiceM auto
VoiceType property SexLabVoiceF auto
FormList property VoicesPlayer auto

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

int function Moan(actor a, float strength = 0.3, actor victim = none)
	; Non rough selection
	if victim != a
		if strength <= 0.25
			return PlayMild(a)
		; Mostly Mild, occasionalyl rough/hot
		elseif strength <= 0.45
			int random = utility.RandomInt(1,10)
			if random == 1
				return PlayHot(a)
			else
				return PlayMild(a)
			endIf
		; Slightly more mixed
		elseif strength <= 0.50
			int random = utility.RandomInt(1,8)	
			if random == 1
				return PlayHot(a)
			else
				return PlayMild(a)
			endIf
		; Slightly more more mixed
		elseif strength <= 0.70
			int random = utility.RandomInt(1,7)	
			if random == 1
				return PlayHot(a)
			else
				return PlayMild(a)
			endIf
		; Almost split mild and hot/medium
		elseif strength <= 0.85
			int random = utility.RandomInt(1,5)	
			if random == 1
				return PlayMedium(a)
			elseif random == 2
				return PlayHot(a)
			else
				return PlayMild(a)
			endIf
		; split mild and hot/medium
		elseif strength <= 0.99
			int random = utility.RandomInt(1,4)	
			if random == 1
				return PlayMedium(a)
			elseif random == 2
				return PlayHot(a)
			else
				return PlayMild(a)
			endIf
		; Full strength, all hot
		else
			return PlayHot(a)
		endIf
	else
		return PlayMedium(a)
	endIf
endFunction


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
