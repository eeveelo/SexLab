scriptname sslBaseVoice extends sslBaseObject

Sound property Mild auto
Sound property Medium auto
Sound property Hot auto

int property Gender auto hidden
bool property Male hidden
	bool function get()
		return (Gender == 0 || Gender == -1)
	endFunction
endProperty
bool property Female hidden
	bool function get()
		return (Gender == 1 || Gender == -1)
	endFunction
endProperty

function Moan(Actor ActorRef, int Strength = 30, bool IsVictim = false)
	if Config.UseLipSync && Game.GetCameraState() != 3
		ActorRef.Say(Config.LipSync)
	endIf
	GetSound(Strength, IsVictim).PlayAndWait(ActorRef)
endFunction

Sound function GetSound(int Strength, bool IsVictim = false)
	if IsVictim
		return Medium
	elseIf Strength > 75
		return Hot
	endIf
	return Mild
endFunction

bool function CheckGender(int CheckGender)
	return Gender == CheckGender || (Gender == -1 && (CheckGender == 1 || CheckGender == 0))
endFunction

function Save(int id = -1)
	parent.Save(id)
	AddTagConditional("Male",   (Gender == 0 || Gender == -1))
	AddTagConditional("Female", (Gender == 1 || Gender == -1))
	Log(Name, "Voices["+id+"]")
endFunction

function Initialize()
	Gender = -1
	Mild   = none
	Medium = none
	Hot    = none
	parent.Initialize()
endFunction

; ------------------------------------------------------- ;
; --- Tagging System                                  --- ;
; ------------------------------------------------------- ;

; bool function AddTag(string Tag) native
; bool function HasTag(string Tag) native
; bool function RemoveTag(string Tag) native
; bool function ToggleTag(string Tag) native
; bool function AddTagConditional(string Tag, bool AddTag) native
; bool function ParseTags(string[] TagList, bool RequireAll = true) native
; bool function CheckTags(string[] CheckTags, bool RequireAll = true, bool Suppress = false) native
; bool function HasOneTag(string[] TagList) native
; bool function HasAllTag(string[] TagList) native

; function AddTags(string[] TagList)
; 	int i = TagList.Length
; 	while i
; 		i -= 1
; 		AddTag(TagList[i])
; 	endWhile
; endFunction

; int function TagCount() native
; string function GetNthTag(int i) native
; function TagSlice(string[] Ouput) native

; string[] function GetTags()
; 	int i = TagCount()
; 	Log(Registry+" - TagCount: "+i)
; 	if i < 1
; 		return sslUtility.StringArray(0)
; 	endIf
; 	string[] Output = sslUtility.StringArray(i)
; 	TagSlice(Output)
; 	Log(Registry+" - SKSE Tags: "+Output)
; 	return Output
; endFunction

; function RevertTags() native
