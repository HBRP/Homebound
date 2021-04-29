
local function attempt_open_glovebox_inventory()

    local ped     = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)

    if vehicle == 0 then
        return false
    end

    local ped_in_driver = GetPedInVehicleSeat(vehicle, -1)
    local ped_in_front_passenger = GetPedInVehicleSeat(vehicle, 0)

    if ped ~= ped_in_driver and ped ~= ped_in_front_passenger then
        return false
    end

    local storage_id = exports["em_fw"]:get_vehicle_storage_id(GetVehicleNumberPlateText(vehicle), "Glovebox")
    TriggerEvent("esx_inventoryhud:open_secondary_inventory", storage_id, "Glovebox")

end

local function attempt_open_trunk_inventory()

    local ped = PlayerPedId()

    if GetVehiclePedIsIn(ped, false) ~= 0 then
        return
    end

    local vehicle = exports["em_fw"]:get_nearest_vehicle()

    if vehicle == 0 then
        return
    end

    local ped_coords = GetEntityCoords(ped)
    local veh_coords = GetEntityCoords(vehicle)
    if #(ped_coords - veh_coords) > 5.0 then
        return
    end

    if GetVehicleDoorAngleRatio(vehicle, 5) ~= 0 then
        local storage_id = exports["em_fw"]:get_vehicle_storage_id(GetVehicleNumberPlateText(vehicle), "Trunk")
        TriggerEvent("esx_inventoryhud:open_secondary_inventory", storage_id, "Trunk")
    else
        return
    end

end

RegisterCommand('secondary_inventory', function()

    if attempt_open_glovebox_inventory() then
        return
    end
    attempt_open_trunk_inventory()

end, false)
RegisterKeyMapping('secondary_inventory', 'secondary_inventory', 'keyboard', 'F2')