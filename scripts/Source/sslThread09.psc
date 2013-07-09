scriptname sslThread09 extends sslBaseThread

int function tid()
	return 9
endFunction

sslThreadController function _GetView()
	return SexLab.GetController(9)
endFunction