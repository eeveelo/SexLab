scriptname sslActorSlots extends Quest

ReferenceAlias[] ActorSlot

int function SlotActor(actor position)
	int i = 0
	while i < ActorSlot.Length
		if ActorSlot[i].ForceRefIfEmpty(position)
			ActorSlot[i].TryToEvaluatePackage()
			Debug.Trace("SexLab: Slotting ActorSlot["+i+"] with "+position)
			return i
		endIf
		i += 1
	endWhile
	return -1
endFunction


int function FindSlot(actor position)
	if position != none
		int i = 0
		while i < ActorSlot.Length
			if (ActorSlot[i].GetReference() as actor) == position
				return i
			endIf
			i += 1
		endWhile		
	endIf
	return -1
endFunction

function ClearSlot(int slot)
	if slot >= 0 && slot < ActorSlot.Length
		actor position = ActorSlot[slot].GetReference() as actor
		Debug.Trace("SexLab: Clearing ActorSlot["+slot+"] of "+position)
		ActorSlot[slot].Clear()
		position.EvaluatePackage()
	endIf
endFunction

function ClearActor(actor position)
	int slot = FindSlot(position)
	if slot != -1
		ClearSlot(slot)
	endIf
endFunction

sslActorAlias function GetActorAlias(actor position)
	return (ActorSlot[FindSlot(position)] as sslActorAlias)
endFunction

ReferenceAlias property ActorSlot000 auto
ReferenceAlias property ActorSlot001 auto
ReferenceAlias property ActorSlot002 auto
ReferenceAlias property ActorSlot003 auto
ReferenceAlias property ActorSlot004 auto
ReferenceAlias property ActorSlot005 auto
ReferenceAlias property ActorSlot006 auto
ReferenceAlias property ActorSlot007 auto
ReferenceAlias property ActorSlot008 auto
ReferenceAlias property ActorSlot009 auto

ReferenceAlias property ActorSlot010 auto
ReferenceAlias property ActorSlot011 auto
ReferenceAlias property ActorSlot012 auto
ReferenceAlias property ActorSlot013 auto
ReferenceAlias property ActorSlot014 auto
ReferenceAlias property ActorSlot015 auto
ReferenceAlias property ActorSlot016 auto
ReferenceAlias property ActorSlot017 auto
ReferenceAlias property ActorSlot018 auto
ReferenceAlias property ActorSlot019 auto

ReferenceAlias property ActorSlot020 auto
ReferenceAlias property ActorSlot021 auto
ReferenceAlias property ActorSlot022 auto
ReferenceAlias property ActorSlot023 auto
ReferenceAlias property ActorSlot024 auto
ReferenceAlias property ActorSlot025 auto
ReferenceAlias property ActorSlot026 auto
ReferenceAlias property ActorSlot027 auto
ReferenceAlias property ActorSlot028 auto
ReferenceAlias property ActorSlot029 auto

ReferenceAlias property ActorSlot030 auto
ReferenceAlias property ActorSlot031 auto
ReferenceAlias property ActorSlot032 auto
ReferenceAlias property ActorSlot033 auto
ReferenceAlias property ActorSlot034 auto
ReferenceAlias property ActorSlot035 auto
ReferenceAlias property ActorSlot036 auto
ReferenceAlias property ActorSlot037 auto
ReferenceAlias property ActorSlot038 auto
ReferenceAlias property ActorSlot039 auto

ReferenceAlias property ActorSlot040 auto
ReferenceAlias property ActorSlot041 auto
ReferenceAlias property ActorSlot042 auto
ReferenceAlias property ActorSlot043 auto
ReferenceAlias property ActorSlot044 auto
ReferenceAlias property ActorSlot045 auto
ReferenceAlias property ActorSlot046 auto
ReferenceAlias property ActorSlot047 auto
ReferenceAlias property ActorSlot048 auto
ReferenceAlias property ActorSlot049 auto

ReferenceAlias property ActorSlot050 auto
ReferenceAlias property ActorSlot051 auto
ReferenceAlias property ActorSlot052 auto
ReferenceAlias property ActorSlot053 auto
ReferenceAlias property ActorSlot054 auto
ReferenceAlias property ActorSlot055 auto
ReferenceAlias property ActorSlot056 auto
ReferenceAlias property ActorSlot057 auto
ReferenceAlias property ActorSlot058 auto
ReferenceAlias property ActorSlot059 auto

ReferenceAlias property ActorSlot060 auto
ReferenceAlias property ActorSlot061 auto
ReferenceAlias property ActorSlot062 auto
ReferenceAlias property ActorSlot063 auto
ReferenceAlias property ActorSlot064 auto
ReferenceAlias property ActorSlot065 auto
ReferenceAlias property ActorSlot066 auto
ReferenceAlias property ActorSlot067 auto
ReferenceAlias property ActorSlot068 auto
ReferenceAlias property ActorSlot069 auto

ReferenceAlias property ActorSlot070 auto
ReferenceAlias property ActorSlot071 auto
ReferenceAlias property ActorSlot072 auto
ReferenceAlias property ActorSlot073 auto
ReferenceAlias property ActorSlot074 auto


function _Setup()
	ActorSlot = new ReferenceAlias[75]
	ActorSlot[0] = ActorSlot000
	ActorSlot[1] = ActorSlot001
	ActorSlot[2] = ActorSlot002
	ActorSlot[3] = ActorSlot003
	ActorSlot[4] = ActorSlot004
	ActorSlot[5] = ActorSlot005
	ActorSlot[6] = ActorSlot006
	ActorSlot[7] = ActorSlot007
	ActorSlot[8] = ActorSlot008
	ActorSlot[9] = ActorSlot009
	ActorSlot[10] = ActorSlot010
	ActorSlot[11] = ActorSlot011
	ActorSlot[12] = ActorSlot012
	ActorSlot[13] = ActorSlot013
	ActorSlot[14] = ActorSlot014
	ActorSlot[15] = ActorSlot015
	ActorSlot[16] = ActorSlot016
	ActorSlot[17] = ActorSlot017
	ActorSlot[18] = ActorSlot018
	ActorSlot[19] = ActorSlot019
	ActorSlot[20] = ActorSlot020
	ActorSlot[21] = ActorSlot021
	ActorSlot[22] = ActorSlot022
	ActorSlot[23] = ActorSlot023
	ActorSlot[24] = ActorSlot024
	ActorSlot[25] = ActorSlot025
	ActorSlot[26] = ActorSlot026
	ActorSlot[27] = ActorSlot027
	ActorSlot[28] = ActorSlot028
	ActorSlot[29] = ActorSlot029
	ActorSlot[30] = ActorSlot030
	ActorSlot[31] = ActorSlot031
	ActorSlot[32] = ActorSlot032
	ActorSlot[33] = ActorSlot033
	ActorSlot[34] = ActorSlot034
	ActorSlot[35] = ActorSlot035
	ActorSlot[36] = ActorSlot036
	ActorSlot[37] = ActorSlot037
	ActorSlot[38] = ActorSlot038
	ActorSlot[39] = ActorSlot039
	ActorSlot[40] = ActorSlot040
	ActorSlot[41] = ActorSlot041
	ActorSlot[42] = ActorSlot042
	ActorSlot[43] = ActorSlot043
	ActorSlot[44] = ActorSlot044
	ActorSlot[45] = ActorSlot045
	ActorSlot[46] = ActorSlot046
	ActorSlot[47] = ActorSlot047
	ActorSlot[48] = ActorSlot048
	ActorSlot[49] = ActorSlot049
	ActorSlot[50] = ActorSlot050
	ActorSlot[51] = ActorSlot051
	ActorSlot[52] = ActorSlot052
	ActorSlot[53] = ActorSlot053
	ActorSlot[54] = ActorSlot054
	ActorSlot[55] = ActorSlot055
	ActorSlot[56] = ActorSlot056
	ActorSlot[57] = ActorSlot057
	ActorSlot[58] = ActorSlot058
	ActorSlot[59] = ActorSlot059
	ActorSlot[60] = ActorSlot060
	ActorSlot[61] = ActorSlot061
	ActorSlot[62] = ActorSlot062
	ActorSlot[63] = ActorSlot063
	ActorSlot[64] = ActorSlot064
	ActorSlot[65] = ActorSlot065
	ActorSlot[66] = ActorSlot066
	ActorSlot[67] = ActorSlot067
	ActorSlot[68] = ActorSlot068
	ActorSlot[69] = ActorSlot069
	ActorSlot[70] = ActorSlot070
	ActorSlot[71] = ActorSlot071
	ActorSlot[72] = ActorSlot072
	ActorSlot[73] = ActorSlot073
	ActorSlot[74] = ActorSlot074

	int i = 0
	while i < ActorSlot.Length
		ActorSlot[i].TryToClear()
		i += 1
	endWhile
endFunction

event OnInit()
	_Setup()
endEvent