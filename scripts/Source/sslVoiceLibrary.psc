scriptname sslVoiceLibrary extends Quest
{DEPRECATED: This script is a proxy for the original sslConfigMenu script which has been replaced, and is only provided as a means to provide backwards compatibility by redirecting all it's functions to their new iterations}




function DEPRECATED()
	string log = "SexLab DEPRECATED -- sslVoiceLibrary.psc -- Use of this script has been deprecated, the mod that called this function should be updated as soon as possible. If you are not the author of this mod, notify them of this error if possible."
	Debug.TraceStack(log)
	if SSL.Config.DebugMode
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





sslVoiceSlots property Slots hidden
	sslVoiceSlots function get()
		DEPRECATED()
		return SSL.VoiceSlots
	endFunction
endProperty
VoiceType property SexLabVoiceM hidden
	VoiceType function get()
		DEPRECATED()
		return SSL.Config.SexLabVoiceM
	endFunction
endProperty
VoiceType property SexLabVoiceF hidden
	VoiceType function get()
		DEPRECATED()
		return SSL.Config.SexLabVoiceF
	endFunction
endProperty
FormList property VoicesPlayer hidden
	FormList function get()
		DEPRECATED()
		return SSL.Config.SexLabVoices
	endFunction
endProperty
string property sPlayerVoice hidden
	string function get()
		DEPRECATED()
		return SSL.VoiceSlots.GetSavedName(Game.GetPlayer())
	endFunction
endProperty
bool property bNPCSaveVoice hidden
	bool function get()
		DEPRECATED()
		return SSL.Config.NPCSaveVoice
	endFunction
endProperty
sslBaseVoice function PickVoice(actor a)
	DEPRECATED()
	return SSL.VoiceSlots.PickVoice(a)
endFunction
function SaveVoice(actor a, sslBaseVoice Voice)
	DEPRECATED()
	SSL.VoiceSlots.SaveVoice(a, Voice)
endFunction
function ForgetVoice(actor a)
	DEPRECATED()
	SSL.VoiceSlots.ForgetVoice(a)
endFunction
sslBaseVoice function GetVoice(actor a)
	DEPRECATED()
	return SSL.VoiceSlots.PickVoice(a)
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
		return SSL.AnimLib
	endFunction
endProperty
sslVoiceLibrary property VoiceLib hidden
	sslVoiceLibrary function get()
		DEPRECATED()
		return SSL.VoiceLib
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
; sslControlLibrary property ControlLib hidden
; 	sslControlLibrary function get()
; 		DEPRECATED()
; 		return SSL.ControlLib
; 	endFunction
; endProperty
sslExpressionLibrary property ExpressionLib hidden
	sslExpressionLibrary function get()
		DEPRECATED()
		return SSL.ExpressionLib
	endFunction
endProperty
sslAnimationSlots property Animations hidden
	sslAnimationSlots function get()
		DEPRECATED()
		return SSL.AnimSlots
	endFunction
endProperty
sslCreatureAnimationSlots property CreatureAnimations hidden
	sslCreatureAnimationSlots function get()
		DEPRECATED()
		return SSL.CreatureSlots
	endFunction
endProperty
sslVoiceSlots property Voices hidden
	sslVoiceSlots function get()
		DEPRECATED()
		return SSL.VoiceSlots
	endFunction
endProperty
sslThreadSlots property Threads hidden
	sslThreadSlots function get()
		DEPRECATED()
		return SSL.ThreadSlots
	endFunction
endProperty
sslExpressionSlots property Expressions hidden
	sslExpressionSlots function get()
		DEPRECATED()
		return SSL.ExpressionSlots
	endFunction
endProperty
sslActorStats property ActorStats hidden
	sslActorStats function get()
		DEPRECATED()
		return SSL.Stats
	endFunction
endProperty

