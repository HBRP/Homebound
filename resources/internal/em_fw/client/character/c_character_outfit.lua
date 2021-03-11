

function create_outfit(outfit_name, outfit)

    trigger_server_callback("em_fw:create_outfit", function()

    end, get_character_id(), outfit_name, outfit)

end

function update_outfit(character_outfit_id, outfit)

    trigger_server_callback("em_fw:update_outfit", function()

    end, character_outfit_id, outfit)

end

function get_outfit(character_outfit_id)

    trigger_server_callback("em_fw:get_outfit", function()

    end, character_outfit_id)

end

function get_active_outfit()

    local active_outfit = nil
    
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

    trigger_server_callback("em_fw:get_all_outfit_meta_data", function(outfits)

    end, get_character_id())

end