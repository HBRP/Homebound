

register_server_callback("em_dal:get_character_vehicles", function(source, callback, character_id)

    local endpoint = string.format("/Vehicle/Garage/Character/Vehicles/%d", character_id)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:takeout_vehicle", function(source, callback, character_id, vehicle_id)

    local endpoint = string.format("/Vehicle/Garage/TakeOutVehicle/%d/%d", character_id, vehicle_id)
    HttpPost(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:get_nearby_garage", function(source, callback, character_id, x, y, z)

    local endpoint = string.format("/Vehicle/Garage/Nearby/%d/%f/%f/%f", character_id, x, y, z)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:store_vehicle", function(source, callback, plate, vehicle_garage_id, vehicle_mods, vehicle_state, vehicle_gas_level)

    local data = {plate = plate, vehicle_garage_id = vehicle_garage_id, vehicle_mods = vehicle_mods, vehicle_state = vehicle_state, vehicle_gas_level = vehicle_gas_level}
    HttpPut("/Vehicle/Garage/StoreVehicle", data, function(error_code, result_data, result_headers)

        callback()

    end)
    
end)

register_server_callback("em_dal:get_group_vehicles", function(source, callback, group_id)

    local endpoint = string.format("/Vehicle/Group/Vehicles/%d", group_id)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)


Citizen.CreateThread(function()

    Citizen.Wait(100)
    HttpPut("/Vehicle/Reset", nil, function(error_code, result_data, result_headers) end)

end)