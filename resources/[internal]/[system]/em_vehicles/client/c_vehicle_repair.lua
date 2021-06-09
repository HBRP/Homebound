

function repair_vehicle(veh)

    SetVehicleFixed(veh)
    SetVehicleEngineHealth(veh, 1000.0)

    if GetVehicleFuelLevel(veh) < 65.0 then
        SetVehicleFuelLevel(veh, 65.0)
    end

end