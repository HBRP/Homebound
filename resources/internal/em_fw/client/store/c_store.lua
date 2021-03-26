

function get_nearby_stores_async(callback)

    local player_coords = GetEntityCoords(PlayerPedId())
    trigger_server_callback_async("em_fw:get_nearby_stores", callback, player_coords.x, player_coords.y, player_coords.z)

end