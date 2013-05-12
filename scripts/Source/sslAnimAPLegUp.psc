scriptname sslAnimAPLegUp extends sslBaseAnimation

; Actor 1 (Female)
idle property AP_LegUp_A1_S1 auto
idle property AP_LegUp_A1_S2 auto
idle property AP_LegUp_A1_S3 auto
idle property AP_LegUp_A1_S4 auto
idle property AP_LegUp_A1_S5 auto
; Actor 2 (Male)
idle property AP_LegUp_A2_S1 auto
idle property AP_LegUp_A2_S2 auto
idle property AP_LegUp_A2_S3 auto
idle property AP_LegUp_A2_S4 auto
idle property AP_LegUp_A2_S5 auto

function LoadAnimation()
	name = "AP Leg Up Fuck"
	
	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, 0, addCum=Vaginal)
	AddPositionStage(a1, AP_LegUp_A1_S1)
	AddPositionStage(a1, AP_LegUp_A1_S2)
	AddPositionStage(a1, AP_LegUp_A1_S3)
	AddPositionStage(a1, AP_LegUp_A1_S4)
	AddPositionStage(a1, AP_LegUp_A1_S5)

	int a2 = AddPosition(Male, 44, rotation=180.0)
	AddPositionStage(a2, AP_LegUp_A2_S1)
	AddPositionStage(a2, AP_LegUp_A2_S2)
	AddPositionStage(a2, AP_LegUp_A2_S3)
	AddPositionStage(a2, AP_LegUp_A2_S4)
	AddPositionStage(a2, AP_LegUp_A2_S5)

	AddTag("AP")
	AddTag("MF")
	AddTag("Dirty")
	AddTag("Laying")
	AddTag("Aggressive")
	AddTag("Vaginal")
endFunction