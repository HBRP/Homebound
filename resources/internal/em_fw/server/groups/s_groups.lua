

register_server_callback("em_fw:get_nearby_job_clock_in", function(source, callback, character_id, x, y, z)

    local endpoint = string.format("/Groups/GetNeabyJobClockIn/%d/%f/%f/%f", character_id, x, y, z)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_fw:get_clocked_on_job", function(source, callback, character_id)

    local endpoint = string.format("/Groups/GetClockedOnJob/%d", character_id)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_fw:clock_in", function(source, callback, character_id, group_id)

    local endpoint = string.format("/Groups/ClockIn/%d/%d", character_id, group_id)
    HttpPost(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_fw:clock_out", function(source, callback, character_id)

    local endpoint = string.format("/Groups/ClockOut/%d", character_id)
    HttpPut(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)  

end)