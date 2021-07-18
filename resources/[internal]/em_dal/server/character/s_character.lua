

local character_ids = {}
local function register_character_id_to_source(source, character, player_id)

    character.character_name = character["first_name"] .. " " .. character["last_name"]
    character.source         = source
    character.player_id      = player_id

    for i = 1, #character_ids do
        if character_ids[i].source == source or character_ids[i].character_id == character_id then
            table.remove(character_ids, i)
            break
        end
    end
    table.insert(character_ids, character)

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

function get_character_from_source(source)

    for i = 1, #character_ids do
        if character_ids[i].source == source then
            return character_ids[i]
        end
    end

    assert(0 == 1, string.format("Could not find character for source %d", source))

    return nil

end

function get_source_from_phone_number(phone_number)

    for i = 1, #character_ids do
        if character_ids[i].phone_number == phone_number then
            return character_ids[i].source
        end
    end

end

function get_phone_number_from_source(source)

    for i = 1, #character_ids do
        if character_ids[i].source == source then
            return character_ids[i].phone_number
        end
    end

end

function get_player_id_by_character_id(character_id)

    for i = 1, #character_ids do
        if character_ids[i].character_id == character_id then
            return character_ids[i].player_id
        end
    end

end

function remove_stale_source(source)

    for i = 1, #character_ids do

        if character_ids[i].source == source then

            table.remove(character_ids, i)
            break

        end

    end

end

function get_current_character_ids()

    return character_ids
    
end


RegisterNetEvent("em_dal:trigger_event_for_character")
AddEventHandler("em_dal:trigger_event_for_character", function(event, character_id, args) 

    TriggerClientEvent(event, get_server_id_from_character_id(character_id), args)

end)

RegisterNetEvent("em_dal:trigger_proximity_event")
AddEventHandler("em_dal:trigger_proximity_event", function(event, distance, args) 

    local source_coords = GetEntityCoords(GetPlayerPed(source))
    for i = 1, #character_ids do

        local ped = GetPlayerPed(character_ids[i].source)
        if #(source_coords - GetEntityCoords(ped)) <= distance then

            TriggerClientEvent(event, character_ids[i].source, args)

        end

    end

end)

AddEventHandler('playerDropped', function(reason)

    remove_stale_source(source)
    
end)


register_server_callback("em_dal:get_player_character_id", function(source, callback, target)

    callback(get_character_id_from_source(target))

end)

register_server_callback("em_dal:get_player_character_id_batch", function(source, callback, targets)

    callback(get_character_ids_from_sources(targets))

end)

register_server_callback("em_dal:get_server_id_from_character_id", function(source, callback, character_id)

    callback(get_server_id_from_character_id(character_id))

end)

register_server_callback("em_dal:is_character_id_in_radius", function(source, callback, character_id, radius)

    local other_server_id = get_server_id_from_character_id(character_id)

    if other_server_id == nil then
        callback(false)
        return
    end

    local diff = #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(other_server_id)))
    callback(diff <= radius)

end)

register_server_callback("em_dal:create_character", function(source, callback, character)

    local data = character
    HttpPost("/Character/Create", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:delete_character", function(source, callback, character_id)

    local data = {character_id = character_id}
    HttpPut("/Character/Delete", data, function(error_code, result_data, result_headers)

        callback({})

    end)

end)

register_server_callback("em_dal:get_character_info", function(source, callback, character_id)

    local data = {character_id = character_id}
    HttpGet("/Character/GetInfo", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        register_character_id_to_source(source, temp["character"], get_player_id(source))
        callback(temp)

    end)

end)

register_server_callback("em_dal:get_all_characters", function(source, callback, player_id)

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

RegisterNetEvent("em_dal:update_character_position")
AddEventHandler("em_dal:update_character_position", function(character_id, position) 

    local source = source
    local data = {character_id = character_id, position = position}
    HttpPut("/Character/UpdatePosition", data, function() end)

end)

