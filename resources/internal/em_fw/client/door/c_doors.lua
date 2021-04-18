

function get_nearby_doors_async(callback)

    local player_coords = GetEntityCoords(PlayerPedId())
    trigger_server_callback_async("em_fw:get_nearby_doors", callback, get_character_id(), table.unpack(player_coords))

end

function toggle_door(door_location_id)

    trigger_server_callback_async("em_fw:toggle_door", function() end, door_location_id)

end