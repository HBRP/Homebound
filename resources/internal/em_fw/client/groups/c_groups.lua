

function get_nearby_job_clock_in_async(callback)

    local player_coords = GetEntityCoords(PlayerPedId())

    trigger_server_callback("em_fw:get_nearby_job_clock_in", callback, get_character_id(), player_coords.x, player_coords.y, player_coords.z)

end

function get_clocked_on_job_async(callback)

    trigger_server_callback("em_fw:get_clocked_on_job", callback, get_character_id())

end

function clock_in_async(callback, group_id)

    trigger_server_callback("em_fw:clock_in", callback, get_character_id(), group_id)

end

function clock_out_async(callback)

    trigger_server_callback("em_fw:clock_out", callback, get_character_id())

end