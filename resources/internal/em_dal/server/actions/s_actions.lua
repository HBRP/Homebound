

register_server_callback("em_dal:can_do_action", function(source, callback, action)

	local character_id = get_character_id_from_source(source)
	local data = {character_id = character_id, action = action}
	HttpPost("/Action/CanDoAction", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)