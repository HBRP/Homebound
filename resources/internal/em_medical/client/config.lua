
GENERAL_BODY_PARTS = {
	HEAD     = "Head",
	L_ARM    = "Left Arm",
	R_ARM    = "Right Arm",
	L_LEG    = "Left Leg",
	R_LEG    = "Right Leg",
	PELVIS   = "Pelvis",
	CHEST    = "Chest",
	ABDOMEN  = "Abdomen",
	BACK     = "Back"
}

CHECKED_BONES = {
	SKEL_Pelvis     = {name = "SKEL_Pelvis"    , hash = 0x2E28, general_body_part = GENERAL_BODY_PARTS.PELVIS},
	SKEL_L_Thigh    = {name = "SKEL_L_Thigh"   , hash = 0xE39F, general_body_part = GENERAL_BODY_PARTS.L_LEG},
	SKEL_L_Calf     = {name = "SKEL_L_Calf"    , hash = 0xF9BB, general_body_part = GENERAL_BODY_PARTS.L_LEG},
	SKEL_L_Foot     = {name = "SKEL_L_Foot"    , hash = 0x3779, general_body_part = GENERAL_BODY_PARTS.L_LEG},
    SKEL_L_Toe0     = {name = "SKEL_L_Toe0"    , hash = 0x83C , general_body_part = GENERAL_BODY_PARTS.L_LEG},
    SKEL_R_Thigh    = {name = "SKEL_R_Thigh"   , hash = 0xCA72, general_body_part = GENERAL_BODY_PARTS.R_LEG},
	SKEL_R_Calf     = {name = "SKEL_R_Calf"    , hash = 0x9000, general_body_part = GENERAL_BODY_PARTS.R_LEG},
	SKEL_R_Foot     = {name = "SKEL_R_Foot"    , hash = 0xCC4D, general_body_part = GENERAL_BODY_PARTS.R_LEG},
	SKEL_R_Toe0     = {name = "SKEL_R_Toe0"    , hash = 0x512D, general_body_part = GENERAL_BODY_PARTS.R_LEG},
	SKEL_L_Clavicle = {name = "SKEL_L_Clavicle", hash = 0xFCD9, general_body_part = GENERAL_BODY_PARTS.L_ARM},
	SKEL_L_UpperArm = {name = "SKEL_L_UpperArm", hash = 0xB1C5, general_body_part = GENERAL_BODY_PARTS.L_ARM},
	SKEL_L_Forearm  = {name = "SKEL_L_Forearm" , hash = 0xEEEB, general_body_part = GENERAL_BODY_PARTS.L_ARM},
    SKEL_L_Hand     = {name = "SKEL_L_Hand"    , hash = 0x49D9, general_body_part = GENERAL_BODY_PARTS.L_ARM},
    SKEL_R_Clavicle = {name = "SKEL_R_Clavicle", hash = 0x29D2, general_body_part = GENERAL_BODY_PARTS.R_ARM},
	SKEL_R_UpperArm = {name = "SKEL_R_UpperArm", hash = 0x9D4D, general_body_part = GENERAL_BODY_PARTS.R_ARM},
	SKEL_R_Forearm  = {name = "SKEL_R_Forearm" , hash = 0x6E5C, general_body_part = GENERAL_BODY_PARTS.R_ARM},
    SKEL_R_Hand     = {name = "SKEL_R_Hand"    , hash = 0xDEAD, general_body_part = GENERAL_BODY_PARTS.R_ARM},
    SKEL_Neck_1     = {name = "SKEL_Neck_1"    , hash = 0x9995, general_body_part = GENERAL_BODY_PARTS.HEAD},
    SKEL_Head       = {name = "SKEL_Head"      , hash = 0x796E, general_body_part = GENERAL_BODY_PARTS.HEAD},
    SPR_L_Breast    = {name = "SPR_L_Breast"   , hash = 0xFC8E, general_body_part = GENERAL_BODY_PARTS.CHEST},
	SPR_R_Breast    = {name = "SPR_R_Breast"   , hash = 0x885F, general_body_part = GENERAL_BODY_PARTS.CHEST},
	SKEL_Spine0     = {name = "SKEL_Spine0"    , hash = 0x5C01, general_body_part = GENERAL_BODY_PARTS.BACK},
	SKEL_Spine1     = {name = "SKEL_Spine1"    , hash = 0x60F0, general_body_part = GENERAL_BODY_PARTS.BACK},
	SKEL_Spine2     = {name = "SKEL_Spine2"    , hash = 0x60F1, general_body_part = GENERAL_BODY_PARTS.CHEST},
	SKEL_Spine3     = {name = "SKEL_Spine3"    , hash = 0x60F2, general_body_part = GENERAL_BODY_PARTS.CHEST},
	SKEL_Spine_Root = {name = "SKEL_Spine_Root", hash = 0xE0FD, general_body_part = GENERAL_BODY_PARTS.BACK},
	SM_CockNBalls_ROOT = {name = "SM_CockNBalls_ROOT", hash = 0xC67D,general_body_part = GENERAL_BODY_PARTS.PELVIS},
	SM_CockNBalls      = {name = "SM_CockNBalls", hash = 0x9D34, general_body_part = GENERAL_BODY_PARTS.PELVIS},
}

PLAYER_MAX_LEVEL = {

	FOOD   = 1000000,
	WATER  = 1000000,
	STRESS = 1000000

}

PLAYER_MAX_FOOD_LEVEL   = 1000000
PLAYER_MAX_WATER_LEVEL  = 1000000
PLAYER_MAX_STRESS_LEVEL = 1000000

PAIN_THRESHOLD_BEFORE_SHOCK = 25
PLAYER_RESPAWN_HOLD_TIME = 5 * 1000
REVIVE_WAIT_PERIOD = 10 * 60 * 1000

WOUND_TYPES = {
	SMALL_CONTUSION      = {name = "Small Contusion"         , pain_level = 0, bleeding = 0, heal_time = 1200},
	CONTUSION            = {name = "Contusion"               , pain_level = 1, bleeding = 0, heal_time = 1320},
	LARGE_CONTUSION      = {name = "Large Contusion"         , pain_level = 2, bleeding = 0, heal_time = 1440},
	SMALL_LACERATION     = {name = "Small Laceration"        , pain_level = 1, bleeding = 0, heal_time = 1200},
	LACERATION           = {name = "Laceration"              , pain_level = 1, bleeding = 1},
	LARGE_LACERATION     = {name = "Large Laceration"        , pain_level = 2, bleeding = 2},
	PUNCTURE_WOUND       = {name = "Puncture Wound"          , pain_level = 5, bleeding = 7},
	LARGE_PUNCTURE_WOUND = {name = "Large Puncture Wound"    , pain_level = 7, bleeding = 9},
	FIRST_DEGREE_BURN    = {name = "First Degree Burn"       , pain_level = 2, bleeding = 0, heal_time = 1440},
	SECOND_DEGREE_BURN   = {name = "Second Degree Burn"      , pain_level = 5, bleeding = 0, heal_time = 2400},
	THIRD_DEGREE_BURN    = {name = "Third Degree Burn"       , pain_level = 1, bleeding = 0},
	INFECTION            = {name = "Infection"               , pain_level = 0, bleeding = 0},
	SMALL_GUN_SHOT       = {name = "Small Gun Shot Entrance" , pain_level = 5, bleeding = 1},
	MEDIUM_GUN_SHOT      = {name = "Medium Gun Shot Entrance", pain_level = 6, bleeding = 2},
	LARGE_GUN_SHOT       = {name = "Large Gun Shot Entrance" , pain_level = 9, bleeding = 3},
	SMALL_GUN_SHOT_EXIT  = {name = "Small Gun Shot Exit"     , pain_level = 5, bleeding = 2},
	MEDIUM_GUN_SHOT_EXIT = {name = "Medium Gun Shot Exit"    , pain_level = 6, bleeding = 3},
	LARGE_GUN_SHOT_EXIT  = {name = "Large Gun Shot Exit"     , pain_level = 9, bleeding = 5},
	BROKEN_BONE          = {name = "Broken Bone"             , pain_level = 6, bleeding = 0},
	SMALL_INCISION       = {name = "Small Incision"          , pain_level = 3, bleeding = 2},
	INCISION             = {name = "Incision"                , pain_level = 5, bleeding = 3},
	LARGE_INCISION       = {name = "Large Incision"          , pain_level = 6, bleeding = 5},
	FRACTURE             = {name = "Fracture"                , pain_level = 3, bleeding = 0},
	BULLET_FRAGMENTS     = {name = "Bullet Fragments"        , pain_level = 4, bleeding = 0},
	TASER_PRONGS         = {name = "Taser Prongs"            , pain_level = 1, bleeding = 0}
}

ITEMS = {

	BANDAGES = {
		BANDAGE          = {name = "Bandage"},
		DRESSING         = {name = "Dressing"},
		COMPRESSION      = {name = "Compression"},
		GAUZE            = {name = "Gauze"},
		USED_BANDAGE     = {name = "Used Bandage"},
		USED_DRESSING    = {name = "Used Dressing"},
		USED_COMPRESSION = {name = "Used Compression"},
		USED_GAUZE       = {name = "Used Gauze"},
		SPLINT           = {name = "Splint"},
		NECK_BRACE       = {name = "Neck Brace"},
		TOURNIQUET       = {name = "Tourniquet"},
		STITCHING        = {name = "Stitching"},
		OLD_STITCHING    = {name = "Old Stitching"},
		ALCOHOL_PAD      = {name = "Alcohol Pad"}
	},
	INJECTABLES = {
		MORPHINE      = {name = "Morphine"     , effect_time = 60*5},
		EPINEPHRINE   = {name = "Epinephrine"  , effect_time = 60*1},
		SALINE_250ML  = {name = "Saline 250ml" , effect_time = 60*1},
		SALINE_500ML  = {name = "Saline 500ml" , effect_time = 60*2},
		SALINE_750ML  = {name = "Saline 750ml" , effect_time = 60*3},
		SALINE_1000ML = {name = "Saline 1000ml", effect_time = 60*4},
		BLOOD_250ML   = {name = "Blood 250ml"  , effect_time = 60*1},
		BLOOD_500ML   = {name = "Blood 500ml"  , effect_time = 60*2},
		BLOOD_750ML   = {name = "Blood 750ml"  , effect_time = 60*3},
		BLOOD_1000ML  = {name = "Blood 1000ml" , effect_time = 60*4},
	},
	MEDICATION = {
		ACETAMINOPHEN = {name = "Acetaminophen"},
		ASPIRIN       = {name = "Aspirin"},
		IBUPROFEN     = {name = "Ibuprofen"}
	},
	DRUGS = {
		METH = {name = "Meth", effect_time = 60}
	}

}

DAMAGE_SEVERITY_TYPES = {

	NONE      = 1,
	MINOR     = 2,
	MEDIUM    = 3,
	SEVERE    = 4,
	CRTICICAL = 5

}

EFFECTS = {
	SHOCK             = {name = "Shock"        , effect_time = 60*20},
	ADRENALINE        = {name = "Adrenaline"   , modifiers = {stimulant = 2}, effect_time = 35},
	NO_ADRENALINE     = {name = "No Adrenaline", effect_time = 60*5},
	FATIGUE           = {name = "Fatigue"      , effect_time = 60*5},
	KNOCKED_OUT       = {name = "Knocked Out"  , effect_time = 15},
	BLACK_OUT         = {name = "Black Out"    , effect_time = 4},
	UNCONSCIOUS       = {name = "Unconscious"  , effect_time = 60*10},
	LIMPING           = {name = "Limping"      , effect_time = 60*2},
	TAZED             = {name = "Tazed"        , effect_time = 10},
	DEHYDRATED        = {name = "Dehydrated"   , effect_time = 60},
	STARVED           = {name = "Starved"      , effect_time = 60},

	MORPHINE      = ITEMS.INJECTABLES.MORPHINE,
	EPINEPHRINE   = ITEMS.INJECTABLES.EPINEPHRINE,
	SALINE_250ML  = ITEMS.INJECTABLES.SALINE_250ML,
	SALINE_500ML  = ITEMS.INJECTABLES.SALINE_500ML,
	SALINE_750ML  = ITEMS.INJECTABLES.SALINE_750ML,
	SALINE_1000ML = ITEMS.INJECTABLES.SALINE_1000ML,
	BLOOD_250ML   = ITEMS.INJECTABLES.BLOOD_250ML,
	BLOOD_500ML   = ITEMS.INJECTABLES.BLOOD_500ML,
	BLOOD_750ML   = ITEMS.INJECTABLES.BLOOD_750ML,
	BLOOD_1000ML  = ITEMS.INJECTABLES.BLOOD_1000ML,

	ACETAMINOPHEN = ITEMS.MEDICATION.ACETAMINOPHEN,
	ASPIRIN       = ITEMS.MEDICATION.ASPIRIN,
	IBUPROFEN     = ITEMS.MEDICATION.IBUPROFEN,

	METH          = ITEMS.DRUGS.METH
}

WEAPON_TYPES = {
	MILD_BLUNT                 = 1,
	BLUNT                      = 2,
	SEVERE_BLUNT               = 3,
	SHARP                      = 4,
	SEVERE_SHARP               = 5,
	SMALL_CALIBER_ROUND        = 6,
	MEDIUM_SMALL_CALIBER_ROUND = 7,
	MEDIUM_CALIBER_ROUND       = 8,
	LARGE_CALIBER_ROUND        = 9,
	LESS_LETHAL                = 10,
	FIRE                       = 11,
	TEETH                      = 12,
	HAND                       = 13,
	ARROW                      = 14,
	SEVERE_ARROW               = 15,
	EXPLOSION                  = 16,
	SHOTGUN_SHELL              = 17,
	SEVERE_SHOTGUN_SHELL       = 18,
	VEHICLE                    = 19,
	FALL                       = 20,
	DROWNING                   = 21,
	MILD_IRRITANT              = 22,
	IRRITANT                   = 23,
	SEVERE_IRRITANT            = 24
}

WEAPON_HASHES = {
	WEAPON_DAGGER      = {name = "WEAPON_DAGGER", hash = 0x92A27487, weapon_type = WEAPON_TYPES.SHARP},
	WEAPON_BOTTLE      = {name = "WEAPON_BOTTLE", hash = 0xF9E6AA4B, weapon_type = WEAPON_TYPES.SHARP},
	WEAPON_FLASHLIGHT  = {name = "WEAPON_FLASHLIGHT", hash = 0x8BB05FD7, weapon_type = WEAPON_TYPES.BLUNT},
	WEAPON_HATCHET     = {name = "WEAPON_HATCHET", hash = 0xF9DCBF2D, weapon_type = WEAPON_TYPES.SEVERE_SHARP},
	WEAPON_KNUCKLE     = {name = "WEAPON_KNUCKLE", hash = 0xD8DF3C3C, weapon_type = WEAPON_TYPES.BLUNT},
	WEAPON_MACHETE     = {name = "WEAPON_MACHETE", hash = 0xDD5DF8D9, weapon_type = WEAPON_TYPES.SEVERE_SHARP},
	WEAPON_SWITCHBLADE = {name = "WEAPON_SWITCHBLADE", hash = 0xDFE37640, weapon_type = WEAPON_TYPES.SHARP},
	WEAPON_WRENCH      = {name = "WEAPON_WRENCH", hash = 0x19044EE0, weapon_type = WEAPON_TYPES.SEVERE_BLUNT},
	WEAPON_BATTLEAXE   = {name = "WEAPON_BATTLEAXE", hash = 0xCD274149, weapon_type = WEAPON_TYPES.SEVERE_SHARP},
	WEAPON_POOLCUE     = {name = "WEAPON_POOLCUE", hash = 0x94117305, weapon_type = WEAPON_TYPES.SEVERE_BLUNT},
	WEAPON_STONE_HATCHET = {name = "WEAPON_STONE_HATCHET", hash = 0x3813FC08, weapon_type = WEAPON_TYPES.SHARP},

	WEAPON_PISTOL_MK2     = {name = "WEAPON_PISTOL_MK2", hash = 0xBFE256D4, weapon_type = WEAPON_TYPES.MEDIUM_CALIBER_ROUND},
	WEAPON_SNSPISTOL      = {name = "WEAPON_SNSPISTOL", hash = 0xBFD21232, weapon_type = WEAPON_TYPES.SMALL_CALIBER_ROUND},
	WEAPON_SNSPISTOL_MK2  = {name = "WEAPON_SNSPISTOL_MK2", hash = 0x88374054, weapon_type = WEAPON_TYPES.SMALL_CALIBER_ROUND},
	WEAPON_HEAVYPISTOL    = {name = "WEAPON_HEAVYPISTOL", hash = 0xD205520E, weapon_type = WEAPON_TYPES.MEDIUM_SMALL_CALIBER_ROUND},
	WEAPON_VINTAGEPISTOL  = {name = "WEAPON_VINTAGEPISTOL", hash = 0x83839C4, weapon_type = WEAPON_TYPES.SMALL_CALIBER_ROUND},
	WEAPON_FLAREGUN       = {name = "WEAPON_FLAREGUN", hash = 0x47757124, weapon_type = WEAPON_TYPES.FIRE},
	WEAPON_MARKSMANPISTOL = {name = "WEAPON_MARKSMANPISTOL", hash = 0xDC4DB296, weapon_type = WEAPON_TYPES.MEDIUM_CALIBER_ROUND},
	WEAPON_REVOLVER       = {name = "WEAPON_REVOLVER", hash = 0xC1B3C3D1, weapon_type = WEAPON_TYPES.MEDIUM_CALIBER_ROUND},
	WEAPON_REVOLVER_MK2   = {name = "WEAPON_REVOLVER_MK2", hash = 0xCB96392F, weapon_type = WEAPON_TYPES.MEDIUM_CALIBER_ROUND},
	WEAPON_DOUBLEACTION   = {name = "WEAPON_DOUBLEACTION", hash = 0x97EA20B8, weapon_type = WEAPON_TYPES.MEDIUM_CALIBER_ROUND},
	WEAPON_RAYPISTOL      = {name = "WEAPON_RAYPISTOL", hash = 0xAF3696A1, weapon_type = WEAPON_TYPES.SEVERE_BLUNT},
	WEAPON_CERAMICPISTOL  = {name = "WEAPON_CERAMICPISTOL", hash = 0x2B5EF5EC, weapon_type = WEAPON_TYPES.SMALL_CALIBER_ROUND},
	WEAPON_NAVYREVOLVER   = {name = "WEAPON_NAVYREVOLVER", hash = 0x917F6C8C, weapon_type = WEAPON_TYPES.MEDIUM_CALIBER_ROUND},
	WEAPON_GADGETPISTOL   = {name = "WEAPON_GADGETPISTOL", hash = 0x57A4368C, weapon_type = WEAPON_TYPES.SMALL_CALIBER_ROUND},
	WEAPON_SMG_MK2        = {name = "WEAPON_SMG_MK2", hash = 0x78A97CD0, weapon_type = WEAPON_TYPES.MEDIUM_CALIBER_ROUND},
	WEAPON_ASSAULTSMG     = {name = "WEAPON_ASSAULTSMG", hash = 0xEFE7E2DF, weapon_type = WEAPON_TYPES.MEDIUM_CALIBER_ROUND},
	WEAPON_COMBATPDW      = {name = "WEAPON_COMBATPDW", hash = 0x0A3D4D34, weapon_type = WEAPON_TYPES.MEDIUM_CALIBER_ROUND},
	WEAPON_MACHINEPISTOL  = {name = "WEAPON_MACHINEPISTOL", hash = 0xDB1AA450, weapon_type = WEAPON_TYPES.SMALL_CALIBER_ROUND},
	WEAPON_MINISMG        = {name = "WEAPON_MINISMG", hash = 0xBD248B55, weapon_type = WEAPON_TYPES.SMALL_CALIBER_ROUND},
	WEAPON_RAYCARBINE     = {name = "WEAPON_RAYCARBINE", hash = 0x476BF155, weapon_type = WEAPON_TYPES.LARGE_CALIBER_ROUND},

	WEAPON_PUMPSHOTGUN_MK2 = {name = "WEAPON_PUMPSHOTGUN_MK2", hash = 0x555AF99A, weapon_type = WEAPON_TYPES.SHOTGUN_SHELL},
	WEAPON_MUSKET        = {name = "WEAPON_MUSKET", hash = 0xA89CB99E, weapon_type = WEAPON_TYPES.MEDIUM_CALIBER_ROUND},
	WEAPON_HEAVYSHOTGUN  = {name = "WEAPON_HEAVYSHOTGUN", hash = 0x3AABBBAA, weapon_type = WEAPON_TYPES.SHOTGUN_SHELL},
	WEAPON_DBSHOTGUN     = {name = "WEAPON_DBSHOTGUN", hash = 0xEF951FBB, weapon_type = WEAPON_TYPES.SHOTGUN_SHELL},
	WEAPON_AUTOSHOTGUN   = {name = "WEAPON_AUTOSHOTGUN", hash = 0x12E82D3D, weapon_type = WEAPON_TYPES.SHOTGUN_SHELL},
	WEAPON_COMBATSHOTGUN = {name = "WEAPON_COMBATSHOTGUN", hash = 0x5A96BA4, weapon_type = WEAPON_TYPES.SEVERE_SHOTGUN_SHELL},

	WEAPON_ASSAULTRIFLE_MK2   = {name = "WEAPON_ASSAULTRIFLE_MK2", hash = 0x394F415C, weapon_type = WEAPON_TYPES.LARGE_CALIBER_ROUND},
	WEAPON_CARBINERIFLE_MK2   = {name = "WEAPON_CARBINERIFLE_MK2", hash = 0xFAD1F1C9, weapon_type = WEAPON_TYPES.LARGE_CALIBER_ROUND},
	WEAPON_SPECIALCARBINE     = {name = "WEAPON_SPECIALCARBINE", hash = 0xC0A3098D, weapon_type = WEAPON_TYPES.LARGE_CALIBER_ROUND},
	WEAPON_SPECIALCARBINE_MK2 = {name = "WEAPON_SPECIALCARBINE_MK2", hash = 0x969C3D67, weapon_type = WEAPON_TYPES.LARGE_CALIBER_ROUND},
	WEAPON_BULLPUPRIFLE       = {name = "WEAPON_BULLPUPRIFLE", hash = 0x7F229F94, weapon_type = WEAPON_TYPES.MEDIUM_CALIBER_ROUND},
	WEAPON_BULLPUPRIFLE_MK2   = {name = "WEAPON_BULLPUPRIFLE_MK2", hash = 0x84D6FAFD, weapon_type = WEAPON_TYPES.MEDIUM_CALIBER_ROUND},
	WEAPON_COMPACTRIFLE       = {name = "WEAPON_COMPACTRIFLE", hash = 0x624FE830, weapon_type = WEAPON_TYPES.LARGE_CALIBER_ROUND},
	WEAPON_MILITARYRIFLE      = {name = "WEAPON_MILITARYRIFLE", hash = 0x9D1F17E6, weapon_type = WEAPON_TYPES.LARGE_CALIBER_ROUND},
	WEAPON_COMBATMG_MK2       = {name = "WEAPON_COMBATMG_MK2", hash = 0xDBBD7280, weapon_type = WEAPON_TYPES.LARGE_CALIBER_ROUND},
	WEAPON_GUSENBERG          = {name = "WEAPON_GUSENBERG", hash = 0x61012683, weapon_type = WEAPON_TYPES.MEDIUM_CALIBER_ROUND},

	WEAPON_HEAVYSNIPER_MK2 = {name = "WEAPON_HEAVYSNIPER_MK2", hash = 0xA914799, weapon_type = WEAPON_TYPES.LARGE_CALIBER_ROUND},
	WEAPON_MARKSMANRIFLE   = {name = "WEAPON_MARKSMANRIFLE", hash = 0xC734385A, weapon_type = WEAPON_TYPES.MEDIUM_CALIBER_ROUND},
	WEAPON_MARKSMANRIFLE_MK2 = {name = "WEAPON_MARKSMANRIFLE_MK2", hash = 0x6A6C02E0, weapon_type = WEAPON_TYPES.MEDIUM_CALIBER_ROUND},
	WEAPON_FIREWORK        = {name = "WEAPON_FIREWORK", hash = 0x7F7497E5, weapon_type = WEAPON_TYPES.EXPLOSION},
	WEAPON_RAILGUN         = {name = "WEAPON_RAILGUN", hash = 0x6D544C99, weapon_type = WEAPON_TYPES.LARGE_CALIBER_ROUND},
	WEAPON_HOMINGLAUNCHER  = {name = "WEAPON_HOMINGLAUNCHER", hash = 0x63AB0442, weapon_type = WEAPON_TYPES.EXPLOSION},
	WEAPON_COMPACTLAUNCHER = {name = "WEAPON_COMPACTLAUNCHER", hash = 0x0781FE4A, weapon_type = WEAPON_TYPES.EXPLOSION},
	WEAPON_RAYMINIGUN      = {name = "WEAPON_RAYMINIGUN", hash = 0xB62D1F67, weapon_type = WEAPON_TYPES.LARGE_CALIBER_ROUND},
	WEAPON_PROXMINE        = {name = "WEAPON_PROXMINE", hash = 0xAB564B93, weapon_type = WEAPON_TYPES.EXPLOSION},

    WEAPON_UNARMED               = {name = "WEAPON_UNARMED", hash = 0xA2719263, weapon_type = WEAPON_TYPES.HAND},
    WEAPON_ANIMAL                = {name = "WEAPON_ANIMAL", hash = 0xF9FBAEBE, weapon_type = WEAPON_TYPES.TEETH},
    WEAPON_COUGAR                = {name = "WEAPON_COUGAR", hash = 0x08D4BE52, weapon_type = WEAPON_TYPES.TEETH},
    WEAPON_KNIFE                 = {name = "WEAPON_KNIFE", hash = 0x99B507EA, weapon_type = WEAPON_TYPES.SHARP},
    WEAPON_NIGHTSTICK            = {name = "WEAPON_NIGHTSTICK", hash = 0x678B81B1, weapon_type = WEAPON_TYPES.BLUNT},
    WEAPON_HAMMER                = {name = "WEAPON_HAMMER", hash = 0x4E875F73, weapon_type = WEAPON_TYPES.SEVERE_BLUNT},
    WEAPON_BAT                   = {name = "WEAPON_BAT", hash = 0x958A4A8F, weapon_type = WEAPON_TYPES.BLUNT},
    WEAPON_GOLFCLUB              = {name = "WEAPON_GOLFCLUB", hash = 0x440E4788, weapon_type = WEAPON_TYPES.BLUNT},
    WEAPON_CROWBAR               = {name = "WEAPON_CROWBAR", hash = 0x84BD7BFD, weapon_type = WEAPON_TYPES.SEVERE_ARROW},
    WEAPON_PISTOL                = {name = "WEAPON_PISTOL", hash = 0x1B06D571, weapon_type = WEAPON_TYPES.SMALL_CALIBER_ROUND},
    WEAPON_COMBATPISTOL          = {name = "WEAPON_COMBATPISTOL", hash = 0x5EF9FEC4, weapon_type = WEAPON_TYPES.SMALL_CALIBER_ROUND},
    WEAPON_APPISTOL              = {name = "WEAPON_APPISTOL", hash = 0x22D8FE39, weapon_type = WEAPON_TYPES.MEDIUM_CALIBER_ROUND},
    WEAPON_PISTOL50              = {name = "WEAPON_PISTOL50", hash = 0x99AEEB3B, weapon_type = WEAPON_TYPES.MEDIUM_CALIBER_ROUND},
    WEAPON_MICROSMG              = {name = "WEAPON_MICROSMG", hash = 0x13532244, weapon_type = WEAPON_TYPES.SMALL_CALIBER_ROUND},
    WEAPON_SMG                   = {name = "WEAPON_SMG", hash = 0x2BE6766B, weapon_type = WEAPON_TYPES.MEDIUM_CALIBER_ROUND},
    WEAPON_ASSAULTRIFLE          = {name = "WEAPON_ASSAULTRIFLE", hash = 0xBFEFFF6D, weapon_type = WEAPON_TYPES.LARGE_CALIBER_ROUND},
    WEAPON_CARBINERIFLE          = {name = "WEAPON_CARBINERIFLE", hash = 0x83BF0278, weapon_type = WEAPON_TYPES.LARGE_CALIBER_ROUND},
    WEAPON_ADVANCEDRIFLE         = {name = "WEAPON_ADVANCEDRIFLE", hash = 0xAF113F99, weapon_type = WEAPON_TYPES.LARGE_CALIBER_ROUND},
    WEAPON_MG                    = {name = "WEAPON_MG", hash = 0x9D07F764, weapon_type = WEAPON_TYPES.MEDIUM_CALIBER_ROUND},
    WEAPON_COMBATMG              = {name = "WEAPON_COMBATMG", hash = 0x7FD62962, weapon_type = WEAPON_TYPES.LARGE_CALIBER_ROUND},
    WEAPON_PUMPSHOTGUN           = {name = "WEAPON_PUMPSHOTGUN", hash = 0x1D073A89, weapon_type = WEAPON_TYPES.SHOTGUN_SHELL},
    WEAPON_SAWNOFFSHOTGUN        = {name = "WEAPON_SAWNOFFSHOTGUN", hash = 0x7846A318, weapon_type = WEAPON_TYPES.SHOTGUN_SHELL},
    WEAPON_ASSAULTSHOTGUN        = {name = "WEAPON_ASSAULTSHOTGUN", hash = 0xE284C527, weapon_type = WEAPON_TYPES.SHOTGUN_SHELL},
    WEAPON_BULLPUPSHOTGUN        = {name = "WEAPON_BULLPUPSHOTGUN", hash = 0x9D61E50F, weapon_type = WEAPON_TYPES.SHOTGUN_SHELL},
    WEAPON_STUNGUN               = {name = "WEAPON_STUNGUN", hash = 0x3656C8C1, weapon_type = WEAPON_TYPES.LESS_LETHAL},
    WEAPON_SNIPERRIFLE           = {name = "WEAPON_SNIPERRIFLE", hash = 0x05FC3C11, weapon_type = WEAPON_TYPES.MEDIUM_CALIBER_ROUND},
    WEAPON_HEAVYSNIPER           = {name = "WEAPON_HEAVYSNIPER", hash = 0x0C472FE2, weapon_type = WEAPON_TYPES.LARGE_CALIBER_ROUND},
    WEAPON_REMOTESNIPER          = {name = "WEAPON_REMOTESNIPER", hash = 0x33058E22, weapon_type = WEAPON_TYPES.MEDIUM_CALIBER_ROUND},
    WEAPON_GRENADELAUNCHER       = {name = "WEAPON_GRENADELAUNCHER", hash = 0xA284510B, weapon_type = WEAPON_TYPES.EXPLOSION},
    WEAPON_GRENADELAUNCHER_SMOKE = {name = "WEAPON_GRENADELAUNCHER_SMOKE", hash = 0x4DD2DC56, weapon_type = WEAPON_TYPES.MILD_IRRITANT},
    WEAPON_RPG                   = {name = "WEAPON_RPG", hash = 0xB1CA77B1, weapon_type = WEAPON_TYPES.EXPLOSION},
    WEAPON_PASSENGER_ROCKET      = {name = "WEAPON_PASSENGER_ROCKET", hash = 0x166218FF, weapon_type = WEAPON_TYPES.EXPLOSION},
    WEAPON_AIRSTRIKE_ROCKET      = {name = "WEAPON_AIRSTRIKE_ROCKET", hash = 0x13579279, weapon_type = WEAPON_TYPES.EXPLOSION},
    WEAPON_STINGER               = {name = "WEAPON_STINGER", hash = 0x687652CE, weapon_type = WEAPON_TYPES.EXPLOSION},
    WEAPON_MINIGUN               = {name = "WEAPON_MINIGUN", hash = 0x42BF8A85, weapon_type = WEAPON_TYPES.LARGE_CALIBER_ROUND},
    WEAPON_GRENADE               = {name = "WEAPON_GRENADE", hash = 0x93E220BD, weapon_type = WEAPON_TYPES.EXPLOSION},
    WEAPON_STICKYBOMB            = {name = "WEAPON_STICKYBOMB", hash = 0x2C3731D9, weapon_type = WEAPON_TYPES.EXPLOSION},
    WEAPON_SMOKEGRENADE          = {name = "WEAPON_SMOKEGRENADE", hash = 0xFDBC8A50, weapon_type = WEAPON_TYPES.MILD_IRRITANT},
    WEAPON_BZGAS                 = {name = "WEAPON_BZGAS", hash = 0xA0973D5E, weapon_type = WEAPON_TYPES.SEVERE_IRRITANT},
    WEAPON_MOLOTOV               = {name = "WEAPON_MOLOTOV", hash = 0x24B17070, weapon_type = WEAPON_TYPES.FIRE},
    WEAPON_FIREEXTINGUISHER      = {name = "WEAPON_FIREEXTINGUISHER",  hash = 0x060EC506},
    WEAPON_PETROLCAN             = {name = "WEAPON_PETROLCAN", hash = 0x34A67B97},
    WEAPON_DIGISCANNER           = {name = "WEAPON_DIGISCANNER", hash = 0xFDBADCED},
    WEAPON_BRIEFCASE             = {name = "WEAPON_BRIEFCASE", hash = 0x88C78EB7},
    WEAPON_BRIEFCASE_02          = {name = "WEAPON_BRIEFCASE_02", hash = 0x01B79F17},
    WEAPON_BALL                  = {name = "WEAPON_BALL", hash = 0x23C9F95C, weapon_type = WEAPON_TYPES.MILD_BLUNT},
    WEAPON_FLARE                 = {name = "WEAPON_FLARE",  hash = 0x497FACC3, weapon_type = WEAPON_TYPES.FIRE},
    WEAPON_VEHICLE_ROCKET        = {name = "WEAPON_VEHICLE_ROCKET", hash = 0xBEFDC581, weapon_type = WEAPON_TYPES.EXPLOSION},
    WEAPON_BARBED_WIRE           = {name = "WEAPON_BARBED_WIRE", hash = 0x48E7B178, weapon_type = WEAPON_TYPES.SHARP},
    WEAPON_DROWNING              = {name = "WEAPON_DROWNING", hash = 0xFF58C4FB, weapon_type = WEAPON_TYPES.DROWNING},
    WEAPON_DROWNING_IN_VEHICLE   = {name = "WEAPON_DROWNING_IN_VEHICLE", hash = 0x736F5990, weapon_type = WEAPON_TYPES.DROWNING},
    WEAPON_BLEEDING              = {name = "WEAPON_BLEEDING", hash = 0x8B7333FB},
    WEAPON_ELECTRIC_FENCE        = {name = "WEAPON_ELECTRIC_FENCE", hash = 0x92BD4EBB},
    WEAPON_EXPLOSION             = {name = "WEAPON_EXPLOSION", hash = 0x2024F4E8, weapon_type = WEAPON_TYPES.EXPLOSION},
    WEAPON_FALL                  = {name = "WEAPON_FALL", hash = 0xCDC174B0, weapon_type = WEAPON_TYPES.FALL},
    WEAPON_EXHAUSTION            = {name = "WEAPON_EXHAUSTION", hash = 0x364A29EC},
    WEAPON_HIT_BY_WATER_CANNON   = {name = "WEAPON_HIT_BY_WATER_CANNON", hash = 0xCC34325E, weapon_type = WEAPON_TYPES.BLUNT},
    WEAPON_RAMMED_BY_CAR         = {name = "WEAPON_RAMMED_BY_CAR", hash = 0x07FC7D7A, weapon_type = WEAPON_TYPES.VEHICLE},
    WEAPON_RUN_OVER_BY_CAR       = {name = "WEAPON_RUN_OVER_BY_CAR", hash = 0xA36D413E, weapon_type = WEAPON_TYPES.VEHICLE},
    WEAPON_HELI_CRASH            = {name = "WEAPON_HELI_CRASH", hash = 0x145F1012, weapon_type = WEAPON_TYPES.EXPLOSION},
    WEAPON_FIRE                  = {name = "WEAPON_FIRE", hash = 0xDF8E89EB, weapon_type = WEAPON_TYPES.FIRE}
}