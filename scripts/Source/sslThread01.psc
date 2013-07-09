scriptname sslThread01 extends sslBaseThread

int function tid()
	return 1
endFunction

sslThreadController function _GetView()
	return SexLab.GetController(1)
endFunction