scriptname sslVoiceDefaults extends sslVoiceFactory

function LoadVoices()
	; Prepare factory resources
	PrepareFactory()
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

function FemaleClassic(int id)
	sslBaseVoice Base = Create(id)

	Base.Name = "Classic (Female)"
	Base.Gender = Female

	Base.Mild = Game.GetFormFromFile(0x67548, "SexLab.esm") as Sound
	Base.Medium = Game.GetFormFromFile(0x67547, "SexLab.esm") as Sound
	Base.Hot = Game.GetFormFromFile(0x67546, "SexLab.esm") as Sound

	Base.AddTag("Female")
	Base.AddTag("Classic")
	Base.AddTag("Normal")

	Base.Save(id)
endFunction

function FemaleBreathy(int id)
	sslBaseVoice Base = Create(id)

	Base.Name = "Breathy (Female)"
	Base.Gender = Female

	Base.Mild = Game.GetFormFromFile(0x6754B, "SexLab.esm") as Sound
	Base.Medium = Game.GetFormFromFile(0x6754A, "SexLab.esm") as Sound
	Base.Hot = Game.GetFormFromFile(0x67549, "SexLab.esm") as Sound

	Base.AddTag("Female")
	Base.AddTag("Breathy")
	Base.AddTag("Loud")
	Base.AddTag("Rough")

	Base.Save(id)
endFunction

function FemaleYoung(int id)
	sslBaseVoice Base = Create(id)

	Base.Name = "Young (Female)"
	Base.Gender = Female

	Base.Mild = Game.GetFormFromFile(0x6754E, "SexLab.esm") as Sound
	Base.Medium = Game.GetFormFromFile(0x6754D, "SexLab.esm") as Sound
	Base.Hot = Game.GetFormFromFile(0x6754C, "SexLab.esm") as Sound

	Base.AddTag("Female")
	Base.AddTag("Young")
	Base.AddTag("Loud")

	Base.Save(id)
endFunction

function FemaleStimulated(int id)
	sslBaseVoice Base = Create(id)

	Base.Name = "Stimulated (Female)"
	Base.Gender = Female

	Base.Mild = Game.GetFormFromFile(0x67551, "SexLab.esm") as Sound
	Base.Medium = Game.GetFormFromFile(0x67550, "SexLab.esm") as Sound
	Base.Hot = Game.GetFormFromFile(0x6754F, "SexLab.esm") as Sound

	Base.AddTag("Female")
	Base.AddTag("Stimulated")
	Base.AddTag("Loud")
	Base.AddTag("Excited")

	Base.Save(id)
endFunction

function FemaleQuiet(int id)
	sslBaseVoice Base = Create(id)

	Base.Name = "Quiet (Female)"
	Base.Gender = Female

	Base.Mild = Game.GetFormFromFile(0x67554, "SexLab.esm") as Sound
	Base.Medium = Game.GetFormFromFile(0x67553, "SexLab.esm") as Sound
	Base.Hot = Game.GetFormFromFile(0x67552, "SexLab.esm") as Sound

	Base.AddTag("Female")
	Base.AddTag("Quiet")
	Base.AddTag("Timid")

	Base.Save(id)
endFunction

function FemaleExcitable(int id)
	sslBaseVoice Base = Create(id)

	Base.Name = "Excitable (Female)"
	Base.Gender = Female

	Base.Mild = Game.GetFormFromFile(0x67557, "SexLab.esm") as Sound
	Base.Medium = Game.GetFormFromFile(0x67556, "SexLab.esm") as Sound
	Base.Hot = Game.GetFormFromFile(0x67555, "SexLab.esm") as Sound


	Base.AddTag("Female")
	Base.AddTag("Excitable")
	Base.AddTag("Excited")
	Base.AddTag("Loud")

	Base.Save(id)
endFunction

function FemaleAverage(int id)
	sslBaseVoice Base = Create(id)

	Base.Name = "Average (Female)"
	Base.Gender = Female

	Base.Mild = Game.GetFormFromFile(0x6755A, "SexLab.esm") as Sound
	Base.Medium = Game.GetFormFromFile(0x67559, "SexLab.esm") as Sound
	Base.Hot = Game.GetFormFromFile(0x67558, "SexLab.esm") as Sound

	Base.AddTag("Female")
	Base.AddTag("Average")
	Base.AddTag("Normal")
	Base.AddTag("Harsh")

	Base.Save(id)
endFunction

function FemaleMature(int id)
	sslBaseVoice Base = Create(id)

	Base.Name = "Mature (Female)"
	Base.Gender = Female

	Base.Mild = Game.GetFormFromFile(0x6755D, "SexLab.esm") as Sound
	Base.Medium = Game.GetFormFromFile(0x6755C, "SexLab.esm") as Sound
	Base.Hot = Game.GetFormFromFile(0x6755B, "SexLab.esm") as Sound

	Base.AddTag("Female")
	Base.AddTag("Mature")
	Base.AddTag("Old")
	Base.AddTag("Harsh")
	Base.AddTag("Rough")

	Base.Save(id)
endFunction

function MaleNeutral(int id)
	sslBaseVoice Base = Create(id)

	Base.Name = "Neutral (Male)"
	Base.Gender = Male

	Base.Mild = Game.GetFormFromFile(0x67560, "SexLab.esm") as Sound
	Base.Medium = Game.GetFormFromFile(0x6755F, "SexLab.esm") as Sound
	Base.Hot = Game.GetFormFromFile(0x6755E, "SexLab.esm") as Sound

	Base.AddTag("Male")
	Base.AddTag("Neutral")
	Base.AddTag("Quiet")
	Base.AddTag("Normal")

	Base.Save(id)
endFunction

function MaleCalm(int id)
	sslBaseVoice Base = Create(id)

	Base.Name = "Calm (Male)"
	Base.Gender = Male

	Base.Mild = Game.GetFormFromFile(0x67563, "SexLab.esm") as Sound
	Base.Medium = Game.GetFormFromFile(0x67562, "SexLab.esm") as Sound
	Base.Hot = Game.GetFormFromFile(0x67561, "SexLab.esm") as Sound

	Base.AddTag("Male")
	Base.AddTag("Calm")
	Base.AddTag("Quiet")

	Base.Save(id)
endFunction

function MaleRough(int id)
	sslBaseVoice Base = Create(id)

	Base.Name = "Rough (Male)"
	Base.Gender = Male

	Base.Mild = Game.GetFormFromFile(0x67566, "SexLab.esm") as Sound
	Base.Medium = Game.GetFormFromFile(0x67565, "SexLab.esm") as Sound
	Base.Hot = Game.GetFormFromFile(0x67564, "SexLab.esm") as Sound

	Base.AddTag("Male")
	Base.AddTag("Rough")
	Base.AddTag("Harsh")
	Base.AddTag("Loud")
	Base.AddTag("Old")

	Base.Save(id)
endFunction

function MaleAverage(int id)
	sslBaseVoice Base = Create(id)

	Base.Name = "Average (Male)"
	Base.Gender = Male

	Base.Mild = Game.GetFormFromFile(0x67569, "SexLab.esm") as Sound
	Base.Medium = Game.GetFormFromFile(0x67568, "SexLab.esm") as Sound
	Base.Hot = Game.GetFormFromFile(0x67567, "SexLab.esm") as Sound

	Base.AddTag("Male")
	Base.AddTag("Average")
	Base.AddTag("Normal")
	Base.AddTag("Quiet")

	Base.Save(id)
endFunction
