Scriptname sslSystemAlias extends ReferenceAlias  

SexLabFramework property SexLab Auto

event OnInit()
	SexLab._CheckSystem()
	SexLab._SetupSystem()
	SexLab.Data.LoadAnimations()
	SexLab.Data.LoadVoices()
endEvent

event OnPlayerLoadGame()
	SexLab._CheckSystem()
	Sexlab._StopAnimations()
	SexLab.Data.LoadAnimations()
	SexLab.Data.LoadVoices()
endEvent

