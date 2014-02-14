scriptname sslAnimationSlots extends Quest

int property Slotted auto hidden
; Animation readonly storage
sslBaseAnimation[] Slots
sslBaseAnimation[] property Animations hidden
	sslBaseAnimation[] function get()
		return Slots
	endFunction
endProperty

; ------------------------------------------------------- ;
; --- Animation Filtering                             --- ;
; ------------------------------------------------------- ;



; ------------------------------------------------------- ;
; --- Find single animation object                    --- ;
; ------------------------------------------------------- ;

sslBaseAnimation function GetByName(string name)
	int i
	while i < Slotted
		if Slots[i].Name == name
			return Slots[i]
		endIf
		i += 1
	endWhile
	return none
endFunction

sslBaseAnimation function GetSlot(int index)
	return Slots[index]
endFunction

int function FindByRegistrar(string Registrar)
	return StorageUtil.StringListFind(self, "Registry", Registrar)
endFunction

sslBaseAnimation function GetEmpty()
	if Slotted < Slots.Length
		return Slots[Slotted]
	endIf
	return none
endFunction

; ------------------------------------------------------- ;
; --- System Use Only                                 --- ;
; ------------------------------------------------------- ;

sslBaseAnimation function Register(string Registrar)
	if FindByRegistrar(Registrar) == -1 && Slotted < Slots.Length
		StorageUtil.StringListAdd(self, "Registry", Registrar, false)
		sslBaseAnimation Claiming = Slots[Slotted]
		Claiming.Initialize()
		Claiming.Registry = Registrar
		Slotted = StorageUtil.StringListCount(self, "Registry")
		return Claiming
	endIf
	return none
endFunction

function Setup()
	Initialize()
	(Quest.GetQuest("SexLabQuestAnimations") as sslAnimationDefaults).LoadAnimations()
	ModEvent.Send(ModEvent.Create("SexLabSlotAnimations"))
	Debug.Notification("$SSL_NotifyAnimationInstall")
endFunction

function Initialize()
	Slotted = 0
	StorageUtil.StringListClear(self, "Registry")
	Slots = new sslBaseAnimation[125]
	int i = Slots.Length
	while i
		i -= 1
		Slots[i] = (GetNthAlias(i) as sslBaseAnimation)
		Slots[i].Clear()
	endWhile
endFunction

event OnInit()
	; Setup()
endEvent
