

register_server_callback("em_dal:get_nearby_stores", function(source, callback, character_id, x, y, z)

    local endpoint = string.format("/Stores/Nearby/%d/%.4f/%.4f/%.4f", character_id, x, y, z)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:get_store_items_async", function(source, callback, character_id, store_type_id)

    local endpoint = string.format("/Stores/Items/%d/%d", character_id, store_type_id)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)