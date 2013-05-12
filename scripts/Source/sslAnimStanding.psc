scriptname sslAnimStanding extends sslBaseAnimation

; Actor 1 (Female)
idle property Standing_A1_S1 auto
idle property Standing_A1_S2 auto
idle property Standing_A1_S3 auto
idle property Standing_A1_S4 auto
; Actor 2 (Male)
idle property Standing_A2_S1 auto
idle property Standing_A2_S2 auto
idle property Standing_A2_S3 auto
idle property Standing_A2_S4 auto

function LoadAnimation()
	name = "Standing Fuck"
	
	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, 0, addCum=Anal)
	AddPositionStage(a1, Standing_A1_S1)
	AddPositionStage(a1, Standing_A1_S2)
	AddPositionStage(a1, Standing_A1_S3)
	AddPositionStage(a1, Standing_A1_S4)

	int a2 = AddPosition(Male, -81)
	AddPositionStage(a2, Standing_A2_S1)
	AddPositionStage(a2, Standing_A2_S2)
	AddPositionStage(a2, Standing_A2_S3)
	AddPositionStage(a2, Standing_A2_S4)

	AddTag("Default")
	AddTag("Sex")
	AddTag("MF")
	AddTag("Standing")
	AddTag("Dirty")
	AddTag("Vaginal")
endFunction