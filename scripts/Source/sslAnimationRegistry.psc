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


sslBaseAnimation property SexLabAnimationSlot000 auto
sslBaseAnimation property SexLabAnimationSlot001 auto
sslBaseAnimation property SexLabAnimationSlot002 auto
sslBaseAnimation property SexLabAnimationSlot003 auto
sslBaseAnimation property SexLabAnimationSlot004 auto
sslBaseAnimation property SexLabAnimationSlot005 auto
sslBaseAnimation property SexLabAnimationSlot006 auto
sslBaseAnimation property SexLabAnimationSlot007 auto
sslBaseAnimation property SexLabAnimationSlot008 auto
sslBaseAnimation property SexLabAnimationSlot009 auto
sslBaseAnimation property SexLabAnimationSlot010 auto
sslBaseAnimation property SexLabAnimationSlot011 auto
sslBaseAnimation property SexLabAnimationSlot012 auto
sslBaseAnimation property SexLabAnimationSlot013 auto
sslBaseAnimation property SexLabAnimationSlot014 auto
sslBaseAnimation property SexLabAnimationSlot015 auto
sslBaseAnimation property SexLabAnimationSlot016 auto
sslBaseAnimation property SexLabAnimationSlot017 auto
sslBaseAnimation property SexLabAnimationSlot018 auto
sslBaseAnimation property SexLabAnimationSlot019 auto
sslBaseAnimation property SexLabAnimationSlot020 auto
sslBaseAnimation property SexLabAnimationSlot021 auto
sslBaseAnimation property SexLabAnimationSlot022 auto
sslBaseAnimation property SexLabAnimationSlot023 auto
sslBaseAnimation property SexLabAnimationSlot024 auto
sslBaseAnimation property SexLabAnimationSlot025 auto
sslBaseAnimation property SexLabAnimationSlot026 auto
sslBaseAnimation property SexLabAnimationSlot027 auto
sslBaseAnimation property SexLabAnimationSlot028 auto
sslBaseAnimation property SexLabAnimationSlot029 auto
sslBaseAnimation property SexLabAnimationSlot030 auto
sslBaseAnimation property SexLabAnimationSlot031 auto
sslBaseAnimation property SexLabAnimationSlot032 auto
sslBaseAnimation property SexLabAnimationSlot033 auto
sslBaseAnimation property SexLabAnimationSlot034 auto
sslBaseAnimation property SexLabAnimationSlot035 auto
sslBaseAnimation property SexLabAnimationSlot036 auto
sslBaseAnimation property SexLabAnimationSlot037 auto
sslBaseAnimation property SexLabAnimationSlot038 auto
sslBaseAnimation property SexLabAnimationSlot039 auto
sslBaseAnimation property SexLabAnimationSlot040 auto
sslBaseAnimation property SexLabAnimationSlot041 auto
sslBaseAnimation property SexLabAnimationSlot042 auto
sslBaseAnimation property SexLabAnimationSlot043 auto
sslBaseAnimation property SexLabAnimationSlot044 auto
sslBaseAnimation property SexLabAnimationSlot045 auto
sslBaseAnimation property SexLabAnimationSlot046 auto
sslBaseAnimation property SexLabAnimationSlot047 auto
sslBaseAnimation property SexLabAnimationSlot048 auto
sslBaseAnimation property SexLabAnimationSlot049 auto
sslBaseAnimation property SexLabAnimationSlot050 auto
sslBaseAnimation property SexLabAnimationSlot051 auto
sslBaseAnimation property SexLabAnimationSlot052 auto
sslBaseAnimation property SexLabAnimationSlot053 auto
sslBaseAnimation property SexLabAnimationSlot054 auto
sslBaseAnimation property SexLabAnimationSlot055 auto
sslBaseAnimation property SexLabAnimationSlot056 auto
sslBaseAnimation property SexLabAnimationSlot057 auto
sslBaseAnimation property SexLabAnimationSlot058 auto
sslBaseAnimation property SexLabAnimationSlot059 auto
sslBaseAnimation property SexLabAnimationSlot060 auto
sslBaseAnimation property SexLabAnimationSlot061 auto
sslBaseAnimation property SexLabAnimationSlot062 auto
sslBaseAnimation property SexLabAnimationSlot063 auto
sslBaseAnimation property SexLabAnimationSlot064 auto
sslBaseAnimation property SexLabAnimationSlot065 auto
sslBaseAnimation property SexLabAnimationSlot066 auto
sslBaseAnimation property SexLabAnimationSlot067 auto
sslBaseAnimation property SexLabAnimationSlot068 auto
sslBaseAnimation property SexLabAnimationSlot069 auto
sslBaseAnimation property SexLabAnimationSlot070 auto
sslBaseAnimation property SexLabAnimationSlot071 auto
sslBaseAnimation property SexLabAnimationSlot072 auto
sslBaseAnimation property SexLabAnimationSlot073 auto
sslBaseAnimation property SexLabAnimationSlot074 auto

function _Setup()
	locked = true

	Registry = new sslBaseAnimation[75]
	Registry[0] = SexLabAnimationSlot000
	Registry[1] = SexLabAnimationSlot001
	Registry[2] = SexLabAnimationSlot002
	Registry[3] = SexLabAnimationSlot003
	Registry[4] = SexLabAnimationSlot004
	Registry[5] = SexLabAnimationSlot005
	Registry[6] = SexLabAnimationSlot006
	Registry[7] = SexLabAnimationSlot007
	Registry[8] = SexLabAnimationSlot008
	Registry[9] = SexLabAnimationSlot009
	Registry[10] = SexLabAnimationSlot010
	Registry[11] = SexLabAnimationSlot011
	Registry[12] = SexLabAnimationSlot012
	Registry[13] = SexLabAnimationSlot013
	Registry[14] = SexLabAnimationSlot014
	Registry[15] = SexLabAnimationSlot015
	Registry[16] = SexLabAnimationSlot016
	Registry[17] = SexLabAnimationSlot017
	Registry[18] = SexLabAnimationSlot018
	Registry[19] = SexLabAnimationSlot019
	Registry[20] = SexLabAnimationSlot020
	Registry[21] = SexLabAnimationSlot021
	Registry[22] = SexLabAnimationSlot022
	Registry[23] = SexLabAnimationSlot023
	Registry[24] = SexLabAnimationSlot024
	Registry[25] = SexLabAnimationSlot025
	Registry[26] = SexLabAnimationSlot026
	Registry[27] = SexLabAnimationSlot027
	Registry[28] = SexLabAnimationSlot028
	Registry[29] = SexLabAnimationSlot029
	Registry[30] = SexLabAnimationSlot030
	Registry[31] = SexLabAnimationSlot031
	Registry[32] = SexLabAnimationSlot032
	Registry[33] = SexLabAnimationSlot033
	Registry[34] = SexLabAnimationSlot034
	Registry[35] = SexLabAnimationSlot035
	Registry[36] = SexLabAnimationSlot036
	Registry[37] = SexLabAnimationSlot037
	Registry[38] = SexLabAnimationSlot038
	Registry[39] = SexLabAnimationSlot039
	Registry[40] = SexLabAnimationSlot040
	Registry[41] = SexLabAnimationSlot041
	Registry[42] = SexLabAnimationSlot042
	Registry[43] = SexLabAnimationSlot043
	Registry[44] = SexLabAnimationSlot044
	Registry[45] = SexLabAnimationSlot045
	Registry[46] = SexLabAnimationSlot046
	Registry[47] = SexLabAnimationSlot047
	Registry[48] = SexLabAnimationSlot048
	Registry[49] = SexLabAnimationSlot049
	Registry[50] = SexLabAnimationSlot050
	Registry[51] = SexLabAnimationSlot051
	Registry[52] = SexLabAnimationSlot052
	Registry[53] = SexLabAnimationSlot053
	Registry[54] = SexLabAnimationSlot054
	Registry[55] = SexLabAnimationSlot055
	Registry[56] = SexLabAnimationSlot056
	Registry[57] = SexLabAnimationSlot057
	Registry[58] = SexLabAnimationSlot058
	Registry[59] = SexLabAnimationSlot059
	Registry[60] = SexLabAnimationSlot060
	Registry[61] = SexLabAnimationSlot061
	Registry[62] = SexLabAnimationSlot062
	Registry[63] = SexLabAnimationSlot063
	Registry[64] = SexLabAnimationSlot064
	Registry[65] = SexLabAnimationSlot065
	Registry[66] = SexLabAnimationSlot066
	Registry[67] = SexLabAnimationSlot067
	Registry[68] = SexLabAnimationSlot068
	Registry[69] = SexLabAnimationSlot069
	Registry[70] = SexLabAnimationSlot070
	Registry[71] = SexLabAnimationSlot071
	Registry[72] = SexLabAnimationSlot072
	Registry[73] = SexLabAnimationSlot073
	Registry[74] = SexLabAnimationSlot074

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
