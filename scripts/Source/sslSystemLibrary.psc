scriptname sslSystemLibrary extends Quest

; Settings access
sslSystemConfig property Config auto

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

; Data
Actor property PlayerRef auto

function Setup()
	UnregisterForUpdate()
	GoToState("")
	LoadLibs()
endFunction

bool function CheckLibs()
	return Config && ActorLib && ThreadLib && Stats && ThreadSlots && AnimSlots && CreatureSlots && VoiceSlots && ExpressionSlots && PlayerRef
endFunction

function LoadLibs()
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
	; Sync Player
	if !PlayerRef
		PlayerRef = Game.GetPlayer()
	endIf
endFunction

function Log(string Log, string Type = "NOTICE")
	Log = Type+": "+Log
	if Config.DebugMode
		SexLabUtil.PrintConsole(Log)
	endIf
	if Type == "FATAL"
		Debug.TraceStack("SEXLAB - "+Log)
	else
		Debug.Trace("SEXLAB - "+Log)
	endIf
endFunction
