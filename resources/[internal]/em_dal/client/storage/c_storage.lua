

function get_storage(storage_id)

    local storage = nil
    trigger_server_callback("em_dal:get_storage", function(result)

        storage = result

    end, storage_id)

    local storage_items = storage["storage_items"]
    for i = 1, #storage_items do
        storage_items[i].item_metadata = json.decode(storage_items[i].item_metadata)
    end

    return storage

end

function get_storage_async(callback, storage_id)

    local storage = nil
    trigger_server_callback("em_dal:get_storage", function(result)

        local storage_items = result["storage_items"]
        for i = 1, #storage_items do
            storage_items[i].item_metadata = json.decode(storage_items[i].item_metadata)
        end
        callback(result)

    end, storage_id)

end


function give_item(storage_id, item_id, amount, storage_item_id, slot)

    local response = nil
    trigger_server_callback("em_dal:give_item", function(result)

        response = result
        TriggerEvent('em_dal:inventory_change')

    end, get_character_id(), storage_id, item_id, amount, storage_item_id, slot)
    return response

end


function remove_item(storage_item_id, amount)

    trigger_server_callback("em_dal:remove_item", function(result) 

        TriggerEvent('em_dal:inventory_change')

    end, storage_item_id, amount)

end

function move_item(old_storage_id, old_storage_item_id, new_storage_id, new_slot_id, item_id, amount)

    local move_item_response = nil
    trigger_server_callback("em_dal:move_item", function(result) 

        move_item_response = result
        TriggerEvent('em_dal:inventory_change')

    end, old_storage_id, old_storage_item_id, new_storage_id, new_slot_id, item_id, amount)

    return move_item_response

end

function move_item_async(callback, old_storage_id, old_storage_item_id, new_storage_id, new_slot_id, item_id, amount)

    trigger_server_callback_async("em_dal:move_item", function(result) 

        callback(result)
        TriggerEvent('em_dal:inventory_change')

    end, old_storage_id, old_storage_item_id, new_storage_id, new_slot_id, item_id, amount)

end

function give_item_to_other_character(character_id, item_id, amount, storage_item_id)

    local response = nil
    trigger_server_callback("em_dal:give_item_to_other_character", function(result)

        response = result

    end, character_id, item_id, amount, storage_item_id)
    return response

end