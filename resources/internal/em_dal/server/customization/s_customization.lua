

register_server_callback("em_dal:get_nearby_customization_points_async", function(source, callback, x, y, z)

    local endpoint = string.format("/Customization/Nearby/%.4f/%.4f/%.4f", x, y, z)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)