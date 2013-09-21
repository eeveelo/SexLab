scriptname sslAnimationLibrary extends Quest

; Scripts
sslAnimationSlots property Slots auto
sslCreatureAnimationSlots property CreatureSlots auto

; Data

; Config
bool property bRestrictAggressive auto hidden
bool property bAllowCreatures auto hidden


bool function AllowedCreature(Race creature)
	return bAllowCreatures && CreatureSlots.HasAnimation(creature)
endFunction

function _Defaults()
	bRestrictAggressive = true
	bAllowCreatures = false
endFunction