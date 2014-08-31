scriptname StorageUtil Hidden

;/
	MOD AUTHORS, READ!

	This script contains functions for saving and loading any amount of int, float, form and string values
	by name on a form or globally. These values can be accessed and changed from any mod which allows
	mods to become compatible with each other without adding any requirements to the other mod or its version
	other than this plugin.

	Values will stay on forms or globally until they are Unset or Cleared in case of lists. If value
	is set on a form and the object is deleted then value will be removed when saving game.
	If you are done with using a certain variable you should use Unset or Clear function to remove them
	but it is not required.

	Saving MCM config values here would allow other mods to change your mod settings which may
	be useful. It should also allow you to change MCM config script without worrying about versioning
	since there are no new variables in the script itself.

	Functions that start with File in the name will save values to a separate file, so that you can
	access the same values from all savegames. This may be useful for configuration settings.

	Saved values take very little memory - expect to use less than 500 KB of physical memory even when
	setting thousands of values.

	Value names are not case sensitive, that means GetIntValue(none, "abc") == GetIntValue(none, "aBC").

	All values are separated from each other by type! That means SetIntValue(none, "abc", 1) and
	SetFloatValue(none, "abc", 2.0) create separate entries and aren't affected by each other.
	StorageUtil.SetIntValue(none, "myValue", 1)
	StorageUtil.SetFloatValue(none, "myValue", 5.0)
	int value = StorageUtil.GetIntValue(none, "myValue")
	value == 1 ; true
	value == 5 ; false

	When choosing names for variables try to remember that all mods access the same storage, so if you
	create a variable with name "Name" then many other mods could use the same variable but in different
	ways that lead to unwanted behavior. It is recommended to prefix the variable with your mod name,
	that way you can be sure nobody else will try to use the same variable in their mod. For example
	realistic needs and diseases might set hunger as "rnd_hungervalue".

	You can also use this storage to make your mod functions available to other mods, for example if
	your mod has a function that sets an Actor to be invisible you could add a script that checks:
	int i = StorageUtil.FormListCount(none, "MakeInvisible")
	while(i > 0)
		i--
		Actor make = StorageUtil.FormListGet(none, "MakeInvisible", i) as Actor
		if(make)
			MyScriptFunction(make)
		endif
		StorageUtil.FormListRemoveAt(none, "MakeInvisible", i)
	endwhile
	And the other mod could write:
	StorageUtil.FormListAdd(none, "MakeInvisible", myActor)
	to make someone invisible using your mod. But if your mod isn't present then nothing happens.
	This is just an example, I'm sure you can find better ways to implement compatibility, it would
	help to include a documentation for other modders if you do.
;/





;/
	Storage functions - values in save game file.
/;


;/ Set int/float/string/Form value globally or on any form by name and return
   previous value.

   obj: form to save on. Set none to save globally.
   key: name of value.
   value: value itself.
/;
int function SetIntValue(Form obj, string key, int value) global native
float function SetFloatValue(Form obj, string key, float value) global native
string function SetStringValue(Form obj, string key, string value) global native
Form function SetFormValue(Form obj, string key, Form value) global native


;/ Remove a previously set int/float/string/Form value on an form or globally and
   return if successful. This will return false if value didn't exist.

   obj: form to remove from. Set none to remove global value.
   key: name of value.
/;
bool function UnsetIntValue(Form obj, string key) global native;
bool function UnsetFloatValue(Form obj, string key) global native
bool function UnsetStringValue(Form obj, string key) global native
bool function UnsetFormValue(Form obj, string key) global native


;/ Check if int/float/string/Form value has been set on form or globally.

   obj: form to check on. Set none to check global value.
   key: name of value.
/;
bool function HasIntValue(Form obj, string key) global native
bool function HasFloatValue(Form obj, string key) global native
bool function HasStringValue(Form obj, string key) global native
bool function HasFormValue(Form obj, string key) global native


;/ Get previously saved int/float/string/Form value on form or globally.

   obj: form to get from. Set none to get global value.
   key: name of value.
   [optional] missing: if value has not been set, return this value instead.
/;
int function GetIntValue(Form obj, string key, int missing = 0) global native
float function GetFloatValue(Form obj, string key, float missing = 0.0) global native
string function GetStringValue(Form obj, string key, string missing = "") global native
Form function GetFormValue(Form obj, string key, Form missing = none) global native

;/ Get previously saved int/float/string/Form value on form or globally.

   obj: form to get from. Set none to get global value.
   key: name of value.
   amount: +/- the amount to adjust the current value by

   given keys will be initialized to given amount if it does not exist
/;
int function AdjustIntValue(Form obj, string key, int amount) global native
float function AdjustFloatValue(Form obj, string key, float amount) global native


;/ Add an int/float/string/Form to a list on form or globally and return
   the value's new index. Index can be -1 if we were unable to add
   the value.

   obj: form to add to. Set none to add global value.
   key: name of value.
   value: value to add.
   [optional] allowDuplicate: allow adding value to list if this value already exists in the list.
/;
int function IntListAdd(Form obj, string key, int value, bool allowDuplicate = true) global native
int function FloatListAdd(Form obj, string key, float value, bool allowDuplicate = true) global native
int function StringListAdd(Form obj, string key, string value, bool allowDuplicate = true) global native
int function FormListAdd(Form obj, string key, Form value, bool allowDuplicate = true) global native

;/ Get a value from list by index on form or globally.
   This will return 0 as value if there was a problem.

   obj: form to get value on. Set none to get global list value.
   key: name of list.
   index: index of value in the list.
/;
int function IntListGet(Form obj, string key, int index) global native
float function FloatListGet(Form obj, string key, int index) global native
string function StringListGet(Form obj, string key, int index) global native
Form function FormListGet(Form obj, string key, int index) global native

;/ Set a value in list by index on form or globally.
   This will return the previous value or 0 if there was a problem.

   obj: form to set value on. Set none to set global list value.
   key: name of list.
   index: index of value in the list.
   value: value to set to.
/;
int function IntListSet(Form obj, string key, int index, int value) global native
float function FloatListSet(Form obj, string key, int index, float value) global native
string function StringListSet(Form obj, string key, int index, string value) global native
Form function FormListSet(Form obj, string key, int index, Form value) global native

;/ Adjust the existing value of a list by the given amount.

   obj: form to set value on. Set none to set global list value.
   key: name of list.
   index: index of value in the list.
   amount: +/- the amount to adjust the lists current index value by.

   returns 0 if index does not exists
/;
int function IntListAdjust(Form obj, string key, int index, int amount) global native
float function FloatListAdjust(Form obj, string key, int index, float amount) global native

;/ Insert an int/float/string/Form to a list on form or globally and return
   if successful.

   obj: form to add to. Set none to add global value.
   key: name of value.
   index: position in list to put the value. 0 is first entry in list.
   value: value to add.
/;
bool function IntListInsert(Form obj, string key, int index, int value) global native
bool function FloatListInsert(Form obj, string key, int index, float value) global native
bool function StringListInsert(Form obj, string key, int index, string value) global native
bool function FormListInsert(Form obj, string key, int index, Form value) global native


;/ Remove a previously added int/float/string/Form value from a list on form
   or globally and return how many instances of this value were removed.

   obj: form to remove from. Set none to remove global value.
   key: name of value.
   value: value to remove.
   [optional] allowInstances: remove all instances of this value in a list.
/;
int function IntListRemove(Form obj, string key, int value, bool allInstances = false) global native
int function FloatListRemove(Form obj, string key, float value, bool allInstances = false) global native
int function StringListRemove(Form obj, string key, string value, bool allInstances = false) global native
int function FormListRemove(Form obj, string key, Form value, bool allInstances = false) global native


;/ Clear a list of values (unset) on an form or globally and
   return the previous size of list.

   obj: form to clear on. Set none to clear global list.
   key: name of list.
/;
int function IntListClear(Form obj, string key) global native
int function FloatListClear(Form obj, string key) global native
int function StringListClear(Form obj, string key) global native
int function FormListClear(Form obj, string key) global native

;/ Remove a value from list by index on form or globally and
   return if we were successful in doing so.

   obj: form to remove from. Set none to remove global value.
   key: name of list.
   index: index of value in the list.
/;
bool function IntListRemoveAt(Form obj, string key, int index) global native
bool function FloatListRemoveAt(Form obj, string key, int index) global native
bool function StringListRemoveAt(Form obj, string key, int index) global native
bool function FormListRemoveAt(Form obj, string key, int index) global native

;/ Get size of a list on form or globally.

   obj: form to check on. Set none to check global list.
   key: name of list.
/;
int function IntListCount(Form obj, string key) global native
int function FloatListCount(Form obj, string key) global native
int function StringListCount(Form obj, string key) global native
int function FormListCount(Form obj, string key) global native

;/ Find a value in list on form or globally and return its
   index or -1 if value was not found.

   obj: form to find value on. Set none to find global list value.
   key: name of list.
   value: value to search.
/;
int function IntListFind(Form obj, string key, int value) global native
int function FloatListFind(Form obj, string key, float value) global native
int function StringListFind(Form obj, string key, string value) global native
int function FormListFind(Form obj, string key, Form value) global native

;/ Find if a value in list on form or globally exists, true if it exists,
   false if it doesn't.

   obj: form to find value on. Set none to find global list value.
   key: name of list.
   value: value to search.
/;
bool function IntListHas(Form obj, string key, int value) global native
bool function FloatListHas(Form obj, string key, float value) global native
bool function StringListHas(Form obj, string key, string value) global native
bool function FormListHas(Form obj, string key, Form value) global native

;/ Sort an int/float/string/Form list by values in ascending order.

   obj: form to sort on. Set none for global value.
   key: name of value.
/;
function IntListSort(Form obj, string key) global native
function FloatListSort(Form obj, string key) global native
function StringListSort(Form obj, string key) global native
function FormListSort(Form obj, string key) global native


;/ Fills the given input array with the values of the list on form or globally,
   will fill the array until either the array or list runs out of valid indexes

   obj: form to find value on. Set none to find global list value.
   key: name of list.
   slice[]: an initialized array set to the slice size you want, i.e. int[] slice = new int[10]
   [optional] startIndex: the starting list index you want to start filling your slice array with
/;
function IntListSlice(Form obj, string key, int[] slice, int startIndex = 0) global native
function FloatListSlice(Form obj, string key, float[] slice, int startIndex = 0) global native
function StringListSlice(Form obj, string key, string[] slice, int startIndex = 0) global native
function FormListSlice(Form obj, string key, Form[] slice, int startIndex = 0) global native


;/ Sizes the given list to a set number of elements. If the list exists already it will be truncated
   when given fewer elements, or resized to the appropiate length with the filler argument being used as
   the default values

   Returns the number of elements truncated (signed) or added (unsigned) onto the list.

   obj: form to find value on. Set none to find global list value.
   key: name of list.
   toLength: The size you want to change the list to. Max length when using this function is 500.
   [optional] filler: When adding empty elements to the list this will be used as the default value
/;
int function IntListResize(Form obj, string key, int toLength, int filler = 0) global native
int function FloatListResize(Form obj, string key, int toLength, float filler = 0.0) global native
int function StringListResize(Form obj, string key, int toLength, string filler = "") global native
int function FormListResize(Form obj, string key, int toLength, Form filler = none) global native

;/ Creates a copy of array on the given storage list at the given object+key,
   overwriting any list that might already exists.

   Returns true on success.

   obj: form to find value on. Set none to find global list value.
   key: name of list.
   copy[]: The papyrus array with the content you wish to copy over into StorageUtil
   [optional] filler: When adding empty elements to the list this will be used as the default value
/;
bool function IntListCopy(Form obj, string key, int[] copy) global native
bool function FloatListCopy(Form obj, string key, float[] copy) global native
bool function StringListCopy(Form obj, string key, string[] copy) global native
bool function FormListCopy(Form obj, string key, Form[] copy) global native

;/
	Storage functions - separate file. These are shared in all save games. Values are loaded and saved
	when savegame is loaded or saved.
/;


;/ Set int value globally by name and return previous value.

   key: name of value.
   value: value itself.
/;
int function FileSetIntValue(string key, int value) global native
float function FileSetFloatValue(string key, float value) global native
string function FileSetStringValue(string key, string value) global native
form function FileSetFormValue(string key, Form value) global native

;/ Adjust any value at key by the given amount.

   key: name of value.
   amount: +/- the amount to adjust the current value by

   given keys will be initialized to given amount if it does not exist
/;
int function FileAdjustIntValue(string key, int amount) global native
float function FileAdjustFloatValue(string key, float amount) global native

;/ Remove a previously set int value globally and return if successful. This
   will return false if value didn't exist.

   key: name of value.
/;
bool function FileUnsetIntValue(string key) global native
bool function FileUnsetFloatValue(string key) global native
bool function FileUnsetStringValue(string key) global native
bool function FileUnsetFormValue(string key) global native


;/ Check if value has been set globally.

   key: name of value.
/;
bool function FileHasIntValue(string key) global native
bool function FileHasFloatValue(string key) global native
bool function FileHasStringValue(string key) global native
bool function FileHasFormValue(string key) global native


;/ Get previously saved int value globally.

   key: name of value.
   [optional] missing: if value has not been set, return this value instead.
/;
int function FileGetIntValue(string key, int missing = 0) global native
float function FileGetFloatValue(string key, float missing = 0.0) global native
string function FileGetStringValue(string key, string missing = "") global native
Form function FileGetFormValue(string key, Form missing = none) global native


;/ Add an int to a list globally and return the value's new index. Index can be
   -1 if we were unable to add the value.

   key: name of value.
   value: value to add.
   [optional] allowDuplicate: allow adding value to list if this value
                              already exists in the list.
/;
int function FileIntListAdd(string key, int value, bool allowDuplicate = true) global native
int function FileFloatListAdd(string key, float value, bool allowDuplicate = true) global native
int function FileStringListAdd(string key, string value, bool allowDuplicate = true) global native
int function FileFormListAdd(string key, Form value, bool allowDuplicate = true) global native

;/ Adjust the existing index value of a list by the given amount.

   key: name of list.
   index: index of value in the list.
   amount: +/- the amount to adjust the lists current index value by.

   returns 0 if index does not exists
/;
int function FileIntListAdjust(string key, int index, int amount) global native
float function FileFloatListAdjust(string key, int index, float amount) global native

;/ Remove a previously added value from a list globally and return how many
   instances of this value were removed.

   key: name of value.
   value: value to remove.
   [optional] allowInstances: remove all instances of this value in a list.
/;
int function FileIntListRemove(string key, int value, bool allInstances = false) global native
int function FileFloatListRemove(string key, float value, bool allInstances = false) global native
int function FileStringListRemove(string key, string value, bool allInstances = false) global native
int function FileFormListRemove(string key, Form value, bool allInstances = false) global native


;/ Get a value from list by index globally. This will return 0
   as value if there was a problem.

   key: name of list.
   index: index of value in the list.
/;
int function FileIntListGet(string key, int index) global native
float function FileFloatListGet(string key, int index) global native
string function FileStringListGet(string key, int index) global native
Form function FileFormListGet(string key, int index) global native


;/ Set a value in list by index globally. This will return the previous
   value or 0 if there was a problem.

   key: name of list.
   index: index of value in the list.
   value: value to set to.
/;
int function FileIntListSet(string key, int index, int value) global native
float function FileFloatListSet(string key, int index, float value) global native
string function FileStringListSet(string key, int index, string value) global native
Form function FileFormListSet(string key, int index, Form value) global native

;/ Clear a list of values (unset) globally and return the previous size of list.

   key: name of list.
/;
int function FileIntListClear(string key) global native
int function FileFloatListClear(string key) global native
int function FileStringListClear(string key) global native
int function FileFormListClear(string key) global native


;/ Remove a value from list by index globally and return if we were successful
   in doing so.

   key: name of list.
   index: index of value in the list.
/;
bool function FileIntListRemoveAt(string key, int index) global native
bool function FileFloatListRemoveAt(string key, int index) global native
bool function FileStringListRemoveAt(string key, int index) global native
bool function FileFormListRemoveAt(string key, int index) global native


;/ Insert an int/float/string/Form to a list globally and return
   if successful.

   key: name of value.
   index: position in list to put the value. 0 is first entry in list.
   value: value to add.
/;
bool function FileIntListInsert(string key, int index, int value) global native
bool function FileFloatListInsert(string key, int index, float value) global native
bool function FileStringListInsert(string key, int index, string value) global native
bool function FileFormListInsert(string key, int index, Form value) global native


;/ Get size of a list globally.

   key: name of list.
/;
int function FileIntListCount(string key) global native
int function FileFloatListCount(string key) global native
int function FileStringListCount(string key) global native
int function FileFormListCount(string key) global native


;/ Find a value in list globally and return its index or -1 if value was not found.

   key: name of list.
   value: value to search.
/;
int function FileIntListFind(string key, int value) global native
int function FileFloatListFind(string key, float value) global native
int function FileStringListFind(string key, string value) global native
int function FileFormListFind(string key, Form value) global native

;/ Find if a value in list exists globally and return true if it does.

   key: name of list.
   value: value to search.
/;
bool function FileIntListHas(string key, int value) global native
bool function FileFloatListHas(string key, float value) global native
bool function FileStringListHas(string key, string value) global native
bool function FileFormListHas(string key, Form value) global native

;/ Fills the given input array with the values of the list from global external file,
   will fill the array until either the array or list runs out of valid indexes

   key: name of list.
   slice: an initialized array set to the slice size you want, i.e. int[] slice = new int[10]
   [optional] startIndex: the starting list index you want to start filling your slice array with
/;
function FileIntListSlice(string key, int[] slice, int startIndex = 0) global native
function FileFloatListSlice(string key, float[] slice, int startIndex = 0) global native
function FileStringListSlice(string key, string[] slice, int startIndex = 0) global native
function FileFormListSlice(string key, Form[] slice, int startIndex = 0) global native

;/ Sizes the given list to a set number of elements. If the list exists already it will be truncated
   when given fewer elements, or resized to the appropiate length with the filler argument being used as
   the default values.

   Returns the number of elements truncated (signed) or added (unsigned) onto the list.

   key: name of list.
   toLength: The size you want to change the list to. Max length when using this function is 500.
   [optional] filler: When adding empty elements to the list this will be used as the default value
/;
int function FileIntListResize(string key, int toLength, int filler = 0) global native
int function FileFloatListResize(string key, int toLength, float filler = 0.0) global native
int function FileStringListResize(string key, int toLength, string filler = "") global native
int function FileFormListResize(string key, int toLength, Form filler = none) global native


;/ Creates a copy of array on the given storage list at the given object+key,
   overwriting any list that might already exists.

   Returns true on success.

   key: name of list.
   copy[]: The papyrus array with the content you wish to copy over into StorageUtil
   [optional] filler: When adding empty elements to the list this will be used as the default value
/;
bool function FileIntListCopy(string key, int[] copy) global native
bool function FileFloatListCopy(string key, float[] copy) global native
bool function FileStringListCopy(string key, string[] copy) global native
bool function FileFormListCopy(string key, Form[] copy) global native


;/
	Debug functions - can be helpful to find problems or for development.
/;

function debug_SaveFile() global native
function debug_DeleteValues(Form obj) global native
function debug_DeleteAllValues() global native

int function debug_Cleanup() global native


int function debug_GetIntObjectCount() global native
int function debug_GetFloatObjectCount() global native
int function debug_GetStringObjectCount() global native
int function debug_GetFormObjectCount() global native
int function debug_GetIntListObjectCount() global native
int function debug_GetFloatListObjectCount() global native
int function debug_GetStringListObjectCount() global native
int function debug_GetFormListObjectCount() global native

int function debug_GetIntKeysCount(Form obj) global native
int function debug_GetFloatKeysCount(Form obj) global native
int function debug_GetStringKeysCount(Form obj) global native
int function debug_GetFormKeysCount(Form obj) global native
int function debug_GetIntListKeysCount(Form obj) global native
int function debug_GetFloatListKeysCount(Form obj) global native
int function debug_GetStringListKeysCount(Form obj) global native
int function debug_GetFormListKeysCount(Form obj) global native

string function debug_GetIntKey(Form obj, int index) global native
string function debug_GetFloatKey(Form obj, int index) global native
string function debug_GetStringKey(Form obj, int index) global native
string function debug_GetFormKey(Form obj, int index) global native
string function debug_GetIntListKey(Form obj, int index) global native
string function debug_GetFloatListKey(Form obj, int index) global native
string function debug_GetStringListKey(Form obj, int index) global native
string function debug_GetFormListKey(Form obj, int index) global native


Form function debug_GetIntObject(int index) global native
Form function debug_GetFloatObject(int index) global native
Form function debug_GetStringObject(int index) global native
Form function debug_GetFormObject(int index) global native
Form function debug_GetIntListObject(int index) global native
Form function debug_GetFloatListObject(int index) global native
Form function debug_GetStringListObject(int index) global native
Form function debug_GetFormListObject(int index) global native


; Currently no longer implemented
int function debug_FileGetIntKeysCount() global
   return 0
endFunction

int function debug_FileGetFloatKeysCount() global
   return 0
endFunction

int function debug_FileGetStringKeysCount() global
   return 0
endFunction

int function debug_FileGetIntListKeysCount() global
   return 0
endFunction

int function debug_FileGetFloatListKeysCount() global
   return 0
endFunction

int function debug_FileGetStringListKeysCount() global
   return 0
endFunction

string function debug_FileGetIntKey(int index) global
   return ""
endFunction

string function debug_FileGetFloatKey(int index) global
   return ""
endFunction

string function debug_FileGetStringKey(int index) global
   return ""
endFunction

string function debug_FileGetIntListKey(int index) global
   return ""
endFunction

string function debug_FileGetFloatListKey(int index) global
   return ""
endFunction

string function debug_FileGetStringListKey(int index) global
   return ""
endFunction

function debug_FileDeleteAllValues() global
endFunction

function debug_SetDebugMode(bool enabled) global
endFunction

bool function ImportFile(string fileName, string restrictKey = "", int restrictType = -1, Form restrictForm = none, bool restrictGlobal = false, bool keyContains = false) global
   return false
endFunction
bool function ExportFile(string fileName, string restrictKey = "", int restrictType = -1, Form restrictForm = none, bool restrictGlobal = false, bool keyContains = false, bool append = true) global
   return false
endFunction
