scriptname sslThreadSlots extends Quest

sslThreadController[] ThreadView

; sslThreadController[] property Controller hidden
; 	sslThreadController function get()
; 		return ThreadView
; 	endfunction
; endProperty

int property Count hidden
	int function get()
		return ThreadView.Length
	endFunction
endProperty


sslThreadController function GetController(int tid)
	int i = 0
	while i < ThreadView.Length
		if ThreadView[i].tid == tid
			return ThreadView[i]
		endIf
		i += 1
	endWhile
endFunction

sslThreadController function PickController()
	int i = 0
	while i < ThreadView.Length
		if !ThreadView[i].IsLocked
			return ThreadView[i]
		endIf
		i += 1
	endWhile
	return none
endFunction

sslThreadView00 property ThreadView00 auto
sslThreadView01 property ThreadView01 auto
sslThreadView02 property ThreadView02 auto
sslThreadView03 property ThreadView03 auto
sslThreadView04 property ThreadView04 auto
sslThreadView05 property ThreadView05 auto
sslThreadView06 property ThreadView06 auto
sslThreadView07 property ThreadView07 auto
sslThreadView08 property ThreadView08 auto
sslThreadView09 property ThreadView09 auto
sslThreadView10 property ThreadView10 auto
sslThreadView11 property ThreadView11 auto
sslThreadView12 property ThreadView12 auto
sslThreadView13 property ThreadView13 auto
sslThreadView14 property ThreadView14 auto

function _Setup()
	ThreadView = new sslThreadController[15]
	ThreadView[0] = ThreadView00 as sslThreadView00
	ThreadView[1] = ThreadView01 as sslThreadView01
	ThreadView[2] = ThreadView02 as sslThreadView02
	ThreadView[3] = ThreadView03 as sslThreadView03
	ThreadView[4] = ThreadView04 as sslThreadView04
	ThreadView[5] = ThreadView05 as sslThreadView05
	ThreadView[6] = ThreadView06 as sslThreadView06
	ThreadView[7] = ThreadView07 as sslThreadView07
	ThreadView[8] = ThreadView08 as sslThreadView08
	ThreadView[9] = ThreadView09 as sslThreadView09
	ThreadView[10] = ThreadView10 as sslThreadView10
	ThreadView[11] = ThreadView11 as sslThreadView11
	ThreadView[12] = ThreadView12 as sslThreadView12
	ThreadView[13] = ThreadView13 as sslThreadView13
	ThreadView[14] = ThreadView14 as sslThreadView14
endFunction

event OnInit()
	_Setup()
endEvent