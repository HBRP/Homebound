

exports["em_commands"]:register_command("311r", function(source, args, raw_command)

    local to_source = tonumber(args[1])
    local message = "Generic 311 Response"

    if #args > 1 then
        message = table.concat({table.unpack(args, 2, #args)}, " ")
    end

    TriggerServerEvent("em_ems_commands:311r", to_source, message)


end, "Respond to a 311 call", {{name = "character_id", help = "integer"}, {name = "message", help = "Your message!"}})

exports["em_commands"]:register_command_no_perms("311", function(source, args, raw_command)

	local message = table.concat(args, " ")
	local coords = GetEntityCoords(PlayerPedId())
	TriggerServerEvent("em_ems_commands:311", message, coords)

    TriggerEvent('chat:addMessage', {
        template = string.format('<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(71, 224, 25, 0.8); border-radius: 3px; font-size:18px;"> (311) (you): %s</div>', message),
        args = {}
    })

end, "Send a 311 call", {{name = "Message", help = "Your message!"}})

RegisterNetEvent("em_ems_commands:311")
AddEventHandler("em_ems_commands:311", function(from_source, message, coords)

    TriggerEvent('chat:addMessage', {
        template = string.format('<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(71, 224, 25, 0.8); border-radius: 3px; font-size:18px;"> (311) (%d): %s</div>', from_source, message),
        args = {}
    })

    exports["em_blips"]:create_temp_blip(coords, 280, 4, string.format('311 call for %d', from_source), 60*1000)

end)

RegisterNetEvent("em_ems_commands:311r")
AddEventHandler("em_ems_commands:311r", function(to_source, message)

    TriggerEvent('chat:addMessage', {
        template = string.format('<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(39, 128, 13, 0.8); border-radius: 3px; font-size:18px;"> (311r) (%d): %s</div>', to_source, message),
        args = {}
    })

end)