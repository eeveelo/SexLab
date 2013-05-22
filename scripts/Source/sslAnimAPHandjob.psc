scriptname sslAnimAPHandjob extends sslBaseAnimation

function LoadAnimation()
	name = "AP Handjob"

	SetContent(Sexual)
	SetSFX(Silent)

	int a1 = AddPosition(Female, 0, noVoice=true, addCum=Oral)
	AddPositionStage(a1, "AP_Handjob_A1_S1")
	AddPositionStage(a1, "AP_Handjob_A1_S2")
	AddPositionStage(a1, "AP_Handjob_A1_S3")
	AddPositionStage(a1, "AP_Handjob_A1_S4")
	AddPositionStage(a1, "AP_Handjob_A1_S5")

	int a2 = AddPosition(Male, 44, rotation=180.0)
	AddPositionStage(a2, "AP_IdleStand_A2_S1")
	AddPositionStage(a2, "AP_IdleStand_A2_S2")
	AddPositionStage(a2, "AP_IdleStand_A2_S3")
	AddPositionStage(a2, "AP_IdleStand_A2_S4")
	AddPositionStage(a2, "AP_IdleStand_A2_S5")

	AddTag("AP")
	AddTag("Sex")
	AddTag("Straight")
	AddTag("MF")
	AddTag("Dirty")
	AddTag("Handjob")
endFunction