scriptname sslAnimArrokSittingForeplay extends sslBaseAnimation

function LoadAnimation()
	name = "Arrok Sitting Foreplay"
	
	SetContent(Foreplay)

	int a1 = AddPosition(Female)
	AddPositionStage(a1, "Arrok_SittingForeplay_A1_S1", 0)
	AddPositionStage(a1, "Arrok_SittingForeplay_A1_S2", 0)
	AddPositionStage(a1, "Arrok_SittingForeplay_A1_S3", 0)
	AddPositionStage(a1, "Arrok_SittingForeplay_A1_S4", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "Arrok_SittingForeplay_A2_S1", -100, strapon = false)
	AddPositionStage(a2, "Arrok_SittingForeplay_A2_S2", -100, strapon = false)
	AddPositionStage(a2, "Arrok_SittingForeplay_A2_S3", -100, strapon = false)
	AddPositionStage(a2, "Arrok_SittingForeplay_A2_S4", -100, strapon = false)

	AddTag("Arrok")
	AddTag("BBP")
	AddTag("MF")
	AddTag("Kissing")
	AddTag("Cuddling")
	AddTag("Loving")
	AddTag("Foreplay")
	AddTag("LeadIn")
endFunction