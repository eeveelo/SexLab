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

function MoveLips(Actor ActorRef, Sound SoundRef = none, float Strength = 1.0) global
	if !ActorRef
		return
	endIf
	
	sslSystemConfig Conf = SexLabUtil.GetConfig()
	MoveLipsEx(ActorRef, SoundRef, Strength, Conf.LipsSoundTime, Conf.LipsMoveTime, Conf.LipsPhoneme, Conf.LipsMinValue, Conf.LipsMaxValue, Conf.LipsFixedValue, Conf.HasMFGFix)
endFunction

function MoveLipsEx(Actor ActorRef, Sound SoundRef = none, float Strength = 1.0, int SoundCut = 0, float MoveTime = 0.2, int Phoneme = 1, int MinValue = 20, int MaxValue = 50, bool IsFixedValue = false, bool UseMFG = false) global
	if !ActorRef
		return
	endIf
	
	float SavedP
	int p = Phoneme
	if p < 0 || p > 15
		p = 0
		float[] Phonemes = new float[32]
		int i
		; Get Phonemes
		while i <= 15
			Phonemes[i] = sslBaseExpression.GetPhoneme(ActorRef, i) ; 0.0 - 1.0
			if Phonemes[i] >= Phonemes[p] ; seems to be required to prevet issues
				p = i
			endIf
			i += 1
		endWhile
		SavedP = Phonemes[p]
	else
		SavedP = sslBaseExpression.GetPhoneme(ActorRef, p)
	endIf
	int MinP = MinValue
	int MaxP = MaxValue
	if !IsFixedValue
		float ReferenceP = SavedP
		if ReferenceP > (1.0 - (0.2 * Strength))
			ReferenceP = (1.0 - (0.2 * Strength))
		endIf
		MinP = ((ReferenceP * 100) - (MinP * Strength)) as int
		MaxP = ((ReferenceP * 100) + (MaxP * Strength)) as int
	endIf
	if MinP < 0
		MinP = 0
	elseIf MinP > 90
		MinP = 90
	endIf
	if (MaxP - MinP) < 10
		MaxP = MinP + 10
	endIf
;	if ((SavedP * 100) - MinP) > 2
;		TransitDown(ActorRef, (SavedP * 100) as int, MinP)
;	endIf
	if UseMFG
		MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, p, MinP)
	else
		ActorRef.SetExpressionPhoneme(p, (MinP as float)*0.01)
	endIf
	Utility.Wait(0.1)
	int Instance = -1
	if SoundCut != -1 && SoundRef != none
		Instance = SoundRef.Play(ActorRef)
	endIf
;	TransitUp(ActorRef, MinP, MaxP)
	if UseMFG
		MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, p, MaxP)
	else
		ActorRef.SetExpressionPhoneme(p, (MaxP as float)*0.01)
	endIf
	if SoundCut == -1 && SoundRef != none
		SoundRef.PlayAndWait(ActorRef)
	else
		Utility.Wait(MoveTime)
	endIf
;	if (MaxP - (SavedP * 100)) > 2
;		TransitDown(ActorRef, MaxP, (SavedP * 100) as int)
;	endIf
;	Utility.Wait(0.1)
	if UseMFG
		MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, p, (SavedP*100) as int)
	else
		ActorRef.SetExpressionPhoneme(p, SavedP as float)
	endIf
	if SoundCut == 1 && Instance != -1
		Sound.StopInstance(Instance)
	endIf
	Utility.Wait(0.2)
;	Debug.Trace("SEXLAB - MoveLipsEx("+ActorRef+", "+SoundRef+", "+Strength+") -- SavedP:"+SavedP+", MinP:"+MinP+", MaxP:"+MaxP)
endFunction

function PlayMoan(Actor ActorRef, int Strength = 30, bool IsVictim = false, bool UseLipSync = false)
	PlayMoanEx(ActorRef, Strength, IsVictim, UseLipSync, Config.LipsSoundTime, Config.LipsMoveTime, Config.LipsPhoneme, Config.LipsMinValue, Config.LipsMaxValue, Config.LipsFixedValue, Config.HasMFGFix)
endFunction

function PlayMoanEx(Actor ActorRef, int Strength = 30, bool IsVictim = false, bool UseLipSync = false, int SoundCut = 0, float MoveTime = 0.2, int Phoneme = 1, int MinValue = 20, int MaxValue = 50, bool IsFixedValue = false, bool UseMFG = false)
	if !ActorRef
		return
	endIf
	
	Sound SoundRef = GetSound(Strength, IsVictim)
	if !UseLipSync
		if SoundRef
			SoundRef.Play(ActorRef)
			Utility.WaitMenuMode(0.4)
		endIf
	else
		MoveLipsEx(ActorRef, SoundRef, (Strength as float / 100.0), SoundCut, MoveTime, Phoneme, MinValue, MaxValue, IsFixedValue, UseMFG)
	endIf
endFunction

function Moan(Actor ActorRef, int Strength = 30, bool IsVictim = false) ;DEPRECATED
	if !ActorRef
		return
	endIf
	
	ActorBase BaseRef = ActorRef.GetLeveledActorBase()
	bool UseLipSync = Config.UseLipSync && BaseRef && !sslCreatureAnimationSlots.HasRaceType(BaseRef.GetRace())
	; Use the values of the version 1.62 for compatibility reasons
	PlayMoanEx(ActorRef, Strength, IsVictim, UseLipSync, 0, 0.2, 1, 20, 50, false, Config.HasMFGFix)
endFunction

function MoanNoWait(Actor ActorRef, int Strength = 30, bool IsVictim = false, float Volume = 1.0) ;DEPRECATED
	if !ActorRef
		return
	endIf
	
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
	if !ActorRef
		return
	endIf
	
	if (ForceUse || Config.UseLipSync) && Game.GetCameraState() != 3
		ActorRef.Say(LipSync)
	endIf
endFunction

function TransitUp(Actor ActorRef, int from, int to) global
	if !ActorRef
		return
	endIf

	int value = from
	bool HasMFG = SexLabUtil.GetConfig().HasMFGFix
	if HasMFG
		MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, 1, from) ; OLDRIM
		Utility.Wait(0.1)
		while value < (to + 4)
			value += 4
			MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, 1, from) ; OLDRIM
			Utility.Wait(0.02)
		endWhile
		MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, 1, to) ; OLDRIM
	else
		ActorRef.SetExpressionPhoneme(1, (from as float / 100.0))
		Utility.Wait(0.1)
		while value < (to + 4)
			value += 4
			ActorRef.SetExpressionPhoneme(1, (value as float / 100.0))
			Utility.Wait(0.02)
		endWhile
		ActorRef.SetExpressionPhoneme(1, (to as float / 100.0))
	endIf
endFunction

function TransitDown(Actor ActorRef, int from, int to) global
	if !ActorRef
		return
	endIf

	int value = from
	bool HasMFG = SexLabUtil.GetConfig().HasMFGFix
	if HasMFG
		MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, 1, from) ; OLDRIM
		Utility.Wait(0.1)
		while value > (to - 4)
			value -= 4
			MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, 1, value) ; OLDRIM
			Utility.Wait(0.02)
		endWhile
		MfgConsoleFunc.SetPhonemeModifier(ActorRef, 0, 1, to) ; OLDRIM
	else
		ActorRef.SetExpressionPhoneme(1, (from as float / 100.0)) ; SKYRIM SE
		Utility.Wait(0.1)
		while value > (to - 4)
			value -= 4
			ActorRef.SetExpressionPhoneme(1, (value as float / 100.0)) ; SKYRIM SE
			Utility.Wait(0.02)
		endWhile
		ActorRef.SetExpressionPhoneme(1, (to as float / 100.0)) ; SKYRIM SE
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

