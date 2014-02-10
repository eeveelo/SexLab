scriptname sslSystemLibrary extends Quest

Actor property PlayerRef auto

; Libraries
sslSystemConfig property Config auto hidden
; sslAnimationLibrary property AnimLib auto
; sslVoiceLibrary property VoiceLib auto
sslThreadLibrary property ThreadLib auto hidden
sslActorLibrary property ActorLib auto hidden
; sslControlLibrary property ControlLib auto
; sslExpressionLibrary property ExpressionLib auto

; Object Registeries
sslAnimationSlots property AnimSlots auto hidden
; sslCreatureAnimationSlots property CreatureAnimations auto
; sslVoiceSlots property Voices auto
sslThreadSlots property ThreadSlots auto hidden
; sslActorSlots property Actors auto
; sslExpressionSlots property Expressions auto

; Misc
; sslActorStats property ActorStats auto

function _Setup()
	PlayerRef = Game.GetPlayer()
	Config = Quest.GetQuest("SexLabQuestFramework") as sslSystemConfig
	ActorLib = Quest.GetQuest("SexLabQuestFramework") as sslActorLibrary
	ThreadLib = Quest.GetQuest("SexLabQuestFramework") as sslThreadLibrary

	ThreadSlots = Quest.GetQuest("SexLabQuestFramework") as sslThreadSlots
	AnimSlots = Quest.GetQuest("SexLabQuestAnimations") as sslAnimationSlots
endFunction

event OnInit()
	_Setup()
endEvent
