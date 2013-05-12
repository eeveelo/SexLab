scriptname sslAnimArrokBlowjob extends sslBaseAnimation

; Actor 1 (Female)
idle property Arrok_Blowjob_A1_S1 auto
idle property Arrok_Blowjob_A1_S2 auto
idle property Arrok_Blowjob_A1_S3 auto
; Actor 2 (Male)
idle property Arrok_Blowjob_A2_S1 auto
idle property Arrok_Blowjob_A2_S2 auto
idle property Arrok_Blowjob_A2_S3 auto

function LoadAnimation()
	name = "Arrok Blowjob"

	SetContent(Sexual)
	SetSFX(Sucking)

	int a1 = AddPosition(Female, 0, noVoice=true, addCum=Oral)
	AddPositionStage(a1, Arrok_Blowjob_A1_S1)
	AddPositionStage(a1, Arrok_Blowjob_A1_S2)
	AddPositionStage(a1, Arrok_Blowjob_A1_S2)
	AddPositionStage(a1, Arrok_Blowjob_A1_S3)

	int a2 = AddPosition(Male, -120)
	AddPositionStage(a2, Arrok_Blowjob_A2_S1)
	AddPositionStage(a2, Arrok_Blowjob_A2_S2)
	AddPositionStage(a2, Arrok_Blowjob_A2_S2)
	AddPositionStage(a2, Arrok_Blowjob_A2_S3)

	AddTag("Arrok")
	AddTag("BBP")
	AddTag("Sex")
	AddTag("MF")
	AddTag("Oral")
	AddTag("Dirty")
	AddTag("Blowjob")
endFunction