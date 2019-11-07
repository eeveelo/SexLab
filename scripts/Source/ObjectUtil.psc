scriptname ObjectUtil Hidden

;/
	Animation override.

	Here you can replace animations on objects by animation event name.

	Idle Property laughIdle Auto ; "IdleLaugh" here from CK
	SetReplaceAnimation(akTarget, "moveStart", laughIdle)

	No whenever this character tries to move they start laughing instead.

	Animation replace is checked once, that means if you replace moveStart with
	IdleLaugh and IdleLaugh with idleEatingStandingStart then whenever you try to
	move you start laughing and not eating.

	This replacement persists through save games.
/;



; IMPORTANT SKYRIM SPECIAL EDITION NOTE:
; These functions no longer function in the current version of PapyrusUtilSE.
; They have been commented out in order to raise compiler errors so any script
; to make any old script conversions aware of this.
;
; To force compile old scripts at your own risk, uncomment these now empty functions.



; Replace animation on object by animation event name. If obj is none then it will replace globally, be careful with this!
; function SetReplaceAnimation(ObjectReference obj, string oldAnimEvent, Idle newAnim) global
; 	return
; endFunction

; Remove a previously set animation replacement.
; bool function RemoveReplaceAnimation(ObjectReference obj, string oldAnimEvent) global
; 	return false
; endFunction

; Count how many animation replacements have been set on object.
; int function CountReplaceAnimation(ObjectReference obj) global
; 	return -1
; endFunction

; Clear all animation replacements on object.
; int function ClearReplaceAnimation(ObjectReference obj) global
; 	return -1
; endFunction

; Get animation event that is replaced on an object by index (use count function to iterate).
; string function GetKeyReplaceAnimation(ObjectReference obj, int index) global
; 	return ""
; endFunction

; Get animation that is replacing previous animation on an object.
; Idle function GetValueReplaceAnimation(ObjectReference obj, string oldAnim) global
; 	return none
; endFunction
