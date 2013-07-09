scriptname sslThread12 extends sslBaseThread

int function tid()
	return 12
endFunction

sslThreadController function _GetView()
	return SexLab.GetController(12)
endFunction