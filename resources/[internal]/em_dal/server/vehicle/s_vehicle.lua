

register_server_callback("em_dal:get_all_vehicle_models", function(source, callback)

	HttpGetSim("/Vehicle/Models", nil, callback)

end)