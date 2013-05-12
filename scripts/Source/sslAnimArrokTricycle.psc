scriptname sslAnimArrokTricycle extends sslBaseAnimation

idle property Arrok_Tricycle_A1_S1 auto
idle property Arrok_Tricycle_A1_S2 auto
idle property Arrok_Tricycle_A1_S3 auto
idle property Arrok_Tricycle_A1_S4 auto

idle property Arrok_Tricycle_A2_S1 auto
idle property Arrok_Tricycle_A2_S2 auto
idle property Arrok_Tricycle_A2_S3 auto
idle property Arrok_Tricycle_A2_S4 auto

idle property Arrok_Tricycle_A3_S1 auto
idle property Arrok_Tricycle_A3_S2 auto
idle property Arrok_Tricycle_A3_S3 auto
idle property Arrok_Tricycle_A3_S4 auto

function LoadAnimation()
	name = "Arrok Tricycle"

	SetContent(Sexual)
	SetSFX(SexMix)

	int a1 = AddPosition(Female, 0, addCum=Oral)
	AddPositionStage(a1, Arrok_Tricycle_A1_S1)
	AddPositionStage(a1, Arrok_Tricycle_A1_S2)
	AddPositionStage(a1, Arrok_Tricycle_A1_S3)
	AddPositionStage(a1, Arrok_Tricycle_A1_S4)

	int a2 = AddPosition(Female, -100, addCum=Oral)
	AddPositionStage(a2, Arrok_Tricycle_A2_S1)
	AddPositionStage(a2, Arrok_Tricycle_A2_S2)
	AddPositionStage(a2, Arrok_Tricycle_A2_S3)
	AddPositionStage(a2, Arrok_Tricycle_A2_S4)

	int a3 = AddPosition(Male, 108)
	AddPositionStage(a3, Arrok_Tricycle_A3_S1)
	AddPositionStage(a3, Arrok_Tricycle_A3_S2)
	AddPositionStage(a3, Arrok_Tricycle_A3_S3)
	AddPositionStage(a3, Arrok_Tricycle_A3_S4)

	AddTag("Sex")
	AddTag("Arrok")
	AddTag("BBP")
	AddTag("MFF")
	AddTag("Tricycle")
	AddTag("Threeway")
	AddTag("Blowjob")
	AddTag("Oral")
	AddTag("Cunnilingus")
	AddTag("Orgy")
	AddTag("Vaginal")
	AddTag("Dirty")
endFunction