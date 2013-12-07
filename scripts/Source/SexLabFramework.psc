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

bool systemenabled = false
bool property Enabled hidden
	bool function get()
		return systemenabled
	endFunction
endProperty

; Scripts
sslAnimationSlots property AnimSlots auto
sslAnimationLibrary property AnimLib auto

sslVoiceSlots property VoiceSlots auto
sslVoiceLibrary property VoiceLib auto

sslExpressionSlots property ExpressionSlots auto
sslExpressionLibrary property ExpressionLib auto

sslThreadSlots property ThreadSlots auto
sslThreadLibrary property ThreadLib auto

sslActorSlots property ActorSlots auto
sslActorLibrary property ActorLib auto

sslActorStats property Stats auto

sslControlLibrary property ControlLib auto

; Animation Sets
sslBaseAnimation[] property Animation hidden
	sslBaseAnimation[] function get()
		return AnimSlots.Animations
	endFunction
endProperty

; Creature animations
sslBaseAnimation[] property CreatureAnimation hidden
	sslBaseAnimation[] function get()
		return AnimLib.CreatureSlots.Slots
	endFunction
endProperty

; Voice Sets
sslBaseVoice[] property Voice hidden
	sslBaseVoice[] function get()
		return VoiceSlots.Voices
	endFunction
endProperty

; Readonly Config Accessor
sslSystemConfig property Config auto

; Data
actor property PlayerRef auto
faction property AnimatingFaction auto
actor[] property DebugActor auto hidden

;#---------------------------#
;#                           #
;#   API RELATED FUNCTIONS   #
;#                           #
;#---------------------------#

sslThreadModel function NewThread(float timeout = 5.0)
	if !systemenabled
		_Log("NewThread", "Failed to make new thread model; system is currently disabled", "FATAL")
		return none
	endIf
	; Claim an available thread
	sslThreadController ThreadView = ThreadSlots.PickController()
	if ThreadView != none
		Debug.Trace("SexLab: Making thread["+ThreadView.tid+"] "+ThreadView)
		return ThreadView.Make((timeout + 25.0))
	endIf
	return none
endFunction

int function StartSex(actor[] sexActors, sslBaseAnimation[] anims, actor victim = none, ObjectReference centerOn = none, bool allowBed = true, string hook = "")
	if !systemenabled
		_Log("StartSex", "Failed to make new thread model; system is currently disabled", "FATAL")
		return -99
	endIf
	; Claim a thread
	sslThreadModel Make = NewThread()
	; Add actors to thread
	int i
	while i < sexActors.Length
		if Make.AddActor(sexActors[i], (victim == sexActors[i])) < 0
			return -1 ; Actor failed to add
		endIf
		i += 1
	endWhile
	; Configure our thread with passed arguments
	Make.SetAnimations(anims)
	Make.CenterOnObject(centerOn)
	if allowBed == false
		Make.SetBedding(-1)
	endIf
	Make.SetHook(hook)
	; Start the animation
	sslThreadController Controller = Make.StartThread()
	if Controller != none
		return Controller.tid
	endIf
	return -1
endFunction

sslThreadController function QuickStart(actor a1, actor a2 = none, actor a3 = none, actor a4 = none, actor a5 = none, actor victim = none, string hook = "")
	sslBaseAnimation[] anim
	int tid = StartSex(ActorLib.MakeActorArray(a1, a2, a3, a4, a5), anim, victim, none, true, hook)
	if tid != -1
		return ThreadSlots.GetController(tid)
	endIf
	return none
endFunction

;#------------------------------#
;#  ACTOR FUNCTIONS             #
;#------------------------------#

int function ValidateActor(actor a)
	return ActorLib.ValidateActor(a)
endFunction

bool function IsValidActor(actor a)
	return ActorLib.IsValidActor(a)
endFunction

actor[] function MakeActorArray(actor a1 = none, actor a2 = none, actor a3 = none, actor a4 = none, actor a5 = none)
	return ActorLib.MakeActorArray(a1, a2, a3, a4, a5)
endFunction

actor function FindAvailableActor(ObjectReference centerRef, float radius = 5000.0, int findGender = -1, actor ignore1 = none, actor ignore2 = none, actor ignore3 = none, actor ignore4 = none)
	return ActorLib.FindAvailableActor(centerRef, radius, findGender, ignore1, ignore2, ignore3, ignore4)
endFunction

actor[] function FindAvailablePartners(actor[] Positions, int total, int males = -1, int females = -1, float radius = 10000.0)
	return ActorLib.FindAvailablePartners(Positions, total, males, females, radius)
endFunction

actor[] function SortActors(actor[] actorList, bool femaleFirst = true)
	return ActorLib.SortActors(actorList, femaleFirst)
endFunction

function ApplyCum(actor a, int cumID)
	ActorLib.ApplyCum(a, cumID)
endFunction

function ClearCum(actor a)
	ActorLib.ClearCum(a)
endFunction

form[] function StripActor(actor a, actor victim = none, bool animate = true, bool leadIn = false)
	return ActorLib.StripActor(a, victim, animate, leadIn)
endFunction

bool function IsStrippable(form item)
	return ActorLib.IsStrippable(item)
endFunction

form[] function StripSlots(actor a, bool[] strip, bool animate = false, bool allowNudesuit = true)
	return ActorLib.StripSlots(a, strip, animate, allowNudesuit)
endFunction

function UnstripActor(actor a, form[] stripped, actor victim = none)
	ActorLib.UnstripActor(a, stripped, victim)
endFunction

form function EquipStrapon(actor a)
	return ActorLib.EquipStrapon(a)
endFunction

function UnequipStrapon(actor a)
	ActorLib.UnequipStrapon(a)
endFunction

function ForbidActor(actor a)
	ActorLib.ForbidActor(a)
endFunction

function AllowActor(actor a)
	ActorLib.AllowActor(a)
endFunction

bool function IsForbidden(actor a)
	return ActorLib.IsForbidden(a)
endFunction

function TreatAsMale(actor a)
	ActorLib.TreatAsMale(a)
endFunction

function TreatAsFemale(actor a)
	ActorLib.TreatAsFemale(a)
endFunction

function ClearForcedGender(actor a)
	ActorLib.ClearForcedGender(a)
endFunction

int function GetGender(actor a)
	return ActorLib.GetGender(a)
endFunction

int[] function GenderCount(actor[] pos)
	return ActorLib.GenderCount(pos)
endFunction

int function MaleCount(actor[] pos)
	return ActorLib.MaleCount(pos)
endFunction

int function FemaleCount(actor[] pos)
	return ActorLib.FemaleCount(pos)
endFunction
int function CreatureCount(actor[] pos)
	return ActorLib.CreatureCount(pos)
endFunction

;#------------------------------#
;#     END ACTOR FUNCTIONS      #
;#------------------------------#


;#------------------------------#
;#  BEGIN CONTROLLER FUNCTIONS  #
;#------------------------------#

ObjectReference function FindBed(ObjectReference centerRef, float radius = 1000.0, bool ignoreUsed = true, ObjectReference ignore1 = none, ObjectReference ignore2 = none)
	return ThreadLib.FindBed(centerRef, radius, ignoreUsed, ignore1, ignore2)
endFunction

int function FindActorController(actor toFind)
	return ThreadSlots.FindActorController(toFind)
endFunction

sslThreadController function GetActorController(actor toFind)
	return ThreadSlots.GetActorController(toFind)
endFunction

int function FindPlayerController()
	return ThreadSlots.FindActorController(PlayerRef)
endFunction

sslThreadController function GetPlayerController()
	return ThreadSlots.GetActorController(PlayerRef)
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
	return AnimSlots.GetByName(findName)
endFunction

sslBaseAnimation[] function GetAnimationsByType(int actors, int males = -1, int females = -1, int stages = -1, bool aggressive = false, bool sexual = true)
	return AnimSlots.GetByType(actors, males, females, stages, aggressive, sexual)
endFunction

sslBaseAnimation[] function GetAnimationsByTag(int actors, string tag1, string tag2 = "", string tag3 = "", string tagSuppress = "", bool requireAll = true)
	return AnimSlots.GetByTag(actors, tag1, tag2, tag3, tagSuppress, requireAll)
endFunction

sslBaseAnimation[] function MergeAnimationLists(sslBaseAnimation[] list1, sslBaseAnimation[] list2)
	return AnimSlots.MergeLists(list1, list2)
endFunction

sslBaseAnimation[] function PickAnimationsByActors(actor[] Positions, int limit = 64, bool aggressive = false)
	return AnimSlots.PickByActors(Positions, limit, aggressive)
endFunction

int function FindAnimationByName(string findName)
	return AnimSlots.FindByName(findName)
endFunction

int function GetAnimationCount(bool ignoreDisabled = true)
	return AnimSlots.GetCount(ignoreDisabled)
endFunction

bool function AllowedCreature(Race creature)
	return AnimLib.AllowedCreature(creature)
endFunction

bool function AllowedCreatureCombination(Race creature, Race creature2)
	return AnimLib.AllowedCreatureCombination(creature, creature2)
endFunction

string function MakeAnimationGenderTag(actor[] Positions)
	AnimLib.MakeGenderTag(Positions)
endFunction

int function RegisterAnimation(sslBaseAnimation anim)
	return -1
endFunction

;#---------------------------#
;#  END ANIMATION FUNCTIONS  #
;#---------------------------#

;#---------------------------#
;#   BEGIN VOICE FUNCTIONS   #
;#---------------------------#

sslBaseVoice function PickVoice(actor a)
	return VoiceLib.PickVoice(a)
endFunction

sslBaseVoice function GetVoiceByGender(int g)
	return VoiceSlots.GetRandom(g)
endFunction

sslBaseVoice function GetVoiceByName(string findName)
	return VoiceSlots.GetByName(findName)
endFunction

int function FindVoiceByName(string findName)
	return VoiceSlots.FindByName(findName)
endFunction

sslBaseVoice function GetVoiceByTag(string tag1, string tag2 = "", string tagSuppress = "", bool requireAll = true)
	return VoiceSlots.GetByTag(tag1, tag2, tagSuppress, requireAll)
endFunction

sslBaseVoice function GetVoiceBySlot(int slot)
	return VoiceSlots.GetBySlot(slot)
endFunction

int function RegisterVoice(sslBaseVoice voice)
	return -1
endFunction

;#---------------------------#
;#    END VOICE FUNCTIONS    #
;#---------------------------#

;#---------------------------#
;#    START HOOK FUNCTIONS   #
;#---------------------------#

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
	return ThreadSlots.GetController(argString as int).VictimRef
endFunction

actor[] function HookActors(string argString)
	return ThreadSlots.GetController(argString as int).Positions
endFunction

float function HookTime(string argString)
	return ThreadSlots.GetController(argString as int).TotalTime
endFunction

;#---------------------------#
;#    END HOOK FUNCTIONS     #
;#---------------------------#

;#---------------------------#
;#   START STAT FUNCTIONS    #
;#---------------------------#

int function FindStat(string name)
	return Stats.FindStat(name)
endFunction

int function RegisterStat(string name, string value, string prepend = "", string append = "")
	return Stats.RegisterStat(name, value, prepend, append)
endFunction

function Alter(string name, string newName = "", string value = "", string prepend = "", string append = "")
	Stats.Alter(name, newName, value, prepend, append)
endFunction

string[] function GetInfo(string name)
	return Stats.GetInfo(name)
endFunction

string function GetStat(string name)
	return Stats.GetStat(name)
endFunction

int function GetStatInt(string name)
	return Stats.GetStatInt(name)
endFunction

float function GetStatFloat(string name)
	return Stats.GetStatFloat(name)
endFunction

string function SetStat(string name, string value)
	return Stats.SetStat(name, value)
endFunction

int function AdjustBy(string name, int adjust)
	return Stats.AdjustBy(name, adjust)
endFunction

int function CalcSexuality(bool IsFemale, int males, int females)
	return Stats.CalcSexuality(IsFemale, males, females)
endFunction

int function CalcLevel(float total, float curve = 0.65)
	return Stats.CalcLevel(total, curve)
endFunction

string function ParseTime(int time)
	return Stats.ParseTime(time)
endFunction

int function PlayerSexCount(actor a)
	return Stats.PlayerSexCount(a)
endFunction

bool function HadPlayerSex(actor a)
	return Stats.HadPlayerSex(a)
endFunction

function AddPlayerSex(actor a)
	Stats.AddPlayerSex(a)
endFunction

function UpdatePlayerStats(sslBaseAnimation anim, float time, actor[] pos, actor victim)
	int[] genders = ActorLib.GenderCount(pos)
	Stats.UpdatePlayerStats(genders[0], genders[1], genders[2], anim, victim, time)
endFunction

float function AdjustPlayerPurity(float amount)
	return Stats.AdjustPurity(amount)
endFunction

int function GetPlayerPurityLevel()
	return Stats.GetPlayerPurityLevel()
endFunction

string function GetPlayerPurityTitle()
	return Stats.GetPlayerPurityTitle()
endFunction

string function GetPlayerSexuality()
	return Stats.GetSexualityTitle()
endFunction

int function GetPlayerStatLevel(string type)
	return Stats.GetPlayerProficencyLevel(type)
endFunction

string function GetStatProficiency(string type)
	return Stats.GetPlayerProficencyTitle(type)
endFunction

int function GetActorProficencyLevel(actor ActorRef)
	return Stats.GetActorProficencyLevel(ActorRef)
endFunction

float function GetActorPurityStat(actor ActorRef)
	return Stats.GetActorPurityStat(ActorRef)
endFunction

int function GetActorPurityLevel(actor ActorRef)
	return Stats.GetActorPurityLevel(ActorRef)
endFunction

bool function IsActorPure(actor ActorRef)
	return Stats.GetActorPurityStat(ActorRef)
endFunction

bool function IsActorImpure(actor ActorRef)
	return Stats.IsActorImpure(ActorRef)
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

function _Setup()
	actor[] aInit
	DebugActor = aInit
	systemenabled = true
endFunction

function _EnableSystem(bool EnableSexLab = true)
	systemenabled = EnableSexLab
	if !EnableSexLab
		ThreadSlots._StopAll()
	endIf
endFunction

function _Log(string log, string method, string type = "NOTICE")
	Debug.Trace("--------------------------------------------------------------------------------------------")
	Debug.Trace("--- SexLabFramework ---")
	Debug.Trace("--------------------------------------------------------------------------------------------")
	Debug.Trace(" "+type+": "+method+"()" )
	Debug.Trace("   "+log)
	Debug.Trace("--------------------------------------------------------------------------------------------")
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
