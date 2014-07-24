scriptname JsonUtil Hidden

bool function Load(string FileName) global native
bool function Save(string FileName, bool StyledWrite = false) global native

int function SetInt(string FileName, string skey, int value) global native
int function GetInt(string FileName, string skey, int missing = 0) global native
bool function UnsetInt(string FileName, string skey) global native
bool function HasInt(string FileName, string skey) global native

float function SetFloat(string FileName, string skey, float value) global native
float function GetFloat(string FileName, string skey, float missing = 0.0) global native
bool function UnsetFloat(string FileName, string skey) global native
bool function HasFloat(string FileName, string skey) global native

string function SetString(string FileName, string skey, string value) global native
string function GetString(string FileName, string skey, string missing = "") global native
bool function UnsetString(string FileName, string skey) global native
bool function HasString(string FileName, string skey) global native

form function SetForm(string FileName, string skey, form value) global native
form function GetForm(string FileName, string skey, form missing = none) global native
bool function UnsetForm(string FileName, string skey) global native
bool function HasForm(string FileName, string skey) global native

int function IntListAdd(string FileName, string skey, Int value, bool allowDuplicate = true) global native
Int function IntListGet(string FileName, string skey, int index) global native
Int function IntListSet(string FileName, string skey, int index, Int value) global native
int function IntListRemove(string FileName, string skey, Int value, bool allInstances = true) global native
bool function IntListInsertAt(string FileName, string skey, int index, Int value) global native
bool function IntListRemoveAt(string FileName, string skey, int index) global native
int function IntListClear(string FileName, string skey) global native
int function IntListCount(string FileName, string skey) global native
int function IntListFind(string FileName, string skey, Int value) global native
bool function IntListHas(string FileName, string skey, Int value) global native

int function FloatListAdd(string FileName, string skey, Float value, bool allowDuplicate = true) global native
Float function FloatListGet(string FileName, string skey, int index) global native
Float function FloatListSet(string FileName, string skey, int index, Float value) global native
int function FloatListRemove(string FileName, string skey, Float value, bool allInstances = true) global native
bool function FloatListInsertAt(string FileName, string skey, int index, Float value) global native
bool function FloatListRemoveAt(string FileName, string skey, int index) global native
int function FloatListClear(string FileName, string skey) global native
int function FloatListCount(string FileName, string skey) global native
int function FloatListFind(string FileName, string skey, Float value) global native
bool function FloatListHas(string FileName, string skey, Float value) global native

int function StringListAdd(string FileName, string skey, String value, bool allowDuplicate = true) global native
String function StringListGet(string FileName, string skey, int index) global native
String function StringListSet(string FileName, string skey, int index, String value) global native
int function StringListRemove(string FileName, string skey, String value, bool allInstances = true) global native
bool function StringListInsertAt(string FileName, string skey, int index, String value) global native
bool function StringListRemoveAt(string FileName, string skey, int index) global native
int function StringListClear(string FileName, string skey) global native
int function StringListCount(string FileName, string skey) global native
int function StringListFind(string FileName, string skey, String value) global native
bool function StringListHas(string FileName, string skey, String value) global native

int function FormListAdd(string FileName, string skey, Form value, bool allowDuplicate = true) global native
Form function FormListGet(string FileName, string skey, int index) global native
Form function FormListSet(string FileName, string skey, int index, Form value) global native
int function FormListRemove(string FileName, string skey, Form value, bool allInstances = true) global native
bool function FormListInsertAt(string FileName, string skey, int index, Form value) global native
bool function FormListRemoveAt(string FileName, string skey, int index) global native
int function FormListClear(string FileName, string skey) global native
int function FormListCount(string FileName, string skey) global native
int function FormListFind(string FileName, string skey, Form value) global native
bool function FormListHas(string FileName, string skey, Form value) global native
