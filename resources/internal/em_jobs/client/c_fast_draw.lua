
local fast_draw_group_ids = {2, 3, 4}

function can_fast_draw()

    local job = get_current_job()

    for i = 1, #fast_draw_group_ids do
        if job.group_id == fast_draw_group_ids[i] then
            return true
        end
    end
    return false

end