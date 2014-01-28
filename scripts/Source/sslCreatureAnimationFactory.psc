scriptname sslCreatureAnimationFactory extends sslAnimationFactory

int slot

; Gender Types
int property Creature = 2 autoreadonly hidden

;/-----------------------------------------------\;
;|	Registering Animations                       |;
;\-----------------------------------------------/;

; Send callback event to start registration
int function RegisterAnimation(string registrar)
	if Slots.FindByRegistrar(registrar) != -1
		return Slots.FindByRegistrar(registrar) ; Duplicate
	elseif !Slots.FreeSlots
		return -1 ; No free slots
	endIf
	; Wait for factory to be free
	while Animation != none
		Utility.Wait(0.10)
	endWhile
	; Get free animation slot
	Animation = Slots.GetFree()
	slot = Slots.Register(Animation, registrar)
	; Send load event
	RegisterForModEvent("RegisterAnimation", registrar)
	SendModEvent("RegisterAnimation", registrar, 1)
	UnregisterForAllModEvents()
	return slot
endFunction

; Unlocks factory for next callback, MUST be called at end of callback
function Save()
	; Run animation caches
	Animation.CacheAllForwards()
	; Free up factory
	Debug.Trace("SexLabCreatureAnimationFactory: Registered creature animation slot SexLabFramework.CreatureAnimation["+slot+"] to '"+Animation.Name+"' ")
	Animation = none
	slot = -1
endfunction

;/-----------------------------------------------\;
;|	Callback Animation Property Shortcuts        |;
;\-----------------------------------------------/;

function AddRace(Race creatureRace)
	Animation.AddRace(creatureRace)
	Slots.AddRace(creatureRace)
endFunction
