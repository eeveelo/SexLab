scriptname sslAnimArrokMaleMasturbation extends sslBaseAnimation

; Actor 1 (Male)
idle property Arrok_MaleMasturbation_A1_S1 auto
idle property Arrok_MaleMasturbation_A1_S2 auto
idle property Arrok_MaleMasturbation_A1_S3 auto
idle property Arrok_MaleMasturbation_A1_S4 auto

function LoadAnimation()
	name = "Arrok Male Masturbation"
	
	SetContent(Sexual)
	SetSFX(Silent)

	int a1 = AddPosition(Male, 0)
	AddPositionStage(a1, Arrok_MaleMasturbation_A1_S1)
	AddPositionStage(a1, Arrok_MaleMasturbation_A1_S2)
	AddPositionStage(a1, Arrok_MaleMasturbation_A1_S3)
	AddPositionStage(a1, Arrok_MaleMasturbation_A1_S4)

	AddTag("Sex")
	AddTag("Solo")
	AddTag("M")
	AddTag("Masturbation")
	AddTag("Standing")
endFunction