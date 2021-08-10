
function get_vehicle_store_stock_async(callback, vehicle_store_name)

    trigger_server_callback_async("em_dal:get_vehicle_store_stock", callback, vehicle_store_name)

end

function can_purchase_a_vehicle()

    local can_purchase = nil
    trigger_server_callback("em_dal:can_purchase_a_vehicle", function(result)

        can_purchase = result

    end, get_character_id())

    return can_purchase

end

function insert_new_vehicle_async(callback, vehicle_model, vehicle_mods, vehicle_state)

    trigger_server_callback_async("em_dal:insert_new_vehicle", callback, get_character_id(), vehicle_model, vehicle_mods, vehicle_state)

end

function order_vehicle_async(callback, vehicle_model_id, amount_to_order)

    trigger_server_callback_async("em_dal:order_vehicle", callback, vehicle_model_id, amount_to_order)

end