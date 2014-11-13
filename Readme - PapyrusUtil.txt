File Name: PapyrusUtil
File Submitter: h38fh2mf
File Submitted: 07 Dec 2013
File Category: Modders Resources
Requires: SKSE


1. Description
2. Examples
3. Requirements
4. Installing
5. Uninstalling
6. Updating
7. Compatibility & issues
8. Credits
9. Changelog



1. Description

SKSE plugin that allows you to save any amount of int, float, form and string values on any form or globally from papyrus scripts. Also supports lists of those data types. These values can be accessed from any mod allowing easy dynamic compatibility.

Also adds the following papyrus commands:
Toggle fly cam and set fly cam speed - TFC.
Set menus on / off - TM.
Bat command - execute batch file in console.
Write to file / read to file functions. Good to combine with bat command.
Adds an additional package stack override on actors. See ActorUtil.psc
Replace any animations on selected objects. See ObjectUtil.psc
Print messages to console.
set and load data to custom external JSON files. See JsonUtil.psc
Some other misc stuff.

PapyrusUtil.psc - version check & variable initialized arrays.
StorageUtil.psc - store variables and lists of data on a form that can be pulled back out using the form and variable name as keys. See psc file for documentation.
JsonUtil.psc - Similar to StorageUtil.psc but saves data to custom external .json files instead of forms, letting them be customizable out of game and stored independent of a users save file.
ActorUtil.psc - actor package override.
ObjectUtil.psc - animation replacement.
MiscUtil.psc - some misc commands.

3. Requirements

SKSE 1.7.1 latest version: http://skse.silverlock.org/



4. Installing

Use mod manager or extract files manually.



5. Uninstalling

Remove the files you added in Installing step.



6. Updating

Just overwrite all files.



7. Compatibility & issues

Should be compatible with everything.



8. Credits

exiledviper - continued maintenance & refactoring of original plugin's source code
meh321 - original version and idea
SKSE team - for making this plugin possible
milzschnitte - for suggestions


9. Changelog
2.8 - 10/03/2014
Fixed critical bug causing StringListRemove to do exactly the opposite of what you want it to do
Fixed crash to desktop issue some users have experienced when plugin loads an external json files for reading
Added papyrus array initializing functions to PapyrusUtil.psc
2.7 - 09/09/2014
Added back package override saving.
Added AdjustInt/FloatValue() and Int/FloatListAdjust() functions to StorageUtil and JsonUtil, shortcut function for adjusting existing values +/- a given amount
Added a ClearAll() function to JsonUtil for emptying out an external json files contents.
Cleaned up various native functions to better check for proper arguments being passed to prevent potential crashes.
2.6 - 08/11/2014
Fixed bug causing crash/freeze when attempting to load a nonexistent external file.
2.5 - 08/08/2014
REQUIRES SKSE 1.7.1
Rewrite of plugin source code
Added new JsonUtil script
ListSlice() function for copying list into a Papyrus array
ListCopy() function for copying a Papyrus array into a list
ListResize() function for changing the length of list
Various other bug fixes and minor new functions
