scriptname PapyrusUtil Hidden

; Get version of papyrus library. For version 2.8 will be returned 28.
int function GetVersion() global native

; function _SetFormValue(Form[] Array, int index, Form value) global native
; function _SetAliasValue(Alias[] Array, int index, Alias value) global native
; function _SetIntValue(int[] Array, int index, int value) global native

; ##
; ## Array manipulation utilities
; ##

Actor[] function ActorArray(int size, Actor filler = none) global native
; ObjectReference[] function ObjectRefArray(int size, ObjectReference filler = none) global native

float[] function ResizeFloatArray(float[] ArrayValues, int toSize, float filler = 0.0) global native
int[] function ResizeIntArray(int[] ArrayValues, int toSize, int filler = 0) global native
bool[] function ResizeBoolArray(bool[] ArrayValues, int toSize, bool filler = false) global
	bool[] Output = Utility.CreateBoolArray(toSize, filler)
	int i = ArrayValues.Length
	if i > toSize
		i = toSize
	endIf
	while i
		i -= 1
		Output[i] = ArrayValues[i]
	endWhile
	return Output
endFunction
string[] function ResizeStringArray(string[] ArrayValues, int toSize, string filler = "") global native
Form[] function ResizeFormArray(Form[] ArrayValues, int toSize, Form filler = none) global native
Alias[] function ResizeAliasArray(Alias[] ArrayValues, int toSize, Alias filler = none) global native
Actor[] function ResizeActorArray(Actor[] ArrayValues, int toSize, Actor filler = none) global native
; ObjectReference[] function ResizeObjectRefArray(ObjectReference[] ArrayValues, int toSize, ObjectReference filler = none) global native

float[] function PushFloat(float[] ArrayValues, float push) global native
int[] function PushInt(int[] ArrayValues, int push) global native
bool[] function PushBool(bool[] ArrayValues, bool push) global
	return ResizeBoolArray(ArrayValues, ArrayValues.Length + 1, push)
endFunction
string[] function PushString(string[] ArrayValues, string push) global native
Form[] function PushForm(Form[] ArrayValues, Form push) global native
Alias[] function PushAlias(Alias[] ArrayValues, Alias push) global native
Actor[] function PushActor(Actor[] ArrayValues, Actor push) global native
; ObjectReference[] function PushObjectRef(ObjectReference[] ArrayValues, ObjectReference push) global native

float[] function RemoveFloat(float[] ArrayValues, float ToRemove) global native
int[] function RemoveInt(int[] ArrayValues, int ToRemove) global native
bool[] function RemoveBool(bool[] ArrayValues, bool ToRemove) global native
string[] function RemoveString(string[] ArrayValues, string ToRemove) global native
Form[] function RemoveForm(Form[] ArrayValues, Form ToRemove) global native
Alias[] function RemoveAlias(Alias[] ArrayValues, Alias ToRemove) global native
Actor[] function RemoveActor(Actor[] ArrayValues, Actor ToRemove) global native
; ObjectReference[] function RemoveObjectRef(ObjectReference[] ArrayValues, ObjectReference ToRemove) global native

int function CountFloat(float[] ArrayValues, float EqualTo) global native
int function CountInt(int[] ArrayValues, int EqualTo) global native
int function CountBool(bool[] ArrayValues, bool EqualTo) global native
int function CountString(string[] ArrayValues, string EqualTo) global native
int function CountForm(Form[] ArrayValues, Form EqualTo) global native
int function CountAlias(Alias[] ArrayValues, Alias EqualTo) global native
int function CountActor(Actor[] ArrayValues, Actor EqualTo) global native
; int function CountObjectRef(ObjectReference[] ArrayValues, ObjectReference EqualTo) global native

float[] function MergeFloatArray(float[] ArrayValues1, float[] ArrayValues2, bool RemoveDupes = false) global native
int[] function MergeIntArray(int[] ArrayValues1, int[] ArrayValues2, bool RemoveDupes = false) global native
bool[] function MergeBoolArray(bool[] ArrayValues1, bool[] ArrayValues2, bool RemoveDupes = false) global native
string[] function MergeStringArray(string[] ArrayValues1, string[] ArrayValues2, bool RemoveDupes = false) global native
Form[] function MergeFormArray(Form[] ArrayValues1, Form[] ArrayValues2, bool RemoveDupes = false) global native
Alias[] function MergeAliasArray(Alias[] ArrayValues1, Alias[] ArrayValues2, bool RemoveDupes = false) global native
Actor[] function MergeActorArray(Actor[] ArrayValues1, Actor[] ArrayValues2, bool RemoveDupes = false) global native
; ObjectReference[] function MergeObjectRefArray(ObjectReference[] ArrayValues1, ObjectReference[] ArrayValues2, bool RemoveDupes = false) global native

float[] function SliceFloatArray(float[] ArrayValues, int StartIndex, int EndIndex = -1) global native
int[] function SliceIntArray(int[] ArrayValues, int StartIndex, int EndIndex = -1) global native
bool[] function SliceBoolArray(bool[] ArrayValues, int StartIndex, int EndIndex = -1) global native
string[] function SliceStringArray(string[] ArrayValues, int StartIndex, int EndIndex = -1) global native
Form[] function SliceFormArray(Form[] ArrayValues, int StartIndex, int EndIndex = -1) global native
Alias[] function SliceAliasArray(Alias[] ArrayValues, int StartIndex, int EndIndex = -1) global native
Actor[] function SliceActorArray(Actor[] ArrayValues, int StartIndex, int EndIndex = -1) global native
; ObjectReference[] function SliceObjectRefArray(ObjectReference[] ArrayValues, int StartIndex, int EndIndex = -1) global native

string[] function StringSplit(string ArgString, string Delimiter = ",") global native
string function StringJoin(string[] Values, string Delimiter = ",") global native

float function AddFloatValues(float[] Values) global native
int function AddIntValues(int[] Values) global native

float function WrapFloat(float value, float end, float start = 0.0) global native
int function WrapInt(int value, int end, int start = 0) global native

float function SignFloat(bool doSign, float value) global native
int function SignInt(bool doSign, int value) global native

float function ClampFloat(float value, float min, float max) global native
int function ClampInt(int value, int min, int max) global native

; ##
; ## Shortcuts for common usage
; ##

string[] function ClearEmpty(string[] ArrayValues) global
	return RemoveString(ArrayValues, "")
endFunction
Form[] function ClearNone(Form[] ArrayValues) global
	return RemoveForm(ArrayValues, none)
endFunction

int function CountFalse(bool[] ArrayValues) global
	return CountBool(ArrayValues, false)
endFunction
int function CountTrue(bool[] ArrayValues) global
	return CountBool(ArrayValues, true)
endFunction
int function CountNone(Form[] ArrayValues) global
	return CountForm(ArrayValues, none)
endFunction


; ##
; ## DEPRECATED: SKSE now provides their own variable sized arrays for these types.
; ##

float[] function FloatArray(int size, float filler = 0.0) global
	return Utility.CreateFloatArray(size, filler)
endFunction
int[] function IntArray(int size, int filler = 0) global
	return Utility.CreateIntArray(size, filler)
endFunction
bool[] function BoolArray(int size, bool filler = false) global
	return Utility.CreateBoolArray(size, filler)
endFunction
string[] function StringArray(int size, string filler = "") global
	return Utility.CreateStringArray(size, filler)
endFunction
Form[] function FormArray(int size, Form filler = none) global
	return Utility.CreateFormArray(size, filler)
endFunction
Alias[] function AliasArray(int size, Alias filler = none) global
	return Utility.CreateAliasArray(size, filler)
endFunction
