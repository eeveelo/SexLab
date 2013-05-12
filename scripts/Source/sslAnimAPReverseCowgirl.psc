scriptname sslAnimAPReverseCowgirl extends sslBaseAnimation

; Animation Currently not used due to roation problems on some stages

; Actor 1 (Female)
idle property AP_ReverseCowgirl_A1_S1 auto
idle property AP_ReverseCowgirl_A1_S2 auto
idle property AP_ReverseCowgirl_A1_S3 auto ; Weird Rotation
idle property AP_ReverseCowgirl_A1_S4 auto ; Weird Rotation
idle property AP_ReverseCowgirl_A1_S5 auto ; Weird Rotation

; Actor 2 (Male)
idle property AP_Cowgirl_A2_S1 auto
idle property AP_Cowgirl_A2_S2 auto
idle property AP_Cowgirl_A2_S3 auto
idle property AP_Cowgirl_A2_S4 auto

function LoadAnimation()
	name = "AP Reverse Cowgirl"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, 0, addCum=Anal)
	AddPositionStage(a1, AP_ReverseCowgirl_A1_S1)
	AddPositionStage(a1, AP_ReverseCowgirl_A1_S2)
	AddPositionStage(a1, AP_ReverseCowgirl_A1_S3)
	AddPositionStage(a1, AP_ReverseCowgirl_A1_S4)
	AddPositionStage(a1, AP_ReverseCowgirl_A1_S5)

	int a2 = AddPosition(Male, 44, rotation=180.0)
	AddPositionStage(a2, AP_Cowgirl_A2_S1)
	AddPositionStage(a2, AP_Cowgirl_A2_S2)
	AddPositionStage(a2, AP_Cowgirl_A2_S2)
	AddPositionStage(a2, AP_Cowgirl_A2_S3)
	AddPositionStage(a2, AP_Cowgirl_A2_S4)

	AddTag("AP")
	AddTag("Sex")
	AddTag("Straight")
	AddTag("Cowgirl")
	AddTag("MF")
	AddTag("Anal")
	AddTag("Dirty")
endFunction