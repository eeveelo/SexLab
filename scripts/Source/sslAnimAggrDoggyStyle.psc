scriptname sslAnimAggrDoggyStyle extends sslBaseAnimation

; Actor 1 (Female)
idle property AggrDoggyStyle_A1_S1 auto
idle property AggrDoggyStyle_A1_S2 auto
idle property AggrDoggyStyle_A1_S3 auto
idle property AggrDoggyStyle_A1_S4 auto
; Actor 2 (Male)
idle property AggrDoggyStyle_A2_S1 auto
idle property AggrDoggyStyle_A2_S2 auto
idle property AggrDoggyStyle_A2_S3 auto
idle property AggrDoggyStyle_A2_S4 auto

function LoadAnimation()
	name = "Rough Doggy Style"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, 0, addCum=Anal)
	AddPositionStage(a1, AggrDoggyStyle_A1_S1)
	AddPositionStage(a1, AggrDoggyStyle_A1_S2)
	AddPositionStage(a1, AggrDoggyStyle_A1_S3)
	AddPositionStage(a1, AggrDoggyStyle_A1_S4)

	int a2 = AddPosition(Male, -100)
	AddPositionStage(a2, AggrDoggyStyle_A2_S1)
	AddPositionStage(a2, AggrDoggyStyle_A2_S2)
	AddPositionStage(a2, AggrDoggyStyle_A2_S3)
	AddPositionStage(a2, AggrDoggyStyle_A2_S4)

	AddTag("Default")
	AddTag("Sex")
	AddTag("MF")
	AddTag("Doggystyle")
	AddTag("Behind")
	AddTag("Anal")
	AddTag("Aggressive")
endFunction