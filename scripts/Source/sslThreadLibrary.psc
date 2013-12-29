scriptname sslThreadLibrary extends sslSystemLibrary

; Data
sound property sfxSquishing01 auto
sound property sfxSucking01 auto
sound property sfxSexMix01 auto
sound property OrgasmEffect auto
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
bool property bOrgasmEffects auto hidden
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

bool function IsActorFree(actor position)
	return Threads.FindActorController(position) == -1
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
	fSFXVolume = 1.0
	bAutoAdvance = true
	bForeplayStage = false
	bOrgasmEffects = false
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
function _Export()
	_ExportFloat("fSFXDelay", fSFXDelay)
	_ExportFloat("fSFXVolume", fSFXVolume)
	_ExportBool("bAutoAdvance", bAutoAdvance)
	_ExportBool("bForeplayStage", bForeplayStage)
	_ExportBool("bOrgasmEffects", bOrgasmEffects)
	_ExportString("sNPCBed", sNPCBed)
	; Timers
	_ExportFloatList("fStageTimer", fStageTimer, 5)
	_ExportFloatList("fStageTimerLeadIn", fStageTimerLeadIn, 5)
	_ExportFloatList("fStageTimerAggr", fStageTimerAggr, 5)
endFunction
function _Import()
	_Defaults()
	fSFXDelay = _ImportFloat("fSFXDelay", fSFXDelay)
	fSFXVolume = _ImportFloat("fSFXVolume", fSFXVolume)
	bAutoAdvance = _ImportBool("bAutoAdvance", bAutoAdvance)
	bForeplayStage = _ImportBool("bForeplayStage", bForeplayStage)
	bOrgasmEffects = _ImportBool("bOrgasmEffects", bOrgasmEffects)
	sNPCBed = _ImportString("sNPCBed", sNPCBed)
	fStageTimer = _ImportFloatList("fStageTimer", fStageTimer, 5)
	fStageTimerLeadIn = _ImportFloatList("fStageTimerLeadIn", fStageTimerLeadIn, 5)
	fStageTimerAggr = _ImportFloatList("fStageTimerAggr", fStageTimerAggr, 5)
endFunction
