

function get_context_async(callback)

    local player_coords = GetEntityCoords(PlayerPedId())
    trigger_server_callback_async("em_fw:get_context", callback, get_character_id(), player_coords.x, player_coords.y, player_coords.z)

end