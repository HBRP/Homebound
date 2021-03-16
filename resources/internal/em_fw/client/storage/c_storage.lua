

function get_storage(storage_id)

    local storage = nil
    trigger_server_callback("em_fw:get_storage", function(result)

        storage = result

    end, storage_id)

    return storage

end


function give_item(storage_id, item_id, amount, storage_item_id, slot)

    trigger_server_callback("em_fw:give_item", function(result)

    end, storage_id, item_id, amount, storage_item_id, slot)

end


function remove_item(storage_item_id, amount)

    trigger_server_callback("em_fw:remove_item", function(result) 


    end, storage_item_id, amount)

end