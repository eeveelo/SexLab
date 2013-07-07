scriptname sslAnimAPStandBlowjob extends sslBaseAnimation

function LoadAnimation()
	name = "AP Standing Blowjob"
	
	SetContent(Sexual)
	SetSFX(Sucking)

	int a1 = AddPosition(Female, addCum=Oral)
	AddPositionStage(a1, "AP_StandBlowjob_A1_S1", 0, silent = true, openMouth = true)
	AddPositionStage(a1, "AP_StandBlowjob_A1_S2", 0, silent = true, openMouth = true)
	AddPositionStage(a1, "AP_StandBlowjob_A1_S3", 0, silent = true, openMouth = true)
	AddPositionStage(a1, "AP_StandBlowjob_A1_S4", 0, silent = true, openMouth = true)
	AddPositionStage(a1, "AP_StandBlowjob_A1_S5", 0, silent = true, openMouth = true)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "AP_IdleStand_A2_S1", 44, rotate = 180, sos = -1)
	AddPositionStage(a2, "AP_IdleStand_A2_S2", 44, rotate = 180, sos = -1)
	AddPositionStage(a2, "AP_IdleStand_A2_S3", 44, rotate = 180, sos = -1)
	AddPositionStage(a2, "AP_IdleStand_A2_S4", 44, rotate = 180, sos = -1)
	AddPositionStage(a2, "AP_IdleStand_A2_S5", 44, rotate = 180, sos = -1)

	AddTag("AP")
	AddTag("Sex")
	AddTag("Straight")
	AddTag("MF")
	AddTag("Dirty")
	AddTag("Oral")
	AddTag("Blowjob")
	AddTag("LeadIn")
endFunction