scriptname sslAnimArrokOral extends sslBaseAnimation

; Actor 1 (Female)
idle property Arrok_Oral_A1_S1 auto
idle property Arrok_Oral_A1_S2 auto
idle property Arrok_Oral_A1_S3 auto
idle property Arrok_Oral_A1_S4 auto

; Actor 2 (Male)
idle property Arrok_Oral_A2_S1 auto
idle property Arrok_Oral_A2_S2 auto
idle property Arrok_Oral_A2_S3 auto

function LoadAnimation()
	name = "Arrok 69"

	SetContent(Sexual)
	SetSFX(Sucking)

	int a1 = AddPosition(Female, 0, addCum=Oral)
	AddPositionStage(a1, Arrok_Oral_A1_S1)
	AddPositionStage(a1, Arrok_Oral_A1_S2)
	AddPositionStage(a1, Arrok_Oral_A1_S3)
	AddPositionStage(a1, Arrok_Oral_A1_S3)
	AddPositionStage(a1, Arrok_Oral_A1_S4)

	int a2 = AddPosition(Male, 45, rotation=180.0, noVoice=true)
	AddPositionStage(a2, Arrok_Oral_A2_S1)
	AddPositionStage(a2, Arrok_Oral_A2_S1)
	AddPositionStage(a2, Arrok_Oral_A2_S2)
	AddPositionStage(a2, Arrok_Oral_A2_S3)
	AddPositionStage(a2, Arrok_Oral_A2_S3)

	AddTag("Arrok")
	AddTag("BBP")
	AddTag("Sex")
	AddTag("MF")
	AddTag("Oral")
	AddTag("Cunnilingus")
	AddTag("Blowjob")
	AddTag("69")
endFunction