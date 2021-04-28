
function get_nearby_houses_async(callback, housing_type_id)

    local player_coords = GetEntityCoords(PlayerPedId())
    trigger_server_callback_async("em_fw:get_nearby_houses", callback, housing_type_id, get_character_id(), player_coords.x, player_coords.y, player_coords.z)

end

function get_house_async(callback, house_id)

    trigger_server_callback_async("em_fw:get_house", callback, house_id)

end

function toggle_housing_door_lock_async(callback, housing_door_id)

    trigger_server_callback_async("em_fw:toggle_housing_door_lock", callback, housing_door_id)

end