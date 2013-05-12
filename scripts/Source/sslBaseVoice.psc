scriptname sslBaseVoice extends quest

bool property enabled = true auto

int property Male = 0 autoreadonly
int property Female = 1 autoreadonly

string property name = "" auto
int property gender = 1 auto

sound property mild auto
sound property hot auto
sound property medium auto

topic property MoanMild auto
topic property MoanMedium auto
topic property MoanHot auto


int function PlayMild(actor a)
	; a.Say(MoanMild)
	return mild.Play(a)
endFunction

int function PlayMedium(actor a)
	; a.Say(MoanMedium)
	return medium.Play(a)
endFunction

int function PlayHot(actor a)
	; a.Say(MoanHot)
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
	gender = 1
	mild = none
	hot = none
	medium = none
endFunction
