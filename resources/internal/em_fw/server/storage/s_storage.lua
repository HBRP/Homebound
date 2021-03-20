

register_server_callback("em_fw:get_storage", function(source, callback, storage_id)

    local data = {storage_id = storage_id}
    HttpPost("/Storage/Get", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_fw:give_item", function(source, callback, storage_id, item_id, amount, storage_item_id, slot)

    local data = {storage_id = storage_id, item_id = item_id, amount = amount, storage_item_id = storage_item_id, slot = slot}
    
    HttpPost("/Storage/Give", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

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
        callback(temp)

    end)

end)