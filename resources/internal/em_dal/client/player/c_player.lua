
local player_id = nil

RegisterNetEvent("get_player_info:response")
AddEventHandler("get_player_info:response", function(player_info)

    player_id = player_info["player_id"]
    TriggerEvent("em_dal:player_loaded")

end)


function get_player_id()

    return player_id

end

Citizen.CreateThread(function()

    Citizen.Wait(0)
    TriggerServerEvent("em_dal:get_player_id")
    
end)