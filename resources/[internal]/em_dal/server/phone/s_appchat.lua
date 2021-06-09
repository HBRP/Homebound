
register_server_callback("em_dal:appchat_get_messages", function(source, callback, channel)

	local endpoint = string.format("/Phone/AppChat/Messages/<channel>")
	HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:appchat_send_message", function(source, callback, channel, message)

	local data = { character_id = get_character_id_from_source(source), channel = channel, message = message }
	HttpPost("/Phone/AppChat/NewMessage", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)