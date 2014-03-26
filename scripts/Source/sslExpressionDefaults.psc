scriptname sslExpressionDefaults extends sslExpressionFactory

function LoadExpressions()
	; Regsiter expressions
	RegisterExpression("Pleasure")
	RegisterExpression("Happy")
	RegisterExpression("Joy")
	RegisterExpression("Shy")
	RegisterExpression("Sad")
	RegisterExpression("Afraid")
	RegisterExpression("Pained")
	RegisterExpression("Angry")
endFunction

function Pleasure(int id)
	sslBaseExpression Base = Create(id)

	Base.Name = "Pleasure"

	Base.AddTag("Happy")
	Base.AddTag("Normal")
	Base.AddTag("Pleasure")

	Base.AddTag("Consensual")

	; Female
	Base.AddExpression(1, Female, 2, 30)
	Base.AddPhoneme(1, Female, 5, 30)
	Base.AddPhoneme(1, Female, 6, 10)

	Base.AddExpression(2, Female, 10, 50)
	Base.AddModifier(2, Female, 4, 30)
	Base.AddModifier(2, Female, 5, 30)
	Base.AddModifier(2, Female, 6, 20)
	Base.AddModifier(2, Female, 7, 20)
	Base.AddPhoneme(2, Female, 0, 20)
	Base.AddPhoneme(2, Female, 3, 30)

	Base.AddExpression(3, Female, 10, 70)
	Base.AddModifier(3, Female, 2, 50)
	Base.AddModifier(3, Female, 3, 50)
	Base.AddModifier(3, Female, 4, 30)
	Base.AddModifier(3, Female, 5, 30)
	Base.AddModifier(3, Female, 6, 70)
	Base.AddModifier(3, Female, 7, 40)
	Base.AddPhoneme(3, Female, 12, 30)
	Base.AddPhoneme(3, Female, 13, 10)

	Base.AddExpression(4, Female, 10, 100)
	Base.AddModifier(4, Female, 0, 10)
	Base.AddModifier(4, Female, 1, 10)
	Base.AddModifier(4, Female, 2, 25)
	Base.AddModifier(4, Female, 3, 25)
	Base.AddModifier(4, Female, 6, 100)
	Base.AddModifier(4, Female, 7, 100)
	Base.AddModifier(4, Female, 12, 30)
	Base.AddModifier(4, Female, 13, 30)
	Base.AddPhoneme(4, Female, 4, 35)
	Base.AddPhoneme(4, Female, 10, 20)
	Base.AddPhoneme(4, Female, 12, 30)

	Base.AddExpression(5, Female, 12, 60)
	Base.AddModifier(5, Female, 0, 15)
	Base.AddModifier(5, Female, 1, 15)
	Base.AddModifier(5, Female, 2, 25)
	Base.AddModifier(5, Female, 3, 25)
	Base.AddModifier(5, Female, 4, 60)
	Base.AddModifier(5, Female, 5, 60)
	Base.AddModifier(5, Female, 11, 100)
	Base.AddModifier(5, Female, 12, 70)
	Base.AddModifier(5, Female, 13, 30)
	Base.AddPhoneme(5, Female, 0, 40)
	Base.AddPhoneme(5, Female, 5, 20)
	Base.AddPhoneme(5, Female, 12, 80)
	Base.AddPhoneme(5, Female, 15, 20)

	; Male
	Base.AddExpression(1, Male, 13, 40)
	Base.AddModifier(1, Male, 6, 20)
	Base.AddModifier(1, Male, 7, 20)
	Base.AddPhoneme(1, Male, 5, 20)

	Base.AddExpression(2, Male, 8, 40)
	Base.AddModifier(2, Male, 12, 40)
	Base.AddModifier(2, Male, 13, 40)
	Base.AddPhoneme(2, Male, 2, 50)
	Base.AddPhoneme(2, Male, 13, 20)

	Base.AddExpression(3, Male, 13, 80)
	Base.AddModifier(3, Male, 6, 80)
	Base.AddModifier(3, Male, 7, 80)
	Base.AddModifier(3, Male, 12, 30)
	Base.AddModifier(3, Male, 13, 30)
	Base.AddPhoneme(3, Male, 0, 30)

	Base.Save(id)
endFunction

function Shy(int id)
	sslBaseExpression Base = Create(id)

	Base.Name = "Shy"

	Base.AddTag("Normal")
	Base.AddTag("Nervous")
	Base.AddTag("Sad")
	Base.AddTag("Shy")

	Base.AddTag("Consensual")

	; Female
	Base.AddExpression(1, Female, 4, 90)
	Base.AddModifier(1, Female, 11, 20)
	Base.AddPhoneme(1, Female, 1, 10)
	Base.AddPhoneme(1, Female, 11, 10)

	Base.AddExpression(2, Female, 3, 50)
	Base.AddModifier(2, Female, 8, 50)
	Base.AddModifier(2, Female, 9, 40)
	Base.AddModifier(2, Female, 12, 30)

	Base.AddExpression(3, Female, 3, 50)
	Base.AddModifier(3, Female, 8, 50)
	Base.AddModifier(3, Female, 9, 40)
	Base.AddModifier(3, Female, 12, 30)
	Base.AddPhoneme(3, Female, 1, 10)
	Base.AddPhoneme(3, Female, 11, 10)

	; Male
	Base.AddExpression(1, Male, 4, 90)
	Base.AddModifier(1, Male, 11, 20)
	Base.AddPhoneme(1, Male, 1, 10)
	Base.AddPhoneme(1, Male, 11, 10)

	Base.AddExpression(2, Male, 3, 50)
	Base.AddModifier(2, Male, 8, 50)
	Base.AddModifier(2, Male, 9, 40)
	Base.AddModifier(2, Male, 12, 30)

	Base.AddExpression(3, Male, 3, 50)
	Base.AddModifier(3, Male, 8, 50)
	Base.AddModifier(3, Male, 9, 40)
	Base.AddModifier(3, Male, 12, 30)
	Base.AddPhoneme(3, Male, 1, 10)
	Base.AddPhoneme(3, Male, 11, 10)

	Base.Save(id)
endFunction

function Afraid(int id)
	sslBaseExpression Base = Create(id)

	Base.Name = "Afraid"

	Base.AddTag("Afraid")
	Base.AddTag("Scared")
	Base.AddTag("Pain")
	Base.AddTag("Negative")

	Base.AddTag("Aggressor")

	; Female
	Base.AddExpression(1, Female, 3, 100)
	Base.AddModifier(1, Female, 2, 10)
	Base.AddModifier(1, Female, 3, 10)
	Base.AddModifier(1, Female, 6, 50)
	Base.AddModifier(1, Female, 7, 50)
	Base.AddModifier(1, Female, 1, 30)
	Base.AddModifier(1, Female, 12, 30)
	Base.AddModifier(1, Female, 13, 30)
	Base.AddPhoneme(1, Female, 0, 20)

	Base.AddExpression(2, Female, 8, 100)
	Base.AddModifier(2, Female, 0, 100)
	Base.AddModifier(2, Female, 1, 100)
	Base.AddModifier(2, Female, 2, 100)
	Base.AddModifier(2, Female, 3, 100)
	Base.AddModifier(2, Female, 4, 100)
	Base.AddModifier(2, Female, 5, 100)
	Base.AddPhoneme(2, Female, 2, 100)
	Base.AddPhoneme(2, Female, 2, 100)
	Base.AddPhoneme(2, Female, 5, 40)

	Base.AddExpression(3, Female, 3, 100)
	Base.AddModifier(3, Female, 11, 50)
	Base.AddModifier(3, Female, 13, 40)
	Base.AddPhoneme(3, Female, 2, 50)
	Base.AddPhoneme(3, Female, 13, 20)
	Base.AddPhoneme(3, Female, 15, 40)

	Base.AddExpression(4, Female, 9, 100)
	Base.AddModifier(4, Female, 2, 100)
	Base.AddModifier(4, Female, 3, 100)
	Base.AddModifier(4, Female, 4, 100)
	Base.AddModifier(4, Female, 5, 100)
	Base.AddModifier(4, Female, 11, 90)
	Base.AddPhoneme(4, Female, 0, 30)
	Base.AddPhoneme(4, Female, 2, 30)

	; Male
	Base.AddExpression(1, Male, 3, 100)
	Base.AddModifier(1, Male, 2, 10)
	Base.AddModifier(1, Male, 3, 10)
	Base.AddModifier(1, Male, 6, 50)
	Base.AddModifier(1, Male, 7, 50)
	Base.AddModifier(1, Male, 1, 30)
	Base.AddModifier(1, Male, 12, 30)
	Base.AddModifier(1, Male, 13, 30)
	Base.AddPhoneme(1, Male, 0, 20)

	Base.AddExpression(2, Male, 8, 100)
	Base.AddModifier(2, Male, 0, 100)
	Base.AddModifier(2, Male, 1, 100)
	Base.AddModifier(2, Male, 2, 100)
	Base.AddModifier(2, Male, 3, 100)
	Base.AddModifier(2, Male, 4, 100)
	Base.AddModifier(2, Male, 5, 100)
	Base.AddPhoneme(2, Male, 2, 100)
	Base.AddPhoneme(2, Male, 2, 100)
	Base.AddPhoneme(2, Male, 5, 40)

	Base.AddExpression(3, Male, 3, 100)
	Base.AddModifier(3, Male, 11, 50)
	Base.AddModifier(3, Male, 13, 40)
	Base.AddPhoneme(3, Male, 2, 50)
	Base.AddPhoneme(3, Male, 13, 20)
	Base.AddPhoneme(3, Male, 15, 40)

	Base.AddExpression(4, Male, 9, 100)
	Base.AddModifier(4, Male, 2, 100)
	Base.AddModifier(4, Male, 3, 100)
	Base.AddModifier(4, Male, 4, 100)
	Base.AddModifier(4, Male, 5, 100)
	Base.AddModifier(4, Male, 11, 90)
	Base.AddPhoneme(4, Male, 0, 30)
	Base.AddPhoneme(4, Male, 2, 30)

	Base.Save(id)
endFunction


function Pained(int id)
	sslBaseExpression Base = Create(id)

	Base.Name = "Pained"

	Base.AddTag("Afraid")
	Base.AddTag("Pain")
	Base.AddTag("Pained")
	Base.AddTag("Negative")

	Base.AddTag("Victim")

	; Female
	Base.AddExpression(1, Female, 3, 100)
	Base.AddModifier(1, Female, 2, 10)
	Base.AddModifier(1, Female, 3, 10)
	Base.AddModifier(1, Female, 6, 50)
	Base.AddModifier(1, Female, 7, 50)
	Base.AddModifier(1, Female, 1, 30)
	Base.AddModifier(1, Female, 12, 30)
	Base.AddModifier(1, Female, 13, 30)
	Base.AddPhoneme(1, Female, 0, 20)

	Base.AddExpression(2, Female, 3, 100)
	Base.AddModifier(2, Female, 11, 50)
	Base.AddModifier(2, Female, 13, 40)
	Base.AddPhoneme(2, Female, 2, 50)
	Base.AddPhoneme(2, Female, 13, 20)
	Base.AddPhoneme(2, Female, 15, 40)

	Base.AddExpression(3, Female, 8, 100)
	Base.AddModifier(3, Female, 0, 100)
	Base.AddModifier(3, Female, 1, 100)
	Base.AddModifier(3, Female, 2, 100)
	Base.AddModifier(3, Female, 3, 100)
	Base.AddModifier(3, Female, 4, 100)
	Base.AddModifier(3, Female, 5, 100)
	Base.AddPhoneme(3, Female, 2, 100)
	Base.AddPhoneme(3, Female, 5, 40)

	Base.AddExpression(4, Female, 9, 100)
	Base.AddModifier(4, Female, 2, 100)
	Base.AddModifier(4, Female, 3, 100)
	Base.AddModifier(4, Female, 4, 100)
	Base.AddModifier(4, Female, 5, 100)
	Base.AddModifier(4, Female, 11, 90)
	Base.AddPhoneme(4, Female, 0, 30)
	Base.AddPhoneme(4, Female, 2, 30)

	; Male
	Base.AddExpression(1, Male, 3, 100)
	Base.AddModifier(1, Male, 2, 10)
	Base.AddModifier(1, Male, 3, 10)
	Base.AddModifier(1, Male, 6, 50)
	Base.AddModifier(1, Male, 7, 50)
	Base.AddModifier(1, Male, 1, 30)
	Base.AddModifier(1, Male, 12, 30)
	Base.AddModifier(1, Male, 13, 30)
	Base.AddPhoneme(1, Male, 0, 20)

	Base.AddExpression(2, Male, 3, 100)
	Base.AddModifier(2, Male, 11, 50)
	Base.AddModifier(2, Male, 13, 40)
	Base.AddPhoneme(2, Male, 2, 50)
	Base.AddPhoneme(2, Male, 13, 20)
	Base.AddPhoneme(2, Male, 15, 40)

	Base.AddExpression(3, Male, 8, 100)
	Base.AddModifier(3, Male, 0, 100)
	Base.AddModifier(3, Male, 1, 100)
	Base.AddModifier(3, Male, 2, 100)
	Base.AddModifier(3, Male, 3, 100)
	Base.AddModifier(3, Male, 4, 100)
	Base.AddModifier(3, Male, 5, 100)
	Base.AddPhoneme(3, Male, 2, 100)
	Base.AddPhoneme(3, Male, 5, 40)

	Base.AddExpression(4, Male, 9, 100)
	Base.AddModifier(4, Male, 2, 100)
	Base.AddModifier(4, Male, 3, 100)
	Base.AddModifier(4, Male, 4, 100)
	Base.AddModifier(4, Male, 5, 100)
	Base.AddModifier(4, Male, 11, 90)
	Base.AddPhoneme(4, Male, 0, 30)
	Base.AddPhoneme(4, Male, 2, 30)

	Base.Save(id)
endFunction

function Angry(int id)
	sslBaseExpression Base = Create(id)

	Base.Name = "Angry"

	Base.AddTag("Mad")
	Base.AddTag("Angry")
	Base.AddTag("Upset")

	Base.AddTag("Aggressor")
	Base.AddTag("Victim")

	; Female
	Base.AddExpression(1, Female, 0, 40)
	Base.AddModifier(1, Female, 12, 30)
	Base.AddModifier(1, Female, 13, 30)
	Base.AddPhoneme(1, Female, 4, 40)

	Base.AddExpression(2, Female, 0, 55)
	Base.AddModifier(2, Female, 12, 50)
	Base.AddModifier(2, Female, 13, 50)
	Base.AddPhoneme(2, Female, 4, 40)

	Base.AddExpression(3, Female, 0, 100)
	Base.AddModifier(3, Female, 12, 65)
	Base.AddModifier(3, Female, 13, 65)
	Base.AddPhoneme(3, Female, 4, 50)
	Base.AddPhoneme(3, Female, 3, 40)

	; Male
	Base.AddExpression(1, Male, 0, 40)
	Base.AddModifier(1, Male, 12, 30)
	Base.AddModifier(1, Male, 13, 30)
	Base.AddPhoneme(1, Male, 4, 40)

	Base.AddExpression(2, Male, 0, 55)
	Base.AddModifier(2, Male, 12, 50)
	Base.AddModifier(2, Male, 13, 50)
	Base.AddPhoneme(2, Male, 4, 40)

	Base.AddExpression(3, Male, 0, 100)
	Base.AddModifier(3, Male, 12, 65)
	Base.AddModifier(3, Male, 13, 65)
	Base.AddPhoneme(3, Male, 4, 50)
	Base.AddPhoneme(3, Male, 3, 40)

	Base.Save(id)
endFunction

function Happy(int id)
	sslBaseExpression Base = Create(id)

	Base.Name = "Happy"

	Base.AddTag("Happy")
	Base.AddTag("Normal")

	Base.AddTag("Consensual")

	; Female
	Base.AddExpression(1, Female, 2, 50)
	Base.AddModifier(1, Female, 12, 50)
	Base.AddModifier(1, Female, 13, 50)
	Base.AddPhoneme(1, Female, 5, 50)

	Base.AddExpression(2, Female, 2, 70)
	Base.AddModifier(2, Female, 12, 70)
	Base.AddModifier(2, Female, 13, 70)
	Base.AddPhoneme(2, Female, 5, 50)
	Base.AddPhoneme(2, Female, 8, 50)

	Base.AddExpression(3, Female, 2, 80)
	Base.AddModifier(3, Female, 12, 80)
	Base.AddModifier(3, Female, 13, 80)
	Base.AddPhoneme(3, Female, 5, 50)
	Base.AddPhoneme(3, Female, 11, 60)

	; Male
	Base.AddExpression(1, Male, 2, 50)
	Base.AddModifier(1, Male, 12, 50)
	Base.AddModifier(1, Male, 13, 50)
	Base.AddPhoneme(1, Male, 5, 50)

	Base.AddExpression(2, Male, 2, 70)
	Base.AddModifier(2, Male, 12, 70)
	Base.AddModifier(2, Male, 13, 70)
	Base.AddPhoneme(2, Male, 5, 50)
	Base.AddPhoneme(2, Male, 8, 50)

	Base.AddExpression(3, Male, 2, 80)
	Base.AddModifier(3, Male, 12, 80)
	Base.AddModifier(3, Male, 13, 80)
	Base.AddPhoneme(3, Male, 5, 50)
	Base.AddPhoneme(3, Male, 11, 60)

	Base.Save(id)
endFunction

function Sad(int id)
	sslBaseExpression Base = Create(id)

	Base.Name = "Sad"

	Base.AddTag("Sad")
	Base.AddTag("Normal")

	Base.AddTag("Victim")

	; Female
	Base.AddExpression(1, Female, 2, 50)
	Base.AddModifier(1, Female, 12, 50)
	Base.AddModifier(1, Female, 13, 50)
	Base.AddPhoneme(1, Female, 5, 50)

	Base.AddExpression(2, Female, 2, 70)
	Base.AddModifier(2, Female, 12, 70)
	Base.AddModifier(2, Female, 13, 70)
	Base.AddPhoneme(2, Female, 5, 50)
	Base.AddPhoneme(2, Female, 8, 50)

	Base.AddExpression(3, Female, 2, 80)
	Base.AddModifier(3, Female, 12, 80)
	Base.AddModifier(3, Female, 13, 80)
	Base.AddPhoneme(3, Female, 5, 50)
	Base.AddPhoneme(3, Female, 11, 60)

	; Male
	Base.AddExpression(1, Male, 2, 50)
	Base.AddModifier(1, Male, 12, 50)
	Base.AddModifier(1, Male, 13, 50)
	Base.AddPhoneme(1, Male, 5, 50)

	Base.AddExpression(2, Male, 2, 70)
	Base.AddModifier(2, Male, 12, 70)
	Base.AddModifier(2, Male, 13, 70)
	Base.AddPhoneme(2, Male, 5, 50)
	Base.AddPhoneme(2, Male, 8, 50)

	Base.AddExpression(3, Male, 2, 80)
	Base.AddModifier(3, Male, 12, 80)
	Base.AddModifier(3, Male, 13, 80)
	Base.AddPhoneme(3, Male, 5, 50)
	Base.AddPhoneme(3, Male, 11, 60)

	Base.Save(id)
endFunction

function Joy(int id)
	sslBaseExpression Base = Create(id)

	Base.Name = "Joy"

	Base.AddTag("Happy")
	Base.AddTag("Normal")
	Base.AddTag("Joy")
	Base.AddTag("Pleasure")

	Base.AddTag("Consensual")

	; Female
	Base.AddExpression(1, Female, 10, 45)
	Base.AddPhoneme(1, Female, 0, 30)
	Base.AddPhoneme(1, Female, 7, 60)
	Base.AddPhoneme(1, Female, 12, 60)
	Base.AddModifier(1, Female, 0, 30)
	Base.AddModifier(1, Female, 1, 30)
	Base.AddModifier(1, Female, 4, 100)
	Base.AddModifier(1, Female, 5, 100)
	Base.AddModifier(1, Female, 12, 70)
	Base.AddModifier(1, Female, 13, 70)

	Base.AddExpression(2, Female, 10, 60)
	Base.AddPhoneme(2, Female, 7, 100)
	Base.AddPhoneme(2, Female, 15, 50)
	Base.AddModifier(2, Female, 0, 30)
	Base.AddModifier(2, Female, 1, 30)
	Base.AddModifier(2, Female, 4, 100)
	Base.AddModifier(2, Female, 5, 100)
	Base.AddModifier(2, Female, 12, 70)
	Base.AddModifier(2, Female, 13, 70)

	Base.AddExpression(3, Female, 10, 60)
	Base.AddPhoneme(3, Female, 7, 100)
	Base.AddPhoneme(3, Female, 15, 50)
	Base.AddModifier(3, Female, 0, 30)
	Base.AddModifier(3, Female, 1, 30)
	Base.AddModifier(3, Female, 4, 100)
	Base.AddModifier(3, Female, 5, 100)
	Base.AddModifier(3, Female, 12, 70)
	Base.AddModifier(3, Female, 13, 70)

	Base.AddExpression(4, Female, 10, 45)
	Base.AddPhoneme(4, Female, 0, 10)
	Base.AddPhoneme(4, Female, 6, 50)
	Base.AddPhoneme(4, Female, 7, 50)
	Base.AddModifier(4, Female, 0, 30)
	Base.AddModifier(4, Female, 1, 30)
	Base.AddModifier(4, Female, 2, 70)
	Base.AddModifier(4, Female, 3, 70)
	Base.AddModifier(4, Female, 4, 100)
	Base.AddModifier(4, Female, 5, 100)
	Base.AddModifier(4, Female, 12, 70)
	Base.AddModifier(4, Female, 13, 70)

	Base.AddExpression(5, Female, 10, 60)
	Base.AddPhoneme(5, Female, 0, 60)
	Base.AddPhoneme(5, Female, 6, 50)
	Base.AddPhoneme(5, Female, 7, 50)
	Base.AddModifier(5, Female, 0, 30)
	Base.AddModifier(5, Female, 1, 30)
	Base.AddModifier(5, Female, 2, 70)
	Base.AddModifier(5, Female, 3, 70)
	Base.AddModifier(5, Female, 4, 100)
	Base.AddModifier(5, Female, 5, 100)
	Base.AddModifier(5, Female, 12, 70)
	Base.AddModifier(5, Female, 13, 70)

	; Male (copy of pleasure)
	Base.AddExpression(1, Male, 13, 40)
	Base.AddModifier(1, Male, 6, 20)
	Base.AddModifier(1, Male, 7, 20)
	Base.AddPhoneme(1, Male, 5, 20)

	Base.AddExpression(2, Male, 8, 40)
	Base.AddModifier(2, Male, 12, 40)
	Base.AddModifier(2, Male, 13, 40)
	Base.AddPhoneme(2, Male, 2, 50)
	Base.AddPhoneme(2, Male, 13, 20)

	Base.AddExpression(3, Male, 13, 80)
	Base.AddModifier(3, Male, 6, 80)
	Base.AddModifier(3, Male, 7, 80)
	Base.AddModifier(3, Male, 12, 30)
	Base.AddModifier(3, Male, 13, 30)
	Base.AddPhoneme(3, Male, 0, 30)

	Base.Save(id)
endFunction
