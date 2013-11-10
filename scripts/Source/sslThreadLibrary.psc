scriptname sslThreadLibrary extends Quest

; Scripts
sslAnimationSlots property Animations auto
sslCreatureAnimationSlots property CreatureAnimations auto
sslVoiceLibrary property Voices auto
sslActorLibrary property Actors auto
sslExpressionLibrary property Expressions auto

; Data
actor property PlayerRef auto

sound property sfxSquishing01 auto
sound property sfxSucking01 auto
sound property sfxSexMix01 auto
Static property LocationMarker auto
ActorBase property SexLabStager auto
FormList property BedsList auto
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

int function FindNext(actor[] Positions, sslBaseAnimation Animation, int offset, bool findCreature)
	while offset
		offset -= 1
		if Animation.HasRace(Positions[offset].GetLeveledActorBase().GetRace()) == findCreature
			return offset
		endIf
	endwhile
	return -1
endFunction


ObjectReference function FindBed(ObjectReference centerRef, float radius = 1000.0, bool ignoreUsed = true, ObjectReference ignore1 = none, ObjectReference ignore2 = none)
	if centerRef == none || radius < 0
		return none ; Invalid args
	endIf
	; Create supression list
	form[] supress = new Form[12]
	supress[11] = ignore1
	supress[10] = ignore2
	; Attempt 10 times before giving up
	int attempts = 10
	while attempts
		attempts -= 1
		; Find nearby
		ObjectReference BedRef = Game.FindRandomReferenceOfAnyTypeInListFromRef(BedsList, centerRef, radius)
		if BedRef == none
			return none ; If none, than none in radius, give up now.
		elseIf supress.Find(BedRef) == -1
			; Add to supression list
			supress[attempts] = BedRef
			; Check if free
			if !ignoreUsed || (ignoreUsed && !BedRef.IsFurnitureInUse(true))
				return BedRef
			endIf
		endIf
	endWhile
	; No beds found in attempts
	return none
endFunction

actor[] function SortCreatures(actor[] Positions, sslBaseAnimation Animation)
	if Positions.Length < 2 || !Animation.IsCreature
		return Positions ; Nothing to sort
	endIf
	int slot
	int i
	while i < Positions.Length
		; Put non creatures first
		if !Animation.HasRace(Positions[i].GetLeveledActorBase().GetRace()) && i > slot
			actor moved = Positions[slot]
			Positions[slot] = Positions[i]
			Positions[i] = moved
			slot += 1
		endIf
		i += 1
	endWhile
	return Positions
endFunction

function _Defaults()
	; Config
	fSFXDelay = 4.0
	fSFXVolume = 0.8
	bAutoAdvance = true
	bForeplayStage = false
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
