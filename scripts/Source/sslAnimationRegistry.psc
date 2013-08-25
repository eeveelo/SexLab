scriptname sslAnimationRegistry extends Quest

sslBaseAnimation[] Registry
bool locked

int property Index hidden
	int function get()
		int i = 0
		while i < 128
			if Registry[i] == none || Registry[i].name == ""
				return i
			endIf
			i += 1
		endWhile
		return -1
	endFunction
endProperty

int function Register(sslBaseAnimation Animation)
	_WaitLock()
	int aid = FindByName(Animation.name)
	; Animation not found, register it.
	if aid == -1
		aid = Index
		Registry[aid] = Animation
		Registry[aid].UnloadAnimation()
		Registry[aid].LoadAnimation()
		Debug.Trace("SexLab Register Animation: successfully registered '"+Animation.name+"'")
	endIf
	locked = false
	return aid
endFunction


;/-----------------------------------------------\;
;|	Search Animations                            |;
;\-----------------------------------------------/;

sslBaseAnimation function GetByName(string findName)
	int i = 0
	while i < 128
		if Registry[i] != none && Registry[i].name == findName
			return Registry[i]
		endIf
		i += 1
	endWhile
	return none
endFunction

sslBaseAnimation[] function GetByTag(int actors, string tag1, string tag2 = "", string tag3 = "", string tagSuppress = "", bool requireAll = true)
	sslBaseAnimation[] animReturn
	int i = 0
	while i < 128
		if Registry[i] != none && Registry[i].Enabled && Registry[i].ActorCount() == actors
			bool check1 = Registry[i].HasTag(tag1)
			bool check2 = Registry[i].HasTag(tag2)
			bool check3 = Registry[i].HasTag(tag3)
			bool supress = Registry[i].HasTag(tagSuppress)
			if requireAll && check1 && (check2 || tag2 == "") && (check3 || tag3 == "") && !(supress && tagSuppress != "")
				animReturn = sslUtility.PushAnimation(Registry[i], animReturn)
			elseif !requireAll && (check1 || check2 || check3) && !(supress && tagSuppress != "")
				animReturn = sslUtility.PushAnimation(Registry[i], animReturn)
			; else
				; debug.trace("Rejecting "+Registry[i].name+" based on "+check1+check2+check3+supress)
			endIf
		endIf
		i += 1
	endWhile
	Debug.Trace("SexLab Get Animations By Tag Count: "+animReturn.Length)
	Debug.Trace("SexLab Get Animations By Tag: "+animReturn)
	return animReturn
endFunction

sslBaseAnimation[] function GetByType(int actors, int males = -1, int females = -1, int stages = -1, bool aggressive = false, bool sexual = true, bool restrictAggressive = true)
	sslBaseAnimation[] animReturn
	int i = 0
	while i < 128
		if Registry[i] != none && Registry[i].enabled
			bool accepted = true
			if actors != Registry[i].ActorCount()
				accepted = false
			endIf
			if accepted && males != -1 && males != Registry[i].MaleCount()
				accepted = false
			endIf
			if accepted && females != -1 && females != Registry[i].FemaleCount()
				accepted = false
			endIf
			if accepted && stages != -1 && stages != Registry[i].StageCount()
				accepted = false
			endIf
			if accepted && (aggressive != Registry[i].HasTag("Aggressive") && restrictAggressive)
				accepted = false
			endIf
			if accepted && sexual != Registry[i].IsSexual()
				accepted = false
			endIf
			; Still accepted? Push it's return
			if accepted
				animReturn = sslUtility.PushAnimation(Registry[i], animReturn)
			endIf
		endIf
		i += 1
	endWhile
	Debug.Trace("SexLab Get Animations By Type Count: "+animReturn.Length)
	Debug.Trace("SexLab Get Animations By Type: "+animReturn)
	return animReturn
endFunction

;/-----------------------------------------------\;
;|	Locate Animations                            |;
;\-----------------------------------------------/;

int function FindByName(string findName)
	int i = 0
	while i < 128
		if Registry[i] != none && Registry[i].name == findName
			return i
		endIf
		i += 1
	endWhile
	return -1
endFunction

;/-----------------------------------------------\;
;|	Manage Animations                            |;
;\-----------------------------------------------/;

int function GetCount(bool ignoreDisabled = true)
	int count = 0
	int i = 0
	while i < 128
		if Registry[i] != none && Registry[i].Name == "" && ((ignoreDisabled && Registry[i].Enabled) || !ignoreDisabled)
			count += 1
		endIf
		i += 1
	endWhile
	return count
endFunction

sslBaseAnimation[] function MergeLists(sslBaseAnimation[] list1, sslBaseAnimation[] list2)
	int i = 0
	while i < list2.Length
		list1 = sslUtility.PushAnimation(list2[i], list1)
		i += 1
	endWhile
	return list1
endFunction

;/-----------------------------------------------\;
;|	System Animations                            |;
;\-----------------------------------------------/;

function _Setup()
	Registry = new sslBaseAnimation[128]
	locked = false
endFunction

sslAnimAggrBehind property SexLabAggrBehind auto
sslAnimAggrDoggyStyle property SexLabAggrDoggyStyle auto
sslAnimAggrMissionary property SexLabAggrMissonary auto
sslAnimBoobjob property SexLabBoobjob auto
sslAnimDoggyStyle property SexLabDoggyStyle auto
sslAnimHuggingSex property SexLabHuggingSex auto
sslAnimMissionary property SexLabMissonary auto
sslAnimReverseCowgirl property SexLabReverseCowgirl auto
sslAnimSideways property SexLabSideways auto
sslAnimStanding property SexLabStanding auto
sslAnimTribadism property SexLabTribadism auto

sslAnimArrokBlowjob property ArrokBlowjob auto
sslAnimArrokBoobJob property ArrokBoobJob auto
sslAnimArrokCowgirl property ArrokCowgirl auto
sslAnimArrokDevilsThreeway property ArrokDevilsThreeway auto
sslAnimArrokDoggyStyle property ArrokDoggyStyle auto
sslAnimArrokForeplay property ArrokForeplay auto
sslAnimArrokLegUp property ArrokLegUp auto
sslAnimArrokMaleMasturbation property ArrokMaleMasturbation auto
sslAnimArrokMissionary property ArrokMissionary auto
sslAnimArrokOral property ArrokOral auto
sslAnimArrokReverseCowgirl property ArrokReverseCowgirl auto
sslAnimArrokSideways property ArrokSideways auto
sslAnimArrokStanding property ArrokStanding auto
sslAnimArrokStandingForeplay property ArrokStandingForeplay auto
sslAnimArrokTricycle property ArrokTricycle auto
sslAnimArrokHugFuck property ArrokHugFuck auto
sslAnimArrokLesbian property ArrokLesbian auto
sslAnimArrokSittingForeplay property ArrokSittingForeplay auto
sslAnimArrokAnal property ArrokAnal auto
sslAnimArrokRape property ArrokRape auto

sslAnimAPAnal property APAnal auto
sslAnimAPBedMissionary property APBedMissionary auto
sslAnimAPBlowjob property APBlowjob auto
sslAnimAPBoobjob property APBoobjob auto
sslAnimAPCowgirl property APCowgirl auto
sslAnimAPFemaleSolo property APFemaleSolo auto
sslAnimAPFisting property APFisting auto
sslAnimAPHandjob property APHandjob auto
sslAnimAPKneelBlowjob property APKneelBlowjob auto
sslAnimAPLegUp property APLegUp auto
; sslAnimAPReverseCowgirl property APReverseCowgirl auto ; Buggy Rotation, not used
sslAnimAPShoulder property APShoulder auto
sslAnimAPStandBlowjob property APStandBlowjob auto
sslAnimAPStanding property APStanding auto

sslAnimAPDoggyStyle property APDoggyStyle auto
sslAnimAPHoldLegUp property APHoldLegUp auto
sslAnimAPFaceDown property APFaceDown auto
sslAnimAPSkullFuck property APSkullFuck auto

sslAnimAPUnknown property APUNKNOWN auto

function _Load()
	; MiniLovers
	Register(SexLabAggrBehind)
	Register(SexLabAggrDoggyStyle)
	Register(SexLabAggrMissonary)
	Register(SexLabBoobjob)
	Register(SexLabDoggyStyle)
	Register(SexLabHuggingSex)
	Register(SexLabMissonary)
	Register(SexLabReverseCowgirl)
	Register(SexLabSideways)
	Register(SexLabStanding)
	Register(SexLabTribadism)

	; Arrok
	Register(ArrokBlowjob)
	Register(ArrokBoobJob)
	Register(ArrokCowgirl)
	Register(ArrokDevilsThreeway)
	Register(ArrokDoggyStyle)
	Register(ArrokForeplay)
	Register(ArrokLegUp)
	Register(ArrokMaleMasturbation)
	Register(ArrokMissionary)
	Register(ArrokOral)
	Register(ArrokReverseCowgirl)
	Register(ArrokSideways)
	Register(ArrokStanding)
	Register(ArrokStandingForeplay)
	Register(ArrokTricycle)
	Register(ArrokHugFuck)
	Register(ArrokLesbian)
	Register(ArrokSittingForeplay)
	Register(ArrokAnal)
	Register(ArrokRape)

	; AP
	Register(APAnal)
	Register(APBedMissionary)
	Register(APBlowjob)
	Register(APBoobjob)
	Register(APCowgirl)
	Register(APFemaleSolo)
	Register(APFisting)
	Register(APHandjob)
	Register(APKneelBlowjob)
	Register(APLegUp)
	; Register(APReverseCowgirl) ; Buggy Rotation, not used
	Register(APShoulder)
	Register(APStandBlowjob)
	Register(APStanding)

	;Register(APDoggyStyle) ; Unsure of male position idles
	Register(APHoldLegUp)
	Register(APFaceDown)
	Register(APSkullFuck)
endFunction

function _WaitLock()
	while locked
		Utility.Wait(0.25)
	endWhile
	locked = true
endFunction
