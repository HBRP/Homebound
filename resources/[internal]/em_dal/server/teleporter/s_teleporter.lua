

register_server_callback("em_dal:get_nearby_teleporter_points", function(source, callback, x, y, z)

    local endpoint = string.format("/Teleporter/NearbyPoints/%.3f/%.3f/%.3f", x, y, z)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:get_teleporter_options", function(source, callback, teleporter_point_id)

    local endpoint = string.format("/Teleporter/TeleporterOptions/%d", teleporter_point_id)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)