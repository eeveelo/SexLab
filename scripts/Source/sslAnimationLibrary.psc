scriptname sslAnimationLibrary extends Quest
{DEPRECATED: This script is no longer used in any sexlab systems, and is only provided as a means to provide backwards compatibility by redirecting all it's functions to their new iterations}

sslAnimationSlots property Slots hidden
	sslAnimationSlots function get()
		DEPRECATED()
		return SexLab.AnimSlots
	endFunction
endProperty
bool property bRestrictAggressive hidden
	bool function get()
		DEPRECATED()
		return SexLab.Config.RestrictAggressive
	endFunction
endProperty
bool property bAllowCreatures hidden
	bool function get()
		DEPRECATED()
		return SexLab.Config.AllowCreatures
	endFunction
endProperty
string function MakeGenderTag(actor[] Positions)
	DEPRECATED()
	return SexLabUtil.MakeGenderTag(Positions)
endFunction
string function GetGenderTag(int females = 0, int males = 0, int creatures = 0) global
	DEPRECATED()
	return SexLabUtil.GetGenderTag(Females, Males, Creatures)
endFunction
bool function AllowedCreature(Race RaceRef)
	DEPRECATED()
	return SexLab.CreatureSlots.AllowedCreature(RaceRef)
endFunction
bool function AllowedCreatureCombination(Race RaceRef1, Race RaceRef2)
	DEPRECATED()
	return SexLab.CreatureSlots.AllowedCreatureCombination(RaceRef1, RaceRef2)
endFunction
function _Defaults()
	DEPRECATED()
endFunction
function _Export()
	DEPRECATED()
endFunction
function _Import()
	DEPRECATED()
endFunction
sslAnimationLibrary property AnimLib hidden
	sslAnimationLibrary function get()
		DEPRECATED()
		return SexLab.AnimLib
	endFunction
endProperty
sslVoiceLibrary property VoiceLib hidden
	sslVoiceLibrary function get()
		DEPRECATED()
		return SexLab.VoiceLib
	endFunction
endProperty
sslThreadLibrary property ThreadLib hidden
	sslThreadLibrary function get()
		DEPRECATED()
		return SexLab.ThreadLib
	endFunction
endProperty
sslActorLibrary property ActorLib hidden
	sslActorLibrary function get()
		DEPRECATED()
		return SexLab.ActorLib
	endFunction
endProperty
; sslControlLibrary property ControlLib hidden
; 	sslControlLibrary function get()
; 		DEPRECATED()
; 		return SexLab.ControlLib
; 	endFunction
; endProperty
sslExpressionLibrary property ExpressionLib hidden
	sslExpressionLibrary function get()
		DEPRECATED()
		return SexLab.ExpressionLib
	endFunction
endProperty
sslAnimationSlots property Animations hidden
	sslAnimationSlots function get()
		DEPRECATED()
		return SexLab.AnimSlots
	endFunction
endProperty
sslCreatureAnimationSlots property CreatureAnimations hidden
	sslCreatureAnimationSlots function get()
		DEPRECATED()
		return SexLab.CreatureSlots
	endFunction
endProperty
sslVoiceSlots property Voices hidden
	sslVoiceSlots function get()
		DEPRECATED()
		return SexLab.VoiceSlots
	endFunction
endProperty
sslThreadSlots property Threads hidden
	sslThreadSlots function get()
		DEPRECATED()
		return SexLab.ThreadSlots
	endFunction
endProperty
sslExpressionSlots property Expressions hidden
	sslExpressionSlots function get()
		DEPRECATED()
		return SexLab.ExpressionSlots
	endFunction
endProperty
sslActorStats property ActorStats hidden
	sslActorStats function get()
		DEPRECATED()
		return SexLab.Stats
	endFunction
endProperty

SexLabFramework SexLab
sslAnimationLibrary function Setup()
	Stop()
	Start()
	SexLab = SexLabUtil.GetAPI()
	return self
endFunction
function DEPRECATED() global
	string log = "SexLab DEPRECATED -- sslAnimationLibrary.psc -- Use of this script has been deprecated, the mod that called this function should be updated as soon as possible. If you are not the author of this mod, notify them of this error if possible."
	Debug.TraceStack(log)
	if SexLabUtil.GetAPI().Config.DebugMode
		MiscUtil.PrintConsole(log)
	endIf
endFunction

