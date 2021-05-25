
local group_type_ids = {

    JOB = 1,
    GROUP = 2,
    MISC = 3,
    LAW_ENFORCEMENT = 4,
    FEDERAL_LAW_ENFORCEMENT = 5,
    EMERGENCY_MEDICAL_SERVICES = 6

}

function get_number_of_group_type_clocked_in(group_type_id)

    local number = 0
    exports["em_dal"]:trigger_server_callback("em_jobs:get_number_of_group_type_clocked_in", function(result)
        number = result
    end, group_type_id)
    
    return result

end

function get_num_law_enforcement_clocked_in()

	return get_number_of_group_type_clocked_in(4)

end