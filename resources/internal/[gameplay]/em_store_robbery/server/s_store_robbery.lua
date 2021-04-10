
local safes_being_robbed = {}


local function is_safe_being_robbed(safe)

    for i = 1, #safes_being_robbed do

        if safes_being_robbed[i].interaction_point_id == safe.interaction_point_id then
            return true
        end

    end
    return false

end

local function remove_safe(safe)

    for i = 1, #safes_being_robbed do

        if safes_being_robbed[i].interaction_point_id == safe.interaction_point_id then
            table.remove(safes_being_robbed, i)
            break
        end

    end

end

exports["em_fw"]:register_server_callback("em_store_robbery:start_robbing_safe", function(source, callback, safe)

    local can_rob = not is_safe_being_robbed(safe)

    if can_rob then
        table.insert(safes_being_robbed, safe)
    end

    callback(can_rob)

end)

exports["em_fw"]:register_server_callback("em_store_robbery:stopped_robbing_safe", function(source, callback, safe, finished)

    Citizen.CreateThread(function()

        if finished then
            Citizen.Wait(1000 * 60 * 15)
        end

        remove_safe(safe)

    end)
    
    if finished then
        callback(math.random(300, 600))
        return
    end

    callback(0)

end)