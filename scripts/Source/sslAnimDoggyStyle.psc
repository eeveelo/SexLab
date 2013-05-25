scriptname sslAnimDoggyStyle extends sslBaseAnimation

function LoadAnimation()
	name = "Doggy Style"
	
	SetSFX(Squishing)
	SetContent(Sexual)

	int a1 = AddPosition(Female, 0, addCum=Anal)
	AddPositionStage(a1, "DoggyStyle_A1_S1")
	AddPositionStage(a1, "DoggyStyle_A1_S2")
	AddPositionStage(a1, "DoggyStyle_A1_S3")
	AddPositionStage(a1, "DoggyStyle_A1_S4")

	int a2 = AddPosition(Male, -104)
	AddPositionStage(a2, "DoggyStyle_A2_S1")
	AddPositionStage(a2, "DoggyStyle_A2_S2")
	AddPositionStage(a2, "DoggyStyle_A2_S3")
	AddPositionStage(a2, "DoggyStyle_A2_S4")

	AddTag("Default")
	AddTag("Sex")
	AddTag("MF")
	AddTag("Doggy Style")
	AddTag("Vaginal")
endFunction