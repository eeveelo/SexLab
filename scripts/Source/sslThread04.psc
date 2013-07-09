scriptname sslThread04 extends sslBaseThread

int function tid()
	return 4
endFunction

sslThreadController function _GetView()
	return SexLab.GetController(4)
endFunction