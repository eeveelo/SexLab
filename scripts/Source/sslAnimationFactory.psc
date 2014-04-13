scriptname sslAnimationFactory extends Quest hidden

sslAnimationSlots property Slots auto hidden

; Gender Types
int property Male = 0 autoreadonly hidden
int property Female = 1 autoreadonly hidden
int property Creature = 2 autoreadonly hidden
; Cum Types
int property Vaginal = 1 autoreadonly hidden
int property Oral = 2 autoreadonly hidden
int property Anal = 3 autoreadonly hidden
int property VaginalOral = 4 autoreadonly hidden
int property VaginalAnal = 5 autoreadonly hidden
int property OralAnal = 6 autoreadonly hidden
int property VaginalOralAnal = 7 autoreadonly hidden
; Content Types
int property Misc = 0 autoreadonly hidden
int property Sexual = 1 autoreadonly hidden
int property Foreplay = 2 autoreadonly hidden
; SFX Types
Sound property Squishing auto hidden
Sound property Sucking auto hidden
Sound property SexMix auto hidden

; ------------------------------------------------------- ;
; --- Registering Animations                          --- ;
; ------------------------------------------------------- ;

; Send callback event to start registration
function RegisterAnimation(string Registrar)
	; Get free Animation slot
	int id = Slots.Register(Registrar)
	if id != -1
		; Get slot
		sslBaseAnimation Slot = Slots.GetNthAlias(id) as sslBaseAnimation
		Slots.Animations[id] = Slot
		; Init Animation
		Slot.Initialize()
		Slot.Registry = Registrar
		Slot.Enabled = true
		; Send load event
		RegisterForModEvent(Registrar, Registrar)
		int handle = ModEvent.Create(Registrar)
		ModEvent.PushInt(handle, id)
		ModEvent.Send(handle)
	endIf
endFunction

; Gets the Animation resource object for use in the callback, MUST be called at start of callback to get the appropiate resource
sslBaseAnimation function Create(int id)
	sslBaseAnimation Slot = Slots.GetbySlot(id)
	UnregisterForModEvent(Slot.Registry)
	return Slot
endFunction

; ------------------------------------------------------- ;
; --- Callback Data Handling - SYSTEM USE ONLY        --- ;
; ------------------------------------------------------- ;

function Initialize()
	sslSystemConfig Config = Game.GetFormFromFile(0xD62, "SexLab.esm") as sslSystemConfig
	Squishing = Config.SquishingFX
	Sucking   = Config.SuckingFX
	SexMix    = Config.SexMixedFX
endFunction
