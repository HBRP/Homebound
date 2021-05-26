local player_identifiers = {}

function get_steam_id_from_identifier(source)

  for k,v in pairs(GetPlayerIdentifiers(source))do
    if string.sub(v, 1, string.len("steam:")) == "steam:" then
        return v
    end
  end

end

local function register_player_identifier(source, steamid, player_id)

    table.insert(player_identifiers, {source = source, steamid = steamid, player_id = player_id})

end

function get_steam_id(source)

    for i = 1, #player_identifiers do

        if player_identifiers[i].source == source then

            return player_identifiers[i].steamid

        end

    end

    assert(0, string.format("Could not find steam_id for source %d", source))

end

function get_player_id(source)

    for i = 1, #player_identifiers do

        if player_identifiers[i].source == source then

            return player_identifiers[i].player_id

        end

    end
    assert(0, "Unable to find player_id")

end

local function create_session(player_id)

    local endpoint = string.format("/Player/CreateSession/%d", player_id)
    HttpPost(endpoint, nil, function(error_code, result_data, result_headers) end)

end

local function end_session(player_id)

    local endpoint = string.format("/Player/EndSession/%d", player_id)
    HttpPost(endpoint, nil, function(error_code, result_data, result_headers) end)

end

RegisterNetEvent("em_dal:get_player_id")
AddEventHandler("em_dal:get_player_id", function() 

    local source = source
    local steam_identifier = {steamid = get_steam_id_from_identifier(source)}

    HttpGet("/Player/GetPlayerId", steam_identifier, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        create_session(temp["player_id"])
        register_player_identifier(source, steam_identifier.steamid, temp["player_id"])
        TriggerClientEvent("get_player_info:response", source, temp)

    end)

end)

function get_priority_if_whitelisted(steam_id)

    local endpoint = string.format("/Player/GetPriority/%s", steam_id)
    local result = nil
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        result = json.decode(result_data)

    end)
    while result == nil do
        Citizen.Wait(100)
    end
    return result

end

AddEventHandler('playerDropped', function(reason)

    local player_id = get_player_id(source)
    end_session(player_id)
    TriggerEvent("em_dal:player_id_dropped", player_id)

end)
