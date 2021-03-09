RegisterNetEvent("em_fw:create_character")
AddEventHandler("em_fw:create_character", function(player_id, firstname, lastname, dob) 

    local source = source
    local data   = {player_id = player_id, firstname = firstname, lastname = lastname, dob = dob}
    HttpPost("/Character/Create", data, function(error_code, result_data, result_headers)

        Citizen.Trace(result_data)

    end)

end)

RegisterNetEvent("em_fw:delete_character")
AddEventHandler("em_fw:delete_character", function(character_id) 

    local source = source
    local data   = {character_id = character_id}
    HttpPost("/Character/Delete", data, function(error_code, result_data, result_headers)

        Citizen.Trace("Deleted character_id = " .. character_id)
        Citizen.Trace(result_data)

    end)

end)

RegisterNetEvent("em_fw:get_character_info")
AddEventHandler("em_fw:get_character_info", function(character_id) 

    local source = source
    local data = {character_id = character_id}
    HttpGet("/Character/GetInfo", data, function(error_code, result_data, result_headers)

        TriggerClientEvent("em_fw:get_character_info", source, result_data)

    end)

end)

RegisterNetEvent("em_fw:get_all_characters")
AddEventHandler("em_fw:get_all_characters", function(player_id) 

    local source = source
    local data = {player_id = player_id}
    HttpGet("/Character/GetAll", data, function(error_code, result_data, result_headers)

        TriggerClientEvent("em_fw:get_all_characters:response", source, json.decode(result_data))

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

RegisterNetEvent("UpdateCharacterPosition")
AddEventHandler("UpdateCharacterPosition", function(character_id, position) 

    local source = source
    local data   = {character_id = character_id, position = position}
    HttpPut("/Character/UpdatePosition", data)

end)

