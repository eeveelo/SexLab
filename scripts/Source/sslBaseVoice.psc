scriptname sslBaseVoice extends sslBaseObject

Topic LipSync
FormList VoicesPlayer
VoiceType SexLabVoiceM
VoiceType SexLabVoiceF

Sound property Mild auto hidden
Sound property Medium auto hidden
Sound property Hot auto hidden

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

function Moan(Actor ActorRef, int Strength = 30, bool IsVictim = false, bool UseLipSync = false)
	if UseLipSync && Game.GetCameraState() != 3
		ActorRef.Say(LipSync)
	endIf
	GetSound(Strength, IsVictim).PlayAndWait(ActorRef)
endFunction

function SetVoice(ActorBase BaseRef)
	VoiceType Type = BaseRef.GetVoiceType()
	if !VoicesPlayer.HasForm(Type) && Type != SexLabVoiceM && Type != SexLabVoiceF
		if BaseRef.GetSex() == 1
			BaseRef.SetVoiceType(SexLabVoiceF)
		else
			BaseRef.SetVoiceType(SexLabVoiceM)
		endIf
	endIf
endFunction

Sound function GetSound(int Strength, bool IsVictim = false)
	if IsVictim
		return Medium
	elseIf Strength > 75
		return Hot
	endIf
	return Mild
endFunction

bool function GenderUsed(int CheckGender)
	return Gender == CheckGender || (Gender == -1 && (CheckGender == 1 || CheckGender == 0))
endFunction

function Initialize()
	Gender = -1
	Mild = none
	Medium = none
	Hot = none
	sslThreadLibrary Lib = Quest.GetQuest("SexLabQuestFramework") as sslThreadLibrary
	LipSync = Lib.LipSync
	VoicesPlayer = Lib.VoicesPlayer
	SexLabVoiceM = Lib.SexLabVoiceM
	SexLabVoiceF = Lib.SexLabVoiceF
	parent.Initialize()
endFunction
