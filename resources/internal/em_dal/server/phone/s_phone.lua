

register_server_callback("em_dal:phone_get_phone_data", function(source, callback)

	local endpoint = string.format("/Phone/Data/%d", get_character_id_from_source(source))
	HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:phone_delete_messages", function(source, callback, phone_number)

	local endpoint = string.format("/Phone/Message/Delete/%d/%s", get_character_id_from_source(source), phone_number)
	HttpPut(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:delete_all_messages", function(source, callback)

    local endpoint = string.format("/Phone/Message/DeleteAll/%d", get_character_id_from_source(source), phone_number)
    HttpPut(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:phone_new_message", function(source, callback, phone_number, message)

    local data = {character_id = get_character_id_from_source(source), phone_number = phone_number, message = message}
    HttpPost("/Phone/Message/New", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:phone_get_messages", function(source, callback)

    local endpoint = string.format("/Phone/Messages/%d", get_character_id_from_source(source))
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:phone_mark_messages_read", function(source, callback, phone_number)

    local endpoint = string.format("/Phone/Message/MarkRead/%d/%s", get_character_id_from_source(source), phone_number)
    HttpPut(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:phone_get_contacts", function(source, callback)

    local endpoint = string.format("/Phone/Contacts/%d", get_character_id_from_source(source))
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:phone_new_contact", function(source, callback, phone_number, phone_contact_name)

    local data = {character_id = get_character_id_from_source(source), phone_number = phone_number, phone_contact_name = phone_contact_name}
    HttpPost("/Phone/Contact/New", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:phone_delete_contact", function(source, callback, phone_contact_id)

    local endpoint = string.format("/Phone/Contact/Delete/%d/%d", get_character_id_from_source(source), phone_contact_id)
    HttpPost(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:phone_update_contact", function(source, callback, phone_contact_id, phone_number, phone_contact_name)

    local data = {phone_contact_id = phone_contact_id, phone_number = phone_number, phone_contact_name = phone_contact_name}
    HttpPost("/Phone/Contact/Update", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)