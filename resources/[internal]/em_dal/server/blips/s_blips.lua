
register_server_callback("em_dal:get_blips", function(source, callback)

    HttpGet("/Blip/Get", nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

function get_blip_group_subscription(callback)

    Citizen.CreateThread(function()
        HttpGet("/Blip/GroupSubscriptions", nil, function(error_code, result_data, result_headers)

            blips = json.decode(result_data)
            callback(blips)

        end)
    end)

end