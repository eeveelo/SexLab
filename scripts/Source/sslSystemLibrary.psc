scriptname sslSystemLibrary extends Quest

Actor property PlayerRef auto hidden

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

function Log(string Log, string Type = "NOTICE")
	SexLabUtil.DebugLog(Log, Type, Config.DebugMode)
endFunction

function Setup()
	; Clean script of events
	UnregisterForUpdate()
	GoToState("")
	; Sync Player
	if !PlayerRef
		PlayerRef = Game.GetPlayer()
	endIf
	; Sync function Libraries - SexLabQuestFramework
	Quest SexLabQuestFramework  = Game.GetFormFromFile(0xD62, "SexLab.esm") as Quest
	if SexLabQuestFramework
		Config      = SexLabQuestFramework as sslSystemConfig
		ThreadLib   = SexLabQuestFramework as sslThreadLibrary
		ThreadSlots = SexLabQuestFramework as sslThreadSlots
		ActorLib    = SexLabQuestFramework as sslActorLibrary
		Stats       = SexLabQuestFramework as sslActorStats
	endIf
	; Sync animation registry - SexLabQuestAnimations
	Quest SexLabQuestAnimations = Game.GetFormFromFile(0x639DF, "SexLab.esm") as Quest
	if SexLabQuestAnimations
		AnimSlots = SexLabQuestAnimations as sslAnimationSlots
	endIf
	; Sync secondary object registry - SexLabQuestRegistry
	Quest SexLabQuestRegistry   = Game.GetFormFromFile(0x664FB, "SexLab.esm") as Quest
	if SexLabQuestRegistry
		CreatureSlots   = SexLabQuestRegistry as sslCreatureAnimationSlots
		VoiceSlots      = SexLabQuestRegistry as sslVoiceSlots
		ExpressionSlots = SexLabQuestRegistry as sslExpressionSlots
	endIf
endFunction

bool function TestLibrary()
	return PlayerRef && Config && ActorLib && ThreadLib && Stats && ThreadSlots && AnimSlots && CreatureSlots && VoiceSlots && ExpressionSlots
endFunction
