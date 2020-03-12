scriptname sslBaseVoice extends sslBaseObject

Sound property Hot auto
Sound property Mild auto
Sound property Medium auto

; Sound[] property HotPack
; Sound[] property MildPack
; Sound[] property VictimPack

Topic property LipSync auto hidden

string[] property RaceKeys auto hidden

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
bool property Creature hidden
	bool function get()
		return RaceKeys && RaceKeys.Length > 0
	endFunction
endProperty

function PlayMoan(Actor ActorRef, int Strength = 30, bool IsVictim = false, bool UseLipSync = false)
	Sound SoundRef = GetSound(Strength, IsVictim)
	if SoundRef
		if !UseLipSync
			SoundRef.Play(ActorRef)
			Utility.WaitMenuMode(0.4)
		else
			bool HasMFG = Config.HasMFGFix
			float SavedP = sslBaseExpression.GetPhoneme(ActorRef, 1)
			if HasMFG
				MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, 1, 20)
			else
				ActorRef.SetExpressionPhoneme(1, 0.2)
			endIf
			Utility.WaitMenuMode(0.1)
			SoundRef.Play(ActorRef)
			TransitUp(ActorRef, 20, 50)
			Utility.WaitMenuMode(0.2)
			TransitDown(ActorRef, 50, 20)
			Utility.WaitMenuMode(0.1)
			if HasMFG
				MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, 1, (SavedP*100) as int)
			else
				ActorRef.SetExpressionPhoneme(1, Saved as float)
			endIf

		endIf
	endIf
endFunction

function Moan(Actor ActorRef, int Strength = 30, bool IsVictim = false)
	PlayMoan(ActorRef, Strength, Isvictim, Config.UseLipSync)
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

function TransitUp(Actor ActorRef, int from, int to)
	if Config.HasMFGFix
		while from < to
			from += 2
			MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, 1, from) ; OLDRIM
		endWhile
	else
		while from < to
			from += 2
			ActorRef.SetExpressionPhoneme(1, (from as float / 100.0))
		endWhile
	endIf
endFunction

function TransitDown(Actor ActorRef, int from, int to)
	if Config.HasMFGFix
		while from > to
			from -= 2
			MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, 1, from) ; OLDRIM
		endWhile
	else
		while from > to
			from -= 2
			ActorRef.SetExpressionPhoneme(1, (from as float / 100.0)) ; SKYRIM SE
		endWhile
	endIf	
endFunction

bool function CheckGender(int CheckGender)
	return Gender == CheckGender || (Gender == -1 && (CheckGender == 1 || CheckGender == 0)) || (CheckGender >= 2 && Gender >= 2)
endFunction

function SetRaceKeys(string RaceList)
	string[] KeyList = PapyrusUtil.StringSplit(RaceList)
	int i = KeyList.Length
	while i
		i -= 1
		if KeyList[i]
			AddRaceKey(KeyList[i])
		endIf
	endWhile
endFunction
function AddRaceKey(string RaceKey)
	if !RaceKey
		; Do nothing
	elseIf !RaceKeys || !RaceKeys.Length
		RaceKeys = new string[1]
		RaceKeys[0] = RaceKey
	elseIf RaceKeys.Find(RaceKey) == -1
		RaceKeys = PapyrusUtil.PushString(RaceKeys, RaceKey)
	endIf
endFunction
bool function HasRaceKey(string RaceKey)
	return RaceKey && RaceKeys && RaceKeys.Find(RaceKey) != -1
endFunction
bool function HasRaceKeyMatch(string[] RaceList)
	if RaceList && RaceKeys
		int i = RaceList.Length
		while i
			i -= 1
			if RaceKeys.Find(RaceList[i]) != -1
				return true
			endIf
		endWhile
	endIf
	return false
endFunction

function Save(int id = -1)
	AddTagConditional("Male",   (Gender == 0 || Gender == -1))
	AddTagConditional("Female", (Gender == 1 || Gender == -1))
	AddTagConditional("Creature", (Gender == 2 || Gender == 3))
	Log(Name, "Voices["+id+"]")
	parent.Save(id)
endFunction

function Initialize()
	Gender  = -1
	Mild    = none
	Medium  = none
	Hot     = none
	RaceKeys = Utility.CreateStringArray(0)
	parent.Initialize()
	LipSync = Config.LipSync
endFunction

