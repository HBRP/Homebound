

local character_ids = {}
local function register_character_id_to_source(source, player_id, character_id, storage_id)

    for i = 1, #character_ids do
        if character_ids[i].source == source or character_ids[i].character_id == character_id then
            table.remove(character_ids, i)
            break
        end
    end
    table.insert(character_ids, {source = source, character_id = character_id, storage_id = storage_id})

end

function get_character_id_from_source(source)

    for i = 1, #character_ids do
        if character_ids[i].source == source then
            return character_ids[i].character_id
        end
    end

    return nil

end

function get_character_storage_id_from_character_id(character_id)

    for i = 1, #character_ids do
        if character_ids[i].character_id == character_id then
            return character_ids[i].storage_id
        end
    end
    return nil

end

function get_character_ids_from_sources(sources)

    local temp_character_ids = {}
    for i = 1, #character_ids do
        for j = 1, #sources do
            if sources[j] == character_ids[i].source then
                table.insert(temp_character_ids, {source = sources[j], character_id = character_ids[i].character_id})
                break
            end
        end
    end

    return temp_character_ids

end

function get_server_id_from_character_id(character_id)

    for i = 1, #character_ids do
        if character_ids[i].character_id == character_id then
            return character_ids[i].source
        end
    end

    return nil

end


RegisterNetEvent("em_fw:trigger_event_for_character")
AddEventHandler("em_fw:trigger_event_for_character", function(event, character_id, args) 

    TriggerClientEvent(event, get_server_id_from_character_id(character_id), args)

end)


register_server_callback("em_fw:get_player_character_id", function(source, callback, target)

    callback(get_character_id_from_source(target))

end)

register_server_callback("em_fw:get_player_character_id_batch", function(source, callback, targets)

    callback(get_character_ids_from_sources(targets))

end)

register_server_callback("em_fw:get_server_id_from_character_id", function(source, callback, character_id)

    callback(get_server_id_from_character_id(character_id))

end)

register_server_callback("em_fw:create_character", function(source, callback, character)

    local data = character
    HttpPost("/Character/Create", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_fw:delete_character", function(source, callback, character_id)

    local data = {character_id = character_id}
    HttpPut("/Character/Delete", data, function(error_code, result_data, result_headers)

        callback({})

    end)

end)

register_server_callback("em_fw:get_character_info", function(source, callback, character_id)

    local data = {character_id = character_id}
    HttpGet("/Character/GetInfo", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        register_character_id_to_source(source, character_id, temp["character"]["character_id"], temp["character"]["storage_id"])
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

