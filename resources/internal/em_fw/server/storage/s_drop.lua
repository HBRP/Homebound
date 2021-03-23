
register_server_callback("em_fw:get_nearby_drops", function(source, callback, x, y, z)

    local endpoint = string.format("/Storage/Drops/%.4f/%.4f/%.4f", x, y, z)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_fw:get_free_drop_zone", function(source, callback, x, y, z)

    local endpoint = string.format("/Storage/GetFreeDropZone/%.4f/%.4f/%.4f", x, y, z)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        Citizen.Trace(result_data .. "\n")
        local temp = json.decode(result_data)
        callback(temp)

    end)

end)