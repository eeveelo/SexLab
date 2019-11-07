scriptname sslCreatureAnimationDefaults extends sslAnimationFactory

function LoadCreatureAnimations()
	; Prepare factory resources (as creature)
	PrepareFactoryCreatures()
	
	; Bear
	RegisterAnimation("BearDoggystyle")
	RegisterCategory("Bear")

	; Dog
	RegisterAnimation("CanineDoggystyle")
	RegisterAnimation("CanineDoggystyle2")
	RegisterAnimation("CanineMissionary")
	RegisterCategory("Dog")
	
	; Chaurus
	RegisterAnimation("ChaurusForward")
	RegisterAnimation("ChaurusReverse")
	RegisterCategory("Chaurus")
	
	; Dragon
	RegisterAnimation("DragonPenetration")
	RegisterAnimation("DragonTongue")
	RegisterCategory("Dragon")
	
	; Draugr
	RegisterAnimation("DraugrDoggystyle")
	RegisterAnimation("DraugrHolding")
	RegisterAnimation("DraugrMissionary")
	RegisterAnimation("DraugrGangbang3P")
	RegisterAnimation("DraugrGangbang4P")
	RegisterAnimation("DraugrGangbang5P")
	RegisterCategory("Draugr")
	
	; Falmer
	RegisterAnimation("FalmerDoggystyle")
	RegisterAnimation("FalmerHolding")
	RegisterAnimation("FalmerMissionary")
	RegisterAnimation("FalmerGangbang3P")
	RegisterAnimation("FalmerGangbang4P")
	RegisterAnimation("FalmerGangbang5P")
	RegisterCategory("Falmer")
	
	; Dawguard Gargoyle
	RegisterAnimation("GargoyleDoggystyle")
	RegisterAnimation("GargoyleHolding")
	RegisterAnimation("GargoyleMissionary")
	RegisterCategory("Gargoyle")
	
	; Giant
	RegisterAnimation("GiantPenetration")
	RegisterAnimation("GiantHarrassment")
	RegisterAnimation("GiantHolding")
	RegisterCategory("Giant")
	
	; Horse
	RegisterAnimation("HorseDoggystyle")
	RegisterAnimation("HorsePanicDoggystyle")
	RegisterAnimation("HorseGroping")
	RegisterCategory("Horse")
	
	; Riekling
	RegisterAnimation("RieklingMissionary")
	RegisterAnimation("RieklingThreeWay")
	RegisterCategory("Riekling")
	
	; SabreCat
	RegisterAnimation("CatDoggystyle")
	RegisterCategory("SabreCat")
	
	; Dragonborn Daedra Seeker
	RegisterAnimation("DaedraHugging")
	RegisterCategory("Seeker")
	
	; Spider
	RegisterAnimation("SpiderDouble")
	RegisterAnimation("SpiderPenetration")
	RegisterAnimation("BigSpiderPenetration")
	RegisterCategory("Spider")
	
	; Troll
	RegisterAnimation("TrollDoggystyle")
	RegisterAnimation("TrollHolding")
	RegisterAnimation("TrollMissionary")
	RegisterAnimation("TrollDominate")
	RegisterAnimation("TrollGrabbing")
	RegisterCategory("Troll")
	
	; Werewolf
	RegisterAnimation("WerewolfAggrDoggystyle")
	RegisterAnimation("WerewolfDoggystyle")
	RegisterAnimation("WerewolfHolding")
	RegisterAnimation("WerewolfMissionary")
	; RegisterAnimation("WerewolfMissionaryFemale")
	RegisterCategory("Werewolf")
	
	; Wolf
	RegisterAnimation("WolfDoggystyle")
	RegisterAnimation("WolfDoggystyle2")
	RegisterAnimation("WolfMissionary")
	RegisterCategory("Wolf")
	
	; Dawnguard Vampire Lord
	RegisterAnimation("VampireLordDoggystyle")
	RegisterAnimation("VampireLordHolding")
	RegisterAnimation("VampireLordMissionary")
	RegisterCategory("VampireLord")

	; Register any remaining custom categories from json loaders
	RegisterOtherCategories()
endFunction

function BearDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Bear) Doggystyle"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Bears"

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Bear_Doggystyle_A1_S1")
	Base.AddPositionStage(a1, "Bear_Doggystyle_A1_S2")
	Base.AddPositionStage(a1, "Bear_Doggystyle_A1_S3")
	Base.AddPositionStage(a1, "Bear_Doggystyle_A1_S4")

	int a2 = Base.AddCreaturePosition("Bears", Creature)
	Base.AddPositionStage(a2, "Bear_Doggystyle_A2_S1", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Bear_Doggystyle_A2_S2", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Bear_Doggystyle_A2_S3", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Bear_Doggystyle_A2_S4", 45.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Doggystyle,Bear,Vaginal")

	Base.Save(id)
endFunction

function ChaurusForward(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Chaurus) Forward"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Chaurus"

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Chaurus_Forward_A1_S1")
	Base.AddPositionStage(a1, "Chaurus_Forward_A1_S2")
	Base.AddPositionStage(a1, "Chaurus_Forward_A1_S3")
	Base.AddPositionStage(a1, "Chaurus_Forward_A1_S4")

	int a2 = Base.AddCreaturePosition("Chaurus", Creature)
	Base.AddPositionStage(a2, "Chaurus_Forward_A2_S1", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Chaurus_Forward_A2_S2", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Chaurus_Forward_A2_S3", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Chaurus_Forward_A2_S4", 40.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Holding,Chaurus,Vaginal")

	Base.Save(id)
endFunction

function ChaurusReverse(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Chaurus) Reverse"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Chaurus"

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "Chaurus_Reverse_A1_S1")
	Base.AddPositionStage(a1, "Chaurus_Reverse_A1_S2")
	Base.AddPositionStage(a1, "Chaurus_Reverse_A1_S3")
	Base.AddPositionStage(a1, "Chaurus_Reverse_A1_S4")

	int a2 = Base.AddCreaturePosition("Chaurus", Creature)
	Base.AddPositionStage(a2, "Chaurus_Reverse_A2_S1", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Chaurus_Reverse_A2_S2", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Chaurus_Reverse_A2_S3", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Chaurus_Reverse_A2_S4", 40.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Holding,Chaurus,Anal")

	Base.Save(id)
endFunction

function DaedraHugging(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Seeker) Hugging"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Seekers"

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "Daedra_Hugging_A1_S1")
	Base.AddPositionStage(a1, "Daedra_Hugging_A1_S2")
	Base.AddPositionStage(a1, "Daedra_Hugging_A1_S3")
	Base.AddPositionStage(a1, "Daedra_Hugging_A1_S4")

	int a2 = Base.AddCreaturePosition("Seekers", Creature)
	Base.AddPositionStage(a2, "Daedra_Hugging_A2_S1", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Daedra_Hugging_A2_S2", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Daedra_Hugging_A2_S3", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Daedra_Hugging_A2_S4", 40.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Holding,Hugging,Daedra,Seeking,Vaginal,Anal")

	Base.Save(id)
endFunction

function CanineDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Dog) Doggystyle"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Dogs"

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Canine_Doggystyle_A1_S1")
	Base.AddPositionStage(a1, "Canine_Doggystyle_A1_S2")
	Base.AddPositionStage(a1, "Canine_Doggystyle_A1_S3")
	Base.AddPositionStage(a1, "Canine_Doggystyle_A1_S4")

	int a2 = Base.AddCreaturePosition("Dogs", Creature)
	Base.AddPositionStage(a2, "Dog_Doggystyle_A2_S1", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Dog_Doggystyle_A2_S2", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Dog_Doggystyle_A2_S3", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Dog_Doggystyle_A2_S4", 45.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Doggystyle,Canine,Dog,Vaginal")

	Base.Save(id)
endFunction

function CanineDoggystyle2(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Dog) Dominate"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Dogs"

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Canine_Doggystyle2_A1_S1")
	Base.AddPositionStage(a1, "Canine_Doggystyle2_A1_S2")
	Base.AddPositionStage(a1, "Canine_Doggystyle2_A1_S3")
	Base.AddPositionStage(a1, "Canine_Doggystyle2_A1_S4")
	Base.AddPositionStage(a1, "Canine_Doggystyle2_A1_S5")

	int a2 = Base.AddCreaturePosition("Dogs", Creature)
	Base.AddPositionStage(a2, "Dog_Doggystyle2_A2_S1")
	Base.AddPositionStage(a2, "Dog_Doggystyle2_A2_S2")
	Base.AddPositionStage(a2, "Dog_Doggystyle2_A2_S3")
	Base.AddPositionStage(a2, "Dog_Doggystyle2_A2_S4")
	Base.AddPositionStage(a2, "Dog_Doggystyle2_A2_S5")

	Base.SetTags("Panicforever,Creature,Bestiality,Dirty,Doggystyle,Canine,Dog,Anal")

	Base.Save(id)
endFunction

function CanineMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Dog) Missionary"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Dogs"

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "Canine_Missionary_A1_S1")
	Base.AddPositionStage(a1, "Canine_Missionary_A1_S2")
	Base.AddPositionStage(a1, "Canine_Missionary_A1_S3")
	Base.AddPositionStage(a1, "Canine_Missionary_A1_S4")

	int a2 = Base.AddCreaturePosition("Dogs", Creature)
	Base.AddPositionStage(a2, "Dog_Missionary_A2_S1", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Dog_Missionary_A2_S2", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Dog_Missionary_A2_S3", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Dog_Missionary_A2_S4", 45.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Missionary,Canine,Dog,Vaginal")

	Base.Save(id)
endFunction


function DragonPenetration(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Dragon) Penetration"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Dragons"

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Dragon_Penetration_A1_S1")
	Base.AddPositionStage(a1, "Dragon_Penetration_A1_S2")
	Base.AddPositionStage(a1, "Dragon_Penetration_A1_S3")
	Base.AddPositionStage(a1, "Dragon_Penetration_A1_S4")

	int a2 = Base.AddCreaturePosition("Dragons", Creature)
	Base.AddPositionStage(a2, "Dragon_Penetration_A2_S1", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Dragon_Penetration_A2_S2", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Dragon_Penetration_A2_S3", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Dragon_Penetration_A2_S4", 35.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Missionary,Dragon,Vaginal")

	Base.Save(id)
endFunction

function DragonTongue(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Dragon) Tongue"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Dragons"

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "Dragon_Tongue_A1_S1")
	Base.AddPositionStage(a1, "Dragon_Tongue_A1_S2")
	Base.AddPositionStage(a1, "Dragon_Tongue_A1_S3")
	Base.AddPositionStage(a1, "Dragon_Tongue_A1_S4")

	int a2 = Base.AddCreaturePosition("Dragons", Creature)
	Base.AddPositionStage(a2, "Dragon_Tongue_A2_S1", 32.0)
	Base.AddPositionStage(a2, "Dragon_Tongue_A2_S2", 32.0)
	Base.AddPositionStage(a2, "Dragon_Tongue_A2_S3", 32.0)
	Base.AddPositionStage(a2, "Dragon_Tongue_A2_S4", 32.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Oral,Dragon,Oral")

	Base.Save(id)
endFunction

function DraugrDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Draugr) Doggystyle"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Draugrs"
	Base.GenderedCreatures = true

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Draugr_Doggystyle_A1_S1")
	Base.AddPositionStage(a1, "Draugr_Doggystyle_A1_S2")
	Base.AddPositionStage(a1, "Draugr_Doggystyle_A1_S3")
	Base.AddPositionStage(a1, "Draugr_Doggystyle_A1_S4")

	int a2 = Base.AddCreaturePosition("Draugrs", CreatureMale)
	Base.AddPositionStage(a2, "Draugr_Doggystyle_A2_S1", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Doggystyle_A2_S2", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Doggystyle_A2_S3", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Doggystyle_A2_S4", 35.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Doggystyle,Draugr,Vaginal")

	Base.Save(id)
endFunction

function DraugrGangbang3P(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Draugr) Gangbang 3P"
	Base.SoundFX  = SexMix
	; Base.RaceType = "Draugrs"
	Base.GenderedCreatures = true

	int a1 = Base.AddPosition(Female, VaginalOralAnal)
	Base.AddPositionStage(a1, "Draugr_Gangbang_A1_S1", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Draugr_Gangbang_A1_S2", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Draugr_Gangbang_A1_S3", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Draugr_Gangbang_A1_S4", silent = true, openMouth = true)

	int a2 = Base.AddCreaturePosition("Draugrs", CreatureMale)
	Base.AddPositionStage(a2, "Draugr_Gangbang_A2_S1", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Gangbang_A2_S2", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Gangbang_A2_S3", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Gangbang_A2_S4", 30.0, rotate=180.0)

	int a3 = Base.AddCreaturePosition("Draugrs", CreatureMale)
	Base.AddPositionStage(a3, "Draugr_Gangbang_A3_S1", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Draugr_Gangbang_A3_S2", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Draugr_Gangbang_A3_S3", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Draugr_Gangbang_A3_S4", 31.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Gangbang,Draugr,Vaginal,Oral")

	Base.Save(id)
endFunction

function DraugrGangbang4P(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Draugr) Gangbang 4P"
	Base.SoundFX  = SexMix
	; Base.RaceType = "Draugrs"
	Base.GenderedCreatures = true

	int a1 = Base.AddPosition(Female, VaginalOralAnal)
	Base.AddPositionStage(a1, "Draugr_Gangbang_A1_S1", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Draugr_Gangbang_A1_S2", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Draugr_Gangbang_A1_S3", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Draugr_Gangbang_A1_S4", silent = true, openMouth = true)

	int a2 = Base.AddCreaturePosition("Draugrs", CreatureMale)
	Base.AddPositionStage(a2, "Draugr_Gangbang_A2_S1", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Gangbang_A2_S2", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Gangbang_A2_S3", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Gangbang_A2_S4", 30.0, rotate=180.0)

	int a3 = Base.AddCreaturePosition("Draugrs", CreatureMale)
	Base.AddPositionStage(a3, "Draugr_Gangbang_A3_S1", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Draugr_Gangbang_A3_S2", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Draugr_Gangbang_A3_S3", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Draugr_Gangbang_A3_S4", 31.0, rotate=180.0)

	int a4 = Base.AddCreaturePosition("Draugrs", CreatureMale)
	Base.AddPositionStage(a4, "Draugr_Gangbang_A4_S1", 32.0, rotate=180.0)
	Base.AddPositionStage(a4, "Draugr_Gangbang_A4_S2", 32.0, rotate=180.0)
	Base.AddPositionStage(a4, "Draugr_Gangbang_A4_S3", 32.0, rotate=180.0)
	Base.AddPositionStage(a4, "Draugr_Gangbang_A4_S4", 32.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Gangbang,Draugr,Vaginal,Oral,Anal")

	Base.Save(id)
endFunction

function DraugrGangbang5P(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Draugr) Gangbang 5P"
	Base.SoundFX  = SexMix
	; Base.RaceType = "Draugrs"
	Base.GenderedCreatures = true

	int a1 = Base.AddPosition(Female, VaginalOralAnal)
	Base.AddPositionStage(a1, "Draugr_Gangbang_A1_S1", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Draugr_Gangbang_A1_S2", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Draugr_Gangbang_A1_S3", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Draugr_Gangbang_A1_S4", silent = true, openMouth = true)

	int a2 = Base.AddCreaturePosition("Draugrs", CreatureMale)
	Base.AddPositionStage(a2, "Draugr_Gangbang_A2_S1", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Gangbang_A2_S2", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Gangbang_A2_S3", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Gangbang_A2_S4", 30.0, rotate=180.0)

	int a3 = Base.AddCreaturePosition("Draugrs", CreatureMale)
	Base.AddPositionStage(a3, "Draugr_Gangbang_A3_S1", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Draugr_Gangbang_A3_S2", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Draugr_Gangbang_A3_S3", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Draugr_Gangbang_A3_S4", 31.0, rotate=180.0)

	int a4 = Base.AddCreaturePosition("Draugrs", CreatureMale)
	Base.AddPositionStage(a4, "Draugr_Gangbang_A4_S1", 32.0, rotate=180.0)
	Base.AddPositionStage(a4, "Draugr_Gangbang_A4_S2", 32.0, rotate=180.0)
	Base.AddPositionStage(a4, "Draugr_Gangbang_A4_S3", 32.0, rotate=180.0)
	Base.AddPositionStage(a4, "Draugr_Gangbang_A4_S4", 32.0, rotate=180.0)

	int a5 = Base.AddCreaturePosition("Draugrs", CreatureMale)
	Base.AddPositionStage(a4, "Draugr_Gangbang_A5_S1", 33.0, rotate=180.0)
	Base.AddPositionStage(a4, "Draugr_Gangbang_A5_S2", 33.0, rotate=180.0)
	Base.AddPositionStage(a4, "Draugr_Gangbang_A5_S3", 33.0, rotate=180.0)
	Base.AddPositionStage(a4, "Draugr_Gangbang_A5_S4", 33.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Gangbang,Draugr,Vaginal,Oral,Anal")

	Base.Save(id)
endFunction

function DraugrHolding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Draugr) Holding"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Draugrs"
	Base.GenderedCreatures = true

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Draugr_Holding_A1_S1")
	Base.AddPositionStage(a1, "Draugr_Holding_A1_S2")
	Base.AddPositionStage(a1, "Draugr_Holding_A1_S3")
	Base.AddPositionStage(a1, "Draugr_Holding_A1_S4")

	int a2 = Base.AddCreaturePosition("Draugrs", CreatureMale)
	Base.AddPositionStage(a2, "Draugr_Holding_A2_S1", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Holding_A2_S2", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Holding_A2_S3", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Holding_A2_S4", 35.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Holding,Draugr,Vaginal")

	Base.Save(id)
endFunction

function DraugrMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Draugr) Missionary"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Draugrs"
	Base.GenderedCreatures = true

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "Draugr_Missionary_A1_S1")
	Base.AddPositionStage(a1, "Draugr_Missionary_A1_S2")
	Base.AddPositionStage(a1, "Draugr_Missionary_A1_S3")
	Base.AddPositionStage(a1, "Draugr_Missionary_A1_S4")

	int a2 = Base.AddCreaturePosition("Draugrs", CreatureMale)
	Base.AddPositionStage(a2, "Draugr_Missionary_A2_S1", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Missionary_A2_S2", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Missionary_A2_S3", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Draugr_Missionary_A2_S4", 35.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Missionary,Draugr,Vaginal")

	Base.Save(id)
endFunction

function FalmerDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Falmer) Doggystyle"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Falmers"
	Base.GenderedCreatures = true

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Falmer_Doggystyle_A1_S1")
	Base.AddPositionStage(a1, "Falmer_Doggystyle_A1_S2")
	Base.AddPositionStage(a1, "Falmer_Doggystyle_A1_S3")
	Base.AddPositionStage(a1, "Falmer_Doggystyle_A1_S4")

	int a2 = Base.AddCreaturePosition("Falmers", CreatureMale)
	Base.AddPositionStage(a2, "Falmer_Doggystyle_A2_S1", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Doggystyle_A2_S2", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Doggystyle_A2_S3", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Doggystyle_A2_S4", 35.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Doggystyle,Falmer,Anal")

	Base.Save(id)
endFunction

function FalmerGangbang3P(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Falmer) Gangbang 3P"
	Base.SoundFX  = SexMix
	; Base.RaceType = "Falmers"
	Base.GenderedCreatures = true

	int a1 = Base.AddPosition(Female, VaginalOralAnal)
	Base.AddPositionStage(a1, "Falmer_Gangbang_A1_S1", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Falmer_Gangbang_A1_S2", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Falmer_Gangbang_A1_S3", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Falmer_Gangbang_A1_S4", silent = true, openMouth = true)

	int a2 = Base.AddCreaturePosition("Falmers", CreatureMale)
	Base.AddPositionStage(a2, "Falmer_Gangbang_A2_S1", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Gangbang_A2_S2", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Gangbang_A2_S3", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Gangbang_A2_S4", 30.0, rotate=180.0)

	int a3 = Base.AddCreaturePosition("Falmers", CreatureMale)
	Base.AddPositionStage(a3, "Falmer_Gangbang_A3_S1", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Falmer_Gangbang_A3_S2", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Falmer_Gangbang_A3_S3", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Falmer_Gangbang_A3_S4", 31.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Gangbang,Falmer,Anal,Oral")

	Base.Save(id)
endFunction

function FalmerGangbang4P(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Falmer) Gangbang 4P"
	Base.SoundFX  = SexMix
	; Base.RaceType = "Falmers"
	Base.GenderedCreatures = true

	int a1 = Base.AddPosition(Female, VaginalOralAnal)
	Base.AddPositionStage(a1, "Falmer_Gangbang_A1_S1", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Falmer_Gangbang_A1_S2", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Falmer_Gangbang_A1_S3", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Falmer_Gangbang_A1_S4", silent = true, openMouth = true)

	int a2 = Base.AddCreaturePosition("Falmers", CreatureMale)
	Base.AddPositionStage(a2, "Falmer_Gangbang_A2_S1", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Gangbang_A2_S2", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Gangbang_A2_S3", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Gangbang_A2_S4", 30.0, rotate=180.0)

	int a3 = Base.AddCreaturePosition("Falmers", CreatureMale)
	Base.AddPositionStage(a3, "Falmer_Gangbang_A3_S1", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Falmer_Gangbang_A3_S2", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Falmer_Gangbang_A3_S3", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Falmer_Gangbang_A3_S4", 31.0, rotate=180.0)

	int a4 = Base.AddCreaturePosition("Falmers", CreatureMale)
	Base.AddPositionStage(a4, "Falmer_Gangbang_A4_S1", 32.0, rotate=180.0)
	Base.AddPositionStage(a4, "Falmer_Gangbang_A4_S2", 32.0, rotate=180.0)
	Base.AddPositionStage(a4, "Falmer_Gangbang_A4_S3", 32.0, rotate=180.0)
	Base.AddPositionStage(a4, "Falmer_Gangbang_A4_S4", 32.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Gangbang,Falmer,Anal,Oral,Vaginal")

	Base.Save(id)
endFunction

function FalmerGangbang5P(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Falmer) Gangbang 5P"
	Base.SoundFX  = SexMix
	; Base.RaceType = "Falmers"
	Base.GenderedCreatures = true

	int a1 = Base.AddPosition(Female, VaginalOralAnal)
	Base.AddPositionStage(a1, "Falmer_Gangbang_A1_S1", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Falmer_Gangbang_A1_S2", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Falmer_Gangbang_A1_S3", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Falmer_Gangbang_A1_S4", silent = true, openMouth = true)

	int a2 = Base.AddCreaturePosition("Falmers", CreatureMale)
	Base.AddPositionStage(a2, "Falmer_Gangbang_A2_S1", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Gangbang_A2_S2", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Gangbang_A2_S3", 30.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Gangbang_A2_S4", 30.0, rotate=180.0)

	int a3 = Base.AddCreaturePosition("Falmers", CreatureMale)
	Base.AddPositionStage(a3, "Falmer_Gangbang_A3_S1", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Falmer_Gangbang_A3_S2", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Falmer_Gangbang_A3_S3", 31.0, rotate=180.0)
	Base.AddPositionStage(a3, "Falmer_Gangbang_A3_S4", 31.0, rotate=180.0)

	int a4 = Base.AddCreaturePosition("Falmers", CreatureMale)
	Base.AddPositionStage(a4, "Falmer_Gangbang_A4_S1", 32.0, rotate=180.0)
	Base.AddPositionStage(a4, "Falmer_Gangbang_A4_S2", 32.0, rotate=180.0)
	Base.AddPositionStage(a4, "Falmer_Gangbang_A4_S3", 32.0, rotate=180.0)
	Base.AddPositionStage(a4, "Falmer_Gangbang_A4_S4", 32.0, rotate=180.0)

	int a5 = Base.AddCreaturePosition("Falmers", CreatureMale)
	Base.AddPositionStage(a4, "Falmer_Gangbang_A5_S1", 33.0, rotate=180.0)
	Base.AddPositionStage(a4, "Falmer_Gangbang_A5_S2", 33.0, rotate=180.0)
	Base.AddPositionStage(a4, "Falmer_Gangbang_A5_S3", 33.0, rotate=180.0)
	Base.AddPositionStage(a4, "Falmer_Gangbang_A5_S4", 33.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Gangbang,Falmer,Anal,Oral,Vaginal")

	Base.Save(id)
endFunction

function FalmerHolding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Falmer) Holding"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Falmers"
	Base.GenderedCreatures = true

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Falmer_Holding_A1_S1")
	Base.AddPositionStage(a1, "Falmer_Holding_A1_S2")
	Base.AddPositionStage(a1, "Falmer_Holding_A1_S3")
	Base.AddPositionStage(a1, "Falmer_Holding_A1_S4")

	int a2 = Base.AddCreaturePosition("Falmers", CreatureMale)
	Base.AddPositionStage(a2, "Falmer_Holding_A2_S1", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Holding_A2_S2", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Holding_A2_S3", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Holding_A2_S4", 35.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Doggystyle,Missionary,Holding,Gangbang,Vaginal")

	Base.Save(id)
endFunction

function FalmerMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Falmer) Missionary"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Falmers"
	Base.GenderedCreatures = true

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "Falmer_Missionary_A1_S1")
	Base.AddPositionStage(a1, "Falmer_Missionary_A1_S2")
	Base.AddPositionStage(a1, "Falmer_Missionary_A1_S3")
	Base.AddPositionStage(a1, "Falmer_Missionary_A1_S4")

	int a2 = Base.AddCreaturePosition("Falmers", CreatureMale)
	Base.AddPositionStage(a2, "Falmer_Missionary_A2_S1", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Missionary_A2_S2", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Missionary_A2_S3", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Missionary_A2_S4", 35.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Doggystyle,Missionary,Holding,Vaginal")

	Base.Save(id)
endFunction

function GargoyleDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Gargoyle) Doggystyle"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Gargoyles"

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Gargoyle_Doggystyle_A1_S1")
	Base.AddPositionStage(a1, "Gargoyle_Doggystyle_A1_S2")
	Base.AddPositionStage(a1, "Gargoyle_Doggystyle_A1_S3")
	Base.AddPositionStage(a1, "Gargoyle_Doggystyle_A1_S4")

	int a2 = Base.AddCreaturePosition("Gargoyles", CreatureMale)
	Base.AddPositionStage(a2, "Gargoyle_Doggystyle_A2_S1", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Gargoyle_Doggystyle_A2_S2", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Gargoyle_Doggystyle_A2_S3", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Gargoyle_Doggystyle_A2_S4", 40.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Doggystyle,Gargoyle,Anal")

	Base.Save(id)
endFunction

function GargoyleHolding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Gargoyle) Holding"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Gargoyles"

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Gargoyle_Holding_A1_S1")
	Base.AddPositionStage(a1, "Gargoyle_Holding_A1_S2")
	Base.AddPositionStage(a1, "Gargoyle_Holding_A1_S3")
	Base.AddPositionStage(a1, "Gargoyle_Holding_A1_S4")

	int a2 = Base.AddCreaturePosition("Gargoyles", CreatureMale)
	Base.AddPositionStage(a2, "Gargoyle_Holding_A2_S1", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Gargoyle_Holding_A2_S2", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Gargoyle_Holding_A2_S3", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Gargoyle_Holding_A2_S4", 40.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Holding,Gargoyle,Vaginal")

	Base.Save(id)
endFunction

function GargoyleMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Gargoyle) Missionary"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Gargoyles"

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "Gargoyle_Missionary_A1_S1")
	Base.AddPositionStage(a1, "Gargoyle_Missionary_A1_S2")
	Base.AddPositionStage(a1, "Gargoyle_Missionary_A1_S3")
	Base.AddPositionStage(a1, "Gargoyle_Missionary_A1_S4")

	int a2 = Base.AddCreaturePosition("Gargoyles", CreatureMale)
	Base.AddPositionStage(a2, "Gargoyle_Missionary_A2_S1", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Gargoyle_Missionary_A2_S2", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Gargoyle_Missionary_A2_S3", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Gargoyle_Missionary_A2_S4", 40.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Missionary,Gargoyle,Vaginal")

	Base.Save(id)
endFunction

function GiantPenetration(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Giant) Penetration"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Giants"

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Giant_Penetration_A1_S1")
	Base.AddPositionStage(a1, "Giant_Penetration_A1_S2")
	Base.AddPositionStage(a1, "Giant_Penetration_A1_S3")
	Base.AddPositionStage(a1, "Giant_Penetration_A1_S4")

	int a2 = Base.AddCreaturePosition("Giants", CreatureMale)
	Base.AddPositionStage(a2, "Giant_Penetration_A2_S1", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Giant_Penetration_A2_S2", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Giant_Penetration_A2_S3", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Giant_Penetration_A2_S4", 35.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Holding,Rough,Giant,Vaginal")

	Base.Save(id)
endFunction

function HorseDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Horse) Doggystyle"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Horses"

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Horse_Doggystyle_A1_S1")
	Base.AddPositionStage(a1, "Horse_Doggystyle_A1_S2")
	Base.AddPositionStage(a1, "Horse_Doggystyle_A1_S3")
	Base.AddPositionStage(a1, "Horse_Doggystyle_A1_S4")

	int a2 = Base.AddCreaturePosition("Horses", CreatureMale)
	Base.AddPositionStage(a2, "Horse_Doggystyle_A2_S1", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Horse_Doggystyle_A2_S2", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Horse_Doggystyle_A2_S3", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Horse_Doggystyle_A2_S4", 45.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Doggystyle,Horse,Anal")

	Base.Save(id)
endFunction

function CatDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Sabre Cat) Doggystyle"
	Base.SoundFX  = Squishing
	; Base.RaceType = "SabreCats"

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Cat_Doggystyle_A1_S1")
	Base.AddPositionStage(a1, "Cat_Doggystyle_A1_S2")
	Base.AddPositionStage(a1, "Cat_Doggystyle_A1_S3")
	Base.AddPositionStage(a1, "Cat_Doggystyle_A1_S4")

	int a2 = Base.AddCreaturePosition("SabreCats", Creature)
	Base.AddPositionStage(a2, "Cat_Doggystyle_A2_S1", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Cat_Doggystyle_A2_S2", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Cat_Doggystyle_A2_S3", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Cat_Doggystyle_A2_S4", 45.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Doggystyle,Cat,Vaginal")

	Base.Save(id)
endFunction

function SpiderDouble(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Spider) Double"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Spiders"

	int a1 = Base.AddPosition(Female, VaginalOralAnal)
	Base.AddPositionStage(a1, "Spider_Double_A1_S1")
	Base.AddPositionStage(a1, "Spider_Double_A1_S2")
	Base.AddPositionStage(a1, "Spider_Double_A1_S3")
	Base.AddPositionStage(a1, "Spider_Double_A1_S4")

	int a2 = Base.AddCreaturePosition("Spiders", Creature)
	Base.AddPositionStage(a2, "Spider_Double_A2_S1", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Spider_Double_A2_S2", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Spider_Double_A2_S3", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Spider_Double_A2_S4", 35.0, rotate=180.0)

	int a3 = Base.AddCreaturePosition("Spiders", Creature)
	Base.AddPositionStage(a3, "Spider_Double_A3_S1", 70.0, rotate=180.0)
	Base.AddPositionStage(a3, "Spider_Double_A3_S2", 70.0, rotate=180.0)
	Base.AddPositionStage(a3, "Spider_Double_A3_S3", 70.0, rotate=180.0)
	Base.AddPositionStage(a3, "Spider_Double_A3_S4", 70.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Gangbang,Spider,Vaginal,Oral")

	Base.Save(id)
endFunction

function SpiderPenetration(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Spider) Penetration"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Spiders"

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Spider_Penetration_A1_S1")
	Base.AddPositionStage(a1, "Spider_Penetration_A1_S2")
	Base.AddPositionStage(a1, "Spider_Penetration_A1_S3")
	Base.AddPositionStage(a1, "Spider_Penetration_A1_S4")

	int a2 = Base.AddCreaturePosition("Spiders", Creature)
	Base.AddPositionStage(a2, "Spider_Penetration_A2_S1", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Spider_Penetration_A2_S2", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Spider_Penetration_A2_S3", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Spider_Penetration_A2_S4", 35.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Missionary,Spider,Vaginal")

	Base.Save(id)
endFunction

function BigSpiderPenetration(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Large Spider) Penetration"
	Base.SoundFX  = Squishing
	; Base.RaceType = "LargeSpiders"

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "BigSpider_Penetration_A1_S1")
	Base.AddPositionStage(a1, "BigSpider_Penetration_A1_S2")
	Base.AddPositionStage(a1, "BigSpider_Penetration_A1_S3")
	Base.AddPositionStage(a1, "BigSpider_Penetration_A1_S4")

	int a2 = Base.AddCreaturePosition("LargeSpiders", Creature)
	Base.AddPositionStage(a2, "BigSpider_Penetration_A2_S1", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "BigSpider_Penetration_A2_S2", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "BigSpider_Penetration_A2_S3", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "BigSpider_Penetration_A2_S4", 35.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Rough,Spider,Big Spider,Vaginal")

	Base.Save(id)
endFunction


function TrollDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Troll) Doggystyle"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Trolls"

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Troll_Doggystyle_A1_S1")
	Base.AddPositionStage(a1, "Troll_Doggystyle_A1_S2")
	Base.AddPositionStage(a1, "Troll_Doggystyle_A1_S3")
	Base.AddPositionStage(a1, "Troll_Doggystyle_A1_S4")

	int a2 = Base.AddCreaturePosition("Trolls", CreatureMale)
	Base.AddPositionStage(a2, "Troll_Doggystyle_A2_S1", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Troll_Doggystyle_A2_S2", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Troll_Doggystyle_A2_S3", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Troll_Doggystyle_A2_S4", 45.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Doggystyle,Troll,Anal")

	Base.Save(id)
endFunction

function TrollHolding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Troll) Holding"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Trolls"

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Troll_Holding_A1_S1")
	Base.AddPositionStage(a1, "Troll_Holding_A1_S2")
	Base.AddPositionStage(a1, "Troll_Holding_A1_S3")
	Base.AddPositionStage(a1, "Troll_Holding_A1_S4")

	int a2 = Base.AddCreaturePosition("Trolls", CreatureMale)
	Base.AddPositionStage(a2, "Troll_Holding_A2_S1", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Troll_Holding_A2_S2", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Troll_Holding_A2_S3", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Troll_Holding_A2_S4", 45.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Holding,Troll,Vaginal")

	Base.Save(id)
endFunction

function TrollMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Troll) Missionary"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Trolls"

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "Troll_Missionary_A1_S1")
	Base.AddPositionStage(a1, "Troll_Missionary_A1_S2")
	Base.AddPositionStage(a1, "Troll_Missionary_A1_S3")
	Base.AddPositionStage(a1, "Troll_Missionary_A1_S4")

	int a2 = Base.AddCreaturePosition("Trolls", CreatureMale)
	Base.AddPositionStage(a2, "Troll_Missionary_A2_S1", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Troll_Missionary_A2_S2", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Troll_Missionary_A2_S3", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Troll_Missionary_A2_S4", 45.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Missionary,Troll,Vaginal")

	Base.Save(id)
endFunction

function TrollDominate(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Troll) Dominate"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Trolls"

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Troll_Dominate_A1_S1")
	Base.AddPositionStage(a1, "Troll_Dominate_A1_S2")
	Base.AddPositionStage(a1, "Troll_Dominate_A1_S3")

	int a2 = Base.AddCreaturePosition("Trolls", CreatureMale)
	Base.AddPositionStage(a2, "Troll_Dominate_A2_S1")
	Base.AddPositionStage(a2, "Troll_Dominate_A2_S2")
	Base.AddPositionStage(a2, "Troll_Dominate_A2_S3")

	Base.SetTags("Panicforever,Creature,Bestiality,Dirty,Missionary,Troll,Anal")

	Base.Save(id)
endFunction

function TrollGrabbing(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Troll) Grabbing"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Trolls"

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Troll_Grabbing_A1_S1")
	Base.AddPositionStage(a1, "Troll_Grabbing_A1_S2")
	Base.AddPositionStage(a1, "Troll_Grabbing_A1_S3")

	int a2 = Base.AddCreaturePosition("Trolls", CreatureMale)
	Base.AddPositionStage(a2, "Troll_Grabbing_A2_S1")
	Base.AddPositionStage(a2, "Troll_Grabbing_A2_S2")
	Base.AddPositionStage(a2, "Troll_Grabbing_A2_S3")

	Base.SetTags("Panicforever,Creature,Bestiality,Dirty,Doggystyle,Troll,Vaginal")

	Base.Save(id)
endFunction

function VampireLordDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Vampire Lord) Doggystyle"
	Base.SoundFX  = Squishing
	; Base.RaceType = "VampireLords"
	Base.GenderedCreatures = true

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "VampireLord_Doggystyle_A1_S1")
	Base.AddPositionStage(a1, "VampireLord_Doggystyle_A1_S2")
	Base.AddPositionStage(a1, "VampireLord_Doggystyle_A1_S3")
	Base.AddPositionStage(a1, "VampireLord_Doggystyle_A1_S4")

	int a2 = Base.AddCreaturePosition("VampireLords", CreatureMale)
	Base.AddPositionStage(a2, "VampireLord_Doggystyle_A2_S1", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "VampireLord_Doggystyle_A2_S2", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "VampireLord_Doggystyle_A2_S3", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "VampireLord_Doggystyle_A2_S4", 40.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Doggystyle,Vampire Lord,Anal")

	Base.Save(id)
endFunction

function VampireLordHolding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Vampire Lord) Holding"
	Base.SoundFX  = Squishing
	; Base.RaceType = "VampireLords"
	Base.GenderedCreatures = true

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "VampireLord_Holding_A1_S1")
	Base.AddPositionStage(a1, "VampireLord_Holding_A1_S2")
	Base.AddPositionStage(a1, "VampireLord_Holding_A1_S3")
	Base.AddPositionStage(a1, "VampireLord_Holding_A1_S4")

	int a2 = Base.AddCreaturePosition("VampireLords", CreatureMale)
	Base.AddPositionStage(a2, "VampireLord_Holding_A2_S1", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "VampireLord_Holding_A2_S2", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "VampireLord_Holding_A2_S3", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "VampireLord_Holding_A2_S4", 40.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Holding,Vampire Lord,Vaginal")

	Base.Save(id)
endFunction

function VampireLordMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Vampire Lord) Missionary"
	Base.SoundFX  = Squishing
	; Base.RaceType = "VampireLords"
	Base.GenderedCreatures = true

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "VampireLord_Missionary_A1_S1")
	Base.AddPositionStage(a1, "VampireLord_Missionary_A1_S2")
	Base.AddPositionStage(a1, "VampireLord_Missionary_A1_S3")
	Base.AddPositionStage(a1, "VampireLord_Missionary_A1_S4")

	int a2 = Base.AddCreaturePosition("VampireLords", CreatureMale)
	Base.AddPositionStage(a2, "VampireLord_Missionary_A2_S1", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "VampireLord_Missionary_A2_S2", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "VampireLord_Missionary_A2_S3", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "VampireLord_Missionary_A2_S4", 40.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Missionary,Vampire Lord,Vaginal")

	Base.Save(id)
endFunction

function WerewolfAggrDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Werewolf) Rough Doggystyle"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Werewolves"
	Base.GenderedCreatures = true

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Werewolf_AggrDoggystyle_A1_S1")
	Base.AddPositionStage(a1, "Werewolf_AggrDoggystyle_A1_S2")
	Base.AddPositionStage(a1, "Werewolf_AggrDoggystyle_A1_S3")
	Base.AddPositionStage(a1, "Werewolf_AggrDoggystyle_A1_S4")

	int a2 = Base.AddCreaturePosition("Werewolves", CreatureMale)
	Base.AddPositionStage(a2, "Werewolf_AggrDoggystyle_A2_S1")
	Base.AddPositionStage(a2, "Werewolf_AggrDoggystyle_A2_S2")
	Base.AddPositionStage(a2, "Werewolf_AggrDoggystyle_A2_S3")
	Base.AddPositionStage(a2, "Werewolf_AggrDoggystyle_A2_S4")

	Base.SetTags("Panicforever,Creature,Bestiality,Dirty,Doggystyle,Rough,Werewolf,Anal")

	Base.Save(id)
endFunction

function WerewolfDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Werewolf) Doggystyle"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Werewolves"
	Base.GenderedCreatures = true

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Werewolf_Doggystyle_A1_S1")
	Base.AddPositionStage(a1, "Werewolf_Doggystyle_A1_S2")
	Base.AddPositionStage(a1, "Werewolf_Doggystyle_A1_S3")
	Base.AddPositionStage(a1, "Werewolf_Doggystyle_A1_S4")

	int a2 = Base.AddCreaturePosition("Werewolves", CreatureMale)
	Base.AddPositionStage(a2, "Werewolf_Doggystyle_A2_S1", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Werewolf_Doggystyle_A2_S2", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Werewolf_Doggystyle_A2_S3", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Werewolf_Doggystyle_A2_S4", 40.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Doggystyle,Rough,Werewolf,Anal")

	Base.Save(id)
endFunction

function WerewolfHolding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Werewolf) Holding"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Werewolves"
	Base.GenderedCreatures = true

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Werewolf_Holding_A1_S1")
	Base.AddPositionStage(a1, "Werewolf_Holding_A1_S2")
	Base.AddPositionStage(a1, "Werewolf_Holding_A1_S3")
	Base.AddPositionStage(a1, "Werewolf_Holding_A1_S4")

	int a2 = Base.AddCreaturePosition("Werewolves", CreatureMale)
	Base.AddPositionStage(a2, "Werewolf_Holding_A2_S1", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Werewolf_Holding_A2_S2", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Werewolf_Holding_A2_S3", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Werewolf_Holding_A2_S4", 40.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Holding,Rough,Werewolf,Vaginal")

	Base.Save(id)
endFunction

function WerewolfMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Werewolf) Missionary"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Werewolves"
	Base.GenderedCreatures = true

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "Werewolf_Missionary_A1_S1")
	Base.AddPositionStage(a1, "Werewolf_Missionary_A1_S2")
	Base.AddPositionStage(a1, "Werewolf_Missionary_A1_S3")
	Base.AddPositionStage(a1, "Werewolf_Missionary_A1_S4")

	int a2 = Base.AddCreaturePosition("Werewolves", CreatureMale)
	Base.AddPositionStage(a2, "Werewolf_Missionary_A2_S1", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Werewolf_Missionary_A2_S2", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Werewolf_Missionary_A2_S3", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "Werewolf_Missionary_A2_S4", 40.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Missionary,Rough,Werewolf,Vaginal")

	Base.Save(id)
endFunction

function WolfDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Wolf) Doggystyle"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Wolves"

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Canine_Doggystyle_A1_S1")
	Base.AddPositionStage(a1, "Canine_Doggystyle_A1_S2")
	Base.AddPositionStage(a1, "Canine_Doggystyle_A1_S3")
	Base.AddPositionStage(a1, "Canine_Doggystyle_A1_S4")

	int a2 = Base.AddCreaturePosition("Wolves", Creature)
	Base.AddPositionStage(a2, "Wolf_Doggystyle_A2_S1", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Wolf_Doggystyle_A2_S2", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Wolf_Doggystyle_A2_S3", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Wolf_Doggystyle_A2_S4", 45.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Doggystyle,Wolf,Anal")
	
	Base.Save(id)
endFunction

function WolfDoggystyle2(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Wolf) Dominate"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Wolves"

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Canine_Doggystyle2_A1_S1")
	Base.AddPositionStage(a1, "Canine_Doggystyle2_A1_S2")
	Base.AddPositionStage(a1, "Canine_Doggystyle2_A1_S3")
	Base.AddPositionStage(a1, "Canine_Doggystyle2_A1_S4")
	Base.AddPositionStage(a1, "Canine_Doggystyle2_A1_S5")

	int a2 = Base.AddCreaturePosition("Wolves", Creature)
	Base.AddPositionStage(a2, "Wolf_Doggystyle2_A2_S1")
	Base.AddPositionStage(a2, "Wolf_Doggystyle2_A2_S2")
	Base.AddPositionStage(a2, "Wolf_Doggystyle2_A2_S3")
	Base.AddPositionStage(a2, "Wolf_Doggystyle2_A2_S4")
	Base.AddPositionStage(a2, "Wolf_Doggystyle2_A2_S5")

	Base.SetTags("Panicforever,Creature,Bestiality,Dirty,Doggystyle,Wolf,Vaginal")

	Base.Save(id)
endFunction

function WolfMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Wolf) Missionary"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Wolves"

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "Canine_Missionary_A1_S1")
	Base.AddPositionStage(a1, "Canine_Missionary_A1_S2")
	Base.AddPositionStage(a1, "Canine_Missionary_A1_S3")
	Base.AddPositionStage(a1, "Canine_Missionary_A1_S4")

	int a2 = Base.AddCreaturePosition("Wolves", Creature)
	Base.AddPositionStage(a2, "Wolf_Missionary_A2_S1", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Wolf_Missionary_A2_S2", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Wolf_Missionary_A2_S3", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Wolf_Missionary_A2_S4", 45.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Missionary,Wolf,Vaginal")

	Base.Save(id)
endFunction

function GiantHarrassment(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Giant) Harrassment"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Giants"

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Giant_Harrassment_A1_S1")
	Base.AddPositionStage(a1, "Giant_Harrassment_A1_S2")
	Base.AddPositionStage(a1, "Giant_Harrassment_A1_S3")
	Base.AddPositionStage(a1, "Giant_Harrassment_A1_S4")

	int a2 = Base.AddCreaturePosition("Giants", Creature)
	Base.AddPositionStage(a2, "Giant_Harrassment_A2_S1")
	Base.AddPositionStage(a2, "Giant_Harrassment_A2_S2")
	Base.AddPositionStage(a2, "Giant_Harrassment_A2_S3")
	Base.AddPositionStage(a2, "Giant_Harrassment_A2_S4")

	Base.SetTags("Panicforever,Creature,Bestiality,Dirty,Holding,Rough,Giant,Vaginal")

	Base.Save(id)
endFunction

function GiantHolding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Giant) Holding"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Giants"

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Giant_Holding_A1_S1")
	Base.AddPositionStage(a1, "Giant_Holding_A1_S2")
	Base.AddPositionStage(a1, "Giant_Holding_A1_S3")

	int a2 = Base.AddCreaturePosition("Giants", CreatureMale)
	Base.AddPositionStage(a2, "Giant_Holding_A2_S1")
	Base.AddPositionStage(a2, "Giant_Holding_A2_S2")
	Base.AddPositionStage(a2, "Giant_Holding_A2_S3")

	Base.SetTags("Panicforever,Creature,Bestiality,Dirty,Holding,Rough,Giant,Vaginal")

	Base.Save(id)
endFunction


function HorseGroping(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Horse) Groping"
	Base.SoundFX  = None
	; Base.RaceType = "Horses"

	int a1 = Base.AddPosition(Female, Oral)
	Base.AddPositionStage(a1, "Horse_Groping_A1_S1")
	Base.AddPositionStage(a1, "Horse_Groping_A1_S2")
	Base.AddPositionStage(a1, "Horse_Groping_A1_S3")
	Base.AddPositionStage(a1, "Horse_Groping_A1_S4")
	Base.AddPositionStage(a1, "Horse_Groping_A1_S5")
	Base.AddPositionStage(a1, "Horse_Groping_A1_S6")
	Base.AddPositionStage(a1, "Horse_Groping_A1_S7")

	int a2 = Base.AddCreaturePosition("Horses", CreatureMale)
	Base.AddPositionStage(a2, "Horse_Groping_A2_S1")
	Base.AddPositionStage(a2, "Horse_Groping_A2_S2")
	Base.AddPositionStage(a2, "Horse_Groping_A2_S3")
	Base.AddPositionStage(a2, "Horse_Groping_A2_S4")
	Base.AddPositionStage(a2, "Horse_Groping_A2_S5")
	Base.AddPositionStage(a2, "Horse_Groping_A2_S6")
	Base.AddPositionStage(a2, "Horse_Groping_A2_S7")

	Base.SetTags("Panicforever,Creature,Bestiality,Groping,Fondling,Horse,Oral")

	Base.Save(id)
endFunction

function HorsePanicDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Horse) Doggystyle Alt"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Horses"

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Horse_PanicDoggystyle_A1_S1")
	Base.AddPositionStage(a1, "Horse_PanicDoggystyle_A1_S2")
	Base.AddPositionStage(a1, "Horse_PanicDoggystyle_A1_S3")
	Base.AddPositionStage(a1, "Horse_PanicDoggystyle_A1_S4")

	int a2 = Base.AddCreaturePosition("Horses", CreatureMale)
	Base.AddPositionStage(a2, "Horse_PanicDoggystyle_A2_S1")
	Base.AddPositionStage(a2, "Horse_PanicDoggystyle_A2_S2")
	Base.AddPositionStage(a2, "Horse_PanicDoggystyle_A2_S3")
	Base.AddPositionStage(a2, "Horse_PanicDoggystyle_A2_S4")

	Base.SetTags("Panicforever,Creature,Bestiality,Doggystyle,Horse,Vaginal")

	Base.Save(id)
endFunction

function RieklingThreesome(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Riekling) Threesome"
	Base.SoundFX  = SexMix
	; Base.RaceType = "Rieklings"
	Base.GenderedCreatures = true

	int a1 = Base.AddPosition(Female, VaginalOralAnal)
	Base.AddPositionStage(a1, "Riekling_Threesome_A1_S1")
	Base.AddPositionStage(a1, "Riekling_Threesome_A1_S2", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Riekling_Threesome_A1_S3", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Riekling_Threesome_A1_S4", silent = true, openMouth = true)

	int a2 = Base.AddCreaturePosition("Rieklings", CreatureMale)
	Base.AddPositionStage(a2, "Riekling_Threesome_A2_S1")
	Base.AddPositionStage(a2, "Riekling_Threesome_A2_S2")
	Base.AddPositionStage(a2, "Riekling_Threesome_A2_S3")
	Base.AddPositionStage(a2, "Riekling_Threesome_A2_S4")

	int a3 = Base.AddCreaturePosition("Rieklings", CreatureMale)
	Base.AddPositionStage(a3, "Riekling_Threesome_A3_S1")
	Base.AddPositionStage(a3, "Riekling_Threesome_A3_S2")
	Base.AddPositionStage(a3, "Riekling_Threesome_A3_S3")
	Base.AddPositionStage(a3, "Riekling_Threesome_A3_S4")

	Base.SetTags("Panicforever,Creature,Bestiality,Gangbang,Riekling,Dirty,Vaginal,Oral")

	Base.Save(id)
endFunction


function RieklingMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Riekling) Missionary"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Rieklings"
	Base.GenderedCreatures = true

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Riekling_Missionary_A1_S1")
	Base.AddPositionStage(a1, "Riekling_Missionary_A1_S2")
	Base.AddPositionStage(a1, "Riekling_Missionary_A1_S3")
	Base.AddPositionStage(a1, "Riekling_Missionary_A1_S4")

	int a2 = Base.AddCreaturePosition("Rieklings", CreatureMale)
	Base.AddPositionStage(a2, "Riekling_Threeway_A2_S1")
	Base.AddPositionStage(a2, "Riekling_Threeway_A2_S2")
	Base.AddPositionStage(a2, "Riekling_Threeway_A2_S3")
	Base.AddPositionStage(a2, "Riekling_Threeway_A2_S4")

	Base.SetTags("Panicforever,Creature,Bestiality,Riekling,Dirty,Vaginal")

	Base.Save(id)
endFunction

function RieklingThreeWay(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Riekling) Three-Way"
	Base.SoundFX  = SexMix
	; Base.RaceType = "Rieklings"
	Base.GenderedCreatures = true

	int a1 = Base.AddPosition(Female, VaginalOralAnal)
	Base.AddPositionStage(a1, "Riekling_ThreeWay_A1_S1")
	Base.AddPositionStage(a1, "Riekling_ThreeWay_A1_S2")
	Base.AddPositionStage(a1, "Riekling_ThreeWay_A1_S3")
	Base.AddPositionStage(a1, "Riekling_ThreeWay_A1_S4")

	int a2 = Base.AddCreaturePosition("Rieklings", CreatureMale)
	Base.AddPositionStage(a2, "Riekling_ThreeWay_A2_S1")
	Base.AddPositionStage(a2, "Riekling_ThreeWay_A2_S2")
	Base.AddPositionStage(a2, "Riekling_ThreeWay_A2_S3")
	Base.AddPositionStage(a2, "Riekling_ThreeWay_A2_S4")

	int a3 = Base.AddCreaturePosition("Rieklings", CreatureMale)
	Base.AddPositionStage(a3, "Riekling_ThreeWay_A3_S1")
	Base.AddPositionStage(a3, "Riekling_ThreeWay_A3_S2")
	Base.AddPositionStage(a3, "Riekling_ThreeWay_A3_S3")
	Base.AddPositionStage(a3, "Riekling_ThreeWay_A3_S4")

	Base.SetTags("Panicforever,Creature,Bestiality,Gangbang,3P,Riekling,Dirty,Vaginal,Oral")

	Base.Save(id)
endFunction
