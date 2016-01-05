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

; TODO: Finish.
;
; import JsonUtil

; string Dir
; bool function DoAutoLoad(string File)
; 	return JsonUtil.GetPathBoolValue(File, ".autoload")
; endFunction

; function CacheAutoLoaders(string Path)
; 	Dir = Path
; 	string[] Files = JsonUtil.JsonInFolder(Path)
; 	if !Files || Files.Length < 1
; 		return
; 	endIf
; 	int i = Files.Length
; 	_Log("JSON Animation Files("+i+"): "+Files)
; 	while i
; 		i -= 1
; 		string File = Path + "/" + Files[i]
; 		if DoAutoLoad(File) || Path != ""
; 			string Registrar = StringUtil.Substring(Files[i], 0, (StringUtil.GetLength(Files[i]) - 5))
; 			string Category  = JsonUtil.GetPathStringValue(File, ".category", "none")
; 			StorageUtil.StringListAdd(self, "categories.autoload", Category, false)
; 			StorageUtil.StringListAdd(self, "autoload."+Category, Registrar, false)
; 			_Log("Added "+Category+": "+Registrar+" / "+File, "CacheAutoLoaders")
; 		else
; 			JsonUtil.Unload(File)
; 		endIf
; 	endWhile

; endFunction

; ;/ function RunAutoLoaders()
; 	string[] Categories = StorageUtil.StringListToArray(self, "categories.autoload")
; 	if Categories
; 		int i = Categories.Length
; 		while i
; 			i -= 1
			
; 			int n = StorageUtil.StringListCount(self, "autoload."+Category)
; 		endWhile
; 	endIf	
; endFunction /;

; function LoadCategory(string Category)
; 	_Log("LoadCategory("+Category+"): "+StorageUtil.StringListCount(self, "autoload."+Category))
; 	while StorageUtil.StringListCount(self, "autoload."+Category) > 0
; 		StorageUtil.StringListRemove(self, "autoload."+Category, RegisterLoader(StorageUtil.StringListPluck(self, "autoload."+Category, 0, "")), true)
; 	endWhile
; 	StorageUtil.StringListClear(self, "autoload."+Category)
; endFunction

; string function RegisterLoader(string Registrar)
; 	string File = Dir + "/" + Registrar + ".json"
; 	_Log("RegisterLoader("+Registrar+") "+File)
; 	; Check if loader syntax is valid
; 	if !ValidateLoader(File)
; 		return Registrar
; 	endIf
; 	; Get free Animation slot
; 	int id = Slots.Register(Registrar)
; 	sslBaseAnimation Slot = Slots.GetBySlot(id)
; 	if !Slot
; 		return Registrar
; 	endIf
; 	; Init slot	
; 	Slot.Initialize()
; 	Slot.Registry = Registrar
; 	Slot.Enabled  = GetPathBoolValue(File, ".enabled", true)
; 	Slot.Name     = GetPathStringValue(File, ".name", Registrar)
; 	; Global SFX
; 	Slot.SoundFX  = GetLoaderSFX(File, ".soundfx")
; 	; Set racekey for Creature animations
; 	string RaceKey
; 	if IsCreatureFactory
; 		RaceKey = GetPathStringValue(File, ".racekey", "")
; 	endIf
; 	; Positions and Stages
; 	int Positions = PathCount(File, ".positions")
; 	int Stages    = PathCount(File, ".positions[0].stages")
; 	int a = 0
; 	while a < Positions
; 		string pos = ".positions["+a+"]"
; 		int Gender = GetPathIntValue(File, pos+".gender")
; 		if IsCreatureFactory && Gender > 1
; 			Slot.AddCreaturePosition(GetPathStringValue(File, pos+".racekey", RaceKey), Gender)
; 		else
; 			Slot.AddPosition(Gender, GetLoaderCum(File, pos+".stages[0].cum"))
; 		endIf
; 		int Stage = 0
; 		while Stage < Stages

; 			;AddPositionStage(int Position, string AnimationEvent, float forward = 0.0, float side = 0.0, float up = 0.0, float rotate = 0.0, bool silent = false, bool openmouth = false, bool strapon = true, int sos = 0)
; 			string AnimationEvent =  GetPathStringValue(File, pos+".stages["+Stage+"].event")
; 			bool Silent           =  GetPathBoolValue(File, pos+".stages["+Stage+"].silent", false)
; 			bool OpenMouth        =  GetPathBoolValue(File, pos+".stages["+Stage+"].openmouth", false)
; 			bool Strapon          =  GetPathBoolValue(File, pos+".stages["+Stage+"].strapon", true)
; 			int SOS               =  GetPathIntValue(File, pos+".stages["+Stage+"].sos", 0)
; 			int CumID             =  GetLoaderCum(File, pos+".stages["+Stage+"].cum")

; 			float[] Offsets
; 			if IsPathArray(File, pos+".stages["+Stage+"].offsets")
; 				Offsets = PathFloatElements(File, pos+".stages["+Stage+"].offsets")
; 			endIf
; 			if !Offsets || Offsets.Length != 4
; 				Offsets = new float[4]
; 			endIf
; 			_Log(pos+".stages["+Stage+"].offsets = "+Offsets)
; 			; Add Stage
; 			Slot.AddPositionStage(a, AnimationEvent, Offsets[0], Offsets[1], Offsets[2], Offsets[3], Silent, OpenMouth, Strapon, SOS)
; 			; Stage specific cum type
; 			if CumID > 0
; 				Slot.SetStageCumID(a, Stage, CumID)
; 			endIf

; 			Stage += 1
; 		endWhile
; 		a += 1
; 	endWhile


; 	; Tags
; 	Slot.SetTags(GetPathStringValue(File, ".tags", Registrar))

; 	; Finalize
; 	Slot.Save(id)
; 	JsonUtil.Unload(File)
; 	return Registrar
; endFunction

; Sound function GetLoaderSFX(string File, string Path)
; 	if CanResolvePath(File, Path)
; 		string stringfx = GetPathStringValue(File, Path)
; 		if stringfx == "Squishing"
; 			return Squishing
; 		elseIf stringfx == "Sucking"
; 			return Sucking
; 		elseIf stringfx == "SexMix"
; 			return SexMix
; 		elseIf stringfx == "Squirting"
; 			return Squirting
; 		elseif stringfx != "" && IsPathForm(File, Path)
; 			return GetPathFormValue(File, Path) as Sound
; 		endIf
; 	endIf
; 	return none
; endFunction

; int function GetLoaderCum(string File, string Path)
; 	if CanResolvePath(File, Path)
; 		string cum = GetPathStringValue(File, Path)
; 		if cum == "Vaginal"
; 			return Vaginal
; 		elseIf cum == "Oral"
; 			return Oral
; 		elseIf cum == "Anal"
; 			return Anal
; 		elseIf cum == "VaginalOral"
; 			return VaginalOral
; 		elseIf cum == "VaginalAnal"
; 			return VaginalAnal
; 		elseIf cum == "OralAnal"
; 			return OralAnal
; 		elseIf cum == "VaginalOralAnal"
; 			return VaginalOralAnal
; 		endIf
; 	endIf
; 	return -1
; endFunction

; bool function ValidateLoader(string File)
; 	; Check basic settings
; 	if !JsonUtil.Load(File) || !JsonUtil.IsGood(File)
; 		_Log("ValidateLoader("+File+") - FAILED - Could not load file.")
; 		return false
; 	elseIf JsonUtil.GetPathStringValue(File, ".name", "") == ""
; 		_Log("ValidateLoader("+File+") - FAILED - Invalid or missing name property")
; 		return false
; 	elseIf !JsonUtil.IsPathString(File, ".tags")
; 		_Log("ValidateLoader("+File+") - FAILED - Invalid or missing tags property")
; 		return false
; 	elseIf IsCreatureFactory && !JsonUtil.IsPathString(File, ".racekey")
; 		_Log("ValidateLoader("+File+") - FAILED - Invalid or missing racekey property")
; 		return false
; 	endIf
; 	; Check for positions array
; 	int Positions = JsonUtil.PathCount(File, ".positions")
; 	if Positions < 1 || Positions > 5
; 		_Log("ValidateLoader("+File+") - FAILED - Invalid or missing positions array")
; 		return false
; 	endIf
; 	; Check number of stages
; 	int Stages = JsonUtil.PathCount(File, ".positions[0].stages")
; 	if Stages < 1
; 		_Log("ValidateLoader("+File+") - FAILED - Unable to determine number of stages")
; 		return false
; 	elseIf (Positions > 1 && JsonUtil.PathCount(File, ".positions[1].stages") != Stages) \
; 		|| (Positions > 2 && JsonUtil.PathCount(File, ".positions[2].stages") != Stages) \
; 		|| (Positions > 3 && JsonUtil.PathCount(File, ".positions[3].stages") != Stages) \
; 		|| (Positions > 4 && JsonUtil.PathCount(File, ".positions[4].stages") != Stages)
; 		_Log("ValidateLoader("+File+") - FAILED - Number of stages not equal between all positions")
; 		return false
; 	endIf
; 	;TODO: might need additional checks
; 	return true ; Loader is most likely valid
; endFunction


; function _Log(string Log, string Type = "NOTICE")
; 	Log = Type+": "+Log
; 	SexLabUtil.PrintConsole(Log)
; 	Debug.TraceUser("SexLabDebug", Log)
; 	Debug.Trace("SEXLAB - "+Log)
; endFunction