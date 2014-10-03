scriptname PapyrusUtil Hidden

; Get version of papyrus library. For version 2.8 will be returned 28.
int function GetVersion() global native


; ##
; ## Variable sized arrays:
; ##

; To get around Papyrus's lack of dynamically allocated arrays, these can be used to initialize an array with a variable size.
; Due to their size they can be slow if used to much, but make for a simple method of allocating an array whose size is not always static.
; Use sparingly and only when absolutely necessary or extremely convenient.

; Available Variants:
; ObjectReference[] ObjectReferenceArray(int size)
; Actor[] ActorArray(int size)
; Form[] FormArray(int size)
; string[] StringArray(int size)
; bool[] BoolArray(int size)
; int[] IntArray(int size)
; float[] FloatArray(int size)


float[] function FloatArray(int size) global
	if size < 8
		if size == 0
			float[] Empty
			return Empty
		elseIf size == 1
			return new float[1]
		elseIf size == 2
			return new float[2]
		elseIf size == 3
			return new float[3]
		elseIf size == 4
			return new float[4]
		elseIf size == 5
			return new float[5]
		elseIf size == 6
			return new float[6]
		else
			return new float[7]
		endIf
	elseIf size < 16
		if size == 8
			return new float[8]
		elseIf size == 9
			return new float[9]
		elseIf size == 10
			return new float[10]
		elseIf size == 11
			return new float[11]
		elseIf size == 12
			return new float[12]
		elseIf size == 13
			return new float[13]
		elseIf size == 14
			return new float[14]
		else
			return new float[15]
		endIf
	elseIf size < 24
		if size == 16
			return new float[16]
		elseIf size == 17
			return new float[17]
		elseIf size == 18
			return new float[18]
		elseIf size == 19
			return new float[19]
		elseIf size == 20
			return new float[20]
		elseIf size == 21
			return new float[21]
		elseIf size == 22
			return new float[22]
		else
			return new float[23]
		endIf
	elseIf size < 32
		if size == 24
			return new float[24]
		elseIf size == 25
			return new float[25]
		elseIf size == 26
			return new float[26]
		elseIf size == 27
			return new float[27]
		elseIf size == 28
			return new float[28]
		elseIf size == 29
			return new float[29]
		elseIf size == 30
			return new float[30]
		else
			return new float[31]
		endIf
	elseIf size < 40
		if size == 32
			return new float[32]
		elseIf size == 33
			return new float[33]
		elseIf size == 34
			return new float[34]
		elseIf size == 35
			return new float[35]
		elseIf size == 36
			return new float[36]
		elseIf size == 37
			return new float[37]
		elseIf size == 38
			return new float[38]
		else
			return new float[39]
		endIf
	elseIf size < 48
		if size == 40
			return new float[40]
		elseIf size == 41
			return new float[41]
		elseIf size == 42
			return new float[42]
		elseIf size == 43
			return new float[43]
		elseIf size == 44
			return new float[44]
		elseIf size == 45
			return new float[45]
		elseIf size == 46
			return new float[46]
		else
			return new float[47]
		endIf
	elseIf size < 56
		if size == 48
			return new float[48]
		elseIf size == 49
			return new float[49]
		elseIf size == 50
			return new float[50]
		elseIf size == 51
			return new float[51]
		elseIf size == 52
			return new float[52]
		elseIf size == 53
			return new float[53]
		elseIf size == 54
			return new float[54]
		else
			return new float[55]
		endif
	elseIf size < 64
		if size == 56
			return new float[56]
		elseIf size == 57
			return new float[57]
		elseIf size == 58
			return new float[58]
		elseIf size == 59
			return new float[59]
		elseIf size == 60
			return new float[60]
		elseIf size == 61
			return new float[61]
		elseIf size == 62
			return new float[62]
		else
			return new float[63]
		endIf
	elseIf size < 72
		if size == 64
			return new float[64]
		elseIf size == 65
			return new float[65]
		elseIf size == 66
			return new float[66]
		elseIf size == 67
			return new float[67]
		elseIf size == 68
			return new float[68]
		elseIf size == 69
			return new float[69]
		elseIf size == 70
			return new float[70]
		else
			return new float[71]
		endif
	elseIf size < 80
		if size == 72
			return new float[72]
		elseIf size == 73
			return new float[73]
		elseIf size == 74
			return new float[74]
		elseIf size == 75
			return new float[75]
		elseIf size == 76
			return new float[76]
		elseIf size == 77
			return new float[77]
		elseIf size == 78
			return new float[78]
		else
			return new float[79]
		endIf
	elseIf size < 88
		if size == 80
			return new float[80]
		elseIf size == 81
			return new float[81]
		elseIf size == 82
			return new float[82]
		elseIf size == 83
			return new float[83]
		elseIf size == 84
			return new float[84]
		elseIf size == 85
			return new float[85]
		elseIf size == 86
			return new float[86]
		else
			return new float[87]
		endif
	elseIf size < 96
		if size == 88
			return new float[88]
		elseIf size == 89
			return new float[89]
		elseIf size == 90
			return new float[90]
		elseIf size == 91
			return new float[91]
		elseIf size == 92
			return new float[92]
		elseIf size == 93
			return new float[93]
		elseIf size == 94
			return new float[94]
		else
			return new float[95]
		endIf
	elseIf size < 104
		if size == 96
			return new float[96]
		elseIf size == 97
			return new float[97]
		elseIf size == 98
			return new float[98]
		elseIf size == 99
			return new float[99]
		elseIf size == 100
			return new float[100]
		elseIf size == 101
			return new float[101]
		elseIf size == 102
			return new float[102]
		else
			return new float[103]
		endif
	elseIf size < 112
		if size == 104
			return new float[104]
		elseIf size == 105
			return new float[105]
		elseIf size == 106
			return new float[106]
		elseIf size == 107
			return new float[107]
		elseIf size == 108
			return new float[108]
		elseIf size == 109
			return new float[109]
		elseIf size == 110
			return new float[110]
		else
			return new float[111]
		endif
	elseIf size < 120
		if size == 112
			return new float[112]
		elseIf size == 113
			return new float[113]
		elseIf size == 114
			return new float[114]
		elseIf size == 115
			return new float[115]
		elseIf size == 116
			return new float[116]
		elseIf size == 117
			return new float[117]
		elseIf size == 118
			return new float[118]
		else
			return new float[119]
		endif
	else
		if size == 120
			return new float[120]
		elseIf size == 121
			return new float[121]
		elseIf size == 122
			return new float[122]
		elseIf size == 123
			return new float[123]
		elseIf size == 124
			return new float[124]
		elseIf size == 125
			return new float[125]
		elseIf size == 126
			return new float[126]
		elseIf size == 127
			return new float[127]
		else
			return new float[128]
		endIf
	endIf
endFunction
int[] function IntArray(int size) global
	if size < 8
		if size == 0
			int[] Empty
			return Empty
		elseIf size == 1
			return new int[1]
		elseIf size == 2
			return new int[2]
		elseIf size == 3
			return new int[3]
		elseIf size == 4
			return new int[4]
		elseIf size == 5
			return new int[5]
		elseIf size == 6
			return new int[6]
		else
			return new int[7]
		endIf
	elseIf size < 16
		if size == 8
			return new int[8]
		elseIf size == 9
			return new int[9]
		elseIf size == 10
			return new int[10]
		elseIf size == 11
			return new int[11]
		elseIf size == 12
			return new int[12]
		elseIf size == 13
			return new int[13]
		elseIf size == 14
			return new int[14]
		else
			return new int[15]
		endIf
	elseIf size < 24
		if size == 16
			return new int[16]
		elseIf size == 17
			return new int[17]
		elseIf size == 18
			return new int[18]
		elseIf size == 19
			return new int[19]
		elseIf size == 20
			return new int[20]
		elseIf size == 21
			return new int[21]
		elseIf size == 22
			return new int[22]
		else
			return new int[23]
		endIf
	elseIf size < 32
		if size == 24
			return new int[24]
		elseIf size == 25
			return new int[25]
		elseIf size == 26
			return new int[26]
		elseIf size == 27
			return new int[27]
		elseIf size == 28
			return new int[28]
		elseIf size == 29
			return new int[29]
		elseIf size == 30
			return new int[30]
		else
			return new int[31]
		endIf
	elseIf size < 40
		if size == 32
			return new int[32]
		elseIf size == 33
			return new int[33]
		elseIf size == 34
			return new int[34]
		elseIf size == 35
			return new int[35]
		elseIf size == 36
			return new int[36]
		elseIf size == 37
			return new int[37]
		elseIf size == 38
			return new int[38]
		else
			return new int[39]
		endIf
	elseIf size < 48
		if size == 40
			return new int[40]
		elseIf size == 41
			return new int[41]
		elseIf size == 42
			return new int[42]
		elseIf size == 43
			return new int[43]
		elseIf size == 44
			return new int[44]
		elseIf size == 45
			return new int[45]
		elseIf size == 46
			return new int[46]
		else
			return new int[47]
		endIf
	elseIf size < 56
		if size == 48
			return new int[48]
		elseIf size == 49
			return new int[49]
		elseIf size == 50
			return new int[50]
		elseIf size == 51
			return new int[51]
		elseIf size == 52
			return new int[52]
		elseIf size == 53
			return new int[53]
		elseIf size == 54
			return new int[54]
		else
			return new int[55]
		endif
	elseIf size < 64
		if size == 56
			return new int[56]
		elseIf size == 57
			return new int[57]
		elseIf size == 58
			return new int[58]
		elseIf size == 59
			return new int[59]
		elseIf size == 60
			return new int[60]
		elseIf size == 61
			return new int[61]
		elseIf size == 62
			return new int[62]
		else
			return new int[63]
		endIf
	elseIf size < 72
		if size == 64
			return new int[64]
		elseIf size == 65
			return new int[65]
		elseIf size == 66
			return new int[66]
		elseIf size == 67
			return new int[67]
		elseIf size == 68
			return new int[68]
		elseIf size == 69
			return new int[69]
		elseIf size == 70
			return new int[70]
		else
			return new int[71]
		endif
	elseIf size < 80
		if size == 72
			return new int[72]
		elseIf size == 73
			return new int[73]
		elseIf size == 74
			return new int[74]
		elseIf size == 75
			return new int[75]
		elseIf size == 76
			return new int[76]
		elseIf size == 77
			return new int[77]
		elseIf size == 78
			return new int[78]
		else
			return new int[79]
		endIf
	elseIf size < 88
		if size == 80
			return new int[80]
		elseIf size == 81
			return new int[81]
		elseIf size == 82
			return new int[82]
		elseIf size == 83
			return new int[83]
		elseIf size == 84
			return new int[84]
		elseIf size == 85
			return new int[85]
		elseIf size == 86
			return new int[86]
		else
			return new int[87]
		endif
	elseIf size < 96
		if size == 88
			return new int[88]
		elseIf size == 89
			return new int[89]
		elseIf size == 90
			return new int[90]
		elseIf size == 91
			return new int[91]
		elseIf size == 92
			return new int[92]
		elseIf size == 93
			return new int[93]
		elseIf size == 94
			return new int[94]
		else
			return new int[95]
		endIf
	elseIf size < 104
		if size == 96
			return new int[96]
		elseIf size == 97
			return new int[97]
		elseIf size == 98
			return new int[98]
		elseIf size == 99
			return new int[99]
		elseIf size == 100
			return new int[100]
		elseIf size == 101
			return new int[101]
		elseIf size == 102
			return new int[102]
		else
			return new int[103]
		endif
	elseIf size < 112
		if size == 104
			return new int[104]
		elseIf size == 105
			return new int[105]
		elseIf size == 106
			return new int[106]
		elseIf size == 107
			return new int[107]
		elseIf size == 108
			return new int[108]
		elseIf size == 109
			return new int[109]
		elseIf size == 110
			return new int[110]
		else
			return new int[111]
		endif
	elseIf size < 120
		if size == 112
			return new int[112]
		elseIf size == 113
			return new int[113]
		elseIf size == 114
			return new int[114]
		elseIf size == 115
			return new int[115]
		elseIf size == 116
			return new int[116]
		elseIf size == 117
			return new int[117]
		elseIf size == 118
			return new int[118]
		else
			return new int[119]
		endif
	else
		if size == 120
			return new int[120]
		elseIf size == 121
			return new int[121]
		elseIf size == 122
			return new int[122]
		elseIf size == 123
			return new int[123]
		elseIf size == 124
			return new int[124]
		elseIf size == 125
			return new int[125]
		elseIf size == 126
			return new int[126]
		elseIf size == 127
			return new int[127]
		else
			return new int[128]
		endIf
	endIf
endFunction
bool[] function BoolArray(int size) global
	if size < 8
		if size == 0
			bool[] Empty
			return Empty
		elseIf size == 1
			return new bool[1]
		elseIf size == 2
			return new bool[2]
		elseIf size == 3
			return new bool[3]
		elseIf size == 4
			return new bool[4]
		elseIf size == 5
			return new bool[5]
		elseIf size == 6
			return new bool[6]
		else
			return new bool[7]
		endIf
	elseIf size < 16
		if size == 8
			return new bool[8]
		elseIf size == 9
			return new bool[9]
		elseIf size == 10
			return new bool[10]
		elseIf size == 11
			return new bool[11]
		elseIf size == 12
			return new bool[12]
		elseIf size == 13
			return new bool[13]
		elseIf size == 14
			return new bool[14]
		else
			return new bool[15]
		endIf
	elseIf size < 24
		if size == 16
			return new bool[16]
		elseIf size == 17
			return new bool[17]
		elseIf size == 18
			return new bool[18]
		elseIf size == 19
			return new bool[19]
		elseIf size == 20
			return new bool[20]
		elseIf size == 21
			return new bool[21]
		elseIf size == 22
			return new bool[22]
		else
			return new bool[23]
		endIf
	elseIf size < 32
		if size == 24
			return new bool[24]
		elseIf size == 25
			return new bool[25]
		elseIf size == 26
			return new bool[26]
		elseIf size == 27
			return new bool[27]
		elseIf size == 28
			return new bool[28]
		elseIf size == 29
			return new bool[29]
		elseIf size == 30
			return new bool[30]
		else
			return new bool[31]
		endIf
	elseIf size < 40
		if size == 32
			return new bool[32]
		elseIf size == 33
			return new bool[33]
		elseIf size == 34
			return new bool[34]
		elseIf size == 35
			return new bool[35]
		elseIf size == 36
			return new bool[36]
		elseIf size == 37
			return new bool[37]
		elseIf size == 38
			return new bool[38]
		else
			return new bool[39]
		endIf
	elseIf size < 48
		if size == 40
			return new bool[40]
		elseIf size == 41
			return new bool[41]
		elseIf size == 42
			return new bool[42]
		elseIf size == 43
			return new bool[43]
		elseIf size == 44
			return new bool[44]
		elseIf size == 45
			return new bool[45]
		elseIf size == 46
			return new bool[46]
		else
			return new bool[47]
		endIf
	elseIf size < 56
		if size == 48
			return new bool[48]
		elseIf size == 49
			return new bool[49]
		elseIf size == 50
			return new bool[50]
		elseIf size == 51
			return new bool[51]
		elseIf size == 52
			return new bool[52]
		elseIf size == 53
			return new bool[53]
		elseIf size == 54
			return new bool[54]
		else
			return new bool[55]
		endif
	elseIf size < 64
		if size == 56
			return new bool[56]
		elseIf size == 57
			return new bool[57]
		elseIf size == 58
			return new bool[58]
		elseIf size == 59
			return new bool[59]
		elseIf size == 60
			return new bool[60]
		elseIf size == 61
			return new bool[61]
		elseIf size == 62
			return new bool[62]
		else
			return new bool[63]
		endIf
	elseIf size < 72
		if size == 64
			return new bool[64]
		elseIf size == 65
			return new bool[65]
		elseIf size == 66
			return new bool[66]
		elseIf size == 67
			return new bool[67]
		elseIf size == 68
			return new bool[68]
		elseIf size == 69
			return new bool[69]
		elseIf size == 70
			return new bool[70]
		else
			return new bool[71]
		endif
	elseIf size < 80
		if size == 72
			return new bool[72]
		elseIf size == 73
			return new bool[73]
		elseIf size == 74
			return new bool[74]
		elseIf size == 75
			return new bool[75]
		elseIf size == 76
			return new bool[76]
		elseIf size == 77
			return new bool[77]
		elseIf size == 78
			return new bool[78]
		else
			return new bool[79]
		endIf
	elseIf size < 88
		if size == 80
			return new bool[80]
		elseIf size == 81
			return new bool[81]
		elseIf size == 82
			return new bool[82]
		elseIf size == 83
			return new bool[83]
		elseIf size == 84
			return new bool[84]
		elseIf size == 85
			return new bool[85]
		elseIf size == 86
			return new bool[86]
		else
			return new bool[87]
		endif
	elseIf size < 96
		if size == 88
			return new bool[88]
		elseIf size == 89
			return new bool[89]
		elseIf size == 90
			return new bool[90]
		elseIf size == 91
			return new bool[91]
		elseIf size == 92
			return new bool[92]
		elseIf size == 93
			return new bool[93]
		elseIf size == 94
			return new bool[94]
		else
			return new bool[95]
		endIf
	elseIf size < 104
		if size == 96
			return new bool[96]
		elseIf size == 97
			return new bool[97]
		elseIf size == 98
			return new bool[98]
		elseIf size == 99
			return new bool[99]
		elseIf size == 100
			return new bool[100]
		elseIf size == 101
			return new bool[101]
		elseIf size == 102
			return new bool[102]
		else
			return new bool[103]
		endif
	elseIf size < 112
		if size == 104
			return new bool[104]
		elseIf size == 105
			return new bool[105]
		elseIf size == 106
			return new bool[106]
		elseIf size == 107
			return new bool[107]
		elseIf size == 108
			return new bool[108]
		elseIf size == 109
			return new bool[109]
		elseIf size == 110
			return new bool[110]
		else
			return new bool[111]
		endif
	elseIf size < 120
		if size == 112
			return new bool[112]
		elseIf size == 113
			return new bool[113]
		elseIf size == 114
			return new bool[114]
		elseIf size == 115
			return new bool[115]
		elseIf size == 116
			return new bool[116]
		elseIf size == 117
			return new bool[117]
		elseIf size == 118
			return new bool[118]
		else
			return new bool[119]
		endif
	else
		if size == 120
			return new bool[120]
		elseIf size == 121
			return new bool[121]
		elseIf size == 122
			return new bool[122]
		elseIf size == 123
			return new bool[123]
		elseIf size == 124
			return new bool[124]
		elseIf size == 125
			return new bool[125]
		elseIf size == 126
			return new bool[126]
		elseIf size == 127
			return new bool[127]
		else
			return new bool[128]
		endIf
	endIf
endFunction
string[] function StringArray(int size) global
	if size < 8
		if size == 0
			string[] Empty
			return Empty
		elseIf size == 1
			return new string[1]
		elseIf size == 2
			return new string[2]
		elseIf size == 3
			return new string[3]
		elseIf size == 4
			return new string[4]
		elseIf size == 5
			return new string[5]
		elseIf size == 6
			return new string[6]
		else
			return new string[7]
		endIf
	elseIf size < 16
		if size == 8
			return new string[8]
		elseIf size == 9
			return new string[9]
		elseIf size == 10
			return new string[10]
		elseIf size == 11
			return new string[11]
		elseIf size == 12
			return new string[12]
		elseIf size == 13
			return new string[13]
		elseIf size == 14
			return new string[14]
		else
			return new string[15]
		endIf
	elseIf size < 24
		if size == 16
			return new string[16]
		elseIf size == 17
			return new string[17]
		elseIf size == 18
			return new string[18]
		elseIf size == 19
			return new string[19]
		elseIf size == 20
			return new string[20]
		elseIf size == 21
			return new string[21]
		elseIf size == 22
			return new string[22]
		else
			return new string[23]
		endIf
	elseIf size < 32
		if size == 24
			return new string[24]
		elseIf size == 25
			return new string[25]
		elseIf size == 26
			return new string[26]
		elseIf size == 27
			return new string[27]
		elseIf size == 28
			return new string[28]
		elseIf size == 29
			return new string[29]
		elseIf size == 30
			return new string[30]
		else
			return new string[31]
		endIf
	elseIf size < 40
		if size == 32
			return new string[32]
		elseIf size == 33
			return new string[33]
		elseIf size == 34
			return new string[34]
		elseIf size == 35
			return new string[35]
		elseIf size == 36
			return new string[36]
		elseIf size == 37
			return new string[37]
		elseIf size == 38
			return new string[38]
		else
			return new string[39]
		endIf
	elseIf size < 48
		if size == 40
			return new string[40]
		elseIf size == 41
			return new string[41]
		elseIf size == 42
			return new string[42]
		elseIf size == 43
			return new string[43]
		elseIf size == 44
			return new string[44]
		elseIf size == 45
			return new string[45]
		elseIf size == 46
			return new string[46]
		else
			return new string[47]
		endIf
	elseIf size < 56
		if size == 48
			return new string[48]
		elseIf size == 49
			return new string[49]
		elseIf size == 50
			return new string[50]
		elseIf size == 51
			return new string[51]
		elseIf size == 52
			return new string[52]
		elseIf size == 53
			return new string[53]
		elseIf size == 54
			return new string[54]
		else
			return new string[55]
		endif
	elseIf size < 64
		if size == 56
			return new string[56]
		elseIf size == 57
			return new string[57]
		elseIf size == 58
			return new string[58]
		elseIf size == 59
			return new string[59]
		elseIf size == 60
			return new string[60]
		elseIf size == 61
			return new string[61]
		elseIf size == 62
			return new string[62]
		else
			return new string[63]
		endIf
	elseIf size < 72
		if size == 64
			return new string[64]
		elseIf size == 65
			return new string[65]
		elseIf size == 66
			return new string[66]
		elseIf size == 67
			return new string[67]
		elseIf size == 68
			return new string[68]
		elseIf size == 69
			return new string[69]
		elseIf size == 70
			return new string[70]
		else
			return new string[71]
		endif
	elseIf size < 80
		if size == 72
			return new string[72]
		elseIf size == 73
			return new string[73]
		elseIf size == 74
			return new string[74]
		elseIf size == 75
			return new string[75]
		elseIf size == 76
			return new string[76]
		elseIf size == 77
			return new string[77]
		elseIf size == 78
			return new string[78]
		else
			return new string[79]
		endIf
	elseIf size < 88
		if size == 80
			return new string[80]
		elseIf size == 81
			return new string[81]
		elseIf size == 82
			return new string[82]
		elseIf size == 83
			return new string[83]
		elseIf size == 84
			return new string[84]
		elseIf size == 85
			return new string[85]
		elseIf size == 86
			return new string[86]
		else
			return new string[87]
		endif
	elseIf size < 96
		if size == 88
			return new string[88]
		elseIf size == 89
			return new string[89]
		elseIf size == 90
			return new string[90]
		elseIf size == 91
			return new string[91]
		elseIf size == 92
			return new string[92]
		elseIf size == 93
			return new string[93]
		elseIf size == 94
			return new string[94]
		else
			return new string[95]
		endIf
	elseIf size < 104
		if size == 96
			return new string[96]
		elseIf size == 97
			return new string[97]
		elseIf size == 98
			return new string[98]
		elseIf size == 99
			return new string[99]
		elseIf size == 100
			return new string[100]
		elseIf size == 101
			return new string[101]
		elseIf size == 102
			return new string[102]
		else
			return new string[103]
		endif
	elseIf size < 112
		if size == 104
			return new string[104]
		elseIf size == 105
			return new string[105]
		elseIf size == 106
			return new string[106]
		elseIf size == 107
			return new string[107]
		elseIf size == 108
			return new string[108]
		elseIf size == 109
			return new string[109]
		elseIf size == 110
			return new string[110]
		else
			return new string[111]
		endif
	elseIf size < 120
		if size == 112
			return new string[112]
		elseIf size == 113
			return new string[113]
		elseIf size == 114
			return new string[114]
		elseIf size == 115
			return new string[115]
		elseIf size == 116
			return new string[116]
		elseIf size == 117
			return new string[117]
		elseIf size == 118
			return new string[118]
		else
			return new string[119]
		endif
	else
		if size == 120
			return new string[120]
		elseIf size == 121
			return new string[121]
		elseIf size == 122
			return new string[122]
		elseIf size == 123
			return new string[123]
		elseIf size == 124
			return new string[124]
		elseIf size == 125
			return new string[125]
		elseIf size == 126
			return new string[126]
		elseIf size == 127
			return new string[127]
		else
			return new string[128]
		endIf
	endIf
endFunction



Form[] function FormArray(int size) global
	if size < 8
		if size == 0
			Form[] Empty
			return Empty
		elseIf size == 1
			return new Form[1]
		elseIf size == 2
			return new Form[2]
		elseIf size == 3
			return new Form[3]
		elseIf size == 4
			return new Form[4]
		elseIf size == 5
			return new Form[5]
		elseIf size == 6
			return new Form[6]
		else
			return new Form[7]
		endIf
	elseIf size < 16
		if size == 8
			return new Form[8]
		elseIf size == 9
			return new Form[9]
		elseIf size == 10
			return new Form[10]
		elseIf size == 11
			return new Form[11]
		elseIf size == 12
			return new Form[12]
		elseIf size == 13
			return new Form[13]
		elseIf size == 14
			return new Form[14]
		else
			return new Form[15]
		endIf
	elseIf size < 24
		if size == 16
			return new Form[16]
		elseIf size == 17
			return new Form[17]
		elseIf size == 18
			return new Form[18]
		elseIf size == 19
			return new Form[19]
		elseIf size == 20
			return new Form[20]
		elseIf size == 21
			return new Form[21]
		elseIf size == 22
			return new Form[22]
		else
			return new Form[23]
		endIf
	elseIf size < 32
		if size == 24
			return new Form[24]
		elseIf size == 25
			return new Form[25]
		elseIf size == 26
			return new Form[26]
		elseIf size == 27
			return new Form[27]
		elseIf size == 28
			return new Form[28]
		elseIf size == 29
			return new Form[29]
		elseIf size == 30
			return new Form[30]
		else
			return new Form[31]
		endIf
	elseIf size < 40
		if size == 32
			return new Form[32]
		elseIf size == 33
			return new Form[33]
		elseIf size == 34
			return new Form[34]
		elseIf size == 35
			return new Form[35]
		elseIf size == 36
			return new Form[36]
		elseIf size == 37
			return new Form[37]
		elseIf size == 38
			return new Form[38]
		else
			return new Form[39]
		endIf
	elseIf size < 48
		if size == 40
			return new Form[40]
		elseIf size == 41
			return new Form[41]
		elseIf size == 42
			return new Form[42]
		elseIf size == 43
			return new Form[43]
		elseIf size == 44
			return new Form[44]
		elseIf size == 45
			return new Form[45]
		elseIf size == 46
			return new Form[46]
		else
			return new Form[47]
		endIf
	elseIf size < 56
		if size == 48
			return new Form[48]
		elseIf size == 49
			return new Form[49]
		elseIf size == 50
			return new Form[50]
		elseIf size == 51
			return new Form[51]
		elseIf size == 52
			return new Form[52]
		elseIf size == 53
			return new Form[53]
		elseIf size == 54
			return new Form[54]
		else
			return new Form[55]
		endif
	elseIf size < 64
		if size == 56
			return new Form[56]
		elseIf size == 57
			return new Form[57]
		elseIf size == 58
			return new Form[58]
		elseIf size == 59
			return new Form[59]
		elseIf size == 60
			return new Form[60]
		elseIf size == 61
			return new Form[61]
		elseIf size == 62
			return new Form[62]
		else
			return new Form[63]
		endIf
	elseIf size < 72
		if size == 64
			return new Form[64]
		elseIf size == 65
			return new Form[65]
		elseIf size == 66
			return new Form[66]
		elseIf size == 67
			return new Form[67]
		elseIf size == 68
			return new Form[68]
		elseIf size == 69
			return new Form[69]
		elseIf size == 70
			return new Form[70]
		else
			return new Form[71]
		endif
	elseIf size < 80
		if size == 72
			return new Form[72]
		elseIf size == 73
			return new Form[73]
		elseIf size == 74
			return new Form[74]
		elseIf size == 75
			return new Form[75]
		elseIf size == 76
			return new Form[76]
		elseIf size == 77
			return new Form[77]
		elseIf size == 78
			return new Form[78]
		else
			return new Form[79]
		endIf
	elseIf size < 88
		if size == 80
			return new Form[80]
		elseIf size == 81
			return new Form[81]
		elseIf size == 82
			return new Form[82]
		elseIf size == 83
			return new Form[83]
		elseIf size == 84
			return new Form[84]
		elseIf size == 85
			return new Form[85]
		elseIf size == 86
			return new Form[86]
		else
			return new Form[87]
		endif
	elseIf size < 96
		if size == 88
			return new Form[88]
		elseIf size == 89
			return new Form[89]
		elseIf size == 90
			return new Form[90]
		elseIf size == 91
			return new Form[91]
		elseIf size == 92
			return new Form[92]
		elseIf size == 93
			return new Form[93]
		elseIf size == 94
			return new Form[94]
		else
			return new Form[95]
		endIf
	elseIf size < 104
		if size == 96
			return new Form[96]
		elseIf size == 97
			return new Form[97]
		elseIf size == 98
			return new Form[98]
		elseIf size == 99
			return new Form[99]
		elseIf size == 100
			return new Form[100]
		elseIf size == 101
			return new Form[101]
		elseIf size == 102
			return new Form[102]
		else
			return new Form[103]
		endif
	elseIf size < 112
		if size == 104
			return new Form[104]
		elseIf size == 105
			return new Form[105]
		elseIf size == 106
			return new Form[106]
		elseIf size == 107
			return new Form[107]
		elseIf size == 108
			return new Form[108]
		elseIf size == 109
			return new Form[109]
		elseIf size == 110
			return new Form[110]
		else
			return new Form[111]
		endif
	elseIf size < 120
		if size == 112
			return new Form[112]
		elseIf size == 113
			return new Form[113]
		elseIf size == 114
			return new Form[114]
		elseIf size == 115
			return new Form[115]
		elseIf size == 116
			return new Form[116]
		elseIf size == 117
			return new Form[117]
		elseIf size == 118
			return new Form[118]
		else
			return new Form[119]
		endif
	else
		if size == 120
			return new Form[120]
		elseIf size == 121
			return new Form[121]
		elseIf size == 122
			return new Form[122]
		elseIf size == 123
			return new Form[123]
		elseIf size == 124
			return new Form[124]
		elseIf size == 125
			return new Form[125]
		elseIf size == 126
			return new Form[126]
		elseIf size == 127
			return new Form[127]
		else
			return new Form[128]
		endIf
	endIf
endFunction
ObjectReference[] function ObjectReferenceArray(int size) global
	if size < 8
		if size == 0
			ObjectReference[] Empty
			return Empty
		elseIf size == 1
			return new ObjectReference[1]
		elseIf size == 2
			return new ObjectReference[2]
		elseIf size == 3
			return new ObjectReference[3]
		elseIf size == 4
			return new ObjectReference[4]
		elseIf size == 5
			return new ObjectReference[5]
		elseIf size == 6
			return new ObjectReference[6]
		else
			return new ObjectReference[7]
		endIf
	elseIf size < 16
		if size == 8
			return new ObjectReference[8]
		elseIf size == 9
			return new ObjectReference[9]
		elseIf size == 10
			return new ObjectReference[10]
		elseIf size == 11
			return new ObjectReference[11]
		elseIf size == 12
			return new ObjectReference[12]
		elseIf size == 13
			return new ObjectReference[13]
		elseIf size == 14
			return new ObjectReference[14]
		else
			return new ObjectReference[15]
		endIf
	elseIf size < 24
		if size == 16
			return new ObjectReference[16]
		elseIf size == 17
			return new ObjectReference[17]
		elseIf size == 18
			return new ObjectReference[18]
		elseIf size == 19
			return new ObjectReference[19]
		elseIf size == 20
			return new ObjectReference[20]
		elseIf size == 21
			return new ObjectReference[21]
		elseIf size == 22
			return new ObjectReference[22]
		else
			return new ObjectReference[23]
		endIf
	elseIf size < 32
		if size == 24
			return new ObjectReference[24]
		elseIf size == 25
			return new ObjectReference[25]
		elseIf size == 26
			return new ObjectReference[26]
		elseIf size == 27
			return new ObjectReference[27]
		elseIf size == 28
			return new ObjectReference[28]
		elseIf size == 29
			return new ObjectReference[29]
		elseIf size == 30
			return new ObjectReference[30]
		else
			return new ObjectReference[31]
		endIf
	elseIf size < 40
		if size == 32
			return new ObjectReference[32]
		elseIf size == 33
			return new ObjectReference[33]
		elseIf size == 34
			return new ObjectReference[34]
		elseIf size == 35
			return new ObjectReference[35]
		elseIf size == 36
			return new ObjectReference[36]
		elseIf size == 37
			return new ObjectReference[37]
		elseIf size == 38
			return new ObjectReference[38]
		else
			return new ObjectReference[39]
		endIf
	elseIf size < 48
		if size == 40
			return new ObjectReference[40]
		elseIf size == 41
			return new ObjectReference[41]
		elseIf size == 42
			return new ObjectReference[42]
		elseIf size == 43
			return new ObjectReference[43]
		elseIf size == 44
			return new ObjectReference[44]
		elseIf size == 45
			return new ObjectReference[45]
		elseIf size == 46
			return new ObjectReference[46]
		else
			return new ObjectReference[47]
		endIf
	elseIf size < 56
		if size == 48
			return new ObjectReference[48]
		elseIf size == 49
			return new ObjectReference[49]
		elseIf size == 50
			return new ObjectReference[50]
		elseIf size == 51
			return new ObjectReference[51]
		elseIf size == 52
			return new ObjectReference[52]
		elseIf size == 53
			return new ObjectReference[53]
		elseIf size == 54
			return new ObjectReference[54]
		else
			return new ObjectReference[55]
		endif
	elseIf size < 64
		if size == 56
			return new ObjectReference[56]
		elseIf size == 57
			return new ObjectReference[57]
		elseIf size == 58
			return new ObjectReference[58]
		elseIf size == 59
			return new ObjectReference[59]
		elseIf size == 60
			return new ObjectReference[60]
		elseIf size == 61
			return new ObjectReference[61]
		elseIf size == 62
			return new ObjectReference[62]
		else
			return new ObjectReference[63]
		endIf
	elseIf size < 72
		if size == 64
			return new ObjectReference[64]
		elseIf size == 65
			return new ObjectReference[65]
		elseIf size == 66
			return new ObjectReference[66]
		elseIf size == 67
			return new ObjectReference[67]
		elseIf size == 68
			return new ObjectReference[68]
		elseIf size == 69
			return new ObjectReference[69]
		elseIf size == 70
			return new ObjectReference[70]
		else
			return new ObjectReference[71]
		endif
	elseIf size < 80
		if size == 72
			return new ObjectReference[72]
		elseIf size == 73
			return new ObjectReference[73]
		elseIf size == 74
			return new ObjectReference[74]
		elseIf size == 75
			return new ObjectReference[75]
		elseIf size == 76
			return new ObjectReference[76]
		elseIf size == 77
			return new ObjectReference[77]
		elseIf size == 78
			return new ObjectReference[78]
		else
			return new ObjectReference[79]
		endIf
	elseIf size < 88
		if size == 80
			return new ObjectReference[80]
		elseIf size == 81
			return new ObjectReference[81]
		elseIf size == 82
			return new ObjectReference[82]
		elseIf size == 83
			return new ObjectReference[83]
		elseIf size == 84
			return new ObjectReference[84]
		elseIf size == 85
			return new ObjectReference[85]
		elseIf size == 86
			return new ObjectReference[86]
		else
			return new ObjectReference[87]
		endif
	elseIf size < 96
		if size == 88
			return new ObjectReference[88]
		elseIf size == 89
			return new ObjectReference[89]
		elseIf size == 90
			return new ObjectReference[90]
		elseIf size == 91
			return new ObjectReference[91]
		elseIf size == 92
			return new ObjectReference[92]
		elseIf size == 93
			return new ObjectReference[93]
		elseIf size == 94
			return new ObjectReference[94]
		else
			return new ObjectReference[95]
		endIf
	elseIf size < 104
		if size == 96
			return new ObjectReference[96]
		elseIf size == 97
			return new ObjectReference[97]
		elseIf size == 98
			return new ObjectReference[98]
		elseIf size == 99
			return new ObjectReference[99]
		elseIf size == 100
			return new ObjectReference[100]
		elseIf size == 101
			return new ObjectReference[101]
		elseIf size == 102
			return new ObjectReference[102]
		else
			return new ObjectReference[103]
		endif
	elseIf size < 112
		if size == 104
			return new ObjectReference[104]
		elseIf size == 105
			return new ObjectReference[105]
		elseIf size == 106
			return new ObjectReference[106]
		elseIf size == 107
			return new ObjectReference[107]
		elseIf size == 108
			return new ObjectReference[108]
		elseIf size == 109
			return new ObjectReference[109]
		elseIf size == 110
			return new ObjectReference[110]
		else
			return new ObjectReference[111]
		endif
	elseIf size < 120
		if size == 112
			return new ObjectReference[112]
		elseIf size == 113
			return new ObjectReference[113]
		elseIf size == 114
			return new ObjectReference[114]
		elseIf size == 115
			return new ObjectReference[115]
		elseIf size == 116
			return new ObjectReference[116]
		elseIf size == 117
			return new ObjectReference[117]
		elseIf size == 118
			return new ObjectReference[118]
		else
			return new ObjectReference[119]
		endif
	else
		if size == 120
			return new ObjectReference[120]
		elseIf size == 121
			return new ObjectReference[121]
		elseIf size == 122
			return new ObjectReference[122]
		elseIf size == 123
			return new ObjectReference[123]
		elseIf size == 124
			return new ObjectReference[124]
		elseIf size == 125
			return new ObjectReference[125]
		elseIf size == 126
			return new ObjectReference[126]
		elseIf size == 127
			return new ObjectReference[127]
		else
			return new ObjectReference[128]
		endIf
	endIf
endFunction
Actor[] function ActorArray(int size) global
	if size < 8
		if size == 0
			Actor[] Empty
			return Empty
		elseIf size == 1
			return new Actor[1]
		elseIf size == 2
			return new Actor[2]
		elseIf size == 3
			return new Actor[3]
		elseIf size == 4
			return new Actor[4]
		elseIf size == 5
			return new Actor[5]
		elseIf size == 6
			return new Actor[6]
		else
			return new Actor[7]
		endIf
	elseIf size < 16
		if size == 8
			return new Actor[8]
		elseIf size == 9
			return new Actor[9]
		elseIf size == 10
			return new Actor[10]
		elseIf size == 11
			return new Actor[11]
		elseIf size == 12
			return new Actor[12]
		elseIf size == 13
			return new Actor[13]
		elseIf size == 14
			return new Actor[14]
		else
			return new Actor[15]
		endIf
	elseIf size < 24
		if size == 16
			return new Actor[16]
		elseIf size == 17
			return new Actor[17]
		elseIf size == 18
			return new Actor[18]
		elseIf size == 19
			return new Actor[19]
		elseIf size == 20
			return new Actor[20]
		elseIf size == 21
			return new Actor[21]
		elseIf size == 22
			return new Actor[22]
		else
			return new Actor[23]
		endIf
	elseIf size < 32
		if size == 24
			return new Actor[24]
		elseIf size == 25
			return new Actor[25]
		elseIf size == 26
			return new Actor[26]
		elseIf size == 27
			return new Actor[27]
		elseIf size == 28
			return new Actor[28]
		elseIf size == 29
			return new Actor[29]
		elseIf size == 30
			return new Actor[30]
		else
			return new Actor[31]
		endIf
	elseIf size < 40
		if size == 32
			return new Actor[32]
		elseIf size == 33
			return new Actor[33]
		elseIf size == 34
			return new Actor[34]
		elseIf size == 35
			return new Actor[35]
		elseIf size == 36
			return new Actor[36]
		elseIf size == 37
			return new Actor[37]
		elseIf size == 38
			return new Actor[38]
		else
			return new Actor[39]
		endIf
	elseIf size < 48
		if size == 40
			return new Actor[40]
		elseIf size == 41
			return new Actor[41]
		elseIf size == 42
			return new Actor[42]
		elseIf size == 43
			return new Actor[43]
		elseIf size == 44
			return new Actor[44]
		elseIf size == 45
			return new Actor[45]
		elseIf size == 46
			return new Actor[46]
		else
			return new Actor[47]
		endIf
	elseIf size < 56
		if size == 48
			return new Actor[48]
		elseIf size == 49
			return new Actor[49]
		elseIf size == 50
			return new Actor[50]
		elseIf size == 51
			return new Actor[51]
		elseIf size == 52
			return new Actor[52]
		elseIf size == 53
			return new Actor[53]
		elseIf size == 54
			return new Actor[54]
		else
			return new Actor[55]
		endif
	elseIf size < 64
		if size == 56
			return new Actor[56]
		elseIf size == 57
			return new Actor[57]
		elseIf size == 58
			return new Actor[58]
		elseIf size == 59
			return new Actor[59]
		elseIf size == 60
			return new Actor[60]
		elseIf size == 61
			return new Actor[61]
		elseIf size == 62
			return new Actor[62]
		else
			return new Actor[63]
		endIf
	elseIf size < 72
		if size == 64
			return new Actor[64]
		elseIf size == 65
			return new Actor[65]
		elseIf size == 66
			return new Actor[66]
		elseIf size == 67
			return new Actor[67]
		elseIf size == 68
			return new Actor[68]
		elseIf size == 69
			return new Actor[69]
		elseIf size == 70
			return new Actor[70]
		else
			return new Actor[71]
		endif
	elseIf size < 80
		if size == 72
			return new Actor[72]
		elseIf size == 73
			return new Actor[73]
		elseIf size == 74
			return new Actor[74]
		elseIf size == 75
			return new Actor[75]
		elseIf size == 76
			return new Actor[76]
		elseIf size == 77
			return new Actor[77]
		elseIf size == 78
			return new Actor[78]
		else
			return new Actor[79]
		endIf
	elseIf size < 88
		if size == 80
			return new Actor[80]
		elseIf size == 81
			return new Actor[81]
		elseIf size == 82
			return new Actor[82]
		elseIf size == 83
			return new Actor[83]
		elseIf size == 84
			return new Actor[84]
		elseIf size == 85
			return new Actor[85]
		elseIf size == 86
			return new Actor[86]
		else
			return new Actor[87]
		endif
	elseIf size < 96
		if size == 88
			return new Actor[88]
		elseIf size == 89
			return new Actor[89]
		elseIf size == 90
			return new Actor[90]
		elseIf size == 91
			return new Actor[91]
		elseIf size == 92
			return new Actor[92]
		elseIf size == 93
			return new Actor[93]
		elseIf size == 94
			return new Actor[94]
		else
			return new Actor[95]
		endIf
	elseIf size < 104
		if size == 96
			return new Actor[96]
		elseIf size == 97
			return new Actor[97]
		elseIf size == 98
			return new Actor[98]
		elseIf size == 99
			return new Actor[99]
		elseIf size == 100
			return new Actor[100]
		elseIf size == 101
			return new Actor[101]
		elseIf size == 102
			return new Actor[102]
		else
			return new Actor[103]
		endif
	elseIf size < 112
		if size == 104
			return new Actor[104]
		elseIf size == 105
			return new Actor[105]
		elseIf size == 106
			return new Actor[106]
		elseIf size == 107
			return new Actor[107]
		elseIf size == 108
			return new Actor[108]
		elseIf size == 109
			return new Actor[109]
		elseIf size == 110
			return new Actor[110]
		else
			return new Actor[111]
		endif
	elseIf size < 120
		if size == 112
			return new Actor[112]
		elseIf size == 113
			return new Actor[113]
		elseIf size == 114
			return new Actor[114]
		elseIf size == 115
			return new Actor[115]
		elseIf size == 116
			return new Actor[116]
		elseIf size == 117
			return new Actor[117]
		elseIf size == 118
			return new Actor[118]
		else
			return new Actor[119]
		endif
	else
		if size == 120
			return new Actor[120]
		elseIf size == 121
			return new Actor[121]
		elseIf size == 122
			return new Actor[122]
		elseIf size == 123
			return new Actor[123]
		elseIf size == 124
			return new Actor[124]
		elseIf size == 125
			return new Actor[125]
		elseIf size == 126
			return new Actor[126]
		elseIf size == 127
			return new Actor[127]
		else
			return new Actor[128]
		endIf
	endIf
endFunction
