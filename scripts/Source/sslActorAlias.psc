scriptname sslActorAlias extends ReferenceAlias

SexLabFramework property SexLab auto
sslSystemResources property Data auto
sslSystemConfig property Config auto


actor Position
sslThreadController Controller

; Actor Information
bool IsPlayer
bool IsVictim


function SetupActor()
endFunction

function SetupAlias(sslThreadController ThreadView)
	Position = GetReference() as actor
	Controller = ThreadView
endFunction

event OnPackageStart(package newPackage)
	Debug.Trace("Slotted actor "+GetActorRef())
endEvent

Event OnActivate(ObjectReference akActionRef)
	Debug.Trace("Activated by " + akActionRef)
EndEvent