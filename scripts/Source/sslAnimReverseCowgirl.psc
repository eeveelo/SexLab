scriptname sslAnimReverseCowgirl extends sslBaseAnimation

function LoadAnimation()
	name = "Reverse Cowgirl"
	
	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, 0, addCum=VaginalAnal)
	AddPositionStage(a1, "ReverseCowgirl_A1_S1")
	AddPositionStage(a1, "ReverseCowgirl_A1_S2")
	AddPositionStage(a1, "ReverseCowgirl_A1_S3")
	AddPositionStage(a1, "ReverseCowgirl_A1_S4")

	int a2 = AddPosition(Male, -107) ; -102
	AddPositionStage(a2, "ReverseCowgirl_A2_S1")
	AddPositionStage(a2, "ReverseCowgirl_A2_S2")
	AddPositionStage(a2, "ReverseCowgirl_A2_S3")
	AddPositionStage(a2, "ReverseCowgirl_A2_S4")

	AddTag("Default")
	AddTag("Sex")
	AddTag("MF")
	AddTag("Dirty")
	AddTag("Cowgirl")
	AddTag("Anal")
endFunction