
function get_steam_id(source)

  for k,v in pairs(GetPlayerIdentifiers(source))do

    if string.sub(v, 1, string.len("steam:")) == "steam:" then

        return v

    end

  end

end

RegisterNetEvent("em_fw:get_player_id")
AddEventHandler("em_fw:get_player_id", function() 

    local source = source
    local steamidentifier = {steamid = get_steam_id(source)}
    HttpGet("/Player/GetPlayerId", steamidentifier, function(error_code, result_data, result_headers)

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