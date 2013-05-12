scriptname sslAnimBoobjob extends sslBaseAnimation

; Actor 1 (Female)
idle property Boobjob_A1_S1 auto
idle property Boobjob_A1_S2 auto
idle property Boobjob_A1_S3 auto
idle property Boobjob_A1_S4 auto
; Actor 2 (Male)
idle property Boobjob_A2_S1 auto
idle property Boobjob_A2_S2 auto
idle property Boobjob_A2_S3 auto
idle property Boobjob_A2_S4 auto

function LoadAnimation()
	name = "Boobjob"

	SetContent(Sexual)
	SetSFX(Silent)

	int a1 = AddPosition(Female, 0, addCum=Oral)
	AddPositionStage(a1, Boobjob_A1_S1)
	AddPositionStage(a1, Boobjob_A1_S2)
	AddPositionStage(a1, Boobjob_A1_S3)
	AddPositionStage(a1, Boobjob_A1_S4)

	int a2 = AddPosition(Male, -102)
	AddPositionStage(a2, Boobjob_A2_S1)
	AddPositionStage(a2, Boobjob_A2_S2)
	AddPositionStage(a2, Boobjob_A2_S3)
	AddPositionStage(a2, Boobjob_A2_S4)

	AddTag("Default")
	AddTag("Sex")
	AddTag("MF")
	AddTag("Boobjob")
	AddTag("Dirty")
	AddTag("Breast")
endFunction