scriptname sslAnimAPAnal extends sslBaseAnimation

function LoadAnimation()
	name = "AP Anal"
	
	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "AP_Anal_A1_S1", 0)
	AddPositionStage(a1, "AP_Anal_A1_S2", 0)
	AddPositionStage(a1, "AP_Anal_A1_S3", 0)
	AddPositionStage(a1, "AP_Anal_A1_S4", 0)
	AddPositionStage(a1, "AP_Anal_A1_S5", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "AP_Anal_A2_S1", 44, rotate = 180)
	AddPositionStage(a2, "AP_Anal_A2_S2", 44, rotate = 180)
	AddPositionStage(a2, "AP_Anal_A2_S3", 44, rotate = 180)
	AddPositionStage(a2, "AP_Anal_A2_S4", 44, rotate = 180)
	AddPositionStage(a2, "AP_Anal_A2_S5", 44, rotate = 180)

	AddTag("AP")
	AddTag("Sex")
	AddTag("Straight")
	AddTag("MF")
	AddTag("Aggressive")
	AddTag("Anal")
endFunction