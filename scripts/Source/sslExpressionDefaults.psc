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
	; Empty customizable expressions
	RegisterExpression("Custom1")
	RegisterExpression("Custom2")
	RegisterExpression("Custom3")
	RegisterExpression("Custom4")
	RegisterExpression("Custom5")

endFunction

function Pleasure(int id)
	sslBaseExpression Base = Create(id)

	Base.Name = "Pleasure"

	Base.AddTag("Happy")
	Base.AddTag("Normal")
	Base.AddTag("Pleasure")

	Base.AddTag("Consensual")

	; Female
	Base.AddMood(1, Female, 2, 30)
	Base.AddPhoneme(1, Female, 5, 30)
	Base.AddPhoneme(1, Female, 6, 10)

	Base.AddMood(2, Female, 10, 50)
	Base.AddModifier(2, Female, 4, 30)
	Base.AddModifier(2, Female, 5, 30)
	Base.AddModifier(2, Female, 6, 20)
	Base.AddModifier(2, Female, 7, 20)
	Base.AddPhoneme(2, Female, 0, 20)
	Base.AddPhoneme(2, Female, 3, 30)

	Base.AddMood(3, Female, 10, 70)
	Base.AddModifier(3, Female, 2, 50)
	Base.AddModifier(3, Female, 3, 50)
	Base.AddModifier(3, Female, 4, 30)
	Base.AddModifier(3, Female, 5, 30)
	Base.AddModifier(3, Female, 6, 70)
	Base.AddModifier(3, Female, 7, 40)
	Base.AddPhoneme(3, Female, 12, 30)
	Base.AddPhoneme(3, Female, 13, 10)

	Base.AddMood(4, Female, 10, 100)
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

	Base.AddMood(5, Female, 12, 60)
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
	Base.AddMood(1, Male, 13, 40)
	Base.AddModifier(1, Male, 6, 20)
	Base.AddModifier(1, Male, 7, 20)
	Base.AddPhoneme(1, Male, 5, 20)

	Base.AddMood(2, Male, 8, 40)
	Base.AddModifier(2, Male, 12, 40)
	Base.AddModifier(2, Male, 13, 40)
	Base.AddPhoneme(2, Male, 2, 50)
	Base.AddPhoneme(2, Male, 13, 20)

	Base.AddMood(3, Male, 13, 80)
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

	; Male + Female
	Base.AddMood(1, MaleFemale, 4, 90)
	Base.AddModifier(1, MaleFemale, 11, 20)
	Base.AddPhoneme(1, MaleFemale, 1, 10)
	Base.AddPhoneme(1, MaleFemale, 11, 10)

	Base.AddMood(2, MaleFemale, 3, 50)
	Base.AddModifier(2, MaleFemale, 8, 50)
	Base.AddModifier(2, MaleFemale, 9, 40)
	Base.AddModifier(2, MaleFemale, 12, 30)

	Base.AddMood(3, MaleFemale, 3, 50)
	Base.AddModifier(3, MaleFemale, 8, 50)
	Base.AddModifier(3, MaleFemale, 9, 40)
	Base.AddModifier(3, MaleFemale, 12, 30)
	Base.AddPhoneme(3, MaleFemale, 1, 10)
	Base.AddPhoneme(3, MaleFemale, 11, 10)

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

	; Male + Female
	Base.AddMood(1, MaleFemale, 3, 100)
	Base.AddModifier(1, MaleFemale, 2, 10)
	Base.AddModifier(1, MaleFemale, 3, 10)
	Base.AddModifier(1, MaleFemale, 6, 50)
	Base.AddModifier(1, MaleFemale, 7, 50)
	Base.AddModifier(1, MaleFemale, 1, 30)
	Base.AddModifier(1, MaleFemale, 12, 30)
	Base.AddModifier(1, MaleFemale, 13, 30)
	Base.AddPhoneme(1, MaleFemale, 0, 20)

	Base.AddMood(2, MaleFemale, 8, 100)
	Base.AddModifier(2, MaleFemale, 0, 100)
	Base.AddModifier(2, MaleFemale, 1, 100)
	Base.AddModifier(2, MaleFemale, 2, 100)
	Base.AddModifier(2, MaleFemale, 3, 100)
	Base.AddModifier(2, MaleFemale, 4, 100)
	Base.AddModifier(2, MaleFemale, 5, 100)
	Base.AddPhoneme(2, MaleFemale, 2, 100)
	Base.AddPhoneme(2, MaleFemale, 2, 100)
	Base.AddPhoneme(2, MaleFemale, 5, 40)

	Base.AddMood(3, MaleFemale, 3, 100)
	Base.AddModifier(3, MaleFemale, 11, 50)
	Base.AddModifier(3, MaleFemale, 13, 40)
	Base.AddPhoneme(3, MaleFemale, 2, 50)
	Base.AddPhoneme(3, MaleFemale, 13, 20)
	Base.AddPhoneme(3, MaleFemale, 15, 40)

	Base.AddMood(4, MaleFemale, 9, 100)
	Base.AddModifier(4, MaleFemale, 2, 100)
	Base.AddModifier(4, MaleFemale, 3, 100)
	Base.AddModifier(4, MaleFemale, 4, 100)
	Base.AddModifier(4, MaleFemale, 5, 100)
	Base.AddModifier(4, MaleFemale, 11, 90)
	Base.AddPhoneme(4, MaleFemale, 0, 30)
	Base.AddPhoneme(4, MaleFemale, 2, 30)


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

	; Male + Female
	Base.AddMood(1, MaleFemale, 3, 100)
	Base.AddModifier(1, MaleFemale, 2, 10)
	Base.AddModifier(1, MaleFemale, 3, 10)
	Base.AddModifier(1, MaleFemale, 6, 50)
	Base.AddModifier(1, MaleFemale, 7, 50)
	Base.AddModifier(1, MaleFemale, 1, 30)
	Base.AddModifier(1, MaleFemale, 12, 30)
	Base.AddModifier(1, MaleFemale, 13, 30)
	Base.AddPhoneme(1, MaleFemale, 0, 20)

	Base.AddMood(2, MaleFemale, 3, 100)
	Base.AddModifier(2, MaleFemale, 11, 50)
	Base.AddModifier(2, MaleFemale, 13, 40)
	Base.AddPhoneme(2, MaleFemale, 2, 50)
	Base.AddPhoneme(2, MaleFemale, 13, 20)
	Base.AddPhoneme(2, MaleFemale, 15, 40)

	Base.AddMood(3, MaleFemale, 8, 100)
	Base.AddModifier(3, MaleFemale, 0, 100)
	Base.AddModifier(3, MaleFemale, 1, 100)
	Base.AddModifier(3, MaleFemale, 2, 100)
	Base.AddModifier(3, MaleFemale, 3, 100)
	Base.AddModifier(3, MaleFemale, 4, 100)
	Base.AddModifier(3, MaleFemale, 5, 100)
	Base.AddPhoneme(3, MaleFemale, 2, 100)
	Base.AddPhoneme(3, MaleFemale, 5, 40)

	Base.AddMood(4, MaleFemale, 9, 100)
	Base.AddModifier(4, MaleFemale, 2, 100)
	Base.AddModifier(4, MaleFemale, 3, 100)
	Base.AddModifier(4, MaleFemale, 4, 100)
	Base.AddModifier(4, MaleFemale, 5, 100)
	Base.AddModifier(4, MaleFemale, 11, 90)
	Base.AddPhoneme(4, MaleFemale, 0, 30)
	Base.AddPhoneme(4, MaleFemale, 2, 30)

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

	; Male + Female
	Base.AddMood(1, MaleFemale, 0, 40)
	Base.AddModifier(1, MaleFemale, 12, 30)
	Base.AddModifier(1, MaleFemale, 13, 30)
	Base.AddPhoneme(1, MaleFemale, 4, 40)

	Base.AddMood(2, MaleFemale, 0, 55)
	Base.AddModifier(2, MaleFemale, 12, 50)
	Base.AddModifier(2, MaleFemale, 13, 50)
	Base.AddPhoneme(2, MaleFemale, 4, 40)

	Base.AddMood(3, MaleFemale, 0, 100)
	Base.AddModifier(3, MaleFemale, 12, 65)
	Base.AddModifier(3, MaleFemale, 13, 65)
	Base.AddPhoneme(3, MaleFemale, 4, 50)
	Base.AddPhoneme(3, MaleFemale, 3, 40)

	Base.Save(id)
endFunction

function Happy(int id)
	sslBaseExpression Base = Create(id)

	Base.Name = "Happy"

	Base.AddTag("Happy")
	Base.AddTag("Normal")

	Base.AddTag("Consensual")

	; Male + Female
	Base.AddMood(1, MaleFemale, 2, 50)
	Base.AddModifier(1, MaleFemale, 12, 50)
	Base.AddModifier(1, MaleFemale, 13, 50)
	Base.AddPhoneme(1, MaleFemale, 5, 50)

	Base.AddMood(2, MaleFemale, 2, 70)
	Base.AddModifier(2, MaleFemale, 12, 70)
	Base.AddModifier(2, MaleFemale, 13, 70)
	Base.AddPhoneme(2, MaleFemale, 5, 50)
	Base.AddPhoneme(2, MaleFemale, 8, 50)

	Base.AddMood(3, MaleFemale, 2, 80)
	Base.AddModifier(3, MaleFemale, 12, 80)
	Base.AddModifier(3, MaleFemale, 13, 80)
	Base.AddPhoneme(3, MaleFemale, 5, 50)
	Base.AddPhoneme(3, MaleFemale, 11, 60)

	Base.Save(id)
endFunction

function Sad(int id)
	sslBaseExpression Base = Create(id)

	Base.Name = "Sad"

	Base.AddTag("Sad")
	Base.AddTag("Normal")

	Base.AddTag("Victim")

	; Male + Female
	Base.AddMood(1, MaleFemale, 2, 50)
	Base.AddModifier(1, MaleFemale, 12, 50)
	Base.AddModifier(1, MaleFemale, 13, 50)
	Base.AddPhoneme(1, MaleFemale, 5, 50)

	Base.AddMood(2, MaleFemale, 2, 70)
	Base.AddModifier(2, MaleFemale, 12, 70)
	Base.AddModifier(2, MaleFemale, 13, 70)
	Base.AddPhoneme(2, MaleFemale, 5, 50)
	Base.AddPhoneme(2, MaleFemale, 8, 50)

	Base.AddMood(3, MaleFemale, 2, 80)
	Base.AddModifier(3, MaleFemale, 12, 80)
	Base.AddModifier(3, MaleFemale, 13, 80)
	Base.AddPhoneme(3, MaleFemale, 5, 50)
	Base.AddPhoneme(3, MaleFemale, 11, 60)

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
	Base.AddMood(1, Female, 10, 45)
	Base.AddPhoneme(1, Female, 0, 30)
	Base.AddPhoneme(1, Female, 7, 60)
	Base.AddPhoneme(1, Female, 12, 60)
	Base.AddModifier(1, Female, 0, 30)
	Base.AddModifier(1, Female, 1, 30)
	Base.AddModifier(1, Female, 4, 100)
	Base.AddModifier(1, Female, 5, 100)
	Base.AddModifier(1, Female, 12, 70)
	Base.AddModifier(1, Female, 13, 70)

	Base.AddMood(2, Female, 10, 60)
	Base.AddPhoneme(2, Female, 7, 100)
	Base.AddPhoneme(2, Female, 15, 50)
	Base.AddModifier(2, Female, 0, 30)
	Base.AddModifier(2, Female, 1, 30)
	Base.AddModifier(2, Female, 4, 100)
	Base.AddModifier(2, Female, 5, 100)
	Base.AddModifier(2, Female, 12, 70)
	Base.AddModifier(2, Female, 13, 70)

	Base.AddMood(3, Female, 10, 60)
	Base.AddPhoneme(3, Female, 7, 100)
	Base.AddPhoneme(3, Female, 15, 50)
	Base.AddModifier(3, Female, 0, 30)
	Base.AddModifier(3, Female, 1, 30)
	Base.AddModifier(3, Female, 4, 100)
	Base.AddModifier(3, Female, 5, 100)
	Base.AddModifier(3, Female, 12, 70)
	Base.AddModifier(3, Female, 13, 70)

	Base.AddMood(4, Female, 10, 45)
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

	Base.AddMood(5, Female, 10, 60)
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
	Base.AddMood(1, Male, 13, 40)
	Base.AddModifier(1, Male, 6, 20)
	Base.AddModifier(1, Male, 7, 20)
	Base.AddPhoneme(1, Male, 5, 20)

	Base.AddMood(2, Male, 8, 40)
	Base.AddModifier(2, Male, 12, 40)
	Base.AddModifier(2, Male, 13, 40)
	Base.AddPhoneme(2, Male, 2, 50)
	Base.AddPhoneme(2, Male, 13, 20)

	Base.AddMood(3, Male, 13, 80)
	Base.AddModifier(3, Male, 6, 80)
	Base.AddModifier(3, Male, 7, 80)
	Base.AddModifier(3, Male, 12, 30)
	Base.AddModifier(3, Male, 13, 30)
	Base.AddPhoneme(3, Male, 0, 30)

	Base.Save(id)
endFunction

function Custom1(int id)
	sslBaseExpression Base = Create(id)
	Base.Name = "Custom 1"
	Base.Enabled   = false
	Base.Save(id)
endFunction
function Custom2(int id)
	sslBaseExpression Base = Create(id)
	Base.Name = "Custom 2"
	Base.Enabled   = false
	Base.Save(id)
endFunction
function Custom3(int id)
	sslBaseExpression Base = Create(id)
	Base.Name = "Custom 3"
	Base.Enabled   = false
	Base.Save(id)
endFunction
function Custom4(int id)
	sslBaseExpression Base = Create(id)
	Base.Name = "Custom 4"
	Base.Enabled   = false
	Base.Save(id)
endFunction
function Custom5(int id)
	sslBaseExpression Base = Create(id)
	Base.Name = "Custom 5"
	Base.Enabled   = false
	Base.Save(id)
endFunction
