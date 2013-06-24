scriptname sslAnimStanding extends sslBaseAnimation

function LoadAnimation()
	name = "Standing Fuck"
	
	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Standing_A1_S1", 0)
	AddPositionStage(a1, "Standing_A1_S2", 0)
	AddPositionStage(a1, "Standing_A1_S3", 0)
	AddPositionStage(a1, "Standing_A1_S4", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "Standing_A2_S1", -81)
	AddPositionStage(a2, "Standing_A2_S2", -81)
	AddPositionStage(a2, "Standing_A2_S3", -81)
	AddPositionStage(a2, "Standing_A2_S4", -81)

	AddTag("Default")
	AddTag("Sex")
	AddTag("MF")
	AddTag("Standing")
	AddTag("Dirty")
	AddTag("Vaginal")
endFunction