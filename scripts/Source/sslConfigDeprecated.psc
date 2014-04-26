scriptname sslConfigDeprecated extends sslConfigMenu
{DEPRECATED: This script is a proxy for the original sslConfigMenu script which has been replaced, and is only provided as a means to provide backwards compatibility by redirecting all it's functions to their new iterations}

;/

DEPRECATED NOTICE:

The sslConfigMenu script was never intended for modder use, however some people have found a
use for it as a means to check SexLab's installed version. This means anytime the config quest is
reset, as has happened recently, any mod using it for its sexlab check breaks.

As an alternative, the script SexLabUtil provides a global version of the version functions,
which is an accesspoint that can pulled from any script without property, or requiring a modder
to have the SkyUI SDK installed in order to compile anything, as the sslConfigMenu script
is now completely isolated from all other scripts others.

Please replace any version check you have done through sslConfigMenu with these 2 functions:

int function SexLabUtil.GetVerison()
	@return - the integer representation of SexLab's version. i.e. '15300' for SexLab v1.53

string function SexLabUtil.GetStringVer()
	@return - a string based readable representation of SexLab's version i.e. '1.53' for SexLab v1.53

Or any actual configuration accessing can be done through SexLab's sslSystemConfig script, which
is made accessible via the Config property on the SexLabFramework.psc script, or through the
SexLabUtil global function, GetConfig()

i.e. via property

SexLabFramework property SexLab auto
if SexLab.Config.AllowCreatures
	Debug.Trace("User has creatures enabled!")
endIf

i.e. via SexLabUtil global

if SexLabUtil.GetConfig().AllowCreatures
	Debug.Trace("User has creatures enabled!")
endIf

/;

function DEPRECATED()
	string log = "SexLab DEPRECATED -- sslConfigMenu.psc (sslConfigDeprecated.psc) -- Use of this script has been deprecated, the mod that called this function should be updated as soon as possible. If you are not the author of this mod, notify them of this error if possible."
	Debug.TraceStack(log, 1)
	if SexLabUtil.GetConfig().DebugMode
		MiscUtil.PrintConsole(log)
	endIf
	GoToState("Silence")
	RegisterForSingleUpdate(3.0)
endFunction
state Silence
	event OnUpdate()
		GoToState("")
	endEvent
	function DEPRECATED()
	endFunction
endState
SexLabFramework property SSL hidden
	SexLabFramework function get()
		return (Game.GetFormFromFile(0xD62, "SexLab.esm") as SexLabFramework)
	endFunction
endProperty

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
	return SSL.Config.DebugMode
endFunction

sslAnimationSlots property AnimSlots hidden
	sslAnimationSlots function get()
		DEPRECATED()
		return SSL.AnimSlots
	endFunction
endProperty
sslAnimationLibrary property AnimLib hidden
	sslAnimationLibrary function get()
		DEPRECATED()
		return SSL.AnimLib
	endFunction
endProperty
sslCreatureAnimationSlots property CreatureAnimSlots hidden
	sslCreatureAnimationSlots function get()
		DEPRECATED()
		return SSL.CreatureSlots
	endFunction
endProperty
sslVoiceSlots property VoiceSlots hidden
	sslVoiceSlots function get()
		DEPRECATED()
		return SSL.VoiceSlots
	endFunction
endProperty
sslVoiceLibrary property VoiceLib hidden
	sslVoiceLibrary function get()
		DEPRECATED()
		return SSL.VoiceLib
	endFunction
endProperty
sslExpressionSlots property ExpressionSlots hidden
	sslExpressionSlots function get()
		DEPRECATED()
		return SSL.ExpressionSlots
	endFunction
endProperty
sslExpressionLibrary property ExpressionLib hidden
	sslExpressionLibrary function get()
		DEPRECATED()
		return SSL.ExpressionLib
	endFunction
endProperty
sslThreadSlots property ThreadSlots hidden
	sslThreadSlots function get()
		DEPRECATED()
		return SSL.ThreadSlots
	endFunction
endProperty
sslThreadLibrary property ThreadLib hidden
	sslThreadLibrary function get()
		DEPRECATED()
		return SSL.ThreadLib
	endFunction
endProperty
sslActorLibrary property ActorLib hidden
	sslActorLibrary function get()
		DEPRECATED()
		return SSL.ActorLib
	endFunction
endProperty
sslActorStats property Stats hidden
	sslActorStats function get()
		DEPRECATED()
		return SSL.Stats
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
	Stop()
endEvent
