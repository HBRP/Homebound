register_server_callback("em_fw:get_vehicle_storage", function(source, callback, plate, location)


    local endpoint = string.format("/Storage/VehicleStorage/%s/%s", plate, location)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_fw:get_vehicle_storage_id", function(source, callback, plate, location)


    local endpoint = string.format("/Storage/VehicleStorageId/%s/%s", plate, location)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)