Scriptname MfgConsoleFunc Hidden

; native functions, wrapper base. these have magic number for select some parameter.
bool function SetPhonemeModifier(Actor act, int mode, int id, int value) native global
int function GetPhonemeModifier(Actor act, int mode, int id) native global

; wrapper functions

; set phoneme/modifier, same as console.
bool function SetPhoneme(Actor act, int id, int value) global
	return SetPhonemeModifier(act, 0, id, value)
endfunction
bool function SetModifier(Actor act, int id, int value) global
	return SetPhonemeModifier(act, 1, id, value)
endfunction

; reset phoneme/modifier. this does not reset expression.
bool function ResetPhonemeModifier(Actor act) global
	return SetPhonemeModifier(act, -1, 0, 0)
endfunction

; get phoneme/modifier/expression
int function GetPhoneme(Actor act, int id) global
	return GetPhonemeModifier(act, 0, id)
endfunction
int function GetModifier(Actor act, int id) global
	return GetPhonemeModifier(act, 1, id)
endfunction

; return expression value which is enabled. (enabled only one at a time.)
int function GetExpressionValue(Actor act) global
	return GetPhonemeModifier(act, 2, 0)
endfunction
; return expression ID which is enabled.
int function GetExpressionID(Actor act) global
	return GetPhonemeModifier(act, 3, 0)
endfunction

