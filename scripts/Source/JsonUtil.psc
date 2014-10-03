scriptname JsonUtil Hidden


;/
	MOD AUTHORS, READ!

	These functions all work in exactly the same way as their StorageUtil.psc equivalents. See them for usage docs.

	The important difference between these functions and the ones on StorageUtil.psc, is that instead of giving "Form obj"
	argument for the location to save the data, you give it a "string FileName" argument, pointing to an external JSON formatted file.

	These files will be saved/loaded in JSON format, and the starting location for the files to save/load from is as follows:

		data/skse/plugins/StorageUtilData/


	Some important notes on usage to keep in mind:

	- You may specific a folder path in the filename, i.e. "../MyData/config" will save to data/skse/plugins/MyData/config.json

	- If not given in the filename argument, the filename will have the extension .json appended to it automatically when used.

	- You do not need to call Load() or Save() manually unless you have a specific need to.

	- When the player saves their game any modified file will be automatically saved, written to, or created if it does not exist.

	- When the player loads another save without saving themselves or the Save() function having been manually called by a script,
	  the loaded data will be discarded and revert back to whatever the contents of the current saved file are.

/;


bool function Load(string FileName) global native
bool function Save(string FileName, bool minify = false) global native
function ClearAll(string FileName) global native


; See StorageUtil.psc for equivalent function usage instructions

int function SetIntValue(string FileName, string key, int value) global native
int function GetIntValue(string FileName, string key, int missing = 0) global native
int function AdjustIntValue(string FileName, string key, int amount) global native
bool function UnsetIntValue(string FileName, string key) global native
bool function HasIntValue(string FileName, string key) global native

float function SetFloatValue(string FileName, string key, float value) global native
float function GetFloatValue(string FileName, string key, float missing = 0.0) global native
float function AdjustFloatValue(string FileName, string key, float amount) global native
bool function UnsetFloatValue(string FileName, string key) global native
bool function HasFloatValue(string FileName, string key) global native

string function SetStringValue(string FileName, string key, string value) global native
string function GetStringValue(string FileName, string key, string missing = "") global native
bool function UnsetStringValue(string FileName, string key) global native
bool function HasStringValue(string FileName, string key) global native

form function SetFormValue(string FileName, string key, form value) global native
form function GetFormValue(string FileName, string key, form missing = none) global native
bool function UnsetFormValue(string FileName, string key) global native
bool function HasFormValue(string FileName, string key) global native

int function IntListAdd(string FileName, string key, Int value, bool allowDuplicate = true) global native
Int function IntListGet(string FileName, string key, int index) global native
Int function IntListSet(string FileName, string key, int index, Int value) global native
Int function IntListAdjust(string FileName, string key, int index, Int amount) global native
int function IntListRemove(string FileName, string key, Int value, bool allInstances = true) global native
bool function IntListInsertAt(string FileName, string key, int index, Int value) global native
bool function IntListRemoveAt(string FileName, string key, int index) global native
int function IntListClear(string FileName, string key) global native
int function IntListCount(string FileName, string key) global native
int function IntListFind(string FileName, string key, Int value) global native
bool function IntListHas(string FileName, string key, Int value) global native

int function FloatListAdd(string FileName, string key, Float value, bool allowDuplicate = true) global native
Float function FloatListGet(string FileName, string key, int index) global native
Float function FloatListSet(string FileName, string key, int index, Float value) global native
float function FloatListAdjust(string FileName, string key, int index, float amount) global native
int function FloatListRemove(string FileName, string key, Float value, bool allInstances = true) global native
bool function FloatListInsertAt(string FileName, string key, int index, Float value) global native
bool function FloatListRemoveAt(string FileName, string key, int index) global native
int function FloatListClear(string FileName, string key) global native
int function FloatListCount(string FileName, string key) global native
int function FloatListFind(string FileName, string key, Float value) global native
bool function FloatListHas(string FileName, string key, Float value) global native

int function StringListAdd(string FileName, string key, String value, bool allowDuplicate = true) global native
String function StringListGet(string FileName, string key, int index) global native
String function StringListSet(string FileName, string key, int index, String value) global native
int function StringListRemove(string FileName, string key, String value, bool allInstances = true) global native
bool function StringListInsertAt(string FileName, string key, int index, String value) global native
bool function StringListRemoveAt(string FileName, string key, int index) global native
int function StringListClear(string FileName, string key) global native
int function StringListCount(string FileName, string key) global native
int function StringListFind(string FileName, string key, String value) global native
bool function StringListHas(string FileName, string key, String value) global native

int function FormListAdd(string FileName, string key, Form value, bool allowDuplicate = true) global native
Form function FormListGet(string FileName, string key, int index) global native
Form function FormListSet(string FileName, string key, int index, Form value) global native
int function FormListRemove(string FileName, string key, Form value, bool allInstances = true) global native
bool function FormListInsertAt(string FileName, string key, int index, Form value) global native
bool function FormListRemoveAt(string FileName, string key, int index) global native
int function FormListClear(string FileName, string key) global native
int function FormListCount(string FileName, string key) global native
int function FormListFind(string FileName, string key, Form value) global native
bool function FormListHas(string FileName, string key, Form value) global native

function IntListSlice(string FileName, string key, int[] slice, int startIndex = 0) global native
function FloatListSlice(string FileName, string key, float[] slice, int startIndex = 0) global native
function StringListSlice(string FileName, string key, string[] slice, int startIndex = 0) global native
function FormListSlice(string FileName, string key, Form[] slice, int startIndex = 0) global native

int function IntListResize(string FileName, string key, int toLength, int filler = 0) global native
int function FloatListResize(string FileName, string key, int toLength, float filler = 0.0) global native
int function StringListResize(string FileName, string key, int toLength, string filler = "") global native
int function FormListResize(string FileName, string key, int toLength, Form filler = none) global native

bool function IntListCopy(string FileName, string key, int[] copy) global native
bool function FloatListCopy(string FileName, string key, float[] copy) global native
bool function StringListCopy(string FileName, string key, string[] copy) global native
bool function FormListCopy(string FileName, string key, Form[] copy) global native
