scriptname sslConfigDeprecated extends sslConfigMenu
{DEPRECATED: This script is a proxy for the original sslConfigMenu script which has been replaced, and is only provided as a means to provide backwards compatibility by redirecting all it's functions to their new iterations}

function DEPRECATED()
	string log = "SexLab DEPRECATED -- sslConfigMenu.psc (sslConfigDeprecated.psc) -- Use of this script has been deprecated, the mod that called this function should be updated as soon as possible. If you are not the author of this mod, notify them of this error if possible."
	Debug.TraceStack(log)
	if SexLab.Config.DebugMode
		MiscUtil.PrintConsole(log)
	endIf
endFunction

int function GetVersion()
	DEPRECATED()
	return SexLabUtil.GetVersion()
endFunction
string function GetStringVer()
	DEPRECATED()
	return SexLabUtil.GetStringVer()
endFunction
bool function DebugMode()
	DEPRECATED()
	return SexLab.Config.DebugMode
endFunction

sslAnimationSlots property AnimSlots hidden
	sslAnimationSlots function get()
		DEPRECATED()
		return SexLab.AnimSlots
	endFunction
endProperty
sslAnimationLibrary property AnimLib hidden
	sslAnimationLibrary function get()
		DEPRECATED()
		return SexLab.AnimLib
	endFunction
endProperty
sslCreatureAnimationSlots property CreatureAnimSlots hidden
	sslCreatureAnimationSlots function get()
		DEPRECATED()
		return SexLab.CreatureSlots
	endFunction
endProperty
sslVoiceSlots property VoiceSlots hidden
	sslVoiceSlots function get()
		DEPRECATED()
		return SexLab.VoiceSlots
	endFunction
endProperty
sslVoiceLibrary property VoiceLib hidden
	sslVoiceLibrary function get()
		DEPRECATED()
		return SexLab.VoiceLib
	endFunction
endProperty
sslExpressionSlots property ExpressionSlots hidden
	sslExpressionSlots function get()
		DEPRECATED()
		return SexLab.ExpressionSlots
	endFunction
endProperty
sslExpressionLibrary property ExpressionLib hidden
	sslExpressionLibrary function get()
		DEPRECATED()
		return SexLab.ExpressionLib
	endFunction
endProperty
sslThreadSlots property ThreadSlots hidden
	sslThreadSlots function get()
		DEPRECATED()
		return SexLab.ThreadSlots
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
sslActorStats property Stats hidden
	sslActorStats function get()
		DEPRECATED()
		return SexLab.Stats
	endFunction
endProperty

event OnVersionUpdate(int version)
endEvent
function SetupSystem()
endFunction
event OnGameReload()
endEvent
event OnPageReset(string page)
endEvent
event OnConfigInit()
endEvent
event OnInit()
endEvent
