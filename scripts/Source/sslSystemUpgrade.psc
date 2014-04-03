scriptname sslSystemUpgrade extends Quest


state 14400
	function Upgrade()

	endFunction
endState

function Upgrade()
	StorageUtil.FormListClear(none, "SexLab.StripList")
	StorageUtil.FormListClear(none, "SexLab.NoStripList")
endFunction


