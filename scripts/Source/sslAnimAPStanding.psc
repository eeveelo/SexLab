scriptname sslAnimAPStanding extends sslBaseAnimation

function LoadAnimation()
	name = "AP Standing"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "AP_Standing_A1_S1", 0)
	AddPositionStage(a1, "AP_Standing_A1_S2", 0)
	AddPositionStage(a1, "AP_Standing_A1_S3", 0)
	AddPositionStage(a1, "AP_Standing_A1_S4", 0)
	AddPositionStage(a1, "AP_Standing_A1_S5", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "AP_Standing_A2_S1", 43, rotate = 180, sos = 2)
	AddPositionStage(a2, "AP_Standing_A2_S2", 43, rotate = 180, sos = 2)
	AddPositionStage(a2, "AP_Standing_A2_S2", 43, rotate = 180, sos = 2)
	AddPositionStage(a2, "AP_Standing_A2_S3", 43, rotate = 180, sos = 2)
	AddPositionStage(a2, "AP_Standing_A2_S3", 43, rotate = 180, sos = 2)

	AddTag("AP")
	AddTag("Sex")
	AddTag("Straight")
	AddTag("Standing")
	AddTag("Vaginal")
	AddTag("MF")
endFunction