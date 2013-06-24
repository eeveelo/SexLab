scriptname sslAnimArrokStandingForeplay extends sslBaseAnimation

function LoadAnimation()
	name = "Arrok Standing Foreplay"

	SetContent(Foreplay)

	int a1 = AddPosition(Female)
	AddPositionStage(a1, "Arrok_StandingForeplay_A1_S1", 0)
	AddPositionStage(a1, "Arrok_StandingForeplay_A1_S2", 0)
	AddPositionStage(a1, "Arrok_StandingForeplay_A1_S3", 0)
	AddPositionStage(a1, "Arrok_StandingForeplay_A1_S4", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "Arrok_StandingForeplay_A2_S1", -100, strapon = false)
	AddPositionStage(a2, "Arrok_StandingForeplay_A2_S2", -100, strapon = false)
	AddPositionStage(a2, "Arrok_StandingForeplay_A2_S3", -100, strapon = false)
	AddPositionStage(a2, "Arrok_StandingForeplay_A2_S4", -100, strapon = false)

	AddTag("Arrok")
	AddTag("BBP")
	AddTag("Foreplay")
	AddTag("MF")
	AddTag("Standing")
	AddTag("Loving")
	AddTag("Kissing")
endFunction