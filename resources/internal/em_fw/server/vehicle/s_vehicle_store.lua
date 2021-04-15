
register_server_callback("em_fw:get_vehicle_store_stock", function(source, callback, vehicle_store_name)

    local endpoint = string.format("/Vehicle/Store/Stock/%s", vehicle_store_name)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)