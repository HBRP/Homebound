
function add_wound(bone, wound_type, amount)

	local amount_to_add = amount or 1
	local bone_part     = bone.general_body_part
	local wound_type    = wound_type

	if PLAYER.WOUNDS[bone_part] == nil then
		PLAYER.WOUNDS[bone_part] = {}
	end

	for i = 1, amount_to_add do

		table.insert(PLAYER.WOUNDS[bone_part], {name = wound_type.name, bandages = {}})
		if wound_type.heal_time ~= nil then
			PLAYER.WOUNDS[bone_part][#PLAYER.WOUNDS[bone_part]].heal_time = wound_type.heal_time * 1000
			PLAYER.WOUNDS[bone_part][#PLAYER.WOUNDS[bone_part]].last_update_time = GetGameTimer()
		end

	end

end

function apply_weapon_damage(out_bone, weapon)

    local bone = nil
    for _, temp_bone_info in pairs(CHECKED_BONES) do
        
        if temp_bone_info.hash == out_bone then
            bone = temp_bone_info
            break
        end

    end

	if bone == nil then
		print("Unknown bone " .. json.encode(out_bone))
        return -1
	end
	
	if weapon.damage == nil then
		print("Weapon not registered to damage: " .. weapon.name)
		return 0
	end

	apply_adrenaline()
	weapon.damage(bone, weapon)

	if bone.reaction ~= nil then
		bone.reaction(bone, weapon)
	end

	if weapon.reaction ~= nil then
		weapon.reaction()
	end

end

function attempt_to_apply_weapon_type_damage(weapon)

	if weapon.name == "WEAPON_RUN_OVER_BY_CAR" then

		apply_vehicle(CHECKED_BONES.SPR_L_Breast, nil)
		apply_vehicle(CHECKED_BONES.SPR_R_Breast, nil)

		apply_vehicle(CHECKED_BONES.SKEL_L_UpperArm, nil)
		apply_vehicle(CHECKED_BONES.SKEL_R_UpperArm, nil)

	elseif weapon.name == "WEAPON_RAMMED_BY_CAR" then

		apply_hand(CHECKED_BONES.SKEL_Head, nil)
		apply_hand(CHECKED_BONES.SPR_L_Breast, nil)
		apply_hand(CHECKED_BONES.SPR_R_Breast, nil)

	elseif weapon.name == "WEAPON_UNARMED" then

		apply_hand(CHECKED_BONES.SKEL_Head, nil)
		apply_hand(CHECKED_BONES.SKEL_R_Clavicle, nil)
		apply_hand(CHECKED_BONES.SKEL_L_Clavicle, nil)

	else
		apply_weapon_damage(CHECKED_BONES.SM_CockNBalls, weapon)
	end

end

local function wound_heal_time(body_part, wound)

	if wound.heal_time == nil then
		return 0 
	end

	local current_time = GetGameTimer()
	local dt = current_time - wound.last_update_time

	wound.heal_time        = wound.heal_time - dt
	wound.last_update_time = current_time

end

function check_wound_heal_time()

	if is_player_unconscious() then
		return 0
	end

	for body_part, wounds in pairs(PLAYER.WOUNDS) do
		
		for i = 1, #wounds do

			wound_heal_time(body_part, wounds[i])

		end

		for i = #wounds, 1, -1 do

			if wounds[i].heal_time ~= nil and wounds[i].heal_time <= 0 then
				table.remove(wounds, i)
			end

		end

	end

end

function body_part_cleanup()

	for body_part, wounds in pairs(PLAYER.WOUNDS) do
		if next(wounds) == nil then
			PLAYER.WOUNDS[body_part] = nil
		end
	end

end

function register_weapon_type_damages(weapon_type, damage_function)

	for weapon_name, weapon_info in pairs(WEAPON_HASHES) do

		if weapon_type == weapon_info.weapon_type then

			weapon_info.damage = damage_function

		end

	end

end