

function get_character_health(callback)

    trigger_server_callback_async("em_dal:get_character_health", callback)

end

function set_character_health(health)

    trigger_server_callback_async("em_dal:set_character_health", nil, health)

end