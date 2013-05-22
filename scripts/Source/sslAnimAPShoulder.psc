scriptname sslAnimAPShoulder extends sslBaseAnimation

function LoadAnimation()
	name = "AP Shoulder"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, 0, addCum=VaginalAnal)
	AddPositionStage(a1, "AP_Shoulder_A1_S1")
	AddPositionStage(a1, "AP_Shoulder_A1_S2")
	AddPositionStage(a1, "AP_Shoulder_A1_S3")
	AddPositionStage(a1, "AP_Shoulder_A1_S4")
	AddPositionStage(a1, "AP_Shoulder_A1_S5")

	int a2 = AddPosition(Male, 44, rotation=180.0)
	AddPositionStage(a2, "AP_IdleStand_A2_S1")
	AddPositionStage(a2, "AP_IdleStand_A2_S2")
	AddPositionStage(a2, "AP_IdleStand_A2_S3")
	AddPositionStage(a2, "AP_IdleStand_A2_S4")
	AddPositionStage(a2, "AP_IdleStand_A2_S5")

	AddTag("AP")
	AddTag("Sex")
	AddTag("Straight")
	AddTag("Standing")
	AddTag("Vaginal")
	AddTag("MF")
endFunction