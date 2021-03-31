

register_server_callback("em_jobs:get_number_online", function(source, callback, group_id)

    local current_jobs = exports["em_fw"]:get_current_character_jobs()
    local number = 0
    
    for i = 1, #current_jobs do
        if current_jobs[i].job.group_id == group_id then
            number = number + 1
        end
    end

    callback(number)

end)