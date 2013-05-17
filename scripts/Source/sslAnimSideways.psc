scriptname sslAnimSideways extends sslBaseAnimation

; Actor 1 (Female)
idle property Sideways_A1_S1 auto
idle property Sideways_A1_S2 auto
idle property Sideways_A1_S3 auto
idle property Sideways_A1_S4 auto
; Actor 2 (Male)
idle property Sideways_A2_S1 auto
idle property Sideways_A2_S2 auto
idle property Sideways_A2_S3 auto
idle property Sideways_A2_S4 auto

function LoadAnimation()
	name = "Sideways Fuck"
	
	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, 0, addCum=VaginalAnal)
	AddPositionStage(a1, Sideways_A1_S1)
	AddPositionStage(a1, Sideways_A1_S2)
	AddPositionStage(a1, Sideways_A1_S3)
	AddPositionStage(a1, Sideways_A1_S4)

	int a2 = AddPosition(Male, -100)
	AddPositionStage(a2, Sideways_A2_S1)
	AddPositionStage(a2, Sideways_A2_S2)
	AddPositionStage(a2, Sideways_A2_S3)
	AddPositionStage(a2, Sideways_A2_S4)

	AddTag("Default")
	AddTag("Sex")
	AddTag("MF")
	AddTag("Standing")
	AddTag("Sideways")
	AddTag("Vaginal")
endFunction