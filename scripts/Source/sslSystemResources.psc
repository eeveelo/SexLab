scriptname sslSystemResources extends quest

SexLabFramework property SexLab Auto

message property mOldSkyrim auto
message property mOldSKSE auto
message property mNoSKSE auto
message property mAdjustChange auto
message property mUseBed auto
message property mDirtyUpgrade auto
message property mCleanSystemStart auto
message property mCleanSystemFinish auto
message property mSystemDisabled auto
message property mMoveScene auto
;message property mAnimationSet auto
;idle property ResetIdle auto
armor property aCalypsStrapon auto
armor property aNudeSuit auto
spell property SexLabDebugSpell auto
FormList property BedsList auto
form[] property strapons auto hidden
sound property sfxSquishing01 auto
sound property sfxSucking01 auto
EffectShader property CumVaginalOralAnal auto
EffectShader property CumOralAnal auto
EffectShader property CumVaginalOral auto
EffectShader property CumVaginalAnal auto
EffectShader property CumVaginal auto
EffectShader property CumOral auto
EffectShader property CumAnal auto
Static property LocationMarker auto

;
; Player Stats
;
float property fTimeSpent = 0.0 auto hidden
float property fSexualPurity = 0.0 auto hidden
int property iMalePartners = 0 auto hidden
int property iFemalePartners = 0 auto hidden
int property iMasturbationCount = 0 auto hidden
int property iAnalCount = 0 auto hidden
int property iVaginalCount = 0 auto hidden
int property iOralCount = 0 auto hidden
int property iVictimCount = 0 auto hidden
int property iAggressorCount = 0 auto hidden
string[] property sCustomStatName auto hidden
string[] property sCustomStatValue auto hidden
;
; Animations
; 
sslAnimAggrBehind property SexLabAggrBehind auto
sslAnimAggrDoggyStyle property SexLabAggrDoggyStyle auto
sslAnimAggrMissionary property SexLabAggrMissonary auto
sslAnimBoobjob property SexLabBoobjob auto
sslAnimDoggyStyle property SexLabDoggyStyle auto
sslAnimHuggingSex property SexLabHuggingSex auto
sslAnimMissionary property SexLabMissonary auto
sslAnimReverseCowgirl property SexLabReverseCowgirl auto
sslAnimSideways property SexLabSideways auto
sslAnimStanding property SexLabStanding auto
sslAnimTribadism property SexLabTribadism auto

sslAnimArrokBlowjob property ArrokBlowjob auto
sslAnimArrokBoobJob property ArrokBoobJob auto
sslAnimArrokCowgirl property ArrokCowgirl auto
sslAnimArrokDevilsThreeway property ArrokDevilsThreeway auto
sslAnimArrokDoggyStyle property ArrokDoggyStyle auto
sslAnimArrokForeplay property ArrokForeplay auto
sslAnimArrokLegUp property ArrokLegUp auto
sslAnimArrokMaleMasturbation property ArrokMaleMasturbation auto
sslAnimArrokMissionary property ArrokMissionary auto
sslAnimArrokOral property ArrokOral auto
sslAnimArrokReverseCowgirl property ArrokReverseCowgirl auto
sslAnimArrokSideways property ArrokSideways auto
sslAnimArrokStanding property ArrokStanding auto
sslAnimArrokStandingForeplay property ArrokStandingForeplay auto
sslAnimArrokTricycle property ArrokTricycle auto
sslAnimArrokHugFuck property ArrokHugFuck auto
sslAnimArrokLesbian property ArrokLesbian auto
sslAnimArrokSittingForeplay property ArrokSittingForeplay auto

sslAnimAPAnal property APAnal auto
sslAnimAPBedMissionary property APBedMissionary auto
sslAnimAPBlowjob property APBlowjob auto
sslAnimAPBoobjob property APBoobjob auto
sslAnimAPCowgirl property APCowgirl auto
sslAnimAPFemaleSolo property APFemaleSolo auto
sslAnimAPFisting property APFisting auto
sslAnimAPHandjob property APHandjob auto
sslAnimAPKneelBlowjob property APKneelBlowjob auto
sslAnimAPLegUp property APLegUp auto
; sslAnimAPReverseCowgirl property APReverseCowgirl auto ; Buggy Rotation, not used
sslAnimAPShoulder property APShoulder auto
sslAnimAPStandBlowjob property APStandBlowjob auto
sslAnimAPStanding property APStanding auto

sslAnimAPDoggyStyle property APDoggyStyle auto
sslAnimAPHoldLegUp property APHoldLegUp auto
sslAnimAPFaceDown property APFaceDown auto
sslAnimAPSkullFuck property APSkullFuck auto

sslAnimAPUnknown property APUNKNOWN auto

function LoadAnimations()
	; MiniLovers
	SexLab.RegisterAnimation(SexLabAggrBehind)
	SexLab.RegisterAnimation(SexLabAggrDoggyStyle)
	SexLab.RegisterAnimation(SexLabAggrMissonary)
	SexLab.RegisterAnimation(SexLabBoobjob)
	SexLab.RegisterAnimation(SexLabDoggyStyle)
	SexLab.RegisterAnimation(SexLabHuggingSex)
	SexLab.RegisterAnimation(SexLabMissonary)
	SexLab.RegisterAnimation(SexLabReverseCowgirl)
	SexLab.RegisterAnimation(SexLabSideways)
	SexLab.RegisterAnimation(SexLabStanding)
	SexLab.RegisterAnimation(SexLabTribadism)

	; Arrok
	SexLab.RegisterAnimation(ArrokBlowjob)
	SexLab.RegisterAnimation(ArrokBoobJob)
	SexLab.RegisterAnimation(ArrokCowgirl)
	SexLab.RegisterAnimation(ArrokDevilsThreeway)
	SexLab.RegisterAnimation(ArrokDoggyStyle)
	SexLab.RegisterAnimation(ArrokForeplay)
	SexLab.RegisterAnimation(ArrokLegUp)
	SexLab.RegisterAnimation(ArrokMaleMasturbation)
	SexLab.RegisterAnimation(ArrokMissionary)
	SexLab.RegisterAnimation(ArrokOral)
	SexLab.RegisterAnimation(ArrokReverseCowgirl)
	SexLab.RegisterAnimation(ArrokSideways)
	SexLab.RegisterAnimation(ArrokStanding)
	SexLab.RegisterAnimation(ArrokStandingForeplay)
	SexLab.RegisterAnimation(ArrokTricycle)
	SexLab.RegisterAnimation(ArrokHugFuck)
	SexLab.RegisterAnimation(ArrokLesbian)
	SexLab.RegisterAnimation(ArrokSittingForeplay)

	; AP
	SexLab.RegisterAnimation(APAnal)
	SexLab.RegisterAnimation(APBedMissionary)
	SexLab.RegisterAnimation(APBlowjob)
	SexLab.RegisterAnimation(APBoobjob)
	SexLab.RegisterAnimation(APCowgirl)
	SexLab.RegisterAnimation(APFemaleSolo)
	SexLab.RegisterAnimation(APFisting)
	SexLab.RegisterAnimation(APHandjob)
	SexLab.RegisterAnimation(APKneelBlowjob)
	SexLab.RegisterAnimation(APLegUp)
	; SexLab.RegisterAnimation(APReverseCowgirl) ; Buggy Rotation, not used
	SexLab.RegisterAnimation(APShoulder)
	SexLab.RegisterAnimation(APStandBlowjob)
	SexLab.RegisterAnimation(APStanding)

	;SexLab.RegisterAnimation(APDoggyStyle) ; Unsure of male position idles
	SexLab.RegisterAnimation(APHoldLegUp)
	SexLab.RegisterAnimation(APFaceDown)
	SexLab.RegisterAnimation(APSkullFuck)

	; Tester
	;SexLab.RegisterAnimation(APUNKNOWN)
endFunction


;
; Voices
;
sslVoiceMaleMoan01 property malemoan01 auto

sslVoiceFemaleMoan01 property femalemoan01 auto
sslVoiceFemaleMoan02 property femalemoan02 auto
sslVoiceFemaleMoan03 property femalemoan03 auto
sslVoiceFemaleMoan04 property femalemoan04 auto
sslVoiceFemaleMoan05 property femalemoan05 auto
sslVoiceFemaleMoan06 property femalemoan06 auto
sslVoiceFemaleMoan07 property femalemoan07 auto
sslVoiceFemaleMoan08 property femalemoan08 auto
sslVoiceFemaleMoan09 property femalemoan09 auto

function LoadVoices()
	; Male Voices
	SexLab.RegisterVoice(malemoan01)

	; Female Voices
	SexLab.RegisterVoice(femalemoan01) 
	SexLab.RegisterVoice(femalemoan02)
	SexLab.RegisterVoice(femalemoan03) 
	SexLab.RegisterVoice(femalemoan04) 
	SexLab.RegisterVoice(femalemoan05) 
	SexLab.RegisterVoice(femalemoan06) 
	SexLab.RegisterVoice(femalemoan07) 
	SexLab.RegisterVoice(femalemoan08)  
	SexLab.RegisterVoice(femalemoan09) 
endFunction

function FindStrapons()
{Find strapons from other mods and register it for use as an available resource}

	string[] straponMod = new string[8]
	int[] straponForm = new int[8]
	; Horker Tusk / Aeon
	straponMod[0] = "StrapOnbyaeonv1.1.esp"
	straponForm[0] = 0x0D65
	; Futa Equippable
	straponMod[1] = "Futa equippable.esp"
	straponForm[1] = 0x0D66
	straponMod[2] = "Futa equippable.esp"
	straponForm[2] = 0x0D67
	straponMod[3] = "Futa equippable.esp"
	straponForm[3] = 0x01D96
	straponMod[4] = "Futa equippable.esp"
	straponForm[4] = 0x022FB
	straponMod[5] = "Futa equippable.esp"
	straponForm[5] = 0x022FC
	straponMod[6] = "Futa equippable.esp"
	straponForm[6] = 0x022FD
	; Cozy & Rebels Futa
	straponMod[7] = "TG.esp"
	straponForm[7] = 0x0182B

	form[] straponsFound
	straponsFound = sslUtility.PushForm(aCalypsStrapon, straponsFound)
	int i = 0
	while i < 8
		armor strapon = Game.GetFormFromFile(straponForm[i], straponMod[i]) as armor
		if strapon != none
			straponsFound = sslUtility.PushForm(strapon, straponsFound)
		elseif strapon == none && i == 1
			i = 6 ; Futa equippable.esp missing, don't bother with checking others
		endIf
		i += 1
	endWhile
	strapons = straponsFound
endFunction
