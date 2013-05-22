scriptname sslAnimAPAnal extends sslBaseAnimation

function LoadAnimation()
	name = "AP Anal"
	
	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, 0, addCum=Anal)
	AddPositionStage(a1, "AP_Anal_A1_S1")
	AddPositionStage(a1, "AP_Anal_A1_S2")
	AddPositionStage(a1, "AP_Anal_A1_S3")
	AddPositionStage(a1, "AP_Anal_A1_S4")
	AddPositionStage(a1, "AP_Anal_A1_S5")

	int a2 = AddPosition(Male, 44, rotation=180.0)
	AddPositionStage(a2, "AP_Anal_A2_S1")
	AddPositionStage(a2, "AP_Anal_A2_S2")
	AddPositionStage(a2, "AP_Anal_A2_S3")
	AddPositionStage(a2, "AP_Anal_A2_S4")
	AddPositionStage(a2, "AP_Anal_A2_S5")

	AddTag("AP")
	AddTag("Sex")
	AddTag("Straight")
	AddTag("MF")
	AddTag("Aggressive")
	AddTag("Anal")
endFunction