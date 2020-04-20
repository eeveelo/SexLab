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
string[] function GetAllRaceKeys(Race RaceRef = none) global native
string[] function GetAllRaceIDs(string RaceKey) global native
Race[] function GetAllRaces(string RaceKey) global native

import PapyrusUtil

sslBaseAnimation[] function GetByRace(int ActorCount, Race RaceRef)
	Log("GetByRace(ActorCount="+ActorCount+", RaceRef="+RaceRef+")")
	string[] RaceTypes = GetAllRaceKeys(RaceRef)
	if RaceTypes.Length < 1
		return sslUtility.AnimationArray(0)
	endIf
	; Check Cache
	string CacheName = ActorCount+":"+PapyrusUtil.StringJoin(RaceTypes, "|")
	sslBaseAnimation[] Output = CheckCache(CacheName)
	if Output
		return Output
	endIf
	; Search
	bool[] Valid  = Utility.CreateBoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		sslBaseAnimation Slot = GetBySlot(i)
		Valid[i] = Slot.Enabled && ActorCount == Slot.PositionCount && RaceTypes.Find(Slot.RaceType) != -1
	endWhile
	Output = GetList(valid)
	CacheAnims(CacheName, Output)
	return Output
endFunction

sslBaseAnimation[] function GetByRaceTags(int ActorCount, Race RaceRef, string Tags, string TagsSuppressed = "", bool RequireAll = true)
	Log("GetByRaceTags(ActorCount="+ActorCount+", RaceRef="+RaceRef+", Tags="+Tags+", TagsSuppressed="+TagsSuppressed+", RequireAll="+RequireAll+")")
	string[] RaceTypes = GetAllRaceKeys(RaceRef)
	if RaceTypes.Length < 1
		return sslUtility.AnimationArray(0)
	endIf
	; Check Cache
	string CacheName = ActorCount+":"+Tags+":"+TagsSuppressed+":"+RequireAll+":"+PapyrusUtil.StringJoin(RaceTypes, "|")
	sslBaseAnimation[] Output = CheckCache(CacheName)
	if Output
		return Output
	endIf
	; Search
	bool[] Valid      = Utility.CreateBoolArray(Slotted)
	string[] Suppress = StringSplit(TagsSuppressed)
	string[] Search   = StringSplit(Tags)
	int i = Slotted
	while i
		i -= 1
		sslBaseAnimation Slot = GetBySlot(i)
		Valid[i] = Slot && Slot.Enabled && RaceTypes.Find(Slot.RaceType) != -1 && ActorCount == Slot.PositionCount && Slot.TagSearch(Search, Suppress, RequireAll)
	endWhile
	Output = GetList(valid)
	CacheAnims(CacheName, Output)
	return Output
endFunction

sslBaseAnimation[] function GetByRaceKey(int ActorCount, string RaceKey)
	Log("GetByRaceKey(ActorCount="+ActorCount+", RaceKey="+RaceKey+")")
	if !HasRaceKey(RaceKey)
		return sslUtility.AnimationArray(0)
	endIf
	; Check Cache
	string CacheName = ActorCount+":"+RaceKey
	sslBaseAnimation[] Output = CheckCache(CacheName)
	if Output
		return Output
	endIf
	; Search
	bool[] Valid  = Utility.CreateBoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		sslBaseAnimation Slot = GetBySlot(i)
		Valid[i] = Slot && Slot.RaceType == RaceKey && Slot.Enabled && ActorCount == Slot.PositionCount
	endWhile
	Output = GetList(valid)
	CacheAnims(CacheName, Output)
	return Output
endFunction

sslBaseAnimation[] function GetByRaceKeyTags(int ActorCount, string RaceKey, string Tags, string TagsSuppressed = "", bool RequireAll = true)
	Log("GetByRaceKeyTags(ActorCount="+ActorCount+", RaceKey="+RaceKey+", Tags="+Tags+", TagsSuppressed="+TagsSuppressed+", RequireAll="+RequireAll+")")
	if !HasRaceKey(RaceKey)
		return sslUtility.AnimationArray(0)
	endIf
	; Check Cache
	string CacheName = ActorCount+":"+RaceKey+":"+Tags+":"+TagsSuppressed+":"+RequireAll
	sslBaseAnimation[] Output = CheckCache(CacheName)
	if Output
		return Output
	endIf
	; Search
	bool[] Valid      = Utility.CreateBoolArray(Slotted)
	string[] Suppress = StringSplit(TagsSuppressed)
	string[] Search   = StringSplit(Tags)
	int i = Slotted
	while i
		i -= 1
		sslBaseAnimation Slot = GetBySlot(i)
		Valid[i] = Slot && Slot.RaceType == RaceKey && Slot.Enabled && ActorCount == Slot.PositionCount && Slot.TagSearch(Search, Suppress, RequireAll)
	endWhile
	Output = GetList(valid)
	CacheAnims(CacheName, Output)
	return Output
endFunction

sslBaseAnimation[] function GetByRaceGenders(int ActorCount, Race RaceRef, int MaleCreatures = 0, int FemaleCreatures = 0, bool ForceUse = false)
	Log("GetByRaceGenders(ActorCount="+ActorCount+", RaceRef="+RaceRef+", MaleCreatures="+MaleCreatures+", FemaleCreatures="+FemaleCreatures+", ForceUse="+ForceUse+")")
	if !Config.UseCreatureGender && !ForceUse
		return GetByRace(ActorCount, RaceRef)
	endIf
	string[] RaceTypes = GetAllRaceKeys(RaceRef)
	if RaceTypes.Length < 1
		return sslUtility.AnimationArray(0)
	endIf

	; Check Cache
	string CacheName = ActorCount+":Male-"+MaleCreatures+":Female-"+FemaleCreatures+":"+PapyrusUtil.StringJoin(RaceTypes, "|")
	sslBaseAnimation[] Output = CheckCache(CacheName)
	if Output
		return Output
	endIf

	bool[] Valid  = Utility.CreateBoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		sslBaseAnimation Slot = GetBySlot(i)
		Valid[i] = Slot && Slot.Enabled && RaceTypes.Find(Slot.RaceType) != -1 && ActorCount == Slot.PositionCount && (!Slot.GenderedCreatures || (MaleCreatures == Slot.MaleCreatures && FemaleCreatures == Slot.FemaleCreatures))
	endWhile
	
	Output = GetList(valid)
	CacheAnims(CacheName, Output)
	return Output
endFunction

sslBaseAnimation[] function FilterCreatureGenders(sslBaseAnimation[] Anims, int MaleCreatures = 0, int FemaleCreatures = 0)
	if !Config.UseCreatureGender || !Anims
		return Anims
	endIf
	int Del
	int i = Anims.Length
	while i
		i -= 1
		if Anims[i] && Anims[i].GenderedCreatures && (MaleCreatures != Anims[i].MaleCreatures || FemaleCreatures != Anims[i].FemaleCreatures)
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
	return Output
endFunction

bool function RaceHasAnimation(Race RaceRef, int ActorCount = -1, int Gender = -1)
	string[] RaceTypes = GetAllRaceKeys(RaceRef)
	if RaceTypes
		bool UseGender = Gender != -1 && Config.UseCreatureGender
		int i = Slotted
		while i
			i -= 1
			sslBaseAnimation Slot = GetBySlot(i)
			if Slot && Slot.Enabled && RaceTypes.Find(Slot.RaceType) != -1 && (ActorCount == -1 || ActorCount == Slot.PositionCount) && ((!UseGender || !Slot.GenderedCreatures) || Slot.Genders[Gender] > 0)
				return true
			endIf
		endWhile
	endIf
	return false
endFunction

bool function RaceKeyHasAnimation(string RaceKey, int ActorCount = -1, int Gender = -1)
	if HasRaceKey(RaceKey)
		bool UseGender = Gender != -1 && Config.UseCreatureGender
		int i = Slotted
		while i
			i -= 1
			sslBaseAnimation Slot = GetBySlot(i)
			if Slot && Slot.Enabled && RaceKey == Slot.RaceType && (ActorCount == -1 || ActorCount == Slot.PositionCount) && ((!UseGender || !Slot.GenderedCreatures) || Slot.Genders[Gender] > 0)
				return true
			endIf
		endWhile
	endIf
	return false
endFunction

bool function HasCreature(Actor ActorRef)
	return sslCreatureAnimationSlots.HasCreatureType(ActorRef)
endFunction

bool function HasRace(Race RaceRef)
	return sslCreatureAnimationSlots.HasRaceType(RaceRef)
endFunction

bool function AllowedCreature(Race RaceRef)
	return Config.AllowCreatures && HasAnimation(RaceRef)
endFunction

bool function AllowedCreatureCombination(Race RaceRef1, Race RaceRef2)
	if !Config.AllowCreatures || !RaceRef1 || !RaceRef2
		return false ; No creatures or missing RaceRef
	elseIf RaceRef1 == RaceRef2
		return true ; No need to check same races
	endIf

	string[] Keys1 = GetAllRaceKeys(RaceRef1)
	string[] Keys2 = GetAllRaceKeys(RaceRef2)
	if !Keys1 || !Keys2
		return false ; Invalid race found
	endIf

	int k1 = Keys1.Length
	int k2 = Keys2.Length
	if k1 < 1 || k2 < 1
		return false ; a probably unnecessary error check

	elseIf k1 == 1 && k2 == 1 && Keys1[0] != Keys2[0] 
		return false ; Simple single key mismatch

	elseIf (k1 == 1 && k2 > 1 && Keys2.Find(Keys1[0]) != -1) || \
	       (k2 == 1 && k1 > 1 && Keys1.Find(Keys2[0]) != -1)
	   return true ; Matched single key to multikey

	endIf
	
	while k1
		k1 -= 1
		if Keys2.Find(Keys1[k1]) != -1
			return true ; Matched between multikey arrays
		endIf
	endWhile

	return false ; No matches found
endFunction

; Deprecated
bool function HasAnimation(Race RaceRef, int Gender = -1)
	return RaceHasAnimation(RaceRef, -1, Gender)
endFunction

; ------------------------------------------------------- ;
; --- System Use Only                                 --- ;
; ------------------------------------------------------- ;

function Setup()
	RegisterRaces()
	parent.Setup()
	CacheID = "SexLab.CreatureTags"
endfunction

function RegisterSlots()
	CacheID = "SexLab.CreatureTags"
	if Config.AllowCreatures
		; Register the creature animations and voices
		; PreloadCategoryLoaders()
		(Game.GetFormFromFile(0x664FB, "SexLab.esm") as sslCreatureAnimationDefaults).LoadCreatureAnimations()
		(Game.GetFormFromFile(0x664FB, "SexLab.esm") as sslVoiceDefaults).LoadCreatureVoices()
		ModEvent.Send(ModEvent.Create("SexLabSlotCreatureAnimations"))
		Debug.Notification("$SSL_NotifyCreatureAnimationInstall")
	else
		Config.Log("Creatures not enabled, skipping registration.", "RegisterSlots() Creature")
	endIf
endFunction

; string[] function GetTagCache()
; 	return StorageUtil.StringListToArray(Config, "SexLab.CreatureTags")
; endFunction

; function CacheTags()
; 	DoCache("SexLab.CreatureTags")
; endFunction

; event OnUpdate()
; 	CacheTags()
; endEvent

; int function Register(string Registrar)
; 	int i = parent.Register(Registrar)
; 	RegisterForSingleUpdate(7.0)
; 	return i
; endFunction

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
	AddRaceID("Wolves", "FoxRace")

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

	ClearRaceKey("Lurkers")
	AddRaceID("Lurkers", "DLC2LurkerRace")

	ClearRaceKey("Spriggans")
	AddRaceID("Spriggans", "SprigganRace")
	AddRaceID("Spriggans", "SprigganMatronRace")
	AddRaceID("Spriggans", "SprigganEarthMotherRace")
	AddRaceID("Spriggans", "DLC2SprigganBurntRace")
	AddRaceID("Spriggans", "_00FrostSprigganMatronRace")
	AddRaceID("Spriggans", "_00VenerableSprigganBurntRace")
	AddRaceID("Spriggans", "_00VenerableSprigganEarthMotherRace")
	AddRaceID("Spriggans", "_00VenerableSprigganMatronRace")
	AddRaceID("Spriggans", "_00VenerableSprigganRace")
	AddRaceID("Spriggans", "_00DwarvenDroidRace03")

	ClearRaceKey("FlameAtronach")
	AddRaceID("FlameAtronach", "AtronachFlameRace")
	AddRaceID("FlameAtronach", "_SLSD_AtronachFlameRace")
	AddRaceID("FlameAtronach", "_00DwarvenDroidRace01")

	ClearRaceKey("Skeevers")
	AddRaceID("Skeevers", "SkeeverRace")

	ClearRaceKey("Chickens")
	AddRaceID("Chickens", "ChickenRace")

	; Send creature race key registration event
	ModEvent.Send(ModEvent.Create("SexLabRegisterCreatureKey"))
endFunction
