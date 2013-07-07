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
	AddPositionStage(a2, "Arrok_Foreplay_A2_S1", -106, strapon = false, sos = 0)
	AddPositionStage(a2, "Arrok_Foreplay_A2_S2", -106, strapon = false, sos = 0)
	AddPositionStage(a2, "Arrok_Foreplay_A2_S3", -106, strapon = false, sos = 5)
	AddPositionStage(a2, "Arrok_Foreplay_A2_S4", -106, strapon = false, sos = 5)

	AddTag("Arrok")
	AddTag("BBP")
	AddTag("Foreplay")
	AddTag("MF")
	AddTag("Laying")
	AddTag("Loving")
	AddTag("Cuddling")
	AddTag("LeadIn")
endFunction