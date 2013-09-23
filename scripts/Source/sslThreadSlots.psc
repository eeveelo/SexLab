scriptname sslThreadSlots extends Quest

; Scripts
sslThreadLibrary property Lib auto

; Local
sslThreadController[] ThreadView

int property ActiveThreads hidden
	int function get()
		int count
		int i
		while i < 15
			count += ThreadView[i].IsLocked as int
			i += 1
		endWhile
		return count
	endFunction
endProperty

int function FindActorController(actor toFind)
	int i
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
	int i
	while i < ThreadView.Length
		if !ThreadView[i].IsLocked
			return ThreadView[i]
		endIf
		i += 1
	endWhile
	return none
endFunction	

;/-----------------------------------------------\;
;|	Thread Slots Setup                           |;
;\-----------------------------------------------/;

function _Setup()
	ThreadView = new sslThreadController[15]

	int i
	while i < 15
		if i < 10
			ThreadView[i] = GetAliasByName("ThreadView00"+i) as sslThreadController
		else
			ThreadView[i] = GetAliasByName("ThreadView0"+i) as sslThreadController
		endIf
		ThreadView[i]._SetThreadID(i)
		i += 1
	endWhile
endFunction

function _StopAll()
	int i
	while i < ThreadView.Length
		int slot
		while slot < ThreadView[i].ActorAlias.Length
			if ThreadView[i].ActorAlias[slot] != none
				sslActorAlias clearing = ThreadView[i].ActorAlias[slot] as sslActorAlias
				clearing.UnlockActor()
				clearing.ResetActor()
				clearing.StopAnimating(true)
				clearing.ClearAlias()
			endIf
			slot += 1
		endWhile
		ThreadView[i].UnlockThread()
		i += 1
	endWhile
endFunction
