scriptname SexLabFramework extends Quest

;####################################################################
;#################### SEXLAB ANIMATION FRAMEWORK ####################
;####################################################################
;#------------------------------------------------------------------#
;#-                                                                -#
;#-                 Created by Ashal@LoversLab.com                 -#
;#-              http://www.loverslab.com/user/1-ashal/            -#
;#-                                                                -#
;#-                    API Guide For Modders:                      -#
;#-     http://git.loverslab.com/sexlab/framework/wikis/home       -#
;#-                                                                -#
;#------------------------------------------------------------------#
;####################################################################

bool SystemEnabled = false
bool property Enabled hidden
	bool function get()
		return SystemEnabled
	endFunction
endProperty

; Animation Threads
sslThreadSlots property ThreadSlots auto
sslThreadController[] property Threads hidden
	sslThreadController[] function get()
		return ThreadSlots.Threads
	endFunction
endProperty

; Animation Sets
sslAnimationSlots property AnimSlots auto
sslBaseAnimation[] property Animations hidden
	sslBaseAnimation[] function get()
		return AnimSlots.Animations
	endFunction
endProperty

; Creature animations


; Voice Sets
sslVoiceSlots property VoiceSlots auto
sslBaseVoice[] property Voices hidden
	sslBaseVoice[] function get()
		return VoiceSlots.Voices
	endFunction
endProperty

; Configuration Accessor
sslSystemConfig property Config auto

; API Library
sslActorLibrary property ActorLib auto
sslThreadLibrary property ThreadLib auto
sslAnimationLibrary property AnimLib auto

; Data
Faction property AnimatingFaction auto
Actor property PlayerRef auto

Actor[] property DebugActor auto hidden

;#---------------------------#
;#                           #
;#   API RELATED FUNCTIONS   #
;#                           #
;#---------------------------#

sslThreadModel function NewThread(float TimeOut = 30.0)
	if !SystemEnabled
		Log("NewThread() - Failed to make new thread model; system is currently disabled", "FATAL")
		return none
	endIf
	; Claim an available thread
	return ThreadSlots.PickModel(TimeOut)
endFunction

int function StartSex(Actor[] Positions, sslBaseAnimation[] Anims, Actor VictimRef = none, ObjectReference CenterOn = none, bool AllowBed = true, string Hook = "")
	if !SystemEnabled
		Log("StartSex() - Failed to make new thread model; system is currently disabled", "FATAL")
		return -99
	endIf
	; Claim a thread
	sslThreadModel Make = NewThread()
	if Make == none
		Log("StartSex() - Failed to claim an available thread")
		return -1
	; Add actors list to thread
	elseIf !Make.AddActors(Positions, VictimRef)
		Log("StartSex() - Failed to add some actors to thread")
		return -1
	endIf
	; Configure our thread with passed arguments
	Make.SetAnimations(Anims)
	Make.CenterOnObject(CenterOn)
	Make.DisableBedUse(!AllowBed)
	Make.SetHook(Hook)
	; Start the animation
	if Make.StartThread()
		return Make.tid
	endIf
	return -1
endFunction

sslThreadController function QuickStart(Actor Actor1, Actor Actor2 = none, Actor Actor3 = none, Actor Actor4 = none, Actor Actor5 = none, actor VictimRef = none, string Hook = "")
	sslBaseAnimation[] Anims
	return ThreadSlots.GetController(StartSex(ActorLib.MakeActorArray(Actor1, Actor2, Actor3, Actor4, Actor5), Anims, VictimRef, none, true, Hook))
endFunction

; ;#------------------------------#
; ;#  ACTOR FUNCTIONS             #
; ;#------------------------------#

int function ValidateActor(Actor ActorRef)
	return ActorLib.ValidateActor(ActorRef)
endFunction

bool function IsValidActor(Actor ActorRef)
	return ActorLib.IsValidActor(ActorRef)
endFunction

bool function IsActorActive(Actor ActorRef)
	return ActorLib.IsActorActive(ActorRef)
endFunction

Actor[] function MakeActorArray(Actor Actor1 = none, Actor Actor2 = none, Actor Actor3 = none, Actor Actor4 = none, Actor Actor5 = none)
	return ActorLib.MakeActorArray(Actor1, Actor2, Actor3, Actor4, Actor5)
endFunction

Actor function FindAvailableActor(ObjectReference CenterRef, float Radius = 5000.0, int FindGender = -1, actor IgnoreRef1 = none, actor IgnoreRef2 = none, actor IgnoreRef3 = none, actor IgnoreRef4 = none)
	return ActorLib.FindAvailableActor(CenterRef, Radius, FindGender, IgnoreRef1, IgnoreRef2, IgnoreRef3, IgnoreRef4)
endFunction

Actor[] function FindAvailablePartners(actor[] Positions, int TotalActors, int Males = -1, int Females = -1, float Radius = 10000.0)
	return ActorLib.FindAvailablePartners(Positions, TotalActors, Males, Females, Radius)
endFunction

Actor[] function SortActors(Actor[] Positions, bool FemaleFirst = true)
	return ActorLib.SortActors(Positions, FemaleFirst)
endFunction

function ApplyCum(Actor ActorRef, int CumID)
	ActorLib.ApplyCum(ActorRef, CumID)
endFunction

function AddCum(Actor ActorRef, bool Vaginal = true, bool Oral = true, bool Anal = true)
	ActorLib.AddCum(ActorRef, Vaginal, Oral, Anal)
endFunction

function ClearCum(Actor ActorRef)
	ActorLib.ClearCum(ActorRef)
endFunction

form[] function StripActor(Actor ActorRef, Actor VictimRef = none, bool DoAnimate = true, bool LeadIn = false)
	return ActorLib.StripActor(ActorRef, VictimRef, DoAnimate, LeadIn)
endFunction

form[] function StripSlots(Actor ActorRef, bool[] Strip, bool DoAnimate = false, bool AllowNudesuit = true, int Gender = 0)
	return ActorLib.StripSlots(ActorRef, Strip, DoAnimate, AllowNudesuit, Gender)
endFunction

function UnstripActor(Actor ActorRef, form[] Stripped, bool IsVictim = false)
	ActorLib.UnstripActor(ActorRef, Stripped, IsVictim)
endFunction

bool function IsStrippable(form ItemRef)
	return ActorLib.IsStrippable(ItemRef)
endFunction

form function StripWeapon(Actor ActorRef, bool RightHand = true)
	return ActorLib.StripWeapon(ActorRef, RightHand)
endFunction

form function StripSlot(Actor ActorRef, int SlotMask)
	return ActorLib.StripSlot(ActorRef, SlotMask)
endFunction

form function WornStrapon(Actor ActorRef)
	return ActorLib.WornStrapon(ActorRef)
endFunction

bool function HasStrapon(Actor ActorRef)
	return ActorLib.HasStrapon(ActorRef)
endFunction

form function PickStrapon(Actor ActorRef)
	return ActorLib.PickStrapon(ActorRef)
endFunction

form function EquipStrapon(Actor ActorRef)
	return ActorLib.EquipStrapon(ActorRef)
endFunction

function UnequipStrapon(Actor ActorRef)
	ActorLib.UnequipStrapon(ActorRef)
endFunction

Armor function LoadStrapon(string esp, int id)
	return ActorLib.LoadStrapon(esp, id)
endFunction

function ForbidActor(Actor ActorRef)
	ActorLib.ForbidActor(ActorRef)
endFunction

function AllowActor(Actor ActorRef)
	ActorLib.AllowActor(ActorRef)
endFunction

bool function IsForbidden(Actor ActorRef)
	return ActorLib.IsForbidden(ActorRef)
endFunction

function TreatAsMale(Actor ActorRef)
	ActorLib.TreatAsMale(ActorRef)
endFunction

function TreatAsFemale(Actor ActorRef)
	ActorLib.TreatAsFemale(ActorRef)
endFunction

function ClearForcedGender(Actor ActorRef)
	ActorLib.ClearForcedGender(ActorRef)
endFunction

int function GetGender(Actor ActorRef)
	return ActorLib.GetGender(ActorRef)
endFunction

int[] function GenderCount(Actor[] Positions)
	return ActorLib.GenderCount(Positions)
endFunction

int function MaleCount(Actor[] Positions)
	return ActorLib.MaleCount(Positions)
endFunction

int function FemaleCount(Actor[] Positions)
	return ActorLib.FemaleCount(Positions)
endFunction

int function CreatureCount(Actor[] Positions)
	return ActorLib.CreatureCount(Positions)
endFunction

; ;#------------------------------#
; ;#     END ACTOR FUNCTIONS      #
; ;#------------------------------#


; ;#------------------------------#
; ;#  BEGIN CONTROLLER FUNCTIONS  #
; ;#------------------------------#

ObjectReference function FindBed(ObjectReference CenterRef, float Radius = 1000.0, bool IgnoreUsed = true, ObjectReference IgnoreRef1 = none, ObjectReference IgnoreRef2 = none)
	return ThreadLib.FindBed(CenterRef, Radius, IgnoreUsed, IgnoreRef1, IgnoreRef2)
endFunction

sslThreadController function GetActorController(Actor ActorRef)
	return ThreadSlots.GetActorController(ActorRef)
endFunction

sslThreadController function GetPlayerController()
	return ThreadSlots.GetActorController(PlayerRef)
endFunction

sslThreadController function GetController(int tid)
	return ThreadSlots.GetController(tid)
endFunction

int function FindActorController(Actor ActorRef)
	return ThreadSlots.FindActorController(ActorRef)
endFunction

int function FindPlayerController()
	return ThreadSlots.FindActorController(PlayerRef)
endFunction

; ;#---------------------------#
; ;#   END THREAD FUNCTIONS    #
; ;#---------------------------#

; ;#---------------------------#
; ;# BEGIN ANIMATION FUNCTIONS #
; ;#---------------------------#

sslBaseAnimation[] function GetAnimationsByTags(int ActorCount, string Tags, string TagsSuppressed = "", bool RequireAll = true)
	return AnimSlots.GetByTags(ActorCount, Tags, TagsSuppressed, RequireAll)
endFunction

sslBaseAnimation[] function GetAnimationsByTag(int ActorCount, string Tag1, string Tag2 = "", string Tag3 = "", string TagsSuppressed = "", bool RequireAll = true)
	return AnimSlots.GetByTags(ActorCount, sslUtility.MakeArgs(",", Tag1, Tag2, Tag3), TagsSuppressed, RequireAll)
endFunction

sslBaseAnimation[] function GetAnimationsByType(int ActorCount, int Males = -1, int Females = -1, int StageCount = -1, bool Aggressive = false, bool Sexual = true)
	return AnimSlots.GetByType(ActorCount, Males, Females, StageCount, Aggressive, Sexual)
endFunction

sslBaseAnimation[] function PickAnimationsByActors(actor[] Positions, int limit = 64, bool aggressive = false)
	return AnimSlots.PickByActors(Positions, limit, aggressive)
endFunction

sslBaseAnimation[] function GetAnimationsByDefault(int Males, int Females, bool IsAggressive = false, bool UsingBed = false, bool RestrictAggressive = true)
	return AnimSlots.GetByDefault(Males, Females, IsAggressive, UsingBed, RestrictAggressive)
endFunction

sslBaseAnimation[] function MergeAnimationLists(sslBaseAnimation[] List1, sslBaseAnimation[] List2)
	return AnimSlots.MergeLists(List1, List2)
endFunction

sslBaseAnimation function GetAnimationByName(string FindName)
	return AnimSlots.GetByName(FindName)
endFunction

int function FindAnimationByName(string FindName)
	return AnimSlots.FindByName(FindName)
endFunction

int function GetAnimationCount(bool IgnoreDisabled = true)
	return AnimSlots.GetCount(IgnoreDisabled)
endFunction

; bool function AllowedCreature(Race creature)
; 	return AnimLib.AllowedCreature(creature)
; endFunction

; bool function AllowedCreatureCombination(Race creature, Race creature2)
; 	return AnimLib.AllowedCreatureCombination(creature, creature2)
; endFunction

; string function MakeAnimationGenderTag(actor[] Positions)
; 	AnimLib.MakeGenderTag(Positions)
; endFunction

; ;#---------------------------#
; ;#  END ANIMATION FUNCTIONS  #
; ;#---------------------------#

; ;#---------------------------#
; ;#   BEGIN VOICE FUNCTIONS   #
; ;#---------------------------#

; sslBaseVoice function PickVoice(actor a)
; 	return VoiceLib.PickVoice(a)
; endFunction

; function SaveVoice(actor a, sslBaseVoice saving)
; 	VoiceLib.SaveVoice(a, saving)
; endFunction

; function ForgetVoice(actor a)
; 	VoiceLib.ForgetVoice(a)
; endFunction

; sslBaseVoice function GetVoice(actor a)
; 	return VoiceLib.GetVoice(a)
; endFunction

; sslBaseVoice function GetVoiceByGender(int g)
; 	return VoiceSlots.GetRandom(g)
; endFunction

; sslBaseVoice function GetVoiceByName(string findName)
; 	return VoiceSlots.GetByName(findName)
; endFunction

; int function FindVoiceByName(string findName)
; 	return VoiceSlots.FindByName(findName)
; endFunction

; sslBaseVoice function GetVoiceByTag(string tag1, string tag2 = "", string tagSuppress = "", bool requireAll = true)
; 	return VoiceSlots.GetByTag(tag1, tag2, tagSuppress, requireAll)
; endFunction

; sslBaseVoice function GetVoiceBySlot(int slot)
; 	return VoiceSlots.GetBySlot(slot)
; endFunction

; int function RegisterVoice(sslBaseVoice voice)
; 	return -1
; endFunction

; ;#---------------------------#
; ;#    END VOICE FUNCTIONS    #
; ;#---------------------------#

; ;#---------------------------#
; ;# BEGIN EXPRESSION FUNCTION #
; ;#---------------------------#

; function ClearMFG(actor ActorRef)
; 	sslExpressionLibrary.ClearMFG(ActorRef)
; endFunction

; function ClearPhoneme(actor ActorRef)
; 	sslExpressionLibrary.ClearPhoneme(ActorRef)
; endFunction

; function OpenMouth(actor ActorRef)
; 	sslExpressionLibrary.OpenMouth(ActorRef)
; endFunction

; bool function IsMouthOpen(actor ActorRef)
; 	return sslExpressionLibrary.IsMouthOpen(ActorRef)
; endFunction

; sslBaseExpression function PickExpression(actor ActorRef, actor VictimRef = none)
; 	return ExpressionLib.PickExpression(ActorRef, VictimRef)
; endFunction

; sslBaseExpression function RandomExpressionByTag(string tag)
; 	return ExpressionSlots.RandomByTag(tag)
; endFunction

; sslBaseExpression  function GetExpressionByName(string findName)
; 	return ExpressionSlots.GetByName(findName)
; endFunction

; int function FindExpressionByName(string findName)
; 	return ExpressionSlots.FindByName(findName)
; endFunction

; sslBaseExpression function GetExpressionBySlot(int slot)
; 	return ExpressionSlots.GetBySlot(slot)
; endFunction

; ;#---------------------------#
; ;#  END EXPRESSION FUNCTIONS #
; ;#---------------------------#

; ;#---------------------------#
; ;#    START HOOK FUNCTIONS   #
; ;#---------------------------#

; sslThreadController function HookController(string argString)
; 	return ThreadSlots.GetController(argString as int)
; endFunction

; sslBaseAnimation function HookAnimation(string argString)
; 	return ThreadSlots.GetController(argString as int).Animation
; endFunction

; int function HookStage(string argString)
; 	return ThreadSlots.GetController(argString as int).Stage
; endFunction

; actor function HookVictim(string argString)
; 	return ThreadSlots.GetController(argString as int).VictimRef
; endFunction

; actor[] function HookActors(string argString)
; 	return ThreadSlots.GetController(argString as int).Positions
; endFunction

; float function HookTime(string argString)
; 	return ThreadSlots.GetController(argString as int).TotalTime
; endFunction

; ;#---------------------------#
; ;#    END HOOK FUNCTIONS     #
; ;#---------------------------#

; ;#---------------------------#
; ;#   START STAT FUNCTIONS    #
; ;#---------------------------#

; int function RegisterStat(string name, string value, string prepend = "", string append = "")
; 	return Stats.RegisterStat(name, value, prepend, append)
; endFunction

; int function FindStat(string name)
; 	return Stats.FindStat(name)
; endFunction

; function Alter(string name, string newName = "", string value = "", string prepend = "", string append = "")
; 	Stats.Alter(name, newName, value, prepend, append)
; endFunction

; string function GetActorStat(actor ActorRef, string name)
; 	return Stats.GetStat(ActorRef, name)
; endFunction

; int function GetActorStatInt(actor ActorRef, string name)
; 	return Stats.GetStatInt(ActorRef, name)
; endFunction

; float function GetActorStatFloat(actor ActorRef, string name)
; 	return Stats.GetStatFloat(ActorRef, name)
; endFunction

; string function SetActorStat(actor ActorRef, string name, string value)
; 	return Stats.SetStat(ActorRef, name, value)
; endFunction

; int function ActorAdjustBy(actor ActorRef, string name, int adjust)
; 	return Stats.AdjustBy(ActorRef, name, adjust)
; endFunction

; string function GetActorStatFull(actor ActorRef, string name)
; 	return Stats.GetStatFull(ActorRef, name)
; endFunction

; string function GetStatFull(string name)
; 	return Stats.GetStatFull(PlayerRef, name)
; endFunction

; string function GetStat(string name)
; 	return Stats.GetStat(PlayerRef, name)
; endFunction

; int function GetStatInt(string name)
; 	return Stats.GetStatInt(PlayerRef, name)
; endFunction

; float function GetStatFloat(string name)
; 	return Stats.GetStatFloat(PlayerRef, name)
; endFunction

; string function SetStat(string name, string value)
; 	return Stats.SetStat(PlayerRef, name, value)
; endFunction

; int function AdjustBy(string name, int adjust)
; 	return Stats.AdjustBy(PlayerRef, name, adjust)
; endFunction

; int function CalcSexuality(bool IsFemale, int males, int females)
; 	return Stats.CalcSexuality(IsFemale, males, females)
; endFunction

; int function CalcLevel(float total, float curve = 0.65)
; 	return Stats.CalcLevel(total, curve)
; endFunction

; string function ParseTime(int time)
; 	return Stats.ParseTime(time)
; endFunction

; int function PlayerSexCount(actor a)
; 	return Stats.PlayerSexCount(a)
; endFunction

; bool function HadPlayerSex(actor a)
; 	return Stats.HadPlayerSex(a)
; endFunction

; function AddPlayerSex(actor a)
; 	Stats.AddPlayerSex(a)
; endFunction

; float function AdjustPurity(actor ActorRef, float amount)
; 	Stats.AdjustFloat(ActorRef, "Purity", amount)
; 	return Stats.GetPurity(ActorRef)
; endFunction

; float function AdjustPlayerPurity(float amount)
; 	Stats.AdjustFloat(PlayerRef, "Purity", amount)
; 	return Stats.GetPurity(PlayerRef)
; endFunction

; int function GetPlayerPurityLevel()
; 	return Stats.GetPlayerPurityLevel()
; endFunction

; string function GetPlayerPurityTitle()
; 	return Stats.GetPlayerPurityTitle()
; endFunction

; string function GetPlayerSexualityTitle()
; 	return Stats.GetSexualityTitle(PlayerRef)
; endFunction

; int function GetPlayerStatLevel(string type)
; 	return Stats.GetPlayerSkillLevel(type)
; endFunction
; int function GetPlayerSkillLevel(string skill)
; 	return Stats.GetPlayerSkillLevel(skill)
; endFunction

; string function GetPlayerSkillTitle(string skill)
; 	return Stats.GetPlayerSkillTitle(skill)
; endFunction

; int function GetSexuality(actor ActorRef)
; 	return Stats.GetSexuality(ActorRef)
; endFunction

; string function GetSexualityTitle(actor ActorRef)
; 	return Stats.GetSexualityTitle(ActorRef)
; endFunction

; string function GetSkillTitle(actor ActorRef, string skill)
; 	return Stats.GetSkillTitle(ActorRef, skill)
; endFunction

; int function GetSkill(actor ActorRef, string skill)
; 	return Stats.GetSkill(ActorRef, skill)
; endFunction

; int function GetSkillLevel(actor ActorRef, string skill)
; 	return Stats.GetSkillLevel(ActorRef, skill)
; endFunction

; float function GetPurity(actor ActorRef)
; 	return Stats.GetPurity(ActorRef)
; endFunction

; int function GetPurityLevel(actor ActorRef)
; 	return Stats.GetPurityLevel(ActorRef)
; endFunction

; string function GetPurityTitle(actor ActorRef)
; 	return Stats.GetPurityTitle(ActorRef)
; endFunction

; bool function IsPure(actor ActorRef)
; 	return Stats.IsPure(ActorRef)
; endFunction

; bool function IsImpure(actor ActorRef)
; 	return Stats.IsImpure(ActorRef)
; endFunction

; bool function IsStraight(actor ActorRef)
; 	return IsStraight(ActorRef)
; endFunction

; bool function IsBisexual(actor ActorRef)
; 	return IsBisexual(ActorRef)
; endFunction

; bool function IsGay(actor ActorRef)
; 	return IsGay(ActorRef)
; endFunction

; int function SexCount(actor a)
; 	return Stats.SexCount(a)
; endFunction

; bool function HadSex(actor a)
; 	return Stats.HadSex(a)
; endFunction

; ; Last sex - Game time - float days
; float function LastSexGameTime(actor a)
; 	return Stats.LastSexGameTime(a)
; endFunction

; float function DaysSinceLastSex(actor a)
; 	return Stats.DaysSinceLastSex(a)
; endFunction

; float function HoursSinceLastSex(actor a)
; 	return Stats.HoursSinceLastSex(a)
; endFunction

; float function MinutesSinceLastSex(actor a)
; 	return Stats.MinutesSinceLastSex(a)
; endFunction

; float function SecondsSinceLastSex(actor a)
; 	return Stats.SecondsSinceLastSex(a)
; endFunction

; string function LastSexTimerString(actor a)
; 	return Stats.LastSexTimerString(a)
; endFunction

; ; Last sex - Real Time - float seconds
; float function LastSexRealTime(actor a)
; 	return Stats.LastSexRealTime(a)
; endFunction

; float function SecondsSinceLastSexRealTime(actor a)
; 	return Stats.SecondsSinceLastSexRealTime(a)
; endFunction

; float function MinutesSinceLastSexRealTime(actor a)
; 	return Stats.MinutesSinceLastSexRealTime(a)
; endFunction

; float function HoursSinceLastSexRealTime(actor a)
; 	return Stats.HoursSinceLastSexRealTime(a)
; endFunction

; float function DaysSinceLastSexRealTime(actor a)
; 	return Stats.DaysSinceLastSexRealTime(a)
; endFunction

; string function LastSexTimerStringRealTime(actor a)
; 	return Stats.LastSexTimerStringRealTime(a)
; endFunction

; string[] function GetInfo(string name)
; 	return none ; Removed in 1.32
; endFunction

; ;#---------------------------#
; ;#    END STAT FUNCTIONS     #
; ;#---------------------------#



; ;#---------------------------#
; ;#                           #
; ;# END API RELATED FUNCTIONS #
; ;#                           #
; ;#---------------------------#


; ------------------------------------------------------- ;
; --- Intended for system use only - DO NOT USE       --- ;
; ------------------------------------------------------- ;

function Initialize()
	Actor[] aInit
	DebugActor    = aInit
	SystemEnabled = true

	RegisterForModEvent("StageStart", "PlainHook")
	RegisterForModEvent("StageEnd_Test", "TestHook")
	Log("SexLab Initialized")
endFunction

event PlainHook(int tid, string HookEvent)
	sslThreadController Thread = GetController(tid)
	Log("Plain hook --  "+HookEvent+" -- on "+Thread.tid)
endEvent
event TestHook(int tid, string HookEvent)
	sslThreadController Thread = GetController(tid)
	Log("Custom hook --  "+HookEvent+" -- on "+Thread.tid)
endEvent


function EnableSystem(bool EnableSexLab = true)
	SystemEnabled = EnableSexLab
	if !EnableSexLab
		ThreadSlots.StopAll()
	endIf
endFunction

function Log(string Log, string Type = "NOTICE")
	SexLabUtil.DebugLog(Log, Type, Config.DebugMode)
endFunction
