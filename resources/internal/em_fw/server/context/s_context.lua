

register_server_callback("em_fw:get_context", function(source, callback, character_id, x, y, z)

    if get_character_id_from_source(source) ~= character_id then
        callback()
        return
    end

    local endpoint = string.format("/Context/%d/%.2f/%.2f/%.2f")
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)