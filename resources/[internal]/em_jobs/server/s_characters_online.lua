
exports["em_dal"]:register_server_callback("em_jobs:get_number_online", function(source, callback, group_id)

    local current_jobs = exports["em_dal"]:get_current_character_jobs()
    local number = 0
    
    for i = 1, #current_jobs do
        if current_jobs[i].job.group_id == group_id then
            number = number + 1
        end
    end

    callback(number)

end)

exports["em_dal"]:register_server_callback("em_jobs:get_number_of_group_type_clocked_in", function(source, callback, group_type_id)

    local current_jobs = exports["em_dal"]:get_current_character_jobs()
    local number = 0
    
    for i = 1, #current_jobs do
        if current_jobs[i].job.group_type_id == group_type_id then
            number = number + 1
        end
    end

    callback(number)

end)