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


;/ Set int value globally or on any form by name and return
   previous value.

   obj: form to save on. Set none to save globally.
   key: name of value.
   value: value itself.
/;
int function SetIntValue(Form obj, string key, int value) global native


;/ Set float value globally or on any form by name and return
   previous value.

   obj: form to save on. Set none to save globally.
   key: name of value.
   value: value itself.
/;
float function SetFloatValue(Form obj, string key, float value) global native


;/ Set string value globally or on any form by name and return
   previous value.

   obj: form to save on. Set none to save globally.
   key: name of value.
   value: value itself.
/;
string function SetStringValue(Form obj, string key, string value) global native

;/ Set form value globally or on any form by name and return
   previous value.

   obj: form to save on. Set none to save globally.
   key: name of value.
   value: value itself.
/;
Form function SetFormValue(Form obj, string key, Form value) global native


;/ Remove a previously set int value on an form or globally and
   return if successful. This will return false if value didn't exist.

   obj: form to remove from. Set none to remove global value.
   key: name of value.
/;
bool function UnsetIntValue(Form obj, string key) global native


;/ Remove a previously set float value on an form or globally and
   return if successful. This will return false if value didn't exist.

   obj: form to remove from. Set none to remove global value.
   key: name of value.
/;
bool function UnsetFloatValue(Form obj, string key) global native


;/ Remove a previously set string value on an form or globally and
   return if successful. This will return false if value didn't exist.

   obj: form to remove from. Set none to remove global value.
   key: name of value.
/;
bool function UnsetStringValue(Form obj, string key) global native

;/ Remove a previously set form value on an form or globally and
   return if successful. This will return false if value didn't exist.

   obj: form to remove from. Set none to remove global value.
   key: name of value.
/;
bool function UnsetFormValue(Form obj, string key) global native


;/ Check if value has been set on form or globally.

   obj: form to check on. Set none to check global value.
   key: name of value.
/;
bool function HasIntValue(Form obj, string key) global native


;/ Check if value has been set on form or globally.

   obj: form to check on. Set none to check global value.
   key: name of value.
/;
bool function HasFloatValue(Form obj, string key) global native


;/ Check if value has been set on form or globally.

   obj: form to check on. Set none to check global value.
   key: name of value.
/;
bool function HasStringValue(Form obj, string key) global native

;/ Check if value has been set on form or globally.

   obj: form to check on. Set none to check global value.
   key: name of value.
/;
bool function HasFormValue(Form obj, string key) global native


;/ Get previously saved int value on form or globally.

   obj: form to get from. Set none to get global value.
   key: name of value.
   [optional] missing: if value has not been set, return this value instead.
/;
int function GetIntValue(Form obj, string key, int missing = 0) global native


;/ Get previously saved float value on form or globally.

   obj: form to get from. Set none to get global value.
   key: name of value.
   [optional] missing: if value has not been set, return this value instead.
/;
float function GetFloatValue(Form obj, string key, float missing = 0.0) global native


;/ Get previously saved string value on form or globally.

   obj: form to get from. Set none to get global value.
   key: name of value.
   [optional] missing: if value has not been set, return this value instead.
/;
string function GetStringValue(Form obj, string key, string missing = "") global native

;/ Get previously saved form value on form or globally.

   obj: form to get from. Set none to get global value.
   key: name of value.
   [optional] missing: if value has not been set, return this value instead.
/;
Form function GetFormValue(Form obj, string key, Form missing = none) global native


;/ Add an int to a list on form or globally and return
   the value's new index. Index can be -1 if we were unable to add
   the value.

   obj: form to add to. Set none to add global value.
   key: name of value.
   value: value to add.
   [optional] allowDuplicate: allow adding value to list if this value
                              already exists in the list.
/;
int function IntListAdd(Form obj, string key, int value, bool allowDuplicate = true) global native


;/ Remove a previously added int value from a list on form
   or globally and return how many instances of this value were removed.

   obj: form to remove from. Set none to remove global value.
   key: name of value.
   value: value to remove.
   [optional] allowInstances: remove all instances of this value in a list.
/;
int function IntListRemove(Form obj, string key, int value, bool allInstances = false) global native


;/ Clear a list of values (unset) on an form or globally and
   return the previous size of list.

   obj: form to clear on. Set none to clear global list.
   key: name of list.
/;
int function IntListClear(Form obj, string key) global native


;/ Remove a value from list by index on form or globally and
   return if we were successful in doing so.

   obj: form to remove from. Set none to remove global value.
   key: name of list.
   index: index of value in the list.
/;
bool function IntListRemoveAt(Form obj, string key, int index) global native


;/ Get size of a list on form or globally.

   obj: form to check on. Set none to check global list.
   key: name of list.
/;
int function IntListCount(Form obj, string key) global native


;/ Get a value from list by index on form or globally.
   This will return 0 as value if there was a problem.

   obj: form to get value on. Set none to get global list value.
   key: name of list.
   index: index of value in the list.
/;
int function IntListGet(Form obj, string key, int index) global native


;/ Set a value in list by index on form or globally.
   This will return the previous value or 0 if there was a problem.

   obj: form to set value on. Set none to set global list value.
   key: name of list.
   index: index of value in the list.
   value: value to set to.
/;
int function IntListSet(Form obj, string key, int index, int value) global native


;/ Find a value in list on form or globally and return its
   index or -1 if value was not found.

   obj: form to find value on. Set none to find global list value.
   key: name of list.
   value: value to search.
/;
int function IntListFind(Form obj, string key, int value) global native


;/ Add a float to a list on form or globally and return
   the value's new index. Index can be -1 if we were unable to add
   the value.

   obj: form to add to. Set none to add global value.
   key: name of value.
   value: value to add.
   [optional] allowDuplicate: allow adding value to list if this value
                              already exists in the list.
/;
int function FloatListAdd(Form obj, string key, float value, bool allowDuplicate = true) global native


;/ Remove a previously added float value from a list on form
   or globally and return how many instances of this value were removed.

   obj: form to remove from. Set none to remove global value.
   key: name of value.
   value: value to remove.
   [optional] allowInstances: remove all instances of this value in a list.
/;
int function FloatListRemove(Form obj, string key, float value, bool allInstances = false) global native


;/ Clear a list of values (unset) on an form or globally and
   return the previous size of list.

   obj: form to clear on. Set none to clear global list.
   key: name of list.
/;
int function FloatListClear(Form obj, string key) global native


;/ Remove a value from list by index on form or globally and
   return if we were successful in doing so.

   obj: form to remove from. Set none to remove global value.
   key: name of list.
   index: index of value in the list.
/;
bool function FloatListRemoveAt(Form obj, string key, int index) global native


;/ Get size of a list on form or globally.

   obj: form to check on. Set none to check global list.
   key: name of list.
/;
int function FloatListCount(Form obj, string key) global native


;/ Get a value from list by index on form or globally.
   This will return 0 as value if there was a problem.

   obj: form to get value on. Set none to get global list value.
   key: name of list.
   index: index of value in the list.
/;
float function FloatListGet(Form obj, string key, int index) global native


;/ Set a value in list by index on form or globally.
   This will return the previous value or 0 if there was a problem.

   obj: form to set value on. Set none to set global list value.
   key: name of list.
   index: index of value in the list.
   value: value to set to.
/;
float function FloatListSet(Form obj, string key, int index, float value) global native


;/ Find a value in list on form or globally and return its
   index or -1 if value was not found.

   obj: form to find value on. Set none to find global list value.
   key: name of list.
   value: value to search.
/;
int function FloatListFind(Form obj, string key, float value) global native


;/ Add a string to a list on form or globally and return
   the value's new index. Index can be -1 if we were unable to add
   the value.

   obj: form to add to. Set none to add global value.
   key: name of value.
   value: value to add.
   [optional] allowDuplicate: allow adding value to list if this value
                              already exists in the list.
/;
int function StringListAdd(Form obj, string key, string value, bool allowDuplicate = true) global native


;/ Remove a previously added string value from a list on form
   or globally and return how many instances of this value were removed.

   obj: form to remove from. Set none to remove global value.
   key: name of value.
   value: value to remove.
   [optional] allowInstances: remove all instances of this value in a list.
/;
int function StringListRemove(Form obj, string key, string value, bool allInstances = false) global native


;/ Clear a list of values (unset) on an form or globally and
   return the previous size of list.

   obj: form to clear on. Set none to clear global list.
   key: name of list.
/;
int function StringListClear(Form obj, string key) global native


;/ Remove a value from list by index on form or globally and
   return if we were successful in doing so.

   obj: form to remove from. Set none to remove global value.
   key: name of list.
   index: index of value in the list.
/;
bool function StringListRemoveAt(Form obj, string key, int index) global native


;/ Get size of a list on form or globally.

   obj: form to check on. Set none to check global list.
   key: name of list.
/;
int function StringListCount(Form obj, string key) global native


;/ Get a value from list by index on form or globally.
   This will return 0 as value if there was a problem.

   obj: form to get value on. Set none to get global list value.
   key: name of list.
   index: index of value in the list.
/;
string function StringListGet(Form obj, string key, int index) global native


;/ Set a value in list by index on form or globally.
   This will return the previous value or 0 if there was a problem.

   obj: form to set value on. Set none to set global list value.
   key: name of list.
   index: index of value in the list.
   value: value to set to.
/;
string function StringListSet(Form obj, string key, int index, string value) global native


;/ Find a value in list on form or globally and return its
   index or -1 if value was not found.

   obj: form to find value on. Set none to find global list value.
   key: name of list.
   value: value to search.
/;
int function StringListFind(Form obj, string key, string value) global native


;/ Add a form to a list on form or globally and return
   the value's new index. Index can be -1 if we were unable to add
   the value.

   obj: form to add to. Set none to add global value.
   key: name of value.
   value: value to add.
   [optional] allowDuplicate: allow adding value to list if this value
                              already exists in the list.
/;
int function FormListAdd(Form obj, string key, Form value, bool allowDuplicate = true) global native


;/ Remove a previously added form value from a list on form
   or globally and return how many instances of this value were removed.

   obj: form to remove from. Set none to remove global value.
   key: name of value.
   value: value to remove.
   [optional] allowInstances: remove all instances of this value in a list.
/;
int function FormListRemove(Form obj, string key, Form value, bool allInstances = false) global native


;/ Clear a list of values (unset) on an form or globally and
   return the previous size of list.

   obj: form to clear on. Set none to clear global list.
   key: name of list.
/;
int function FormListClear(Form obj, string key) global native


;/ Remove a value from list by index on form or globally and
   return if we were successful in doing so.

   obj: form to remove from. Set none to remove global value.
   key: name of list.
   index: index of value in the list.
/;
bool function FormListRemoveAt(Form obj, string key, int index) global native


;/ Get size of a list on form or globally.

   obj: form to check on. Set none to check global list.
   key: name of list.
/;
int function FormListCount(Form obj, string key) global native


;/ Get a value from list by index on form or globally.
   This will return 0 as value if there was a problem.

   obj: form to get value on. Set none to get global list value.
   key: name of list.
   index: index of value in the list.
/;
Form function FormListGet(Form obj, string key, int index) global native


;/ Set a value in list by index on form or globally.
   This will return the previous value or 0 if there was a problem.

   obj: form to set value on. Set none to set global list value.
   key: name of list.
   index: index of value in the list.
   value: value to set to.
/;
Form function FormListSet(Form obj, string key, int index, Form value) global native


;/ Find a value in list on form or globally and return its
   index or -1 if value was not found.

   obj: form to find value on. Set none to find global list value.
   key: name of list.
   value: value to search.
/;
int function FormListFind(Form obj, string key, Form value) global native




;/
	Export / import specific data to and from file.
/;

;/ Import data from a separate JSON formated file.

   fileName: what file to import data from. This file is located in "Data/SKSE/Plugins/StorageUtilData/x.txt" where x is fileName.
   restrictKey: only import data with this name, for example "myValue" would only import variables with this name.
   restrictType: mask of which data to import. Set -1 to import all types of data.
		1 - int
		2 - float
		4 - string
		8 - form
		16 - intlist
		32 - floatlist
		64 - stringlist
		128 - formlist
	restrictForm: only import data saved on this form.
	restrictGlobal: only import globally saved data. restrictForm is ignored if this is set to true.
	keyContains: normally values will be imported if restrictKey is empty or equals the name of saved value. If this is true
	             then saved value must contain restrictKey instead of equal. example "myvalue_a", "myvalue_b", "myvalue_c" will
				 all be imported if keyContains is true and restrictKey is "myvalue_"
/;
bool function ImportFile(string fileName, string restrictKey = "", int restrictType = -1, Form restrictForm = none, bool restrictGlobal = false, bool keyContains = false) global native


;/ Export data to a separate JSON formated file.

   fileName: what file to export data to. This file is located in "Data/SKSE/Plugins/StorageUtilData/x.txt" where x is fileName.
   restrictKey: only export data with this name, for example "myValue" would only export variables with this name.
   restrictType: mask of which data to export. Set -1 to export all types of data.
		1 - int
		2 - float
		4 - string
		8 - form
		16 - intlist
		32 - floatlist
		64 - stringlist
		128 - formlist
	restrictForm: only export data saved on this form.
	restrictGlobal: only export globally saved data. restrictForm is ignored if this is set to true.
	keyContains: normally values will be exported if restrictKey is empty or equals the name of saved value. If this is true
	             then saved value must contain restrictKey instead of equal. example "myvalue_a", "myvalue_b", "myvalue_c" will
				 all be exported if keyContains is true and restrictKey is "myvalue_"
	append: if this is false then the file is cleared before exporting. If true then we only modify or add data.
/;
bool function ExportFile(string fileName, string restrictKey = "", int restrictType = -1, Form restrictForm = none, bool restrictGlobal = false, bool keyContains = false, bool append = true) global native




;/
	Storage functions - separate file. These are shared in all save games. Values are loaded and saved
	when savegame is loaded or saved.
/;


;/ Set int value globally by name and return previous value.

   key: name of value.
   value: value itself.
/;
int function FileSetIntValue(string key, int value) global native


;/ Set float value globally by name and return previous value.

   key: name of value.
   value: value itself.
/;
float function FileSetFloatValue(string key, float value) global native


;/ Set string value globally by name and return previous value.

   key: name of value.
   value: value itself.
/;
string function FileSetStringValue(string key, string value) global native


;/ Remove a previously set int value globally and return if successful. This
   will return false if value didn't exist.

   key: name of value.
/;
bool function FileUnsetIntValue(string key) global native


;/ Remove a previously set float value globally and return if successful. This
   will return false if value didn't exist.

   key: name of value.
/;
bool function FileUnsetFloatValue(string key) global native


;/ Remove a previously set string value globally and return if successful. This
   will return false if value didn't exist.

   key: name of value.
/;
bool function FileUnsetStringValue(string key) global native


;/ Check if value has been set globally.

   key: name of value.
/;
bool function FileHasIntValue(string key) global native


;/ Check if value has been set globally.

   key: name of value.
/;
bool function FileHasFloatValue(string key) global native


;/ Check if value has been set globally.

   key: name of value.
/;
bool function FileHasStringValue(string key) global native


;/ Get previously saved int value globally.

   key: name of value.
   [optional] missing: if value has not been set, return this value instead.
/;
int function FileGetIntValue(string key, int missing = 0) global native


;/ Get previously saved float value globally.

   key: name of value.
   [optional] missing: if value has not been set, return this value instead.
/;
float function FileGetFloatValue(string key, float missing = 0.0) global native


;/ Get previously saved string value globally.

   key: name of value.
   [optional] missing: if value has not been set, return this value instead.
/;
string function FileGetStringValue(string key, string missing = "") global native


;/ Add an int to a list globally and return the value's new index. Index can be
   -1 if we were unable to add the value.

   key: name of value.
   value: value to add.
   [optional] allowDuplicate: allow adding value to list if this value
                              already exists in the list.
/;
int function FileIntListAdd(string key, int value, bool allowDuplicate = true) global native


;/ Remove a previously added value from a list globally and return how many
   instances of this value were removed.

   key: name of value.
   value: value to remove.
   [optional] allowInstances: remove all instances of this value in a list.
/;
int function FileIntListRemove(string key, int value, bool allInstances = false) global native


;/ Clear a list of values (unset) globally and return the previous size of list.

   key: name of list.
/;
int function FileIntListClear(string key) global native


;/ Remove a value from list by index globally and return if we were successful
   in doing so.

   key: name of list.
   index: index of value in the list.
/;
bool function FileIntListRemoveAt(string key, int index) global native


;/ Get size of a list globally.

   key: name of list.
/;
int function FileIntListCount(string key) global native


;/ Get a value from list by index globally. This will return 0
   as value if there was a problem.

   key: name of list.
   index: index of value in the list.
/;
int function FileIntListGet(string key, int index) global native


;/ Set a value in list by index globally. This will return the previous
   value or 0 if there was a problem.

   key: name of list.
   index: index of value in the list.
   value: value to set to.
/;
int function FileIntListSet(string key, int index, int value) global native


;/ Find a value in list globally and return its index or -1 if value was not found.

   key: name of list.
   value: value to search.
/;
int function FileIntListFind(string key, int value) global native


;/ Add a float to a list globally and return the value's new index. Index can be
   -1 if we were unable to add the value.

   key: name of value.
   value: value to add.
   [optional] allowDuplicate: allow adding value to list if this value
                              already exists in the list.
/;
int function FileFloatListAdd(string key, float value, bool allowDuplicate = true) global native


;/ Remove a previously added value from a list globally and return how many
   instances of this value were removed.

   key: name of value.
   value: value to remove.
   [optional] allowInstances: remove all instances of this value in a list.
/;
int function FileFloatListRemove(string key, float value, bool allInstances = false) global native


;/ Clear a list of values (unset) globally and return the previous size of list.

   key: name of list.
/;
int function FileFloatListClear(string key) global native


;/ Remove a value from list by index globally and return if we were successful
   in doing so.

   key: name of list.
   index: index of value in the list.
/;
bool function FileFloatListRemoveAt(string key, int index) global native


;/ Get size of a list globally.

   key: name of list.
/;
int function FileFloatListCount(string key) global native


;/ Get a value from list by index globally. This will return 0
   as value if there was a problem.

   key: name of list.
   index: index of value in the list.
/;
float function FileFloatListGet(string key, int index) global native


;/ Set a value in list by index globally. This will return the previous
   value or 0 if there was a problem.

   key: name of list.
   index: index of value in the list.
   value: value to set to.
/;
float function FileFloatListSet(string key, int index, float value) global native


;/ Find a value in list globally and return its index or -1 if value was not found.

   key: name of list.
   value: value to search.
/;
int function FileFloatListFind(string key, float value) global native


;/ Add a string to a list globally and return the value's new index. Index can be
   -1 if we were unable to add the value.

   key: name of value.
   value: value to add.
   [optional] allowDuplicate: allow adding value to list if this value
                              already exists in the list.
/;
int function FileStringListAdd(string key, string value, bool allowDuplicate = true) global native


;/ Remove a previously added value from a list globally and return how many
   instances of this value were removed.

   key: name of value.
   value: value to remove.
   [optional] allowInstances: remove all instances of this value in a list.
/;
int function FileStringListRemove(string key, string value, bool allInstances = false) global native


;/ Clear a list of values (unset) globally and return the previous size of list.

   key: name of list.
/;
int function FileStringListClear(string key) global native


;/ Remove a value from list by index globally and return if we were successful
   in doing so.

   key: name of list.
   index: index of value in the list.
/;
bool function FileStringListRemoveAt(string key, int index) global native


;/ Get size of a list globally.

   key: name of list.
/;
int function FileStringListCount(string key) global native


;/ Get a value from list by index globally. This will return 0
   as value if there was a problem.

   key: name of list.
   index: index of value in the list.
/;
string function FileStringListGet(string key, int index) global native


;/ Set a value in list by index globally. This will return the previous
   value or 0 if there was a problem.

   key: name of list.
   index: index of value in the list.
   value: value to set to.
/;
string function FileStringListSet(string key, int index, string value) global native


;/ Find a value in list globally and return its index or -1 if value was not found.

   key: name of list.
   value: value to search.
/;
int function FileStringListFind(string key, string value) global native






;/
	Debug functions - can be helpful to find problems or for development.
/;


;/ Save all values in file without saving the game.
/;
function debug_SaveFile() global native

;/ Delete all values on an form or globally.
/;
function debug_DeleteValues(Form obj) global native

;/ Delete all values of all forms and also globally.
/;
function debug_DeleteAllValues() global native

;/ Delete all values from file.
/;
function debug_FileDeleteAllValues() global native

;/ Get the amount of variables saved on an form or globally.
/;
int function debug_GetIntKeysCount(Form obj) global native

;/ Get the amount of variables saved on an form or globally.
/;
int function debug_GetFloatKeysCount(Form obj) global native

;/ Get the amount of variables saved on an form or globally.
/;
int function debug_GetStringKeysCount(Form obj) global native

;/ Get the amount of variables saved on an form or globally.
/;
int function debug_GetFormKeysCount(Form obj) global native

;/ Get the amount of variables saved on an form or globally.
/;
int function debug_GetIntListKeysCount(Form obj) global native

;/ Get the amount of variables saved on an form or globally.
/;
int function debug_GetFloatListKeysCount(Form obj) global native

;/ Get the amount of variables saved on an form or globally.
/;
int function debug_GetStringListKeysCount(Form obj) global native

;/ Get the amount of variables saved on an form or globally.
/;
int function debug_GetFormListKeysCount(Form obj) global native

;/ Return the name of Nth variable that is saved on this form
   or globally.
/;
string function debug_GetIntKey(Form obj, int index) global native

;/ Return the name of Nth variable that is saved on this form
   or globally.
/;
string function debug_GetFloatKey(Form obj, int index) global native

;/ Return the name of Nth variable that is saved on this form
   or globally.
/;
string function debug_GetStringKey(Form obj, int index) global native

;/ Return the name of Nth variable that is saved on this form
   or globally.
/;
string function debug_GetFormKey(Form obj, int index) global native

;/ Return the name of Nth variable that is saved on this form
   or globally.
/;
string function debug_GetIntListKey(Form obj, int index) global native

;/ Return the name of Nth variable that is saved on this form
   or globally.
/;
string function debug_GetFloatListKey(Form obj, int index) global native

;/ Return the name of Nth variable that is saved on this form
   or globally.
/;
string function debug_GetStringListKey(Form obj, int index) global native

;/ Return the name of Nth variable that is saved on this form
   or globally.
/;
string function debug_GetFormListKey(Form obj, int index) global native

;/ Return the count of objects that we have saved variables on.
/;
int function debug_GetIntObjectCount() global native

;/ Return the count of objects that we have saved variables on.
/;
int function debug_GetFloatObjectCount() global native

;/ Return the count of objects that we have saved variables on.
/;
int function debug_GetStringObjectCount() global native

;/ Return the count of objects that we have saved variables on.
/;
int function debug_GetFormObjectCount() global native

;/ Return the count of objects that we have saved variables on.
/;
int function debug_GetIntListObjectCount() global native

;/ Return the count of objects that we have saved variables on.
/;
int function debug_GetFloatListObjectCount() global native

;/ Return the count of objects that we have saved variables on.
/;
int function debug_GetStringListObjectCount() global native

;/ Return the count of objects that we have saved variables on.
/;
int function debug_GetFormListObjectCount() global native

;/ Get the Nth object that we have saved variables on.
/;
Form function debug_GetIntObject(int index) global native

;/ Get the Nth object that we have saved variables on.
/;
Form function debug_GetFloatObject(int index) global native

;/ Get the Nth object that we have saved variables on.
/;
Form function debug_GetStringObject(int index) global native

;/ Get the Nth object that we have saved variables on.
/;
Form function debug_GetFormObject(int index) global native

;/ Get the Nth object that we have saved variables on.
/;
Form function debug_GetIntListObject(int index) global native

;/ Get the Nth object that we have saved variables on.
/;
Form function debug_GetFloatListObject(int index) global native

;/ Get the Nth object that we have saved variables on.
/;
Form function debug_GetStringListObject(int index) global native

;/ Get the Nth object that we have saved variables on.
/;
Form function debug_GetFormListObject(int index) global native

;/ Get the amount of variables saved.
/;
int function debug_FileGetIntKeysCount() global native

;/ Get the amount of variables saved.
/;
int function debug_FileGetFloatKeysCount() global native

;/ Get the amount of variables saved.
/;
int function debug_FileGetStringKeysCount() global native

;/ Get the amount of variables saved.
/;
int function debug_FileGetIntListKeysCount() global native

;/ Get the amount of variables saved.
/;
int function debug_FileGetFloatListKeysCount() global native

;/ Get the amount of variables saved.
/;
int function debug_FileGetStringListKeysCount() global native

;/ Get name of Nth variable saved.
/;
string function debug_FileGetIntKey(int index) global native

;/ Get name of Nth variable saved.
/;
string function debug_FileGetFloatKey(int index) global native

;/ Get name of Nth variable saved.
/;
string function debug_FileGetStringKey(int index) global native

;/ Get name of Nth variable saved.
/;
string function debug_FileGetIntListKey(int index) global native

;/ Get name of Nth variable saved.
/;
string function debug_FileGetFloatListKey(int index) global native

;/ Get name of Nth variable saved.
/;
string function debug_FileGetStringListKey(int index) global native

;/ Remove all saved values that were on a form that is now deleted
   and return how many objects we removed from.

   It is not necessary to use this function - this is done automatically.
/;
int function debug_Cleanup() global native
