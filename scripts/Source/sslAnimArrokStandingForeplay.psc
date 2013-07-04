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
	AddPositionStage(a2, "Arrok_StandingForeplay_A2_S1", -101, strapon = false, sos = -1)
	AddPositionStage(a2, "Arrok_StandingForeplay_A2_S2", -101, strapon = false, sos = -1)
	AddPositionStage(a2, "Arrok_StandingForeplay_A2_S3", -101, silent = true, strapon = false, sos = 5)
	AddPositionStage(a2, "Arrok_StandingForeplay_A2_S4", -101, silent = true, strapon = false, sos = 5)

	AddTag("Arrok")
	AddTag("BBP")
	AddTag("Foreplay")
	AddTag("MF")
	AddTag("Standing")
	AddTag("Loving")
	AddTag("Kissing")
endFunction