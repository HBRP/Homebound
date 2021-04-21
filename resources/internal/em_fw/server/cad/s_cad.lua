

register_server_callback("em_fw:cad_get_latest_cad_reports", function(source, callback)

    HttpGet("/Cad/Latest/Reports", nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_fw:cad_get_charges", function(source, callback)

    HttpGet("/Cad/Charges", nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_fw:cad_perform_character_search", function(source, callback, character_info)

    local endpoint = string.format("/Cad/Search/Character/%s", character_info)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_fw:cad_get_character_details", function(source, callback, character_id)

    local endpoint = string.format("/Cad/CharacterDetails/%d", character_id)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_fw:cad_get_report", function(source, callback, cad_report_id)

    local endpoint = string.format("/Cad/Report/%d", cad_report_id)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_fw:cad_new_report", function(source, callback, modifying_character_id, character_id, title, incident, charges, author, name)

    local data = {

        modifying_character_id = modifying_character_id, 
        character_id = character_id, 
        title = title, 
        incident = incident, 
        charges = charges, 
        author = author, 
        name = name

    }
    HttpPost("/Cad/New/Report", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)