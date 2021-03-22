

function get_storage(storage_id)

    local storage = nil
    trigger_server_callback("em_fw:get_storage", function(result)

        storage = result

    end, storage_id)

    return storage

end


function give_item(storage_id, item_id, amount, storage_item_id, slot)

    trigger_server_callback("em_fw:give_item", function(result)

        TriggerEvent('em_fw:inventory_change')

    end, storage_id, item_id, amount, storage_item_id, slot)

end


function remove_item(storage_item_id, amount)

    trigger_server_callback("em_fw:remove_item", function(result) 

        TriggerEvent('em_fw:inventory_change')

    end, storage_item_id, amount)

end

function move_item(old_storage_id, old_storage_item_id, new_storage_id, new_slot_id, item_id, amount)

    local move_item_response = nil
    trigger_server_callback("em_fw:move_item", function(result) 

        move_item_response = result
        TriggerEvent('em_fw:inventory_change')

    end, old_storage_id, old_storage_item_id, new_storage_id, new_slot_id, item_id, amount)

    return move_item_response

end

function get_nearby_stashes()

    local nearby_stashes = nil
    local coords = GetEntityCoords(PlayerPedId())

    trigger_server_callback("em_fw:get_nearby_stashes", function(result) 

        nearby_stashes = result

    end, coords.x, coords.y, coords.z)

    return nearby_stashes

end


function get_vehicle_storage(plate, location)

    local storage = nil

    trigger_server_callback("em_fw:get_vehicle_storage", function(result)

        storage = result

    end, plate, location)

    return storage

end

function get_vehicle_storage_id(plate, location)

    local temp = nil

    trigger_server_callback("em_fw:get_vehicle_storage_id", function(result)

        temp = result

    end, plate, location)

    return temp["storage_id"]

end