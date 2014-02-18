scriptname sslSystemLibrary extends Quest

Actor property PlayerRef auto

; Libraries
sslSystemConfig property Config auto hidden
sslAnimationLibrary property AnimLib auto hidden
; sslVoiceLibrary property VoiceLib auto
sslThreadLibrary property ThreadLib auto hidden
sslActorLibrary property ActorLib auto hidden
; sslControlLibrary property ControlLib auto
; sslExpressionLibrary property ExpressionLib auto

; Object Registeries
sslAnimationSlots property AnimSlots auto hidden
; sslCreatureAnimationSlots property CreatureAnimations auto
sslVoiceSlots property VoiceSlots auto hidden
sslThreadSlots property ThreadSlots auto hidden
; sslActorSlots property Actors auto
; sslExpressionSlots property Expressions auto

; Misc
sslActorStats property ActorStats auto

function Log(string Log, string Type = "NOTICE")
	SexLabUtil.DebugLog(Log, Type, Config.DebugMode)
endFunction

function Setup()
	; PlayerRef = Game.GetPlayer()
	Config = Quest.GetQuest("SexLabQuestFramework") as sslSystemConfig
	AnimLib = Quest.GetQuest("SexLabQuestFramework") as sslAnimationLibrary
	ActorLib = Quest.GetQuest("SexLabQuestFramework") as sslActorLibrary
	ThreadLib = Quest.GetQuest("SexLabQuestFramework") as sslThreadLibrary

	ThreadSlots = Quest.GetQuest("SexLabQuestFramework") as sslThreadSlots
	AnimSlots = Quest.GetQuest("SexLabQuestAnimations") as sslAnimationSlots
	VoiceSlots = Quest.GetQuest("SexLabQuestRegistry") as sslVoiceSlots

	ActorStats = Quest.GetQuest("SexLabQuestRegistry") as sslActorStats
endFunction

event OnInit()
	Setup()
endEvent
