
local temp_storage_cache = {}

register_server_callback("em_fw:get_temp_storage", function(source, callback, storage_name)

    if temp_storage_cache[storage_name] == nil then
        temp_storage_cache[storage_name] = {}
    end

    callback(temp_storage_cache[storage_name])

end)

register_server_callback("em_fw:temp_storage_give", function(source, callback)

end)

register_server_callback("em_fw:temp_storage_remove", function(source, callback)

end)

register_server_callback("em_fw:temp_storage_move", function(source, callback)

    

end)