scriptname sslSystemUpgrade extends Quest

event Upgrade()
	StorageUtil.FormListClear(none, "SexLab.StripList")
	StorageUtil.FormListClear(none, "SexLab.NoStripList")
endEvent
