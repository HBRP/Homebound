

function trigger_event_for_character(event, character_id, ...)

    local args = {...}
    trigger_server_callback_async("em_dal:trigger_event_for_character", function() end, event, character_id, args)

end

function trigger_proximity_event(event, distance, ...)

    local args = {...}
    trigger_server_callback_async("em_dal:trigger_proximity_event", function() end, event, distance, args)

end