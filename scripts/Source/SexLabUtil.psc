scriptname SexLabUtil

bool function SexLabIsActive() global
	bool active
	int i
	while i < Game.GetModCount() && !active
		active = Game.GetModName(i) == "SexLab.esm"
		i += 1
	endWhile
	return active
endFunction

SexLabFramework function GetAPI() global
	if !SexLabIsActive()
		return none
	endIf
	return (Game.GetFormFromFile(0x0D62, "SexLab.esm") as Quest) as SexLabFramework
endFunction

int function StartSex(actor[] sexActors, sslBaseAnimation[] anims, actor victim = none, ObjectReference centerOn = none, bool allowBed = true, string hook = "") global
	SexLabFramework SexLab = GetAPI()
	if SexLab == none
		return -1
	endIf
	return SexLab.StartSex(sexActors, anims, victim, centerOn, allowBed, hook)
endFunction

sslThreadModel function NewThread(float timeout = 5.0) global
	SexLabFramework SexLab = GetAPI()
	if SexLab == none
		return none
	endIf
	return SexLab.NewThread(timeout)
endFunction
