scriptname sslAnimDoggyStyle extends sslBaseAnimation

function LoadAnimation()
	name = "Doggy Style"
	
	SetSFX(Squishing)
	SetContent(Sexual)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "DoggyStyle_A1_S1", 0)
	AddPositionStage(a1, "DoggyStyle_A1_S2", 0)
	AddPositionStage(a1, "DoggyStyle_A1_S3", 0)
	AddPositionStage(a1, "DoggyStyle_A1_S4", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "DoggyStyle_A2_S1", -104)
	AddPositionStage(a2, "DoggyStyle_A2_S2", -104)
	AddPositionStage(a2, "DoggyStyle_A2_S3", -104)
	AddPositionStage(a2, "DoggyStyle_A2_S4", -104)

	AddTag("Default")
	AddTag("Sex")
	AddTag("MF")
	AddTag("Doggy Style")
	AddTag("Vaginal")
endFunction