scriptname sslExpressionSlots extends Quest

int property Slotted auto hidden
; Expressions readonly storage
sslBaseExpression[] Slots
sslBaseExpression[] property Expressions hidden
	sslBaseExpression[] function get()
		return Slots
	endFunction
endProperty


; ; ------------------------------------------------------- ;
; ; --- Expression Filtering                            --- ;
; ; ------------------------------------------------------- ;

; sslBaseExpression function PickExpression(Actor ActorRef)
; endFunction

; sslBaseExpression function GetByTags(string Tags, string TagsSuppressed = "", bool RequireAll = true)
; 	string[] Search = sslUtility.ArgString(Tags)
; 	if Search.Length == 0
; 		return none
; 	endIf
; 	string[] Suppress = sslUtility.ArgString(TagsSuppressed)
; 	bool[] Valid = new bool[50]
; 	int i = Slotted
; 	while i
; 		i -= 1
; 		Valid[i] = Slots[i].Enabled && (TagsSuppressed == "" || Slots[i].CheckTags(Suppress, false, true)) && Slots[i].CheckTags(Search, RequireAll)
; 	endWhile
; 	sslBaseExpression[] Found = GetList(Valid)
; 	int r = Utility.RandomInt(0, (Found.Length - 1))
; 	return Found[r]
; endFunction

; sslBaseExpression function GetByRegistrar(string Registrar)
; 	return GetBySlot(FindByRegistrar(Registrar))
; endFunction

; sslBaseExpression function GetByName(string FindName)
; 	return GetBySlot(FindByName(FindName))
; endFunction

; sslBaseExpression function GetBySlot(int index)
; 	if index < 0 || index >= Slotted
; 		return none
; 	endIf
; 	return Slots[index]
; endFunction

; ; ------------------------------------------------------- ;
; ; --- System Use Only                                 --- ;
; ; ------------------------------------------------------- ;

; sslBaseExpression[] function GetList(bool[] Valid)
; 	; int i = sslUtility.CountTrue(Valid)
; 	; if i == 0
; 	; 	return none ; OR empty array?
; 	; endIf
; 	; string Found
; 	; sslBaseExpression[] Output = sslUtility.VoiceArray(i)
; 	; int pos = Valid.Find(true)
; 	; while pos != -1 && pos < Slotted
; 	; 	i -= 1
; 	; 	Output[i] = Slots[pos]
; 	; 	pos = Valid.Find(true, (pos + 1))
; 	; 	Found += Output[i].Name+", "
; 	; endWhile
; 	; SexLabUtil.DebugLog("Found Voices("+Output.Length+"): "+Found, "", Config.DebugMode)
; 	; return Output
; endFunction

bool function IsRegistered(string Registrar)
	return FindByRegistrar(Registrar) != -1
endFunction

int function FindByName(string FindName)
	int i = Slotted
	while i
		i -= 1
		if Slots[i].Name == FindName
			return i
		endIf
	endWhile
	return -1
endFunction

int function FindByRegistrar(string Registrar)
	return StorageUtil.StringListFind(self, "Expression.Registry", Registrar)
endFunction

; sslBaseExpression function Register(string Registrar)
; 	if FindByRegistrar(Registrar) == -1 && Slotted < Slots.Length
; 		StorageUtil.StringListAdd(self, "Expression.Registry", Registrar, false)
; 		Slotted = StorageUtil.StringListCount(self, "Expression.Registry")
; 		return Slots[(Slotted - 1)]
; 	endIf
; 	return none
; endFunction

function RegisterExpressions()
	; Register default voices
	; (Quest.GetQuest("SexLabQuestRegistry") as sslExpressionDefaults).LoadExpressions()
	; Send mod event for 3rd party voices
	; ModEvent.Send(ModEvent.Create("SexLabSlotExpressions"))
	; Debug.Notification("$SSL_NotifyVoiceInstall")
endFunction

function Setup()
	; Clear Slots
	Slots = new sslBaseExpression[75]
	int i = Slots.Length
	while i
		i -= 1
		Alias BaseAlias = GetNthAlias(i)
		if BaseAlias != none
			Slots[i] = BaseAlias as sslBaseExpression
			Slots[i].Clear()
		endIf
	endWhile
	; Init variables
	Slotted = 0
	StorageUtil.StringListClear(self, "Expression.Registry")
	; Register voices
	RegisterExpressions()
endFunction
