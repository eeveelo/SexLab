scriptname sslAnimationLibrary extends sslSystemLibrary

; Scripts
sslAnimationSlots property Slots auto

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

string function GetGenderTag(int females = 0, int males = 0, int creatures = 0) global
	string tag
	while females
		females -= 1
		tag += "F"
	endWhile
	while males
		males -= 1
		tag += "M"
	endWhile
	while creatures
		creatures -= 1
		tag += "C"
	endWhile
	return tag
endFunction

bool function AllowedCreature(Race creature)
	return bAllowCreatures && CreatureAnimations.HasAnimation(creature)
endFunction

bool function AllowedCreatureCombination(Race creature, Race creature2)
	return bAllowCreatures && CreatureAnimations.HasAnimation(creature, creature2)
endFunction

;/-----------------------------------------------\;
;|	System Use Only                              |;
;\-----------------------------------------------/;

function _Defaults()
	bRestrictAggressive = true
	bAllowCreatures = false
endFunction
function _Export()
	_ExportBool("bRestrictAggressive", bRestrictAggressive)
	_ExportBool("bAllowCreatures", bAllowCreatures)
	int i = Animations.Slotted
	while i
		i -= 1
		Animations.Slots[i]._Export()
	endWhile
	i = CreatureAnimations.Slotted
	while i
		i -= 1
		CreatureAnimations.Slots[i]._Export()
	endWhile
endFunction
function _Import()
	_Defaults()
	bRestrictAggressive = _ImportBool("bRestrictAggressive", bRestrictAggressive)
	bAllowCreatures = _ImportBool("bAllowCreatures", bAllowCreatures)
	int i = Animations.Slotted
	while i
		i -= 1
		Animations.Slots[i]._Import()
	endWhile
	i = CreatureAnimations.Slotted
	while i
		i -= 1
		CreatureAnimations.Slots[i]._Import()
	endWhile
endFunction
