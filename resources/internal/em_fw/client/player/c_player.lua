
local player_id = nil

RegisterNetEvent("get_player_info:response")
AddEventHandler("get_player_info:response", function(player_info)

    player_id = player_info["player_id"]
    init_all_characters()

end)


function get_player_id()

    return player_id

end