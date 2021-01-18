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
	string CacheName = ActorCount+":"+StringJoin(RaceTypes, "|")
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
	Output = GetList(Valid)
	CacheAnims(CacheName, Output)
	return Output
endFunction

sslBaseAnimation[] function GetByRaceTags(int ActorCount, Race RaceRef, string Tags, string TagsSuppressed = "", bool RequireAll = true)
	Log("GetByRaceTags(ActorCount="+ActorCount+", RaceRef="+RaceRef+", Tags="+Tags+", TagsSuppressed="+TagsSuppressed+", RequireAll="+RequireAll+")")
	string[] RaceTypes = GetAllRaceKeys(RaceRef)
	if RaceTypes.Length < 1
		return sslUtility.AnimationArray(0)
	endIf
	; Making the tags lists and optimize for CACHE
	string[] Suppress = StringSplit(TagsSuppressed)
	Suppress = ClearEmpty(Suppress)
	SortStringArray(Suppress)
	string[] Search   = StringSplit(Tags)
	Search = ClearEmpty(Search)
	SortStringArray(Search)
	; Check Cache
	string CacheName = ActorCount+":"+StringJoin(RaceTypes, "|")+":"+Search+":"+Suppress+":"+RequireAll
	sslBaseAnimation[] Output = CheckCache(CacheName)
	if Output
		return Output
	endIf
	; Search
	bool[] Valid      = Utility.CreateBoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		sslBaseAnimation Slot = GetBySlot(i)
		Valid[i] = Slot && Slot.Enabled && RaceTypes.Find(Slot.RaceType) != -1 && ActorCount == Slot.PositionCount && Slot.TagSearch(Search, Suppress, RequireAll)
	endWhile
	Output = GetList(Valid)
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
	Output = GetList(Valid)
	CacheAnims(CacheName, Output)
	return Output
endFunction

sslBaseAnimation[] function GetByRaceKeyTags(int ActorCount, string RaceKey, string Tags, string TagsSuppressed = "", bool RequireAll = true)
	Log("GetByRaceKeyTags(ActorCount="+ActorCount+", RaceKey="+RaceKey+", Tags="+Tags+", TagsSuppressed="+TagsSuppressed+", RequireAll="+RequireAll+")")
	if !HasRaceKey(RaceKey)
		return sslUtility.AnimationArray(0)
	endIf
	; Making the tags lists and optimize for CACHE
	string[] Suppress = StringSplit(TagsSuppressed)
	Suppress = ClearEmpty(Suppress)
	SortStringArray(Suppress)
	string[] Search   = StringSplit(Tags)
	Search = ClearEmpty(Search)
	SortStringArray(Search)
	; Check Cache
	string CacheName = ActorCount+":"+RaceKey+":"+Search+":"+Suppress+":"+RequireAll
	sslBaseAnimation[] Output = CheckCache(CacheName)
	if Output
		return Output
	endIf
	; Search
	bool[] Valid      = Utility.CreateBoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		sslBaseAnimation Slot = GetBySlot(i)
		Valid[i] = Slot && Slot.RaceType == RaceKey && Slot.Enabled && ActorCount == Slot.PositionCount && Slot.TagSearch(Search, Suppress, RequireAll)
	endWhile
	Output = GetList(Valid)
	CacheAnims(CacheName, Output)
	return Output
endFunction

sslBaseAnimation[] function GetByCreatureActors(int ActorCount, Actor[] Positions)
	Log("GetByCreatureActors(ActorCount="+ActorCount+", Positions="+Positions+")")
	if !Positions || Positions.Length < 1 || Positions.Length > ActorCount
		return sslUtility.AnimationArray(0)
	endIf
	if ActorCount == 1
		return GetByRace(ActorCount, Positions[0].GetLeveledActorBase().GetRace())
	endIf
	
	string[] RaceTypesTemp
	string[] RaceTypes0
	string[] RaceTypes1
	string[] RaceTypes2
	string[] RaceTypes3
	string[] RaceTypes4
	Race CreatureRef
	
	int[] RaceCount = new int[5]
	
	int i = Positions.Length
	while i > 0
		i -= 1
		RaceTypesTemp = GetAllRaceKeys(Positions[i].GetLeveledActorBase().GetRace())
		if RaceTypesTemp && RaceTypesTemp.Length > 0
			if !RaceTypes0 || RaceTypes0.Length < 1
				RaceTypes0 = RaceTypesTemp
				RaceCount[0] = 1
				CreatureRef = Positions[i].GetLeveledActorBase().GetRace()
			else
				if AllowedRaceKeyCombination(RaceTypes0, RaceTypesTemp)
					RaceTypes0 = MergeStringArray(RaceTypes0, RaceTypesTemp, True)
					RaceCount[0] = RaceCount[0] + 1
				else
					if !RaceTypes1 || RaceTypes1.Length < 1
						RaceTypes1 = RaceTypesTemp
						RaceCount[1] = 1
					else
						if AllowedRaceKeyCombination(RaceTypes1, RaceTypesTemp)
							RaceTypes1 = MergeStringArray(RaceTypes1, RaceTypesTemp, True)
							RaceCount[1] = RaceCount[1] + 1
						else
							if !RaceTypes2 || RaceTypes2.Length < 1
								RaceTypes2 = RaceTypesTemp
								RaceCount[2] = 1
							else
								if AllowedRaceKeyCombination(RaceTypes2, RaceTypesTemp)
									RaceTypes2 = MergeStringArray(RaceTypes2, RaceTypesTemp, True)
									RaceCount[2] = RaceCount[2] + 1
								else
									if !RaceTypes3 || RaceTypes3.Length < 1
										RaceTypes3 = RaceTypesTemp
										RaceCount[3] = 1
									else
										if AllowedRaceKeyCombination(RaceTypes3, RaceTypesTemp)
											RaceTypes3 = MergeStringArray(RaceTypes3, RaceTypesTemp, True)
											RaceCount[3] = RaceCount[3] + 1
										else
											if !RaceTypes4 || RaceTypes4.Length < 1
												RaceTypes4 = RaceTypesTemp
												RaceCount[4] = 1
											else
												if AllowedRaceKeyCombination(RaceTypes4, RaceTypesTemp)
													RaceTypes4 = MergeStringArray(RaceTypes4, RaceTypesTemp, True)
													RaceCount[4] = RaceCount[4] + 1
												else
													Log("FATAL - GetByCreatureActors() - Failed to count RaceType or limit reached")
												endIf
											endIf
										endIf
									endIf
								endIf
							endIf
						endIf
					endIf
				endIf
			endIf
		endIf
	endWhile
	Log("GetByCreatureActors() - RaceCount:"+RaceCount+" RaceTypes0:"+RaceTypes0+" RaceTypes1:"+RaceTypes1+" RaceTypes2:"+RaceTypes2+" RaceTypes3:"+RaceTypes3+" RaceTypes4:"+RaceTypes4)

	int[] Genders = ActorLib.GenderCount(Positions)
	int Creatures = (Genders[2] + Genders[3])
	if !RaceTypes0 || RaceTypes0.Length < 1
		return sslUtility.AnimationArray(0)
	elseIf !RaceTypes1 || RaceTypes1.Length < 1
		if ActorCount > Creatures ;Creatures == 1
			return GetByRaceGendersTags(ActorCount, CreatureRef, Genders[2], Genders[3], "", "Interspecies,")
		endIf
	endIf

	; Check Cache
	string CacheName = ActorCount+":"+Creatures+":"+RaceCount+":"+StringJoin(RaceTypes0, "|")+":"+StringJoin(RaceTypes1, "|")+":"+StringJoin(RaceTypes2, "|")+":"+StringJoin(RaceTypes3, "|")+":"+StringJoin(RaceTypes4, "|")
	sslBaseAnimation[] Output = CheckCache(CacheName)
	if Output
		return Output
	endIf

	bool[] Valid  = Utility.CreateBoolArray(Slotted)
	i = Slotted
	while i
		i -= 1
		sslBaseAnimation Slot = GetBySlot(i)
		bool HasAllRaces = True
		Valid[i] = Slot && Slot.Enabled && ActorCount == Slot.PositionCount && Creatures == Slot.Creatures
		if Valid[i]
			if Slot.CountValidRaceKey(RaceTypes0) == RaceCount[0]
				if Slot.CountValidRaceKey(RaceTypes1) == RaceCount[1]
					if RaceTypes2 && RaceTypes2.Length > 0 
						if Slot.CountValidRaceKey(RaceTypes2) == RaceCount[2]
							if RaceTypes3 && RaceTypes3.Length > 0 
								if Slot.CountValidRaceKey(RaceTypes3) == RaceCount[3]
									if RaceTypes4 && RaceTypes4.Length > 0 
										if Slot.CountValidRaceKey(RaceTypes4) == RaceCount[4]
											HasAllRaces = True ; Not need
										else
											HasAllRaces = False
										endIf
									endIf
								else
									HasAllRaces = False
								endIf
							endIf
						else
							HasAllRaces = False
						endIf
					endIf
				else
					HasAllRaces = False
				endIf
			else
				HasAllRaces = False
			endIf
			Valid[i] = HasAllRaces
		endIf
	endWhile
	Output = GetList(Valid)
	CacheAnims(CacheName, Output)
	return Output
endFunction

sslBaseAnimation[] function GetByCreatureActorsTags(int ActorCount, Actor[] Positions, string Tags, string TagsSuppressed = "", bool RequireAll = true)
	Log("GetByCreatureActorsTags(ActorCount="+ActorCount+", Positions="+Positions+", Tags="+Tags+", TagsSuppressed="+TagsSuppressed+", RequireAll="+RequireAll+")")
	if !Positions || Positions.Length < 1 || Positions.Length > ActorCount
		return sslUtility.AnimationArray(0)
	endIf
	if ActorCount == 1
		return GetByRaceTags(ActorCount, Positions[0].GetLeveledActorBase().GetRace(), Tags, TagsSuppressed, RequireAll)
	endIf
	
	string[] RaceTypesTemp
	string[] RaceTypes0
	string[] RaceTypes1
	string[] RaceTypes2
	string[] RaceTypes3
	string[] RaceTypes4
	Race CreatureRef
	
	int[] RaceCount = new int[5]
	
	int i = Positions.Length
	while i > 0
		i -= 1
		RaceTypesTemp = GetAllRaceKeys(Positions[i].GetLeveledActorBase().GetRace())
		if RaceTypesTemp && RaceTypesTemp.Length > 0
			if !RaceTypes0 || RaceTypes0.Length < 1
				RaceTypes0 = RaceTypesTemp
				RaceCount[0] = 1
				CreatureRef = Positions[i].GetLeveledActorBase().GetRace()
			else
				if AllowedRaceKeyCombination(RaceTypes0, RaceTypesTemp)
					RaceTypes0 = MergeStringArray(RaceTypes0, RaceTypesTemp, True)
					RaceCount[0] = RaceCount[0] + 1
				else
					if !RaceTypes1 || RaceTypes1.Length < 1
						RaceTypes1 = RaceTypesTemp
						RaceCount[1] = 1
					else
						if AllowedRaceKeyCombination(RaceTypes1, RaceTypesTemp)
							RaceTypes1 = MergeStringArray(RaceTypes1, RaceTypesTemp, True)
							RaceCount[1] = RaceCount[1] + 1
						else
							if !RaceTypes2 || RaceTypes2.Length < 1
								RaceTypes2 = RaceTypesTemp
								RaceCount[2] = 1
							else
								if AllowedRaceKeyCombination(RaceTypes2, RaceTypesTemp)
									RaceTypes2 = MergeStringArray(RaceTypes2, RaceTypesTemp, True)
									RaceCount[2] = RaceCount[2] + 1
								else
									if !RaceTypes3 || RaceTypes3.Length < 1
										RaceTypes3 = RaceTypesTemp
										RaceCount[3] = 1
									else
										if AllowedRaceKeyCombination(RaceTypes3, RaceTypesTemp)
											RaceTypes3 = MergeStringArray(RaceTypes3, RaceTypesTemp, True)
											RaceCount[3] = RaceCount[3] + 1
										else
											if !RaceTypes4 || RaceTypes4.Length < 1
												RaceTypes4 = RaceTypesTemp
												RaceCount[4] = 1
											else
												if AllowedRaceKeyCombination(RaceTypes4, RaceTypesTemp)
													RaceTypes4 = MergeStringArray(RaceTypes4, RaceTypesTemp, True)
													RaceCount[4] = RaceCount[4] + 1
												else
													Log("FATAL - GetByCreatureActorsTags() - Failed to count RaceType or limit reached")
												endIf
											endIf
										endIf
									endIf
								endIf
							endIf
						endIf
					endIf
				endIf
			endIf
		endIf
	endWhile
	Log("GetByCreatureActorsTags() - RaceCount:"+RaceCount+" RaceTypes0:"+RaceTypes0+" RaceTypes1:"+RaceTypes1+" RaceTypes2:"+RaceTypes2+" RaceTypes3:"+RaceTypes3+" RaceTypes4:"+RaceTypes4)

	int[] Genders = ActorLib.GenderCount(Positions)
	int Creatures = (Genders[2] + Genders[3])
	if !RaceTypes0 || RaceTypes0.Length < 1
		return sslUtility.AnimationArray(0)
	elseIf !RaceTypes1 || RaceTypes1.Length < 1
		if ActorCount > Creatures
			return GetByRaceGendersTags(ActorCount, CreatureRef, Genders[2], Genders[3], Tags, "Interspecies,"+TagsSuppressed, RequireAll)
		endIf
	endIf
	
	; Making the tags lists and optimize for CACHE
	string[] Suppress = StringSplit(TagsSuppressed)
	Suppress = ClearEmpty(Suppress)
	SortStringArray(Suppress)
	string[] Search   = StringSplit(Tags)
	Search = ClearEmpty(Search)
	SortStringArray(Search)
	; Check Cache
	string CacheName = ActorCount+":"+Creatures+":"+RaceCount+":"+StringJoin(RaceTypes0, "|")+":"+StringJoin(RaceTypes1, "|")+":"+StringJoin(RaceTypes2, "|")+":"+StringJoin(RaceTypes3, "|")+":"+StringJoin(RaceTypes4, "|")+":"+Search+":"+Suppress+":"+RequireAll
	sslBaseAnimation[] Output = CheckCache(CacheName)
	if Output
		return Output
	endIf

	bool[] Valid      = Utility.CreateBoolArray(Slotted)
	i = Slotted
	while i
		i -= 1
		sslBaseAnimation Slot = GetBySlot(i)
		bool HasAllRaces = True
		string[] SlotRaceTypes = RemoveString(Slot.GetRaceTypes(), "")
		Valid[i] = Slot && Slot.Enabled && ActorCount == Slot.PositionCount && Creatures == Slot.Creatures && Slot.TagSearch(Search, Suppress, RequireAll)
		if Valid[i]
			if Slot.CountValidRaceKey(RaceTypes0) == RaceCount[0]
				if Slot.CountValidRaceKey(RaceTypes1) == RaceCount[1]
					if RaceTypes2 && RaceTypes2.Length > 0 
						if Slot.CountValidRaceKey(RaceTypes2) == RaceCount[2]
							if RaceTypes3 && RaceTypes3.Length > 0 
								if Slot.CountValidRaceKey(RaceTypes3) == RaceCount[3]
									if RaceTypes4 && RaceTypes4.Length > 0 
										if Slot.CountValidRaceKey(RaceTypes4) == RaceCount[4]
											HasAllRaces = True ; Not need
										else
											HasAllRaces = False
										endIf
									endIf
								else
									HasAllRaces = False
								endIf
							endIf
						else
							HasAllRaces = False
						endIf
					endIf
				else
					HasAllRaces = False
				endIf
			else
				HasAllRaces = False
			endIf
			Valid[i] = HasAllRaces
		endIf
	endWhile
	Output = GetList(Valid)
	CacheAnims(CacheName, Output)
	return Output
endFunction

sslBaseAnimation[] function GetByRaceGenders(int ActorCount, Race RaceRef, int MaleCreatures = 0, int FemaleCreatures = 0, bool ForceUse = false)
	Log("GetByRaceGenders(ActorCount="+ActorCount+", RaceRef="+RaceRef+", MaleCreatures="+MaleCreatures+", FemaleCreatures="+FemaleCreatures+", ForceUse="+ForceUse+")")
	if !Config.UseCreatureGender && ActorCount <= 2 && (MaleCreatures + FemaleCreatures) < 2 ;&& !ForceUse
		return GetByRace(ActorCount, RaceRef)
	endIf
	string[] RaceTypes = GetAllRaceKeys(RaceRef)
	if RaceTypes.Length < 1
		return sslUtility.AnimationArray(0)
	endIf

	; Check Cache
	string CacheName = ActorCount+":"+StringJoin(RaceTypes, "|")+":"+MaleCreatures+":"+FemaleCreatures;+":"+ForceUse
	sslBaseAnimation[] Output = CheckCache(CacheName)
	if Output
		return Output
	endIf

	bool[] Valid  = Utility.CreateBoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		sslBaseAnimation Slot = GetBySlot(i)
		Valid[i] = Slot && Slot.Enabled && RaceTypes.Find(Slot.RaceType) != -1 && ActorCount == Slot.PositionCount 
		if Valid[i]
			if Config.UseCreatureGender && Slot.GenderedCreatures
				Valid[i] = MaleCreatures == Slot.MaleCreatures && FemaleCreatures == Slot.FemaleCreatures
			else
				Valid[i] = (MaleCreatures + FemaleCreatures) == Slot.Creatures
			endIf
		endIf
	endWhile
	Output = GetList(Valid)
	CacheAnims(CacheName, Output)
	return Output
endFunction

sslBaseAnimation[] function GetByRaceGendersTags(int ActorCount, Race RaceRef, int MaleCreatures = 0, int FemaleCreatures = 0, string Tags, string TagsSuppressed = "", bool RequireAll = true)
	Log("GetByRaceGenders(ActorCount="+ActorCount+", RaceRef="+RaceRef+", MaleCreatures="+MaleCreatures+", FemaleCreatures="+FemaleCreatures+", Tags="+Tags+", TagsSuppressed="+TagsSuppressed+", RequireAll="+RequireAll+")")
	if !Config.UseCreatureGender && ActorCount <= 2 && (MaleCreatures + FemaleCreatures) < 2 ;&& !ForceUse
		return GetByRaceTags(ActorCount, RaceRef, Tags, TagsSuppressed, RequireAll)
	endIf
	string[] RaceTypes = GetAllRaceKeys(RaceRef)
	if RaceTypes.Length < 1
		return sslUtility.AnimationArray(0)
	endIf

	; Making the tags lists and optimize for CACHE
	string[] Suppress = StringSplit(TagsSuppressed)
	Suppress = ClearEmpty(Suppress)
	SortStringArray(Suppress)
	string[] Search   = StringSplit(Tags)
	Search = ClearEmpty(Search)
	SortStringArray(Search)
	; Check Cache
	string CacheName = ActorCount+":"+StringJoin(RaceTypes, "|")+":"+MaleCreatures+":"+FemaleCreatures+":"+Search+":"+Suppress+":"+RequireAll
	sslBaseAnimation[] Output = CheckCache(CacheName)
	if Output
		return Output
	endIf

	bool[] Valid  = Utility.CreateBoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		sslBaseAnimation Slot = GetBySlot(i)
		Valid[i] = Slot && Slot.Enabled && RaceTypes.Find(Slot.RaceType) != -1 && ActorCount == Slot.PositionCount && Slot.TagSearch(Search, Suppress, RequireAll)
		if Valid[i]
			if Config.UseCreatureGender && Slot.GenderedCreatures
				Valid[i] = MaleCreatures == Slot.MaleCreatures && FemaleCreatures == Slot.FemaleCreatures
			else
				Valid[i] = (MaleCreatures + FemaleCreatures) == Slot.Creatures
			endIf
		endIf
	endWhile
	Output = GetList(Valid)
	CacheAnims(CacheName, Output)
	return Output
endFunction
;TODO: Enhace FilterCreatureGenders to allow CxC animations
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

bool function AllowedRaceKeyCombination(string[] Keys1, string[] Keys2)
	if !Config.AllowCreatures || !Keys1 || !Keys2
		return false ; No creatures or missing RaceRef
	endIf
	
	int k1 = Keys1.Length
	int k2 = Keys2.Length
	if k1 < 1 || k2 < 1
		return false ; a probably unnecessary error check
	endIf
	
	if Keys1 == Keys2
		return true ; No need to check same races
	endIf
	
	if k1 == 1 && k2 == 1 && Keys1[0] != Keys2[0] 
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

function RegisterRaces()
	;Ashhoppers = Actors\DLC02\Scrib\ScribProject.hkx
		ClearRaceKey("Ashhoppers")
		AddRaceID("Ashhoppers", "DLC2AshHopperRace")

	;Bears = Actors\Bear\BearProject.hkx
		ClearRaceKey("Bears")
		AddRaceID("Bears", "BearBlackRace")
		AddRaceID("Bears", "BearBrownRace")
		AddRaceID("Bears", "BearSnowRace")

	;Boars = Actors\DLC02\BoarRiekling\BoarProject.hkx
		ClearRaceKey("Boars")
		AddRaceID("Boars", "DLC2BoarRace")

	;BoarsAny = Actors\DLC02\BoarRiekling\BoarProject.hkx
		ClearRaceKey("BoarsAny")
		AddRaceID("BoarsAny", "DLC2BoarRace")
		AddRaceID("BoarsAny", "DLC2MountedRieklingRace")

	;BoarsMounted = Actors\DLC02\BoarRiekling\BoarProject.hkx
		ClearRaceKey("BoarsMounted")
		AddRaceID("BoarsMounted", "DLC2MountedRieklingRace")

	;Canines = Actors\Canine\DogProject.hkx AND Actors\Canine\WolfProject.hkx
		ClearRaceKey("Canines")
		AddRaceID("Canines", "DogRace")
		AddRaceID("Canines", "DogCompanionRace")
		AddRaceID("Canines", "MG07DogRace")
		AddRaceID("Canines", "DA03BarbasDogRace")
		AddRaceID("Canines", "DLC1HuskyArmoredCompanionRace")
		AddRaceID("Canines", "DLC1HuskyArmoredRace")
		AddRaceID("Canines", "DLC1HuskyBareCompanionRace")
		AddRaceID("Canines", "DLC1HuskyBareRace")
		AddRaceID("Canines", "WolfRace")
		AddRaceID("Canines", "DLC1DeathHoundCompanionRace")
		AddRaceID("Canines", "DLC1DeathHoundRace")

	;Chaurus = Actors\Chaurus\ChaurusProject.hkx
		ClearRaceKey("Chaurus")
		AddRaceID("Chaurus", "ChaurusRace")
		AddRaceID("Chaurus", "DLC1_BF_ChaurusRace")

	;ChaurusHunters = Actors\DLC01\ChaurusFlyer\ChaurusFlyer.hkx
		ClearRaceKey("ChaurusHunters")
		AddRaceID("ChaurusHunters", "DLC1ChaurusHunterRace")

	;ChaurusReapers = Actors\Chaurus\ChaurusProject.hkx
		ClearRaceKey("ChaurusReapers")
		AddRaceID("ChaurusReapers", "ChaurusReaperRace")

	;Chickens = Actors\Ambient\Chicken\ChickenProject.hkx
		ClearRaceKey("Chickens")
		AddRaceID("Chickens", "ChickenRace")

	;Cows = Actors\Cow\HighlandCowProject.hkx
		ClearRaceKey("Cows")
		AddRaceID("Cows", "CowRace")

	;Deers = Actors\Deer\DeerProject.hkx
		ClearRaceKey("Deers")
		AddRaceID("Deers", "DeerRace")
		AddRaceID("Deers", "ElkRace")
		AddRaceID("Deers", "WhiteStagRace")
		AddRaceID("Deers", "DLC1DeerGlowRace")

	;Dogs = Actors\Canine\DogProject.hkx
		ClearRaceKey("Dogs")
		AddRaceID("Dogs", "DogRace")
		AddRaceID("Dogs", "DogCompanionRace")
		AddRaceID("Dogs", "MG07DogRace")
		AddRaceID("Dogs", "DA03BarbasDogRace")
		AddRaceID("Dogs", "DLC1HuskyArmoredCompanionRace")
		AddRaceID("Dogs", "DLC1HuskyArmoredRace")
		AddRaceID("Dogs", "DLC1HuskyBareCompanionRace")
		AddRaceID("Dogs", "DLC1HuskyBareRace")

	;DragonPriests = Actors\DragonPriest\Dragon_Priest.hkx
		ClearRaceKey("DragonPriests")
		AddRaceID("DragonPriests", "DragonPriestRace")
		AddRaceID("DragonPriests", "SkeletonNecroPriestRace")
		AddRaceID("DragonPriests", "DLC2AcolyteDragonPriestRace")

	;Dragons = Actors\Dragon\DragonProject.hkx
		ClearRaceKey("Dragons")
		AddRaceID("Dragons", "DragonRace")
		AddRaceID("Dragons", "AlduinRace")
		AddRaceID("Dragons", "UndeadDragonRace")
		AddRaceID("Dragons", "DLC1UndeadDragonRace")
		AddRaceID("Dragons", "DragonBlackRace")
		AddRaceID("Dragons", "DLC2DragonBlackRace")

	;Draugrs = Actors\Draugr\DraugrProject.hkx
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
		AddRaceID("Draugrs", "DLC2HulkingDraugrRace")
		AddRaceID("Draugrs", "DLC2AshSpawnRace")
		AddRaceID("Draugrs", "DLC2RigidSkeletonRace")

	;DwarvenBallistas = Actors\DLC02\DwarvenBallistaCenturion\BallistaCenturion.hkx
		ClearRaceKey("DwarvenBallistas")
		AddRaceID("DwarvenBallistas", "DLC2DwarvenBallistaRace")

	;DwarvenCenturions = Actors\DwarvenSteamCenturion\SteamProject.hkx
		ClearRaceKey("DwarvenCenturions")
		AddRaceID("DwarvenCenturions", "DwarvenCenturionRace")
		AddRaceID("DwarvenCenturions", "DLC1LD_ForgemasterRace")

	;DwarvenSpheres = Actors\DwarvenSphereCenturion\SphereCenturion.hkx
		ClearRaceKey("DwarvenSpheres")
		AddRaceID("DwarvenSpheres", "DwarvenSphereRace")

	;DwarvenSpiders = Actors\DwarvenSpider\DwarvenSpiderCenturionProject.hkx
		ClearRaceKey("DwarvenSpiders")
		AddRaceID("DwarvenSpiders", "DwarvenSpiderRace")

	;Falmers = Actors\Falmer\FalmerProject.hkx
		ClearRaceKey("Falmers")
		AddRaceID("Falmers", "FalmerRace")
		AddRaceID("Falmers", "DLC1SkinVampireFalmer")
		AddRaceID("Falmers", "FalmerFrozenVampRace")

	;FlameAtronach = Actors\AtronachFlame\AtronachFlame.hkx
		ClearRaceKey("FlameAtronach")
		AddRaceID("FlameAtronach", "AtronachFlameRace")

	;Foxes = Actors\Canine\WolfProject.hkx
		ClearRaceKey("Foxes")
		AddRaceID("Foxes", "FoxRace")

	;FrostAtronach = Actors\AtronachFrost\AtronachFrostProject.hkx
		ClearRaceKey("FrostAtronach")
		AddRaceID("FrostAtronach", "AtronachFrostRace")

	;Gargoyles = Actors\DLC01\VampireBrute\VampireBruteProject.hkx
		ClearRaceKey("Gargoyles")
		AddRaceID("Gargoyles", "DLC1GargoyleRace")
		AddRaceID("Gargoyles", "DLC1GargoyleVariantBossRace")
		AddRaceID("Gargoyles", "DLC1GargoyleVariantGreenRace")

	;Giants = Actors\Giant\GiantProject.hkx
		ClearRaceKey("Giants")
		AddRaceID("Giants", "GiantRace")
		AddRaceID("Giants", "DLC2GhostFrostGiantRace")

	;Goats = Actors\Goat\GoatProject.hkx
		ClearRaceKey("Goats")
		AddRaceID("Goats", "GoatDomesticRace")
		AddRaceID("Goats", "GoatRace")

	;Hagravens = Actors\Hagraven\HagravenProject.hkx
		ClearRaceKey("Hagravens")
		AddRaceID("Hagravens", "HagravenRace")

	;Horkers = Actors\Horker\HorkerProject.hkx
		ClearRaceKey("Horkers")
		AddRaceID("Horkers", "HorkerRace")

	;Horses = Actors\Horse\HorseProject.hkx
		ClearRaceKey("Horses")
		AddRaceID("Horses", "HorseRace")

	;IceWraiths = Actors\IceWraith\IceWraithProject.hkx
		ClearRaceKey("IceWraiths")
		AddRaceID("IceWraiths", "IceWraithRace")
		AddRaceID("IceWraiths", "dlc2SpectralDragonRace")

	;Lurkers = Actors\DLC02\BenthicLurker\BenthicLurkerProject.hkx
		ClearRaceKey("Lurkers")
		AddRaceID("Lurkers", "DLC2LurkerRace")

	;Mammoths = Actors\Mammoth\MammothProject.hkx
		ClearRaceKey("Mammoths")
		AddRaceID("Mammoths", "MammothRace")

	;Mudcrabs = Actors\Mudcrab\MudcrabProject.hkx
		ClearRaceKey("Mudcrabs")
		AddRaceID("Mudcrabs", "MudcrabRace")
		AddRaceID("Mudcrabs", "DLC2MudcrabSolstheimRace")

	;Netches = Actors\DLC02\Netch\NetchProject.hkx
		ClearRaceKey("Netches")
		AddRaceID("Netches", "DLC2NetchRace")

	;Rabbits = Actors\Ambient\Hare\HareProject.hkx
		ClearRaceKey("Rabbits")
		AddRaceID("Rabbits", "HareRace")

	;Rieklings = Actors\DLC02\Riekling\RieklingProject.hkx
		ClearRaceKey("Rieklings")
		AddRaceID("Rieklings", "DLC2RieklingRace")
		AddRaceID("Rieklings", "DLC2ThirskRieklingRace")

	;SabreCats = Actors\SabreCat\SabreCatProject.hkx
		ClearRaceKey("SabreCats")
		AddRaceID("SabreCats", "SabreCatRace")
		AddRaceID("SabreCats", "SabreCatSnowyRace")
		AddRaceID("SabreCats", "DLC1SabreCatGlowRace")

	;Seekers = Actors\DLC02\HMDaedra\HMDaedra.hkx
		ClearRaceKey("Seekers")
		AddRaceID("Seekers", "DLC2SeekerRace")

	;Skeevers = Actors\Skeever\SkeeverProject.hkx
		ClearRaceKey("Skeevers")
		AddRaceID("Skeevers", "SkeeverRace")
		AddRaceID("skeevers", "SkeeverWhiteRace")

	;Slaughterfishes = Actors\Slaughterfish\SlaughterfishProject.hkx
		ClearRaceKey("Slaughterfishes")
		AddRaceID("Slaughterfishes", "SlaughterfishRace")

	;StormAtronach = Actors\AtronachStorm\AtronachStormProject.hkx
		ClearRaceKey("StormAtronach")
		AddRaceID("StormAtronach", "AtronachStormRace")
		AddRaceID("StormAtronach", "dlc2AshGuardianRace")

	;Spiders = Actors\FrostbiteSpider\FrostbiteSpiderProject.hkx
		ClearRaceKey("Spiders")
		AddRaceID("Spiders", "FrostbiteSpiderRace")
		AddRaceID("Spiders", "DLC2ExpSpiderBaseRace")
		AddRaceID("Spiders", "DLC2ExpSpiderPackmuleRace")

	;LargeSpiders = Actors\FrostbiteSpider\FrostbiteSpiderProject.hkx
		ClearRaceKey("LargeSpiders")
		AddRaceID("LargeSpiders", "FrostbiteSpiderRaceLarge")

	;GiantSpiders = Actors\FrostbiteSpider\FrostbiteSpiderProject.hkx
		ClearRaceKey("GiantSpiders")
		AddRaceID("GiantSpiders", "FrostbiteSpiderRaceGiant")

	;Spriggans = Actors\Spriggan\Spriggan.hkx
		ClearRaceKey("Spriggans")
		AddRaceID("Spriggans", "SprigganRace")
		AddRaceID("Spriggans", "SprigganMatronRace")
		AddRaceID("Spriggans", "SprigganEarthMotherRace")
		AddRaceID("Spriggans", "DLC2SprigganBurntRace")

	;Trolls = Actors\Troll\TrollProject.hkx
		ClearRaceKey("Trolls")
		AddRaceID("Trolls", "TrollRace")
		AddRaceID("Trolls", "TrollFrostRace")
		AddRaceID("Trolls", "DLC1TrollFrostRaceArmored")
		AddRaceID("Trolls", "DLC1TrollRaceArmored")

	;VampireLords = Actors\VampireLord\VampireLord.hkx
		ClearRaceKey("VampireLords")
		AddRaceID("VampireLords", "DLC1VampireBeastRace")

	;Werewolves = Actors\WerewolfBeast\WerewolfBeastProject.hkx
		ClearRaceKey("Werewolves")
		AddRaceID("Werewolves", "WerewolfBeastRace")
		AddRaceID("Werewolves", "DLC2WerebearBeastRace")

	;WispMothers = Actors\Wisp\WispProject.hkx
		ClearRaceKey("WispMothers")
		AddRaceID("WispMothers", "WispRace")
		AddRaceID("WispMothers", "WispShadeRace")

	;Wisps = Actors\Witchlight\WitchlightProject.hkx
		ClearRaceKey("Wisps")
		AddRaceID("Wisps", "WitchlightRace")
		AddRaceID("Wisps", "DLC1SoulCairnSoulWispRace")
		AddRaceID("Wisps", "DLC2dunInstrumentsRace")

	;Wolves = Actors\Canine\WolfProject.hkx
		ClearRaceKey("Wolves")
		AddRaceID("Wolves", "WolfRace")
		AddRaceID("Wolves", "DLC1DeathHoundCompanionRace")
		AddRaceID("Wolves", "DLC1DeathHoundRace")

	; Send creature race key registration event
	ModEvent.Send(ModEvent.Create("SexLabRegisterCreatureKey"))
endFunction
