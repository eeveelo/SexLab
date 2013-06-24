scriptname sslAnimAPBlowjob extends sslBaseAnimation

function LoadAnimation()
	name = "AP Blowjob"
	
	SetContent(Sexual)
	SetSFX(Sucking)

	int a1 = AddPosition(Female, addCum=Oral)
	AddPositionStage(a1, "AP_Blowjob_A1_S1", 0, silent = true, openMouth = true)
	AddPositionStage(a1, "AP_Blowjob_A1_S2", 0, silent = true, openMouth = true)
	AddPositionStage(a1, "AP_Blowjob_A1_S3", 0, silent = true, openMouth = true)
	AddPositionStage(a1, "AP_Blowjob_A1_S4", 0, silent = true, openMouth = true)
	AddPositionStage(a1, "AP_Blowjob_A1_S5", 0, silent = true, openMouth = true)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "AP_Cowgirl_A2_S1", 44, rotate = 180)
	AddPositionStage(a2, "AP_Cowgirl_A2_S2", 44, rotate = 180)
	AddPositionStage(a2, "AP_Cowgirl_A2_S2", 44, rotate = 180)
	AddPositionStage(a2, "AP_Cowgirl_A2_S3", 44, rotate = 180)
	AddPositionStage(a2, "AP_Cowgirl_A2_S4", 44, rotate = 180)

	AddTag("AP")
	AddTag("Sex")
	AddTag("Straight")
	AddTag("MF")
	AddTag("Dirty")
	AddTag("Oral")
	AddTag("Blowjob")
endFunction