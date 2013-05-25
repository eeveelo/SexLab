scriptname sslAnimAPFemaleSolo extends sslBaseAnimation

function LoadAnimation()
	name = "AP Female Masturbation"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, 0)
	AddPositionStage(a1, "AP_FemaleSolo_A1_S1")
	AddPositionStage(a1, "AP_FemaleSolo_A1_S2")
	AddPositionStage(a1, "AP_FemaleSolo_A1_S3")
	AddPositionStage(a1, "AP_FemaleSolo_A1_S4")
	AddPositionStage(a1, "AP_FemaleSolo_A1_S5")
	AddPositionStage(a1, "AP_FemaleSolo_A1_S6")

	AddTag("Sex")
	AddTag("Solo")
	AddTag("F")
	AddTag("Masturbation")
	AddTag("Standing")
endFunction