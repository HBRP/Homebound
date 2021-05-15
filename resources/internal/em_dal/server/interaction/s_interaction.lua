
register_server_callback("em_dal:get_nearby_interaction_points", function(source, callback, x, y, z)

    local endpoint = string.format("/Interaction/NearbyPoints/%.3f/%.3f/%.3f", x, y, z)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:get_all_interaction_props", function(source, callback)

    HttpGet("/Interaction/AllProps", nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:get_nearby_interaction_peds", function(source, callback, x, y, z)

    local endpoint = string.format("/Interaction/NearbyPeds/%.3f/%.3f/%.3f", x, y, z)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)