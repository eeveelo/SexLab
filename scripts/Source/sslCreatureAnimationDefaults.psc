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

; Temporary alpha testing - SKSE 1.7.0 compatibility
function SendEvent(string Registrar)
	RegisterForModEvent("Register"+Registrar, Registrar)
	ModEvent.Send(ModEvent.Create("Register"+Registrar))
	; SendModEvent("Register"+Registrar)
	UnregisterForAllModEvents()
endFunction

function LoadRaces()
	BearBlackRace = Game.GetForm(0x131E8) as Race
	BearBrownRace = Game.GetForm(0x131E7) as Race
	BearSnowRace = Game.GetForm(0x131E9) as Race
	SabreCatRace = Game.GetForm(0x13200) as Race
	SabreCatSnowyRace = Game.GetForm(0x13202) as Race
	ChaurusRace = Game.GetForm(0x131EB) as Race
	ChaurusReaperRace = Game.GetForm(0xA5601) as Race
	DragonRace = Game.GetForm(0x12E82) as Race
	UndeadDragonRace = Game.GetForm(0x1052A3) as Race
	DraugrRace = Game.GetForm(0x0D53) as Race
	DraugrMagicRace = Game.GetForm(0xF71DC) as Race
	FalmerRace = Game.GetForm(0x131F4) as Race
	GiantRace = Game.GetForm(0x131F9) as Race
	HorseRace = Game.GetForm(0x131FD) as Race
	FrostbiteSpiderRace = Game.GetForm(0x131F8) as Race
	FrostbiteSpiderRaceGiant = Game.GetForm(0x4E507) as Race
	FrostbiteSpiderRaceLarge = Game.GetForm(0x53477) as Race
	TrollRace = Game.GetForm(0x13205) as Race
	TrollFrostRace = Game.GetForm(0x105A3) as Race
	WerewolfBeastRace = Game.GetForm(0xCDD84) as Race
	WolfRace = Game.GetForm(0x1320A) as Race
	DogRace = Game.GetForm(0x131EE) as Race
	DogCompanionRace = Game.GetForm(0xF1AC4) as Race
	MG07DogRace = Game.GetForm(0xF905F) as Race
	DA03BarbasDogRace = Game.GetForm(0xCD657) as Race

	dawnguard = false
	dragonborn = false
	int mods = Game.GetModCount()
	int i
	while i < mods
		string modname = Game.GetModName(i)
		if !dawnguard && modname == "Dawnguard.esm"
			dawnguard = true
			; Dogs
			DLC1HuskyArmoredCompanionRace = Game.GetFormFromFile(0x3D01, "Dawnguard.esm") as Race
			DLC1DeathHoundCompanionRace = Game.GetFormFromFile(0x3D02, "Dawnguard.esm") as Race
			DLC1DeathHoundRace = Game.GetFormFromFile(0xC5F0, "Dawnguard.esm") as Race
			; Draugr
			SkeletonArmorRace = Game.GetFormFromFile(0x23E2, "Dawnguard.esm") as Race
			DLC1SoulCairnKeeperRace = Game.GetFormFromFile(0x7AF3, "Dawnguard.esm") as Race
			DLC1SoulCairnSkeletonArmorRace = Game.GetFormFromFile(0x894D, "Dawnguard.esm") as Race
			; Vampire Lord
			DLC1VampireBeastRace = Game.GetFormFromFile(0x283A, "Dawnguard.esm") as Race
			; Gargoyle
			DLC1GargoyleRace = Game.GetFormFromFile(0xA2C6, "Dawnguard.esm") as Race
			DLC1GargoyleVariantBossRace = Game.GetFormFromFile(0x10D00, "Dawnguard.esm") as Race
			DLC1GargoyleVariantGreenRace = Game.GetFormFromFile(0x19D86, "Dawnguard.esm") as Race
		elseif !dragonborn && modname == "Dragonborn.esm"
			dragonborn = true
			; Seeker
			DLC2SeekerRace = Game.GetFormFromFile(0x1DCB9, "Dragonborn.esm") as Race
			; Draugr
			DLC2AshSpawnRace  = Game.GetFormFromFile(0x1B637, "Dragonborn.esm") as Race
		elseif dawnguard && dragonborn
			return
		endIf
		i += 1
	endwhile
endFunction

function AddRace(Race CreatureRace)
	Animation.AddRace(CreatureRace)
	(Slots as sslCreatureAnimationSlots).AddRace(CreatureRace)
endFunction

function LoadAnimations()
	; Prepare factory for load
	Slots = Quest.GetQuest("SexLabQuestCreatureAnimations") as sslCreatureAnimationSlots
	FreeFactory()
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

function BearDoggystyle()
	Name = "(Bear) Doggystyle"

	SoundFX = Squishing
	AddRace(BearBlackRace)
	AddRace(BearBrownRace)
	AddRace(BearSnowRace)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Bear_Doggystyle_A1_S1")
	AddPositionStage(a1, "Bear_Doggystyle_A1_S2")
	AddPositionStage(a1, "Bear_Doggystyle_A1_S3")
	AddPositionStage(a1, "Bear_Doggystyle_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Bear_Doggystyle_A2_S1", 45.0, rotate=180.0)
	AddPositionStage(a2, "Bear_Doggystyle_A2_S2", 45.0, rotate=180.0)
	AddPositionStage(a2, "Bear_Doggystyle_A2_S3", 45.0, rotate=180.0)
	AddPositionStage(a2, "Bear_Doggystyle_A2_S4", 45.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Doggystyle")
	AddTag("Bear")

	Save()
endFunction

function ChaurusForward()
	Name = "(Chaurus) Forward"

	SoundFX = Squishing
	AddRace(ChaurusRace)
	AddRace(ChaurusReaperRace)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Chaurus_Forward_A1_S1")
	AddPositionStage(a1, "Chaurus_Forward_A1_S2")
	AddPositionStage(a1, "Chaurus_Forward_A1_S3")
	AddPositionStage(a1, "Chaurus_Forward_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Chaurus_Forward_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Chaurus_Forward_A2_S2", 40.0, rotate=180.0)
	AddPositionStage(a2, "Chaurus_Forward_A2_S3", 40.0, rotate=180.0)
	AddPositionStage(a2, "Chaurus_Forward_A2_S4", 40.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Holding")
	AddTag("Chaurus")

	Save()
endFunction

function ChaurusReverse()
	Name = "(Chaurus) Reverse"

	SoundFX = Squishing
	AddRace(ChaurusRace)
	AddRace(ChaurusReaperRace)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "Chaurus_Reverse_A1_S1")
	AddPositionStage(a1, "Chaurus_Reverse_A1_S2")
	AddPositionStage(a1, "Chaurus_Reverse_A1_S3")
	AddPositionStage(a1, "Chaurus_Reverse_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Chaurus_Reverse_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Chaurus_Reverse_A2_S2", 40.0, rotate=180.0)
	AddPositionStage(a2, "Chaurus_Reverse_A2_S3", 40.0, rotate=180.0)
	AddPositionStage(a2, "Chaurus_Reverse_A2_S4", 40.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Holding")
	AddTag("Chaurus")

	Save()
endFunction

function DaedraHugging()
	Name = "(Seeker) Hugging"

	SoundFX = Squishing
	AddRace(DLC2SeekerRace)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "Daedra_Hugging_A1_S1")
	AddPositionStage(a1, "Daedra_Hugging_A1_S2")
	AddPositionStage(a1, "Daedra_Hugging_A1_S3")
	AddPositionStage(a1, "Daedra_Hugging_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Daedra_Hugging_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Daedra_Hugging_A2_S2", 40.0, rotate=180.0)
	AddPositionStage(a2, "Daedra_Hugging_A2_S3", 40.0, rotate=180.0)
	AddPositionStage(a2, "Daedra_Hugging_A2_S4", 40.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Holding")
	AddTag("Hugging")
	AddTag("Daedra")
	AddTag("Seeking")

	Save()
endFunction

function CanineDoggystyle()
	Name = "(Dog) Doggystyle"

	SoundFX = Squishing

	AddRace(DogRace)
	AddRace(DogCompanionRace)
	AddRace(MG07DogRace)
	AddRace(DA03BarbasDogRace)
	if dawnguard
		AddRace(DLC1HuskyArmoredCompanionRace)
		AddRace(DLC1DeathHoundCompanionRace)
		AddRace(DLC1DeathHoundRace)
	endIf

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Canine_Doggystyle_A1_S1")
	AddPositionStage(a1, "Canine_Doggystyle_A1_S2")
	AddPositionStage(a1, "Canine_Doggystyle_A1_S3")
	AddPositionStage(a1, "Canine_Doggystyle_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Dog_Doggystyle_A2_S1", 45.0, rotate=180.0)
	AddPositionStage(a2, "Dog_Doggystyle_A2_S2", 45.0, rotate=180.0)
	AddPositionStage(a2, "Dog_Doggystyle_A2_S3", 45.0, rotate=180.0)
	AddPositionStage(a2, "Dog_Doggystyle_A2_S4", 45.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Doggystyle")
	AddTag("Canine")
	AddTag("Dog")

	Save()
endFunction

function CanineDoggystyle2()
	Name = "(Dog) Doggystyle 2"

	SoundFX = Squishing

	AddRace(DogRace)
	AddRace(DogCompanionRace)
	AddRace(MG07DogRace)
	AddRace(DA03BarbasDogRace)
	if dawnguard
		AddRace(DLC1HuskyArmoredCompanionRace)
		AddRace(DLC1DeathHoundCompanionRace)
		AddRace(DLC1DeathHoundRace)
	endIf

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Canine_Doggystyle2_A1_S1")
	AddPositionStage(a1, "Canine_Doggystyle2_A1_S2")
	AddPositionStage(a1, "Canine_Doggystyle2_A1_S3")
	AddPositionStage(a1, "Canine_Doggystyle2_A1_S4")
	AddPositionStage(a1, "Canine_Doggystyle2_A1_S5")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Dog_Doggystyle2_A2_S1")
	AddPositionStage(a2, "Dog_Doggystyle2_A2_S2")
	AddPositionStage(a2, "Dog_Doggystyle2_A2_S3")
	AddPositionStage(a2, "Dog_Doggystyle2_A2_S4")
	AddPositionStage(a2, "Dog_Doggystyle2_A2_S5")

	AddTag("Panicforever")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Doggystyle")
	AddTag("Canine")
	AddTag("Dog")

	Save()
endFunction

function CanineMissionary()
	Name = "(Dog) Missionary"

	SoundFX = Squishing
	AddRace(DogRace)
	AddRace(DogCompanionRace)
	AddRace(MG07DogRace)
	AddRace(DA03BarbasDogRace)
	if dawnguard
		AddRace(DLC1HuskyArmoredCompanionRace)
		AddRace(DLC1DeathHoundCompanionRace)
		AddRace(DLC1DeathHoundRace)
	endIf

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "Canine_Missionary_A1_S1")
	AddPositionStage(a1, "Canine_Missionary_A1_S2")
	AddPositionStage(a1, "Canine_Missionary_A1_S3")
	AddPositionStage(a1, "Canine_Missionary_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Dog_Missionary_A2_S1", 45.0, rotate=180.0)
	AddPositionStage(a2, "Dog_Missionary_A2_S2", 45.0, rotate=180.0)
	AddPositionStage(a2, "Dog_Missionary_A2_S3", 45.0, rotate=180.0)
	AddPositionStage(a2, "Dog_Missionary_A2_S4", 45.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Missionary")
	AddTag("Canine")
	AddTag("Dog")

	Save()
endFunction


function DragonPenetration()
	Name = "(Dragon) Penetration"

	SoundFX = Squishing
	AddRace(DragonRace)
	AddRace(UndeadDragonRace)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "Dragon_Penetration_A1_S1")
	AddPositionStage(a1, "Dragon_Penetration_A1_S2")
	AddPositionStage(a1, "Dragon_Penetration_A1_S3")
	AddPositionStage(a1, "Dragon_Penetration_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Dragon_Penetration_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Dragon_Penetration_A2_S2", 35.0, rotate=180.0)
	AddPositionStage(a2, "Dragon_Penetration_A2_S3", 35.0, rotate=180.0)
	AddPositionStage(a2, "Dragon_Penetration_A2_S4", 35.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Missionary")
	AddTag("Dragon")

	Save()
endFunction

function DragonTongue()
	Name = "(Dragon) Tongue"

	SoundFX = Squishing
	AddRace(DragonRace)
	AddRace(UndeadDragonRace)

	int a1 = AddPosition(Female)
	AddPositionStage(a1, "Dragon_Tongue_A1_S1")
	AddPositionStage(a1, "Dragon_Tongue_A1_S2")
	AddPositionStage(a1, "Dragon_Tongue_A1_S3")
	AddPositionStage(a1, "Dragon_Tongue_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Dragon_Tongue_A2_S1", 32.0)
	AddPositionStage(a2, "Dragon_Tongue_A2_S2", 32.0)
	AddPositionStage(a2, "Dragon_Tongue_A2_S3", 32.0)
	AddPositionStage(a2, "Dragon_Tongue_A2_S4", 32.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Oral")
	AddTag("Dragon")

	Save()
endFunction

function DraugrDoggystyle()
	Name = "(Draugr) Doggystyle"

	SoundFX = Squishing
	AddRace(DraugrRace)
	AddRace(DraugrMagicRace)
	if dawnguard
		AddRace(SkeletonArmorRace)
		AddRace(DLC1SoulCairnKeeperRace)
		AddRace(DLC1SoulCairnSkeletonArmorRace)
	endIf
	if dragonborn
		AddRace(DLC2AshSpawnRace)
	endIf

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Draugr_Doggystyle_A1_S1")
	AddPositionStage(a1, "Draugr_Doggystyle_A1_S2")
	AddPositionStage(a1, "Draugr_Doggystyle_A1_S3")
	AddPositionStage(a1, "Draugr_Doggystyle_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Draugr_Doggystyle_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Doggystyle_A2_S2", 35.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Doggystyle_A2_S3", 35.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Doggystyle_A2_S4", 35.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Doggystyle")
	AddTag("Draugr")

	Save()
endFunction

function DraugrGangbang3P()
	Name = "(Draugr) Gangbang 3P"

	SoundFX = SexMix
	AddRace(DraugrRace)
	AddRace(DraugrMagicRace)
	if dawnguard
		AddRace(SkeletonArmorRace)
		AddRace(DLC1SoulCairnKeeperRace)
		AddRace(DLC1SoulCairnSkeletonArmorRace)
	endIf
	if dragonborn
		AddRace(DLC2AshSpawnRace)
	endIf

	int a1 = AddPosition(Female, addCum=VaginalOralAnal)
	AddPositionStage(a1, "Draugr_Gangbang_A1_S1", silent = true, openMouth = true)
	AddPositionStage(a1, "Draugr_Gangbang_A1_S2", silent = true, openMouth = true)
	AddPositionStage(a1, "Draugr_Gangbang_A1_S3", silent = true, openMouth = true)
	AddPositionStage(a1, "Draugr_Gangbang_A1_S4", silent = true, openMouth = true)

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Draugr_Gangbang_A2_S1", 30.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Gangbang_A2_S2", 30.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Gangbang_A2_S3", 30.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Gangbang_A2_S4", 30.0, rotate=180.0)

	int a3 = AddPosition(Creature)
	AddPositionStage(a3, "Draugr_Gangbang_A3_S1", 31.0, rotate=180.0)
	AddPositionStage(a3, "Draugr_Gangbang_A3_S2", 31.0, rotate=180.0)
	AddPositionStage(a3, "Draugr_Gangbang_A3_S3", 31.0, rotate=180.0)
	AddPositionStage(a3, "Draugr_Gangbang_A3_S4", 31.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Gangbang")
	AddTag("Draugr")

	Save()
endFunction

function DraugrGangbang4P()
	Name = "(Draugr) Gangbang 4P"

	SoundFX = SexMix
	AddRace(DraugrRace)
	AddRace(DraugrMagicRace)
	if dawnguard
		AddRace(SkeletonArmorRace)
		AddRace(DLC1SoulCairnKeeperRace)
		AddRace(DLC1SoulCairnSkeletonArmorRace)
	endIf
	if dragonborn
		AddRace(DLC2AshSpawnRace)
	endIf

	int a1 = AddPosition(Female, addCum=VaginalOralAnal)
	AddPositionStage(a1, "Draugr_Gangbang_A1_S1", silent = true, openMouth = true)
	AddPositionStage(a1, "Draugr_Gangbang_A1_S2", silent = true, openMouth = true)
	AddPositionStage(a1, "Draugr_Gangbang_A1_S3", silent = true, openMouth = true)
	AddPositionStage(a1, "Draugr_Gangbang_A1_S4", silent = true, openMouth = true)

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Draugr_Gangbang_A2_S1", 30.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Gangbang_A2_S2", 30.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Gangbang_A2_S3", 30.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Gangbang_A2_S4", 30.0, rotate=180.0)

	int a3 = AddPosition(Creature)
	AddPositionStage(a3, "Draugr_Gangbang_A3_S1", 31.0, rotate=180.0)
	AddPositionStage(a3, "Draugr_Gangbang_A3_S2", 31.0, rotate=180.0)
	AddPositionStage(a3, "Draugr_Gangbang_A3_S3", 31.0, rotate=180.0)
	AddPositionStage(a3, "Draugr_Gangbang_A3_S4", 31.0, rotate=180.0)

	int a4 = AddPosition(Creature)
	AddPositionStage(a4, "Draugr_Gangbang_A4_S1", 32.0, rotate=180.0)
	AddPositionStage(a4, "Draugr_Gangbang_A4_S2", 32.0, rotate=180.0)
	AddPositionStage(a4, "Draugr_Gangbang_A4_S3", 32.0, rotate=180.0)
	AddPositionStage(a4, "Draugr_Gangbang_A4_S4", 32.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Gangbang")
	AddTag("Draugr")

	Save()
endFunction

function DraugrGangbang5P()
	Name = "(Draugr) Gangbang 5P"

	SoundFX = SexMix
	AddRace(DraugrRace)
	AddRace(DraugrMagicRace)
	if dawnguard
		AddRace(SkeletonArmorRace)
		AddRace(DLC1SoulCairnKeeperRace)
		AddRace(DLC1SoulCairnSkeletonArmorRace)
	endIf
	if dragonborn
		AddRace(DLC2AshSpawnRace)
	endIf

	int a1 = AddPosition(Female, addCum=VaginalOralAnal)
	AddPositionStage(a1, "Draugr_Gangbang_A1_S1", silent = true, openMouth = true)
	AddPositionStage(a1, "Draugr_Gangbang_A1_S2", silent = true, openMouth = true)
	AddPositionStage(a1, "Draugr_Gangbang_A1_S3", silent = true, openMouth = true)
	AddPositionStage(a1, "Draugr_Gangbang_A1_S4", silent = true, openMouth = true)

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Draugr_Gangbang_A2_S1", 30.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Gangbang_A2_S2", 30.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Gangbang_A2_S3", 30.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Gangbang_A2_S4", 30.0, rotate=180.0)

	int a3 = AddPosition(Creature)
	AddPositionStage(a3, "Draugr_Gangbang_A3_S1", 31.0, rotate=180.0)
	AddPositionStage(a3, "Draugr_Gangbang_A3_S2", 31.0, rotate=180.0)
	AddPositionStage(a3, "Draugr_Gangbang_A3_S3", 31.0, rotate=180.0)
	AddPositionStage(a3, "Draugr_Gangbang_A3_S4", 31.0, rotate=180.0)

	int a4 = AddPosition(Creature)
	AddPositionStage(a4, "Draugr_Gangbang_A4_S1", 32.0, rotate=180.0)
	AddPositionStage(a4, "Draugr_Gangbang_A4_S2", 32.0, rotate=180.0)
	AddPositionStage(a4, "Draugr_Gangbang_A4_S3", 32.0, rotate=180.0)
	AddPositionStage(a4, "Draugr_Gangbang_A4_S4", 32.0, rotate=180.0)

	int a5 = AddPosition(Creature)
	AddPositionStage(a4, "Draugr_Gangbang_A5_S1", 33.0, rotate=180.0)
	AddPositionStage(a4, "Draugr_Gangbang_A5_S2", 33.0, rotate=180.0)
	AddPositionStage(a4, "Draugr_Gangbang_A5_S3", 33.0, rotate=180.0)
	AddPositionStage(a4, "Draugr_Gangbang_A5_S4", 33.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Gangbang")
	AddTag("Draugr")

	Save()
endFunction

function DraugrHolding()
	Name = "(Draugr) Holding"

	SoundFX = Squishing
	AddRace(DraugrRace)
	AddRace(DraugrMagicRace)
	if dawnguard
		AddRace(SkeletonArmorRace)
		AddRace(DLC1SoulCairnKeeperRace)
		AddRace(DLC1SoulCairnSkeletonArmorRace)
	endIf
	if dragonborn
		AddRace(DLC2AshSpawnRace)
	endIf

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Draugr_Holding_A1_S1")
	AddPositionStage(a1, "Draugr_Holding_A1_S2")
	AddPositionStage(a1, "Draugr_Holding_A1_S3")
	AddPositionStage(a1, "Draugr_Holding_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Draugr_Holding_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Holding_A2_S2", 35.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Holding_A2_S3", 35.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Holding_A2_S4", 35.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Holding")
	AddTag("Draugr")

	Save()
endFunction

function DraugrMissionary()
	Name = "(Draugr) Missionary"

	SoundFX = Squishing
	AddRace(DraugrRace)
	AddRace(DraugrMagicRace)
	if dawnguard
		AddRace(SkeletonArmorRace)
		AddRace(DLC1SoulCairnKeeperRace)
		AddRace(DLC1SoulCairnSkeletonArmorRace)
	endIf
	if dragonborn
		AddRace(DLC2AshSpawnRace)
	endIf

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "Draugr_Missionary_A1_S1")
	AddPositionStage(a1, "Draugr_Missionary_A1_S2")
	AddPositionStage(a1, "Draugr_Missionary_A1_S3")
	AddPositionStage(a1, "Draugr_Missionary_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Draugr_Missionary_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Missionary_A2_S2", 35.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Missionary_A2_S3", 35.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Missionary_A2_S4", 35.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Missionary")
	AddTag("Draugr")

	Save()
endFunction

function FalmerDoggystyle()
	Name = "(Falmer) Doggystyle"

	SoundFX = Squishing
	AddRace(FalmerRace)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Falmer_Doggystyle_A1_S1")
	AddPositionStage(a1, "Falmer_Doggystyle_A1_S2")
	AddPositionStage(a1, "Falmer_Doggystyle_A1_S3")
	AddPositionStage(a1, "Falmer_Doggystyle_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Falmer_Doggystyle_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Doggystyle_A2_S2", 35.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Doggystyle_A2_S3", 35.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Doggystyle_A2_S4", 35.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Doggystyle")
	AddTag("Falmer")

	Save()
endFunction

function FalmerGangbang3P()
	Name = "(Falmer) Gangbang 3P"

	SoundFX = SexMix
	AddRace(FalmerRace)

	int a1 = AddPosition(Female, addCum=VaginalOralAnal)
	AddPositionStage(a1, "Falmer_Gangbang_A1_S1", silent = true, openMouth = true)
	AddPositionStage(a1, "Falmer_Gangbang_A1_S2", silent = true, openMouth = true)
	AddPositionStage(a1, "Falmer_Gangbang_A1_S3", silent = true, openMouth = true)
	AddPositionStage(a1, "Falmer_Gangbang_A1_S4", silent = true, openMouth = true)

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Falmer_Gangbang_A2_S1", 30.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Gangbang_A2_S2", 30.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Gangbang_A2_S3", 30.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Gangbang_A2_S4", 30.0, rotate=180.0)

	int a3 = AddPosition(Creature)
	AddPositionStage(a3, "Falmer_Gangbang_A3_S1", 31.0, rotate=180.0)
	AddPositionStage(a3, "Falmer_Gangbang_A3_S2", 31.0, rotate=180.0)
	AddPositionStage(a3, "Falmer_Gangbang_A3_S3", 31.0, rotate=180.0)
	AddPositionStage(a3, "Falmer_Gangbang_A3_S4", 31.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Gangbang")
	AddTag("Falmer")

	Save()
endFunction

function FalmerGangbang4P()
	Name = "(Falmer) Gangbang 4P"

	SoundFX = SexMix
	AddRace(FalmerRace)

	int a1 = AddPosition(Female, addCum=VaginalOralAnal)
	AddPositionStage(a1, "Falmer_Gangbang_A1_S1", silent = true, openMouth = true)
	AddPositionStage(a1, "Falmer_Gangbang_A1_S2", silent = true, openMouth = true)
	AddPositionStage(a1, "Falmer_Gangbang_A1_S3", silent = true, openMouth = true)
	AddPositionStage(a1, "Falmer_Gangbang_A1_S4", silent = true, openMouth = true)

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Falmer_Gangbang_A2_S1", 30.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Gangbang_A2_S2", 30.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Gangbang_A2_S3", 30.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Gangbang_A2_S4", 30.0, rotate=180.0)

	int a3 = AddPosition(Creature)
	AddPositionStage(a3, "Falmer_Gangbang_A3_S1", 31.0, rotate=180.0)
	AddPositionStage(a3, "Falmer_Gangbang_A3_S2", 31.0, rotate=180.0)
	AddPositionStage(a3, "Falmer_Gangbang_A3_S3", 31.0, rotate=180.0)
	AddPositionStage(a3, "Falmer_Gangbang_A3_S4", 31.0, rotate=180.0)

	int a4 = AddPosition(Creature)
	AddPositionStage(a4, "Falmer_Gangbang_A4_S1", 32.0, rotate=180.0)
	AddPositionStage(a4, "Falmer_Gangbang_A4_S2", 32.0, rotate=180.0)
	AddPositionStage(a4, "Falmer_Gangbang_A4_S3", 32.0, rotate=180.0)
	AddPositionStage(a4, "Falmer_Gangbang_A4_S4", 32.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Gangbang")
	AddTag("Falmer")

	Save()
endFunction

function FalmerGangbang5P()
	Name = "(Falmer) Gangbang 5P"

	SoundFX = SexMix
	AddRace(FalmerRace)

	int a1 = AddPosition(Female, addCum=VaginalOralAnal)
	AddPositionStage(a1, "Falmer_Gangbang_A1_S1", silent = true, openMouth = true)
	AddPositionStage(a1, "Falmer_Gangbang_A1_S2", silent = true, openMouth = true)
	AddPositionStage(a1, "Falmer_Gangbang_A1_S3", silent = true, openMouth = true)
	AddPositionStage(a1, "Falmer_Gangbang_A1_S4", silent = true, openMouth = true)

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Falmer_Gangbang_A2_S1", 30.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Gangbang_A2_S2", 30.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Gangbang_A2_S3", 30.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Gangbang_A2_S4", 30.0, rotate=180.0)

	int a3 = AddPosition(Creature)
	AddPositionStage(a3, "Falmer_Gangbang_A3_S1", 31.0, rotate=180.0)
	AddPositionStage(a3, "Falmer_Gangbang_A3_S2", 31.0, rotate=180.0)
	AddPositionStage(a3, "Falmer_Gangbang_A3_S3", 31.0, rotate=180.0)
	AddPositionStage(a3, "Falmer_Gangbang_A3_S4", 31.0, rotate=180.0)

	int a4 = AddPosition(Creature)
	AddPositionStage(a4, "Falmer_Gangbang_A4_S1", 32.0, rotate=180.0)
	AddPositionStage(a4, "Falmer_Gangbang_A4_S2", 32.0, rotate=180.0)
	AddPositionStage(a4, "Falmer_Gangbang_A4_S3", 32.0, rotate=180.0)
	AddPositionStage(a4, "Falmer_Gangbang_A4_S4", 32.0, rotate=180.0)

	int a5 = AddPosition(Creature)
	AddPositionStage(a4, "Falmer_Gangbang_A5_S1", 33.0, rotate=180.0)
	AddPositionStage(a4, "Falmer_Gangbang_A5_S2", 33.0, rotate=180.0)
	AddPositionStage(a4, "Falmer_Gangbang_A5_S3", 33.0, rotate=180.0)
	AddPositionStage(a4, "Falmer_Gangbang_A5_S4", 33.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Gangbang")
	AddTag("Falmer")

	Save()
endFunction

function FalmerHolding()
	Name = "(Falmer) Holding"

	SoundFX = Squishing
	AddRace(FalmerRace)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "Falmer_Holding_A1_S1")
	AddPositionStage(a1, "Falmer_Holding_A1_S2")
	AddPositionStage(a1, "Falmer_Holding_A1_S3")
	AddPositionStage(a1, "Falmer_Holding_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Falmer_Holding_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Holding_A2_S2", 35.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Holding_A2_S3", 35.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Holding_A2_S4", 35.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Doggystyle")
	AddTag("Missionary")
	AddTag("Holding")
	AddTag("Gangbang")

	Save()
endFunction

function FalmerMissionary()
	Name = "(Falmer) Missionary"

	SoundFX = Squishing
	AddRace(FalmerRace)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "Falmer_Missionary_A1_S1")
	AddPositionStage(a1, "Falmer_Missionary_A1_S2")
	AddPositionStage(a1, "Falmer_Missionary_A1_S3")
	AddPositionStage(a1, "Falmer_Missionary_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Falmer_Missionary_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Missionary_A2_S2", 35.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Missionary_A2_S3", 35.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Missionary_A2_S4", 35.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Doggystyle")
	AddTag("Missionary")
	AddTag("Holding")
	AddTag("Gangbang")

	Save()
endFunction

function GargoyleDoggystyle()
	Name = "(Gargoyle) Doggystyle"

	SoundFX = Squishing
	AddRace(DLC1GargoyleRace)
	AddRace(DLC1GargoyleVariantBossRace)
	AddRace(DLC1GargoyleVariantGreenRace)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Gargoyle_Doggystyle_A1_S1")
	AddPositionStage(a1, "Gargoyle_Doggystyle_A1_S2")
	AddPositionStage(a1, "Gargoyle_Doggystyle_A1_S3")
	AddPositionStage(a1, "Gargoyle_Doggystyle_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Gargoyle_Doggystyle_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Gargoyle_Doggystyle_A2_S2", 40.0, rotate=180.0)
	AddPositionStage(a2, "Gargoyle_Doggystyle_A2_S3", 40.0, rotate=180.0)
	AddPositionStage(a2, "Gargoyle_Doggystyle_A2_S4", 40.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Doggystyle")
	AddTag("Gargoyle")

	Save()
endFunction

function GargoyleHolding()
	Name = "(Gargoyle) Holding"

	SoundFX = Squishing
	AddRace(DLC1GargoyleRace)
	AddRace(DLC1GargoyleVariantBossRace)
	AddRace(DLC1GargoyleVariantGreenRace)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "Gargoyle_Holding_A1_S1")
	AddPositionStage(a1, "Gargoyle_Holding_A1_S2")
	AddPositionStage(a1, "Gargoyle_Holding_A1_S3")
	AddPositionStage(a1, "Gargoyle_Holding_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Gargoyle_Holding_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Gargoyle_Holding_A2_S2", 40.0, rotate=180.0)
	AddPositionStage(a2, "Gargoyle_Holding_A2_S3", 40.0, rotate=180.0)
	AddPositionStage(a2, "Gargoyle_Holding_A2_S4", 40.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Holding")
	AddTag("Gargoyle")

	Save()
endFunction

function GargoyleMissionary()
	Name = "(Gargoyle) Missionary"

	SoundFX = Squishing
	AddRace(DLC1GargoyleRace)
	AddRace(DLC1GargoyleVariantBossRace)
	AddRace(DLC1GargoyleVariantGreenRace)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "Gargoyle_Missionary_A1_S1")
	AddPositionStage(a1, "Gargoyle_Missionary_A1_S2")
	AddPositionStage(a1, "Gargoyle_Missionary_A1_S3")
	AddPositionStage(a1, "Gargoyle_Missionary_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Gargoyle_Missionary_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Gargoyle_Missionary_A2_S2", 40.0, rotate=180.0)
	AddPositionStage(a2, "Gargoyle_Missionary_A2_S3", 40.0, rotate=180.0)
	AddPositionStage(a2, "Gargoyle_Missionary_A2_S4", 40.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Missionary")
	AddTag("Gargoyle")

	Save()
endFunction

function GiantPenetration()
	Name = "(Giant) Penetration"

	SoundFX = Squishing
	AddRace(GiantRace)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "Giant_Penetration_A1_S1")
	AddPositionStage(a1, "Giant_Penetration_A1_S2")
	AddPositionStage(a1, "Giant_Penetration_A1_S3")
	AddPositionStage(a1, "Giant_Penetration_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Giant_Penetration_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Giant_Penetration_A2_S2", 35.0, rotate=180.0)
	AddPositionStage(a2, "Giant_Penetration_A2_S3", 35.0, rotate=180.0)
	AddPositionStage(a2, "Giant_Penetration_A2_S4", 35.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Holding")
	AddTag("Rough")
	AddTag("Giant")

	Save()
endFunction

function HorseDoggystyle()
	Name = "(Horse) Doggystyle"

	SoundFX = Squishing
	AddRace(HorseRace)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Horse_Doggystyle_A1_S1")
	AddPositionStage(a1, "Horse_Doggystyle_A1_S2")
	AddPositionStage(a1, "Horse_Doggystyle_A1_S3")
	AddPositionStage(a1, "Horse_Doggystyle_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Horse_Doggystyle_A2_S1", 45.0, rotate=180.0)
	AddPositionStage(a2, "Horse_Doggystyle_A2_S2", 45.0, rotate=180.0)
	AddPositionStage(a2, "Horse_Doggystyle_A2_S3", 45.0, rotate=180.0)
	AddPositionStage(a2, "Horse_Doggystyle_A2_S4", 45.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Doggystyle")
	AddTag("Horse")

	Save()
endFunction

function CatDoggystyle()
	Name = "(Sabre Cat) Doggystyle"

	SoundFX = Squishing
	AddRace(SabreCatRace)
	AddRace(SabreCatSnowyRace)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Cat_Doggystyle_A1_S1")
	AddPositionStage(a1, "Cat_Doggystyle_A1_S2")
	AddPositionStage(a1, "Cat_Doggystyle_A1_S3")
	AddPositionStage(a1, "Cat_Doggystyle_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Cat_Doggystyle_A2_S1", 45.0, rotate=180.0)
	AddPositionStage(a2, "Cat_Doggystyle_A2_S2", 45.0, rotate=180.0)
	AddPositionStage(a2, "Cat_Doggystyle_A2_S3", 45.0, rotate=180.0)
	AddPositionStage(a2, "Cat_Doggystyle_A2_S4", 45.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Doggystyle")
	AddTag("Cat")

	Save()
endFunction

function SpiderDouble()
	Name = "(Spider) Double"

	SoundFX = Squishing
	AddRace(FrostbiteSpiderRace)

	int a1 = AddPosition(Female, addCum=VaginalOralAnal)
	AddPositionStage(a1, "Spider_Double_A1_S1")
	AddPositionStage(a1, "Spider_Double_A1_S2")
	AddPositionStage(a1, "Spider_Double_A1_S3")
	AddPositionStage(a1, "Spider_Double_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Spider_Double_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Spider_Double_A2_S2", 35.0, rotate=180.0)
	AddPositionStage(a2, "Spider_Double_A2_S3", 35.0, rotate=180.0)
	AddPositionStage(a2, "Spider_Double_A2_S4", 35.0, rotate=180.0)

	int a3 = AddPosition(Creature)
	AddPositionStage(a3, "Spider_Double_A3_S1", 70.0, rotate=180.0)
	AddPositionStage(a3, "Spider_Double_A3_S2", 70.0, rotate=180.0)
	AddPositionStage(a3, "Spider_Double_A3_S3", 70.0, rotate=180.0)
	AddPositionStage(a3, "Spider_Double_A3_S4", 70.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Gangbang")
	AddTag("Spider")

	Save()
endFunction

function SpiderPenetration()
	Name = "(Spider) Penetration"

	SoundFX = Squishing
	AddRace(FrostbiteSpiderRace)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "Spider_Penetration_A1_S1")
	AddPositionStage(a1, "Spider_Penetration_A1_S2")
	AddPositionStage(a1, "Spider_Penetration_A1_S3")
	AddPositionStage(a1, "Spider_Penetration_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Spider_Penetration_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Spider_Penetration_A2_S2", 35.0, rotate=180.0)
	AddPositionStage(a2, "Spider_Penetration_A2_S3", 35.0, rotate=180.0)
	AddPositionStage(a2, "Spider_Penetration_A2_S4", 35.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Missionary")
	AddTag("Spider")

	Save()
endFunction

function BigSpiderPenetration()
	Name = "(Large Spider) Penetration"

	SoundFX = Squishing
	AddRace(FrostbiteSpiderRaceLarge)
	AddRace(FrostbiteSpiderRaceGiant)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "BigSpider_Penetration_A1_S1")
	AddPositionStage(a1, "BigSpider_Penetration_A1_S2")
	AddPositionStage(a1, "BigSpider_Penetration_A1_S3")
	AddPositionStage(a1, "BigSpider_Penetration_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "BigSpider_Penetration_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "BigSpider_Penetration_A2_S2", 35.0, rotate=180.0)
	AddPositionStage(a2, "BigSpider_Penetration_A2_S3", 35.0, rotate=180.0)
	AddPositionStage(a2, "BigSpider_Penetration_A2_S4", 35.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Rough")
	AddTag("Spider")
	AddTag("Big Spider")

	Save()
endFunction


function TrollDoggystyle()
	Name = "(Troll) Doggystyle"

	SoundFX = Squishing
	AddRace(TrollRace)
	AddRace(TrollFrostRace)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Troll_Doggystyle_A1_S1")
	AddPositionStage(a1, "Troll_Doggystyle_A1_S2")
	AddPositionStage(a1, "Troll_Doggystyle_A1_S3")
	AddPositionStage(a1, "Troll_Doggystyle_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Troll_Doggystyle_A2_S1", 45.0, rotate=180.0)
	AddPositionStage(a2, "Troll_Doggystyle_A2_S2", 45.0, rotate=180.0)
	AddPositionStage(a2, "Troll_Doggystyle_A2_S3", 45.0, rotate=180.0)
	AddPositionStage(a2, "Troll_Doggystyle_A2_S4", 45.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Doggystyle")
	AddTag("Troll")

	Save()
endFunction

function TrollHolding()
	Name = "(Troll) Holding"

	SoundFX = Squishing
	AddRace(TrollRace)
	AddRace(TrollFrostRace)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "Troll_Holding_A1_S1")
	AddPositionStage(a1, "Troll_Holding_A1_S2")
	AddPositionStage(a1, "Troll_Holding_A1_S3")
	AddPositionStage(a1, "Troll_Holding_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Troll_Holding_A2_S1", 45.0, rotate=180.0)
	AddPositionStage(a2, "Troll_Holding_A2_S2", 45.0, rotate=180.0)
	AddPositionStage(a2, "Troll_Holding_A2_S3", 45.0, rotate=180.0)
	AddPositionStage(a2, "Troll_Holding_A2_S4", 45.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Holding")
	AddTag("Troll")

	Save()
endFunction

function TrollMissionary()
	Name = "(Troll) Missionary"

	SoundFX = Squishing
	AddRace(TrollRace)
	AddRace(TrollFrostRace)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "Troll_Missionary_A1_S1")
	AddPositionStage(a1, "Troll_Missionary_A1_S2")
	AddPositionStage(a1, "Troll_Missionary_A1_S3")
	AddPositionStage(a1, "Troll_Missionary_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Troll_Missionary_A2_S1", 45.0, rotate=180.0)
	AddPositionStage(a2, "Troll_Missionary_A2_S2", 45.0, rotate=180.0)
	AddPositionStage(a2, "Troll_Missionary_A2_S3", 45.0, rotate=180.0)
	AddPositionStage(a2, "Troll_Missionary_A2_S4", 45.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Missionary")
	AddTag("Troll")

	Save()
endFunction

function TrollDominate()
	Name = "(Troll) Dominate"

	SoundFX = Squishing
	AddRace(TrollRace)
	AddRace(TrollFrostRace)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "Troll_Dominate_A1_S1")
	AddPositionStage(a1, "Troll_Dominate_A1_S2")
	AddPositionStage(a1, "Troll_Dominate_A1_S3")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Troll_Dominate_A2_S1")
	AddPositionStage(a2, "Troll_Dominate_A2_S2")
	AddPositionStage(a2, "Troll_Dominate_A2_S3")

	AddTag("Panicforever")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Missionary")
	AddTag("Troll")

	Save()
endFunction

function TrollGrabbing()
	Name = "(Troll) Grabbing"

	SoundFX = Squishing
	AddRace(TrollRace)
	AddRace(TrollFrostRace)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "Troll_Grabbing_A1_S1")
	AddPositionStage(a1, "Troll_Grabbing_A1_S2")
	AddPositionStage(a1, "Troll_Grabbing_A1_S3")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Troll_Grabbing_A2_S1")
	AddPositionStage(a2, "Troll_Grabbing_A2_S2")
	AddPositionStage(a2, "Troll_Grabbing_A2_S3")

	AddTag("Panicforever")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Doggystyle")
	AddTag("Troll")

	Save()
endFunction

function VampireLordDoggystyle()
	Name = "(Vampire Lord) Doggystyle"

	SoundFX = Squishing
	AddRace(DLC1VampireBeastRace)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "VampireLord_Doggystyle_A1_S1")
	AddPositionStage(a1, "VampireLord_Doggystyle_A1_S2")
	AddPositionStage(a1, "VampireLord_Doggystyle_A1_S3")
	AddPositionStage(a1, "VampireLord_Doggystyle_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "VampireLord_Doggystyle_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "VampireLord_Doggystyle_A2_S2", 40.0, rotate=180.0)
	AddPositionStage(a2, "VampireLord_Doggystyle_A2_S3", 40.0, rotate=180.0)
	AddPositionStage(a2, "VampireLord_Doggystyle_A2_S4", 40.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Doggystyle")
	AddTag("Vampire Lord")

	Save()
endFunction

function VampireLordHolding()
	Name = "(Vampire Lord) Holding"

	SoundFX = Squishing
	AddRace(DLC1VampireBeastRace)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "VampireLord_Holding_A1_S1")
	AddPositionStage(a1, "VampireLord_Holding_A1_S2")
	AddPositionStage(a1, "VampireLord_Holding_A1_S3")
	AddPositionStage(a1, "VampireLord_Holding_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "VampireLord_Holding_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "VampireLord_Holding_A2_S2", 40.0, rotate=180.0)
	AddPositionStage(a2, "VampireLord_Holding_A2_S3", 40.0, rotate=180.0)
	AddPositionStage(a2, "VampireLord_Holding_A2_S4", 40.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Holding")
	AddTag("Vampire Lord")

	Save()
endFunction

function VampireLordMissionary()
	Name = "(Vampire Lord) Missionary"

	SoundFX = Squishing
	AddRace(DLC1VampireBeastRace)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "VampireLord_Missionary_A1_S1")
	AddPositionStage(a1, "VampireLord_Missionary_A1_S2")
	AddPositionStage(a1, "VampireLord_Missionary_A1_S3")
	AddPositionStage(a1, "VampireLord_Missionary_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "VampireLord_Missionary_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "VampireLord_Missionary_A2_S2", 40.0, rotate=180.0)
	AddPositionStage(a2, "VampireLord_Missionary_A2_S3", 40.0, rotate=180.0)
	AddPositionStage(a2, "VampireLord_Missionary_A2_S4", 40.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Missionary")
	AddTag("Vampire Lord")

	Save()
endFunction

function WerewolfAggrDoggystyle()
	Name = "(Werewolf) Rough Doggystyle"

	SoundFX = Squishing
	AddRace(WerewolfBeastRace)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Werewolf_AggrDoggystyle_A1_S1")
	AddPositionStage(a1, "Werewolf_AggrDoggystyle_A1_S2")
	AddPositionStage(a1, "Werewolf_AggrDoggystyle_A1_S3")
	AddPositionStage(a1, "Werewolf_AggrDoggystyle_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Werewolf_AggrDoggystyle_A2_S1")
	AddPositionStage(a2, "Werewolf_AggrDoggystyle_A2_S2")
	AddPositionStage(a2, "Werewolf_AggrDoggystyle_A2_S3")
	AddPositionStage(a2, "Werewolf_AggrDoggystyle_A2_S4")

	AddTag("Panicforever")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Doggystyle")
	AddTag("Rough")
	AddTag("Werewolf")

	Save()
endFunction

function WerewolfDoggystyle()
	Name = "(Werewolf) Doggystyle"

	SoundFX = Squishing
	AddRace(WerewolfBeastRace)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Werewolf_Doggystyle_A1_S1")
	AddPositionStage(a1, "Werewolf_Doggystyle_A1_S2")
	AddPositionStage(a1, "Werewolf_Doggystyle_A1_S3")
	AddPositionStage(a1, "Werewolf_Doggystyle_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Werewolf_Doggystyle_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Werewolf_Doggystyle_A2_S2", 40.0, rotate=180.0)
	AddPositionStage(a2, "Werewolf_Doggystyle_A2_S3", 40.0, rotate=180.0)
	AddPositionStage(a2, "Werewolf_Doggystyle_A2_S4", 40.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Doggystyle")
	AddTag("Rough")
	AddTag("Werewolf")

	Save()
endFunction

function WerewolfHolding()
	Name = "(Werewolf) Holding"

	SoundFX = Squishing
	AddRace(WerewolfBeastRace)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "Werewolf_Holding_A1_S1")
	AddPositionStage(a1, "Werewolf_Holding_A1_S2")
	AddPositionStage(a1, "Werewolf_Holding_A1_S3")
	AddPositionStage(a1, "Werewolf_Holding_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Werewolf_Holding_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Werewolf_Holding_A2_S2", 40.0, rotate=180.0)
	AddPositionStage(a2, "Werewolf_Holding_A2_S3", 40.0, rotate=180.0)
	AddPositionStage(a2, "Werewolf_Holding_A2_S4", 40.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Holding")
	AddTag("Rough")
	AddTag("Werewolf")

	Save()
endFunction

function WerewolfMissionary()
	Name = "(Werewolf) Missionary"

	SoundFX = Squishing
	AddRace(WerewolfBeastRace)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "Werewolf_Missionary_A1_S1")
	AddPositionStage(a1, "Werewolf_Missionary_A1_S2")
	AddPositionStage(a1, "Werewolf_Missionary_A1_S3")
	AddPositionStage(a1, "Werewolf_Missionary_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Werewolf_Missionary_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Werewolf_Missionary_A2_S2", 40.0, rotate=180.0)
	AddPositionStage(a2, "Werewolf_Missionary_A2_S3", 40.0, rotate=180.0)
	AddPositionStage(a2, "Werewolf_Missionary_A2_S4", 40.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Missionary")
	AddTag("Rough")
	AddTag("Werewolf")

	Save()
endFunction

function WolfDoggystyle()
	Name = "(Wolf) Doggystyle"

	SoundFX = Squishing
	AddRace(WolfRace)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Canine_Doggystyle_A1_S1")
	AddPositionStage(a1, "Canine_Doggystyle_A1_S2")
	AddPositionStage(a1, "Canine_Doggystyle_A1_S3")
	AddPositionStage(a1, "Canine_Doggystyle_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Wolf_Doggystyle_A2_S1", 45.0, rotate=180.0)
	AddPositionStage(a2, "Wolf_Doggystyle_A2_S2", 45.0, rotate=180.0)
	AddPositionStage(a2, "Wolf_Doggystyle_A2_S3", 45.0, rotate=180.0)
	AddPositionStage(a2, "Wolf_Doggystyle_A2_S4", 45.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Doggystyle")
	AddTag("Wolf")

	Save()
endFunction

function WolfDoggystyle2()
	Name = "(Wolf) Doggystyle 2"

	SoundFX = Squishing
	AddRace(WolfRace)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Canine_Doggystyle2_A1_S1")
	AddPositionStage(a1, "Canine_Doggystyle2_A1_S2")
	AddPositionStage(a1, "Canine_Doggystyle2_A1_S3")
	AddPositionStage(a1, "Canine_Doggystyle2_A1_S4")
	AddPositionStage(a1, "Canine_Doggystyle2_A1_S5")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Wolf_Doggystyle2_A2_S1")
	AddPositionStage(a2, "Wolf_Doggystyle2_A2_S2")
	AddPositionStage(a2, "Wolf_Doggystyle2_A2_S3")
	AddPositionStage(a2, "Wolf_Doggystyle2_A2_S4")
	AddPositionStage(a2, "Wolf_Doggystyle2_A2_S5")

	AddTag("Panicforever")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Doggystyle")
	AddTag("Wolf")

	Save()
endFunction

function WolfMissionary()
	Name = "(Wolf) Missionary"

	SoundFX = Squishing
	AddRace(WolfRace)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "Canine_Missionary_A1_S1")
	AddPositionStage(a1, "Canine_Missionary_A1_S2")
	AddPositionStage(a1, "Canine_Missionary_A1_S3")
	AddPositionStage(a1, "Canine_Missionary_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Wolf_Missionary_A2_S1", 45.0, rotate=180.0)
	AddPositionStage(a2, "Wolf_Missionary_A2_S2", 45.0, rotate=180.0)
	AddPositionStage(a2, "Wolf_Missionary_A2_S3", 45.0, rotate=180.0)
	AddPositionStage(a2, "Wolf_Missionary_A2_S4", 45.0, rotate=180.0)

	AddTag("Gone")
	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Missionary")
	AddTag("Wolf")

	Save()
endFunction
