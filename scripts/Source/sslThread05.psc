scriptname sslThread05 extends sslBaseThread

int function tid()
	return 5
endFunction

sslThreadController function _GetView()
	return SexLab.GetController(5)
endFunction