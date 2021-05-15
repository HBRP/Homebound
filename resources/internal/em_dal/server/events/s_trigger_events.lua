
register_server_callback("em_dal:trigger_event_for_character", function(source, callback, event, character_id, args)

    TriggerClientEvent(event, get_server_id_from_character_id(character_id), table.unpack(args))
    callback()

end)

register_server_callback("em_dal:trigger_proximity_event", function(source, callback, event, distance, args)

    local source_coords = GetEntityCoords(GetPlayerPed(source))
    local character_ids = get_current_character_ids()
    for i = 1, #character_ids do

        if #(source_coords - GetEntityCoords(GetPlayerPed(character_ids[i].source))) <= distance then

            TriggerClientEvent(event, character_ids[i].source, table.unpack(args))

        end

    end

end)