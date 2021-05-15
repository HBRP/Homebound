

RegisterCommand('unlock_car', function() 

    local veh = exports["em_dal"]:get_nearest_vehicle()

    if not has_keys(veh) then


        exports["t-notify"]:Alert({style = "error", message = "You don't have keys"})
        return

    end

    local lock_status = GetVehicleDoorLockStatus(veh)
    if lock_status == 1 then
        exports["t-notify"]:Alert({style = "error", message = "Doors locked"})
        SetVehicleDoorsLocked(veh, 10)
    else
        exports["t-notify"]:Alert({style = "info", message = "Doors unlocked"})
        SetVehicleDoorsLocked(veh, 1)
    end

end, false)

RegisterKeyMapping('unlock_car', 'unlock_car', 'keyboard', 'u')