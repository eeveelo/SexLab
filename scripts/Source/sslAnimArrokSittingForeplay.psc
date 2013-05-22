scriptname sslAnimArrokSittingForeplay extends sslBaseAnimation

function LoadAnimation()
	name = "Arrok Sitting Foreplay"
	
	SetSFX(Silent)
	SetContent(Sexual)

	int a1 = AddPosition(Female, 0)
	AddPositionStage(a1, "Arrok_SittingForeplay_A1_S1")
	AddPositionStage(a1, "Arrok_SittingForeplay_A1_S2")
	AddPositionStage(a1, "Arrok_SittingForeplay_A1_S3")
	AddPositionStage(a1, "Arrok_SittingForeplay_A1_S4")

	int a2 = AddPosition(Male, -100)
	AddPositionStage(a2, "Arrok_SittingForeplay_A2_S1")
	AddPositionStage(a2, "Arrok_SittingForeplay_A2_S2")
	AddPositionStage(a2, "Arrok_SittingForeplay_A2_S3")
	AddPositionStage(a2, "Arrok_SittingForeplay_A2_S4")

	AddTag("Arrok")
	AddTag("BBP")
	AddTag("MF")
	AddTag("Kissing")
	AddTag("Cuddling")
	AddTag("Loving")
	AddTag("Foreplay")
endFunction