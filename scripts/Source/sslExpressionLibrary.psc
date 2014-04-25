scriptname sslExpressionLibrary extends sslSystemLibrary
{DEPRECATED: This script is no longer used in any sexlab systems, and is only provided as a means to provide backwards compatibility by redirecting all it's functions to their new iterations}

sslExpressionSlots property Slots hidden
	sslExpressionSlots function get()
		return SexLabUtil.GetAPI().ExpressionSlots
	endFunction
endProperty
bool property Male = false autoreadonly hidden
bool property Female = true autoreadonly hidden
int property Phoneme = 0 autoreadonly hidden
int property Modifier = 1 autoreadonly hidden
int property Expression = 2 autoreadonly hidden
function OpenMouth(Actor ActorRef) global
	sslBaseExpression.OpenMouth(ActorRef)
endFunction
function CloseMouth(Actor ActorRef) global
	sslBaseExpression.CloseMouth(ActorRef)
endFunction
bool function IsMouthOpen(Actor ActorRef) global
	return sslBaseExpression.IsMouthOpen(ActorRef)
endFunction
function ClearMFG(Actor ActorRef) global
	sslBaseExpression.ClearMFG(ActorRef)
endFunction
function ClearPhoneme(Actor ActorRef) global
	sslBaseExpression.ClearPhoneme(ActorRef)
endFunction
function ClearModifier(Actor ActorRef) global
	sslBaseExpression.ClearModifier(ActorRef)
endFunction
sslBaseExpression function PickExpression(Actor ActorRef, Actor VictimRef = none)
	return Slots.PickExpression(ActorRef, VictimRef)
endFunction
function MFG(Actor ActorRef, int mode, int id, int value) global
	; No longer used
endFunction
function ApplyPreset(int[] Presets, Actor ActorRef, bool OpenMouth = false) global
	sslBaseExpression.ApplyPreset(ActorRef, Presets)
	if OpenMouth
		sslBaseExpression.OpenMouth(ActorRef)
	endIf
endFunction
function _Defaults()
	; No longer used
endFunction
function _Export()
	; No longer used
endFunction
function _Import()
	; No longer used
endFunction

