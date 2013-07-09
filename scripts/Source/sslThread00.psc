scriptname sslThread00 extends sslBaseThread

int function tid()
	return 0
endFunction

sslThreadController function _GetView()
	return SexLab.GetController(0)
endFunction