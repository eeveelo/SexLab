scriptname sslAnimReverseCowgirl extends sslBaseAnimation

function LoadAnimation()
	name = "Reverse Cowgirl"
	
	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "ReverseCowgirl_A1_S1", 0)
	AddPositionStage(a1, "ReverseCowgirl_A1_S2", 0)
	AddPositionStage(a1, "ReverseCowgirl_A1_S3", 0)
	AddPositionStage(a1, "ReverseCowgirl_A1_S4", 0)

	int a2 = AddPosition(Male) ; -102
	AddPositionStage(a2, "ReverseCowgirl_A2_S1", -107, sos = 3)
	AddPositionStage(a2, "ReverseCowgirl_A2_S2", -107, sos = 3)
	AddPositionStage(a2, "ReverseCowgirl_A2_S3", -107, sos = 3)
	AddPositionStage(a2, "ReverseCowgirl_A2_S4", -107, sos = 3)

	AddTag("Default")
	AddTag("Sex")
	AddTag("MF")
	AddTag("Dirty")
	AddTag("Cowgirl")
	AddTag("Anal")
endFunction