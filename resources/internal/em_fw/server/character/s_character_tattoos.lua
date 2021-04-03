

register_server_callback("em_fw:get_tattoos", function(source, callback, character_id)

    local endpoint = string.format("/Character/Tattoos/%d", character_id)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_fw:update_tattoos", function(source, callback, character_id, tattoos)

    local data = {character_id = character_id, tattoos = json.encode(tattoos)}
    HttpPut("/Character/UpdateTattoos", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)