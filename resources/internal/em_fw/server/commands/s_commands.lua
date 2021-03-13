
register_server_callback("em_fw:can_use_command", function(source, callback, character_id, command)

    local data = {character_id = character_id, command = command}
    HttpPost("/Command/CanUseCommand", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)