
local group_type_ids = {

    JOB = 1,
    GROUP = 2,
    MISC = 3,
    LAW_ENFORCEMENT = 4,
    FEDERAL_LAW_ENFORCEMENT = 5,
    EMERGENCY_MEDICAL_SERVICES = 6

}

local group_type_numbers = {}

function get_number_of_group_type_clocked_in(group_type_id)


    if group_type_numbers[group_type_id] == nil or group_type_numbers[group_type_id].next_refresh < GetGameTimer() then

        exports["em_dal"]:trigger_server_callback("em_jobs:get_number_of_group_type_clocked_in", function(result)

            group_type_numbers[group_type_id] = {}
            group_type_numbers[group_type_id].clocked_in_number = result
            group_type_numbers[group_type_id].next_refresh = GetGameTimer() + 1000 * 10

        end, group_type_id)

    end

    return group_type_numbers[group_type_id].clocked_in_number

end

local law_enforcement = {clocked_in = 0, next_check = 0}

function get_num_law_enforcement_clocked_in()

	return get_number_of_group_type_clocked_in(4)

end