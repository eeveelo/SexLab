scriptname sslAnimArrokForeplay extends sslBaseAnimation

function LoadAnimation()
	name = "Arrok Foreplay"

	SetContent(Foreplay)

	int a1 = AddPosition(Female)
	AddPositionStage(a1, "Arrok_Foreplay_A1_S1", 0)
	AddPositionStage(a1, "Arrok_Foreplay_A1_S2", 0)
	AddPositionStage(a1, "Arrok_Foreplay_A1_S3", 0)
	AddPositionStage(a1, "Arrok_Foreplay_A1_S4", 0)

	int a2 = AddPosition(Male) ; -104
	AddPositionStage(a2, "Arrok_Foreplay_A2_S1", -108, strapon = false)
	AddPositionStage(a2, "Arrok_Foreplay_A2_S2", -108, strapon = false)
	AddPositionStage(a2, "Arrok_Foreplay_A2_S3", -108, strapon = false)
	AddPositionStage(a2, "Arrok_Foreplay_A2_S4", -108, strapon = false)

	AddTag("Arrok")
	AddTag("BBP")
	AddTag("Foreplay")
	AddTag("MF")
	AddTag("Laying")
	AddTag("Loving")
	AddTag("Cuddling")
endFunction