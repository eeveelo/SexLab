scriptname sslCreatureAnimationDefaults extends sslAnimationFactory

function LoadCreatureAnimations()
	; Prepare factory resources (as creature)
	PrepareFactoryCreatures()
	; Bear
	RegisterAnimation("BearDoggystyle")
	; Dog
	RegisterAnimation("CanineDoggystyle")
	RegisterAnimation("CanineDoggystyle2")
	RegisterAnimation("CanineMissionary")
	; Chaurus
	RegisterAnimation("ChaurusForward")
	RegisterAnimation("ChaurusReverse")
	; Dragon
	RegisterAnimation("DragonPenetration")
	RegisterAnimation("DragonTongue")
	; Draugr
	RegisterAnimation("DraugrDoggystyle")
	RegisterAnimation("DraugrHolding")
	RegisterAnimation("DraugrMissionary")
	RegisterAnimation("DraugrGangbang3P")
	RegisterAnimation("DraugrGangbang4P")
	RegisterAnimation("DraugrGangbang5P")
	; Falmer
	RegisterAnimation("FalmerDoggystyle")
	RegisterAnimation("FalmerHolding")
	RegisterAnimation("FalmerMissionary")
	RegisterAnimation("FalmerGangbang3P")
	RegisterAnimation("FalmerGangbang4P")
	RegisterAnimation("FalmerGangbang5P")
	; Dawguard Gargoyle
	RegisterAnimation("GargoyleDoggystyle")
	RegisterAnimation("GargoyleHolding")
	RegisterAnimation("GargoyleMissionary")
	; Giant
	RegisterAnimation("GiantPenetration")
	RegisterAnimation("GiantHarrassment")
	RegisterAnimation("GiantHolding")
	; Horse
	RegisterAnimation("HorseDoggystyle")
	RegisterAnimation("HorsePanicDoggystyle")
	RegisterAnimation("HorseGroping")
	; Rieklings
	RegisterAnimation("RieklingMissionary")
	RegisterAnimation("RieklingThreeWay")
	; SabreCat
	RegisterAnimation("CatDoggystyle")
	; Dragonborn Daedra Seeker
	RegisterAnimation("DaedraHugging")
	; Spider
	RegisterAnimation("SpiderDouble")
	RegisterAnimation("SpiderPenetration")
	RegisterAnimation("BigSpiderPenetration")
	; Troll
	RegisterAnimation("TrollDoggystyle")
	RegisterAnimation("TrollHolding")
	RegisterAnimation("TrollMissionary")
	RegisterAnimation("TrollDominate")
	RegisterAnimation("TrollGrabbing")
	; Werewolf
	RegisterAnimation("WerewolfAggrDoggystyle")
	RegisterAnimation("WerewolfDoggystyle")
	RegisterAnimation("WerewolfHolding")
	RegisterAnimation("WerewolfMissionary")
	; Wolf
	RegisterAnimation("WolfDoggystyle")
	RegisterAnimation("WolfDoggystyle2")
	RegisterAnimation("WolfMissionary")
	; Dawnguard Vampire Lord
	RegisterAnimation("VampireLordDoggystyle")
	RegisterAnimation("VampireLordHolding")
	RegisterAnimation("VampireLordMissionary")
endFunction

function BearDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Bear) Doggystyle"
	Base.RaceType = "Bears"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Bear_Doggystyle_A1_S1")
	Base.AddPositionStage(a1, "Bear_Doggystyle_A1_S2")
	Base.AddPositionStage(a1, "Bear_Doggystyle_A1_S3")
	Base.AddPositionStage(a1, "Bear_Doggystyle_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Bear_Doggystyle_A2_S1", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Bear_Doggystyle_A2_S2", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Bear_Doggystyle_A2_S3", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Bear_Doggystyle_A2_S4", 45.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Doggystyle")
	Base.AddTag("Bear")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function ChaurusForward(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Chaurus) Forward"
	Base.RaceType = "Chaurus"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Chaurus_Forward_A1_S1")
	Base.AddPositionStage(a1, "Chaurus_Forward_A1_S2")
	Base.AddPositionStage(a1, "Chaurus_Forward_A1_S3")
	Base.AddPositionStage(a1, "Chaurus_Forward_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Chaurus_Forward_A2_S1", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Chaurus_Forward_A2_S2", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Chaurus_Forward_A2_S3", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Chaurus_Forward_A2_S4", 40.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Holding")
	Base.AddTag("Chaurus")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function ChaurusReverse(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Chaurus) Reverse"
	Base.RaceType = "Chaurus"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "Chaurus_Reverse_A1_S1")
	Base.AddPositionStage(a1, "Chaurus_Reverse_A1_S2")
	Base.AddPositionStage(a1, "Chaurus_Reverse_A1_S3")
	Base.AddPositionStage(a1, "Chaurus_Reverse_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Chaurus_Reverse_A2_S1", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Chaurus_Reverse_A2_S2", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Chaurus_Reverse_A2_S3", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Chaurus_Reverse_A2_S4", 40.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Holding")
	Base.AddTag("Chaurus")
	Base.AddTag("Anal")

	Base.Save(id)
endFunction

function DaedraHugging(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Seeker) Hugging"
	Base.RaceType = "Seekers"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "Daedra_Hugging_A1_S1")
	Base.AddPositionStage(a1, "Daedra_Hugging_A1_S2")
	Base.AddPositionStage(a1, "Daedra_Hugging_A1_S3")
	Base.AddPositionStage(a1, "Daedra_Hugging_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Daedra_Hugging_A2_S1", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Daedra_Hugging_A2_S2", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Daedra_Hugging_A2_S3", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Daedra_Hugging_A2_S4", 40.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Holding")
	Base.AddTag("Hugging")
	Base.AddTag("Daedra")
	Base.AddTag("Seeking")
	Base.AddTag("Vaginal")
	Base.AddTag("Anal")

	Base.Save(id)
endFunction

function CanineDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Dog) Doggystyle"
	Base.RaceType = "Dogs"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Canine_Doggystyle_A1_S1")
	Base.AddPositionStage(a1, "Canine_Doggystyle_A1_S2")
	Base.AddPositionStage(a1, "Canine_Doggystyle_A1_S3")
	Base.AddPositionStage(a1, "Canine_Doggystyle_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Dog_Doggystyle_A2_S1", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Dog_Doggystyle_A2_S2", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Dog_Doggystyle_A2_S3", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Dog_Doggystyle_A2_S4", 45.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Doggystyle")
	Base.AddTag("Canine")
	Base.AddTag("Dog")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function CanineDoggystyle2(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Dog) Dominate"
	Base.RaceType = "Dogs"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Canine_Doggystyle2_A1_S1")
	Base.AddPositionStage(a1, "Canine_Doggystyle2_A1_S2")
	Base.AddPositionStage(a1, "Canine_Doggystyle2_A1_S3")
	Base.AddPositionStage(a1, "Canine_Doggystyle2_A1_S4")
	Base.AddPositionStage(a1, "Canine_Doggystyle2_A1_S5")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Dog_Doggystyle2_A2_S1")
	Base.AddPositionStage(a2, "Dog_Doggystyle2_A2_S2")
	Base.AddPositionStage(a2, "Dog_Doggystyle2_A2_S3")
	Base.AddPositionStage(a2, "Dog_Doggystyle2_A2_S4")
	Base.AddPositionStage(a2, "Dog_Doggystyle2_A2_S5")

	Base.AddTag("Panicforever")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Doggystyle")
	Base.AddTag("Canine")
	Base.AddTag("Dog")
	Base.AddTag("Anal")

	Base.Save(id)
endFunction

function CanineMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Dog) Missionary"
	Base.RaceType = "Dogs"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "Canine_Missionary_A1_S1")
	Base.AddPositionStage(a1, "Canine_Missionary_A1_S2")
	Base.AddPositionStage(a1, "Canine_Missionary_A1_S3")
	Base.AddPositionStage(a1, "Canine_Missionary_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Dog_Missionary_A2_S1", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Dog_Missionary_A2_S2", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Dog_Missionary_A2_S3", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Dog_Missionary_A2_S4", 45.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Missionary")
	Base.AddTag("Canine")
	Base.AddTag("Dog")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction


function DragonPenetration(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Dragon) Penetration"
	Base.RaceType = "Dragons"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Dragon_Penetration_A1_S1")
	Base.AddPositionStage(a1, "Dragon_Penetration_A1_S2")
	Base.AddPositionStage(a1, "Dragon_Penetration_A1_S3")
	Base.AddPositionStage(a1, "Dragon_Penetration_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Dragon_Penetration_A2_S1", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Dragon_Penetration_A2_S2", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Dragon_Penetration_A2_S3", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Dragon_Penetration_A2_S4", 35.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Missionary")
	Base.AddTag("Dragon")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function DragonTongue(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Dragon) Tongue"
	Base.RaceType = "Dragons"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "Dragon_Tongue_A1_S1")
	Base.AddPositionStage(a1, "Dragon_Tongue_A1_S2")
	Base.AddPositionStage(a1, "Dragon_Tongue_A1_S3")
	Base.AddPositionStage(a1, "Dragon_Tongue_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Dragon_Tongue_A2_S1", 32.0)
	Base.AddPositionStage(a2, "Dragon_Tongue_A2_S2", 32.0)
	Base.AddPositionStage(a2, "Dragon_Tongue_A2_S3", 32.0)
	Base.AddPositionStage(a2, "Dragon_Tongue_A2_S4", 32.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Oral")
	Base.AddTag("Dragon")
	Base.AddTag("Oral")

	Base.Save(id)
endFunction

function DraugrDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Draugr) Doggystyle"
	Base.RaceType = "Draugrs"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Draugr_Doggystyle_A1_S1")
	Base.AddPositionStage(a1, "Draugr_Doggystyle_A1_S2")
	Base.AddPositionStage(a1, "Draugr_Doggystyle_A1_S3")
	Base.AddPositionStage(a1, "Draugr_Doggystyle_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Draugr_Doggystyle_A2_S1", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Doggystyle_A2_S2", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Doggystyle_A2_S3", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Doggystyle_A2_S4", 35.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Doggystyle")
	Base.AddTag("Draugr")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function DraugrGangbang3P(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Draugr) Gangbang 3P"
	Base.RaceType = "Draugrs"
	Base.SoundFX  = SexMix

	int a1 = Base.AddPosition(Female, VaginalOralAnal)
	Base.AddPositionStage(a1, "Draugr_Gangbang_A1_S1", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Draugr_Gangbang_A1_S2", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Draugr_Gangbang_A1_S3", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Draugr_Gangbang_A1_S4", silent = true, openMouth = true)

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Draugr_Gangbang_A2_S1", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Gangbang_A2_S2", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Gangbang_A2_S3", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Gangbang_A2_S4", 30.0, rotate=180.0)

	int a3 = Base.AddPosition(Creature)
	Base.AddPositionStage(a3, "Draugr_Gangbang_A3_S1", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Draugr_Gangbang_A3_S2", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Draugr_Gangbang_A3_S3", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Draugr_Gangbang_A3_S4", 31.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Gangbang")
	Base.AddTag("Draugr")
	Base.AddTag("Vaginal")
	Base.AddTag("Oral")

	Base.Save(id)
endFunction

function DraugrGangbang4P(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Draugr) Gangbang 4P"
	Base.RaceType = "Draugrs"
	Base.SoundFX  = SexMix

	int a1 = Base.AddPosition(Female, VaginalOralAnal)
	Base.AddPositionStage(a1, "Draugr_Gangbang_A1_S1", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Draugr_Gangbang_A1_S2", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Draugr_Gangbang_A1_S3", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Draugr_Gangbang_A1_S4", silent = true, openMouth = true)

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Draugr_Gangbang_A2_S1", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Gangbang_A2_S2", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Gangbang_A2_S3", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Gangbang_A2_S4", 30.0, rotate=180.0)

	int a3 = Base.AddPosition(Creature)
	Base.AddPositionStage(a3, "Draugr_Gangbang_A3_S1", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Draugr_Gangbang_A3_S2", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Draugr_Gangbang_A3_S3", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Draugr_Gangbang_A3_S4", 31.0, rotate=180.0)

	int a4 = Base.AddPosition(Creature)
	Base.AddPositionStage(a4, "Draugr_Gangbang_A4_S1", 32.0, rotate=180.0)
	Base.AddPositionStage(a4, "Draugr_Gangbang_A4_S2", 32.0, rotate=180.0)
	Base.AddPositionStage(a4, "Draugr_Gangbang_A4_S3", 32.0, rotate=180.0)
	Base.AddPositionStage(a4, "Draugr_Gangbang_A4_S4", 32.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Gangbang")
	Base.AddTag("Draugr")
	Base.AddTag("Vaginal")
	Base.AddTag("Oral")
	Base.AddTag("Anal")

	Base.Save(id)
endFunction

function DraugrGangbang5P(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Draugr) Gangbang 5P"
	Base.RaceType = "Draugrs"
	Base.SoundFX  = SexMix

	int a1 = Base.AddPosition(Female, VaginalOralAnal)
	Base.AddPositionStage(a1, "Draugr_Gangbang_A1_S1", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Draugr_Gangbang_A1_S2", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Draugr_Gangbang_A1_S3", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Draugr_Gangbang_A1_S4", silent = true, openMouth = true)

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Draugr_Gangbang_A2_S1", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Gangbang_A2_S2", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Gangbang_A2_S3", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Gangbang_A2_S4", 30.0, rotate=180.0)

	int a3 = Base.AddPosition(Creature)
	Base.AddPositionStage(a3, "Draugr_Gangbang_A3_S1", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Draugr_Gangbang_A3_S2", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Draugr_Gangbang_A3_S3", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Draugr_Gangbang_A3_S4", 31.0, rotate=180.0)

	int a4 = Base.AddPosition(Creature)
	Base.AddPositionStage(a4, "Draugr_Gangbang_A4_S1", 32.0, rotate=180.0)
	Base.AddPositionStage(a4, "Draugr_Gangbang_A4_S2", 32.0, rotate=180.0)
	Base.AddPositionStage(a4, "Draugr_Gangbang_A4_S3", 32.0, rotate=180.0)
	Base.AddPositionStage(a4, "Draugr_Gangbang_A4_S4", 32.0, rotate=180.0)

	int a5 = Base.AddPosition(Creature)
	Base.AddPositionStage(a4, "Draugr_Gangbang_A5_S1", 33.0, rotate=180.0)
	Base.AddPositionStage(a4, "Draugr_Gangbang_A5_S2", 33.0, rotate=180.0)
	Base.AddPositionStage(a4, "Draugr_Gangbang_A5_S3", 33.0, rotate=180.0)
	Base.AddPositionStage(a4, "Draugr_Gangbang_A5_S4", 33.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Gangbang")
	Base.AddTag("Draugr")
	Base.AddTag("Vaginal")
	Base.AddTag("Oral")
	Base.AddTag("Anal")

	Base.Save(id)
endFunction

function DraugrHolding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Draugr) Holding"
	Base.RaceType = "Draugrs"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Draugr_Holding_A1_S1")
	Base.AddPositionStage(a1, "Draugr_Holding_A1_S2")
	Base.AddPositionStage(a1, "Draugr_Holding_A1_S3")
	Base.AddPositionStage(a1, "Draugr_Holding_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Draugr_Holding_A2_S1", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Holding_A2_S2", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Holding_A2_S3", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Holding_A2_S4", 35.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Holding")
	Base.AddTag("Draugr")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function DraugrMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Draugr) Missionary"
	Base.RaceType = "Draugrs"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "Draugr_Missionary_A1_S1")
	Base.AddPositionStage(a1, "Draugr_Missionary_A1_S2")
	Base.AddPositionStage(a1, "Draugr_Missionary_A1_S3")
	Base.AddPositionStage(a1, "Draugr_Missionary_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Draugr_Missionary_A2_S1", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Missionary_A2_S2", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Missionary_A2_S3", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Missionary_A2_S4", 35.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Missionary")
	Base.AddTag("Draugr")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function FalmerDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Falmer) Doggystyle"
	Base.RaceType = "Falmers"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Falmer_Doggystyle_A1_S1")
	Base.AddPositionStage(a1, "Falmer_Doggystyle_A1_S2")
	Base.AddPositionStage(a1, "Falmer_Doggystyle_A1_S3")
	Base.AddPositionStage(a1, "Falmer_Doggystyle_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Falmer_Doggystyle_A2_S1", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Doggystyle_A2_S2", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Doggystyle_A2_S3", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Doggystyle_A2_S4", 35.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Doggystyle")
	Base.AddTag("Falmer")
	Base.AddTag("Anal")

	Base.Save(id)
endFunction

function FalmerGangbang3P(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Falmer) Gangbang 3P"
	Base.RaceType = "Falmers"
	Base.SoundFX  = SexMix

	int a1 = Base.AddPosition(Female, VaginalOralAnal)
	Base.AddPositionStage(a1, "Falmer_Gangbang_A1_S1", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Falmer_Gangbang_A1_S2", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Falmer_Gangbang_A1_S3", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Falmer_Gangbang_A1_S4", silent = true, openMouth = true)

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Falmer_Gangbang_A2_S1", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Gangbang_A2_S2", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Gangbang_A2_S3", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Gangbang_A2_S4", 30.0, rotate=180.0)

	int a3 = Base.AddPosition(Creature)
	Base.AddPositionStage(a3, "Falmer_Gangbang_A3_S1", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Falmer_Gangbang_A3_S2", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Falmer_Gangbang_A3_S3", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Falmer_Gangbang_A3_S4", 31.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Gangbang")
	Base.AddTag("Falmer")
	Base.AddTag("Anal")
	Base.AddTag("Oral")

	Base.Save(id)
endFunction

function FalmerGangbang4P(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Falmer) Gangbang 4P"
	Base.RaceType = "Falmers"
	Base.SoundFX  = SexMix

	int a1 = Base.AddPosition(Female, VaginalOralAnal)
	Base.AddPositionStage(a1, "Falmer_Gangbang_A1_S1", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Falmer_Gangbang_A1_S2", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Falmer_Gangbang_A1_S3", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Falmer_Gangbang_A1_S4", silent = true, openMouth = true)

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Falmer_Gangbang_A2_S1", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Gangbang_A2_S2", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Gangbang_A2_S3", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Gangbang_A2_S4", 30.0, rotate=180.0)

	int a3 = Base.AddPosition(Creature)
	Base.AddPositionStage(a3, "Falmer_Gangbang_A3_S1", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Falmer_Gangbang_A3_S2", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Falmer_Gangbang_A3_S3", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Falmer_Gangbang_A3_S4", 31.0, rotate=180.0)

	int a4 = Base.AddPosition(Creature)
	Base.AddPositionStage(a4, "Falmer_Gangbang_A4_S1", 32.0, rotate=180.0)
	Base.AddPositionStage(a4, "Falmer_Gangbang_A4_S2", 32.0, rotate=180.0)
	Base.AddPositionStage(a4, "Falmer_Gangbang_A4_S3", 32.0, rotate=180.0)
	Base.AddPositionStage(a4, "Falmer_Gangbang_A4_S4", 32.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Gangbang")
	Base.AddTag("Falmer")
	Base.AddTag("Anal")
	Base.AddTag("Oral")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function FalmerGangbang5P(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Falmer) Gangbang 5P"
	Base.RaceType = "Falmers"
	Base.SoundFX  = SexMix

	int a1 = Base.AddPosition(Female, VaginalOralAnal)
	Base.AddPositionStage(a1, "Falmer_Gangbang_A1_S1", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Falmer_Gangbang_A1_S2", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Falmer_Gangbang_A1_S3", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Falmer_Gangbang_A1_S4", silent = true, openMouth = true)

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Falmer_Gangbang_A2_S1", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Gangbang_A2_S2", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Gangbang_A2_S3", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Gangbang_A2_S4", 30.0, rotate=180.0)

	int a3 = Base.AddPosition(Creature)
	Base.AddPositionStage(a3, "Falmer_Gangbang_A3_S1", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Falmer_Gangbang_A3_S2", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Falmer_Gangbang_A3_S3", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Falmer_Gangbang_A3_S4", 31.0, rotate=180.0)

	int a4 = Base.AddPosition(Creature)
	Base.AddPositionStage(a4, "Falmer_Gangbang_A4_S1", 32.0, rotate=180.0)
	Base.AddPositionStage(a4, "Falmer_Gangbang_A4_S2", 32.0, rotate=180.0)
	Base.AddPositionStage(a4, "Falmer_Gangbang_A4_S3", 32.0, rotate=180.0)
	Base.AddPositionStage(a4, "Falmer_Gangbang_A4_S4", 32.0, rotate=180.0)

	int a5 = Base.AddPosition(Creature)
	Base.AddPositionStage(a4, "Falmer_Gangbang_A5_S1", 33.0, rotate=180.0)
	Base.AddPositionStage(a4, "Falmer_Gangbang_A5_S2", 33.0, rotate=180.0)
	Base.AddPositionStage(a4, "Falmer_Gangbang_A5_S3", 33.0, rotate=180.0)
	Base.AddPositionStage(a4, "Falmer_Gangbang_A5_S4", 33.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Gangbang")
	Base.AddTag("Falmer")
	Base.AddTag("Anal")
	Base.AddTag("Oral")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function FalmerHolding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Falmer) Holding"
	Base.RaceType = "Falmers"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Falmer_Holding_A1_S1")
	Base.AddPositionStage(a1, "Falmer_Holding_A1_S2")
	Base.AddPositionStage(a1, "Falmer_Holding_A1_S3")
	Base.AddPositionStage(a1, "Falmer_Holding_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Falmer_Holding_A2_S1", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Holding_A2_S2", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Holding_A2_S3", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Holding_A2_S4", 35.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Doggystyle")
	Base.AddTag("Missionary")
	Base.AddTag("Holding")
	Base.AddTag("Gangbang")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function FalmerMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Falmer) Missionary"
	Base.RaceType = "Falmers"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "Falmer_Missionary_A1_S1")
	Base.AddPositionStage(a1, "Falmer_Missionary_A1_S2")
	Base.AddPositionStage(a1, "Falmer_Missionary_A1_S3")
	Base.AddPositionStage(a1, "Falmer_Missionary_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Falmer_Missionary_A2_S1", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Missionary_A2_S2", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Missionary_A2_S3", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Missionary_A2_S4", 35.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Doggystyle")
	Base.AddTag("Missionary")
	Base.AddTag("Holding")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function GargoyleDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Gargoyle) Doggystyle"
	Base.RaceType = "Gargoyles"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Gargoyle_Doggystyle_A1_S1")
	Base.AddPositionStage(a1, "Gargoyle_Doggystyle_A1_S2")
	Base.AddPositionStage(a1, "Gargoyle_Doggystyle_A1_S3")
	Base.AddPositionStage(a1, "Gargoyle_Doggystyle_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Gargoyle_Doggystyle_A2_S1", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Gargoyle_Doggystyle_A2_S2", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Gargoyle_Doggystyle_A2_S3", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Gargoyle_Doggystyle_A2_S4", 40.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Doggystyle")
	Base.AddTag("Gargoyle")
	Base.AddTag("Anal")

	Base.Save(id)
endFunction

function GargoyleHolding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Gargoyle) Holding"
	Base.RaceType = "Gargoyles"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Gargoyle_Holding_A1_S1")
	Base.AddPositionStage(a1, "Gargoyle_Holding_A1_S2")
	Base.AddPositionStage(a1, "Gargoyle_Holding_A1_S3")
	Base.AddPositionStage(a1, "Gargoyle_Holding_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Gargoyle_Holding_A2_S1", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Gargoyle_Holding_A2_S2", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Gargoyle_Holding_A2_S3", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Gargoyle_Holding_A2_S4", 40.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Holding")
	Base.AddTag("Gargoyle")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function GargoyleMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Gargoyle) Missionary"
	Base.RaceType = "Gargoyles"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "Gargoyle_Missionary_A1_S1")
	Base.AddPositionStage(a1, "Gargoyle_Missionary_A1_S2")
	Base.AddPositionStage(a1, "Gargoyle_Missionary_A1_S3")
	Base.AddPositionStage(a1, "Gargoyle_Missionary_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Gargoyle_Missionary_A2_S1", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Gargoyle_Missionary_A2_S2", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Gargoyle_Missionary_A2_S3", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Gargoyle_Missionary_A2_S4", 40.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Missionary")
	Base.AddTag("Gargoyle")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function GiantPenetration(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Giant) Penetration"
	Base.RaceType = "Giants"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Giant_Penetration_A1_S1")
	Base.AddPositionStage(a1, "Giant_Penetration_A1_S2")
	Base.AddPositionStage(a1, "Giant_Penetration_A1_S3")
	Base.AddPositionStage(a1, "Giant_Penetration_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Giant_Penetration_A2_S1", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Giant_Penetration_A2_S2", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Giant_Penetration_A2_S3", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Giant_Penetration_A2_S4", 35.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Holding")
	Base.AddTag("Rough")
	Base.AddTag("Giant")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function HorseDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Horse) Doggystyle"
	Base.RaceType = "Horses"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Horse_Doggystyle_A1_S1")
	Base.AddPositionStage(a1, "Horse_Doggystyle_A1_S2")
	Base.AddPositionStage(a1, "Horse_Doggystyle_A1_S3")
	Base.AddPositionStage(a1, "Horse_Doggystyle_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Horse_Doggystyle_A2_S1", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Horse_Doggystyle_A2_S2", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Horse_Doggystyle_A2_S3", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Horse_Doggystyle_A2_S4", 45.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Doggystyle")
	Base.AddTag("Horse")
	Base.AddTag("Anal")

	Base.Save(id)
endFunction

function CatDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Sabre Cat) Doggystyle"
	Base.RaceType = "SabreCats"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Cat_Doggystyle_A1_S1")
	Base.AddPositionStage(a1, "Cat_Doggystyle_A1_S2")
	Base.AddPositionStage(a1, "Cat_Doggystyle_A1_S3")
	Base.AddPositionStage(a1, "Cat_Doggystyle_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Cat_Doggystyle_A2_S1", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Cat_Doggystyle_A2_S2", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Cat_Doggystyle_A2_S3", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Cat_Doggystyle_A2_S4", 45.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Doggystyle")
	Base.AddTag("Cat")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function SpiderDouble(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Spider) Double"
	Base.RaceType = "Spiders"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, VaginalOralAnal)
	Base.AddPositionStage(a1, "Spider_Double_A1_S1")
	Base.AddPositionStage(a1, "Spider_Double_A1_S2")
	Base.AddPositionStage(a1, "Spider_Double_A1_S3")
	Base.AddPositionStage(a1, "Spider_Double_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Spider_Double_A2_S1", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Spider_Double_A2_S2", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Spider_Double_A2_S3", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Spider_Double_A2_S4", 35.0, rotate=180.0)

	int a3 = Base.AddPosition(Creature)
	Base.AddPositionStage(a3, "Spider_Double_A3_S1", 70.0, rotate=180.0)
	Base.AddPositionStage(a3, "Spider_Double_A3_S2", 70.0, rotate=180.0)
	Base.AddPositionStage(a3, "Spider_Double_A3_S3", 70.0, rotate=180.0)
	Base.AddPositionStage(a3, "Spider_Double_A3_S4", 70.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Gangbang")
	Base.AddTag("Spider")
	Base.AddTag("Vaginal")
	Base.AddTag("Oral")

	Base.Save(id)
endFunction

function SpiderPenetration(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Spider) Penetration"
	Base.RaceType = "Spiders"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Spider_Penetration_A1_S1")
	Base.AddPositionStage(a1, "Spider_Penetration_A1_S2")
	Base.AddPositionStage(a1, "Spider_Penetration_A1_S3")
	Base.AddPositionStage(a1, "Spider_Penetration_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Spider_Penetration_A2_S1", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Spider_Penetration_A2_S2", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Spider_Penetration_A2_S3", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Spider_Penetration_A2_S4", 35.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Missionary")
	Base.AddTag("Spider")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function BigSpiderPenetration(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Large Spider) Penetration"
	Base.RaceType = "LargeSpiders"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "BigSpider_Penetration_A1_S1")
	Base.AddPositionStage(a1, "BigSpider_Penetration_A1_S2")
	Base.AddPositionStage(a1, "BigSpider_Penetration_A1_S3")
	Base.AddPositionStage(a1, "BigSpider_Penetration_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "BigSpider_Penetration_A2_S1", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "BigSpider_Penetration_A2_S2", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "BigSpider_Penetration_A2_S3", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "BigSpider_Penetration_A2_S4", 35.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Rough")
	Base.AddTag("Spider")
	Base.AddTag("Big Spider")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction


function TrollDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Troll) Doggystyle"
	Base.RaceType = "Trolls"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Troll_Doggystyle_A1_S1")
	Base.AddPositionStage(a1, "Troll_Doggystyle_A1_S2")
	Base.AddPositionStage(a1, "Troll_Doggystyle_A1_S3")
	Base.AddPositionStage(a1, "Troll_Doggystyle_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Troll_Doggystyle_A2_S1", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Troll_Doggystyle_A2_S2", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Troll_Doggystyle_A2_S3", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Troll_Doggystyle_A2_S4", 45.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Doggystyle")
	Base.AddTag("Troll")
	Base.AddTag("Anal")

	Base.Save(id)
endFunction

function TrollHolding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Troll) Holding"
	Base.RaceType = "Trolls"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Troll_Holding_A1_S1")
	Base.AddPositionStage(a1, "Troll_Holding_A1_S2")
	Base.AddPositionStage(a1, "Troll_Holding_A1_S3")
	Base.AddPositionStage(a1, "Troll_Holding_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Troll_Holding_A2_S1", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Troll_Holding_A2_S2", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Troll_Holding_A2_S3", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Troll_Holding_A2_S4", 45.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Holding")
	Base.AddTag("Troll")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function TrollMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Troll) Missionary"
	Base.RaceType = "Trolls"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "Troll_Missionary_A1_S1")
	Base.AddPositionStage(a1, "Troll_Missionary_A1_S2")
	Base.AddPositionStage(a1, "Troll_Missionary_A1_S3")
	Base.AddPositionStage(a1, "Troll_Missionary_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Troll_Missionary_A2_S1", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Troll_Missionary_A2_S2", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Troll_Missionary_A2_S3", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Troll_Missionary_A2_S4", 45.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Missionary")
	Base.AddTag("Troll")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function TrollDominate(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Troll) Dominate"
	Base.RaceType = "Trolls"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Troll_Dominate_A1_S1")
	Base.AddPositionStage(a1, "Troll_Dominate_A1_S2")
	Base.AddPositionStage(a1, "Troll_Dominate_A1_S3")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Troll_Dominate_A2_S1")
	Base.AddPositionStage(a2, "Troll_Dominate_A2_S2")
	Base.AddPositionStage(a2, "Troll_Dominate_A2_S3")

	Base.AddTag("Panicforever")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Missionary")
	Base.AddTag("Troll")
	Base.AddTag("Anal")

	Base.Save(id)
endFunction

function TrollGrabbing(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Troll) Grabbing"
	Base.RaceType = "Trolls"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Troll_Grabbing_A1_S1")
	Base.AddPositionStage(a1, "Troll_Grabbing_A1_S2")
	Base.AddPositionStage(a1, "Troll_Grabbing_A1_S3")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Troll_Grabbing_A2_S1")
	Base.AddPositionStage(a2, "Troll_Grabbing_A2_S2")
	Base.AddPositionStage(a2, "Troll_Grabbing_A2_S3")

	Base.AddTag("Panicforever")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Doggystyle")
	Base.AddTag("Troll")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function VampireLordDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Vampire Lord) Doggystyle"
	Base.RaceType = "VampireLords"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "VampireLord_Doggystyle_A1_S1")
	Base.AddPositionStage(a1, "VampireLord_Doggystyle_A1_S2")
	Base.AddPositionStage(a1, "VampireLord_Doggystyle_A1_S3")
	Base.AddPositionStage(a1, "VampireLord_Doggystyle_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "VampireLord_Doggystyle_A2_S1", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "VampireLord_Doggystyle_A2_S2", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "VampireLord_Doggystyle_A2_S3", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "VampireLord_Doggystyle_A2_S4", 40.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Doggystyle")
	Base.AddTag("Vampire Lord")
	Base.AddTag("Anal")

	Base.Save(id)
endFunction

function VampireLordHolding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Vampire Lord) Holding"
	Base.RaceType = "VampireLords"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "VampireLord_Holding_A1_S1")
	Base.AddPositionStage(a1, "VampireLord_Holding_A1_S2")
	Base.AddPositionStage(a1, "VampireLord_Holding_A1_S3")
	Base.AddPositionStage(a1, "VampireLord_Holding_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "VampireLord_Holding_A2_S1", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "VampireLord_Holding_A2_S2", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "VampireLord_Holding_A2_S3", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "VampireLord_Holding_A2_S4", 40.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Holding")
	Base.AddTag("Vampire Lord")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function VampireLordMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Vampire Lord) Missionary"
	Base.RaceType = "VampireLords"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "VampireLord_Missionary_A1_S1")
	Base.AddPositionStage(a1, "VampireLord_Missionary_A1_S2")
	Base.AddPositionStage(a1, "VampireLord_Missionary_A1_S3")
	Base.AddPositionStage(a1, "VampireLord_Missionary_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "VampireLord_Missionary_A2_S1", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "VampireLord_Missionary_A2_S2", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "VampireLord_Missionary_A2_S3", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "VampireLord_Missionary_A2_S4", 40.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Missionary")
	Base.AddTag("Vampire Lord")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function WerewolfAggrDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Werewolf) Rough Doggystyle"
	Base.RaceType = "Werewolves"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Werewolf_AggrDoggystyle_A1_S1")
	Base.AddPositionStage(a1, "Werewolf_AggrDoggystyle_A1_S2")
	Base.AddPositionStage(a1, "Werewolf_AggrDoggystyle_A1_S3")
	Base.AddPositionStage(a1, "Werewolf_AggrDoggystyle_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Werewolf_AggrDoggystyle_A2_S1")
	Base.AddPositionStage(a2, "Werewolf_AggrDoggystyle_A2_S2")
	Base.AddPositionStage(a2, "Werewolf_AggrDoggystyle_A2_S3")
	Base.AddPositionStage(a2, "Werewolf_AggrDoggystyle_A2_S4")

	Base.AddTag("Panicforever")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Doggystyle")
	Base.AddTag("Rough")
	Base.AddTag("Werewolf")
	Base.AddTag("Anal")

	Base.Save(id)
endFunction

function WerewolfDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Werewolf) Doggystyle"
	Base.RaceType = "Werewolves"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Werewolf_Doggystyle_A1_S1")
	Base.AddPositionStage(a1, "Werewolf_Doggystyle_A1_S2")
	Base.AddPositionStage(a1, "Werewolf_Doggystyle_A1_S3")
	Base.AddPositionStage(a1, "Werewolf_Doggystyle_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Werewolf_Doggystyle_A2_S1", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Werewolf_Doggystyle_A2_S2", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Werewolf_Doggystyle_A2_S3", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Werewolf_Doggystyle_A2_S4", 40.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Doggystyle")
	Base.AddTag("Rough")
	Base.AddTag("Werewolf")
	Base.AddTag("Anal")

	Base.Save(id)
endFunction

function WerewolfHolding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Werewolf) Holding"
	Base.RaceType = "Werewolves"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Werewolf_Holding_A1_S1")
	Base.AddPositionStage(a1, "Werewolf_Holding_A1_S2")
	Base.AddPositionStage(a1, "Werewolf_Holding_A1_S3")
	Base.AddPositionStage(a1, "Werewolf_Holding_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Werewolf_Holding_A2_S1", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Werewolf_Holding_A2_S2", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Werewolf_Holding_A2_S3", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Werewolf_Holding_A2_S4", 40.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Holding")
	Base.AddTag("Rough")
	Base.AddTag("Werewolf")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function WerewolfMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Werewolf) Missionary"
	Base.RaceType = "Werewolves"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "Werewolf_Missionary_A1_S1")
	Base.AddPositionStage(a1, "Werewolf_Missionary_A1_S2")
	Base.AddPositionStage(a1, "Werewolf_Missionary_A1_S3")
	Base.AddPositionStage(a1, "Werewolf_Missionary_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Werewolf_Missionary_A2_S1", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Werewolf_Missionary_A2_S2", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Werewolf_Missionary_A2_S3", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Werewolf_Missionary_A2_S4", 40.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Missionary")
	Base.AddTag("Rough")
	Base.AddTag("Werewolf")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function WolfDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Wolf) Doggystyle"
	Base.RaceType = "Wolves"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Canine_Doggystyle_A1_S1")
	Base.AddPositionStage(a1, "Canine_Doggystyle_A1_S2")
	Base.AddPositionStage(a1, "Canine_Doggystyle_A1_S3")
	Base.AddPositionStage(a1, "Canine_Doggystyle_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Wolf_Doggystyle_A2_S1", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Wolf_Doggystyle_A2_S2", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Wolf_Doggystyle_A2_S3", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Wolf_Doggystyle_A2_S4", 45.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Doggystyle")
	Base.AddTag("Wolf")
	Base.AddTag("Anal")

	Base.Save(id)
endFunction

function WolfDoggystyle2(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Wolf) Dominate"
	Base.RaceType = "Wolves"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Canine_Doggystyle2_A1_S1")
	Base.AddPositionStage(a1, "Canine_Doggystyle2_A1_S2")
	Base.AddPositionStage(a1, "Canine_Doggystyle2_A1_S3")
	Base.AddPositionStage(a1, "Canine_Doggystyle2_A1_S4")
	Base.AddPositionStage(a1, "Canine_Doggystyle2_A1_S5")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Wolf_Doggystyle2_A2_S1")
	Base.AddPositionStage(a2, "Wolf_Doggystyle2_A2_S2")
	Base.AddPositionStage(a2, "Wolf_Doggystyle2_A2_S3")
	Base.AddPositionStage(a2, "Wolf_Doggystyle2_A2_S4")
	Base.AddPositionStage(a2, "Wolf_Doggystyle2_A2_S5")

	Base.AddTag("Panicforever")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Doggystyle")
	Base.AddTag("Wolf")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function WolfMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Wolf) Missionary"
	Base.RaceType = "Wolves"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "Canine_Missionary_A1_S1")
	Base.AddPositionStage(a1, "Canine_Missionary_A1_S2")
	Base.AddPositionStage(a1, "Canine_Missionary_A1_S3")
	Base.AddPositionStage(a1, "Canine_Missionary_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Wolf_Missionary_A2_S1", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Wolf_Missionary_A2_S2", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Wolf_Missionary_A2_S3", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Wolf_Missionary_A2_S4", 45.0, rotate=180.0)

	Base.AddTag("Gone")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Missionary")
	Base.AddTag("Wolf")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function GiantHarrassment(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Giant) Harrassment"
	Base.RaceType = "Giants"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Giant_Harrassment_A1_S1")
	Base.AddPositionStage(a1, "Giant_Harrassment_A1_S2")
	Base.AddPositionStage(a1, "Giant_Harrassment_A1_S3")
	Base.AddPositionStage(a1, "Giant_Harrassment_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Giant_Harrassment_A2_S1")
	Base.AddPositionStage(a2, "Giant_Harrassment_A2_S2")
	Base.AddPositionStage(a2, "Giant_Harrassment_A2_S3")
	Base.AddPositionStage(a2, "Giant_Harrassment_A2_S4")

	Base.AddTag("Panicforever")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Holding")
	Base.AddTag("Rough")
	Base.AddTag("Giant")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function GiantHolding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Giant) Holding"
	Base.RaceType = "Giants"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Giant_Holding_A1_S1")
	Base.AddPositionStage(a1, "Giant_Holding_A1_S2")
	Base.AddPositionStage(a1, "Giant_Holding_A1_S3")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Giant_Holding_A2_S1")
	Base.AddPositionStage(a2, "Giant_Holding_A2_S2")
	Base.AddPositionStage(a2, "Giant_Holding_A2_S3")

	Base.AddTag("Panicforever")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Dirty")
	Base.AddTag("Holding")
	Base.AddTag("Rough")
	Base.AddTag("Giant")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction


function HorseGroping(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Horse) Groping"
	Base.RaceType = "Horses"
	Base.SoundFX  = None

	int a1 = Base.AddPosition(Female, Oral)
	Base.AddPositionStage(a1, "Horse_Groping_A1_S1")
	Base.AddPositionStage(a1, "Horse_Groping_A1_S2")
	Base.AddPositionStage(a1, "Horse_Groping_A1_S3")
	Base.AddPositionStage(a1, "Horse_Groping_A1_S4")
	Base.AddPositionStage(a1, "Horse_Groping_A1_S5")
	Base.AddPositionStage(a1, "Horse_Groping_A1_S6")
	Base.AddPositionStage(a1, "Horse_Groping_A1_S7")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Horse_Groping_A2_S1")
	Base.AddPositionStage(a2, "Horse_Groping_A2_S2")
	Base.AddPositionStage(a2, "Horse_Groping_A2_S3")
	Base.AddPositionStage(a2, "Horse_Groping_A2_S4")
	Base.AddPositionStage(a2, "Horse_Groping_A2_S5")
	Base.AddPositionStage(a2, "Horse_Groping_A2_S6")
	Base.AddPositionStage(a2, "Horse_Groping_A2_S7")

	Base.AddTag("Panicforever")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Groping")
	Base.AddTag("Fondling")
	Base.AddTag("Horse")
	Base.AddTag("Oral")

	Base.Save(id)
endFunction

function HorsePanicDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Horse) Doggystyle Alt"
	Base.RaceType = "Horses"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Horse_PanicDoggystyle_A1_S1")
	Base.AddPositionStage(a1, "Horse_PanicDoggystyle_A1_S2")
	Base.AddPositionStage(a1, "Horse_PanicDoggystyle_A1_S3")
	Base.AddPositionStage(a1, "Horse_PanicDoggystyle_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Horse_PanicDoggystyle_A2_S1")
	Base.AddPositionStage(a2, "Horse_PanicDoggystyle_A2_S2")
	Base.AddPositionStage(a2, "Horse_PanicDoggystyle_A2_S3")
	Base.AddPositionStage(a2, "Horse_PanicDoggystyle_A2_S4")

	Base.AddTag("Panicforever")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Doggystyle")
	Base.AddTag("Horse")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function RieklingThreesome(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Riekling) Threesome"
	Base.RaceType = "Rieklings"
	Base.SoundFX  = SexMix

	int a1 = Base.AddPosition(Female, VaginalOralAnal)
	Base.AddPositionStage(a1, "Riekling_Threesome_A1_S1")
	Base.AddPositionStage(a1, "Riekling_Threesome_A1_S2", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Riekling_Threesome_A1_S3", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Riekling_Threesome_A1_S4", silent = true, openMouth = true)

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Riekling_Threesome_A2_S1")
	Base.AddPositionStage(a2, "Riekling_Threesome_A2_S2")
	Base.AddPositionStage(a2, "Riekling_Threesome_A2_S3")
	Base.AddPositionStage(a2, "Riekling_Threesome_A2_S4")

	int a3 = Base.AddPosition(Creature)
	Base.AddPositionStage(a3, "Riekling_Threesome_A3_S1")
	Base.AddPositionStage(a3, "Riekling_Threesome_A3_S2")
	Base.AddPositionStage(a3, "Riekling_Threesome_A3_S3")
	Base.AddPositionStage(a3, "Riekling_Threesome_A3_S4")

	Base.AddTag("Panicforever")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Gangbang")
	Base.AddTag("Riekling")
	Base.AddTag("Dirty")
	Base.AddTag("Vaginal")
	Base.AddTag("Oral")

	Base.Save(id)
endFunction


function RieklingMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Riekling) Missionary"
	Base.RaceType = "Rieklings"
	Base.SoundFX  = Squishing

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Riekling_Missionary_A1_S1")
	Base.AddPositionStage(a1, "Riekling_Missionary_A1_S2")
	Base.AddPositionStage(a1, "Riekling_Missionary_A1_S3")
	Base.AddPositionStage(a1, "Riekling_Missionary_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Riekling_Threeway_A2_S1")
	Base.AddPositionStage(a2, "Riekling_Threeway_A2_S2")
	Base.AddPositionStage(a2, "Riekling_Threeway_A2_S3")
	Base.AddPositionStage(a2, "Riekling_Threeway_A2_S4")

	Base.AddTag("Panicforever")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Riekling")
	Base.AddTag("Dirty")
	Base.AddTag("Vaginal")

	Base.Save(id)
endFunction

function RieklingThreeWay(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Riekling) Three-Way"
	Base.RaceType = "Rieklings"
	Base.SoundFX  = SexMix

	int a1 = Base.AddPosition(Female, VaginalOralAnal)
	Base.AddPositionStage(a1, "Riekling_ThreeWay_A1_S1")
	Base.AddPositionStage(a1, "Riekling_ThreeWay_A1_S2")
	Base.AddPositionStage(a1, "Riekling_ThreeWay_A1_S3")
	Base.AddPositionStage(a1, "Riekling_ThreeWay_A1_S4")

	int a2 = Base.AddPosition(Creature)
	Base.AddPositionStage(a2, "Riekling_ThreeWay_A2_S1")
	Base.AddPositionStage(a2, "Riekling_ThreeWay_A2_S2")
	Base.AddPositionStage(a2, "Riekling_ThreeWay_A2_S3")
	Base.AddPositionStage(a2, "Riekling_ThreeWay_A2_S4")

	int a3 = Base.AddPosition(Creature)
	Base.AddPositionStage(a3, "Riekling_ThreeWay_A3_S1")
	Base.AddPositionStage(a3, "Riekling_ThreeWay_A3_S2")
	Base.AddPositionStage(a3, "Riekling_ThreeWay_A3_S3")
	Base.AddPositionStage(a3, "Riekling_ThreeWay_A3_S4")

	Base.AddTag("Panicforever")
	Base.AddTag("Creature")
	Base.AddTag("Bestiality")
	Base.AddTag("Gangbang")
	Base.AddTag("3P")
	Base.AddTag("Riekling")
	Base.AddTag("Dirty")
	Base.AddTag("Vaginal")
	Base.AddTag("Oral")

	Base.Save(id)
endFunction
