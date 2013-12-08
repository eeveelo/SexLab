scriptname sslExpressionDefaults extends sslExpressionFactory

function LoadExpressions()
	RegisterExpression("Pleasure")
	RegisterExpression("Shy")
	RegisterExpression("Afraid")
	RegisterExpression("Pained")
	RegisterExpression("Angry")
endFunction

function Pleasure(string eventName, string id, float argNum, form sender)
	Name = "Pleasure"

	AddTag("Happy")
	AddTag("Normal")
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
	AddPreset(5, Female, Expression, 12, 60)
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
	AddPreset(1, Male, Expression, 13, 40)
	AddPreset(2, Male, Modifier, 6, 20)
	AddPreset(2, Male, Modifier, 7, 20)
	AddPreset(1, Male, Phoneme, 5, 20)

	; // Male Phase 2
	AddPreset(2, Male, Expression, 8, 40)
	AddPreset(2, Male, Modifier, 12, 40)
	AddPreset(2, Male, Modifier, 13, 40)
	AddPreset(2, Male, Phoneme, 2, 50)
	AddPreset(2, Male, Phoneme, 13, 20)

	; // Male Phase 3
	AddPreset(3, Male, Expression, 13, 80)
	AddPreset(3, Male, Modifier, 6, 80)
	AddPreset(3, Male, Modifier, 7, 80)
	AddPreset(3, Male, Modifier, 12, 30)
	AddPreset(3, Male, Modifier, 13, 30)
	AddPreset(3, Male, Phoneme, 0, 30)

	Save()
endFunction

function Shy(string eventName, string id, float argNum, form sender)
	Name = "Shy"

	AddTag("Normal")
	AddTag("Nervous")
	AddTag("Sad")
	AddTag("Shy")

	AddTag("Consensual")

	; Female
	AddPreset(1, Female, Expression, 4, 90)
	AddPreset(1, Female, Modifier, 11, 20)
	AddPreset(1, Female, Phoneme, 1, 10)
	AddPreset(1, Female, Phoneme, 11, 10)

	AddPreset(2, Female, Expression, 3, 50)
	AddPreset(2, Female, Modifier, 8, 50)
	AddPreset(2, Female, Modifier, 9, 40)
	AddPreset(2, Female, Modifier, 12, 30)

	AddPreset(3, Female, Expression, 3, 50)
	AddPreset(3, Female, Modifier, 8, 50)
	AddPreset(3, Female, Modifier, 9, 40)
	AddPreset(3, Female, Modifier, 12, 30)
	AddPreset(3, Female, Phoneme, 1, 10)
	AddPreset(3, Female, Phoneme, 11, 10)

	; Male
	AddPreset(1, Male, Expression, 4, 90)
	AddPreset(1, Male, Modifier, 11, 20)
	AddPreset(1, Male, Phoneme, 1, 10)
	AddPreset(1, Male, Phoneme, 11, 10)

	AddPreset(2, Male, Expression, 3, 50)
	AddPreset(2, Male, Modifier, 8, 50)
	AddPreset(2, Male, Modifier, 9, 40)
	AddPreset(2, Male, Modifier, 12, 30)

	AddPreset(3, Male, Expression, 3, 50)
	AddPreset(3, Male, Modifier, 8, 50)
	AddPreset(3, Male, Modifier, 9, 40)
	AddPreset(3, Male, Modifier, 12, 30)
	AddPreset(3, Male, Phoneme, 1, 10)
	AddPreset(3, Male, Phoneme, 11, 10)

	Save()
endFunction

function Afraid(string eventName, string id, float argNum, form sender)
	Name = "Afraid"

	AddTag("Afraid")
	AddTag("Scared")
	AddTag("Pain")
	AddTag("Negative")

	AddTag("Aggressor")

	; Female
	AddPreset(1, Female, Expression, 3, 100)
	AddPreset(1, Female, Modifier, 2, 10)
	AddPreset(1, Female, Modifier, 3, 10)
	AddPreset(1, Female, Modifier, 6, 50)
	AddPreset(1, Female, Modifier, 7, 50)
	AddPreset(1, Female, Modifier, 1, 30)
	AddPreset(1, Female, Modifier, 12, 30)
	AddPreset(1, Female, Modifier, 13, 30)
	AddPreset(1, Female, Phoneme, 0, 20)

	AddPreset(2, Female, Expression, 8, 100)
	AddPreset(2, Female, Modifier, 0, 100)
	AddPreset(2, Female, Modifier, 1, 100)
	AddPreset(2, Female, Modifier, 2, 100)
	AddPreset(2, Female, Modifier, 3, 100)
	AddPreset(2, Female, Modifier, 4, 100)
	AddPreset(2, Female, Modifier, 5, 100)
	AddPreset(2, Female, Phoneme, 2, 100)
	AddPreset(2, Female, Phoneme, 2, 100)
	AddPreset(2, Female, Phoneme, 5, 40)

	AddPreset(3, Female, Expression, 3, 100)
	AddPreset(3, Female, Modifier, 11, 50)
	AddPreset(3, Female, Modifier, 13, 40)
	AddPreset(3, Female, Phoneme, 2, 50)
	AddPreset(3, Female, Phoneme, 13, 20)
	AddPreset(3, Female, Phoneme, 15, 40)

	AddPreset(4, Female, Expression, 9, 100)
	AddPreset(4, Female, Modifier, 2, 100)
	AddPreset(4, Female, Modifier, 3, 100)
	AddPreset(4, Female, Modifier, 4, 100)
	AddPreset(4, Female, Modifier, 5, 100)
	AddPreset(4, Female, Modifier, 11, 90)
	AddPreset(4, Female, Phoneme, 0, 30)
	AddPreset(4, Female, Phoneme, 2, 30)

	; Male
	AddPreset(1, Male, Expression, 3, 100)
	AddPreset(1, Male, Modifier, 2, 10)
	AddPreset(1, Male, Modifier, 3, 10)
	AddPreset(1, Male, Modifier, 6, 50)
	AddPreset(1, Male, Modifier, 7, 50)
	AddPreset(1, Male, Modifier, 1, 30)
	AddPreset(1, Male, Modifier, 12, 30)
	AddPreset(1, Male, Modifier, 13, 30)
	AddPreset(1, Male, Phoneme, 0, 20)

	AddPreset(2, Male, Expression, 8, 100)
	AddPreset(2, Male, Modifier, 0, 100)
	AddPreset(2, Male, Modifier, 1, 100)
	AddPreset(2, Male, Modifier, 2, 100)
	AddPreset(2, Male, Modifier, 3, 100)
	AddPreset(2, Male, Modifier, 4, 100)
	AddPreset(2, Male, Modifier, 5, 100)
	AddPreset(2, Male, Phoneme, 2, 100)
	AddPreset(2, Male, Phoneme, 2, 100)
	AddPreset(2, Male, Phoneme, 5, 40)

	AddPreset(3, Male, Expression, 3, 100)
	AddPreset(3, Male, Modifier, 11, 50)
	AddPreset(3, Male, Modifier, 13, 40)
	AddPreset(3, Male, Phoneme, 2, 50)
	AddPreset(3, Male, Phoneme, 13, 20)
	AddPreset(3, Male, Phoneme, 15, 40)

	AddPreset(4, Male, Expression, 9, 100)
	AddPreset(4, Male, Modifier, 2, 100)
	AddPreset(4, Male, Modifier, 3, 100)
	AddPreset(4, Male, Modifier, 4, 100)
	AddPreset(4, Male, Modifier, 5, 100)
	AddPreset(4, Male, Modifier, 11, 90)
	AddPreset(4, Male, Phoneme, 0, 30)
	AddPreset(4, Male, Phoneme, 2, 30)

	Save()
endFunction


function Pained(string eventName, string id, float argNum, form sender)
	Name = "Pained"

	AddTag("Afraid")
	AddTag("Pain")
	AddTag("Pained")
	AddTag("Negative")

	AddTag("Victim")

	; Female
	AddPreset(1, Female, Expression, 3, 100)
	AddPreset(1, Female, Modifier, 2, 10)
	AddPreset(1, Female, Modifier, 3, 10)
	AddPreset(1, Female, Modifier, 6, 50)
	AddPreset(1, Female, Modifier, 7, 50)
	AddPreset(1, Female, Modifier, 1, 30)
	AddPreset(1, Female, Modifier, 12, 30)
	AddPreset(1, Female, Modifier, 13, 30)
	AddPreset(1, Female, Phoneme, 0, 20)

	AddPreset(2, Female, Expression, 3, 100)
	AddPreset(2, Female, Modifier, 11, 50)
	AddPreset(2, Female, Modifier, 13, 40)
	AddPreset(2, Female, Phoneme, 2, 50)
	AddPreset(2, Female, Phoneme, 13, 20)
	AddPreset(2, Female, Phoneme, 15, 40)

	AddPreset(3, Female, Expression, 8, 100)
	AddPreset(3, Female, Modifier, 0, 100)
	AddPreset(3, Female, Modifier, 1, 100)
	AddPreset(3, Female, Modifier, 2, 100)
	AddPreset(3, Female, Modifier, 3, 100)
	AddPreset(3, Female, Modifier, 4, 100)
	AddPreset(3, Female, Modifier, 5, 100)
	AddPreset(3, Female, Phoneme, 2, 100)
	AddPreset(3, Female, Phoneme, 5, 40)

	AddPreset(4, Female, Expression, 9, 100)
	AddPreset(4, Female, Modifier, 2, 100)
	AddPreset(4, Female, Modifier, 3, 100)
	AddPreset(4, Female, Modifier, 4, 100)
	AddPreset(4, Female, Modifier, 5, 100)
	AddPreset(4, Female, Modifier, 11, 90)
	AddPreset(4, Female, Phoneme, 0, 30)
	AddPreset(4, Female, Phoneme, 2, 30)

	; Male
	AddPreset(1, Male, Expression, 3, 100)
	AddPreset(1, Male, Modifier, 2, 10)
	AddPreset(1, Male, Modifier, 3, 10)
	AddPreset(1, Male, Modifier, 6, 50)
	AddPreset(1, Male, Modifier, 7, 50)
	AddPreset(1, Male, Modifier, 1, 30)
	AddPreset(1, Male, Modifier, 12, 30)
	AddPreset(1, Male, Modifier, 13, 30)
	AddPreset(1, Male, Phoneme, 0, 20)

	AddPreset(2, Male, Expression, 3, 100)
	AddPreset(2, Male, Modifier, 11, 50)
	AddPreset(2, Male, Modifier, 13, 40)
	AddPreset(2, Male, Phoneme, 2, 50)
	AddPreset(2, Male, Phoneme, 13, 20)
	AddPreset(2, Male, Phoneme, 15, 40)

	AddPreset(3, Male, Expression, 8, 100)
	AddPreset(3, Male, Modifier, 0, 100)
	AddPreset(3, Male, Modifier, 1, 100)
	AddPreset(3, Male, Modifier, 2, 100)
	AddPreset(3, Male, Modifier, 3, 100)
	AddPreset(3, Male, Modifier, 4, 100)
	AddPreset(3, Male, Modifier, 5, 100)
	AddPreset(3, Male, Phoneme, 2, 100)
	AddPreset(3, Male, Phoneme, 5, 40)

	AddPreset(4, Male, Expression, 9, 100)
	AddPreset(4, Male, Modifier, 2, 100)
	AddPreset(4, Male, Modifier, 3, 100)
	AddPreset(4, Male, Modifier, 4, 100)
	AddPreset(4, Male, Modifier, 5, 100)
	AddPreset(4, Male, Modifier, 11, 90)
	AddPreset(4, Male, Phoneme, 0, 30)
	AddPreset(4, Male, Phoneme, 2, 30)

	Save()
endFunction


function Angry(string eventName, string id, float argNum, form sender)
	Name = "Angry"

	AddTag("Mad")
	AddTag("Angry")
	AddTag("Upset")

	AddTag("Aggressor")
	AddTag("Victim")

	; Female
	AddPreset(1, Female, Expression, 0, 40)
	AddPreset(1, Female, Modifier, 12, 30)
	AddPreset(1, Female, Modifier, 13, 30)
	AddPreset(1, Female, Phoneme, 4, 40)

	AddPreset(2, Female, Expression, 0, 55)
	AddPreset(2, Female, Modifier, 12, 50)
	AddPreset(2, Female, Modifier, 13, 50)
	AddPreset(2, Female, Phoneme, 4, 40)

	AddPreset(3, Female, Expression, 0, 100)
	AddPreset(3, Female, Modifier, 12, 65)
	AddPreset(3, Female, Modifier, 13, 65)
	AddPreset(3, Female, Phoneme, 4, 50)
	AddPreset(3, Female, Phoneme, 3, 40)

	; Male
	AddPreset(1, Male, Expression, 0, 40)
	AddPreset(1, Male, Modifier, 12, 30)
	AddPreset(1, Male, Modifier, 13, 30)
	AddPreset(1, Male, Phoneme, 4, 40)

	AddPreset(2, Male, Expression, 0, 55)
	AddPreset(2, Male, Modifier, 12, 50)
	AddPreset(2, Male, Modifier, 13, 50)
	AddPreset(2, Male, Phoneme, 4, 40)

	AddPreset(3, Male, Expression, 0, 100)
	AddPreset(3, Male, Modifier, 12, 65)
	AddPreset(3, Male, Modifier, 13, 65)
	AddPreset(3, Male, Phoneme, 4, 50)
	AddPreset(3, Male, Phoneme, 3, 40)

	Save()
endFunction
