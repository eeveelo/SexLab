scriptname sslCreatureAnimationDefaults extends sslAnimationFactory

; Vanilla Races
Race BearBlackRace
Race BearBrownRace
Race BearSnowRace
Race SabreCatRace
Race SabreCatSnowyRace
Race ChaurusRace
Race ChaurusReaperRace
Race DragonRace
Race UndeadDragonRace
Race DraugrRace
Race DraugrMagicRace
Race FalmerRace
Race GiantRace
Race HorseRace
Race FrostbiteSpiderRace
Race FrostbiteSpiderRaceGiant
Race FrostbiteSpiderRaceLarge
Race TrollRace
Race TrollFrostRace
Race WerewolfBeastRace

Race WolfRace
Race DogRace
Race DogCompanionRace
Race MG07DogRace
Race DA03BarbasDogRace

; Dawnguard only
bool dawnguard
Race DLC1HuskyArmoredCompanionRace
Race DLC1DeathHoundCompanionRace
Race DLC1DeathHoundRace
Race SkeletonArmorRace
Race DLC1SoulCairnKeeperRace
Race DLC1SoulCairnSkeletonArmorRace
Race DLC1VampireBeastRace
Race DLC1GargoyleRace
Race DLC1GargoyleVariantBossRace
Race DLC1GargoyleVariantGreenRace

; Dragonborn only
bool dragonborn
Race DLC2SeekerRace
Race DLC2AshSpawnRace

function LoadRaces()
	BearBlackRace            = Game.GetForm(0x131E8) as Race
	BearBrownRace            = Game.GetForm(0x131E7) as Race
	BearSnowRace             = Game.GetForm(0x131E9) as Race
	SabreCatRace             = Game.GetForm(0x13200) as Race
	SabreCatSnowyRace        = Game.GetForm(0x13202) as Race
	ChaurusRace              = Game.GetForm(0x131EB) as Race
	ChaurusReaperRace        = Game.GetForm(0xA5601) as Race
	DragonRace               = Game.GetForm(0x12E82) as Race
	UndeadDragonRace         = Game.GetForm(0x1052A3) as Race
	DraugrRace               = Game.GetForm(0x0D53) as Race
	DraugrMagicRace          = Game.GetForm(0xF71DC) as Race
	FalmerRace               = Game.GetForm(0x131F4) as Race
	GiantRace                = Game.GetForm(0x131F9) as Race
	HorseRace                = Game.GetForm(0x131FD) as Race
	FrostbiteSpiderRace      = Game.GetForm(0x131F8) as Race
	FrostbiteSpiderRaceGiant = Game.GetForm(0x4E507) as Race
	FrostbiteSpiderRaceLarge = Game.GetForm(0x53477) as Race
	TrollRace                = Game.GetForm(0x13205) as Race
	TrollFrostRace           = Game.GetForm(0x105A3) as Race
	WerewolfBeastRace        = Game.GetForm(0xCDD84) as Race
	WolfRace                 = Game.GetForm(0x1320A) as Race
	DogRace                  = Game.GetForm(0x131EE) as Race
	DogCompanionRace         = Game.GetForm(0xF1AC4) as Race
	MG07DogRace              = Game.GetForm(0xF905F) as Race
	DA03BarbasDogRace        = Game.GetForm(0xCD657) as Race

	dawnguard = false
	dragonborn = false
	int mods = Game.GetModCount()
	int i
	while i < mods
		string modname = Game.GetModName(i)
		if !dawnguard && modname == "Dawnguard.esm"
			dawnguard = true
			; Dogs
			DLC1HuskyArmoredCompanionRace  = Game.GetFormFromFile(0x3D01, "Dawnguard.esm") as Race
			DLC1DeathHoundCompanionRace    = Game.GetFormFromFile(0x3D02, "Dawnguard.esm") as Race
			DLC1DeathHoundRace             = Game.GetFormFromFile(0xC5F0, "Dawnguard.esm") as Race
			; Draugr
			SkeletonArmorRace              = Game.GetFormFromFile(0x23E2, "Dawnguard.esm") as Race
			DLC1SoulCairnKeeperRace        = Game.GetFormFromFile(0x7AF3, "Dawnguard.esm") as Race
			DLC1SoulCairnSkeletonArmorRace = Game.GetFormFromFile(0x894D, "Dawnguard.esm") as Race
			; Vampire Lord
			DLC1VampireBeastRace           = Game.GetFormFromFile(0x283A, "Dawnguard.esm") as Race
			; Gargoyle
			DLC1GargoyleRace               = Game.GetFormFromFile(0xA2C6, "Dawnguard.esm") as Race
			DLC1GargoyleVariantBossRace    = Game.GetFormFromFile(0x10D00, "Dawnguard.esm") as Race
			DLC1GargoyleVariantGreenRace   = Game.GetFormFromFile(0x19D86, "Dawnguard.esm") as Race
		elseif !dragonborn && modname == "Dragonborn.esm"
			dragonborn = true
			; Seeker
			DLC2SeekerRace   = Game.GetFormFromFile(0x1DCB9, "Dragonborn.esm") as Race
			; Draugr
			DLC2AshSpawnRace = Game.GetFormFromFile(0x1B637, "Dragonborn.esm") as Race
		elseif dawnguard && dragonborn
			return
		endIf
		i += 1
	endwhile
endFunction

function LoadCreatureAnimations()
	; Loaded needed race forms
	LoadRaces()
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
	if dawnguard
		RegisterAnimation("GargoyleDoggystyle")
		RegisterAnimation("GargoyleHolding")
		RegisterAnimation("GargoyleMissionary")
		RegisterAnimation("VampireLordDoggystyle")
		RegisterAnimation("VampireLordHolding")
		RegisterAnimation("VampireLordMissionary")
	endIf
	; Dragonborn Daedra Seeker
	if dragonborn
		RegisterAnimation("DaedraHugging")
	endIf
endFunction

function BearDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "(Bear) Doggystyle"

	Base.SoundFX = Squishing
	Base.AddRace(BearBlackRace)
	Base.AddRace(BearBrownRace)
	Base.AddRace(BearSnowRace)

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
	Base.AddRace(ChaurusRace)
	Base.AddRace(ChaurusReaperRace)

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
	Base.AddRace(ChaurusRace)
	Base.AddRace(ChaurusReaperRace)

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
	Base.AddRace(DLC2SeekerRace)

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

	Base.AddRace(DogRace)
	Base.AddRace(DogCompanionRace)
	Base.AddRace(MG07DogRace)
	Base.AddRace(DA03BarbasDogRace)
	if dawnguard
		Base.AddRace(DLC1HuskyArmoredCompanionRace)
		Base.AddRace(DLC1DeathHoundCompanionRace)
		Base.AddRace(DLC1DeathHoundRace)
	endIf

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

	Base.AddRace(DogRace)
	Base.AddRace(DogCompanionRace)
	Base.AddRace(MG07DogRace)
	Base.AddRace(DA03BarbasDogRace)
	if dawnguard
		Base.AddRace(DLC1HuskyArmoredCompanionRace)
		Base.AddRace(DLC1DeathHoundCompanionRace)
		Base.AddRace(DLC1DeathHoundRace)
	endIf

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
	Base.AddRace(DogRace)
	Base.AddRace(DogCompanionRace)
	Base.AddRace(MG07DogRace)
	Base.AddRace(DA03BarbasDogRace)
	if dawnguard
		Base.AddRace(DLC1HuskyArmoredCompanionRace)
		Base.AddRace(DLC1DeathHoundCompanionRace)
		Base.AddRace(DLC1DeathHoundRace)
	endIf

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
	Base.AddRace(DragonRace)
	Base.AddRace(UndeadDragonRace)

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
	Base.AddRace(DragonRace)
	Base.AddRace(UndeadDragonRace)

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
	Base.AddRace(DraugrRace)
	Base.AddRace(DraugrMagicRace)
	if dawnguard
		Base.AddRace(SkeletonArmorRace)
		Base.AddRace(DLC1SoulCairnKeeperRace)
		Base.AddRace(DLC1SoulCairnSkeletonArmorRace)
	endIf
	if dragonborn
		Base.AddRace(DLC2AshSpawnRace)
	endIf

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
	Base.AddRace(DraugrRace)
	Base.AddRace(DraugrMagicRace)
	if dawnguard
		Base.AddRace(SkeletonArmorRace)
		Base.AddRace(DLC1SoulCairnKeeperRace)
		Base.AddRace(DLC1SoulCairnSkeletonArmorRace)
	endIf
	if dragonborn
		Base.AddRace(DLC2AshSpawnRace)
	endIf

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
	Base.AddRace(DraugrRace)
	Base.AddRace(DraugrMagicRace)
	if dawnguard
		Base.AddRace(SkeletonArmorRace)
		Base.AddRace(DLC1SoulCairnKeeperRace)
		Base.AddRace(DLC1SoulCairnSkeletonArmorRace)
	endIf
	if dragonborn
		Base.AddRace(DLC2AshSpawnRace)
	endIf

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
	Base.AddRace(DraugrRace)
	Base.AddRace(DraugrMagicRace)
	if dawnguard
		Base.AddRace(SkeletonArmorRace)
		Base.AddRace(DLC1SoulCairnKeeperRace)
		Base.AddRace(DLC1SoulCairnSkeletonArmorRace)
	endIf
	if dragonborn
		Base.AddRace(DLC2AshSpawnRace)
	endIf

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
	Base.AddRace(DraugrRace)
	Base.AddRace(DraugrMagicRace)
	if dawnguard
		Base.AddRace(SkeletonArmorRace)
		Base.AddRace(DLC1SoulCairnKeeperRace)
		Base.AddRace(DLC1SoulCairnSkeletonArmorRace)
	endIf
	if dragonborn
		Base.AddRace(DLC2AshSpawnRace)
	endIf

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
	Base.AddRace(DraugrRace)
	Base.AddRace(DraugrMagicRace)
	if dawnguard
		Base.AddRace(SkeletonArmorRace)
		Base.AddRace(DLC1SoulCairnKeeperRace)
		Base.AddRace(DLC1SoulCairnSkeletonArmorRace)
	endIf
	if dragonborn
		Base.AddRace(DLC2AshSpawnRace)
	endIf

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
	Base.AddRace(FalmerRace)

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
	Base.AddRace(FalmerRace)

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
	Base.AddRace(FalmerRace)

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
	Base.AddRace(FalmerRace)

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
	Base.AddRace(FalmerRace)

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
	Base.AddRace(FalmerRace)

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
	Base.AddRace(DLC1GargoyleRace)
	Base.AddRace(DLC1GargoyleVariantBossRace)
	Base.AddRace(DLC1GargoyleVariantGreenRace)

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
	Base.AddRace(DLC1GargoyleRace)
	Base.AddRace(DLC1GargoyleVariantBossRace)
	Base.AddRace(DLC1GargoyleVariantGreenRace)

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
	Base.AddRace(DLC1GargoyleRace)
	Base.AddRace(DLC1GargoyleVariantBossRace)
	Base.AddRace(DLC1GargoyleVariantGreenRace)

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
	Base.AddRace(GiantRace)

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
	Base.AddRace(HorseRace)

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
	Base.AddRace(SabreCatRace)
	Base.AddRace(SabreCatSnowyRace)

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
	Base.AddRace(FrostbiteSpiderRace)

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
	Base.AddRace(FrostbiteSpiderRace)

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
	Base.AddRace(FrostbiteSpiderRaceLarge)
	Base.AddRace(FrostbiteSpiderRaceGiant)

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
	Base.AddRace(TrollRace)
	Base.AddRace(TrollFrostRace)

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
	Base.AddRace(TrollRace)
	Base.AddRace(TrollFrostRace)

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
	Base.AddRace(TrollRace)
	Base.AddRace(TrollFrostRace)

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
	Base.AddRace(TrollRace)
	Base.AddRace(TrollFrostRace)

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
	Base.AddRace(TrollRace)
	Base.AddRace(TrollFrostRace)

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
	Base.AddRace(DLC1VampireBeastRace)

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
	Base.AddRace(DLC1VampireBeastRace)

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
	Base.AddRace(DLC1VampireBeastRace)

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
	Base.AddRace(WerewolfBeastRace)

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
	Base.AddRace(WerewolfBeastRace)

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
	Base.AddRace(WerewolfBeastRace)

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
	Base.AddRace(WerewolfBeastRace)

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
	Base.AddRace(WolfRace)

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
	Base.AddRace(WolfRace)

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
	Base.AddRace(WolfRace)

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
