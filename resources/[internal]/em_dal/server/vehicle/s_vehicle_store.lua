
register_server_callback("em_dal:get_vehicle_store_stock", function(source, callback, vehicle_store_name)

    local endpoint = string.format("/Vehicle/Store/Stock/%s", vehicle_store_name)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:can_purchase_a_vehicle", function(source, callback, character_id)

    local endpoint = string.format("/Vehicle/CanPurchase/%d", character_id)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:purchase_vehicle", function(source, callback, vehicle, vehicle_store_name)

    local data = {
        vehicle_store_name = vehicle_store_name,
        seller_character_id = get_character_id_from_source(source),
        vehicle = vehicle
    }
    HttpPostSim("/Vehicle/Purchase", data, callback)

end)

register_server_callback("em_dal:insert_new_vehicle", function(source, callback, character_id, vehicle_model, vehicle_mods, vehicle_state)

    local data = {character_id = character_id, vehicle_model = vehicle_model, vehicle_mods = vehicle_mods, vehicle_state = vehicle_state}
    HttpPost("/Vehicle/InsertVehicle", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:order_vehicle", function(source, callback, vehicle_model_id, amount_to_order)

    local character_job = get_character_job(source).job
    local data = {
        character_id = get_character_id_from_source(source),
        group_rank_id = character_job.group_rank_id,
        vehicle_model_id = vehicle_model_id,
        amount_to_order = amount_to_order,
    }
    HttpPostSim("/Vehicle/Store/OrderVehicle", data, callback)

end)

register_server_callback("em_dal:get_vehicle_orders", function(source, callback, vehicle_store_name)

    local data = {vehicle_store_name = vehicle_store_name}
    HttpPostSim("/Vehicle/Store/Orders", data, callback)

end)