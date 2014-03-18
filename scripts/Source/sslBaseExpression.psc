scriptname sslBaseExpression extends sslBaseObject

int[] phases

int[] male1
int[] male2
int[] male3
int[] male4
int[] male5

int[] female1
int[] female2
int[] female3
int[] female4
int[] female5


int[] function GetPhase(int phase, int gender)
	; Female presets
	if gender == 1
		if phase == 1
			return female1
		elseIf phase == 2
			return female2
		elseIf phase == 3
			return female3
		elseIf phase == 4
			return female4
		elseIf phase == 5
			return female5
		else
			return female1
		endIf
	; Male presets
	else
		if phase == 1
			return male1
		elseIf phase == 2
			return male2
		elseIf phase == 3
			return male3
		elseIf phase == 4
			return male4
		elseIf phase == 5
			return male5
		else
			return male1
		endIf
	endIf
endFunction

;/-----------------------------------------------\;
;|	Editing Functions                            |;
;\-----------------------------------------------/;

function SetPhase(int phase, int gender, int[] presets)
	; Female presets
	if gender == 1
		if phase == 1
			female1 = presets
		elseIf phase == 2
			female2 = presets
		elseIf phase == 3
			female3 = presets
		elseIf phase == 4
			female4 = presets
		elseIf phase == 5
			female5 = presets
		endIf
	; Male presets
	else
		if phase == 1
			male1 = presets
		elseIf phase == 2
			male2 = presets
		elseIf phase == 3
			male3 = presets
		elseIf phase == 4
			male4 = presets
		elseIf phase == 5
			male5 = presets
		endIf
	endIf
	; increase genders phase count
	if phase > phases[gender]
		phases[gender] = phase
	endIf
endFunction

function SetModifiers(int phase, int gender, int m0 = 0, int m1 = 0, int m2 = 0, int m3 = 0, int m4 = 0, int m5 = 0, int m6 = 0, int m7 = 0, int m8 = 0, int m9 = 0, int m10 = 0, int m11 = 0, int m12 = 0, int m13 = 0)
	if phase < 1 || phase > 5
		return ; Invalid phase
	endIf
	; Get phase preset
	int[] presets = GetPhase(phase, gender)
	if presets.Length != 32
		presets = new int[32]
	endIf
	; Set modifier indexes
	presets[0] = m0
	presets[1] = m1
	presets[2] = m2
	presets[3] = m3
	presets[4] = m4
	presets[5] = m5
	presets[6] = m6
	presets[7] = m7
	presets[8] = m8
	presets[9] = m9
	presets[10] = m10
	presets[11] = m11
	presets[12] = m12
	presets[13] = m13

	SetPhase(phase, gender, presets)
endFunction

function SetPhonemes(int phase, int gender, int p0 = 0, int p1 = 0, int p2 = 0, int p3 = 0, int p4 = 0, int p5 = 0, int p6 = 0, int p7 = 0, int p8 = 0, int p9 = 0, int p10 = 0, int p11 = 0, int p12 = 0, int p13 = 0,  int p14 = 0,  int p15 = 0)
	if phase < 1 || phase > 5
		return ; Invalid phase
	endIf
	; Get phase preset
	int[] presets = GetPhase(phase, gender)
	if presets.Length != 32
		presets = new int[32]
	endIf
	; Set phoneme indexes
	presets[14] = p0
	presets[15] = p1
	presets[16] = p2
	presets[17] = p3
	presets[18] = p4
	presets[19] = p5
	presets[20] = p6
	presets[21] = p7
	presets[22] = p8
	presets[23] = p9
	presets[24] = p10
	presets[25] = p11
	presets[26] = p12
	presets[27] = p13
	presets[28] = p14
	presets[29] = p15

	SetPhase(phase, gender, presets)
endFunction

function SetExpression(int phase, int gender, int eid, int amount)
	if phase < 1 || phase > 5
		return ; Invalid phase
	endIf
	; Get phase preset
	int[] presets = GetPhase(phase, gender)
	if presets.Length != 32
		presets = new int[32]
	endIf
	; Set expression type id + amount
	presets[30] = eid
	presets[31] = amount

	SetPhase(phase, gender, presets)
endFunction


function Initialize()
	phases = new int[2]

	int[] intDel1
	male1 = intDel1
	int[] intDel2
	male2 = intDel2
	int[] intDel3
	male3 = intDel3
	int[] intDel4
	male4 = intDel4
	int[] intDel5
	male5 = intDel5

	int[] intDel6
	female1 = intDel6
	int[] intDel7
	female2 = intDel7
	int[] intDel8
	female3 = intDel8
	int[] intDel9
	female4 = intDel9
	int[] intDel10
	female5 = intDel10
	parent.Initialize()
endFunction
