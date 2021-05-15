
register_server_callback("em_dal:get_vehicle_store_stock", function(source, callback, vehicle_store_name)

    local endpoint = string.format("/Vehicle/Store/Stock/%s", vehicle_store_name)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:can_purchase_a_vehicle", function(source, callback, character_id)

    local endpoint = string.format("/Vehicle/CanPurchase/%d", character_id)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:insert_new_vehicle", function(source, callback, character_id, vehicle_model, vehicle_mods, vehicle_state)

    local data = {character_id = character_id, vehicle_model = vehicle_model, vehicle_mods = vehicle_mods, vehicle_state = vehicle_state}
    HttpPost("/Vehicle/InsertVehicle", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)