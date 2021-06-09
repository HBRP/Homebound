
local function stun_gun_reaction()

	if PLAYER.SHORTERM_EFFECTS["Meth"] ~= nil then

		if math.random() >= 0.8 then
			apply_short_term_effect(EFFECTS.TAZED)
		end

	else
		apply_short_term_effect(EFFECTS.TAZED)
	end

	if PLAYER.SHORTERM_EFFECTS["Tazed"] ~= nil then

		if math.random() <= 0.05 then
			apply_short_term_effect(EFFECTS.SHOCK)
		elseif math.random() <= 0.20 and PLAYER.SHORTERM_EFFECTS["Meth"] ~= nil then
			apply_short_term_effect(EFFECTS.SHOCK)
		end

	end

end

register_weapon_reaction(WEAPON_HASHES.WEAPON_STUNGUN, stun_gun_reaction)