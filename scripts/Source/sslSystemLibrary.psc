scriptname sslSystemLibrary extends Quest

Actor property PlayerRef auto

; Libraries
sslSystemConfig property Config auto hidden
sslAnimationLibrary property AnimLib auto hidden
sslThreadLibrary property ThreadLib auto hidden
sslActorLibrary property ActorLib auto hidden
sslVoiceLibrary property VoiceLib auto hidden
; sslExpressionLibrary property ExpressionLib auto

; Object Registeries
sslAnimationSlots property AnimSlots auto hidden
; sslCreatureAnimationSlots property CreatureAnimations auto
sslVoiceSlots property VoiceSlots auto hidden
sslThreadSlots property ThreadSlots auto hidden
; sslExpressionSlots property Expressions auto

; Misc
sslActorStats property Stats auto hidden

function Log(string Log, string Type = "NOTICE")
	SexLabUtil.DebugLog(Log, Type, Config.DebugMode)
endFunction

function Setup()
	; PlayerRef = Game.GetPlayer()
	Config = Quest.GetQuest("SexLabQuestFramework") as sslSystemConfig
	AnimLib = Quest.GetQuest("SexLabQuestFramework") as sslAnimationLibrary
	ActorLib = Quest.GetQuest("SexLabQuestFramework") as sslActorLibrary
	ThreadLib = Quest.GetQuest("SexLabQuestFramework") as sslThreadLibrary
	VoiceLib = Quest.GetQuest("SexLabQuestFramework") as sslVoiceLibrary

	ThreadSlots = Quest.GetQuest("SexLabQuestFramework") as sslThreadSlots
	AnimSlots = Quest.GetQuest("SexLabQuestAnimations") as sslAnimationSlots
	VoiceSlots = Quest.GetQuest("SexLabQuestRegistry") as sslVoiceSlots

	Stats = Quest.GetQuest("SexLabQuestFramework") as sslActorStats
endFunction

event OnInit()
	Setup()
endEvent
