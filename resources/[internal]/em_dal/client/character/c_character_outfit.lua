

function create_outfit(outfit_name, outfit)

    trigger_server_callback("em_dal:create_outfit", function()

    end, get_character_id(), outfit_name, outfit)

end

function update_outfit(character_outfit_id, outfit_name, outfit)

    trigger_server_callback("em_dal:update_outfit", function()

    end, character_outfit_id, outfit_name,  outfit)

end

function get_outfit(character_outfit_id)

    local current_outfit = nil

    trigger_server_callback("em_dal:get_outfit", function(outfit)

        current_outfit = outfit
        current_outfit["outfit"] = json.decode(current_outfit["outfit"])
        
    end, character_outfit_id)

    return current_outfit
end

function get_active_outfit()

    local active_outfit = nil
    trigger_server_callback("em_dal:get_active_outfit", function(outfit)

        active_outfit = outfit

    end, get_character_id())

    return active_outfit

end

function delete_outfit(character_outfit_id)

    trigger_server_callback("em_dal:delete_outfit", function()

    end, character_outfit_id)

end

function get_all_outfit_meta_data()

    local meta_data_outfits = nil
    trigger_server_callback("em_dal:get_all_outfit_meta_data", function(outfits)

        meta_data_outfits = outfits

    end, get_character_id())

    return meta_data_outfits

end

function create_skin(character_skin)

    trigger_server_callback("em_dal:create_skin", function()

    end, get_character_id(), character_skin)

end

function update_skin(character_skin)

    trigger_server_callback("em_dal:update_skin", function()

    end, get_character_id(), character_skin)

end

function get_skin()

    local skin = nil
    trigger_server_callback("em_dal:get_skin", function(character_skin)

        if character_skin ~= nil then
            skin = character_skin
            skin["character_skin"] = json.decode(skin["character_skin"])
        end

    end, get_character_id())

    return skin

end