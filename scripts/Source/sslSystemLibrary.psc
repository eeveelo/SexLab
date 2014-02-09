scriptname sslSystemLibrary extends Quest

Actor property PlayerRef auto

; Libraries
sslSystemConfig property Config auto hidden
; sslAnimationLibrary property AnimLib auto
; sslVoiceLibrary property VoiceLib auto
; sslThreadLibrary property ThreadLib auto
sslActorLibrary property ActorLib auto
; sslControlLibrary property ControlLib auto
; sslExpressionLibrary property ExpressionLib auto

; Object Registeries
; sslAnimationSlots property Animations auto
; sslCreatureAnimationSlots property CreatureAnimations auto
; sslVoiceSlots property Voices auto
sslThreadSlots property Threads auto hidden
; sslActorSlots property Actors auto
; sslExpressionSlots property Expressions auto

; Misc
; sslActorStats property ActorStats auto

function _Setup()
	PlayerRef = Game.GetPlayer()
	Config = Quest.GetQuest("SexLabQuestFramework") as sslSystemConfig
	ActorLib = Quest.GetQuest("SexLabQuestFramework") as sslActorLibrary
	Threads = Quest.GetQuest("SexLabQuestFramework") as sslThreadSlots
endFunction

event OnInit()
	_Setup()
endEvent
