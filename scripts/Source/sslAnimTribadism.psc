scriptname sslAnimTribadism extends sslBaseAnimation

; Actor 1 (Female)
idle property Tribadism_A1_S1 auto
idle property Tribadism_A1_S2 auto

; Actor 2 (Male)
idle property Tribadism_A2_S1 auto
idle property Tribadism_A2_S2 auto


function LoadAnimation()
	name = "Tribadism"
	
	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, 0)
	AddPositionStage(a1, Tribadism_A1_S1)
	AddPositionStage(a1, Tribadism_A1_S2)
	AddPositionStage(a1, Tribadism_A1_S2)

	int a2 = AddPosition(Female, 60)
	AddPositionStage(a2, Tribadism_A2_S1)
	AddPositionStage(a2, Tribadism_A2_S2)
	AddPositionStage(a2, Tribadism_A2_S2)

	AddTag("Default")
	AddTag("Sex")
	AddTag("FF")
	AddTag("Lesbian")
	AddTag("Tribadism")
	AddTag("Vaginal")
endFunction