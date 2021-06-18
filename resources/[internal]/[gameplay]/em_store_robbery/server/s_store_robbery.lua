
local recently_robbed = {}

exports["em_dal"]:register_server_callback("em_store_robbery:can_rob_store", function(source, callback, interaction_ped_id)

    for i = 1, #recently_robbed do

        if interaction_ped_id== recently_robbed[i].interaction_ped_id then
            callback(false)
            return
        end

    end
    callback(true)

end)

exports["em_dal"]:register_server_callback("em_store_robbery:begin_robbing_store", function(source, callback, interaction_ped_id)

    for i = 1, #recently_robbed do

        if interaction_ped_id== recently_robbed[i].interaction_ped_id then
            callback(false)
            return
        end

    end

    exports["em_dal"]:log_generic(source, string.format("start_store_robbery:%d", interaction_ped_id), {})

    table.insert(recently_robbed, {interaction_ped_id = interaction_ped_id, end_robbery_time = GetGameTimer() + 1000 * 60 * 25})
    callback(true)

end)

exports["em_dal"]:register_server_callback("em_store_robbery:finished_robbing_store", function(source, callback, interaction_ped_id, successful)

    local found_id = false
    for i = 1, #recently_robbed do

        if interaction_ped_id== recently_robbed[i].interaction_ped_id then
            found_id = true
            break
        end

    end

    if found_id then

        local amount       = math.random(50, 250)
        local item_id      = exports["em_items"]:get_item_id_from_name("cash")
        local character    = exports["em_dal"]:get_character_from_source(source)
        local character_id = character.character_id
        local storage_id   = character.storage_id

        exports["em_dal"]:give_item(source, function()

            TriggerClientEvent("t-notify:client:Alert", source, {
                style = "success",
                message = string.format("Received $%d from the clerk", amount)
            })

        end, character_id, storage_id, item_id, amount, -1, -1)
        exports["em_dal"]:log_generic(source, string.format("finished_store_robbery:%d", interaction_ped_id), {amount_robbed = amount})
        callback(amount)
    end
    callback(0)

end)

Citizen.CreateThread(function()

    while true do

        Citizen.Wait(10000)
        for i = 1, #recently_robbed do

            if recently_robbed[i].end_robbery_time < GetGameTimer() then
                table.remove(recently_robbed, i)
            end

        end

    end

end)