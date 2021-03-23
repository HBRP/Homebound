
function get_nearby_stashes()

    local nearby_stashes = nil
    local coords = GetEntityCoords(PlayerPedId())

    trigger_server_callback("em_fw:get_nearby_stashes", function(result) 

        nearby_stashes = result

    end, coords.x, coords.y, coords.z)

    return nearby_stashes

end