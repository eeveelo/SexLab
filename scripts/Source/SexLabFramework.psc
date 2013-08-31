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

; Load our configuration settings from MCM
sslSystemConfig property Config auto
; Load our resources data
sslSystemResources property Data auto

bool property Enabled hidden
	bool function get()
		return systemenabled
	endFunction
endProperty

;#---------------------------#
;# Start Animation Variables #
;#---------------------------#
sslAnimationRegistry property AnimationRegistry auto
sslThreadSlots property ThreadSlots auto
sslActorSlots property ActorSlots auto

; Animation Sets
sslBaseAnimation[] property animation auto hidden
int animIndex = 0

; Animation Faction
faction property AnimatingFaction auto

;#---------------------------#
;#  End Animation Variables  #
;#---------------------------#

; Debug Spell Actor Storage, for Development use only
actor property DebugActor auto hidden

; Voice Files
sslBaseVoice[] property voice auto hidden
int voiceIndex = 0

; local vars
bool systemenabled = false
bool ready = false
bool hkready = false
bool clean = false

; The Player (That's you!)
actor property PlayerRef auto
sslThreadController PlayerController

; Schlongs of Skyrim integration
bool property sosEnabled = false auto hidden

;#---------------------------#
;#                           #
;#   API RELATED FUNCTIONS   #
;#                           #
;#---------------------------#

sslThreadModel function NewThread(float timeout = 5.0)
	if !systemenabled
		_DebugTrace("NewThread","","Failed to make new thread model; system is currently disabled")
		return none
	endIf
	sslThreadController ThreadView = ThreadSlots.PickController()
	if ThreadView != none
		debug.trace("Making thread["+ThreadView.tid+"] "+ThreadView)
		return ThreadView.Make(timeout)
	endIf
	return none
endFunction

int function StartSex(actor[] sexActors, sslBaseAnimation[] anims, actor victim = none, ObjectReference centerOn = none, bool allowBed = true, string hook = "")
	if !Enabled
		_DebugTrace("StartSex","","Failed to start animation; system is currently disabled")
		return -99
	endIf
	int i = 0
	while i < sexActors.Length
		if ValidateActor(sexActors[i]) != 1
			return -1 ; Don't both locking a thread, bad actor passed
		endIf
		i += 1
	endWhile
	sslThreadModel Make = NewThread()
	i = 0
	while i < sexActors.Length
		if Make.AddActor(sexActors[i], (victim == sexActors[i])) < 0
			return -1 ; Actor failed to add
		endIf
		i += 1
	endWhile
	Make.SetAnimations(anims)
	Make.CenterOnObject(centerOn)
	if allowBed == false
		Make.SetBedding(-1)
	endIf
	Make.SetHook(hook)
	sslThreadController Controller = Make.StartThread()

	if Controller != none
		return Controller.tid
	endIf
	return -1
endFunction

int function ValidateActor(actor a)
	return ActorSlots.ValidateActor(a)
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
		if GetGender(a) == priorityGender && i > orderSlot
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
	Debug.Trace("Applying "+cumID+" to "+a.GetLeveledActorBase().GetName())
	if cumID < 1
		return
	elseif cumID == 1
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

form[] function StripActor(actor a, actor victim = none, bool animate = true, bool leadIn = false)
	int gender = GetGender(a)
	bool[] strip
	if leadIn && gender < 1
		strip = Config.bStripLeadInMale
	elseif leadIn && gender > 0
		strip = Config.bStripLeadInFemale
	elseif victim != none && a == victim
		strip = Config.bStripVictim
	elseif victim != none && a != victim
		strip = Config.bStripAggressor
	elseif victim == none && gender < 1
		strip = Config.bStripMale
	else
		strip = Config.bstripFemale
	endIf
	return StripSlots(a, strip, animate)
endFunction

form[] function StripSlots(actor a, bool[] strip, bool animate = false, bool allowNudesuit = true)

	if strip.Length != 33
		_DebugTrace("StripSlots","actor="+a+", strip="+strip+", allowNudesuit="+allowNudesuit,"Not enough strip slots passed, should be bool size 33")
		return none
	endIf

	int gender = GetGender(a)
	form[] items
	int mask
	armor item
	weapon eWeap

	if Config.bUndressAnimation && animate
		if gender > 0 
			Debug.SendAnimationEvent(a, "Arrok_FemaleUndress")
		else
			Debug.SendAnimationEvent(a, "Arrok_MaleUndress")
		endIf
	else
		animate = false
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
				if animate
					utility.wait(0.35)
				endIf
			endIf 
		elseif strip[i] && i == 32			
			eWeap = a.GetEquippedWeapon(true)
			if eWeap != none && !eWeap.HasKeyWordString("SexLabNoStrip")
				int type = a.GetEquippedItemType(1)
				if type == 5 || type == 6 || type == 7
					a.AddItem(Data.DummyWeapon, abSilent = true)
					a.EquipItem(Data.DummyWeapon, abSilent = true)
					a.UnEquipItem(Data.DummyWeapon, abSilent = true)
					a.RemoveItem(Data.DummyWeapon, abSilent = true)
				else
					a.UnequipItem(eWeap, false, true)
				endIf
				items = sslUtility.PushForm(eWeap, items)
			endIf
			eWeap = a.GetEquippedWeapon(false)
			if eWeap != none && !eWeap.HasKeyWordString("SexLabNoStrip")
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

	if animate
		Debug.SendAnimationEvent(a, "IdleForceDefaultState")
	endIf

	return items
endFunction

function UnstripActor(actor a, form[] stripped, actor victim = none)
	int i = stripped.Length
	if i < 1
		_DebugTrace("EquipStrapon","actor="+a+", stripped="+stripped+", victim="+victim,"No items passed to stripped argument for actor to equip")
	endIf

	; Remove nudesuits
	int gender = GetGender(a)
	if (gender < 2 && Config.bUseMaleNudeSuit) || (gender == 1  && Config.bUseFemaleNudeSuit)
		a.UnequipItem(Data.aNudeSuit, true, true)
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

	if GetGender(a) == 1
		int sid = utility.RandomInt(0, straponCount - 1)
		a.EquipItem(Data.strapons[sid], false, true)
		return Data.strapons[sid]
	else
		_DebugTrace("EquipStrapon","actor="+a+"","Is male and cannot use strapons")
		return none
	endIf
endFunction

function UnequipStrapon(actor a)
	int straponCount = Data.strapons.Length
	if straponCount == 0
		return
	endIf

	if GetGender(a) == 1
		int i = 0
		while i < straponCount
			Form strapon = Data.strapons[i]
			if a.IsEquipped(strapon)
				a.UnequipItem(strapon, false, true)
				a.RemoveItem(strapon, 1, true)
			endIf
			i += 1
		endWhile
	endIf
endFunction


int function GetGender(actor a)
	ActorBase base = a.GetLeveledActorBase()
	if a.HasKeyWordString("SexLabTreatMale") || base.HasKeyWordString("SexLabTreatMale")
		return 0
	elseif a.HasKeyWordString("SexLabTreatFemale") || base.HasKeyWordString("SexLabTreatFemale")
		return 1
	else
		return base.GetSex()
	endIf
endFunction

int[] function GenderCount(actor[] pos)
	int[] genders = new int[2]
	int i = 0
	while i < pos.Length
		if GetGender(pos[i]) > 0
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

;#------------------------------#
;#  BEGIN CONTROLLER FUNCTIONS  #
;#------------------------------#

int function FindActorController(actor toFind)
	int i = 0
	while i < 15
		if ThreadSlots.GetController(i).HasActor(toFind)
			return i
		endIf
		i += 1
	endWhile
	return -1
endFunction

sslThreadController function GetActorController(actor toFind)
	int tid = FindActorController(toFind)
	if tid != -1
		return ThreadSlots.GetController(tid)
	endIf
	return none
endFunction

int function FindPlayerController()
	return PlayerController.tid
endFunction

sslThreadController function GetPlayerController()
	if PlayerController != none
		return ThreadSlots.GetController(PlayerController.tid)
	endIf
	return none
endFunction

sslThreadController function GetController(int tid)
	return ThreadSlots.GetController(tid)
endFunction

;#---------------------------#
;#   END THREAD FUNCTIONS    #
;#---------------------------#

;#---------------------------#
;# BEGIN ANIMATION FUNCTIONS #
;#---------------------------#

sslBaseAnimation function GetAnimationByName(string findName)
	return AnimationRegistry.GetByName(findName)
endFunction

sslBaseAnimation[] function GetAnimationsByType(int actors, int males = -1, int females = -1, int stages = -1, bool aggressive = false, bool sexual = true)
	return AnimationRegistry.GetByType(actors, males, females, stages, aggressive, sexual, Config.bRestrictAggressive)
endFunction

sslBaseAnimation[] function GetAnimationsByTag(int actors, string tag1, string tag2 = "", string tag3 = "", string tagSuppress = "", bool requireAll = true)
	return AnimationRegistry.GetByTag(actors, tag1, tag2, tag3, tagSuppress, requireAll)
endFunction

sslBaseAnimation[] function MergeAnimationLists(sslBaseAnimation[] list1, sslBaseAnimation[] list2)
	return AnimationRegistry.MergeLists(list1, list2)
endFunction

int function FindAnimationByName(string findName)
	return AnimationRegistry.FindByName(findName)
endFunction

int function GetAnimationCount(bool ignoreDisabled = true)
	return AnimationRegistry.GetCount(ignoreDisabled)
endFunction

int function RegisterAnimation(sslBaseAnimation anim)
	return -1
	;return AnimationRegistry.Register(anim)
endFunction

;#---------------------------#
;#  END ANIMATION FUNCTIONS  #
;#---------------------------#

;#---------------------------#
;#   BEGIN VOICE FUNCTIONS   #
;#---------------------------#

sslBaseVoice function PickVoice(actor a)
	if a == PlayerRef && Config.sPlayerVoice != "$SSL_Random"
		return GetVoiceByName(Config.sPlayerVoice)
	else
		return GetVoiceByGender(a.GetLeveledActorBase().GetSex())
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

sslBaseVoice function GetVoiceByTag(string tag1, string tag2 = "", string tagSuppress = "", bool requireAll = true)
	int i = 0
	while i < voiceIndex
		if voice[i].enabled
			bool check1 = voice[i].HasTag(tag1)
			bool check2 = voice[i].HasTag(tag2)
			bool supress = voice[i].HasTag(tagSuppress)
			if requireAll && check1 && (check2 || tag2 == "") && !(supress && tagSuppress != "")
				return voice[i]
			elseif !requireAll && (check1 || check2) && !(supress && tagSuppress != "")
				return voice[i]
			endIf
		endIf
		i += 1
	endWhile
	return none
endFunction

int function RegisterVoice(sslBaseVoice vc)
	_ReadyWait()
	ready = false
	int vid = FindVoiceByName(vc.name)
	if vid == -1
		vid = voiceIndex
		voice[vid] = vc
		voice[vid].LoadVoice()
		_DebugTrace("RegisterVoice","Voice script successfully registered",vc.name)
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

; sslBaseThread function HookThread(string argString)
; {DEPRECATED: TO BE REMOVED IN 1.2}
; 	_Deprecate("HookThread", "HookController")
; 	return thread[(argString as int)]
; endFunction

sslThreadController function HookController(string argString)
	return ThreadSlots.GetController(argString as int)
endFunction

sslBaseAnimation function HookAnimation(string argString)
	return ThreadSlots.GetController(argString as int).Animation
endFunction

int function HookStage(string argString)
	return ThreadSlots.GetController(argString as int).Stage
endFunction

actor function HookVictim(string argString)
	return ThreadSlots.GetController(argString as int).GetVictim()
endFunction

actor[] function HookActors(string argString)
	return ThreadSlots.GetController(argString as int).Positions
endFunction

float function HookTime(string argString)
	return ThreadSlots.GetController(argString as int).GetTime()
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

	int[] genders = GenderCount(pos)
	int males = genders[0]
	int females = genders[1]

	if GetGender(PlayerRef) > 0
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
		return titles[6]
	elseif level < 0
		return titles[0]
	else
		return titles[level]
	endIf
endFunction

string function GetPlayerSexuality()
	int males = Data.iMalePartners
	int females = Data.iFemalePartners
	int partners = 1 + (males + females)
	int gender = GetGender(PlayerRef)
	float ratio
	if gender > 0
		ratio = ((males + 1.0) / partners as float) * 100.0
	else
		ratio = ((females + 1.0) / partners as float) * 100.0
	endIf
	if ratio <= 35 && gender > 0
		return "$SSL_Lesbian"
	elseIf ratio <= 35 && gender < 1
		return "$SSL_Gay"
	elseIf ratio > 35 && ratio < 65
		return "$SSL_Bisexual"
	else
		return "$SSL_Heterosexual"
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
		return Config.sStatTitles[6]
	elseif level < 0
		return Config.sStatTitles[0]
	else
		return Config.sStatTitles[level]
	endIf
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
	systemenabled = true
	_DebugTrace("OnInit","","SYSTEM INITIALIZED")
endEvent

function _StopAnimations()
	ready = false
	int i = 0
	while i < ThreadSlots.Count
		ThreadSlots.GetController(i).EndAnimation(quick = true)
		i += 1
	endWhile
	ready = true
endFunction

function _ClearAnimations()
	ready = false
	AnimationRegistry._Setup()
	ready = true
endFunction


function _LoadAnimations()
	ready = false
	AnimationRegistry._Load()
	ready = true
endFunction

function _ClearVoices()
	ready = false
	int i = 0
	while i < voiceIndex
		voice[i].UnloadVoice()
		i += 1
	endWhile
	voice = new sslBaseVoice[128]
	voiceIndex = 0
	ready = true
endFunction

function _CleanSystem()
	ready = false
	_SetupSystem()
	Config.SetDefaults()
	Data.mCleanSystemFinish.Show()
	ready = true
endFunction

function _SetupSystem()
	ready = false

	; Init Thread Controllers
	ThreadSlots._Setup()
	; Init Alias Slots
	ActorSlots._Setup()

	ready = true
	systemenabled = true

	; Init animations
	_ClearAnimations()
	_LoadAnimations()

	; Init voices
	_ClearVoices()
	Data.LoadVoices()

endFunction

function _EnableSystem(bool EnableSexLab = true)
	systemenabled = EnableSexLab
	if !EnableSexLab
		_StopAnimations()
	else
		_CheckSystem()
	endIf
endFunction

bool function _CheckClean()
	return clean
endFunction

function _CheckSystem()
	ready = false
	; Check SKSE Version
	float skseNeeded = 1.0609
	float skseInstalled = SKSE.GetVersion() + SKSE.GetVersionMinor() * 0.01 + SKSE.GetVersionBeta() * 0.0001
	if skseInstalled == 0
		Data.mNoSKSE.Show()
		systemenabled = false
	elseif skseInstalled < skseNeeded
		Data.mOldSKSE.Show(skseInstalled, skseNeeded)
		systemenabled = false
	endIf
	; Check Skyrim Version
	float skyrimNeeded = 1.8
	float skyrimMajor = StringUtil.SubString(Debug.GetVersionNumber(), 0, 3) as float
	if skyrimMajor < skyrimNeeded
		Data.mOldSkyrim.Show(skyrimMajor, skyrimNeeded)
		systemenabled = false
	endIf
	; Check for Schlongs of Skyrim
	sosEnabled = false
	form check = Game.GetFormFromFile(0x0D64, "Schlongs of Skyrim.esp") ; Armor SkinNaked
	if check != none
		sosEnabled = true
		_DebugTrace("_CheckSystem","SexLab Compatibility: 'Schlongs of Skyrim.esp' was found")
	else
		check = Game.GetFormFromFile(0x0D67, "Schlongs of Skyrim - Light.esp") ; ArmorAddon NakedTorso
		if check != none
			sosEnabled = true
			_DebugTrace("_CheckSystem","SexLab Compatibility: 'Schlongs of Skyrim - Light.esp' was found")
		endIf
	endIf
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
	; int i = 0
	; while i < 15
	; 	if DoNothing[i].ForceRefIfEmpty(a)
	; 		DoNothing[i].TryToEvaluatePackage()
	; 		return i
	; 	endIf
	; 	i += 1
	; endWhile
	return -1
endFunction

function _ClearDoNothing(actor a)
	; int i = 0
	; while i < 15
	; 	if DoNothing[i].GetActorReference() == a
	; 		Debug.Trace("Clearing SexLabDoNothing["+i+"] of "+a)
	; 		DoNothing[i].Clear()
	; 		a.EvaluatePackage()
	; 		return
	; 	endIf
	; 	i += 1
	; endWhile
endFunction

function _EnableHotkeys(int tid)
	RegisterForKey(Config.kBackwards)
	RegisterForKey(Config.kAdjustStage)
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
	; playerThread = tid ; DEPRECATED, to be removed in 1.2
	PlayerController = ThreadSlots.GetController(tid)
	hkReady = true
endFunction

function _DisableHotkeys()
	UnregisterForAllKeys()
	PlayerController = none
	; PlayerThread = -1
	hkready = true
endFunction

function _DebugTrace(string functionName, string str, string args = "")
	debug.trace("--SEXLAB NOTICE "+functionName+"("+args+") --- "+str)
endFunction

function _Deprecate(string deprecated, string replacer)
	;Debug.Notification(deprecated+"() has been deprecated; check trace log")
	Debug.Trace("--------------------------------------------------------------------------------------------", 1)
	Debug.Trace("-- ATTENTION MODDER: SEXLAB DEPRECATION NOTICE ---------------------------------------------", 1)
	Debug.Trace("--------------------------------------------------------------------------------------------", 1)
	Debug.Trace(" "+deprecated+"() is deprecated and will be removed in the next major update of SexLab.", 1)
	Debug.Trace(" Update your mod to use "+replacer+"() instead, or notify the creator", 1)
	Debug.Trace(" of the mod which is calling it", 1)
	Debug.TraceStack(" "+deprecated+"() Called By: ", 1)
	Debug.Trace("--------------------------------------------------------------------------------------------", 1)
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
	if PlayerController != none && hkReady
		hkReady = false

		bool backwards
		if Config.kBackwards == 42 || Config.kBackwards == 54
			; Check both shift keys
			backwards = ( input.IsKeyPressed(42) || input.IsKeyPressed(54) )
		else
			backwards = input.IsKeyPressed(Config.kBackwards)
		endIf

		bool adjustingstage
		if Config.kAdjustStage == 157 || Config.kAdjustStage == 29
			; Check both ctrl keys
			adjustingstage = ( input.IsKeyPressed(157) || input.IsKeyPressed(29) )
		else
			adjustingstage = input.IsKeyPressed(Config.kBackwards)
		endIf
		
		; Advance Stage
		if keyCode == Config.kAdvanceAnimation
			PlayerController.AdvanceStage(backwards)
		; Change Animation
		elseIf keyCode == Config.kChangeAnimation
			PlayerController.ChangeAnimation(backwards)
		; Change Positions
		elseIf keyCode == Config.kChangePositions
			PlayerController.ChangePositions(backwards)
		; Forward / Backward adjustments
		elseIf keyCode == Config.kAdjustForward
			PlayerController.AdjustForward(backwards, adjustingstage)
		; Left / Right adjustments
		elseIf keyCode == Config.kAdjustSideways
			PlayerController.AdjustSideways(backwards, adjustingstage)
		; Up / Down adjustments
		elseIf keyCode == Config.kAdjustUpward
			PlayerController.AdjustUpward(backwards, adjustingstage)
		; Change Adjusted Actor
		elseIf keyCode == Config.kAdjustChange
			PlayerController.AdjustChange(backwards)
		; Reposition Actors
		elseIf keyCode == Config.kRealignActors
			PlayerController.RealignActors()
		; Restore animation offsets
		elseIf keyCode == Config.kRestoreOffsets
			PlayerController.RestoreOffsets()
		; Move Scene
		elseIf keyCode == Config.kMoveScene
			PlayerController.MoveScene()
		; Rotate Scene
		elseIf keyCode == Config.kRotateScene
			PlayerController.RotateScene(backwards)
		endIf
		hkReady = true
	endIf
endEvent
;#---------------------------#
;#  END Hotkeys For Player   #
;#---------------------------#