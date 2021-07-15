
local is_dragging_person = false
local dragging_server_id = -1

local is_being_dragged = false

local function backwards_get_empty_vehicle_seat(veh)

    local number_of_seats = GetVehicleModelNumberOfSeats(GetEntityModel(veh))
    for i = number_of_seats - 2, 0, -1 do

        if GetPedInVehicleSeat(veh, i) == 0 then
            return i
        end

    end

    return nil

end

local function check_to_place_in_car()

    local veh, distance = table.unpack(exports["em_vehicles"]:get_closest_vehicle())

    if distance > 2.5 then
        return
    end

    if GetVehicleDoorLockStatus(veh) > 1 then
        return
    end

    local available_seat = backwards_get_empty_vehicle_seat(veh)
    if available_seat == nil then
        return
    end

    SetPedIntoVehicle(PlayerPedId(), veh, available_seat)

end

local function check_to_exit_car()

    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh == 0 then
        return
    end

    TaskLeaveVehicle(PlayerPedId(), veh, 16)

end

local function is_in_locked_vehicle()

    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh == 0 then
        return
    end

    if GetVehicleDoorLockStatus(veh) > 1 then
        return true
    end

    return false

end

local function is_in_vehicle()

    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    return veh ~= 0

end

RegisterNetEvent("em_drag:drag_request")
AddEventHandler("em_drag:drag_request", function(requesting_source)

    if not is_dragging_person and not is_in_locked_vehicle() then

        if is_being_dragged then
            DetachEntity(PlayerPedId(), true, false)
            check_to_place_in_car()
        else
            check_to_exit_car()
            Citizen.Wait(50)
            AttachEntityToEntity(PlayerPedId(), GetPlayerPed(GetPlayerFromServerId(requesting_source)), 4103, 11816, 0.48, 0.00, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
        end
        is_being_dragged = not is_being_dragged

    end

    TriggerServerEvent("em_drag:drag_response", requesting_source, is_being_dragged)

end)

RegisterNetEvent("em_drag:drag_response")
AddEventHandler("em_drag:drag_response", function(dragging_server_id, getting_dragged)

    dragging_server_id = dragging_server_id
    is_dragging_person = getting_dragged

end)

local next_acceptable_register = 0

RegisterCommand('drag_command', function() 

    if GetGameTimer() < next_acceptable_register then
        return
    end

    next_acceptable_register = GetGameTimer() + 500

    if is_dragging_person then

        TriggerServerEvent("em_drag:drag_request", dragging_server_id)
        return

    end

    if is_in_vehicle() then
        return
    end

    if exports["em_medical"]:is_player_unconscious() or exports["em_gen_commands"]:is_handcuffed() then
        exports["t-notify"]:Alert({style = "error", message = "Cannot drag someone while unconscious or handcuffed"})
        return
    end

    local player_id, player_distance = table.unpack(exports["em_ped"]:get_closest_player())

    if player_distance > 2.5 then
        return
    end

    TriggerServerEvent("em_drag:drag_request", GetPlayerServerId(player_id))

end, false)

RegisterKeyMapping('drag_command', 'drag_command', 'keyboard', 'HOME')