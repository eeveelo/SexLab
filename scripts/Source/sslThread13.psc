scriptname sslThread13 extends sslBaseThread

int function tid()
	return 13
endFunction

sslThreadController function _GetView()
	return SexLab.GetController(13)
endFunction