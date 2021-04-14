

function get_emote_keybinds(callback)

    trigger_server_callback_async("em_fw:get_emote_keybinds", callback, get_character_id())

end

function update_emote_keybinds(emote_number, emote)

    trigger_server_callback_async("em_fw:update_emote_keybinds", function() end, get_character_id(), emote_number, emote)

end