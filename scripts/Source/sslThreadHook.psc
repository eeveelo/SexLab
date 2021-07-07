scriptname sslThreadHook extends ReferenceAlias

SexLabFramework property SexLab auto hidden
sslSystemConfig property SexLabConfig auto hidden



bool function AnimationStarting(sslThreadModel Thread)
	return false
endFunction

bool function AnimationPrepare(sslThreadController Thread)
	return false
endFunction

bool function StageStart(sslThreadController Thread)
	return false
endFunction

bool function StageEnd(sslThreadController Thread)
	return false
endFunction

bool function AnimationEnding(sslThreadController Thread)
	return false
endFunction

bool function AnimationEnd(sslThreadController Thread)
	return false
endFunction




Actor[] hkActorFilter
bool property HasActorFilter hidden
	bool function get()
		return hkActorFilter && hkActorFilter.Length > 0
	endFunction
endProperty

function AddActorFilter(Actor _FilteredRef)
	if _FilteredRef && hkActorFilter.Find(_FilteredRef) == -1
		hkActorFilter = PapyrusUtil.PushActor(hkActorFilter, _FilteredRef)
	endIf
endFunction

function RemoveActorFilter(Actor _FilteredRef)
	if _FilteredRef && hkActorFilter.Find(_FilteredRef) != -1
		hkActorFilter = PapyrusUtil.RemoveActor(hkActorFilter, _FilteredRef)
	endIf
endFunction

function ClearAllActorFilters()
	hkActorFilter = PapyrusUtil.ActorArray(0)
endFunction

Actor[] function GetFilteredActors()
	return hkActorFilter
endFunction

bool function IsActorFiltered(Actor _FilteredRef)
	return hkActorFilter && _FilteredRef && hkActorFilter.Find(_FilteredRef) != -1
endFunction

bool function ActorFilterMatch(Actor[] _ActorList)
	if !HasActorFilter || !_ActorList || _ActorList.Length == 0
		return false
	endIf
	int _idx = _ActorList.Length
	while _idx
		_idx -= 1
		if _ActorList[_idx] && hkActorFilter.Find(_ActorList[_idx]) != -1
			return true
		endIf
	endWhile
	return false
endFunction



string[] hkTagFilter
bool property HasTagFilter hidden
	bool function get()
		return hkTagFilter && hkTagFilter.Length > 0
	endFunction
endProperty

function AddTagFilter(string _FilteredTag)
	if _FilteredTag && hkTagFilter.Find(_FilteredTag) == -1
		hkTagFilter = PapyrusUtil.PushString(hkTagFilter, _FilteredTag)
	endIf
endFunction

function RemoveTagFilter(string _FilteredTag)
	if _FilteredTag && hkTagFilter.Find(_FilteredTag) != -1
		hkTagFilter = PapyrusUtil.RemoveString(hkTagFilter, _FilteredTag)
	endIf
endFunction

function ClearAllTagFilters()
	hkTagFilter = Utility.CreateStringArray(0)
endFunction

string[] function GetFilteredTags()
	return hkTagFilter
endFunction

bool function IsTagFiltered(string _FilteredTag)
	return hkTagFilter && _FilteredTag && hkTagFilter.Find(_FilteredTag) != -1
endFunction

bool function TagFilterMatch(string[] _TagList)
	if !HasTagFilter || !_TagList || _TagList.Length == 0
		return false
	endIf
	int _idx = _TagList.Length
	while _idx
		_idx -= 1
		if _TagList[_idx] && hkTagFilter.Find(_TagList[_idx]) != -1
			return true
		endIf
	endWhile
	return false
endFunction

bool property IsHookFiltered hidden
	bool function get()
		return (hkActorFilter && hkActorFilter.Length > 0) || (hkTagFilter && hkTagFilter.Length > 0)
	endFunction
endProperty

bool function CanRunHook(Actor[] _ActorList, string[] _TagList)
	return !IsHookFiltered || ActorFilterMatch(_ActorList) || TagFilterMatch(_TagList)
endFunction




event OnInit()
	OnPlayerLoadGame()
endEvent

event OnPlayerLoadGame()
	if !SexLab
		SexLab = SexLabUtil.GetAPI()
	endIf
	if !SexLabConfig
		SexLabConfig = SexLab.Config
	endIf
	int i = SexLabConfig.RegisterThreadHook(self)
	Debug.Trace("RegisterThreadHook("+self+") index: "+i)
	OnStartUp()
endEvent

function OnStartUp()
endFunction

event SexLabGameLoaded()
endEvent