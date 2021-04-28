
function get_nearby_houses_async(callback, housing_type_id)

    local player_coords = GetEntityCoords(PlayerPedId())
    trigger_server_callback_async("em_fw:get_nearby_houses", callback, housing_type_id, get_character_id(), player_coords.x, player_coords.y, player_coords.z)

end

function get_house(callback, house_id)

    trigger_server_callback_async("em_fw:get_house", callback, house_id)

end