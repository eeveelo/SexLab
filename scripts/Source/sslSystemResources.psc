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
message property mSystemUpdated auto
;message property mAnimationSet auto
;idle property ResetIdle auto
armor property aCalypsStrapon auto
armor property aNudeSuit auto
spell property SexLabDebugSpell auto
FormList property BedsList auto
form[] property strapons auto hidden
sound property sfxSquishing01 auto
sound property sfxSucking01 auto
sound property sfxSexMix01 auto
EffectShader property CumVaginalOralAnal auto
EffectShader property CumOralAnal auto
EffectShader property CumVaginalOral auto
EffectShader property CumVaginalAnal auto
EffectShader property CumVaginal auto
EffectShader property CumOral auto
EffectShader property CumAnal auto
Static property LocationMarker auto
Form property SexLabStageBox auto
Keyword property SexLabForbid auto
Keyword property SexLabNoStrip auto
Weapon property DummyWeapon auto
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
sslAnimArrokAnal property ArrokAnal auto
sslAnimArrokRape property ArrokRape auto

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
	SexLab.RegisterAnimation(ArrokAnal)
	SexLab.RegisterAnimation(ArrokRape)

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
sslVoiceMaleMoan02 property malemoan02 auto
sslVoiceMaleMoan03 property malemoan03 auto
sslVoiceMaleMoan04 property malemoan04 auto

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
	SexLab.RegisterVoice(malemoan02)
	SexLab.RegisterVoice(malemoan03)
	SexLab.RegisterVoice(malemoan04)

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


armor function LoadStrapon(string esp, int id)
	armor strapon = Game.GetFormFromFile(id, esp) as armor
	if strapon != none
		strapons = sslUtility.PushForm(strapon, strapons)
	endif
	return strapon
endFunction

function FindStrapons()
{Find strapons from other mods and register it for use as an available resource}
	strapons = new form[1]
	strapons[0] = aCalypsStrapon

	LoadStrapon("StrapOnbyaeonv1.1.esp", 0x0D65)
	LoadStrapon("TG.esp", 0x0182B)

	armor check = LoadStrapon("Futa equippable.esp", 0x0D66)
	if check != none
		LoadStrapon("Futa equippable.esp", 0x0D67)
		LoadStrapon("Futa equippable.esp", 0x01D96)
		LoadStrapon("Futa equippable.esp", 0x022FB)
		LoadStrapon("Futa equippable.esp", 0x022FC)
		LoadStrapon("Futa equippable.esp", 0x022FD)
	endIf

	check = LoadStrapon("Skyrim_Strap_Ons.esp", 0x00D65)
	if check != none
		LoadStrapon("Skyrim_Strap_Ons.esp", 0x02859)
		LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285A)
		LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285B)
		LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285C)
		LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285D)
		LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285E)
		LoadStrapon("Skyrim_Strap_Ons.esp", 0x0285F)
	endIf
endFunction
