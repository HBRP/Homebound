
function register_vehicle_as_player_owned(veh)

    local plate = GetVehicleNumberPlateText(veh)
    local character_id = exports["em_fw"]:get_character_id()
    exports["em_fw"]:trigger_server_callback_async("em_vehicles:register_plate_as_player_owned", function() end, character_id, plate)

end

function is_vehicle_player_owned(veh)

    local plate = GetVehicleNumberPlateText(veh)
    local is_vehicle_player_owned = false

    exports["em_fw"]:trigger_server_callback("em_vehicles:is_vehicle_player_owned", function(result) 

        is_vehicle_player_owned = result

    end, plate)

    return is_vehicle_player_owned

end

function has_keys(veh)

    local plate = GetVehicleNumberPlateText(veh)
    local has_keys_to_car = false

    exports["em_fw"]:trigger_server_callback("em_vehicles:has_keys", function(result) 

        has_keys_to_car = result

    end, exports["em_fw"]:get_character_id(), plate)

    return has_keys_to_car

end

function transfer_keys(to_character_id, veh)

    local plate = GetVehicleNumberPlateText(veh)

    exports["em_fw"]:trigger_server_callback_async("em_vehicles:transfer_keys", function(success)

        if success then
            print("Successfully transfer_keys")
            -- successful transfer
        else
            -- not successful transfer
        end

    end, exports["em_fw"]:get_character_id(), to_character_id, plate)


end