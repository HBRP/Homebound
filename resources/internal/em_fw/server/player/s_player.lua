
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