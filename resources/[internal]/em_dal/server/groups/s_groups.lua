
local character_jobs = {}

local function clear_previous_entry(source, character_id)

    for i = 1, #character_jobs do

        if character_jobs[i].source == source or character_jobs[i].character_id == character_id then
            table.remove(character_jobs, i)
            break
        end

    end

end

local function register_character_job(source, character_id, job)

    clear_previous_entry(source, character_id)
    table.insert(character_jobs, {source = source, character_id = character_id, job = job})

end

function get_current_character_jobs()

    return character_jobs

end

register_server_callback("em_dal:get_nearby_job_clock_in", function(source, callback, character_id, x, y, z)

    local endpoint = string.format("/Groups/GetNeabyJobClockIn/%d/%f/%f/%f", character_id, x, y, z)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:get_clocked_on_job", function(source, callback, character_id)

    local endpoint = string.format("/Groups/GetClockedOnJob/%d", character_id)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        register_character_job(source, character_id, temp)
        callback(temp)

    end)

end)

register_server_callback("em_dal:clock_in", function(source, callback, character_id, group_id)

    local endpoint = string.format("/Groups/ClockIn/%d/%d", character_id, group_id)
    HttpPost(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        register_character_job(source, character_id, temp)
        callback(temp)

    end)

end)

register_server_callback("em_dal:clock_out", function(source, callback, character_id)

    local endpoint = string.format("/Groups/ClockOut/%d", character_id)
    HttpPost(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        register_character_job(source, character_id, temp)
        callback(temp)

    end)  

end)

AddEventHandler('playerDropped', function (reason)

    clear_previous_entry(source, 0)
    
end)

function get_group_alerts(callback)

    HttpGet("/Groups/GroupAlerts", nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end

function get_group_alert_subscriptions(callback)

    HttpGet("/Groups/GroupAlertSubscriptions", nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end