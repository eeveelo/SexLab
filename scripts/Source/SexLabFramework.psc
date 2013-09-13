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

sslThreadSlots property ThreadSlots auto
sslThreadLibrary property ThreadLib auto

sslActorSlots property ActorSlots auto
sslActorLibrary property ActorLib auto

sslActorStats property Stats auto

; Animation Sets
sslBaseAnimation[] property Animation hidden
	sslBaseAnimation[] function get()
		return AnimSlots.Animations
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
actor property DebugActor auto hidden

;#---------------------------#
;#                           #
;#   API RELATED FUNCTIONS   #
;#                           #
;#---------------------------#

sslThreadModel function NewThread(float timeout = 5.0)
	if !Enabled
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
		if ActorLib.ValidateActor(sexActors[i]) != 1
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
	return ActorLib.ValidateActor(a)
endFunction

actor[] function SortActors(actor[] actorList, bool femaleFirst = true)
	return ActorLib.SortActors(actorList, femaleFirst)
endFunction

function ApplyCum(actor a, int cumID)
	ActorLib.ApplyCum(a, cumID)
endFunction

; form[] function StripActor(actor a, actor victim = none, bool animate = true, bool leadIn = false)
; 	return ActorLib.StripActor(a, victim, animation, leadIn)
; endFunction

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

;#------------------------------#
;#  BEGIN CONTROLLER FUNCTIONS  #
;#------------------------------#

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

int function FindAnimationByName(string findName)
	return AnimSlots.FindByName(findName)
endFunction

int function GetAnimationCount(bool ignoreDisabled = true)
	return AnimSlots.GetCount(ignoreDisabled)
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
	Stats.UpdatePlayerStats(anim, time, pos, victim)
endFunction

float function AdjustPlayerPurity(float amount)
	return Stats.AdjustPlayerPurity(amount)
endFunction

int function GetPlayerPurityLevel()
	return Stats.GetPlayerPurityLevel()
endFunction

string function GetPlayerPurityTitle()
	return Stats.GetPlayerPurityTitle()
endFunction

string function GetPlayerSexuality()
	return Stats.GetPlayerSexuality()
endFunction

int function GetPlayerStatLevel(string type)
	return GetPlayerStatLevel(type)
endFunction

string function GetPlayerStatTitle(string type)
	return GetPlayerStatTitle(type)
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
	DebugActor = none
	systemenabled = true
endFunction

function _EnableSystem(bool EnableSexLab = true)
	systemenabled = EnableSexLab
	if !EnableSexLab
		ThreadSlots._StopAll()
	endIf
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