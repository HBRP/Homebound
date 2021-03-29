

register_server_callback("em_fw:get_storage", function(source, callback, storage_id)

    local data = {storage_id = storage_id}
    HttpPost("/Storage/Get", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

local function give_item(source, callback, character_id, storage_id, item_id, amount, storage_item_id, slot)

    local data = { character_id = character_id, storage_id = storage_id, item_id = item_id, amount = amount, storage_item_id = storage_item_id, slot = slot}
    HttpPost("/Storage/Give", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        if not temp.response.success then
            Citizen.Trace(temp.response.message .. "\n")
        end
        callback(temp)

    end)

end

register_server_callback("em_fw:give_item", function(source, callback, character_id, storage_id, item_id, amount, storage_item_id, slot)

    give_item(source, callback, character_id, storage_id, item_id, amount, storage_item_id, slot)

end)

register_server_callback("em_fw:remove_item", function(source, callback, storage_item_id, amount)

    local data = {storage_item_id = storage_item_id, amount = amount}
    HttpPost("/Storage/Remove", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)


register_server_callback("em_fw:move_item", function(source, callback, old_storage_id, old_storage_item_id, new_storage_id, new_slot_id, item_id, amount)


    local data = {old_storage_id = old_storage_id, old_storage_item_id = old_storage_item_id, new_storage_id = new_storage_id, new_slot_id = new_slot_id, item_id = item_id, amount = amount}
    HttpPost("/Storage/Move", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        if not temp.response.success then
            Citizen.Trace(temp.response.message .. "\n")
        end
        callback(temp)

    end)

end)

register_server_callback("em_fw:give_item_to_other_character", function(source, callback, character_id, item_id, amount, storage_item_id)

    local player_notification = function(result)

        if result.response.success then
            local server_id = get_server_id_from_character_id(character_id)
            TriggerClientEvent("em_fw:inventory_change", server_id)
            TriggerClientEvent("em_fw:successful_give", server_id, item_id, amount)
        end
        callback(result)

    end

    give_item(source, player_notification, character_id, get_character_storage_id_from_character_id(character_id), item_id, amount, storage_item_id, -1)

end)


Citizen.CreateThread(function()

    Citizen.Wait(10)
    HttpPut("/Storage/ResetTemp", nil, function(error_code, result_data, result_headers) end)

end)