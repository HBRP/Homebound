
register_server_callback("em_fw:create_character", function(source, callback, character)

    local data = character
    HttpPost("/Character/Create", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_fw:delete_character", function(source, callback, character_id)

    local data = {character_id = character_id}
    HttpGet("/Character/Delete", data, function(error_code, result_data, result_headers)

        callback({})

    end)

end)

register_server_callback("em_fw:get_character_info", function(source, callback, character_id)

    local data = {character_id = character_id}
    HttpGet("/Character/GetInfo", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_fw:get_all_characters", function(source, callback, player_id)

    local data = {player_id = player_id}
    HttpGet("/Character/GetAll", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

RegisterNetEvent("GetCharacterPosition")
AddEventHandler("GetCharacterPosition", function(character_id) 

    local source = source
    local data   = {character_id = character_id}
    HttpGet("/Character/GetPosition", data, function(error_code, result_data, result_headers)

        Citizen.Trace(result_data)

    end)


end)

RegisterNetEvent("GetCharacterHealth")
AddEventHandler("GetCharacterHealth", function() 

    local source = source
    local data   = {character_id = character_id}
    HttpGet("/Character/GetHealth", data, function(error_code, result_data, result_headers)

        Citizen.Trace(result_data)

    end)

end)

RegisterNetEvent("UpdateCharacterHealth")
AddEventHandler("UpdateCharacterHealth", function(character_id, health) 

    local source = source
    local data   = {character_id = character_id, health = health}
    HttpPut("/Character/UpdateHealth", data)

end)

RegisterNetEvent("em_fw:update_character_position")
AddEventHandler("em_fw:update_character_position", function(character_id, position) 

    local source = source
    local data = {character_id = character_id, position = position}
    HttpPut("/Character/UpdatePosition", data)

end)

