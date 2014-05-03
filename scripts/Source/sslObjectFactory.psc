scriptname sslObjectFactory extends sslSystemLibrary

; ------------------------------------------------------- ;
; --- Readonly Flags                                  --- ;
; ------------------------------------------------------- ;

; Gender Types
int function Male() global
	return 0
endFunction
int function Female() global
	return 1
endFunction
int function MaleFemale() global
	return -1
endFunction
; Cum Types
int function Vaginal() global
	return 1
endFunction
int function Oral() global
	return 2
endFunction
int function Anal() global
	return 3
endFunction
int function VaginalOral() global
	return 4
endFunction
int function VaginalAnal() global
	return 5
endFunction
int function OralAnal() global
	return 6
endFunction
int function VaginalOralAnal() global
	return 7
endFunction
; Content Types
int function Misc() global
	return 0
endFunction
int function Sexual() global
	return 1
endFunction
int function Foreplay() global
	return 2
endFunction
; SFX Types
Sound function Squishing() global
	return Game.GetFormFromFile(0x65A31, "SexLab.esm") as Sound
endFunction
Sound function Sucking() global
	return Game.GetFormFromFile(0x65A32, "SexLab.esm") as Sound
endFunction
Sound function SexMix() global
	return Game.GetFormFromFile(0x65A33, "SexLab.esm") as Sound
endFunction
Sound function Squirting() global
	return Game.GetFormFromFile(0x65A34, "SexLab.esm") as Sound
endFunction
; MFG Types
int function Phoneme() global
	return 0
endFunction
int function Modifier() global
	return 16
endFunction
int function Expression() global
	return 30
endFunction

; ------------------------------------------------------- ;
; --- Ephemeral Animations                            --- ;
; ------------------------------------------------------- ;

string[] aids
sslBaseAnimation[] Animations

sslBaseAnimation[] function GetOwnerAnimations(Form Owner)
	bool[] Valid = new bool[64]
	int i = Animations.Length
	while i
		i -= 1
		Valid[i] = Animations[i] != none && Animations[i].Registered && Animations[i].Storage == Owner
	endWhile
	; Get list of valid Animations
	i = sslUtility.CountTrue(Valid)
	if i == 0
		return none ; OR empty array?
	endIf
	sslBaseAnimation[] Output = sslUtility.AnimationArray(i)
	int pos = Valid.Find(true)
	while pos != -1
		i -= 1
		Output[i] = Animations[pos]
		pos += 1
		if pos < 64
			pos = Valid.Find(true, pos)
		else
			pos = -1
		endIf
	endWhile
	return Output
endFunction

sslBaseAnimation function NewAnimation(string Token, Form Owner)
	if Token == "" || FindAnimation(Token) != -1 || Owner == none
		Log("NewAnimation("+Token+") - Failed to create animation - Invalid arguments given - Token given already exists ("+FindAnimation(Token)+") or was empty", "ERROR")
		return none
	endIf
	int i = aids.Find("")
	if i == -1
		Log("NewAnimation("+Token+") - Failed to create animation - unable to find a free animation slot", "ERROR")
		return none
	endIf
	aids[i] = Token
	Animations[i] = GetNthAlias(i) as sslBaseAnimation
	Animations[i].MakeEphemeral(Token, Owner)
	return Animations[i]
endFunction

sslBaseAnimation function GetSetAnimation(string Token, string Callback, Form Owner)
	sslBaseAnimation Slot = GetAnimation(Token)
	if Slot != none || Callback == ""
		Log("GET", "GetSetAnimation("+Token+")")
		return Slot
	endIf
	; Create new animation and send callback
	Slot = NewAnimation(Token, Owner)
	if Slot != none
		Log("SET", "GetSetAnimation("+Token+")")
		SendCallback(Callback, Animations.Find(Slot), Owner)
	endIf
	return Slot
endFunction

sslBaseAnimation function NewAnimationCopy(string Token, sslBaseAnimation CopyFrom, Form Owner)
	sslBaseAnimation Slot = NewAnimation(Token, Owner)
	if Slot != none
		Slot = CopyAnimation(Slot, CopyFrom)
		Slot.Save(Animations.Find(Slot))
	endIf
	return Slot
endFunction

sslBaseAnimation function GetAnimation(string Token)
	int i = FindAnimation(Token)
	if i < 0 || i >= Animations.Length
		return none
	endIf
	return Animations[i]
endFunction

int function FindAnimation(string Token)
	return aids.Find(Token)
endFunction

bool function HasAnimation(string Token)
	return aids.Find(Token) != -1
endFunction

bool function ReleaseAnimation(string Token)
	int i = FindAnimation(Token)
	if i != -1
		Animations[i].Initialize()
		Animations[i] = none
		aids[i] = ""
		return true
	endIf
	return false
endFunction

int function ReleaseOwnerAnimations(Form Owner)
	int Count
	if Owner != none
		int i = Animations.Length
		while i
			i -= 1
			if Animations[i] != none && Animations[i].Storage == Owner
				Count += 1
				ReleaseAnimation(i)
			endIf
		endWhile
	endIf
	return Count
endFunction

sslBaseAnimation function MakeAnimationRegistered(string Token)
	; Get the object to register
	if FindAnimation(Token) == -1
		return none
	endIf
	sslBaseAnimation Slot = GetAnimation(Token)
	; Make sure this isn't a duplicate and we have enough info to make it a global
	if (!Slot.IsCreature && AnimSlots.FindByRegistrar(Token) != -1) || (Slot.IsCreature && CreatureSlots.FindByRegistrar(Token) != -1)
		Log("MakeAnimationRegistered("+Token+") - Failed to create global animation - has duplicate registry token with another animation already registered globally", "ERROR")
		return none
	elseIf Slot.Name == ""
		Log("MakeAnimationRegistered("+Token+") - Failed to create global animation - has empty name, the name property must be set on the animation to be registered globally", "ERROR")
		return none
	elseIf Slot.GetTags().Length < 1
		Log("MakeAnimationRegistered("+Token+") - Failed to create global animation - has no tags set, atleast one searchable tag is required to be registered globally", "ERROR")
		return none
	endIf
	; Register as creature or normal
	int id
	sslBaseAnimation Anim
	if Slot.IsCreature
		id = CreatureSlots.Register(Token)
		Anim = CreatureSlots.GetBySlot(id)
	else
		id = AnimSlots.Register(Token)
		Anim = AnimSlots.GetBySlot(id)
	endIf
	; Failed to register
	if Anim == none
		Log("MakeAnimationRegistered("+Token+") - Failed to create global animation - was unable to claim a slot with the global registry", "ERROR")
		return none
	endIf
	; Copy phantom slot onto global slot
	Anim.Initialize()
	Anim.Registry = Token
	Anim = CopyAnimation(Anim, Slot)
	Anim.Save(id)
	ReleaseAnimation(Token)
	return Anim
endFunction

; ------------------------------------------------------- ;
; --- Ephemeral Voices                                --- ;
; ------------------------------------------------------- ;

string[] vids
sslBaseVoice[] Voices

sslBaseVoice[] function GetOwnerVoices(Form Owner)
	bool[] Valid = new bool[64]
	int i = Voices.Length
	while i
		i -= 1
		Valid[i] = Voices[i] != none && Voices[i].Registered && Voices[i].Storage == Owner
	endWhile
	; Get list of valid voices
	i = sslUtility.CountTrue(Valid)
	if i == 0
		return none ; OR empty array?
	endIf
	sslBaseVoice[] Output = sslUtility.VoiceArray(i)
	int pos = Valid.Find(true)
	while pos != -1
		i -= 1
		Output[i] = Voices[pos]
		pos += 1
		if pos < 64
			pos = Valid.Find(true, pos)
		else
			pos = -1
		endIf
	endWhile
	return Output
endFunction

sslBaseVoice function NewVoice(string Token, Form Owner)
	if Token == "" || FindVoice(Token) != -1 || Owner == none
		Log("NewVoice("+Token+") - Failed to create voice - Invalid arguments given - Token given already exists ("+FindVoice(Token)+") or was empty", "ERROR")
		return none
	endIf
	int i = vids.Find("")
	if i == -1
		Log("NewVoice("+Token+") - Failed to create voice - unable to find a free vpoce slot", "ERROR")
		return none
	endIf
	vids[i] = Token
	Voices[i] = GetNthAlias(i) as sslBaseVoice
	Voices[i].MakeEphemeral(Token, Owner)
	return Voices[i]
endFunction

sslBaseVoice function GetSetVoice(string Token, string Callback, Form Owner)
	sslBaseVoice Slot = GetVoice(Token)
	if Slot != none || Callback == ""
		Log("GET", "GetSetVoice("+Token+")")
		return Slot
	endIf
	; Create new voice and send callback
	Slot = NewVoice(Token, Owner)
	if Slot != none
		Log("SET", "GetSetVoice("+Token+")")
		SendCallback(Callback, Voices.Find(Slot), Owner)
	endIf
	return Slot
endFunction

sslBaseVoice function NewVoiceCopy(string Token, sslBaseVoice CopyFrom, Form Owner)
	sslBaseVoice Slot = NewVoice(Token, Owner)
	if Slot != none
		Slot = CopyVoice(Slot, CopyFrom)
		Slot.Save(Voices.Find(Slot))
	endIf
	return Slot
endFunction

sslBaseVoice function GetVoice(string Token)
	int i = FindVoice(Token)
	if i < 0 || i >= Voices.Length
		return none
	endIf
	return Voices[i]
endFunction

int function FindVoice(string Token)
	return vids.Find(Token)
endFunction

bool function HasVoice(string Token)
	return vids.Find(Token) != -1
endFunction

bool function ReleaseVoice(string Token)
	int i = FindVoice(Token)
	if i != -1
		Voices[i].Initialize()
		Voices[i] = none
		vids[i] = ""
		return true
	endIf
	return false
endFunction

int function ReleaseOwnerVoices(Form Owner)
	int Count
	if Owner != none
		int i = Voices.Length
		while i
			i -= 1
			if Voices[i] != none && Voices[i].Storage == Owner
				Count += 1
				ReleaseVoice(i)
			endIf
		endWhile
	endIf
	return Count
endFunction

sslBaseVoice function MakeVoiceRegistered(string Token)
	; Get the object to register
	if FindVoice(Token) == -1
		return none
	endIf
	sslBaseVoice Slot = GetVoice(Token)
	; Make sure this isn't a duplicate and we have enough info to make it a global
	if VoiceSlots.FindByRegistrar(Token) != -1
		Log("MakeVoiceRegistered("+Token+") - Failed to create global voice - has duplicate registry token with another voice already registered globally", "ERROR")
		return none
	elseIf Slot.Name == ""
		Log("MakeVoiceRegistered("+Token+") - Failed to create global voice - has empty name, the name property must be set on the voice to be registered globally", "ERROR")
		return none
	elseIf Slot.GetTags().Length < 1
		Log("MakeVoiceRegistered("+Token+") - Failed to create global voice - has no tags set, atleast one searchable tag is required to be registered globally", "ERROR")
		return none
	endIf
	; Register as creature or normal
	int id = VoiceSlots.Register(Token)
	sslBaseVoice Voice = VoiceSlots.GetBySlot(id)
	; Failed to register
	if Voice == none
		Log("MakeVoiceRegistered("+Token+") - Failed to create global Voice - was unable to claim a slot with the global registry", "ERROR")
		return none
	endIf
	; Copy phantom slot onto global slot
	Voice.Initialize()
	Voice.Registry = Token
	Voice = CopyVoice(Voice, Slot)
	Voice.Save(id)
	ReleaseVoice(Token)
	return Voice
endFunction


; ------------------------------------------------------- ;
; --- Ephemeral Expressions                           --- ;
; ------------------------------------------------------- ;

string[] eids
sslBaseExpression[] Expressions

sslBaseExpression[] function GetOwnerExpressions(Form Owner)
	bool[] Valid = new bool[64]
	int i = Expressions.Length
	while i
		i -= 1
		Valid[i] = Expressions[i] != none && Expressions[i].Registered && Expressions[i].Storage == Owner
	endWhile
	; Get list of valid Expressions
	i = sslUtility.CountTrue(Valid)
	if i == 0
		return none ; OR empty array?
	endIf
	sslBaseExpression[] Output = sslUtility.ExpressionArray(i)
	int pos = Valid.Find(true)
	while pos != -1
		i -= 1
		Output[i] = Expressions[pos]
		pos += 1
		if pos < 64
			pos = Valid.Find(true, pos)
		else
			pos = -1
		endIf
	endWhile
	return Output
endFunction
sslBaseExpression function NewExpression(string Token, Form Owner)
	if Token == "" || FindExpression(Token) != -1 || Owner == none
		Log("NewExpression("+Token+") - Failed to create Expression - Invalid arguments given - Token given already exists ("+FindExpression(Token)+") or was empty", "ERROR")
		return none
	endIf
	int i = eids.Find("")
	if i == -1
		Log("NewExpression("+Token+") - Failed to create Expression - unable to find a free vpoce slot", "ERROR")
		return none
	endIf
	eids[i] = Token
	Expressions[i] = GetNthAlias(i) as sslBaseExpression
	Expressions[i].MakeEphemeral(Token, Owner)
	return Expressions[i]
endFunction

sslBaseExpression function GetSetExpression(string Token, string Callback, Form Owner)
	sslBaseExpression Slot = GetExpression(Token)
	if Slot != none || Callback == ""
		Log("GET", "GetSetExpression("+Token+")")
		return Slot
	endIf
	; Create new Expression and send callback
	Slot = NewExpression(Token, Owner)
	if Slot != none
		Log("SET", "GetSetExpression("+Token+")")
		SendCallback(Callback, Expressions.Find(Slot), Owner)
	endIf
	return Slot
endFunction

sslBaseExpression function NewExpressionCopy(string Token, sslBaseExpression CopyFrom, Form Owner)
	sslBaseExpression Slot = NewExpression(Token, Owner)
	if Slot != none
		Slot = CopyExpression(Slot, CopyFrom)
		Slot.Save(Expressions.Find(Slot))
	endIf
	return Slot
endFunction

sslBaseExpression function GetExpression(string Token)
	int i = FindExpression(Token)
	if i < 0 || i >= Expressions.Length
		return none
	endIf
	return Expressions[i]
endFunction

int function FindExpression(string Token)
	return eids.Find(Token)
endFunction

bool function HasExpression(string Token)
	return eids.Find(Token) != -1
endFunction

bool function ReleaseExpression(string Token)
	int i = FindExpression(Token)
	if i != -1
		Expressions[i].Initialize()
		Expressions[i] = none
		eids[i] = ""
		return true
	endIf
	return false
endFunction

int function ReleaseOwnerExpressions(Form Owner)
	int Count
	if Owner != none
		int i = Expressions.Length
		while i
			i -= 1
			if Expressions[i] != none && Expressions[i].Storage == Owner
				Count += 1
				ReleaseExpression(i)
			endIf
		endWhile
	endIf
	return Count
endFunction

sslBaseExpression function MakeExpressionRegistered(string Token)
	; Get the object to register
	if FindExpression(Token) == -1
		return none
	endIf
	sslBaseExpression Slot = GetExpression(Token)
	; Make sure this isn't a duplicate and we have enough info to make it a global
	if ExpressionSlots.FindByRegistrar(Token) != -1
		Log("MakeExpressionRegistered("+Token+") - Failed to create global expression - has duplicate registry token with another expression already registered globally", "ERROR")
		return none
	elseIf Slot.Name == ""
		Log("MakeExpressionRegistered("+Token+") - Failed to create global expression - has empty name, the name property must be set on the expression to be registered globally", "ERROR")
		return none
	elseIf Slot.GetTags().Length < 1
		Log("MakeExpressionRegistered("+Token+") - Failed to create global expression - has no tags set, atleast one searchable tag is required to be registered globally", "ERROR")
		return none
	endIf
	; Register as creature or normal
	int id = ExpressionSlots.Register(Token)
	sslBaseExpression Expression = ExpressionSlots.GetBySlot(id)
	; Failed to register
	if Expression == none
		Log("MakeExpressionRegistered("+Token+") - Failed to create global expression - was unable to claim a slot with the global registry", "ERROR")
		return none
	endIf
	; Copy phantom slot onto global slot
	Expression.Initialize()
	Expression.Registry = Token
	Expression = CopyExpression(Expression, Slot)
	Expression.Save(id)
	ReleaseExpression(Token)
	return Expression
endFunction

; ------------------------------------------------------- ;
; --- System Use Only                                 --- ;
; ------------------------------------------------------- ;

function SendCallback(string Token, int Slot, Form CallbackForm = none, ReferenceAlias CallbackAlias = none) global
	if CallbackForm != none
		CallbackForm.RegisterForModEvent(Token, Token)
	endIf
	if CallbackAlias != none
		CallbackAlias.RegisterForModEvent(Token, Token)
	endIf
	int e = ModEvent.Create(Token)
	ModEvent.PushInt(e, Slot)
	ModEvent.Send(e)
	Utility.WaitMenuMode(0.2)
	if CallbackForm != none
		CallbackForm.UnregisterForModEvent(Token)
	endIf
	if CallbackAlias != none
		CallbackAlias.UnregisterForModEvent(Token)
	endIf
endFunction

function Cleanup()
	; Init slots if empty
	if aids.Length < 64
		aids = new string[64]
		Animations = new sslBaseAnimation[64]
	endIf
	if vids.Length < 64
		vids = new string[64]
		Voices = new sslBaseVoice[64]
	endIf
	if eids.Length < 64
		eids = new string[64]
		Expressions = new sslBaseExpression[64]
	endIf
	; Check for empty forms for storage to indicate owner has been disabled
	int i = Animations.Length
	while i
		i -= 1
		if Animations[i] != none && Animations[i].Registered && Animations[i].Storage == none
			Log("Clearing phantom animation ["+i+"] '"+aids[i]+"'")
			Animations[i].Initialize()
			Animations[i] = none
			aids[i] = ""
		endIf
		if Voices[i] != none && Voices[i].Registered && Voices[i].Storage == none
			Log("Clearing phantom voice ["+i+"] '"+vids[i]+"'")
			Voices[i].Initialize()
			Voices[i] = none
			vids[i] = ""
		endIf
		if Expressions[i] != none && Expressions[i].Registered && Expressions[i].Storage == none
			Log("Clearing phantom expression["+i+"] '"+eids[i]+"'")
			Expressions[i].Initialize()
			Expressions[i] = none
			eids[i] = ""
		endIf
	endWhile
endFunction

sslBaseAnimation function CopyAnimation(sslBaseAnimation Copy, sslBaseAnimation Orig)
	; Set info
	Copy.Name = Orig.Name
	Copy.SoundFX = Orig.SoundFX
	Copy.SetContent(Orig.IsSexual as int)
	Copy.AddTags(Orig.GetTags())
	; Loop positions
	int Position
	while Position < Orig.PositionCount
		; Add Position
		Copy.AddPosition(Orig.GetGender(Position), Orig.GetCum(Position))
		; Loop through stages
		int Stage
		while Stage < Orig.StageCount
			Stage += 1
			; Add stage
			float[] Offsets = Orig.GetRawOffsets(Position, Stage)
			Copy.AddPositionStage(Position, Orig.FetchPositionStage(Position, Stage), Offsets[0], Offsets[1], Offsets[2], Offsets[3], Orig.IsSilent(Position, Stage), Orig.UseOpenMouth(Position, Stage), Orig.UseStrapon(Position, Stage), Orig.AccessFlag(Position, Stage, 3))
		endWhile
		Position += 1
	endWhile
	; Return copied
	return Copy
endFunction

sslBaseVoice function CopyVoice(sslBaseVoice Copy, sslBaseVoice Orig)
	Copy.Name   = Orig.Name
	Copy.Gender = Orig.Gender
	Copy.Mild   = Orig.Mild
	Copy.Medium = Orig.Medium
	Copy.Hot    = Orig.Hot
	Copy.AddTags(Orig.GetTags())
	return Copy
endFunction

sslBaseExpression function CopyExpression(sslBaseExpression Copy, sslBaseExpression Orig)
	Copy.Name = Orig.Name
	Copy.AddTags(Orig.GetTags())
	int Gender
	while Gender <= 1
		int Phase
		while Phase < Orig.PhaseCounts[Gender]
			Phase += 1
			Copy.SetPhase(Phase, Gender, Orig.GetPhase(Phase, Gender))
		endWhile
		Gender += 1
	endWhile
	return Copy
endFunction
