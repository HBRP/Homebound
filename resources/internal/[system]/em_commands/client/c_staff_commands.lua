

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

    local storage_id = exports["em_fw"]:get_character_storage_id()
    local response = exports["em_fw"]:give_item(storage_id, tonumber(args[1]), tonumber(args[2]), -1, -1)

    if response.response.success then
        exports['t-notify']:Alert({style = 'success', message = "Gave Item"})
    else
        exports['t-notify']:Alert({style = 'error', message = "Could not give item"})
    end

end, "Give item by item id", {{ name = "id", help = "item id"}, {name = "amount", help = "amount to give"}})