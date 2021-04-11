
function get_nearby_interaction_points_async(callback)

    local player_coords = GetEntityCoords(PlayerPedId())
    trigger_server_callback_async("em_fw:get_nearby_interaction_points", callback, player_coords.x, player_coords.y, player_coords.z)

end

function get_all_interaction_props_async(callback)

    trigger_server_callback_async("em_fw:get_all_interaction_props", callback)

end

function get_nearby_interaction_peds_async(callback)

    local player_coords = GetEntityCoords(PlayerPedId())
    trigger_server_callback_async("em_fw:get_nearby_interaction_peds", callback, player_coords.x, player_coords.y, player_coords.z)

end