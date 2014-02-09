scriptname sslActorAlias extends ReferenceAlias

sslActorLibrary property Lib auto
sslSystemConfig property Config auto

Actor property ActorRef auto hidden
sslThreadController Thread

int property Gender auto hidden
bool IsMale
bool IsFemale
bool IsCreature
bool IsPlayer
bool IsVictim
bool IsSilent
bool IsForcedSilent

ActorBase BaseRef
string ActorName

sslBaseVoice Voice


bool function PrepareAlias(Actor ProspectRef, bool MakeVictim = false, sslBaseVoice UseVoice = none, bool ForceSilence = false)
	if ProspectRef == none || GetReference() != ProspectRef || !Lib.ValidateActor(ProspectRef)
		return false ; Failed to set prospective actor into alias
	endIf
	; Register actor as active
	StorageUtil.FormListAdd(Lib, "Registry", ProspectRef, false)
	; Init actor alias information
	ActorRef = ProspectRef
	BaseRef = ActorRef.GetLeveledActorBase()
	ActorName = BaseRef.GetName()
	Gender = Lib.GetGender(ActorRef)
	IsMale = Gender == 0
	IsFemale = Gender == 1
	IsCreature = Gender == 2
	IsPlayer = ActorRef == Lib.PlayerRef
	IsForcedSilent = ForceSilence
	Voice = UseVoice
	IsVictim = MakeVictim
	if MakeVictim
		Thread.VictimRef = ActorRef
	endIf
	Thread.Log("ActorAlias has successfully slotted '"+ActorName+"'", self)
	return true
endFunction



function Initialize()
	UnregisterForUpdate()
	GoToState("")

	ActorRef = none
endFunction

event OnInit()
	Thread = (GetOwningQuest() as sslThreadController)
endEvent
