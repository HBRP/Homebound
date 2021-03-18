
register_server_callback("em_fw:get_item_modifiers", function(source, callback, item_id)

    local data    = nil
    local request = string.format("/Item/Modifiers/%s", item_id)
    HttpGet(request, data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)