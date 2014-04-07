scriptname sslSystemAlias extends ReferenceAlias

Actor property PlayerRef auto hidden

; Settings access
sslSystemConfig property Config auto hidden

; Function libraries
sslActorStats property Stats auto hidden

; Object registeries
sslAnimationSlots property AnimSlots auto hidden
sslCreatureAnimationSlots property CreatureSlots auto hidden
sslVoiceSlots property VoiceSlots auto hidden
sslExpressionSlots property ExpressionSlots auto hidden

; StorageUtil form key
Form property Storage auto hidden

function Log(string Log, string Type = "NOTICE")
	SexLabUtil.DebugLog(Log, Type, Config.DebugMode)
endFunction

function Setup()
	Storage = Game.GetFormFromFile(0xD62, "SexLab.esm")
	SexLabFramework SexLab = Storage as SexLabFramework
	; Sync resources across framework
	PlayerRef       = SexLab.PlayerRef
	Config          = SexLab.Config
	Stats           = SexLab.Stats
	AnimSlots       = SexLab.AnimSlots
	CreatureSlots   = SexLab.CreatureSlots
	VoiceSlots      = SexLab.VoiceSlots
	ExpressionSlots = SexLab.ExpressionSlots
	TryToClear()
endFunction
