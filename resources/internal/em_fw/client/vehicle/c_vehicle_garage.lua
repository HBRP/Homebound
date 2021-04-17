

function get_character_vehicles_async(callback)

    trigger_server_callback_async("em_fw:get_character_vehicles", callback, get_character_id())

end

function takeout_vehicle_async(callback, vehicle_id)

    trigger_server_callback_async("em_fw:takeout_vehicle", callback, get_character_id(), vehicle_id)

end

function get_nearby_garage()

    local nearby_garage = nil
    local player_coords = GetEntityCoords(PlayerPedId())

    trigger_server_callback("em_fw:get_nearby_garage", function(result)

        nearby_garage = result

    end, get_character_id(), player_coords.x, player_coords.y, player_coords.z)

    return nearby_garage

end

function store_vehicle(plate, vehicle_garage_id, vehicle_mods, vehicle_state, vehicle_gas_level)

    trigger_server_callback_async("em_fw:store_vehicle", function() end, plate, vehicle_garage_id, vehicle_mods, vehicle_state, vehicle_gas_level)

end

function get_group_vehicles_async(callback, group_id)

    trigger_server_callback_async("em_fw:get_group_vehicles", callback, group_id)

end