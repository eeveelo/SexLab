scriptname sslUtility hidden

;/-----------------------------------------------\;
;|	Float Utility Functions                      |;
;\-----------------------------------------------/;

function FloatCopyTo(float[] Array, float[] Output, int StartIndex = 0, int EndIndex = -1) global native
float function AddFloatValues(float[] Array) global native

float[] function IncreaseFloat(int by, float[] Array) global
	int len = Array.Length
	if by < 1 || (len+by > 128)
		return Array
	elseIf len == 0
		return FloatArray(by)
	endIf
	float[] Output = FloatArray(len+by)
	FloatCopyTo(Array, Output)
	return Output
endFunction

float[] function PushFloat(float var, float[] Array) global
	int len = Array.Length
	if len >= 128
		return Array
	endIf
	float[] Output = IncreaseFloat(1, Array)
	Output[len] = var
	return Output
endFunction

float[] function MergeFloatArray(float[] Push, float[] Array) global
	int Pushing = Push.Length
	int have = Array.length
	if have == 0
		return Push
	elseIf Pushing == 0 || Pushing+have > 128
		return Array
	endIf
	float[] Output = IncreaseFloat(Pushing, Array)
	int len = Output.Length
	while Pushing
		len -= 1
		Pushing -= 1
		Output[len] = Push[Pushing]
	endWhile
	return Output
endFunction

float[] function TrimFloatArray(float[] Array, int len) global
	if Array.Length < 1 || Array.Length == len
		return Array
	endIf
	float[] Output = FloatArray(len)
	FloatCopyTo(Array, Output, 0, len)
	return Output
endFunction

float[] function EmptyFloatArray() global
	float[] empty
	return empty
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

function IntCopyTo(int[] Array, int[] Output, int StartIndex = 0, int EndIndex = -1) global native
int function AddIntValues(int[] Array) global native

int[] function IncreaseInt(int by, int[] Array) global
	int len = Array.Length
	if by < 1 || (len+by > 128)
		return Array
	elseIf len == 0
		return IntArray(by)
	endIf
	int[] Output = IntArray(len+by)
	IntCopyTo(Array, Output)
	return Output
endFunction

int[] function PushInt(int var, int[] Array) global
	int len = Array.Length
	if len >= 128
		return Array
	endIf
	int[] Output = IncreaseInt(1, Array)
	Output[len] = var
	return Output
endFunction

int[] function MergeIntArray(int[] Push, int[] Array) global
	int Pushing = Push.Length
	int have = Array.length
	if have == 0
		return Push
	elseIf Pushing == 0 || Pushing+have > 128
		return Array
	endIf
	int[] Output = IncreaseInt(Pushing, Array)
	int len = Output.Length
	while Pushing
		len -= 1
		Pushing -= 1
		Output[len] = Push[Pushing]
	endWhile
	return Output
endFunction

int[] function TrimIntArray(int[] Array, int len) global
	if Array.Length < 1 || Array.Length == len
		return Array
	endIf
	int[] Output = IntArray(len)
	IntCopyTo(Array, Output, 0, len)
	return Output
endFunction

int[] function EmptyIntArray() global
	int[] empty
	return empty
endFunction

int[] function SliceIntArray(int[] Array, int startindex = 0, int endindex = -1) global
	int len = Array.Length
	if startindex >= len || (startindex == 0 && endindex == -1) || (endindex <= startindex && endindex != -1)
		return Array
	elseIf endindex >= len || endindex == -1
		endindex = len - 1
	endIf
	int[] Output = IntArray((endindex - startindex) + 1)
	int i = Output.Length
	while i
		i -= 1
		Output[i] = Array[endindex]
		endindex -= 1
	endWhile
	return Output
endFunction

int function ClampInt(int value, int min, int max) global
	if value >= max
		return max
	elseIf value <= min
		return min
	endIf
	return value
endFunction

int function WrapIndex(int index, int len) global
	if index >= len
		return 0
	elseif index < 0
		return len - 1
	endIf
	return index
endFunction


int function IndexTravel(int index, int len, bool backwards = false) global
	; Direction of travel
	if backwards
		index -= 1
	else
		index += 1
	endIf
	; Wrap around
	if index >= len
		return 0
	elseif index < 0
		return len - 1
	endIf
	return index
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

int function CountTrue(bool[] Array) global native
function BoolCopyTo(bool[] Array, bool[] Output, int StartIndex = 0, int EndIndex = -1) global native

bool[] function IncreaseBool(int by, bool[] Array) global
	int len = Array.Length
	if by < 1 || (len+by > 128)
		return Array
	elseIf len == 0
		return BoolArray(by)
	endIf
	bool[] Output = BoolArray(len+by)
	BoolCopyTo(Array, Output)
	return Output
endFunction


bool[] function PushBool(bool var, bool[] Array) global
	int len = Array.Length
	if len >= 128
		return Array
	endIf
	bool[] Output = IncreaseBool(1, Array)
	Output[len] = var
	return Output
endFunction

bool[] function MergeBoolArray(bool[] Push, bool[] Array) global
	int Pushing = Push.Length
	int have = Array.length
	if have == 0
		return Push
	elseIf Pushing == 0 || Pushing+have > 128
		return Array
	endIf
	bool[] Output = IncreaseBool(Pushing, Array)
	int len = Output.Length
	while Pushing
		len -= 1
		Pushing -= 1
		Output[len] = Push[Pushing]
	endWhile
	return Output
endFunction

bool[] function TrimBoolArray(bool[] Array, int len) global
	if Array.Length < 1 || Array.Length == len
		return Array
	endIf
	bool[] Output = BoolArray(len)
	BoolCopyTo(Array, Output, 0, len)
	return Output
endFunction

bool[] function EmptyBoolArray() global
	bool[] empty
	return empty
endFunction

;/-----------------------------------------------\;
;|	String Utility Functions                     |;
;\-----------------------------------------------/;

int function CountEmpty(string[] Array) global native
function StringCopyTo(string[] Array, string[] Output, int StartIndex = 0, int EndIndex = -1, bool AllowEmpty = true) global native

string[] function IncreaseString(int by, string[] Array) global
	int len = Array.Length
	if by < 1 || (len+by > 128)
		return Array
	elseIf len == 0
		return StringArray(by)
	endIf
	string[] Output = StringArray(len+by)
	StringCopyTo(Array, Output)
	return Output
endFunction

string[] function PushString(string var, string[] Array) global
	int len = Array.Length
	if len >= 128
		return Array
	endIf
	string[] Output = IncreaseString(1, Array)
	Output[len] = var
	return Output
endFunction

string[] function MergeStringArray(string[] Push, string[] Array) global
	int Pushing = Push.Length
	int have = Array.length
	if have == 0
		return Push
	elseIf Pushing == 0 || Pushing+have > 128
		return Array
	endIf
	string[] Output = IncreaseString(Pushing, Array)
	int len = Output.Length
	while Pushing
		len -= 1
		Pushing -= 1
		Output[len] = Push[Pushing]
	endWhile
	return Output
endFunction

string[] function TrimStringArray(string[] Array, int len) global
	if Array.Length < 1 || Array.Length == len
		return Array
	endIf
	string[] Output = StringArray(len)
	StringCopyTo(Array, Output, 0, len)
	return Output
endFunction

string[] function ClearEmpty(string[] Array) global
	int Count = (array.Length - CountEmpty(array))
	if Count < 1
		string[] empty
		return empty
	elseif Count == Array.Length
		return Array
	endIf
	string[] Output = StringArray(Count)
	StringCopyTo(Array, Output, 0, -1, false)
	return Output
endFunction

string[] function EmptyStringArray() global
	string[] empty
	return empty
endFunction


string[] function ArgString(string args, string delimiter = ",") global
	string[] Output
	; Empty args
	if args == ""
		return Output
	endIf
	; Has no delimiter present
	int Next = StringUtil.Find(args, delimiter)
	if Next == -1
		return PushString(args, Output)
	endIf
	; Count occurences of delimiter
	args += delimiter
	int Len = StringUtil.GetLength(args)
	int Count
	while Next != -1 && Next < Len
		Count += 1
		Next = StringUtil.Find(args, delimiter, (Next + 1))
	endWhile
	; Parse the argurments out of string
	int i
	Output = StringArray(Count)
	int DelimLen = StringUtil.GetLength(delimiter)
	int Prev
	Next = StringUtil.Find(args, delimiter)
	while Next != -1 && Next < Len
		Output[i] = Trim(StringUtil.SubString(args, Prev, (Next - Prev)))
		Prev = Next + DelimLen
		Next = StringUtil.Find(args, delimiter, Prev)
		i += 1
	endWhile
	return Output
endFunction

string function MakeArgs(string delimiter, string arg1, string arg2 = "", string arg3 = "", string arg4 = "", string arg5 = "") global
	if arg2 != ""
		arg1 += delimiter+arg2
	endIf
	if arg3 != ""
		arg1 += delimiter+arg3
	endIf
	if arg4 != ""
		arg1 += delimiter+arg4
	endIf
	if arg5 != ""
		arg1 += delimiter+arg5
	endIf
	return arg1
endFunction

string function Trim(string var) global
	if StringUtil.GetNthChar(var, 0) == " "
		return StringUtil.SubString(var, 1)
	endIf
	return var
endFunction

string function RemoveString(string str, string toRemove, int startindex = 0) global
	int i = StringUtil.Find(str, toRemove, startindex)
	if i == -1
		return str
	elseIf i == 0
		return StringUtil.SubString(str, StringUtil.GetLength(toRemove))
	endIf
	string part1 = StringUtil.SubString(str, 0, i)
	string part2 = StringUtil.SubString(str, (i + StringUtil.GetLength(toRemove)))
	return part1 + part2
endFunction


;/-----------------------------------------------\;
;|	Form Utility Functions                       |;
;\-----------------------------------------------/;

int function CountNone(form[] Array) global native
function FormCopyTo(form[] Source, form[] Output, bool AllowNone) global native

form[] function IncreaseForm(int by, form[] Array) global
	int len = Array.Length
	if by < 1 || (len+by > 128)
		return Array
	elseIf len == 0
		return FormArray(by)
	endIf
	form[] Output = FormArray(len+by)
	FormCopyTo(Array, Output, true)
	return Output
endFunction

form[] function PushForm(form var, form[] Array) global
	int len = Array.Length
	if len >= 128
		return Array
	endIf
	form[] Output = IncreaseForm(1, Array)
	Output[len] = var
	return Output
endFunction

form[] function MergeFormArray(form[] Push, form[] Array) global
	int Pushing = Push.Length
	int have = Array.length
	if have == 0
		return Push
	elseIf Pushing == 0 || Pushing+have > 128
		return Array
	endIf
	form[] Output = IncreaseForm(Pushing, Array)
	int len = Output.Length
	while Pushing
		len -= 1
		Pushing -= 1
		Output[len] = Push[Pushing]
	endWhile
	return Output
endFunction

form[] function ClearNone(form[] Array) global
	int Count = (Array.Length - CountNone(Array))
	if Count < 1
		form[] empty
		return empty
	elseif Count == Array.Length
		return Array
	endIf
	form[] Output = FormArray(Count)
	FormCopyTo(Array, Output, false)
	return Output
endFunction

form[] function EmptyFormArray() global
	form[] empty
	return empty
endFunction

;/-----------------------------------------------\;
;|	Other Utility Functions                      |;
;\-----------------------------------------------/;

sslBaseAnimation[] function PushAnimation(sslBaseAnimation var, sslBaseAnimation[] Array) global
	int len = Array.Length
	if len >= 100
		return Array
	elseIf len == 0
		array = new sslBaseAnimation[1]
		array[0] = var
		return Array
	endIf
	sslBaseAnimation[] Pushed = AnimationArray(len+1)
	pushed[len] = var
	while len
		len -=1
		pushed[len] = Array[len]
	endWhile
	return Pushed
endFunction

sslBaseAnimation[] function IncreaseAnimation(int by, sslBaseAnimation[] Array) global
	int len = Array.Length
	if by < 1 || (len+by > 100)
		return Array
	elseIf len == 0
		return AnimationArray(by)
	endIf
	sslBaseAnimation[] Output = AnimationArray(len+by)
	while len
		len -= 1
		Output[len] = Array[len]
	endWhile
	return Output
endFunction

sslBaseAnimation[] function EmptyAnimationArray() global
	sslBaseAnimation[] empty
	return empty
endFunction

Actor[] function PushActor(Actor var, Actor[] Array) global
	int len = Array.Length
	if len >= 5
		return Array
	elseIf len == 0
		array = new Actor[1]
		array[0] = var
		return Array
	endIf
	Actor[] Pushed = ActorArray(len+1)
	pushed[len] = var
	while len
		len -=1
		pushed[len] = Array[len]
	endWhile
	return Pushed
endFunction

Actor[] function MakeActorArray(Actor Actor1 = none, Actor Actor2 = none, Actor Actor3 = none, Actor Actor4 = none, Actor Actor5 = none) global
	Actor[] Output
	if Actor1
		Output = PushActor(Actor1, Output)
	endIf
	if Actor2
		Output = PushActor(Actor2, Output)
	endIf
	if Actor3
		Output = PushActor(Actor3, Output)
	endIf
	if Actor4
		Output = PushActor(Actor4, Output)
	endIf
	if Actor5
		Output = PushActor(Actor5, Output)
	endIf
	return Output
endFunction

;##############################################
;#  Below Array Functions Originally by Cmod  #
;##############################################

Actor[] function ActorArray(int size) global
	if size == 0
		Actor[] empty
		return empty
	elseIf size == 1
		return new Actor[1]
	elseIf size == 2
		return new Actor[2]
	elseIf size == 3
		return new Actor[3]
	elseIf size == 4
		return new Actor[4]
	else
		return new Actor[5]
	endIf
endFunction

sslBaseAnimation[] function AnimationArray(int size) global
	if size < 8
		if size == 0
			sslBaseAnimation[] Empty
			return Empty
		elseIf size == 1
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
		else
			return new sslBaseAnimation[7]
		endIf
	elseIf size < 16
		if size == 8
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
		else
			return new sslBaseAnimation[15]
		endIf
	elseIf size < 24
		if size == 16
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
		else
			return new sslBaseAnimation[23]
		endIf
	elseIf size < 32
		if size == 24
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
		else
			return new sslBaseAnimation[31]
		endIf
	elseIf size < 40
		if size == 32
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
		else
			return new sslBaseAnimation[39]
		endIf
	elseIf size < 48
		if size == 40
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
		else
			return new sslBaseAnimation[47]
		endIf
	elseIf size < 56
		if size == 48
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
		else
			return new sslBaseAnimation[55]
		endif
	elseIf size < 64
		if size == 56
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
		else
			return new sslBaseAnimation[63]
		endIf
	elseIf size < 72
		if size == 64
			return new sslBaseAnimation[64]
		elseIf size == 65
			return new sslBaseAnimation[65]
		elseIf size == 66
			return new sslBaseAnimation[66]
		elseIf size == 67
			return new sslBaseAnimation[67]
		elseIf size == 68
			return new sslBaseAnimation[68]
		elseIf size == 69
			return new sslBaseAnimation[69]
		elseIf size == 70
			return new sslBaseAnimation[70]
		else
			return new sslBaseAnimation[71]
		endif
	elseIf size < 80
		if size == 72
			return new sslBaseAnimation[72]
		elseIf size == 73
			return new sslBaseAnimation[73]
		elseIf size == 74
			return new sslBaseAnimation[74]
		elseIf size == 75
			return new sslBaseAnimation[75]
		elseIf size == 76
			return new sslBaseAnimation[76]
		elseIf size == 77
			return new sslBaseAnimation[77]
		elseIf size == 78
			return new sslBaseAnimation[78]
		else
			return new sslBaseAnimation[79]
		endIf
	elseIf size < 88
		if size == 80
			return new sslBaseAnimation[80]
		elseIf size == 81
			return new sslBaseAnimation[81]
		elseIf size == 82
			return new sslBaseAnimation[82]
		elseIf size == 83
			return new sslBaseAnimation[83]
		elseIf size == 84
			return new sslBaseAnimation[84]
		elseIf size == 85
			return new sslBaseAnimation[85]
		elseIf size == 86
			return new sslBaseAnimation[86]
		else
			return new sslBaseAnimation[87]
		endif
	elseIf size < 96
		if size == 88
			return new sslBaseAnimation[88]
		elseIf size == 89
			return new sslBaseAnimation[89]
		elseIf size == 90
			return new sslBaseAnimation[90]
		elseIf size == 91
			return new sslBaseAnimation[91]
		elseIf size == 92
			return new sslBaseAnimation[92]
		elseIf size == 93
			return new sslBaseAnimation[93]
		elseIf size == 94
			return new sslBaseAnimation[94]
		else
			return new sslBaseAnimation[95]
		endIf
	elseIf size < 104
		if size == 96
			return new sslBaseAnimation[96]
		elseIf size == 97
			return new sslBaseAnimation[97]
		elseIf size == 98
			return new sslBaseAnimation[98]
		elseIf size == 99
			return new sslBaseAnimation[99]
		elseIf size == 100
			return new sslBaseAnimation[100]
		elseIf size == 101
			return new sslBaseAnimation[101]
		elseIf size == 102
			return new sslBaseAnimation[102]
		else
			return new sslBaseAnimation[103]
		endif
	elseIf size < 112
		if size == 104
			return new sslBaseAnimation[104]
		elseIf size == 105
			return new sslBaseAnimation[105]
		elseIf size == 106
			return new sslBaseAnimation[106]
		elseIf size == 107
			return new sslBaseAnimation[107]
		elseIf size == 108
			return new sslBaseAnimation[108]
		elseIf size == 109
			return new sslBaseAnimation[109]
		elseIf size == 110
			return new sslBaseAnimation[110]
		else
			return new sslBaseAnimation[111]
		endif
	elseIf size < 120
		if size == 112
			return new sslBaseAnimation[112]
		elseIf size == 113
			return new sslBaseAnimation[113]
		elseIf size == 114
			return new sslBaseAnimation[114]
		elseIf size == 115
			return new sslBaseAnimation[115]
		elseIf size == 116
			return new sslBaseAnimation[116]
		elseIf size == 117
			return new sslBaseAnimation[117]
		elseIf size == 118
			return new sslBaseAnimation[118]
		else
			return new sslBaseAnimation[119]
		endif
	else
		if size == 120
			return new sslBaseAnimation[120]
		elseIf size == 121
			return new sslBaseAnimation[121]
		elseIf size == 122
			return new sslBaseAnimation[122]
		elseIf size == 123
			return new sslBaseAnimation[123]
		elseIf size == 124
			return new sslBaseAnimation[124]
		elseIf size == 125
			return new sslBaseAnimation[125]
		elseIf size == 126
			return new sslBaseAnimation[126]
		elseIf size == 127
			return new sslBaseAnimation[127]
		else
			return new sslBaseAnimation[128]
		endIf
	endIf
endFunction
sslBaseVoice[] function VoiceArray(int size) global
	if size < 8
		if size == 0
			sslBaseVoice[] Empty
			return Empty
		elseIf size == 1
			return new sslBaseVoice[1]
		elseIf size == 2
			return new sslBaseVoice[2]
		elseIf size == 3
			return new sslBaseVoice[3]
		elseIf size == 4
			return new sslBaseVoice[4]
		elseIf size == 5
			return new sslBaseVoice[5]
		elseIf size == 6
			return new sslBaseVoice[6]
		else
			return new sslBaseVoice[7]
		endIf
	elseIf size < 16
		if size == 8
			return new sslBaseVoice[8]
		elseIf size == 9
			return new sslBaseVoice[9]
		elseIf size == 10
			return new sslBaseVoice[10]
		elseIf size == 11
			return new sslBaseVoice[11]
		elseIf size == 12
			return new sslBaseVoice[12]
		elseIf size == 13
			return new sslBaseVoice[13]
		elseIf size == 14
			return new sslBaseVoice[14]
		else
			return new sslBaseVoice[15]
		endIf
	elseIf size < 24
		if size == 16
			return new sslBaseVoice[16]
		elseIf size == 17
			return new sslBaseVoice[17]
		elseIf size == 18
			return new sslBaseVoice[18]
		elseIf size == 19
			return new sslBaseVoice[19]
		elseIf size == 20
			return new sslBaseVoice[20]
		elseIf size == 21
			return new sslBaseVoice[21]
		elseIf size == 22
			return new sslBaseVoice[22]
		else
			return new sslBaseVoice[23]
		endIf
	elseIf size < 32
		if size == 24
			return new sslBaseVoice[24]
		elseIf size == 25
			return new sslBaseVoice[25]
		elseIf size == 26
			return new sslBaseVoice[26]
		elseIf size == 27
			return new sslBaseVoice[27]
		elseIf size == 28
			return new sslBaseVoice[28]
		elseIf size == 29
			return new sslBaseVoice[29]
		elseIf size == 30
			return new sslBaseVoice[30]
		else
			return new sslBaseVoice[31]
		endIf
	elseIf size < 40
		if size == 32
			return new sslBaseVoice[32]
		elseIf size == 33
			return new sslBaseVoice[33]
		elseIf size == 34
			return new sslBaseVoice[34]
		elseIf size == 35
			return new sslBaseVoice[35]
		elseIf size == 36
			return new sslBaseVoice[36]
		elseIf size == 37
			return new sslBaseVoice[37]
		elseIf size == 38
			return new sslBaseVoice[38]
		else
			return new sslBaseVoice[39]
		endIf
	elseIf size < 48
		if size == 40
			return new sslBaseVoice[40]
		elseIf size == 41
			return new sslBaseVoice[41]
		elseIf size == 42
			return new sslBaseVoice[42]
		elseIf size == 43
			return new sslBaseVoice[43]
		elseIf size == 44
			return new sslBaseVoice[44]
		elseIf size == 45
			return new sslBaseVoice[45]
		elseIf size == 46
			return new sslBaseVoice[46]
		else
			return new sslBaseVoice[47]
		endIf
	elseIf size < 56
		if size == 48
			return new sslBaseVoice[48]
		elseIf size == 49
			return new sslBaseVoice[49]
		elseIf size == 50
			return new sslBaseVoice[50]
		elseIf size == 51
			return new sslBaseVoice[51]
		elseIf size == 52
			return new sslBaseVoice[52]
		elseIf size == 53
			return new sslBaseVoice[53]
		elseIf size == 54
			return new sslBaseVoice[54]
		else
			return new sslBaseVoice[55]
		endif
	elseIf size < 64
		if size == 56
			return new sslBaseVoice[56]
		elseIf size == 57
			return new sslBaseVoice[57]
		elseIf size == 58
			return new sslBaseVoice[58]
		elseIf size == 59
			return new sslBaseVoice[59]
		elseIf size == 60
			return new sslBaseVoice[60]
		elseIf size == 61
			return new sslBaseVoice[61]
		elseIf size == 62
			return new sslBaseVoice[62]
		else
			return new sslBaseVoice[63]
		endIf
	elseIf size < 72
		if size == 64
			return new sslBaseVoice[64]
		elseIf size == 65
			return new sslBaseVoice[65]
		elseIf size == 66
			return new sslBaseVoice[66]
		elseIf size == 67
			return new sslBaseVoice[67]
		elseIf size == 68
			return new sslBaseVoice[68]
		elseIf size == 69
			return new sslBaseVoice[69]
		elseIf size == 70
			return new sslBaseVoice[70]
		else
			return new sslBaseVoice[71]
		endif
	elseIf size < 80
		if size == 72
			return new sslBaseVoice[72]
		elseIf size == 73
			return new sslBaseVoice[73]
		elseIf size == 74
			return new sslBaseVoice[74]
		elseIf size == 75
			return new sslBaseVoice[75]
		elseIf size == 76
			return new sslBaseVoice[76]
		elseIf size == 77
			return new sslBaseVoice[77]
		elseIf size == 78
			return new sslBaseVoice[78]
		else
			return new sslBaseVoice[79]
		endIf
	elseIf size < 88
		if size == 80
			return new sslBaseVoice[80]
		elseIf size == 81
			return new sslBaseVoice[81]
		elseIf size == 82
			return new sslBaseVoice[82]
		elseIf size == 83
			return new sslBaseVoice[83]
		elseIf size == 84
			return new sslBaseVoice[84]
		elseIf size == 85
			return new sslBaseVoice[85]
		elseIf size == 86
			return new sslBaseVoice[86]
		else
			return new sslBaseVoice[87]
		endif
	elseIf size < 96
		if size == 88
			return new sslBaseVoice[88]
		elseIf size == 89
			return new sslBaseVoice[89]
		elseIf size == 90
			return new sslBaseVoice[90]
		elseIf size == 91
			return new sslBaseVoice[91]
		elseIf size == 92
			return new sslBaseVoice[92]
		elseIf size == 93
			return new sslBaseVoice[93]
		elseIf size == 94
			return new sslBaseVoice[94]
		else
			return new sslBaseVoice[95]
		endIf
	elseIf size < 104
		if size == 96
			return new sslBaseVoice[96]
		elseIf size == 97
			return new sslBaseVoice[97]
		elseIf size == 98
			return new sslBaseVoice[98]
		elseIf size == 99
			return new sslBaseVoice[99]
		elseIf size == 100
			return new sslBaseVoice[100]
		elseIf size == 101
			return new sslBaseVoice[101]
		elseIf size == 102
			return new sslBaseVoice[102]
		else
			return new sslBaseVoice[103]
		endif
	elseIf size < 112
		if size == 104
			return new sslBaseVoice[104]
		elseIf size == 105
			return new sslBaseVoice[105]
		elseIf size == 106
			return new sslBaseVoice[106]
		elseIf size == 107
			return new sslBaseVoice[107]
		elseIf size == 108
			return new sslBaseVoice[108]
		elseIf size == 109
			return new sslBaseVoice[109]
		elseIf size == 110
			return new sslBaseVoice[110]
		else
			return new sslBaseVoice[111]
		endif
	elseIf size < 120
		if size == 112
			return new sslBaseVoice[112]
		elseIf size == 113
			return new sslBaseVoice[113]
		elseIf size == 114
			return new sslBaseVoice[114]
		elseIf size == 115
			return new sslBaseVoice[115]
		elseIf size == 116
			return new sslBaseVoice[116]
		elseIf size == 117
			return new sslBaseVoice[117]
		elseIf size == 118
			return new sslBaseVoice[118]
		else
			return new sslBaseVoice[119]
		endif
	else
		if size == 120
			return new sslBaseVoice[120]
		elseIf size == 121
			return new sslBaseVoice[121]
		elseIf size == 122
			return new sslBaseVoice[122]
		elseIf size == 123
			return new sslBaseVoice[123]
		elseIf size == 124
			return new sslBaseVoice[124]
		elseIf size == 125
			return new sslBaseVoice[125]
		elseIf size == 126
			return new sslBaseVoice[126]
		elseIf size == 127
			return new sslBaseVoice[127]
		else
			return new sslBaseVoice[128]
		endIf
	endIf
endFunction
sslBaseExpression[] function ExpressionArray(int size) global
	if size < 8
		if size == 0
			sslBaseExpression[] Empty
			return Empty
		elseIf size == 1
			return new sslBaseExpression[1]
		elseIf size == 2
			return new sslBaseExpression[2]
		elseIf size == 3
			return new sslBaseExpression[3]
		elseIf size == 4
			return new sslBaseExpression[4]
		elseIf size == 5
			return new sslBaseExpression[5]
		elseIf size == 6
			return new sslBaseExpression[6]
		else
			return new sslBaseExpression[7]
		endIf
	elseIf size < 16
		if size == 8
			return new sslBaseExpression[8]
		elseIf size == 9
			return new sslBaseExpression[9]
		elseIf size == 10
			return new sslBaseExpression[10]
		elseIf size == 11
			return new sslBaseExpression[11]
		elseIf size == 12
			return new sslBaseExpression[12]
		elseIf size == 13
			return new sslBaseExpression[13]
		elseIf size == 14
			return new sslBaseExpression[14]
		else
			return new sslBaseExpression[15]
		endIf
	elseIf size < 24
		if size == 16
			return new sslBaseExpression[16]
		elseIf size == 17
			return new sslBaseExpression[17]
		elseIf size == 18
			return new sslBaseExpression[18]
		elseIf size == 19
			return new sslBaseExpression[19]
		elseIf size == 20
			return new sslBaseExpression[20]
		elseIf size == 21
			return new sslBaseExpression[21]
		elseIf size == 22
			return new sslBaseExpression[22]
		else
			return new sslBaseExpression[23]
		endIf
	elseIf size < 32
		if size == 24
			return new sslBaseExpression[24]
		elseIf size == 25
			return new sslBaseExpression[25]
		elseIf size == 26
			return new sslBaseExpression[26]
		elseIf size == 27
			return new sslBaseExpression[27]
		elseIf size == 28
			return new sslBaseExpression[28]
		elseIf size == 29
			return new sslBaseExpression[29]
		elseIf size == 30
			return new sslBaseExpression[30]
		else
			return new sslBaseExpression[31]
		endIf
	elseIf size < 40
		if size == 32
			return new sslBaseExpression[32]
		elseIf size == 33
			return new sslBaseExpression[33]
		elseIf size == 34
			return new sslBaseExpression[34]
		elseIf size == 35
			return new sslBaseExpression[35]
		elseIf size == 36
			return new sslBaseExpression[36]
		elseIf size == 37
			return new sslBaseExpression[37]
		elseIf size == 38
			return new sslBaseExpression[38]
		else
			return new sslBaseExpression[39]
		endIf
	elseIf size < 48
		if size == 40
			return new sslBaseExpression[40]
		elseIf size == 41
			return new sslBaseExpression[41]
		elseIf size == 42
			return new sslBaseExpression[42]
		elseIf size == 43
			return new sslBaseExpression[43]
		elseIf size == 44
			return new sslBaseExpression[44]
		elseIf size == 45
			return new sslBaseExpression[45]
		elseIf size == 46
			return new sslBaseExpression[46]
		else
			return new sslBaseExpression[47]
		endIf
	elseIf size < 56
		if size == 48
			return new sslBaseExpression[48]
		elseIf size == 49
			return new sslBaseExpression[49]
		elseIf size == 50
			return new sslBaseExpression[50]
		elseIf size == 51
			return new sslBaseExpression[51]
		elseIf size == 52
			return new sslBaseExpression[52]
		elseIf size == 53
			return new sslBaseExpression[53]
		elseIf size == 54
			return new sslBaseExpression[54]
		else
			return new sslBaseExpression[55]
		endif
	elseIf size < 64
		if size == 56
			return new sslBaseExpression[56]
		elseIf size == 57
			return new sslBaseExpression[57]
		elseIf size == 58
			return new sslBaseExpression[58]
		elseIf size == 59
			return new sslBaseExpression[59]
		elseIf size == 60
			return new sslBaseExpression[60]
		elseIf size == 61
			return new sslBaseExpression[61]
		elseIf size == 62
			return new sslBaseExpression[62]
		else
			return new sslBaseExpression[63]
		endIf
	elseIf size < 72
		if size == 64
			return new sslBaseExpression[64]
		elseIf size == 65
			return new sslBaseExpression[65]
		elseIf size == 66
			return new sslBaseExpression[66]
		elseIf size == 67
			return new sslBaseExpression[67]
		elseIf size == 68
			return new sslBaseExpression[68]
		elseIf size == 69
			return new sslBaseExpression[69]
		elseIf size == 70
			return new sslBaseExpression[70]
		else
			return new sslBaseExpression[71]
		endif
	elseIf size < 80
		if size == 72
			return new sslBaseExpression[72]
		elseIf size == 73
			return new sslBaseExpression[73]
		elseIf size == 74
			return new sslBaseExpression[74]
		elseIf size == 75
			return new sslBaseExpression[75]
		elseIf size == 76
			return new sslBaseExpression[76]
		elseIf size == 77
			return new sslBaseExpression[77]
		elseIf size == 78
			return new sslBaseExpression[78]
		else
			return new sslBaseExpression[79]
		endIf
	elseIf size < 88
		if size == 80
			return new sslBaseExpression[80]
		elseIf size == 81
			return new sslBaseExpression[81]
		elseIf size == 82
			return new sslBaseExpression[82]
		elseIf size == 83
			return new sslBaseExpression[83]
		elseIf size == 84
			return new sslBaseExpression[84]
		elseIf size == 85
			return new sslBaseExpression[85]
		elseIf size == 86
			return new sslBaseExpression[86]
		else
			return new sslBaseExpression[87]
		endif
	elseIf size < 96
		if size == 88
			return new sslBaseExpression[88]
		elseIf size == 89
			return new sslBaseExpression[89]
		elseIf size == 90
			return new sslBaseExpression[90]
		elseIf size == 91
			return new sslBaseExpression[91]
		elseIf size == 92
			return new sslBaseExpression[92]
		elseIf size == 93
			return new sslBaseExpression[93]
		elseIf size == 94
			return new sslBaseExpression[94]
		else
			return new sslBaseExpression[95]
		endIf
	elseIf size < 104
		if size == 96
			return new sslBaseExpression[96]
		elseIf size == 97
			return new sslBaseExpression[97]
		elseIf size == 98
			return new sslBaseExpression[98]
		elseIf size == 99
			return new sslBaseExpression[99]
		elseIf size == 100
			return new sslBaseExpression[100]
		elseIf size == 101
			return new sslBaseExpression[101]
		elseIf size == 102
			return new sslBaseExpression[102]
		else
			return new sslBaseExpression[103]
		endif
	elseIf size < 112
		if size == 104
			return new sslBaseExpression[104]
		elseIf size == 105
			return new sslBaseExpression[105]
		elseIf size == 106
			return new sslBaseExpression[106]
		elseIf size == 107
			return new sslBaseExpression[107]
		elseIf size == 108
			return new sslBaseExpression[108]
		elseIf size == 109
			return new sslBaseExpression[109]
		elseIf size == 110
			return new sslBaseExpression[110]
		else
			return new sslBaseExpression[111]
		endif
	elseIf size < 120
		if size == 112
			return new sslBaseExpression[112]
		elseIf size == 113
			return new sslBaseExpression[113]
		elseIf size == 114
			return new sslBaseExpression[114]
		elseIf size == 115
			return new sslBaseExpression[115]
		elseIf size == 116
			return new sslBaseExpression[116]
		elseIf size == 117
			return new sslBaseExpression[117]
		elseIf size == 118
			return new sslBaseExpression[118]
		else
			return new sslBaseExpression[119]
		endif
	else
		if size == 120
			return new sslBaseExpression[120]
		elseIf size == 121
			return new sslBaseExpression[121]
		elseIf size == 122
			return new sslBaseExpression[122]
		elseIf size == 123
			return new sslBaseExpression[123]
		elseIf size == 124
			return new sslBaseExpression[124]
		elseIf size == 125
			return new sslBaseExpression[125]
		elseIf size == 126
			return new sslBaseExpression[126]
		elseIf size == 127
			return new sslBaseExpression[127]
		else
			return new sslBaseExpression[128]
		endIf
	endIf
endFunction
form[] function FormArray(int size) global
	if size < 8
		if size == 0
			form[] Empty
			return Empty
		elseIf size == 1
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
		else
			return new form[7]
		endIf
	elseIf size < 16
		if size == 8
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
		else
			return new form[15]
		endIf
	elseIf size < 24
		if size == 16
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
		else
			return new form[23]
		endIf
	elseIf size < 32
		if size == 24
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
		else
			return new form[31]
		endIf
	elseIf size < 40
		if size == 32
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
		else
			return new form[39]
		endIf
	elseIf size < 48
		if size == 40
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
		else
			return new form[47]
		endIf
	elseIf size < 56
		if size == 48
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
		else
			return new form[55]
		endif
	elseIf size < 64
		if size == 56
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
		else
			return new form[63]
		endIf
	elseIf size < 72
		if size == 64
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
		else
			return new form[71]
		endif
	elseIf size < 80
		if size == 72
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
		else
			return new form[79]
		endIf
	elseIf size < 88
		if size == 80
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
		else
			return new form[87]
		endif
	elseIf size < 96
		if size == 88
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
		else
			return new form[95]
		endIf
	elseIf size < 104
		if size == 96
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
		else
			return new form[103]
		endif
	elseIf size < 112
		if size == 104
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
		else
			return new form[111]
		endif
	elseIf size < 120
		if size == 112
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
		else
			return new form[119]
		endif
	else
		if size == 120
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
		else
			return new form[128]
		endIf
	endIf
endFunction
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
