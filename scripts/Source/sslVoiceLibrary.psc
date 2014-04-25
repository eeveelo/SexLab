scriptname sslVoiceLibrary extends Quest
{DEPRECATED: This script is a proxy for the original sslConfigMenu script which has been replaced, and is only provided as a means to provide backwards compatibility by redirecting all it's functions to their new iterations}

sslVoiceSlots property Slots hidden
	sslVoiceSlots function get()
		DEPRECATED()
		return SexLabUtil.GetAPI().VoiceSlots
	endFunction
endProperty
VoiceType property SexLabVoiceM hidden
	VoiceType function get()
		DEPRECATED()
		return SexLabUtil.GetAPI().Config.SexLabVoiceM
	endFunction
endProperty
VoiceType property SexLabVoiceF hidden
	VoiceType function get()
		DEPRECATED()
		return SexLabUtil.GetAPI().Config.SexLabVoiceF
	endFunction
endProperty
FormList property VoicesPlayer hidden
	FormList function get()
		DEPRECATED()
		return SexLabUtil.GetAPI().Config.VoicesPlayer
	endFunction
endProperty
string property sPlayerVoice hidden
	string function get()
		DEPRECATED()
		return SexLabUtil.GetAPI().VoiceSlots.GetSavedName(Game.GetPlayer())
	endFunction
endProperty
bool property bNPCSaveVoice hidden
	bool function get()
		DEPRECATED()
		return SexLabUtil.GetAPI().Config.NPCSaveVoice
	endFunction
endProperty
sslBaseVoice function PickVoice(actor a)
	DEPRECATED()
	return SexLabUtil.GetAPI().VoiceSlots.PickVoice(a)
endFunction
function SaveVoice(actor a, sslBaseVoice Voice)
	DEPRECATED()
	SexLabUtil.GetAPI().VoiceSlots.SaveVoice(a, Voice)
endFunction
function ForgetVoice(actor a)
	DEPRECATED()
	SexLabUtil.GetAPI().VoiceSlots.ForgetVoice(a)
endFunction
sslBaseVoice function GetVoice(actor a)
	DEPRECATED()
	return SexLabUtil.GetAPI().VoiceSlots.PickVoice(a)
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
sslVoiceLibrary function Setup()
	Stop()
	Start()
	SexLab = SexLabUtil.GetAPI()
	return self
endFunction

function DEPRECATED() global
	string log = "SexLab DEPRECATED -- sslVoiceLibrary.psc -- Use of this script has been deprecated, the mod that called this function should be updated as soon as possible. If you are not the author of this mod, notify them of this error if possible."
	Debug.TraceStack(log)
	if SexLabUtil.GetAPI().Config.DebugMode
		MiscUtil.PrintConsole(log)
	endIf
endFunction
