
local player_id = nil

RegisterNetEvent("GetPlayerInfo:Response")
AddEventHandler("GetPlayerInfo:Response", function(player_info)

    player_id = json.decode(player_info)["player_id"]
    init_all_characters(player_id)
    
end)


function get_player_id()

    return player_id

end