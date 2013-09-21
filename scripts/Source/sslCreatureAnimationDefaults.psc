scriptname sslCreatureAnimationDefaults extends sslCreatureAnimationFactory

Race property BearBlackRace auto
Race property BearBrownRace auto
Race property BearSnowRace auto
Race property SabreCatRace auto
Race property SabreCatSnowyRace auto
Race property ChaurusRace auto
Race property ChaurusReaperRace auto
Race property DragonRace auto
Race property UndeadDragonRace auto
Race property DraugrRace auto
Race property DraugrMagicRace auto
Race property FalmerRace auto
Race property GiantRace auto
Race property HorseRace auto
Race property FrostbiteSpiderRace auto
Race property FrostbiteSpiderRaceGiant auto
Race property FrostbiteSpiderRaceLarge auto
Race property TrollRace auto
Race property WerewolfBeastRace auto
Race property WolfRace auto

bool dawnguard
Race DLC1VampireBeastRace
Race DLC1GargoyleRace
Race DLC1GargoyleVariantBossRace
Race DLC1GargoyleVariantGreenRace

bool dragonborn
Race DLC2SeekerRace

function DLCLoad()
	dawnguard = false
	dragonborn = false
	int mods = Game.GetModCount()
	int i 
	while i < mods
		string modname = Game.GetModName(i)
		if !dawnguard && modname == "Dawnguard.esm"
			dawnguard = true
			DLC1VampireBeastRace = Game.GetFormFromFile(0x283A, "Dawnguard.esm") as Race
			DLC1GargoyleRace = Game.GetFormFromFile(0xA2C6, "Dawnguard.esm") as Race
			DLC1GargoyleVariantBossRace = Game.GetFormFromFile(0x10D00, "Dawnguard.esm") as Race
			DLC1GargoyleVariantGreenRace = Game.GetFormFromFile(0x19D86, "Dawnguard.esm") as Race
		elseif !dragonborn && modname == "Dragonborn.esm"
			dragonborn = true
			DLC2SeekerRace = Game.GetFormFromFile(0x1DCB9, "Dragonborn.esm") as Race
		elseif dawnguard && dragonborn
			return
		endIf
		i += 1
	endwhile
endFunction

function LoadAnimations()
	DLCLoad()
	RegisterAnimation("BearDoggystyle")

	RegisterAnimation("CatDoggystyle")

	RegisterAnimation("ChaurusForward")
	RegisterAnimation("ChaurusReverse")

	RegisterAnimation("DragonPenetration")
	RegisterAnimation("DragonTongue")

	RegisterAnimation("DraugrDoggystyle")
	RegisterAnimation("DraugrGangbang")
	RegisterAnimation("DraugrHolding")
	RegisterAnimation("DraugrMissionary")

	RegisterAnimation("FalmerDoggystyle")
	RegisterAnimation("FalmerGangbang")
	RegisterAnimation("FalmerHolding")
	RegisterAnimation("FalmerMissionary")

	RegisterAnimation("GiantPenetration")

	RegisterAnimation("HorseDoggystyle")

	RegisterAnimation("SpiderDouble")
	RegisterAnimation("SpiderPenetration")
	RegisterAnimation("BigSpiderPenetration")

	RegisterAnimation("TrollDoggystyle")
	RegisterAnimation("TrollHolding")
	RegisterAnimation("TrollMissionary")

	RegisterAnimation("WerewolfDoggystyle")
	RegisterAnimation("WerewolfHolding")
	RegisterAnimation("WerewolfMissionary")

	RegisterAnimation("WolfDoggystyle")
	RegisterAnimation("WolfMissionary")

	if dawnguard
		RegisterAnimation("GargoyleDoggystyle")
		RegisterAnimation("GargoyleHolding")
		RegisterAnimation("GargoyleMissionary")
		RegisterAnimation("VampireLordDoggystyle")
		RegisterAnimation("VampireLordHolding")
		RegisterAnimation("VampireLordMissionary")
	endIf

	if dragonborn
		RegisterAnimation("DaedraHugging")
	endIf

endFunction

function BearDoggystyle(string eventName, string id, float argNum, form sender)
	Name = "(Bear) Doggystyle"
	SetSFX(Squishing)

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
	AddPositionStage(a2, "Bear_Doggystyle_A2_S1", 45.0, rotate=180.0)
	AddPositionStage(a2, "Bear_Doggystyle_A2_S1", 45.0, rotate=180.0)
	AddPositionStage(a2, "Bear_Doggystyle_A2_S1", 45.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Doggystyle")
	AddTag("Bear")

	Save()
endFunction

function CatDoggystyle(string eventName, string id, float argNum, form sender)
	Name = "(Sabre Cat) Doggystyle"
	SetSFX(Squishing)

	AddRace(SabreCatRace)
	AddRace(SabreCatSnowyRace)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Cat_Doggystyle_A1_S1")
	AddPositionStage(a1, "Cat_Doggystyle_A1_S2")
	AddPositionStage(a1, "Cat_Doggystyle_A1_S3")
	AddPositionStage(a1, "Cat_Doggystyle_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Cat_Doggystyle_A2_S1", 45.0, rotate=180.0)
	AddPositionStage(a2, "Cat_Doggystyle_A2_S1", 45.0, rotate=180.0)
	AddPositionStage(a2, "Cat_Doggystyle_A2_S1", 45.0, rotate=180.0)
	AddPositionStage(a2, "Cat_Doggystyle_A2_S1", 45.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Doggystyle")
	AddTag("Cat")

	Save()
endFunction

function ChaurusForward(string eventName, string id, float argNum, form sender)
	Name = "(Chaurus) Forward"
	SetSFX(Squishing)

	AddRace(ChaurusRace)
	AddRace(ChaurusReaperRace)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Chaurus_Forward_A1_S1")
	AddPositionStage(a1, "Chaurus_Forward_A1_S2")
	AddPositionStage(a1, "Chaurus_Forward_A1_S3")
	AddPositionStage(a1, "Chaurus_Forward_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Chaurus_Forward_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Chaurus_Forward_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Chaurus_Forward_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Chaurus_Forward_A2_S1", 40.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Holding")
	AddTag("Chaurus")

	Save()
endFunction

function ChaurusReverse(string eventName, string id, float argNum, form sender)
	Name = "(Chaurus) Reverse"
	SetSFX(Squishing)

	AddRace(ChaurusRace)
	AddRace(ChaurusReaperRace)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "Chaurus_Reverse_A1_S1")
	AddPositionStage(a1, "Chaurus_Reverse_A1_S2")
	AddPositionStage(a1, "Chaurus_Reverse_A1_S3")
	AddPositionStage(a1, "Chaurus_Reverse_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Chaurus_Reverse_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Chaurus_Reverse_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Chaurus_Reverse_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Chaurus_Reverse_A2_S1", 40.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Holding")
	AddTag("Chaurus")

	Save()
endFunction

function DaedraHugging(string eventName, string id, float argNum, form sender)
	Name = "(Daedra) Hugging"
	SetSFX(Squishing)

	AddRace(DLC2SeekerRace)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "Daedra_Hugging_A1_S1")
	AddPositionStage(a1, "Daedra_Hugging_A1_S2")
	AddPositionStage(a1, "Daedra_Hugging_A1_S3")
	AddPositionStage(a1, "Daedra_Hugging_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Daedra_Hugging_A2_S1", 45.0, rotate=180.0)
	AddPositionStage(a2, "Daedra_Hugging_A2_S1", 45.0, rotate=180.0)
	AddPositionStage(a2, "Daedra_Hugging_A2_S1", 45.0, rotate=180.0)
	AddPositionStage(a2, "Daedra_Hugging_A2_S1", 45.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Holding")
	AddTag("Hugging")
	AddTag("Daedra")

	Save()
endFunction

function DragonPenetration(string eventName, string id, float argNum, form sender)
	Name = "(Dragon) Penetration"
	SetSFX(Squishing)

	AddRace(DragonRace)
	AddRace(UndeadDragonRace)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "Dragon_Penetration_A1_S1")
	AddPositionStage(a1, "Dragon_Penetration_A1_S2")
	AddPositionStage(a1, "Dragon_Penetration_A1_S3")
	AddPositionStage(a1, "Dragon_Penetration_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Dragon_Penetration_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Dragon_Penetration_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Dragon_Penetration_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Dragon_Penetration_A2_S1", 35.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Oral")
	AddTag("Dragon")

	Save()
endFunction

function DragonTongue(string eventName, string id, float argNum, form sender)
	Name = "(Dragon) Tongue"
	SetSFX(Squishing)

	AddRace(DragonRace)
	AddRace(UndeadDragonRace)

	int a1 = AddPosition(Female)
	AddPositionStage(a1, "Dragon_Tongue_A1_S1")
	AddPositionStage(a1, "Dragon_Tongue_A1_S2")
	AddPositionStage(a1, "Dragon_Tongue_A1_S3")
	AddPositionStage(a1, "Dragon_Tongue_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Dragon_Tongue_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Dragon_Tongue_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Dragon_Tongue_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Dragon_Tongue_A2_S1", 35.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Missionary")
	AddTag("Dragon")

	Save()
endFunction

function DraugrDoggystyle(string eventName, string id, float argNum, form sender)
	Name = "(Draugr) Doggystyle"
	SetSFX(Squishing)

	AddRace(DraugrRace)
	AddRace(DraugrMagicRace)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Draugr_Doggystyle_A1_S1")
	AddPositionStage(a1, "Draugr_Doggystyle_A1_S2")
	AddPositionStage(a1, "Draugr_Doggystyle_A1_S3")
	AddPositionStage(a1, "Draugr_Doggystyle_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Draugr_Doggystyle_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Doggystyle_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Doggystyle_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Doggystyle_A2_S1", 35.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Doggystyle")
	AddTag("Draugr")

	Save()
endFunction

function DraugrGangbang(string eventName, string id, float argNum, form sender)
	Name = "(Draugr) Gangbang"
	SetSFX(Squishing)

	AddRace(DraugrRace)
	AddRace(DraugrMagicRace)

	int a1 = AddPosition(Female, addCum=VaginalOralAnal)
	AddPositionStage(a1, "Draugr_Gangbang_A1_S1")
	AddPositionStage(a1, "Draugr_Gangbang_A1_S2")
	AddPositionStage(a1, "Draugr_Gangbang_A1_S3")
	AddPositionStage(a1, "Draugr_Gangbang_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Draugr_Gangbang_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Gangbang_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Gangbang_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Gangbang_A2_S1", 35.0, rotate=180.0)

	int a3 = AddPosition(Creature)
	AddPositionStage(a3, "Draugr_Gangbang_A3_S1", 45.0, rotate=180.0)
	AddPositionStage(a3, "Draugr_Gangbang_A3_S1", 45.0, rotate=180.0)
	AddPositionStage(a3, "Draugr_Gangbang_A3_S1", 45.0, rotate=180.0)
	AddPositionStage(a3, "Draugr_Gangbang_A3_S1", 45.0, rotate=180.0)

	int a4 = AddPosition(Creature)
	AddPositionStage(a4, "Draugr_Gangbang_A4_S1", 55.0, rotate=180.0)
	AddPositionStage(a4, "Draugr_Gangbang_A4_S1", 55.0, rotate=180.0)
	AddPositionStage(a4, "Draugr_Gangbang_A4_S1", 55.0, rotate=180.0)
	AddPositionStage(a4, "Draugr_Gangbang_A4_S1", 55.0, rotate=180.0)

	int a5 = AddPosition(Creature)
	AddPositionStage(a5, "Draugr_Gangbang_A5_S1", 65.0, rotate=180.0)
	AddPositionStage(a5, "Draugr_Gangbang_A5_S1", 65.0, rotate=180.0)
	AddPositionStage(a5, "Draugr_Gangbang_A5_S1", 65.0, rotate=180.0)
	AddPositionStage(a5, "Draugr_Gangbang_A5_S1", 65.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Gangbang")
	AddTag("Draugr")

	Save()
endFunction

function DraugrHolding(string eventName, string id, float argNum, form sender)
	Name = "(Draugr) Holding"
	SetSFX(Squishing)

	AddRace(DraugrRace)
	AddRace(DraugrMagicRace)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Draugr_Holding_A1_S1")
	AddPositionStage(a1, "Draugr_Holding_A1_S2")
	AddPositionStage(a1, "Draugr_Holding_A1_S3")
	AddPositionStage(a1, "Draugr_Holding_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Draugr_Holding_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Holding_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Holding_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Holding_A2_S1", 35.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Holding")
	AddTag("Draugr")

	Save()
endFunction

function DraugrMissionary(string eventName, string id, float argNum, form sender)
	Name = "(Draugr) Missionary"
	SetSFX(Squishing)

	AddRace(DraugrRace)
	AddRace(DraugrMagicRace)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "Draugr_Missionary_A1_S1")
	AddPositionStage(a1, "Draugr_Missionary_A1_S2")
	AddPositionStage(a1, "Draugr_Missionary_A1_S3")
	AddPositionStage(a1, "Draugr_Missionary_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Draugr_Missionary_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Missionary_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Missionary_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Draugr_Missionary_A2_S1", 35.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Missionary")
	AddTag("Draugr")

	Save()
endFunction

function FalmerDoggystyle(string eventName, string id, float argNum, form sender)
	Name = "(Falmer) Doggystyle"
	SetSFX(Squishing)

	AddRace(FalmerRace)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Falmer_Doggystyle_A1_S1")
	AddPositionStage(a1, "Falmer_Doggystyle_A1_S2")
	AddPositionStage(a1, "Falmer_Doggystyle_A1_S3")
	AddPositionStage(a1, "Falmer_Doggystyle_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Falmer_Doggystyle_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Doggystyle_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Doggystyle_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Doggystyle_A2_S1", 35.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Doggystyle")
	AddTag("Falmer")

	Save()
endFunction

function FalmerGangbang(string eventName, string id, float argNum, form sender)
	Name = "(Falmer) Gangbang"
	SetSFX(Squishing)

	AddRace(FalmerRace)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Falmer_Gangbang_A1_S1")
	AddPositionStage(a1, "Falmer_Gangbang_A1_S2")
	AddPositionStage(a1, "Falmer_Gangbang_A1_S3")
	AddPositionStage(a1, "Falmer_Gangbang_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Falmer_Gangbang_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Gangbang_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Gangbang_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Gangbang_A2_S1", 35.0, rotate=180.0)

	int a3 = AddPosition(Creature)
	AddPositionStage(a3, "Falmer_Gangbang_A3_S1", 35.0, rotate=180.0)
	AddPositionStage(a3, "Falmer_Gangbang_A3_S1", 35.0, rotate=180.0)
	AddPositionStage(a3, "Falmer_Gangbang_A3_S1", 35.0, rotate=180.0)
	AddPositionStage(a3, "Falmer_Gangbang_A3_S1", 35.0, rotate=180.0)

	int a4 = AddPosition(Creature)
	AddPositionStage(a4, "Falmer_Gangbang_A4_S1", 35.0, rotate=180.0)
	AddPositionStage(a4, "Falmer_Gangbang_A4_S1", 35.0, rotate=180.0)
	AddPositionStage(a4, "Falmer_Gangbang_A4_S1", 35.0, rotate=180.0)
	AddPositionStage(a4, "Falmer_Gangbang_A4_S1", 35.0, rotate=180.0)

	int a5 = AddPosition(Creature)
	AddPositionStage(a5, "Falmer_Gangbang_A5_S1", 35.0, rotate=180.0)
	AddPositionStage(a5, "Falmer_Gangbang_A5_S1", 35.0, rotate=180.0)
	AddPositionStage(a5, "Falmer_Gangbang_A5_S1", 35.0, rotate=180.0)
	AddPositionStage(a5, "Falmer_Gangbang_A5_S1", 35.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Gangbang")
	AddTag("Falmer")

	Save()
endFunction

function FalmerHolding(string eventName, string id, float argNum, form sender)
	Name = "(Falmer) Holding"
	SetSFX(Squishing)

	AddRace(FalmerRace)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "Falmer_Holding_A1_S1")
	AddPositionStage(a1, "Falmer_Holding_A1_S2")
	AddPositionStage(a1, "Falmer_Holding_A1_S3")
	AddPositionStage(a1, "Falmer_Holding_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Falmer_Holding_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Holding_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Holding_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Holding_A2_S1", 35.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Doggystyle")
	AddTag("Missionary")
	AddTag("Holding")
	AddTag("Gangbang")

	Save()
endFunction

function FalmerMissionary(string eventName, string id, float argNum, form sender)
	Name = "(Falmer) Missionary"
	SetSFX(Squishing)

	AddRace(FalmerRace)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "Falmer_Missionary_A1_S1")
	AddPositionStage(a1, "Falmer_Missionary_A1_S2")
	AddPositionStage(a1, "Falmer_Missionary_A1_S3")
	AddPositionStage(a1, "Falmer_Missionary_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Falmer_Missionary_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Missionary_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Missionary_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Falmer_Missionary_A2_S1", 35.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Doggystyle")
	AddTag("Missionary")
	AddTag("Holding")
	AddTag("Gangbang")

	Save()
endFunction

function GargoyleDoggystyle(string eventName, string id, float argNum, form sender)
	Name = "(Gargoyle) Doggystyle"
	SetSFX(Squishing)

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
	AddPositionStage(a2, "Gargoyle_Doggystyle_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Gargoyle_Doggystyle_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Gargoyle_Doggystyle_A2_S1", 40.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Doggystyle")
	AddTag("Gargoyle")

	Save()
endFunction

function GargoyleHolding(string eventName, string id, float argNum, form sender)
	Name = "(Gargoyle) Holding"
	SetSFX(Squishing)

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
	AddPositionStage(a2, "Gargoyle_Holding_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Gargoyle_Holding_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Gargoyle_Holding_A2_S1", 40.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Holding")
	AddTag("Gargoyle")

	Save()
endFunction

function GargoyleMissionary(string eventName, string id, float argNum, form sender)
	Name = "(Gargoyle) Missionary"
	SetSFX(Squishing)

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
	AddPositionStage(a2, "Gargoyle_Missionary_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Gargoyle_Missionary_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Gargoyle_Missionary_A2_S1", 40.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Missionary")
	AddTag("Gargoyle")

	Save()
endFunction

function GiantPenetration(string eventName, string id, float argNum, form sender)
	Name = "(Giant) Penetration"
	SetSFX(Squishing)

	AddRace(GiantRace)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "Giant_Penetration_A1_S1")
	AddPositionStage(a1, "Giant_Penetration_A1_S2")
	AddPositionStage(a1, "Giant_Penetration_A1_S3")
	AddPositionStage(a1, "Giant_Penetration_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Giant_Penetration_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Giant_Penetration_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Giant_Penetration_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Giant_Penetration_A2_S1", 35.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Holding")
	AddTag("Rough")
	AddTag("Giant")

	Save()
endFunction

function HorseDoggystyle(string eventName, string id, float argNum, form sender)
	Name = "(Horse) Doggystyle"
	SetSFX(Squishing)

	AddRace(HorseRace)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Horse_Doggystyle_A1_S1")
	AddPositionStage(a1, "Horse_Doggystyle_A1_S2")
	AddPositionStage(a1, "Horse_Doggystyle_A1_S3")
	AddPositionStage(a1, "Horse_Doggystyle_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Horse_Doggystyle_A2_S1", 45.0, rotate=180.0)
	AddPositionStage(a2, "Horse_Doggystyle_A2_S1", 45.0, rotate=180.0)
	AddPositionStage(a2, "Horse_Doggystyle_A2_S1", 45.0, rotate=180.0)
	AddPositionStage(a2, "Horse_Doggystyle_A2_S1", 45.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Doggystyle")
	AddTag("Horse")

	Save()
endFunction

function SpiderDouble(string eventName, string id, float argNum, form sender)
	Name = "(Spider) Double"
	SetSFX(Squishing)

	AddRace(FrostbiteSpiderRace)

	int a1 = AddPosition(Female, addCum=VaginalOralAnal)
	AddPositionStage(a1, "Spider_Double_A1_S1")
	AddPositionStage(a1, "Spider_Double_A1_S2")
	AddPositionStage(a1, "Spider_Double_A1_S3")
	AddPositionStage(a1, "Spider_Double_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Spider_Double_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Spider_Double_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Spider_Double_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Spider_Double_A2_S1", 35.0, rotate=180.0)

	int a3 = AddPosition(Creature)
	AddPositionStage(a3, "Spider_Double_A3_S1", -35.0, rotate=180.0)
	AddPositionStage(a3, "Spider_Double_A3_S1", -35.0, rotate=180.0)
	AddPositionStage(a3, "Spider_Double_A3_S1", -35.0, rotate=180.0)
	AddPositionStage(a3, "Spider_Double_A3_S1", -35.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Gangbang")
	AddTag("Spider")

	Save()
endFunction

function SpiderPenetration(string eventName, string id, float argNum, form sender)
	Name = "(Spider) Penetration"
	SetSFX(Squishing)

	AddRace(FrostbiteSpiderRace)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "Spider_Penetration_A1_S1")
	AddPositionStage(a1, "Spider_Penetration_A1_S2")
	AddPositionStage(a1, "Spider_Penetration_A1_S3")
	AddPositionStage(a1, "Spider_Penetration_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Spider_Penetration_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Spider_Penetration_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Spider_Penetration_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "Spider_Penetration_A2_S1", 35.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Missionary")
	AddTag("Spider")

	Save()
endFunction

function BigSpiderPenetration(string eventName, string id, float argNum, form sender)
	Name = "(Large Spider) Penetration"
	SetSFX(Squishing)

	AddRace(FrostbiteSpiderRaceLarge)
	AddRace(FrostbiteSpiderRaceGiant)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "BigSpider_Penetration_A1_S1")
	AddPositionStage(a1, "BigSpider_Penetration_A1_S2")
	AddPositionStage(a1, "BigSpider_Penetration_A1_S3")
	AddPositionStage(a1, "BigSpider_Penetration_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "BigSpider_Penetration_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "BigSpider_Penetration_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "BigSpider_Penetration_A2_S1", 35.0, rotate=180.0)
	AddPositionStage(a2, "BigSpider_Penetration_A2_S1", 35.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Rough")
	AddTag("Spider")
	AddTag("Big Spider")

	Save()
endFunction


function TrollDoggystyle(string eventName, string id, float argNum, form sender)
	Name = "(Troll) Doggystyle"
	SetSFX(Squishing)

	AddRace(TrollRace)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Troll_Doggystyle_A1_S1")
	AddPositionStage(a1, "Troll_Doggystyle_A1_S2")
	AddPositionStage(a1, "Troll_Doggystyle_A1_S3")
	AddPositionStage(a1, "Troll_Doggystyle_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Troll_Doggystyle_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Troll_Doggystyle_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Troll_Doggystyle_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Troll_Doggystyle_A2_S1", 40.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Doggystyle")
	AddTag("Troll")

	Save()
endFunction

function TrollHolding(string eventName, string id, float argNum, form sender)
	Name = "(Troll) Holding"
	SetSFX(Squishing)

	AddRace(TrollRace)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "Troll_Holding_A1_S1")
	AddPositionStage(a1, "Troll_Holding_A1_S2")
	AddPositionStage(a1, "Troll_Holding_A1_S3")
	AddPositionStage(a1, "Troll_Holding_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Troll_Holding_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Troll_Holding_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Troll_Holding_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Troll_Holding_A2_S1", 40.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Holding")
	AddTag("Troll")

	Save()
endFunction

function TrollMissionary(string eventName, string id, float argNum, form sender)
	Name = "(Troll) Missionary"
	SetSFX(Squishing)

	AddRace(TrollRace)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "Troll_Missionary_A1_S1")
	AddPositionStage(a1, "Troll_Missionary_A1_S2")
	AddPositionStage(a1, "Troll_Missionary_A1_S3")
	AddPositionStage(a1, "Troll_Missionary_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Troll_Missionary_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Troll_Missionary_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Troll_Missionary_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Troll_Missionary_A2_S1", 40.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Missionary")
	AddTag("Troll")

	Save()
endFunction


function VampireLordDoggystyle(string eventName, string id, float argNum, form sender)
	Name = "(Vampire Lord) Doggystyle"
	SetSFX(Squishing)

	AddRace(DLC1VampireBeastRace)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "VampireLord_Doggystyle_A1_S1")
	AddPositionStage(a1, "VampireLord_Doggystyle_A1_S2")
	AddPositionStage(a1, "VampireLord_Doggystyle_A1_S3")
	AddPositionStage(a1, "VampireLord_Doggystyle_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "VampireLord_Doggystyle_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "VampireLord_Doggystyle_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "VampireLord_Doggystyle_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "VampireLord_Doggystyle_A2_S1", 40.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Doggystyle")
	AddTag("Vampire Lord")

	Save()
endFunction

function VampireLordHolding(string eventName, string id, float argNum, form sender)
	Name = "(Vampire Lord) Holding"
	SetSFX(Squishing)

	AddRace(DLC1VampireBeastRace)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "VampireLord_Holding_A1_S1")
	AddPositionStage(a1, "VampireLord_Holding_A1_S2")
	AddPositionStage(a1, "VampireLord_Holding_A1_S3")
	AddPositionStage(a1, "VampireLord_Holding_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "VampireLord_Holding_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "VampireLord_Holding_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "VampireLord_Holding_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "VampireLord_Holding_A2_S1", 40.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Holding")
	AddTag("Vampire Lord")

	Save()
endFunction

function VampireLordMissionary(string eventName, string id, float argNum, form sender)
	Name = "(Vampire Lord) Missionary"
	SetSFX(Squishing)

	AddRace(DLC1VampireBeastRace)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "VampireLord_Missionary_A1_S1")
	AddPositionStage(a1, "VampireLord_Missionary_A1_S2")
	AddPositionStage(a1, "VampireLord_Missionary_A1_S3")
	AddPositionStage(a1, "VampireLord_Missionary_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "VampireLord_Missionary_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "VampireLord_Missionary_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "VampireLord_Missionary_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "VampireLord_Missionary_A2_S1", 40.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Missionary")
	AddTag("Vampire Lord")

	Save()
endFunction

function WerewolfDoggystyle(string eventName, string id, float argNum, form sender)
	Name = "(Werewolf) Doggystyle"
	SetSFX(Squishing)

	AddRace(WerewolfBeastRace)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Werewolf_Doggystyle_A1_S1")
	AddPositionStage(a1, "Werewolf_Doggystyle_A1_S2")
	AddPositionStage(a1, "Werewolf_Doggystyle_A1_S3")
	AddPositionStage(a1, "Werewolf_Doggystyle_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Werewolf_Doggystyle_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Werewolf_Doggystyle_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Werewolf_Doggystyle_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Werewolf_Doggystyle_A2_S1", 40.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Doggystyle")
	AddTag("Rough")
	AddTag("Werewolf")

	Save()
endFunction

function WerewolfHolding(string eventName, string id, float argNum, form sender)
	Name = "(Werewolf) Holding"
	SetSFX(Squishing)

	AddRace(WerewolfBeastRace)

	int a1 = AddPosition(Female, addCum=VaginalAnal)
	AddPositionStage(a1, "Werewolf_Holding_A1_S1")
	AddPositionStage(a1, "Werewolf_Holding_A1_S2")
	AddPositionStage(a1, "Werewolf_Holding_A1_S3")
	AddPositionStage(a1, "Werewolf_Holding_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Werewolf_Holding_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Werewolf_Holding_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Werewolf_Holding_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Werewolf_Holding_A2_S1", 40.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Holding")
	AddTag("Rough")
	AddTag("Werewolf")

	Save()
endFunction

function WerewolfMissionary(string eventName, string id, float argNum, form sender)
	Name = "(Werewolf) Missionary"
	SetSFX(Squishing)

	AddRace(WerewolfBeastRace)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "Werewolf_Missionary_A1_S1")
	AddPositionStage(a1, "Werewolf_Missionary_A1_S2")
	AddPositionStage(a1, "Werewolf_Missionary_A1_S3")
	AddPositionStage(a1, "Werewolf_Missionary_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Werewolf_Missionary_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Werewolf_Missionary_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Werewolf_Missionary_A2_S1", 40.0, rotate=180.0)
	AddPositionStage(a2, "Werewolf_Missionary_A2_S1", 40.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Missionary")
	AddTag("Rough")
	AddTag("Werewolf")

	Save()
endFunction

function WolfDoggystyle(string eventName, string id, float argNum, form sender)
	Name = "(Wolf) Doggystyle"
	SetSFX(Squishing)

	AddRace(WolfRace)

	int a1 = AddPosition(Female, addCum=Anal)
	AddPositionStage(a1, "Wolf_Doggystyle_A1_S1")
	AddPositionStage(a1, "Wolf_Doggystyle_A1_S2")
	AddPositionStage(a1, "Wolf_Doggystyle_A1_S3")
	AddPositionStage(a1, "Wolf_Doggystyle_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Wolf_Doggystyle_A2_S1", 45.0, rotate=180.0)
	AddPositionStage(a2, "Wolf_Doggystyle_A2_S1", 45.0, rotate=180.0)
	AddPositionStage(a2, "Wolf_Doggystyle_A2_S1", 45.0, rotate=180.0)
	AddPositionStage(a2, "Wolf_Doggystyle_A2_S1", 45.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Doggystyle")
	AddTag("Wolf")

	Save()
endFunction

function WolfMissionary(string eventName, string id, float argNum, form sender)
	Name = "(Wolf) Missionary"
	SetSFX(Squishing)

	AddRace(WolfRace)

	int a1 = AddPosition(Female, addCum=Vaginal)
	AddPositionStage(a1, "Wolf_Missionary_A1_S1")
	AddPositionStage(a1, "Wolf_Missionary_A1_S2")
	AddPositionStage(a1, "Wolf_Missionary_A1_S3")
	AddPositionStage(a1, "Wolf_Missionary_A1_S4")

	int a2 = AddPosition(Creature)
	AddPositionStage(a2, "Wolf_Missionary_A2_S1", 45.0, rotate=180.0)
	AddPositionStage(a2, "Wolf_Missionary_A2_S1", 45.0, rotate=180.0)
	AddPositionStage(a2, "Wolf_Missionary_A2_S1", 45.0, rotate=180.0)
	AddPositionStage(a2, "Wolf_Missionary_A2_S1", 45.0, rotate=180.0)

	AddTag("Creature")
	AddTag("Bestiality")
	AddTag("Dirty")
	AddTag("Missionary")
	AddTag("Wolf")

	Save()
endFunction
