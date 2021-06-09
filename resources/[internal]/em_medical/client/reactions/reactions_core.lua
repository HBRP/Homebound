

function register_bone_reaction(bone, reaction_func)

	bone.reaction = reaction_func

end

function register_generic_body_part_reaction(body_part, reaction_func)

	for bone_name, bone_info in pairs(GENERAL_BODY_PARTS) do

		if body_part == bone_info.general_body_part then

			body_part.reaction = reaction_func

		end

	end

end

function register_weapon_reaction(weapon, weapon_func)

	weapon.reaction = weapon_func

end