scriptname sslAnimAggrBehind extends sslBaseAnimation

function LoadAnimation()
	name = "Rough Behind"
	
	SetContent(Sexual)
	SetSFX(Squishing)
	
	tcl = true
	enabled = false

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "AggrBehind_A1_S1", 0)
	AddPositionStage(a1, "AggrBehind_A1_S2", 0)
	AddPositionStage(a1, "AggrBehind_A1_S3", 0)
	AddPositionStage(a1, "AggrBehind_A1_S4", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "AggrBehind_A2_S1", -12)
	AddPositionStage(a2, "AggrBehind_A2_S2", -12)
	AddPositionStage(a2, "AggrBehind_A2_S3", -12)
	AddPositionStage(a2, "AggrBehind_A2_S4", -12)

	AddTag("Default")
	AddTag("Sex")
	AddTag("MF")
	AddTag("Behind")
	AddTag("Anal")
	AddTag("Aggressive")
endFunction