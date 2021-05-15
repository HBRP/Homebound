

function get_nearby_stores_async(callback)

    local player_coords = GetEntityCoords(PlayerPedId())
    trigger_server_callback_async("em_dal:get_nearby_stores", callback, get_character_id(), player_coords.x, player_coords.y, player_coords.z)

end

function get_store_items_async(callback, store_type_id)

    trigger_server_callback_async("em_dal:get_store_items_async", callback, get_character_id(), store_type_id)

end