

function get_all_customization_points_async()

end

function get_nearby_customization_points_async(callback)

    local player_coords = GetEntityCoords(PlayerPedId())
    trigger_server_callback("em_fw:get_nearby_customization_points_async", callback, player_coords.x, player_coords.y, player_coords.z)

end