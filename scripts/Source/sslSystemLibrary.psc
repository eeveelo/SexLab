scriptname sslSystemLibrary extends Quest hidden

; Settings access
sslSystemConfig property Config auto hidden

; Function libraries
sslActorLibrary property ActorLib auto hidden
sslThreadLibrary property ThreadLib auto hidden
sslActorStats property Stats auto hidden

; Object registeries
sslThreadSlots property ThreadSlots auto hidden
sslAnimationSlots property AnimSlots auto hidden
sslCreatureAnimationSlots property CreatureSlots auto hidden
sslVoiceSlots property VoiceSlots auto hidden
sslExpressionSlots property ExpressionSlots auto hidden

; Data
Actor property PlayerRef auto hidden

function LoadLibs(bool Forced = false)
	; Sync function Libraries - SexLabQuestFramework
	if Forced || !Config || !ThreadLib || !ThreadSlots || !ActorLib || !Stats
		Form SexLabQuestFramework  = Game.GetFormFromFile(0xD62, "SexLab.esm")
		if SexLabQuestFramework
			Config      = SexLabQuestFramework as sslSystemConfig
			ThreadLib   = SexLabQuestFramework as sslThreadLibrary
			ThreadSlots = SexLabQuestFramework as sslThreadSlots
			ActorLib    = SexLabQuestFramework as sslActorLibrary
			Stats       = SexLabQuestFramework as sslActorStats
		endIf
	endIf
	; Sync animation registry - SexLabQuestAnimations
	if Forced || !AnimSlots
		Form SexLabQuestAnimations = Game.GetFormFromFile(0x639DF, "SexLab.esm")
		if SexLabQuestAnimations
			AnimSlots = SexLabQuestAnimations as sslAnimationSlots
		endIf
	endIf
	; Sync secondary object registry - SexLabQuestRegistry
	if Forced || !CreatureSlots || !VoiceSlots || !ExpressionSlots
		Form SexLabQuestRegistry   = Game.GetFormFromFile(0x664FB, "SexLab.esm")
		if SexLabQuestRegistry
			CreatureSlots   = SexLabQuestRegistry as sslCreatureAnimationSlots
			ExpressionSlots = SexLabQuestRegistry as sslExpressionSlots
			VoiceSlots      = SexLabQuestRegistry as sslVoiceSlots
		endIf
	endIf
	; Sync data
	if Forced || !PlayerRef
		PlayerRef = Game.GetPlayer()
	endIf
endFunction

function Setup()
	UnregisterForUpdate()
	GoToState("")
	LoadLibs(true)
endFunction

event OnInit()
	LoadLibs(false)
	Debug.Trace("SEXLAB -- Init "+self)
endEvent

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
