scriptname sslAnimAPFaceDown extends sslBaseAnimation

function LoadAnimation()
	name = "AP Face Down Anal"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, 0, addCum=Anal)
	AddPositionStage(a1, "AP_FaceDown_A1_S1")
	AddPositionStage(a1, "AP_FaceDown_A1_S2")
	AddPositionStage(a1, "AP_FaceDown_A1_S3")
	AddPositionStage(a1, "AP_FaceDown_A1_S4")
	AddPositionStage(a1, "AP_FaceDown_A1_S5")

	int a2 = AddPosition(Male, 44, rotation=180.0)
	AddPositionStage(a2, "AP_FaceDown_A2_S1")
	AddPositionStage(a2, "AP_FaceDown_A2_S2")
	AddPositionStage(a2, "AP_FaceDown_A2_S3")
	AddPositionStage(a2, "AP_FaceDown_A2_S3")
	AddPositionStage(a2, "AP_FaceDown_A2_S4")

	AddTag("AP")
	AddTag("Sex")
	AddTag("Laying")
	AddTag("Aggressive")
	AddTag("MF")
	AddTag("Straight")
	AddTag("Anal")
endFunction