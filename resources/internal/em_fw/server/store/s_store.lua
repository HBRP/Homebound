

register_server_callback("em_fw:get_nearby_stores", function(source, callback, x, y, z)

    local endpoint = string.format("/Stores/Nearby/%.4f/%.4f/%.4f", x, y, z)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_fw:get_store_items_async", function(source, callback, store_type_id)

    local endpoint = string.format("/Stores/Items/%d", store_type_id)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)