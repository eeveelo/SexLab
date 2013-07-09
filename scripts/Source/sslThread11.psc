scriptname sslThread11 extends sslBaseThread

int function tid()
	return 11
endFunction

sslThreadController function _GetView()
	return SexLab.GetController(11)
endFunction