# SexLab SE
SexLab is a Framework made with the objective of give a tool to the mod author’s to help them to easily make sex orientated Mods. SexLab Framework isn’t made to start animations by his own and for that objective need to be followed by some mod that start the on context.

# Install & Update
Before update disable the option to "Purge Dead Actors Every 10 Game Days" on the "SexLab Aroused" MCM and save the game on interior location then close the game to install the new SexLab.
That option is executed sometimes on the load game event and cause CTD if happens at the same time the SexLab Framework is being updated.
Also save the game again once the update be completed and don't leave the room until then.
When you install the new SexLab Framework make sure of remove all the fixes and Patches for the previous version because they no longer are compatible besides no longer be required.
The fixes and patch are those Mods that override some SexLab Script files like the "SexLab Fix", "Better Blowjob", previous versions of the SLSO and others.
* The Update process start automaticaly the change on the version number is detected but can also be forced using the "Clean System" option
	
* If you want to install SexLab on a Saved game make sure of first save the game on interior location to reduce the stress caused for the installation process then close the game and start the installation.

To install just open the compressed file with your Mod Administrator or copy the uncompressed files directly on your Skyrim "Data" folder.
Run "FNIS for Users" before start the game (recommended even if you are using Nemesis instead of FNIS)
Start a new game or open your last saved game, wait at least few seconds until the SexLab MCM be added.
* For a new game is better wait until the end of the Unbound quest (is when you leave the cell on the alternative start mod or when the player hands are unbounded bit after reach the dungeon after the Alduin scene on Helgen) before force the SexLab Installation. Mostly because the player needs to be on 3rd Person Camera to correctly install the Default Animations
Once the SexLab MCM is ready you can save the game and the SexLab Installation will start automatically next time you load the game and the min requirements be reached or you can force the SexLab Installation process.

To force the SexLab Installation process first the player requires a visible body and need to be on 3rd Person Camera (the 3rd Person Camera is only required for the installation process and just because some requirements are not detected while you are on First Person Camera)
Open the SexLab MCM and check the requirements if they are all green OK then you can continue. The ones tagged as "?" can be ignored but are recommended, and the red "X" need to be solved before continue with the installation.
If everything is fine you only have to make click on the "Install" option and wait until the notification windows informing the installation is done.
After the installation be completed is recommended save the game before try anything else. 
* The installation process can take between 15 minutes and in some cases even more than 1 hour (depends of the PC, the Skyrim.ini configuration and the amount of Mod scrips running at the same time). On that time the player should stay on the same location to avoid CTD or Frost Screen for lack of resources. The SexLab Installation process is really heavy but don’t wary because is constantly tested on a PC with the Skyrim minimal requirements and work without problems…

* Is not recommended start a SexLab scene just installed because between other reasons the mods that use the "SexLab Framework" as hard dependency may detect the recent installation on the SexLab and may be executing his own installation process.
* You can’t test the "SexLab Framework" using the "Play Animation" option on the "Toggle Animation" page of the SexLab MCM, the "Match Maker" option of the "SexLab Tools" Mod or using the "SexLab MatchMaker" Mod. Never use the SexLab Debug Spell because is reserved for use of the SexLab Framework author only.


# Know Issues
* The Animation CACHE get resettled or updated each time you install/remove or enable/disable some animation even get updated when the animation tags get edited using the "Toggle Animation" page of the SexLab MCM. But can’t detect when the animations tags are changed as consequence of an animation update or the tags are changed by some external mod. On those cases is recommended use the "Clean Animation CACHE" option.
* The first time a SexLab scene is started after install the SexLab, the scene can take more than 20 minutes to start. That’s because the CACHE if empty and nothing is speeding the scene startup, don’t wary because each new scene will be faster to start once be stored on the CACHE eventually taking less than 15 seconds.

# Change Log

GitHub:
* Fix issue with the Tag list of the "Filter By Tag" option in the "Toggle Animation" page taking too long to respound afther close the SexLab MCM and open it again. Still take hapend but now is only when the animations tags are changed or the "Clean Animation CACHE" option is used.
* Include AdjustEnjoytmen function to allow the mod authors change the value of the actor enjoyment
* Add Advanced Configuration for the Lips Sync together with the OpenMouth Advanced Configuration on the MCM.
* Replace the file "SexlabOffsets.json" by the "SexlabOffsetsDefault.json" on the Setup to prevent override the "SexlabOffsets.json" edited by the user. And update the scripts to process both files. Now I can keep updating the Default Animation Offsets without interfere with the user adjustment.
* Fix issues with the "Play Animation" option of the "Animation Editor" page.
* Fix issue with the detection of the Node Scales for the Humanoid Skeleton files.
* Fix issue with the version update process.
* Added "Forcibly Sort Positions" MCM option to force actor gender position sorting at the start of animation.

BETA 9:
* Increase the max animations count to 1000.
* Enhance the Animation Cache to speed up the start of most used animations
* More accurate detection of the actor scale even if the scale was settled directly on the Skeleton file or using the NiOverride (RaceMenu)
* Include animations filter to correct bad gender position and unnatural animations like Males receiving "Vaginal" sex
* Include internal function to process Creatures Animations with multiple races (right now handle the CC animations)
* Allow some users that don't like to see the actors get stripped on some scenes like "kissing", once disabled in both genders the slot 32 (Body) for the Strip Lead will use the limited striping just if all the animations on the list have the "LimitedStrip" tag.
* Include option to strip chance % for individual items on "Strip Editor"
* Fix issue with strip idle in middle of the animation.
* Include FadeToBlack option to hide the odds animation stages like when actors teleport, animation re-align or animation end without Ragdoll.
* Include "Foreplay/LeadIn Cooldown" option to avoid the LeadIn/Foreplay Animations get played too often.
* Enhance the LeadIn disabling the LeadIn scenes when the PrimaryAnimations have just Foreplay Animations like happen with most of the Kissing scenes.
* Include another hidden function for the Ctrl key. Now keep holding the Ctrl key while accept the Slider Window of the Alignment option in the "Animation Editor" page allow you apply the selected value to all the stages of the current Animation Profile.
* Added "FemDom" tag to the main filters on Aggressive Animations. Include "Adjust Victim/Aggressor Positions" option to the MCM to allow disable the FemDom function and avoid the Defeat Mod issue.
* Include "Restrict Strapons Use" option to the MCM to allow remove the "Straight" Tagged Animations from the Animation List when all the humanoid actors are female and "Females Use Strap-ons" is enabled.
* Include "Clean Animation CACHE" option to the MCM to allow force the animation CACHE cleaning functions for the Creature and Standard Animations.
* Include "Shake Camera Strength" option to the MCM to allow adjust and disable the ShakeCamera effect on the player orgasms.
* Include new alignment options hidden on the SexLab MCM "Animation Editor" page to adjust the "Animation" Furniture/Bed offsets (Forward, Sides, Up, Rotation) also added one preset file on "SKSE/SexLab/SexlabOffsetsDefault.json" with some predefined Animation offsets. Plus, the user made file on "SKSE/SexLab/SexlabOffsets.json" with the Animation offsets of the user.
* Enhance the "Animation Editor" page. Now:
	* The "Play Animation" option made to test the selected animation deal better with creature animations and can test animations with more than 2 actors filling the missing positions with the nearby valid actors. 
	* The default adjustments values are taken from the "Global" animation adjustment Profile.
* Added few missing Altars and Beds to the Bed list.
* Enhance the Find Bed functions. Now:
	* Will prioritize the nearest Beds.
	* Depending of the scene type will reduce or increase the Search Radios in order to prevent break the immersion.
* Added one "Times with the Player" counter for the NPC'S on the "Sex Diary"
* Enhance the SexLab Expression system. Now:
	* Include advanced OpenMouth Phonemes configuration "Edit OpenMouth Expression" allowing more control of the user of the open mouth expression. By the way the OpenMouth * Phonemes configuration is the same for all the Expressions but the Modifiers are taked from the current SexLab Expression applied to the actor so at less the eyes look different for each expression while the mouth is open.
	* Moved the "OpenMouth Size" option from the "Animation Settings" page to the "Expression Editor" page.
	* Include "Alternative OpenMouth Expression" option to allow use the "Combat Anger" expression instead of the "Combat Shout" expression. This can help with teeth and tong issues.
	* Add new "Auto Refresh Expression" option to toggle the automatic expression refreshments every few seconds instead of with each scene stage.
	* Include the "Refresh Expression Delay" option to adjust who often the expression is refreshed.
	* The "Test Expression" options now also allow test the expression with the Mouth Open.
	* Allow copy the previous Phase of the Expression on the "Expression Editor" when new Phase is added using the SexLab MCM.
	* Fixed few Expressions issues so now should work fine with and without the MFG.

* Enhance OpenMouth function called from the SexLabFramework.psc to keep the actor mouth open on the sex scene until the CloseMouth function be called or the scene end.
* Fix and Enhance the internal ChangeActors function to correct alignment issues when add or remove actors and now also allow Creatures.
* Fix Random Animation Problem when exceed 125 animations for the list
* Fix the Hook system.
* Fix and enhance a bit some internal function to gain stability


BETA 8:
* 
* Updated SexLabUtil.dll and PapyrusUtil.dll to the new version of SKSE  (2.0.17)
	* Skyrim SE, version 1.5.97 only

BETA 7:
* Increased animation slots to 750, decreased voice/expression slots to 375.
* Include the Animation CACHE to speed up the start of most used animations
* A new hook system (partially implemented) for developers that don't work on events, allowing them to fully complete their hook function before the thread continues. Solves some sync issues with more complicated or timing sensitive hooks.
* Updated SexLabUtil.dll and PapyrusUtil.dll to the new version of SKSE  (2.0.16)
	* Skyrim SE, version 1.5.80 only
* Re-enabled HDT Heels detection
* A few minor bug fixes

BETA 6:
* Updated SexLabUtil.dll and PapyrusUtil.dll to the new version of SKSE  (2.0.15)
	* Skyrim SE, version 1.5.73 only
* A few fixes I can't track in the GitHub server History ant provably tagged as BETA 5 or BETA 7

BETA 5:
* Include the SexLabActorGenderChange event to allow the external mods detect when the actor gender is changed
* A new scaling fix that finally solves the issue with some actors/creatures randomly changing sizes when animating (enabled by default)
* Updated SexLabUtil.dll and PapyrusUtil.dll to the new version of SKSE  (2.0.11 or 2.0.12)
	* Skyrim SE, version 1.5.62 only
* Re-added all high heel options in the MCM.

BETA 4:
* Updated SexLabUtil.dll and PapyrusUtil.dll to the SKSE 2.0.10

BETA 3:
* Updated SexLabUtil.dll and PapyrusUtil.dll to the new version of SKSE  (2.0.8)
* Fixed most of the slowdown at animation startup
* Fixed disabled animations still getting used for awhile afterward
* Some minor tweaks here and there

BETA 2:
* Updated SexLabUtil.dll and PapyrusUtil.dll to the new version of SKSE  (2.0.7)
* Removed references to Oldrim scripts (NiOverride and MfgConsoleFunc) to fix compile issues
* Some minor tweaks here and there

BETA 1:


* Some other stuff I'm surely forgetting because it's been a long time.



