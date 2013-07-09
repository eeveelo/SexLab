scriptname sslThread02 extends sslBaseThread

int function tid()
	return 2
endFunction

sslThreadController function _GetView()
	return SexLab.GetController(2)
endFunction