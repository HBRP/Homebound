
register_server_callback("em_dal:get_nearby_drops", function(source, callback, x, y, z)

    local endpoint = string.format("/Storage/Drops/%.4f/%.4f/%.4f", x, y, z)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:get_free_drop_zone", function(source, callback, x, y, z)

    local endpoint = string.format("/Storage/GetFreeDropZone/%.4f/%.4f/%.4f", x, y, z)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:set_drop_zone_inactive", function(source, callback, storage_id)

    local endpoint = string.format("/Storage/SetDropZoneInactive/%d", storage_id)
    HttpPut(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)