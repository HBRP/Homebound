
local function spawn_vehicle(vehicle_id)

    exports["em_fw"]:takeout_vehicle_async(function(vehicle)

        

    end, vehicle_id)

end

local function setup_character_vehicles(nearby_garage)

    exports["em_fw"]:get_character_vehicles_async(function(vehicles)

        local dialog_options = {}

        for i = 1, #vehicles do

            local dialog = nil
            local callback = nil

            if vehicles[i].taken_out then

                dialog = string.format("[%s is out]", vehicles[i].vehicle_name)
                callback = function() end

            if vehicles[i].vehicle_garage_id == nearby_garage.vehicle_garage_id then

                dialog = string.format("[Take out %s]", vehicles[i].vehicle_name)
                callback = function()
                    spawn_vehicle(vehicles[i].vehicle_id)
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

    end)

end

function take_out_vehicle(nearby_garage)

    if nearby_garage ~= nil and nearby_garage.any_nearby then

        return {

            dialog = "[Take out cars]",
            callback = function()

                exports["em_dialog"]:hide_dialog()
                if nearby_garage.group_id ~= -1 then

                else
                    setup_character_vehicles(nearby_garage)
                end 

            end

        }

    end
    return nil

end

function return_vehicle(nearby_garage)

    if nearby_garage ~= nil and nearby_garage.any_nearby  then

    end
    return nil

end