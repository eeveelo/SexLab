scriptname sslThreadLibrary extends Quest

; Scripts
sslAnimationSlots property Animations auto
sslVoiceLibrary property Voices auto
sslActorLibrary property Actors auto

; Data
actor property PlayerRef auto
FormList property BedsList auto
sound property sfxSquishing01 auto
sound property sfxSucking01 auto
sound property sfxSexMix01 auto
Static property LocationMarker auto
ActorBase property SexLabStager auto
message property mAdjustChange auto
message property mUseBed auto
message property mMoveScene auto

; Config Settings
float property fSFXDelay auto hidden
float property fSFXVolume auto hidden
bool property bAutoAdvance auto hidden
bool property bForeplayStage auto hidden
string property sNPCBed auto hidden
float[] property fStageTimer auto hidden
float[] property fStageTimerLeadIn auto hidden
float[] property fStageTimerAggr auto hidden

Sound function GetSFX(int id)
	; Squishing
	if id == 1
		return sfxSquishing01
	; Sucking
	elseIf id == 2
		return sfxSucking01
	; SexMix
	elseIf id == 3
		return sfxSexMix01
	; Empty
	else
		return none
	endIf
endFunction

function _Defaults()
	; Config
	fSFXDelay = 4.0
	fSFXVolume = 0.8
	bAutoAdvance = true
	bForeplayStage = true
	sNPCBed = "$SSL_Never"

	; Timers
	fStageTimer = new float[5]
	fStageTimer[0] = 30.0
	fStageTimer[1] = 20.0
	fStageTimer[2] = 15.0
	fStageTimer[3] = 15.0
	fStageTimer[4] = 9.0

	fStageTimerLeadIn = new float[5]
	fStageTimerLeadIn[0] = 10.0
	fStageTimerLeadIn[1] = 10.0
	fStageTimerLeadIn[2] = 10.0
	fStageTimerLeadIn[3] = 8.0
	fStageTimerLeadIn[4] = 8.0

	fStageTimerAggr = new float[5]
	fStageTimerAggr[0] = 20.0
	fStageTimerAggr[1] = 15.0
	fStageTimerAggr[2] = 10.0
	fStageTimerAggr[3] = 10.0
	fStageTimerAggr[4] = 3.0
endFunction