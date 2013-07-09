scriptname sslThread06 extends sslBaseThread

int function tid()
	return 6
endFunction

sslThreadController function _GetView()
	return SexLab.GetController(6)
endFunction