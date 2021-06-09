
local function spawn_vehicle(group_id, vehicle_id)

    exports["em_dal"]:takeout_vehicle_async(function(vehicle)

        local player_coords = GetEntityCoords(PlayerPedId())
        local forward_vec   = GetEntityForwardVector(PlayerPedId())

        local veh_position  = {
            forward_vec.x * 2.5 + player_coords.x,
            forward_vec.y * 2.5 + player_coords.y,
            forward_vec.z * 2.5 + player_coords.z 
        }
        local veh_heading = GetEntityHeading(PlayerPedId()) + 90.0
        local veh = exports["em_vehicles"]:spawn_vehicle(vehicle.vehicle_model, vehicle.plate, vehicle.vehicle_state, veh_position, veh_heading, false, false)

        if group_id == -1 then
            exports["em_vehicles"]:register_vehicle_as_player_owned(veh)
        else
            exports["em_vehicles"]:register_vehicle_as_group_owned(group_id, veh)
        end

        exports["em_vehicles"]:set_vehicle_mods(veh, vehicle.vehicle_mods)
        exports["LegacyFuel"]:SetFuel(veh, vehicle.vehicle_gas_level)
        SetVehicleNumberPlateText(veh, vehicle.plate)

    end, vehicle_id)

end

local function setup_vehicles(nearby_garage, vehicles)

    local dialog_options = {}

    for i = 1, #vehicles do

        local dialog = nil
        local callback = nil

        if vehicles[i].taken_out then

            dialog = string.format("[%s is out]", vehicles[i].vehicle_name)
            callback = function() end

        elseif vehicles[i].vehicle_garage_id == nearby_garage.vehicle_garage_id then

            dialog = string.format("[Take out %s]", vehicles[i].vehicle_name)
            callback = function()

                spawn_vehicle(nearby_garage.group_id, vehicles[i].vehicle_id)
                exports["em_dialog"]:hide_dialog()

            end

        else
            dialog = string.format("[%s is in garage %s]", vehicles[i].vehicle_name, vehicles[i].vehicle_garage_name)
            callback = function() end
        end

        table.insert(dialog_options, {

            dialog   = dialog,
            callback = callback

        })

    end

    exports["em_dialog"]:show_dialog(nearby_garage.vehicle_garage_name, dialog_options)
end

local function setup_character_vehicles(nearby_garage)

    exports["em_dal"]:get_character_vehicles_async(function(vehicles)
        setup_vehicles(nearby_garage, vehicles)
    end)

end

local function setup_group_vehicles(nearby_garage)

    exports["em_dal"]:get_group_vehicles_async(function(vehicles)

        setup_vehicles(nearby_garage, vehicles)

    end, nearby_garage.group_id)

end

function take_out_vehicle(nearby_garage)

    if nearby_garage ~= nil and nearby_garage.any_nearby then

        return {

            dialog = "[Take out cars]",
            callback = function()

                exports["em_dialog"]:hide_dialog()
                if nearby_garage.group_id ~= -1 then
                    setup_group_vehicles(nearby_garage)
                else
                    setup_character_vehicles(nearby_garage)
                end 

            end

        }

    end
    return nil

end

function return_vehicle(nearby_garage)

    if nearby_garage ~= nil and nearby_garage.any_nearby then

        local dialog = nil
        local callback = nil

        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if veh ~= 0 then

            local vehicle_store_callback = function()

                local plate = GetVehicleNumberPlateText(veh)
                local veh_mods = exports["em_vehicles"]:get_vehicle_mods(veh)
                local veh_state = exports["em_vehicles"]:get_vehicle_state(veh)
                local veh_gas_level = exports["LegacyFuel"]:GetFuel(veh)

                exports["em_dal"]:store_vehicle(plate, nearby_garage.vehicle_garage_id, veh_mods, veh_state, veh_gas_level)
                exports["em_vehicles"]:despawn_vehicle(veh)
                exports["em_dialog"]:hide_dialog()

            end

            if exports["em_vehicles"]:is_vehicle_player_owned(veh) and not exports["em_vehicles"]:is_vehicle_owned_by_group(veh) and nearby_garage.group_id == -1 then

                dialog = "[Store vehicle]"
                callback = vehicle_store_callback

            elseif  nearby_garage.group_id ~= -1 and exports["em_vehicles"]:is_vehicle_owned_by_group_id(nearby_garage.group_id, veh) then

                dialog = "[Store vehicle]"
                callback = vehicle_store_callback

            else

                dialog = "[Cannot store this vehicle here]"
                callback = function() exports["em_dialog"]:hide_dialog() end

            end

            return {
                dialog = dialog,
                callback = callback
            }  

        end

    end
    return nil

end