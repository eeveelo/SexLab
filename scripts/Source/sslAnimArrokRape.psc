scriptname sslAnimArrokRape extends sslBaseAnimation

function LoadAnimation()
	name = "Arrok Rape"
	
	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=Oral)
	AddPositionStage(a1, "Arrok_Rape_A1_S1", 0)
	AddPositionStage(a1, "Arrok_Rape_A1_S2", 0)
	AddPositionStage(a1, "Arrok_Rape_A1_S3", 0)
	AddPositionStage(a1, "Arrok_Rape_A1_S4", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "Arrok_Rape_A2_S1", -125)
	AddPositionStage(a2, "Arrok_Rape_A2_S2", -125)
	AddPositionStage(a2, "Arrok_Rape_A2_S3", -125, sos = 4)
	AddPositionStage(a2, "Arrok_Rape_A2_S4", -125, up = 4)

	AddTag("Arrok")
	AddTag("TBBP")
	AddTag("MF")
	AddTag("Anal")
	AddTag("Sex")
	AddTag("Aggressive")
	AddTag("Dirty")
	AddTag("Behind")
endFunction