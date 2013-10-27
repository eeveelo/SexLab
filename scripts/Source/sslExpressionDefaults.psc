scriptname sslExpressionDefaults extends sslExpressionFactory

function LoadExpressions()
	RegisterExpression("Pleasure")
endFunction

function Pleasure(string eventName, string id, float argNum, form sender)
	Name = "Pleasure"

	AddTag("Happy")
	AddTag("Pleasure")
	AddTag("Consensual")

	; // Female Phase 1
	AddPreset(1, Female, Expression, 2, 30)
	AddPreset(1, Female, Phoneme, 5, 30)
	AddPreset(1, Female, Phoneme, 6, 10)

	; // Female Phase 2
	AddPreset(2, Female, Expression, 10, 50)
	AddPreset(2, Female, Modifier, 4, 30)
	AddPreset(2, Female, Modifier, 5, 30)
	AddPreset(2, Female, Modifier, 6, 20)
	AddPreset(2, Female, Modifier, 7, 20)
	AddPreset(2, Female, Phoneme, 0, 20)
	AddPreset(2, Female, Phoneme, 3, 30)

	; // Female Phase 3
	AddPreset(3, Female, Expression, 10, 70)
	AddPreset(3, Female, Modifier, 2, 50)
	AddPreset(3, Female, Modifier, 3, 50)
	AddPreset(3, Female, Modifier, 4, 30)
	AddPreset(3, Female, Modifier, 5, 30)
	AddPreset(3, Female, Modifier, 6, 70)
	AddPreset(3, Female, Modifier, 7, 40)
	AddPreset(3, Female, Phoneme, 12, 30)
	AddPreset(3, Female, Phoneme, 13, 10)

	; // Female Phase 4
	AddPreset(4, Female, Expression, 10, 100)
	AddPreset(4, Female, Modifier, 0, 10)
	AddPreset(4, Female, Modifier, 1, 10)
	AddPreset(4, Female, Modifier, 2, 25)
	AddPreset(4, Female, Modifier, 3, 25)
	AddPreset(4, Female, Modifier, 6, 100)
	AddPreset(4, Female, Modifier, 7, 100)
	AddPreset(4, Female, Modifier, 12, 30)
	AddPreset(4, Female, Modifier, 13, 30)
	AddPreset(4, Female, Phoneme, 4, 35)
	AddPreset(4, Female, Phoneme, 10, 20)
	AddPreset(4, Female, Phoneme, 12, 30)

	; // Female Phase 5
	AddPreset(5, Female, Expression, 12, 100)
	AddPreset(5, Female, Modifier, 0, 15)
	AddPreset(5, Female, Modifier, 1, 15)
	AddPreset(5, Female, Modifier, 2, 25)
	AddPreset(5, Female, Modifier, 3, 25)
	AddPreset(5, Female, Modifier, 4, 60)
	AddPreset(5, Female, Modifier, 5, 60)
	AddPreset(5, Female, Modifier, 11, 100)
	AddPreset(5, Female, Modifier, 12, 70)
	AddPreset(5, Female, Modifier, 13, 30)
	AddPreset(5, Female, Phoneme, 0, 40)
	AddPreset(5, Female, Phoneme, 5, 20)
	AddPreset(5, Female, Phoneme, 12, 80)
	AddPreset(5, Female, Phoneme, 15, 20)

	; // Male Phase 1
	AddPreset(1, Male, Expression, 2, 30)
	AddPreset(1, Male, Phoneme, 5, 30)
	AddPreset(1, Male, Phoneme, 6, 10)

	; // Male Phase 2
	AddPreset(2, Male, Expression, 10, 50)
	AddPreset(2, Male, Modifier, 4, 30)
	AddPreset(2, Male, Modifier, 5, 30)
	AddPreset(2, Male, Modifier, 6, 20)
	AddPreset(2, Male, Modifier, 7, 20)
	AddPreset(2, Male, Phoneme, 0, 20)
	AddPreset(2, Male, Phoneme, 3, 30)

	; // Male Phase 3
	AddPreset(3, Male, Expression, 10, 70)
	AddPreset(3, Male, Modifier, 2, 50)
	AddPreset(3, Male, Modifier, 3, 50)
	AddPreset(3, Male, Modifier, 4, 30)
	AddPreset(3, Male, Modifier, 5, 30)
	AddPreset(3, Male, Modifier, 6, 70)
	AddPreset(3, Male, Modifier, 7, 40)
	AddPreset(3, Male, Phoneme, 12, 30)
	AddPreset(3, Male, Phoneme, 13, 10)

	; // Male Phase 4
	AddPreset(4, Male, Expression, 10, 100)
	AddPreset(4, Male, Modifier, 0, 10)
	AddPreset(4, Male, Modifier, 1, 10)
	AddPreset(4, Male, Modifier, 2, 25)
	AddPreset(4, Male, Modifier, 3, 25)
	AddPreset(4, Male, Modifier, 6, 100)
	AddPreset(4, Male, Modifier, 7, 100)
	AddPreset(4, Male, Modifier, 12, 30)
	AddPreset(4, Male, Modifier, 13, 30)
	AddPreset(4, Male, Phoneme, 4, 35)
	AddPreset(4, Male, Phoneme, 10, 20)
	AddPreset(4, Male, Phoneme, 12, 30)

	; // Male Phase 5
	AddPreset(5, Male, Expression, 12, 100)
	AddPreset(5, Male, Modifier, 0, 15)
	AddPreset(5, Male, Modifier, 1, 15)
	AddPreset(5, Male, Modifier, 2, 25)
	AddPreset(5, Male, Modifier, 3, 25)
	AddPreset(5, Male, Modifier, 4, 60)
	AddPreset(5, Male, Modifier, 5, 60)
	AddPreset(5, Male, Modifier, 11, 100)
	AddPreset(5, Male, Modifier, 12, 70)
	AddPreset(5, Male, Modifier, 13, 30)
	AddPreset(5, Male, Phoneme, 0, 40)
	AddPreset(5, Male, Phoneme, 5, 20)
	AddPreset(5, Male, Phoneme, 12, 80)
	AddPreset(5, Male, Phoneme, 15, 20)

	Save()
endFunction
