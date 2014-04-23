scriptname sslCreatureAnimationDefaults extends sslAnimationFactory

function LoadCreatureAnimations()
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
	; Giant
	RegisterAnimation("GiantPenetration")
	; Horse
	RegisterAnimation("HorseDoggystyle")
	; SabreCat
	RegisterAnimation("CatDoggystyle")
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
	; Dawguard Gargoyle & Vampire Lord
	RegisterAnimation("GargoyleDoggystyle")
	RegisterAnimation("GargoyleHolding")
	RegisterAnimation("GargoyleMissionary")
	RegisterAnimation("VampireLordDoggystyle")
	RegisterAnimation("VampireLordHolding")
	RegisterAnimation("VampireLordMissionary")
	; Dragonborn Daedra Seeker
	RegisterAnimation("DaedraHugging")
endFunction

function BearDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Bear) Doggystyle"

	Base.SoundFX = Squishing
	Base.AddRaceID("BearBlackRace")
	Base.AddRaceID("BearBrownRace")
	Base.AddRaceID("BearSnowRace")

	int a1 = Base.AddPosition(Female, addCum=Anal)
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

	Base.Save(id)
endFunction

function ChaurusForward(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Chaurus) Forward"

	Base.SoundFX = Squishing
	Base.AddRaceID("ChaurusRace")
	Base.AddRaceID("ChaurusReaperRace")

	int a1 = Base.AddPosition(Female, addCum=Anal)
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

	Base.Save(id)
endFunction

function ChaurusReverse(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Chaurus) Reverse"

	Base.SoundFX = Squishing
	Base.AddRaceID("ChaurusRace")
	Base.AddRaceID("ChaurusReaperRace")

	int a1 = Base.AddPosition(Female, addCum=Vaginal)
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

	Base.Save(id)
endFunction

function DaedraHugging(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Seeker) Hugging"

	Base.SoundFX = Squishing
	Base.AddRaceID("DLC2SeekerRace")

	int a1 = Base.AddPosition(Female, addCum=Vaginal)
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

	Base.Save(id)
endFunction

function CanineDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Dog) Doggystyle"

	Base.SoundFX = Squishing

	Base.AddRaceID("DogRace")
	Base.AddRaceID("DogCompanionRace")
	Base.AddRaceID("MG07DogRace")
	Base.AddRaceID("DA03BarbasDogRace")
	Base.AddRaceID("DLC1HuskyArmoredCompanionRace")
	Base.AddRaceID("DLC1DeathHoundCompanionRace")
	Base.AddRaceID("DLC1DeathHoundRace")

	int a1 = Base.AddPosition(Female, addCum=Anal)
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

	Base.Save(id)
endFunction

function CanineDoggystyle2(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Dog) Doggystyle 2"

	Base.SoundFX = Squishing

	Base.AddRaceID("DogRace")
	Base.AddRaceID("DogCompanionRace")
	Base.AddRaceID("MG07DogRace")
	Base.AddRaceID("DA03BarbasDogRace")
	Base.AddRaceID("DLC1HuskyArmoredCompanionRace")
	Base.AddRaceID("DLC1DeathHoundCompanionRace")
	Base.AddRaceID("DLC1DeathHoundRace")

	int a1 = Base.AddPosition(Female, addCum=Anal)
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

	Base.Save(id)
endFunction

function CanineMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Dog) Missionary"

	Base.SoundFX = Squishing
	Base.AddRaceID("DogRace")
	Base.AddRaceID("DogCompanionRace")
	Base.AddRaceID("MG07DogRace")
	Base.AddRaceID("DA03BarbasDogRace")
	Base.AddRaceID("DLC1HuskyArmoredCompanionRace")
	Base.AddRaceID("DLC1DeathHoundCompanionRace")
	Base.AddRaceID("DLC1DeathHoundRace")

	int a1 = Base.AddPosition(Female, addCum=Vaginal)
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

	Base.Save(id)
endFunction


function DragonPenetration(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Dragon) Penetration"

	Base.SoundFX = Squishing
	Base.AddRaceID("DragonRace")
	Base.AddRaceID("UndeadDragonRace")

	int a1 = Base.AddPosition(Female, addCum=VaginalAnal)
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

	Base.Save(id)
endFunction

function DragonTongue(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Dragon) Tongue"

	Base.SoundFX = Squishing
	Base.AddRaceID("DragonRace")
	Base.AddRaceID("UndeadDragonRace")

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

	Base.Save(id)
endFunction

function DraugrDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Draugr) Doggystyle"

	Base.SoundFX = Squishing
	Base.AddRaceID("DraugrRace")
	Base.AddRaceID("DraugrMagicRace")
	Base.AddRaceID("SkeletonArmorRace")
	Base.AddRaceID("DLC1SoulCairnKeeperRace")
	Base.AddRaceID("DLC1SoulCairnSkeletonArmorRace")
	Base.AddRaceID("DLC2AshSpawnRace")

	int a1 = Base.AddPosition(Female, addCum=Anal)
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

	Base.Save(id)
endFunction

function DraugrGangbang3P(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Draugr) Gangbang 3P"

	Base.SoundFX = SexMix
	Base.AddRaceID("DraugrRace")
	Base.AddRaceID("DraugrMagicRace")
	Base.AddRaceID("SkeletonArmorRace")
	Base.AddRaceID("DLC1SoulCairnKeeperRace")
	Base.AddRaceID("DLC1SoulCairnSkeletonArmorRace")
	Base.AddRaceID("DLC2AshSpawnRace")

	int a1 = Base.AddPosition(Female, addCum=VaginalOralAnal)
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

	Base.Save(id)
endFunction

function DraugrGangbang4P(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Draugr) Gangbang 4P"

	Base.SoundFX = SexMix
	Base.AddRaceID("DraugrRace")
	Base.AddRaceID("DraugrMagicRace")
	Base.AddRaceID("SkeletonArmorRace")
	Base.AddRaceID("DLC1SoulCairnKeeperRace")
	Base.AddRaceID("DLC1SoulCairnSkeletonArmorRace")
	Base.AddRaceID("DLC2AshSpawnRace")

	int a1 = Base.AddPosition(Female, addCum=VaginalOralAnal)
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

	Base.Save(id)
endFunction

function DraugrGangbang5P(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Draugr) Gangbang 5P"

	Base.SoundFX = SexMix
	Base.AddRaceID("DraugrRace")
	Base.AddRaceID("DraugrMagicRace")
	Base.AddRaceID("SkeletonArmorRace")
	Base.AddRaceID("DLC1SoulCairnKeeperRace")
	Base.AddRaceID("DLC1SoulCairnSkeletonArmorRace")
	Base.AddRaceID("DLC2AshSpawnRace")

	int a1 = Base.AddPosition(Female, addCum=VaginalOralAnal)
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

	Base.Save(id)
endFunction

function DraugrHolding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Draugr) Holding"

	Base.SoundFX = Squishing
	Base.AddRaceID("DraugrRace")
	Base.AddRaceID("DraugrMagicRace")
	Base.AddRaceID("SkeletonArmorRace")
	Base.AddRaceID("DLC1SoulCairnKeeperRace")
	Base.AddRaceID("DLC1SoulCairnSkeletonArmorRace")
	Base.AddRaceID("DLC2AshSpawnRace")

	int a1 = Base.AddPosition(Female, addCum=Anal)
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

	Base.Save(id)
endFunction

function DraugrMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Draugr) Missionary"

	Base.SoundFX = Squishing
	Base.AddRaceID("DraugrRace")
	Base.AddRaceID("DraugrMagicRace")
	Base.AddRaceID("SkeletonArmorRace")
	Base.AddRaceID("DLC1SoulCairnKeeperRace")
	Base.AddRaceID("DLC1SoulCairnSkeletonArmorRace")
	Base.AddRaceID("DLC2AshSpawnRace")

	int a1 = Base.AddPosition(Female, addCum=Vaginal)
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

	Base.Save(id)
endFunction

function FalmerDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Falmer) Doggystyle"

	Base.SoundFX = Squishing
	Base.AddRaceID("FalmerRace")

	int a1 = Base.AddPosition(Female, addCum=Anal)
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

	Base.Save(id)
endFunction

function FalmerGangbang3P(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Falmer) Gangbang 3P"

	Base.SoundFX = SexMix
	Base.AddRaceID("FalmerRace")

	int a1 = Base.AddPosition(Female, addCum=VaginalOralAnal)
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

	Base.Save(id)
endFunction

function FalmerGangbang4P(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Falmer) Gangbang 4P"

	Base.SoundFX = SexMix
	Base.AddRaceID("FalmerRace")

	int a1 = Base.AddPosition(Female, addCum=VaginalOralAnal)
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

	Base.Save(id)
endFunction

function FalmerGangbang5P(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Falmer) Gangbang 5P"

	Base.SoundFX = SexMix
	Base.AddRaceID("FalmerRace")

	int a1 = Base.AddPosition(Female, addCum=VaginalOralAnal)
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

	Base.Save(id)
endFunction

function FalmerHolding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Falmer) Holding"

	Base.SoundFX = Squishing
	Base.AddRaceID("FalmerRace")

	int a1 = Base.AddPosition(Female, addCum=VaginalAnal)
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

	Base.Save(id)
endFunction

function FalmerMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Falmer) Missionary"

	Base.SoundFX = Squishing
	Base.AddRaceID("FalmerRace")

	int a1 = Base.AddPosition(Female, addCum=Vaginal)
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
	Base.AddTag("Gangbang")

	Base.Save(id)
endFunction

function GargoyleDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Gargoyle) Doggystyle"

	Base.SoundFX = Squishing
	Base.AddRaceID("DLC1GargoyleRace")
	Base.AddRaceID("DLC1GargoyleVariantBossRace")
	Base.AddRaceID("DLC1GargoyleVariantGreenRace")

	int a1 = Base.AddPosition(Female, addCum=Anal)
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

	Base.Save(id)
endFunction

function GargoyleHolding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Gargoyle) Holding"

	Base.SoundFX = Squishing
	Base.AddRaceID("DLC1GargoyleRace")
	Base.AddRaceID("DLC1GargoyleVariantBossRace")
	Base.AddRaceID("DLC1GargoyleVariantGreenRace")

	int a1 = Base.AddPosition(Female, addCum=VaginalAnal)
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

	Base.Save(id)
endFunction

function GargoyleMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Gargoyle) Missionary"

	Base.SoundFX = Squishing
	Base.AddRaceID("DLC1GargoyleRace")
	Base.AddRaceID("DLC1GargoyleVariantBossRace")
	Base.AddRaceID("DLC1GargoyleVariantGreenRace")

	int a1 = Base.AddPosition(Female, addCum=Vaginal)
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

	Base.Save(id)
endFunction

function GiantPenetration(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Giant) Penetration"

	Base.SoundFX = Squishing
	Base.AddRaceID("GiantRace")

	int a1 = Base.AddPosition(Female, addCum=VaginalAnal)
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

	Base.Save(id)
endFunction

function HorseDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Horse) Doggystyle"

	Base.SoundFX = Squishing
	Base.AddRaceID("HorseRace")

	int a1 = Base.AddPosition(Female, addCum=Anal)
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

	Base.Save(id)
endFunction

function CatDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Sabre Cat) Doggystyle"

	Base.SoundFX = Squishing
	Base.AddRaceID("SabreCatRace")
	Base.AddRaceID("SabreCatSnowyRace")

	int a1 = Base.AddPosition(Female, addCum=Anal)
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

	Base.Save(id)
endFunction

function SpiderDouble(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Spider) Double"

	Base.SoundFX = Squishing
	Base.AddRaceID("FrostbiteSpiderRace")

	int a1 = Base.AddPosition(Female, addCum=VaginalOralAnal)
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

	Base.Save(id)
endFunction

function SpiderPenetration(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Spider) Penetration"

	Base.SoundFX = Squishing
	Base.AddRaceID("FrostbiteSpiderRace")

	int a1 = Base.AddPosition(Female, addCum=VaginalAnal)
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

	Base.Save(id)
endFunction

function BigSpiderPenetration(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Large Spider) Penetration"

	Base.SoundFX = Squishing
	Base.AddRaceID("FrostbiteSpiderRaceLarge")
	Base.AddRaceID("FrostbiteSpiderRaceGiant")

	int a1 = Base.AddPosition(Female, addCum=VaginalAnal)
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

	Base.Save(id)
endFunction


function TrollDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Troll) Doggystyle"

	Base.SoundFX = Squishing
	Base.AddRaceID("TrollRace")
	Base.AddRaceID("TrollFrostRace")

	int a1 = Base.AddPosition(Female, addCum=Anal)
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

	Base.Save(id)
endFunction

function TrollHolding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Troll) Holding"

	Base.SoundFX = Squishing
	Base.AddRaceID("TrollRace")
	Base.AddRaceID("TrollFrostRace")

	int a1 = Base.AddPosition(Female, addCum=VaginalAnal)
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

	Base.Save(id)
endFunction

function TrollMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Troll) Missionary"

	Base.SoundFX = Squishing
	Base.AddRaceID("TrollRace")
	Base.AddRaceID("TrollFrostRace")

	int a1 = Base.AddPosition(Female, addCum=Vaginal)
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

	Base.Save(id)
endFunction

function TrollDominate(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Troll) Dominate"

	Base.SoundFX = Squishing
	Base.AddRaceID("TrollRace")
	Base.AddRaceID("TrollFrostRace")

	int a1 = Base.AddPosition(Female, addCum=Vaginal)
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

	Base.Save(id)
endFunction

function TrollGrabbing(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Troll) Grabbing"

	Base.SoundFX = Squishing
	Base.AddRaceID("TrollRace")
	Base.AddRaceID("TrollFrostRace")

	int a1 = Base.AddPosition(Female, addCum=VaginalAnal)
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

	Base.Save(id)
endFunction

function VampireLordDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Vampire Lord) Doggystyle"

	Base.SoundFX = Squishing
	Base.AddRaceID("DLC1VampireBeastRace")

	int a1 = Base.AddPosition(Female, addCum=Anal)
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

	Base.Save(id)
endFunction

function VampireLordHolding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Vampire Lord) Holding"

	Base.SoundFX = Squishing
	Base.AddRaceID("DLC1VampireBeastRace")

	int a1 = Base.AddPosition(Female, addCum=VaginalAnal)
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

	Base.Save(id)
endFunction

function VampireLordMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Vampire Lord) Missionary"

	Base.SoundFX = Squishing
	Base.AddRaceID("DLC1VampireBeastRace")

	int a1 = Base.AddPosition(Female, addCum=Vaginal)
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

	Base.Save(id)
endFunction

function WerewolfAggrDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Werewolf) Rough Doggystyle"

	Base.SoundFX = Squishing
	Base.AddRaceID("WerewolfBeastRace")

	int a1 = Base.AddPosition(Female, addCum=Anal)
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

	Base.Save(id)
endFunction

function WerewolfDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Werewolf) Doggystyle"

	Base.SoundFX = Squishing
	Base.AddRaceID("WerewolfBeastRace")

	int a1 = Base.AddPosition(Female, addCum=Anal)
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

	Base.Save(id)
endFunction

function WerewolfHolding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Werewolf) Holding"

	Base.SoundFX = Squishing
	Base.AddRaceID("WerewolfBeastRace")

	int a1 = Base.AddPosition(Female, addCum=VaginalAnal)
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

	Base.Save(id)
endFunction

function WerewolfMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Werewolf) Missionary"

	Base.SoundFX = Squishing
	Base.AddRaceID("WerewolfBeastRace")

	int a1 = Base.AddPosition(Female, addCum=Vaginal)
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

	Base.Save(id)
endFunction

function WolfDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Wolf) Doggystyle"

	Base.SoundFX = Squishing
	Base.AddRaceID("WolfRace")

	int a1 = Base.AddPosition(Female, addCum=Anal)
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

	Base.Save(id)
endFunction

function WolfDoggystyle2(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Wolf) Doggystyle 2"

	Base.SoundFX = Squishing
	Base.AddRaceID("WolfRace")

	int a1 = Base.AddPosition(Female, addCum=Anal)
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

	Base.Save(id)
endFunction

function WolfMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Wolf) Missionary"

	Base.SoundFX = Squishing
	Base.AddRaceID("WolfRace")

	int a1 = Base.AddPosition(Female, addCum=Vaginal)
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

	Base.Save(id)
endFunction
