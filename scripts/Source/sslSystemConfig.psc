scriptname sslSystemConfig extends Quest
{ WARNING: This script is no longer used, sslConfigMenu now handles settings. This script only exists as a means of backwards compatibility for accessing config settings. }

; Libraries
sslAnimationLibrary property AnimLib auto
sslVoiceLibrary property VoiceLib auto
sslThreadLibrary property ThreadLib auto
sslActorLibrary property ActorLib auto

; Animation Library
bool property bRestrictAggressive hidden
	bool function get()
		return AnimLib.bRestrictAggressive
	endFunction
endProperty

; Voice Library
string property sPlayerVoice hidden
	string function get()
		return VoiceLib.sPlayerVoice 
	endFunction
endProperty

; Thread Library
float property fSFXDelay hidden
	float function get()
		return ThreadLib.fSFXDelay
	endFunction
endProperty
float property fSFXVolume hidden
	float function get()
		return ThreadLib.fSFXVolume
	endFunction
endProperty
bool property bAutoAdvance hidden
	bool function get()
		return ThreadLib.bAutoAdvance
	endFunction
endProperty
bool property bForeplayStage hidden
	bool function get()
		return ThreadLib.bForeplayStage
	endFunction
endProperty
string property sNPCBed hidden
	string function get()
		return ThreadLib.sNPCBed
	endFunction
endProperty
float[] property fStageTimer hidden
	float[] function get()
		return ThreadLib.fStageTimer
	endFunction
endProperty
float[] property fStageTimerLeadIn hidden
	float[] function get()
		return ThreadLib.fStageTimerLeadIn
	endFunction
endProperty
float[] property fStageTimerAggr hidden
	float[] function get()
		return ThreadLib.fStageTimerAggr
	endFunction
endProperty
bool[] property bStripMale hidden
	bool[] function get()
		return ThreadLib.bStripMale
	endFunction
endProperty
bool[] property bStripFemale hidden
	bool[] function get()
		return ThreadLib.bStripFemale
	endFunction
endProperty
bool[] property bStripLeadInFemale hidden
	bool[] function get()
		return ThreadLib.bStripLeadInFemale
	endFunction
endProperty
bool[] property bStripLeadInMale hidden
	bool[] function get()
		return ThreadLib.bStripLeadInMale
	endFunction
endProperty
bool[] property bStripVictim hidden
	bool[] function get()
		return ThreadLib.bStripVictim
	endFunction
endProperty
bool[] property bStripAggressor hidden
	bool[] function get()
		return ThreadLib.bStripAggressor
	endFunction
endProperty

; Actor Library
bool property bDisablePlayer hidden
	bool function get()
		return ActorLib.bDisablePlayer
	endFunction
endProperty
bool property bEnableTCL hidden 
	bool function get()
		return ActorLib.bEnableTCL
	endFunction
endProperty
bool property bScaleActors hidden
	bool function get()
		return ActorLib.bScaleActors
	endFunction
endProperty
bool property bUseCum hidden
	bool function get()
		return ActorLib.bUseCum
	endFunction
endProperty
bool property bAllowFFCum hidden
	bool function get()
		return ActorLib.bAllowFFCum
	endFunction
endProperty
bool property bUseStrapons hidden
	bool function get()
		return ActorLib.bUseStrapons
	endFunction
endProperty
bool property bReDressVictim hidden
	bool function get()
		return ActorLib.bReDressVictim
	endFunction
endProperty
bool property bRagdollEnd hidden
	bool function get()
		return ActorLib.bRagdollEnd
	endFunction
endProperty
bool property bUseMaleNudeSuit hidden
	bool function get()
		return ActorLib.bUseMaleNudeSuit
	endFunction
endProperty
bool property bUseFemaleNudeSuit hidden
	bool function get()
		return ActorLib.bUseFemaleNudeSuit
	endFunction
endProperty
bool property bUndressAnimation hidden
	bool function get()
		return ActorLib.bUndressAnimation
	endFunction
endProperty
float property fMaleVoiceDelay hidden
	float function get()
		return ActorLib.fMaleVoiceDelay
	endFunction
endProperty
float property fFemaleVoiceDelay hidden
	float function get()
		return ActorLib.fFemaleVoiceDelay
	endFunction
endProperty
float property fVoiceVolume hidden
	float function get()
		return ActorLib.fVoiceVolume
	endFunction
endProperty
float property fCumTimer hidden
	float function get()
		return ActorLib.fCumTimer
	endFunction
endProperty
int property kBackwards hidden
	int function get()
		return ActorLib.kBackwards
	endFunction
endProperty
int property kAdjustStage hidden
	int function get()
		return ActorLib.kAdjustStage
	endFunction
endProperty
int property kAdvanceAnimation hidden
	int function get()
		return ActorLib.kAdvanceAnimation
	endFunction
endProperty
int property kChangeAnimation hidden
	int function get()
		return ActorLib.kChangeAnimation
	endFunction
endProperty
int property kChangePositions hidden
	int function get()
		return ActorLib.kChangePositions
	endFunction
endProperty
int property kAdjustChange hidden
	int function get()
		return ActorLib.kAdjustChange
	endFunction
endProperty
int property kAdjustForward hidden
	int function get()
		return ActorLib.kAdjustForward
	endFunction
endProperty
int property kAdjustSideways hidden
	int function get()
		return ActorLib.kAdjustSideways
	endFunction
endProperty
int property kAdjustUpward hidden
	int function get()
		return ActorLib.kAdjustUpward
	endFunction
endProperty
int property kRealignActors hidden
	int function get()
		return ActorLib.kRealignActors
	endFunction
endProperty
int property kMoveScene hidden
	int function get()
		return ActorLib.kMoveScene
	endFunction
endProperty
int property kRestoreOffsets hidden
	int function get()
		return ActorLib.kRestoreOffsets
	endFunction
endProperty
int property kRotateScene hidden
	int function get()
		return ActorLib.kRotateScene
	endFunction
endProperty