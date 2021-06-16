
local player_id = nil

function get_player_id()

    return player_id

end

function ban_player_async(callback, player_id, length)

    trigger_server_callback_async("em_dal:ban_player", callback, player_id, length)

end

function whitelist_player_async(callback, player_id, whitelist_flag)

    trigger_server_callback_async("em_dal:whitelist_player", callback, player_id, whitelist_flag)

end

Citizen.CreateThread(function()

    Citizen.Wait(0)
    trigger_server_callback_async("em_dal:get_player_id", function(response)

        player_id = response["player_id"]
        TriggerEvent("em_dal:player_loaded")

    end)
    
end)