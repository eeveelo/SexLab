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
ActorBase property SexLabStager auto
Keyword property SexLabForbid auto
Keyword property SexLabNoStrip auto
Keyword property SexLabActive auto
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
