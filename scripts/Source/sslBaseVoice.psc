scriptname sslBaseVoice extends sslBaseObject

Sound property Hot auto
Sound property Mild auto
Sound property Medium auto

; Sound[] property HotPack
; Sound[] property MildPack
; Sound[] property VictimPack

Topic property LipSync auto hidden

int property Gender auto hidden
bool property Male hidden
	bool function get()
		return (Gender == 0 || Gender == -1)
	endFunction
endProperty
bool property Female hidden
	bool function get()
		return (Gender == 1 || Gender == -1)
	endFunction
endProperty

function Moan(Actor ActorRef, int Strength = 30, bool IsVictim = false)
	if Strength < 1
		Strength = 1
	endIf
	;/ Sound SoundRef = GetSound(Strength, IsVictim)
	if SoundRef
		LipSync(ActorRef, Strength)
		SoundRef.Play(ActorRef)
		Utility.WaitMenuMode(0.8)
	endIf /;

	Sound SoundRef = GetSound(Strength, IsVictim)
	if SoundRef
		MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, 1, 20)
		Utility.WaitMenuMode(0.1)
		SoundRef.Play(ActorRef)
		TransitUp(ActorRef, 20, 50)
		Utility.WaitMenuMode(0.2)
		TransitDown(ActorRef, 50, 20)
		MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, 1, 0)
	endIf
endFunction

function MoanNoWait(Actor ActorRef, int Strength = 30, bool IsVictim = false, float Volume = 1.0)
	if Volume > 0.0
		Sound SoundRef = GetSound(Strength, IsVictim)
		if SoundRef
			LipSync(ActorRef, Strength)
			Sound.SetInstanceVolume(SoundRef.Play(ActorRef), Volume)
		endIf
	endIf
endFunction

function TransitUp(Actor ActorRef, int from, int to)
	while from < to
		from += 2
		MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, 1, from)
	endWhile
endFunction
function TransitDown(Actor ActorRef, int from, int to)
	while from > to
		from -= 2
		MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, 1, from)
	endWhile
endFunction
function AnimatedMoan(Actor ActorRef, int Strength = 30, bool IsVictim = false, float Volume = 1.0)
	Sound SoundRef = GetSound(Strength, IsVictim)
	if SoundRef
		MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, 1, 20)
		Utility.WaitMenuMode(0.1)
		Sound.SetInstanceVolume(SoundRef.Play(ActorRef), Volume)
		TransitUp(ActorRef, 20, 50)
		Utility.WaitMenuMode(0.2)
		TransitDown(ActorRef, 50, 20)
		MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, 1, 0)
	endIf
endFunction

Sound function GetSound(int Strength, bool IsVictim = false)
	if Strength > 75 && Hot
		return Hot
	elseIf IsVictim && Medium
		return Medium
	endIf
	return Mild
endFunction

function LipSync(Actor ActorRef, int Strength, bool ForceUse = false)
	if (ForceUse || Config.UseLipSync) && Game.GetCameraState() != 3
		ActorRef.Say(LipSync)
	endIf
endFunction

bool function CheckGender(int CheckGender)
	return Gender == CheckGender || (Gender == -1 && (CheckGender == 1 || CheckGender == 0))
endFunction

function Save(int id = -1)
	parent.Save(id)
	AddTagConditional("Male",   (Gender == 0 || Gender == -1))
	AddTagConditional("Female", (Gender == 1 || Gender == -1))
	Log(Name, "Voices["+id+"]")
endFunction

function Initialize()
	Gender = -1
	Mild   = none
	Medium = none
	Hot    = none
	parent.Initialize()
	LipSync = Config.LipSync
endFunction

