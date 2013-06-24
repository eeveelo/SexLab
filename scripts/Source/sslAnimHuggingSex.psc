scriptname sslAnimHuggingSex extends sslBaseAnimation

function LoadAnimation()
	name = "Hugging Fuck"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "HuggingSex_A1_S1", 0)
	AddPositionStage(a1, "HuggingSex_A1_S2", 0)
	AddPositionStage(a1, "HuggingSex_A1_S3", 0)
	AddPositionStage(a1, "HuggingSex_A1_S4", 0)

	int a2 = AddPosition(Male) ; -99
	AddPositionStage(a2, "HuggingSex_A2_S1", -102)
	AddPositionStage(a2, "HuggingSex_A2_S2", -102)
	AddPositionStage(a2, "HuggingSex_A2_S3", -102)
	AddPositionStage(a2, "HuggingSex_A2_S4", -102)

	AddTag("Default")
	AddTag("Sex")
	AddTag("MF")
	AddTag("Hugging")
	AddTag("Loving")
	AddTag("Vaginal")
endFunction