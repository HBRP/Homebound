

register_server_callback("em_fw:get_character_vehicles", function(source, callback, character_id)

    local endpoint = string.format("/Vehicle/Garage/Character/Vehicles/%d", character_id)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_fw:takeout_vehicle", function(source, callback, character_id, vehicle_id)

    local endpoint = string.format("/Vehicle/Garage/TakeOutVehicle/%d/%d", character_id, vehicle_id)
    HttpPost(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_fw:get_nearby_garage", function(source, callback, character_id, x, y, z)

    local endpoint = string.format("/Vehicle/Garage/Nearby/%d/%f/%f/%f", character_id, x, y, z)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("/Vehicle/Garage/StoreVehicle", function(source, callback, plate, vehicle_garage_id, vehicle_mods, vehicle_state, vehicle_gas_level)

    local data = {plate = plate, vehicle_garage_id = vehicle_garage_id, vehicle_mods = vehicle_mods, vehicle_state = vehicle_state, vehicle_gas_level = vehicle_gas_level}
    HttpPut("/Vehicle/Garage/StoreVehicle", data, function(error_code, result_data, result_headers)

        callback()

    end)
    
end)


Citizen.CreateThread(function()

    Citizen.Wait(10)
    HttpPut("/Vehicle/Reset", nil, function(error_code, result_data, result_headers) end)

end)