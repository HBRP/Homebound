

register_server_callback("em_dal:get_phone_data", function(source, callback)

	local endpoint = string.format("/Phone/Data/%d", get_character_id_from_source(source))
	HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:delete_messages", function(source, callback, transmitter_phone, receiving_phone)

	local endpoint = string.format("/Phone/DeleteMessages/%s/%s", transmitter_phone, receiving_phone)
	HttpPost(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)