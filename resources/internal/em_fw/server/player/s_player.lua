
local sessions = {}

RegisterNetEvent("GetPlayerInfo")
AddEventHandler("GetPlayerInfo", function(session) 

    local source = source
    sessions[source] = {session_id = session["session_id"], player_id = nil}
    HttpGet("/Player/PlayerId", session, function(error_code, result_data, result_headers)

        sessions[source].player_id = json.decode(result_data).player_id
        TriggerClientEvent("GetPlayerInfo:Response", source, result_data)

    end)

end)

local function check_source(source)

    assert(sessions[source], "get_player_id: Unable to find session for source " .. tostring(source))
    assert(sessions[source].player_id, "get_player_id: Unable to find player_id for source " .. tostring(source))

end

function get_player_id(source)

    check_source(source)
    return sessions[source].player_id

end

function get_session_id(source)

    check_source(source)
    return sessions[source].session_id

end