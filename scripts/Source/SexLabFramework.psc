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


int function GetVersion()
	return SexLabUtil.GetVersion()
endFunction

string function GetStringVer()
	return SexLabUtil.GetStringVer()
endFunction

bool property Enabled hidden
	bool function get()
		return GetState() != "Disabled"
	endFunction
endProperty

bool property IsRunning hidden
	bool function get()
		return ThreadSlots.IsRunning()
	endFunction
endProperty

int property ActiveAnimations hidden
	int function get()
		return ThreadSlots.ActiveThreads()
	endFunction
endProperty

sslSystemConfig property Config auto

;#---------------------------#
;#                           #
;#   API RELATED FUNCTIONS   #
;#                           #
;#---------------------------#

sslThreadModel function NewThread(float TimeOut = 30.0)
	; Claim an available thread
	return ThreadSlots.PickModel(TimeOut)
endFunction

int function StartSex(Actor[] Positions, sslBaseAnimation[] Anims, Actor Victim = none, ObjectReference CenterOn = none, bool AllowBed = true, string Hook = "")
	; Claim a thread
	sslThreadModel Make = NewThread()
	if !Make
		Log("StartSex() - Failed to claim an available thread")
		return -1
	; Add actors list to thread
	elseIf !Make.AddActors(Positions, Victim)
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

sslThreadController function QuickStart(Actor Actor1, Actor Actor2 = none, Actor Actor3 = none, Actor Actor4 = none, Actor Actor5 = none, Actor Victim = none, string Hook = "", string AnimationTags = "")
	Actor[] Positions = sslUtility.MakeActorArray(Actor1, Actor2, Actor3, Actor4, Actor5)
	sslBaseAnimation[] Anims
	if AnimationTags != ""
		Anims = AnimSlots.GetByTags(Positions.Length, AnimationTags, "", false)
	endIf
	return ThreadSlots.GetController(StartSex(Positions, Anims, Victim, none, true, Hook))
endFunction

;#------------------------------#
;#  ACTOR FUNCTIONS             #
;#------------------------------#

;/**
* Gets an actors "SexLab gender" which may differ from their vanilla ActorBase.GetSex() if their gender has been overridden.
* 
* @param  Actor ActorRef - The actor to get the SexLab gender for.
* @return int - 0 for male, 1 for female, 3 for creature, 4 for female creature if creature genders are enabled and they are female - otherwise female creatures will default to 3 along with males.
**/;
int function GetGender(Actor ActorRef)
	return ActorLib.GetGender(ActorRef)
endFunction

;/**
* Force an actors SexLab gender to be considered male, even if their ActorBase.GetSex() is female. Useful for having SexLab treat female hermaphrodites as if they were male.
* 
* @param  Actor ActorRef - The actor to set SexLab gender to male.
**/;
function TreatAsMale(Actor ActorRef)
	ActorLib.TreatAsMale(ActorRef)
endFunction

;/**
* Force an actors SexLab gender to be considered male, even if their ActorBase.GetSex() is male. Useful for having SexLab treat male character as if they were female.
* 
* @param  Actor ActorRef - The actor to set SexLab gender to female.
**/;
function TreatAsFemale(Actor ActorRef)
	ActorLib.TreatAsFemale(ActorRef)
endFunction

;/**
* Force an actors SexLab gender to be considered male or female.
* 
* @param  Actor ActorRef - The actor to set SexLab gender.
* @param  bool AsFemale - TRUE to make female, FALSE to make male.
**/;
function TreatAsGender(Actor ActorRef, bool AsFemale)
	ActorLib.TreatAsGender(ActorRef, AsFemale)
endFunction

;/**
* Clears any forced SexLab genders on actor from TreatAsMale/Female/Gender() functions.
* 
* @param  Actor ActorRef - The actor to clear forced gender on, reverting them to their vanilla gender.
**/;
function ClearForcedGender(Actor ActorRef)
	ActorLib.ClearForcedGender(ActorRef)
endFunction

;/**
* Get an array of counts for the each gender in a list of actors.
* 
* @param  Actor[] Positions - The array of actors you want to check.
* @return int[] - A 4 length array of the genders. [0] Males, [1] Females, [2] Creatures, [3] Female Creatures - if Creature Genders are enabled by the user.
**/;
int[] function GenderCount(Actor[] Positions)
	return ActorLib.GenderCount(Positions)
endFunction

;/**
* 
* 
* @param  Actor[] Positions - The array of actors you want to check.
* @return int - The number of males in Positions array.
**/;
int function MaleCount(Actor[] Positions)
	return ActorLib.MaleCount(Positions)
endFunction

;/**
* 
* 
* @param  Actor[] Positions - The array of actors you want to check.
* @return int - The number of females in Positions array.
**/;
int function FemaleCount(Actor[] Positions)
	return ActorLib.FemaleCount(Positions)
endFunction

;/**
* 
* 
* @param  Actor[] Positions - The array of actors you want to check.
* @return int - The number of creatures in Positions array.
**/;
int function CreatureCount(Actor[] Positions)
	return ActorLib.CreatureCount(Positions)
endFunction

;/**
* Checks if given actor is a valid target for SexLab animation.
* 
* @param  Actor ActorRef - The actor to check for validation
* @return int - The integer code of the validation state
*                1 if valid actor, signed int if invalid.
**/;
int function ValidateActor(Actor ActorRef)
	return ActorLib.ValidateActor(ActorRef)
endFunction

;/**
* Checks if given actor is a valid target for SexLab animation.
* Equivalent to ValidateActor() == 1
**/;
bool function IsValidActor(Actor ActorRef)
	return ActorLib.IsValidActor(ActorRef)
endFunction

;/**
* Checks if the given actor is active in any SexLab animation
* 
* @param  Actor ActorRef - The actor to check for activity
* @return bool - TRUE if ActorRef is being animated by SexLab.
**/;
bool function IsActorActive(Actor ActorRef)
	return ActorRef.IsInFaction(Config.AnimatingFaction)
endFunction

;/**
* Make an actor never allowed to engage in SexLab scenes.
* 
* @param  Actor ActorRef - The actor to forbid from SexLab use.
**/;
function ForbidActor(Actor ActorRef)
	ActorLib.ForbidActor(ActorRef)
endFunction

;/**
* Removes an actor from the forbidden list, undoing the effects of ForbidActor()
* 
* @param  Actor ActorRef - The actor to remove from the forbid list.
**/;
function AllowActor(Actor ActorRef)
	ActorLib.AllowActor(ActorRef)
endFunction

;/**
* Checks if an actor is currently forbidden from use in SexLab scenes.
* 
* @param  Actor ActorRef - The actor to check.
* @return bool - TRUE if the actor is forbidden from use.
**/;
bool function IsForbidden(Actor ActorRef)
	return ActorLib.IsForbidden(ActorRef)
endFunction

;/**
* Searches within a given area for a SexLab valid actor
* 
* @param  ObjectReference CenterRef - The object to use as the center point in the search. 
* @param  float Radius - The distance from the center point to search.
* @param  int FindGender - The desired gender id to look for, -1 for any, 0 for male, 1 for female.
* @param  Actor IgnoreRef1/2/3/4 - An actor you know for certain you do not want returned by this function.
* @return Actor - A valid actor found, if any. Returns none if no valid actor found.
**/;
Actor function FindAvailableActor(ObjectReference CenterRef, float Radius = 5000.0, int FindGender = -1, Actor IgnoreRef1 = none, Actor IgnoreRef2 = none, Actor IgnoreRef3 = none, Actor IgnoreRef4 = none)
	return ThreadLib.FindAvailableActor(CenterRef, Radius, FindGender, IgnoreRef1, IgnoreRef2, IgnoreRef3, IgnoreRef4)
endFunction

;/**
* Searches within a given area for multiple SexLab valid actors
* 
* @param  Actor[] Positions - A list of at least 1 actor you want to find the needed partners for.
* @param  int TotalActors - The desired total number of actors you want in the return array.
* @param  int Males - From the TotalActors amount, you want at least this many males.
* @param  int Females - From the TotalActors amount, you want at least this many females.
* @param  float Radius - The distance from the center point to search.
* @return Actor[] - A list of valid actors that is at most the length of TotalActors.
**/;
Actor[] function FindAvailablePartners(Actor[] Positions, int TotalActors, int Males = -1, int Females = -1, float Radius = 10000.0)
	return ThreadLib.FindAvailablePartners(Positions, TotalActors, Males, Females, Radius)
endFunction

;/**
* Sort a list of actors to include either female or male actors first in the array.
* SexLab animations generally expect the female actor to be listed first in a scene.
* 
* @param  Actor[] Positions - The list of actors to sort by gender
* @param  bool FemaleFirst - If switched to FALSE, male actors will be sorted first instead of females.
* @return Actor[] - The final sorted list of actors.
**/;
Actor[] function SortActors(Actor[] Positions, bool FemaleFirst = true)
	return ThreadLib.SortActors(Positions, FemaleFirst)
endFunction

;/**
* Applies the cum effect to an actor for the given locations
* 
* @param  Actor ActorRef - The actor to apply the cum effectshader to
* @param  bool Vaginal/Oral/Anal - Each location set to TRUE will have it's effect stacked.
**/;
function AddCum(Actor ActorRef, bool Vaginal = true, bool Oral = true, bool Anal = true)
	ActorLib.AddCum(ActorRef, Vaginal, Oral, Anal)
endFunction

;/**
* Removes existing cum effectshaders.
* 
* @param  Actor ActorRef - The actor you want to remove the effectshaders from.
**/;
function ClearCum(Actor ActorRef)
	ActorLib.ClearCum(ActorRef)
endFunction

;/**
* Strip an actor using SexLab's strip settings as chosen by the user from the SexLab MCM
* 
* @param  Actor ActorRef - The actor whose equipment shall be un-equipped.
* @param  Actor VictimRef - If ActorRef matches VictimRef victim strip settings are used. If VictimRef is set but doesn't match, aggressor settings are used.
* @param  bool DoAnimate - Whether or not to play the actor stripping animation during
* @param  bool LeadIn - If TRUE and VictimRef == none, Foreplay strip settings will be used.
* @return Form[] - An array of all equipment stripped from ActorRef
**/;
Form[] function StripActor(Actor ActorRef, Actor VictimRef = none, bool DoAnimate = true, bool LeadIn = false)
	return ActorLib.StripActor(ActorRef, VictimRef, DoAnimate, LeadIn)
endFunction

;/**
* Strip an actor of equipment using a custom selection of biped objects / slot masks.
* See for slot values: http://www.creationkit.com/Biped_Object
* 
* @param  Actor ActorRef - The actor whose equipment shall be un-equipped.
* @param  bool[] Strip - MUST be exactly 33 array length. Any index set to TRUE will be stripped using nth + 30 = biped object / slot mask. The extra index Strip[32] = weapons
* @param  bool DoAnimate - Whether or not to play the actor stripping animation during
* @param  bool AllowNudesuit - Whether to allow the use of nudesuits, if the user has that option enabled in the MCM (the poor fool)
* @return Form[] - An array of all equipment stripped from ActorRef
**/;
Form[] function StripSlots(Actor ActorRef, bool[] Strip, bool DoAnimate = false, bool AllowNudesuit = true)
	return ActorLib.StripSlots(ActorRef, Strip, DoAnimate, AllowNudesuit)
endFunction

;/**
* Equips an actor with the given equipment. Intended for reversing the results of the Strip functions using their return results.
* 
* @param  Actor ActorRef - The actor whose equipment shall be re-equipped.
* @param  Form[] Stripped - A form array of all the equipment to be equipped on ActorRef. Typically the saved result of StripActor() or StripSlots()
* @param  bool IsVictim - If TRUE and the user has the SexLab MCM option for Victims Redress disabled, the actor will not actually re-equip their gear.
**/;
function UnstripActor(Actor ActorRef, Form[] Stripped, bool IsVictim = false)
	ActorLib.UnstripActor(ActorRef, Stripped, IsVictim)
endFunction

;/**
* Check if a given item is considered able to be removed by the SexLab strip functions.
* 
* @param  Form ItemRef - The item you want to check.
* @return bool - TRUE if the item does not have the keyword with the word "NoStrip" in it, or is flagged as "Always Strip" in the SexLab MCM Strip Editor.
**/;
bool function IsStrippable(Form ItemRef)
	return ActorLib.IsStrippable(ItemRef)
endFunction

;/**
* Removes the item from the given slot mask, if it is considered strippable by SexLab.
* 
* @param  Actor ActorRef - The actor to un-equip the slot from
* @param  int SlotMask - The slot mask id for your chosen biped object. See more: http://www.creationkit.com/Slot_Masks_-_Armor
* @return Form - The item equipped on the SlotMask if removed. None if it was not removed or nothing was there.
**/;
Form function StripSlot(Actor ActorRef, int SlotMask)
	return ActorLib.StripSlot(ActorRef, SlotMask)
endFunction

;/**
* Checks and returns for any registered SexLab strapons in an actors inventory.
* 
* @param  Actor ActorRef - The actor to look for a strapon on.
* @return Form - The SexLab registered strapon actor is currently wearing, if any.
**/;
Form function WornStrapon(Actor ActorRef)
	return Config.WornStrapon(ActorRef)
endFunction

;/**
* Checks for any registered SexLab strapons on an actor.
* 
* @param  Actor ActorRef - The actor to look for a strapon on.
* @return bool - TRUE if the actor has a SexLab registered strapon equipped or in their inventory.
**/;
bool function HasStrapon(Actor ActorRef)
	return Config.HasStrapon(ActorRef)
endFunction

;/**
* Picks a strapon from the SexLab registered strapons for the actor to use.
* 
* @param  Actor ActorRef - The actor to look for a strapon to use.
* @return Form - A randomly selected strapon or the strapon the actor already has in inventory, if any.
**/;
Form function PickStrapon(Actor ActorRef)
	return Config.PickStrapon(ActorRef)
endFunction

;/**
* Equips a SexLab registered strapon on the actor.
* 
* @param  Actor ActorRef - The actor to equip a strapon.
* @return Form - The strapon equipped, either randomly selected or pre-owned by ActorRef.
**/;
Form function EquipStrapon(Actor ActorRef)
	return Config.EquipStrapon(ActorRef)
endFunction

;/**
* Un-equips a strapon from an actor, if they are wearing one.
* 
* @param  Actor ActorRef - The actor to un-equip any worn strapon.
**/;
function UnequipStrapon(Actor ActorRef)
	Config.UnequipStrapon(ActorRef)
endFunction

;/**
* Loads an armor from mod into the list of valid strapons to use.
* 
* @param  string esp - the .esp/.esm mod to load a form from.
* @param  int id - the form id to load from the esp 
* @return Armor - If form was found and is a valid armor, a copy of the loaded Armor form. 
**/;
Armor function LoadStrapon(string esp, int id)
	return Config.LoadStrapon(esp, id)
endFunction


;/**
* Removes an actor from the audience of any currently active bard scenes, preventing them from playing the clapping animation.
* For more future prevention, add actor to the faction BardAudienceExcludedFaction (id: 0x0010FCB4)
* 
* @param  Actor ActorRef - The actor you want to remove/check
* @param  bool RemoveFromAudience - Set to FALSE to only check if they are present and not remove them fromt he audience.
* @return bool - TRUE if ActorRef was/is present in a bard audience
**/;
bool function CheckBardAudience(Actor ActorRef, bool RemoveFromAudience = true)
	return Config.CheckBardAudience(ActorRef, RemoveFromAudience)
endFunction

;#------------------------------#
;#     END ACTOR FUNCTIONS      #
;#------------------------------#


;#------------------------------#
;#  BEGIN CONTROLLER FUNCTIONS  #
;#------------------------------#

ObjectReference function FindBed(ObjectReference CenterRef, float Radius = 1000.0, bool IgnoreUsed = true, ObjectReference IgnoreRef1 = none, ObjectReference IgnoreRef2 = none)
	return ThreadLib.FindBed(CenterRef, Radius, IgnoreUsed, IgnoreRef1, IgnoreRef2)
endFunction

bool function IsBedRoll(ObjectReference BedRef)
	return ThreadLib.IsBedRoll(BedRef)
endFunction

bool function IsDoubleBed(ObjectReference BedRef)
	return ThreadLib.IsDoubleBed(BedRef)
endFunction

bool function IsSingleBed(ObjectReference BedRef)
	return ThreadLib.IsSingleBed(BedRef)
endFunction

bool function IsBedAvailable(ObjectReference BedRef)
	return ThreadLib.IsBedAvailable(BedRef)
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

function TrackActor(Actor ActorRef, string Callback)
	ThreadLib.TrackActor(ActorRef, Callback)
endFunction

function UntrackActor(Actor ActorRef, string Callback)
	ThreadLib.UntrackActor(ActorRef, Callback)
endFunction

function TrackFaction(Faction FactionRef, string Callback)
	ThreadLib.TrackFaction(FactionRef, Callback)
endFunction

function UntrackFaction(Faction FactionRef, string Callback)
	ThreadLib.UntrackFaction(FactionRef, Callback)
endFunction

function SendTrackedEvent(Actor ActorRef, string Hook, int id = -1)
	ThreadLib.SendTrackedEvent(ActorRef, Hook, id)
endFunction

bool function IsActorTracked(Actor ActorRef)
	return ThreadLib.IsActorTracked(ActorRef)
endFunction

;#---------------------------#
;#   END THREAD FUNCTIONS    #
;#---------------------------#

;#---------------------------#
;# BEGIN ANIMATION FUNCTIONS #
;#---------------------------#

sslBaseAnimation[] function GetAnimationsByTags(int ActorCount, string Tags, string TagSuppress = "", bool RequireAll = true)
	return AnimSlots.GetByTags(ActorCount, Tags, TagSuppress, RequireAll)
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
	return sslUtility.MergeAnimationLists(List1, List2)
endFunction

sslBaseAnimation[] function RemoveTagged(sslBaseAnimation[] Anims, string Tags)
	return sslUtility.RemoveTaggedAnimations(Anims, PapyrusUtil.StringSplit(Tags))
endFunction

sslBaseAnimation function GetAnimationByName(string FindName)
	return AnimSlots.GetByName(FindName)
endFunction

sslBaseAnimation function GetAnimationByRegistry(string Registry)
	return AnimSlots.GetByRegistrar(Registry)
endFunction

int function CountTag(sslBaseAnimation[] Anims, string Tags)
	return AnimSlots.CountTag(Anims, Tags)
endFunction

int function FindAnimationByName(string FindName)
	return AnimSlots.FindByName(FindName)
endFunction

int function GetAnimationCount(bool IgnoreDisabled = true)
	return AnimSlots.GetCount(IgnoreDisabled)
endFunction

bool function AllowedCreature(Race CreatureRace)
	return CreatureSlots.AllowedCreature(CreatureRace)
endFunction

bool function AllowedCreatureCombination(Race CreatureRace, Race CreatureRace2)
	return CreatureSlots.AllowedCreatureCombination(CreatureRace, CreatureRace2)
endFunction

string function MakeAnimationGenderTag(Actor[] Positions)
	return ActorLib.MakeGenderTag(Positions)
endFunction

string function GetGenderTag(int Females = 0, int Males = 0, int Creatures = 0)
	return ActorLib.GetGenderTag(Females, Males, Creatures)
endFunction

; DEPRECATED
sslBaseAnimation[] function GetAnimationsByTag(int ActorCount, string Tag1, string Tag2 = "", string Tag3 = "", string TagSuppress = "", bool RequireAll = true)
	return AnimSlots.GetByTags(ActorCount, sslUtility.MakeArgs(",", Tag1, Tag2, Tag3), TagSuppress, RequireAll)
endFunction

;#---------------------------#
;#  END ANIMATION FUNCTIONS  #
;#---------------------------#

;#---------------------------#
;# START CREATURES FUNCTIONS #
;#---------------------------#

sslBaseAnimation[] function GetCreatureAnimationsByRace(int ActorCount, Race RaceRef)
	return CreatureSlots.GetByRace(ActorCount, RaceRef)
endFunction

sslBaseAnimation[] function GetCreatureAnimationsByRaceKey(int ActorCount, string RaceKey)
	return CreatureSlots.GetByRaceKey(ActorCount, RaceKey)
endFunction

sslBaseAnimation[] function GetCreatureAnimationsByRaceGenders(int ActorCount, Race RaceRef, int MaleCreatures = 0, int FemaleCreatures = 0, bool ForceUse = false)
	return CreatureSlots.GetByRaceGenders(ActorCount, RaceRef, MaleCreatures, FemaleCreatures, ForceUse)
endFunction

sslBaseAnimation function GetCreatureAnimationByName(string FindName)
	return CreatureSlots.GetByName(FindName)
endFunction

sslBaseAnimation function GetCreatureAnimationByRegistry(string Registry)
	return CreatureSlots.GetByRegistrar(Registry)
endFunction

;#---------------------------#
;#  END CREATURES FUNCTIONS  #
;#---------------------------#

;#---------------------------#
;#   BEGIN VOICE FUNCTIONS   #
;#---------------------------#

sslBaseVoice function PickVoice(Actor ActorRef)
	return VoiceSlots.PickVoice(ActorRef)
endFunction

; Alias of PickVoice()
sslBaseVoice function GetVoice(Actor ActorRef)
	return VoiceSlots.PickVoice(ActorRef)
endFunction

function SaveVoice(Actor ActorRef, sslBaseVoice Saving)
	VoiceSlots.SaveVoice(ActorRef, Saving)
endFunction

function ForgetVoice(Actor ActorRef)
	VoiceSlots.ForgetVoice(ActorRef)
endFunction

sslBaseVoice function GetVoiceByGender(int Gender)
	return VoiceSlots.PickGender(Gender)
endFunction

sslBaseVoice function GetVoiceByName(string FindName)
	return VoiceSlots.GetByName(FindName)
endFunction

int function FindVoiceByName(string FindName)
	return VoiceSlots.FindByName(FindName)
endFunction

sslBaseVoice function GetVoiceBySlot(int slot)
	return VoiceSlots.GetBySlot(slot)
endFunction

sslBaseVoice function GetVoiceByTags(string Tags, string TagSuppress = "", bool RequireAll = true)
	return VoiceSlots.GetByTags(Tags, TagSuppress, RequireAll)
endFunction

sslBaseVoice function GetVoiceByTag(string Tag1, string Tag2 = "", string TagSuppress = "", bool RequireAll = true)
	return VoiceSlots.GetByTags(sslUtility.MakeArgs(",", Tag1, Tag2), TagSuppress, RequireAll)
endFunction

bool function HasCustomVoice(Actor ActorRef)
	return VoiceSlots.HasCustomVoice(ActorRef)
endFunction

;#---------------------------#
;#    END VOICE FUNCTIONS    #
;#---------------------------#

;#---------------------------#
;# BEGIN EXPRESSION FUNCTION #
;#---------------------------#

sslBaseExpression function PickExpressionByStatus(Actor ActorRef, bool IsVictim = false, bool IsAggressor = false)
	return ExpressionSlots.PickByStatus(ActorRef, IsVictim, IsAggressor)
endFunction

sslBaseExpression function PickExpression(Actor ActorRef, Actor VictimRef = none)
	return ExpressionSlots.PickByStatus(ActorRef, (VictimRef && VictimRef == ActorRef), (VictimRef && VictimRef != ActorRef))
endFunction

sslBaseExpression function RandomExpressionByTag(string Tag)
	return ExpressionSlots.RandomByTag(Tag)
endFunction

sslBaseExpression  function GetExpressionByName(string findName)
	return ExpressionSlots.GetByName(findName)
endFunction

sslBaseExpression function GetExpressionBySlot(int slot)
	return ExpressionSlots.GetBySlot(slot)
endFunction

int function FindExpressionByName(string findName)
	return ExpressionSlots.FindByName(findName)
endFunction

function OpenMouth(Actor ActorRef)
	sslBaseExpression.OpenMouth(ActorRef)
endFunction

function CloseMouth(Actor ActorRef)
	sslBaseExpression.CloseMouth(ActorRef)
endFunction

bool function IsMouthOpen(Actor ActorRef)
	return sslBaseExpression.IsMouthOpen(ActorRef)
endFunction

function ClearMFG(Actor ActorRef)
	sslBaseExpression.ClearMFG(ActorRef)
endFunction

function ClearPhoneme(Actor ActorRef)
	sslBaseExpression.ClearPhoneme(ActorRef)
endFunction

function ClearModifier(Actor ActorRef)
	sslBaseExpression.ClearModifier(ActorRef)
endFunction

function ApplyPresetFloats(Actor ActorRef, float[] Preset)
	sslBaseExpression.ApplyPresetFloats(ActorRef, Preset)
endfunction

; DEPRECATED - Expression presets have migrated to float arrays of 0.0-1.0 instead of 0-100
; in order to be directly compatible with SKSE's native MFG functions.
function ApplyPreset(Actor ActorRef, int[] Preset)
	sslBaseExpression.ApplyPreset(ActorRef, Preset)
endFunction

;#---------------------------#
;#  END EXPRESSION FUNCTIONS #
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

Actor function HookVictim(string argString)
	return ThreadSlots.GetController(argString as int).VictimRef
endFunction

Actor[] function HookActors(string argString)
	return ThreadSlots.GetController(argString as int).Positions
endFunction

float function HookTime(string argString)
	return ThreadSlots.GetController(argString as int).TotalTime
endFunction

; TODO: Overkill?
int function GetEnjoyment(int tid, Actor ActorRef)
	return ThreadSlots.GetController(tid).GetEnjoyment(ActorRef)
endfunction

bool function IsVictim(int tid, Actor ActorRef)
	return ThreadSlots.GetController(tid).IsVictim(ActorRef)
endFunction

bool function IsAggressor(int tid, Actor ActorRef)
	return ThreadSlots.GetController(tid).IsAggressor(ActorRef)
endFunction

bool function IsUsingStrapon(int tid, Actor ActorRef)
	return ThreadSlots.GetController(tid).ActorAlias(ActorRef).IsUsingStrapon()
endFunction

bool function PregnancyRisk(int tid, Actor ActorRef, bool AllowFemaleCum = false, bool AllowCreatureCum = false)
	return ThreadSlots.GetController(tid).PregnancyRisk(ActorRef, AllowFemaleCum, AllowCreatureCum)
endfunction


;#---------------------------#
;#    END HOOK FUNCTIONS     #
;#---------------------------#

;#---------------------------#
;#   START STAT FUNCTIONS    #
;#---------------------------#

int function RegisterStat(string Name, string Value, string Prepend = "", string Append = "")
	return Stats.RegisterStat(Name, Value, Prepend, Append)
endFunction

int function FindStat(string Name)
	return Stats.FindStat(Name)
endFunction

function Alter(string Name, string NewName = "", string Value = "", string Prepend = "", string Append = "")
	Stats.Alter(Name, NewName, Value, Prepend, Append)
endFunction

string function GetActorStat(Actor ActorRef, string Name)
	return Stats.GetStat(ActorRef, Name)
endFunction

int function GetActorStatInt(Actor ActorRef, string Name)
	return Stats.GetStatInt(ActorRef, Name)
endFunction

float function GetActorStatFloat(Actor ActorRef, string Name)
	return Stats.GetStatFloat(ActorRef, Name)
endFunction

string function SetActorStat(Actor ActorRef, string Name, string Value)
	return Stats.SetStat(ActorRef, Name, Value)
endFunction

int function ActorAdjustBy(Actor ActorRef, string Name, int AdjustBy)
	return Stats.AdjustBy(ActorRef, Name, AdjustBy)
endFunction

string function GetActorStatFull(Actor ActorRef, string Name)
	return Stats.GetStatFull(ActorRef, Name)
endFunction

string function GetStatFull(string Name)
	return Stats.GetStatFull(PlayerRef, Name)
endFunction

string function GetStat(string Name)
	return Stats.GetStat(PlayerRef, Name)
endFunction

int function GetStatInt(string Name)
	return Stats.GetStatInt(PlayerRef, Name)
endFunction

float function GetStatFloat(string Name)
	return Stats.GetStatFloat(PlayerRef, Name)
endFunction

string function SetStat(string Name, string Value)
	return Stats.SetStat(PlayerRef, Name, Value)
endFunction

int function AdjustBy(string Name, int AdjustBy)
	return Stats.AdjustBy(PlayerRef, Name, AdjustBy)
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

int function PlayerSexCount(Actor ActorRef)
	return Stats.PlayerSexCount(ActorRef)
endFunction

bool function HadPlayerSex(Actor ActorRef)
	return Stats.HadPlayerSex(ActorRef)
endFunction

Actor function MostUsedPlayerSexPartner()
	return Stats.MostUsedPlayerSexPartner()
endFunction

Actor function LastSexPartner(Actor ActorRef)
	return Stats.LastSexPartner(ActorRef)
endFunction
bool function HasHadSexTogether(Actor ActorRef1, Actor ActorRef2)
	return Stats.HasHadSexTogether(ActorRef1, ActorRef2)
endfunction

Actor function LastAggressor(Actor ActorRef)
	return Stats.LastAggressor(ActorRef)
endFunction
bool function WasVictimOf(Actor VictimRef, Actor AggressorRef)
	return Stats.WasVictimOf(VictimRef, AggressorRef)
endFunction

Actor function LastVictim(Actor ActorRef)
	return Stats.LastVictim(ActorRef)
endFunction
bool function WasAggressorTo(Actor AggressorRef, Actor VictimRef)
	return Stats.WasAggressorTo(AggressorRef, VictimRef)
endFunction

float function AdjustPurity(Actor ActorRef, float amount)
	return Stats.AdjustPurity(ActorRef, amount)
endFunction

function SetSexuality(Actor ActorRef, int amount)
	Stats.SetSkill(ActorRef, "Sexuality", PapyrusUtil.ClampInt(amount, 1, 100))
endFunction

function SetSexualityStraight(Actor ActorRef)
	Stats.SetSkill(ActorRef, "Sexuality", 100)
endFunction

function SetSexualityBisexual(Actor ActorRef)
	Stats.SetSkill(ActorRef, "Sexuality", 50)
endFunction

function SetSexualityGay(Actor ActorRef)
	Stats.SetSkill(ActorRef, "Sexuality", 1)
endFunction

int function GetSexuality(Actor ActorRef)
	return Stats.GetSexuality(ActorRef)
endFunction

string function GetSexualityTitle(Actor ActorRef)
	return Stats.GetSexualityTitle(ActorRef)
endFunction

string function GetSkillTitle(Actor ActorRef, string Skill)
	return Stats.GetSkillTitle(ActorRef, Skill)
endFunction

int function GetSkill(Actor ActorRef, string Skill)
	return Stats.GetSkill(ActorRef, Skill)
endFunction

int function GetSkillLevel(Actor ActorRef, string Skill)
	return Stats.GetSkillLevel(ActorRef, Skill)
endFunction

float function GetPurity(Actor ActorRef)
	return Stats.GetPurity(ActorRef)
endFunction

int function GetPurityLevel(Actor ActorRef)
	return Stats.GetPurityLevel(ActorRef)
endFunction

string function GetPurityTitle(Actor ActorRef)
	return Stats.GetPurityTitle(ActorRef)
endFunction

bool function IsPure(Actor ActorRef)
	return Stats.IsPure(ActorRef)
endFunction

; Impure replaced by Lewd, legacy support alias, do not use.
bool function IsImpure(Actor ActorRef)
	return Stats.IsLewd(ActorRef)
endFunction

bool function IsLewd(Actor ActorRef)
	return Stats.IsLewd(ActorRef)
endFunction

bool function IsStraight(Actor ActorRef)
	return Stats.IsStraight(ActorRef)
endFunction

bool function IsBisexual(Actor ActorRef)
	return Stats.IsBisexual(ActorRef)
endFunction

bool function IsGay(Actor ActorRef)
	return Stats.IsGay(ActorRef)
endFunction

int function SexCount(Actor ActorRef)
	return Stats.SexCount(ActorRef)
endFunction

bool function HadSex(Actor ActorRef)
	return Stats.HadSex(ActorRef)
endFunction

; Last sex - Game time - float days
float function LastSexGameTime(Actor ActorRef)
	return Stats.LastSexGameTime(ActorRef)
endFunction

float function DaysSinceLastSex(Actor ActorRef)
	return Stats.DaysSinceLastSex(ActorRef)
endFunction

float function HoursSinceLastSex(Actor ActorRef)
	return Stats.HoursSinceLastSex(ActorRef)
endFunction

float function MinutesSinceLastSex(Actor ActorRef)
	return Stats.MinutesSinceLastSex(ActorRef)
endFunction

float function SecondsSinceLastSex(Actor ActorRef)
	return Stats.SecondsSinceLastSex(ActorRef)
endFunction

string function LastSexTimerString(Actor ActorRef)
	return Stats.LastSexTimerString(ActorRef)
endFunction

; Last sex - Real Time - float seconds
float function LastSexRealTime(Actor ActorRef)
	return Stats.LastSexRealTime(ActorRef)
endFunction

float function SecondsSinceLastSexRealTime(Actor ActorRef)
	return Stats.SecondsSinceLastSexRealTime(ActorRef)
endFunction

float function MinutesSinceLastSexRealTime(Actor ActorRef)
	return Stats.MinutesSinceLastSexRealTime(ActorRef)
endFunction

float function HoursSinceLastSexRealTime(Actor ActorRef)
	return Stats.HoursSinceLastSexRealTime(ActorRef)
endFunction

float function DaysSinceLastSexRealTime(Actor ActorRef)
	return Stats.DaysSinceLastSexRealTime(ActorRef)
endFunction

string function LastSexTimerStringRealTime(Actor ActorRef)
	return Stats.LastSexTimerStringRealTime(ActorRef)
endFunction

; Player shortcuts
float function AdjustPlayerPurity(float amount)
	return Stats.AdjustPurity(PlayerRef, amount)
endFunction

int function GetPlayerPurityLevel()
	return Stats.GetPurityLevel(PlayerRef)
endFunction

string function GetPlayerPurityTitle()
	return Stats.GetPurityTitle(PlayerRef)
endFunction

string function GetPlayerSexualityTitle()
	return Stats.GetSexualityTitle(PlayerRef)
endFunction

int function GetPlayerStatLevel(string Skill)
	return Stats.GetSkillLevel(PlayerRef, Skill)
endFunction

int function GetPlayerSkillLevel(string Skill)
	return Stats.GetSkillLevel(PlayerRef, Skill)
endFunction

string function GetPlayerSkillTitle(string Skill)
	return Stats.GetSkillTitle(PlayerRef, Skill)
endFunction

;#---------------------------#
;#    END STAT FUNCTIONS     #
;#---------------------------#


;#---------------------------#
;#  START FACTORY FUNCTIONS  #
;#---------------------------#

sslBaseAnimation function RegisterAnimation(string Registrar, Form CallbackForm = none, ReferenceAlias CallbackAlias = none)
	return AnimSlots.RegisterAnimation(Registrar, CallbackForm, CallbackAlias)
endFunction
sslBaseAnimation function RegisterCreatureAnimation(string Registrar, Form CallbackForm = none, ReferenceAlias CallbackAlias = none)
	return CreatureSlots.RegisterAnimation(Registrar, CallbackForm, CallbackAlias)
endFunction
sslBaseVoice function RegisterVoice(string Registrar, Form CallbackForm = none, ReferenceAlias CallbackAlias = none)
	return VoiceSlots.RegisterVoice(Registrar, CallbackForm, CallbackAlias)
endFunction
sslBaseExpression function RegisterExpression(string Registrar, Form CallbackForm = none, ReferenceAlias CallbackAlias = none)
	return ExpressionSlots.RegisterExpression(Registrar, CallbackForm, CallbackAlias)
endFunction

sslBaseAnimation function NewAnimationObject(string Token, Form Owner)
	return Factory.NewAnimation(Token, Owner)
endFunction
sslBaseVoice function NewVoiceObject(string Token, Form Owner)
	return Factory.NewVoice(Token, Owner)
endFunction
sslBaseExpression function NewExpressionObject(string Token, Form Owner)
	return Factory.NewExpression(Token, Owner)
endFunction

sslBaseAnimation function GetSetAnimationObject(string Token, string Callback, Form Owner)
	return Factory.GetSetAnimation(Token, Callback, Owner)
endFunction
sslBaseVoice function GetSetVoiceObject(string Token, string Callback, Form Owner)
	return Factory.GetSetVoice(Token, Callback, Owner)
endFunction
sslBaseExpression function GetSetExpressionObject(string Token, string Callback, Form Owner)
	return Factory.GetSetExpression(Token, Callback, Owner)
endFunction

sslBaseAnimation function NewAnimationObjectCopy(string Token, sslBaseAnimation CopyFrom, Form Owner)
	return Factory.NewAnimationCopy(Token, CopyFrom, Owner)
endFunction
sslBaseVoice function NewVoiceObjectCopy(string Token, sslBaseVoice CopyFrom, Form Owner)
	return Factory.NewVoiceCopy(Token, CopyFrom, Owner)
endFunction
sslBaseExpression function NewExpressionObjectCopy(string Token, sslBaseExpression CopyFrom, Form Owner)
	return Factory.NewExpressionCopy(Token, CopyFrom, Owner)
endFunction

sslBaseAnimation function GetAnimationObject(string Token)
	return Factory.GetAnimation(Token)
endFunction
sslBaseVoice function GetVoiceObject(string Token)
	return Factory.GetVoice(Token)
endFunction
sslBaseExpression function GetExpressionObject(string Token)
	return Factory.GetExpression(Token)
endFunction

sslBaseAnimation[] function GetOwnerAnimations(Form Owner)
	return Factory.GetOwnerAnimations(Owner)
endFunction
sslBaseVoice[] function GetOwnerVoices(Form Owner)
	return Factory.GetOwnerVoices(Owner)
endFunction
sslBaseExpression[] function GetOwnerExpressions(Form Owner)
	return Factory.GetOwnerExpressions(Owner)
endFunction

bool function HasAnimationObject(string Token)
	return Factory.HasAnimation(Token)
endFunction
bool function HasVoiceObject(string Token)
	return Factory.HasVoice(Token)
endFunction
bool function HasExpressionObject(string Token)
	return Factory.HasExpression(Token)
endFunction

bool function ReleaseAnimationObject(string Token)
	return Factory.ReleaseAnimation(Token)
endFunction
bool function ReleaseVoiceObject(string Token)
	return Factory.ReleaseVoice(Token)
endFunction
bool function ReleaseExpressionObject(string Token)
	return Factory.ReleaseExpression(Token)
endFunction

int function ReleaseOwnerAnimations(Form Owner)
	return Factory.ReleaseOwnerAnimations(Owner)
endFunction
int function ReleaseOwnerVoices(Form Owner)
	return Factory.ReleaseOwnerVoices(Owner)
endFunction
int function ReleaseOwnerExpressions(Form Owner)
	return Factory.ReleaseOwnerExpressions(Owner)
endFunction

sslBaseAnimation function MakeAnimationRegistered(string Token)
	return Factory.MakeAnimationRegistered(Token)
endFunction
sslBaseVoice function MakeVoiceRegistered(string Token)
	return Factory.MakeVoiceRegistered(Token)
endFunction
sslBaseExpression function MakeExpressionRegistered(string Token)
	return Factory.MakeExpressionRegistered(Token)
endFunction

bool function RemoveRegisteredAnimation(string Registrar)
	return AnimSlots.UnregisterAnimation(Registrar)
endFunction

bool function RemoveRegisteredCreatureAnimation(string Registrar)
	return CreatureSlots.UnregisterAnimation(Registrar)
endFunction

bool function RemoveRegisteredVoice(string Registrar)
	return VoiceSlots.UnregisterVoice(Registrar)
endFunction

bool function RemoveRegisteredExpression(string Registrar)
	return ExpressionSlots.UnregisterExpression(Registrar)
endFunction

;#---------------------------#
;#   END FACTORY FUNCTIONS   #
;#---------------------------#


;#---------------------------#
;#  START UTILITY FUNCTIONS  #
;#  For more see:            #
;#  - SexLabUtil.psc         #
;#  - sslUtility.psc         #
;#---------------------------#

Actor[] function MakeActorArray(Actor Actor1 = none, Actor Actor2 = none, Actor Actor3 = none, Actor Actor4 = none, Actor Actor5 = none)
	return sslUtility.MakeActorArray(Actor1, Actor2, Actor3, Actor4, Actor5)
endFunction

;#---------------------------#
;#   END UTILITY FUNCTIONS   #
;#---------------------------#



;#---------------------------#
;#   DEPRECATED FUNCTIONS    #
;#  AVOID USING IF POSSIBLE  #
;#---------------------------#

function ApplyCum(Actor ActorRef, int CumID)
	ActorLib.ApplyCum(ActorRef, CumID)
endFunction

form function StripWeapon(Actor ActorRef, bool RightHand = true)
	return none ; ActorLib.StripWeapon(ActorRef, RightHand)
endFunction

;#---------------------------#
;#                           #
;# END API RELATED FUNCTIONS #
;#                           #
;#---------------------------#





; ------------------------------------------------------- ;
; --- Intended for system use only - DO NOT USE       --- ;
; ------------------------------------------------------- ;

; Data
Actor property PlayerRef auto
Faction property AnimatingFaction auto hidden

; Function libraries
sslActorLibrary property ActorLib auto
sslThreadLibrary property ThreadLib auto
sslActorStats property Stats auto

; Object registeries
sslThreadSlots property ThreadSlots auto
sslAnimationSlots property AnimSlots auto
sslCreatureAnimationSlots property CreatureSlots auto
sslVoiceSlots property VoiceSlots auto
sslExpressionSlots property ExpressionSlots auto
sslObjectFactory property Factory auto

; Animation Threads
sslThreadController[] property Threads hidden
	sslThreadController[] function get()
		return ThreadSlots.Threads
	endFunction
endProperty

; Animation Sets
sslBaseAnimation[] property Animations hidden
	sslBaseAnimation[] function get()
		return AnimSlots.Animations
	endFunction
endProperty

; Creature animations
sslBaseAnimation[] property CreatureAnimations hidden
	sslBaseAnimation[] function get()
		return CreatureSlots.Animations
	endFunction
endProperty

; Voice Sets
sslBaseVoice[] property Voices hidden
	sslBaseVoice[] function get()
		return VoiceSlots.Voices
	endFunction
endProperty

; Expression Sets
sslBaseExpression[] property Expressions hidden
	sslBaseExpression[] function get()
		return ExpressionSlots.Expressions
	endFunction
endProperty

function Setup()
	; Reset function Libraries - SexLabQuestFramework
	Form SexLabQuestFramework = Game.GetFormFromFile(0xD62, "SexLab.esm")
	if SexLabQuestFramework
		Config      = SexLabQuestFramework as sslSystemConfig
		ThreadLib   = SexLabQuestFramework as sslThreadLibrary
		ThreadSlots = SexLabQuestFramework as sslThreadSlots
		ActorLib    = SexLabQuestFramework as sslActorLibrary
		Stats       = SexLabQuestFramework as sslActorStats
	endIf
	; Reset secondary object registry - SexLabQuestRegistry
	Form SexLabQuestRegistry = Game.GetFormFromFile(0x664FB, "SexLab.esm")
	if SexLabQuestRegistry
		CreatureSlots   = SexLabQuestRegistry as sslCreatureAnimationSlots
		ExpressionSlots = SexLabQuestRegistry as sslExpressionSlots
		VoiceSlots      = SexLabQuestRegistry as sslVoiceSlots
	endIf
	; Reset animation registry - SexLabQuestAnimations
	Form SexLabQuestAnimations = Game.GetFormFromFile(0x639DF, "SexLab.esm")
	if SexLabQuestAnimations
		AnimSlots = SexLabQuestAnimations as sslAnimationSlots
	endIf
	; Reset phantom object registry - SexLabQuestRegistry
	Form SexLabObjectFactory = Game.GetFormFromFile(0x78818, "SexLab.esm")
	if SexLabObjectFactory
		Factory = SexLabObjectFactory as sslObjectFactory
	endIf
	; Sync Data
	PlayerRef        = Game.GetPlayer()
	AnimatingFaction = Config.AnimatingFaction
endFunction

function Log(string Log, string Type = "NOTICE")
	Log = Type+": "+Log
	if Config.InDebugMode
		SexLabUtil.PrintConsole(Log)
	endIf
	if Type == "FATAL"
		Debug.TraceStack("SEXLAB - "+Log)
	else
		Debug.Trace("SEXLAB - "+Log)
	endIf
endFunction

auto state Disabled
	sslThreadModel function NewThread(float TimeOut = 30.0)
		Log("NewThread() - Failed to make new thread model; system is currently disabled or not installed", "FATAL")
		return none
	endFunction
	int function StartSex(Actor[] Positions, sslBaseAnimation[] Anims, Actor Victim = none, ObjectReference CenterOn = none, bool AllowBed = true, string Hook = "")
		Log("StartSex() - Failed to make new thread model; system is currently disabled or not installed", "FATAL")
		return -1
	endFunction
	sslThreadController function QuickStart(Actor Actor1, Actor Actor2 = none, Actor Actor3 = none, Actor Actor4 = none, Actor Actor5 = none, Actor Victim = none, string Hook = "", string AnimationTags = "")
		Log("QuestStart() - Failed to make new thread model; system is currently disabled or not installed", "FATAL")
		return none
	endFunction
	event OnBeginState()
		Log("SexLabFramework - Disabled")
		ModEvent.Send(ModEvent.Create("SexLabDisabled"))
	endEvent
endState

state Enabled
	event OnBeginState()
		Log("SexLabFramework - Enabled")
		ModEvent.Send(ModEvent.Create("SexLabEnabled"))
	endEvent
endState
