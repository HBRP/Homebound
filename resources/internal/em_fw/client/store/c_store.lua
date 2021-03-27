

function get_nearby_stores_async(callback)

    local player_coords = GetEntityCoords(PlayerPedId())
    trigger_server_callback_async("em_fw:get_nearby_stores", callback, player_coords.x, player_coords.y, player_coords.z)

end

function get_store_items_async(callback, store_type_id)

    trigger_server_callback_async("em_fw:get_store_items_async", callback, store_type_id)

end