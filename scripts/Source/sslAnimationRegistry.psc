scriptname sslAnimationRegistry extends Quest

sslBaseAnimation[] Registry
Scene[] AnimationSlots
bool locked

int property FreeSlot hidden
	int function get()
		int i = 0
		while i < Registry.Length
			if Registry[i] == none || Registry[i].Registrar == ""
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
		aid = FreeSlot
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
	while i < Registry.Length
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
	while i < Registry.Length
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
	while i < Registry.Length
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

sslBaseAnimation function GetBySlot(int slot)
	return Registry[slot]
endFunction

;/-----------------------------------------------\;
;|	Locate Animations                            |;
;\-----------------------------------------------/;

int function FindByName(string findName)
	int i = 0
	while i < Registry.Length
		if Registry[i] != none && Registry[i].name == findName
			return i
		endIf
		i += 1
	endWhile
	return -1
endFunction

int function FindByRegistrar(string id)
	int i = 0
	while i < Registry.Length
		if Registry[i] != none && Registry[i].Registrar == id
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
	while i < Registry.Length
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


Scene property SexLabAnimationSlot000 auto
Scene property SexLabAnimationSlot001 auto
; Scene property SexLabAnimationSlot002 auto
; Scene property SexLabAnimationSlot003 auto
; Scene property SexLabAnimationSlot004 auto
; Scene property SexLabAnimationSlot005 auto
; Scene property SexLabAnimationSlot006 auto
; Scene property SexLabAnimationSlot007 auto
; Scene property SexLabAnimationSlot008 auto
; Scene property SexLabAnimationSlot009 auto

function _Setup()
	locked = true

	Registry = new sslBaseAnimation[2]
	Registry[0] = SexLabAnimationSlot000 as sslBaseAnimation
	Registry[1] = SexLabAnimationSlot001 as sslBaseAnimation
	; Registry[2] = SexLabAnimationSlot002 as sslBaseAnimation
	; Registry[3] = SexLabAnimationSlot003 as sslBaseAnimation
	; Registry[4] = SexLabAnimationSlot004 as sslBaseAnimation
	; Registry[5] = SexLabAnimationSlot005 as sslBaseAnimation
	; Registry[6] = SexLabAnimationSlot006 as sslBaseAnimation
	; Registry[7] = SexLabAnimationSlot007 as sslBaseAnimation
	; Registry[8] = SexLabAnimationSlot008 as sslBaseAnimation
	; Registry[9] = SexLabAnimationSlot009 as sslBaseAnimation

	int i
	while i < Registry.Length
		Registry[i].UnloadAnimation()
		i += 1
	endWhile

	locked = false
endFunction


sslAnimationDefaults property Defaults auto
function _Load()
	Defaults.LoadAnimations()
endFunction

function _WaitLock()
	while locked
		Utility.Wait(0.25)
	endWhile
	locked = true
endFunction
