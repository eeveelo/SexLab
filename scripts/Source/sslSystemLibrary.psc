scriptname sslSystemLibrary extends Quest

Actor property PlayerRef auto

; Libraries
sslSystemConfig property Config auto hidden

sslActorLibrary property ActorLib auto hidden
sslThreadLibrary property ThreadLib auto hidden
sslActorStats property Stats auto hidden

; Object Registeries
sslAnimationSlots property AnimSlots auto hidden
sslCreatureAnimationSlots property CreatureSlots auto hidden
sslVoiceSlots property VoiceSlots auto hidden
sslThreadSlots property ThreadSlots auto hidden

; Misc

function Log(string Log, string Type = "NOTICE")
	SexLabUtil.DebugLog(Log, Type, Config.DebugMode)
endFunction

function Setup()
	Config        = Quest.GetQuest("SexLabQuestFramework") as sslSystemConfig
	ActorLib      = Quest.GetQuest("SexLabQuestFramework") as sslActorLibrary
	ThreadLib     = Quest.GetQuest("SexLabQuestFramework") as sslThreadLibrary
	Stats         = Quest.GetQuest("SexLabQuestFramework") as sslActorStats
	ThreadSlots   = Quest.GetQuest("SexLabQuestFramework") as sslThreadSlots
	AnimSlots     = Quest.GetQuest("SexLabQuestAnimations") as sslAnimationSlots
	CreatureSlots = Quest.GetQuest("SexLabQuestCreatureAnimations") as sslCreatureAnimationSlots
	VoiceSlots    = Quest.GetQuest("SexLabQuestRegistry") as sslVoiceSlots
endFunction

event OnInit()
	Setup()
endEvent
