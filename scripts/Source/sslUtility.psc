scriptname sslUtility hidden

;/-----------------------------------------------\;
;|	Float Utility Functions                      |;
;\-----------------------------------------------/;

float[] function IncreaseFloat(int by, float[] array) global
	int len = array.Length
	if by < 1 || (len+by > 128)
		return array
	elseIf len == 0
		return FloatArray(by)
	endIf
	float[] output = FloatArray(len+by)
	while len
		len -= 1
		output[len] = array[len]
	endWhile
	return output
endFunction

float[] function PushFloat(float var, float[] array) global
	int len = array.Length
	if len >= 128
		return array
	endIf
	float[] output = IncreaseFloat(1, array)
	output[len] = var
	return output
endFunction

float[] function MergeFloatArray(float[] push, float[] array) global
	int pushing = push.Length
	if pushing+array.Length > 128 || pushing == 0
		return array
	endIf
	float[] output = IncreaseFloat(pushing, array)
	int len = output.Length
	while pushing
		len -= 1
		pushing -= 1
		output[len] = push[pushing]
	endWhile
	return output
endFunction

float function ClampFloat(float value, float min, float max) global
	if value >= max
		return max
	elseIf value <= min
		return min
	endIf
	return value
endFunction

float function SignFloat(bool sign, float value) global
	if sign
		return value * -1
	endIf
	return value
endFunction

;/-----------------------------------------------\;
;|	Integer Utility Functions                    |;
;\-----------------------------------------------/;

int[] function IncreaseInt(int by, int[] array) global
	int len = array.Length
	if by < 1 || (len+by > 128)
		return array
	elseIf len == 0
		return IntArray(by)
	endIf
	int[] output = IntArray(len+by)
	while len
		len -= 1
		output[len] = array[len]
	endWhile
	return output
endFunction

int[] function PushInt(int var, int[] array) global
	int len = array.Length
	if len >= 128
		return array
	endIf
	int[] output = IncreaseInt(1, array)
	output[len] = var
	return output
endFunction

int[] function MergeIntArray(int[] push, int[] array) global
	int pushing = push.Length
	if pushing+array.Length > 128 || pushing == 0
		return array
	endIf
	int[] output = IncreaseInt(pushing, array)
	int len = output.Length
	while pushing
		len -= 1
		pushing -= 1
		output[len] = push[pushing]
	endWhile
	return output
endFunction

int function ClampInt(int value, int min, int max) global
	if value >= max
		return max
	elseIf value <= min
		return min
	endIf
	return value
endFunction

int function SignInt(bool sign, int value) global
	if sign
		return value * -1
	endIf
	return value
endFunction

;/-----------------------------------------------\;
;|	Bool Utility Functions                       |;
;\-----------------------------------------------/;

bool[] function IncreaseBool(int by, bool[] array) global
	int len = array.Length
	if by < 1 || (len+by > 128)
		return array
	elseIf len == 0
		return BoolArray(by)
	endIf
	bool[] output = BoolArray(len+by)
	while len
		len -= 1
		output[len] = array[len]
	endWhile
	return output
endFunction


bool[] function PushBool(bool var, bool[] array) global
	int len = array.Length
	if len >= 128
		return array
	endIf
	bool[] output = IncreaseBool(1, array)
	output[len] = var
	return output
endFunction

bool[] function MergeBoolArray(bool[] push, bool[] array) global
	int pushing = push.Length
	if pushing+array.Length > 128 || pushing == 0
		return array
	endIf
	bool[] output = IncreaseBool(pushing, array)
	int len = output.Length
	while pushing
		len -= 1
		pushing -= 1
		output[len] = push[pushing]
	endWhile
	return output
endFunction

int function CountTrue(bool[] array) global
	int len = array.Length
	int pos = array.Find(true)
	int count
	while pos != -1 && pos < len
		count += 1
		pos += 1
		if pos < len
			pos = array.Find(true, pos)
		else
			pos = -1
		endIf
	endWhile
	return count
endFunction


;/-----------------------------------------------\;
;|	String Utility Functions                     |;
;\-----------------------------------------------/;

string[] function ArgString(string args, string delimiter = ",") global
	string[] output
	if args == "" || args == " "
		return output ; Empty arg string, return empty array
	endIf
	args += delimiter
	int prev = 0
	int next = StringUtil.Find(args, delimiter, prev)
	while next != -1
		string arg = StringUtil.SubString(args, prev, (next - prev))
		if StringUtil.GetNthChar(arg, 0) == " "
			arg = StringUtil.SubString(arg, 1)
		endIf
		if arg != "" && arg != delimiter
			output = PushString(arg, output)
		endIf
		prev = next + 1
		next = StringUtil.Find(args, delimiter, prev)
	endWhile
	return output
endFunction

string[] function IncreaseString(int by, string[] array) global
	int len = array.Length
	if by < 1 || (len+by > 128)
		return array
	elseIf len == 0
		return StringArray(by)
	endIf
	string[] output = StringArray(len+by)
	while len
		len -= 1
		output[len] = array[len]
	endWhile
	return output
endFunction

string[] function PushString(string var, string[] array) global
	int len = array.Length
	if len >= 128
		return array
	endIf
	string[] output = IncreaseString(1, array)
	output[len] = var
	return output
endFunction

string[] function MergeStringArray(string[] push, string[] array) global
	int pushing = push.Length
	if pushing+array.Length > 128 || pushing == 0
		return array
	endIf
	string[] output = IncreaseString(pushing, array)
	int len = output.Length
	while pushing
		len -= 1
		pushing -= 1
		output[len] = push[pushing]
	endWhile
	return output
endFunction

;/-----------------------------------------------\;
;|	Form Utility Functions                       |;
;\-----------------------------------------------/;

form[] function IncreaseForm(int by, form[] array) global
	int len = array.Length
	if by < 1 || (len+by > 128)
		return array
	elseIf len == 0
		return FormArray(by)
	endIf
	form[] output = FormArray(len+by)
	while len
		len -= 1
		output[len] = array[len]
	endWhile
	return output
endFunction

form[] function PushForm(form var, form[] array) global
	int len = array.Length
	if len >= 128
		return array
	endIf
	form[] output = IncreaseForm(1, array)
	output[len] = var
	return output
endFunction

form[] function MergeFormArray(form[] push, form[] array) global
	int pushing = push.Length
	if pushing+array.Length > 128 || pushing == 0
		return array
	endIf
	form[] output = IncreaseForm(pushing, array)
	int len = output.Length
	while pushing
		len -= 1
		pushing -= 1
		output[len] = push[pushing]
	endWhile
	return output
endFunction

int function CountNone(form[] array) global
	int len = array.Length
	int pos = array.Find(none)
	int count
	while pos != -1
		count += 1
		pos += 1
		if pos < len
			pos = array.Find(none, pos)
		else
			pos = -1
		endIf
	endWhile
	return count
endFunction

form[] function ClearNone(form[] array) global
	int filled = (array.Length - CountNone(array))
	if filled < 1
		form[] empty
		return empty
	elseif filled == array.Length
		return array
	endIf
	form[] output = FormArray(filled)
	filled -= 1
	int i = array.Length
	while i
		i -= 1
		if array[i] != none
			output[filled] = array[i]
			filled -= 1
		endIf
	endWhile
	return output
endFunction

;/-----------------------------------------------\;
;|	Other Utility Functions                      |;
;\-----------------------------------------------/;

sslBaseAnimation[] function PushAnimation(sslBaseAnimation var, sslBaseAnimation[] array) global
	int len = array.Length
	if len >= 64
		return array
	elseIf len == 0
		array = new sslBaseAnimation[1]
		array[0] = var
		return array
	endIf
	sslBaseAnimation[] pushed = AnimationArray(len+1)
	pushed[len] = var
	while len
		len -=1
		pushed[len] = array[len]
	endWhile
	return pushed
endFunction

actor[] function PushActor(actor var, actor[] array) global
	int len = array.Length
	if len >= 5
		return array
	elseIf len == 0
		array = new actor[1]
		array[0] = var
		return array
	endIf
	actor[] pushed = ActorArray(len+1)
	pushed[len] = var
	while len
		len -=1
		pushed[len] = array[len]
	endWhile
	return pushed
endFunction

;##############################################
;#  Below Array Functions Originally by Cmod  #
;##############################################

int function ValidateSize(int size) global
	if size < 1
		return 1
	elseIf size > 128
		return 128
	else
		return size
	endIf
endFunction

actor[] function ActorArray(int size) global
	if size == 1
		return new actor[1]
	elseIf size == 2
		return new actor[2]
	elseIf size == 3
		return new actor[3]
	elseIf size == 4
		return new actor[4]
	else
		return new actor[5]
	endIf
endFunction

sslBaseAnimation[] function AnimationArray(int size) global
	if size == 1
		return new sslBaseAnimation[1]
	elseIf size == 2
		return new sslBaseAnimation[2]
	elseIf size == 3
		return new sslBaseAnimation[3]
	elseIf size == 4
		return new sslBaseAnimation[4]
	elseIf size == 5
		return new sslBaseAnimation[5]
	elseIf size == 6
		return new sslBaseAnimation[6]
	elseIf size == 7
		return new sslBaseAnimation[7]
	elseIf size == 8
		return new sslBaseAnimation[8]
	elseIf size == 9
		return new sslBaseAnimation[9]
	elseIf size == 10
		return new sslBaseAnimation[10]
	elseIf size == 11
		return new sslBaseAnimation[11]
	elseIf size == 12
		return new sslBaseAnimation[12]
	elseIf size == 13
		return new sslBaseAnimation[13]
	elseIf size == 14
		return new sslBaseAnimation[14]
	elseIf size == 15
		return new sslBaseAnimation[15]
	elseIf size == 16
		return new sslBaseAnimation[16]
	elseIf size == 17
		return new sslBaseAnimation[17]
	elseIf size == 18
		return new sslBaseAnimation[18]
	elseIf size == 19
		return new sslBaseAnimation[19]
	elseIf size == 20
		return new sslBaseAnimation[20]
	elseIf size == 21
		return new sslBaseAnimation[21]
	elseIf size == 22
		return new sslBaseAnimation[22]
	elseIf size == 23
		return new sslBaseAnimation[23]
	elseIf size == 24
		return new sslBaseAnimation[24]
	elseIf size == 25
		return new sslBaseAnimation[25]
	elseIf size == 26
		return new sslBaseAnimation[26]
	elseIf size == 27
		return new sslBaseAnimation[27]
	elseIf size == 28
		return new sslBaseAnimation[28]
	elseIf size == 29
		return new sslBaseAnimation[29]
	elseIf size == 30
		return new sslBaseAnimation[30]
	elseIf size == 31
		return new sslBaseAnimation[31]
	elseIf size == 32
		return new sslBaseAnimation[32]
	elseIf size == 33
		return new sslBaseAnimation[33]
	elseIf size == 34
		return new sslBaseAnimation[34]
	elseIf size == 35
		return new sslBaseAnimation[35]
	elseIf size == 36
		return new sslBaseAnimation[36]
	elseIf size == 37
		return new sslBaseAnimation[37]
	elseIf size == 38
		return new sslBaseAnimation[38]
	elseIf size == 39
		return new sslBaseAnimation[39]
	elseIf size == 40
		return new sslBaseAnimation[40]
	elseIf size == 41
		return new sslBaseAnimation[41]
	elseIf size == 42
		return new sslBaseAnimation[42]
	elseIf size == 43
		return new sslBaseAnimation[43]
	elseIf size == 44
		return new sslBaseAnimation[44]
	elseIf size == 45
		return new sslBaseAnimation[45]
	elseIf size == 46
		return new sslBaseAnimation[46]
	elseIf size == 47
		return new sslBaseAnimation[47]
	elseIf size == 48
		return new sslBaseAnimation[48]
	elseIf size == 49
		return new sslBaseAnimation[49]
	elseIf size == 50
		return new sslBaseAnimation[50]
	elseIf size == 51
		return new sslBaseAnimation[51]
	elseIf size == 52
		return new sslBaseAnimation[52]
	elseIf size == 53
		return new sslBaseAnimation[53]
	elseIf size == 54
		return new sslBaseAnimation[54]
	elseIf size == 55
		return new sslBaseAnimation[55]
	elseIf size == 56
		return new sslBaseAnimation[56]
	elseIf size == 57
		return new sslBaseAnimation[57]
	elseIf size == 58
		return new sslBaseAnimation[58]
	elseIf size == 59
		return new sslBaseAnimation[59]
	elseIf size == 60
		return new sslBaseAnimation[60]
	elseIf size == 61
		return new sslBaseAnimation[61]
	elseIf size == 62
		return new sslBaseAnimation[62]
	elseIf size == 63
		return new sslBaseAnimation[63]
	else
		return new sslBaseAnimation[64]
	endIf
endFunction

form[] function FormArray(int size) global
	size = ValidateSize(size)
	if size == 1
		return new form[1]
	elseIf size == 2
		return new form[2]
	elseIf size == 3
		return new form[3]
	elseIf size == 4
		return new form[4]
	elseIf size == 5
		return new form[5]
	elseIf size == 6
		return new form[6]
	elseIf size == 7
		return new form[7]
	elseIf size == 8
		return new form[8]
	elseIf size == 9
		return new form[9]
	elseIf size == 10
		return new form[10]
	elseIf size == 11
		return new form[11]
	elseIf size == 12
		return new form[12]
	elseIf size == 13
		return new form[13]
	elseIf size == 14
		return new form[14]
	elseIf size == 15
		return new form[15]
	elseIf size == 16
		return new form[16]
	elseIf size == 17
		return new form[17]
	elseIf size == 18
		return new form[18]
	elseIf size == 19
		return new form[19]
	elseIf size == 20
		return new form[20]
	elseIf size == 21
		return new form[21]
	elseIf size == 22
		return new form[22]
	elseIf size == 23
		return new form[23]
	elseIf size == 24
		return new form[24]
	elseIf size == 25
		return new form[25]
	elseIf size == 26
		return new form[26]
	elseIf size == 27
		return new form[27]
	elseIf size == 28
		return new form[28]
	elseIf size == 29
		return new form[29]
	elseIf size == 30
		return new form[30]
	elseIf size == 31
		return new form[31]
	elseIf size == 32
		return new form[32]
	elseIf size == 33
		return new form[33]
	elseIf size == 34
		return new form[34]
	elseIf size == 35
		return new form[35]
	elseIf size == 36
		return new form[36]
	elseIf size == 37
		return new form[37]
	elseIf size == 38
		return new form[38]
	elseIf size == 39
		return new form[39]
	elseIf size == 40
		return new form[40]
	elseIf size == 41
		return new form[41]
	elseIf size == 42
		return new form[42]
	elseIf size == 43
		return new form[43]
	elseIf size == 44
		return new form[44]
	elseIf size == 45
		return new form[45]
	elseIf size == 46
		return new form[46]
	elseIf size == 47
		return new form[47]
	elseIf size == 48
		return new form[48]
	elseIf size == 49
		return new form[49]
	elseIf size == 50
		return new form[50]
	elseIf size == 51
		return new form[51]
	elseIf size == 52
		return new form[52]
	elseIf size == 53
		return new form[53]
	elseIf size == 54
		return new form[54]
	elseIf size == 55
		return new form[55]
	elseIf size == 56
		return new form[56]
	elseIf size == 57
		return new form[57]
	elseIf size == 58
		return new form[58]
	elseIf size == 59
		return new form[59]
	elseIf size == 60
		return new form[60]
	elseIf size == 61
		return new form[61]
	elseIf size == 62
		return new form[62]
	elseIf size == 63
		return new form[63]
	elseIf size == 64
		return new form[64]
	elseIf size == 65
		return new form[65]
	elseIf size == 66
		return new form[66]
	elseIf size == 67
		return new form[67]
	elseIf size == 68
		return new form[68]
	elseIf size == 69
		return new form[69]
	elseIf size == 70
		return new form[70]
	elseIf size == 71
		return new form[71]
	elseIf size == 72
		return new form[72]
	elseIf size == 73
		return new form[73]
	elseIf size == 74
		return new form[74]
	elseIf size == 75
		return new form[75]
	elseIf size == 76
		return new form[76]
	elseIf size == 77
		return new form[77]
	elseIf size == 78
		return new form[78]
	elseIf size == 79
		return new form[79]
	elseIf size == 80
		return new form[80]
	elseIf size == 81
		return new form[81]
	elseIf size == 82
		return new form[82]
	elseIf size == 83
		return new form[83]
	elseIf size == 84
		return new form[84]
	elseIf size == 85
		return new form[85]
	elseIf size == 86
		return new form[86]
	elseIf size == 87
		return new form[87]
	elseIf size == 88
		return new form[88]
	elseIf size == 89
		return new form[89]
	elseIf size == 90
		return new form[90]
	elseIf size == 91
		return new form[91]
	elseIf size == 92
		return new form[92]
	elseIf size == 93
		return new form[93]
	elseIf size == 94
		return new form[94]
	elseIf size == 95
		return new form[95]
	elseIf size == 96
		return new form[96]
	elseIf size == 97
		return new form[97]
	elseIf size == 98
		return new form[98]
	elseIf size == 99
		return new form[99]
	elseIf size == 100
		return new form[100]
	elseIf size == 101
		return new form[101]
	elseIf size == 102
		return new form[102]
	elseIf size == 103
		return new form[103]
	elseIf size == 104
		return new form[104]
	elseIf size == 105
		return new form[105]
	elseIf size == 106
		return new form[106]
	elseIf size == 107
		return new form[107]
	elseIf size == 108
		return new form[108]
	elseIf size == 109
		return new form[109]
	elseIf size == 110
		return new form[110]
	elseIf size == 111
		return new form[111]
	elseIf size == 112
		return new form[112]
	elseIf size == 113
		return new form[113]
	elseIf size == 114
		return new form[114]
	elseIf size == 115
		return new form[115]
	elseIf size == 116
		return new form[116]
	elseIf size == 117
		return new form[117]
	elseIf size == 118
		return new form[118]
	elseIf size == 119
		return new form[119]
	elseIf size == 120
		return new form[120]
	elseIf size == 121
		return new form[121]
	elseIf size == 122
		return new form[122]
	elseIf size == 123
		return new form[123]
	elseIf size == 124
		return new form[124]
	elseIf size == 125
		return new form[125]
	elseIf size == 126
		return new form[126]
	elseIf size == 127
		return new form[127]
	elseIf size == 128
		return new form[128]
	endIf
endFunction

float[] function FloatArray(int size) global
	size = ValidateSize(size)
	if size == 1
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
	elseIf size == 7
		return new float[7]
	elseIf size == 8
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
	elseIf size == 15
		return new float[15]
	elseIf size == 16
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
	elseIf size == 23
		return new float[23]
	elseIf size == 24
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
	elseIf size == 31
		return new float[31]
	elseIf size == 32
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
	elseIf size == 39
		return new float[39]
	elseIf size == 40
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
	elseIf size == 47
		return new float[47]
	elseIf size == 48
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
	elseIf size == 55
		return new float[55]
	elseIf size == 56
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
	elseIf size == 63
		return new float[63]
	elseIf size == 64
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
	elseIf size == 71
		return new float[71]
	elseIf size == 72
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
	elseIf size == 79
		return new float[79]
	elseIf size == 80
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
	elseIf size == 87
		return new float[87]
	elseIf size == 88
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
	elseIf size == 95
		return new float[95]
	elseIf size == 96
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
	elseIf size == 103
		return new float[103]
	elseIf size == 104
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
	elseIf size == 111
		return new float[111]
	elseIf size == 112
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
	elseIf size == 119
		return new float[119]
	elseIf size == 120
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
	elseIf size == 128
		return new float[128]
	endIf
endFunction
int[] function IntArray(int size) global
	size = ValidateSize(size)
	if size == 1
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
	elseIf size == 7
		return new int[7]
	elseIf size == 8
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
	elseIf size == 15
		return new int[15]
	elseIf size == 16
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
	elseIf size == 23
		return new int[23]
	elseIf size == 24
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
	elseIf size == 31
		return new int[31]
	elseIf size == 32
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
	elseIf size == 39
		return new int[39]
	elseIf size == 40
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
	elseIf size == 47
		return new int[47]
	elseIf size == 48
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
	elseIf size == 55
		return new int[55]
	elseIf size == 56
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
	elseIf size == 63
		return new int[63]
	elseIf size == 64
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
	elseIf size == 71
		return new int[71]
	elseIf size == 72
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
	elseIf size == 79
		return new int[79]
	elseIf size == 80
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
	elseIf size == 87
		return new int[87]
	elseIf size == 88
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
	elseIf size == 95
		return new int[95]
	elseIf size == 96
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
	elseIf size == 103
		return new int[103]
	elseIf size == 104
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
	elseIf size == 111
		return new int[111]
	elseIf size == 112
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
	elseIf size == 119
		return new int[119]
	elseIf size == 120
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
	elseIf size == 128
		return new int[128]
	endIf
Endfunction
bool[] function BoolArray(int size) global
	size = ValidateSize(size)
	if size == 1
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
	elseIf size == 7
		return new bool[7]
	elseIf size == 8
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
	elseIf size == 15
		return new bool[15]
	elseIf size == 16
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
	elseIf size == 23
		return new bool[23]
	elseIf size == 24
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
	elseIf size == 31
		return new bool[31]
	elseIf size == 32
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
	elseIf size == 39
		return new bool[39]
	elseIf size == 40
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
	elseIf size == 47
		return new bool[47]
	elseIf size == 48
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
	elseIf size == 55
		return new bool[55]
	elseIf size == 56
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
	elseIf size == 63
		return new bool[63]
	elseIf size == 64
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
	elseIf size == 71
		return new bool[71]
	elseIf size == 72
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
	elseIf size == 79
		return new bool[79]
	elseIf size == 80
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
	elseIf size == 87
		return new bool[87]
	elseIf size == 88
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
	elseIf size == 95
		return new bool[95]
	elseIf size == 96
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
	elseIf size == 103
		return new bool[103]
	elseIf size == 104
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
	elseIf size == 111
		return new bool[111]
	elseIf size == 112
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
	elseIf size == 119
		return new bool[119]
	elseIf size == 120
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
	elseIf size == 128
		return new bool[128]
	endIf
endFunction
string[] function StringArray(int size) global
	size = ValidateSize(size)
	if size == 1
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
	elseIf size == 7
		return new string[7]
	elseIf size == 8
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
	elseIf size == 15
		return new string[15]
	elseIf size == 16
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
	elseIf size == 23
		return new string[23]
	elseIf size == 24
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
	elseIf size == 31
		return new string[31]
	elseIf size == 32
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
	elseIf size == 39
		return new string[39]
	elseIf size == 40
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
	elseIf size == 47
		return new string[47]
	elseIf size == 48
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
	elseIf size == 55
		return new string[55]
	elseIf size == 56
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
	elseIf size == 63
		return new string[63]
	elseIf size == 64
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
	elseIf size == 71
		return new string[71]
	elseIf size == 72
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
	elseIf size == 79
		return new string[79]
	elseIf size == 80
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
	elseIf size == 87
		return new string[87]
	elseIf size == 88
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
	elseIf size == 95
		return new string[95]
	elseIf size == 96
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
	elseIf size == 103
		return new string[103]
	elseIf size == 104
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
	elseIf size == 111
		return new string[111]
	elseIf size == 112
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
	elseIf size == 119
		return new string[119]
	elseIf size == 120
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
	elseIf size == 128
		return new string[128]
	endIf
endfunction
