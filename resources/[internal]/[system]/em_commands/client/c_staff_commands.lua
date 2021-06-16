

register_command("tpm", function(source, args, raw)

    Citizen.CreateThread(function()

        local waypoint_coords = GetBlipCoords(GetFirstBlipInfoId(8))
        for i = 1, 20 do
            SetEntityCoords(PlayerPedId(), waypoint_coords.x, waypoint_coords.y, waypoint_coords.z + (i*50))
            Citizen.Wait(100)
            local _, z = GetGroundZFor_3dCoord(waypoint_coords.x, waypoint_coords.y, waypoint_coords.z + (i*50), 1)

            if z ~= 0.0 then
                SetEntityCoords(PlayerPedId(), waypoint_coords.x, waypoint_coords.y, z + 1)
                return
            end
        end

    end)
    
end, "Teleport to marker")

register_command("tpto", function(source, args, raw)

    if #args < 3 then
        return
    end
    SetEntityCoords(PlayerPedId(), tonumber(args[1]), tonumber(args[2]), tonumber(args[3]) + 0.25)
    
end, "Teleport to coordinates", {{name = 'x', help = 'float'}, {name = 'y', help = 'float'}, {name = 'z', help = 'float'}})

register_command("give_item", function(source, args, raw)

    local storage_id = exports["em_dal"]:get_character_storage_id()
    local response = exports["em_dal"]:give_item(storage_id, tonumber(args[1]), tonumber(args[2]), -1, -1)

    if response.response.success then
        exports['t-notify']:Alert({style = 'success', message = "Gave Item"})
    else
        exports['t-notify']:Alert({style = 'error', message = "Could not give item"})
    end

end, "Give item by item id", {{ name = "id", help = "item id"}, {name = "amount", help = "amount to give"}})

register_command("ban_player", function(source, args, raw)

    local player_id = tonumber(args[1])
    local length = tonumber(args[2])

    exports["em_dal"]:ban_player_async(function(response) 

        print(json.encode(response))
        if response.result.success then
            exports['t-notify']:Alert({style = 'success', message = response.result.message})
        else
            exports['t-notify']:Alert({style = 'error', message = response.result.message})
        end

    end, player_id, length)

end, "Ban player", {{name = "player_id", help = "integer"}, {name = "length in days", message = "integer"}})

register_command("ban_by_character", function(source, args, raw)

    local character_id = tonumber(args[1])
    local length = tonumber(args[2])

    exports["em_dal"]:ban_character_async(function(response) 

        if response.result.success then
            exports['t-notify']:Alert({style = 'success', message = response.result.message})
        else
            exports['t-notify']:Alert({style = 'error', message = response.result.message})
        end

    end, character_id, length)

end, "Ban character", {{name = "character_id", help = "integer"}, {name = "length in days", message = "integer"}})


register_command("whitelist_player", function(source, args, raw)

    local player_id = tonumber(args[1])
    exports["em_dal"]:whitelist_player_async(function(response) 

        if response.result.success then
            exports['t-notify']:Alert({style = 'success', message = response.result.message})
        else
            exports['t-notify']:Alert({style = 'error', message = response.result.message})
        end

    end, player_id, 1)

end, "Whitelist player", {{name = "player_id", help = "integer"}})

register_command("kick_character", function(source, args, raw)

    local character_id = tonumber(args[1])
    local message = "You have been kicked"

    if #args > 1 then
        message = table.concat({table.unpack(args, 2, #args)}, " ")
    end

    exports["em_dal"]:trigger_server_callback_async("em_commands:kick_character", function(response)

        exports['t-notify']:Alert({style = "info", message = response})

    end, character_id, message)

end, "Kick character", {{name = "character_id", help = "integer"}, {name = "message", help = "(optional) why this person has been kicked"}})