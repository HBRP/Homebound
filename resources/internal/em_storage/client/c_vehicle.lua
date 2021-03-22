

exports["em_commands"]:register_command_no_perms("open_glovebox", function(source, args, raw_command)

    local ped     = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)

    if vehicle == 0 then
        return
    end

    local ped_in_driver = GetPedInVehicleSeat(vehicle, -1)
    local ped_in_front_passenger = GetPedInVehicleSeat(vehicle, 0)

    if ped ~= ped_in_driver and ped ~= ped_in_front_passenger then
        return
    end

    local storage_id = exports["em_fw"]:get_vehicle_storage_id(GetVehicleNumberPlateText(vehicle), "Glovebox")
    TriggerEvent("esx_inventoryhud:open_secondary_inventory", storage_id)

end)