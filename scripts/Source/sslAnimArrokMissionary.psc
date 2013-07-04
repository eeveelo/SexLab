scriptname sslAnimArrokMissionary extends sslBaseAnimation

function LoadAnimation()
	name = "Arrok Missionary"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "Arrok_Missionary_A1_S1", 0)
	AddPositionStage(a1, "Arrok_Missionary_A1_S2", 0)
	AddPositionStage(a1, "Arrok_Missionary_A1_S3", 0)
	AddPositionStage(a1, "Arrok_Missionary_A1_S4", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "Arrok_Missionary_A2_S1", -105)
	AddPositionStage(a2, "Arrok_Missionary_A2_S2", -105)
	AddPositionStage(a2, "Arrok_Missionary_A2_S3", -105, sos = 3)
	AddPositionStage(a2, "Arrok_Missionary_A2_S4", -107, sos = 7)

	AddTag("Arrok")
	AddTag("BBP")
	AddTag("Sex")
	AddTag("MF")
	AddTag("Missionary")
	AddTag("Laying")
	AddTag("Vaginal")
endFunction