scriptname sslThread10 extends sslBaseThread

int function tid()
	return 10
endFunction

sslThreadController function _GetView()
	return SexLab.GetController(10)
endFunction