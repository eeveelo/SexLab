scriptname sslVoiceDefaults extends sslVoiceFactory

function LoadVoices()
	RegisterVoice("FemaleClassic")
	RegisterVoice("FemaleBreathy")
	RegisterVoice("FemaleYoung")
	RegisterVoice("FemaleStimulated")
	RegisterVoice("FemaleQuiet")
	RegisterVoice("FemaleExcitable")
	RegisterVoice("FemaleAverage")
	RegisterVoice("FemaleMature")
	RegisterVoice("MaleNeutral")
	RegisterVoice("MaleCalm")
	RegisterVoice("MaleRough")
	RegisterVoice("MaleAverage")
endFunction

Sound property SexLabvFemale01MildM auto
Sound property SexLabvFemale01MediumM auto
Sound property SexLabvFemale01HotM auto
function FemaleClassic(string eventName, string id, float argNum, form sender)
	Name = "Classic (Female)"
	Gender = Female
	Mild = SexLabvFemale01MildM
	Medium = SexLabvFemale01MediumM
	Hot = SexLabvFemale01HotM
	AddTag("Female")
	AddTag("Classic")
	AddTag("Normal")
	Save()
endFunction

Sound property SexLabvFemale02MildM auto
Sound property SexLabvFemale02MediumM auto
Sound property SexLabvFemale02HotM auto
function FemaleBreathy(string eventName, string id, float argNum, form sender)
	Name = "Breathy (Female)"
	Gender = Female
	Mild = SexLabvFemale02MildM
	Medium = SexLabvFemale02MediumM
	Hot = SexLabvFemale02HotM
	AddTag("Female")
	AddTag("Breathy")
	AddTag("Loud")
	AddTag("Rough")
	Save()
endFunction

Sound property SexLabvFemale03MildM auto
Sound property SexLabvFemale03MediumM auto
Sound property SexLabvFemale03HotM auto
function FemaleYoung(string eventName, string id, float argNum, form sender)
	Name = "Young (Female)"
	Gender = Female
	Mild = SexLabvFemale03MildM
	Medium = SexLabvFemale03MediumM
	Hot = SexLabvFemale03HotM
	AddTag("Female")
	AddTag("Young")
	AddTag("Loud")
	Save()
endFunction

Sound property SexLabvFemale04MildM auto
Sound property SexLabvFemale04MediumM auto
Sound property SexLabvFemale04HotM auto
function FemaleStimulated(string eventName, string id, float argNum, form sender)
	Name = "Stimulated (Female)"
	Gender = Female
	Mild = SexLabvFemale04MildM
	Medium = SexLabvFemale04MediumM
	Hot = SexLabvFemale04HotM
	AddTag("Female")
	AddTag("Stimulated")
	AddTag("Loud")
	AddTag("Excited")
	Save()
endFunction

Sound property SexLabvFemale05MildM auto
Sound property SexLabvFemale05MediumM auto
Sound property SexLabvFemale05HotM auto
function FemaleQuiet(string eventName, string id, float argNum, form sender)
	Name = "Quiet (Female)"
	Gender = Female
	Mild = SexLabvFemale05MildM
	Medium = SexLabvFemale05MediumM
	Hot = SexLabvFemale05HotM
	AddTag("Female")
	AddTag("Quiet")
	AddTag("Timid")
	Save()
endFunction

Sound property SexLabvFemale06MildM auto
Sound property SexLabvFemale06MediumM auto
Sound property SexLabvFemale06HotM auto
function FemaleExcitable(string eventName, string id, float argNum, form sender)
	Name = "Excitable (Female)"
	Gender = Female
	Mild = SexLabvFemale06MildM
	Medium = SexLabvFemale06MediumM
	Hot = SexLabvFemale06HotM
	AddTag("Female")
	AddTag("Excitable")
	AddTag("Excited")
	AddTag("Loud")
	Save()
endFunction

Sound property SexLabvFemale07MildM auto
Sound property SexLabvFemale07MediumM auto
Sound property SexLabvFemale07HotM auto
function FemaleAverage(string eventName, string id, float argNum, form sender)
	Name = "Average (Female)"
	Gender = Female
	Mild = SexLabvFemale07MildM
	Medium = SexLabvFemale07MediumM
	Hot = SexLabvFemale07HotM
	AddTag("Female")
	AddTag("Average")
	AddTag("Normal")
	AddTag("Harsh")
	Save()
endFunction

Sound property SexLabvFemale08MildM auto
Sound property SexLabvFemale08MediumM auto
Sound property SexLabvFemale08HotM auto
function FemaleMature(string eventName, string id, float argNum, form sender)
	Name = "Mature (Female)"
	Gender = Female
	Mild = SexLabvFemale08MildM
	Medium = SexLabvFemale08MediumM
	Hot = SexLabvFemale08HotM
	AddTag("Female")
	AddTag("Mature")
	AddTag("Old")
	AddTag("Harsh")
	AddTag("Rough")
	Save()
endFunction

Sound property SexLabvMale01MildM auto
Sound property SexLabvMale01MediumM auto
Sound property SexLabvMale01HotM auto
function MaleNeutral(string eventName, string id, float argNum, form sender)
	Name = "Neutral (Male)"
	Gender = Male
	Mild = SexLabvMale01MildM
	Medium = SexLabvMale01MediumM
	Hot = SexLabvMale01HotM
	AddTag("Male")
	AddTag("Neutral")
	AddTag("Quiet")
	AddTag("Normal")
	Save()
endFunction

Sound property SexLabvMale02MildM auto
Sound property SexLabvMale02MediumM auto
Sound property SexLabvMale02HotM auto
function MaleCalm(string eventName, string id, float argNum, form sender)
	Name = "Calm (Male)"
	Gender = Male
	Mild = SexLabvMale02MildM
	Medium = SexLabvMale02MediumM
	Hot = SexLabvMale02HotM
	AddTag("Male")
	AddTag("Calm")
	AddTag("Quiet")
	Save()
endFunction

Sound property SexLabvMale03MildM auto
Sound property SexLabvMale03MediumM auto
Sound property SexLabvMale03HotM auto
function MaleRough(string eventName, string id, float argNum, form sender)
	Name = "Rough (Male)"
	Gender = Male
	Mild = SexLabvMale03MildM
	Medium = SexLabvMale03MediumM
	Hot = SexLabvMale03HotM
	AddTag("Male")
	AddTag("Rough")
	AddTag("Harsh")
	AddTag("Loud")
	AddTag("Old")
	Save()
endFunction

Sound property SexLabvMale04MildM auto
Sound property SexLabvMale04MediumM auto
Sound property SexLabvMale04HotM auto
function MaleAverage(string eventName, string id, float argNum, form sender)
	Name = "Average (Male)"
	Gender = Male
	Mild = SexLabvMale04MildM
	Medium = SexLabvMale04MediumM
	Hot = SexLabvMale04HotM
	AddTag("Male")
	AddTag("Average")
	AddTag("Normal")
	AddTag("Quiet")
	Save()
endFunction