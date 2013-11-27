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
	_StopAll()
	ThreadView = new sslThreadController[15]
	int i = 15
	while i
		i -= 1
		ThreadView[i] = GetNthAlias(i) as sslThreadController
		ThreadView[i]._SetThreadID(i)
		ThreadView[i].Initialize()
	endWhile
endFunction

function _StopAll()
	int i = ThreadView.Length
	while i
		i -= 1
		if ThreadView[i].GetState() != "Unlocked"
			ThreadView[i].FastEnd = true
			int n = ThreadView[i].ActorAlias.Length
			while n
				n -= 1
				sslActorAlias clearing = ThreadView[i].ActorAlias[n]
				clearing.StopAnimating(true)
				clearing.GoToState("")
				clearing.GoToState("Reset")
			endWhile
		endIf
		ThreadView[i].Initialize()
	endWhile
endFunction
