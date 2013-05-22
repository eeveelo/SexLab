scriptname sslAnimArrokStandingForeplay extends sslBaseAnimation

function LoadAnimation()
	name = "Arrok Standing Foreplay"

	SetContent(Foreplay)
	SetSFX(Silent)

	int a1 = AddPosition(Female, 0)
	AddPositionStage(a1, "Arrok_StandingForeplay_A1_S1")
	AddPositionStage(a1, "Arrok_StandingForeplay_A1_S2")
	AddPositionStage(a1, "Arrok_StandingForeplay_A1_S3")
	AddPositionStage(a1, "Arrok_StandingForeplay_A1_S4")

	int a2 = AddPosition(Male, -100, noStrapon=true)
	AddPositionStage(a2, "Arrok_StandingForeplay_A2_S1")
	AddPositionStage(a2, "Arrok_StandingForeplay_A2_S2")
	AddPositionStage(a2, "Arrok_StandingForeplay_A2_S3")
	AddPositionStage(a2, "Arrok_StandingForeplay_A2_S4")

	AddTag("Arrok")
	AddTag("BBP")
	AddTag("Foreplay")
	AddTag("MF")
	AddTag("Standing")
	AddTag("Loving")
	AddTag("Kissing")
endFunction