scriptname sslSystemUpgrade extends Quest


state v14400
	function Upgrade()

	endFunction
endState

function Upgrade()
	StorageUtil.FormListClear(none, "SexLab.StripList")
	StorageUtil.FormListClear(none, "SexLab.NoStripList")
endFunction


