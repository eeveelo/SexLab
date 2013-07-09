scriptname sslThread03 extends sslBaseThread

int function tid()
	return 3
endFunction

sslThreadController function _GetView()
	return SexLab.GetController(3)
endFunction