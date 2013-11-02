scriptname sslExpressionLibrary extends Quest

; Scripts
sslExpressionSlots property Slots auto

; Data
actor property PlayerRef auto

; Config


function MFG(actor ActorRef, int mode, int id, int value)
	if mode == 2
		ActorRef.SetExpressionOverride(id, value)
	else
		MfgConsoleFunc.SetPhonemeModifier(ActorRef, mode, id, value)
	endIf
endFunction

function ClearMFG(actor ActorRef)
	ActorRef.ClearExpressionOverride()
	MfgConsoleFunc.ResetPhonemeModifier(ActorRef)
endFunction

sslBaseExpression function PickExpression(actor a)
	return Slots.GetByName("Pleasure")
endFunction

function _Defaults()



endFunction
