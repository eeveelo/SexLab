scriptname sslAnimationDefaults extends sslAnimationFactory

function LoadAnimations()
	; Missionary
	RegisterAnimation("SexLabMissonary")
	RegisterAnimation("SexLabAggrMissonary")
	RegisterAnimation("ArrokMissionary")
	RegisterAnimation("ArrokLegUp")
	RegisterAnimation("APBedMissionary")
	RegisterAnimation("APHoldLegUp")
	RegisterAnimation("APLegUp")
	; Doggystyle
	RegisterAnimation("SexLabDoggyStyle")
	RegisterAnimation("SexLabAggrBehind")
	RegisterAnimation("SexLabAggrDoggyStyle")
	RegisterAnimation("ArrokDoggyStyle")
	RegisterAnimation("ArrokRape")
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
	; Solo
	RegisterAnimation("BleaghFemaleSolo")
	RegisterAnimation("APFemaleSolo")
	RegisterAnimation("ArrokMaleMasturbation")
	; Gay/Lesbian
	RegisterAnimation("SexLabTribadism")
	RegisterAnimation("ArrokLesbian")
	RegisterAnimation("ZynLesbian")
	; Misc
	RegisterAnimation("APFisting")
	; 3P+
	RegisterAnimation("ArrokDevilsThreeway")
	RegisterAnimation("ArrokTricycle")
endFunction

function ArrokBlowjob(string eventName, string id, float argNum, form sender)
	Name = "Arrok Blowjob"

	SetContent(Sexual)
	SetSFX(Sucking)

	int a1 = AddPosition(Female, addCum=Oral)
	AddPositionStage(a1, "Arrok_Blowjob_A1_S1", 0, silent = true, openMouth = true)
	AddPositionStage(a1, "Arrok_Blowjob_A1_S2", 0, silent = true, openMouth = true)
	AddPositionStage(a1, "Arrok_Blowjob_A1_S2", 0, silent = true, openMouth = true)
	AddPositionStage(a1, "Arrok_Blowjob_A1_S3", 0, silent = true, openMouth = true)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "Arrok_Blowjob_A2_S1", -120, side = -3.5, sos = -1)
	AddPositionStage(a2, "Arrok_Blowjob_A2_S2", -120, side = -3.5, sos = -1)
	AddPositionStage(a2, "Arrok_Blowjob_A2_S2", -120, side = -3.5, sos = 1)
	AddPositionStage(a2, "Arrok_Blowjob_A2_S3", -120, side = -3.5, sos = 2)

	AddTag("Arrok")
	AddTag("BBP")
	AddTag("Sex")
	AddTag("Oral")
	AddTag("Dirty")
	AddTag("Blowjob")
	AddTag("LeadIn")

	Save()
endFunction

function ArrokBoobjob(string eventName, string id, float argNum, form sender)
	Name = "Arrok Boobjob"

	SetContent(Sexual)

	int a1 = AddPosition(Female, addCum=Oral)
	AddPositionStage(a1, "Arrok_Boobjob_A1_S1", 0)
	AddPositionStage(a1, "Arrok_Boobjob_A1_S2", 0)
	AddPositionStage(a1, "Arrok_Boobjob_A1_S3", 0)
	AddPositionStage(a1, "Arrok_Boobjob_A1_S4", 0, silent = true, openMouth = true)

	int a2 = AddPosition(Male) ; 102
	AddPositionStage(a2, "Arrok_Boobjob_A2_S1", -119, sos = 2)
	AddPositionStage(a2, "Arrok_Boobjob_A2_S2", -119, sos = 3)
	AddPositionStage(a2, "Arrok_Boobjob_A2_S3", -119, sos = -2)
	AddPositionStage(a2, "Arrok_Boobjob_A2_S4", -119, sos = -2)

	AddTag("Arrok")
	AddTag("BBP")
	AddTag("Sex")
	AddTag("Dirty")
	AddTag("Boobjob")
	AddTag("Breast")
	AddTag("LeadIn")

	Save()
endFunction

function ArrokCowgirl(string eventName, string id, float argNum, form sender)
	Name = "Arrok Cowgirl"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "Arrok_Cowgirl_A1_S1", 0)
	AddPositionStage(a1, "Arrok_Cowgirl_A1_S2", 0)
	AddPositionStage(a1, "Arrok_Cowgirl_A1_S3", 0)
	AddPositionStage(a1, "Arrok_Cowgirl_A1_S4", 0)
	AddPositionStage(a1, "Arrok_Cowgirl_A1_S5", 0)
	AddPositionStage(a1, "Arrok_Cowgirl_A1_S6", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "Arrok_Cowgirl_A2_S1", -102)
	AddPositionStage(a2, "Arrok_Cowgirl_A2_S2", -102)
	AddPositionStage(a2, "Arrok_Cowgirl_A2_S2", -102)
	AddPositionStage(a2, "Arrok_Cowgirl_A2_S3", -102)
	AddPositionStage(a2, "Arrok_Cowgirl_A2_S4", -102)
	AddPositionStage(a2, "Arrok_Cowgirl_A2_S4", -102)

	AddTag("Arrok")
	AddTag("BBP")
	AddTag("Sex")
	AddTag("Dirty")
	AddTag("Cowgirl")
	AddTag("Vaginal")

	Save()
endFunction

function ArrokDevilsThreeway(string eventName, string id, float argNum, form sender)
	Name = "Arrok Devils Threeway"

	SetContent(Sexual)
	SetSFX(SexMix)

	int a1 = AddPosition(Female, addCum=VaginalOralAnal)
	AddPositionStage(a1, "Arrok_DevilsThreeway_A1_S1", 0, silent = true, openMouth = true)
	AddPositionStage(a1, "Arrok_DevilsThreeway_A1_S2", 0, silent = true, openMouth = true)
	AddPositionStage(a1, "Arrok_DevilsThreeway_A1_S3", 0, silent = true, openMouth = true)
	AddPositionStage(a1, "Arrok_DevilsThreeway_A1_S4", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "Arrok_DevilsThreeway_A2_S1", -105, side = -2, sos = -1)
	AddPositionStage(a2, "Arrok_DevilsThreeway_A2_S2", -98, sos = 5)
	AddPositionStage(a2, "Arrok_DevilsThreeway_A2_S3", -114, sos = 7)
	AddPositionStage(a2, "Arrok_DevilsThreeway_A2_S4", -100, sos = 3)

	int a3 = AddPosition(Male)
	AddPositionStage(a3, "Arrok_DevilsThreeway_A3_S1", 105, sos = -3)
	AddPositionStage(a3, "Arrok_DevilsThreeway_A3_S2", 100, sos = 9)
	AddPositionStage(a3, "Arrok_DevilsThreeway_A3_S3", 120, sos = -3)
	AddPositionStage(a3, "Arrok_DevilsThreeway_A3_S4", 100, sos = -3)

	AddTag("Sex")
	AddTag("Arrok")
	AddTag("BBP")
	AddTag("MMF")
	AddTag("Doggy")
	AddTag("Blowjob")
	AddTag("Oral")
	AddTag("Orgy")
	AddTag("Vaginal")
	AddTag("Dirty")

	Save()
endFunction

function ArrokDoggyStyle(string eventName, string id, float argNum, form sender)
	Name = "Arrok DoggyStyle"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Arrok_DoggyStyle_A1_S1", 0)
	AddPositionStage(a1, "Arrok_DoggyStyle_A1_S2", 0)
	AddPositionStage(a1, "Arrok_DoggyStyle_A1_S3", 0)
	AddPositionStage(a1, "Arrok_DoggyStyle_A1_S4", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "Arrok_DoggyStyle_A2_S1", -100, sos = -2)
	AddPositionStage(a2, "Arrok_DoggyStyle_A2_S2", -100, sos = -2)
	AddPositionStage(a2, "Arrok_DoggyStyle_A2_S3", -100, sos = -2)
	AddPositionStage(a2, "Arrok_DoggyStyle_A2_S4", -100, sos = -2)

	AddTag("Arrok")
	AddTag("BBP")
	AddTag("Sex")
	AddTag("Doggy Style")
	AddTag("Anal")

	Save()
endFunction

function ArrokForeplay(string eventName, string id, float argNum, form sender)
	Name = "Arrok Foreplay"

	SetContent(Foreplay)

	int a1 = AddPosition(Female)
	AddPositionStage(a1, "Arrok_Foreplay_A1_S1", 0)
	AddPositionStage(a1, "Arrok_Foreplay_A1_S2", 0)
	AddPositionStage(a1, "Arrok_Foreplay_A1_S3", 0)
	AddPositionStage(a1, "Arrok_Foreplay_A1_S4", 0)

	int a2 = AddPosition(Male) ; -104
	AddPositionStage(a2, "Arrok_Foreplay_A2_S1", -106, strapon = false, sos = 0)
	AddPositionStage(a2, "Arrok_Foreplay_A2_S2", -106, strapon = false, sos = 0)
	AddPositionStage(a2, "Arrok_Foreplay_A2_S3", -106, strapon = false, sos = 5)
	AddPositionStage(a2, "Arrok_Foreplay_A2_S4", -106, strapon = false, sos = 5)

	AddTag("Arrok")
	AddTag("BBP")
	AddTag("Foreplay")
	AddTag("Laying")
	AddTag("Loving")
	AddTag("Cuddling")
	AddTag("LeadIn")

	Save()
endFunction

function ArrokLegUp(string eventName, string id, float argNum, form sender)
	Name = "Arrok Leg Up Fuck"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "Arrok_LegUp_A1_S1", 0)
	AddPositionStage(a1, "Arrok_LegUp_A1_S2", 0)
	AddPositionStage(a1, "Arrok_LegUp_A1_S3", 0)
	AddPositionStage(a1, "Arrok_LegUp_A1_S4", 0)
	AddPositionStage(a1, "Arrok_LegUp_A1_S5", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "Arrok_LegUp_A2_S1", 44, rotate = 180, sos = 2)
	AddPositionStage(a2, "Arrok_LegUp_A2_S2", 44, rotate = 180, sos = 2)
	AddPositionStage(a2, "Arrok_LegUp_A2_S3", 44, rotate = 180, sos = 2)
	AddPositionStage(a2, "Arrok_LegUp_A2_S4", 44, rotate = 180, sos = 4)
	AddPositionStage(a2, "Arrok_LegUp_A2_S5", 44, rotate = 180, sos = 3)

	AddTag("Arrok")
	AddTag("BBP")
	AddTag("Dirty")
	AddTag("Laying")
	AddTag("Aggressive")
	AddTag("Vaginal")

	Save()
endFunction

function ArrokMaleMasturbation(string eventName, string id, float argNum, form sender)
	Name = "Arrok Male Masturbation"

	SetContent(Sexual)

	int a1 = AddPosition(Male)
	AddPositionStage(a1, "Arrok_MaleMasturbation_A1_S1", 0, sos = 3)
	AddPositionStage(a1, "Arrok_MaleMasturbation_A1_S2", 0, sos = 3)
	AddPositionStage(a1, "Arrok_MaleMasturbation_A1_S3", 0, sos = 3)
	AddPositionStage(a1, "Arrok_MaleMasturbation_A1_S4", 0, sos = 3)

	AddTag("Sex")
	AddTag("Solo")
	AddTag("M")
	AddTag("Masturbation")
	AddTag("Standing")
	AddTag("Dirty")

	Save()
endFunction

function ArrokMissionary(string eventName, string id, float argNum, form sender)
	Name = "Arrok Missionary"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "Arrok_Missionary_A1_S1", 0)
	AddPositionStage(a1, "Arrok_Missionary_A1_S2", 0)
	AddPositionStage(a1, "Arrok_Missionary_A1_S3", 0)
	AddPositionStage(a1, "Arrok_Missionary_A1_S4", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "Arrok_Missionary_A2_S1", -105)
	AddPositionStage(a2, "Arrok_Missionary_A2_S2", -105)
	AddPositionStage(a2, "Arrok_Missionary_A2_S3", -105, sos = 3)
	AddPositionStage(a2, "Arrok_Missionary_A2_S4", -107, sos = 7)

	AddTag("Arrok")
	AddTag("BBP")
	AddTag("Sex")
	AddTag("Missionary")
	AddTag("Laying")
	AddTag("Vaginal")

	Save()
endFunction

function ArrokOral(string eventName, string id, float argNum, form sender)
	Name = "Arrok 69"

	SetContent(Sexual)
	SetSFX(Sucking)

	int a1 = AddPosition(Female, addCum=Oral)
	AddPositionStage(a1, "Arrok_Oral_A1_S1", 0)
	AddPositionStage(a1, "Arrok_Oral_A1_S2", 0)
	AddPositionStage(a1, "Arrok_Oral_A1_S3", 0, silent = true, openMouth = true)
	AddPositionStage(a1, "Arrok_Oral_A1_S3", 0, silent = true, openMouth = true)
	AddPositionStage(a1, "Arrok_Oral_A1_S4", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "Arrok_Oral_A2_S1", 46, rotate = 180, silent = true, openMouth = true)
	AddPositionStage(a2, "Arrok_Oral_A2_S1", 46, rotate = 180, silent = true, openMouth = true)
	AddPositionStage(a2, "Arrok_Oral_A2_S2", 46, rotate = 180, silent = true, openMouth = true)
	AddPositionStage(a2, "Arrok_Oral_A2_S3", 46, rotate = 180, silent = true, openMouth = true)
	AddPositionStage(a2, "Arrok_Oral_A2_S3", 46, rotate = 180, silent = true, openMouth = true)

	AddTag("Arrok")
	AddTag("BBP")
	AddTag("Sex")
	AddTag("Oral")
	AddTag("Cunnilingus")
	AddTag("Blowjob")
	AddTag("69")

	Save()
endFunction



function ArrokReverseCowgirl(string eventName, string id, float argNum, form sender)
	Name = "Arrok Reverse Cowgirl"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "Arrok_ReverseCowgirl_A1_S1", 0)
	AddPositionStage(a1, "Arrok_ReverseCowgirl_A1_S2", 0)
	AddPositionStage(a1, "Arrok_ReverseCowgirl_A1_S3", 0)
	AddPositionStage(a1, "Arrok_ReverseCowgirl_A1_S4", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "Arrok_ReverseCowgirl_A2_S1", -105, sos = 5)
	AddPositionStage(a2, "Arrok_ReverseCowgirl_A2_S2", -105, sos = 5)
	AddPositionStage(a2, "Arrok_ReverseCowgirl_A2_S3", -105, sos = 8)
	AddPositionStage(a2, "Arrok_ReverseCowgirl_A2_S4", -105, sos = 8)

	AddTag("Arrok")
	AddTag("BBP")
	AddTag("Sex")
	AddTag("Dirty")
	AddTag("Cowgirl")
	AddTag("Anal")

	Save()
endFunction

function ArrokSideways(string eventName, string id, float argNum, form sender)
	Name = "Arrok Sideways Fuck"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "Arrok_Sideways_A1_S1", 0)
	AddPositionStage(a1, "Arrok_Sideways_A1_S2", 0)
	AddPositionStage(a1, "Arrok_Sideways_A1_S3", 0)
	AddPositionStage(a1, "Arrok_Sideways_A1_S4", 0)

	int a2 = AddPosition(Male) ; -100
	AddPositionStage(a2, "Arrok_Sideways_A2_S1", -118.5, sos = 8)
	AddPositionStage(a2, "Arrok_Sideways_A2_S2", -118.5, sos = 8)
	AddPositionStage(a2, "Arrok_Sideways_A2_S3", -118.5, sos = 6)
	AddPositionStage(a2, "Arrok_Sideways_A2_S4", -118.5, sos = 5)

	AddTag("Arrok")
	AddTag("BBP")
	AddTag("Sex")
	AddTag("Standing")
	AddTag("Sideways")
	AddTag("Dirty")
	AddTag("Vaginal")

	Save()
endFunction

function ArrokStanding(string eventName, string id, float argNum, form sender)
	Name = "Arrok Standing Fuck"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "Arrok_Standing_A1_S1", 0)
	AddPositionStage(a1, "Arrok_Standing_A1_S2", 0)
	AddPositionStage(a1, "Arrok_Standing_A1_S3", 0)
	AddPositionStage(a1, "Arrok_Standing_A1_S4", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "Arrok_Standing_A2_S1", -104, sos = 9)
	AddPositionStage(a2, "Arrok_Standing_A2_S2", -104, sos = 6)
	AddPositionStage(a2, "Arrok_Standing_A2_S3", -104, sos = -7)
	AddPositionStage(a2, "Arrok_Standing_A2_S4", -104, sos = 7)

	AddTag("Arrok")
	AddTag("BBP")
	AddTag("Sex")
	AddTag("Standing")
	AddTag("Dirty")
	AddTag("Vaginal")

	Save()
endFunction

function ArrokStandingForeplay(string eventName, string id, float argNum, form sender)
	Name = "Arrok Standing Foreplay"

	SetContent(Foreplay)

	int a1 = AddPosition(Female)
	AddPositionStage(a1, "Arrok_StandingForeplay_A1_S1", 0)
	AddPositionStage(a1, "Arrok_StandingForeplay_A1_S2", 0)
	AddPositionStage(a1, "Arrok_StandingForeplay_A1_S3", 0)
	AddPositionStage(a1, "Arrok_StandingForeplay_A1_S4", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "Arrok_StandingForeplay_A2_S1", -101, strapon = false, sos = -1)
	AddPositionStage(a2, "Arrok_StandingForeplay_A2_S2", -101, strapon = false, sos = -1)
	AddPositionStage(a2, "Arrok_StandingForeplay_A2_S3", -101, silent = true, strapon = false, sos = 5)
	AddPositionStage(a2, "Arrok_StandingForeplay_A2_S4", -101, silent = true, strapon = false, sos = 5)

	AddTag("Arrok")
	AddTag("BBP")
	AddTag("Foreplay")
	AddTag("Standing")
	AddTag("Loving")
	AddTag("Kissing")
	AddTag("LeadIn")

	Save()
endFunction

function ArrokTricycle(string eventName, string id, float argNum, form sender)
	Name = "Arrok Tricycle"

	SetContent(Sexual)
	SetSFX(SexMix)

	int a1 = AddPosition(Female, addCum=Oral)
	AddPositionStage(a1, "Arrok_Tricycle_A1_S1", -1, up = 2, silent = true, openMouth = true)
	AddPositionStage(a1, "Arrok_Tricycle_A1_S2", 0)
	AddPositionStage(a1, "Arrok_Tricycle_A1_S3", 0)
	AddPositionStage(a1, "Arrok_Tricycle_A1_S4", 1, side = 2.5, up = 3, silent = true, openMouth = true)

	int a2 = AddPosition(Female, addCum=Oral)
	AddPositionStage(a2, "Arrok_Tricycle_A2_S1", -100)
	AddPositionStage(a2, "Arrok_Tricycle_A2_S2", -100)
	AddPositionStage(a2, "Arrok_Tricycle_A2_S3", -100.5, silent = true, openMouth = true)
	AddPositionStage(a2, "Arrok_Tricycle_A2_S4", -100, side = -1, up = 2, silent = true, openMouth = true)

	int a3 = AddPosition(Male)
	AddPositionStage(a3, "Arrok_Tricycle_A3_S1", 108, sos = -2)
	AddPositionStage(a3, "Arrok_Tricycle_A3_S2", 108, silent = true, openMouth = true, sos = 5)
	AddPositionStage(a3, "Arrok_Tricycle_A3_S3", 108, sos = -1)
	AddPositionStage(a3, "Arrok_Tricycle_A3_S4", 108, sos = -3)

	AddTag("Sex")
	AddTag("Arrok")
	AddTag("BBP")
	AddTag("Tricycle")
	AddTag("Threeway")
	AddTag("Blowjob")
	AddTag("Oral")
	AddTag("Cunnilingus")
	AddTag("Orgy")
	AddTag("Vaginal")
	AddTag("Dirty")

	Save()
endFunction

function ArrokHugFuck(string eventName, string id, float argNum, form sender)
	Name = "Arrok HugFuck"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "Arrok_Hugfuck_A1_S1", 0)
	AddPositionStage(a1, "Arrok_Hugfuck_A1_S2", 0)
	AddPositionStage(a1, "Arrok_Hugfuck_A1_S3", 0)
	AddPositionStage(a1, "Arrok_Hugfuck_A1_S4", 0)

	int a2 = AddPosition(Male) ; -99
	AddPositionStage(a2, "Arrok_Hugfuck_A2_S1", -103.5, sos = 9)
	AddPositionStage(a2, "Arrok_Hugfuck_A2_S2", -103.5, sos = 9)
	AddPositionStage(a2, "Arrok_Hugfuck_A2_S3", -103.5, sos = 9)
	AddPositionStage(a2, "Arrok_Hugfuck_A2_S4", -103.5, sos = 9)

	AddTag("Arrok")
	AddTag("BBP")
	AddTag("Sex")
	AddTag("Hugging")
	AddTag("Loving")
	AddTag("Vaginal")

	Save()
endFunction

function ArrokLesbian(string eventName, string id, float argNum, form sender)
	Name = "Arrok Lesbian"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female)
	AddPositionStage(a1, "Arrok_Lesbian_A1_S1", 0)
	AddPositionStage(a1, "Arrok_Lesbian_A1_S2", 0)
	AddPositionStage(a1, "Arrok_Lesbian_A1_S3", 0)
	AddPositionStage(a1, "Arrok_Lesbian_A1_S4", 0)

	int a2 = AddPosition(Female)
	AddPositionStage(a2, "Arrok_Lesbian_A2_S1", -100)
	AddPositionStage(a2, "Arrok_Lesbian_A2_S2", -100)
	AddPositionStage(a2, "Arrok_Lesbian_A2_S3", -100)
	AddPositionStage(a2, "Arrok_Lesbian_A2_S4", -100)

	AddTag("Arrok")
	AddTag("BBP")
	AddTag("Sex")
	AddTag("FF")
	AddTag("Lesbian")
	AddTag("Oral")
	AddTag("Vaginal")

	Save()
endFunction

function ArrokSittingForeplay(string eventName, string id, float argNum, form sender)
	Name = "Arrok Sitting Foreplay"

	SetContent(Foreplay)

	int a1 = AddPosition(Female)
	AddPositionStage(a1, "Arrok_SittingForeplay_A1_S1", 0)
	AddPositionStage(a1, "Arrok_SittingForeplay_A1_S2", 0)
	AddPositionStage(a1, "Arrok_SittingForeplay_A1_S3", 0)
	AddPositionStage(a1, "Arrok_SittingForeplay_A1_S4", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "Arrok_SittingForeplay_A2_S1", -100, strapon = false)
	AddPositionStage(a2, "Arrok_SittingForeplay_A2_S2", -100, strapon = false)
	AddPositionStage(a2, "Arrok_SittingForeplay_A2_S3", -100, strapon = false)
	AddPositionStage(a2, "Arrok_SittingForeplay_A2_S4", -100, strapon = false)

	AddTag("Arrok")
	AddTag("BBP")
	AddTag("Kissing")
	AddTag("Cuddling")
	AddTag("Loving")
	AddTag("Foreplay")
	AddTag("LeadIn")

	Save()
endFunction

function ArrokAnal(string eventName, string id, float argNum, form sender)
	Name = "Arrok Anal"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Arrok_Anal_A1_S1", 0)
	AddPositionStage(a1, "Arrok_Anal_A1_S2", 0)
	AddPositionStage(a1, "Arrok_Anal_A1_S3", 0)
	AddPositionStage(a1, "Arrok_Anal_A1_S4", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "Arrok_Anal_A2_S1", -117, silent = true, openMouth = true)
	AddPositionStage(a2, "Arrok_Anal_A2_S2", -103.5, sos = 3)
	AddPositionStage(a2, "Arrok_Anal_A2_S3", -121.5, sos = 4)
	AddPositionStage(a2, "Arrok_Anal_A2_S4", -123.5, sos = 3)

	AddTag("Arrok")
	AddTag("TBBP")
	AddTag("Anal")
	AddTag("Sex")
	AddTag("Dirty")

	Save()
endFunction

function ArrokRape(string eventName, string id, float argNum, form sender)
	Name = "Arrok Rape"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=Oral)
	AddPositionStage(a1, "Arrok_Rape_A1_S1", 0)
	AddPositionStage(a1, "Arrok_Rape_A1_S2", 0)
	AddPositionStage(a1, "Arrok_Rape_A1_S3", 0)
	AddPositionStage(a1, "Arrok_Rape_A1_S4", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "Arrok_Rape_A2_S1", -125)
	AddPositionStage(a2, "Arrok_Rape_A2_S2", -125)
	AddPositionStage(a2, "Arrok_Rape_A2_S3", -125, sos = 4)
	AddPositionStage(a2, "Arrok_Rape_A2_S4", -125, up = 4)

	AddTag("Arrok")
	AddTag("TBBP")
	AddTag("Anal")
	AddTag("Sex")
	AddTag("Aggressive")
	AddTag("Dirty")
	AddTag("Behind")

	Save()
endFunction

function SexLabAggrBehind(string eventName, string id, float argNum, form sender)
	Name = "Rough Behind"

	SetContent(Sexual)
	SetSFX(Squishing)


	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "AggrBehind_A1_S1", 0)
	AddPositionStage(a1, "AggrBehind_A1_S2", 0)
	AddPositionStage(a1, "AggrBehind_A1_S3", 0)
	AddPositionStage(a1, "AggrBehind_A1_S4", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "AggrBehind_A2_S1", -12)
	AddPositionStage(a2, "AggrBehind_A2_S2", -12)
	AddPositionStage(a2, "AggrBehind_A2_S3", -12)
	AddPositionStage(a2, "AggrBehind_A2_S4", -12)

	AddTag("Default")
	AddTag("Sex")
	AddTag("Behind")
	AddTag("Anal")
	AddTag("Aggressive")

	Save()
endFunction

function SexLabAggrDoggyStyle(string eventName, string id, float argNum, form sender)
	Name = "Rough Doggy Style"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "AggrDoggyStyle_A1_S1", 0)
	AddPositionStage(a1, "AggrDoggyStyle_A1_S2", 0)
	AddPositionStage(a1, "AggrDoggyStyle_A1_S3", 0)
	AddPositionStage(a1, "AggrDoggyStyle_A1_S4", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "AggrDoggyStyle_A2_S1", -100, sos = 5)
	AddPositionStage(a2, "AggrDoggyStyle_A2_S2", -100, sos = 5)
	AddPositionStage(a2, "AggrDoggyStyle_A2_S3", -100, sos = 7)
	AddPositionStage(a2, "AggrDoggyStyle_A2_S4", -100, sos = 5)

	AddTag("Default")
	AddTag("Sex")
	AddTag("Doggystyle")
	AddTag("Behind")
	AddTag("Anal")
	AddTag("Aggressive")

	Save()
endFunction

function SexLabAggrMissonary(string eventName, string id, float argNum, form sender)
	Name = "Rough Missionary"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "AggrMissionary_A1_S1", 0)
	AddPositionStage(a1, "AggrMissionary_A1_S2", 0)
	AddPositionStage(a1, "AggrMissionary_A1_S3", 0)
	AddPositionStage(a1, "AggrMissionary_A1_S4", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "AggrMissionary_A2_S1", -86, sos = 4)
	AddPositionStage(a2, "AggrMissionary_A2_S2", -86, sos = 4)
	AddPositionStage(a2, "AggrMissionary_A2_S3", -86, sos = 3)
	AddPositionStage(a2, "AggrMissionary_A2_S4", -86, sos = 3)

	AddTag("Default")
	AddTag("Sex")
	AddTag("Missionary")
	AddTag("Laying")
	AddTag("Vaginal")
	AddTag("Aggressive")

	Save()
endFunction

function SexLabBoobjob(string eventName, string id, float argNum, form sender)
	Name = "Boobjob"

	SetContent(Sexual)

	int a1 = AddPosition(Female, addCum=Oral)
	AddPositionStage(a1, "Boobjob_A1_S1", 0)
	AddPositionStage(a1, "Boobjob_A1_S2", 0)
	AddPositionStage(a1, "Boobjob_A1_S3", 0)
	AddPositionStage(a1, "Boobjob_A1_S4", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "Boobjob_A2_S1", -102)
	AddPositionStage(a2, "Boobjob_A2_S2", -102)
	AddPositionStage(a2, "Boobjob_A2_S3", -102)
	AddPositionStage(a2, "Boobjob_A2_S4", -102)

	AddTag("Default")
	AddTag("Sex")
	AddTag("Boobjob")
	AddTag("Dirty")
	AddTag("Breast")

	Save()
endFunction

function SexLabDoggyStyle(string eventName, string id, float argNum, form sender)
	Name = "Doggy Style"

	SetSFX(Squishing)
	SetContent(Sexual)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "DoggyStyle_A1_S1", 0)
	AddPositionStage(a1, "DoggyStyle_A1_S2", 0)
	AddPositionStage(a1, "DoggyStyle_A1_S3", 0)
	AddPositionStage(a1, "DoggyStyle_A1_S4", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "DoggyStyle_A2_S1", -104, sos = 3)
	AddPositionStage(a2, "DoggyStyle_A2_S2", -104, sos = 3)
	AddPositionStage(a2, "DoggyStyle_A2_S3", -104, sos = 3)
	AddPositionStage(a2, "DoggyStyle_A2_S4", -104, sos = 3)

	AddTag("Default")
	AddTag("Sex")
	AddTag("Doggy Style")
	AddTag("Vaginal")

	Save()
endFunction

function SexLabHuggingSex(string eventName, string id, float argNum, form sender)
	Name = "Hugging Fuck"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "HuggingSex_A1_S1", 0)
	AddPositionStage(a1, "HuggingSex_A1_S2", 0)
	AddPositionStage(a1, "HuggingSex_A1_S3", 0)
	AddPositionStage(a1, "HuggingSex_A1_S4", 0)

	int a2 = AddPosition(Male) ; -99
	AddPositionStage(a2, "HuggingSex_A2_S1", -102, sos = 9)
	AddPositionStage(a2, "HuggingSex_A2_S2", -102, sos = 9)
	AddPositionStage(a2, "HuggingSex_A2_S3", -102, sos = 9)
	AddPositionStage(a2, "HuggingSex_A2_S4", -102, sos = 9)

	AddTag("Default")
	AddTag("Sex")
	AddTag("Hugging")
	AddTag("Loving")
	AddTag("Vaginal")

	Save()
endFunction

function SexLabMissonary(string eventName, string id, float argNum, form sender)
	Name = "Missionary"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "Missionary_A1_S1", 0)
	AddPositionStage(a1, "Missionary_A1_S2", 0)
	AddPositionStage(a1, "Missionary_A1_S3", 0)
	AddPositionStage(a1, "Missionary_A1_S4", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "Missionary_A2_S1", -104, sos = 4)
	AddPositionStage(a2, "Missionary_A2_S2", -104, sos = 4)
	AddPositionStage(a2, "Missionary_A2_S3", -104, sos = 4)
	AddPositionStage(a2, "Missionary_A2_S4", -104, sos = 4)

	AddTag("Default")
	AddTag("Sex")
	AddTag("Missionary")
	AddTag("Laying")
	AddTag("Vaginal")

	Save()
endFunction

function SexLabReverseCowgirl(string eventName, string id, float argNum, form sender)
	Name = "Reverse Cowgirl"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "ReverseCowgirl_A1_S1", 0)
	AddPositionStage(a1, "ReverseCowgirl_A1_S2", 0)
	AddPositionStage(a1, "ReverseCowgirl_A1_S3", 0)
	AddPositionStage(a1, "ReverseCowgirl_A1_S4", 0)

	int a2 = AddPosition(Male) ; -102
	AddPositionStage(a2, "ReverseCowgirl_A2_S1", -107, sos = 3)
	AddPositionStage(a2, "ReverseCowgirl_A2_S2", -107, sos = 3)
	AddPositionStage(a2, "ReverseCowgirl_A2_S3", -107, sos = 3)
	AddPositionStage(a2, "ReverseCowgirl_A2_S4", -107, sos = 3)

	AddTag("Default")
	AddTag("Sex")
	AddTag("Dirty")
	AddTag("Cowgirl")
	AddTag("Anal")

	Save()
endFunction

function SexLabSideways(string eventName, string id, float argNum, form sender)
	Name = "Sideways Fuck"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "Sideways_A1_S1", 0)
	AddPositionStage(a1, "Sideways_A1_S2", 0)
	AddPositionStage(a1, "Sideways_A1_S3", 0)
	AddPositionStage(a1, "Sideways_A1_S4", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "Sideways_A2_S1", -104, sos = 9)
	AddPositionStage(a2, "Sideways_A2_S2", -104, sos = 9)
	AddPositionStage(a2, "Sideways_A2_S3", -104, sos = 9)
	AddPositionStage(a2, "Sideways_A2_S4", -104, sos = 9)

	AddTag("Default")
	AddTag("Sex")
	AddTag("Standing")
	AddTag("Sideways")
	AddTag("Vaginal")

	Save()
endFunction

function SexLabStanding(string eventName, string id, float argNum, form sender)
	Name = "Standing Fuck"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Standing_A1_S1", 0)
	AddPositionStage(a1, "Standing_A1_S2", 0)
	AddPositionStage(a1, "Standing_A1_S3", 0)
	AddPositionStage(a1, "Standing_A1_S4", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "Standing_A2_S1", -81, sos = 4)
	AddPositionStage(a2, "Standing_A2_S2", -81, sos = 3)
	AddPositionStage(a2, "Standing_A2_S3", -81, sos = 5)
	AddPositionStage(a2, "Standing_A2_S4", -81, sos = 6)

	AddTag("Default")
	AddTag("Sex")
	AddTag("Standing")
	AddTag("Dirty")
	AddTag("Vaginal")

	Save()
endFunction

function SexLabTribadism(string eventName, string id, float argNum, form sender)
	Name = "Tribadism"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female)
	AddPositionStage(a1, "Tribadism_A1_S1", 0)
	AddPositionStage(a1, "Tribadism_A1_S2", 0)
	AddPositionStage(a1, "Tribadism_A1_S2", 0)

	int a2 = AddPosition(Female)
	AddPositionStage(a2, "Tribadism_A2_S1", 60)
	AddPositionStage(a2, "Tribadism_A2_S2", 60)
	AddPositionStage(a2, "Tribadism_A2_S2", 60)

	AddTag("Default")
	AddTag("Sex")
	AddTag("FF")
	AddTag("Lesbian")
	AddTag("Tribadism")
	AddTag("Vaginal")

	Save()
endFunction

function BleaghFemaleSolo(string eventName, string id, float argNum, form sender)
	Name = "Bleagh Female Masturbation"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female)
	AddPositionStage(a1, "Bleagh_FemaleSolo_A1_S1", 0)
	AddPositionStage(a1, "Bleagh_FemaleSolo_A1_S2", 0)
	AddPositionStage(a1, "Bleagh_FemaleSolo_A1_S3", 0)
	AddPositionStage(a1, "Bleagh_FemaleSolo_A1_S4", 0)
	AddPositionStage(a1, "Bleagh_FemaleSolo_A1_S5", 0)

	AddTag("Sex")
	AddTag("Solo")
	AddTag("F")
	AddTag("Masturbation")
	AddTag("Dirty")

	Save()
endFunction

function APAnal(string eventName, string id, float argNum, form sender)
	Name = "AP Anal"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "AP_Anal_A1_S1", 0)
	AddPositionStage(a1, "AP_Anal_A1_S2", 0)
	AddPositionStage(a1, "AP_Anal_A1_S3", 0)
	AddPositionStage(a1, "AP_Anal_A1_S4", 0)
	AddPositionStage(a1, "AP_Anal_A1_S5", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "AP_Anal_A2_S1", 44, rotate = 180)
	AddPositionStage(a2, "AP_Anal_A2_S2", 44, rotate = 180)
	AddPositionStage(a2, "AP_Anal_A2_S3", 44, rotate = 180)
	AddPositionStage(a2, "AP_Anal_A2_S4", 44, rotate = 180)
	AddPositionStage(a2, "AP_Anal_A2_S5", 44, rotate = 180)

	AddTag("AP")
	AddTag("Sex")
	AddTag("Straight")
	AddTag("Aggressive")
	AddTag("Anal")

	Save()
endFunction

function APBedMissionary(string eventName, string id, float argNum, form sender)
	Name = "AP Bed Missionary"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "AP_BedMissionary_A1_S1", 0)
	AddPositionStage(a1, "AP_BedMissionary_A1_S2", 0)
	AddPositionStage(a1, "AP_BedMissionary_A1_S3", 0)
	AddPositionStage(a1, "AP_BedMissionary_A1_S4", 0)
	AddPositionStage(a1, "AP_BedMissionary_A1_S5", 0)
	AddPositionStage(a1, "AP_BedMissionary_A1_S6", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "AP_BedMissionary_A2_S1", 44, rotate = 180, sos = 5)
	AddPositionStage(a2, "AP_BedMissionary_A2_S2", 44, rotate = 180, sos = 5)
	AddPositionStage(a2, "AP_BedMissionary_A2_S3", 44, rotate = 180, sos = 5)
	AddPositionStage(a2, "AP_BedMissionary_A2_S4", 44, rotate = 180, sos = 5)
	AddPositionStage(a2, "AP_BedMissionary_A2_S4", 44, rotate = 180, sos = 5)
	AddPositionStage(a2, "AP_BedMissionary_A2_S4", 44, rotate = 180, sos = 5)

	AddTag("AP")
	AddTag("Sex")
	AddTag("Straight")
	AddTag("Missionary")
	AddTag("Vaginal")

	Save()
endFunction

function APBlowjob(string eventName, string id, float argNum, form sender)
	Name = "AP Blowjob"

	SetContent(Sexual)
	SetSFX(Sucking)

	int a1 = AddPosition(Female, addCum=Oral)
	AddPositionStage(a1, "AP_Blowjob_A1_S1", 0, silent = true, openMouth = true)
	AddPositionStage(a1, "AP_Blowjob_A1_S2", 0, silent = true, openMouth = true)
	AddPositionStage(a1, "AP_Blowjob_A1_S3", 0, silent = true, openMouth = true)
	AddPositionStage(a1, "AP_Blowjob_A1_S4", 0, silent = true, openMouth = true)
	AddPositionStage(a1, "AP_Blowjob_A1_S5", 0, silent = true, openMouth = true)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "AP_Cowgirl_A2_S1", 43, rotate = 180, sos = 1)
	AddPositionStage(a2, "AP_Cowgirl_A2_S2", 43, rotate = 180, sos = 1)
	AddPositionStage(a2, "AP_Cowgirl_A2_S2", 43, rotate = 180, sos = 1)
	AddPositionStage(a2, "AP_Cowgirl_A2_S3", 43, rotate = 180, sos = 1)
	AddPositionStage(a2, "AP_Cowgirl_A2_S4", 43, rotate = 180, sos = 1)

	AddTag("AP")
	AddTag("Sex")
	AddTag("Straight")
	AddTag("Dirty")
	AddTag("Oral")
	AddTag("Blowjob")
	AddTag("LeadIn")

	Save()
endFunction

function APBoobjob(string eventName, string id, float argNum, form sender)
	Name = "AP Boobjob"

	SetContent(Sexual)

	int a1 = AddPosition(Female, addCum=Oral)
	AddPositionStage(a1, "AP_Boobjob_A1_S1", 0)
	AddPositionStage(a1, "AP_Boobjob_A1_S2", 0)
	AddPositionStage(a1, "AP_Boobjob_A1_S3", 0)
	AddPositionStage(a1, "AP_Boobjob_A1_S4", 0)
	AddPositionStage(a1, "AP_Boobjob_A1_S5", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "AP_IdleStand_A2_S1", 30, rotate = 180, sos = 6)
	AddPositionStage(a2, "AP_IdleStand_A2_S2", 30, rotate = 180, sos = 6)
	AddPositionStage(a2, "AP_IdleStand_A2_S3", 30, rotate = 180, sos = 6)
	AddPositionStage(a2, "AP_IdleStand_A2_S4", 30, rotate = 180, sos = 6)
	AddPositionStage(a2, "AP_IdleStand_A2_S5", 30, rotate = 180, sos = 6)

	AddTag("AP")
	AddTag("Sex")
	AddTag("Straight")
	AddTag("Dirty")
	AddTag("Boobjob")
	AddTag("Breast")

	Save()
endFunction

function APCowgirl(string eventName, string id, float argNum, form sender)
	Name = "AP Cowgirl"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "AP_Cowgirl_A1_S1", 0)
	AddPositionStage(a1, "AP_Cowgirl_A1_S2", 0)
	AddPositionStage(a1, "AP_Cowgirl_A1_S3", 0)
	AddPositionStage(a1, "AP_Cowgirl_A1_S4", 0)
	AddPositionStage(a1, "AP_Cowgirl_A1_S5", 0)
	AddPositionStage(a1, "AP_Cowgirl_A1_S6", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "AP_Cowgirl_A2_S1", 44, rotate = 180, sos = 1)
	AddPositionStage(a2, "AP_Cowgirl_A2_S2", 44, rotate = 180, sos = 1)
	AddPositionStage(a2, "AP_Cowgirl_A2_S2", 44, rotate = 180, sos = 1)
	AddPositionStage(a2, "AP_Cowgirl_A2_S3", 44, rotate = 180, sos = 1)
	AddPositionStage(a2, "AP_Cowgirl_A2_S4", 44, rotate = 180, sos = 2)
	AddPositionStage(a2, "AP_Cowgirl_A2_S4", 44, rotate = 180, sos = 2)

	AddTag("AP")
	AddTag("Sex")
	AddTag("Straight")
	AddTag("Cowgirl")
	AddTag("Dirty")
	AddTag("Vaginal")

	Save()
endFunction

function APFemaleSolo(string eventName, string id, float argNum, form sender)
	Name = "AP Female Masturbation"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female)
	AddPositionStage(a1, "AP_FemaleSolo_A1_S1", 0)
	AddPositionStage(a1, "AP_FemaleSolo_A1_S2", 0)
	AddPositionStage(a1, "AP_FemaleSolo_A1_S3", 0)
	AddPositionStage(a1, "AP_FemaleSolo_A1_S4", 0)
	AddPositionStage(a1, "AP_FemaleSolo_A1_S5", 0)
	AddPositionStage(a1, "AP_FemaleSolo_A1_S6", 0)

	AddTag("Sex")
	AddTag("Solo")
	AddTag("F")
	AddTag("Masturbation")
	AddTag("Dirty")

	Save()
endFunction

function APFisting(string eventName, string id, float argNum, form sender)
	Name = "AP Fisting"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female)
	AddPositionStage(a1, "AP_Fisting_A1_S1", 0)
	AddPositionStage(a1, "AP_Fisting_A1_S2", 0)
	AddPositionStage(a1, "AP_Fisting_A1_S3", 0)
	AddPositionStage(a1, "AP_Fisting_A1_S4", 0)
	AddPositionStage(a1, "AP_Fisting_A1_S5", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "AP_Fisting_A2_S1", 44, rotate = 180, strapon = false)
	AddPositionStage(a2, "AP_Fisting_A2_S2", 44, rotate = 180, strapon = false)
	AddPositionStage(a2, "AP_Fisting_A2_S3", 44, rotate = 180, strapon = false)
	AddPositionStage(a2, "AP_Fisting_A2_S4", 44, rotate = 180, strapon = false)
	AddPositionStage(a2, "AP_Fisting_A2_S4", 44, rotate = 180, strapon = false)

	AddTag("AP")
	AddTag("Sex")
	AddTag("Straight")
	AddTag("Aggressive")
	AddTag("Fisting")
	AddTag("Rough")
	AddTag("Dirty")

	Save()
endFunction

function APHandjob(string eventName, string id, float argNum, form sender)
	Name = "AP Handjob"

	SetContent(Sexual)

	int a1 = AddPosition(Female, addCum=Oral)
	AddPositionStage(a1, "AP_Handjob_A1_S1", 0, up = 0.5, silent = true)
	AddPositionStage(a1, "AP_Handjob_A1_S2", 0, up = 0.5, silent = true)
	AddPositionStage(a1, "AP_Handjob_A1_S3", 0, up = 0.5, silent = true)
	AddPositionStage(a1, "AP_Handjob_A1_S4", 0, up = 0.5, silent = true)
	AddPositionStage(a1, "AP_Handjob_A1_S5", 0, up = 0.5, silent = true, openMouth = true)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "AP_IdleStand_A2_S1", 44, side = -3, rotate = 180, sos = -1)
	AddPositionStage(a2, "AP_IdleStand_A2_S2", 44, side = -3, rotate = 180, sos = -1)
	AddPositionStage(a2, "AP_IdleStand_A2_S3", 44, side = -3, rotate = 180, sos = -1)
	AddPositionStage(a2, "AP_IdleStand_A2_S4", 44, side = -3, rotate = 180, sos = -1)
	AddPositionStage(a2, "AP_IdleStand_A2_S5", 44, side = -3, rotate = 180, sos = -1)

	AddTag("AP")
	AddTag("Sex")
	AddTag("Straight")
	AddTag("Dirty")
	AddTag("Handjob")

	Save()
endFunction

function APKneelBlowjob(string eventName, string id, float argNum, form sender)
	Name = "AP Kneeling Blowjob"

	SetContent(Sexual)
	SetSFX(Sucking)

	int a1 = AddPosition(Female, addCum=Oral)
	AddPositionStage(a1, "AP_KneelBlowjob_A1_S1", 0, up = 1, silent = true, openMouth = true)
	AddPositionStage(a1, "AP_KneelBlowjob_A1_S2", 0, up = 1, silent = true, openMouth = true)
	AddPositionStage(a1, "AP_KneelBlowjob_A1_S3", 0, up = 1, silent = true, openMouth = true)
	AddPositionStage(a1, "AP_KneelBlowjob_A1_S4", 0, up = 1, silent = true, openMouth = true)
	AddPositionStage(a1, "AP_KneelBlowjob_A1_S5", 0, up = 1, silent = true, openMouth = true)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "AP_IdleStand_A2_S1", 44, rotate = 180, sos = -2)
	AddPositionStage(a2, "AP_IdleStand_A2_S2", 44, rotate = 180, sos = -2)
	AddPositionStage(a2, "AP_IdleStand_A2_S3", 44, rotate = 180, sos = -2)
	AddPositionStage(a2, "AP_IdleStand_A2_S4", 44, rotate = 180, sos = -2)
	AddPositionStage(a2, "AP_IdleStand_A2_S5", 44, rotate = 180, sos = -2)

	AddTag("AP")
	AddTag("Sex")
	AddTag("Straight")
	AddTag("Dirty")
	AddTag("Oral")
	AddTag("Blowjob")
	AddTag("LeadIn")

	Save()
endFunction

function APLegUp(string eventName, string id, float argNum, form sender)
	Name = "AP Leg Up Fuck"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "AP_LegUp_A1_S1", 0)
	AddPositionStage(a1, "AP_LegUp_A1_S2", 0)
	AddPositionStage(a1, "AP_LegUp_A1_S3", 0)
	AddPositionStage(a1, "AP_LegUp_A1_S4", 0)
	AddPositionStage(a1, "AP_LegUp_A1_S5", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "AP_LegUp_A2_S1", 44, up = 5, rotate = 180, sos = 3)
	AddPositionStage(a2, "AP_LegUp_A2_S2", 44, up = 5, rotate = 180, sos = 3)
	AddPositionStage(a2, "AP_LegUp_A2_S3", 44, up = 5, rotate = 180, sos = 3)
	AddPositionStage(a2, "AP_LegUp_A2_S4", 44, up = 5, rotate = 180, sos = 3)
	AddPositionStage(a2, "AP_LegUp_A2_S5", 44, up = 5, rotate = 180, sos = 3)

	AddTag("AP")
	AddTag("Dirty")
	AddTag("Laying")
	AddTag("Aggressive")
	AddTag("Vaginal")

	Save()
endFunction

function APShoulder(string eventName, string id, float argNum, form sender)
	Name = "AP Shoulder"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "AP_Shoulder_A1_S1", 0)
	AddPositionStage(a1, "AP_Shoulder_A1_S2", 0)
	AddPositionStage(a1, "AP_Shoulder_A1_S3", 0)
	AddPositionStage(a1, "AP_Shoulder_A1_S4", 0)
	AddPositionStage(a1, "AP_Shoulder_A1_S5", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "AP_IdleStand_A2_S1", 44, rotate = 180, sos = 2)
	AddPositionStage(a2, "AP_IdleStand_A2_S2", 44, rotate = 180, sos = 2)
	AddPositionStage(a2, "AP_IdleStand_A2_S3", 44, rotate = 180, sos = 2)
	AddPositionStage(a2, "AP_IdleStand_A2_S4", 44, rotate = 180, sos = 2)
	AddPositionStage(a2, "AP_IdleStand_A2_S5", 44, rotate = 180, sos = 2)

	AddTag("AP")
	AddTag("Sex")
	AddTag("Straight")
	AddTag("Standing")
	AddTag("Vaginal")

	Save()
endFunction

function APStandBlowjob(string eventName, string id, float argNum, form sender)
	Name = "AP Standing Blowjob"

	SetContent(Sexual)
	SetSFX(Sucking)

	int a1 = AddPosition(Female, addCum=Oral)
	AddPositionStage(a1, "AP_StandBlowjob_A1_S1", 0, silent = true, openMouth = true)
	AddPositionStage(a1, "AP_StandBlowjob_A1_S2", 0, silent = true, openMouth = true)
	AddPositionStage(a1, "AP_StandBlowjob_A1_S3", 0, silent = true, openMouth = true)
	AddPositionStage(a1, "AP_StandBlowjob_A1_S4", 0, silent = true, openMouth = true)
	AddPositionStage(a1, "AP_StandBlowjob_A1_S5", 0, silent = true, openMouth = true)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "AP_IdleStand_A2_S1", 44, rotate = 180, sos = -1)
	AddPositionStage(a2, "AP_IdleStand_A2_S2", 44, rotate = 180, sos = -1)
	AddPositionStage(a2, "AP_IdleStand_A2_S3", 44, rotate = 180, sos = -1)
	AddPositionStage(a2, "AP_IdleStand_A2_S4", 44, rotate = 180, sos = -1)
	AddPositionStage(a2, "AP_IdleStand_A2_S5", 44, rotate = 180, sos = -1)

	AddTag("AP")
	AddTag("Sex")
	AddTag("Straight")
	AddTag("Dirty")
	AddTag("Oral")
	AddTag("Blowjob")
	AddTag("LeadIn")

	Save()
endFunction

function APStanding(string eventName, string id, float argNum, form sender)
	Name = "AP Standing"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "AP_Standing_A1_S1", 0)
	AddPositionStage(a1, "AP_Standing_A1_S2", 0)
	AddPositionStage(a1, "AP_Standing_A1_S3", 0)
	AddPositionStage(a1, "AP_Standing_A1_S4", 0)
	AddPositionStage(a1, "AP_Standing_A1_S5", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "AP_Standing_A2_S1", 43, rotate = 180, sos = 2)
	AddPositionStage(a2, "AP_Standing_A2_S2", 43, rotate = 180, sos = 2)
	AddPositionStage(a2, "AP_Standing_A2_S2", 43, rotate = 180, sos = 2)
	AddPositionStage(a2, "AP_Standing_A2_S3", 43, rotate = 180, sos = 2)
	AddPositionStage(a2, "AP_Standing_A2_S3", 43, rotate = 180, sos = 2)

	AddTag("AP")
	AddTag("Sex")
	AddTag("Straight")
	AddTag("Standing")
	AddTag("Vaginal")

	Save()
endFunction

function APDoggyStyle(string eventName, string id, float argNum, form sender)
	Name = "AP DoggyStyle"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "AP_DoggyStyle_A1_S1", 0)
	AddPositionStage(a1, "AP_DoggyStyle_A1_S2", 0)
	AddPositionStage(a1, "AP_DoggyStyle_A1_S3", 0)
	AddPositionStage(a1, "AP_DoggyStyle_A1_S4", 0)
	AddPositionStage(a1, "AP_DoggyStyle_A1_S5", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "AP_HoldLegUp_A2_S1", 44, rotate = 180)
	AddPositionStage(a2, "AP_HoldLegUp_A2_S2", 44, rotate = 180)
	AddPositionStage(a2, "AP_HoldLegUp_A2_S2", 44, rotate = 180)
	AddPositionStage(a2, "AP_HoldLegUp_A2_S3", 44, rotate = 180)
	AddPositionStage(a2, "AP_HoldLegUp_A2_S3", 44, rotate = 180)

	AddTag("AP")
	AddTag("Sex")
	AddTag("Straight")
	AddTag("DoggyStyle")
	AddTag("Knees")
	AddTag("Anal")

	Save()
endFunction

function APHoldLegUp(string eventName, string id, float argNum, form sender)
	Name = "AP Holding Leg Up"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "AP_HoldLegUp_A1_S1", 0)
	AddPositionStage(a1, "AP_HoldLegUp_A1_S2", 0)
	AddPositionStage(a1, "AP_HoldLegUp_A1_S3", 0)
	AddPositionStage(a1, "AP_HoldLegUp_A1_S4", 0)
	AddPositionStage(a1, "AP_HoldLegUp_A1_S5", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "AP_HoldLegUp_A2_S1", 44, rotate = 180)
	AddPositionStage(a2, "AP_HoldLegUp_A2_S2", 44, rotate = 180)
	AddPositionStage(a2, "AP_HoldLegUp_A2_S2", 44, rotate = 180)
	AddPositionStage(a2, "AP_HoldLegUp_A2_S3", 44, rotate = 180)
	AddPositionStage(a2, "AP_HoldLegUp_A2_S3", 44, rotate = 180)

	AddTag("AP")
	AddTag("Sex")
	AddTag("Laying")
	AddTag("Aggressive")
	AddTag("Straight")
	AddTag("Anal")

	Save()
endFunction

function APFaceDown(string eventName, string id, float argNum, form sender)
	Name = "AP Face Down Anal"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "AP_FaceDown_A1_S1", 0)
	AddPositionStage(a1, "AP_FaceDown_A1_S2", 0)
	AddPositionStage(a1, "AP_FaceDown_A1_S3", 0)
	AddPositionStage(a1, "AP_FaceDown_A1_S4", 0)
	AddPositionStage(a1, "AP_FaceDown_A1_S5", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "AP_FaceDown_A2_S1", 44, rotate = 180)
	AddPositionStage(a2, "AP_FaceDown_A2_S2", 44, rotate = 180)
	AddPositionStage(a2, "AP_FaceDown_A2_S3", 44, rotate = 180)
	AddPositionStage(a2, "AP_FaceDown_A2_S3", 44, rotate = 180)
	AddPositionStage(a2, "AP_FaceDown_A2_S4", 44, rotate = 180)

	AddTag("AP")
	AddTag("Sex")
	AddTag("Laying")
	AddTag("Aggressive")
	AddTag("Straight")
	AddTag("Anal")

	Save()
endFunction

function APSkullFuck(string eventName, string id, float argNum, form sender)
	Name = "AP Skull Fuck"

	SetContent(Sexual)
	SetSFX(Oral)

	int a1 = AddPosition(Female, addCum=Oral)
	AddPositionStage(a1, "AP_SkullFuck_A1_S1", 0, silent = true, openMouth = true)
	AddPositionStage(a1, "AP_SkullFuck_A1_S2", 0, silent = true, openMouth = true)
	AddPositionStage(a1, "AP_SkullFuck_A1_S3", 0, silent = true, openMouth = true)
	AddPositionStage(a1, "AP_SkullFuck_A1_S4", 0, silent = true, openMouth = true)
	AddPositionStage(a1, "AP_SkullFuck_A1_S5", 0, silent = true, openMouth = true)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "AP_SkullFuck_A2_S1", 49, rotate = 180, sos = 1)
	AddPositionStage(a2, "AP_SkullFuck_A2_S2", 49, rotate = 180, sos = 1)
	AddPositionStage(a2, "AP_SkullFuck_A2_S3", 49, rotate = 180, sos = 2)
	AddPositionStage(a2, "AP_SkullFuck_A2_S4", 49, rotate = 180, sos = 2)
	AddPositionStage(a2, "AP_SkullFuck_A2_S5", 49, rotate = 180, sos = 2)

	AddTag("AP")
	AddTag("Sex")
	AddTag("Straight")
	AddTag("Aggressive")
	AddTag("Blowjob")
	AddTag("Oral")

	Save()
endFunction



function ZynRoughStanding(string eventName, string id, float argNum, form sender)
	Name = "Zyn Rough Standing"

	SetContent(Sexual)
	SetSFX(Sucking)

	int a1 = AddPosition(Female, addCum=VaginalOral)
	AddPositionStage(a1, "Zyn_RoughStanding_A1_S1", 0)
	AddPositionStage(a1, "Zyn_RoughStanding_A1_S2", silent = true, openMouth = true)
	AddPositionStage(a1, "Zyn_RoughStanding_A1_S3", 0)
	AddPositionStage(a1, "Zyn_RoughStanding_A1_S4", 0)

	int a2 = AddPosition(Male) ; -102
	AddPositionStage(a2, "Zyn_RoughStanding_A2_S1", -107, sos = 9)
	AddPositionStage(a2, "Zyn_RoughStanding_A2_S2", -107, sos = 9)
	AddPositionStage(a2, "Zyn_RoughStanding_A2_S3", -107, sos = 9)
	AddPositionStage(a2, "Zyn_RoughStanding_A2_S4", -107, sos = 9)

	AddTag("Zyn")
	AddTag("Sex")
	AddTag("Rough")
	AddTag("Standing")
	AddTag("Aggressive")
	AddTag("Oral")
	AddTag("Vaginal")

	Save()
endFunction

function ZynLesbian(string eventName, string id, float argNum, form sender)
	Name = "Zyn Lesbian"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "Zyn_Lesbian_A1_S1", 0, silent = true)
	AddPositionStage(a1, "Zyn_Lesbian_A1_S2", 0)
	AddPositionStage(a1, "Zyn_Lesbian_A1_S3", 0)
	AddPositionStage(a1, "Zyn_Lesbian_A1_S4", 0)

	int a2 = AddPosition(Female)
	AddPositionStage(a2, "Zyn_Lesbian_A2_S1", -81, silent = true)
	AddPositionStage(a2, "Zyn_Lesbian_A2_S2", -81, silent = true, openMouth = true)
	AddPositionStage(a2, "Zyn_Lesbian_A2_S3", -81)
	AddPositionStage(a2, "Zyn_Lesbian_A2_S4", -81)

	AddTag("Zyn")
	AddTag("Sex")
	AddTag("FF")
	AddTag("Lesbian")
	AddTag("Dirty")
	AddTag("Vaginal")
	AddTag("Oral")
	AddTag("Kissing")

	Save()
endFunction
