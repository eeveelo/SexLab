scriptname sslExpressionDefaults extends sslExpressionFactory

function LoadExpressions()
	RegisterExpression("Pleasure")
	RegisterExpression("Happy")
	RegisterExpression("Joy")
	RegisterExpression("Shy")
	RegisterExpression("Sad")
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

	; Female
	AddExpression(1, Female, 2, 30)
	AddPhoneme(1, Female, 5, 30)
	AddPhoneme(1, Female, 6, 10)

	AddExpression(2, Female, 10, 50)
	AddModifier(2, Female, 4, 30)
	AddModifier(2, Female, 5, 30)
	AddModifier(2, Female, 6, 20)
	AddModifier(2, Female, 7, 20)
	AddPhoneme(2, Female, 0, 20)
	AddPhoneme(2, Female, 3, 30)

	AddExpression(3, Female, 10, 70)
	AddModifier(3, Female, 2, 50)
	AddModifier(3, Female, 3, 50)
	AddModifier(3, Female, 4, 30)
	AddModifier(3, Female, 5, 30)
	AddModifier(3, Female, 6, 70)
	AddModifier(3, Female, 7, 40)
	AddPhoneme(3, Female, 12, 30)
	AddPhoneme(3, Female, 13, 10)

	AddExpression(4, Female, 10, 100)
	AddModifier(4, Female, 0, 10)
	AddModifier(4, Female, 1, 10)
	AddModifier(4, Female, 2, 25)
	AddModifier(4, Female, 3, 25)
	AddModifier(4, Female, 6, 100)
	AddModifier(4, Female, 7, 100)
	AddModifier(4, Female, 12, 30)
	AddModifier(4, Female, 13, 30)
	AddPhoneme(4, Female, 4, 35)
	AddPhoneme(4, Female, 10, 20)
	AddPhoneme(4, Female, 12, 30)

	AddExpression(5, Female, 12, 60)
	AddModifier(5, Female, 0, 15)
	AddModifier(5, Female, 1, 15)
	AddModifier(5, Female, 2, 25)
	AddModifier(5, Female, 3, 25)
	AddModifier(5, Female, 4, 60)
	AddModifier(5, Female, 5, 60)
	AddModifier(5, Female, 11, 100)
	AddModifier(5, Female, 12, 70)
	AddModifier(5, Female, 13, 30)
	AddPhoneme(5, Female, 0, 40)
	AddPhoneme(5, Female, 5, 20)
	AddPhoneme(5, Female, 12, 80)
	AddPhoneme(5, Female, 15, 20)

	; Male
	AddExpression(1, Male, 13, 40)
	AddModifier(1, Male, 6, 20)
	AddModifier(1, Male, 7, 20)
	AddPhoneme(1, Male, 5, 20)

	AddExpression(2, Male, 8, 40)
	AddModifier(2, Male, 12, 40)
	AddModifier(2, Male, 13, 40)
	AddPhoneme(2, Male, 2, 50)
	AddPhoneme(2, Male, 13, 20)

	AddExpression(3, Male, 13, 80)
	AddModifier(3, Male, 6, 80)
	AddModifier(3, Male, 7, 80)
	AddModifier(3, Male, 12, 30)
	AddModifier(3, Male, 13, 30)
	AddPhoneme(3, Male, 0, 30)

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
	AddExpression(1, Female, 4, 90)
	AddModifier(1, Female, 11, 20)
	AddPhoneme(1, Female, 1, 10)
	AddPhoneme(1, Female, 11, 10)

	AddExpression(2, Female, 3, 50)
	AddModifier(2, Female, 8, 50)
	AddModifier(2, Female, 9, 40)
	AddModifier(2, Female, 12, 30)

	AddExpression(3, Female, 3, 50)
	AddModifier(3, Female, 8, 50)
	AddModifier(3, Female, 9, 40)
	AddModifier(3, Female, 12, 30)
	AddPhoneme(3, Female, 1, 10)
	AddPhoneme(3, Female, 11, 10)

	; Male
	AddExpression(1, Male, 4, 90)
	AddModifier(1, Male, 11, 20)
	AddPhoneme(1, Male, 1, 10)
	AddPhoneme(1, Male, 11, 10)

	AddExpression(2, Male, 3, 50)
	AddModifier(2, Male, 8, 50)
	AddModifier(2, Male, 9, 40)
	AddModifier(2, Male, 12, 30)

	AddExpression(3, Male, 3, 50)
	AddModifier(3, Male, 8, 50)
	AddModifier(3, Male, 9, 40)
	AddModifier(3, Male, 12, 30)
	AddPhoneme(3, Male, 1, 10)
	AddPhoneme(3, Male, 11, 10)

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
	AddExpression(1, Female, 3, 100)
	AddModifier(1, Female, 2, 10)
	AddModifier(1, Female, 3, 10)
	AddModifier(1, Female, 6, 50)
	AddModifier(1, Female, 7, 50)
	AddModifier(1, Female, 1, 30)
	AddModifier(1, Female, 12, 30)
	AddModifier(1, Female, 13, 30)
	AddPhoneme(1, Female, 0, 20)

	AddExpression(2, Female, 8, 100)
	AddModifier(2, Female, 0, 100)
	AddModifier(2, Female, 1, 100)
	AddModifier(2, Female, 2, 100)
	AddModifier(2, Female, 3, 100)
	AddModifier(2, Female, 4, 100)
	AddModifier(2, Female, 5, 100)
	AddPhoneme(2, Female, 2, 100)
	AddPhoneme(2, Female, 2, 100)
	AddPhoneme(2, Female, 5, 40)

	AddExpression(3, Female, 3, 100)
	AddModifier(3, Female, 11, 50)
	AddModifier(3, Female, 13, 40)
	AddPhoneme(3, Female, 2, 50)
	AddPhoneme(3, Female, 13, 20)
	AddPhoneme(3, Female, 15, 40)

	AddExpression(4, Female, 9, 100)
	AddModifier(4, Female, 2, 100)
	AddModifier(4, Female, 3, 100)
	AddModifier(4, Female, 4, 100)
	AddModifier(4, Female, 5, 100)
	AddModifier(4, Female, 11, 90)
	AddPhoneme(4, Female, 0, 30)
	AddPhoneme(4, Female, 2, 30)

	; Male
	AddExpression(1, Male, 3, 100)
	AddModifier(1, Male, 2, 10)
	AddModifier(1, Male, 3, 10)
	AddModifier(1, Male, 6, 50)
	AddModifier(1, Male, 7, 50)
	AddModifier(1, Male, 1, 30)
	AddModifier(1, Male, 12, 30)
	AddModifier(1, Male, 13, 30)
	AddPhoneme(1, Male, 0, 20)

	AddExpression(2, Male, 8, 100)
	AddModifier(2, Male, 0, 100)
	AddModifier(2, Male, 1, 100)
	AddModifier(2, Male, 2, 100)
	AddModifier(2, Male, 3, 100)
	AddModifier(2, Male, 4, 100)
	AddModifier(2, Male, 5, 100)
	AddPhoneme(2, Male, 2, 100)
	AddPhoneme(2, Male, 2, 100)
	AddPhoneme(2, Male, 5, 40)

	AddExpression(3, Male, 3, 100)
	AddModifier(3, Male, 11, 50)
	AddModifier(3, Male, 13, 40)
	AddPhoneme(3, Male, 2, 50)
	AddPhoneme(3, Male, 13, 20)
	AddPhoneme(3, Male, 15, 40)

	AddExpression(4, Male, 9, 100)
	AddModifier(4, Male, 2, 100)
	AddModifier(4, Male, 3, 100)
	AddModifier(4, Male, 4, 100)
	AddModifier(4, Male, 5, 100)
	AddModifier(4, Male, 11, 90)
	AddPhoneme(4, Male, 0, 30)
	AddPhoneme(4, Male, 2, 30)

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
	AddExpression(1, Female, 3, 100)
	AddModifier(1, Female, 2, 10)
	AddModifier(1, Female, 3, 10)
	AddModifier(1, Female, 6, 50)
	AddModifier(1, Female, 7, 50)
	AddModifier(1, Female, 1, 30)
	AddModifier(1, Female, 12, 30)
	AddModifier(1, Female, 13, 30)
	AddPhoneme(1, Female, 0, 20)

	AddExpression(2, Female, 3, 100)
	AddModifier(2, Female, 11, 50)
	AddModifier(2, Female, 13, 40)
	AddPhoneme(2, Female, 2, 50)
	AddPhoneme(2, Female, 13, 20)
	AddPhoneme(2, Female, 15, 40)

	AddExpression(3, Female, 8, 100)
	AddModifier(3, Female, 0, 100)
	AddModifier(3, Female, 1, 100)
	AddModifier(3, Female, 2, 100)
	AddModifier(3, Female, 3, 100)
	AddModifier(3, Female, 4, 100)
	AddModifier(3, Female, 5, 100)
	AddPhoneme(3, Female, 2, 100)
	AddPhoneme(3, Female, 5, 40)

	AddExpression(4, Female, 9, 100)
	AddModifier(4, Female, 2, 100)
	AddModifier(4, Female, 3, 100)
	AddModifier(4, Female, 4, 100)
	AddModifier(4, Female, 5, 100)
	AddModifier(4, Female, 11, 90)
	AddPhoneme(4, Female, 0, 30)
	AddPhoneme(4, Female, 2, 30)

	; Male
	AddExpression(1, Male, 3, 100)
	AddModifier(1, Male, 2, 10)
	AddModifier(1, Male, 3, 10)
	AddModifier(1, Male, 6, 50)
	AddModifier(1, Male, 7, 50)
	AddModifier(1, Male, 1, 30)
	AddModifier(1, Male, 12, 30)
	AddModifier(1, Male, 13, 30)
	AddPhoneme(1, Male, 0, 20)

	AddExpression(2, Male, 3, 100)
	AddModifier(2, Male, 11, 50)
	AddModifier(2, Male, 13, 40)
	AddPhoneme(2, Male, 2, 50)
	AddPhoneme(2, Male, 13, 20)
	AddPhoneme(2, Male, 15, 40)

	AddExpression(3, Male, 8, 100)
	AddModifier(3, Male, 0, 100)
	AddModifier(3, Male, 1, 100)
	AddModifier(3, Male, 2, 100)
	AddModifier(3, Male, 3, 100)
	AddModifier(3, Male, 4, 100)
	AddModifier(3, Male, 5, 100)
	AddPhoneme(3, Male, 2, 100)
	AddPhoneme(3, Male, 5, 40)

	AddExpression(4, Male, 9, 100)
	AddModifier(4, Male, 2, 100)
	AddModifier(4, Male, 3, 100)
	AddModifier(4, Male, 4, 100)
	AddModifier(4, Male, 5, 100)
	AddModifier(4, Male, 11, 90)
	AddPhoneme(4, Male, 0, 30)
	AddPhoneme(4, Male, 2, 30)

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
	AddExpression(1, Female, 0, 40)
	AddModifier(1, Female, 12, 30)
	AddModifier(1, Female, 13, 30)
	AddPhoneme(1, Female, 4, 40)

	AddExpression(2, Female, 0, 55)
	AddModifier(2, Female, 12, 50)
	AddModifier(2, Female, 13, 50)
	AddPhoneme(2, Female, 4, 40)

	AddExpression(3, Female, 0, 100)
	AddModifier(3, Female, 12, 65)
	AddModifier(3, Female, 13, 65)
	AddPhoneme(3, Female, 4, 50)
	AddPhoneme(3, Female, 3, 40)

	; Male
	AddExpression(1, Male, 0, 40)
	AddModifier(1, Male, 12, 30)
	AddModifier(1, Male, 13, 30)
	AddPhoneme(1, Male, 4, 40)

	AddExpression(2, Male, 0, 55)
	AddModifier(2, Male, 12, 50)
	AddModifier(2, Male, 13, 50)
	AddPhoneme(2, Male, 4, 40)

	AddExpression(3, Male, 0, 100)
	AddModifier(3, Male, 12, 65)
	AddModifier(3, Male, 13, 65)
	AddPhoneme(3, Male, 4, 50)
	AddPhoneme(3, Male, 3, 40)

	Save()
endFunction

function Happy(string eventName, string id, float argNum, form sender)
	Name = "Happy"

	AddTag("Happy")
	AddTag("Normal")

	AddTag("Consensual")

	; Female
	AddExpression(1, Female, 2, 50)
	AddModifier(1, Female, 12, 50)
	AddModifier(1, Female, 13, 50)
	AddPhoneme(1, Female, 5, 50)

	AddExpression(2, Female, 2, 70)
	AddModifier(2, Female, 12, 70)
	AddModifier(2, Female, 13, 70)
	AddPhoneme(2, Female, 5, 50)
	AddPhoneme(2, Female, 8, 50)

	AddExpression(3, Female, 2, 80)
	AddModifier(3, Female, 12, 80)
	AddModifier(3, Female, 13, 80)
	AddPhoneme(3, Female, 5, 50)
	AddPhoneme(3, Female, 11, 60)

	; Male
	AddExpression(1, Male, 2, 50)
	AddModifier(1, Male, 12, 50)
	AddModifier(1, Male, 13, 50)
	AddPhoneme(1, Male, 5, 50)

	AddExpression(2, Male, 2, 70)
	AddModifier(2, Male, 12, 70)
	AddModifier(2, Male, 13, 70)
	AddPhoneme(2, Male, 5, 50)
	AddPhoneme(2, Male, 8, 50)

	AddExpression(3, Male, 2, 80)
	AddModifier(3, Male, 12, 80)
	AddModifier(3, Male, 13, 80)
	AddPhoneme(3, Male, 5, 50)
	AddPhoneme(3, Male, 11, 60)

	Save()
endFunction

function Sad(string eventName, string id, float argNum, form sender)
	Name = "Sad"

	AddTag("Sad")
	AddTag("Normal")

	AddTag("Victim")

	; Female
	AddExpression(1, Female, 2, 50)
	AddModifier(1, Female, 12, 50)
	AddModifier(1, Female, 13, 50)
	AddPhoneme(1, Female, 5, 50)

	AddExpression(2, Female, 2, 70)
	AddModifier(2, Female, 12, 70)
	AddModifier(2, Female, 13, 70)
	AddPhoneme(2, Female, 5, 50)
	AddPhoneme(2, Female, 8, 50)

	AddExpression(3, Female, 2, 80)
	AddModifier(3, Female, 12, 80)
	AddModifier(3, Female, 13, 80)
	AddPhoneme(3, Female, 5, 50)
	AddPhoneme(3, Female, 11, 60)

	; Male
	AddExpression(1, Male, 2, 50)
	AddModifier(1, Male, 12, 50)
	AddModifier(1, Male, 13, 50)
	AddPhoneme(1, Male, 5, 50)

	AddExpression(2, Male, 2, 70)
	AddModifier(2, Male, 12, 70)
	AddModifier(2, Male, 13, 70)
	AddPhoneme(2, Male, 5, 50)
	AddPhoneme(2, Male, 8, 50)

	AddExpression(3, Male, 2, 80)
	AddModifier(3, Male, 12, 80)
	AddModifier(3, Male, 13, 80)
	AddPhoneme(3, Male, 5, 50)
	AddPhoneme(3, Male, 11, 60)

	Save()
endFunction

function Joy(string eventName, string id, float argNum, form sender)
	Name = "Joy"

	AddTag("Happy")
	AddTag("Normal")
	AddTag("Joy")
	AddTag("Pleasure")

	AddTag("Consensual")

	; Female
	AddExpression(1, Female, 10, 45)
	AddPhoneme(1, Female, 0, 30)
	AddPhoneme(1, Female, 7, 60)
	AddPhoneme(1, Female, 12, 60)
	AddModifier(1, Female, 0, 30)
	AddModifier(1, Female, 1, 30)
	AddModifier(1, Female, 4, 100)
	AddModifier(1, Female, 5, 100)
	AddModifier(1, Female, 12, 70)
	AddModifier(1, Female, 13, 70)

	SetModifiers(i0 = 30)

	AddExpression(2, Female, 10, 60)
	AddPhoneme(2, Female, 7, 100)
	AddPhoneme(2, Female, 15, 50)
	AddModifier(2, Female, 0, 30)
	AddModifier(2, Female, 1, 30)
	AddModifier(2, Female, 4, 100)
	AddModifier(2, Female, 5, 100)
	AddModifier(2, Female, 12, 70)
	AddModifier(2, Female, 13, 70)

	AddExpression(3, Female, 10, 60)
	AddPhoneme(3, Female, 7, 100)
	AddPhoneme(3, Female, 15, 50)
	AddModifier(3, Female, 0, 30)
	AddModifier(3, Female, 1, 30)
	AddModifier(3, Female, 4, 100)
	AddModifier(3, Female, 5, 100)
	AddModifier(3, Female, 12, 70)
	AddModifier(3, Female, 13, 70)

	AddExpression(4, Female, 10, 45)
	AddPhoneme(4, Female, 0, 10)
	AddPhoneme(4, Female, 6, 50)
	AddPhoneme(4, Female, 7, 50)
	AddModifier(4, Female, 0, 30)
	AddModifier(4, Female, 1, 30)
	AddModifier(4, Female, 2, 70)
	AddModifier(4, Female, 3, 70)
	AddModifier(4, Female, 4, 100)
	AddModifier(4, Female, 5, 100)
	AddModifier(4, Female, 12, 70)
	AddModifier(4, Female, 13, 70)

	AddExpression(5, Female, 10, 60)
	AddPhoneme(5, Female, 0, 60)
	AddPhoneme(5, Female, 6, 50)
	AddPhoneme(5, Female, 7, 50)
	AddModifier(5, Female, 0, 30)
	AddModifier(5, Female, 1, 30)
	AddModifier(5, Female, 2, 70)
	AddModifier(5, Female, 3, 70)
	AddModifier(5, Female, 4, 100)
	AddModifier(5, Female, 5, 100)
	AddModifier(5, Female, 12, 70)
	AddModifier(5, Female, 13, 70)

	; Male (copy of pleasure)
	AddExpression(1, Male, 13, 40)
	AddModifier(1, Male, 6, 20)
	AddModifier(1, Male, 7, 20)
	AddPhoneme(1, Male, 5, 20)

	AddExpression(2, Male, 8, 40)
	AddModifier(2, Male, 12, 40)
	AddModifier(2, Male, 13, 40)
	AddPhoneme(2, Male, 2, 50)
	AddPhoneme(2, Male, 13, 20)

	AddExpression(3, Male, 13, 80)
	AddModifier(3, Male, 6, 80)
	AddModifier(3, Male, 7, 80)
	AddModifier(3, Male, 12, 30)
	AddModifier(3, Male, 13, 30)
	AddPhoneme(3, Male, 0, 30)

	Save()
endFunction
