


register_server_callback("em_dal:create_outfit", function(source, callback, character_id, outfit_name, outfit)

    local data = {character_id = character_id, outfit_name = outfit_name, outfit = outfit}
    HttpPost("/CharacterOutfit/Create", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:update_outfit", function(source, callback, character_outfit_id, outfit_name, outfit)

    local data = {character_outfit_id = character_outfit_id, outfit_name = outfit_name, outfit = outfit}
    HttpPut("/CharacterOutfit/Update", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:get_outfit", function(source, callback, character_outfit_id)

    local data = {character_outfit_id = character_outfit_id}
    HttpPost("/CharacterOutfit/Get", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:get_active_outfit", function(source, callback, character_id)

    local data = {character_id = character_id}
    HttpPost("/CharacterOutfit/GetActive", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)


register_server_callback("em_dal:get_all_outfit_meta_data", function(source, callback, character_id)

    local data = {character_id = character_id}
    HttpPost("/CharacterOutfit/GetMetaData", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:delete_outfit", function(source, callback, character_outfit_id)

    local data = {character_outfit_id = character_outfit_id}
    HttpPut("/CharacterOutfit/Delete", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_dal:create_skin", function(source, callback, character_id, character_skin)

    local data = {character_id = character_id, character_skin = character_skin}
    HttpPut("/Character/CreateSkin", data, function(error_code, result_data, result_headers)

        callback({})

    end)

end)

register_server_callback("em_dal:update_skin", function(source, callback, character_id, character_skin)

    local data = {character_id = character_id, character_skin = character_skin}
    HttpPut("/Character/UpdateSkin", data, function(error_code, result_data, result_headers)

        callback({})

    end)

end)

register_server_callback("em_dal:get_skin", function(source, callback, character_id)

    local data = {character_id = character_id, character_skin = character_skin}
    HttpPost("/Character/GetSkin", data, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)