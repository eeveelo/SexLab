scriptname sslAnimationSlots extends Quest

sslAnimationDefaults property Defaults auto
sslAnimationLibrary property Lib auto

sslBaseAnimation[] Slots
sslBaseAnimation[] property Animations hidden
	sslBaseAnimation[] function get()
		return Slots
	endFunction
endProperty

string[] registry
int slotted

bool property FreeSlots hidden
	bool function get()
		return slotted < 100
	endFunction
endProperty

;/-----------------------------------------------\;
;|	Search Animations                            |;
;\-----------------------------------------------/;

sslBaseAnimation function GetByName(string findName)
	int i = 0
	while i < slotted
		if Slots[i].Registered && Slots[i].Name == findName
			return Slots[i]
		endIf
		i += 1
	endWhile
	return none
endFunction

sslBaseAnimation[] function GetByTag(int actors, string tag1, string tag2 = "", string tag3 = "", string tagSuppress = "", bool requireAll = true)
	sslBaseAnimation[] animReturn
	int i = 0
	while i < slotted
		if Slots[i].Registered && Slots[i].Enabled && Slots[i].ActorCount() == actors
			bool check1 = Slots[i].HasTag(tag1)
			bool check2 = Slots[i].HasTag(tag2)
			bool check3 = Slots[i].HasTag(tag3)
			bool supress = Slots[i].HasTag(tagSuppress)
			if requireAll && check1 && (check2 || tag2 == "") && (check3 || tag3 == "") && !(supress && tagSuppress != "")
				animReturn = sslUtility.PushAnimation(Slots[i], animReturn)
			elseif !requireAll && (check1 || check2 || check3) && !(supress && tagSuppress != "")
				animReturn = sslUtility.PushAnimation(Slots[i], animReturn)
			; else
				; debug.trace("Rejecting "+Slots[i].Name+" based on "+check1+check2+check3+supress)
			endIf
		endIf
		i += 1
	endWhile
	; Debug.Trace("SexLab Get Animations By Tag Count: "+animReturn.Length)
	; Debug.Trace("SexLab Get Animations By Tag: "+animReturn)
	return animReturn
endFunction

sslBaseAnimation[] function GetByType(int actors, int males = -1, int females = -1, int stages = -1, bool aggressive = false, bool sexual = true)
	sslBaseAnimation[] animReturn
	int i = 0
	while i < slotted
		if Slots[i].Registered && Slots[i].Enabled
			bool accepted = true
			if actors != Slots[i].ActorCount()
				accepted = false
			endIf
			if accepted && males != -1 && males != Slots[i].MaleCount()
				accepted = false
			endIf
			if accepted && females != -1 && females != Slots[i].FemaleCount()
				accepted = false
			endIf
			if accepted && stages != -1 && stages != Slots[i].StageCount()
				accepted = false
			endIf
			if accepted && (aggressive != Slots[i].HasTag("Aggressive") && Lib.bRestrictAggressive)
				accepted = false
			endIf
			if accepted && sexual != Slots[i].IsSexual()
				accepted = false
			endIf
			; Still accepted? Push it's return
			if accepted
				animReturn = sslUtility.PushAnimation(Slots[i], animReturn)
			endIf
		endIf
		i += 1
	endWhile
	; Debug.Trace("SexLab Get Animations By Type Count: "+animReturn.Length)
	; Debug.Trace("SexLab Get Animations By Type: "+animReturn)
	return animReturn
endFunction

sslBaseAnimation function GetBySlot(int slot)
	return Slots[slot]
endFunction

;/-----------------------------------------------\;
;|	Locate Animations                            |;
;\-----------------------------------------------/;

int function FindByName(string findName)
	int i = 0
	while i < slotted
		if Slots[i].Registered && Slots[i].Name == findName
			return i
		endIf
		i += 1
	endWhile
	return -1
endFunction

int function FindByRegistrar(string registrar)
	return registry.Find(registrar)
endFunction

int function Find(sslBaseAnimation findAnim)
	return Slots.Find(findAnim)
endFunction

;/-----------------------------------------------\;
;|	Manage Animations                            |;
;\-----------------------------------------------/;

sslBaseAnimation function GetFree()
	return Slots[slotted]
endFunction

int function Register(sslBaseAnimation Claiming, string registrar)
	registry = sslUtility.PushString(registrar, registry)
	slotted = registry.Length
	Claiming.Initialize()
	return Slots.Find(Claiming)
endFunction

int function GetCount(bool ignoreDisabled = true)
	if !ignoreDisabled
		return slotted
	endIf
	int count = 0
	int i = 0
	while i < slotted
		if Slots[i].Registered && Slots[i].Enabled
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


sslBaseAnimation property AnimationSlot000 auto
sslBaseAnimation property AnimationSlot001 auto
sslBaseAnimation property AnimationSlot002 auto
sslBaseAnimation property AnimationSlot003 auto
sslBaseAnimation property AnimationSlot004 auto
sslBaseAnimation property AnimationSlot005 auto
sslBaseAnimation property AnimationSlot006 auto
sslBaseAnimation property AnimationSlot007 auto
sslBaseAnimation property AnimationSlot008 auto
sslBaseAnimation property AnimationSlot009 auto
sslBaseAnimation property AnimationSlot010 auto
sslBaseAnimation property AnimationSlot011 auto
sslBaseAnimation property AnimationSlot012 auto
sslBaseAnimation property AnimationSlot013 auto
sslBaseAnimation property AnimationSlot014 auto
sslBaseAnimation property AnimationSlot015 auto
sslBaseAnimation property AnimationSlot016 auto
sslBaseAnimation property AnimationSlot017 auto
sslBaseAnimation property AnimationSlot018 auto
sslBaseAnimation property AnimationSlot019 auto
sslBaseAnimation property AnimationSlot020 auto
sslBaseAnimation property AnimationSlot021 auto
sslBaseAnimation property AnimationSlot022 auto
sslBaseAnimation property AnimationSlot023 auto
sslBaseAnimation property AnimationSlot024 auto
sslBaseAnimation property AnimationSlot025 auto
sslBaseAnimation property AnimationSlot026 auto
sslBaseAnimation property AnimationSlot027 auto
sslBaseAnimation property AnimationSlot028 auto
sslBaseAnimation property AnimationSlot029 auto
sslBaseAnimation property AnimationSlot030 auto
sslBaseAnimation property AnimationSlot031 auto
sslBaseAnimation property AnimationSlot032 auto
sslBaseAnimation property AnimationSlot033 auto
sslBaseAnimation property AnimationSlot034 auto
sslBaseAnimation property AnimationSlot035 auto
sslBaseAnimation property AnimationSlot036 auto
sslBaseAnimation property AnimationSlot037 auto
sslBaseAnimation property AnimationSlot038 auto
sslBaseAnimation property AnimationSlot039 auto
sslBaseAnimation property AnimationSlot040 auto
sslBaseAnimation property AnimationSlot041 auto
sslBaseAnimation property AnimationSlot042 auto
sslBaseAnimation property AnimationSlot043 auto
sslBaseAnimation property AnimationSlot044 auto
sslBaseAnimation property AnimationSlot045 auto
sslBaseAnimation property AnimationSlot046 auto
sslBaseAnimation property AnimationSlot047 auto
sslBaseAnimation property AnimationSlot048 auto
sslBaseAnimation property AnimationSlot049 auto
sslBaseAnimation property AnimationSlot050 auto
sslBaseAnimation property AnimationSlot051 auto
sslBaseAnimation property AnimationSlot052 auto
sslBaseAnimation property AnimationSlot053 auto
sslBaseAnimation property AnimationSlot054 auto
sslBaseAnimation property AnimationSlot055 auto
sslBaseAnimation property AnimationSlot056 auto
sslBaseAnimation property AnimationSlot057 auto
sslBaseAnimation property AnimationSlot058 auto
sslBaseAnimation property AnimationSlot059 auto
sslBaseAnimation property AnimationSlot060 auto
sslBaseAnimation property AnimationSlot061 auto
sslBaseAnimation property AnimationSlot062 auto
sslBaseAnimation property AnimationSlot063 auto
sslBaseAnimation property AnimationSlot064 auto
sslBaseAnimation property AnimationSlot065 auto
sslBaseAnimation property AnimationSlot066 auto
sslBaseAnimation property AnimationSlot067 auto
sslBaseAnimation property AnimationSlot068 auto
sslBaseAnimation property AnimationSlot069 auto
sslBaseAnimation property AnimationSlot070 auto
sslBaseAnimation property AnimationSlot071 auto
sslBaseAnimation property AnimationSlot072 auto
sslBaseAnimation property AnimationSlot073 auto
sslBaseAnimation property AnimationSlot074 auto
sslBaseAnimation property AnimationSlot075 auto
sslBaseAnimation property AnimationSlot076 auto
sslBaseAnimation property AnimationSlot077 auto
sslBaseAnimation property AnimationSlot078 auto
sslBaseAnimation property AnimationSlot079 auto
sslBaseAnimation property AnimationSlot080 auto
sslBaseAnimation property AnimationSlot081 auto
sslBaseAnimation property AnimationSlot082 auto
sslBaseAnimation property AnimationSlot083 auto
sslBaseAnimation property AnimationSlot084 auto
sslBaseAnimation property AnimationSlot085 auto
sslBaseAnimation property AnimationSlot086 auto
sslBaseAnimation property AnimationSlot087 auto
sslBaseAnimation property AnimationSlot088 auto
sslBaseAnimation property AnimationSlot089 auto
sslBaseAnimation property AnimationSlot090 auto
sslBaseAnimation property AnimationSlot091 auto
sslBaseAnimation property AnimationSlot092 auto
sslBaseAnimation property AnimationSlot093 auto
sslBaseAnimation property AnimationSlot094 auto
sslBaseAnimation property AnimationSlot095 auto
sslBaseAnimation property AnimationSlot096 auto
sslBaseAnimation property AnimationSlot097 auto
sslBaseAnimation property AnimationSlot098 auto
sslBaseAnimation property AnimationSlot099 auto

function _Setup()
	Slots = new sslBaseAnimation[100]
	Slots[0] = AnimationSlot000
	Slots[1] = AnimationSlot001
	Slots[2] = AnimationSlot002
	Slots[3] = AnimationSlot003
	Slots[4] = AnimationSlot004
	Slots[5] = AnimationSlot005
	Slots[6] = AnimationSlot006
	Slots[7] = AnimationSlot007
	Slots[8] = AnimationSlot008
	Slots[9] = AnimationSlot009
	Slots[10] = AnimationSlot010
	Slots[11] = AnimationSlot011
	Slots[12] = AnimationSlot012
	Slots[13] = AnimationSlot013
	Slots[14] = AnimationSlot014
	Slots[15] = AnimationSlot015
	Slots[16] = AnimationSlot016
	Slots[17] = AnimationSlot017
	Slots[18] = AnimationSlot018
	Slots[19] = AnimationSlot019
	Slots[20] = AnimationSlot020
	Slots[21] = AnimationSlot021
	Slots[22] = AnimationSlot022
	Slots[23] = AnimationSlot023
	Slots[24] = AnimationSlot024
	Slots[25] = AnimationSlot025
	Slots[26] = AnimationSlot026
	Slots[27] = AnimationSlot027
	Slots[28] = AnimationSlot028
	Slots[29] = AnimationSlot029
	Slots[30] = AnimationSlot030
	Slots[31] = AnimationSlot031
	Slots[32] = AnimationSlot032
	Slots[33] = AnimationSlot033
	Slots[34] = AnimationSlot034
	Slots[35] = AnimationSlot035
	Slots[36] = AnimationSlot036
	Slots[37] = AnimationSlot037
	Slots[38] = AnimationSlot038
	Slots[39] = AnimationSlot039
	Slots[40] = AnimationSlot040
	Slots[41] = AnimationSlot041
	Slots[42] = AnimationSlot042
	Slots[43] = AnimationSlot043
	Slots[44] = AnimationSlot044
	Slots[45] = AnimationSlot045
	Slots[46] = AnimationSlot046
	Slots[47] = AnimationSlot047
	Slots[48] = AnimationSlot048
	Slots[49] = AnimationSlot049
	Slots[50] = AnimationSlot050
	Slots[51] = AnimationSlot051
	Slots[52] = AnimationSlot052
	Slots[53] = AnimationSlot053
	Slots[54] = AnimationSlot054
	Slots[55] = AnimationSlot055
	Slots[56] = AnimationSlot056
	Slots[57] = AnimationSlot057
	Slots[58] = AnimationSlot058
	Slots[59] = AnimationSlot059
	Slots[60] = AnimationSlot060
	Slots[61] = AnimationSlot061
	Slots[62] = AnimationSlot062
	Slots[63] = AnimationSlot063
	Slots[64] = AnimationSlot064
	Slots[65] = AnimationSlot065
	Slots[66] = AnimationSlot066
	Slots[67] = AnimationSlot067
	Slots[68] = AnimationSlot068
	Slots[69] = AnimationSlot069
	Slots[70] = AnimationSlot070
	Slots[71] = AnimationSlot071
	Slots[72] = AnimationSlot072
	Slots[73] = AnimationSlot073
	Slots[74] = AnimationSlot074
	Slots[75] = AnimationSlot075
	Slots[76] = AnimationSlot076
	Slots[77] = AnimationSlot077
	Slots[78] = AnimationSlot078
	Slots[79] = AnimationSlot079
	Slots[80] = AnimationSlot080
	Slots[81] = AnimationSlot081
	Slots[82] = AnimationSlot082
	Slots[83] = AnimationSlot083
	Slots[84] = AnimationSlot084
	Slots[85] = AnimationSlot085
	Slots[86] = AnimationSlot086
	Slots[87] = AnimationSlot087
	Slots[88] = AnimationSlot088
	Slots[89] = AnimationSlot089
	Slots[90] = AnimationSlot090
	Slots[91] = AnimationSlot091
	Slots[92] = AnimationSlot092
	Slots[93] = AnimationSlot093
	Slots[94] = AnimationSlot094
	Slots[95] = AnimationSlot095
	Slots[96] = AnimationSlot096
	Slots[97] = AnimationSlot097
	Slots[98] = AnimationSlot098
	Slots[99] = AnimationSlot099

	int i
	while i < Slots.Length
		Slots[i].Initialize()
		i += 1
	endWhile

	string[] init
	registry = init
	slotted = 0

	Defaults.LoadAnimations()
endFunction