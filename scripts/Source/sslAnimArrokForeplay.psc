scriptname sslAnimArrokForeplay extends sslBaseAnimation

function LoadAnimation()
	name = "Arrok Foreplay"

	SetContent(Foreplay)
	SetSFX(Silent)

	int a1 = AddPosition(Female, 0)
	AddPositionStage(a1, "Arrok_Foreplay_A1_S1")
	AddPositionStage(a1, "Arrok_Foreplay_A1_S2")
	AddPositionStage(a1, "Arrok_Foreplay_A1_S3")
	AddPositionStage(a1, "Arrok_Foreplay_A1_S4")

	int a2 = AddPosition(Male, -108) ; -104
	AddPositionStage(a2, "Arrok_Foreplay_A2_S1")
	AddPositionStage(a2, "Arrok_Foreplay_A2_S2")
	AddPositionStage(a2, "Arrok_Foreplay_A2_S3")
	AddPositionStage(a2, "Arrok_Foreplay_A2_S4")

	AddTag("Arrok")
	AddTag("BBP")
	AddTag("Foreplay")
	AddTag("MF")
	AddTag("Laying")
	AddTag("Loving")
	AddTag("Cuddling")
endFunction