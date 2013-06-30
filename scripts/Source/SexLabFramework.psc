scriptname SexLabFramework extends Quest

;####################################################
;############ SEXLAB ANIMATION FRAMEWORK ############
;####################################################
;#--------------------------------------------------#
;#-                                                -#
;#-        Created by Ashal@LoversLab.com          -#
;#-     http://www.loverslab.com/user/1-ashal/     -#
;#-                                                -#
;#--------------------------------------------------#
;####################################################

;Load our configuration settings from MCM
sslSystemConfig property config auto
;Load our resources data
sslSystemResources property data auto

;#---------------------------#
;# Start Animation Variables #
;#---------------------------#
; Current number of default threads available
int threadCount = 15
sslBaseThread[] thread
sslThread00 property Thread00 auto
sslThread01 property Thread01 auto
sslThread02 property Thread02 auto
sslThread03 property Thread03 auto
sslThread04 property Thread04 auto
sslThread05 property Thread05 auto
sslThread06 property Thread06 auto
sslThread07 property Thread07 auto
sslThread08 property Thread08 auto
sslThread09 property Thread09 auto
sslThread10 property Thread10 auto
sslThread11 property Thread11 auto
sslThread12 property Thread12 auto
sslThread13 property Thread13 auto
sslThread14 property Thread14 auto
; Available animation slots/threads
bool[] activeThread

; Animation Sets
sslBaseAnimation[] property animation auto
int animIndex = 0

; Animation Faction
faction property AnimatingFaction auto

; Reference Alias for DoNothing package
ReferenceAlias property DoNothing00 auto
ReferenceAlias property DoNothing01 auto
ReferenceAlias property DoNothing02 auto
ReferenceAlias property DoNothing03 auto
ReferenceAlias property DoNothing04 auto
ReferenceAlias property DoNothing05 auto
ReferenceAlias property DoNothing06 auto
ReferenceAlias property DoNothing07 auto
ReferenceAlias property DoNothing08 auto
ReferenceAlias property DoNothing09 auto
ReferenceAlias property DoNothing10 auto
ReferenceAlias property DoNothing11 auto
ReferenceAlias property DoNothing12 auto
ReferenceAlias property DoNothing13 auto
ReferenceAlias property DoNothing14 auto
ReferenceAlias[] property DoNothing auto
;#---------------------------#
;#  End Animation Variables  #
;#---------------------------#

; Debug Spell Actor Storage, for Development use only
actor property DebugActor auto hidden

; Voice Files
sslBaseVoice[] property voice auto
int voiceIndex = 0

; local vars
bool enabled = false
bool ready = false
bool hkready = false
bool clean = false

; The Player (That's you!)
actor property PlayerRef auto
int playerThread = -1

;#---------------------------#
;#                           #
;#   API RELATED FUNCTIONS   #
;#                           #
;#---------------------------#

int function StartSex(actor[] sexActors, sslBaseAnimation[] anims, actor victim = none, ObjectReference centerOn = none, bool allowBed = true, string hook = "")
	if !enabled
		Data.mSystemDisabled.Show()
		_DebugTrace("StartSex","","Failed to start animation; system is currently disabled")
		return -99
	endIf

	_ReadyWait()
	ready = false
	clean = false

	int i = 0
	int playerPosition = -1
	bool aggr = false
	int actorCount = sexActors.Length
	int animCount = anims.Length
	int males = 0
	int females = 0

	if actorCount == 0
		ready = true
		_DebugTrace("StartSex","sexActors="+sexActors,"Failed to start animation; no actors passed")
		return -2 ; No Actors passed
	endIf

	if victim != none
		aggr = true
	endIf

	; Validate Actors & get genders
	i = 0
	while i < actorCount
		int validate = ValidateActor(sexActors[i])
		if validate < 0
			ready = true
			return validate ; Failed Validation
		endIf

		if sexActors[i].GetLeveledActorBase().GetSex() == 1
			females += 1
		else
			males += 1
		endIf

		int first = sexActors.Find(sexActors[i])
		int last = sexActors.RFind(sexActors[i])
		if first != last
			ready = true
			_DebugTrace("StartSex","sexActors="+sexActors,"Failed to start animation; duplicate actor found in list")
			return -3
		endIf

		if sexActors[i] == PlayerRef
			playerPosition = i
		endIf
		i += 1
	endWhile

	; No animations passed, get some
	if animCount == 0
		if (females == 2 && males == 0) || (males == 2 && females == 0)
			; Don't limit to just same sex animations for same sex pairings
			anims = GetAnimationsByType(actorCount, 1, 1, aggressive=aggr)
			sslBaseAnimation[] animsSameSex = GetAnimationsByType(actorCount, males, females, aggressive=aggr)
			anims = MergeAnimationLists(anims, animsSameSex)
		elseif actorCount < 3
			; Grab animations like normal
			anims = GetAnimationsByType(actorCount, males, females, aggressive=aggr)
		elseif actorCount >= 3
			; Get 3p + animations ignoring gender
			anims = GetAnimationsByType(actorCount, aggressive=aggr)
		endIf
	endIf
	
	if anims.Length < 1
		ready = true
		_DebugTrace("StartSex","sexActors="+sexActors+", anims="+anims,"Failed to start animation; no valid animations found")
		return -4
	endIf

	; Find a bed to center on if we can use one
	ObjectReference bed
	if allowBed && playerPosition != -1 && centerOn == none
		bed = Game.FindClosestReferenceOfAnyTypeInListFromRef(Data.BedsList, PlayerRef, 500.0)
	elseif allowBed && playerPosition == -1 && centerOn == none
		bed = Game.FindClosestReferenceOfAnyTypeInListFromRef(Data.BedsList, sexActors[0], 500.0)
	endIf

	; A bed was selected, should we use it?
	if bed != none && centerOn == none
		int useBed = 0
		if playerPosition != -1 && PlayerRef != victim
			useBed = Data.mUseBed.Show()
		elseif Config.sNPCBed == "Always"
			useBed = 1
		elseif Config.sNPCBed == "Sometimes"
			useBed = utility.RandomInt(0,1)
		endIf

		if useBed == 1
			centerOn = bed
		endIf
	endIf

	; Find a marker near one of our actors and center there
	if centerOn == none
		i = 0
		while i < actorCount
			form marker = Game.FindRandomReferenceOfTypeFromRef(Data.LocationMarker, sexActors[i], 600.0)
			if marker != none
				centerOn = marker as ObjectReference
				i = actorCount
			endIf
			i += 1
		endWhile
	endIf

	; Determine if foreplay should be used
	sslBaseAnimation[] foreplay
	if !aggr && actorCount > 1 && Config.bForeplayStage
		foreplay = GetAnimationsByTag(actorCount, "Foreplay")
	endIf

	; Center on actor[0] and place victim there if still none
	if centerOn == none && victim != none
		centerOn = victim
	elseif centerOn == none && victim == none && playerPosition == -1
		centerOn = sexActors[0]
	elseIf centerOn == none && victim == none && playerPosition != -1
		centerOn = sexActors[playerPosition]
	endIf

	int SexThread = PickThread(true)
	if SexThread >= 0
		_DebugTrace("StartSex","sexActors="+sexActors,"Starting animation thread["+sexThread+"]")
		thread[SexThread].SpawnThread(sexActors, anims, foreplay, victim, centerOn, hook)
	else
		_DebugTrace("StartSex","sexActors="+sexActors,"Failed to start animation; no available animation slots")
	endIf
	ready = true
	return SexThread
endFunction

int function PickThread(bool claim = false)
	int i = 0
	while i < threadCount
		if !activeThread[i]
			activeThread[i] = claim
			return i
		endIf
	endWhile
	_DebugTrace("PickThread","claim="+claim,"Failed to find a non-active animation thread.")
	return -1
endFunction

int function ValidateActor(actor a)
	if a.IsInFaction(AnimatingFaction)
		_DebugTrace("ValidateActor","actor="+a,"Failed to start animation; actor appears to already be in an animation")
		return -10
	endIf
	if a.IsDead()
		_DebugTrace("ValidateActor","actor="+a,"Failed to start animation; actor is dead")
		return -11
	endIf
	if a.IsDisabled()
		_DebugTrace("ValidateActor","actor="+a,"Failed to start animation; actor is disabled")
		return -12
	endIf
	if a.IsChild() || a.GetLeveledActorBase().GetRace().IsRaceFlagSet(0x00000004)
		_DebugTrace("ValidateActor","actor="+a,"Failed to start animation; actor is child")
		return -13
	endIf
	if a.HasKeyWordString("ActorTypeCreature") || a.HasKeyWordString("ActorTypeDwarven")
		_DebugTrace("ValidateActor","actor="+a,"Failed to start animation; actor is a creature or Dwemer that is currently not supported")
		return -14
	endIf
	return 1
endFunction

actor[] function SortActors(actor[] actorList, bool femaleFirst = true)
	int actorCount = actorList.Length
	if actorCount == 1
		return actorList ; Why reorder a single actor?
	endIf

	int priorityGender = 1
	if !femaleFirst
		priorityGender = 0
	endIf

	int orderSlot = 0
	int i = 0
	while i < actorCount
		actor a = actorList[i]
		if a.GetLeveledActorBase().GetSex() == priorityGender && i > orderSlot
			actor moved = actorList[orderSlot]
			actorList[orderSlot] = a
			actorList[i] = moved
			orderSlot += 1
		endIf
		i += 1
	endWhile
	
	return actorList
endFunction 

function ApplyCum(actor a, int cumID)
	if cumID == 1
		Data.CumVaginal.Play(a, Config.fCumTimer)
	elseif cumID == 2
		Data.CumOral.Play(a, Config.fCumTimer)
	elseif cumID == 3
		Data.CumAnal.Play(a, Config.fCumTimer)
	elseif cumID == 4
		Data.CumVaginalOral.Play(a, Config.fCumTimer)
	elseif cumID == 5
		Data.CumVaginalAnal.Play(a, Config.fCumTimer)
	elseif cumID == 6
		Data.CumOralAnal.Play(a, Config.fCumTimer)
	elseif cumID == 7
		Data.CumVaginalOralAnal.Play(a, Config.fCumTimer)
	endIf
endFunction

form[] function StripActor(actor a, actor victim = none)
	int gender = a.GetLeveledActorBase().GetSex()
	bool[] strip
	if victim != none && a == victim
		strip = Config.bStripVictim
	elseif victim != none && a != victim
		strip = Config.bStripAggressor
	elseif victim == none && gender < 1
		strip = Config.bStripMale
	else
		strip = Config.bstripFemale
	endIf
	return StripSlots(a, strip)
endFunction

form[] function StripSlots(actor a, bool[] strip, bool allowNudesuit = true)

	if strip.Length != 33
		_DebugTrace("StripSlots","actor="+a+", strip="+strip+", allowNudesuit="+allowNudesuit,"Not enough strip slots passed, should be bool size 33")
		return none
	endIf

	int gender = a.GetLeveledActorBase().GetSex()
	form[] items
	int mask
	armor item
	weapon eWeap
	spell eSpell

	if gender > 0
		Debug.SendAnimationEvent(a, "Arrok_FemaleUndress")
	else
		Debug.SendAnimationEvent(a, "Arrok_MaleUndress")
	endIf

	; Use Strip settings
	int i = 0
	while i < 33
		if strip[i] && i != 32
			mask = armor.GetMaskForSlot(i + 30)
			item = a.GetWornForm(mask) as armor
			if item != none && !item.HasKeyWordString("SexLabNoStrip")
				a.UnequipItem(item, false, true)
				items = sslUtility.PushForm(item, items)
				utility.wait(0.3)
			endIf 
		elseif strip[i] && i == 32
			eWeap = a.GetEquippedWeapon(true)
			if eWeap != none && !item.HasKeyWordString("SexLabNoStrip")
				a.UnequipItem(eWeap, false, true)
				items = sslUtility.PushForm(eWeap, items)
			endIf
			eWeap = a.GetEquippedWeapon(false)
			if eWeap != none && !item.HasKeyWordString("SexLabNoStrip")
				a.UnequipItem(eWeap, false, true)
				items = sslUtility.PushForm(eWeap, items)
			endIf
		endIf
		i += 1
	endWhile

	; Apply Nudesuit
	if strip[2] && allowNudesuit
		if (gender < 1 && Config.bUseMaleNudeSuit) || (gender == 1  && Config.bUseFemaleNudeSuit)
			a.EquipItem(Data.aNudeSuit, false, true)
		endIf
	endIf

	Debug.SendAnimationEvent(a, "IdleForceDefaultState")

	return items
endFunction

function UnstripActor(actor a, form[] stripped, actor victim = none)
	int i = stripped.Length
	if i < 1
		_DebugTrace("EquipStrapon","actor="+a+", stripped="+stripped+", victim="+victim,"No items passed to stripped argument for actor to equip")
	endIf

	; Remove nudesuits
	int gender = a.GetLeveledActorBase().GetSex()
	if (gender < 2 && Config.bUseMaleNudeSuit) || (gender == 1  && Config.bUseFemaleNudeSuit)
		a.UnequipItem(Data.aNudeSuit, false, true)
		a.RemoveItem(Data.aNudeSuit, 1, true)
	endIf

	if a == victim && !Config.bReDressVictim
		return ; Don't requip victims
	endIf
	; Requip stripped
	int hand = 1

	while i
		i -= 1
		int type = stripped[i].GetType()
		if type == 22 || type == 82
			a.EquipSpell(stripped[i] as spell, hand)
		else
			a.EquipItem(stripped[i], false, true)
		endIf
		; Move to other hand if weapon, light, spell, or leveledspell
		if type == 41 || type == 31 || type == 22 || type == 82
			hand = 0
		endIf
	endWhile
endFunction

form function EquipStrapon(actor a)
	int straponCount = Data.strapons.Length
	if straponCount == 0
		return none
	endIf

	if a.GetLeveledActorBase().GetSex() == 1
		int sid = utility.RandomInt(0, straponCount - 1)
		a.EquipItem(Data.strapons[sid], false, true)
		return Data.strapons[sid]
	else
		_DebugTrace("EquipStrapon","actor="+a+"","Is male and cannot use strapons")
		return none
	endIf
endFunction

int[] function GenderCount(actor[] pos)
	int[] genders = new int[2]
	int i = 0
	while i < pos.Length
		if pos[i].GetLeveledActorBase().GetSex() > 0
			genders[1] = ( genders[1] + 1 )
		else
			genders[0] = ( genders[0] + 1 )
		endIf
		i += 1
	endWhile
	return genders
endFunction

int function MaleCount(actor[] pos)
	int[] gender = GenderCount(pos)
	return gender[0]
endFunction

int function FemaleCount(actor[] pos)
	int[] gender = GenderCount(pos)
	return gender[1]
endFunction

;#---------------------------#
;#  BEGIN THREAD FUNCTIONS   #
;#---------------------------#

int function FindActorThread(actor toFind)
	int i = 0
	while i < threadCount
		if activeThread[i]
			actor[] actorList = thread[i].GetActors()
			int p = 0
			while p < actorList.Length
				if actorList[p] == toFind
					return i
				endIf
				p += 1
			endWhile
		endIf
		i += 1
	endWhile
	return -1
endFunction

sslBaseThread function GetActorThread(actor toFind)
	int tid = FindActorThread(toFind)
	if tid != -1
		return thread[tid]
	else
		return none
	endIf
endFunction

int function FindPlayerThread()
	return playerThread
endFunction

sslBaseThread function GetPlayerThread()
	return thread[playerThread]
endFunction

sslBaseThread function GetThread(int tid)
	return thread[tid]
endFunction

;#---------------------------#
;#   END THREAD FUNCTIONS    #
;#---------------------------#

;#---------------------------#
;# BEGIN ANIMATION FUNCTIONS #
;#---------------------------#

sslBaseAnimation function GetAnimationByName(string findName)
	int i = 0
	while i < animIndex
		if animation[i].name == findName
			return animation[i]
		endIf
		i += 1
	endWhile
	return none
endFunction

sslBaseAnimation[] function GetAnimationsByType(int actors, int males = -1, int females = -1, int stages = -1, bool aggressive = false, bool sexual = true)
	sslBaseAnimation[] animReturn
	int i = 0

	while i < animIndex
		if animation[i] != none && animation[i].enabled
			int actorCount = animation[i].ActorCount()
			int stageCount = animation[i].StageCount()
			bool sexualAnim = animation[i].IsSexual()
			bool aggressiveAnim = animation[i].HasTag("Aggressive")
			int maleCount = 0
			int femaleCount = 0

			int g = 0
			while g < actorCount
				if animation[i].GetGender(g) == 1
					femaleCount += 1
				else
					maleCount += 1
				endIf
				g += 1
			endWhile

			bool accepted = true
			if actors != actorCount
				accepted = false
			endIf
			if accepted && males != -1 && males != maleCount
				accepted = false
			endIf
			if accepted && females != -1 && females != femaleCount
				accepted = false
			endIf
			if accepted && stages != -1 && stages != stageCount
				accepted = false
			endIf
			if accepted && (aggressive != aggressiveAnim && Config.bRestrictAggressive)
				accepted = false
			endIf
			if accepted && sexual != sexualAnim
				accepted = false
			endIf

			; Still accepted? Push it's return
			if accepted
				animReturn = sslUtility.PushAnimation(animation[i], animReturn)
			endIf
		endIf
		i += 1
	endWhile
	_DebugTrace("GetAnimationsByType","actors="+actors+", males="+males+", females="+females+", stages="+stages+", aggress="+aggressive+", sexual="+sexual,"Selected "+animReturn)
	return animReturn
endFunction

sslBaseAnimation[] function GetAnimationsByTag(int actors, string tag1, string tag2 = "", string tag3 = "", string tagSuppress = "", bool requireAll = true)
	sslBaseAnimation[] animReturn

	int i = 0
	while i < animIndex
		if animation[i].enabled && animation[i].ActorCount() == actors
			bool check1 = animation[i].HasTag(tag1)
			bool check2 = animation[i].HasTag(tag2)
			bool check3 = animation[i].HasTag(tag3)
			bool supress = animation[i].HasTag(tagSuppress)
			if requireAll && check1 && check2 && check3 && !(supress && tagSuppress != "")
				animReturn = sslUtility.PushAnimation(animation[i], animReturn)
			elseif !requireAll && (check1 || check2 || check3) && !(supress && tagSuppress != "")
				animReturn = sslUtility.PushAnimation(animation[i], animReturn)
			else
				; debug.trace("Rejecting "+animation[i].name+" based on "+check1+check2+check3+supress)
			endIf
		endIf
		i += 1
	endWhile
	_DebugTrace("GetAnimationsByTag","tag1="+tag1+", tag2="+tag2+", tag3="+tag3+", tagSuppress="+tagSuppress,"Selected "+animReturn)
	return animReturn
endFunction

sslBaseAnimation[] function MergeAnimationLists(sslBaseAnimation[] list1, sslBaseAnimation[] list2)
	int list1Count = list1.Length
	int list2Count = list2.Length
	int newCount = list1Count + list2Count
	sslBaseAnimation[] anims
	int i = 0
	while i < list1Count
		anims = sslUtility.PushAnimation(list1[i],anims)
		i+= 1
	endWhile
	i = 0
	while i < list2Count
		anims = sslUtility.PushAnimation(list2[i],anims)
		i+= 1
	endWhile
	return anims
endFunction

int function FindAnimationByName(string findName)
	if animIndex >= 0
		int i = 0
		while i < animIndex
			if animation[i] != none && animation[i].name == findName
				return i
			endIf
			i += 1
		endWhile
	endIf
	return -1
endFunction

int function GetAnimationCount(bool ignoreDisabled = true)
	int count = 0
	int i = 0
	while i < animIndex
		if animation[i] != none && ignoreDisabled && animation[i].enabled
			count += 1
		elseif animation[i] != none && !ignoreDisabled
			count += 1
		endIf
		i += 1
	endWhile
	return count
endFunction

int function RegisterAnimation(sslBaseAnimation anim)
	_ReadyWait()
	ready = false
	int aid = FindAnimationByName(anim.name)

	; Animation not found, register it.
	if aid < 0
		aid = animIndex
		animation[aid] = anim
		animation[aid].LoadAnimation()
		_DebugTrace("RegisterAnimation","Animation script successfully registered",anim.name)
		animIndex += 1
	endIf

	ready = true
	return aid
endFunction
;#---------------------------#
;#  END ANIMATION FUNCTIONS  #
;#---------------------------#

;#---------------------------#
;#   BEGIN VOICE FUNCTIONS   #
;#---------------------------#

sslBaseVoice function PickVoice(actor a)
	int g = a.GetLeveledActorBase().GetSex()
	if a == PlayerRef && Config.sPlayerVoice != "Random"
		return GetVoiceByName(Config.sPlayerVoice)
	else
		return GetVoiceByGender(g)
	endIf
endFunction

sslBaseVoice function GetVoiceByGender(int g)
	int[] voiceSelection
	int i = 0
	while i < voiceIndex
		if voice[i] != none && voice[i].gender == g && voice[i].enabled
			voiceSelection = sslUtility.PushInt(i,voiceSelection)
		endIf
		i += 1
	endWhile

	int found = voiceSelection.Length

	if found == 0
		return none
	endIf

	int random = utility.RandomInt(0, found - 1)
	int vid = voiceSelection[random]
	return voice[vid]
endFunction

sslBaseVoice function GetVoiceByName(string findName)
	int i = 0
	while i < voiceIndex
		if voice[i] != none && voice[i].name == findName
			return voice[i]
		endIf
		i += 1
	endWhile
	return none
endFunction

int function FindVoiceByName(string findName)
	if voiceIndex >= 0
		int i = 0
		while i < voiceIndex
			if voice[i] != none && voice[i].name == findName
				return i
			endIf
			i += 1
		endWhile
	endIf
	return -1
endFunction

int function RegisterVoice(sslBaseVoice vc)
	_ReadyWait()
	ready = false

	int vid = FindVoiceByName(vc.name)

	; Animation already registered, return it's index
	if vid >= 0
		; debug.trace("----SexLab---- Skipping Voice '"+vc.name+"'. Already registered under index ["+vid+"]")
	; Appears to be new, register it and return new index
	else
		vid = voiceIndex
		voice[vid] = vc
		voice[vid].LoadVoice()
		_DebugTrace("RegisterVoice",vc.name,"Voice script successfully registered")
		voiceIndex += 1
	endIf

	ready = true
	return vid
endFunction
;#---------------------------#
;#    END VOICE FUNCTIONS    #
;#---------------------------#

;#---------------------------#
;#    START HOOK FUNCTIONS   #
;#---------------------------#

sslBaseThread function HookThread(string argString)
	return thread[(argString as int)]
endFunction

sslBaseAnimation function HookAnimation(string argString)
	return thread[(argString as int)].GetAnimation()
endFunction

int function HookStage(string argString)
	return thread[(argString as int)].GetStage()
endFunction

actor function HookVictim(string argString)
	return thread[(argString as int)].GetVictim()
endFunction

actor[] function HookActors(string argString)
	return thread[(argString as int)].GetActors()
endFunction

float function HookTime(string argString)
	return thread[(argString as int)].GetTime()
endFunction

;#---------------------------#
;#    END HOOK FUNCTIONS     #
;#---------------------------#

;#---------------------------#
;#   START STAT FUNCTIONS    #
;#---------------------------#

function UpdatePlayerStats(sslBaseAnimation anim, float time, actor[] pos, actor victim)
	if !anim.IsSexual()
		return
	endIf
	; Update time spent
	Data.fTimeSpent = Data.fTimeSpent + time
	; Don't count the player in partner counts
	int PlayerSex = PlayerRef.GetActorBase().GetSex()

	int[] genders = GenderCount(pos)
	int males = genders[0]
	int females = genders[1]

	if PlayerSex > 0
		Data.iMalePartners = Data.iMalePartners + males
		Data.iFemalePartners = Data.iFemalePartners + (females - 1)
	else
		Data.iMalePartners = Data.iMalePartners + (males - 1)
		Data.iFemalePartners = Data.iFemalePartners + females
	endIf
	int partners = (males + females) - 1
	bool anal = anim.HasTag("Anal")
	bool vaginal = anim.HasTag("Vaginal")
	bool oral = anim.HasTag("Oral")
	bool solo = anim.HasTag("Masturbation")
	; Vaginal tag but no vaginas present, gay male pairing?
	if vaginal && females == 0 && !solo
		vaginal = false
		anal = true
	endIf
	; Update type counts
	if anal
		Data.iAnalCount = Data.iAnalCount + 1
	endIf
	if vaginal
		Data.iVaginalCount = Data.iVaginalCount + 1
	endIf
	if oral
		Data.iOralCount = Data.iOralCount + 1
	endIf
	if solo
		Data.iMasturbationCount = Data.iMasturbationCount + 1
		AdjustPlayerPurity(-1.0)
		return ; masturbation does it's own pervert/purity, don't continue
	endIf
	; Update perversion
	bool dirty = anim.HasTag("Dirty")
	bool loving = anim.HasTag("Loving")
	if dirty
		AdjustPlayerPurity(-2.5 * partners)
	endIf
	if loving
		AdjustPlayerPurity(2.5 * partners)
	elseIf !loving && !dirty
		AdjustPlayerPurity(Utility.RandomFloat(-1.0, 1.0) * partners)
	endIf
	; Victim/Aggressor
	if victim != none
		if victim == PlayerRef
			; Victim
			Data.iVictimCount = Data.iVictimCount + 1
			AdjustPlayerPurity(-1.2 * partners)
		else 
			; Aggressor
			Data.iAggressorCount = Data.iAggressorCount + 1
			AdjustPlayerPurity(-2.5 * partners)
		endIf
	endIf
endFunction

float function AdjustPlayerPurity(float amount)
	float current = (Data.fSexualPurity + amount)
	Data.fSexualPurity = current
	return current
endFunction

int function GetPlayerPurityLevel()
	float level = (Data.fSexualPurity * 1)
	if level < 0
		; Flip float signing for impure, but return to signed for level number
		level = (Math.Sqrt((((Data.fSexualPurity * -1.0) + 1.0) / 2.0) * 0.2) * -1.0) 
	else
		level = Math.Sqrt(((Data.fSexualPurity + 1.0) / 2.0) * 0.2)
	endIf
	return level as int ; Return as int to floor value for level number
endFunction

string function GetPlayerPurityTitle()
	int level = GetPlayerPurityLevel()
	string[] titles
	if level < 0
		level = level * -1
		titles = Config.sImpureTitles
	else
		titles = Config.sPureTitles
	endIf
	; Clamp levels to titles array
	string title
	if level > 6
		title = titles[6]
	elseif level < 0
		title = titles[0]
	else
		title = titles[level]
	endIf
	; Return title
	return title+" ("+level+")"
endFunction

string function GetPlayerSexuality()
	int males = Data.iMalePartners
	int females = Data.iFemalePartners
	int partners = 1 + (males + females)
	int gender = PlayerRef.GetActorBase().GetSex()
	float ratio
	if gender > 0
		ratio = ((males + 1.0) / partners as float) * 100.0
	else
		ratio = ((females + 1.0) / partners as float) * 100.0
	endIf
	if ratio <= 35 && gender > 0
		return "Lesbian"
	elseIf ratio <= 35 && gender < 1
		return "Gay"
	elseIf ratio > 35 && ratio < 65
		return "Bisexual"
	else
		return "Straight"
	endIf
endFunction

int function GetPlayerStatLevel(string type)
	float val
	if type == "Vaginal"
		val = Data.iVaginalCount as float
	elseIf type == "Anal"
		val = Data.iAnalCount as float
	elseIf type == "Oral"
		val = Data.iOralCount as float
	else
		return -1
	endIf
	float level = Math.Sqrt(((val + 1.0) / 2.0) * 0.65)
	return level as int ; Return as int to floor value for level number
endFunction

string function GetPlayerStatTitle(string type)
	int level = GetPlayerStatLevel(type)
	; Clamp levels to titles array
	string title
	if level > 6
		title = Config.sStatTitles[6]
	elseif level < 0
		title = Config.sStatTitles[0]
	else
		title = Config.sStatTitles[level]
	endIf
	; Return title
	return title+" ("+level+")"
endFunction

;#---------------------------#
;#    END STAT FUNCTIONS     #
;#---------------------------#



;#---------------------------#
;#                           #
;# END API RELATED FUNCTIONS #
;#                           #
;#---------------------------#


;#---------------------------#
;#  System Related Functions #
;#---------------------------#

event OnInit()
	ready = true
	_DebugTrace("OnInit","","SYSTEM INITIALIZED")
endEvent

function _StopAnimations()
	int i = 0
	while i < threadCount
		if activeThread[i]
			thread[i].EndAnimation(quick = true)
		endIf
		i += 1
	endWhile
	activeThread = new bool[15]
endFunction

function _ClearAnimations()
	if animIndex == 0
		return
	endIf

	int i = 0
	while i < animIndex
		animation[i].UnloadAnimation()
		animation[i].Reset()
		i += 1
	endWhile
	animation = new sslBaseAnimation[128]
	animIndex = 0
endFunction

function _ClearVoices()
	if voiceIndex == 0
		return
	endIf

	int i = 0
	while i < voiceIndex
		voice[i].UnloadVoice()
		voice[i].Reset()
		i += 1
	endWhile
	voice = new sslBaseVoice[128]
	voiceIndex = 0
endFunction

function _CleanSystem()
	while Utility.IsInMenuMode()
	endWhile

	_ReadyWait()
	ready = false

	; Data.mCleanSystemStart.Show()

	int i = 0
	while i < threadCount
		thread[i].EndAnimation(quick = true)
		utility.Wait(0.1)
		i += 1
	endWhile

	_ClearAnimations()
	_ClearVoices()
	_SetupSystem()
	Config.SetDefaults()

	Data.mCleanSystemFinish.Show()

	clean = true
	hkReady = true
	ready = true
endFunction

function _SetupSystem()
	Start()
	; Init animations
	animation = new sslBaseAnimation[128]
	animIndex = 0

	; Init voices
	voice = new sslBaseVoice[128]
	voiceIndex = 0

	; Init thread variables based on current thread count: 15
	thread = new sslBaseThread[15]
	thread[0] = Thread00 as sslThread00
	thread[1] = Thread01 as sslThread01
	thread[2] = Thread02 as sslThread02
	thread[3] = Thread03 as sslThread03
	thread[4] = Thread04 as sslThread04
	thread[5] = Thread05 as sslThread05
	thread[6] = Thread06 as sslThread06
	thread[7] = Thread07 as sslThread07
	thread[8] = Thread08 as sslThread08
	thread[9] = Thread09 as sslThread09
	thread[10] = Thread10 as sslThread10
	thread[11] = Thread11 as sslThread11
	thread[12] = Thread12 as sslThread12
	thread[13] = Thread13 as sslThread13
	thread[14] = Thread14 as sslThread14
	activeThread = new bool[15]

	DoNothing = new ReferenceAlias[15]
	DoNothing[0] = DoNothing00
	DoNothing[1] = DoNothing01
	DoNothing[2] = DoNothing02
	DoNothing[3] = DoNothing03
	DoNothing[4] = DoNothing04
	DoNothing[5] = DoNothing05
	DoNothing[6] = DoNothing06
	DoNothing[7] = DoNothing07
	DoNothing[8] = DoNothing08
	DoNothing[9] = DoNothing09
	DoNothing[10] = DoNothing10
	DoNothing[11] = DoNothing11
	DoNothing[12] = DoNothing12
	DoNothing[13] = DoNothing13
	DoNothing[14] = DoNothing14
	int i = 15
	while i < 15
		DoNothing[i].Clear()
		thread[i].Reset()
		i += 1
	endWhile
endFunction

bool function _CheckClean()
	return clean
endFunction

function _CheckSystem()
	_ReadyWait()
	ready = false
	enabled = true

	; Check SKSE Version
	float skseNeeded = 1.0609
	float skseInstalled = SKSE.GetVersion() + SKSE.GetVersionMinor() * 0.01 + SKSE.GetVersionBeta() * 0.0001
	if skseInstalled == 0
		Data.mNoSKSE.Show()
		enabled = false
	elseif skseInstalled < skseNeeded
		Data.mOldSKSE.Show(skseInstalled, skseNeeded)
		enabled = false
	endIf
	
	; Check Skyrim Version
	float skyrimNeeded = 1.8
	float skyrimMajor = StringUtil.SubString(Debug.GetVersionNumber(), 0, 3) as float
	if skyrimMajor < skyrimNeeded
		Data.mOldSkyrim.Show(skyrimMajor, skyrimNeeded)
		enabled = false
	endIf

	; Load Strapons
	Data.FindStrapons()

	; Add debug spell
	if Config.DebugMode() && !PlayerRef.HasSpell(Data.SexLabDebugSpell)
		PlayerRef.AddSpell(Data.SexLabDebugSpell, true)
		DebugActor = none
	endIf

	hkReady = true
	ready = true
endFunction

function _SendEventHook(string eventName, int threadID, string customHook = "")
	; Send Custom Event
	if customHook != ""
		string customEvent = eventName+"_"+customHook
		_DebugTrace("_SendHookEvent","Sending custom event "+customEvent,"eventName="+eventName+", tid="+threadID)
		SendModEvent(customEvent, threadID, 1)
	endIf
	; Send Global Event
	SendModEvent(eventName, threadID, 1)
endFunction

int function _SlotDoNothing(actor a)
	int i = 0
	while i < 15
		if DoNothing[i].ForceRefIfEmpty(a)
			DoNothing[i].TryToEvaluatePackage()
			return i
		endIf
		i += 1
	endWhile
	return -1
endFunction

function _ClearDoNothing(int slot)
	if slot < 0
		return
	endIf
	actor a = DoNothing[slot].GetActorReference()
	DoNothing[slot].Clear()
	a.EvaluatePackage()
endFunction

function _EnableHotkeys(int tid)
	RegisterForKey(Config.kBackwards)
	RegisterForKey(Config.kAdvanceAnimation)
	RegisterForKey(Config.kChangeAnimation)
	RegisterForKey(Config.kChangePositions)
	RegisterForKey(Config.kAdjustChange)
	RegisterForKey(Config.kAdjustForward)
	RegisterForKey(Config.kAdjustSideways)
	RegisterForKey(Config.kAdjustUpward)
	RegisterForKey(Config.kRealignActors)
	RegisterForKey(Config.kRestoreOffsets)
	RegisterForKey(Config.kMoveScene)
	RegisterForKey(Config.kRotateScene)
	playerThread = tid
	hkReady = true
endFunction

function _EndThread(int tid, int player)
	if player >= 0
		playerThread = -1
		hkReady = true
	endIf
	_DebugTrace("_EndThread","tid="+tid+", player="+player,"Freeing up animation thread["+tid+"]")
	activeThread[tid] = false
endFunction

function _DebugTrace(string functionName, string str, string args = "")
	debug.trace("--SEXLAB NOTICE "+functionName+"("+args+") --- "+str)
endFunction

function _ReadyWait()
	while !ready
		Utility.Wait(0.05)
	endWhile
endFunction

;#---------------------------#
;#   END System Functions    #
;#---------------------------#


;#---------------------------#
;#    Hotkeys For Player     #
;#---------------------------#
event OnKeyDown(int keyCode)
	if playerThread >= 0 && hkReady
		hkReady = false

		bool backwards
		if Config.kBackwards == 42 || Config.kBackwards == 54
			; Check both shift keys
			bool lShift = input.IsKeyPressed(42)
			bool rShift = input.IsKeyPressed(54)
			if lShift || rShift
				backwards = true
			endIf
		else
			backwards = input.IsKeyPressed(Config.kBackwards)
		endIf
		
		; Advance Stage
		if keyCode == Config.kAdvanceAnimation
			thread[playerThread].AdvanceStage(backwards)
		; Change Animation
		elseIf keyCode == Config.kChangeAnimation
			thread[playerThread].ChangeAnimation(backwards)
		; Change Positions
		elseIf keyCode == Config.kChangePositions
			thread[playerThread].ChangePositions()
		; Forward / Backward adjustments
		elseIf keyCode == Config.kAdjustForward
			thread[playerThread].AdjustForward(backwards)
		; Left / Right adjustments
		elseIf keyCode == Config.kAdjustSideways
			thread[playerThread].AdjustSideways(backwards)
		; Up / Down adjustments
		elseIf keyCode == Config.kAdjustUpward
			thread[playerThread].AdjustUpward(backwards)
		; Change Adjusted Actor
		elseIf keyCode == Config.kAdjustChange
			thread[playerThread].AdjustChange(backwards)
		; Reposition Actors
		elseIf keyCode == Config.kRealignActors
			thread[playerThread].RealignActors()
		; Restore animation offsets
		elseIf keyCode == Config.kRestoreOffsets
			thread[playerThread].RestoreOffsets()
		; Move Scene
		elseIf keyCode == Config.kMoveScene
			thread[playerThread].MoveScene()
		; Rotate Scene
		elseIf keyCode == Config.kRotateScene
			thread[playerThread].RotateScene(backwards)
		endIf
		hkReady = true
	endIf
endEvent
;#---------------------------#
;#  END Hotkeys For Player   #
;#---------------------------#