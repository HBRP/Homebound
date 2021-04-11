
local recently_robbed = {}

exports["em_fw"]:register_server_callback("em_store_robbery:can_rob_store", function(source, callback, interaction_ped_id)

    for i = 1, #recently_robbed do

        if interaction_ped_id == recently_robbed[i] then
            callback(false)
            return
        end

    end
    callback(true)

end)

exports["em_fw"]:register_server_callback("em_store_robbery:begin_robbing_store", function(source, callback, interaction_ped_id)

    table.insert(recently_robbed, interaction_ped_id)
    callback()

end)

exports["em_fw"]:register_server_callback("em_store_robbery:finished_robbing_store", function(source, callback, interaction_ped_id, successful)

    
    callback()

end)