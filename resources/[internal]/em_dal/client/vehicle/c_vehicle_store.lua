
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

--[[

#[derive(Serialize, Deserialize, Debug)]
pub struct VehicleInsert {

    pub character_id: i32,
    pub vehicle_model: String,
    pub vehicle_mods: serde_json::Value,
    pub vehicle_state: serde_json::Value

}

#[derive(Serialize, Deserialize, Debug)]
pub struct VehicleBuyRequest {

    vehicle: vehicles::VehicleInsert,
    vehicle_store_name: String,
    seller_character_id: i32

}

]]

function purchase_vehicle_async(callback, vehicle, vehicle_store_name)

    assert(vehicle.character_id ~= nil, "purchase_vehicle_async: Error, vehicle structure malformed with character_id")
    assert(vehicle.vehicle_model ~= nil, "purchase_vehicle_async: Error, vehicle structure malformed with vehicle_model")
    assert(vehicle.vehicle_mods ~= nil, "purchase_vehicle_async: Error, vehicle structure malformed with vehicle_mods")
    assert(vehicle.vehicle_state ~= nil, "purchase_vehicle_async: Error, vehicle structure malformed with vehicle_state")
    trigger_server_callback_async("em_dal:purchase_vehicle" calback, vehicle, vehicle_store_name)

end

function insert_new_vehicle_async(callback, vehicle_model, vehicle_mods, vehicle_state)

    trigger_server_callback_async("em_dal:insert_new_vehicle", callback, get_character_id(), vehicle_model, vehicle_mods, vehicle_state)

end

function order_vehicle_async(callback, vehicle_model_id, amount_to_order)

    trigger_server_callback_async("em_dal:order_vehicle", callback, vehicle_model_id, amount_to_order)

end

function get_vehicle_orders_async(callback, vehicle_store_name)

    trigger_server_callback_async("em_dal:get_vehicle_orders", callback, vehicle_store_name)

end