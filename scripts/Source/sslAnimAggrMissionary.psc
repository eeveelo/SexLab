scriptname sslAnimAggrMissionary extends sslBaseAnimation

function LoadAnimation()
	name = "Rough Missionary"
	
	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, 0, addCum=VaginalAnal)
	AddPositionStage(a1, "AggrMissionary_A1_S1")
	AddPositionStage(a1, "AggrMissionary_A1_S2")
	AddPositionStage(a1, "AggrMissionary_A1_S3")
	AddPositionStage(a1, "AggrMissionary_A1_S4")

	int a2 = AddPosition(Male, -86)
	AddPositionStage(a2, "AggrMissionary_A2_S1")
	AddPositionStage(a2, "AggrMissionary_A2_S2")
	AddPositionStage(a2, "AggrMissionary_A2_S3")
	AddPositionStage(a2, "AggrMissionary_A2_S4")

	AddTag("Default")
	AddTag("Sex")
	AddTag("MF")
	AddTag("Missionary")
	AddTag("Laying")
	AddTag("Vaginal")
	AddTag("Aggressive")
endFunction