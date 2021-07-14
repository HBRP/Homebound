
local is_dragging_person = false
local dragging_server_id = -1

local is_being_dragged = false

RegisterNetEvent("em_drag:drag_request")
AddEventHandler("em_drag:drag_request", function(requesting_source)

    if is_being_dragged then
        DetachEntity(PlayerPedId(), true, false)
    else
        AttachEntityToEntity(PlayerPedId(), GetPlayerPed(GetPlayerFromServerId(requesting_source)), 4103, 11816, 0.48, 0.00, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
    end

end)

RegisterNetEvent("em_drag:drag_response")
AddEventHandler("em_drag:drag_response", function(dragging_server_id, getting_dragged)

    dragging_server_id = dragging_server_id
    is_dragging_person = getting_dragged

end)

RegisterCommand('drag_command', function() 

    if is_dragging_person then

        TriggerServerEvent("em_drag:drag_request", dragging_server_id)
        return

    end

    if exports["em_medical"]:is_player_unconscious() or exports["em_gen_commands"]:is_handcuffed() then
        exports["t-notify"]:Alert({style = "error", message = "Cannot drag someone while unconscious or handcuffed"})
        return
    end

    local player_id, player_distance = exports["em_ped"]:get_closest_player()

    if player_distance > 2.5 then
        return
    end
    
    local server_id = GetPlayerServerId(player_id)
    TriggerServerEvent("em_drag:drag_request", server_id)

end, false)

RegisterKeyMapping('drag_command', 'drag_command', 'keyboard', 'HOME')