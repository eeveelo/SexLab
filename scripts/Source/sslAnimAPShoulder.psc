scriptname sslAnimAPShoulder extends sslBaseAnimation

function LoadAnimation()
	name = "AP Shoulder"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "AP_Shoulder_A1_S1", 0)
	AddPositionStage(a1, "AP_Shoulder_A1_S2", 0)
	AddPositionStage(a1, "AP_Shoulder_A1_S3", 0)
	AddPositionStage(a1, "AP_Shoulder_A1_S4", 0)
	AddPositionStage(a1, "AP_Shoulder_A1_S5", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "AP_IdleStand_A2_S1", 44, rotate = 180)
	AddPositionStage(a2, "AP_IdleStand_A2_S2", 44, rotate = 180)
	AddPositionStage(a2, "AP_IdleStand_A2_S3", 44, rotate = 180)
	AddPositionStage(a2, "AP_IdleStand_A2_S4", 44, rotate = 180)
	AddPositionStage(a2, "AP_IdleStand_A2_S5", 44, rotate = 180)

	AddTag("AP")
	AddTag("Sex")
	AddTag("Straight")
	AddTag("Standing")
	AddTag("Vaginal")
	AddTag("MF")
endFunction