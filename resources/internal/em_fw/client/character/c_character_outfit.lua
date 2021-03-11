

function create_outfit(outfit_name, outfit)

    Citizen.Trace("Creating outfit\n")
    trigger_server_callback("em_fw:create_outfit", function()

    end, get_character_id(), outfit_name, outfit)

end

function update_outfit(character_outfit_id, outfit_name, outfit)

    trigger_server_callback("em_fw:update_outfit", function()

    end, character_outfit_id, outfit_name,  outfit)

end

function get_outfit(character_outfit_id)

    trigger_server_callback("em_fw:get_outfit", function()

    end, character_outfit_id)

end

function get_active_outfit()

    local active_outfit = nil
    Citizen.Trace("Getting Active Outfit\n")
    trigger_server_callback("em_fw:get_active_outfit", function(outfit)

        active_outfit = outfit

    end, get_character_id())

    return active_outfit

end

function delete_outfit(character_outfit_id)

    trigger_server_callback("em_fw:delete_outfit", function()

    end, character_outfit_id)

end

function get_all_outfit_meta_data()

    local meta_data_outfits = nil
    trigger_server_callback("em_fw:get_all_outfit_meta_data", function(outfits)

        meta_data_outfits = outfits

    end, get_character_id())

    return meta_data_outfits

end

function create_skin(character_skin)

    Citizen.Trace("Creating Skin\n")
    trigger_server_callback("em_fw:create_skin", function()

    end, get_character_id(), character_skin)
    Citizen.Trace("Done Creating Skin\n")

end

function update_skin(character_skin)

    trigger_server_callback("em_fw:update_skin", function()

    end, get_character_id(), character_skin)

end

function get_skin()

    local skin = nil
    trigger_server_callback("em_fw:get_outfit", function(character_skin)

        skin = character_skin

    end, get_character_id())

    return skin

end