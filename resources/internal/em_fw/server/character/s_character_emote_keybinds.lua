
register_server_callback("em_fw:get_emote_keybinds", function(source, callback, character_id)

    local endpoint = string.format("/Character/Emote/Keybinds/%d", character_id)
    HttpGet(endpoint, nil, function(error_code, result_data, result_headers)

        local temp = json.decode(result_data)
        callback(temp)

    end)

end)

register_server_callback("em_fw:update_emote_keybinds", function(source, callback, character_id, emote_number, emote)

    local data = {character_id = character_id, emote_number = emote_number, emote = emote}
    HttpPut("/Character/Emote/KeybindUpdate", nil, function(error_code, result_data, result_headers)

        callback()

    end)

end)