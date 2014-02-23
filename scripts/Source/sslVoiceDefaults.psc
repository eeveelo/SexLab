scriptname sslVoiceDefaults extends sslVoiceFactory

function LoadVoices()
	; Prepare factory for load
	Slots = (Quest.GetQuest("SexLabQuestRegistry") as sslVoiceSlots)
	FreeFactory()
	; Female voices
	RegisterVoice("FemaleClassic")
	RegisterVoice("FemaleBreathy")
	RegisterVoice("FemaleYoung")
	RegisterVoice("FemaleStimulated")
	RegisterVoice("FemaleQuiet")
	RegisterVoice("FemaleExcitable")
	RegisterVoice("FemaleAverage")
	RegisterVoice("FemaleMature")
	; Male voices
	RegisterVoice("MaleNeutral")
	RegisterVoice("MaleCalm")
	RegisterVoice("MaleRough")
	RegisterVoice("MaleAverage")
endFunction

Sound property SexLabVoiceFemale01Mild auto
Sound property SexLabVoiceFemale01Medium auto
Sound property SexLabVoiceFemale01Hot auto
function FemaleClassic()
	Name = "Classic (Female)"
	Gender = Female
	Mild = SexLabVoiceFemale01Mild
	Medium = SexLabVoiceFemale01Medium
	Hot = SexLabVoiceFemale01Hot
	AddTag("Female")
	AddTag("Classic")
	AddTag("Normal")
	Save()
endFunction

Sound property SexLabVoiceFemale02Mild auto
Sound property SexLabVoiceFemale02Medium auto
Sound property SexLabVoiceFemale02Hot auto
function FemaleBreathy()
	Name = "Breathy (Female)"
	Gender = Female
	Mild = SexLabVoiceFemale02Mild
	Medium = SexLabVoiceFemale02Medium
	Hot = SexLabVoiceFemale02Hot
	AddTag("Female")
	AddTag("Breathy")
	AddTag("Loud")
	AddTag("Rough")
	Save()
endFunction

Sound property SexLabVoiceFemale03Mild auto
Sound property SexLabVoiceFemale03Medium auto
Sound property SexLabVoiceFemale03Hot auto
function FemaleYoung()
	Name = "Young (Female)"
	Gender = Female
	Mild = SexLabVoiceFemale03Mild
	Medium = SexLabVoiceFemale03Medium
	Hot = SexLabVoiceFemale03Hot
	AddTag("Female")
	AddTag("Young")
	AddTag("Loud")
	Save()
endFunction

Sound property SexLabVoiceFemale04Mild auto
Sound property SexLabVoiceFemale04Medium auto
Sound property SexLabVoiceFemale04Hot auto
function FemaleStimulated()
	Name = "Stimulated (Female)"
	Gender = Female
	Mild = SexLabVoiceFemale04Mild
	Medium = SexLabVoiceFemale04Medium
	Hot = SexLabVoiceFemale04Hot
	AddTag("Female")
	AddTag("Stimulated")
	AddTag("Loud")
	AddTag("Excited")
	Save()
endFunction

Sound property SexLabVoiceFemale05Mild auto
Sound property SexLabVoiceFemale05Medium auto
Sound property SexLabVoiceFemale05Hot auto
function FemaleQuiet()
	Name = "Quiet (Female)"
	Gender = Female
	Mild = SexLabVoiceFemale05Mild
	Medium = SexLabVoiceFemale05Medium
	Hot = SexLabVoiceFemale05Hot
	AddTag("Female")
	AddTag("Quiet")
	AddTag("Timid")
	Save()
endFunction

Sound property SexLabVoiceFemale06Mild auto
Sound property SexLabVoiceFemale06Medium auto
Sound property SexLabVoiceFemale06Hot auto
function FemaleExcitable()
	Name = "Excitable (Female)"
	Gender = Female
	Mild = SexLabVoiceFemale06Mild
	Medium = SexLabVoiceFemale06Medium
	Hot = SexLabVoiceFemale06Hot
	AddTag("Female")
	AddTag("Excitable")
	AddTag("Excited")
	AddTag("Loud")
	Save()
endFunction

Sound property SexLabVoiceFemale07Mild auto
Sound property SexLabVoiceFemale07Medium auto
Sound property SexLabVoiceFemale07Hot auto
function FemaleAverage()
	Name = "Average (Female)"
	Gender = Female
	Mild = SexLabVoiceFemale07Mild
	Medium = SexLabVoiceFemale07Medium
	Hot = SexLabVoiceFemale07Hot
	AddTag("Female")
	AddTag("Average")
	AddTag("Normal")
	AddTag("Harsh")
	Save()
endFunction

Sound property SexLabVoiceFemale08Mild auto
Sound property SexLabVoiceFemale08Medium auto
Sound property SexLabVoiceFemale08Hot auto
function FemaleMature()
	Name = "Mature (Female)"
	Gender = Female
	Mild = SexLabVoiceFemale08Mild
	Medium = SexLabVoiceFemale08Medium
	Hot = SexLabVoiceFemale08Hot
	AddTag("Female")
	AddTag("Mature")
	AddTag("Old")
	AddTag("Harsh")
	AddTag("Rough")
	Save()
endFunction

Sound property SexLabVoiceMale01Mild auto
Sound property SexLabVoiceMale01Medium auto
Sound property SexLabVoiceMale01Hot auto
function MaleNeutral()
	Name = "Neutral (Male)"
	Gender = Male
	Mild = SexLabVoiceMale01Mild
	Medium = SexLabVoiceMale01Medium
	Hot = SexLabVoiceMale01Hot
	AddTag("Male")
	AddTag("Neutral")
	AddTag("Quiet")
	AddTag("Normal")
	Save()
endFunction

Sound property SexLabVoiceMale02Mild auto
Sound property SexLabVoiceMale02Medium auto
Sound property SexLabVoiceMale02Hot auto
function MaleCalm()
	Name = "Calm (Male)"
	Gender = Male
	Mild = SexLabVoiceMale02Mild
	Medium = SexLabVoiceMale02Medium
	Hot = SexLabVoiceMale02Hot
	AddTag("Male")
	AddTag("Calm")
	AddTag("Quiet")
	Save()
endFunction

Sound property SexLabVoiceMale03Mild auto
Sound property SexLabVoiceMale03Medium auto
Sound property SexLabVoiceMale03Hot auto
function MaleRough()
	Name = "Rough (Male)"
	Gender = Male
	Mild = SexLabVoiceMale03Mild
	Medium = SexLabVoiceMale03Medium
	Hot = SexLabVoiceMale03Hot
	AddTag("Male")
	AddTag("Rough")
	AddTag("Harsh")
	AddTag("Loud")
	AddTag("Old")
	Save()
endFunction

Sound property SexLabVoiceMale04Mild auto
Sound property SexLabVoiceMale04Medium auto
Sound property SexLabVoiceMale04Hot auto
function MaleAverage()
	Name = "Average (Male)"
	Gender = Male
	Mild = SexLabVoiceMale04Mild
	Medium = SexLabVoiceMale04Medium
	Hot = SexLabVoiceMale04Hot
	AddTag("Male")
	AddTag("Average")
	AddTag("Normal")
	AddTag("Quiet")
	Save()
endFunction
