scriptname sslThread08 extends sslBaseThread

int function tid()
	return 8
endFunction

sslThreadController function _GetView()
	return SexLab.GetController(8)
endFunction