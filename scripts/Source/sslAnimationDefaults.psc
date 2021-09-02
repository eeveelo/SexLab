scriptname sslAnimationDefaults extends sslAnimationFactory


;/ 

For JSON loading animation instructions, see /data/SKSE/Plugins/SexLab/Animations/_README_.txt

/;

function LoadAnimations()
	; Prepare factory resources (as non creature)
	PrepareFactory()

	if Game.GetCameraState() == 0
		if Utility.IsInMenuMode()
			MiscUtil.PrintConsole("WARNING! To continue with the SexLab animations setup close the console and all the menu")
		endIf
		Utility.Wait(0.1)
		Game.ForceThirdPerson()
	endIf
	bool SexLabDefault = Game.GetPlayer().GetAnimationVariableInt("SexLabDefault") >= 16300
	bool APPack = Game.GetPlayer().GetAnimationVariableInt("SexLabAPAnimations") >= 16300

	; Missionary
	if SexLabDefault
		RegisterAnimation("SexLabMissionary")
		RegisterAnimation("SexLabAggrMissionary")
		RegisterAnimation("ArrokMissionary")
		RegisterAnimation("ArrokLegUp")
		RegisterAnimation("ZynMissionary")
		RegisterAnimation("zjMissionary")
		RegisterAnimation("zjLaying")
		RegisterAnimation("zjLyingVar")
		RegisterAnimation("LeitoMissionary")
		RegisterAnimation("LeitoMissionaryVar")
		RegisterAnimation("fdBedMissionary")
		RegisterAnimation("fdLegUp")
	endIf
	if APPack
		RegisterAnimation("APBedMissionary")
		RegisterAnimation("APHoldLegUp")
		RegisterAnimation("APLegUp")
	endIf
	RegisterCategory("Missionary")

	; DoggyStyle
	if SexLabDefault
		RegisterAnimation("SexLabDoggyStyle")
		RegisterAnimation("SexLabAggrBehind")
		RegisterAnimation("SexLabAggrDoggyStyle")
		RegisterAnimation("ArrokDoggyStyle")
		RegisterAnimation("ArrokRape")
		RegisterAnimation("ZynDoggystyle")
		RegisterAnimation("DarkInvestigationsDoggystyle")
		RegisterAnimation("zjDoggy")
		RegisterAnimation("zjDomination")
		RegisterAnimation("LeitoDoggy")
		RegisterAnimation("fdDoggyStyle")
	endIf
	if APPack
		RegisterAnimation("APDoggyStyle")
	endIf
	RegisterCategory("DoggyStyle")

	; Cowgirl
	if SexLabDefault
		RegisterAnimation("SexLabReverseCowgirl")
		RegisterAnimation("ArrokCowgirl")
		RegisterAnimation("ArrokReverseCowgirl")
		RegisterAnimation("zjCowgirl")
		RegisterAnimation("LeitoCowgirl")
		RegisterAnimation("LeitoRCowgirl")
		RegisterAnimation("fdCowgirl")
		RegisterAnimation("fdRCowgirl")
		RegisterAnimation("MitosReverseCowgirl")
	endIf
	if APPack
		RegisterAnimation("APCowgirl")
	endIf
	RegisterCategory("Cowgirl")

	; Sideways
	if SexLabDefault
		RegisterAnimation("SexLabSideways")
		RegisterAnimation("ArrokSideways")
	endIf
	if APPack
		RegisterAnimation("APShoulder")
	endIf
	RegisterCategory("Sideways")
	
	; Standing
	if SexLabDefault
		RegisterAnimation("SexLabHuggingSex")
		RegisterAnimation("SexLabStanding")
		RegisterAnimation("ArrokHugFuck")
		RegisterAnimation("ArrokStanding")
		RegisterAnimation("ZynRoughStanding")
		RegisterAnimation("ZynStanding")
		RegisterAnimation("zjStanding")
		RegisterAnimation("zjStandingVar")
		RegisterAnimation("zjHolding")
		RegisterAnimation("LeitoStanding")
		RegisterAnimation("MitosStanding")
	endIf
	if APPack
		RegisterAnimation("APStanding")
	endIf
	RegisterCategory("Standing")
	
	; Anal
	if SexLabDefault
		RegisterAnimation("ArrokAnal")
		RegisterAnimation("zjAnal")
		RegisterAnimation("LeitoDoggyAnal")
		RegisterAnimation("MitosHugBehind")
	endIf
	if APPack
		RegisterAnimation("APAnal")
		RegisterAnimation("APFaceDown")
	endIf
	RegisterCategory("Anal")
	
	; Oral
	if SexLabDefault
		RegisterAnimation("ArrokBlowjob")
		RegisterAnimation("ArrokOral")
		RegisterAnimation("ArrokLedgeBlowjob")
		RegisterAnimation("DarkInvestigationsBlowjob")
		RegisterAnimation("LeitoBlowjob")
		RegisterAnimation("LeitoCunnilingus")
		RegisterAnimation("MitosFaceFemdom")
	endIf
	if APPack
		RegisterAnimation("APBlowjob")
		RegisterAnimation("APKneelBlowjob")
		RegisterAnimation("APStandBlowjob")
		RegisterAnimation("APHandjob")
		RegisterAnimation("APSkullFuck")
	endIf
	RegisterCategory("Oral")
	
	; Boobjob
	if SexLabDefault
		RegisterAnimation("SexLabBoobjob")
		RegisterAnimation("ArrokBoobjob")
	endIf
	if APPack
		RegisterAnimation("APBoobjob")
	endIf
	RegisterCategory("Boobjob")

	; Foreplay
	if SexLabDefault
		RegisterAnimation("ArrokForeplay")
		RegisterAnimation("ArrokSittingForeplay")
		RegisterAnimation("ArrokStandingForeplay")
		RegisterAnimation("zjEroMassage")
		RegisterAnimation("zjBreastFeeding")
		RegisterAnimation("zjBreastFeedingVar")
		RegisterAnimation("LeitoKissing")
		RegisterAnimation("LeitoSpoon")
	endIf
	RegisterCategory("Foreplay")

	; Lesbian/Gay
	if SexLabDefault
		RegisterAnimation("SexLabTribadism")
		RegisterAnimation("ArrokLesbian")
		RegisterAnimation("ZynLesbian")
		RegisterAnimation("ZynLicking")
	endIf
	RegisterCategory("Lesbian")
	RegisterCategory("Gay")

	; Footjob
	if SexLabDefault
		RegisterAnimation("BleaghFootJob")
		RegisterAnimation("LeitoFeet")
		RegisterAnimation("LeitoFeet2")
		RegisterAnimation("LeitoFeet3")
		RegisterAnimation("MitosFootjob")
		RegisterAnimation("MitosTease")
	endIf
	RegisterCategory("Footjob")

	; Misc
	if SexLabDefault
		RegisterAnimation("MitosLapLove")
		RegisterAnimation("MitosReachAround")
		RegisterAnimation("fdFisting")
	endIf
	if APPack
		RegisterAnimation("APFisting")
	endIf
	RegisterCategory("Misc")

	; Solo
	if SexLabDefault
		RegisterAnimation("BleaghFemaleSolo")
		RegisterAnimation("LeitoFemaleSolo")
		RegisterAnimation("fdFMasturbation")
		RegisterAnimation("FBFMasturbation")
		RegisterAnimation("ArrokMaleMasturbation")
		RegisterAnimation("fdMMasturbation")
	endIf
	if APPack
		RegisterAnimation("APFemaleSolo")
	endIf
	RegisterCategory("Solo")

	; 3P+
	if SexLabDefault
		RegisterAnimation("ArrokDevilsThreeway")
		RegisterAnimation("ArrokTricycle")
		RegisterAnimation("zjThreesome")
		RegisterAnimation("fdThreesome")
		RegisterAnimation("DarkInvestigationsThreesome")
		RegisterAnimation("ZynDoublePenetration")
		RegisterAnimation("ZynFemdom")
		RegisterAnimation("ZynFourWay")
	endIf
	RegisterCategory("Orgy")

	; Register any remaining custom categories from json loaders
	RegisterOtherCategories()
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

	Base.SetTags("Arrok,BBP,Sex,Hands,Penis,Oral,Standing,Laying,Blowjob,Handjob,Kneeling,Facial,LeadIn,Dirty")

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
	Base.AddPositionStage(a2, "Arrok_Boobjob_A2_S1", -100, sos = 2)
	Base.AddPositionStage(a2, "Arrok_Boobjob_A2_S2", -100, sos = 3)
	Base.AddPositionStage(a2, "Arrok_Boobjob_A2_S3", -100, sos = -2)
	Base.AddPositionStage(a2, "Arrok_Boobjob_A2_S4", -100, sos = -2)

	Base.SetTags("Arrok,BBP,Sex,Boobs,Penis,Kneeling,Facing,Boobjob,ChestCum,Facial,LeadIn,Breast")

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

	Base.SetTags("Arrok,BBP,Sex,Penis,Vaginal,Cowgirl,Facing,Loving,Creampie")

	Base.Save(id)
endFunction

function ArrokDevilsThreeway(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Arrok Devils Threeway"
	Base.SoundFX = SexMix

	int a1 = Base.AddPosition(Female)
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

	Base.SetStageCumID(a1, 1, Oral)
	Base.SetStageCumID(a1, 2, OralAnal)
	Base.SetStageCumID(a1, 3, VaginalOral)
	Base.SetStageCumID(a1, 4, Oral)

	Base.SetTags("Arrok,BBP,Sex,Penis,Hands,Oral,Vaginal,Blowjob,Doggystyle,Doggy,Kneeling,69,Orgy,Facial,Dirty")

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

	Base.SetTags("Arrok,BBP,Sex,Penis,Vaginal,Doggystyle,Doggy,Reverse,Beds,Creampie")

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

	Base.SetTags("Arrok,BBP,Foreplay,Oral,Hands,Dick,Laying,Lying,OnBack,Cuddling,LeadIn,Loving,CumInMouth")

	Base.Save(id)
endFunction

function ArrokLegUp(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Arrok Leg Up Fuck"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Arrok_LegUp_A1_S1", 0, rotate = 180)
	Base.AddPositionStage(a1, "Arrok_LegUp_A1_S2", 0, rotate = 180)
	Base.AddPositionStage(a1, "Arrok_LegUp_A1_S3", 0, rotate = 180)
	Base.AddPositionStage(a1, "Arrok_LegUp_A1_S4", 0, rotate = 180)
	Base.AddPositionStage(a1, "Arrok_LegUp_A1_S5", 0, rotate = 180)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Arrok_LegUp_A2_S1", -44, sos = 2)
	Base.AddPositionStage(a2, "Arrok_LegUp_A2_S2", -44, sos = 2)
	Base.AddPositionStage(a2, "Arrok_LegUp_A2_S3", -44, sos = 2)
	Base.AddPositionStage(a2, "Arrok_LegUp_A2_S4", -44, sos = 4)
	Base.AddPositionStage(a2, "Arrok_LegUp_A2_S5", -44, sos = 3)

	Base.SetTags("Arrok,BBP,Penis,Vaginal,Missionary,Laying,Lying,Facing,Beds,Creampie,Dirty,Aggressive,AggressiveDefault")

	Base.Save(id)
endFunction

function ArrokMaleMasturbation(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Arrok Male Masturbation"

	int a1 = Base.AddPosition(Male)
	Base.AddPositionStage(a1, "Arrok_MaleMasturbation_A1_S1", -55.0, sos = 3)
	Base.AddPositionStage(a1, "Arrok_MaleMasturbation_A1_S2", -55.0, sos = 3)
	Base.AddPositionStage(a1, "Arrok_MaleMasturbation_A1_S3", -55.0, sos = 3)
	Base.AddPositionStage(a1, "Arrok_MaleMasturbation_A1_S4", -55.0, sos = 3)

	Base.SetTags("Arrok,Sex,Solo,Penis,Hands,Masturbation,Standing,AirCum,Dirty")

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
	Base.AddPositionStage(a2, "Arrok_Missionary_A2_S1", -105, sos = 2)
	Base.AddPositionStage(a2, "Arrok_Missionary_A2_S2", -105, sos = 2)
	Base.AddPositionStage(a2, "Arrok_Missionary_A2_S3", -105, sos = 4)
	Base.AddPositionStage(a2, "Arrok_Missionary_A2_S4", -107, sos = 4)

	Base.SetTags("Arrok,BBP,Sex,Penis,Vaginal,Missionary,Laying,Lying,OnBack,Facing,Kneeling,Holding,Beds,Creampie,Loving")

	Base.Save(id)
endFunction

function ArrokOral(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Arrok 69"
	Base.SoundFX = SexMix

	int a1 = Base.AddPosition(Female, Oral)
	Base.AddPositionStage(a1, "Arrok_Oral_A1_S1", 0, rotate = 180)
	Base.AddPositionStage(a1, "Arrok_Oral_A1_S2", 0, rotate = 180)
	Base.AddPositionStage(a1, "Arrok_Oral_A1_S3", 0, rotate = 180, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Arrok_Oral_A1_S3", 0, rotate = 180, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Arrok_Oral_A1_S4", 0, rotate = 180)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Arrok_Oral_A2_S1", -46, silent = true)
	Base.AddPositionStage(a2, "Arrok_Oral_A2_S1", -46, silent = true)
	Base.AddPositionStage(a2, "Arrok_Oral_A2_S2", -46, silent = true)
	Base.AddPositionStage(a2, "Arrok_Oral_A2_S3", -46, silent = true)
	Base.AddPositionStage(a2, "Arrok_Oral_A2_S3", -46, silent = true)

	Base.SetTags("Arrok,BBP,Sex,Pussy,Cunnilingus,Mouth,Kneeling,69,Laying,Blowjob,Facial,CumInMouth")

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

	Base.SetTags("Arrok,BBP,Sex,Penis,Vaginal,Cowgirl,Reverse,ReverseCowgirl,Creampie,Dirty")

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

	Base.SetTags("Arrok,BBP,Sex,Penis,Vaginal,Reverse,Beds,Creampie,Dirty,Sideways")

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

	Base.SetTags("Arrok,BBP,Sex,Penis,Vaginal,Standing,Reverse,Creampie")

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

	Base.SetTags("Arrok,BBP,Foreplay,Mouth,Penis,Vaginal,Kissing,LeadIn,Standing,Loving")

	Base.Save(id)
endFunction

function ArrokTricycle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Arrok Tricycle"
	Base.SoundFX = SexMix

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "Arrok_Tricycle_A1_S1", -1, up = 2, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Arrok_Tricycle_A1_S2", 0)
	Base.AddPositionStage(a1, "Arrok_Tricycle_A1_S3", 0)
	Base.AddPositionStage(a1, "Arrok_Tricycle_A1_S4", 1, side = 2.5, up = 3, silent = true, openMouth = true)

	int a2 = Base.AddPosition(Female)
	Base.AddPositionStage(a2, "Arrok_Tricycle_A2_S1", -100)
	Base.AddPositionStage(a2, "Arrok_Tricycle_A2_S2", -100)
	Base.AddPositionStage(a2, "Arrok_Tricycle_A2_S3", -100.5, silent = true, openMouth = true)
	Base.AddPositionStage(a2, "Arrok_Tricycle_A2_S4", -100, side = -1, up = 2, silent = true, openMouth = true)

	int a3 = Base.AddPosition(Male)
	Base.AddPositionStage(a3, "Arrok_Tricycle_A3_S1", 108, sos = -2)
	Base.AddPositionStage(a3, "Arrok_Tricycle_A3_S2", 108, silent = true, openMouth = true, sos = 5)
	Base.AddPositionStage(a3, "Arrok_Tricycle_A3_S3", 108, sos = -1)
	Base.AddPositionStage(a3, "Arrok_Tricycle_A3_S4", 108, sos = -3)

	Base.SetStageCumID(a1, 1, Oral, a3)
	Base.SetStageCumID(a1, 2, Vaginal, a3)
	Base.SetStageCumID(a1, 4, Oral, a3)

	Base.SetStageCumID(a2, 3, VaginalAnal, a3)
	Base.SetStageCumID(a2, 4, Oral, a3)

	Base.SetTags("Arrok,Sex,BBP,Vaginal,Oral,Penis,Blowjob,Cunnilingus,Orgy,Tricycle,Threeway,Dirty,Facial")

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

	Base.SetTags("Arrok,BBP,Sex,Penis,Vaginal,Facing,Standing,Holding,Hugging,Creampie,Loving")

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

	Base.SetTags("Arrok,BBP,Sex,Pussy,Hands,Boobs,Standing,69,Oral,Cunnilingus,Lesbian,Loving")

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

	Base.SetTags("Arrok,BBP,Mouth,Hands,Petting,Handjob,Kissing,Cuddling,Laying,Loving,HandsCum,Foreplay,LeadIn")

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

	Base.SetTags("Arrok,TBBP,Sex,Anal,Penis,Kneeling,Standing,Dirty")

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

	Base.SetTags("Arrok,TBBP,Sex,Anal,Penis,Doggystyle,Standing,Holding,Reverse,Behind,Facial,Aggressive,AggressiveDefault,Dirty")

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

	Base.SetBedOffsets(-30.0, 0, -37.0, 0)

	Base.SetTags("Arrok,TBBP,Sex,Penis,Boobs,Oral,Boobjob,Handjob,Blowjob,Facing,CumInMouth,Beds,BedOnly,Dirty")

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

	Base.SetTags("Sex,Penis,Anal,Doggystyle,Reverse,Behind,Holding,Kneeling,Standing,AnalCreampie,Aggressive,Default,AggressiveDefault")

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

	Base.SetTags("Sex,Penis,Anal,Doggy,Doggystyle,Reverse,Behind,Kneeling,Beds,AnalCum,Aggressive,AggressiveDefault,Default")

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

	Base.SetTags("Sex,Penis,Vaginal,Missionary,Laying,Lying,Facing,Beds,OnBack,Holding,Creampie,Aggressive,AggressiveDefault,Default")

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

	Base.SetTags("Default,Sex,Boobs,Breast,Penis,Boobjob,Laying,Facing,Beds,ChestCum,Dirty")

	Base.Save(id)
endFunction

function SexLabDoggyStyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "DoggyStyle"
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

	Base.SetTags("Default,Sex,Penis,Vaginal,Doggystyle,Doggy,Reverse,Beds,VaginalCum")

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

	Base.SetTags("Default,Sex,Penis,Vaginal,Facing,Kneeling,Hugging,Creampie,Loving")

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

	Base.SetTags("Default,Sex,Penis,Vaginal,Missionary,Laying,Lying,OnBack,Facing,Beds,Creampie,Loving")

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

	Base.SetTags("Default,Sex,Penis,Vaginal,Reverse,ReverseCowgirl,Standing,Creampie,Dirty")

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

	Base.SetTags("Default,Sex,Penis,Vaginal,Reverse,Sideways,Beds,Creampie,Dirty")

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

	Base.SetTags("Default,Sex,Penis,Vaginal,Facing,Standing,Holding,Creampie")

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

	Base.SetTags("Default,Sex,Pussy,Laying,Lesbian,Tribadism,Loving,Dirty")

	Base.Save(id)
endFunction

function BleaghFootJob(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Bleagh FootJob"

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Bleagh_FootJob_A1_S1", 0, rotate = 180)
	Base.AddPositionStage(a1, "Bleagh_FootJob_A1_S2", 0, rotate = 180)
	Base.AddPositionStage(a1, "Bleagh_FootJob_A1_S3", 0, rotate = 180)
	Base.AddPositionStage(a1, "Bleagh_FootJob_A1_S4", 0, rotate = 180)
	Base.AddPositionStage(a1, "Bleagh_FootJob_A1_S5", 0, rotate = 180)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Bleagh_FootJob_A2_S1", -42)
	Base.AddPositionStage(a2, "Bleagh_FootJob_A2_S2", -42)
	Base.AddPositionStage(a2, "Bleagh_FootJob_A2_S3", -42)
	Base.AddPositionStage(a2, "Bleagh_FootJob_A2_S4", -42)
	Base.AddPositionStage(a2, "Bleagh_FootJob_A2_S5", -42)

	Base.SetTags("Bleagh,Sex,Fetish,Feet,Penis,Laying,Beds,Footjob,FeetCum")

	Base.Save(id)
endFunction

function BleaghFemaleSolo(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Bleagh Female Masturbation"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "Bleagh_FemaleSolo_A1_S1", -55.0)
	Base.AddPositionStage(a1, "Bleagh_FemaleSolo_A1_S2", -55.0)
	Base.AddPositionStage(a1, "Bleagh_FemaleSolo_A1_S3", -55.0)
	Base.AddPositionStage(a1, "Bleagh_FemaleSolo_A1_S4", -55.0)
	Base.AddPositionStage(a1, "Bleagh_FemaleSolo_A1_S5", -55.0)

	Base.SetTags("Bleagh,Sex,Solo,Pussy,Hands,Laying,Beds,Masturbation,Dirty")

	Base.Save(id)
endFunction

function APAnal(int id)
	sslBaseAnimation Base = Create(id)

	Base.Enabled = true
	Base.Name    = "AP Anal"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "AP_Anal_A1_S1", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_Anal_A1_S2", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_Anal_A1_S3", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_Anal_A1_S4", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_Anal_A1_S5", 0, rotate = 180)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_Anal_A2_S1", -44)
	Base.AddPositionStage(a2, "AP_Anal_A2_S2", -44)
	Base.AddPositionStage(a2, "AP_Anal_A2_S3", -44)
	Base.AddPositionStage(a2, "AP_Anal_A2_S4", -44)
	Base.AddPositionStage(a2, "AP_Anal_A2_S5", -44)

	Base.SetTags("AP,Sex,Straight,Anal,Penis,Doggystyle,Reverse,Beds,AnalCreampie,Dirty")

	Base.Save(id)
endFunction

function APBedMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Enabled = true
	Base.Name    = "AP Bed Missionary"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "AP_BedMissionary_A1_S1", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_BedMissionary_A1_S2", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_BedMissionary_A1_S3", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_BedMissionary_A1_S4", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_BedMissionary_A1_S5", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_BedMissionary_A1_S6", 0, rotate = 180)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_BedMissionary_A2_S1", -44, sos = 5)
	Base.AddPositionStage(a2, "AP_BedMissionary_A2_S2", -44, sos = 5)
	Base.AddPositionStage(a2, "AP_BedMissionary_A2_S3", -44, sos = 5)
	Base.AddPositionStage(a2, "AP_BedMissionary_A2_S4", -44, sos = 5)
	Base.AddPositionStage(a2, "AP_BedMissionary_A2_S4", -44, sos = 5)
	Base.AddPositionStage(a2, "AP_BedMissionary_A2_S4", -44, sos = 5)

	Base.SetTags("AP,Sex,Straight,Penis,Vaginal,Missionary,Laying,Facing,Beds,Creampie,Loving")

	Base.Save(id)
endFunction

function APBlowjob(int id)
	sslBaseAnimation Base = Create(id)

	Base.Enabled = true
	Base.Name    = "AP Blowjob"
	Base.SoundFX = Sucking

	int a1 = Base.AddPosition(Female, Oral)
	Base.AddPositionStage(a1, "AP_Blowjob_A1_S1", 0, rotate = 180, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_Blowjob_A1_S2", 0, rotate = 180, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_Blowjob_A1_S3", 0, rotate = 180, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_Blowjob_A1_S4", 0, rotate = 180, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_Blowjob_A1_S5", 0, rotate = 180, silent = true, openMouth = true)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_Cowgirl_A2_S1", -43, sos = 1)
	Base.AddPositionStage(a2, "AP_Cowgirl_A2_S2", -43, sos = 1)
	Base.AddPositionStage(a2, "AP_Cowgirl_A2_S2", -43, sos = 1)
	Base.AddPositionStage(a2, "AP_Cowgirl_A2_S3", -43, sos = 1)
	Base.AddPositionStage(a2, "AP_Cowgirl_A2_S4", -43, sos = 1)

	Base.SetTags("AP,Sex,Straight,Penis,Oral,Blowjob,Laying,Facing,CumInMouth,LeadIn")

	Base.Save(id)
endFunction

function APBoobjob(int id)
	sslBaseAnimation Base = Create(id)

	Base.Enabled = true
	Base.Name    = "AP Boobjob"


	int a1 = Base.AddPosition(Female, Oral)
	Base.AddPositionStage(a1, "AP_Boobjob_A1_S1", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_Boobjob_A1_S2", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_Boobjob_A1_S3", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_Boobjob_A1_S4", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_Boobjob_A1_S5", 0, rotate = 180)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S1", -40, sos = 6)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S2", -40, sos = 6)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S3", -40, sos = 6)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S4", -40, sos = 6)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S5", -40, sos = 6)

	Base.SetTags("AP,Sex,Straight,Penis,Boobs,Breast,Standing,Facing,Boobjob,ChestCum,Dirty")

	Base.Save(id)
endFunction

function APCowgirl(int id)
	sslBaseAnimation Base = Create(id)

	Base.Enabled = true
	Base.Name    = "AP Cowgirl"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "AP_Cowgirl_A1_S1", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_Cowgirl_A1_S2", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_Cowgirl_A1_S3", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_Cowgirl_A1_S4", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_Cowgirl_A1_S5", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_Cowgirl_A1_S6", 0, rotate = 180)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_Cowgirl_A2_S1", -44, sos = 1)
	Base.AddPositionStage(a2, "AP_Cowgirl_A2_S2", -44, sos = 1)
	Base.AddPositionStage(a2, "AP_Cowgirl_A2_S2", -44, sos = 1)
	Base.AddPositionStage(a2, "AP_Cowgirl_A2_S3", -44, sos = 1)
	Base.AddPositionStage(a2, "AP_Cowgirl_A2_S4", -44, sos = 2)
	Base.AddPositionStage(a2, "AP_Cowgirl_A2_S4", -44, sos = 2)

	Base.SetTags("AP,Sex,Straight,Penis,Vaginal,Cowgirl,Facing,Beds,Creampie,Loving")

	Base.Save(id)
endFunction

function APFemaleSolo(int id)
	sslBaseAnimation Base = Create(id)

	Base.Enabled = true
	Base.Name    = "AP Female Masturbation"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "AP_FemaleSolo_A1_S1", -55.0)
	Base.AddPositionStage(a1, "AP_FemaleSolo_A1_S2", -55.0)
	Base.AddPositionStage(a1, "AP_FemaleSolo_A1_S3", -55.0)
	Base.AddPositionStage(a1, "AP_FemaleSolo_A1_S4", -55.0)
	Base.AddPositionStage(a1, "AP_FemaleSolo_A1_S5", -55.0)
	Base.AddPositionStage(a1, "AP_FemaleSolo_A1_S6", -55.0)

	Base.SetTags("AP,Sex,Solo,Pussy,Hands,Masturbation,Laying,Beds,Dirty")

	Base.Save(id)
endFunction

function APFisting(int id)
	sslBaseAnimation Base = Create(id)

	Base.Enabled = true
	Base.Name    = "AP Fisting"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "AP_Fisting_A1_S1", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_Fisting_A1_S2", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_Fisting_A1_S3", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_Fisting_A1_S4", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_Fisting_A1_S5", 0, rotate = 180)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_Fisting_A2_S1", -44, strapon = false)
	Base.AddPositionStage(a2, "AP_Fisting_A2_S2", -44, strapon = false)
	Base.AddPositionStage(a2, "AP_Fisting_A2_S3", -44, strapon = false)
	Base.AddPositionStage(a2, "AP_Fisting_A2_S4", -44, strapon = false)
	Base.AddPositionStage(a2, "AP_Fisting_A2_S4", -44, strapon = false)

	Base.SetTags("AP,Sex,Straight,Pussy,Hands,Missionary,Kneeling,Beds,Fisting,Dirty,Aggressive,AggressiveDefault,Rough")

	Base.Save(id)
endFunction

function APHandjob(int id)
	sslBaseAnimation Base = Create(id)

	Base.Enabled = true
	Base.Name    = "AP Handjob"


	int a1 = Base.AddPosition(Female, Oral)
	Base.AddPositionStage(a1, "AP_Handjob_A1_S1", 0, up = 0.5, rotate = 180, silent = true)
	Base.AddPositionStage(a1, "AP_Handjob_A1_S2", 0, up = 0.5, rotate = 180, silent = true)
	Base.AddPositionStage(a1, "AP_Handjob_A1_S3", 0, up = 0.5, rotate = 180, silent = true)
	Base.AddPositionStage(a1, "AP_Handjob_A1_S4", 0, up = 0.5, rotate = 180, silent = true)
	Base.AddPositionStage(a1, "AP_Handjob_A1_S5", 0, up = 0.5, rotate = 180, silent = true, openMouth = true)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S1", -44, side = -3, sos = 0)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S2", -44, side = -3, sos = 0)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S3", -44, side = -3, sos = 0)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S4", -44, side = -3, sos = 0)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S5", -44, side = -3, sos = 0)

	Base.SetTags("AP,Sex,Straight,Penis,Hands,Handjob,Masturbation,Standing,Kneeling,Facial,Loving")

	Base.Save(id)
endFunction

function APKneelBlowjob(int id)
	sslBaseAnimation Base = Create(id)

	Base.Enabled = true
	Base.Name    = "AP Kneeling Blowjob"
	Base.SoundFX = Sucking

	int a1 = Base.AddPosition(Female, Oral)
	Base.AddPositionStage(a1, "AP_KneelBlowjob_A1_S1", 0, rotate = 180, up = 1, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_KneelBlowjob_A1_S2", 0, rotate = 180, up = 1, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_KneelBlowjob_A1_S3", 0, rotate = 180, up = 1, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_KneelBlowjob_A1_S4", 0, rotate = 180, up = 1, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_KneelBlowjob_A1_S5", 0, rotate = 180, up = 1, silent = true, openMouth = true)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S1", -45, sos = 1)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S2", -45, sos = 1)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S3", -45, sos = 1)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S4", -45, sos = 1)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S5", -45, sos = 1)

	Base.SetTags("AP,Sex,Straight,Penis,Oral,Blowjob,Standing,Kneeling,CumInMouth,Loving,LeadIn")

	Base.Save(id)
endFunction

function APLegUp(int id)
	sslBaseAnimation Base = Create(id)

	Base.Enabled = true
	Base.Name    = "AP Leg Up Fuck"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "AP_LegUp_A1_S1", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_LegUp_A1_S2", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_LegUp_A1_S3", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_LegUp_A1_S4", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_LegUp_A1_S5", 0, rotate = 180)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_LegUp_A2_S1", -44, up = 5, sos = 3)
	Base.AddPositionStage(a2, "AP_LegUp_A2_S2", -44, up = 5, sos = 3)
	Base.AddPositionStage(a2, "AP_LegUp_A2_S3", -44, up = 5, sos = 3)
	Base.AddPositionStage(a2, "AP_LegUp_A2_S4", -44, up = 5, sos = 3)
	Base.AddPositionStage(a2, "AP_LegUp_A2_S5", -44, up = 5, sos = 3)

	Base.SetTags("AP,Sex,Dirty,Penis,Vaginal,Reverse,Standing,Creampie,Aggressive,AggressiveDefault")

	Base.Save(id)
endFunction

function APShoulder(int id)
	sslBaseAnimation Base = Create(id)

	Base.Enabled = true
	Base.Name    = "AP Shoulder"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "AP_Shoulder_A1_S1", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_Shoulder_A1_S2", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_Shoulder_A1_S3", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_Shoulder_A1_S4", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_Shoulder_A1_S5", 0, rotate = 180)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S1", -44, sos = 2)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S2", -44, sos = 2)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S3", -44, sos = 2)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S4", -44, sos = 2)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S5", -44, sos = 2)

	Base.SetTags("AP,Sex,Straight,Penis,Vaginal,Standing,Reverse,Loving,Creampie")

	Base.Save(id)
endFunction

function APStandBlowjob(int id)
	sslBaseAnimation Base = Create(id)

	Base.Enabled = true
	Base.Name    = "AP Standing Blowjob"
	Base.SoundFX = Sucking

	int a1 = Base.AddPosition(Female, Oral)
	Base.AddPositionStage(a1, "AP_StandBlowjob_A1_S1", 0, rotate = 180, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_StandBlowjob_A1_S2", 0, rotate = 180, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_StandBlowjob_A1_S3", 0, rotate = 180, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_StandBlowjob_A1_S4", 0, rotate = 180, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_StandBlowjob_A1_S5", 0, rotate = 180, silent = true, openMouth = true)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S1", -44, sos = -1)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S2", -44, sos = -1)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S3", -44, sos = -1)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S4", -44, sos = -1)
	Base.AddPositionStage(a2, "AP_IdleStand_A2_S5", -44, sos = -1)

	Base.SetTags("AP,Sex,Straight,Penis,Oral,Blowjob,Standing,Facing,Dirty,LeadIn,CumInMouth")

	Base.Save(id)
endFunction

function APStanding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Enabled = true
	Base.Name    = "AP Standing"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "AP_Standing_A1_S1", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_Standing_A1_S2", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_Standing_A1_S3", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_Standing_A1_S4", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_Standing_A1_S5", 0, rotate = 180)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_Standing_A2_S1", -43, sos = 2)
	Base.AddPositionStage(a2, "AP_Standing_A2_S2", -43, sos = 2)
	Base.AddPositionStage(a2, "AP_Standing_A2_S2", -43, sos = 2)
	Base.AddPositionStage(a2, "AP_Standing_A2_S3", -43, sos = 2)
	Base.AddPositionStage(a2, "AP_Standing_A2_S3", -43, sos = 2)

	Base.SetTags("AP,Sex,Straight,Vaginal,Standing,Creampie")

	Base.Save(id)
endFunction

function APDoggyStyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Enabled = true
	Base.Name    = "AP DoggyStyle"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "AP_DoggyStyle_A1_S1", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_DoggyStyle_A1_S2", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_DoggyStyle_A1_S3", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_DoggyStyle_A1_S4", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_DoggyStyle_A1_S5", 0, rotate = 180)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_HoldLegUp_A2_S1", -44)
	Base.AddPositionStage(a2, "AP_HoldLegUp_A2_S2", -44)
	Base.AddPositionStage(a2, "AP_HoldLegUp_A2_S2", -44)
	Base.AddPositionStage(a2, "AP_HoldLegUp_A2_S3", -44)
	Base.AddPositionStage(a2, "AP_HoldLegUp_A2_S3", -44)

	Base.SetTags("AP,Sex,Straight,Penis,Anal,Doggystyle,Doggy,Knees,Kneeling,Reverse,Beds,Creampie")

	Base.Save(id)
endFunction

function APHoldLegUp(int id)
	sslBaseAnimation Base = Create(id)

	Base.Enabled = true
	Base.Name    = "AP Holding Leg Up"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "AP_HoldLegUp_A1_S1", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_HoldLegUp_A1_S2", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_HoldLegUp_A1_S3", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_HoldLegUp_A1_S4", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_HoldLegUp_A1_S5", 0, rotate = 180)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_HoldLegUp_A2_S1", -44)
	Base.AddPositionStage(a2, "AP_HoldLegUp_A2_S2", -44)
	Base.AddPositionStage(a2, "AP_HoldLegUp_A2_S2", -44)
	Base.AddPositionStage(a2, "AP_HoldLegUp_A2_S3", -44)
	Base.AddPositionStage(a2, "AP_HoldLegUp_A2_S3", -44)

	Base.SetTags("AP,Sex,Straight,Penis,Vaginal,Missionary,OnBack,Standing,Facing,Creampie,Aggressive,AggressiveDefault")

	Base.Save(id)
endFunction

function APFaceDown(int id)
	sslBaseAnimation Base = Create(id)

	Base.Enabled = true
	Base.Name    = "AP Face Down Anal"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "AP_FaceDown_A1_S1", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_FaceDown_A1_S2", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_FaceDown_A1_S3", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_FaceDown_A1_S4", 0, rotate = 180)
	Base.AddPositionStage(a1, "AP_FaceDown_A1_S5", 0, rotate = 180)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_FaceDown_A2_S1", -44)
	Base.AddPositionStage(a2, "AP_FaceDown_A2_S2", -44)
	Base.AddPositionStage(a2, "AP_FaceDown_A2_S3", -44)
	Base.AddPositionStage(a2, "AP_FaceDown_A2_S3", -44)
	Base.AddPositionStage(a2, "AP_FaceDown_A2_S4", -44)

	Base.SetTags("AP,Sex,Straight,Penis,Vaginal,Missionary,Laying,Lying,OnBack,Beds,Reverse,Creampie,Aggressive,AggressiveDefault,Dirty")

	Base.Save(id)
endFunction

function APSkullFuck(int id)
	sslBaseAnimation Base = Create(id)

	Base.Enabled = true
	Base.Name    = "AP Skull Fuck"
	Base.SoundFX = Sucking

	int a1 = Base.AddPosition(Female, Oral)
	Base.AddPositionStage(a1, "AP_SkullFuck_A1_S1", 0, rotate = 180, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_SkullFuck_A1_S2", 0, rotate = 180, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_SkullFuck_A1_S3", 0, rotate = 180, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_SkullFuck_A1_S4", 0, rotate = 180, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "AP_SkullFuck_A1_S5", 0, rotate = 180, silent = true, openMouth = true)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "AP_SkullFuck_A2_S1", -49, sos = 1)
	Base.AddPositionStage(a2, "AP_SkullFuck_A2_S2", -49, sos = 1)
	Base.AddPositionStage(a2, "AP_SkullFuck_A2_S3", -49, sos = 2)
	Base.AddPositionStage(a2, "AP_SkullFuck_A2_S4", -49, sos = 2)
	Base.AddPositionStage(a2, "AP_SkullFuck_A2_S5", -49, sos = 2)

	Base.SetTags("AP,Sex,Straight,Penis,Oral,Holding,Blowjob,CumInMouth,Aggressive,AggressiveDefault,Dirty")

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

	Base.SetTags("Zyn,Sex,Oral,Vaginal,Facing,Acrobatic,Standing,Aggressive,AggressiveDefault,Rough,Creampie")

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

	Base.SetTags("Zyn,Sex,Mouth,Pussy,Facing,Standing,Kissing,Loving,Lesbian")

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

	Base.SetTags("Zyn,Sex,Mouth,Pussy,Oral,Lesbian,Cunnilingus,Licking,Laying,Kneeling,Loving")

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

	Base.SetTags("Sex,Zyn,BBP,Anal,Vaginal,Standing,Laying,Orgy,Dirty,VaginalCum,AnalCum")

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

	Base.SetTags("Sex,Zyn,BBP,Vaginal,Anal,Oral,Orgy,Dirty")

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
	Base.AddPositionStage(a2, "Zyn_Missionary_A2_S3", -105)
	Base.AddPositionStage(a2, "Zyn_Missionary_A2_S4", -105)
    Base.AddPositionStage(a2, "Zyn_Missionary_A2_S5", -105, sos = 7)

	Base.SetTags("Zyn,BBP,Sex,Pussy,Vaginal,Penis,Missionary,Laying,Lying,OnBack,Beds,ChestCum,EatingCum,Loving")

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

	Base.SetTags("Zyn,BBP,Sex,Penis,Vaginal,Reverse,Doggystyle,Doggy,Kneeling,Dirty,Creampie")

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

	Base.SetTags("Sex,Zyn,Oral,Vaginal,Anal,Orgy,Dirty")

	Base.Save(id)
endFunction

function ZynStanding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "Zyn Standing"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, addCum=Vaginal)
	Base.AddPositionStage(a1, "Zyn_Standing_A1_S1", 0)
	Base.AddPositionStage(a1, "Zyn_Standing_A1_S2", 0, openMouth = true)
	Base.AddPositionStage(a1, "Zyn_Standing_A1_S3", 0)
	Base.AddPositionStage(a1, "Zyn_Standing_A1_S4", 0)
	Base.AddPositionStage(a1, "Zyn_Standing_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Zyn_Standing_A2_S1", 0)
	Base.AddPositionStage(a2, "Zyn_Standing_A2_S2", 0)
	Base.AddPositionStage(a2, "Zyn_Standing_A2_S3", 0)
	Base.AddPositionStage(a2, "Zyn_Standing_A2_S4", 0)
	Base.AddPositionStage(a2, "Zyn_Standing_A2_S5", 0)

	Base.SetStageTimer(5, 9.0)

	Base.SetStageSoundFX(1, none)
	Base.SetStageSoundFX(2, Sucking)
	Base.SetStageSoundFX(3, Sucking)

	Base.SetStageCumID(a1, 1, Vaginal)
	Base.SetStageCumID(a1, 2, Oral)

	Base.SetTags("Zyn,Sex,Straight,Penis,Vaginal,Standing,Acrobatic,Dirty,Creampie")

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

	Base.SetTags("Sex,Dark Investigations,zDI,Athstai,Oral,Vaginal,Doggystyle,Doggy,Blowjob,Orgy,Holding,Dirty,Forced,Facial,VaginalCum,AnalCum")

	Base.Save(id)
endFunction

function DarkInvestigationsDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "DI DoggyStyle"
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

	Base.SetTags("Sex,Dark Investigations,zDI,Athstai,Penis,Vaginal,Doggystyle,Doggy,Beds,Dirty,AnalCum")

	Base.Save(id)
endFunction


function DarkInvestigationsBlowjob(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "DI Blowjob"
	Base.SoundFX = Sucking

	int a1 = Base.AddPosition(Female, Oral)
	Base.AddPositionStage(a1, "zdi2_Blowjob_A1_S1", 0, rotate = 180)
	Base.AddPositionStage(a1, "zdi2_Blowjob_A1_S2", 0, rotate = 180, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "zdi2_Blowjob_A1_S3", 0, rotate = 180, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "zdi2_Blowjob_A1_S4", 0, rotate = 180, openMouth = true)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "zdi2_Blowjob_A2_S1", -50, sos = 0)
	Base.AddPositionStage(a2, "zdi2_Blowjob_A2_S2", -50, sos = 0)
	Base.AddPositionStage(a2, "zdi2_Blowjob_A2_S3", -50, sos = 0)
	Base.AddPositionStage(a2, "zdi2_Blowjob_A2_S4", -50, sos = 0)

	Base.SetStageSoundFX(1, none)
	Base.SetStageSoundFX(4, none)
	Base.SetStageTimer(4, 12.0)

	Base.SetTags("Sex,Dark Investigations,zDI,Athstai,Oral,Handjob,Blowjob,Standing,Dirty,Facial")

	Base.Save(id)
endFunction

function zjAnal(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "3jiou Anal"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, addCum=Anal)
	Base.AddPositionStage(a1, "3j_Anal_A1_S1", 0)
	Base.AddPositionStage(a1, "3j_Anal_A1_S2", 0)
	Base.AddPositionStage(a1, "3j_Anal_A1_S3", 0)
	Base.AddPositionStage(a1, "3j_Anal_A1_S4", 0)
	Base.AddPositionStage(a1, "3j_Anal_A1_S5", 0)
	
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "3j_Anal_A2_S1", 0, sos = 0)
	Base.AddPositionStage(a2, "3j_Anal_A2_S2", 0, sos = 6)
	Base.AddPositionStage(a2, "3j_Anal_A2_S3", 0, sos = 4)
	Base.AddPositionStage(a2, "3j_Anal_A2_S4", 0, sos = 2)
	Base.AddPositionStage(a2, "3j_Anal_A2_S5", 0, sos = 3)
	
	Base.SetTags("3jiou,Sex,Penis,Anal,Missionary,Cowgirl,Reverse,Behind,Dirty,Beds,Acrobatic,AnalCreampie")

	Base.Save(id)
endFunction

function zjCowgirl(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "3jiou Cowgirl"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, addCum=Vaginal)
	Base.AddPositionStage(a1, "3j_Cowgirl_A1_S1", 0)
	Base.AddPositionStage(a1, "3j_Cowgirl_A1_S2", 0)
	Base.AddPositionStage(a1, "3j_Cowgirl_A1_S3", 0)
	Base.AddPositionStage(a1, "3j_Cowgirl_A1_S4", 0)
	Base.AddPositionStage(a1, "3j_Cowgirl_A1_S5", 0)
		
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "3j_Cowgirl_A2_S1", 0)
	Base.AddPositionStage(a2, "3j_Cowgirl_A2_S2", 0)
	Base.AddPositionStage(a2, "3j_Cowgirl_A2_S3", 0)
	Base.AddPositionStage(a2, "3j_Cowgirl_A2_S4", 0)
	Base.AddPositionStage(a2, "3j_Cowgirl_A2_S5", 0)
	
	Base.SetTags("3jiou,Sex,Penis,Vaginal,Cowgirl,Reverse,Beds,Creampie,Dirty")

	Base.Save(id)
endFunction

function zjDoggy(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "3jiou DoggyStyle"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, addCum=Anal)
	Base.AddPositionStage(a1, "3j_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "3j_Doggystyle_A1_S2", 0)
	Base.AddPositionStage(a1, "3j_Doggystyle_A1_S3", 0)
	Base.AddPositionStage(a1, "3j_Doggystyle_A1_S4", 0)
	
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "3j_Doggystyle_A2_S1", 0)
	Base.AddPositionStage(a2, "3j_Doggystyle_A2_S2", 0)
	Base.AddPositionStage(a2, "3j_Doggystyle_A2_S3", 0)
	Base.AddPositionStage(a2, "3j_Doggystyle_A2_S4", 0)
	
	Base.SetTags("3jiou,Sex,Penis,Vaginal,Doggystyle,Doggy,Behind,Reverse,Standing,Creampie,Dirty")

	Base.Save(id)
endFunction

function zjDomination(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "3jiou Domination"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, addCum=Vaginal)
	Base.AddPositionStage(a1, "3j_Domination_A1_S1", 0)
	Base.AddPositionStage(a1, "3j_Domination_A1_S2", 0)
	Base.AddPositionStage(a1, "3j_Domination_A1_S3", 0)
	Base.AddPositionStage(a1, "3j_Domination_A1_S4", 0)
	Base.AddPositionStage(a1, "3j_Domination_A1_S5", 0)
	
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "3j_Domination_A2_S1", 0)
	Base.AddPositionStage(a2, "3j_Domination_A2_S2", 0)
	Base.AddPositionStage(a2, "3j_Domination_A2_S3", 0)
	Base.AddPositionStage(a2, "3j_Domination_A2_S4", 0)
	Base.AddPositionStage(a2, "3j_Domination_A2_S5", 0)

	Base.SetTags("3jiou,Sex,Penis,Vaginal,Missionary,Doggystyle,Facing,Reverse,Dirty,Behind,Standing,Creampie")

	Base.Save(id)
endFunction

function zjEroMassage(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "3jiou Ero Massage"

	int a1 = Base.AddPosition(Female, addCum=Oral)
	Base.AddPositionStage(a1, "3j_Massage_A1_S1", 0)
	Base.AddPositionStage(a1, "3j_Massage_A1_S2", 0)
	Base.AddPositionStage(a1, "3j_Massage_A1_S3", 0)

	int a2 = Base.AddPosition(Male) 
	Base.AddPositionStage(a2, "3j_Massage_A2_S1", 0, silent = true)
	Base.AddPositionStage(a2, "3j_Massage_A2_S2", 0, silent = true)
	Base.AddPositionStage(a2, "3j_Massage_A2_S3", 0)

	Base.SetTags("3jiou,Penis,Hands,Cowgirl,Laying,Lying,Beds,Facing,Reverse,Foreplay,LeadIn,HandsCum")

	Base.Save(id)
endFunction


function zjHolding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "3jiou Holding"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, addCum=Anal)
	Base.AddPositionStage(a1, "3j_Holding_A1_S1", 0)
	Base.AddPositionStage(a1, "3j_Holding_A1_S2", 0)
	Base.AddPositionStage(a1, "3j_Holding_A1_S3", 0)
	Base.AddPositionStage(a1, "3j_Holding_A1_S4", 0)
	
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "3j_Holding_A2_S1", 0, sos = 9)
	Base.AddPositionStage(a2, "3j_Holding_A2_S2", 0, sos = 0)
	Base.AddPositionStage(a2, "3j_Holding_A2_S3", 0, sos = -2)
	Base.AddPositionStage(a2, "3j_Holding_A2_S4", 0, sos = 9)
	
	Base.SetTags("3jiou,Sex,Penis,Vaginal,Standing,Reverse,Holding,Doggystyle,Loving,Creampie")

	Base.Save(id)
endFunction


function zjLaying(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "3jiou Laying"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, addCum=Anal)
	Base.AddPositionStage(a1, "3j_Laying_A1_S1", 0)
	Base.AddPositionStage(a1, "3j_Laying_A1_S2", 0)
	Base.AddPositionStage(a1, "3j_Laying_A1_S3", 0)
	Base.AddPositionStage(a1, "3j_Laying_A1_S4", 0)
	Base.AddPositionStage(a1, "3j_Laying_A1_S5", 0)
	
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "3j_Laying_A2_S1", 0, sos = 3)
	Base.AddPositionStage(a2, "3j_Laying_A2_S2", 0, sos = 3)
	Base.AddPositionStage(a2, "3j_Laying_A2_S3", 0, sos = 3)
	Base.AddPositionStage(a2, "3j_Laying_A2_S4", 0, sos = 3)
	Base.AddPositionStage(a2, "3j_Laying_A2_S5", 0, sos = 3)
	
	Base.SetStageCumID(a1, 1, Vaginal)
	Base.SetStageCumID(a1, 2, Anal)
	Base.SetStageCumID(a1, 3, Anal)
	Base.SetStageCumID(a1, 4, Vaginal)
	Base.SetStageCumID(a1, 5, Oral)

	Base.SetTags("3jiou,Sex,Penis,Vaginal,Missionary,Facing,Laying,Lying,Reverse,OnBack,Acrobatic,Creampie")

	Base.Save(id)
endFunction

function zjLyingVar(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "3jiou Laying Variant"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, addCum=Anal)
	Base.AddPositionStage(a1, "3j_Layingvar_A1_S1", 0)
	Base.AddPositionStage(a1, "3j_Layingvar_A1_S2", 0)
	Base.AddPositionStage(a1, "3j_Layingvar_A1_S3", 0)
	Base.AddPositionStage(a1, "3j_Layingvar_A1_S4", 0)
	Base.AddPositionStage(a1, "3j_Layingvar_A1_S5", 0)
	
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "3j_Layingvar_A2_S1", 0, sos = 0)
	Base.AddPositionStage(a2, "3j_Layingvar_A2_S2", 0, sos = 9)
	Base.AddPositionStage(a2, "3j_Layingvar_A2_S3", 0, sos = 0)
	Base.AddPositionStage(a2, "3j_Layingvar_A2_S4", 0, sos = 0)
	Base.AddPositionStage(a2, "3j_Layingvar_A2_S5", 0, sos = 0)

	Base.SetStageCumID(a1, 1, Oral)
	Base.SetStageCumID(a1, 3, Vaginal)

	Base.SetTags("3jiou,Sex,Penis,Boobs,Vaginal,Cowgirl,Reverse,Boobjob,Laying,Lying,OnBack,Acrobatic,Creampie")

	Base.Save(id)
endFunction

function zjMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "3jiou Missionary"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, addCum=VaginalAnal)
	Base.AddPositionStage(a1, "3j_Missionary_A1_S1", 0)
	Base.AddPositionStage(a1, "3j_Missionary_A1_S2", 0)
	Base.AddPositionStage(a1, "3j_Missionary_A1_S3", 0)
	Base.AddPositionStage(a1, "3j_Missionary_A1_S4", 0)
	
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "3j_Missionary_A2_S1", 0)
	Base.AddPositionStage(a2, "3j_Missionary_A2_S2", 0)
	Base.AddPositionStage(a2, "3j_Missionary_A2_S3", 0)
	Base.AddPositionStage(a2, "3j_Missionary_A2_S4", 0)
	
	Base.SetTags("3jiou,Sex,Penis,Vaginal,Laying,Missionary,Beds,Loving,Laying,Lying,OnBack,Creampie")

	Base.Save(id)
endFunction

function zjStanding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "3jiou Standing"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, addCum=Vaginal)
	Base.AddPositionStage(a1, "3j_Standing_A1_S1", 0)
	Base.AddPositionStage(a1, "3j_Standing_A1_S2", 0)
	Base.AddPositionStage(a1, "3j_Standing_A1_S3", 0)
	Base.AddPositionStage(a1, "3j_Standing_A1_S4", 0)
	Base.AddPositionStage(a1, "3j_Standing_A1_S5", 0)
	Base.AddPositionStage(a1, "3j_Standing_A1_S6", 0)
	
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "3j_Standing_A2_S1", 0, sos = 2)
	Base.AddPositionStage(a2, "3j_Standing_A2_S2", 0, sos = 3)
	Base.AddPositionStage(a2, "3j_Standing_A2_S3", 0, sos = 3)
	Base.AddPositionStage(a2, "3j_Standing_A2_S4", 0, sos = 1)
	Base.AddPositionStage(a2, "3j_Standing_A2_S5", 0, sos = 2)
	Base.AddPositionStage(a2, "3j_Standing_A2_S6", 0, sos = 4)
	
	Base.SetTags("3jiou,Sex,Penis,Vaginal,Standing,Behind,Reverse,Creampie")

	Base.Save(id)
endFunction

function zjStandingVar(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "3jiou Standing Variant"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, addCum=Vaginal)
	Base.AddPositionStage(a1, "3j_Standingvar_A1_S1", 0)
	Base.AddPositionStage(a1, "3j_Standingvar_A1_S2", 0)
	Base.AddPositionStage(a1, "3j_Standingvar_A1_S3", 0)
	Base.AddPositionStage(a1, "3j_Standingvar_A1_S4", 0)
	Base.AddPositionStage(a1, "3j_Standingvar_A1_S5", 0)
	
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "3j_Standingvar_A2_S1", 0, sos = 4)
	Base.AddPositionStage(a2, "3j_Standingvar_A2_S2", 0, sos = 6)
	Base.AddPositionStage(a2, "3j_Standingvar_A2_S3", 0, sos = 4)
	Base.AddPositionStage(a2, "3j_Standingvar_A2_S4", 0, sos = 2)
	Base.AddPositionStage(a2, "3j_Standingvar_A2_S5", 0, sos = 4)
	
	Base.SetTags("3jiou,Sex,Penis,Vaginal,Standing,Reverse,Behind,Creampie")

	Base.Save(id)
endFunction

function zjBreastFeeding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "3jiou Breastfeeding Lesbian"
	Base.SoundFX = Sucking

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "3j_BreastFeeding_A1_S1", 0)
	Base.AddPositionStage(a1, "3j_BreastFeeding_A1_S2", 0)
	Base.AddPositionStage(a1, "3j_BreastFeeding_A1_S3", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "3j_BreastFeeding_A1_S4", 0)
	
	int a2 = Base.AddPosition(Female)
	Base.AddPositionStage(a2, "3j_BreastFeeding_A2_S1", -2, up = 1, silent = true, openMouth = true)
	Base.AddPositionStage(a2, "3j_BreastFeeding_A2_S2", -0.5, up = 2, silent = true, openMouth = true)
	Base.AddPositionStage(a2, "3j_BreastFeeding_A2_S3", 2, up = 2)
	Base.AddPositionStage(a2, "3j_BreastFeeding_A2_S4", 0)

	Base.SetTags("3jiou,Boobs,Breast,Hands,Pussy,Mouth,Breastfeeding,Boobjob,Loving,Foreplay,Leadin,Kissing,Lesbian")

	Base.Save(id)
endFunction


function zjBreastFeedingVar(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "3jiou Breastfeeding Straight"
	Base.SoundFX = Sucking

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "3j_BreastFeedingvar_A1_S1", 0)
	Base.AddPositionStage(a1, "3j_BreastFeedingvar_A1_S2", 0)
	Base.AddPositionStage(a1, "3j_BreastFeedingvar_A1_S3", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "3j_BreastFeedingvar_A1_S3", 0)
	
	int a2 = Base.AddPosition(Male, addCum=Vaginal)
	Base.AddPositionStage(a2, "3j_BreastFeedingvar_A2_S1", -2, up = 1, silent = true, openMouth = true)
	Base.AddPositionStage(a2, "3j_BreastFeedingvar_A2_S2", -0.5, up = 2, silent = true, openMouth = true)
	Base.AddPositionStage(a2, "3j_BreastFeedingvar_A2_S3", 2, up = 2, sos = -1)		
	Base.AddPositionStage(a2, "3j_BreastFeedingvar_A2_S3", 0, sos = -1)	

	Base.SetTags("3jiou,Sex,Straight,Boobs,Breast,Hands,Pussy,Mouth,Breastfeeding,Handjob,Loving,HandsCum")

	Base.Save(id)
endFunction

function zjThreesome(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "3jiou Threesome"
	Base.SoundFX = SexMix

	int a1 = Base.AddPosition(Female, addCum=Anal)
	Base.AddPositionStage(a1, "3j_FFM_A1_S1", 0, openMouth = true)
	Base.AddPositionStage(a1, "3j_FFM_A1_S2", 0, openMouth = true)
	Base.AddPositionStage(a1, "3j_FFM_A1_S3", 0, openMouth = true)
	Base.AddPositionStage(a1, "3j_FFM_A1_S4", 0, openMouth = true)
	Base.AddPositionStage(a1, "3j_FFM_A1_S5", 0)

	int a2 = Base.AddPosition(Female)
	Base.AddPositionStage(a2, "3j_FFM_A2_S1", 0)
	Base.AddPositionStage(a2, "3j_FFM_A2_S2", 0)
	Base.AddPositionStage(a2, "3j_FFM_A2_S3", 0)
	Base.AddPositionStage(a2, "3j_FFM_A2_S4", 0)
	Base.AddPositionStage(a2, "3j_FFM_A2_S5", 0)

	int a3 = Base.AddPosition(Male)
	Base.AddPositionStage(a3, "3j_FFM_A3_S1", 0)
	Base.AddPositionStage(a3, "3j_FFM_A3_S2", 0)
	Base.AddPositionStage(a3, "3j_FFM_A3_S3", 0)
	Base.AddPositionStage(a3, "3j_FFM_A3_S4", 0)
	Base.AddPositionStage(a3, "3j_FFM_A3_S5", 0)

	Base.SetStageCumID(a1, 1, Anal, a3)
	Base.SetStageCumID(a1, 2, Anal, a3)
	Base.SetStageCumID(a1, 3, Anal, a3)
	Base.SetStageCumID(a1, 4, Vaginal, a3)
	Base.SetStageCumID(a1, 5, Anal, a3)

	Base.SetStageCumID(a2, 4, Oral, a3)
	Base.SetStageCumID(a2, 5, Oral, a3)

	Base.SetTags("3jiou,Sex,BBP,Oral,Vaginal,Anal,Doggystyle,Doggy,Blowjob,Orgy,Dirty")

	Base.Save(id)
endFunction

function LeitoBlowjob(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "Leito Blowjob"
	Base.SoundFX = Sucking

	int a1 = Base.AddPosition(Female, addCum=Oral)
	Base.AddPositionStage(a1, "Leito_BlowJob_A1_S1", 0, silent = true)
	Base.AddPositionStage(a1, "Leito_BlowJob_A1_S2", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Leito_BlowJob_A1_S3", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Leito_BlowJob_A1_S4", 0, silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Leito_BlowJob_A1_S5", 0, silent = true, openMouth = true)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Leito_BlowJob_A2_S1", 0, sos = 1)
	Base.AddPositionStage(a2, "Leito_BlowJob_A2_S2", 0, sos = 3)
	Base.AddPositionStage(a2, "Leito_BlowJob_A2_S3", 0, sos = 2)
	Base.AddPositionStage(a2, "Leito_BlowJob_A2_S4", 0, sos = 2)
	Base.AddPositionStage(a2, "Leito_BlowJob_A2_S5", 0, sos = -1)

	Base.SetStageSoundFX(1, none)

	Base.SetTags("Leito,Sex,Straight,Penis,Hands,Oral,Kneeling,Knees,Standing,Handjob,Blowjob,Dirty,CumInMouth")

	Base.Save(id)
endFunction

function LeitoCunnilingus(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "Leito Cunnilingus"
	Base.SoundFX = Sucking

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "Leito_Cunnilingus_A1_S1", -50.0)
	Base.AddPositionStage(a1, "Leito_Cunnilingus_A1_S2", -50.0)
	Base.AddPositionStage(a1, "Leito_Cunnilingus_A1_S3", -50.0)
	Base.AddPositionStage(a1, "Leito_Cunnilingus_A1_S4", -50.0)
	Base.AddPositionStage(a1, "Leito_Cunnilingus_A1_S5", -50.0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Leito_Cunnilingus_A2_S1", -50.0, sos = 3)
	Base.AddPositionStage(a2, "Leito_Cunnilingus_A2_S2", -50.0, silent = true, sos = 3)
	Base.AddPositionStage(a2, "Leito_Cunnilingus_A2_S3", -50.0, silent = true, sos = 3)
	Base.AddPositionStage(a2, "Leito_Cunnilingus_A2_S4", -50.0, silent = true, sos = 3)
	Base.AddPositionStage(a2, "Leito_Cunnilingus_A2_S5", -50.0, sos = 3)

	Base.SetStageTimer(5, 7.0)

	Base.SetTags("Leito,Sex,Pussy,Hands,Mouth,Cunnilingus,Doggystyle,Missionary,Foreplay,LeadIn")

	Base.Save(id)
endFunction

function LeitoCowgirl(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "Leito Cowgirl"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, addCum=Vaginal)
	Base.AddPositionStage(a1, "Leito_Cowgirl_A1_S1", 0)
	Base.AddPositionStage(a1, "Leito_Cowgirl_A1_S2", 0)
	Base.AddPositionStage(a1, "Leito_Cowgirl_A1_S3", 0)
	Base.AddPositionStage(a1, "Leito_Cowgirl_A1_S4", 0)
	Base.AddPositionStage(a1, "Leito_Cowgirl_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Leito_Cowgirl_A2_S1", 0, sos = 3)
	Base.AddPositionStage(a2, "Leito_Cowgirl_A2_S2", 0, sos = 3)
	Base.AddPositionStage(a2, "Leito_Cowgirl_A2_S3", 0, sos = 3)
	Base.AddPositionStage(a2, "Leito_Cowgirl_A2_S4", 0, sos = 3)
	Base.AddPositionStage(a2, "Leito_Cowgirl_A2_S5", 0, sos = 3)

	Base.SetStageSoundFX(5, none)

	Base.SetTags("Leito,Sex,Straight,Penis,Vaginal,Cowgirl,Facing,Creampie,Dirty")

	Base.Save(id)
endFunction

function LeitoDoggy(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "Leito DoggyStyle"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, addCum=Vaginal)
	Base.AddPositionStage(a1, "Leito_Doggystyle_A1_S1", 0)
	Base.AddPositionStage(a1, "Leito_Doggystyle_A1_S2", 0)
	Base.AddPositionStage(a1, "Leito_Doggystyle_A1_S3", 0)
	Base.AddPositionStage(a1, "Leito_Doggystyle_A1_S4", 0)
	Base.AddPositionStage(a1, "Leito_Doggystyle_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Leito_Doggystyle_A2_S1", 0, sos = 3)
	Base.AddPositionStage(a2, "Leito_Doggystyle_A2_S2", 0, sos = 3)
	Base.AddPositionStage(a2, "Leito_Doggystyle_A2_S3", 0, sos = 3)
	Base.AddPositionStage(a2, "Leito_Doggystyle_A2_S4", 0, sos = 3)
	Base.AddPositionStage(a2, "Leito_Doggystyle_A2_S5", 0, sos = 3)

	Base.SetStageSoundFX(1, none)
	Base.SetStageSoundFX(5, none)

	Base.SetTags("Leito,Sex,Straight,Penis,Vaginal,Doggy,Doggystyle,Reverse,Knees,Standing,Hugging,Creampie,Dirty")

	Base.Save(id)
endFunction

function LeitoDoggyAnal(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "Leito DoggyStyle Anal"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, addCum=Anal)
	Base.AddPositionStage(a1, "Leito_DoggystyleAnal_A1_S1", 0)
	Base.AddPositionStage(a1, "Leito_DoggystyleAnal_A1_S2", 0)
	Base.AddPositionStage(a1, "Leito_DoggystyleAnal_A1_S3", 0)
	Base.AddPositionStage(a1, "Leito_DoggystyleAnal_A1_S4", 0)
	Base.AddPositionStage(a1, "Leito_DoggystyleAnal_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Leito_DoggystyleAnal_A2_S1", 0, sos = 0)
	Base.AddPositionStage(a2, "Leito_DoggystyleAnal_A2_S2", 0, sos = 0)
	Base.AddPositionStage(a2, "Leito_DoggystyleAnal_A2_S3", 0, sos = 0)
	Base.AddPositionStage(a2, "Leito_DoggystyleAnal_A2_S4", 0, sos = 0)
	Base.AddPositionStage(a2, "Leito_DoggystyleAnal_A2_S5", 0, sos = 0)

	Base.SetTags("Leito,Sex,Straight,Penis,Anal,Anus,Doggy,Doggystyle,Knees,Behind,Dirty,AnalCreampie")

	Base.Save(id)
endFunction

function LeitoFemaleSolo(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "Leito Female Masturbation"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "Leito_FemaleSolo_A1_S1", -55.0)
	Base.AddPositionStage(a1, "Leito_FemaleSolo_A1_S2", -55.0)
	Base.AddPositionStage(a1, "Leito_FemaleSolo_A1_S3", -55.0)
	Base.AddPositionStage(a1, "Leito_FemaleSolo_A1_S4", -55.0)
	Base.AddPositionStage(a1, "Leito_FemaleSolo_A1_S5", -55.0)

	Base.SetStageTimer(5, 8.2)
	
	Base.SetTags("Leito,Solo,Pussy,Hands,Doggystyle,Kneeling,Masturbation,Dirty")

	Base.Save(id)
endFunction

function LeitoFeet(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "Leito Footjob 1"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "Leito_Feet_A1_S1", 0)
	Base.AddPositionStage(a1, "Leito_Feet_A1_S2", 0)
	Base.AddPositionStage(a1, "Leito_Feet_A1_S3", 0)
	Base.AddPositionStage(a1, "Leito_Feet_A1_S4", 0)
	Base.AddPositionStage(a1, "Leito_Feet_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Leito_Feet_A2_S1", 0, sos = 3)
	Base.AddPositionStage(a2, "Leito_Feet_A2_S2", 0, sos = 3)
	Base.AddPositionStage(a2, "Leito_Feet_A2_S3", 0, sos = 3)
	Base.AddPositionStage(a2, "Leito_Feet_A2_S4", 0, sos = 3)
	Base.AddPositionStage(a2, "Leito_Feet_A2_S5", 0, sos = 3)

	Base.SetStageSoundFX(1, none)
	Base.SetStageSoundFX(2, none)
	Base.SetStageSoundFX(5, none)

	Base.SetTags("Leito,Sex,Straight,Penis,Mouth,Fetish,Feet,Footjob,Missionary,Dirty,FeetCum")

	Base.Save(id)
endFunction

function LeitoFeet2(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "Leito Footjob 2"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "Leito_Feet2_A1_S1", 0)
	Base.AddPositionStage(a1, "Leito_Feet2_A1_S2", 0)
	Base.AddPositionStage(a1, "Leito_Feet2_A1_S3", 0)
	Base.AddPositionStage(a1, "Leito_Feet2_A1_S4", 0)
	Base.AddPositionStage(a1, "Leito_Feet2_A1_S5", 0)

	int a2 = Base.AddPosition(Male, addCum=Vaginal)
	Base.AddPositionStage(a2, "Leito_Feet2_A2_S1", 0, sos = 9)
	Base.AddPositionStage(a2, "Leito_Feet2_A2_S2", 0, sos = 1)
	Base.AddPositionStage(a2, "Leito_Feet2_A2_S3", 0, sos = 0)
	Base.AddPositionStage(a2, "Leito_Feet2_A2_S4", 0, sos = 0)
	Base.AddPositionStage(a2, "Leito_Feet2_A2_S5", 0, sos = 0)

	Base.SetStageSoundFX(1, none)
	Base.SetStageSoundFX(2, none)
	Base.SetStageSoundFX(5, none)

	Base.SetTags("Leito,Sex,Straight,Penis,Mouth,Feet,Footjob,Cowgirl,Fetish,Facing,Dirty,FeetCum")

	Base.Save(id)
endFunction

function LeitoFeet3(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "Leito Footjob 3"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, addCum=Anal)
	Base.AddPositionStage(a1, "Leito_Feet3_A1_S1", 0)
	Base.AddPositionStage(a1, "Leito_Feet3_A1_S2", 0)
	Base.AddPositionStage(a1, "Leito_Feet3_A1_S3", 0)
	Base.AddPositionStage(a1, "Leito_Feet3_A1_S4", 0)
	Base.AddPositionStage(a1, "Leito_Feet3_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Leito_Feet3_A2_S1", 0, sos = 6)
	Base.AddPositionStage(a2, "Leito_Feet3_A2_S2", 0, sos = 6)
	Base.AddPositionStage(a2, "Leito_Feet3_A2_S3", 0, sos = 0)
	Base.AddPositionStage(a2, "Leito_Feet3_A2_S4", 0, sos = 3)
	Base.AddPositionStage(a2, "Leito_Feet3_A2_S5", 0, sos = 3)

	Base.SetTags("Leito,Sex,Straight,Penis,Hands,Feet,Handjob,Footjob,Fetish,Doggystyle,FeetCum,Dirty,AnalCum")

	Base.Save(id)
endFunction

function LeitoKissing(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "Leito Kissing"

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "Leito_Kissing_A1_S1", 0)
	Base.AddPositionStage(a1, "Leito_Kissing_A1_S2", 0)
	Base.AddPositionStage(a1, "Leito_Kissing_A1_S3", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Leito_Kissing_A2_S1", 0)
	Base.AddPositionStage(a2, "Leito_Kissing_A2_S2", 0)
	Base.AddPositionStage(a2, "Leito_Kissing_A2_S3", 0)

	Base.SetStageTimer(1, 1.8)
	Base.SetStageTimer(3, 0.7)

	Base.SetTags("Leito,Foreplay,LeadIn,Straight,Mouth,Kissing,Loving")

	Base.Save(id)
endFunction

function LeitoMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "Leito Missionary"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, addCum=Vaginal)
	Base.AddPositionStage(a1, "Leito_Missionary1_A1_S1", 0)
	Base.AddPositionStage(a1, "Leito_Missionary1_A1_S2", 0)
	Base.AddPositionStage(a1, "Leito_Missionary1_A1_S3", 0)
	Base.AddPositionStage(a1, "Leito_Missionary1_A1_S4", 0)
	Base.AddPositionStage(a1, "Leito_Missionary1_A1_S5", 0)
	
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Leito_Missionary1_A2_S1", 0)
	Base.AddPositionStage(a2, "Leito_Missionary1_A2_S2", 0)
	Base.AddPositionStage(a2, "Leito_Missionary1_A2_S3", 0)
	Base.AddPositionStage(a2, "Leito_Missionary1_A2_S4", 0)
	Base.AddPositionStage(a2, "Leito_Missionary1_A2_S5", 0)
	
	Base.SetTags("Leito,Sex,Penis,Vaginal,Missionary,Laying,Lying,OnBack,Facing,Beds,Creampie,Loving")

	Base.Save(id)
endFunction

function LeitoMissionaryVar(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "Leito Missionary 2"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, addCum=Vaginal)
	Base.AddPositionStage(a1, "Leito_Missionary2_A1_S1", 0)
	Base.AddPositionStage(a1, "Leito_Missionary2_A1_S2", 0)
	Base.AddPositionStage(a1, "Leito_Missionary2_A1_S3", 0)
	Base.AddPositionStage(a1, "Leito_Missionary2_A1_S4", 0)
	Base.AddPositionStage(a1, "Leito_Missionary2_A1_S5", 0)
	
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Leito_Missionary2_A2_S1", 0)
	Base.AddPositionStage(a2, "Leito_Missionary2_A2_S2", 0)
	Base.AddPositionStage(a2, "Leito_Missionary2_A2_S3", 0)
	Base.AddPositionStage(a2, "Leito_Missionary2_A2_S4", 0)
	Base.AddPositionStage(a2, "Leito_Missionary2_A2_S5", 0)
	
	Base.SetTags("Leito,Sex,Penis,Vaginal,Missionary,Laying,Lying,OnBack,Facing,Beds,Creampie,Loving")

	Base.Save(id)
endFunction

function LeitoRCowgirl(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "Leito Reverse Cowgirl"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, addCum=Vaginal)
	Base.AddPositionStage(a1, "Leito_ReverseCowgirl_A1_S1", 0)
	Base.AddPositionStage(a1, "Leito_ReverseCowgirl_A1_S2", 0)
	Base.AddPositionStage(a1, "Leito_ReverseCowgirl_A1_S3", 0)
	Base.AddPositionStage(a1, "Leito_ReverseCowgirl_A1_S4", 0)
	Base.AddPositionStage(a1, "Leito_ReverseCowgirl_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Leito_ReverseCowgirl_A2_S1", 0, sos = 3)
	Base.AddPositionStage(a2, "Leito_ReverseCowgirl_A2_S2", 0, sos = 8)
	Base.AddPositionStage(a2, "Leito_ReverseCowgirl_A2_S3", 0, sos = 8)
	Base.AddPositionStage(a2, "Leito_ReverseCowgirl_A2_S4", 0, sos = 8)
	Base.AddPositionStage(a2, "Leito_ReverseCowgirl_A2_S5", 0, sos = 8)

	Base.SetTags("Leito,Sex,Straight,Penis,Vaginal,Cowgirl,Laying,Reverse,ReverseCowgirl,Beds,Creampie,Dirty")

	Base.Save(id)
endFunction

function LeitoSpoon(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "Leito Spooning"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, addCum=Vaginal)
	Base.AddPositionStage(a1, "Leito_Spooning_A1_S1", 0)
	Base.AddPositionStage(a1, "Leito_Spooning_A1_S2", 0)
	Base.AddPositionStage(a1, "Leito_Spooning_A1_S3", 0)
	Base.AddPositionStage(a1, "Leito_Spooning_A1_S4", 0)
	Base.AddPositionStage(a1, "Leito_Spooning_A1_S5", 0)
	
	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Leito_Spooning_A2_S1", 0, sos = 8)
	Base.AddPositionStage(a2, "Leito_Spooning_A2_S2", 0, sos = 8)
	Base.AddPositionStage(a2, "Leito_Spooning_A2_S3", 0, sos = 8)
	Base.AddPositionStage(a2, "Leito_Spooning_A2_S4", 0, sos = 8)
	Base.AddPositionStage(a2, "Leito_Spooning_A2_S5", 0, sos = 8)
	
	Base.SetTags("Leito,Sex,Penis,Vaginal,Laying,Lying,OnBack,Spooning,Loving,Creampie")

	Base.Save(id)
endFunction

function LeitoStanding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "Leito Standing"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, addCum=Vaginal)
	Base.AddPositionStage(a1, "Leito_Standing_A1_S1", 0)
	Base.AddPositionStage(a1, "Leito_Standing_A1_S2", 0)
	Base.AddPositionStage(a1, "Leito_Standing_A1_S3", 0)
	Base.AddPositionStage(a1, "Leito_Standing_A1_S4", 0)
	Base.AddPositionStage(a1, "Leito_Standing_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Leito_Standing_A2_S1", 0, sos = -1)
	Base.AddPositionStage(a2, "Leito_Standing_A2_S2", 0, sos = -1)
	Base.AddPositionStage(a2, "Leito_Standing_A2_S3", 0, sos = 3)
	Base.AddPositionStage(a2, "Leito_Standing_A2_S4", 0, sos = 3)
	Base.AddPositionStage(a2, "Leito_Standing_A2_S5", 0, sos = 3)

	Base.SetStageSoundFX(1, none)
	Base.SetStageSoundFX(2, none)

	Base.SetTags("Leito,Sex,Straight,Penis,Hands,Vaginal,Handjob,Standing,Facing,Hugging,Creampie")

	Base.Save(id)
endFunction


function fdBedMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "4uDIK Missionary"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, addCum=Vaginal)
	Base.AddPositionStage(a1, "4D_BedMissionary_A1_S1", -60.0, silent=true, openMouth = true)
	Base.AddPositionStage(a1, "4D_BedMissionary_A1_S2", -60.0)
	Base.AddPositionStage(a1, "4D_BedMissionary_A1_S3", -60.0)
	Base.AddPositionStage(a1, "4D_BedMissionary_A1_S4", -60.0)
	Base.AddPositionStage(a1, "4D_BedMissionary_A1_S5", -60.0)
	Base.AddPositionStage(a1, "4D_BedMissionary_A1_S6", -60.0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "4D_BedMissionary_A2_S1", -60.0, rotate = 180, sos = 5)
	Base.AddPositionStage(a2, "4D_BedMissionary_A2_S2", -60.0, rotate = 180, sos = 3)
	Base.AddPositionStage(a2, "4D_BedMissionary_A2_S3", -60.0, rotate = 180, sos = 3)
	Base.AddPositionStage(a2, "4D_BedMissionary_A2_S4", -60.0, rotate = 180, sos = 3)
	Base.AddPositionStage(a2, "4D_BedMissionary_A2_S4", -60.0, rotate = 180, sos = 3)
	Base.AddPositionStage(a2, "4D_BedMissionary_A2_S4", -60.0, rotate = 180, sos = 3)

	Base.SetStageCumID(a1, 1, Oral)

	Base.SetTags("4D,4uDIK,Sex,Straight,Penis,Oral,Vaginal,Laying,Lying,OnBack,Beds,Missionary,Creampie")

	Base.Save(id)
endFunction

function fdCowgirl(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "4uDIK Cowgirl"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, addCum=Vaginal)
	Base.AddPositionStage(a1, "4D_Cowgirl_A1_S1", -180.0, silent=true, openMouth = true)
	Base.AddPositionStage(a1, "4D_Cowgirl_A1_S2", -180.0)
	Base.AddPositionStage(a1, "4D_Cowgirl_A1_S3", -180.0)
	Base.AddPositionStage(a1, "4D_Cowgirl_A1_S4", -180.0)
	Base.AddPositionStage(a1, "4D_Cowgirl_A1_S5", -180.0)
	Base.AddPositionStage(a1, "4D_Cowgirl_A1_S6", -180.0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "4D_Cowgirl_A2_S1", -180.0, rotate = 180, sos = 1)
	Base.AddPositionStage(a2, "4D_Cowgirl_A2_S2", -180.0, rotate = 180, sos = 1)
	Base.AddPositionStage(a2, "4D_Cowgirl_A2_S2", -180.0, rotate = 180, sos = 1)
	Base.AddPositionStage(a2, "4D_Cowgirl_A2_S3", -180.0, rotate = 180, sos = 1)
	Base.AddPositionStage(a2, "4D_Cowgirl_A2_S4", -180.0, rotate = 180, sos = 2)
	Base.AddPositionStage(a2, "4D_Cowgirl_A2_S4", -180.0, rotate = 180, sos = 2)

	Base.SetTags("4D,4uDIK,Sex,Straight,Penis,Oral,Vaginal,Laying,Beds,Cowgirl,Creampie")

	Base.Save(id)
endFunction

function fdDoggyStyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "4uDIK DoggyStyle"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, addCum=Anal)
	Base.AddPositionStage(a1, "4D_DoggyStyle_A1_S1", 0, silent=true, openMouth = true)
	Base.AddPositionStage(a1, "4D_DoggyStyle_A1_S2", 0)
	Base.AddPositionStage(a1, "4D_DoggyStyle_A1_S3", 0)
	Base.AddPositionStage(a1, "4D_DoggyStyle_A1_S4", 0)
	Base.AddPositionStage(a1, "4D_DoggyStyle_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "4D_DoggyStyle_A2_S1", 0, rotate = 180)
	Base.AddPositionStage(a2, "4D_DoggyStyle_A2_S2", 0, rotate = 180)
	Base.AddPositionStage(a2, "4D_DoggyStyle_A2_S3", 0, rotate = 180)
	Base.AddPositionStage(a2, "4D_DoggyStyle_A2_S4", 0, rotate = 180)
	Base.AddPositionStage(a2, "4D_DoggyStyle_A2_S5", 0, rotate = 180)

	Base.SetTags("4D,4uDIK,Sex,Straight,Penis,Hands,Oral,Anal,Doggystyle,Doggy,Knees,Standing,AnalCreampie")

	Base.Save(id)
endFunction

function fdFMasturbation(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "4uDIK Female Masturbation"

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "4D_FemaleSolo_A1_S1", -55.0)
	Base.AddPositionStage(a1, "4D_FemaleSolo_A1_S2", -55.0)
	Base.AddPositionStage(a1, "4D_FemaleSolo_A1_S3", -55.0)
	Base.AddPositionStage(a1, "4D_FemaleSolo_A1_S4", -55.0)

	Base.SetTags("4D,4uDIK,Sex,Solo,Hands,Pussy,Masturbation,Beds,Laying,Lying,OnBack,Dirty")

	Base.Save(id)
endFunction

function fdFisting(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "4uDIK Fisting"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, addCum=VaginalAnal)
	Base.AddPositionStage(a1, "4D_Fisting_A1_S1", 0)
	Base.AddPositionStage(a1, "4D_Fisting_A1_S2", 0)
	Base.AddPositionStage(a1, "4D_Fisting_A1_S3", 0)
	Base.AddPositionStage(a1, "4D_Fisting_A1_S4", 0)
	Base.AddPositionStage(a1, "4D_Fisting_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "4D_Fisting_A2_S1", 0, strapon = false, sos = 2, silent=true, openMouth = true)
	Base.AddPositionStage(a2, "4D_Fisting_A2_S2", 0, strapon = false, sos = 3)
	Base.AddPositionStage(a2, "4D_Fisting_A2_S3", 0, strapon = false, sos = 3)
	Base.AddPositionStage(a2, "4D_Fisting_A2_S4", 0, rotate = 180, strapon = true, sos = 3)
	Base.AddPositionStage(a2, "4D_Fisting_A2_S5", 0, rotate = 180, strapon = true, sos = 3)

	Base.SetTags("4D,4uDIK,Sex,Straight,Pussy,Mouth,Hands,Vaginal,Cunnilingus,Fisting,Laying,Doggystyle,Rough,Dirty,Creampie,Fetish")

	Base.Save(id)
endFunction

function fdMMasturbation(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "4uDIK Male Masturbation"

	int a1 = Base.AddPosition(Male, addCum=Vaginal)
	Base.AddPositionStage(a1, "4D_MaleSolo_A1_S1", -55.0, sos = 3)
	Base.AddPositionStage(a1, "4D_MaleSolo_A1_S2", -55.0, sos = 3)
	Base.AddPositionStage(a1, "4D_MaleSolo_A1_S3", -55.0, sos = 3)
	Base.AddPositionStage(a1, "4D_MaleSolo_A1_S4", -55.0, sos = 3)

	Base.SetTags("4D,4uDIK,Sex,Solo,Hands,Penis,Masturbation,Beds,Laying,Lying,OnBack,AirCum,Dirty")

	Base.Save(id)
endFunction


function fdLegUp(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "4uDIK Leg Up"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, addCum=VaginalAnal)
	Base.AddPositionStage(a1, "4D_LegUp_A1_S1", 0, silent=true, openMouth = true)
	Base.AddPositionStage(a1, "4D_LegUp_A1_S2", 0)
	Base.AddPositionStage(a1, "4D_LegUp_A1_S3", 0)
	Base.AddPositionStage(a1, "4D_LegUp_A1_S4", 0)
	Base.AddPositionStage(a1, "4D_LegUp_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "4D_LegUp_A2_S1", 0, sos = 2)
	Base.AddPositionStage(a2, "4D_LegUp_A2_S2", 0, sos = 3)
	Base.AddPositionStage(a2, "4D_LegUp_A2_S3", 0, sos = 3)
	Base.AddPositionStage(a2, "4D_LegUp_A2_S4", 0, sos = 3)
	Base.AddPositionStage(a2, "4D_LegUp_A2_S5", 0, sos = 3)

	Base.SetStageSoundFX(1, Sucking)

	Base.SetTags("4D,4uDIK,Vaginal,Oral,Penis,Kneeling,Spooning,Doggystyle,Laying,Lying,OnBack,Dirty,Creampie")

	Base.Save(id)
endFunction

function fdRCowgirl(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "4uDIK Reverse Cowgirl"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, addCum=VaginalAnal)
	Base.AddPositionStage(a1, "4D_ReverseCowgirl_A1_S1", 0, silent=true, openMouth = true)
	Base.AddPositionStage(a1, "4D_ReverseCowgirl_A1_S2", 0)
	Base.AddPositionStage(a1, "4D_ReverseCowgirl_A1_S3", 0)
	Base.AddPositionStage(a1, "4D_ReverseCowgirl_A1_S4", 0)
	Base.AddPositionStage(a1, "4D_ReverseCowgirl_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "4D_ReverseCowgirl_A2_S1", 0, sos = 2, silent=true, openMouth = true)
	Base.AddPositionStage(a2, "4D_ReverseCowgirl_A2_S2", 0, sos = 6)
	Base.AddPositionStage(a2, "4D_ReverseCowgirl_A2_S3", 0, sos = -1)
	Base.AddPositionStage(a2, "4D_ReverseCowgirl_A2_S4", 0, sos = -4)
	Base.AddPositionStage(a2, "4D_ReverseCowgirl_A2_S5", 0, sos = -4)

	Base.SetTags("4D,4uDIK,Sex,Straight,Mouth,Penis,Vaginal,Cowgirl,Reverse,ReverseCowgirl,Beds,Dirty,Creampie")

	Base.Save(id)
endFunction

function fdThreesome(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "4uDIK Threesome"
	Base.SoundFX = SexMix

	int a1 = Base.AddPosition(Female, addCum=OralAnal)
	Base.AddPositionStage(a1, "4D_Threesome_A1_S1", 0, silent=true, openMouth = true)
	Base.AddPositionStage(a1, "4D_Threesome_A1_S2", 0, silent=true, openMouth = true)
	Base.AddPositionStage(a1, "4D_Threesome_A1_S3", 0, silent=true, openMouth = true)
	Base.AddPositionStage(a1, "4D_Threesome_A1_S4", 0, silent=true, openMouth = true)
	Base.AddPositionStage(a1, "4D_Threesome_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "4D_Threesome_A2_S1", 0)
	Base.AddPositionStage(a2, "4D_Threesome_A2_S2", 0)
	Base.AddPositionStage(a2, "4D_Threesome_A2_S3", 0)
	Base.AddPositionStage(a2, "4D_Threesome_A2_S4", 0)
	Base.AddPositionStage(a2, "4D_Threesome_A2_S5", 0)

	int a3 = Base.AddPosition(Male)
	Base.AddPositionStage(a3, "4D_Threesome_A3_S1", 0)
	Base.AddPositionStage(a3, "4D_Threesome_A3_S2", 0)
	Base.AddPositionStage(a3, "4D_Threesome_A3_S3", 0)
	Base.AddPositionStage(a3, "4D_Threesome_A3_S4", 0)
	Base.AddPositionStage(a3, "4D_Threesome_A3_S5", 0)

	Base.SetStageCumID(a1, 5, VaginalAnal)

	Base.SetTags("Sex,4D,4uDIK,BBP,Penis,Oral,Anal,Vaginal,Doggystyle,Doggy,Blowjob,Orgy,Dirty,VaginalCum,AnalCum")

	Base.Save(id)
endFunction


function MitosFaceFemdom(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "Mitos Female Facedom"

	Base.SetContent(Foreplay)
	Base.SoundFX = Sucking

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "Mitos_Facefemdom_A1_S1", 0)
	Base.AddPositionStage(a1, "Mitos_Facefemdom_A1_S2", 0)
	Base.AddPositionStage(a1, "Mitos_Facefemdom_A1_S3", 0)
	Base.AddPositionStage(a1, "Mitos_Facefemdom_A1_S4", 0)


	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Mitos_Facefemdom_A2_S1", 0, silent = true, sos = 3)
	Base.AddPositionStage(a2, "Mitos_Facefemdom_A2_S2", 0, silent = true, sos = 3)
	Base.AddPositionStage(a2, "Mitos_Facefemdom_A2_S3", 0, silent = true, openMouth = true, sos = 3)
	Base.AddPositionStage(a2, "Mitos_Facefemdom_A2_S4", 0, silent = true, openMouth = true, sos = 3)

	Base.SetTags("Mitos,Sex,Straight,Pussy,Mouth,Oral,Standing,Cunnilingus,Foreplay,LeadIn,Dirty")

	Base.Save(id)
endFunction

function MitosFootjob(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "Mitos Footjob"

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "Mitos_Footjob_A1_S1", 0)
	Base.AddPositionStage(a1, "Mitos_Footjob_A1_S2", 0)
	Base.AddPositionStage(a1, "Mitos_Footjob_A1_S3", 0)
	Base.AddPositionStage(a1, "Mitos_Footjob_A1_S4", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Mitos_Footjob_A2_S1", 0, sos = 3)
	Base.AddPositionStage(a2, "Mitos_Footjob_A2_S2", 0, sos = 3)
	Base.AddPositionStage(a2, "Mitos_Footjob_A2_S3", 0, sos = 3)
	Base.AddPositionStage(a2, "Mitos_Footjob_A2_S4", 0, sos = 0)

	Base.SetTags("Mitos,Sex,Straight,Anus,Penis,Fetish,Feet,Footjob,Reverse,Standing,Masturbation,Dirty,FeetCum")

	Base.Save(id)
endFunction

function MitosHugBehind(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "Mitos Hugging Behind"

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "Mitos_Hugbehind_A1_S1", 0)
	Base.AddPositionStage(a1, "Mitos_Hugbehind_A1_S2", 0)
	Base.AddPositionStage(a1, "Mitos_Hugbehind_A1_S3", 0)
	Base.AddPositionStage(a1, "Mitos_Hugbehind_A1_S4", 0)
	Base.AddPositionStage(a1, "Mitos_Hugbehind_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Mitos_Hugbehind_A2_S1", 0, sos = 3)
	Base.AddPositionStage(a2, "Mitos_Hugbehind_A2_S2", 0, sos = 3)
	Base.AddPositionStage(a2, "Mitos_Hugbehind_A2_S3", 0, sos = 3)
	Base.AddPositionStage(a2, "Mitos_Hugbehind_A2_S4", 0, sos = 3)
	Base.AddPositionStage(a2, "Mitos_Hugbehind_A2_S5", 0, sos = 3)

	Base.SetStageTimer(5, 7.0)

	Base.SetTags("Mitos,Sex,Straight,Penis,Fetish,Feet,Footjob,Reverse,Laying,Dirty,FeetCum")

	Base.Save(id)
endFunction

function MitosLapLove(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "Mitos Lap"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, addCum=Vaginal)
	Base.AddPositionStage(a1, "Mitos_Laplove_A1_S1", 0)
	Base.AddPositionStage(a1, "Mitos_Laplove_A1_S2", 0)
	Base.AddPositionStage(a1, "Mitos_Laplove_A1_S3", 0)
	Base.AddPositionStage(a1, "Mitos_Laplove_A1_S4", 0)
	Base.AddPositionStage(a1, "Mitos_Laplove_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Mitos_Laplove_A2_S1", 0)
	Base.AddPositionStage(a2, "Mitos_Laplove_A2_S2", 0)
	Base.AddPositionStage(a2, "Mitos_Laplove_A2_S3", 0)
	Base.AddPositionStage(a2, "Mitos_Laplove_A2_S4", 0)
	Base.AddPositionStage(a2, "Mitos_Laplove_A2_S5", 0)

	Base.SetTags("Mitos,Sex,Straight,Penis,Vaginal,Feet,Cowgirl,Laying,Lying,OnBack,Facing,Loving,Creampie")

	Base.Save(id)
endFunction

function MitosReachAround(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "Mitos Reach Around"

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "Mitos_Reacharound_A1_S1", 0)
	Base.AddPositionStage(a1, "Mitos_Reacharound_A1_S2", 0)
	Base.AddPositionStage(a1, "Mitos_Reacharound_A1_S3", 0)
	Base.AddPositionStage(a1, "Mitos_Reacharound_A1_S4", 0)
	Base.AddPositionStage(a1, "Mitos_Reacharound_A1_S5", 0)

	int a2 = Base.AddPosition(Male, addCum=Vaginal)
	Base.AddPositionStage(a2, "Mitos_Reacharound_A2_S1", 0)
	Base.AddPositionStage(a2, "Mitos_Reacharound_A2_S2", 0)
	Base.AddPositionStage(a2, "Mitos_Reacharound_A2_S3", 0)
	Base.AddPositionStage(a2, "Mitos_Reacharound_A2_S4", 0)
	Base.AddPositionStage(a2, "Mitos_Reacharound_A2_S5", 0)

	Base.SetTags("Mitos,Sex,Straight,Penis,Hands,Kissing,Handjob,Masturbation,Behind,Reverse,Standing,Kneeling,LeadIn,Foreplay,Loving,HandsCum,AirCum")

	Base.Save(id)
endFunction

function MitosReverseCowgirl(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "Mitos Reverse Cowgirl"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, addCum=Vaginal)
	Base.AddPositionStage(a1, "Mitos_ReverseCowgirl_A1_S1", 0)
	Base.AddPositionStage(a1, "Mitos_ReverseCowgirl_A1_S2", 0)
	Base.AddPositionStage(a1, "Mitos_ReverseCowgirl_A1_S3", 0)
	Base.AddPositionStage(a1, "Mitos_ReverseCowgirl_A1_S4", 0)
	Base.AddPositionStage(a1, "Mitos_ReverseCowgirl_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Mitos_ReverseCowgirl_A2_S1", 0)
	Base.AddPositionStage(a2, "Mitos_ReverseCowgirl_A2_S2", 0)
	Base.AddPositionStage(a2, "Mitos_ReverseCowgirl_A2_S3", 0)
	Base.AddPositionStage(a2, "Mitos_ReverseCowgirl_A2_S4", 0)
	Base.AddPositionStage(a2, "Mitos_ReverseCowgirl_A2_S5", 0)

	Base.SetTags("Mitos,Sex,Straight,Penis,Vaginal,Cowgirl,Reverse,ReverseCowgirl,Laying,Lying,OnBack,Dirty,Creampie")

	Base.Save(id)
endFunction

function MitosStanding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "Mitos Standing"
	Base.SoundFX = Squishing

	int a1 = Base.AddPosition(Female, addCum=Anal)
	Base.AddPositionStage(a1, "Mitos_Standing_A1_S1", 0)
	Base.AddPositionStage(a1, "Mitos_Standing_A1_S2", 0)
	Base.AddPositionStage(a1, "Mitos_Standing_A1_S3", 0)
	Base.AddPositionStage(a1, "Mitos_Standing_A1_S4", 0)
	Base.AddPositionStage(a1, "Mitos_Standing_A1_S5", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Mitos_Standing_A2_S1", 0)
	Base.AddPositionStage(a2, "Mitos_Standing_A2_S2", 0)
	Base.AddPositionStage(a2, "Mitos_Standing_A2_S3", 0)
	Base.AddPositionStage(a2, "Mitos_Standing_A2_S4", 0)
	Base.AddPositionStage(a2, "Mitos_Standing_A2_S5", 0)

	Base.SetTags("Mitos,Sex,Straight,Penis,Anal,Standing,Reverse,Behind,AnalCreampie,Dirty")

	Base.Save(id)
endFunction

function MitosTease(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "Mitos Teasing"

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "Mitos_Teasing_A1_S1", 0)
	Base.AddPositionStage(a1, "Mitos_Teasing_A1_S2", 0)
	Base.AddPositionStage(a1, "Mitos_Teasing_A1_S3", 0)
	Base.AddPositionStage(a1, "Mitos_Teasing_A1_S4", 0)

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "Mitos_Teasing_A2_S1", 0, sos = -1)
	Base.AddPositionStage(a2, "Mitos_Teasing_A2_S2", 0, sos = 1)
	Base.AddPositionStage(a2, "Mitos_Teasing_A2_S3", 0, silent = true, sos = 1)
	Base.AddPositionStage(a2, "Mitos_Teasing_A2_S4", 0, sos = -1)

	Base.SetTags("Mitos,Sex,Straight,Penis,Hands,Fetish,Feet,Laying,Kneeling,Masturbation,Footjob,Dirty,VaginalCum")

	Base.Save(id)
endFunction

function FBFMasturbation(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "FB2 Female Masturbation"

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "FB_FemaleSolo_A1_S1", -55.0)
	Base.AddPositionStage(a1, "FB_FemaleSolo_A1_S2", -55.0)
	Base.AddPositionStage(a1, "FB_FemaleSolo_A1_S3", -55.0)
	Base.AddPositionStage(a1, "FB_FemaleSolo_A1_S4", -55.0)
	Base.AddPositionStage(a1, "FB_FemaleSolo_A1_S5", -55.0)

	Base.SetStageTimer(5, 7.0)

	Base.SetTags("FB2,FalloutBoy2,Sex,Solo,Hands,Pussy,Boobs,Masturbation,Laying,Lying,OnBack,Dirty")

	Base.Save(id)
endFunction
