local player_identifiers = {}

function get_steam_id_from_identifier(source)

  for k,v in pairs(GetPlayerIdentifiers(source))do
    if string.sub(v, 1, string.len("steam:")) == "steam:" then
        return v
    end
  end

end

local function register_player_identifier(source, steamid)

    table.insert(player_identifiers, {source = source, steamid = steamid})

end

function get_steam_id(source)

    for i = 1, #player_identifiers do
        if player_identifiers[i].source == source then
            return player_identifiers[i].steamid
        end
    end

    assert(0 == 1, string.format("Could not find steam_id for source %d", source))

end

RegisterNetEvent("em_fw:get_player_id")
AddEventHandler("em_fw:get_player_id", function() 

    local source = source
    local steam_identifier = {steamid = get_steam_id_from_identifier(source)}

    register_player_identifier(source, steam_identifier.steamid)

    HttpGet("/Player/GetPlayerId", steam_identifier, function(error_code, result_data, result_headers)
        TriggerClientEvent("get_player_info:response", source, json.decode(result_data))
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