scriptname sslAnimationDefaults extends sslAnimationFactory

function LoadAnimations()
	; Prepare factory resources (as non creature)
	PrepareFactory()
	; Missionary
	RegisterAnimation("SexLabMissionary")
	RegisterAnimation("SexLabAggrMissionary")
	RegisterAnimation("ArrokMissionary")
	RegisterAnimation("ArrokLegUp")
	RegisterAnimation("ZynMissionary")
	RegisterAnimation("APBedMissionary")
	RegisterAnimation("APHoldLegUp")
	RegisterAnimation("APLegUp")
	; Doggystyle
	RegisterAnimation("SexLabDoggyStyle")
	RegisterAnimation("SexLabAggrBehind")
	RegisterAnimation("SexLabAggrDoggyStyle")
	RegisterAnimation("ArrokDoggyStyle")
	RegisterAnimation("ArrokRape")
	RegisterAnimation("ZynDoggystyle")
	RegisterAnimation("DarkInvestigationsDoggystyle")
	RegisterAnimation("APDoggyStyle")
	; Cowgirl
	RegisterAnimation("SexLabReverseCowgirl")
	RegisterAnimation("ArrokCowgirl")
	RegisterAnimation("ArrokReverseCowgirl")
	RegisterAnimation("APCowgirl")
	; Sideways
	RegisterAnimation("SexLabSideways")
	RegisterAnimation("ArrokSideways")
	RegisterAnimation("APShoulder")
	; Standing
	RegisterAnimation("SexLabHuggingSex")
	RegisterAnimation("SexLabStanding")
	RegisterAnimation("ArrokHugFuck")
	RegisterAnimation("ArrokStanding")
	RegisterAnimation("APStanding")
	RegisterAnimation("ZynRoughStanding")
	; Anal
	RegisterAnimation("ArrokAnal")
	RegisterAnimation("APAnal")
	RegisterAnimation("APFaceDown")
	; Oral
	RegisterAnimation("ArrokBlowjob")
	RegisterAnimation("ArrokOral")
	RegisterAnimation("ArrokLedgeBlowjob")
	RegisterAnimation("DarkInvestigationsBlowjob")
	RegisterAnimation("APBlowjob")
	RegisterAnimation("APKneelBlowjob")
	RegisterAnimation("APStandBlowjob")
	RegisterAnimation("APHandjob")
	RegisterAnimation("APSkullFuck")
	; Boobjob
	RegisterAnimation("SexLabBoobjob")
	RegisterAnimation("ArrokBoobjob")
	RegisterAnimation("APBoobjob")
	; Foreplay
	RegisterAnimation("ArrokForeplay")
	RegisterAnimation("ArrokSittingForeplay")
	RegisterAnimation("ArrokStandingForeplay")
	; Footjob
	RegisterAnimation("BleaghFootJob")
	; Solo
	RegisterAnimation("BleaghFemaleSolo")
	RegisterAnimation("APFemaleSolo")
	RegisterAnimation("ArrokMaleMasturbation")
	; Gay/Lesbian
	RegisterAnimation("SexLabTribadism")
	RegisterAnimation("ArrokLesbian")
	RegisterAnimation("ZynLesbian")
	RegisterAnimation("ZynLicking")
	; Misc
	RegisterAnimation("APFisting")
	; 3P+
	RegisterAnimation("ArrokDevilsThreeway")
	RegisterAnimation("ArrokTricycle")
	RegisterAnimation("ZynDoublePenetration")
	RegisterAnimation("ZynFemdom")
	RegisterAnimation("ZynFourWay")
	RegisterAnimation("DarkInvestigationsThreesome")
	; TEMP
	;/ RegisterAnimation("ExtraTMP1")
	RegisterAnimation("ExtraTMP2")
	RegisterAnimation("ExtraTMP3")
	RegisterAnimation("ExtraTMP4")
	RegisterAnimation("ExtraTMP5")
	RegisterAnimation("ExtraTMP6")
	RegisterAnimation("ExtraTMP7")
	RegisterAnimation("ExtraTMP8")
	RegisterAnimation("ExtraTMP9")
	RegisterAnimation("ExtraTMP10")
	RegisterAnimation("ExtraTMP11")
	RegisterAnimation("ExtraTMP12")
	RegisterAnimation("ExtraTMP13")
	RegisterAnimation("ExtraTMP14")
	RegisterAnimation("ExtraTMP15")
	RegisterAnimation("ExtraTMP16")
	RegisterAnimation("ExtraTMP17")
	RegisterAnimation("ExtraTMP18")
	RegisterAnimation("ExtraTMP19")
	RegisterAnimation("ExtraTMP20")
	RegisterAnimation("ExtraTMP21")
	RegisterAnimation("ExtraTMP22")
	RegisterAnimation("ExtraTMP23")
	RegisterAnimation("ExtraTMP24")
	RegisterAnimation("ExtraTMP25")
	RegisterAnimation("ExtraTMP26")
	RegisterAnimation("ExtraTMP27")
	RegisterAnimation("ExtraTMP28")
	RegisterAnimation("ExtraTMP29")
	RegisterAnimation("ExtraTMP30")
	RegisterAnimation("ExtraTMP31")
	RegisterAnimation("ExtraTMP32")
	RegisterAnimation("ExtraTMP33")
	RegisterAnimation("ExtraTMP34")
	RegisterAnimation("ExtraTMP35")
	RegisterAnimation("ExtraTMP36")
	RegisterAnimation("ExtraTMP37")
	RegisterAnimation("ExtraTMP38")
	RegisterAnimation("ExtraTMP39")
	RegisterAnimation("ExtraTMP40")
	RegisterAnimation("ExtraTMP41")
	RegisterAnimation("ExtraTMP42")
	RegisterAnimation("ExtraTMP43")
	RegisterAnimation("ExtraTMP44")
	RegisterAnimation("ExtraTMP45")
	RegisterAnimation("ExtraTMP46")
	RegisterAnimation("ExtraTMP47")
	RegisterAnimation("ExtraTMP48")
	RegisterAnimation("ExtraTMP49")
	RegisterAnimation("ExtraTMP50")
	RegisterAnimation("ExtraTMP51")
	RegisterAnimation("ExtraTMP52")
	RegisterAnimation("ExtraTMP53")
	RegisterAnimation("ExtraTMP54")
	RegisterAnimation("ExtraTMP55")
	RegisterAnimation("ExtraTMP56")
	RegisterAnimation("ExtraTMP57")
	RegisterAnimation("ExtraTMP58")
	RegisterAnimation("ExtraTMP59")
	RegisterAnimation("ExtraTMP60")
	RegisterAnimation("ExtraTMP61")
	RegisterAnimation("ExtraTMP62")
	RegisterAnimation("ExtraTMP63")
	RegisterAnimation("ExtraTMP64")
	RegisterAnimation("ExtraTMP65")
	RegisterAnimation("ExtraTMP66")
	RegisterAnimation("ExtraTMP67")
	RegisterAnimation("ExtraTMP68")
	RegisterAnimation("ExtraTMP69")
	RegisterAnimation("ExtraTMP70")
	RegisterAnimation("ExtraTMP71")
	RegisterAnimation("ExtraTMP72")
	RegisterAnimation("ExtraTMP73")
	RegisterAnimation("ExtraTMP74")
	RegisterAnimation("ExtraTMP75")
	RegisterAnimation("ExtraTMP76")
	RegisterAnimation("ExtraTMP77")
	RegisterAnimation("ExtraTMP78")
	RegisterAnimation("ExtraTMP79")
	RegisterAnimation("ExtraTMP80")
	RegisterAnimation("ExtraTMP81")
	RegisterAnimation("ExtraTMP82")
	RegisterAnimation("ExtraTMP83")
	RegisterAnimation("ExtraTMP84")
	RegisterAnimation("ExtraTMP85")
	RegisterAnimation("ExtraTMP86")
	RegisterAnimation("ExtraTMP87")
	RegisterAnimation("ExtraTMP88")
	RegisterAnimation("ExtraTMP89")
	RegisterAnimation("ExtraTMP90")
	RegisterAnimation("ExtraTMP91") /;
endFunction

function ArrokBlowjob(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Arrok Blowjob"
	Base.SoundFX = Sucking

	int a1 = Base.AddPosition(Female, Oral)
	Base.AddPositionStage(a1, "Arrok_Blowjob_A1_S1", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Arrok_Blowjob_A1_S2", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Arrok_Blowjob_A1_S2", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Arrok_Blowjob_A1_S3", 0, silent = true, openMouth = true)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Arrok_Blowjob_A2_S1", -120, side = -3.5, sos = -1)
	Base.AddPositionStage(a2, "Arrok_Blowjob_A2_S2", -120, side = -3.5, sos = -1)
	Base.AddPositionStage(a2, "Arrok_Blowjob_A2_S2", -120, side = -3.5, sos = 1)
	Base.AddPositionStage(a2, "Arrok_Blowjob_A2_S3", -120, side = -3.5, sos = 2)

	Base.AddTag("Arrok")
	Base.AddTag("BBP")
	Base.AddTag("Sex")
	Base.AddTag("Oral")
	Base.AddTag("Dirty")
	Base.AddTag("Blowjob")
	Base.AddTag("LeadIn")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function ArrokBoobjob(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Arrok Boobjob"


	int a1 = Base.AddPosition(Female, Oral)
	Base.AddPositionStage(a1, "Arrok_Boobjob_A1_S1", 0)
	Base.AddPositionStage(a1, "Arrok_Boobjob_A1_S2", 0)
	Base.AddPositionStage(a1, "Arrok_Boobjob_A1_S3", 0)
	Base.AddPositionStage(a1, "Arrok_Boobjob_A1_S4", 0, silent = true, openMouth = true)

	int a2 = Base.AddPosition(Male) ; 102
	Base.AddPositionStage(a2, "Arrok_Boobjob_A2_S1", -119, sos = 2)
	Base.AddPositionStage(a2, "Arrok_Boobjob_A2_S2", -119, sos = 3)
	Base.AddPositionStage(a2, "Arrok_Boobjob_A2_S3", -119, sos = -2)
	Base.AddPositionStage(a2, "Arrok_Boobjob_A2_S4", -119, sos = -2)

	Base.AddTag("Arrok")
	Base.AddTag("BBP")
	Base.AddTag("Sex")
	Base.AddTag("Dirty")
	Base.AddTag("Boobjob")
	Base.AddTag("Breast")
	Base.AddTag("LeadIn")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function ArrokCowgirl(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Arrok Cowgirl"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Arrok_Cowgirl_A1_S1", 0)
	Base.AddPositionStage(a1, "Arrok_Cowgirl_A1_S2", 0)
	Base.AddPositionStage(a1, "Arrok_Cowgirl_A1_S3", 0)
	Base.AddPositionStage(a1, "Arrok_Cowgirl_A1_S4", 0)
	Base.AddPositionStage(a1, "Arrok_Cowgirl_A1_S5", 0)
	Base.AddPositionStage(a1, "Arrok_Cowgirl_A1_S6", 0)
	Base.AddPositionStage(a1, "Arrok_Cowgirl_A1_S7", 0)
	Base.AddPositionStage(a1, "Arrok_Cowgirl_A1_S8", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Arrok_Cowgirl_A2_S1", 3.5)
	Base.AddPositionStage(a2, "Arrok_Cowgirl_A2_S2", 3.5)
	Base.AddPositionStage(a2, "Arrok_Cowgirl_A2_S3", 3.5)
	Base.AddPositionStage(a2, "Arrok_Cowgirl_A2_S4", 3.5)
	Base.AddPositionStage(a2, "Arrok_Cowgirl_A2_S5", 3.5)
	Base.AddPositionStage(a2, "Arrok_Cowgirl_A2_S6", 3.5)
	Base.AddPositionStage(a2, "Arrok_Cowgirl_A2_S7", 3.5)
	Base.AddPositionStage(a2, "Arrok_Cowgirl_A2_S8", 3.5)

	Base.AddTag("Arrok")
	Base.AddTag("BBP")
	Base.AddTag("Sex")
	Base.AddTag("Dirty")
	Base.AddTag("Cowgirl")
	Base.AddTag("Vaginal")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function ArrokDevilsThreeway(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Arrok Devils Threeway"
	Base.SoundFX = SexMix

	int a1 = Base.AddPosition(Female, VaginalOralAnal)
	Base.AddPositionStage(a1, "Arrok_DevilsThreeway_A1_S1", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Arrok_DevilsThreeway_A1_S2", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Arrok_DevilsThreeway_A1_S3", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Arrok_DevilsThreeway_A1_S4", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Arrok_DevilsThreeway_A2_S1", -105, side = -2, sos = -1)
	Base.AddPositionStage(a2, "Arrok_DevilsThreeway_A2_S2", -98, sos = 5)
	Base.AddPositionStage(a2, "Arrok_DevilsThreeway_A2_S3", -114, sos = 7)
	Base.AddPositionStage(a2, "Arrok_DevilsThreeway_A2_S4", -100, sos = 3)

	int a3 = Base.AddPosition(Male)
	Base.AddPositionStage(a3, "Arrok_DevilsThreeway_A3_S1", 105, sos = -3)
	Base.AddPositionStage(a3, "Arrok_DevilsThreeway_A3_S2", 100, sos = 9)
	Base.AddPositionStage(a3, "Arrok_DevilsThreeway_A3_S3", 120, sos = -3)
	Base.AddPositionStage(a3, "Arrok_DevilsThreeway_A3_S4", 100, sos = -3)

	Base.AddTag("Sex")
	Base.AddTag("Arrok")
	Base.AddTag("BBP")
	Base.AddTag("MMF")
	Base.AddTag("Doggy")
	Base.AddTag("Blowjob")
	Base.AddTag("Oral")
	Base.AddTag("Orgy")
	Base.AddTag("Vaginal")
	Base.AddTag("Dirty")

	Base.Save(id)
endFunction

function ArrokDoggyStyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Arrok DoggyStyle"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Arrok_DoggyStyle_A1_S1", 0)
	Base.AddPositionStage(a1, "Arrok_DoggyStyle_A1_S2", 0)
	Base.AddPositionStage(a1, "Arrok_DoggyStyle_A1_S3", 0)
	Base.AddPositionStage(a1, "Arrok_DoggyStyle_A1_S4", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Arrok_DoggyStyle_A2_S1", -100, sos = -2)
	Base.AddPositionStage(a2, "Arrok_DoggyStyle_A2_S2", -100, sos = -2)
	Base.AddPositionStage(a2, "Arrok_DoggyStyle_A2_S3", -100, sos = -2)
	Base.AddPositionStage(a2, "Arrok_DoggyStyle_A2_S4", -100, sos = -2)

	Base.AddTag("Arrok")
	Base.AddTag("BBP")
	Base.AddTag("Sex")
	Base.AddTag("Doggy Style")
	Base.AddTag("Anal")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function ArrokForeplay(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Arrok Foreplay"


	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "Arrok_Foreplay_A1_S1", 0)
	Base.AddPositionStage(a1, "Arrok_Foreplay_A1_S2", 0)
	Base.AddPositionStage(a1, "Arrok_Foreplay_A1_S3", 0)
	Base.AddPositionStage(a1, "Arrok_Foreplay_A1_S4", 0)

	int a2 = Base.AddPosition(Male) ; -104
	Base.AddPositionStage(a2, "Arrok_Foreplay_A2_S1", 0, strapon = false, sos = 0)
	Base.AddPositionStage(a2, "Arrok_Foreplay_A2_S2", 0, strapon = false, sos = 0)
	Base.AddPositionStage(a2, "Arrok_Foreplay_A2_S3", 0, strapon = false, sos = 5)
	Base.AddPositionStage(a2, "Arrok_Foreplay_A2_S4", 0, strapon = false, sos = 5)

	Base.AddTag("Arrok")
	Base.AddTag("BBP")
	Base.AddTag("Foreplay")
	Base.AddTag("Laying")
	Base.AddTag("Loving")
	Base.AddTag("Cuddling")
	Base.AddTag("LeadIn")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function ArrokLegUp(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Arrok Leg Up Fuck"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Arrok_LegUp_A1_S1", 0)
	Base.AddPositionStage(a1, "Arrok_LegUp_A1_S2", 0)
	Base.AddPositionStage(a1, "Arrok_LegUp_A1_S3", 0)
	Base.AddPositionStage(a1, "Arrok_LegUp_A1_S4", 0)
	Base.AddPositionStage(a1, "Arrok_LegUp_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Arrok_LegUp_A2_S1", 44, rotate = 180, sos = 2)
	Base.AddPositionStage(a2, "Arrok_LegUp_A2_S2", 44, rotate = 180, sos = 2)
	Base.AddPositionStage(a2, "Arrok_LegUp_A2_S3", 44, rotate = 180, sos = 2)
	Base.AddPositionStage(a2, "Arrok_LegUp_A2_S4", 44, rotate = 180, sos = 4)
	Base.AddPositionStage(a2, "Arrok_LegUp_A2_S5", 44, rotate = 180, sos = 3)

	Base.AddTag("Arrok")
	Base.AddTag("BBP")
	Base.AddTag("Dirty")
	Base.AddTag("Laying")
	Base.AddTag("Aggressive")
	Base.AddTAg("AggressiveDefault")
	Base.AddTag("Vaginal")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function ArrokMaleMasturbation(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Arrok Male Masturbation"


	int a1 = Base.AddPosition(Male)
	Base.AddPositionStage(a1, "Arrok_MaleMasturbation_A1_S1", 0, sos = 3)
	Base.AddPositionStage(a1, "Arrok_MaleMasturbation_A1_S2", 0, sos = 3)
	Base.AddPositionStage(a1, "Arrok_MaleMasturbation_A1_S3", 0, sos = 3)
	Base.AddPositionStage(a1, "Arrok_MaleMasturbation_A1_S4", 0, sos = 3)

	Base.AddTag("Sex")
	Base.AddTag("Solo")
	Base.AddTag("Masturbation")
	Base.AddTag("Standing")
	Base.AddTag("Dirty")

	Base.Save(id)
endFunction

function ArrokMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Arrok Missionary"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "Arrok_Missionary_A1_S1", 0)
	Base.AddPositionStage(a1, "Arrok_Missionary_A1_S2", 0)
	Base.AddPositionStage(a1, "Arrok_Missionary_A1_S3", 0)
	Base.AddPositionStage(a1, "Arrok_Missionary_A1_S4", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Arrok_Missionary_A2_S1", -105)
	Base.AddPositionStage(a2, "Arrok_Missionary_A2_S2", -105)
	Base.AddPositionStage(a2, "Arrok_Missionary_A2_S3", -105, sos = 3)
	Base.AddPositionStage(a2, "Arrok_Missionary_A2_S4", -107, sos = 7)

	Base.AddTag("Arrok")
	Base.AddTag("BBP")
	Base.AddTag("Sex")
	Base.AddTag("Missionary")
	Base.AddTag("Laying")
	Base.AddTag("Vaginal")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function ArrokOral(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Arrok 69"
	Base.SoundFX = SexMix

	int a1 = Base.AddPosition(Female, Oral)
	Base.AddPositionStage(a1, "Arrok_Oral_A1_S1", 0)
	Base.AddPositionStage(a1, "Arrok_Oral_A1_S2", 0)
	Base.AddPositionStage(a1, "Arrok_Oral_A1_S3", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Arrok_Oral_A1_S3", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Arrok_Oral_A1_S4", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Arrok_Oral_A2_S1", 46, rotate = 180, silent = true)
	Base.AddPositionStage(a2, "Arrok_Oral_A2_S1", 46, rotate = 180, silent = true)
	Base.AddPositionStage(a2, "Arrok_Oral_A2_S2", 46, rotate = 180, silent = true)
	Base.AddPositionStage(a2, "Arrok_Oral_A2_S3", 46, rotate = 180, silent = true)
	Base.AddPositionStage(a2, "Arrok_Oral_A2_S3", 46, rotate = 180, silent = true)

	Base.AddTag("Arrok")
	Base.AddTag("BBP")
	Base.AddTag("Sex")
	Base.AddTag("Oral")
	Base.AddTag("Cunnilingus")
	Base.AddTag("Blowjob")
	Base.AddTag("69")
	Base.AddTag("MF")

	Base.Save(id)
endFunction



function ArrokReverseCowgirl(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Arrok Reverse Cowgirl"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Arrok_ReverseCowgirl_A1_S1", 0)
	Base.AddPositionStage(a1, "Arrok_ReverseCowgirl_A1_S2", 0)
	Base.AddPositionStage(a1, "Arrok_ReverseCowgirl_A1_S3", 0)
	Base.AddPositionStage(a1, "Arrok_ReverseCowgirl_A1_S4", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Arrok_ReverseCowgirl_A2_S1", -105, sos = 5)
	Base.AddPositionStage(a2, "Arrok_ReverseCowgirl_A2_S2", -105, sos = 5)
	Base.AddPositionStage(a2, "Arrok_ReverseCowgirl_A2_S3", -105, sos = 8)
	Base.AddPositionStage(a2, "Arrok_ReverseCowgirl_A2_S4", -105, sos = 8)

	Base.AddTag("Arrok")
	Base.AddTag("BBP")
	Base.AddTag("Sex")
	Base.AddTag("Dirty")
	Base.AddTag("Cowgirl")
	Base.AddTag("Anal")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function ArrokSideways(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Arrok Sideways Fuck"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Arrok_Sideways_A1_S1", 0)
	Base.AddPositionStage(a1, "Arrok_Sideways_A1_S2", 0)
	Base.AddPositionStage(a1, "Arrok_Sideways_A1_S3", 0)
	Base.AddPositionStage(a1, "Arrok_Sideways_A1_S4", 0)

	int a2 = Base.AddPosition(Male) ; -100
	Base.AddPositionStage(a2, "Arrok_Sideways_A2_S1", -118.5, sos = 8)
	Base.AddPositionStage(a2, "Arrok_Sideways_A2_S2", -118.5, sos = 8)
	Base.AddPositionStage(a2, "Arrok_Sideways_A2_S3", -118.5, sos = 6)
	Base.AddPositionStage(a2, "Arrok_Sideways_A2_S4", -118.5, sos = 5)

	Base.AddTag("Arrok")
	Base.AddTag("BBP")
	Base.AddTag("Sex")
	Base.AddTag("Standing")
	Base.AddTag("Sideways")
	Base.AddTag("Dirty")
	Base.AddTag("Vaginal")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function ArrokStanding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Arrok Standing Fuck"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Arrok_Standing_A1_S1", 0)
	Base.AddPositionStage(a1, "Arrok_Standing_A1_S2", 0)
	Base.AddPositionStage(a1, "Arrok_Standing_A1_S3", 0)
	Base.AddPositionStage(a1, "Arrok_Standing_A1_S4", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Arrok_Standing_A2_S1", -104, sos = 9)
	Base.AddPositionStage(a2, "Arrok_Standing_A2_S2", -104, sos = 6)
	Base.AddPositionStage(a2, "Arrok_Standing_A2_S3", -104, sos = -7)
	Base.AddPositionStage(a2, "Arrok_Standing_A2_S4", -104, sos = 7)

	Base.AddTag("Arrok")
	Base.AddTag("BBP")
	Base.AddTag("Sex")
	Base.AddTag("Standing")
	Base.AddTag("Dirty")
	Base.AddTag("Vaginal")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function ArrokStandingForeplay(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Arrok Standing Foreplay"


	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "Arrok_StandingForeplay_A1_S1", 0, silent = true)
	Base.AddPositionStage(a1, "Arrok_StandingForeplay_A1_S2", 0, silent = true)
	Base.AddPositionStage(a1, "Arrok_StandingForeplay_A1_S3", 0)
	Base.AddPositionStage(a1, "Arrok_StandingForeplay_A1_S4", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Arrok_StandingForeplay_A2_S1", 0, silent = true, strapon = false, sos = -1)
	Base.AddPositionStage(a2, "Arrok_StandingForeplay_A2_S2", 0, silent = true, strapon = false, sos = -1)
	Base.AddPositionStage(a2, "Arrok_StandingForeplay_A2_S3", 0, silent = true, strapon = false, sos = 5)
	Base.AddPositionStage(a2, "Arrok_StandingForeplay_A2_S4", 0, silent = true, strapon = false, sos = 5)

	Base.AddTag("Arrok")
	Base.AddTag("BBP")
	Base.AddTag("Foreplay")
	Base.AddTag("Standing")
	Base.AddTag("Loving")
	Base.AddTag("Kissing")
	Base.AddTag("LeadIn")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function ArrokTricycle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Arrok Tricycle"
	Base.SoundFX = SexMix

	int a1 = Base.AddPosition(Female, Oral)
	Base.AddPositionStage(a1, "Arrok_Tricycle_A1_S1", -1, up = 2, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Arrok_Tricycle_A1_S2", 0)
	Base.AddPositionStage(a1, "Arrok_Tricycle_A1_S3", 0)
	Base.AddPositionStage(a1, "Arrok_Tricycle_A1_S4", 1, side = 2.5, up = 3, silent = true, openMouth = true)

	int a2 = Base.AddPosition(Female, Oral)
	Base.AddPositionStage(a2, "Arrok_Tricycle_A2_S1", -100)
	Base.AddPositionStage(a2, "Arrok_Tricycle_A2_S2", -100)
	Base.AddPositionStage(a2, "Arrok_Tricycle_A2_S3", -100.5, silent = true, openMouth = true)
	Base.AddPositionStage(a2, "Arrok_Tricycle_A2_S4", -100, side = -1, up = 2, silent = true, openMouth = true)

	int a3 = Base.AddPosition(Male)
	Base.AddPositionStage(a3, "Arrok_Tricycle_A3_S1", 108, sos = -2)
	Base.AddPositionStage(a3, "Arrok_Tricycle_A3_S2", 108, silent = true, openMouth = true, sos = 5)
	Base.AddPositionStage(a3, "Arrok_Tricycle_A3_S3", 108, sos = -1)
	Base.AddPositionStage(a3, "Arrok_Tricycle_A3_S4", 108, sos = -3)

	Base.AddTag("Sex")
	Base.AddTag("Arrok")
	Base.AddTag("BBP")
	Base.AddTag("Tricycle")
	Base.AddTag("Threeway")
	Base.AddTag("Blowjob")
	Base.AddTag("Oral")
	Base.AddTag("Cunnilingus")
	Base.AddTag("Orgy")
	Base.AddTag("Vaginal")
	Base.AddTag("Dirty")
	Base.AddTag("MFF")

	Base.Save(id)
endFunction

function ArrokHugFuck(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Arrok HugFuck"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "Arrok_Hugfuck_A1_S1", 0)
	Base.AddPositionStage(a1, "Arrok_Hugfuck_A1_S2", 0)
	Base.AddPositionStage(a1, "Arrok_Hugfuck_A1_S3", 0)
	Base.AddPositionStage(a1, "Arrok_Hugfuck_A1_S4", 0)

	int a2 = Base.AddPosition(Male) ; -99
	Base.AddPositionStage(a2, "Arrok_Hugfuck_A2_S1", -103.5, sos = 9)
	Base.AddPositionStage(a2, "Arrok_Hugfuck_A2_S2", -103.5, sos = 9)
	Base.AddPositionStage(a2, "Arrok_Hugfuck_A2_S3", -103.5, sos = 9)
	Base.AddPositionStage(a2, "Arrok_Hugfuck_A2_S4", -103.5, sos = 9)

	Base.AddTag("Arrok")
	Base.AddTag("BBP")
	Base.AddTag("Sex")
	Base.AddTag("Hugging")
	Base.AddTag("Loving")
	Base.AddTag("Vaginal")
	Base.AddTag("Standing")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function ArrokLesbian(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Arrok Lesbian"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "Arrok_Lesbian_A1_S1", 0)
	Base.AddPositionStage(a1, "Arrok_Lesbian_A1_S2", 0)
	Base.AddPositionStage(a1, "Arrok_Lesbian_A1_S3", 0)
	Base.AddPositionStage(a1, "Arrok_Lesbian_A1_S4", 0)

	int a2 = Base.AddPosition(Female)
	Base.AddPositionStage(a2, "Arrok_Lesbian_A2_S1", -100)
	Base.AddPositionStage(a2, "Arrok_Lesbian_A2_S2", -100)
	Base.AddPositionStage(a2, "Arrok_Lesbian_A2_S3", -100)
	Base.AddPositionStage(a2, "Arrok_Lesbian_A2_S4", -100)

	Base.AddTag("Arrok")
	Base.AddTag("BBP")
	Base.AddTag("Sex")
	Base.AddTag("Lesbian")
	Base.AddTag("Oral")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function ArrokSittingForeplay(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Arrok Sitting Foreplay"


	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "Arrok_SittingForeplay_A1_S1", 0)
	Base.AddPositionStage(a1, "Arrok_SittingForeplay_A1_S2", 0)
	Base.AddPositionStage(a1, "Arrok_SittingForeplay_A1_S3", 0)
	Base.AddPositionStage(a1, "Arrok_SittingForeplay_A1_S4", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Arrok_SittingForeplay_A2_S1", 0, strapon = false)
	Base.AddPositionStage(a2, "Arrok_SittingForeplay_A2_S2", 0, strapon = false)
	Base.AddPositionStage(a2, "Arrok_SittingForeplay_A2_S3", 0, strapon = false)
	Base.AddPositionStage(a2, "Arrok_SittingForeplay_A2_S4", 0, strapon = false)

	Base.AddTag("Arrok")
	Base.AddTag("BBP")
	Base.AddTag("Kissing")
	Base.AddTag("Cuddling")
	Base.AddTag("Loving")
	Base.AddTag("Foreplay")
	Base.AddTag("LeadIn")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function ArrokAnal(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Arrok Anal"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Arrok_Anal_A1_S1", 0)
	Base.AddPositionStage(a1, "Arrok_Anal_A1_S2", 0)
	Base.AddPositionStage(a1, "Arrok_Anal_A1_S3", 0)
	Base.AddPositionStage(a1, "Arrok_Anal_A1_S4", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Arrok_Anal_A2_S1", -17, silent = true, openMouth = true)
	Base.AddPositionStage(a2, "Arrok_Anal_A2_S2", -8, sos = 3)
	Base.AddPositionStage(a2, "Arrok_Anal_A2_S3", -17, sos = 4)
	Base.AddPositionStage(a2, "Arrok_Anal_A2_S4", -17, sos = 3)

	Base.AddTag("Arrok")
	Base.AddTag("TBBP")
	Base.AddTag("Anal")
	Base.AddTag("Sex")
	Base.AddTag("Standing")
	Base.AddTag("Dirty")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function ArrokRape(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Arrok Rape"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, Oral)
	Base.AddPositionStage(a1, "Arrok_Rape_A1_S1", 0)
	Base.AddPositionStage(a1, "Arrok_Rape_A1_S2", 0)
	Base.AddPositionStage(a1, "Arrok_Rape_A1_S3", 0)
	Base.AddPositionStage(a1, "Arrok_Rape_A1_S4", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Arrok_Rape_A2_S1", -125)
	Base.AddPositionStage(a2, "Arrok_Rape_A2_S2", -125)
	Base.AddPositionStage(a2, "Arrok_Rape_A2_S3", -125, sos = 4)
	Base.AddPositionStage(a2, "Arrok_Rape_A2_S4", -125, up = 4)

	Base.AddTag("Arrok")
	Base.AddTag("TBBP")
	Base.AddTag("Anal")
	Base.AddTag("Sex")
	Base.AddTag("Aggressive")
	Base.AddTAg("AggressiveDefault")
	Base.AddTag("Dirty")
	Base.AddTag("Behind")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function ArrokLedgeBlowjob(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Arrok Bed Blowjob"
	Base.SoundFX = Sucking

	int a1 = Base.AddPosition(Female, Oral)
	Base.AddPositionStage(a1, "Arrok_LedgeBlowjob_A1_S1", 0)
	Base.AddPositionStage(a1, "Arrok_LedgeBlowjob_A1_S2", 0)
	Base.AddPositionStage(a1, "Arrok_LedgeBlowjob_A1_S3", 0)
	Base.AddPositionStage(a1, "Arrok_LedgeBlowjob_A1_S4", 0)
	Base.AddPositionStage(a1, "Arrok_LedgeBlowjob_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Arrok_LedgeBlowjob_A2_S1", 0, sos = 0)
	Base.AddPositionStage(a2, "Arrok_LedgeBlowjob_A2_S2", 0, sos = 0)
	Base.AddPositionStage(a2, "Arrok_LedgeBlowjob_A2_S3", 0, sos = 0)
	Base.AddPositionStage(a2, "Arrok_LedgeBlowjob_A2_S4", 0, sos = 0)
	Base.AddPositionStage(a2, "Arrok_LedgeBlowjob_A2_S5", 0, sos = 0)

	Base.SetBedOffsets(0, 0, 0, 0)

	Base.AddTag("Arrok")
	Base.AddTag("TBBP")
	Base.AddTag("Sex")
	Base.AddTag("Blowjob")
	Base.AddTag("Dirty")
	Base.AddTag("Oral")
	Base.AddTag("BedOnly")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function SexLabAggrBehind(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Rough Behind"
	Base.SoundFX = Squishing


	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "AggrBehind_A1_S1", 0)
	Base.AddPositionStage(a1, "AggrBehind_A1_S2", 0)
	Base.AddPositionStage(a1, "AggrBehind_A1_S3", 0)
	Base.AddPositionStage(a1, "AggrBehind_A1_S4", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AggrBehind_A2_S1", -12)
	Base.AddPositionStage(a2, "AggrBehind_A2_S2", -12)
	Base.AddPositionStage(a2, "AggrBehind_A2_S3", -12)
	Base.AddPositionStage(a2, "AggrBehind_A2_S4", -12)

	Base.AddTag("Default")
	Base.AddTag("Sex")
	Base.AddTag("Behind")
	Base.AddTag("Anal")
	Base.AddTag("Aggressive")
	Base.AddTAg("AggressiveDefault")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function SexLabAggrDoggyStyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Rough Doggy Style"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "AggrDoggyStyle_A1_S1", 0)
	Base.AddPositionStage(a1, "AggrDoggyStyle_A1_S2", 0)
	Base.AddPositionStage(a1, "AggrDoggyStyle_A1_S3", 0)
	Base.AddPositionStage(a1, "AggrDoggyStyle_A1_S4", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AggrDoggyStyle_A2_S1", -100, sos = 5)
	Base.AddPositionStage(a2, "AggrDoggyStyle_A2_S2", -100, sos = 5)
	Base.AddPositionStage(a2, "AggrDoggyStyle_A2_S3", -100, sos = 7)
	Base.AddPositionStage(a2, "AggrDoggyStyle_A2_S4", -100, sos = 5)

	Base.AddTag("Default")
	Base.AddTag("Sex")
	Base.AddTag("Doggystyle")
	Base.AddTag("Behind")
	Base.AddTag("Anal")
	Base.AddTag("Aggressive")
	Base.AddTAg("AggressiveDefault")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function SexLabAggrMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Rough Missionary"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "AggrMissionary_A1_S1", 0)
	Base.AddPositionStage(a1, "AggrMissionary_A1_S2", 0)
	Base.AddPositionStage(a1, "AggrMissionary_A1_S3", 0)
	Base.AddPositionStage(a1, "AggrMissionary_A1_S4", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AggrMissionary_A2_S1", -86, sos = 4)
	Base.AddPositionStage(a2, "AggrMissionary_A2_S2", -86, sos = 4)
	Base.AddPositionStage(a2, "AggrMissionary_A2_S3", -86, sos = 3)
	Base.AddPositionStage(a2, "AggrMissionary_A2_S4", -86, sos = 3)

	Base.AddTag("Default")
	Base.AddTag("Sex")
	Base.AddTag("Missionary")
	Base.AddTag("Laying")
	Base.AddTag("Vaginal")
	Base.AddTag("Aggressive")
	Base.AddTAg("AggressiveDefault")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function SexLabBoobjob(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Boobjob"


	int a1 = Base.AddPosition(Female, Oral)
	Base.AddPositionStage(a1, "Boobjob_A1_S1", 0)
	Base.AddPositionStage(a1, "Boobjob_A1_S2", 0)
	Base.AddPositionStage(a1, "Boobjob_A1_S3", 0)
	Base.AddPositionStage(a1, "Boobjob_A1_S4", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Boobjob_A2_S1", -102)
	Base.AddPositionStage(a2, "Boobjob_A2_S2", -102)
	Base.AddPositionStage(a2, "Boobjob_A2_S3", -102)
	Base.AddPositionStage(a2, "Boobjob_A2_S4", -102)

	Base.AddTag("Default")
	Base.AddTag("Sex")
	Base.AddTag("Boobjob")
	Base.AddTag("Dirty")
	Base.AddTag("Breast")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function SexLabDoggyStyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Doggy Style"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "DoggyStyle_A1_S1", 0)
	Base.AddPositionStage(a1, "DoggyStyle_A1_S2", 0)
	Base.AddPositionStage(a1, "DoggyStyle_A1_S3", 0)
	Base.AddPositionStage(a1, "DoggyStyle_A1_S4", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "DoggyStyle_A2_S1", -104, sos = 3)
	Base.AddPositionStage(a2, "DoggyStyle_A2_S2", -104, sos = 3)
	Base.AddPositionStage(a2, "DoggyStyle_A2_S3", -104, sos = 3)
	Base.AddPositionStage(a2, "DoggyStyle_A2_S4", -104, sos = 3)

	Base.AddTag("Default")
	Base.AddTag("Sex")
	Base.AddTag("Doggy Style")
	Base.AddTag("Vaginal")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function SexLabHuggingSex(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Hugging Fuck"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "HuggingSex_A1_S1", 0)
	Base.AddPositionStage(a1, "HuggingSex_A1_S2", 0)
	Base.AddPositionStage(a1, "HuggingSex_A1_S3", 0)
	Base.AddPositionStage(a1, "HuggingSex_A1_S4", 0)

	int a2 = Base.AddPosition(Male) ; -99
	Base.AddPositionStage(a2, "HuggingSex_A2_S1", -100, sos = 7)
	Base.AddPositionStage(a2, "HuggingSex_A2_S2", -100, sos = 7)
	Base.AddPositionStage(a2, "HuggingSex_A2_S3", -100, sos = 7)
	Base.AddPositionStage(a2, "HuggingSex_A2_S4", -100, sos = 7)

	Base.AddTag("Default")
	Base.AddTag("Sex")
	Base.AddTag("Hugging")
	Base.AddTag("Loving")
	Base.AddTag("Vaginal")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function SexLabMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Missionary"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "Missionary_A1_S1", 0)
	Base.AddPositionStage(a1, "Missionary_A1_S2", 0)
	Base.AddPositionStage(a1, "Missionary_A1_S3", 0)
	Base.AddPositionStage(a1, "Missionary_A1_S4", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Missionary_A2_S1", -100, sos = 2)
	Base.AddPositionStage(a2, "Missionary_A2_S2", -100, sos = 2)
	Base.AddPositionStage(a2, "Missionary_A2_S3", -100, sos = 2)
	Base.AddPositionStage(a2, "Missionary_A2_S4", -100, sos = 2)

	Base.AddTag("Default")
	Base.AddTag("Sex")
	Base.AddTag("Missionary")
	Base.AddTag("Laying")
	Base.AddTag("Vaginal")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function SexLabReverseCowgirl(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Reverse Cowgirl"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "ReverseCowgirl_A1_S1", 0)
	Base.AddPositionStage(a1, "ReverseCowgirl_A1_S2", 0)
	Base.AddPositionStage(a1, "ReverseCowgirl_A1_S3", 0)
	Base.AddPositionStage(a1, "ReverseCowgirl_A1_S4", 0)

	int a2 = Base.AddPosition(Male) ; -102
	Base.AddPositionStage(a2, "ReverseCowgirl_A2_S1", -107, sos = 3)
	Base.AddPositionStage(a2, "ReverseCowgirl_A2_S2", -107, sos = 3)
	Base.AddPositionStage(a2, "ReverseCowgirl_A2_S3", -107, sos = 3)
	Base.AddPositionStage(a2, "ReverseCowgirl_A2_S4", -107, sos = 3)

	Base.AddTag("Default")
	Base.AddTag("Sex")
	Base.AddTag("Dirty")
	Base.AddTag("Cowgirl")
	Base.AddTag("Anal")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function SexLabSideways(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Sideways Fuck"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Sideways_A1_S1", 0)
	Base.AddPositionStage(a1, "Sideways_A1_S2", 0)
	Base.AddPositionStage(a1, "Sideways_A1_S3", 0)
	Base.AddPositionStage(a1, "Sideways_A1_S4", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Sideways_A2_S1", -98, -3.0, sos = 2)
	Base.AddPositionStage(a2, "Sideways_A2_S2", -98, -3.0, sos = 2)
	Base.AddPositionStage(a2, "Sideways_A2_S3", -98, -3.0, sos = 2)
	Base.AddPositionStage(a2, "Sideways_A2_S4", -98, -3.0, sos = 2)

	Base.AddTag("Default")
	Base.AddTag("Sex")
	Base.AddTag("Standing")
	Base.AddTag("Sideways")
	Base.AddTag("Vaginal")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function SexLabStanding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Standing Fuck"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Standing_A1_S1", 0)
	Base.AddPositionStage(a1, "Standing_A1_S2", 0)
	Base.AddPositionStage(a1, "Standing_A1_S3", 0)
	Base.AddPositionStage(a1, "Standing_A1_S4", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Standing_A2_S1", -81, sos = 4)
	Base.AddPositionStage(a2, "Standing_A2_S2", -81, sos = 3)
	Base.AddPositionStage(a2, "Standing_A2_S3", -81, sos = 5)
	Base.AddPositionStage(a2, "Standing_A2_S4", -81, sos = 6)

	Base.AddTag("Default")
	Base.AddTag("Sex")
	Base.AddTag("Standing")
	Base.AddTag("Dirty")
	Base.AddTag("Vaginal")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function SexLabTribadism(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Tribadism"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "Tribadism_A1_S1", 0)
	Base.AddPositionStage(a1, "Tribadism_A1_S2", 0)
	Base.AddPositionStage(a1, "Tribadism_A1_S2", 0)

	int a2 = Base.AddPosition(Female)
	Base.AddPositionStage(a2, "Tribadism_A2_S1", 60)
	Base.AddPositionStage(a2, "Tribadism_A2_S2", 60)
	Base.AddPositionStage(a2, "Tribadism_A2_S2", 60)

	Base.AddTag("Default")
	Base.AddTag("Sex")
	Base.AddTag("Lesbian")
	Base.AddTag("Tribadism")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function BleaghFootJob(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Bleagh FootJob"


	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Bleagh_FootJob_A1_S1", 0)
	Base.AddPositionStage(a1, "Bleagh_FootJob_A1_S2", 0)
	Base.AddPositionStage(a1, "Bleagh_FootJob_A1_S3", 0)
	Base.AddPositionStage(a1, "Bleagh_FootJob_A1_S4", 0)
	Base.AddPositionStage(a1, "Bleagh_FootJob_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Bleagh_FootJob_A2_S1", 42, rotate = 180)
	Base.AddPositionStage(a2, "Bleagh_FootJob_A2_S2", 42, rotate = 180)
	Base.AddPositionStage(a2, "Bleagh_FootJob_A2_S3", 42, rotate = 180)
	Base.AddPositionStage(a2, "Bleagh_FootJob_A2_S4", 42, rotate = 180)
	Base.AddPositionStage(a2, "Bleagh_FootJob_A2_S5", 42, rotate = 180)

	Base.AddTag("Sex")
	Base.AddTag("MF")
	Base.AddTag("Fetish")
	Base.AddTag("Feet")
	Base.AddTag("Footjob")
	Base.AddTag("Bleagh")

	Base.Save(id)
endFunction

function BleaghFemaleSolo(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Bleagh Female Masturbation"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "Bleagh_FemaleSolo_A1_S1", 0)
	Base.AddPositionStage(a1, "Bleagh_FemaleSolo_A1_S2", 0)
	Base.AddPositionStage(a1, "Bleagh_FemaleSolo_A1_S3", 0)
	Base.AddPositionStage(a1, "Bleagh_FemaleSolo_A1_S4", 0)
	Base.AddPositionStage(a1, "Bleagh_FemaleSolo_A1_S5", 0)

	Base.AddTag("Sex")
	Base.AddTag("Solo")
	Base.AddTag("Masturbation")
	Base.AddTag("Dirty")

	Base.Save(id)
endFunction

function APAnal(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "AP Anal"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "AP_Anal_A1_S1", 0)
	Base.AddPositionStage(a1, "AP_Anal_A1_S2", 0)
	Base.AddPositionStage(a1, "AP_Anal_A1_S3", 0)
	Base.AddPositionStage(a1, "AP_Anal_A1_S4", 0)
	Base.AddPositionStage(a1, "AP_Anal_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_Anal_A2_S1", 44, rotate = 180)
	Base.AddPositionStage(a2, "AP_Anal_A2_S2", 44, rotate = 180)
	Base.AddPositionStage(a2, "AP_Anal_A2_S3", 44, rotate = 180)
	Base.AddPositionStage(a2, "AP_Anal_A2_S4", 44, rotate = 180)
	Base.AddPositionStage(a2, "AP_Anal_A2_S5", 44, rotate = 180)

	Base.AddTag("AP")
	Base.AddTag("Sex")
	Base.AddTag("Straight")
	Base.AddTag("Aggressive")
	Base.AddTAg("AggressiveDefault")
	Base.AddTag("Anal")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function APBedMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "AP Bed Missionary"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "AP_BedMissionary_A1_S1", 0)
	Base.AddPositionStage(a1, "AP_BedMissionary_A1_S2", 0)
	Base.AddPositionStage(a1, "AP_BedMissionary_A1_S3", 0)
	Base.AddPositionStage(a1, "AP_BedMissionary_A1_S4", 0)
	Base.AddPositionStage(a1, "AP_BedMissionary_A1_S5", 0)
	Base.AddPositionStage(a1, "AP_BedMissionary_A1_S6", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_BedMissionary_A2_S1", 44, rotate = 180, sos = 5)
	Base.AddPositionStage(a2, "AP_BedMissionary_A2_S2", 44, rotate = 180, sos = 5)
	Base.AddPositionStage(a2, "AP_BedMissionary_A2_S3", 44, rotate = 180, sos = 5)
	Base.AddPositionStage(a2, "AP_BedMissionary_A2_S4", 44, rotate = 180, sos = 5)
	Base.AddPositionStage(a2, "AP_BedMissionary_A2_S4", 44, rotate = 180, sos = 5)
	Base.AddPositionStage(a2, "AP_BedMissionary_A2_S4", 44, rotate = 180, sos = 5)

	Base.AddTag("AP")
	Base.AddTag("Sex")
	Base.AddTag("Straight")
	Base.AddTag("Missionary")
	Base.AddTag("Vaginal")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function APBlowjob(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "AP Blowjob"
	Base.SoundFX = Sucking

	int a1 = Base.AddPosition(Female, Oral)
	Base.AddPositionStage(a1, "AP_Blowjob_A1_S1", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_Blowjob_A1_S2", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_Blowjob_A1_S3", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_Blowjob_A1_S4", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_Blowjob_A1_S5", 0, silent = true, openMouth = true)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_Cowgirl_A2_S1", 43, rotate = 180, sos = 1)
	Base.AddPositionStage(a2, "AP_Cowgirl_A2_S2", 43, rotate = 180, sos = 1)
	Base.AddPositionStage(a2, "AP_Cowgirl_A2_S2", 43, rotate = 180, sos = 1)
	Base.AddPositionStage(a2, "AP_Cowgirl_A2_S3", 43, rotate = 180, sos = 1)
	Base.AddPositionStage(a2, "AP_Cowgirl_A2_S4", 43, rotate = 180, sos = 1)

	Base.AddTag("AP")
	Base.AddTag("Sex")
	Base.AddTag("Straight")
	Base.AddTag("Dirty")
	Base.AddTag("Oral")
	Base.AddTag("Blowjob")
	Base.AddTag("Standing")
	Base.AddTag("LeadIn")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function APBoobjob(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "AP Boobjob"


	int a1 = Base.AddPosition(Female, Oral)
	Base.AddPositionStage(a1, "AP_Boobjob_A1_S1", 0)
	Base.AddPositionStage(a1, "AP_Boobjob_A1_S2", 0)
	Base.AddPositionStage(a1, "AP_Boobjob_A1_S3", 0)
	Base.AddPositionStage(a1, "AP_Boobjob_A1_S4", 0)
	Base.AddPositionStage(a1, "AP_Boobjob_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S1", 30, rotate = 180, sos = 6)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S2", 30, rotate = 180, sos = 6)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S3", 30, rotate = 180, sos = 6)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S4", 30, rotate = 180, sos = 6)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S5", 30, rotate = 180, sos = 6)

	Base.AddTag("AP")
	Base.AddTag("Sex")
	Base.AddTag("Straight")
	Base.AddTag("Dirty")
	Base.AddTag("Boobjob")
	Base.AddTag("Standing")
	Base.AddTag("Breast")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function APCowgirl(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "AP Cowgirl"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "AP_Cowgirl_A1_S1", 0)
	Base.AddPositionStage(a1, "AP_Cowgirl_A1_S2", 0)
	Base.AddPositionStage(a1, "AP_Cowgirl_A1_S3", 0)
	Base.AddPositionStage(a1, "AP_Cowgirl_A1_S4", 0)
	Base.AddPositionStage(a1, "AP_Cowgirl_A1_S5", 0)
	Base.AddPositionStage(a1, "AP_Cowgirl_A1_S6", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_Cowgirl_A2_S1", 44, rotate = 180, sos = 1)
	Base.AddPositionStage(a2, "AP_Cowgirl_A2_S2", 44, rotate = 180, sos = 1)
	Base.AddPositionStage(a2, "AP_Cowgirl_A2_S2", 44, rotate = 180, sos = 1)
	Base.AddPositionStage(a2, "AP_Cowgirl_A2_S3", 44, rotate = 180, sos = 1)
	Base.AddPositionStage(a2, "AP_Cowgirl_A2_S4", 44, rotate = 180, sos = 2)
	Base.AddPositionStage(a2, "AP_Cowgirl_A2_S4", 44, rotate = 180, sos = 2)

	Base.AddTag("AP")
	Base.AddTag("Sex")
	Base.AddTag("Straight")
	Base.AddTag("Cowgirl")
	Base.AddTag("Dirty")
	Base.AddTag("Vaginal")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function APFemaleSolo(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "AP Female Masturbation"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "AP_FemaleSolo_A1_S1", 0)
	Base.AddPositionStage(a1, "AP_FemaleSolo_A1_S2", 0)
	Base.AddPositionStage(a1, "AP_FemaleSolo_A1_S3", 0)
	Base.AddPositionStage(a1, "AP_FemaleSolo_A1_S4", 0)
	Base.AddPositionStage(a1, "AP_FemaleSolo_A1_S5", 0)
	Base.AddPositionStage(a1, "AP_FemaleSolo_A1_S6", 0)

	Base.AddTag("Sex")
	Base.AddTag("Solo")
	Base.AddTag("Masturbation")
	Base.AddTag("Dirty")

	Base.Save(id)
endFunction

function APFisting(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "AP Fisting"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "AP_Fisting_A1_S1", 0)
	Base.AddPositionStage(a1, "AP_Fisting_A1_S2", 0)
	Base.AddPositionStage(a1, "AP_Fisting_A1_S3", 0)
	Base.AddPositionStage(a1, "AP_Fisting_A1_S4", 0)
	Base.AddPositionStage(a1, "AP_Fisting_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_Fisting_A2_S1", 44, rotate = 180, strapon = false)
	Base.AddPositionStage(a2, "AP_Fisting_A2_S2", 44, rotate = 180, strapon = false)
	Base.AddPositionStage(a2, "AP_Fisting_A2_S3", 44, rotate = 180, strapon = false)
	Base.AddPositionStage(a2, "AP_Fisting_A2_S4", 44, rotate = 180, strapon = false)
	Base.AddPositionStage(a2, "AP_Fisting_A2_S4", 44, rotate = 180, strapon = false)

	Base.AddTag("AP")
	Base.AddTag("Sex")
	Base.AddTag("Straight")
	Base.AddTag("Aggressive")
	Base.AddTAg("AggressiveDefault")
	Base.AddTag("Fisting")
	Base.AddTag("Rough")
	Base.AddTag("Dirty")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function APHandjob(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "AP Handjob"


	int a1 = Base.AddPosition(Female, Oral)
	Base.AddPositionStage(a1, "AP_Handjob_A1_S1", 0, up = 0.5, silent = true)
	Base.AddPositionStage(a1, "AP_Handjob_A1_S2", 0, up = 0.5, silent = true)
	Base.AddPositionStage(a1, "AP_Handjob_A1_S3", 0, up = 0.5, silent = true)
	Base.AddPositionStage(a1, "AP_Handjob_A1_S4", 0, up = 0.5, silent = true)
	Base.AddPositionStage(a1, "AP_Handjob_A1_S5", 0, up = 0.5, silent = true, openMouth = true)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S1", 44, side = -3, rotate = 180, sos = 0)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S2", 44, side = -3, rotate = 180, sos = 0)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S3", 44, side = -3, rotate = 180, sos = 0)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S4", 44, side = -3, rotate = 180, sos = 0)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S5", 44, side = -3, rotate = 180, sos = 0)

	Base.AddTag("AP")
	Base.AddTag("Sex")
	Base.AddTag("Straight")
	Base.AddTag("Dirty")
	Base.AddTag("Handjob")
	Base.AddTag("Standing")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function APKneelBlowjob(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "AP Kneeling Blowjob"
	Base.SoundFX = Sucking

	int a1 = Base.AddPosition(Female, Oral)
	Base.AddPositionStage(a1, "AP_KneelBlowjob_A1_S1", 0, up = 1, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_KneelBlowjob_A1_S2", 0, up = 1, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_KneelBlowjob_A1_S3", 0, up = 1, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_KneelBlowjob_A1_S4", 0, up = 1, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_KneelBlowjob_A1_S5", 0, up = 1, silent = true, openMouth = true)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S1", 44, rotate = 180, sos = 0)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S2", 44, rotate = 180, sos = 0)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S3", 44, rotate = 180, sos = 0)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S4", 44, rotate = 180, sos = 0)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S5", 44, rotate = 180, sos = 0)

	Base.AddTag("AP")
	Base.AddTag("Sex")
	Base.AddTag("Straight")
	Base.AddTag("Dirty")
	Base.AddTag("Oral")
	Base.AddTag("Blowjob")
	Base.AddTag("Standing")
	Base.AddTag("LeadIn")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function APLegUp(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "AP Leg Up Fuck"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "AP_LegUp_A1_S1", 0)
	Base.AddPositionStage(a1, "AP_LegUp_A1_S2", 0)
	Base.AddPositionStage(a1, "AP_LegUp_A1_S3", 0)
	Base.AddPositionStage(a1, "AP_LegUp_A1_S4", 0)
	Base.AddPositionStage(a1, "AP_LegUp_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_LegUp_A2_S1", 44, up = 5, rotate = 180, sos = 3)
	Base.AddPositionStage(a2, "AP_LegUp_A2_S2", 44, up = 5, rotate = 180, sos = 3)
	Base.AddPositionStage(a2, "AP_LegUp_A2_S3", 44, up = 5, rotate = 180, sos = 3)
	Base.AddPositionStage(a2, "AP_LegUp_A2_S4", 44, up = 5, rotate = 180, sos = 3)
	Base.AddPositionStage(a2, "AP_LegUp_A2_S5", 44, up = 5, rotate = 180, sos = 3)

	Base.AddTag("AP")
	Base.AddTag("Dirty")
	Base.AddTag("Laying")
	Base.AddTag("Aggressive")
	Base.AddTAg("AggressiveDefault")
	Base.AddTag("Vaginal")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function APShoulder(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "AP Shoulder"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "AP_Shoulder_A1_S1", 0)
	Base.AddPositionStage(a1, "AP_Shoulder_A1_S2", 0)
	Base.AddPositionStage(a1, "AP_Shoulder_A1_S3", 0)
	Base.AddPositionStage(a1, "AP_Shoulder_A1_S4", 0)
	Base.AddPositionStage(a1, "AP_Shoulder_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S1", 44, rotate = 180, sos = 2)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S2", 44, rotate = 180, sos = 2)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S3", 44, rotate = 180, sos = 2)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S4", 44, rotate = 180, sos = 2)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S5", 44, rotate = 180, sos = 2)

	Base.AddTag("AP")
	Base.AddTag("Sex")
	Base.AddTag("Straight")
	Base.AddTag("Standing")
	Base.AddTag("Vaginal")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function APStandBlowjob(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "AP Standing Blowjob"
	Base.SoundFX = Sucking

	int a1 = Base.AddPosition(Female, Oral)
	Base.AddPositionStage(a1, "AP_StandBlowjob_A1_S1", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_StandBlowjob_A1_S2", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_StandBlowjob_A1_S3", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_StandBlowjob_A1_S4", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_StandBlowjob_A1_S5", 0, silent = true, openMouth = true)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S1", 44, rotate = 180, sos = -1)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S2", 44, rotate = 180, sos = -1)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S3", 44, rotate = 180, sos = -1)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S4", 44, rotate = 180, sos = -1)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S5", 44, rotate = 180, sos = -1)

	Base.AddTag("AP")
	Base.AddTag("Sex")
	Base.AddTag("Straight")
	Base.AddTag("Dirty")
	Base.AddTag("Oral")
	Base.AddTag("Blowjob")
	Base.AddTag("LeadIn")
	Base.AddTag("Standing")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function APStanding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "AP Standing"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "AP_Standing_A1_S1", 0)
	Base.AddPositionStage(a1, "AP_Standing_A1_S2", 0)
	Base.AddPositionStage(a1, "AP_Standing_A1_S3", 0)
	Base.AddPositionStage(a1, "AP_Standing_A1_S4", 0)
	Base.AddPositionStage(a1, "AP_Standing_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_Standing_A2_S1", 43, rotate = 180, sos = 2)
	Base.AddPositionStage(a2, "AP_Standing_A2_S2", 43, rotate = 180, sos = 2)
	Base.AddPositionStage(a2, "AP_Standing_A2_S2", 43, rotate = 180, sos = 2)
	Base.AddPositionStage(a2, "AP_Standing_A2_S3", 43, rotate = 180, sos = 2)
	Base.AddPositionStage(a2, "AP_Standing_A2_S3", 43, rotate = 180, sos = 2)

	Base.AddTag("AP")
	Base.AddTag("Sex")
	Base.AddTag("Straight")
	Base.AddTag("Standing")
	Base.AddTag("Vaginal")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function APDoggyStyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "AP DoggyStyle"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "AP_DoggyStyle_A1_S1", 0)
	Base.AddPositionStage(a1, "AP_DoggyStyle_A1_S2", 0)
	Base.AddPositionStage(a1, "AP_DoggyStyle_A1_S3", 0)
	Base.AddPositionStage(a1, "AP_DoggyStyle_A1_S4", 0)
	Base.AddPositionStage(a1, "AP_DoggyStyle_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_HoldLegUp_A2_S1", 44, rotate = 180)
	Base.AddPositionStage(a2, "AP_HoldLegUp_A2_S2", 44, rotate = 180)
	Base.AddPositionStage(a2, "AP_HoldLegUp_A2_S2", 44, rotate = 180)
	Base.AddPositionStage(a2, "AP_HoldLegUp_A2_S3", 44, rotate = 180)
	Base.AddPositionStage(a2, "AP_HoldLegUp_A2_S3", 44, rotate = 180)

	Base.AddTag("AP")
	Base.AddTag("Sex")
	Base.AddTag("Straight")
	Base.AddTag("DoggyStyle")
	Base.AddTag("Knees")
	Base.AddTag("Anal")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function APHoldLegUp(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "AP Holding Leg Up"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "AP_HoldLegUp_A1_S1", 0)
	Base.AddPositionStage(a1, "AP_HoldLegUp_A1_S2", 0)
	Base.AddPositionStage(a1, "AP_HoldLegUp_A1_S3", 0)
	Base.AddPositionStage(a1, "AP_HoldLegUp_A1_S4", 0)
	Base.AddPositionStage(a1, "AP_HoldLegUp_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_HoldLegUp_A2_S1", 44, rotate = 180)
	Base.AddPositionStage(a2, "AP_HoldLegUp_A2_S2", 44, rotate = 180)
	Base.AddPositionStage(a2, "AP_HoldLegUp_A2_S2", 44, rotate = 180)
	Base.AddPositionStage(a2, "AP_HoldLegUp_A2_S3", 44, rotate = 180)
	Base.AddPositionStage(a2, "AP_HoldLegUp_A2_S3", 44, rotate = 180)

	Base.AddTag("AP")
	Base.AddTag("Sex")
	Base.AddTag("Laying")
	Base.AddTag("Aggressive")
	Base.AddTAg("AggressiveDefault")
	Base.AddTag("Straight")
	Base.AddTag("Anal")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function APFaceDown(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "AP Face Down Anal"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "AP_FaceDown_A1_S1", 0)
	Base.AddPositionStage(a1, "AP_FaceDown_A1_S2", 0)
	Base.AddPositionStage(a1, "AP_FaceDown_A1_S3", 0)
	Base.AddPositionStage(a1, "AP_FaceDown_A1_S4", 0)
	Base.AddPositionStage(a1, "AP_FaceDown_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_FaceDown_A2_S1", 44, rotate = 180)
	Base.AddPositionStage(a2, "AP_FaceDown_A2_S2", 44, rotate = 180)
	Base.AddPositionStage(a2, "AP_FaceDown_A2_S3", 44, rotate = 180)
	Base.AddPositionStage(a2, "AP_FaceDown_A2_S3", 44, rotate = 180)
	Base.AddPositionStage(a2, "AP_FaceDown_A2_S4", 44, rotate = 180)

	Base.AddTag("AP")
	Base.AddTag("Sex")
	Base.AddTag("Laying")
	Base.AddTag("Aggressive")
	Base.AddTAg("AggressiveDefault")
	Base.AddTag("Straight")
	Base.AddTag("Anal")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function APSkullFuck(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "AP Skull Fuck"
	Base.SoundFX = Sucking

	int a1 = Base.AddPosition(Female, Oral)
	Base.AddPositionStage(a1, "AP_SkullFuck_A1_S1", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_SkullFuck_A1_S2", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_SkullFuck_A1_S3", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_SkullFuck_A1_S4", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_SkullFuck_A1_S5", 0, silent = true, openMouth = true)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_SkullFuck_A2_S1", 49, rotate = 180, sos = 1)
	Base.AddPositionStage(a2, "AP_SkullFuck_A2_S2", 49, rotate = 180, sos = 1)
	Base.AddPositionStage(a2, "AP_SkullFuck_A2_S3", 49, rotate = 180, sos = 2)
	Base.AddPositionStage(a2, "AP_SkullFuck_A2_S4", 49, rotate = 180, sos = 2)
	Base.AddPositionStage(a2, "AP_SkullFuck_A2_S5", 49, rotate = 180, sos = 2)

	Base.AddTag("AP")
	Base.AddTag("Sex")
	Base.AddTag("Straight")
	Base.AddTag("Aggressive")
	Base.AddTAg("AggressiveDefault")
	Base.AddTag("Blowjob")
	Base.AddTag("Oral")
	Base.AddTag("MF")

	Base.Save(id)
endFunction



function ZynRoughStanding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Zyn Rough Standing"
	Base.SoundFX = Sucking

	int a1 = Base.AddPosition(Female, VaginalOral)
	Base.AddPositionStage(a1, "Zyn_RoughStanding_A1_S1", 0)
	Base.AddPositionStage(a1, "Zyn_RoughStanding_A1_S2", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Zyn_RoughStanding_A1_S3", 0)
	Base.AddPositionStage(a1, "Zyn_RoughStanding_A1_S4", 0)

	int a2 = Base.AddPosition(Male) ; -102
	Base.AddPositionStage(a2, "Zyn_RoughStanding_A2_S1", -107, sos = 9)
	Base.AddPositionStage(a2, "Zyn_RoughStanding_A2_S2", -107, sos = 9)
	Base.AddPositionStage(a2, "Zyn_RoughStanding_A2_S3", -107, sos = 9)
	Base.AddPositionStage(a2, "Zyn_RoughStanding_A2_S4", -107, sos = 9)

	Base.AddTag("Zyn")
	Base.AddTag("Sex")
	Base.AddTag("Rough")
	Base.AddTag("Standing")
	Base.AddTag("Aggressive")
	Base.AddTAg("AggressiveDefault")
	Base.AddTag("Oral")
	Base.AddTag("Vaginal")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function ZynLesbian(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Zyn Lesbian"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "Zyn_Lesbian_A1_S1", 0, silent = true)
	Base.AddPositionStage(a1, "Zyn_Lesbian_A1_S2", 0)
	Base.AddPositionStage(a1, "Zyn_Lesbian_A1_S3", 0)
	Base.AddPositionStage(a1, "Zyn_Lesbian_A1_S4", 0)

	int a2 = Base.AddPosition(Female)
	Base.AddPositionStage(a2, "Zyn_Lesbian_A2_S1", -81, silent = true)
	Base.AddPositionStage(a2, "Zyn_Lesbian_A2_S2", -81, silent = true, openMouth = true)
	Base.AddPositionStage(a2, "Zyn_Lesbian_A2_S3", -81)
	Base.AddPositionStage(a2, "Zyn_Lesbian_A2_S4", -81)

	Base.AddTag("Zyn")
	Base.AddTag("Sex")
	Base.AddTag("Lesbian")
	Base.AddTag("Dirty")
	Base.AddTag("Vaginal")
	Base.AddTag("Oral")
	Base.AddTag("Kissing")

	Base.Save(id)
endFunction

function ZynLicking(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Zyn Licking"
	Base.SoundFX = SexMix

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "Zyn_Licking_A1_S1", 0)
	Base.AddPositionStage(a1, "Zyn_Licking_A1_S2", 0)
	Base.AddPositionStage(a1, "Zyn_Licking_A1_S3", 0)
	Base.AddPositionStage(a1, "Zyn_Licking_A1_S4", 0)

	int a2 = Base.AddPosition(Female)
	Base.AddPositionStage(a2, "Zyn_Licking_A2_S1", -96, silent = true)
	Base.AddPositionStage(a2, "Zyn_Licking_A2_S2", -96, silent = true)
	Base.AddPositionStage(a2, "Zyn_Licking_A2_S3", -96, silent = true)
	Base.AddPositionStage(a2, "Zyn_Licking_A2_S4", -96, silent = true)

	Base.AddTag("Zyn")
	Base.AddTag("Sex")
	Base.AddTag("Lesbian")
	Base.AddTag("Dirty")
	Base.AddTag("Oral")
	Base.AddTag("Cunnilingus")
	Base.AddTag("Licking")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function ZynDoublePenetration(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Zyn Double Penetration"
	Base.SoundFX = SexMix

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Zyn_DoublePenetration_A2_S1", 100)
	Base.AddPositionStage(a1, "Zyn_DoublePenetration_A2_S2", 100)
	Base.AddPositionStage(a1, "Zyn_DoublePenetration_A2_S3", 100)
	Base.AddPositionStage(a1, "Zyn_DoublePenetration_A2_S4", 100)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Zyn_DoublePenetration_A1_S1", 0)
	Base.AddPositionStage(a2, "Zyn_DoublePenetration_A1_S2", 0, sos = 9)
	Base.AddPositionStage(a2, "Zyn_DoublePenetration_A1_S3", 0)
	Base.AddPositionStage(a2, "Zyn_DoublePenetration_A1_S4", 0)

	int a3 = Base.AddPosition(Male)
	Base.AddPositionStage(a3, "Zyn_DoublePenetration_A3_S1", -100)
	Base.AddPositionStage(a3, "Zyn_DoublePenetration_A3_S2", -100, sos = 9)
	Base.AddPositionStage(a3, "Zyn_DoublePenetration_A3_S3", -100)
	Base.AddPositionStage(a3, "Zyn_DoublePenetration_A3_S4", -100, sos = 9)

	Base.AddTag("Sex")
	Base.AddTag("Zyn")
	Base.AddTag("BBP")
	Base.AddTag("Dirty")
	Base.AddTag("Orgy")
	Base.AddTag("Vaginal")
	Base.AddTag("Anal")
	Base.AddTag("MMF")

	Base.Save(id)
endFunction

function ZynFemdom(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Zyn FemDom"
	Base.SoundFX = SexMix

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "Zyn_Femdom_A1_S1", 0, strapon = true)
	Base.AddPositionStage(a1, "Zyn_Femdom_A1_S2", 0, strapon = true)
	Base.AddPositionStage(a1, "Zyn_Femdom_A1_S3", 0, strapon = true)
	Base.AddPositionStage(a1, "Zyn_Femdom_A1_S4", 0, strapon = true)

	int a2 = Base.AddPosition(Male, Vaginal)
	Base.AddPositionStage(a2, "Zyn_Femdom_A2_S1", -100)
	Base.AddPositionStage(a2, "Zyn_Femdom_A2_S2", -100)
	Base.AddPositionStage(a2, "Zyn_Femdom_A2_S3", -100)
	Base.AddPositionStage(a2, "Zyn_Femdom_A2_S4", -100)

	int a3 = Base.AddPosition(Female)
	Base.AddPositionStage(a3, "Zyn_Femdom_A3_S1", 108)
	Base.AddPositionStage(a3, "Zyn_Femdom_A3_S2", 108, openMouth = true)
	Base.AddPositionStage(a3, "Zyn_Femdom_A3_S3", 108)
	Base.AddPositionStage(a3, "Zyn_Femdom_A3_S4", 108)

	Base.AddTag("Sex")
	Base.AddTag("Zyn")
	Base.AddTag("BBP")
	Base.AddTag("Orgy")
	Base.AddTag("Dirty")
	Base.AddTag("Vaginal")
	Base.AddTag("Anal")
	Base.AddTag("Oral")
	Base.AddTag("MFF")

	Base.Save(id)
endFunction

function ZynMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Zyn Missionary"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, VaginalOral)
	Base.AddPositionStage(a1, "Zyn_Missionary_A1_S1", 0)
	Base.AddPositionStage(a1, "Zyn_Missionary_A1_S2", 0)
	Base.AddPositionStage(a1, "Zyn_Missionary_A1_S3", 0)
	Base.AddPositionStage(a1, "Zyn_Missionary_A1_S4", 0)
    Base.AddPositionstage(a1, "Zyn_Missionary_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Zyn_Missionary_A2_S1", -105)
	Base.AddPositionStage(a2, "Zyn_Missionary_A2_S2", -105)
	Base.AddPositionStage(a2, "Zyn_Missionary_A2_S3", -105, sos = 3)
	Base.AddPositionStage(a2, "Zyn_Missionary_A2_S4", -105, sos = 7)
    Base.AddPositionStage(a2, "Zyn_Missionary_A2_S5", -105, sos = 7)

	Base.AddTag("Zyn")
	Base.AddTag("BBP")
	Base.AddTag("Sex")
	Base.AddTag("Laying")
	Base.AddTag("Missionary")
	Base.AddTag("Vaginal")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function ZynDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Zyn DoggyStyle"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Zyn_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "Zyn_Doggystyle_A1_S2", 0)
	Base.AddPositionStage(a1, "Zyn_Doggystyle_A1_S3", 0)
	Base.AddPositionStage(a1, "Zyn_Doggystyle_A1_S4", 0)
    Base.AddPositionstage(a1, "Zyn_Doggystyle_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Zyn_Doggystyle_A2_S1", -104, sos = 4)
	Base.AddPositionStage(a2, "Zyn_Doggystyle_A2_S2", -104, sos = 3)
	Base.AddPositionStage(a2, "Zyn_Doggystyle_A2_S3", -104, sos = 3)
	Base.AddPositionStage(a2, "Zyn_Doggystyle_A2_S4", -104, sos = 3)
	Base.AddPositionStage(a2, "Zyn_Doggystyle_A2_S5", -104, sos = 3)

	Base.AddTag("Zyn")
	Base.AddTag("BBP")
	Base.AddTag("Sex")
	Base.AddTag("Dirty")
	Base.AddTag("Doggystyle")
	Base.AddTag("Vaginal")
	Base.AddTag("MF")

	Base.Save(id)
endFunction

function ZynFourWay(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Zyn Gay Fourway"
	Base.SoundFX = SexMix

	; A2's animations better conform to a female role and female positions need to be listed first
	int a1 = Base.AddPosition(Female, VaginalOralAnal)
	Base.AddPositionStage(a1, "Zyn_4Way_A2_S1", 101, openMouth = true, strapon = true)
	Base.AddPositionStage(a1, "Zyn_4Way_A2_S2", 101, strapon = true)
	Base.AddPositionStage(a1, "Zyn_4Way_A2_S3", 101, openMouth = true, strapon = true, sos = 2)
	Base.AddPositionStage(a1, "Zyn_4Way_A2_S4", 101, openMouth = true, strapon = true, sos = 2)

	int a2 = Base.AddPosition(Male, VaginalAnal)
	Base.AddPositionStage(a2, "Zyn_4Way_A1_S1", 0, openMouth = true)
	Base.AddPositionStage(a2, "Zyn_4Way_A1_S2", 0)
	Base.AddPositionStage(a2, "Zyn_4Way_A1_S3", 0)
	Base.AddPositionStage(a2, "Zyn_4Way_A1_S4", 0)

	int a3 = Base.AddPosition(Male, VaginalOral)
	Base.AddPositionStage(a3, "Zyn_4Way_A3_S1", 48)
	Base.AddPositionStage(a3, "Zyn_4Way_A3_S2", 48, sos = 2)
	Base.AddPositionStage(a3, "Zyn_4Way_A3_S3", 48, openMouth = true)
	Base.AddPositionStage(a3, "Zyn_4Way_A3_S4", 48)

	int a4 = Base.AddPosition(Male, VaginalAnal)
	Base.AddPositionStage(a4, "Zyn_4Way_A4_S1", -108)
	Base.AddPositionStage(a4, "Zyn_4Way_A4_S2", -108)
	Base.AddPositionStage(a4, "Zyn_4Way_A4_S3", -108)
	Base.AddPositionStage(a4, "Zyn_4Way_A4_S4", -108)

	Base.AddTag("Sex")
	Base.AddTag("Zyn")
	Base.AddTag("Orgy")
	Base.AddTag("Dirty")
	Base.AddTag("Vaginal")
	Base.AddTag("Anal")
	Base.AddTag("Oral")
	Base.AddTag("MMMM")
	Base.AddTag("MMMF")

	Base.Save(id)
endFunction

function DarkInvestigationsThreesome(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "DI Forced Threesome"
	Base.SoundFX = SexMix

	int a1 = Base.AddPosition(Female, VaginalOralAnal)
	Base.AddPositionStage(a1, "zdi2_Threesome_A1_S1", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "zdi2_Threesome_A1_S2", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "zdi2_Threesome_A1_S3", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "zdi2_Threesome_A1_S4", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Threesome_A2_S1", -82, sos = 0)
	Base.AddPositionStage(a2, "zdi2_Threesome_A2_S2", -82, sos = 0)
	Base.AddPositionStage(a2, "zdi2_Threesome_A2_S3", -82, sos = 0)
	Base.AddPositionStage(a2, "zdi2_Threesome_A2_S4", -82, sos = 0)

	int a3 = Base.AddPosition(Male)
	Base.AddPositionStage(a3, "zdi2_Threesome_A3_S1", 82, rotate = 180.0, sos = 1)
	Base.AddPositionStage(a3, "zdi2_Threesome_A3_S2", 82, rotate = 180.0, sos = 1)
	Base.AddPositionStage(a3, "zdi2_Threesome_A3_S3", 82, rotate = 180.0, sos = 1)
	Base.AddPositionStage(a3, "zdi2_Threesome_A3_S4", 82, rotate = 180.0, sos = 1)

	Base.SetStageSoundFX(4, none)
	Base.SetStageTimer(4, 26.0)

	Base.AddTag("Sex")
	Base.AddTag("Dark Investigations")
	Base.AddTag("zDI")
	Base.AddTag("Athstai")
	Base.AddTag("MMF")
	Base.AddTag("Doggy")
	Base.AddTag("Blowjob")
	Base.AddTag("Oral")
	Base.AddTag("Orgy")
	Base.AddTag("Vaginal")
	Base.AddTag("Dirty")
	Base.AddTag("Forced")

	Base.Save(id)
endFunction

function DarkInvestigationsDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "DI Doggystyle"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S3", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S4", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82, sos = 0)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82, sos = 0)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S3", -82, sos = 0)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S4", -82, sos = 0)

	Base.SetStageSoundFX(4, none)
	Base.SetStageTimer(4, 26.0)

	Base.AddTag("Sex")
	Base.AddTag("Dark Investigations")
	Base.AddTag("zDI")
	Base.AddTag("Athstai")
	Base.AddTag("MF")
	Base.AddTag("Doggy")
	Base.AddTag("Vaginal")
	Base.AddTag("Dirty")

	Base.Save(id)
endFunction


function DarkInvestigationsBlowjob(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "DI Blowjob"
	Base.SoundFX = Sucking

	int a1 = Base.AddPosition(Female, Oral)
	Base.AddPositionStage(a1, "zdi2_Blowjob_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Blowjob_A1_S2", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "zdi2_Blowjob_A1_S3", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "zdi2_Blowjob_A1_S4", 0, openMouth = true)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Blowjob_A2_S1", 50, rotate = 180.0, sos = 0)
	Base.AddPositionStage(a2, "zdi2_Blowjob_A2_S2", 50, rotate = 180.0, sos = 0)
	Base.AddPositionStage(a2, "zdi2_Blowjob_A2_S3", 50, rotate = 180.0, sos = 0)
	Base.AddPositionStage(a2, "zdi2_Blowjob_A2_S4", 50, rotate = 180.0, sos = 0)

	Base.SetStageSoundFX(1, none)
	Base.SetStageSoundFX(4, none)
	Base.SetStageTimer(4, 12.0)

	Base.AddTag("Sex")
	Base.AddTag("Dark Investigations")
	Base.AddTag("zDI")
	Base.AddTag("Athstai")
	Base.AddTag("MF")
	Base.AddTag("Handjob")
	Base.AddTag("Blowjob")
	Base.AddTag("Oral")
	Base.AddTag("Dirty")

	Base.Save(id)
endFunction


function ExtraTMP1(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [1]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP2(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [2]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP3(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [3]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP4(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [4]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP5(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [5]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP6(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [6]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP7(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [7]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP8(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [8]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP9(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [9]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP10(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [10]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP11(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [11]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP12(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [12]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP13(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [13]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP14(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [14]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP15(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [15]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP16(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [16]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP17(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [17]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP18(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [18]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP19(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [19]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP20(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [20]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP21(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [21]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP22(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [22]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP23(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [23]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP24(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [24]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP25(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [25]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP26(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [26]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP27(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [27]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP28(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [28]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP29(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [29]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP30(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [30]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP31(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [31]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP32(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [32]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP33(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [33]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP34(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [34]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP35(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [35]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP36(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [36]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP37(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [37]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP38(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [38]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP39(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [39]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP40(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [40]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP41(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [41]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP42(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [42]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP43(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [43]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP44(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [44]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP45(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [45]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP46(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [46]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP47(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [47]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP48(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [48]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP49(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [49]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP50(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [50]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP51(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [51]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP52(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [52]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP53(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [53]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP54(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [54]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP55(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [55]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP56(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [56]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP57(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [57]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP58(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [58]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP59(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [59]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP60(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [60]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP61(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [61]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP62(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [62]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP63(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [63]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP64(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [64]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP65(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [65]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP66(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [66]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP67(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [67]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP68(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [68]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP69(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [69]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP70(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [70]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP71(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [71]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP72(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [72]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP73(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [73]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP74(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [74]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP75(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [75]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP76(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [76]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP77(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [77]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP78(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [78]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP79(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [79]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP80(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [80]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP81(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [81]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP82(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [82]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP83(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [83]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP84(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [84]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP85(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [85]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP86(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [86]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP87(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [87]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP88(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [88]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP89(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [89]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP90(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [90]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction
function ExtraTMP91(int id)
	sslBaseAnimation Base = Create(id)
	Base.Name    = "ExtraTMP [91]"
	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "zdi2_Doggystyle_A1_S2", 0)
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S1", -82)
	Base.AddPositionStage(a2, "zdi2_Doggystyle_A2_S2", -82)
	Base.AddTag("Sex")
	Base.AddTag("Vaginal")
	Base.Save(id)
endFunction