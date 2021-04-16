
function get_vehicle_store_stock_async(callback, vehicle_store_name)

    trigger_server_callback_async("em_fw:get_vehicle_store_stock", callback, vehicle_store_name)

end

function can_purchase_a_vehicle()

    local can_purchase = false
    trigger_server_callback("em_fw:can_purchase_a_vehicle", function(result)

        can_purchase = result

    end, get_character_id())

    return can_purchase

end