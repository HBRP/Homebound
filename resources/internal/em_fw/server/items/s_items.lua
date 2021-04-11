
register_server_callback("em_fw:get_item_modifiers", function(source, callback, item_id)

    local data    = nil
    local request = string.format("/Item/Modifiers/%s", item_id)
    HttpGet(request, data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_fw:get_weapons", function(source, callback) 

    local data = nil
    HttpGet("/Item/Weapons", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

function get_items(callback)

    HttpGet("/Item/Items", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end

register_server_callback("em_fw:get_items", function(source, callback)

    get_items(callback)

end)

register_server_callback("em_fw:get_attachments", function(source, callback)

    HttpGet("/Item/Attachments", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)