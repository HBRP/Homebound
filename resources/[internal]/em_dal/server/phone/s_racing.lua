
function phone_get_races(source, callback)

    HttpGet("/Phone/Racing", nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)
    
end

register_server_callback("em_dal:phone_get_races", function(source, callback)

    phone_get_races(source, callback)

end)