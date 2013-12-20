scriptname sslAnimationLibrary extends Quest

; Scripts
sslAnimationSlots property Slots auto
sslCreatureAnimationSlots property CreatureSlots auto
sslActorLibrary property ActorLib auto

; Data

; Config
bool property bRestrictAggressive auto hidden
bool property bAllowCreatures auto hidden


string function MakeGenderTag(actor[] Positions)
	string tag
	int[] genders = ActorLib.GenderCount(Positions)
	while genders[1]
		genders[1] = (genders[1] - 1)
		tag += "F"
	endWhile
		while genders[0]
		genders[0] = (genders[0] - 1)
		tag += "M"
	endWhile
	while genders[2]
		genders[2] = (genders[2] - 1)
		tag += "C"
	endWhile
	return tag
endFunction

bool function AllowedCreature(Race creature)
	return bAllowCreatures && CreatureSlots.HasAnimation(creature)
endFunction

bool function AllowedCreatureCombination(Race creature, Race creature2)
	return bAllowCreatures && CreatureSlots.HasAnimation(creature, creature2)
endFunction

function _Defaults()
	bRestrictAggressive = true
	bAllowCreatures = false
endFunction
