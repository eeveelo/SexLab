scriptname sslAnimationDefaults extends sslAnimationFactory

; Temporary alpha testing - SKSE 1.7.0 compatibility
function SendEvent(string Registrar)
	RegisterForModEvent("Register"+Registrar, Registrar)
	ModEvent.Send(ModEvent.Create("Register"+Registrar))
	; SendModEvent("Register"+Registrar)
	UnregisterForAllModEvents()
endFunction

function LoadAnimations()
	; Prepare factory for load
	FreeFactory()
	; Missionary
	RegisterAnimation("SexLabMissionary")
	RegisterAnimation("SexLabAggrMissionary")
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
	; Misc
	RegisterAnimation("APFisting")
	; 3P+
	RegisterAnimation("ArrokDevilsThreeway")
	RegisterAnimation("ArrokTricycle")
endFunction

function ArrokBlowjob()
	Name = "Arrok Blowjob"

	SetContent(Sexual)
	SoundFX = Sucking

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
	AddTag("MF")

	Save()
endFunction

function ArrokBoobjob()
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
	AddTag("MF")

	Save()
endFunction

function ArrokCowgirl()
	Name = "Arrok Cowgirl"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTag("MF")

	Save()
endFunction

function ArrokDevilsThreeway()
	Name = "Arrok Devils Threeway"

	SetContent(Sexual)
	SoundFX = SexMix

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

function ArrokDoggyStyle()
	Name = "Arrok DoggyStyle"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTag("MF")

	Save()
endFunction

function ArrokForeplay()
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
	AddTag("MF")

	Save()
endFunction

function ArrokLegUp()
	Name = "Arrok Leg Up Fuck"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTAg("AggressiveDefault")
	AddTag("Vaginal")
	AddTag("MF")

	Save()
endFunction

function ArrokMaleMasturbation()
	Name = "Arrok Male Masturbation"

	SetContent(Sexual)

	int a1 = AddPosition(Male)
	AddPositionStage(a1, "Arrok_MaleMasturbation_A1_S1", 0, sos = 3)
	AddPositionStage(a1, "Arrok_MaleMasturbation_A1_S2", 0, sos = 3)
	AddPositionStage(a1, "Arrok_MaleMasturbation_A1_S3", 0, sos = 3)
	AddPositionStage(a1, "Arrok_MaleMasturbation_A1_S4", 0, sos = 3)

	AddTag("Sex")
	AddTag("Solo")
	AddTag("Masturbation")
	AddTag("Standing")
	AddTag("Dirty")

	Save()
endFunction

function ArrokMissionary()
	Name = "Arrok Missionary"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTag("MF")

	Save()
endFunction

function ArrokOral()
	Name = "Arrok 69"

	SetContent(Sexual)
	SoundFX = Sucking

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
	AddTag("MF")

	Save()
endFunction



function ArrokReverseCowgirl()
	Name = "Arrok Reverse Cowgirl"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTag("MF")

	Save()
endFunction

function ArrokSideways()
	Name = "Arrok Sideways Fuck"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTag("MF")

	Save()
endFunction

function ArrokStanding()
	Name = "Arrok Standing Fuck"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTag("MF")

	Save()
endFunction

function ArrokStandingForeplay()
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
	AddTag("MF")

	Save()
endFunction

function ArrokTricycle()
	Name = "Arrok Tricycle"

	SetContent(Sexual)
	SoundFX = SexMix

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
	AddTag("MFF")

	Save()
endFunction

function ArrokHugFuck()
	Name = "Arrok HugFuck"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTag("Standing")
	AddTag("MF")

	Save()
endFunction

function ArrokLesbian()
	Name = "Arrok Lesbian"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTag("Lesbian")
	AddTag("Oral")
	AddTag("Vaginal")

	Save()
endFunction

function ArrokSittingForeplay()
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
	AddTag("MF")

	Save()
endFunction

function ArrokAnal()
	Name = "Arrok Anal"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTag("Standing")
	AddTag("Dirty")
	AddTag("MF")

	Save()
endFunction

function ArrokRape()
	Name = "Arrok Rape"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTAg("AggressiveDefault")
	AddTag("Dirty")
	AddTag("Behind")
	AddTag("MF")

	Save()
endFunction

function SexLabAggrBehind()
	Name = "Rough Behind"

	SetContent(Sexual)
	SoundFX = Squishing


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
	AddTAg("AggressiveDefault")
	AddTag("MF")

	Save()
endFunction

function SexLabAggrDoggyStyle()
	Name = "Rough Doggy Style"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTAg("AggressiveDefault")
	AddTag("MF")

	Save()
endFunction

function SexLabAggrMissionary()
	Name = "Rough Missionary"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTAg("AggressiveDefault")
	AddTag("MF")

	Save()
endFunction

function SexLabBoobjob()
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
	AddTag("MF")

	Save()
endFunction

function SexLabDoggyStyle()
	Name = "Doggy Style"

	SoundFX = Squishing
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
	AddTag("MF")

	Save()
endFunction

function SexLabHuggingSex()
	Name = "Hugging Fuck"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTag("MF")

	Save()
endFunction

function SexLabMissionary()
	Name = "Missionary"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTag("MF")

	Save()
endFunction

function SexLabReverseCowgirl()
	Name = "Reverse Cowgirl"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTag("MF")

	Save()
endFunction

function SexLabSideways()
	Name = "Sideways Fuck"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTag("MF")

	Save()
endFunction

function SexLabStanding()
	Name = "Standing Fuck"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTag("MF")

	Save()
endFunction

function SexLabTribadism()
	Name = "Tribadism"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTag("Lesbian")
	AddTag("Tribadism")
	AddTag("Vaginal")

	Save()
endFunction

function BleaghFootJob()
	Name = "Bleagh FootJob"

	SetContent(Sexual)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Bleagh_FootJob_A1_S1", 0)
	AddPositionStage(a1, "Bleagh_FootJob_A1_S2", 0)
	AddPositionStage(a1, "Bleagh_FootJob_A1_S3", 0)
	AddPositionStage(a1, "Bleagh_FootJob_A1_S4", 0)
	AddPositionStage(a1, "Bleagh_FootJob_A1_S5", 0)

	int a2 = AddPosition(Male)
	AddPositionStage(a2, "Bleagh_FootJob_A2_S1", 42, rotate = 180)
	AddPositionStage(a2, "Bleagh_FootJob_A2_S2", 42, rotate = 180)
	AddPositionStage(a2, "Bleagh_FootJob_A2_S3", 42, rotate = 180)
	AddPositionStage(a2, "Bleagh_FootJob_A2_S4", 42, rotate = 180)
	AddPositionStage(a2, "Bleagh_FootJob_A2_S5", 42, rotate = 180)

	AddTag("Sex")
	AddTag("MF")
	AddTag("Fetish")
	AddTag("Feet")
	AddTag("Footjob")
	AddTag("Bleagh")

	Save()
endFunction

function BleaghFemaleSolo()
	Name = "Bleagh Female Masturbation"

	SetContent(Sexual)
	SoundFX = Squishing

	int a1 = AddPosition(Female)
	AddPositionStage(a1, "Bleagh_FemaleSolo_A1_S1", 0)
	AddPositionStage(a1, "Bleagh_FemaleSolo_A1_S2", 0)
	AddPositionStage(a1, "Bleagh_FemaleSolo_A1_S3", 0)
	AddPositionStage(a1, "Bleagh_FemaleSolo_A1_S4", 0)
	AddPositionStage(a1, "Bleagh_FemaleSolo_A1_S5", 0)

	AddTag("Sex")
	AddTag("Solo")
	AddTag("Masturbation")
	AddTag("Dirty")

	Save()
endFunction

function APAnal()
	Name = "AP Anal"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTAg("AggressiveDefault")
	AddTag("Anal")
	AddTag("MF")

	Save()
endFunction

function APBedMissionary()
	Name = "AP Bed Missionary"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTag("MF")

	Save()
endFunction

function APBlowjob()
	Name = "AP Blowjob"

	SetContent(Sexual)
	SoundFX = Sucking

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
	AddTag("Standing")
	AddTag("LeadIn")
	AddTag("MF")

	Save()
endFunction

function APBoobjob()
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
	AddTag("Standing")
	AddTag("Breast")
	AddTag("MF")

	Save()
endFunction

function APCowgirl()
	Name = "AP Cowgirl"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTag("MF")

	Save()
endFunction

function APFemaleSolo()
	Name = "AP Female Masturbation"

	SetContent(Sexual)
	SoundFX = Squishing

	int a1 = AddPosition(Female)
	AddPositionStage(a1, "AP_FemaleSolo_A1_S1", 0)
	AddPositionStage(a1, "AP_FemaleSolo_A1_S2", 0)
	AddPositionStage(a1, "AP_FemaleSolo_A1_S3", 0)
	AddPositionStage(a1, "AP_FemaleSolo_A1_S4", 0)
	AddPositionStage(a1, "AP_FemaleSolo_A1_S5", 0)
	AddPositionStage(a1, "AP_FemaleSolo_A1_S6", 0)

	AddTag("Sex")
	AddTag("Solo")
	AddTag("Masturbation")
	AddTag("Dirty")

	Save()
endFunction

function APFisting()
	Name = "AP Fisting"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTAg("AggressiveDefault")
	AddTag("Fisting")
	AddTag("Rough")
	AddTag("Dirty")
	AddTag("MF")

	Save()
endFunction

function APHandjob()
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
	AddTag("Standing")
	AddTag("MF")

	Save()
endFunction

function APKneelBlowjob()
	Name = "AP Kneeling Blowjob"

	SetContent(Sexual)
	SoundFX = Sucking

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
	AddTag("Standing")
	AddTag("LeadIn")
	AddTag("MF")

	Save()
endFunction

function APLegUp()
	Name = "AP Leg Up Fuck"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTAg("AggressiveDefault")
	AddTag("Vaginal")
	AddTag("MF")

	Save()
endFunction

function APShoulder()
	Name = "AP Shoulder"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTag("MF")

	Save()
endFunction

function APStandBlowjob()
	Name = "AP Standing Blowjob"

	SetContent(Sexual)
	SoundFX = Sucking

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
	AddTag("Standing")
	AddTag("MF")

	Save()
endFunction

function APStanding()
	Name = "AP Standing"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTag("MF")

	Save()
endFunction

function APDoggyStyle()
	Name = "AP DoggyStyle"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTag("MF")

	Save()
endFunction

function APHoldLegUp()
	Name = "AP Holding Leg Up"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTAg("AggressiveDefault")
	AddTag("Straight")
	AddTag("Anal")
	AddTag("MF")

	Save()
endFunction

function APFaceDown()
	Name = "AP Face Down Anal"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTAg("AggressiveDefault")
	AddTag("Straight")
	AddTag("Anal")
	AddTag("MF")

	Save()
endFunction

function APSkullFuck()
	Name = "AP Skull Fuck"

	SetContent(Sexual)
	SoundFX = Sucking

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
	AddTAg("AggressiveDefault")
	AddTag("Blowjob")
	AddTag("Oral")
	AddTag("MF")

	Save()
endFunction



function ZynRoughStanding()
	Name = "Zyn Rough Standing"

	SetContent(Sexual)
	SoundFX = Sucking

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
	AddTAg("AggressiveDefault")
	AddTag("Oral")
	AddTag("Vaginal")
	AddTag("MF")

	Save()
endFunction

function ZynLesbian()
	Name = "Zyn Lesbian"

	SetContent(Sexual)
	SoundFX = Squishing

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
	AddTag("Lesbian")
	AddTag("Dirty")
	AddTag("Vaginal")
	AddTag("Oral")
	AddTag("Kissing")

	Save()
endFunction
