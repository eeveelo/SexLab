scriptname sslAnimAggrMissionary extends sslBaseAnimation

function LoadAnimation()
	name = "Rough Missionary"
	
	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "AggrMissionary_A1_S1", 0)
	AddPositionStage(a1, "AggrMissionary_A1_S2", 0)
	AddPositionStage(a1, "AggrMissionary_A1_S3", 0)
	AddPositionStage(a1, "AggrMissionary_A1_S4", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "AggrMissionary_A2_S1", -86, sos = 4)
	AddPositionStage(a2, "AggrMissionary_A2_S2", -86, sos = 4)
	AddPositionStage(a2, "AggrMissionary_A2_S3", -86, sos = 3)
	AddPositionStage(a2, "AggrMissionary_A2_S4", -86, sos = 3)

	AddTag("Default")
	AddTag("Sex")
	AddTag("MF")
	AddTag("Missionary")
	AddTag("Laying")
	AddTag("Vaginal")
	AddTag("Aggressive")
endFunction