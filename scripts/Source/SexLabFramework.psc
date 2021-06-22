scriptname SexLabFramework extends Quest

;TODO: MERGE MATCHMAKER INTO THE FRAMEWORK AS AN OPTION TO TOGGLE ON/OFF IN THE MCM.

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


;/*  
* * This is a Property of SexLab and it is important to set it with the name of your mod if you are extending this script SexLab Framework
* * e.g. "Scriptname mySexLabMod extends SexLabFramework" Letting you call all functions here directly from your script as if they were it's own.
* * (currently this is unused by SexLab, but may or may not be used in the future.)
*/;
string property ModName auto

;/* The current SexLab script version as represented by a basic int version number, for example: 16100 for 1.61 */;
int function GetVersion()
	return SexLabUtil.GetVersion()
endFunction

;/* The current SexLab script version as represented by a more user friendly string, for example: "1.60b" for 16001 */;
string function GetStringVer()
	return SexLabUtil.GetStringVer()
endFunction

;/* A readonly property that tells you whether or not SexLab is currently enabled and able to start a new scene */;
bool property Enabled hidden
	bool function get()
		return GetState() != "Disabled"
	endFunction
endProperty

;/* A readonly property that returns TRUE if SexLab is currently actively playing a sex animation */;
bool property IsRunning hidden
	bool function get()
		return ThreadSlots.IsRunning()
	endFunction
endProperty

;/* A readonly property that, like IsRunning tells you if, this tells you how many (out of max 15) animations are currently playing */;
int property ActiveAnimations hidden
	int function get()
		return ThreadSlots.ActiveThreads()
	endFunction
endProperty

;/* Check if current user has enabled creature animations or not. */;
bool property AllowCreatures hidden
	bool function get()
		return Config.AllowCreatures
	endFunction
endProperty

;/* Check if current user has enabled gender checking for creature animations */;
bool property CreatureGenders hidden
	bool function get()
		return Config.UseCreatureGender
	endFunction
endProperty

;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#                                                          API RELATED FUNCTIONS                                                          #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#

;/* NewThread 
* * This function picks and returns a SexLab Thread, that is used to define with great details all the information about the "scene" to be played (Positions, Actors, Beds, Stripping, Events, Animations, etc.)
* * See the file sslThreadModel.psc for a further description of this important element.
* * 
* * @param: TimeOut - number of seconds to hold a claim to on this thread without starting an animation before giving up.
* * @return: sslThreadModel - the full definition of the SexLab Thread that can be used to configure, start, and stop the scene (a.k.a. the SexLab animation)
*/;
sslThreadModel function NewThread(float TimeOut = 30.0)
	; Claim an available thread
	return ThreadSlots.PickModel(TimeOut)
endFunction

;/* StartSex 
* * This is an easy and quick function to start a Sexlab animation without requiring too much code.
* * The difference between StartSex and QuickStart is that StartSex requires a list of animations (at least one), while QuickStart grabs the animations using animation Tags
* * 
* * @param: Positions, is an array of Actors that will be used in the animation, up to 5 actors are supported. The very first is considered to be the "Passive Position". If actors are unspecified this function will fail.
* * @param: Anims, is an array of sslBaseAnimation, and it is used to specify which animations will play. In case the animations are empty, not valid, or the number of the actors expected by the animation is not equal to the specified number of actors, then the animations are picked automatically by the default animation. (See GetAnimationsByDefault)
* * @param: Victim [OPTIONAL], if this Actor specified, then the specified actor (that should be one of the list of actors) will be considered as a victim.
* * @param: CenterOn [OPTIONAL], if the ObjectReference is specified, then the animation will be centered on the specified object. It can be a marker, a furniture, or any other possible ObjectReference.
* * @param: AllowBed, it is a boolean, if the value is false, then the animations requiring a bed will be filtered out
* * @param: Hook, you can specify a Hook for the animation, to register for the animation events (AnimationStart, AnimationEnd, OrgasmStart, etc.) See the Hooks section for further description
* *
* * @return: the tid of the thread that is allocated by the function, useable with GetController(). -1 if something went wrong and the animation will not start.
*/;
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

;/* QuickStart 
* * This is a very easy and quick function to start a Sexlab animation without requiring more than a single line of code.
* * The difference between StartSex and QuickStart is that StartSex requires a list of animations (at least one), while QuickStart grabs the animations using animation Tags\
* * This function is actually a wrapper around StartSex, that gets the animations by tags and then delegates StartSex to do the job.
* * 
* * @param: Actor Actor1, is the first position of the animation, and it is mandatory
* * @param: Actor Actor2 ... Actor5 [OPTIONAL], are the other actors involved in the animation.
* * @param: Actor Victim [OPTIONAL], if this Actor specified, then the specified actor (that should be one of the list of actors) will be considered as a victim.
* * @param: string Hook [OPTIONAL], you can specify a Hook for the animation, to register for the animation events (AnimationStart, AnimationEnd, OrgasmStart, etc.) See the Hooks section for further description
* * @param: string AnimationTags [OPTIONAL], is the list of tags the animation has to have. You can add more than one tag by separating them by commas "," (Example: "Oral, Aggressive, FemDom"), the animations will be collected if they have at least one of the specified tags.
* *
* * @return: the thread instance that is allocated by the function. NONE if something went wrong and the animation will not start.
*/;
sslThreadController function QuickStart(Actor Actor1, Actor Actor2 = none, Actor Actor3 = none, Actor Actor4 = none, Actor Actor5 = none, Actor Victim = none, string Hook = "", string AnimationTags = "")
	Actor[] Positions = SexLabUtil.MakeActorArray(Actor1, Actor2, Actor3, Actor4, Actor5)
	sslBaseAnimation[] Anims
	if AnimationTags != ""
		int[] Genders = ActorLib.GenderCount(Positions)
		if (Genders[2] + Genders[3]) < 1
			Anims = AnimSlots.GetByTags(Positions.Length, AnimationTags, "", false)
		else
			Anims = CreatureSlots.GetByCreatureActorsTags(Positions.Length, Positions, AnimationTags, "", false)
		endIf
	endIf
	return ThreadSlots.GetController(StartSex(Positions, Anims, Victim, none, true, Hook))
endFunction

;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#                                                             ACTOR FUNCTIONS                                                             #
;#                  These functions are used to handle and get info on the actors that will participate in the animations.                 #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#

;/* GetGender 
* * SexLab can mark an actor to be male or female without relying on the Sex specified in the Creation Kit for the actor.
* * The "SexLab gender" may differ from their vanilla ActorBase.GetSex() if their gender has been overridden, or they are creatures.
* * This function gives you the sex of the actor considering all SexLab modifications and also enabling sex for creatures.
* * 
* * @param: ActorRef, the actual actor you what to understand the gender
* * @return: an int with these possible values ("Human" is used as "Not a Creature"): 
* *  0 - Human Male (also the default values if the actor is not existing)
* *  1 - Human Female
* *  2 - Male Creature (this is the default value for any creature in case Creature Genders are disabled)
* *  3 - Female Creature (this value is possible only if Creature Genders are enabled)
*/;
int function GetGender(Actor ActorRef)
	return ActorLib.GetGender(ActorRef)
endFunction

;/* TreatAsMale 
* * Forces an actor to be considered as Male by SexLab, even if its ActorBase.GetSex() is female. Useful for having SexLab treat female hermaphrodites as if they were male.
* * 
* * @param: ActorRef, is the actor to set the SexLab Gender to male.
*/;
function TreatAsMale(Actor ActorRef)
	ActorLib.TreatAsMale(ActorRef)
endFunction

;/* TreatAsFemale 
* * Forces an actor to be considered as Female by SexLab, even if its ActorBase.GetSex() is male. Useful for having SexLab treat male character as if they were female.
* * 
* * @param: ActorRef, is the actor to set the SexLab Gender to female.
*/;
function TreatAsFemale(Actor ActorRef)
	ActorLib.TreatAsFemale(ActorRef)
endFunction

;/* TreatAsGender
* * Force an actor to be considered male or female by SexLab, by altering the SexLab gender.
* * 
* * @param: ActorRef, is the actor to set the SexLab Gender.
* * @param: AsFemale, if you pass the value True, then the actor will be considered as Female, if you pass the value False, then it will be considered as Male.
*/;
function TreatAsGender(Actor ActorRef, bool AsFemale)
	ActorLib.TreatAsGender(ActorRef, AsFemale)
endFunction

;/* ClearForcedGender
* * Clears any forced SexLab Gender on the actor, that was set with the function TreatAsMale(), TreatAsFemale(), TreatAsGender()
* * The gender will be now the vanilla genders (the same as ActorBase.getSex())
* * 
* * @param: ActorRef, is the actor for whom to clear forced SexLab Gender.
*/;
function ClearForcedGender(Actor ActorRef)
	ActorLib.ClearForcedGender(ActorRef)
endFunction

;/* GenderCount
* * Produces an array of integers with the number of different genders in the 4 items of the array.
* * 
* * @param: Positions, is an array of actors to be used for the genders calculation.
* * @return: int[] - An int array of Length 4 with the amount of actor of each gender;
* *   [0] is the number of (Human, not creature) Males
* *   [1] is the number of (Human, not creature) Females
* *   [2] is the number of Male Creatures (or all the creatures if Creature Genders are disabled)
* *   [3] is the number of Females Creatures (is always zero if Creature Genders are NOT enabled, contains the number of female creatures if Creature Genders ARE enabled)
*/;
int[] function GenderCount(Actor[] Positions)
	return ActorLib.GenderCount(Positions)
endFunction

;/* TransGenderCount
* * Produces an array of integers with the number of different genders trans in the 4 items of the array.
* * 
* * @param: Positions, is an array of actors to be used for the transgender calculation.
* * @return: int[] - An int array of Length 4 with the amount of actor of each gender that is Transgender/Futa;
* *   [0] is the number of Transgender Humanoid actors treated as Males
* *   [1] is the number of Transgender Humanoid actors treated as Females
* *   [2] is the number of Transgender Creatures actors treated as Male Creatures (or all the creatures if the "Creature Genders" option is disabled)
* *   [3] is the number of Transgender Creatures actors treated as Females Creatures (is always zero if the "Creature Genders" option is disabled)
*/;
int[] function TransGenderCount(Actor[] Positions)
	return ActorLib.TransCount(Positions)
endFunction

;/* MaleCount
* * Counts the number of Males in the array, considering the SexLab Genders.
* * 
* * @param: Positions, is an array of actors to be used for the genders calculation.
* * @return: an int with the number of males
*/;
int function MaleCount(Actor[] Positions)
	return ActorLib.MaleCount(Positions)
endFunction

;/* FemaleCount
* * Counts the number of Females in the array, considering the SexLab Genders.
* * 
* * @param: Positions, is an array of actors to be used for the genders calculation.
* * @return: an int with the number of females
*/;
int function FemaleCount(Actor[] Positions)
	return ActorLib.FemaleCount(Positions)
endFunction

;/* CreatureCount
* * Counts the number of creatures in the array
* * 
* * @param: Positions, is an array of actors to be used for the genders calculation.
* * @return: an int with the number of creatures (creature sex is not considered, use GenderCount() if you need to distinguish between male and female creatures.)
*/;
int function CreatureCount(Actor[] Positions)
	return ActorLib.CreatureCount(Positions)
endFunction

;/* TransMaleCount
* * Counts the number of Transgender Humanoid actors treated as Males in the array, considering the SexLab Genders.
* * 
* * @param: Positions, is an array of actors to be used for the genders calculation.
* * @return: an int with the number of Transgender actors treated as Males
*/;
int function TransMaleCount(Actor[] Positions)
	return ActorLib.TransCount(Positions)[0]
endFunction

;/* TransFemaleCount
* * Counts the number of Transgender Humanoid actors treated as Females in the array, considering the SexLab Genders.
* * 
* * @param: Positions, is an array of actors to be used for the genders calculation.
* * @return: an int with the number of Transgender actors treated as Females
*/;
int function TransFemaleCount(Actor[] Positions)
	return ActorLib.TransCount(Positions)[1]
endFunction

;/* TransCreatureCount
* * Counts the number of Transgender creatures actors in the array
* * 
* * @param: Positions, is an array of actors to be used for the genders calculation.
* * @return: an int with the number of transgender creatures (creature sex is not considered, use TransGenderCount() if you need to distinguish between male and female creatures.)
*/;
int function TransCreatureCount(Actor[] Positions)
	int[] TransCount = ActorLib.TransCount(Positions)
	return TransCount[2] + TransCount[3]
endFunction

;/* ValidateActor
* * Checks if the given actor is a valid target for SexLab animations.
* * 
* * @param: ActorRef, the actor to check if it is valid for SexLab Animations.
* * @return: an int that is 1 if the actor is valid or a negative value if it is not valid
* *   -1 = The Actor does not exists (it is None)
* *   -10 = The Actor is already part of a SexLab animation
* *   -11 = The Actor is forbidden form SexLab animations
* *   -12 = The Actor does not have the 3D loaded
* *   -13 = The Actor is dead (He's dead Jim.)
* *   -14 = The Actor is disabled
* *   -15 = The Actor is flying (so it cannot be SexLab animated)
* *   -16 = The Actor is on mount (so it cannot be SexLab animated)
* *   -17 = The Actor is a creature but creature animations are disabled
* *   -18 = The Actor is a creature that is not supported by SexLab
* *   -19 = The Actor is a creature but there are no valid animations for this type of creature
*/;
int function ValidateActor(Actor ActorRef)
	return ActorLib.ValidateActor(ActorRef)
endFunction

;/* IsValidActor
* * Checks if given actor is a valid target for SexLab animation.
* * Equivalent to ValidateActor() == 1
* * 
* * @param: ActorRef, the actor to check if it is valid for SexLab Animations.
* * @return: True if the actor is valid, and False if it is not.
*/;
bool function IsValidActor(Actor ActorRef)
	return ActorLib.IsValidActor(ActorRef)
endFunction

;/* IsActorActive
* * Checks if the given actor is active in any SexLab animation
* * 
* * @param: ActorRef, the actor to check for activity in a SexLab Animation.
* * @return: True if the actor is being animated by SexLab, and False if it is not.
*/;
bool function IsActorActive(Actor ActorRef)
	return ActorRef.IsInFaction(Config.AnimatingFaction)
endFunction

;/* ForbidActor
* * Makes an actor to be never allowed to engage in SexLab Animations.
* * @param: ActorRef, the actor to forbid from SexLab use.
*/;
function ForbidActor(Actor ActorRef)
	ActorLib.ForbidActor(ActorRef)
endFunction

;/* AllowActor
* * Removes an actor from the forbidden list, undoing the effects of ForbidActor()
* * 
* * @param: ActorRef, the actor to remove from the forbid list.
*/;
function AllowActor(Actor ActorRef)
	ActorLib.AllowActor(ActorRef)
endFunction

;/* IsForbidden
* * Checks if an actor is currently forbidden from use in SexLab scenes.
* * 
* * @param: ActorRef, the actor to check.
* * @return: True if the actor is forbidden from use.
*/;
bool function IsForbidden(Actor ActorRef)
	return ActorLib.IsForbidden(ActorRef)
endFunction

;/* FindAvailableActor
* * Searches within a given area for a SexLab valid actor
* * 
* * @param: ObjectReference CenterRef - The object to use as the center point in the search. 
* * @param: float Radius [OPTIONAL] - The distance from the center point to search.
* * @param: int FindGender [OPTIONAL] - The desired gender id to look for, -1 for any, 0 for male, 1 for female.
* * @param: Actor IgnoreRef1/2/3/4 [OPTIONAL] - An actor you know for certain you do not want returned by this function.
* * @return: Actor - A valid actor found, if any. None if no valid actor found.
*/;
Actor function FindAvailableActor(ObjectReference CenterRef, float Radius = 5000.0, int FindGender = -1, Actor IgnoreRef1 = none, Actor IgnoreRef2 = none, Actor IgnoreRef3 = none, Actor IgnoreRef4 = none)
	return ThreadLib.FindAvailableActor(CenterRef, Radius, FindGender, IgnoreRef1, IgnoreRef2, IgnoreRef3, IgnoreRef4)
endFunction

;/* FindAvailableActorByFaction
* * Searches within a given area for a SexLab valid actor with or without the specified faction
* * 
* * @param: Faction FactionRef - The faction that will be checked on the actor search. 
* * @param: ObjectReference CenterRef - The object to use as the center point in the search. 
* * @param: float Radius [OPTIONAL] - The distance from the center point to search.
* * @param: int FindGender [OPTIONAL] - The desired gender id to look for, -1 for any, 0 for male, 1 for female.
* * @param: Actor IgnoreRef1/2/3/4 [OPTIONAL] - An actor you know for certain you do not want returned by this function.
* * @param: bool HasFaction [OPTIONAL true by default] - If False the returned actor won't be part of the given faction, if True the returned actor most be part of the given faction.
* * @return: Actor - A valid actor found, if any. None if no valid actor found.
*/;
Actor function FindAvailableActorByFaction(Faction FactionRef, ObjectReference CenterRef, float Radius = 5000.0, int FindGender = -1, Actor IgnoreRef1 = none, Actor IgnoreRef2 = none, Actor IgnoreRef3 = none, Actor IgnoreRef4 = none, bool HasFaction = True)
	return ThreadLib.FindAvailableActorInFaction(FactionRef, CenterRef, Radius, FindGender, IgnoreRef1, IgnoreRef2, IgnoreRef3, IgnoreRef4, HasFaction)
endFunction

;/* FindAvailableActorWornForm
* * Searches within a given area for a SexLab valid actor with or without the specified faction
* * 
* * @param: int slotMask - The slotMask that will be checked on the actor search. 
* * @param: ObjectReference CenterRef - The object to use as the center point in the search. 
* * @param: float Radius [OPTIONAL] - The distance from the center point to search.
* * @param: int FindGender [OPTIONAL] - The desired gender id to look for, -1 for any, 0 for male, 1 for female.
* * @param: Actor IgnoreRef1/2/3/4 [OPTIONAL] - An actor you know for certain you do not want returned by this function.
* * @param: bool AvoidNoStripKeyword [OPTIONAL true by default] - If False the search won't check the equipped slotMask is treated as "NoStrip" (naked), if True the equipped slotMask treated as "NoStrip" (naked) will be considered unequipped.
* * @param: bool HasFaction [OPTIONAL true by default] - If False the returned actor won't have the given slotMask unequipped or empty, if True the returned actor most have the given slotMask equipped.
* * @return: Actor - A valid actor found, if any. None if no valid actor found.
*/;
Actor function FindAvailableActorWornForm(int slotMask, ObjectReference CenterRef, float Radius = 5000.0, int FindGender = -1, Actor IgnoreRef1 = none, Actor IgnoreRef2 = none, Actor IgnoreRef3 = none, Actor IgnoreRef4 = none, bool AvoidNoStripKeyword = True, bool HasWornForm = True)
	return ThreadLib.FindAvailableActorWornForm(slotMask, CenterRef, Radius, FindGender, IgnoreRef1, IgnoreRef2, IgnoreRef3, IgnoreRef4, AvoidNoStripKeyword, HasWornForm)
endFunction

;/* FindAvailableCreature
* * Searches within a given area for a SexLab valid creature
* * 
* * @param: string RaceKey - The SexLab RaceKey to find a creature whose race belongs to
* * @param: ObjectReference CenterRef - The object to use as the center point in the search. 
* * @param: float Radius [OPTIONAL] - The distance from the center point to search.
* * @param: int FindGender [OPTIONAL] - The desired gender id to look for, 2 for male/no gender, 3 for female.
* * @param: Actor IgnoreRef1/2/3/4 [OPTIONAL] - A creature you know for certain you do not want returned by this function.
* * @return: Actor - A valid creature found, if any. Returns none if no valid creature found.
**/;
Actor function FindAvailableCreature(string RaceKey, ObjectReference CenterRef, float Radius = 5000.0, int FindGender = 2, Actor IgnoreRef1 = none, Actor IgnoreRef2 = none, Actor IgnoreRef3 = none, Actor IgnoreRef4 = none)
	return ThreadLib.FindAvailableActor(CenterRef, Radius, FindGender, IgnoreRef1, IgnoreRef2, IgnoreRef3, IgnoreRef4, RaceKey)
endFunction

;/* FindAvailableCreatureByFaction
* * Searches within a given area for a SexLab valid creature with or without the specified faction
* * 
* * @param: string RaceKey - The SexLab RaceKey to find a creature whose race belongs to
* * @param: Faction FactionRef - The faction that most have or don't have the creature searched. 
* * @param: ObjectReference CenterRef - The object to use as the center point in the search. 
* * @param: float Radius [OPTIONAL] - The distance from the center point to search.
* * @param: int FindGender [OPTIONAL] - The desired gender id to look for, -1 for any, 0 for male, 1 for female.
* * @param: Actor IgnoreRef1/2/3/4 [OPTIONAL] - A creature you know for certain you do not want returned by this function.
* * @param: bool HasFaction [OPTIONAL true by default] - If False the returned creature won't be part of the given faction, if True the returned creature most be part of the given faction.
* * @return: Actor - A valid creature found, if any. None if no valid creature found.
*/;
Actor function FindAvailableCreatureByFaction(string RaceKey, Faction FactionRef, ObjectReference CenterRef, float Radius = 5000.0, int FindGender = -1, Actor IgnoreRef1 = none, Actor IgnoreRef2 = none, Actor IgnoreRef3 = none, Actor IgnoreRef4 = none, bool HasFaction = True)
	return ThreadLib.FindAvailableActorInFaction(FactionRef, CenterRef, Radius, FindGender, IgnoreRef1, IgnoreRef2, IgnoreRef3, IgnoreRef4, HasFaction, RaceKey)
endFunction

;/* FindAvailableCreatureWornForm
* * Searches within a given area for a SexLab valid creature with or without the specified faction
* * 
* * @param: string RaceKey - The SexLab RaceKey to find a creature whose race belongs to
* * @param: int slotMask - The slotMask that will be checked on the creature search. 
* * @param: ObjectReference CenterRef - The object to use as the center point in the search. 
* * @param: float Radius [OPTIONAL] - The distance from the center point to search.
* * @param: int FindGender [OPTIONAL] - The desired gender id to look for, -1 for any, 0 for male, 1 for female.
* * @param: Actor IgnoreRef1/2/3/4 [OPTIONAL] - A creature you know for certain you do not want returned by this function.
* * @param: bool AvoidNoStripKeyword [OPTIONAL true by default] - If False the search won't check the equipped slotMask is treated as "NoStrip" (naked), if True the equipped slotMask treated as "NoStrip" (naked) will be considered unequipped.
* * @param: bool HasFaction [OPTIONAL true by default] - If False the returned creature won't have the given slotMask unequipped or empty, if True the returned creature most have the given slotMask equipped.
* * @return: Actor - A valid creature found, if any. None if no valid creature found.
*/;
Actor function FindAvailableCreatureWornForm(string RaceKey, int slotMask, ObjectReference CenterRef, float Radius = 5000.0, int FindGender = -1, Actor IgnoreRef1 = none, Actor IgnoreRef2 = none, Actor IgnoreRef3 = none, Actor IgnoreRef4 = none, bool AvoidNoStripKeyword = True, bool HasWornForm = True)
	return ThreadLib.FindAvailableActorWornForm(slotMask, CenterRef, Radius, FindGender, IgnoreRef1, IgnoreRef2, IgnoreRef3, IgnoreRef4, AvoidNoStripKeyword, HasWornForm, RaceKey)
endFunction

;/* FindAvailablePartners
* * Searches within a given area for multiple SexLab valid actors
* * 
* * @param: Actor[] Positions - A list of actors, where at least one is specified (the other items can be set to None)
* * @param: int TotalActors - The desired total number of actors you want in the return array.
* * @param: int Males [OPTIONAL] - From the TotalActors amount, you want at least this many males.
* * @param: int Females [OPTIONAL] - From the TotalActors amount, you want at least this many females.
* * @param: float Radius [OPTIONAL] - The distance from the center point to search.
* * @return: Actor[] - A list of valid actors, the length of the list is the same as the Positions parameter, then number of valid actors can be less than this value.
*/;
Actor[] function FindAvailablePartners(Actor[] Positions, int TotalActors, int Males = -1, int Females = -1, float Radius = 10000.0)
	return ThreadLib.FindAvailablePartners(Positions, TotalActors, Males, Females, Radius)
endFunction

;/* SortActors
* * Sorts a list of actors to include either female or male actors first in the array.
* * SexLab animations generally expect the female actor to be listed first in a scene.
* * 
* * @param: Actor[] Positions - The list of actors to sort by gender
* * @param: bool FemaleFirst [OPTIONAL] - If forced to FALSE, male actors will be sorted first instead of females.
* * @return: Actor[] - The final sorted list of actors.
*/;
Actor[] function SortActors(Actor[] Positions, bool FemaleFirst = true)
	return ThreadLib.SortActors(Positions, FemaleFirst)
endFunction

;/* SortActorsByAnimation
* * Sorts a list of actors to include either female, male or creature actors in the valid position based on the animation gender and race definition.
* * This is a most general propoused function that fully cover standard and creature actors.
* * 
* * @param: Actor[] Positions - The list of humanoid and/or creature actors to sort
* * @param: sslBaseAnimation Animation [OPTIONAL] - Is the animation used as referece to sort the actors. In case the animation is none, not valid, or the number of the actors expected by the animation is not equal to the number of actors in the Positions array, then for the Position array without creatures the SortActors function will be executed instead.
* * @return: Actor[] - The final sorted list of actors.
*/;
Actor[] function SortActorsByAnimation(Actor[] Positions, sslBaseAnimation Animation = none)
	return ThreadLib.SortActorsByAnimation(Positions, Animation)
endFunction

;/* SortCreatures
* * Sorts a list of creature actors to include either female or male standard actors in the valid position based on the animation gender and race definition.
* * This is a creature oriented function that can handle "creature only animations", "humanoid & creature animations" and "multiple creature races on the same animation".
* * 
* * @param: Actor[] Positions - The list of creature and humanoid actors to sort
* * @param: sslBaseAnimation Animation [OPTIONAL] - Is the animation used as referece to sort the actors. In case the animation is none, not valid, or the number of the actors or races expected by the animation is not equal to the number of actors or races in the Positions array, then for the Position array with creatures the humanoid actors will be listed first in a scene.
* * @return: Actor[] - The final sorted list of actors.
*/;
Actor[] function SortCreatures(Actor[] Positions, sslBaseAnimation Animation = none)
	return ThreadLib.SortCreatures(Positions, Animation)
endFunction


;/* AddCum
* * Applies the cum effect to an actor for the given locations
* * 
* * @param: Actor ActorRef - The actor to apply the cum EffectShader to
* * @param: bool Vaginal [OPTIONAL] - if set to TRUE, then the cum will be applied (or staked if it was already there) to the Vagina.
* * @param: bool Oral [OPTIONAL] - if set to TRUE, then the cum will be applied (or staked if it was already there) to the Mouth.
* * @param: bool Anal [OPTIONAL] - if set to TRUE, then the cum will be applied (or staked if it was already there) to the Anus.
*/;
function AddCum(Actor ActorRef, bool Vaginal = true, bool Oral = true, bool Anal = true)
	ActorLib.AddCum(ActorRef, Vaginal, Oral, Anal)
endFunction

;/* ClearCum
* * Removes existing cum EffectShaders.
* * 
* * @param: Actor ActorRef - The actor you want to remove any trace of cum from the skin, it will actually remove the EffectShaders from the actor.
*/;
function ClearCum(Actor ActorRef)
	ActorLib.ClearCum(ActorRef)
endFunction

;/* CountCum
* * Checks how many stacks of cum an actor currently has in the given areas
* * 
* * @param: Actor ActorRef - The actor to check for cum EffectShader stacks
* * @param: bool Vaginal/Oral/Anal - Each location set to TRUE contributes to the returned count of cum stacks.
* * @return: an int with the number of stacked layers
*/;
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

;/* StripActor
* * Strips an actor using SexLab's strip settings as chosen by the user from the SexLab MCM
* * 
* * @param: Actor ActorRef - The actor whose equipment shall be unequipped.
* * @param: Actor VictimRef [OPTIONAL] - If ActorRef matches VictimRef victim strip settings are used. If VictimRef is set but doesn't match, aggressor settings are used.
* * @param: bool DoAnimate [OPTIONAL true by default] - Whether or not to play the actor stripping animations during the strip
* * @param: bool LeadIn [OPTIONAL false by default] - If TRUE and VictimRef == none, Foreplay strip settings will be used.
* * @return: Form[] - An array of all equipment stripped from ActorRef
*/;
Form[] function StripActor(Actor ActorRef, Actor VictimRef = none, bool DoAnimate = true, bool LeadIn = false)
	return ActorLib.StripActor(ActorRef, VictimRef, DoAnimate, LeadIn)
endFunction



;/* StripSlots
* * Strips an actor of equipment using a custom selection of biped objects / slot masks.
* * See for the slot values: http://www.creationkit.com/Biped_Object
* * 
* * @param: Actor ActorRef - The actor whose equipment shall be unequipped.
* * @param: bool[] Strip - MUST be a bool array with a length of exactly 33 items. Any index set to TRUE will be stripped using nth + 30 = biped object / slot mask. The extra index Strip[32] is used to strip weapons
* * @param: bool DoAnimate - Whether or not to play the actor stripping animation during
* * @param: bool AllowNudesuit - Whether to allow the use of nudesuits, if the user has that option enabled in the MCM (the poor fool)
* * @return: Form[] - An array of all equipment stripped from ActorRef
*/;
Form[] function StripSlots(Actor ActorRef, bool[] Strip, bool DoAnimate = false, bool AllowNudesuit = true)
	return ActorLib.StripSlots(ActorRef, Strip, DoAnimate, AllowNudesuit)
endFunction

;/* UnstripActor
* * Equips an actor with the given equipment. Intended for reversing the results of the Strip functions using their return results.
* * 
* * @param: Actor ActorRef - The actor whose equipment shall be re-equipped.
* * @param: Form[] Stripped - A form array of all the equipment to be equipped on ActorRef. Typically the saved result of StripActor() or StripSlots()
* * @param: bool IsVictim - If TRUE and the user has the SexLab MCM option for Victims Redress disabled, the actor will not actually re-equip their gear.
*/;
function UnstripActor(Actor ActorRef, Form[] Stripped, bool IsVictim = false)
	ActorLib.UnstripActor(ActorRef, Stripped, IsVictim)
endFunction

;/* IsStrippable
* * Checks if a given item can be unequipped from actors by the SexLab strip functions.
* * 
* * @param: Form ItemRef - The item you want to check.
* * @return: bool - TRUE if the item does not have the keyword with the word "NoStrip" in it, or is flagged as "Always Strip" in the SexLab MCM Strip Editor.
*/;
bool function IsStrippable(Form ItemRef)
	return ActorLib.IsStrippable(ItemRef)
endFunction

;/* StripSlot
* * Removes and unequip an item from an actor that is in the position defined by the given slot mask.
* * The item is unequipped only if it is considered strippable by SexLab.
* * 
* * @param: Actor ActorRef - The actor to unequip the slot from
* * @param: int SlotMask - The slot mask id for your chosen biped object. See more: http://www.creationkit.com/Slot_Masks_-_Armor
* * @return: Form - The item equipped on the SlotMask if removed. None if it was not removed or nothing was there.
*/;
Form function StripSlot(Actor ActorRef, int SlotMask)
	return ActorLib.StripSlot(ActorRef, SlotMask)
endFunction

;/* WornStrapon
* * Checks and returns for any strapon that equipped by the actor and is considered as a registered strapon by SexLab. (Check LoadStrapon() to find how to add new strapons to SexLab)
* * 
* * @param: Actor ActorRef - The actor to look for a strapon on.
* * @return: Form - The SexLab registered strapon actor is currently wearing, if any.
*/;
Form function WornStrapon(Actor ActorRef)
	return Config.WornStrapon(ActorRef)
endFunction

;/* HasStrapon
* * Checks if the actor is wearing, or has in its inventory, any of the registered SexLab strapons.
* * 
* * @param: Actor ActorRef - The actor to look for a strapon on.
* * @return: bool - TRUE if the actor has a SexLab registered strapon equipped or in their inventory.
*/;
bool function HasStrapon(Actor ActorRef)
	return Config.HasStrapon(ActorRef)
endFunction

;/* PickStrapon
* * Picks a strapon from the SexLab registered strapons for the actor to use.
* * 
* * @param: Actor ActorRef - The actor to look for a strapon to use.
* * @return: Form - A randomly selected strapon or the strapon the actor already has in inventory, if any.
*/;
Form function PickStrapon(Actor ActorRef)
	return Config.PickStrapon(ActorRef)
endFunction

;/* EquipStrapon
* * Equips a SexLab registered strapon on the actor.
* * 
* * @param: Actor ActorRef - The actor to equip a strapon.
* * @return: Form - The strapon equipped, either randomly selected or pre-owned by ActorRef.
*/;
Form function EquipStrapon(Actor ActorRef)
	return Config.EquipStrapon(ActorRef)
endFunction

;/* UnequipStrapon
* * Unequips a strapon from an actor, if they are wearing one.
* * 
* * @param: Actor ActorRef - The actor to unequip any worn strapon.
*/;
function UnequipStrapon(Actor ActorRef)
	Config.UnequipStrapon(ActorRef)
endFunction

;/* 
* * Loads an armor from mod into the list of valid strapons to use.
* * 
* * @param: string esp - the .esp/.esm mod to load a form from. This is not the "Name of a mod", it is the actual name of the .esp/.esm file
* * @param: int id - the form id to load from the esp . Do not put the mod id part, use only the lower 3 bytes of the id. E.G. If your Form has an ID in the Console equals to 0x270AB12C0, then the id to be used is 0x0AB12C0
* * @return: Armor - If form was found and is a valid armor, a copy of the loaded Armor form. 
*/;
Armor function LoadStrapon(string esp, int id)
	return Config.LoadStrapon(esp, id)
endFunction


;/* CheckBardAudience
* * Removes an actor from the audience of any currently active bard scenes, preventing them from playing the clapping animation.
* * For more future prevention, add actor to the faction BardAudienceExcludedFaction (id: 0x0010FCB4)
* * 
* * @param: Actor ActorRef - The actor you want to remove/check
* * @param: bool RemoveFromAudience - Set to FALSE to only check if they are present and not remove them from the audience.
* * @return: bool - TRUE if ActorRef was/is present in a bard audience
*/;
bool function CheckBardAudience(Actor ActorRef, bool RemoveFromAudience = true)
	return Config.CheckBardAudience(ActorRef, RemoveFromAudience)
endFunction

;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#  ^^^                                                   END ACTOR FUNCTIONS                                                       ^^^  #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#


;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#                                                       BEGIN BED FUNCTIONS                                                            #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#

;/* FindBed
* * Searches for a bed within a given radius from a provided center, and returns its ObjectReference.
* * 
* * @param: ObjectReference CenterRef - An object/actor/marker to use as the center point of your search.
* * @param: float Radius - The radius distance to search within the given CenterRef for a bed. 
* * @param: bool IgnoreUsed - When searching for beds, attempt to check if any actor is currently using the bed, in this case the bed will be ignored. 
* * @param: ObjectReference IgnoreRef1/IgnoreRef2 - A bed object that might be within the search radius, but you know you don't want.
* * @return: ObjectReference - The found valid bed within the radius. NONE if no bed found. 
*/;
ObjectReference function FindBed(ObjectReference CenterRef, float Radius = 1000.0, bool IgnoreUsed = true, ObjectReference IgnoreRef1 = none, ObjectReference IgnoreRef2 = none)
	return ThreadLib.FindBed(CenterRef, Radius, IgnoreUsed, IgnoreRef1, IgnoreRef2)
endFunction

;/* IsBedRoll
* * Checks if a given bed is considered a bed roll.
* * 
* * @param: ObjectReference BedRef - The bed object you want to check.
* * @return: bool - TRUE if BedRef is considered a bed roll.
*/;
bool function IsBedRoll(ObjectReference BedRef)
	return ThreadLib.IsBedRoll(BedRef)
endFunction

;/* IsDoubleBed
* * Checks if a given bed is considered a 2 person bed.
* * 
* * @param: ObjectReference BedRef - The bed object you want to check.
* * @return: bool - TRUE if BedRef is considered a 2 person bed.
*/;
bool function IsDoubleBed(ObjectReference BedRef)
	return ThreadLib.IsDoubleBed(BedRef)
endFunction

;/* IsSingleBed
* * Checks if a given bed is considered a single bed.
* * 
* * @param: ObjectReference BedRef - The bed object you want to check.
* * @return: bool - TRUE if BedRef is considered a single bed.
*/;
bool function IsSingleBed(ObjectReference BedRef)
	return ThreadLib.IsSingleBed(BedRef)
endFunction

;/* IsBedAvailable
* * Checks if a given bed is appears to be in use by another actor.
* * 
* * @param: ObjectReference BedRef - The bed object you want to check.
* * @return: bool - TRUE if BedRef is not being used, FALSE if a NPC is sleeping on it or is used by another SexLab thread.
*/;
bool function IsBedAvailable(ObjectReference BedRef)
	return ThreadLib.IsBedAvailable(BedRef)
endFunction

;/* AddCustomBed
* * Adds a new bed to the list of beds SexLab will search for when starting an animation.
* * 
* * @param: Form BaseBed - The base object of the bed you wish to add.
* * @param: int BedType - Defines what kind of bed it is. 0 = normal bed, 1 = bedroll, 2 = double bed.
* * @return: bool - TRUE if bed was successfully added to the bed list. 
*/;
bool function AddCustomBed(Form BaseBed, int BedType = 0)
	return Config.AddCustomBed(BaseBed, BedType)
endFunction

;/* SetCustomBedOffset
* * Override the default bed offsets used by SexLab [30, 0, 37, 0] for a given base bed object during animation.
* * 
* * @param: Form BaseBed - The base object of the bed you wish to add custom offsets.
* * @param: float Forward - The amount the actor(s) should be pushed forward on the bed when playing an animation.
* * @param: float Sideward - The amount the actor(s) should be pushed sideward on the bed when playing an animation.
* * @param: float Upward - The amount the actor(s) should be pushed upward on the bed when playing an animation. (NOTE: Ignored for bedrolls)
* * @param: float Rotation - The amount the actor(s) should be rotated on the bed when playing an animation.
* * @return: bool - TRUE if BedRef if the bed succesfully had it's default offsets overriden.
*/;
bool function SetCustomBedOffset(Form BaseBed, float Forward = 30.0, float Sideward = 0.0, float Upward = 37.0, float Rotation = 0.0)
	return Config.SetCustomBedOffset(BaseBed, Forward, Sideward, Upward, Rotation)
endFunction

;/* ClearCustomBedOffset
* * Removes any bed offset overrides set by the SetCustomBedOffset() function. Reverting it's offsets to the SexLab default.
* * 
* * @param: Form BaseBed - The base object of the bed you wish to remove custom offsets from.
* * @return: bool - TRUE if BedRef if the bed succesfully had it's default offsets restored. FALSE if it didn't have any to begin with.
*/;
bool function ClearCustomBedOffset(Form BaseBed)
	return Config.ClearCustomBedOffset(BaseBed)
endFunction

;/* GetBedOffsets
* * Get an array of offsets that would be used by the given bed. 
 the 
* * @param: ObjectReference BedRef - The bed object you want to get offsets for.
* * @return: float[] - The array of offsets organized as [Forward, Sideward, Upward, Rotation]. If no customs defined, the default is returned.
*/;
float[] function GetBedOffsets(Form BaseBed)
	return Config.GetBedOffsets(BaseBed)
endFunction

;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#  ^^^                                                       END BED FUNCTIONS                                                       ^^^  #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#


;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#                                                         BEGIN THREAD FUNCTIONS                                                          #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#

;/* GetController
* * Gets the thread associated with the given thread id number. Mostly used for getting the thread associated with a hook event.
* * 
* * @param: int tid - The thread id number of the thread you wish to retrieve. Should be a number between 0-14
* * @return: sslThreadController - The thread that the given tid belongs to.
*/;
sslThreadController function GetController(int tid)
	return ThreadSlots.GetController(tid)
endFunction

;/* FindActorController
* * Finds any thread controller an actor is currently associated with and returns it's thread id number.
* *
* * @param: Actor ActorRef - The actor to search for.
* * @return: int - The id of the ThreadController where the actor is currently in. -1 if the actor couldn't be found in any of the ThreadControllers.
*/;
int function FindActorController(Actor ActorRef)
	return ThreadSlots.FindActorController(ActorRef)
endFunction

;/* FindActorController
* * Finds any thread controller the player is currently associated with and returns it's thread id number
* * @return: int - The id of the ThreadController where the player is currently in. -1 if the player couldn't be found in any of the ThreadControllers.
*/;
int function FindPlayerController()
	return ThreadSlots.FindActorController(PlayerRef)
endFunction

;/* 
* * Finds any thread controller an actor is currently associated with and returns it.
* * 
* * @param: Actor ActorRef - The actor to search for.
* * @return: sslThreadController - The ThreadController the actor is currently part of. NONE if actor couldn't be found.
*/;
sslThreadController function GetActorController(Actor ActorRef)
	return ThreadSlots.GetActorController(ActorRef)
endFunction

;/* GetPlayerController
* * Finds any thread controller the player is currently associated with and returns it.
* * 
* * @return: sslThreadController - The ThreadController the player is currently part of. NONE if player couldn't be found.
*/;
sslThreadController function GetPlayerController()
	return ThreadSlots.GetActorController(PlayerRef)
endFunction

;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#  ^^^                                                     END THREAD FUNCTIONS                                                      ^^^  #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#

;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#                                                        BEGIN TRACKING FUNCTIONS                                                         #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#


;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#  TRACKING USAGE INSTRUCTIONS                                                                                                            #
;#                                                                                                                                         #
;# An actor is tracked either by specifically it being marked for tracking, or because it belongs to a faction that is tracked.            #
;# Tracked actors will receive special mod events.                                                                                         #
;# NOTE: The player has a default tracked event associated with them using the callback "PlayerTrack"                                      #
;#                                                                                                                                         #
;# The default tracked event types are: Added, Start, End, Orgasm.                                                                         #
;# Which correspond with an actor being added to a thread, starting an animation, ending an animation, and having an orgasm.               #
;#                                                                                                                                         #
;# Once you register a callback for an actor or faction, the mod event that is sent will be "<custom callback>_<event type>".              #
;#                                                                                                                                         #
;# Example:                                                                                                                                #
;# If you want to run some code, whenever a specific Actor finishes a SexLab animation, then you can do something like this:               #
;#                                                                                                                                         #
;#  Actor myActor = ...                              <-- you get your actor in any way you want                                            #
;#  SexLab.TrackActor(ActorRef, "MyHook")            <-- here you start to track the actor, and the hook that will be used is MyHook       #
;#  RegisterForModEvent("MyHook_End", "DoSomething")                                                                                        #
;#                                                                                                                                         #
;#  Event DoSomething(Form FormRef, int tid)                                                                                               #
;#    Debug.MessageBox("The Actor " + myActor.getDisplayname() just ended an animation.")                                                  #
;#  EndEvent                                                                                                                               #
;#                                                                                                                                         #
;# In the received event, the first parameter FormRef will be the Actor (you may want to cast it),                                         #
;# and the second parameter tid is the ID of the Tread Controller                                                                          #
;#                                                                                                                                         #
;# For an advanced description of the events management look into the HOOKS section.                                                       #
;#                                                                                                                                         #
;#                                                                                                                                         #
;# NOTE: In the following functions the parameter Callback is NOT a function, is a part of the name of the event that is generated.        #
;#                                                                                                                                         #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#

;/* TrackActor
* * Associates a specific actor with a unique callback mod event that is sent whenever the actor performs certain actions within SexLab animations.
* * You need to RegisterForModEvents for an event with name <Callback>_<Event>, where events can be:
* * "Added" - The actor is added to a SexLab animation
* * "Start" - The SexLab animations where the actor was added is starting
* * "Orgasm" - The actor is having an orgasm
* * "End" - The SexLab animations where the actor was added is ended
* * 
* * @param: Actor ActorRef - The actor you want to receive tracked events for.
* * @param: string Callback - The unique callback name you want to associate with this actor.
*/;
function TrackActor(Actor ActorRef, string Callback)
	ThreadLib.TrackActor(ActorRef, Callback)
endFunction

;/* UntrackActor
* * Removes an associated callback name from an actor.
* * Mod Events of type <Callback>_Start, <Callback>_End, <Callback>_Orgasm, and <Callback>_Added, are no more sent for this actor.
* * Warning, do not remove the player, or some old mods may fail to work.
* * 
* * @param: Actor ActorRef - The actor you want to remove the tracked events for.
* * @param: string Callback - The unique callback event you want to disable.
*/;
function UntrackActor(Actor ActorRef, string Callback)
	ThreadLib.UntrackActor(ActorRef, Callback)
endFunction

;/* 
* * Associates a specific Faction with a unique callback mod event that is sent whenever an actor that is in this faction, performs certain actions within SexLab Animations.
* * You need to RegisterForModEvents for an event with name <Callback>_<Event>, where events can be:
* * "Added" - The actor is added to a SexLab animation
* * "Start" - The SexLab animations where the actor was added is starting
* * "Orgasm" - The actor is having an orgasm
* * "End" - The SexLab animations where the actor was added is ended
* * 
* * @param: Faction FactionRef - The faction whose members you want to receive tracked events for.
* * @param: string Callback - The unique callback name you want to associate with this faction's actors.
*/;
function TrackFaction(Faction FactionRef, string Callback)
	ThreadLib.TrackFaction(FactionRef, Callback)
endFunction

;/* UntrackFaction
* * Removes an associated callback from a faction.
* * 
* * @param: Faction FactionRef - The faction you want to remove the tracked events for.
* * @param: string Callback - The unique callback event you want to disable.
*/;
function UntrackFaction(Faction FactionRef, string Callback)
	ThreadLib.UntrackFaction(FactionRef, Callback)
endFunction

;/* SendTrackedEvent
* * Sends a custom tracked event for an actor that is tracked, if they have any associated callbacks themselves or belong to a tracked factions.
* * The actual event name that is sent is the <callback defined to track the actor>_<hook name>, and you have to RegisterForModEvents with this name to being able to receive them.
* * 
* * @param: Actor ActorRef - The actor you want to send a custom tracked event for.
* * @param: string Hook - The event type you want to send, used in place of the default Added, Start, End, Orgasm hook types as "<Hook>_<Callback>"
* * @param: int id [OPTIONAL] - An id number to send with your custom tracked event. This is normally the associated animation thread id number, but can be anything you want.
* * 
* * EXAMPLE:
* * Actor myActor = ...                                                                     <-- get you actor in some way
* * SexLab.TrackActor(myActor, "MyCallBackName")                                            <-- Track the actor for "MyCallBackName"
* * RegisterForModEvents("MyCallBackName_ThisIsATest", "WeReceivedTheCustomEvent")          <-- Register for events "MyCallBackName_ThisIsATest"
* * 
* * SexLab.SendTrackedEvent(myActor, "ThisIsATest", 123)                                    <-- Send a specific event "ThisIsATest"
* * 
* * 
* * Event WeReceivedTheCustomEvent(Form FormRef, int tid)
* *   Debug.MessageBox("The Actor "+(FormRef as Actor).GetDisplayname()+" just received the event ThisIsATest and the value is " + tid)
* *   ; The message displayed will be "The Actor <xxx> just received the event ThisIsATest and the value is 123"
* * EndEvent   
* * 
*/;
function SendTrackedEvent(Actor ActorRef, string Hook, int id = -1)
	ThreadLib.SendTrackedEvent(ActorRef, Hook, id)
endFunction

;/* IsActorTracked
* * Checks if a given actor will receive any tracked events. Will always return TRUE if used on the player, due to the built in "PlayerTrack" callback.
* * 
* * @param: Actor ActorRef - The actor to check.
* * @return: bool - TRUE if the actor has any associated callbacks, or belongs to any tracked factions.
*/;
bool function IsActorTracked(Actor ActorRef)
	return ThreadLib.IsActorTracked(ActorRef)
endFunction

;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#  ^^^                                                     END TRACKING FUNCTIONS                                                    ^^^  #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#

;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#                                                        BEGIN ANIMATION FUNCTIONS                                                        #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#

;/* GetAnimationsByTags
* * Get an array of animations that have a specified set of tags.
* * 
* * @param: int ActorCount - The total number of actors that will participate in the animation, valid values are between 1 and 5. Each animation is specific for a defined number of actors.
* * @param: string Tags - A comma separated list of animation tags you want to use as a filter for the returned animations. (E.g. "Leito,Vaginal,Missionary", to get the animation from Leito, in missionary position, where the mouth has some importance. All or just one of the tags? Depends on the value of the parameter RequireAll)
* * @param: string TagSuppress [OPTIONAL] - A comma separated list of animation tags you DO NOT want present on any of the returned animations. (E.g. "Aggressive" will filter out all the animations that have the tag "Aggressive")
* * @param: bool RequireAll [OPTIONAL True by default] - If TRUE, all tags in the provided "string Tags" list must be present in an animation to be returned. When FALSE only one tag in the list is needed. (E.g. If the tags are "oral,Vaginal" and RequireAll is set to TRUE, then the animations found will have BOTH Oral and Vaginal tags; if RequireAll is set to FALSE, then the animation swill have just one of the two tags, and also both together will be returned in the list.)
* * @return: sslBaseAnimation[] - An array of animations that fit the provided search arguments. Be aware that the maximum number of returned animations is 128. Also if more animations that 128 are valid for the parameters specified.
*/;
sslBaseAnimation[] function GetAnimationsByTags(int ActorCount, string Tags, string TagSuppress = "", bool RequireAll = true)
	return AnimSlots.GetByTags(ActorCount, Tags, TagSuppress, RequireAll)
endFunction

;/* GetAnimationsByType
* * Get an array of animations that fit a specified set of parameters based on the genders of the participants
* *
* * @param: int ActorCount - The total number of actors that will participate in the animation, valid values are between 1 and 5. Each animation is specific for a defined number of actors.
* * @param: int Males [OPTIONAL] - The total number of males the returned animations should be intended for. Set to -1 for any amount.
* * @param: int Females [OPTIONAL] - The total number of females the returned animations should be intended for. Set to -1 for any amount.
* * @param: int StageCount [OPTIONAL] - The total number of stages the returned animations should contain. Set to -1 for any amount.
* * @param: bool Aggressive [OPTIONAL false by default] - TRUE if you want the animations returned to include ones tagged as aggressive.
* * @param: bool Sexual [OPTIONAL true by default] - FALSE if you want the animations returned to be LeadIn/Foreplay type tagged.
* * @return: sslBaseAnimation[] - An array of animations that fit the provided search arguments.
*/;
sslBaseAnimation[] function GetAnimationsByType(int ActorCount, int Males = -1, int Females = -1, int StageCount = -1, bool Aggressive = false, bool Sexual = true)
	return AnimSlots.GetByType(ActorCount, Males, Females, StageCount, Aggressive, Sexual)
endFunction

;/* PickAnimationsByActors
* * Get an array of animations that fit the given array of actors using SexLab's default selection criteria.
* *  
* * @param: Actor[] Positions - An array of 1 to 5 actors you intend to use the resulting animations with.
* * @param: int Limit [OPTIONAL 64 by default] - Limits the number of animations returned to this amount. Searches that result in more than this will randomize the results to fit within the limit.
* * @param: bool Aggressive [OPTIONAL false by default] - TRUE if you want the animations returned to include ones tagged as aggressive.
* * @return: sslBaseAnimation[] - An array of animations that fit the provided search arguments.
*/;
sslBaseAnimation[] function PickAnimationsByActors(Actor[] Positions, int Limit = 64, bool Aggressive = false)
	return AnimSlots.PickByActors(Positions, limit, aggressive)
endFunction

;/* GetAnimationsByDefault
* * Get an array of animations that fit the given number of males and females using SexLab's default selection criteria.
* *  
* * @param: int Males - The total number of males the returned animations should be intended for. Set to -1 for any amount.
* * @param: int Females - The total number of females the returned animations should be intended for. Set to -1 for any amount.
* * @param: bool IsAggressive - TRUE if the animations to be played are considered aggressive.
* * @param: bool UsingBed - TRUE if the animation is going to be played on a bed, which will filter out standing animations and allow BedOnly tagged animations.
* * @param: bool RestrictAggressive - If TRUE, only return aggressive animations if IsAggressive=true and none if IsAggressive=false.
* * @return: sslBaseAnimation[] - An array of animations that fit the provided search arguments.
* * Note about the parameters "IsAggressive" and "RestrictAggressive", they work together and the logic is the following one:
* *  IsAggressive=True, RestrictAggressive=False  --> ONLY aggressive animations are used
* *  IsAggressive=True, RestrictAggressive=True  --> Only animations that are NOT aggressive are used
* *  IsAggressive=False, RestrictAggressive=False  --> Both aggressive and not aggressive animations are used
* *  IsAggressive=False, RestrictAggressive=True  --> Only animations that are NOT aggressive are used
*/;
sslBaseAnimation[] function GetAnimationsByDefault(int Males, int Females, bool IsAggressive = false, bool UsingBed = false, bool RestrictAggressive = true)
	return AnimSlots.GetByDefault(Males, Females, IsAggressive, UsingBed, RestrictAggressive)
endFunction

;/* GetAnimationsByDefaultTags
* * Get an array of animations that fit the given number of males and females using SexLab's default selection criteria.
* *  
* * @param: int Males - The total number of males the returned animations should be intended for. Set to -1 for any amount.
* * @param: int Females - The total number of females the returned animations should be intended for. Set to -1 for any amount.
* * @param: bool IsAggressive - TRUE if the animations to be played are considered aggressive.
* * @param: bool UsingBed - TRUE if the animation is going to be played on a bed, which will filter out standing animations and allow BedOnly tagged animations.
* * @param: bool RestrictAggressive - If TRUE, only return aggressive animations if IsAggressive=true and none if IsAggressive=false.
* * @param: string Tags - A comma separated list of animation tags you want to use as a filter for the returned animations. (E.g. "Leito,Vaginal,Missionary", to get the animation from Leito, in missionary position, where the mouth has some importance. All or just one of the tags? Depends on the value of the parameter RequireAll). WARNING! To prevent issues don't add gender tags or the "Aggressive" tag to this parameter.
* * @param: string TagSuppress [OPTIONAL] - A comma separated list of animation tags you DO NOT want present on any of the returned animations. (E.g. "LeadIn" will filter out all the animations that have the tag "LeadIn"). WARNING! To prevent issues don't add the "Aggressive" tag to this parameter.
* * @param: bool RequireAll [OPTIONAL True by default] - If TRUE, all tags in the provided "string Tags" list must be present in an animation to be returned. When FALSE only one tag in the list is needed. (E.g. If the tags are "oral,Vaginal" and RequireAll is set to TRUE, then the animations found will have BOTH Oral and Vaginal tags; if RequireAll is set to FALSE, then the animation swill have just one of the two tags, and also both together will be returned in the list.)
* * @return: sslBaseAnimation[] - An array of animations that fit the provided search arguments.
* * Note about the parameters "IsAggressive" and "RestrictAggressive", they work together and the logic is the following one:
* *  IsAggressive=True, RestrictAggressive=False  --> ONLY aggressive animations are used
* *  IsAggressive=True, RestrictAggressive=True  --> Only animations that are NOT aggressive are used
* *  IsAggressive=False, RestrictAggressive=False  --> Both aggressive and not aggressive animations are used
* *  IsAggressive=False, RestrictAggressive=True  --> Only animations that are NOT aggressive are used
*/;
sslBaseAnimation[] function GetAnimationsByDefaultTags(int Males, int Females, bool IsAggressive = false, bool UsingBed = false, bool RestrictAggressive = true, string Tags, string TagsSuppressed = "", bool RequireAll = true)
	return AnimSlots.GetByDefaultTags(Males, Females, IsAggressive, UsingBed, RestrictAggressive, Tags, TagsSuppressed, RequireAll)
endFunction

;/* GetAnimationByName
* * Get a single animation by name. Ignores if a user has the animation enabled or not.
* * The animation will NOT include creatures. Use GetCreatureAnimationByName() if you want an animation that is including Creatures.
* * 
* * @param: string FindName - The name of an animation as seen in the SexLab MCM.
* * @return: sslBaseAnimation - The animation whose name matches, if found.
*/;
sslBaseAnimation function GetAnimationByName(string FindName)
	return AnimSlots.GetByName(FindName)
endFunction

;/* GetAnimationByRegistry
* * Get a single animation by it's unique registry name (the ID of the animation.) Ignores if a user has the animation enabled or not.
* * The animation will NOT include creatures. Use GetCreatureAnimationByRegistry() if you want an animation that is including Creatures.
* * 
* * @param: string Registry - The unique registry name of the animation. (string property Registry on any animation)
* * @return: sslBaseAnimation - The animation whose registry matches, if found.
*/;
sslBaseAnimation function GetAnimationByRegistry(string Registry)
	return AnimSlots.GetByRegistrar(Registry)
endFunction

;/* FindAnimationByName
* * Find the registration slot number that an animation currently occupies.
* * 
* * @param: string FindName - The name of an animation as seen in the SexLab MCM.
* * @return: int - The registration slot number for the animation.
*/;
int function FindAnimationByName(string FindName)
	return AnimSlots.FindByName(FindName)
endFunction

;/* GetAnimationCount
* * Get the number of registered animations.
* * 
* * @param: bool IgnoreDisabled [OPTIONAL true by default] - If TRUE, only count animations that are enabled in the SexLab MCM, otherwise count all.
* * @return: int - The total number of animations.
*/;
int function GetAnimationCount(bool IgnoreDisabled = true)
	return AnimSlots.GetCount(IgnoreDisabled)
endFunction

;/* MakeAnimationGenderTag
* * Create a gender tag from a list of actors, in order: F for female, M for male, C for creatures
* * All animations in SexLab have this GenderTag automatically generated based on the animation definition.
* * 
* * @param: Actor[] Positions - A list of actors to create a tag for
* * @return: string - A usable tag for filtering animations by tag and gender. If given an array with 1 male and 1 female, the return will be "FM"
* *
* * EXAMPLE: if the animation expects in the first position is Female, and in the next two positions are a Male, you will get "FMM" as result.
*/;
string function MakeAnimationGenderTag(Actor[] Positions)
	return ActorLib.MakeGenderTag(Positions)
endFunction

;/* GetGenderTag
* * Create a gender tag from specified amount of genders, in order: F for female, M for male, C for creatures
* * @param: int Females - The number of females (F) for the gender tag.
* * @param: int Males - The number of males (M) for the gender tag.
* * @param: int Creatures - The number of creatures (C) for the gender tag.
* * @return: string - A usable tag for filtering animations by tag and gender. If given an array with 2 male and 1 female, the return will be "FMM"
*/;
string function GetGenderTag(int Females = 0, int Males = 0, int Creatures = 0)
	return ActorLib.GetGenderTag(Females, Males, Creatures)
endFunction

;/* MergeAnimationLists
* * Combine 2 separate lists of animations into a single list, removing any duplicates between the two. (Works with both regular and creature animations.)
* * Warning if in the first list there are None values they are kept (duplicates are not removed), and if in the second list there is at least one None value, then at least one None value wil be in the resulting list
* * 
* * @param: sslBaseAnimation[] List1 - The first array of animations to combine.
* * @param: sslBaseAnimation[] List2 - The second array of animations to combine.
* * @return: sslBaseAnimation[] - All the animations from List1 and List2, with any duplicates between them removed.
*/;
sslBaseAnimation[] function MergeAnimationLists(sslBaseAnimation[] List1, sslBaseAnimation[] List2)
	return sslUtility.MergeAnimationLists(List1, List2)
endFunction

;/* RemoveTagged
* * Removes any animations from an existing list that contain one of the provided animation tags. (Works with both regular and creature animations.)
* * 
* * @param: sslBaseAnimation[] Anims - A list of animations you want to filter certain tags out of.
* * @param: string Tags - A comma separated list of animation tags to check Anim's element for, if any of the tags given are present, the animation won't be included in the return.
* * @return: sslBaseAnimation[] - All the animations from Anims that did not have any of the provided tags.
*/;
sslBaseAnimation[] function RemoveTagged(sslBaseAnimation[] Anims, string Tags)
	return sslUtility.RemoveTaggedAnimations(Anims, PapyrusUtil.StringSplit(Tags))
endFunction

;/* CountTag
* * Counts the number of animations in the given array that contain one of provided animation tags. (Works with both regular and creature animations.)
* * 
* * @param: sslBaseAnimation[] Anims - A list of animations you want to check for tags on.
* * @param: string Tags - A comma separated list of animation tags.
* * @return: int - The number of animations from Anims that contain one of the tags provided.
*/;
int function CountTag(sslBaseAnimation[] Anims, string Tags)
	return AnimSlots.CountTag(Anims, Tags)
endFunction

;/* CountTagUsage
* * Counts the number of animations in the registry that contain one of provided animation tags.
* * 
* * @param: string Tags - A comma separated list of animation tags.
* * @return: int - The number of animations from Anims that contain one of the tags provided.
*/;
int function CountTagUsage(string Tags, bool IgnoreDisabled = true)
	return AnimSlots.CountTagUsage(Tags, IgnoreDisabled)
endFunction

int function CountCreatureTagUsage(string Tags, bool IgnoreDisabled = true)
	return CreatureSlots.CountTagUsage(Tags, IgnoreDisabled)
endFunction

;/* GetAllAnimationTags
* * Get a list of all unique tags contained in a set of registered animations.
* * see also: GetAllCreatureAnimationTags, GetAllBothAnimationTags, GetAllAnimationTagsInArray
* * 
* * @param: int ActorCount - The number of actors the animations checked should be intended for. -1 to check all animations regardless of the number of positions.
* * @param: bool IgnoreDisabled - Whether to ignore tags from animations that have been disabled by the user or not. Default value of TRUE will ignore disabled animations.
* * @return: string[] - An alphabetically sorted string array of all unique tags found in the matching animations. 
*/;
string[] function GetAllAnimationTags(int ActorCount = -1, bool IgnoreDisabled = true)
	return AnimSlots.GetAllTags(ActorCount, IgnoreDisabled)
endFunction


;/* GetAllAnimationTagsInArray
* * Get a list of all unique tags contained in an arbitrary list of provided animations. alias to sslUtility.
* * see also: GetAllAnimationTags, GetAllCreatureAnimationTags, GetAllBothAnimationTags
* * 
* * @param: sslBaseAnimation[] - The array of animation objects you want a list of tags for.
* * @return: string[] - An alphabetically sorted string array of all unique tags found in the provided animations. 
*/;
string[] function GetAllAnimationTagsInArray(sslBaseAnimation[] List)
	return sslUtility.GetAllAnimationTagsInArray(List)
endFunction

;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#  ^^^                                                    END ANIMATION FUNCTIONS                                                    ^^^  #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#

;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#                                                        BEGIN CREATURES FUNCTIONS                                                        #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#


;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#  About RaceTypes                                                                                                                        #
;#  SexLab uses some special global identifiers to identify variants of Races.                                                             #
;#  This identifier is called RaceKey. A RaceKey is used to group all creature Races that are similar and can be used with the same        #
;#  creature animation.                                                                                                                    #
;#                                                                                                                                         #
;#  For Exmaple: the RaceKey "Dogs" contains the races:                                                                                    #
;#  "DogRace", "DogCompanionRace", "MG07DogRace", "DA03BarbasDogRace", "DLC1HuskyArmoredCompanionRace", "DLC1HuskyArmoredRace",            #
;#  "DLC1HuskyBareCompanionRace", and "DLC1HuskyBareRace"                                                                                  #
;#                                                                                                                                         #
;#  You can always quickly get the RaceKey from an actor by using the functions:                                                           #
;#    String raceID = MiscUtil.GetActorRaceEditorID(anActor)                                                                               #
;#    String raceKey = sslCreatureAnimationSlots.GetRaceKeyByID(raceID)                                                                    #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#


;/* GetCreatureAnimationsByRace
* * Gets an array of creature animations for a provided creature's race.
* *  
* * @param: int ActorCount - The total number of actors, between 1 and 5 the returned animations should be intended for.
* * @param: Race RaceRef - The Race the returned animations should be usable by.
* * @return: sslBaseAnimation[] - An array of animations that fit the provided search arguments.
*/;
sslBaseAnimation[] function GetCreatureAnimationsByRace(int ActorCount, Race RaceRef)
	return CreatureSlots.GetByRace(ActorCount, RaceRef)
endFunction

;/* GetCreatureAnimationsByRaceTags
* * Gets an array of creature animations that have a specified set of tags AND are valid for a specific creatures race.
* *
* * @param: int ActorCount - The total number of actors, between 1-5 the returned animations should be intended for.
* * @param: Race RaceRef - The race the returned animations should be usable by.
* * @param: string Tags - A comma separated list of animation tags you want to use as a filter for the returned animations.
* * @param: string TagSuppress - A comma separated list of animation tags you DO NOT want present on any of the returned animations.
* * @param: bool RequireAll - If TRUE, all tags in the provided "string Tags" list must be present in an animation to be returned. When FALSE only one tag in the list is needed.
* * @return: sslBaseAnimation[] - An array of animations that fit the provided search arguments.
*/;
sslBaseAnimation[] function GetCreatureAnimationsByRaceTags(int ActorCount, Race RaceRef, string Tags, string TagSuppress = "", bool RequireAll = true)
	return CreatureSlots.GetByRaceTags(ActorCount, RaceRef, Tags, TagSuppress, RequireAll)
endFunction

;/* GetCreatureAnimationsByRaceGenders
* * Gets an array of creature animations for a specific number of actors, creature race, and optionally gender.
* * 
* * @param: int ActorCount - The total number of actors, between 1 and 5 the returned animations should be intended for.
* * @param: Race RaceRef - The race the returned animations should be usable by.
* * @param: int MaleCreatures [OPTIONAL] - The number of male creatures the animation should use. Ignored if user does not have creature genders enabled or ForceUse is set to TRUE.
* * @param: int FemaleCreatures [OPTIONAL] - The number of female creatures the animation should use. Ignored if user does not have creature genders enabled or ForceUse is set to TRUE.
* * @param: bool ForceUse [OPTIONAL false by default] - If left as the default value of FALSE, the MaleCreatures and FemaleCreatures argument will be ignored when creature genders aren't enabled by user.
* * @return: sslBaseAnimation[] - An array of animations that fit the provided search arguments.
*/;
sslBaseAnimation[] function GetCreatureAnimationsByRaceGenders(int ActorCount, Race RaceRef, int MaleCreatures = 0, int FemaleCreatures = 0, bool ForceUse = false)
	return CreatureSlots.GetByRaceGenders(ActorCount, RaceRef, MaleCreatures, FemaleCreatures, ForceUse)
endFunction

;/* GetCreatureAnimationsByRaceGendersTags
* * Gets an array of creature animations for a specific number of actors, creature race, and optionally gender.
* * 
* * @param: int ActorCount - The total number of actors, between 1 and 5 the returned animations should be intended for.
* * @param: Race RaceRef - The race the returned animations should be usable by.
* * @param: int MaleCreatures [OPTIONAL] - The number of male creatures the animation should use. Ignored if user does not have creature genders enabled or ForceUse is set to TRUE.
* * @param: int FemaleCreatures [OPTIONAL] - The number of female creatures the animation should use. Ignored if user does not have creature genders enabled or ForceUse is set to TRUE.
* * @param: string Tags - A comma separated list of animation tags you want to use as a filter for the returned animations. WARNING! To prevent issues don't add gender tags to this parameter.
* * @param: string TagSuppress - A comma separated list of animation tags you DO NOT want present on any of the returned animations.
* * @param: bool RequireAll - If TRUE, all tags in the provided "string Tags" list must be present in an animation to be returned. When FALSE only one tag in the list is needed.
* * @return: sslBaseAnimation[] - An array of animations that fit the provided search arguments.
*/;
sslBaseAnimation[] function GetCreatureAnimationsByRaceGendersTags(int ActorCount, Race RaceRef, int MaleCreatures = 0, int FemaleCreatures = 0, string Tags, string TagSuppress = "", bool RequireAll = true)
	return CreatureSlots.GetByRaceGendersTags(ActorCount, RaceRef, MaleCreatures, FemaleCreatures, Tags, TagSuppress, RequireAll)
endFunction

;/* GetCreatureAnimationsByRaceKey
* * Gets an array of creature animations that require a specific number of actors and race type.
* * 
* * @param: int ActorCount - The total number of actors, between 1 and 5 the returned animations should be intended for.
* * @param: string RaceKey - The creature race sexlab identifier used to identify animations meant for this race.
* * @return: sslBaseAnimation[] - An array of animations that fit the provided search arguments.
*/;
sslBaseAnimation[] function GetCreatureAnimationsByRaceKey(int ActorCount, string RaceKey)
	return CreatureSlots.GetByRaceKey(ActorCount, RaceKey)
endFunction

;/* GetCreatureAnimationsByRaceKeyTags
** Gets an array of creature animations that have a specified set of tags AND are valid for a specific creature race type.
* *
* * @param: int ActorCount - The total number of actors, between 1-5 the returned animations should be intended for.
* * @param: string RaceKey - The creature race sexlab identifier used to identify animations meant for this race.
* * @param: string Tags - A comma separated list of animation tags you want to use as a filter for the returned animations.
* * @param: string TagSuppress - A comma separated list of animation tags you DO NOT want present on any of the returned animations.
* * @param: bool RequireAll - If TRUE, all tags in the provided "string Tags" list must be present in an animation to be returned. When FALSE only one tag in the list is needed.
* * @return: sslBaseAnimation[] - An array of animations that fit the provided search arguments.
*/;
sslBaseAnimation[] function GetCreatureAnimationsByRaceKeyTags(int ActorCount, string RaceKey, string Tags, string TagSuppress = "", bool RequireAll = true)
	return CreatureSlots.GetByRaceKeyTags(ActorCount, RaceKey, Tags, TagSuppress, RequireAll)
endFunction

;/* GetCreatureAnimationsByRaceKey
* * Gets an array of creature animations that require a specific number of actors and race type.
* * Can handle multiple creature races on the same animation
* * 
* * @param: int ActorCount - The total number of actors, between 1 and 5 the returned animations should be intended for.
* * @param: Actor[] Positions - An array of 1 to 5 actors you intend to use the resulting animations with. At least one of the actor on the array must be creature type 
* * @return: sslBaseAnimation[] - An array of animations that fit the provided search arguments.
*/;
sslBaseAnimation[] function GetCreatureAnimationsByActors(int ActorCount, Actor[] Positions)
	return CreatureSlots.GetByCreatureActors(ActorCount, Positions)
endFunction

;/* GetCreatureAnimationsByRaceKeyTags
** Gets an array of creature animations that have a specified set of tags AND are valid for the specific actors in the Position parameter.
* * Can handle multiple creature races on the same animation
* *
* * @param: int ActorCount - The total number of actors, between 1-5 the returned animations should be intended for.
* * @param: Actor[] Positions - An array of 1 to 5 actors you intend to use the resulting animations with. At least one of the actor on the array must be creature type 
* * @param: string Tags - A comma separated list of animation tags you want to use as a filter for the returned animations. WARNING! To prevent issues don't add Race tags to this parameter.
* * @param: string TagSuppress - A comma separated list of animation tags you DO NOT want present on any of the returned animations.
* * @param: bool RequireAll - If TRUE, all tags in the provided "string Tags" list must be present in an animation to be returned. When FALSE only one tag in the list is needed.
* * @return: sslBaseAnimation[] - An array of animations that fit the provided search arguments.
*/;
sslBaseAnimation[] function GetCreatureAnimationsByActorsTags(int ActorCount, Actor[] Positions, string Tags, string TagSuppress = "", bool RequireAll = true)
	return CreatureSlots.GetByCreatureActorsTags(ActorCount, Positions, Tags, TagSuppress, RequireAll)
endFunction

;/* GetCreatureAnimationByName
** Gets a single creature animation by name. Ignores if a user has the animation enabled or not.
* *
* * @param: string FindName - The name of an animation as seen in the SexLab MCM.
* * @return: sslBaseAnimation - The creature animation whose name matches, if found.
*/;
sslBaseAnimation function GetCreatureAnimationByName(string FindName)
	return CreatureSlots.GetByName(FindName)
endFunction

;/* GetCreatureAnimationByRegistry
* * Gets a single creature animation by it's unique registry name. Ignores if a user has the animation enabled or not.
* *
* * @param: string Registry - The unique registry name of the animation. (string property Registry on any animation)
* * @return: sslBaseAnimation - The creature animation whose registry matches, if found.
*/;
sslBaseAnimation function GetCreatureAnimationByRegistry(string Registry)
	return CreatureSlots.GetByRegistrar(Registry)
endFunction

;/* HasCreatureRaceAnimation
* * Checks if a given creature Race has any usable animations currently registered for any valid race key's it is registered under.
* * 
* * @param: Race CreatureRace - The race of the creature you want to check for valid creature animations to use.
* * @param: int ActorCount [OPTIONAL] - Any optional parameter to have it check for a specific number of actor positions in the potential animations. -1 (default) to ignore number of positions.
* * @param: int Gender [OPTIONAL] - Any optional parameter to have it check if a specific creature gender has an animation. -1 (default) to ignore, 2 for Male, 3 for Female.
* * @return: bool - TRUE if the given CreatureRace has any valid and enabled animations for ActorCount positions.
*/;
bool function HasCreatureRaceAnimation(Race CreatureRace, int ActorCount = -1, int Gender = -1)
	return CreatureSlots.RaceHasAnimation(CreatureRace, ActorCount, Gender)
endFunction

;/* HasCreatureRaceKeyAnimation
* * Checks if a specific RaceKey has any usable animations currently registered.
* * 
* * @param: string RaceKey - The creature race sexlab identifier used to identify animations meant for this race.
* * @param: int ActorCount [OPTIONAL] - Any optional parameter to have it check for a specific number of actor positions in the potential animations. -1 (default) to ignore number of positions.
* * @param: int Gender [OPTIONAL] - Any optional parameter to have it check if a specific creature gender has an animation. -1 (default) to ignore, 2 for Male Creature, 3 for Female Creature.
* * @return: bool - TRUE if the given CreatureRace has any valid and enabled animations for ActorCount positions.
*/;
bool function HasCreatureRaceKeyAnimation(string RaceKey, int ActorCount = -1, int Gender = -1)
	return CreatureSlots.RaceKeyHasAnimation(RaceKey, ActorCount, Gender)
endFunction

;/* AllowedCreature
* * Checks if a given creature Race is able to have animations with SexLab.
* * 
* * @param: Race CreatureRace - The race to check if allowed to animate.
* * @return: bool - TRUE if the creature has a valid enabled animation AND that creature animations are enabled.
*/;
bool function AllowedCreature(Race CreatureRace)
	return CreatureSlots.AllowedCreature(CreatureRace)
endFunction

;/* 
* * Checks if two given creature's Races share the same RaceKey, and are likely to have an animation that can play both together.
* * 
* * @param: Race CreatureRace - A creature race to check for a matching RaceKey with the other.
* * @param: Race CreatureRace2 - The other creature race to check for a matching RaceKey with the previous one.
* * @return: bool - TRUE if they do have a shared RaceKey.
*/;
bool function AllowedCreatureCombination(Race CreatureRace, Race CreatureRace2)
	return CreatureSlots.AllowedCreatureCombination(CreatureRace, CreatureRace2)
endFunction

;/* GetAllCreatureAnimationTags
* * Get a list of all unique tags contained in a set of registered creature animations.
* * see also: GetAllAnimationTags, GetAllBothAnimationTags, GetAllAnimationTagsInArray
* * 
* * @param: int ActorCount - The number of actors the animations checked should be intended for. -1 to check all animations regardless of the number of positions.
* * @param: bool IgnoreDisabled - Whether to ignore tags from animations that have been disabled by the user or not. Default value of TRUE will ignore disabled animations.
* * @return: string[] - An alphabetically sorted string array of all unique tags found in the matching animations. 
*/;
string[] function GetAllCreatureAnimationTags(int ActorCount = -1, bool IgnoreDisabled = true)
	return CreatureSlots.GetAllTags(ActorCount, IgnoreDisabled)
endFunction

;/* GetAllBothAnimationTags
* * Combines the results of both GetAllAnimationTags() and GetAllCreatureAnimationTags(). 
* * see also: GetAllAnimationTags, GetAllCreatureAnimationTags, GetAllAnimationTagsInArray
* * 
* * @param: int ActorCount - The number of actors the animations checked should be intended for. -1 to check all animations regardless of the number of positions.
* * @param: bool IgnoreDisabled - Whether to ignore tags from animations that have been disabled by the user or not. Default value of TRUE will ignore disabled animations.
* * @return: string[] - An alphabetically sorted string array of all unique tags found in the matching animations. 
*/;
string[] function GetAllBothAnimationTags(int ActorCount = -1, bool IgnoreDisabled = true)
	string[] Output = PapyrusUtil.MergeStringArray(AnimSlots.GetAllTags(ActorCount, IgnoreDisabled), CreatureSlots.GetAllTags(ActorCount, IgnoreDisabled))
	PapyrusUtil.SortStringArray(Output)
	return Output
endFunction

;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#  ^^^                                                    END CREATURES FUNCTIONS                                                    ^^^  #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#

;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#                                                          BEGIN VOICE FUNCTIONS                                                          #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#

;/* PickVoice
* * @RETURNS an actors saved voice object if the user has the "reuse voices" option enabled, otherwise random for gender.
* * 
* * @param: Actor ActorRef - The actor to pick a voice for.
* * @return: sslBaseVoice - A suitable voice object for the actor to use.
*/;
sslBaseVoice function PickVoice(Actor ActorRef)
	return VoiceSlots.PickVoice(ActorRef)
endFunction
sslBaseVoice function GetVoice(Actor ActorRef) ; Alias of PickVoice()
	return VoiceSlots.PickVoice(ActorRef)
endFunction

;/* 
* * Saves a given voice to an actor. Once saved the function GetSavedVoice() will always return their saved voice,
* * PickVoice() / GetVoice() will also return this voice for the actor if the user has the "reuse voices" option enabled 
* * 
* * @param: Actor ActorRef - The actor to pick a voice for.
* * @return: sslBaseVoice - A suitable voice object for the actor to use. Does not have to be a registered SexLab voice object.
*/;
function SaveVoice(Actor ActorRef, sslBaseVoice Saving)
	VoiceSlots.SaveVoice(ActorRef, Saving)
endFunction

;/* ForgetVoice
* * Removes any saved voice on an actor.
* * 
* * @param: Actor ActorRef - The actor you want to remove a saved voice from.
*/;
function ForgetVoice(Actor ActorRef)
	VoiceSlots.ForgetVoice(ActorRef)
endFunction

;/* GetSavedVoice
* * @RETURNS an actors saved voice object, if they have one saved.
* * 
* * @param: Actor ActorRef - The actor get the saved voice for.
* * @return: sslBaseVoice - The actors saved voice object if one exists, otherwise NONE.
*/;
sslBaseVoice function GetSavedVoice(Actor ActorRef)
	return VoiceSlots.GetSaved(ActorRef)
endFunction

;/* HasCustomVoice
* * Checks if the given Actor has a custom, non-registered SexLab voice.
* * 
* * @param: Actor ActorRef - The actor to check.
* * @return: sslBaseVoice - A suitable voice object for the actor to use.
*/;
bool function HasCustomVoice(Actor ActorRef)
	return VoiceSlots.HasCustomVoice(ActorRef)
endFunction

;/* GetVoiceByGender
* * Get a random voice for a given gender.
* * 
* * @param: int Gender - The gender number to get a random voice for. 0 = male 1 = female.
* * @return: sslBaseVoice - A suitable voice object for the given actor gender.
*/;
sslBaseVoice function GetVoiceByGender(int Gender)
	return VoiceSlots.PickGender(Gender)
endFunction

;/* GetVoicesByGender
* * Get an array of voices for a given gender.
* * 
* * @param: int Gender - The gender number to get a random voice for. 0 = male 1 = female.
* * @return: sslBaseVoice[] - An array of suitable voices for the given actor gender.
*/;
sslBaseVoice[] function GetVoicesByGender(int Gender)
	return VoiceSlots.GetAllGender(Gender)
endFunction

;/* GetVoiceByName
* * Get a single voice object by name. Ignores if a user has the voice enabled or not.
* * 
* * @param: string FindName - The name of an voice object as seen in the SexLab MCM.
* * @return: sslBaseVoice - The voice object whose name matches, if found.
*/;
sslBaseVoice function GetVoiceByName(string FindName)
	return VoiceSlots.GetByName(FindName)
endFunction

;/* FindVoiceByName
* * Find the registration slot number that an voice currently occupies.
* * 
* * @param: string FindName - The name of an voice as seen in the SexLab MCM.
* * @return: int - The registration slot number for the voice.
*/;
int function FindVoiceByName(string FindName)
	return VoiceSlots.FindByName(FindName)
endFunction

;/* GetVoiceBySlot
* * @RETURNS a voice object by it's registration slot number.
* * 
* * @param: int slot - The slot number of the voice object.
* * @return: sslBaseVoice - The voice object that currently occupies that slot, NONE if nothing occupies it.
*/;
sslBaseVoice function GetVoiceBySlot(int slot)
	return VoiceSlots.GetBySlot(slot)
endFunction

;/* GetVoiceByTags
* * Selects a single voice from a set of given tag options.
* * 
* * @param: string Tags - A comma separated list of voice tags you want to use as a filter.
* * @param: string TagSuppress - A comma separated list of voice tags you DO NOT want present on the returned voice.
* * @param: bool RequireAll - If TRUE, all tags in the provided "string Tags" list must be present in an voice to be returned. When FALSE only one tag in the list is needed.
* * @return: sslBaseVoice - A randomly selected voice object among any that match the provided search arguments.
*/;
sslBaseVoice function GetVoiceByTags(string Tags, string TagSuppress = "", bool RequireAll = true)
	return VoiceSlots.GetByTags(Tags, TagSuppress, RequireAll)
endFunction

;/* GetVoicesByTags
* * Selects a single voice from a set of given tag options.
* * 
* * @param: string Tags - A comma separated list of voice tags you want to use as a filter.
* * @param: string TagSuppress - A comma separated list of voice tags you DO NOT want present on the returned voice.
* * @param: bool RequireAll - If TRUE, all tags in the provided "string Tags" list must be present in an voice to be returned. When FALSE only one tag in the list is needed.
* * @return: sslBaseVoice[] - An array of voices that match the provided search arguments.
*/;
sslBaseVoice[] function GetVoicesByTags(string Tags, string TagSuppress = "", bool RequireAll = true)
	return VoiceSlots.GetAllByTags(Tags, TagSuppress, RequireAll)
endFunction

;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#  ^^^                                                      END VOICE FUNCTIONS                                                      ^^^  #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#

;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#                                                        BEGIN EXPRESSION FUNCTION                                                        #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#

;/* PickExpression
* * Selects a random expression that fits the provided criteria. A slightly different method of having the expression compared to PickExpressionByStatus.
* * 
* * @param: Actor ActorRef - The actor who will be using this expression.
* * @param: Actor VictimRef - The actor considered a victim in an aggressive scene.
* * @return: sslBaseExpression - A randomly selected expression object among any that meet the needed criteria.
*/;
sslBaseExpression function PickExpression(Actor ActorRef, Actor VictimRef = none)
	return ExpressionSlots.PickByStatus(ActorRef, (VictimRef && VictimRef == ActorRef), (VictimRef && VictimRef != ActorRef))
endFunction

;/* PickExpressionByStatus
* * Selects a random expression that fits the provided criteria.
* * 
* * @param: Actor ActorRef - The actor who will be using this expression and the following conditions apply to.
* * @param: bool IsVictim - Set to TRUE if the actor is considered the victim in an aggressive scene.
* * @param: bool IsAggressor - Set to TRUE if the actor is considered the aggressor in an aggressive scene.
* * @return: sslBaseExpression - A randomly selected expression object among any that meet the needed criteria.
*/;
sslBaseExpression function PickExpressionByStatus(Actor ActorRef, bool IsVictim = false, bool IsAggressor = false)
	return ExpressionSlots.PickByStatus(ActorRef, IsVictim, IsAggressor)
endFunction

;/* GetExpressionsByStatus
* * Selects a random expression that fits the provided criteria.
* * 
* * @param: Actor ActorRef - The actor who will be using this expression and the following conditions apply to.
* * @param: bool IsVictim - Set to TRUE if the actor is considered the victim in an aggressive scene.
* * @param: bool IsAggressor - Set to TRUE if the actor is considered the aggressor in an aggressive scene.
* * @return: sslBaseExpression[] - An array of expressions that meet the needed criteria.
*/;
sslBaseExpression[] function GetExpressionsByStatus(Actor ActorRef, bool IsVictim = false, bool IsAggressor = false)
	return ExpressionSlots.GetByStatus(ActorRef, IsVictim, IsAggressor)
endFunction

;/* PickExpressionByTag
* * Selects a single expression from based on a single tag.
* * 
* * @param: Actor ActorRef - The actor who will be using this expression and the following conditions apply to.
* * @param: string Tags - A single expression tag to use as the filter when picking randomly. Warning, it is not possible to use a comma separated list of tags.
* * @return: sslBaseExpression - A randomly selected expression object among any that have the provided tag.
*/;
sslBaseExpression function PickExpressionsByTag(Actor ActorRef, string Tag)
	sslBaseExpression[] Found =  ExpressionSlots.GetByTag(Tag, ActorRef.GetLeveledActorBase().GetSex() == 1)
	if Found && Found.Length > 0
		return Found[(Utility.RandomInt(0, (Found.Length - 1)))]
	endIf
	return none
endFunction

;/* GetExpressionsByTag
* * Selects a single expression from based on a single tag.
* * 
* * @param: Actor ActorRef - The actor who will be using this expression and the following conditions apply to.
* * @param: string Tags - A single expression tag to use as the filter when picking randomly. Warning, it is not possible to use a comma separated list of tags.
* * @return: sslBaseExpression[] - An array of expressions that have the provided tag.
*/;
sslBaseExpression[] function GetExpressionsByTag(Actor ActorRef, string Tag)
	return ExpressionSlots.GetByTag(Tag, ActorRef.GetLeveledActorBase().GetSex() == 1)
endFunction

;/* GetExpressionByName
* * Get a single expression object by name. Ignores if a user has the expression enabled or not.
* * 
* * @param: string FindName - The name of an expression object as seen in the SexLab MCM.
* * @return: sslBaseExpression - The expression object whose name matches, if found.
*/;
sslBaseExpression function GetExpressionByName(string findName)
	return ExpressionSlots.GetByName(findName)
endFunction

;/* FindExpressionByName
* * Find the registration slot number that an expression currently occupies.
* * 
* * @param: string FindName - The name of an expression as seen in the SexLab MCM.
* * @return: int - The registration slot number for the expression.
*/;
int function FindExpressionByName(string findName)
	return ExpressionSlots.FindByName(findName)
endFunction

;/* GetExpressionBySlot
* * @RETURNS a expression object by it's registration slot number.
* * 
* * @param: int slot - The slot number of the expression object.
* * @return: sslBaseExpression - The expression object that currently occupies that slot, NONE if nothing occupies it.
*/;
sslBaseExpression function GetExpressionBySlot(int slot)
	return ExpressionSlots.GetBySlot(slot)
endFunction

;/* OpenMouth
* * Opens an actors mouth.
* * Mirrored function of a global in sslBaseExpressions. Is advised to use, in your scripts, the global one instead of this one.
* * Example:
* * SexLab.OpenMouth(myActor)
* *   is equivalent, but less performat (because there is an extra call) compared to
* * sslBaseExpression.OpenMouth(myActor)
* * 
* * @param: Actor ActorRef - The actors whose mouth should open.
*/;
function OpenMouth(Actor ActorRef)
	if ActorRef
		int i
		while i < ThreadSlots.Threads.Length
			int ActorSlot = Threads[i].FindSlot(ActorRef)
			if ActorSlot != -1
				Threads[i].ActorAlias[ActorSlot].ForceOpenMouth = True
			endIf
			i += 1
		endwhile
		sslBaseExpression.OpenMouth(ActorRef)
	endIf
endFunction

;/* CloseMouth
* * Closes an actors mouth.
* * Mirrored function of a global in sslBaseExpressions. Is advised to use, in your scripts, the global one instead of this one.
* *
* * @param: Actor ActorRef - The actors whose mouth should open.
*/;
function CloseMouth(Actor ActorRef)
	if ActorRef
		int i
		while i < ThreadSlots.Threads.Length
			int ActorSlot = Threads[i].FindSlot(ActorRef)
			if ActorSlot != -1
				Threads[i].ActorAlias[ActorSlot].ForceOpenMouth = False
			endIf
			i += 1
		endwhile
		sslBaseExpression.CloseMouth(ActorRef)
	endIf
endFunction

;/* IsMouthOpen
* * Checks if an actor's mouth is currently considered open or not.
* * Mirrored function of a global in sslBaseExpressions. Is advised to use, in your scripts, the global one instead of this one.
* *
* * @param: Actor ActorRef - The actors whose may or may not currently be open.
* * @return: bool - TRUE if the actors mouth appears to be in an open state.
*/;
bool function IsMouthOpen(Actor ActorRef)
	return sslBaseExpression.IsMouthOpen(ActorRef)
endFunction

;/* GetCurrentMFG
* * Get an array with the mood, phonemes, and modifiers currently applied to the actor.
* * Mirrored function of a global in sslBaseExpressions. Is advised to use, in your scripts, the global one instead of this one.
* *
* * @param: Actor ActorRef - The actors whose expression values should be returned.
* * @return: float[] - An float array of Length 32 that match the format and structure of the Preset parameter in the ApplyPresetFloats function.
*/;
float[] function GetCurrentMFG(Actor ActorRef)
	return sslBaseExpression.GetCurrentMFG(ActorRef)
endFunction

;/* ClearMFG
* * Resets an actors mood, phonemes, and modifiers.
* * Mirrored function of a global in sslBaseExpressions. Is advised to use, in your scripts, the global one instead of this one.
* *
* * @param: Actor ActorRef - The actors whose expression should return to normal.
*/;
function ClearMFG(Actor ActorRef)
	sslBaseExpression.ClearMFG(ActorRef)
endFunction

;/* ClearPhoneme
* * Resets all of an actors phonemes to 0.
* * Mirrored function of a global in sslBaseExpressions. Is advised to use, in your scripts, the global one instead of this one.
* *
* * @param: Actor ActorRef - The actor to clear phonemes on.
*/;
function ClearPhoneme(Actor ActorRef)
	sslBaseExpression.ClearPhoneme(ActorRef)
endFunction

;/* ClearModifier
* * Resets all of an actors modifiers to 0.
* * Mirrored function of a global in sslBaseExpressions. Is advised to use, in your scripts, the global one instead of this one.
* *
* * @param: Actor ActorRef - The actor to clear modifiers on.
*/;
function ClearModifier(Actor ActorRef)
	sslBaseExpression.ClearModifier(ActorRef)
endFunction

;/* ApplyPresetFloats
* * Applies an array of values to an actor, automatically setting their phonemes, modifiers, and mood.
* * Mirrored function of a global in sslBaseExpressions. Is advised to use, in your scripts, the global one instead of this one.
* *
* * @param: Actor ActorRef - The actors to apply the preset to.
* * @param: float[] Preset - Must be a 32 length array. Each index corresponds to an MFG id. Values range from 0.0 to 1.0, with the exception of mood type.
* *                          Phonemes   0-15 = Preset[0]  to Preset[15]
* *                          Modifiers  0-13 = Preset[16] to Preset[29]
* *                          Mood Type       = Preset[30]
* *                          Mood Value      = Preset[31]
*/;
function ApplyPresetFloats(Actor ActorRef, float[] Preset)
	sslBaseExpression.ApplyPresetFloats(ActorRef, Preset)
endfunction

;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#  ^^^                                                    END EXPRESSION FUNCTIONS                                                   ^^^  #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#

;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#                                                           START HOOK FUNCTIONS                                                          #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;# ABOUT HOOKS IN SEXLAB                                                                                                                   #   
;#                                                                                                                                         #   
;# Hooks are one of the most powerful functions that yoiu can use in SexLab.                                                               #   
;# They are used to get ModEvents when something happens during a SexLab animations.                                                       #  
;#                                                                                                                                         #   
;# The utility functions provided by SexLab Framework (this script) are commodity functions used to grab all information you need          #  
;# from the data that is sent along with the ModEvent.                                                                                     #  
;#                                                                                                                                         #   
;# HOW TO USE HOOKS                                                                                                                        #  
;# Hooks can be fully defined with the TheadModel that you can get using SexLab.NewThread()                                                #  
;# They can also be quickly set by using the function StartSex().                                                                          #  
;#                                                                                                                                         #   
;# The basic idea is that you define a hook for a Thread, then register for the events generated by SexLab, and do whatever you want       #  
;# when the SexLab mod event is sent.                                                                                                      #  
;#                                                                                                                                         #   
;# SETTING AND USING HOOKS, A QUICK EXAMPLE.                                                                                               #  
;# Imagine that you want to do something when a SexLab animation that you are starting, will end.                                          #  
;# To do that you can define your hook, set it to the Thread, register for the AnimationEnd event, and execute the code you want.          #  
;#                                                                                                                                         #   
;# sslThreadModel Thread = SexLab.NewThread()                               <-- get a SexLab Thread                                        #
;# Thread.AddActor(firstActor)                                              <-- add the first actor to the Thread                          #
;# Thread.AddActor(secondActor)                                             <-- add the second actor to the Thread                         #
;# Thread.SetHook("Example")                                                <-- Define your Hook name                                      #
;# RegisterForModEvent("HookAnimationEnd_Example", "myAnimEndEventHandler") <-- Register for the event you want REALLY IMPORTANT!          #       
;# Thread.StartThread()                                                     <-- Start the SexLab animation and forget.                     #
;#                                                                                                                                         #
;#        <elsewhere in your script>                                                                                                       #
;#                                                                                                                                         #
;# Event myAnimEndEventHandler(int tid, bool HasPlayer)                     <-- This function we registered for will trigger automatically #
;#    sslThreadController Thread = SexLab.GetController(tid)                <-- Use the tid parameter to get the thread instance. It can   #
;#    Actor[] Positions = Thread.Positions ;[firstActor, secondActor]           manipulate or access different information from the scene. #
;# EndEvent                                                                                                                                #
;#                                                                                                                                         #
;# POSSIBLE EVENTS THAT CAN BE USED WITH HOOKS                                                                                             #
;#  AnimationStart - Sent when the animation starts                                                                                        #
;#  AnimationEnding - Sent when the animation is going to end, but the thread is still doing some final tasks                              #  
;#  AnimationEnd - Sent when the animation is fully terminated                                                                             # 
;#  LeadInStart - Sent when the animation starts and has a LeadIn                                                                          #
;#  LeadInEnd - Sent when a LeadIn animation ends                                                                                          #  
;#  StageStart - Sent for every Animation Stage that starts                                                                                #
;#  StageEnd - Sent for every Animation Stage that is completed                                                                            #
;#  OrgasmStart - Sent when an actor reaches the final stage                                                                               #
;#  OrgasmEnd - Sent when the final stage is completed                                                                                     #
;#  AnimationChange - Sent if the Animation that was playing is changed by the HotKey                                                      #
;#  PositionChange - Sent if the Positions of the animation (the involved actors) are changed                                              #
;#  ActorsRelocated - Sent if the actors gets a new alignment                                                                              #
;#  ActorChangeStart - Sent when the function ChangeActors is called                                                                       # 
;#  ActorChangeEnd - Sent when the replacement of actors, by the function ChangeActors is completed                                        # 
;#                                                                                                                                         # 
;#  LOCAL AND GLOBAL HOOKS                                                                                                                 # 
;#  And event is sent when a specific situation is generated by SexLab (See the previous list.)                                            # 
;#  For each possible situation, an event is sent to each specific hook with the format:                                                   # 
;#   Hook<Event Type>_<Hook Name>                                                                                                          # 
;#  And it is also sent a global hook with the event name:                                                                                 # 
;#   Hook<Event Type> (E.g. "HookAnimationStart")                                                                                          # 
;#                                                                                                                                         # 
;#  The global hook, can be used to globally register for events that are generated by all the animations.                                 # 
;#                                                                                                                                         # 
;#  NAMES AND PARAMETERS FOR THE EVENT HANDLER FUNCTION                                                                                    # 
;#  The function that you will create to receive the events should have this format:                                                       # 
;#   Event myEventHandler(int tid, bool hasPlayer)                                                                                         # 
;#  The name you use for the event handler function has to be the same you are registering for RegisterForModEvent                         # 
;#  The two parameters are the ID of the SexLab Thread Controller and a boolean that is TRUE is the Player is in any of the Positions.     # 
;#                                                                                                                                         # 
;#                                                                                                                                         # 
;#  There are other events that are sent by SexLab, but they are NOT related to Hooks.                                                     # 
;#   SexLabDisabled - Sent when SexLab is Disabled                                                                                         # 
;#   SexLabEnabled - Sent when SexLab is Enabled                                                                                           # 
;#   SexLabOrgasm - Sent when an actor has an orgasm:                                                                                      # 
;#    The parameters of the event are: the actor, the Full Enjoyment, and the total amount of orgasms for the current scene                # 
;#   SexLabSlotAnimations_<category> - Sent when a specific category of animations is registered:                                          # 
;#    Categories: Missionary, DoggyStyle, Cowgirl, Sideways, Standing, Anal, Oral, Boobjob, Foreplay, Lesbian, Footjob, Misc, Solo, Orgy   # 
;#   SexLabSlotAnimations - Sent when the animations require to be re-loaded and re-registered                                             # 
;#   SexLabSlotCreatureAnimations_<RaceKey> - Sent after each specific RaceKey is defined, one event for each RaceKey                      # 
;#   SexLabSlotCreatureAnimations - Sent when the Crature animations require to be re-loaded and re-registered                             # 
;#   SexLabRegisterCreaturekey - Sent when all the RaceKeys of SexLab are initialized (useful to add extra Races in the RaceKeys)          # 
;#   SexLabConfigClose - Sent when the MCM of SexLab is closed                                                                             # 
;#   SexLabReset - This ModEvent is sent when Sexlab executes a Setup or a System Cleanup                                                  # 
;#   SexLabSlotExpressions - Sent when the SexLab Expression are initialized, and can be used to register additional expressions           # 
;#   SexLabGameLoaded - Sent every time the player load a game                                                                             # 
;#   SexLabDebugMode - Sent when SexLab is set to Debug mode                                                                               # 
;#   SexLabLoadStrapons - This event is sent when the StraponsAre initialized or reloaded, can be used to add your custom strapons         # 
;#   SexLabStoppedActive - This ModEvent is sent when all the animations are stopped by force                                              # 
;#   SexLabSlotVoices - This ModEvent is sent when the SexLab Voices are initialized, and can be used to register additional voices        # 
;#                                                                                                                                         # 
;#-----------------------------------------------------------------------------------------------------------------------------------------#

;/* GetEnjoyment
* * Given a thread ID and an Actor, gives the enjoyment level for the actor between orgasms
* * NOTE: overkill? Don't use too much!
* *
* * @param: int tid - The thread id
* * @param: Actor ActorRef - The actors to look for the enjoyment
* * @return: int - the enjoyment calculated for the specific actor between orgasms when separated orgasms is enabled or the total enjoyment when separated orgasms is disabled
*/;
int function GetEnjoyment(int tid, Actor ActorRef)
	return ThreadSlots.GetController(tid).GetEnjoyment(ActorRef)
endfunction

;/* IsVictim
* * Used to understand is a specific actor is the Victim for the animation
* *
* * @param: int tid - The thread id
* * @param: Actor ActorRef - The actors to look to be a victim
* * @return: TRUE if the actor is a Victim for the animation, FALSE otherwise
*/;
bool function IsVictim(int tid, Actor ActorRef)
	return ThreadSlots.GetController(tid).IsVictim(ActorRef)
endFunction

;/* IsAggressor
* * Used to understand is a specific actor is the Aggressor for the animation
* *
* * @param: int tid - The thread id
* * @param: Actor ActorRef - The actors to look to be an aggressor
* * @return: TRUE if the actor is the Aggressor for the animation, FALSE otherwise
*/;
bool function IsAggressor(int tid, Actor ActorRef)
	return ThreadSlots.GetController(tid).IsAggressor(ActorRef)
endFunction

;/* IsUsingStrapon
* * Used to understand is a specific actor is using a strapon
* *
* * @param: int tid - The thread id
* * @param: Actor ActorRef - The actors to look for strapons
* * @return: TRUE if the actor is using a strapon for the animation, FALSE otherwise
*/;
bool function IsUsingStrapon(int tid, Actor ActorRef)
	return ThreadSlots.GetController(tid).ActorAlias(ActorRef).IsUsingStrapon()
endFunction

;/* PregnancyRisk
* * Used to understand if the actor can become pregnant by the sex animation
* *
* * @param: int tid - The thread id
* * @param: Actor ActorRef - The actors to look for pregnancy risk
* * @param: AllowFemaleCum [OPTIONAL false by default] - If set to TRUE then also the cum produced by a Female actor may impregnate
* * @param: AllowCreatureCum [OPTIONAL false by default] - If set to TRUE then also the cum produced by a Creature actor may impregnate
* * @return: TRUE if the actor can become pregnant, FALSE otherwise
*/;
bool function PregnancyRisk(int tid, Actor ActorRef, bool AllowFemaleCum = false, bool AllowCreatureCum = false)
	return ThreadSlots.GetController(tid).PregnancyRisk(ActorRef, AllowFemaleCum, AllowCreatureCum)
endfunction

;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#  ^^^                                                       END HOOK FUNCTIONS                                                      ^^^  #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#

;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#                                                           START STAT FUNCTIONS                                                          #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#

;/* RegisterStat
* * Adds a custom statistic in the list of Actor Statistics. If the stat already exists, then it does nothing.
* * 
* * @param: Name - the name of the statistic
* * @param: Value - The value for the statistic
* * @param: Preped - a string to put before the stat
* * @param: Append - a string to put after the stat
* * @return: an int that is the position of the newly created stat
*/;
int function RegisterStat(string Name, string Value, string Prepend = "", string Append = "")
	return Stats.RegisterStat(Name, Value, Prepend, Append)
endFunction

; Alters an existing stat that has already been registered from the above
function Alter(string Name, string NewName = "", string Value = "", string Prepend = "", string Append = "")
	Stats.Alter(Name, NewName, Value, Prepend, Append)
endFunction

;/* FindStat
* * Returns the index of a stat, or -1 if the stat does not exists
* * @param: the Name of the Statistics
* * @return: an int with the index of the stat, -1 if not found
*/;
int function FindStat(string Name)
	return Stats.FindStat(Name)
endFunction

;/* GetActorStat
* * Gets the value for a custom stat for the specified actor as a string
* *
* * @param: ActorRef, is the actor to get the value of the stat
* * @param: Name, is the name of the stat that will be get
* * @return: A string with the value of the stat for the actor, if the actor has no stat for the specified value, then the default value is returned
*/;
string function GetActorStat(Actor ActorRef, string Name)
	return Stats.GetStat(ActorRef, Name)
endFunction

;/* GetActorStatInt
* * Gets the value for a custom stat for the specified actor as an int
* *
* * @param: ActorRef, is the actor to get the value of the stat
* * @param: Name, is the name of the stat that will be get
* * @return: An int  with the value of the stat for the actor, if the actor has no stat for the specified value, then the default value is returned
*/;
int function GetActorStatInt(Actor ActorRef, string Name)
	return Stats.GetStatInt(ActorRef, Name)
endFunction

;/* GetActorStatFloat
* * Gets the value for a custom stat for the specified actor as a float
* *
* * @param: ActorRef, is the actor to get the value of the stat
* * @param: Name, is the name of the stat that will be get
* * @return: A float with the value of the stat for the actor, if the actor has no stat for the specified value, then the default value is returned
*/;
float function GetActorStatFloat(Actor ActorRef, string Name)
	return Stats.GetStatFloat(ActorRef, Name)
endFunction

;/* SetActorStat
* * Sets the value for a custom stat for the specified actor
* *
* * @param: ActorRef, is the actor to get the value of the stat
* * @param: Name, is the name of the stat that will be get
* * @return: The previous value for the stat (TO BE CONFIRMED!!!!)
*/;
string function SetActorStat(Actor ActorRef, string Name, string Value)
	return Stats.SetStat(ActorRef, Name, Value)
endFunction

;/* 
*/;
int function ActorAdjustBy(Actor ActorRef, string Name, int AdjustBy)
	return Stats.AdjustBy(ActorRef, Name, AdjustBy)
endFunction

;/* 
*/;
string function GetActorStatFull(Actor ActorRef, string Name)
	return Stats.GetStatFull(ActorRef, Name)
endFunction

;/* 
*/;
string function GetStatFull(string Name)
	return Stats.GetStatFull(PlayerRef, Name)
endFunction

;/* 
*/;
string function GetStat(string Name)
	return Stats.GetStat(PlayerRef, Name)
endFunction

;/* 
*/;
int function GetStatInt(string Name)
	return Stats.GetStatInt(PlayerRef, Name)
endFunction

;/* 
*/;
float function GetStatFloat(string Name)
	return Stats.GetStatFloat(PlayerRef, Name)
endFunction

;/* 
*/;
string function SetStat(string Name, string Value)
	return Stats.SetStat(PlayerRef, Name, Value)
endFunction

;/* 
*/;
int function AdjustBy(string Name, int AdjustBy)
	return Stats.AdjustBy(PlayerRef, Name, AdjustBy)
endFunction

;/* CalcSexuality
* * Calculates the sexuality given by the number of "partners" as number of males and females
* * This function is a global mathematical function, it is not specific for an actor.
* * 
* * @param: IsFemale, if set to true, then the calculation is done for a female, if set to FALSE then the calculation is done as a male
* * @param: males, is the number of sexual relations had with a male
* * @param: females, is the number of sexual relations had with a female
* * @return: an int between 0 and 100, where 0 is for full homosexual and 100 for full heterosexual. 50 is for bisexual.
*/;
int function CalcSexuality(bool IsFemale, int males, int females)
	return Stats.CalcSexuality(IsFemale, males, females)
endFunction

;/* CalcLevel
* * it is a mathematical function that calculates a level as the square root of the half of the first parameter multiplied by the curve parameter.
* *
* * @param: total, is the number used to calculate the value
* * @param: curve, is a parameter to have the result more smooth (<1.0) or sharp (>1.0)
* * @return: an inte as result of sqr(total / 2) * curve rounded to the integer value
*/;
int function CalcLevel(float total, float curve = 0.65)
	return Stats.CalcLevel(total, curve)
endFunction

;/* ParseTime
* * Utility function that converts an amount of seconds in a string representation with the format HH:MM:SS
* *
* * @param: int time, the number of seconds to convert in the string format
* * @return: a string with the amount of seconds converted in the HH:MM:SS format. If the amount of seconds is zero or negative, then the result is "--:--:--"
*/;
string function ParseTime(int time)
	return Stats.ParseTime(time)
endFunction

;/* PlayerSexCount
* * Returns the number of times the actor had sex with the player.
* *
* * @param: Actor ActorRef, is the actor to check the number of intercourses with the player
* * @return: The number of intercourses the actor had with the player
*/;
int function PlayerSexCount(Actor ActorRef)
	return Stats.PlayerSexCount(ActorRef)
endFunction

;/* HadPlayerSex
* * Checks if the actor ever had sex with the player
* *
* * @param: Actor ActorRef, is the actor to check the number of intercourses with the player
* * @return: TRUE if the actor had sex with the player
*/;
bool function HadPlayerSex(Actor ActorRef)
	return Stats.HadPlayerSex(ActorRef)
endFunction

;/* MostUsedPlayerSexPartner
* * Find which actor had more sex intercourse with the player
* *
* * @return: an Actor that is the partner of the player which had most intercourses with the player
*/;
Actor function MostUsedPlayerSexPartner()
	return Stats.MostUsedPlayerSexPartner()
endFunction

;/* MostUsedPlayerSexPartners
* * Find which actors had more sex intercourse with the player. 
* *
* * @param: int MaxActors [OPTIONAL] - The Max amount actor to add to the returned array 
* * @return: Actor[] - An intercourse sorted Actor array with the partners of the player which had most intercourses with the player
*/;
Actor[] function MostUsedPlayerSexPartners(int MaxActors = 5)
	return Stats.MostUsedPlayerSexPartners(MaxActors)
endFunction

;/* LastSexPartner
* * Find the last sex partner for a given actor
* * 
* * @param: Actor ActorRef, is the actor to check for finding the last sex partner
* * @return: An Actor that was the last actor the ActorRef had sex with
*/;
Actor function LastSexPartner(Actor ActorRef)
	return Stats.LastSexPartner(ActorRef)
endFunction

;/* HasHadSexTogether
* * Checks if the two actors ever had sex together
* *
* * @param: Actor ActorRef1, first of the two partners to check
* * @param: Actor ActorRef2, second of the two partners to check
* * @return: TRUE is the two actors ever had sex together
*/;
bool function HasHadSexTogether(Actor ActorRef1, Actor ActorRef2)
	return Stats.HasHadSexTogether(ActorRef1, ActorRef2)
endfunction

;/* LastAggressor
* * Returns the last actor that was an aggressor in a SexLab animation involving the actor parameter 
* *
* * @param: Actor ActorRef, is the actor to check for finding the last aggressor
* * @return: An Actor that was the last aggressor the ActorRef had, None if the actor never had an aggressor
*/;
Actor function LastAggressor(Actor ActorRef)
	return Stats.LastAggressor(ActorRef)
endFunction

;/* WasVictimOf
* * Very similar to LastAggressor(), but you can specify also a specific aggressor
* *
* * @param: Actor VictimRef, is the actor to check to understand if was aggressed by AggressorRef
* * @param: Actor AggressorRef, is the actor to check to understand VictimRef was aggressed by
* * @return: TRUE AggressorRef was an aggressor of VictimRef
*/;
bool function WasVictimOf(Actor VictimRef, Actor AggressorRef)
	return Stats.WasVictimOf(VictimRef, AggressorRef)
endFunction

;/* LastVictim
* * Finds who was the last vicitm of the specified actor
* *
* * @param: Actor ActorRef, the actor that was an aggressor
* * @return: an Actor that was the last victim of the specified aggressor.
*/;
Actor function LastVictim(Actor ActorRef)
	return Stats.LastVictim(ActorRef)
endFunction

;/* WasAggressorTo
* * Exactly the same of WasVictimOf(), but with the roles exchanged
* *
* * @param: Actor AggressorRef, is the actor to check to understand VictimRef was aggressed by
* * @param: Actor VictimRef, is the actor to check to understand if was aggressed by AggressorRef
* * @return: TRUE AggressorRef was an aggressor of VictimRef
*/;
bool function WasAggressorTo(Actor AggressorRef, Actor VictimRef)
	return Stats.WasAggressorTo(AggressorRef, VictimRef)
endFunction

;/* AdjustPurity
* * Changes the stats for the specified actor for "Pure" and "lewd". If the "amount" is positive then the "Pure" stat is increased. If the "amount" is negative, then the "lewd" stat is increased.
* *
* * @param: Actor ActorRef, is the actor for whom to change the stat
* * @param: float amount, is the amount that will be added to "Pure" (if amount is positive), or "Lewd" (if amount is negative) stats.
* * @return: the resulting value of the stat
*/;
float function AdjustPurity(Actor ActorRef, float amount)
	return Stats.AdjustPurity(ActorRef, amount)
endFunction

;/* SetSexuality
* * Defines the sexual orientation of the specified actor, where 1 is pure homosexual, and 100 is pure heterosexual
* *
* * @param: Actor ActorRef, is the actor for whom to change the sexual orientation (warning this is NOT touching the Sex Gender!)
* * @param: float amount, is the amount that will specify if the actor is 1=pure homosexual, 50=bisexual, 100=pure heterosexual
*/;
function SetSexuality(Actor ActorRef, int amount)
	Stats.SetSkill(ActorRef, "Sexuality", PapyrusUtil.ClampInt(amount, 1, 100))
endFunction

;/* SetSexualityStraight
* * Shortcut for SetSexuality(actor, 100), makes the actor pure heterosexual
* *
* * @param: Actor ActorRef, is the actor for whom to change the sexual orientation (warning this is NOT touching the Sex Gender!)
*/;
function SetSexualityStraight(Actor ActorRef)
	Stats.SetSkill(ActorRef, "Sexuality", 100)
endFunction

;/* SetSexualityBisexual
* * Shortcut for SetSexuality(actor, 50), makes the actor bisexual
* *
* * @param: Actor ActorRef, is the actor for whom to change the sexual orientation (warning this is NOT touching the Sex Gender!)
*/;
function SetSexualityBisexual(Actor ActorRef)
	Stats.SetSkill(ActorRef, "Sexuality", 50)
endFunction

;/* SetSexualityGay
* * Shortcut for SetSexuality(actor, 1), makes the actor pure homosexual
* *
* * @param: Actor ActorRef, is the actor for whom to change the sexual orientation (warning this is NOT touching the Sex Gender!)
*/;
function SetSexualityGay(Actor ActorRef)
	Stats.SetSkill(ActorRef, "Sexuality", 1)
endFunction

;/* GetSexuality
* * Returns the stat for the specified actor about its sexuality
* *
* * @param: Actor ActorRef, is the actor for whom to change the sexual orientation (warning this is NOT touching the Sex Gender!)
* * @return: an int with the sexual orientation of the actor. 1 will be pure homosexual, and 100 will be pure heterosexual
*/;
int function GetSexuality(Actor ActorRef)
	return Stats.GetSexuality(ActorRef)
endFunction

;/* GetSexualityTitle
* * Provides the sexuality not as a number but as a descriptive, translated, string
* *
* * @param: Actor ActorRef, is the actor for whom to change the sexual orientation (warning this is NOT touching the Sex Gender!)
* * @return: a string with "Heterosexual" if the sexuality score is greater or equal to 65; "Bisexual" if the score is between 65 and 35; "Gay" or "Lesbian" in case the sexuality is less than 35, of course the value depends on the actual gender of the actor.
*/;
string function GetSexualityTitle(Actor ActorRef)
	return Stats.GetSexualityTitle(ActorRef)
endFunction

;/* GetSkillTitle
* * Provide a description of the specified skill for the defined actor.
* * Possible values (that can be trnaslated) are: Unskilled, Novice, Apprentice, Journeyman, Expert, Master, and GrandMaster
* *
* * @param: Actor ActorRef, is the actor for whom to calculate the skill title
* * @param: string Skill, is the skill to calculate the title (standard skills are: Foreplay, Vaginal, Anal, Oral, Pure, and Lewd)
* * @return: a string with the title corresponding to the skill level for the actor
*/;
string function GetSkillTitle(Actor ActorRef, string Skill)
	return Stats.GetSkillTitle(ActorRef, Skill)
endFunction

;/* GetSkill
* * Returns the actual value of the specified skill for the specified actor
* *
* * @param: Actor ActorRef, is the actor for whom get the skill value
* * @param: string Skill, is the skill to get (standard skills are: Foreplay, Vaginal, Anal, Oral, Pure, and Lewd)
* * @return: an int with the raw value of the skill for the actor
*/;
int function GetSkill(Actor ActorRef, string Skill)
	return Stats.GetSkill(ActorRef, Skill)
endFunction

;/* GetSkillLevel
* * Returns the calculated level value of the specified skill for the specified actor
* *
* * @param: Actor ActorRef, is the actor for whom get the skill level
* * @param: string Skill, is the skill to get (standard skills are: Foreplay, Vaginal, Anal, Oral, Pure, and Lewd)
* * @return: an int with the calculate level of the skill for the actor
*/;
int function GetSkillLevel(Actor ActorRef, string Skill)
	return Stats.GetSkillLevel(ActorRef, Skill)
endFunction

;/* GetPurity
* * Return the raw walue for the Pure skill for the actor
* *
* * @param: Actor ActorRef, is the actor for whom get the skill value
* * @return: a float with the actual raw value of the "pure" skill
*/;
float function GetPurity(Actor ActorRef)
	return Stats.GetPurity(ActorRef)
endFunction

;/* GetPurityLevel
* * Return the level walue for the Pure skill for the actor
* *
* * @param: Actor ActorRef, is the actor for whom get the skill value
* * @return: an int with the leveled value of the "pure" skill
*/;
int function GetPurityLevel(Actor ActorRef)
	return Stats.GetPurityLevel(ActorRef)
endFunction

;/* GetPurityTitle
* * Provides a string with the title of the purity level for the actor
* * e.g. Neutral, Unsullied, CleanCut, Virtuous, EverFaithful, Lordly, Saintly
* *
* * @param: Actor ActorRef, is the actor for whom get the purity level
* * @return: a string with the purity title
*/;
string function GetPurityTitle(Actor ActorRef)
	return Stats.GetPurityTitle(ActorRef)
endFunction

;/* IsPure
* * Checks if an actor is pure or not
* *
* * @param: Actor ActorRef, is the actor to check for purity
* * @return: true if the actor is pure
*/;
bool function IsPure(Actor ActorRef)
	return Stats.IsPure(ActorRef)
endFunction


;/* IsLewd
* * Checks if an actor is lewd or not
* *
* * @param: Actor ActorRef, is the actor to check
* * @return: true if the actor is lewd
*/;
bool function IsLewd(Actor ActorRef)
	return Stats.IsLewd(ActorRef)
endFunction

;/* IsStraight
* * Checks if the actor is straight, so if it had mainly heterosexual intercourses
* *
* * @param: Actor ActorRef, is the actor to check
* * @return: true if the actor has a level of sexuality greater than 65% (mostly heterosexual)
*/;
bool function IsStraight(Actor ActorRef)
	return Stats.IsStraight(ActorRef)
endFunction

;/* IsBisexual
* * Checks if the actor is bisexual, so if it had a mix of homosexual and heterosexual intercourses
* *
* * @param: Actor ActorRef, is the actor to check
* * @return: true if the actor has a level of sexuality between 35% and 65%
*/;
bool function IsBisexual(Actor ActorRef)
	return Stats.IsBisexual(ActorRef)
endFunction

;/* IsGay
* * Checks if the actor is gay/lesbian, so if it had mainly homosexual intercourses
* *
* * @param: Actor ActorRef, is the actor to check
* * @return: true if the actor has a level of sexuality lower than 35% (mostly homosexual)
*/;
bool function IsGay(Actor ActorRef)
	return Stats.IsGay(ActorRef)
endFunction

;/* SexCount
* * Provides the number of times the actor participated in sex using sexlab
* *
* * @param: Actor ActorRef, is the actor to check
* * @return: an int with the number of times the actor had sex using sexlab
*/;
int function SexCount(Actor ActorRef)
	return Stats.SexCount(ActorRef)
endFunction

;/* HadSex
* * Checks if an actor ever had sex before
* *
* * @param: Actor ActorRef, is the actor to check
* * @return: true if the actor participated in at least one intercourse
*/;
bool function HadSex(Actor ActorRef)
	return Stats.HadSex(ActorRef)
endFunction

;/* LastSexGameTime
* * Provides the last time the actor had sex, in GameTime format
* *
* * @param: Actor ActorRef, is the actor to check
* * @return: a float with the game time (same format as returned by Utility.GetCurrentGameTime()) when the actor had sex last time
*/;
; Last sex - Game time - float days
float function LastSexGameTime(Actor ActorRef)
	return Stats.LastSexGameTime(ActorRef)
endFunction

;/* DaysSinceLastSex
* * Provides the number of days (it can be a fraction) passed from the last time the actor had sex
* *
* * @param: Actor ActorRef, is the actor to check
* * @return: a float with the number of game days passed from the last time the actor had sex
*/;
float function DaysSinceLastSex(Actor ActorRef)
	return Stats.DaysSinceLastSex(ActorRef)
endFunction

;/* HoursSinceLastSex
* * Provides the number of hours (it can be a fraction) passed from the last time the actor had sex
* *
* * @param: Actor ActorRef, is the actor to check
* * @return: a float with the number of game hours passed from the last time the actor had sex
*/;
float function HoursSinceLastSex(Actor ActorRef)
	return Stats.HoursSinceLastSex(ActorRef)
endFunction

;/* MinutesSinceLastSex
* * Provides the number of minutes (it can be a fraction) passed from the last time the actor had sex
* *
* * @param: Actor ActorRef, is the actor to check
* * @return: a float with the number of game minutes passed from the last time the actor had sex
*/;
float function MinutesSinceLastSex(Actor ActorRef)
	return Stats.MinutesSinceLastSex(ActorRef)
endFunction

;/* SecondsSinceLastSex
* * Provides the number of seconds (it can be a fraction) passed from the last time the actor had sex
* *
* * @param: Actor ActorRef, is the actor to check
* * @return: a float with the number of game seconds passed from the last time the actor had sex
*/;
float function SecondsSinceLastSex(Actor ActorRef)
	return Stats.SecondsSinceLastSex(ActorRef)
endFunction

;/* LastSexTimerString
* * Provides the last time the actor had sex, in GameTime format but converted to a descriptive string
* *
* * @param: Actor ActorRef, is the actor to check
* * @return: a string with the game time (same format as returned by Utility.GetCurrentGameTime()) when the actor had sex last time
*/;
string function LastSexTimerString(Actor ActorRef)
	return Stats.LastSexTimerString(ActorRef)
endFunction

;/* LastSexRealTime
* * Provides the last time the actor had sex, in Real Time format
* *
* * @param: Actor ActorRef, is the actor to check
* * @return: a float with the game time (same format as returned by Utility.GetCurrentRealTime()) when the actor had sex last time
*/;
float function LastSexRealTime(Actor ActorRef)
	return Stats.LastSexRealTime(ActorRef)
endFunction

;/* DaysSinceLastSexRealTime
* * Provides the number of days (it can be a fraction) passed from the last time the actor had sex
* *
* * @param: Actor ActorRef, is the actor to check
* * @return: a float with the number of game days passed from the last time the actor had sex
*/;
float function DaysSinceLastSexRealTime(Actor ActorRef)
	return Stats.DaysSinceLastSexRealTime(ActorRef)
endFunction

;/* HoursSinceLastSexRealTime
* * Provides the number of hours (it can be a fraction) passed from the last time the actor had sex
* *
* * @param: Actor ActorRef, is the actor to check
* * @return: a float with the number of real time hours passed from the last time the actor had sex
*/;
float function HoursSinceLastSexRealTime(Actor ActorRef)
	return Stats.HoursSinceLastSexRealTime(ActorRef)
endFunction

;/* MinutesSinceLastSexRealTime
* * Provides the number of minutes (it can be a fraction) passed from the last time the actor had sex
* *
* * @param: Actor ActorRef, is the actor to check
* * @return: a float with the number of real time minutes passed from the last time the actor had sex
*/;
float function MinutesSinceLastSexRealTime(Actor ActorRef)
	return Stats.MinutesSinceLastSexRealTime(ActorRef)
endFunction

;/* SecondsSinceLastSexRealTime
* * Provides the number of seconds (it can be a fraction) passed from the last time the actor had sex
* *
* * @param: Actor ActorRef, is the actor to check
* * @return: a float with the number of real time seconds passed from the last time the actor had sex
*/;
float function SecondsSinceLastSexRealTime(Actor ActorRef)
	return Stats.SecondsSinceLastSexRealTime(ActorRef)
endFunction

;/* LastSexTimerStringRealTime
* * Provides the last time the actor had sex, in Real Time format but converted to a descriptive string
* *
* * @param: Actor ActorRef, is the actor to check
* * @return: a string with the real timewhen the actor had sex last time
*/;
string function LastSexTimerStringRealTime(Actor ActorRef)
	return Stats.LastSexTimerStringRealTime(ActorRef)
endFunction

;/* AdjustPlayerPurity
* * Changes the stats for the p for "Pure" and "lewd". If the "amount" is positive then the "Pure" stat is increased. If the "amount" is negative, then the "lewd" stat is increased.
* * This function is a Player shortcut
* *
* * @param: float amount, is the amount that will be added to "Pure" (if amount is positive), or "Lewd" (if amount is negative) stats.
* * @return: the resulting value of the stat
*/;
float function AdjustPlayerPurity(float amount)
	return Stats.AdjustPurity(PlayerRef, amount)
endFunction

;/* GetPlayerPurityLevel
* * Return the level walue for the Pure skill for the player
* * This function is a Player shortcut
* *
* @return: an int with the leveled value of the "pure" skill
*/;
int function GetPlayerPurityLevel()
	return Stats.GetPurityLevel(PlayerRef)
endFunction

;/* GetPlayerPurityTitle
* * Provides a string with the title of the purity level for the player
* * e.g. Neutral, Unsullied, CleanCut, Virtuous, EverFaithful, Lordly, Saintly
* * This function is a Player shortcut
* *
* @return: a string with the purity title
*/;
string function GetPlayerPurityTitle()
	return Stats.GetPurityTitle(PlayerRef)
endFunction

;/* GetPlayerSexualityTitle
* * Provides the sexuality not as a number but as a descriptive, translated, string
* * This function is a Player shortcut
* *
* @return: a string with "Heterosexual" if the sexuality score of the player is greater or equal to 65; "Bisexual" if the score is between 65 and 35; "Gay" or "Lesbian" in case the sexuality is less than 35, of course the value depends on the actual gender of the player.
*/;
string function GetPlayerSexualityTitle()
	return Stats.GetSexualityTitle(PlayerRef)
endFunction

;/* GetPlayerSkillLevel
* * Returns the calculated level value of the specified skill for the player
* * This function is a Player shortcut
* *
* @return: an int with the calculate level of the skill for the player
*/;
int function GetPlayerSkillLevel(string Skill)
	return Stats.GetSkillLevel(PlayerRef, Skill)
endFunction

;/* GetPlayerSkillTitle
* * Provide a description of the specified skill for the player.
* * Possible values (that can be translated) are: Unskilled, Novice, Apprentice, Journeyman, Expert, Master, and GrandMaster
* * This function is a Player shortcut
* *
* * @param: string Skill, is the skill to calculate the title (standard skills are: Foreplay, Vaginal, Anal, Oral, Pure, and Lewd)
* * @return: a string with the title corresponding to the skill level for the player
*/;
string function GetPlayerSkillTitle(string Skill)
	return Stats.GetSkillTitle(PlayerRef, Skill)
endFunction

;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#  ^^^                                                       END STAT FUNCTIONS                                                      ^^^  #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#


;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#                                                         START FACTORY FUNCTIONS                                                         #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#

;/* RegisterAnimation
* * Find an available animation slot for the animation and starts the callback to register it.
* * In case the animation was already registered you get the already registered animation without any update
* *
* * @param: string Registrar, the ID of the animation, no spaces allowed.
* * @param: Form CallbackForm, the script (as object) that has the code to register the animation, the script has to have an Event with the same name of the registrar
* * @param: ReferenceAlias CallbackAlias, can be used alternatively to CallbackForm, in case the script is inside a ReferenceAlias
* * @return: sslBaseAnimation, the actual animation registered
*/;
sslBaseAnimation function RegisterAnimation(string Registrar, Form CallbackForm = none, ReferenceAlias CallbackAlias = none)
	return AnimSlots.RegisterAnimation(Registrar, CallbackForm, CallbackAlias)
endFunction

;/* RegisterCreatureAnimation
* * Find an available Creature animation slot for the animation and starts the callback to register it.
* * In case the Creature animation was already registered you get the already registered Creature animation without any update
* *
* * @param: string Registrar, the ID of the Creature animation, no spaces allowed.
* * @param: Form CallbackForm, the script (as object) that has the code to register the animation, the script has to have an Event with the same name of the registrar
* * @param: ReferenceAlias CallbackAlias, can be used alternatively to CallbackForm, in case the script is inside a ReferenceAlias
* * @return: sslBaseAnimation, the actual animation registered
*/;
sslBaseAnimation function RegisterCreatureAnimation(string Registrar, Form CallbackForm = none, ReferenceAlias CallbackAlias = none)
	return CreatureSlots.RegisterAnimation(Registrar, CallbackForm, CallbackAlias)
endFunction

;/* RegisterVoice
* * Find an available SexLabVoice slot and starts the callback to register it.
* * In case the SexLabVoice was already registered you get the already registered SexLabVoice without any update
* *
* * @param: string Registrar, the ID of the SexLabVoice, no spaces allowed.
* * @param: Form CallbackForm, the script (as object) that has the code to register the SexLabVoice, the script has to have an Event with the same name of the registrar
* * @param: ReferenceAlias CallbackAlias, can be used alternatively to CallbackForm, in case the script is inside a ReferenceAlias
* * @return: sslBaseVoice, the actual SexLabVoice registered
*/;
sslBaseVoice function RegisterVoice(string Registrar, Form CallbackForm = none, ReferenceAlias CallbackAlias = none)
	return VoiceSlots.RegisterVoice(Registrar, CallbackForm, CallbackAlias)
endFunction

;/* RegisterExpression
* * Find an available SexLabExpression slot and starts the callback to register it.
* * In case the SexLabExpression was already registered you get the already registered SexLabExpression without any update
* *
* * @param: string Registrar, the ID of the SexLabExpression, no spaces allowed.
* * @param: Form CallbackForm, the script (as object) that has the code to register the SexLabExpression, the script has to have an Event with the same name of the registrar
* * @param: ReferenceAlias CallbackAlias, can be used alternatively to CallbackForm, in case the script is inside a ReferenceAlias
* * @return: sslBaseVoice, the actual SexLabExpression registered
*/;
sslBaseExpression function RegisterExpression(string Registrar, Form CallbackForm = none, ReferenceAlias CallbackAlias = none)
	return ExpressionSlots.RegisterExpression(Registrar, CallbackForm, CallbackAlias)
endFunction

;/* NewAnimationObject
* * TODO
* * 
* * @param: 
* * @return: 
*/;
sslBaseAnimation function NewAnimationObject(string Token, Form Owner)
	return Factory.NewAnimation(Token, Owner)
endFunction


;/* NewVoiceObject
* * TODO
* * 
* * @param: 
* * @return: 
*/;
sslBaseVoice function NewVoiceObject(string Token, Form Owner)
	return Factory.NewVoice(Token, Owner)
endFunction

;/* NewExpressionObject
* * TODO
* * 
* * @param: 
* * @return: 
*/;
sslBaseExpression function NewExpressionObject(string Token, Form Owner)
	return Factory.NewExpression(Token, Owner)
endFunction

;/* GetSetAnimationObject
* * TODO
* * 
* * @param: 
* * @return: 
*/;
sslBaseAnimation function GetSetAnimationObject(string Token, string Callback, Form Owner)
	return Factory.GetSetAnimation(Token, Callback, Owner)
endFunction

;/* GetSetVoiceObject
* * TODO
* * 
* * @param: 
* * @return: 
*/;
sslBaseVoice function GetSetVoiceObject(string Token, string Callback, Form Owner)
	return Factory.GetSetVoice(Token, Callback, Owner)
endFunction

;/* GetSetExpressionObject
* * TODO
* * 
* * @param: 
* * @return: 
*/;
sslBaseExpression function GetSetExpressionObject(string Token, string Callback, Form Owner)
	return Factory.GetSetExpression(Token, Callback, Owner)
endFunction

;/* NewAnimationObjectCopy
* * TODO
* * 
* * @param: 
* * @return: 
*/;
sslBaseAnimation function NewAnimationObjectCopy(string Token, sslBaseAnimation CopyFrom, Form Owner)
	return Factory.NewAnimationCopy(Token, CopyFrom, Owner)
endFunction

;/* NewVoiceObjectCopy
* * TODO
* * 
* * @param: 
* * @return: 
*/;
sslBaseVoice function NewVoiceObjectCopy(string Token, sslBaseVoice CopyFrom, Form Owner)
	return Factory.NewVoiceCopy(Token, CopyFrom, Owner)
endFunction

;/* NewExpressionObjectCopy
* * TODO
* * 
* * @param: 
* * @return: 
*/;
sslBaseExpression function NewExpressionObjectCopy(string Token, sslBaseExpression CopyFrom, Form Owner)
	return Factory.NewExpressionCopy(Token, CopyFrom, Owner)
endFunction

;/* GetAnimationObject
* * TODO
* * 
* * @param: 
* * @return: 
*/;
sslBaseAnimation function GetAnimationObject(string Token)
	return Factory.GetAnimation(Token)
endFunction

;/* GetVoiceObject
* * TODO
* * 
* * @param: 
* * @return: 
*/;
sslBaseVoice function GetVoiceObject(string Token)
	return Factory.GetVoice(Token)
endFunction

;/* GetExpressionObject
* * TODO
* * 
* * @param: 
* * @return: 
*/;
sslBaseExpression function GetExpressionObject(string Token)
	return Factory.GetExpression(Token)
endFunction

;/* GetOwnerAnimations
* * TODO
* * 
* * @param: 
* * @return: 
*/;
sslBaseAnimation[] function GetOwnerAnimations(Form Owner)
	return Factory.GetOwnerAnimations(Owner)
endFunction

;/* GetOwnerVoices
* * TODO
* * 
* * @param: 
* * @return: 
*/;
sslBaseVoice[] function GetOwnerVoices(Form Owner)
	return Factory.GetOwnerVoices(Owner)
endFunction

;/* GetOwnerExpressions
* * TODO
* * 
* * @param: 
* * @return: 
*/;
sslBaseExpression[] function GetOwnerExpressions(Form Owner)
	return Factory.GetOwnerExpressions(Owner)
endFunction

;/* HasAnimationObject
* * TODO
* * 
* * @param: 
* * @return: 
*/;
bool function HasAnimationObject(string Token)
	return Factory.HasAnimation(Token)
endFunction

;/* HasVoiceObject
* * TODO
* * 
* * @param: 
* * @return: 
*/;
bool function HasVoiceObject(string Token)
	return Factory.HasVoice(Token)
endFunction

;/* HasExpressionObject
* * TODO
* * 
* * @param: 
* * @return: 
*/;
bool function HasExpressionObject(string Token)
	return Factory.HasExpression(Token)
endFunction

;/* ReleaseAnimationObject
* * TODO
* * 
* * @param: 
* * @return: 
*/;
bool function ReleaseAnimationObject(string Token)
	return Factory.ReleaseAnimation(Token)
endFunction

;/* ReleaseVoiceObject
* * TODO
* * 
* * @param: 
* * @return: 
*/;
bool function ReleaseVoiceObject(string Token)
	return Factory.ReleaseVoice(Token)
endFunction

;/* ReleaseExpressionObject
* * TODO
* * 
* * @param: 
* * @return: 
*/;
bool function ReleaseExpressionObject(string Token)
	return Factory.ReleaseExpression(Token)
endFunction

;/* ReleaseExpressionObject
* * TODO
* * 
* * @param: 
* * @return: 
*/;
int function ReleaseOwnerAnimations(Form Owner)
	return Factory.ReleaseOwnerAnimations(Owner)
endFunction

;/* ReleaseOwnerVoices
* * TODO
* * 
* * @param: 
* * @return: 
*/;
int function ReleaseOwnerVoices(Form Owner)
	return Factory.ReleaseOwnerVoices(Owner)
endFunction

;/* ReleaseOwnerExpressions
* * TODO
* * 
* * @param: 
* * @return: 
*/;
int function ReleaseOwnerExpressions(Form Owner)
	return Factory.ReleaseOwnerExpressions(Owner)
endFunction

;/* MakeAnimationRegistered
* * TODO
* * 
* * @param: 
* * @return: 
*/;
sslBaseAnimation function MakeAnimationRegistered(string Token)
	return Factory.MakeAnimationRegistered(Token)
endFunction

;/* MakeVoiceRegistered
* * TODO
* * 
* * @param: 
* * @return: 
*/;
sslBaseVoice function MakeVoiceRegistered(string Token)
	return Factory.MakeVoiceRegistered(Token)
endFunction

;/* MakeExpressionRegistered
* * TODO
* * 
* * @param: 
* * @return: 
*/;
sslBaseExpression function MakeExpressionRegistered(string Token)
	return Factory.MakeExpressionRegistered(Token)
endFunction

;/* RemoveRegisteredAnimation
* * TODO
* * 
* * @param: 
* * @return: 
*/;
bool function RemoveRegisteredAnimation(string Registrar)
	return AnimSlots.UnregisterAnimation(Registrar)
endFunction

;/* RemoveRegisteredCreatureAnimation
* * TODO
* * 
* * @param: 
* * @return: 
*/;
bool function RemoveRegisteredCreatureAnimation(string Registrar)
	return CreatureSlots.UnregisterAnimation(Registrar)
endFunction

;/* RemoveRegisteredVoice
* * TODO
* * 
* * @param: 
* * @return: 
*/;
bool function RemoveRegisteredVoice(string Registrar)
	return VoiceSlots.UnregisterVoice(Registrar)
endFunction

;/* RemoveRegisteredExpression
* * TODO
* * 
* * @param: 
* * @return: 
*/;
bool function RemoveRegisteredExpression(string Registrar)
	return ExpressionSlots.UnregisterExpression(Registrar)
endFunction

;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#  ^^^                                                     END FACTORY FUNCTIONS                                                     ^^^  #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#


;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#                                                         START UTILITY FUNCTIONS                                                         #
;#                                                        See functions located at:                                                        #
;#                                                              SexLabUtil.psc                                                             #
;#                                                              sslUtility.psc                                                             #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#

;/* MakeActorArray
* * Creates an array of actors with the specified actor objects.
* * Deprecated this script, use it directly from SexLabUtil instead.
* * 
* * @param: Actor Actor1, one actor to add in the array (can be unspefified and so ignored)
* * @param: Actor Actor2, one actor to add in the array (can be unspefified and so ignored)
* * @param: Actor Actor3, one actor to add in the array (can be unspefified and so ignored)
* * @param: Actor Actor4, one actor to add in the array (can be unspefified and so ignored)
* * @param: Actor Actor5, one actor to add in the array (can be unspefified and so ignored)
* * @return: an Actor[] of the size of the non null actors with the specified actors inside.
*/;
Actor[] function MakeActorArray(Actor Actor1 = none, Actor Actor2 = none, Actor Actor3 = none, Actor Actor4 = none, Actor Actor5 = none)
	return SexLabUtil.MakeActorArray(Actor1, Actor2, Actor3, Actor4, Actor5)
endFunction

;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#                                                          END UTILITY FUNCTIONS                                                          #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#



;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#                                                 DEPRECATED FUNCTIONS - DO NOT USE THEM                                                  #
;#         Replace these functions, if used in your mod, with the applicable new versions for easier usage and better performance.         #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#

;/* HookController DEPRECATED!
* * Use GetController(int tid) and use the new Hook functions.
* *
* *
* * @param: argString - The parameter received on the Event function, it is the thread ID
* * @return: A sslThreadController corresponding to the ID
*/;
sslThreadController function HookController(string argString)
	return ThreadSlots.GetController(argString as int)
endFunction

;/* HookAnimation DEPRECATED!
* * SexLab.GetController(tid).Animation
* *
* * @param: argString - The parameter received on the Event function, it is the thread ID
* * @return: a sslBaseAnimation that is the animation being played by the Controller
*/;
sslBaseAnimation function HookAnimation(string argString)
	return ThreadSlots.GetController(argString as int).Animation
endFunction

;/* HookStage DEPRECATED!
* * SexLab.GetController(tid).Stage
* *
* * @param: argString - The parameter received on the Event function, it is the thread ID
* * @return: an int with the index of the Stage of the animation being played.
*/;
int function HookStage(string argString)
	return ThreadSlots.GetController(argString as int).Stage
endFunction

;/* HookVictim DEPRECATED!
* * SexLab.GetController(tid).Victim
* *
* * @param: argString - The parameter received on the Event function, it is the thread ID
* * @return: An Actor that is the Victim for the Sexlab animation. Can be None if the Victim is undefined
*/;
Actor function HookVictim(string argString)
	return ThreadSlots.GetController(argString as int).VictimRef
endFunction

;/* HookActors DEPRECATED!
* * SexLab.GetController(tid).Positions
* *
* * @param: argString - The parameter received on the Event function, it is the thread ID
* * @return: An Actor[] with all the Positions of the SexLab animation played by the controller
*/;
Actor[] function HookActors(string argString)
	return ThreadSlots.GetController(argString as int).Positions
endFunction

;/* HookTime DEPRECATED!
* * SexLab.GetController(tid).TotalTime
* *
* * @param: argString - The parameter received on the Event function, it is the thread ID
* * @return: a Float representing the total time the animation played (the animation may not be completed.)
*/;
float function HookTime(string argString)
	return ThreadSlots.GetController(argString as int).TotalTime
endFunction

;/* HasCreatureAnimation DEPRECATED!
* * (DEPRECATED) Use HasCreatureRaceAnimation or HasCreatureRaceKeyAnimation
*/;
bool function HasCreatureAnimation(Race CreatureRace, int Gender = -1)
	return CreatureSlots.RaceHasAnimation(CreatureRace, -1, Gender)
endFunction


;/* GetAnimationsByTag DEPRECATED!
* * (DEPRECATED) Use GetAnimationsByTags
*/;
sslBaseAnimation[] function GetAnimationsByTag(int ActorCount, string Tag1, string Tag2 = "", string Tag3 = "", string TagSuppress = "", bool RequireAll = true)
	return AnimSlots.GetByTags(ActorCount, sslUtility.MakeArgs(",", Tag1, Tag2, Tag3), TagSuppress, RequireAll)
endFunction

;/* GetCreatureAnimationsByTags DEPRECATED!
* * (DEPRECATED) Use GetCreatureAnimationsByActorsTags, GetCreatureAnimationsByRaceTags or GetCreatureAnimationsByRaceKeyTags
*/;
sslBaseAnimation[] function GetCreatureAnimationsByTags(int ActorCount, string Tags, string TagSuppress = "", bool RequireAll = true)
	return CreatureSlots.GetByTags(ActorCount, Tags, TagSuppress, RequireAll)
endFunction
;/* GetVoiceByTag DEPRECATED!
* * (DEPRECATED) Use GetVoiceByTags
*/;
sslBaseVoice function GetVoiceByTag(string Tag1, string Tag2 = "", string TagSuppress = "", bool RequireAll = true)
	return VoiceSlots.GetByTags(sslUtility.MakeArgs(",", Tag1, Tag2), TagSuppress, RequireAll)
endFunction

;/* ApplyCum DEPRECATED!
* * (DEPRECATED) Use AddCum
*/;
function ApplyCum(Actor ActorRef, int CumID)
	ActorLib.ApplyCum(ActorRef, CumID)
endFunction

;/* StripWeapon DEPRECATED!
* * (DEPRECATED) Use StripSlots, this function does nothing right now
*/;
form function StripWeapon(Actor ActorRef, bool RightHand = true)
	return none ; ActorLib.StripWeapon(ActorRef, RightHand)
endFunction

;/* DEPRECATED! *** Do not access this property directly, or you may get wrong results, use the APIs to get the value */;
sslBaseAnimation[] property Animations hidden
	sslBaseAnimation[] function get()
		return AnimSlots.Animations
	endFunction
endProperty

;/* DEPRECATED! *** Do not access this property directly, or you may get wrong results, use the APIs to get the value */;
sslBaseAnimation[] property CreatureAnimations hidden
	sslBaseAnimation[] function get()
		return CreatureSlots.Animations
	endFunction
endProperty

;/* DEPRECATED! *** Do not access this property directly, or you may get wrong results, use the APIs to get the value */;
sslBaseVoice[] property Voices hidden
	sslBaseVoice[] function get()
		return VoiceSlots.Voices
	endFunction
endProperty

;/* DEPRECATED! *** Do not access this property directly, or you may get wrong results, use the APIs to get the value */;
sslBaseExpression[] property Expressions hidden
	sslBaseExpression[] function get()
		return ExpressionSlots.Expressions
	endFunction
endProperty

;/* RandomExpressionByTag DEPRECATED!
* * (DEPRECATED) Use PickExpressionsByTag
*/;
sslBaseExpression function RandomExpressionByTag(string Tag)
	return ExpressionSlots.RandomByTag(Tag)
endFunction

;/* ApplyPreset DEPRECATED!
* * (DEPRECATED) Use ApplyPresetFloats
*/;
function ApplyPreset(Actor ActorRef, int[] Preset)
	sslBaseExpression.ApplyPreset(ActorRef, Preset)
endFunction

;/* DEPRECATED! *** Do not access this property directly, or you may get wrong results, use the APIs to get the value */;
sslThreadController[] property Threads hidden
	sslThreadController[] function get()
		return ThreadSlots.Threads
	endFunction
endProperty

;/* DEPRECATED! */;
bool function IsImpure(Actor ActorRef)
	return Stats.IsLewd(ActorRef)
endFunction

;/* DEPRECATED! */;
int function GetPlayerStatLevel(string Skill)
	return Stats.GetSkillLevel(PlayerRef, Skill)
endFunction


;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;# ^^^                                            END DEPRECATED FUNCTIONS - DO NOT USE THEM                                           ^^^ #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#





;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#                                    THE FOLLOWING PROPERTIES AND FUNCTION ARE FOR INTERNAL USE ONLY                                      #
;#                                                                                                                                         #
;#                                                                                                                                         #
;#                             ****       ***         *     *   ***   *******     *     *   ******  *******                                #
;#                             *   **    *   *        **    *  *   *     *        *     *  *      * *                                      #
;#                             *     *  *     *       * *   * *     *    *        *     *  *        *                                      #
;#                             *      * *     *       *  *  * *     *    *        *     *   ******  *****                                  #
;#                             *     *  *     *       *   * * *     *    *        *     *         * *                                      #
;#                             *   **    *   *        *    **  *   *     *         *   *   *      * *                                      #
;#                             ****       ***         *     *   ***      *          ***     ******  *******                                #
;#                                                                                                                                         #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#

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

