

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

    local endpoint = string.format("/Cad/Character/Details/%d", character_id)
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


    if get_character_id_from_source(source) ~= modifying_character_id then
        callback()
        return
    end

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

register_server_callback("em_fw:cad_delete_report", function(source, callback, character_id, cad_report_id)

    if get_character_id_from_source(source) ~= character_id then
        callback()
        return
    end

    local endpoint = string.format("/Cad/Delete/Report/%d/%d", character_id, cad_report_id)
    HttpPost(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_fw:cad_get_all_warrants", function(source, callback)

    HttpGet("/Cad/Warrants/All", nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_fw:cad_search_reports", function(source, callback, query)

    local endpoint = string.format("/Cad/Reports/Search/%s", query)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_fw:cad_search_vehicle", function(source, callback, plate)

    local endpoint = string.format("/Cad/Vehicle/Search/%s", plate)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_fw:cad_get_vehicle_details", function(source, callback, character_id, plate)

    local endpoint = string.format("/Cad/Vehicle/Details/%d/%s", character_id, plate)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_fw:cad_update_vehicle", function(source, callback, character_id, plate, notes, stolen)

    if get_character_id_from_source(source) ~= character_id then
        callback()
        return
    end

    local data = {character_id = character_id, plate = plate, notes = notes, stolen = stolen}
    HttpPost("/Cad/Vehicle/UpdateStatus", data, function(error_code, result_data, result_headers)

        callback()

    end)

end)

register_server_callback("em_fw:cad_update_character_details", function(source, callback, modifying_character_id, character_id, changes)

    if get_character_id_from_source(source) ~= character_id then
        callback()
        return
    end

    local data = {modifying_character_id = modifying_character_id, character_id = character_id, changes = changes}
    HttpPost("/Cad/Character/Details/Update", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_fw:cad_update_report", function(source, callback, character_id, cad_report_id, title, incident)

    if get_character_id_from_source(source) ~= character_id then
        callback()
        return
    end

    local data = {character_id = character_id, cad_report_id = cad_report_id, title = title, incident = incident}
    HttpPost("/Cad/Update/Report", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)