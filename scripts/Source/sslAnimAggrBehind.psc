scriptname sslAnimAggrBehind extends sslBaseAnimation

function LoadAnimation()
	name = "Rough Behind"
	
	SetContent(Sexual)
	SetSFX(Squishing)
	
	tcl = true

	int a1 = AddPosition(Female, 0, addCum=Anal)
	AddPositionStage(a1, "AggrBehind_A1_S1")
	AddPositionStage(a1, "AggrBehind_A1_S2")
	AddPositionStage(a1, "AggrBehind_A1_S3")
	AddPositionStage(a1, "AggrBehind_A1_S4")

	int a2 = AddPosition(Male, -12)
	AddPositionStage(a2, "AggrBehind_A2_S1")
	AddPositionStage(a2, "AggrBehind_A2_S2")
	AddPositionStage(a2, "AggrBehind_A2_S3")
	AddPositionStage(a2, "AggrBehind_A2_S4")

	AddTag("Default")
	AddTag("Sex")
	AddTag("MF")
	AddTag("Behind")
	AddTag("Anal")
	AddTag("Aggressive")
endFunction