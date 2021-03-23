

exports["em_commands"]:register_command_no_perms("open_glovebox", function(source, args, raw_command)

    local ped     = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)

    if vehicle == 0 then
        exports['swt_notifications']:Negative("Glovebox", "Not in a vehicle", "top", 2000, true)
        return
    end

    local ped_in_driver = GetPedInVehicleSeat(vehicle, -1)
    local ped_in_front_passenger = GetPedInVehicleSeat(vehicle, 0)

    if ped ~= ped_in_driver and ped ~= ped_in_front_passenger then
        return
    end

    local storage_id = exports["em_fw"]:get_vehicle_storage_id(GetVehicleNumberPlateText(vehicle), "Glovebox")
    TriggerEvent("esx_inventoryhud:open_secondary_inventory", storage_id, "Glovebox")

end)

exports["em_commands"]:register_command_no_perms("open_trunk", function(source, args, raw_command)

    local ped = PlayerPedId()

    if GetVehiclePedIsIn(ped, false) ~= 0 then
        exports['swt_notifications']:Negative("Trunk", "Cannot be in a vehicle", "top", 2000, true)
        return
    end

    local vehicle = exports["em_fw"]:get_nearest_vehicle()

    if vehicle == 0 then
        exports['swt_notifications']:Negative("Trunk", "Vehicle not found", "top", 2000, true)
        return
    end

    local ped_coords = GetEntityCoords(ped)
    local veh_coords = GetEntityCoords(vehicle)
    if #(ped_coords - veh_coords) > 5.0 then
        exports['swt_notifications']:Negative("Trunk", "Too far away from a car", "top", 2000, true)
        return
    end

    if GetVehicleDoorAngleRatio(vehicle, 5) ~= 0 then
        local storage_id = exports["em_fw"]:get_vehicle_storage_id(GetVehicleNumberPlateText(vehicle), "Trunk")
        TriggerEvent("esx_inventoryhud:open_secondary_inventory", storage_id, "Trunk")
    else
        exports['swt_notifications']:Negative("Trunk", "Trunk not open", "top", 2000, true)
        return
    end

end)