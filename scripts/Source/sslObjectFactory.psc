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
int function Creature() global
	return 2
endFunction
int function CreatureMale() global
	return 2
endFunction
int function CreatureFemale() global
	return 3
endFunction
; CumID Types
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

int ASlotted
string[] ATokens
sslBaseAnimation[] Animations

sslBaseAnimation[] function GetOwnerAnimations(Form Owner)
	bool[] Valid = Utility.CreateBoolArray(ASlotted)
	int i = ASlotted
	while i
		i -= 1
		Valid[i] = Animations[i] && Animations[i].Registered && Animations[i].Storage == Owner
	endWhile
	; Get list of valid Animations
	i = PapyrusUtil.CountBool(Valid, true)
	if i == 0
		return none ; OR empty array?
	endIf
	sslBaseAnimation[] Output = sslUtility.AnimationArray(i)
	int pos = Valid.Find(true)
	while pos != -1
		i -= 1
		Output[i] = Animations[pos]
		pos += 1
		if pos < ASlotted
			pos = Valid.Find(true, pos)
		else
			pos = -1
		endIf
	endWhile
	return Output
endFunction

sslBaseAnimation function NewAnimation(string Token, Form Owner)
	if !Owner || Token == "" || FindAnimation(Token) != -1
		Log("NewAnimation("+Token+") - Failed to create animation - Invalid arguments given - Token given already exists ("+FindAnimation(Token)+") or was empty", "ERROR")
		return none
	endIf
	int i = ATokens.Find("")
	if i == -1
		Log("NewAnimation("+Token+") - Failed to create animation - unable to find a free animation slot", "ERROR")
		return none
	endIf
	ATokens[i] = Token
	if i >= ASlotted
		ASlotted += 1
	endIf
	Animations[i] = GetNthAlias(i) as sslBaseAnimation
	Animations[i].MakeEphemeral(Token, Owner)
	return Animations[i]
endFunction

sslBaseAnimation function GetSetAnimation(string Token, string Callback, Form Owner)
	sslBaseAnimation Slot = GetAnimation(Token)
	if Slot || Callback == ""
		Log("GET", "GetSetAnimation("+Token+")")
		return Slot
	endIf
	; Create new animation and send callback
	Slot = NewAnimation(Token, Owner)
	if Slot
		Log("SET", "GetSetAnimation("+Token+")")
		SendCallback(Callback, Animations.Find(Slot), Owner)
	endIf
	return Slot
endFunction

sslBaseAnimation function NewAnimationCopy(string Token, sslBaseAnimation CopyFrom, Form Owner)
	sslBaseAnimation Slot = NewAnimation(Token, Owner)
	if Slot
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
	return ATokens.Find(Token)
endFunction

bool function HasAnimation(string Token)
	return ATokens.Find(Token) != -1
endFunction

bool function ReleaseAnimation(string Token)
	int i = FindAnimation(Token)
	if i != -1
		Animations[i].Initialize()
		Animations[i] = none
		ATokens[i] = ""
		return true
	endIf
	return false
endFunction

int function ReleaseOwnerAnimations(Form Owner)
	int Count
	if Owner
		int i = Animations.Length
		while i
			i -= 1
			if Animations[i] && Animations[i].Storage == Owner
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
		id   = CreatureSlots.Register(Token)
		Anim = CreatureSlots.GetBySlot(id)
	else
		id   = AnimSlots.Register(Token)
		Anim = AnimSlots.GetBySlot(id)
	endIf
	; Failed to register
	if !Anim
		Log("MakeAnimationRegistered("+Token+") - Failed to create global animation - was unable to claim a slot with the global registry", "ERROR")
		return none
	endIf
	; Copy phantom slot onto global slot
	Anim.Initialize()
	Anim.Registry = Token
	Anim.Enabled  = true
	Anim = CopyAnimation(Anim, Slot)
	Anim.Save(id)
	ReleaseAnimation(Token)
	return Anim
endFunction

; ------------------------------------------------------- ;
; --- Ephemeral Voices                                --- ;
; ------------------------------------------------------- ;

int VSlotted
string[] VTokens
sslBaseVoice[] Voices

sslBaseVoice[] function GetOwnerVoices(Form Owner)
	bool[] Valid = Utility.CreateBoolArray(VSlotted)
	int i = VSlotted
	while i
		i -= 1
		Valid[i] = Voices[i] && Voices[i].Registered && Voices[i].Storage == Owner
	endWhile
	; Get list of valid voices
	i = PapyrusUtil.CountBool(Valid, true)
	if i == 0
		return none ; OR empty array?
	endIf
	sslBaseVoice[] Output = sslUtility.VoiceArray(i)
	int pos = Valid.Find(true)
	while pos != -1
		i -= 1
		Output[i] = Voices[pos]
		pos += 1
		if pos < VSlotted
			pos = Valid.Find(true, pos)
		else
			pos = -1
		endIf
	endWhile
	return Output
endFunction

sslBaseVoice function NewVoice(string Token, Form Owner)
	if !Owner || Token == "" || FindVoice(Token) != -1
		Log("NewVoice("+Token+") - Failed to create voice - Invalid arguments given - Token given already exists ("+FindVoice(Token)+") or was empty", "ERROR")
		return none
	endIf
	int i = VTokens.Find("")
	if i == -1
		Log("NewVoice("+Token+") - Failed to create voice - unable to find a free vpoce slot", "ERROR")
		return none
	endIf
	VTokens[i] = Token
	if i >= VSlotted
		VSlotted += 1
	endIf
	Voices[i] = GetNthAlias(i) as sslBaseVoice
	Voices[i].MakeEphemeral(Token, Owner)
	return Voices[i]
endFunction

sslBaseVoice function GetSetVoice(string Token, string Callback, Form Owner)
	sslBaseVoice Slot = GetVoice(Token)
	if Slot || Callback == ""
		Log("GET", "GetSetVoice("+Token+")")
		return Slot
	endIf
	; Create new voice and send callback
	Slot = NewVoice(Token, Owner)
	if Slot
		Log("SET", "GetSetVoice("+Token+")")
		SendCallback(Callback, Voices.Find(Slot), Owner)
	endIf
	return Slot
endFunction

sslBaseVoice function NewVoiceCopy(string Token, sslBaseVoice CopyFrom, Form Owner)
	sslBaseVoice Slot = NewVoice(Token, Owner)
	if Slot
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
	return VTokens.Find(Token)
endFunction

bool function HasVoice(string Token)
	return VTokens.Find(Token) != -1
endFunction

bool function ReleaseVoice(string Token)
	int i = FindVoice(Token)
	if i != -1
		Voices[i].Initialize()
		Voices[i] = none
		VTokens[i] = ""
		return true
	endIf
	return false
endFunction

int function ReleaseOwnerVoices(Form Owner)
	int Count
	if Owner
		int i = Voices.Length
		while i
			i -= 1
			if Voices[i] && Voices[i].Storage == Owner
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
	if !Voice
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

int ESlotted
string[] ETokens
sslBaseExpression[] Expressions

sslBaseExpression[] function GetOwnerExpressions(Form Owner)
	bool[] Valid = Utility.CreateBoolArray(ESlotted)
	int i = ESlotted
	while i
		i -= 1
		Valid[i] = Expressions[i] && Expressions[i].Registered && Expressions[i].Storage == Owner
	endWhile
	; Get list of valid Expressions
	i = PapyrusUtil.CountBool(Valid, true)
	if i == 0
		return none ; OR empty array?
	endIf
	sslBaseExpression[] Output = sslUtility.ExpressionArray(i)
	int pos = Valid.Find(true)
	while pos != -1
		i -= 1
		Output[i] = Expressions[pos]
		pos += 1
		if pos < ESlotted
			pos = Valid.Find(true, pos)
		else
			pos = -1
		endIf
	endWhile
	return Output
endFunction
sslBaseExpression function NewExpression(string Token, Form Owner)
	if !Owner || Token == "" || FindExpression(Token) != -1
		Log("NewExpression("+Token+") - Failed to create Expression - Invalid arguments given - Token given already exists ("+FindExpression(Token)+") or was empty", "ERROR")
		return none
	endIf
	int i = ETokens.Find("")
	if i == -1
		Log("NewExpression("+Token+") - Failed to create Expression - unable to find a free expression slot", "ERROR")
		return none
	endIf
	ETokens[i] = Token
	if i >= ESlotted
		ESlotted += 1
	endIf
	Expressions[i] = GetNthAlias(i) as sslBaseExpression
	Expressions[i].MakeEphemeral(Token, Owner)
	return Expressions[i]
endFunction

sslBaseExpression function GetSetExpression(string Token, string Callback, Form Owner)
	sslBaseExpression Slot = GetExpression(Token)
	if Slot || Callback == ""
		Log("GET", "GetSetExpression("+Token+")")
		return Slot
	endIf
	; Create new Expression and send callback
	Slot = NewExpression(Token, Owner)
	if Slot
		Log("SET", "GetSetExpression("+Token+")")
		SendCallback(Callback, Expressions.Find(Slot), Owner)
	endIf
	return Slot
endFunction

sslBaseExpression function NewExpressionCopy(string Token, sslBaseExpression CopyFrom, Form Owner)
	sslBaseExpression Slot = NewExpression(Token, Owner)
	if Slot
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
	return ETokens.Find(Token)
endFunction

bool function HasExpression(string Token)
	return ETokens.Find(Token) != -1
endFunction

bool function ReleaseExpression(string Token)
	int i = FindExpression(Token)
	if i != -1
		Expressions[i].Initialize()
		Expressions[i] = none
		ETokens[i] = ""
		return true
	endIf
	return false
endFunction

int function ReleaseOwnerExpressions(Form Owner)
	int Count
	if Owner
		int i = Expressions.Length
		while i
			i -= 1
			if Expressions[i] && Expressions[i].Storage == Owner
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
	if !Expression
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
	if CallbackForm
		CallbackForm.RegisterForModEvent(Token, Token)
	endIf
	if CallbackAlias
		CallbackAlias.RegisterForModEvent(Token, Token)
	endIf
	int e = ModEvent.Create(Token)
	ModEvent.PushInt(e, Slot)
	ModEvent.Send(e)
	Utility.WaitMenuMode(0.5)
	if CallbackForm
		CallbackForm.UnregisterForModEvent(Token)
	endIf
	if CallbackAlias
		CallbackAlias.UnregisterForModEvent(Token)
	endIf
endFunction

function Setup()
	parent.Setup()

	ASlotted   = 0
	ATokens    = new string[128]
	Animations = new sslBaseAnimation[128]

	VSlotted = 0
	VTokens  = new string[128]
	Voices   = new sslBaseVoice[128]

	ESlotted    = 0
	ETokens     = new string[128]
	Expressions = new sslBaseExpression[128]

	Cleanup()
endFunction

function Cleanup()
	; Init slots if empty
	if ATokens.Length != 128 || Animations.Length != 128
		ASlotted   = 0
		ATokens    = new string[128]
		Animations = new sslBaseAnimation[128]
	endIf
	if VTokens.Length != 128 || Voices.Length != 128
		VSlotted = 0
		VTokens  = new string[128]
		Voices   = new sslBaseVoice[128]
	endIf
	if ETokens.Length != 128 || Expressions.Length != 128
		ESlotted    = 0
		ETokens     = new string[128]
		Expressions = new sslBaseExpression[128]
	endIf
	; Check for empty forms for storage to indicate owner has been disabled
	int i = ASlotted
	while i
		i -= 1
		if Animations[i] && Animations[i].Registered && !Animations[i].Storage
			Log("Clearing phantom animation ["+i+"] '"+ATokens[i]+"'")
			Animations[i].Initialize()
			Animations[i] = none
			ATokens[i] = ""
		endIf
	endWhile
	i = VSlotted
	while i
		i -= 1
		if Voices[i] && Voices[i].Registered && !Voices[i].Storage
			Log("Clearing phantom voice ["+i+"] '"+VTokens[i]+"'")
			Voices[i].Initialize()
			Voices[i] = none
			VTokens[i] = ""
		endIf
	endWhile
	i = ESlotted
	while i
		i -= 1
		if Expressions[i] && Expressions[i].Registered && !Expressions[i].Storage
			Log("Clearing phantom expression["+i+"] '"+ETokens[i]+"'")
			Expressions[i].Initialize()
			Expressions[i] = none
			ETokens[i] = ""
		endIf
	endWhile
endFunction

; TODO: needs rewrite to match current animation script
sslBaseAnimation function CopyAnimation(sslBaseAnimation Copy, sslBaseAnimation Orig)
	; Set info
	Copy.Name = Orig.Name
	Copy.SoundFX = Orig.SoundFX
	Copy.AddTags(Orig.GetTags())
	Copy.SetRaceIDs(Orig.GetRaceIDs())
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
			int[]   Flags   = Orig.GetPositionFlags("Global", Position, Stage)
			float[] Offsets = Orig.GetRawOffsets(Position, Stage)
			Copy.AddPositionStage(Position, Orig.FetchPositionStage(Position, Stage), Offsets[0], Offsets[1], Offsets[2], Offsets[3], Flags[0] as bool, Flags[1] as bool, Flags[2] as bool, Flags[3])
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
			Copy.SetPhase(Phase, Gender, Orig.GenderPhase(Phase, Gender))
		endWhile
		Gender += 1
	endWhile
	return Copy
endFunction

; ------------------------------------------------------- ;
; --- DEPRECATED - DO NOT USE                         --- ;
; ------------------------------------------------------- ;

; Content Types - no longer used
int function Misc() global
	return 0
endFunction
int function Sexual() global
	return 1
endFunction
int function Foreplay() global
	return 2
endFunction

