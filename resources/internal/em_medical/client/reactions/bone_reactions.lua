
local function check_to_knockout(bone, weapon)

	if PLAYER.SHORTERM_EFFECTS["Knocked Out"] ~= nil then
		return 0
	end

	local modifier = 1
	local comparison_modifier = 1

	if PLAYER.SHORTERM_EFFECTS["Adrenaline"] ~= nil then
		modifier = 0.5
	end

	if weapon.name == "WEAPON_UNARMED" then
		modifier = 1
		comparison_modifier = 0.5
	end

	if get_pain_level_body_part(GENERAL_BODY_PARTS.HEAD) * modifier >= 10 * comparison_modifier  then
		apply_short_term_effect(EFFECTS.KNOCKED_OUT)
	end

end

local function head_reaction(bone, weapon)

	check_to_knockout()

end




register_generic_body_part_reaction(GENERAL_BODY_PARTS.HEAD, head_reaction)