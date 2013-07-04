scriptname sslAnimMissionary extends sslBaseAnimation

function LoadAnimation()
	name = "Missionary"
	
	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "Missionary_A1_S1", 0)
	AddPositionStage(a1, "Missionary_A1_S2", 0)
	AddPositionStage(a1, "Missionary_A1_S3", 0)
	AddPositionStage(a1, "Missionary_A1_S4", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "Missionary_A2_S1", -104, sos = 4)
	AddPositionStage(a2, "Missionary_A2_S2", -104, sos = 4)
	AddPositionStage(a2, "Missionary_A2_S3", -104, sos = 4)
	AddPositionStage(a2, "Missionary_A2_S4", -104, sos = 4)

	AddTag("Default")
	AddTag("Sex")
	AddTag("MF")
	AddTag("Missionary")
	AddTag("Laying")
	AddTag("Vaginal")
endFunction