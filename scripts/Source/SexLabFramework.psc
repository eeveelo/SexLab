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

; If extending this script, fill this property with the name of your mod.
string property ModName auto

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
	sslThreadModel Thread = NewThread()
	if !Thread
		Log("StartSex() - Failed to claim an available thread")
		return -1
	; Add actors list to thread
	elseIf !Thread.AddActors(Positions, Victim)
		Log("StartSex() - Failed to add some actors to thread")
		return -1
	endIf
	; Configure our thread with passed arguments
	Thread.SetAnimations(Anims)
	Thread.CenterOnObject(CenterOn)
	Thread.DisableBedUse(!AllowBed)
	Thread.SetHook(Hook)
	; Start the animation
	if Thread.StartThread()
		return Thread.tid
	endIf
	return -1
endFunction

sslThreadController function QuickStart(Actor Actor1, Actor Actor2 = none, Actor Actor3 = none, Actor Actor4 = none, Actor Actor5 = none, Actor Victim = none, string Hook = "", string AnimationTags = "")
	Actor[] Positions = SexLabUtil.MakeActorArray(Actor1, Actor2, Actor3, Actor4, Actor5)
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
* @return int - 0 for male, 1 for female, 2 for creature, 3 for female creature if creature genders are enabled and they are female - otherwise female creatures will default to 2 along with males.
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
* Searches within a given area for a SexLab valid creature
* 
* @param  string RaceKey - The SexLab RaceKey to find a creature whose race belongs to
* @param  ObjectReference CenterRef - The object to use as the center point in the search. 
* @param  float Radius - The distance from the center point to search.
* @param  int FindGender - The desired gender id to look for, 2 for male/no gender, 3 for female.
* @param  Actor IgnoreRef1/2/3/4 - An actor you know for certain you do not want returned by this function.
* @return Actor - A valid actor found, if any. Returns none if no valid actor found.
**/;
Actor function FindAvailableCreature(string RaceKey, ObjectReference CenterRef, float Radius = 5000.0, int FindGender = 2, Actor IgnoreRef1 = none, Actor IgnoreRef2 = none, Actor IgnoreRef3 = none, Actor IgnoreRef4 = none)
	return ThreadLib.FindAvailableActor(CenterRef, Radius, FindGender, IgnoreRef1, IgnoreRef2, IgnoreRef3, IgnoreRef4, RaceKey)
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
* @param  bool Vaginal/Oral/Anal - Each location set to TRUE will have it's effect added or stacked.
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
* Checks how many stacks of cum an actor currently has in the given areas
* 
* @param  Actor ActorRef - The actor to check for cum effectshader stacks
* @param  bool Vaginal/Oral/Anal - Each location set to TRUE add to the returned count of stacks.
**/;
int function CountCum(Actor ActorRef, bool Vaginal = true, bool Oral = true, bool Anal = true)
	return ActorLib.CountCum(ActorRef, Vaginal, Oral, Anal)
endFunction
int function CountCumVaginal(Actor ActorRef)
	return ActorLib.CountCum(ActorRef, true, false, false)
endFunction
int function CountCumOral(Actor ActorRef)
	return ActorLib.CountCum(ActorRef, false, true, false)
endFunction
int function CountCumAnal(Actor ActorRef)
	return ActorLib.CountCum(ActorRef, false, false, true)
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
* @param  bool RemoveFromAudience - Set to FALSE to only check if they are present and not remove them from the audience.
* @return bool - TRUE if ActorRef was/is present in a bard audience
**/;
bool function CheckBardAudience(Actor ActorRef, bool RemoveFromAudience = true)
	return Config.CheckBardAudience(ActorRef, RemoveFromAudience)
endFunction

;#------------------------------#
;#     END ACTOR FUNCTIONS      #
;#------------------------------#


;#------------------------------#
;#    BEGIN THREAD FUNCTIONS    #
;#------------------------------#

;/**
* Searches for and returns an a bed within a given radius from a provided center. 
* 
* @param  ObjectReference CenterRef - An object/actor to use as the center point of your search.
* @param  float Radius - The radius distance to search within the given CenterRef for a bed. 
* @param  bool IgnoreUsed - When searching for beds, attempt to check if any actors are currently using the bed and ignore it if so. 
* @param  ObjectReference IgnoreRef1/IgnoreRef2 - A bed object that might be within the search radius, but you know you don't want.
* @return ObjectReference - The found valid bed within the radius. NONE if no bed found. 
**/;
ObjectReference function FindBed(ObjectReference CenterRef, float Radius = 1000.0, bool IgnoreUsed = true, ObjectReference IgnoreRef1 = none, ObjectReference IgnoreRef2 = none)
	return ThreadLib.FindBed(CenterRef, Radius, IgnoreUsed, IgnoreRef1, IgnoreRef2)
endFunction

;/**
* Check if a given bed is considered a bed roll.
* 
* @param  ObjectReference BedRef - The bed object you want to check.
* @return bool - TRUE if BedRef is considered a bed roll.
**/;
bool function IsBedRoll(ObjectReference BedRef)
	return ThreadLib.IsBedRoll(BedRef)
endFunction

;/**
* Check if a given bed is considered a 2 person bed.
* 
* @param  ObjectReference BedRef - The bed object you want to check.
* @return bool - TRUE if BedRef is considered a 2 person bed.
**/;
bool function IsDoubleBed(ObjectReference BedRef)
	return ThreadLib.IsDoubleBed(BedRef)
endFunction

;/**
* Check if a given bed is considered a single bed.
* 
* @param  ObjectReference BedRef - The bed object you want to check.
* @return bool - TRUE if BedRef is considered a single bed.
**/;
bool function IsSingleBed(ObjectReference BedRef)
	return ThreadLib.IsSingleBed(BedRef)
endFunction

;/**
* Check if a given bed is appears to be in use by another actor.
* 
* @param  ObjectReference BedRef - The bed object you want to check.
* @return bool - TRUE if BedRef is considered in use.
**/;
bool function IsBedAvailable(ObjectReference BedRef)
	return ThreadLib.IsBedAvailable(BedRef)
endFunction

;/**
* Gets the thread associated with the given thread id number. Mostly used for getting the thread associated with a hook event.
* 
* @param  int tid - The thread id number of the thread you wish to retrieve. Should be a number between 0-14
* @return sslThreadController - The thread that the given tid belongs to.
**/;
sslThreadController function GetController(int tid)
	return ThreadSlots.GetController(tid)
endFunction

;/**
* Finds any thread controller an actor is currently associated with and returns it's thread id number.
*
* @param  Actor ActorRef - The actor to search for.
* @return sslThreadController - The thread actor is currently in. NONE if actor couldn't be found.
**/;
int function FindActorController(Actor ActorRef)
	return ThreadSlots.FindActorController(ActorRef)
endFunction

;/**
* Finds any thread controller the player is currently associated with and returns it's thread id number
* @return sslThreadController - The thread actor is currently in. NONE if actor couldn't be found.
**/;
int function FindPlayerController()
	return ThreadSlots.FindActorController(PlayerRef)
endFunction

;/**
* Finds any thread controller an actor is currently associated with and returns it.
* 
* @param  Actor ActorRef - The actor to search for.
* @return sslThreadController - The thread the actor is currently part of. NONE if actor couldn't be found.
**/;
sslThreadController function GetActorController(Actor ActorRef)
	return ThreadSlots.GetActorController(ActorRef)
endFunction

;/**
* Finds any thread controller the player is currently associated with and returns it.
* 
* @return sslThreadController - The thread the player is currently part of. NONE if player couldn't be found.
**/;
sslThreadController function GetPlayerController()
	return ThreadSlots.GetActorController(PlayerRef)
endFunction

;#---------------------------#
;#   END THREAD FUNCTIONS    #
;#---------------------------#

;#------------------------------#
;#  BEGIN TRACKING FUNCTIONS    #
;#------------------------------#

;/**
*
* TRACKING USAGE INSTRUCTIONS:
* Any actor tracked either by specifically being marked for tracking, or belong to a faction that is tracked, will receive special mod events.
* The default tracked event types are Added, Start, End, Orgasm. Which correspond with an actor being added to a thread, starting animation, ending animation, and having an orgasm.
* Once you register a callback for an actor or faction, the mod event sent will be "<custom callback>_<event type>"
* so if you TrackActor(ActorRef, "DoStuff") and you want to run a callback whenever ActorRef finishes an animation, then you would RegisterForMyEvent("DoStuff_End", "MyEventFunction")
* The received event should then be "event(Form FormRef, int tid)" the FormRef is the actor who triggered it as a form you can cast, and the tid is the related thread id usable with GetController(tid)
*
* NOTE: The player has a default tracked event associated with them using the callback "PlayerTrack"
**/;

;/**
* Associate a specific actor with a unique callback mod event that is sent whenever the actor performs certain actions within SexLab animations.
* 
* @param  Actor ActorRef - The actor you want to receive tracked events for.
* @param  string Callback - The unique callback name you want to associate with this actor.
**/;
function TrackActor(Actor ActorRef, string Callback)
	ThreadLib.TrackActor(ActorRef, Callback)
endFunction

;/**
* Remove an associated callback from an actor.
* 
* @param  Actor ActorRef - The actor you want to remove the tracked events for.
* @param  string Callback - The unique callback event you want to disable.
**/;
function UntrackActor(Actor ActorRef, string Callback)
	ThreadLib.UntrackActor(ActorRef, Callback)
endFunction

;/**
* Associate a specific actor with a unique callback mod event that is sent whenever the actor performs certain actions within SexLab animations.
* 
* @param  Faction FactionRef - The faction whose members you want to receive tracked events for.
* @param  string Callback - The unique callback name you want to associate with this faction's actors.
**/;
function TrackFaction(Faction FactionRef, string Callback)
	ThreadLib.TrackFaction(FactionRef, Callback)
endFunction

;/**
* Remove an associated callback from a faction.
* 
* @param  Faction FactionRef - The faction you want to remove the tracked events for.
* @param  string Callback - The unique callback event you want to disable.
**/;
function UntrackFaction(Faction FactionRef, string Callback)
	ThreadLib.UntrackFaction(FactionRef, Callback)
endFunction

;/**
* Send a custom tracked event for an actor, if they have any associated callbacks themselves or belong to a tracked factions.
* 
* @param  Actor ActorRef - The actor you want to send a custom tracked event for.
* @param  string Hook - The event type you want to send, used in place of the default Added, Start, End, Orgasm hook types as "<Hook>_<Callback>"
* @param  int id - An optional id number to send with your custom tracked event. This is normally the associated animation thread id number, but can be anything you want.
**/;
function SendTrackedEvent(Actor ActorRef, string Hook, int id = -1)
	ThreadLib.SendTrackedEvent(ActorRef, Hook, id)
endFunction

;/**
* Check if a given actor will receive any tracked events. Will always return TRUE if used on the player, due to the built in "PlayerTrack" callback.
* 
* @param  Actor ActorRef - The actor to check.
* @return bool - TRUE if the actor has any associated callbacks, or belongs to any tracked factions.
**/;
bool function IsActorTracked(Actor ActorRef)
	return ThreadLib.IsActorTracked(ActorRef)
endFunction

;#---------------------------#
;#   END THREAD FUNCTIONS    #
;#---------------------------#

;#---------------------------#
;# BEGIN ANIMATION FUNCTIONS #
;#---------------------------#

;/**
* Get an array of animations that have a specified set of tags.
* 
* @param  int ActorCount - The total number of actors, between 1-5 the returned animations should be intended for.
* @param  string Tags - A comma separated list of animation tags you want to use as a filter for the returned animations.
* @param  string TagSuppress - A comma separated list of animation tags you DO NOT want present on any of the returned animations.
* @param  bool RequireAll - If TRUE, all tags in the provided "string Tags" list must be present in an animation to be returned. When FALSE only one tag in the list is needed.
* @return sslBaseAnimation[] - An array of animations that fit the provided search arguments.
**/;
sslBaseAnimation[] function GetAnimationsByTags(int ActorCount, string Tags, string TagSuppress = "", bool RequireAll = true)
	return AnimSlots.GetByTags(ActorCount, Tags, TagSuppress, RequireAll)
endFunction

;/**
* Get an array of animations that fit a specified set of parameters.
*
* @param  int ActorCount - The total number of actors, between 1-5 the returned animations should be intended for.
* @param  int Males - The total number of males the returned animations should be intended for. Set to -1 for any amount.
* @param  int Females - The total number of females the returned animations should be intended for. Set to -1 for any amount.
* @param  int StageCount - The total number of stages the returned animations should contain. Set to -1 for any amount.
* @param  bool Aggressive - TRUE if you want the animations returned to include ones tagged as aggressive.
* @param  bool Sexual - No longer used.
* @return sslBaseAnimation[] - An array of animations that fit the provided search arguments.
**/;
sslBaseAnimation[] function GetAnimationsByType(int ActorCount, int Males = -1, int Females = -1, int StageCount = -1, bool Aggressive = false, bool Sexual = true)
	return AnimSlots.GetByType(ActorCount, Males, Females, StageCount, Aggressive, Sexual)
endFunction

;/**
* Get an array of animations that fit the given array of actors using SexLab's default selection criteria.
*  
* @param  Actor[] Positions - An array of 1 to 5 actors you intend to use the resulting animations with.
* @param  int Limit - Limits the number of animations returned to this amount. Searches that result in more than this will randomize the results to fit within the limit.
* @param  bool Aggressive - TRUE if you want the animations returned to include ones tagged as aggressive.
* @return sslBaseAnimation[] - An array of animations that fit the provided search arguments.
**/;
sslBaseAnimation[] function PickAnimationsByActors(Actor[] Positions, int Limit = 64, bool Aggressive = false)
	return AnimSlots.PickByActors(Positions, limit, aggressive)
endFunction

;/**
* Get an array of animations that fit the given number of males and females using SexLab's default selection criteria.
*  
* @param  int Males - The total number of males the returned animations should be intended for. Set to -1 for any amount.
* @param  int Females - The total number of females the returned animations should be intended for. Set to -1 for any amount.
* @param  bool IsAggressive - TRUE if the animations to be played are considered aggressive.
* @param  bool UsingBed - TRUE if the animation is going to be played on a bed, which will filter out standing animations and allow BedOnly tagged animations.
* @param  bool RestrictAggressive - If TRUE, only return aggressive animations if IsAggressive=true and none if IsAggressive=false.
* @return sslBaseAnimation[] - An array of animations that fit the provided search arguments.
**/;
sslBaseAnimation[] function GetAnimationsByDefault(int Males, int Females, bool IsAggressive = false, bool UsingBed = false, bool RestrictAggressive = true)
	return AnimSlots.GetByDefault(Males, Females, IsAggressive, UsingBed, RestrictAggressive)
endFunction

;/**
* Get a single animation by name. Ignores if a user has the animation enabled or not.
* 
* @param  string FindName - The name of an animation as seen in the SexLab MCM.
* @return sslBaseAnimation - The animation whose name matches, if found.
**/;
sslBaseAnimation function GetAnimationByName(string FindName)
	return AnimSlots.GetByName(FindName)
endFunction

;/**
* Get a single animation by it's unique registry name. Ignores if a user has the animation enabled or not.
* 
* @param  string Registry - The unique registry name of the animation. (string property Registry on any animation)
* @return sslBaseAnimation - The animation whose registry matches, if found.
**/;
sslBaseAnimation function GetAnimationByRegistry(string Registry)
	return AnimSlots.GetByRegistrar(Registry)
endFunction

;/**
* Find the registration slot number that an animation currently occupies.
* 
* @param  string FindName - The name of an animation as seen in the SexLab MCM.
* @return int - The registration slot number for the animation.
**/;
int function FindAnimationByName(string FindName)
	return AnimSlots.FindByName(FindName)
endFunction

;/**
* Get the number of registered animations.
* 
* @param  bool IgnoreDisabled - If TRUE, only count animations that are enabled in the SexLab MCM, otherwise count all.
* @return int - The total number of animations.
**/;
int function GetAnimationCount(bool IgnoreDisabled = true)
	return AnimSlots.GetCount(IgnoreDisabled)
endFunction

;/**
* Create a gender tag from a list of actors, in order: F for female, M for male, C for creatures
* 
* @param  Actor[] Positions - A list of actors to create a tag for
* @return string - A usable tag for filtering animations by tag and gender. If given an array with 1 male and 1 female, the return will be "FM"
**/;
string function MakeAnimationGenderTag(Actor[] Positions)
	return ActorLib.MakeGenderTag(Positions)
endFunction

;/**
* Create a gender tag from specified amount of genders, in order: F for female, M for male, C for creatures
* @param  int Females - The number of females (F) for the gender tag.
* @param  int Males - The number of males (M) for the gender tag.
* @param  int Creatures - The number of creatures (C) for the gender tag.
* @return string - A usable tag for filtering animations by tag and gender. If given an array with 2 male and 1 female, the return will be "FMM"
**/;
string function GetGenderTag(int Females = 0, int Males = 0, int Creatures = 0)
	return ActorLib.GetGenderTag(Females, Males, Creatures)
endFunction

;/**
* Combine 2 separate lists of animations into a single list, removing any duplicates between the two. (Works with both regular and creature animations.)
* 
* @param  sslBaseAnimation[] List1 - The first array of animations to combine.
* @param  sslBaseAnimation[] List2 - The second array of animations to combine.
* @return sslBaseAnimation[] - All the animations from List1 and List2, with any duplicates between them removed.
**/;
sslBaseAnimation[] function MergeAnimationLists(sslBaseAnimation[] List1, sslBaseAnimation[] List2)
	return sslUtility.MergeAnimationLists(List1, List2)
endFunction

;/**
* Removes any animations from an existing list that contain one of the provided animation tags. (Works with both regular and creature animations.)
* 
* @param  sslBaseAnimation[] Anims - A list of animations you want to filter certain tags out of.
* @param  string Tags - A comma separated list of animation tags to check Anim's element for, if any of the tags given are present, the animation won't be included in the return.
* @return sslBaseAnimation[] - All the animations from Anims that did not have any of the provided tags.
**/;
sslBaseAnimation[] function RemoveTagged(sslBaseAnimation[] Anims, string Tags)
	return sslUtility.RemoveTaggedAnimations(Anims, PapyrusUtil.StringSplit(Tags))
endFunction

;/**
* Counts the number of animations in the given array that contain one of provided animation tags. (Works with both regular and creature animations.)
* 
* @param  sslBaseAnimation[] Anims - A list of animations you want to check for tags on.
* @param  string Tags - A comma separated list of animation tags.
* @return int - The number of animations from Anims that contain one of the tags provided.
**/;
int function CountTag(sslBaseAnimation[] Anims, string Tags)
	return AnimSlots.CountTag(Anims, Tags)
endFunction

;/**
* Get a list of all unique tags contained in a set of registerd animations.
* see also: GetAllCreatureAnimationTags, GetAllBothAnimationTags, GetAllAnimationTagsInArray
* 
* @param  int ActorCount - The number of actors the animations checked should be intended for. -1 to check all animations regardless of the number of positions.
* @param  bool IgnoreDisabled - Whether to ignore tags from animations that have been disabled by the user or not. Default value of TRUE will ignore disabled animations.
* @return string[] - An alphabetically sorted string array of all unique tags found in the matching animations. 
**/;
string[] function GetAllAnimationTags(int ActorCount = -1, bool IgnoreDisabled = true)
	return AnimSlots.GetAllTags(ActorCount, IgnoreDisabled)
endFunction


;/**
* Get a list of all unique tags contained in an arbitrary list of provided animations. alias to sslUtility.
* see also: GetAllAnimationTags, GetAllCreatureAnimationTags, GetAllBothAnimationTags
* 
* @param  sslBaseAnimation[] - The array of animation objects you want a list of tags for.
* @return string[] - An alphabetically sorted string array of all unique tags found in the provided animations. 
**/;
string[] function GetAllAnimationTagsInArray(sslBaseAnimation[] List)
	return sslUtility.GetAllAnimationTagsInArray(List)
endFunction

;#---------------------------#
;#  END ANIMATION FUNCTIONS  #
;#---------------------------#

;#---------------------------#
;# START CREATURES FUNCTIONS #
;#---------------------------#

;/**
* Get an array of creature animations for a provided creature's race.
*  
* @param  int ActorCount - The total number of actors, between 1-5 the returned animations should be intended for.
* @param  Race RaceRef - The race the returned animations should be usable by.
* @return sslBaseAnimation[] - An array of animations that fit the provided search arguments.
**/;
sslBaseAnimation[] function GetCreatureAnimationsByRace(int ActorCount, Race RaceRef)
	return CreatureSlots.GetByRace(ActorCount, RaceRef)
endFunction

;/**
* Get an array of creature animations that require a specific number of actors and race type.
* 
* @param  int ActorCount - The total number of actors, between 1-5 the returned animations should be intended for.
* @param  string RaceKey - The creature race sexlab identifier used to identify animations meant for this race.
* @return sslBaseAnimation[] - An array of animations that fit the provided search arguments.
**/;
sslBaseAnimation[] function GetCreatureAnimationsByRaceKey(int ActorCount, string RaceKey)
	return CreatureSlots.GetByRaceKey(ActorCount, RaceKey)
endFunction

;/**
* Get an array of creature animations for a specific number of actors, creature race, and optionally gender.
* 
* @param  int ActorCount - The total number of actors, between 1-5 the returned animations should be intended for.
* @param  Race RaceRef - The race the returned animations should be usable by.
* @param  int MaleCreatures - The number of male creatures the animation should use. Ignored if user does not have creature genders enabled or ForceUse is set to TRUE.
* @param  int FemaleCreatures - The number of female creatures the animation should use. Ignored if user does not have creature genders enabled or ForceUse is set to TRUE.
* @param  bool ForceUse - If left as the default value of FALSE, the MaleCreatures and FemaleCreatures argument will be ignored when creature genders aren't enabled by user.
* @return sslBaseAnimation[] - An array of animations that fit the provided search arguments.
**/;
sslBaseAnimation[] function GetCreatureAnimationsByRaceGenders(int ActorCount, Race RaceRef, int MaleCreatures = 0, int FemaleCreatures = 0, bool ForceUse = false)
	return CreatureSlots.GetByRaceGenders(ActorCount, RaceRef, MaleCreatures, FemaleCreatures, ForceUse)
endFunction

;/**
* Get an array of creature animations that have a specified set of tags AND are valid for a specific creatures race.
*
* @param  int ActorCount - The total number of actors, between 1-5 the returned animations should be intended for.
* @param  Race RaceRef - The race the returned animations should be usable by.
* @param  string Tags - A comma separated list of animation tags you want to use as a filter for the returned animations.
* @param  string TagSuppress - A comma separated list of animation tags you DO NOT want present on any of the returned animations.
* @param  bool RequireAll - If TRUE, all tags in the provided "string Tags" list must be present in an animation to be returned. When FALSE only one tag in the list is needed.
* @return sslBaseAnimation[] - An array of animations that fit the provided search arguments.
**/;
sslBaseAnimation[] function GetCreatureAnimationsByRaceTags(int ActorCount, Race RaceRef, string Tags, string TagSuppress = "", bool RequireAll = true)
	return CreatureSlots.GetByRaceTags(ActorCount, RaceRef, Tags, TagSuppress, RequireAll)
endFunction

;/**
** Get an array of creature animations that have a specified set of tags AND are valid for a specific creature race type.
*
* @param  int ActorCount - The total number of actors, between 1-5 the returned animations should be intended for.
* @param  string RaceKey - The creature race sexlab identifier used to identify animations meant for this race.
* @param  string Tags - A comma separated list of animation tags you want to use as a filter for the returned animations.
* @param  string TagSuppress - A comma separated list of animation tags you DO NOT want present on any of the returned animations.
* @param  bool RequireAll - If TRUE, all tags in the provided "string Tags" list must be present in an animation to be returned. When FALSE only one tag in the list is needed.4\
* @return sslBaseAnimation[] - An array of animations that fit the provided search arguments.
**/;
sslBaseAnimation[] function GetCreatureAnimationsByRaceKeyTags(int ActorCount, string RaceKey, string Tags, string TagSuppress = "", bool RequireAll = true)
	return CreatureSlots.GetByRaceKeyTags(ActorCount, RaceKey, Tags, TagSuppress, RequireAll)
endFunction

;/**
* Get an array of creature animations that have a specified set of tags.
* This will be a mix of different creature type animations, you likely want to use GetCreatureAnimationsByRaceTags() or GetCreatureAnimationsByRaceKeyTags() instead.
* 
* @param  int ActorCount - The total number of actors, between 1-5 the returned animations should be intended for.
* @param  string Tags - A comma separated list of animation tags you want to use as a filter for the returned animations.
* @param  string TagSuppress - A comma separated list of animation tags you DO NOT want present on any of the returned animations.
* @param  bool RequireAll - If TRUE, all tags in the provided "string Tags" list must be present in an animation to be returned. When FALSE only one tag in the list is needed.
* @return sslBaseAnimation[] - An array of animations that fit the provided search arguments.
**/;
sslBaseAnimation[] function GetCreatureAnimationsByTags(int ActorCount, string Tags, string TagSuppress = "", bool RequireAll = true)
	return CreatureSlots.GetByTags(ActorCount, Tags, TagSuppress, RequireAll)
endFunction

;/**
** Get a single creature animation by name. Ignores if a user has the animation enabled or not.
*
* @param  string FindName - The name of an animation as seen in the SexLab MCM.
* @return sslBaseAnimation - The creature animation whose name matches, if found.
**/;
sslBaseAnimation function GetCreatureAnimationByName(string FindName)
	return CreatureSlots.GetByName(FindName)
endFunction

;/**
* Get a single creature animation by it's unique registry name. Ignores if a user has the animation enabled or not.
*
* @param  string Registry - The unique registry name of the animation. (string property Registry on any animation)
* @return sslBaseAnimation - The creature animation whose registry matches, if found.
**/;
sslBaseAnimation function GetCreatureAnimationByRegistry(string Registry)
	return CreatureSlots.GetByRegistrar(Registry)
endFunction

;/**
* Checks if a given creature race has any usable animations currently registered.
* 
* @param  Race CreatureRace - The race of the creature you want to check for valid creature animations to use.
* @param  int Gender - Any optional parameter to have it check if a specific creature gender has an animation. -1 (default) to ignore, 2 for Male, 3 for Female.
* @return bool - 
**/;
bool function HasCreatureAnimation(Race CreatureRace, int Gender = -1)
	return CreatureSlots.HasAnimation(CreatureRace, Gender)
endFunction

;/**
* Checks if a given creature race is able to animate via sexlab at all.
* 
* @param  Race CreatureRace - The race to check if allowed to animate.
* @return bool - TRUE if the creature has a valid enabled animation AND that creature animations are enabled.
**/;
bool function AllowedCreature(Race CreatureRace)
	return CreatureSlots.AllowedCreature(CreatureRace)
endFunction

;/**
* Checks if two given creature's race continue a shared RaceKey, and thus likely a shared animation as well.
* 
* @param  Race CreatureRace - A creature race to check for a matching RaceKey with the other.
* @param  Race CreatureRace2 - The other creature race to check for a matching RaceKey with the previous one.
* @return bool - TRUE if they do have a shared RaceKey.
**/;
bool function AllowedCreatureCombination(Race CreatureRace, Race CreatureRace2)
	return CreatureSlots.AllowedCreatureCombination(CreatureRace, CreatureRace2)
endFunction

;/**
* Get a list of all unique tags contained in a set of registered creature animations.
* see also: GetAllAnimationTags, GetAllBothAnimationTags, GetAllAnimationTagsInArray
* 
* @param  int ActorCount - The number of actors the animations checked should be intended for. -1 to check all animations regardless of the number of positions.
* @param  bool IgnoreDisabled - Whether to ignore tags from animations that have been disabled by the user or not. Default value of TRUE will ignore disabled animations.
* @return string[] - An alphabetically sorted string array of all unique tags found in the matching animations. 
**/;
string[] function GetAllCreatureAnimationTags(int ActorCount = -1, bool IgnoreDisabled = true)
	return CreatureSlots.GetAllTags(ActorCount, IgnoreDisabled)
endFunction

;/**
* Combines the results of both GetAllAnimationTags() and GetAllCreatureAnimationTags(). 
* see also: GetAllAnimationTags, GetAllCreatureAnimationTags, GetAllAnimationTagsInArray
* 
* @param  int ActorCount - The number of actors the animations checked should be intended for. -1 to check all animations regardless of the number of positions.
* @param  bool IgnoreDisabled - Whether to ignore tags from animations that have been disabled by the user or not. Default value of TRUE will ignore disabled animations.
* @return string[] - An alphabetically sorted string array of all unique tags found in the matching animations. 
**/;
string[] function GetAllBothAnimationTags(int ActorCount = -1, bool IgnoreDisabled = true)
	string[] Output = PapyrusUtil.MergeStringArray(AnimSlots.GetAllTags(ActorCount, IgnoreDisabled), CreatureSlots.GetAllTags(ActorCount, IgnoreDisabled))
	PapyrusUtil.SortStringArray(Output)
	return Output
endFunction


;#---------------------------#
;#  END CREATURES FUNCTIONS  #
;#---------------------------#

;#---------------------------#
;#   BEGIN VOICE FUNCTIONS   #
;#---------------------------#

;/**
* Returns an actors saved voice object if the user has the "reuse voices" option enabled, otherwise random for gender.
* 
* @param  Actor ActorRef - The actor to pick a voice for.
* @return sslBaseVoice - A suitable voice object for the actor to use.
**/;
sslBaseVoice function PickVoice(Actor ActorRef)
	return VoiceSlots.PickVoice(ActorRef)
endFunction
sslBaseVoice function GetVoice(Actor ActorRef) ; Alias of PickVoice()
	return VoiceSlots.PickVoice(ActorRef)
endFunction

;/**
* Saves a given voice to an actor. Once saved the function GetSavedVoice() will always return their saved voice,
* PickVoice() / GetVoice() will also return this voice for the actor if the user has the "reuse voices" option enabled 
* 
* @param  Actor ActorRef - The actor to pick a voice for.
* @return sslBaseVoice - A suitable voice object for the actor to use. Does not have to be a registered SexLab voice object.
**/;
function SaveVoice(Actor ActorRef, sslBaseVoice Saving)
	VoiceSlots.SaveVoice(ActorRef, Saving)
endFunction

;/**
* Removes any saved voice on an actor.
* 
* @param  Actor ActorRef - The actor you want to remove a saved voice from.
**/;
function ForgetVoice(Actor ActorRef)
	VoiceSlots.ForgetVoice(ActorRef)
endFunction

;/**
* Returns an actors saved voice object, if they have one saved.
* 
* @param  Actor ActorRef - The actor get the saved voice for.
* @return sslBaseVoice - The actors saved voice object if one exists, otherwise NONE.
**/;
sslBaseVoice function GetSavedVoice(Actor ActorRef)
	return VoiceSlots.GetSaved(ActorRef)
endFunction

;/**
* Checks if the given Actor has a custom, non-registered SexLab voice.
* 
* @param  Actor ActorRef - The actor to check.
* @return sslBaseVoice - A suitable voice object for the actor to use.
**/;
bool function HasCustomVoice(Actor ActorRef)
	return VoiceSlots.HasCustomVoice(ActorRef)
endFunction

;/**
* Get a random voice for a given gender.
* 
* @param  int Gender - The gender number to get a random voice for. 0 = male 1 = female.
* @return sslBaseVoice - A suitable voice object for the actor to use.
**/;
sslBaseVoice function GetVoiceByGender(int Gender)
	return VoiceSlots.PickGender(Gender)
endFunction

;/**
* Get a single voice object by name. Ignores if a user has the voice enabled or not.
* 
* @param  string FindName - The name of an voice object as seen in the SexLab MCM.
* @return sslBaseVoice - The voice object whose name matches, if found.
**/;
sslBaseVoice function GetVoiceByName(string FindName)
	return VoiceSlots.GetByName(FindName)
endFunction

;/**
* Find the registration slot number that an voice currently occupies.
* 
* @param  string FindName - The name of an voice as seen in the SexLab MCM.
* @return int - The registration slot number for the voice.
**/;
int function FindVoiceByName(string FindName)
	return VoiceSlots.FindByName(FindName)
endFunction

;/**
* Returns a voice object by it's registration slot number.
* 
* @param  int slot - The slot number of the voice object.
* @return sslBaseVoice - The voice object that currently occupies that slot, NONE if nothing occupies it.
**/;
sslBaseVoice function GetVoiceBySlot(int slot)
	return VoiceSlots.GetBySlot(slot)
endFunction

;/**
* Selects a single voice from a set of given tag options.
* 
* @param  string Tags - A comma separated list of voice tags you want to use as a filter.
* @param  string TagSuppress - A comma separated list of voice tags you DO NOT want present on the returned voice.
* @param  bool RequireAll - If TRUE, all tags in the provided "string Tags" list must be present in an voice to be returned. When FALSE only one tag in the list is needed.
* @return sslBaseVoice - A randomly selected voice object among any that match the provided search arguments.
**/;
sslBaseVoice function GetVoiceByTags(string Tags, string TagSuppress = "", bool RequireAll = true)
	return VoiceSlots.GetByTags(Tags, TagSuppress, RequireAll)
endFunction

;#---------------------------#
;#    END VOICE FUNCTIONS    #
;#---------------------------#

;#---------------------------#
;# BEGIN EXPRESSION FUNCTION #
;#---------------------------#

;/**
* Selects a random expression that fits the provided criteria.
* 
* @param  Actor ActorRef - The actor who will be using this expression and the following conditions apply to.
* @param  bool IsVictim - Set to TRUE if the actor is considered the victim in an aggressive scene.
* @param  bool IsAggressor - Set to TRUE if the actor is considered the aggressor in an aggressive scene.
* @return sslBaseExpression - A randomly selected expression object among any that meet the needed criteria.
**/;
sslBaseExpression function PickExpressionByStatus(Actor ActorRef, bool IsVictim = false, bool IsAggressor = false)
	return ExpressionSlots.PickByStatus(ActorRef, IsVictim, IsAggressor)
endFunction

;/**
* Selects a random expression that fits the provided criteria. A slightly different method of doing the above.
* 
* @param  Actor ActorRef - The actor who will be using this expression.
* @param  Actor VictimRef - The actor considered a victim in an aggressive scene.
* @return sslBaseExpression - A randomly selected expression object among any that meet the needed criteria.
**/;
sslBaseExpression function PickExpression(Actor ActorRef, Actor VictimRef = none)
	return ExpressionSlots.PickByStatus(ActorRef, (VictimRef && VictimRef == ActorRef), (VictimRef && VictimRef != ActorRef))
endFunction

;/**
* Selects a single expression from based on a single tag.
* 
* @param  string Tags - A single expression tag to use as the filter when picking randomly.
* @return sslBaseExpression - A randomly selected expression object among any that have the provided tag.
**/;
sslBaseExpression function RandomExpressionByTag(string Tag)
	return ExpressionSlots.RandomByTag(Tag)
endFunction

;/**
* Get a single expression object by name. Ignores if a user has the expression enabled or not.
* 
* @param  string FindName - The name of an expression object as seen in the SexLab MCM.
* @return sslBaseExpression - The expression object whose name matches, if found.
**/;
sslBaseExpression  function GetExpressionByName(string findName)
	return ExpressionSlots.GetByName(findName)
endFunction

;/**
* Find the registration slot number that an expression currently occupies.
* 
* @param  string FindName - The name of an expression as seen in the SexLab MCM.
* @return int - The registration slot number for the expression.
**/;
int function FindExpressionByName(string findName)
	return ExpressionSlots.FindByName(findName)
endFunction

;/**
* Returns a expression object by it's registration slot number.
* 
* @param  int slot - The slot number of the expression object.
* @return sslBaseExpression - The expression object that currently occupies that slot, NONE if nothing occupies it.
**/;
sslBaseExpression function GetExpressionBySlot(int slot)
	return ExpressionSlots.GetBySlot(slot)
endFunction

;/**
* Opens an actors mouth.
* Mirrored function of a global in sslBaseExpressions. Suggested to use global instead of the one in this script.
* 
* @param  Actor ActorRef - The actors whose mouth should open.
**/;
function OpenMouth(Actor ActorRef)
	sslBaseExpression.OpenMouth(ActorRef)
endFunction

;/**
* Closes an actors mouth.
* Mirrored function of a global in sslBaseExpressions. Suggested to use global instead of the one in this script.
*
* @param  Actor ActorRef - The actors whose mouth should open.
**/;
function CloseMouth(Actor ActorRef)
	sslBaseExpression.CloseMouth(ActorRef)
endFunction

;/**
* Checks if an actors mouth is currently considered open or not.
* Mirrored function of a global in sslBaseExpressions. Suggested to use global instead of the one in this script.
*
* @param  Actor ActorRef - The actors whose may or may not currently be open.
* @return bool - TRUE if the actors mouth appears to be in an open state.
**/;
bool function IsMouthOpen(Actor ActorRef)
	return sslBaseExpression.IsMouthOpen(ActorRef)
endFunction

;/**
* Resets an actors mood, phonemes, and modifiers.
* Mirrored function of a global in sslBaseExpressions. Suggested to use global instead of the one in this script.
*
* @param  Actor ActorRef - The actors whose expression should return to normal.
**/;
function ClearMFG(Actor ActorRef)
	sslBaseExpression.ClearMFG(ActorRef)
endFunction

;/**
* Resets all of an actors phonemes to 0.
* Mirrored function of a global in sslBaseExpressions. Suggested to use global instead of the one in this script.
*
* @param  Actor ActorRef - The actor to clear phonemes on.
**/;
function ClearPhoneme(Actor ActorRef)
	sslBaseExpression.ClearPhoneme(ActorRef)
endFunction

;/**
* Resets all of an actors modifiers to 0.
* Mirrored function of a global in sslBaseExpressions. Suggested to use global instead of the one in this script.
*
* @param  Actor ActorRef - The actor to clear modifiers on.
**/;
function ClearModifier(Actor ActorRef)
	sslBaseExpression.ClearModifier(ActorRef)
endFunction

;/**
* Applies an array of values to an actor, automatically setting their phonemes, modifiers, and mood.
* Mirrored function of a global in sslBaseExpressions. Suggested to use global instead of the one in this script.
*
* @param  Actor ActorRef - The actors to apply the preset to.
* @param  float[] Preset - Must be a 32 length array. Each index corresponds to an MFG id. Values range from 0.0 to 1.0, with the exception of mood type.
*                          Phonemes   0-15 = Preset[0]  to Preset[15]
*                          Modifiers  0-13 = Preset[16] to Preset[29]
*                          Mood Type       = Preset[30]
*                          Mood Value      = Preset[31]
**/;
function ApplyPresetFloats(Actor ActorRef, float[] Preset)
	sslBaseExpression.ApplyPresetFloats(ActorRef, Preset)
endfunction

;/**
* Applies an array of values to an actor, automatically setting their phonemes, modifiers, and mood.
* Mirrored function of a global in sslBaseExpressions. Suggested to use global instead of the one in this script.
*
* @param  Actor ActorRef - The actors to apply the preset to.
* @param  int[] Preset - Must be a 32 length array. Each index corresponds to an MFG id. Values range from 0 to 100, with the exception of mood type.
*                        Phonemes   0-15 = Preset[0]  to Preset[15]
*                        Modifiers  0-13 = Preset[16] to Preset[29]
*                        Mood Type       = Preset[30]
*                        Mood Value      = Preset[31]
**/;
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
	return SexLabUtil.MakeActorArray(Actor1, Actor2, Actor3, Actor4, Actor5)
endFunction

;#---------------------------#
;#   END UTILITY FUNCTIONS   #
;#---------------------------#



;#---------------------------#
;#   DEPRECATED FUNCTIONS    #
;#  AVOID USING IF POSSIBLE  #
;#---------------------------#

sslBaseAnimation[] function GetAnimationsByTag(int ActorCount, string Tag1, string Tag2 = "", string Tag3 = "", string TagSuppress = "", bool RequireAll = true)
	return AnimSlots.GetByTags(ActorCount, sslUtility.MakeArgs(",", Tag1, Tag2, Tag3), TagSuppress, RequireAll)
endFunction

sslBaseVoice function GetVoiceByTag(string Tag1, string Tag2 = "", string TagSuppress = "", bool RequireAll = true)
	return VoiceSlots.GetByTags(sslUtility.MakeArgs(",", Tag1, Tag2), TagSuppress, RequireAll)
endFunction

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
sslSystemConfig property Config auto hidden
Faction property AnimatingFaction auto hidden
Actor property PlayerRef auto hidden

; Function libraries
sslActorLibrary property ActorLib auto hidden
sslThreadLibrary property ThreadLib auto hidden
sslActorStats property Stats auto hidden

; Object registries
sslThreadSlots property ThreadSlots auto hidden
sslAnimationSlots property AnimSlots auto hidden
sslCreatureAnimationSlots property CreatureSlots auto hidden
sslVoiceSlots property VoiceSlots auto hidden
sslExpressionSlots property ExpressionSlots auto hidden
sslObjectFactory property Factory auto hidden

; Mod Extends support
SexLabFramework SexLab
bool IsExtension

function Setup()
	; Reset function Libraries - SexLabQuestFramework
	Form SexLabQuestFramework = Game.GetFormFromFile(0xD62, "SexLab.esm")
	if SexLabQuestFramework
		SexLab      = SexLabQuestFramework as SexLabFramework
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
	; Check if main framework file, or extended
	IsExtension = self != SexLab
	if IsExtension
		Log(self+" - Loaded SexLab Extension")
	else
		Log(self+" - Loaded SexLabFramework")
	endIf
endFunction

event OnInit()
	Setup()
endEvent

function Log(string Log, string Type = "NOTICE")
	Log = Type+": "+Log
	if Config.InDebugMode
		SexLabUtil.PrintConsole(Log)
	endIf
	if IsExtension && ModName != ""
		Log = ModName+" - "+Log
	else
		Log = "SEXLAB - "+Log
	endIf
	if Type == "FATAL"
		Debug.TraceStack(Log)
	else
		Debug.Trace(Log)
	endIf
endFunction

state Disabled
	sslThreadModel function NewThread(float TimeOut = 30.0)
		Log("NewThread() - Failed to make new thread model; system is currently disabled or not installed", "FATAL")
		return none
	endFunction
	int function StartSex(Actor[] Positions, sslBaseAnimation[] Anims, Actor Victim = none, ObjectReference CenterOn = none, bool AllowBed = true, string Hook = "")
		Log("StartSex() - Failed to make new thread model; system is currently disabled or not installed", "FATAL")
		return -1
	endFunction
	sslThreadController function QuickStart(Actor Actor1, Actor Actor2 = none, Actor Actor3 = none, Actor Actor4 = none, Actor Actor5 = none, Actor Victim = none, string Hook = "", string AnimationTags = "")
		Log("QuickStart() - Failed to make new thread model; system is currently disabled or not installed", "FATAL")
		return none
	endFunction
	event OnBeginState()
		if SexLab == self || (!SexLab && self == SexLabUtil.GetAPI())
			Log("SexLabFramework - Disabled")
			ModEvent.Send(ModEvent.Create("SexLabDisabled"))
		endIf
	endEvent
endState

state Enabled
	event OnBeginState()
		if SexLab == self || (!SexLab && self == SexLabUtil.GetAPI())
			Log("SexLabFramework - Enabled")
			ModEvent.Send(ModEvent.Create("SexLabEnabled"))
		endIf
	endEvent
endState

;#---------------------------#
;#   NO LONGER USED, IGNORE  #
;#---------------------------#

sslBaseAnimation[] property Animations hidden
	sslBaseAnimation[] function get()
		return AnimSlots.Animations
	endFunction
endProperty
sslBaseAnimation[] property CreatureAnimations hidden
	sslBaseAnimation[] function get()
		return CreatureSlots.Animations
	endFunction
endProperty
sslBaseVoice[] property Voices hidden
	sslBaseVoice[] function get()
		return VoiceSlots.Voices
	endFunction
endProperty
sslBaseExpression[] property Expressions hidden
	sslBaseExpression[] function get()
		return ExpressionSlots.Expressions
	endFunction
endProperty
sslThreadController[] property Threads hidden
	sslThreadController[] function get()
		return ThreadSlots.Threads
	endFunction
endProperty