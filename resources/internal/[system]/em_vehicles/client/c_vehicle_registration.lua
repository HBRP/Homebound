
function register_plate_as_player_owned(plate)

    local character_id = exports["em_fw"]:get_character_id()
    exports["em_fw"]:trigger_server_callback_async("em_vehicles:register_plate_as_player_owned", function() end, character_id, plate)

end

function is_vehicle_player_owned(veh)

end