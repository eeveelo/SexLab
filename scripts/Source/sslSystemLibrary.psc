scriptname sslSystemLibrary extends Quest

Actor property PlayerRef auto

; Libraries
sslSystemConfig property Config auto hidden

sslActorLibrary property ActorLib auto hidden
sslThreadLibrary property ThreadLib auto hidden
sslActorStats property Stats auto hidden

; Object Registeries
sslThreadSlots property ThreadSlots auto hidden
sslAnimationSlots property AnimSlots auto hidden
sslCreatureAnimationSlots property CreatureSlots auto hidden
sslVoiceSlots property VoiceSlots auto hidden
sslExpressionSlots property ExpressionSlots auto hidden

; Misc

function Log(string Log, string Type = "NOTICE")
	SexLabUtil.DebugLog(Log, Type, Config.DebugMode)
endFunction

function Setup()
	Quest SexLabQuestFramework  = Quest.GetQuest("SexLabQuestFramework")
	Config          = SexLabQuestFramework as sslSystemConfig
	ActorLib        = SexLabQuestFramework as sslActorLibrary
	ThreadLib       = SexLabQuestFramework as sslThreadLibrary
	Stats           = SexLabQuestFramework as sslActorStats
	ThreadSlots     = SexLabQuestFramework as sslThreadSlots
	Quest SexLabQuestAnimations = Quest.GetQuest("SexLabQuestAnimations")
	AnimSlots       = SexLabQuestAnimations as sslAnimationSlots
	Quest SexLabQuestRegistry   = Quest.GetQuest("SexLabQuestRegistry")
	CreatureSlots   = SexLabQuestRegistry as sslCreatureAnimationSlots
	VoiceSlots      = SexLabQuestRegistry as sslVoiceSlots
	ExpressionSlots = SexLabQuestRegistry as sslExpressionSlots
endFunction

; event OnInit()
; 	Setup()
; endEvent
