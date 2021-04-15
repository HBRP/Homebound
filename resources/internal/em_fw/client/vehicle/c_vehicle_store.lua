
function get_vehicle_store_stock_async(callback, vehicle_store_name)

    trigger_server_callback_async("em_fw:get_vehicle_store_stock", callback, vehicle_store_name)

end