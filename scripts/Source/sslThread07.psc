scriptname sslThread07 extends sslBaseThread

int function tid()
	return 7
endFunction

sslThreadController function _GetView()
	return SexLab.GetController(7)
endFunction