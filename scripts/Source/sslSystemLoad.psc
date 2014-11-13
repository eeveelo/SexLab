scriptname sslSystemLoad extends ReferenceAlias

SexLabFramework property SexLab auto
sslSystemConfig property Config auto
Actor property PlayerRef auto

event OnInit()
endEvent

event OnPlayerLoadGame()
	Log("SexLab Loading...", "Loading")

	; Load Libraries if not set
	if !SexLab || !Config
		Log("Reloading Scripts["+SexLab+", "+Config+"]", "Loading")
		Form SexLabQuestFramework = Game.GetFormFromFile(0xD62, "SexLab.esm")
		if SexLabQuestFramework
			SexLab = SexLabQuestFramework as SexLabFramework
			Config = SexLabQuestFramework as sslSystemConfig
		else
			Log("FAILED TO LOAD \"SexLabQuestFramework\", SEXLAB WILL BE UNABLE TO LOAD PROPERLY!", "FATAL")
		endIf
	endIf
	if !PlayerRef
		PlayerRef = Game.GetPlayer()
	endIf

	; DEV TEMP
	Config.DebugMode = true
	; /DEV TEMP

	if Config.CheckSystem()
		Config.Reload()
	else
		SexLab.GoToState("Disabled")
	endIf

	Log("SexLab Loaded CurrentVerison: "+SexLabUtil.GetVersion(), "Loading")
endEvent

function Log(string Log, string Type = "NOTICE")
	Log = "SEXLAB - "+Type+": "+Log
	SexLabUtil.PrintConsole(Log)
	Debug.Trace(Log)
endFunction

