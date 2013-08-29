scriptname sslAnimationDefaults extends sslAnimationFactory

function LoadAnimations()
	Debug.TraceAndbox("Loading Animations")

	Register("ArrokOral")
	Register("ArrokAnal")
endFunction


function ArrokOral(string eventName, string id, float argNum, form sender)
	Animation.Name = "Arrok 69"

	Animation.SetContent(Sexual)
	Animation.SetSFX(Sucking)

	int a1 = Animation.AddPosition(Female, addCum=Oral)
	Animation.AddPositionStage(a1, "Arrok_Oral_A1_S1", 0)
	Animation.AddPositionStage(a1, "Arrok_Oral_A1_S2", 0)
	Animation.AddPositionStage(a1, "Arrok_Oral_A1_S3", 0, silent = true, openMouth = true)
	Animation.AddPositionStage(a1, "Arrok_Oral_A1_S3", 0, silent = true, openMouth = true)
	Animation.AddPositionStage(a1, "Arrok_Oral_A1_S4", 0)

	int a2 = Animation.AddPosition(Male)
	Animation.AddPositionStage(a2, "Arrok_Oral_A2_S1", 46, rotate = 180, silent = true, openMouth = true)
	Animation.AddPositionStage(a2, "Arrok_Oral_A2_S1", 46, rotate = 180, silent = true, openMouth = true)
	Animation.AddPositionStage(a2, "Arrok_Oral_A2_S2", 46, rotate = 180, silent = true, openMouth = true)
	Animation.AddPositionStage(a2, "Arrok_Oral_A2_S3", 46, rotate = 180, silent = true, openMouth = true)
	Animation.AddPositionStage(a2, "Arrok_Oral_A2_S3", 46, rotate = 180, silent = true, openMouth = true)

	Animation.AddTag("Arrok")
	Animation.AddTag("BBP")
	Animation.AddTag("Sex")
	Animation.AddTag("MF")
	Animation.AddTag("Oral")
	Animation.AddTag("Cunnilingus")
	Animation.AddTag("Blowjob")
	Animation.AddTag("69")

	Save()
endFunction

function ArrokAnal(string eventName, string id, float argNum, form sender)
	Animation.name = "Arrok Anal"

	Animation.SetContent(Sexual)
	Animation.SetSFX(Squishing)

	int a1 = Animation.AddPosition(Female, addCum=Anal)
	Animation.AddPositionStage(a1, "Arrok_Anal_A1_S1", 0)
	Animation.AddPositionStage(a1, "Arrok_Anal_A1_S2", 0)
	Animation.AddPositionStage(a1, "Arrok_Anal_A1_S3", 0)
	Animation.AddPositionStage(a1, "Arrok_Anal_A1_S4", 0)

	int a2 = Animation.AddPosition(Male)
	Animation.AddPositionStage(a2, "Arrok_Anal_A2_S1", -117, silent = true, openMouth = true)
	Animation.AddPositionStage(a2, "Arrok_Anal_A2_S2", -103.5, sos = 3)
	Animation.AddPositionStage(a2, "Arrok_Anal_A2_S3", -121.5, sos = 4)
	Animation.AddPositionStage(a2, "Arrok_Anal_A2_S4", -123.5, sos = 3)

	Animation.AddTag("Arrok")
	Animation.AddTag("TBBP")
	Animation.AddTag("MF")
	Animation.AddTag("Anal")
	Animation.AddTag("Sex")
	Animation.AddTag("Dirty")

	Save()
endFunction