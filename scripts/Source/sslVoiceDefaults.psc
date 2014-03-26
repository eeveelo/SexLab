scriptname sslVoiceDefaults extends sslVoiceFactory

function LoadVoices()
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
function FemaleClassic(int id)
	sslBaseVoice Base = Create(id)

	Base.Name = "Classic (Female)"
	Base.Gender = Female

	Base.Mild = SexLabVoiceFemale01Mild
	Base.Medium = SexLabVoiceFemale01Medium
	Base.Hot = SexLabVoiceFemale01Hot

	Base.AddTag("Female")
	Base.AddTag("Classic")
	Base.AddTag("Normal")

	Base.Save(id)
endFunction

Sound property SexLabVoiceFemale02Mild auto
Sound property SexLabVoiceFemale02Medium auto
Sound property SexLabVoiceFemale02Hot auto
function FemaleBreathy(int id)
	sslBaseVoice Base = Create(id)

	Base.Name = "Breathy (Female)"
	Base.Gender = Female

	Base.Mild = SexLabVoiceFemale02Mild
	Base.Medium = SexLabVoiceFemale02Medium
	Base.Hot = SexLabVoiceFemale02Hot

	Base.AddTag("Female")
	Base.AddTag("Breathy")
	Base.AddTag("Loud")
	Base.AddTag("Rough")

	Base.Save(id)
endFunction

Sound property SexLabVoiceFemale03Mild auto
Sound property SexLabVoiceFemale03Medium auto
Sound property SexLabVoiceFemale03Hot auto
function FemaleYoung(int id)
	sslBaseVoice Base = Create(id)

	Base.Name = "Young (Female)"
	Base.Gender = Female

	Base.Mild = SexLabVoiceFemale03Mild
	Base.Medium = SexLabVoiceFemale03Medium
	Base.Hot = SexLabVoiceFemale03Hot

	Base.AddTag("Female")
	Base.AddTag("Young")
	Base.AddTag("Loud")

	Base.Save(id)
endFunction

Sound property SexLabVoiceFemale04Mild auto
Sound property SexLabVoiceFemale04Medium auto
Sound property SexLabVoiceFemale04Hot auto
function FemaleStimulated(int id)
	sslBaseVoice Base = Create(id)

	Base.Name = "Stimulated (Female)"
	Base.Gender = Female

	Base.Mild = SexLabVoiceFemale04Mild
	Base.Medium = SexLabVoiceFemale04Medium
	Base.Hot = SexLabVoiceFemale04Hot

	Base.AddTag("Female")
	Base.AddTag("Stimulated")
	Base.AddTag("Loud")
	Base.AddTag("Excited")

	Base.Save(id)
endFunction

Sound property SexLabVoiceFemale05Mild auto
Sound property SexLabVoiceFemale05Medium auto
Sound property SexLabVoiceFemale05Hot auto
function FemaleQuiet(int id)
	sslBaseVoice Base = Create(id)

	Base.Name = "Quiet (Female)"
	Base.Gender = Female

	Base.Mild = SexLabVoiceFemale05Mild
	Base.Medium = SexLabVoiceFemale05Medium
	Base.Hot = SexLabVoiceFemale05Hot

	Base.AddTag("Female")
	Base.AddTag("Quiet")
	Base.AddTag("Timid")

	Base.Save(id)
endFunction

Sound property SexLabVoiceFemale06Mild auto
Sound property SexLabVoiceFemale06Medium auto
Sound property SexLabVoiceFemale06Hot auto
function FemaleExcitable(int id)
	sslBaseVoice Base = Create(id)

	Base.Name = "Excitable (Female)"
	Base.Gender = Female

	Base.Mild = SexLabVoiceFemale06Mild
	Base.Medium = SexLabVoiceFemale06Medium
	Base.Hot = SexLabVoiceFemale06Hot

	Base.AddTag("Female")
	Base.AddTag("Excitable")
	Base.AddTag("Excited")
	Base.AddTag("Loud")

	Base.Save(id)
endFunction

Sound property SexLabVoiceFemale07Mild auto
Sound property SexLabVoiceFemale07Medium auto
Sound property SexLabVoiceFemale07Hot auto
function FemaleAverage(int id)
	sslBaseVoice Base = Create(id)

	Base.Name = "Average (Female)"
	Base.Gender = Female

	Base.Mild = SexLabVoiceFemale07Mild
	Base.Medium = SexLabVoiceFemale07Medium
	Base.Hot = SexLabVoiceFemale07Hot

	Base.AddTag("Female")
	Base.AddTag("Average")
	Base.AddTag("Normal")
	Base.AddTag("Harsh")

	Base.Save(id)
endFunction

Sound property SexLabVoiceFemale08Mild auto
Sound property SexLabVoiceFemale08Medium auto
Sound property SexLabVoiceFemale08Hot auto
function FemaleMature(int id)
	sslBaseVoice Base = Create(id)

	Base.Name = "Mature (Female)"
	Base.Gender = Female

	Base.Mild = SexLabVoiceFemale08Mild
	Base.Medium = SexLabVoiceFemale08Medium
	Base.Hot = SexLabVoiceFemale08Hot

	Base.AddTag("Female")
	Base.AddTag("Mature")
	Base.AddTag("Old")
	Base.AddTag("Harsh")
	Base.AddTag("Rough")

	Base.Save(id)
endFunction

Sound property SexLabVoiceMale01Mild auto
Sound property SexLabVoiceMale01Medium auto
Sound property SexLabVoiceMale01Hot auto
function MaleNeutral(int id)
	sslBaseVoice Base = Create(id)

	Base.Name = "Neutral (Male)"
	Base.Gender = Male

	Base.Mild = SexLabVoiceMale01Mild
	Base.Medium = SexLabVoiceMale01Medium
	Base.Hot = SexLabVoiceMale01Hot

	Base.AddTag("Male")
	Base.AddTag("Neutral")
	Base.AddTag("Quiet")
	Base.AddTag("Normal")

	Base.Save(id)
endFunction

Sound property SexLabVoiceMale02Mild auto
Sound property SexLabVoiceMale02Medium auto
Sound property SexLabVoiceMale02Hot auto
function MaleCalm(int id)
	sslBaseVoice Base = Create(id)

	Base.Name = "Calm (Male)"
	Base.Gender = Male

	Base.Mild = SexLabVoiceMale02Mild
	Base.Medium = SexLabVoiceMale02Medium
	Base.Hot = SexLabVoiceMale02Hot

	Base.AddTag("Male")
	Base.AddTag("Calm")
	Base.AddTag("Quiet")

	Base.Save(id)
endFunction

Sound property SexLabVoiceMale03Mild auto
Sound property SexLabVoiceMale03Medium auto
Sound property SexLabVoiceMale03Hot auto
function MaleRough(int id)
	sslBaseVoice Base = Create(id)

	Base.Name = "Rough (Male)"
	Base.Gender = Male

	Base.Mild = SexLabVoiceMale03Mild
	Base.Medium = SexLabVoiceMale03Medium
	Base.Hot = SexLabVoiceMale03Hot

	Base.AddTag("Male")
	Base.AddTag("Rough")
	Base.AddTag("Harsh")
	Base.AddTag("Loud")
	Base.AddTag("Old")

	Base.Save(id)
endFunction

Sound property SexLabVoiceMale04Mild auto
Sound property SexLabVoiceMale04Medium auto
Sound property SexLabVoiceMale04Hot auto
function MaleAverage(int id)
	sslBaseVoice Base = Create(id)

	Base.Name = "Average (Male)"
	Base.Gender = Male

	Base.Mild = SexLabVoiceMale04Mild
	Base.Medium = SexLabVoiceMale04Medium
	Base.Hot = SexLabVoiceMale04Hot

	Base.AddTag("Male")
	Base.AddTag("Average")
	Base.AddTag("Normal")
	Base.AddTag("Quiet")

	Base.Save(id)
endFunction
