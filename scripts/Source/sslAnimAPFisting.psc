scriptname sslAnimAPFisting extends sslBaseAnimation

function LoadAnimation()
	name = "AP Fisting"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female)
	AddPositionStage(a1, "AP_Fisting_A1_S1", 0)
	AddPositionStage(a1, "AP_Fisting_A1_S2", 0)
	AddPositionStage(a1, "AP_Fisting_A1_S3", 0)
	AddPositionStage(a1, "AP_Fisting_A1_S4", 0)
	AddPositionStage(a1, "AP_Fisting_A1_S5", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "AP_Fisting_A2_S1", 44, rotate = 180, strapon = false)
	AddPositionStage(a2, "AP_Fisting_A2_S2", 44, rotate = 180, strapon = false)
	AddPositionStage(a2, "AP_Fisting_A2_S3", 44, rotate = 180, strapon = false)
	AddPositionStage(a2, "AP_Fisting_A2_S4", 44, rotate = 180, strapon = false)
	AddPositionStage(a2, "AP_Fisting_A2_S4", 44, rotate = 180, strapon = false)

	AddTag("AP")
	AddTag("Sex")
	AddTag("Straight")
	AddTag("Aggressive")
	AddTag("Fisting")
	AddTag("Rough")
	AddTag("MF")
	AddTag("Dirty")
endFunction