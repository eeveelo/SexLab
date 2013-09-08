scriptname sslVoiceLibrary extends Quest

; Scripts
sslVoiceSlots property Slots auto

; Data
actor property PlayerRef auto
topic property SexLabMoanMild auto
topic property SexLabMoanMedium auto
topic property SexLabMoanHot auto
VoiceType property SexLabVoiceM auto
VoiceType property SexLabVoiceF auto
FormList property VoicesPlayer auto

; Config
string property sPlayerVoice auto hidden

sslBaseVoice function PickVoice(actor a)
	if a == PlayerRef && sPlayerVoice != "$SSL_Random"
		return Slots.GetByName(sPlayerVoice)
	else
		return Slots.GetRandom(a.GetLeveledActorBase().GetSex())
	endIf
endFunction

function _Defaults()
	sPlayerVoice = "$SSL_Random"
endFunction