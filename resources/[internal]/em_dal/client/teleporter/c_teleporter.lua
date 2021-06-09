

function get_nearby_teleporter_points_async(callback)

    local player_coords = GetEntityCoords(PlayerPedId())
    trigger_server_callback_async("em_dal:get_nearby_teleporter_points", callback, player_coords.x, player_coords.y, player_coords.z)

end

function get_teleporter_options_async(callback, teleporter_point_id)

    trigger_server_callback_async("em_dal:get_teleporter_options", callback, teleporter_point_id)

end