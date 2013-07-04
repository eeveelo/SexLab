scriptname sslAnimAPBoobjob extends sslBaseAnimation

function LoadAnimation()
	name = "AP Boobjob"
	
	SetContent(Sexual)

	int a1 = AddPosition(Female, addCum=Oral)
	AddPositionStage(a1, "AP_Boobjob_A1_S1", 0)
	AddPositionStage(a1, "AP_Boobjob_A1_S2", 0)
	AddPositionStage(a1, "AP_Boobjob_A1_S3", 0)
	AddPositionStage(a1, "AP_Boobjob_A1_S4", 0)
	AddPositionStage(a1, "AP_Boobjob_A1_S5", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "AP_IdleStand_A2_S1", 30, rotate = 180, sos = 6)
	AddPositionStage(a2, "AP_IdleStand_A2_S2", 30, rotate = 180, sos = 6)
	AddPositionStage(a2, "AP_IdleStand_A2_S3", 30, rotate = 180, sos = 6)
	AddPositionStage(a2, "AP_IdleStand_A2_S4", 30, rotate = 180, sos = 6)
	AddPositionStage(a2, "AP_IdleStand_A2_S5", 30, rotate = 180, sos = 6)

	AddTag("AP")
	AddTag("Sex")
	AddTag("Straight")
	AddTag("MF")
	AddTag("Dirty")
	AddTag("Boobjob")
	AddTag("Breast")
endFunction