scriptname sslAnimationFactory extends Quest hidden

sslAnimationSlots property Slots auto hidden

; Gender Types
int property Male = 0 autoreadonly hidden
int property Female = 1 autoreadonly hidden
int property Creature = 2 autoreadonly hidden
int property CreatureMale = 2 autoreadonly hidden
int property CreatureFemale = 3 autoreadonly hidden
; Cum Types
int property Vaginal = 1 autoreadonly hidden
int property Oral = 2 autoreadonly hidden
int property Anal = 3 autoreadonly hidden
int property VaginalOral = 4 autoreadonly hidden
int property VaginalAnal = 5 autoreadonly hidden
int property OralAnal = 6 autoreadonly hidden
int property VaginalOralAnal = 7 autoreadonly hidden
; Content Types
int property Misc = 0 autoreadonly hidden
int property Sexual = 1 autoreadonly hidden
int property Foreplay = 2 autoreadonly hidden
; SFX Types
Sound property Squishing auto hidden
Sound property Sucking auto hidden
Sound property SexMix auto hidden
Sound property Squirting auto hidden
; System Use
bool property IsCreatureFactory auto hidden

; ------------------------------------------------------- ;
; --- Registering Animations                          --- ;
; ------------------------------------------------------- ;

; Prepare the factory for use with the default animation slots
function PrepareFactory()
	sslAnimationSlots AnimSlots = Game.GetFormFromFile(0x639DF, "SexLab.esm") as sslAnimationSlots
	if !Slots || Slots != AnimSlots
		Slots = AnimSlots
	endIf
	if !Squishing
		Squishing = Game.GetFormFromFile(0x65A31, "SexLab.esm") as Sound
	endIf
	if !Sucking
		Sucking   = Game.GetFormFromFile(0x65A32, "SexLab.esm") as Sound
	endIf
	if !SexMix
		SexMix    = Game.GetFormFromFile(0x65A33, "SexLab.esm") as Sound
	endIf
	if !Squirting
		Squirting = Game.GetFormFromFile(0x65A34, "SexLab.esm") as Sound
	endIf
	IsCreatureFactory = false
	; CacheAutoLoaders("../SexLab/Animations")
endFunction

; Prepare the factory for use with the default creature animation slots
function PrepareFactoryCreatures()
	sslCreatureAnimationSlots AnimSlots = Game.GetFormFromFile(0x664FB, "SexLab.esm") as sslCreatureAnimationSlots
	if !Slots || Slots != AnimSlots
		Slots = AnimSlots
	endIf
	if !Squishing
		Squishing = Game.GetFormFromFile(0x65A31, "SexLab.esm") as Sound
	endIf
	if !Sucking
		Sucking   = Game.GetFormFromFile(0x65A32, "SexLab.esm") as Sound
	endIf
	if !SexMix
		SexMix    = Game.GetFormFromFile(0x65A33, "SexLab.esm") as Sound
	endIf
	if !Squirting
		Squirting = Game.GetFormFromFile(0x65A34, "SexLab.esm") as Sound
	endIf
	IsCreatureFactory = true
	; CacheAutoLoaders("../SexLab/Creatures")
endFunction

; Send callback event to start registration
function RegisterAnimation(string Registrar)
	; Get free Animation slot
	int id = Slots.Register(Registrar)
	if id != -1
		; Init slot
		sslBaseAnimation Slot = Slots.GetBySlot(id)
		Slot.Initialize()
		Slot.Registry = Registrar
		Slot.Enabled  = true
		; Send load event
		RegisterForModEvent(Registrar, Registrar)
		int eid = ModEvent.Create(Registrar)
		ModEvent.PushInt(eid, id)
		ModEvent.Send(eid)
		; Utility.WaitMenuMode(0.2)
		; Debug.Trace("RegisterAnimation["+id+"] - Wait")
	endIf
endFunction

; Gets the Animation resource object for use in the callback, MUST be called at start of callback to get the appropiate resource
sslBaseAnimation function Create(int id)
	sslBaseAnimation Slot = Slots.GetbySlot(id)
	UnregisterForModEvent(Slot.Registry)
	return Slot
endFunction

function Initialize()
	PrepareFactory()
endfunction

function RegisterOtherCategories()
	if StorageUtil.StringListCount(Slots, "categories") > 0
		string[] Categories = StorageUtil.StringListToArray(Slots, "categories")
		StorageUtil.StringListClear(Slots, "categories")
		int i = Categories.Length
		while i
			i -= 1
			RegisterCategory(Categories[i])
		endWhile
	endIf
endFunction

function RegisterCategory(string Category)
	; ModEvent for other quest base mod animation loaders
	ModEvent.Send(ModEvent.Create("SexLabSlotAnimations_"+Category))
	Utility.WaitMenuMode(0.4)
	; Load JSON files in category
	string[] Files = StorageUtil.StringListToArray(Slots, "cat."+Category)
	StorageUtil.StringListRemove(Slots, "categories", Category)
	StorageUtil.StringListClear(Slots, "cat."+Category)
	if Files
		int i = Files.Length
		while i
			i -= 1
			StorageUtil.StringListRemove(Slots, "cat."+Category, Files[i])
			RegisterJSON(Files[i])
		endWhile
	endIf
endFunction

sslBaseAnimation function RegisterJSON(string Filename)
	string Registrar = StringUtil.Substring(Filename, 0, StringUtil.GetLength(Filename) - 5)
	Filename = Slots.JLoaders + Filename

	if !ValidateJSON(Filename)
		JsonUtil.Unload(Filename, false, false)
		return none
	endIf
	FactoryLog("JSON LOADING ("+Filename+"): "+Registrar)

	int id = Slots.Register(Registrar)
	if id == -1
		JsonUtil.Unload(Filename, false, false)
		return none
	endIf

	sslBaseAnimation Slot = Slots.GetBySlot(id)
	Slot.Initialize()
	
	; Set basic info
	Slot.Registry = Registrar
	Slot.Enabled = JsonUtil.GetPathIntValue(Filename, ".enabled", 1) as bool
	Slot.Name = JsonUtil.GetPathStringValue(Filename, ".name", Registrar)
	
	; Set Tags
	Slot.AddTags(JsonUtil.PathStringElements(Filename, ".tags"))

	; Build position stage info
	int Positions = JsonUtil.PathCount(Filename, ".positions")
	int Stages = JsonUtil.PathCount(Filename, ".positions[0].animation")

	int stg
	int pos
	while pos < Positions


		int a

		if IsCreatureFactory && JsonUtil.GetPathStringValue(Filename, ".positions["+pos+"].creature") != "" && JsonUtil.GetPathIntValue(Filename, ".positions["+pos+"].gender") >= 2
			a = Slot.AddCreaturePosition(JsonUtil.GetPathStringValue(Filename, ".positions["+pos+"].creature"), JsonUtil.GetPathIntValue(Filename, ".positions["+pos+"].gender", 2))
		else
			a = Slot.AddPosition(JsonUtil.GetPathIntValue(Filename, ".positions["+pos+"].gender", 0))
		endIf

		stg = 0
		while stg < Stages
			string Path = ".positions["+pos+"]"

			; Primary position stage data
			string AnimEvent = JsonUtil.GetPathStringValue(Filename, Path+".animation["+stg+"]")
			float[] Offsets  = JsonUtil.PathFloatElements(Filename, Path+".offset["+stg+"]")
			if !Offsets || Offsets.Length != 4
				Offsets = new float[4] ; default to empty offsets array
			endIf

			; Stage flags
			int schlong    = JsonUtil.GetPathIntValue(Filename, Path+".flag.schlong["+stg+"]", 0)
			bool openmouth = JsonUtil.GetPathIntValue(Filename, Path+".flag.openmouth["+stg+"]", 0) as bool
			bool silent    = JsonUtil.GetPathIntValue(Filename, Path+".flag.silent["+stg+"]", 0) as bool
			bool strapon   = JsonUtil.GetPathIntValue(Filename, Path+".flag.strapon["+stg+"]", 1) as bool
			
			Slot.AddPositionStage(a, AnimEvent, Offsets[0], Offsets[1], Offsets[2], Offsets[3], silent, openmouth, strapon, schlong)

			; Stage specific cum settings
			int cum    = JsonUtil.GetPathIntValue(Filename, Path+".flag.cum["+stg+"]", -1)
			int cumsrc = JsonUtil.GetPathIntValue(Filename, Path+".flag.cumsrc["+stg+"]", -1)
			
			Slot.SetStageCumID(pos, (stg + 1), cum, cumsrc)

			stg += 1
		endWhile

		pos += 1
	endWhile

	; Set stage Sound FX
	string[] SFX = JsonUtil.PathStringElements(Filename, ".sfx")
	if SFX
		if SFX.Length == 1
			FactoryLog("SFX TEST: "+SFX[0]+" == "+StringSFX(SFX[0]))
			Slot.SoundFX = StringSFX(SFX[0])
		else
			int s = SFX.Length
			while s > 0
				s -= 1
				FactoryLog("Multi-SFX TEST: "+SFX[s]+" == "+StringSFX(SFX[s]))
				Slot.SetStageSoundFX((s + 1), StringSFX(SFX[s]))
			endWhile
		endIf
	endIf

	; Set stage specific timers, if any
	float[] Timers = JsonUtil.PathFloatElements(Filename, ".timers")
	if Timers
		int t
		while t < Timers.Length
			t += 1
			Slot.SetStageTimer(t, Timers[t])
		endWhile
	endIf

	Slot.Save(id)

	JsonUtil.Unload(Filename, false, false)
	return Slot
endFunction

bool function ValidateJSON(string Filename)
	string err = "ERROR - ValidateJSON("+Filename+") - "
	; Check formatting errors
	if !JsonUtil.IsGood(Filename)
		FactoryLog(err+JsonUtil.GetErrors(Filename))
		return false
	; Check for name
	elseIf StringUtil.GetLength(JsonUtil.GetPathStringValue(Filename, ".name")) < 3
		FactoryLog(err+"Invalid or missing name - Name: "+JsonUtil.GetPathStringValue(Filename, ".name", "empty"))
		return false
	; Check for tags
	elseIf !JsonUtil.IsPathArray(Filename, ".tags") || JsonUtil.PathCount(Filename, ".tags") <  2
		FactoryLog(err+"Missing tags array or not enough tags.")
		return false
	endIf
	; Check for positions array
	int Positions = JsonUtil.PathCount(Filename, ".positions") * (JsonUtil.IsPathArray(Filename, ".positions") as int)
	if Positions < 1 || Positions > 5 || !JsonUtil.IsPathArray(Filename, ".positions")
		FactoryLog(err+"Invalid positions array")
		return false
	endIf
	; Check for matching number of stages
	int Stages = JsonUtil.PathCount(Filename, ".positions[0].animation") * (JsonUtil.IsPathArray(Filename, ".positions[0].animation") as int)
	if Stages < 1
		FactoryLog(err+"Invalid number of stages or missing stages array.")
		return false
	endIf
	int pos = 1
	while pos < Positions
		if Stages != JsonUtil.PathCount(Filename, ".positions["+pos+"].animation") * (JsonUtil.IsPathArray(Filename, ".positions["+pos+"].animation") as int)
			FactoryLog(err+"Number of stages does not match between all positions or missing.")
			return false
		endIf
		pos += 1
	endWhile
	;/ ; Check for creature types, if creature animation
	if IsCreature && !JsonUtil.IsPathArray(Filename, ".racetypes")
		FactoryLog(err+"Missing racetypes array on assumed creature animation.")
		return false
	endIf /;
	return true
endFunction

Sound function StringSFX(string sfx)
	if sfx == "Squishing"
		return Squishing
	elseIf sfx == "Sucking"
		return Sucking
	elseIf sfx == "SexMix"
		return SexMix
	elseIf sfx == "Squirting"
		return Squirting
	elseIf StringUtil.Find(sfx, "|") != -1
		string[] arr = PapyrusUtil.StringSplit(sfx, "|")
		return Game.GetFormFromFile((arr[0] as int), arr[1]) as Sound
	endIf
	return none
endFunction

function FactoryLog(string msg)
	MiscUtil.PrintConsole(msg)
	Debug.Trace("SEXLAB - "+msg)
endFunction