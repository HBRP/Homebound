register_server_callback("em_dal:get_nearby_stashes", function(source, callback, x, y, z)


    local character_id = get_character_id_from_source(source)
    local endpoint = string.format("/Storage/NearbyStashes/%d/%.4f/%.4f/%.4f", character_id, x, y, z)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)