scriptname sslThreadSlots extends Quest

; Scripts
sslThreadLibrary property Lib auto

; Local
sslThreadController[] ThreadView

int property Count hidden
	int function get()
		return ThreadView.Length
	endFunction
endProperty

int function FindActorController(actor toFind)
	int i = 0
	while i < 15
		if ThreadView[i].HasActor(toFind)
			return i
		endIf
		i += 1
	endWhile
	return -1
endFunction

sslThreadController function GetActorController(actor toFind)
	int tid = FindActorController(toFind)
	if tid != -1
		return ThreadView[tid]
	endIf
	return none
endFunction

int function FindPlayerController()
	return FindActorController(Lib.PlayerRef)
endFunction

sslThreadController function GetPlayerController()
	return GetActorController(Lib.PlayerRef)
endFunction

sslThreadController function GetController(int tid)
	return ThreadView[tid]
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

sslThreadController property ThreadView000 auto
sslThreadController property ThreadView001 auto
sslThreadController property ThreadView002 auto
sslThreadController property ThreadView003 auto
sslThreadController property ThreadView004 auto
sslThreadController property ThreadView005 auto
sslThreadController property ThreadView006 auto
sslThreadController property ThreadView007 auto
sslThreadController property ThreadView008 auto
sslThreadController property ThreadView009 auto
sslThreadController property ThreadView010 auto
sslThreadController property ThreadView011 auto
sslThreadController property ThreadView012 auto
sslThreadController property ThreadView013 auto
sslThreadController property ThreadView014 auto

function _Setup()
	ThreadView = new sslThreadController[15]
	ThreadView[0] = ThreadView000
	ThreadView[1] = ThreadView001
	ThreadView[2] = ThreadView002
	ThreadView[3] = ThreadView003
	ThreadView[4] = ThreadView004
	ThreadView[5] = ThreadView005
	ThreadView[6] = ThreadView006
	ThreadView[7] = ThreadView007
	ThreadView[8] = ThreadView008
	ThreadView[9] = ThreadView009
	ThreadView[10] = ThreadView010
	ThreadView[11] = ThreadView011
	ThreadView[12] = ThreadView012
	ThreadView[13] = ThreadView013
	ThreadView[14] = ThreadView014

	int i = 0
	while i < 15
		ThreadView[i]._SetThreadID(i)
		i += 1
	endWhile
endFunction

function _StopAll()
	int i = 0
	while i < ThreadView.Length
		ThreadView[i].SendActorEvent("EndThread", 1.0)
		ThreadView[i].UnlockThread()
		i += 1
	endWhile
endFunction