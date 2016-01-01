scriptname sslSystemLibrary extends Quest hidden

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
	; Watch for SexLabDebugMode event
	RegisterForModEvent("SexLabDebugMode", "SetDebugMode")
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

bool property InDebugMode auto hidden
event SetDebugMode(bool ToMode)
	InDebugMode = ToMode
	; SexLabUtil.PrintConsole("SEXLABTEST: "+self+ "SET DEBUG MODE ["+ToMode+"]")
	; Debug.Trace("SEXLABTEST: "+self+ "SET DEBUG MODE ["+ToMode+"]")
endEvent

function Log(string msg, string Type = "NOTICE")
	msg = Type+": "+msg
	if InDebugMode
		SexLabUtil.PrintConsole(msg)
		Debug.TraceUser("SexLabDebug", msg)
	endIf
	if Type == "FATAL"
		Debug.TraceStack("SEXLAB - "+msg)
	else
		Debug.Trace("SEXLAB - "+msg)
	endIf
endFunction
