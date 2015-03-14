scriptname sslCreatureAnimationSlots extends sslAnimationSlots

; ------------------------------------------------------- ;
; --- Creature aniamtion support                      --- ;
; ------------------------------------------------------- ;

string function GetRaceKey(Race RaceRef) global native
string function GetRaceKeyByID(string RaceID) global native
function AddRaceID(string RaceKey, string RaceID) global native
bool function HasRaceID(string RaceKey, string RaceID) global native
bool function HasRaceKey(string RaceKey) global native
bool function ClearRaceKey(string RaceKey) global native
bool function HasRaceIDType(string RaceID) global native
bool function HasCreatureType(Actor ActorRef) global native
bool function HasRaceType(Race RaceRef) global native
string[] function GetAllRaceKeys() global native
string[] function GetAllRaceIDs(string RaceKey) global native

; TODO: Make native
string[] function GetRaceTypes(Race RaceRef) global
	string RaceID = MiscUtil.GetRaceEditorID(RaceRef)
	string[] RaceKeys = GetAllRaceKeys()
	string[] Output
	int i = RaceKeys.Length
	while i
		i -= 1
		if HasRaceID(RaceKeys[i], RaceID)
			Output = PapyrusUtil.PushString(Output, RaceKeys[i])
		endIf
	endWhile
	return Output
endFunction

sslBaseAnimation[] function GetByRace(int ActorCount, Race RaceRef)
	string[] RaceTypes = GetRaceTypes(RaceRef)
	if RaceTypes.Length < 1
		return sslUtility.AnimationArray(0)
	endIf
	bool[] Valid  = Utility.CreateBoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		sslBaseAnimation Slot = GetBySlot(i)
		Valid[i] = Slot.Enabled && ActorCount == Slot.PositionCount && RaceTypes.Find(Slot.RaceType) != -1
	endWhile
	return GetList(Valid)
endFunction

sslBaseAnimation[] function GetByRaceKey(int ActorCount, string RaceKey)
	bool[] Valid  = Utility.CreateBoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		sslBaseAnimation Slot = GetBySlot(i)
		Valid[i] = Slot.Enabled && Slot.RaceType == RaceKey && ActorCount == Slot.PositionCount
	endWhile
	return GetList(Valid)
endFunction

sslBaseAnimation[] function GetByRaceGenders(int ActorCount, Race RaceRef, int MaleCreatures = 0, int FemaleCreatures = 0, bool ForceUse = false)
	if !Config.UseCreatureGender && !ForceUse
		return GetByRace(ActorCount, RaceRef)
	endIf
	string[] RaceTypes = GetRaceTypes(RaceRef)
	if RaceTypes.Length < 1
		return sslUtility.AnimationArray(0)
	endIf
	bool[] Valid  = Utility.CreateBoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		sslBaseAnimation Slot = GetBySlot(i)
		Valid[i] = Slot.Enabled && RaceTypes.Find(Slot.RaceType) != -1 && ActorCount == Slot.PositionCount && (Slot.HasTag("NoGenders") || (MaleCreatures == Slot.MaleCreatures && FemaleCreatures == Slot.FemaleCreatures))
	endWhile
	return GetList(Valid)
endFunction

sslBaseAnimation[] function FilterCreatureGenders(sslBaseAnimation[] Anims, int MaleCreatures = 0, int FemaleCreatures = 0)
	if !Config.UseCreatureGender
		return Anims
	endIf
	Log("Checking Creature Filter: "+GetNames(Anims))
	int Del
	int i = Anims.Length
	while i
		i -= 1
		if !Anims[i].HasTag("NoGenders") && (MaleCreatures != Anims[i].MaleCreatures || FemaleCreatures != Anims[i].FemaleCreatures)
			Anims[i] = none
			Del += 1
		endIf
	endWhile
	if Del == 0
		return Anims
	endIf
	i = Anims.Length
	int n = (i - Del)
	sslBaseAnimation[] Output = sslUtility.AnimationArray(n)
	while i && n
		i -= 1
		if Anims[i] != none
			n -= 1
			Output[n] = Anims[i]
		endIf
	endWhile
	Log("Filtered Creatures: "+GetNames(Output))
	return Output
endFunction

bool function HasCreature(Actor ActorRef)
	return sslCreatureAnimationSlots.HasCreatureType(ActorRef)
endFunction

bool function HasRace(Race RaceRef)
	return sslCreatureAnimationSlots.HasRaceType(RaceRef)
endFunction

bool function AllowedCreature(Race RaceRef)
	return Config.AllowCreatures && sslCreatureAnimationSlots.HasRaceType(RaceRef)
endFunction

bool function AllowedCreatureCombination(Race RaceRef1, Race RaceRef2)
	return Config.AllowCreatures && sslCreatureAnimationSlots.GetRaceKey(RaceRef1) == sslCreatureAnimationSlots.GetRaceKey(RaceRef2)
endFunction

; ------------------------------------------------------- ;
; --- System Use Only                                 --- ;
; ------------------------------------------------------- ;

function Setup()
	RegisterRaces()
	parent.Setup()
endfunction

function RegisterSlots()
	StorageUtil.StringListClear(Config, "SexLabCreatures") ; No longer used
	if !Config.AllowCreatures
		Config.Log("Creatures not enabled, skipping registration.", "RegisterSlots() Creature")
	elseIf !Config.HasCreatureInstall()
		Config.Log("No FNIS Creature Pack or SexLab creature behaviors detected, skipping registration.", "RegisterSlots() Creature")
	else
		(Game.GetFormFromFile(0x664FB, "SexLab.esm") as sslCreatureAnimationDefaults).LoadCreatureAnimations()
		ModEvent.Send(ModEvent.Create("SexLabSlotCreatureAnimations"))
		Debug.Notification("$SSL_NotifyCreatureAnimationInstall")
	endIf
endFunction

function RegisterRaces()
	ClearRaceKey("Bears")
	AddRaceID("Bears", "BearBlackRace")
	AddRaceID("Bears", "BearBrownRace")
	AddRaceID("Bears", "BearSnowRace")

	ClearRaceKey("SabreCats")
	AddRaceID("SabreCats", "SabreCatRace")
	AddRaceID("SabreCats", "SabreCatSnowyRace")
	AddRaceID("SabreCats", "DLC1SabreCatGlowRace")

	ClearRaceKey("Chaurus")
	AddRaceID("Chaurus", "ChaurusRace")
	AddRaceID("Chaurus", "ChaurusReaperRace")
	AddRaceID("Chaurus", "DLC1_BF_ChaurusRace")

	ClearRaceKey("Dragons")
	AddRaceID("Dragons", "DragonRace")
	AddRaceID("Dragons", "UndeadDragonRace")
	AddRaceID("Dragons", "DLC1UndeadDragonRace")
	AddRaceID("Dragons", "_00MechaDragonRace0")
	AddRaceID("Dragons", "_00MechaDragonRace1")
	AddRaceID("Dragons", "_00MechaDragonRace2")
	AddRaceID("Dragons", "_00MechaDragonRace3")

	ClearRaceKey("Draugrs")
	AddRaceID("Draugrs", "DraugrRace")
	AddRaceID("Draugrs", "DraugrMagicRace")
	AddRaceID("Draugrs", "RigidSkeletonRace")
	AddRaceID("Draugrs", "SkeletonNecroRace")
	AddRaceID("Draugrs", "SkeletonRace")
	AddRaceID("Draugrs", "SkeletonArmorRace")
	AddRaceID("Draugrs", "DLC1SoulCairnKeeperRace")
	AddRaceID("Draugrs", "DLC1SoulCairnSkeletonArmorRace")
	AddRaceID("Draugrs", "DLC1BlackSkeletonRace")
	AddRaceID("Draugrs", "DLC1SoulCairnSkeletonNecroRace")
	AddRaceID("Draugrs", "_00ArmoredSkeletonArgonianRace")
	AddRaceID("Draugrs", "_00ArmoredSkeletonBeastRace_Old")
	AddRaceID("Draugrs", "_00ArmoredSkeletonKhajiitRace")
	AddRaceID("Draugrs", "_00ArmoredSkeletonRace")
	AddRaceID("Draugrs", "_00ArmoredSkeletonRace_Old")
	AddRaceID("Draugrs", "_00ChaurusGrimWarriorRace")
	AddRaceID("Draugrs", "_00ChaurusWarriorRace")
	AddRaceID("Draugrs", "_00BeastSkeletonRace")
	AddRaceID("Draugrs", "_00DramanRace")
	AddRaceID("Draugrs", "_00DraugrDwarvenRace")
	AddRaceID("Draugrs", "_00DraugrOneEyeRace")
	AddRaceID("Draugrs", "_00DraugrRaceSH")
	AddRaceID("Draugrs", "_00DraugrVarRace")
	AddRaceID("Draugrs", "_00DLC1BonemanSkeletonRace")
	AddRaceID("Draugrs", "_00LichRace")
	AddRaceID("Draugrs", "_00RigidSkeletonBeastRace")
	AddRaceID("Draugrs", "DLC2HulkingDraugrRace")
	AddRaceID("Draugrs", "DLC2AshSpawnRace")
	AddRaceID("Draugrs", "DLC2RigidSkeletonRace")

	ClearRaceKey("Falmers")
	AddRaceID("Falmers", "FalmerRace")
	AddRaceID("Falmers", "_00FalmerRace01")
	AddRaceID("Falmers", "_00FalmerRace02")
	AddRaceID("Falmers", "_00FalmerRace03")
	AddRaceID("Falmers", "_00FalmerRace04")
	AddRaceID("Falmers", "_00FalmerRace05")
	AddRaceID("Falmers", "_00GoblinRace")

	ClearRaceKey("Giants")
	AddRaceID("Giants", "GiantRace")
	AddRaceID("Giants", "DLC2GhostFrostGiantRace")
	AddRaceID("Giants", "_00GiantFrostRace")

	ClearRaceKey("Horses")
	AddRaceID("Horses", "HorseRace")

	ClearRaceKey("Spiders")
	AddRaceID("Spiders", "FrostbiteSpiderRace")
	AddRaceID("Spiders", "_00ChaurusCrawlerRace")
	AddRaceID("Spiders", "_00DwarvenSpiderBoltRace")
	AddRaceID("Spiders", "_00DwarvenSpiderFireRace")
	AddRaceID("Spiders", "_00SkeletonSpiderRace")

	ClearRaceKey("LargeSpiders")
	AddRaceID("LargeSpiders", "FrostbiteSpiderRaceGiant")
	AddRaceID("LargeSpiders", "FrostbiteSpiderRaceLarge")
	AddRaceID("LargeSpiders", "_00ChaurusCrawlerRaceGiant")
	AddRaceID("LargeSpiders", "_00ChaurusCrawlerRaceLarge")

	ClearRaceKey("Trolls")
	AddRaceID("Trolls", "TrollRace")
	AddRaceID("Trolls", "TrollFrostRace")
	AddRaceID("Trolls", "DLC1TrollFrostRaceArmored")
	AddRaceID("Trolls", "DLC1TrollRaceArmored")
	AddRaceID("Trolls", "_00DLC1SwampTrollRaceArmored")

	ClearRaceKey("Werewolves")
	AddRaceID("Werewolves", "WerewolfBeastRace")
	AddRaceID("Werewolves", "DLC2WerebearBeastRace")
	AddRaceID("Werewolves", "_00GreaterShoggothRace")
	AddRaceID("Werewolves", "_00WerebearBeastBlackRace")
	AddRaceID("Werewolves", "_00WerebearBeastSnowRace")
	AddRaceID("Werewolves", "_00WereSkeeverBeastRace")
	AddRaceID("Werewolves", "_00DaedrothRace")
	AddRaceID("Werewolves", "_00DramanBeastRace")
	AddRaceID("Werewolves", "_00DwarvenPunisherRace")
	AddRaceID("Werewolves", "_00WerewolfKingBeastRace")

	ClearRaceKey("Wolves")
	AddRaceID("Wolves", "WolfRace")
	AddRaceID("Wolves", "DLC1DeathHoundCompanionRace")
	AddRaceID("Wolves", "DLC1DeathHoundRace")
	AddRaceID("Wolves", "_00AspectRace")

	ClearRaceKey("Dogs")
	AddRaceID("Dogs", "DogRace")
	AddRaceID("Dogs", "DogCompanionRace")
	AddRaceID("Dogs", "MG07DogRace")
	AddRaceID("Dogs", "DA03BarbasDogRace")
	AddRaceID("Dogs", "DLC1HuskyArmoredCompanionRace")
	AddRaceID("Dogs", "DLC1HuskyArmoredRace")
	AddRaceID("Dogs", "DLC1HuskyBareCompanionRace")
	AddRaceID("Dogs", "DLC1HuskyBareRace")

	ClearRaceKey("VampireLords")
	AddRaceID("VampireLords", "DLC1VampireBeastRace")
	AddRaceID("VampireLords", "_00DramanHunterRace")
	AddRaceID("VampireLords", "_00FeralVampRace")
	AddRaceID("VampireLords", "_00SkeletonLordRace")

	ClearRaceKey("Gargoyles")
	AddRaceID("Gargoyles", "DLC1GargoyleRace")
	AddRaceID("Gargoyles", "DLC1GargoyleVariantBossRace")
	AddRaceID("Gargoyles", "DLC1GargoyleVariantGreenRace")
	AddRaceID("Gargoyles", "_00FrostBruteRace")
	AddRaceID("Gargoyles", "_00WrathBruteRace")
	AddRaceID("Gargoyles", "_00DramanBruteRace")

	ClearRaceKey("Rieklings")
	AddRaceID("Rieklings", "DLC2RieklingRace")
	AddRaceID("Rieklings", "DLC2ThirskRieklingRace")

	ClearRaceKey("Seekers")
	AddRaceID("Seekers", "DLC2SeekerRace")

	; Send creature race key registration event
	ModEvent.Send(ModEvent.Create("SexLabRegisterCreatureKey"))
endFunction
