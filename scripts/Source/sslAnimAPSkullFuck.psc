scriptname sslAnimAPSkullFuck extends sslBaseAnimation

; Actor 1 (Female)
idle property AP_SkullFuck_A1_S1 auto
idle property AP_SkullFuck_A1_S2 auto
idle property AP_SkullFuck_A1_S3 auto
idle property AP_SkullFuck_A1_S4 auto
idle property AP_SkullFuck_A1_S5 auto

; Actor 2 (Male)
idle property AP_SkullFuck_A2_S1 auto
idle property AP_SkullFuck_A2_S2 auto
idle property AP_SkullFuck_A2_S3 auto
idle property AP_SkullFuck_A2_S4 auto
idle property AP_SkullFuck_A2_S5 auto

function LoadAnimation()
	name = "AP Skull Fuck"

	SetContent(Sexual)
	SetSFX(Oral)

	int a1 = AddPosition(Female, 0, addCum=Oral)
	AddPositionStage(a1, AP_SkullFuck_A1_S1)
	AddPositionStage(a1, AP_SkullFuck_A1_S2)
	AddPositionStage(a1, AP_SkullFuck_A1_S3)
	AddPositionStage(a1, AP_SkullFuck_A1_S4)
	AddPositionStage(a1, AP_SkullFuck_A1_S5)

	int a2 = AddPosition(Male, 50, rotation=180.0)
	AddPositionStage(a2, AP_SkullFuck_A2_S1)
	AddPositionStage(a2, AP_SkullFuck_A2_S2)
	AddPositionStage(a2, AP_SkullFuck_A2_S3)
	AddPositionStage(a2, AP_SkullFuck_A2_S4)
	AddPositionStage(a2, AP_SkullFuck_A2_S5)

	AddTag("AP")
	AddTag("Sex")
	AddTag("MF")
	AddTag("Straight")
	AddTag("Aggressive")
	AddTag("Blowjob")
	AddTag("Oral")
endFunction