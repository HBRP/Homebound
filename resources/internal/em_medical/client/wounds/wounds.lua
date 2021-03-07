local function apply_hand_damage(bone, weapon)

	add_wound(bone, WOUND_TYPES.SMALL_CONTUSION, 2)

end

local function apply_mild_blunt(bone, weapon)

	add_wound(bone, WOUND_TYPES.CONTUSION, 2)

end

local function apply_severe_blunt(bone, weapon)

	add_wound(bone, WOUND_TYPES.LACERATION, 1)
	add_wound(bone, WOUND_TYPES.LARGE_CONTUSION, 2)

end

local function apply_sharp(bone, weapon)

	add_wound(bone, WOUND_TYPES.PUNCTURE_WOUND)

end

local function apply_severe_sharp(bone, weapon)

	add_wound(bone, WOUND_TYPES.LARGE_PUNCTURE_WOUND)

end

local function chest_shot_and_has_body_armour(bone)

	if bone.general_body_part == GENERAL_BODY_PARTS.CHEST or bone.general_body_part == GENERAL_BODY_PARTS.BACK then
		return PLAYER_STATS.LAST_ARMOUR > 0
	end
	return false

end

local function apply_small_caliber_round(bone, weapon)

	if chest_shot_and_has_body_armour(bone) then

		add_wound(bone, WOUND_TYPES.CONTUSION)
		return

	end

	add_wound(bone, WOUND_TYPES.SMALL_GUN_SHOT)

	if math.random() <= 0.2 then
		add_wound(bone, WOUND_TYPES.BULLET_FRAGMENTS)
	else
		add_wound(bone, WOUND_TYPES.SMALL_GUN_SHOT_EXIT)
	end

end

local function apply_medium_small_caliber_round(bone, weapon)

	if chest_shot_and_has_body_armour(bone) then

		add_wound(bone, WOUND_TYPES.LARGE_CONTUSION)
		return
		
	end

	local wound = nil
	local exit  = nil

	if math.random() >= 0.6 then
		wound = WOUND_TYPES.MEDIUM_GUN_SHOT
		exit  = WOUND_TYPES.MEDIUM_GUN_SHOT_EXIT
	else
		wound = WOUND_TYPES.SMALL_GUN_SHOT
		exit  = WOUND_TYPES.SMALL_GUN_SHOT_EXIT
	end
	add_wound(bone, wound)

	if math.random() <= 0.15 then
		add_wound(bone, WOUND_TYPES.BULLET_FRAGMENTS)
	else
		add_wound(bone, exit)
	end

end

local function apply_medium_caliber_round(bone, weapon)

	if chest_shot_and_has_body_armour(bone) then

		add_wound(bone, WOUND_TYPES.LARGE_CONTUSION)
		return
		
	end

	add_wound(bone, WOUND_TYPES.MEDIUM_GUN_SHOT)

	if math.random() <= 0.15 then
		add_wound(bone, WOUND_TYPES.BULLET_FRAGMENTS)
	else
		add_wound(bone, WOUND_TYPES.MEDIUM_GUN_SHOT_EXIT)
	end

end

local function apply_large_caliber_round(bone, weapon)

	if chest_shot_and_has_body_armour(bone) then

		add_wound(bone, WOUND_TYPES.LARGE_CONTUSION)
		return
		
	end

	add_wound(bone, WOUND_TYPES.LARGE_GUN_SHOT)

	if math.random() <= 0.1 then
		add_wound(bone, WOUND_TYPES.BULLET_FRAGMENTS)
	else
		add_wound(bone, WOUND_TYPES.LARGE_GUN_SHOT_EXIT)
	end

end

local function apply_less_lethal(bone, weapon)

end

local function apply_fire(bone, weapon)

	add_wound(bone, WOUND_TYPES.SECOND_DEGREE_BURN)

end

local function apply_teeth(bone, weapon)

end

function apply_hand(bone, weapon)

	add_wound(bone, WOUND_TYPES.SMALL_CONTUSION)
	add_wound(bone, WOUND_TYPES.SMALL_LACERATION)

end

local function apply_arrow(bone, weapon)

	add_wound(bone, WOUND_TYPES.LARGE_PUNCTURE_WOUND)

end

local function apply_severe_arrow(bone, weapon)

end

local function apply_explosion(bone, weapon)

	add_wound(bone, WOUND_TYPES.SECOND_DEGREE_BURN)
	add_wound(bone, WOUND_TYPES.LARGE_LACERATION, 2)

end

local function apply_shotgun_shell(bone, weapon)

	local hit_severity = get_hit_severity()

	if hit_severity == DAMAGE_SEVERITY_TYPES.NONE then
        return 0
	end

	if chest_shot_and_has_body_armour(bone) then

		add_wound(bone, WOUND_TYPES.LARGE_CONTUSION)
		return
		
	end

	if hit_severity == DAMAGE_SEVERITY_TYPES.MINOR then
		add_wound(bone, WOUND_TYPES.SMALL_GUN_SHOT, 1)
		add_wound(bone, WOUND_TYPES.BULLET_FRAGMENTS)
	elseif hit_severity == DAMAGE_SEVERITY_TYPES.MEDIUM then
		add_wound(bone, WOUND_TYPES.SMALL_GUN_SHOT, 1)
		add_wound(bone, WOUND_TYPES.BULLET_FRAGMENTS, 2)
	else
		add_wound(bone, WOUND_TYPES.MEDIUM_GUN_SHOT, 4)
		add_wound(bone, WOUND_TYPES.BULLET_FRAGMENTS)
	end

end

local function apply_severe_shotgun_shell(bone, weapon)

	local hit_severity = get_hit_severity()

	if hit_severity == DAMAGE_SEVERITY_TYPES.NONE then
        return 0
	end

	if chest_shot_and_has_body_armour(bone) then

		add_wound(bone, WOUND_TYPES.LARGE_CONTUSION)
		return
		
	end

	if hit_severity == DAMAGE_SEVERITY_TYPES.MINOR then
		add_wound(bone, WOUND_TYPES.SMALL_GUN_SHOT, 1)
		add_wound(bone, WOUND_TYPES.BULLET_FRAGMENTS)
	elseif hit_severity == DAMAGE_SEVERITY_TYPES.MEDIUM then
		add_wound(bone, WOUND_TYPES.SMALL_GUN_SHOT, 2)
		add_wound(bone, WOUND_TYPES.MEDIUM_GUN_SHOT, 1)
		add_wound(bone, WOUND_TYPES.BULLET_FRAGMENTS)
	else
		add_wound(bone, WOUND_TYPES.MEDIUM_GUN_SHOT, 5)
		add_wound(bone, WOUND_TYPES.BULLET_FRAGMENTS)
	end

end

function apply_vehicle(bone, weapon)
	
	add_wound(bone, WOUND_TYPES.LACERATION, 3)
	add_wound(bone, WOUND_TYPES.CONTUSION, 2)

end

local function apply_fall(bone, weapon)

	local hit_severity = get_hit_severity()

    if hit_severity == DAMAGE_SEVERITY_TYPES.NONE then
        return 0
	end

    add_wound(bone, WOUND_TYPES.CONTUSION)

    if hit_severity == DAMAGE_SEVERITY_TYPES.MEDIUM then

    	add_wound(bone, WOUND_TYPES.CONTUSION)
        add_wound(bone, WOUND_TYPES.LACERATION)

    elseif hit_severity == DAMAGE_SEVERITY_TYPES.SEVERE then
        
        add_wound(bone, WOUND_TYPES.LARGE_CONTUSION)
        add_wound(bone, WOUND_TYPES.LARGE_LACERATION, 2)
        add_wound(bone, WOUND_TYPES.BROKEN_BONE, 3)

    elseif hit_severity == DAMAGE_SEVERITY_TYPES.CRTICICAL then
        
        add_wound(bone, WOUND_TYPES.LARGE_CONTUSION, 6)
        add_wound(bone, WOUND_TYPES.LARGE_LACERATION, 5)
        add_wound(bone, WOUND_TYPES.BROKEN_BONE, 7)

    end

end

local function apply_drowning(bone, weapon)

end

local function apply_mild_irritant(bone, weapon)

end

local function apply_irritant(bone, weapon)

end

local function apply_severe_irritant(bone, weapon)

end

register_weapon_type_damages(WEAPON_TYPES.MILD_BLUNT, apply_hand_damage)
register_weapon_type_damages(WEAPON_TYPES.BLUNT, apply_mild_blunt)
register_weapon_type_damages(WEAPON_TYPES.SEVERE_BLUNT, apply_severe_blunt)
register_weapon_type_damages(WEAPON_TYPES.SHARP, apply_sharp)
register_weapon_type_damages(WEAPON_TYPES.SEVERE_SHARP, apply_severe_sharp)
register_weapon_type_damages(WEAPON_TYPES.SMALL_CALIBER_ROUND, apply_small_caliber_round)
register_weapon_type_damages(WEAPON_TYPES.MEDIUM_CALIBER_ROUND, apply_medium_caliber_round)
register_weapon_type_damages(WEAPON_TYPES.MEDIUM_SMALL_CALIBER_ROUND, apply_medium_small_caliber_round)
register_weapon_type_damages(WEAPON_TYPES.LARGE_CALIBER_ROUND, apply_large_caliber_round)
register_weapon_type_damages(WEAPON_TYPES.LESS_LETHAL, apply_less_lethal)
register_weapon_type_damages(WEAPON_TYPES.FIRE, apply_fire)
register_weapon_type_damages(WEAPON_TYPES.TEETH, apply_teeth)
register_weapon_type_damages(WEAPON_TYPES.HAND, apply_hand)
register_weapon_type_damages(WEAPON_TYPES.ARROW, apply_arrow)
register_weapon_type_damages(WEAPON_TYPES.SEVERE_ARROW, apply_severe_arrow)
register_weapon_type_damages(WEAPON_TYPES.EXPLOSION, apply_explosion)
register_weapon_type_damages(WEAPON_TYPES.SHOTGUN_SHELL, apply_shotgun_shell)
register_weapon_type_damages(WEAPON_TYPES.SEVERE_SHOTGUN_SHELL, apply_severe_shotgun_shell)
register_weapon_type_damages(WEAPON_TYPES.VEHICLE, apply_vehicle)
register_weapon_type_damages(WEAPON_TYPES.FALL, apply_fall)
register_weapon_type_damages(WEAPON_TYPES.DROWNING, apply_drowning)
register_weapon_type_damages(WEAPON_TYPES.MILD_IRRITANT, apply_mild_irritant)
register_weapon_type_damages(WEAPON_TYPES.IRRITANT, apply_irritant)
register_weapon_type_damages(WEAPON_TYPES.SEVERE_IRRITANT, apply_severe_irritant)