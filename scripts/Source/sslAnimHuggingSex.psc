scriptname sslAnimHuggingSex extends sslBaseAnimation

function LoadAnimation()
	name = "Hugging Fuck"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, 0, addCum=Vaginal)
	AddPositionStage(a1, "HuggingSex_A1_S1")
	AddPositionStage(a1, "HuggingSex_A1_S2")
	AddPositionStage(a1, "HuggingSex_A1_S3")
	AddPositionStage(a1, "HuggingSex_A1_S4")

	int a2 = AddPosition(Male, -102) ; -99
	AddPositionStage(a2, "HuggingSex_A2_S1")
	AddPositionStage(a2, "HuggingSex_A2_S2")
	AddPositionStage(a2, "HuggingSex_A2_S3")
	AddPositionStage(a2, "HuggingSex_A2_S4")

	AddTag("Default")
	AddTag("Sex")
	AddTag("MF")
	AddTag("Hugging")
	AddTag("Loving")
	AddTag("Vaginal")
endFunction