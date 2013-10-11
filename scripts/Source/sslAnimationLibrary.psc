scriptname sslAnimationLibrary extends Quest

; Scripts
sslAnimationSlots property Slots auto
sslCreatureAnimationSlots property CreatureSlots auto
sslActorLibrary property ActorLib auto

; Data

; Config
bool property bRestrictAggressive auto hidden
bool property bAllowCreatures auto hidden

bool function AllowedCreature(Race creature)
	return bAllowCreatures && CreatureSlots.HasRace(creature)
endFunction

bool function AllowedCreatureCombination(Race creature, Race creature2)
	return bAllowCreatures && CreatureSlots.HasAnimation(creature, creature2)
endFunction

function _Defaults()
	bRestrictAggressive = true
	bAllowCreatures = false
endFunction