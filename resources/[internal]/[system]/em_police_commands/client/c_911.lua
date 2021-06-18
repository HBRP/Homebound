

exports["em_commands"]:register_command("911r", function(source, args, raw_command)

    local to_source = tonumber(args[1])
    local message = "Generic 911 Response"

    if #args > 1 then
        message = table.concat({table.unpack(args, 2, #args)}, " ")
    end

    TriggerServerEvent("em_police_commands:911r", to_source, message)


end, "Respond to a 911 call", {{name = "character_id", help = "integer"}, {name = "message", help = "Your message!"}})

exports["em_commands"]:register_command_no_perms("911", function(source, args, raw_command)

	local message = table.concat(args, " ")
	local coords = GetEntityCoords(PlayerPedId())
	TriggerServerEvent("em_police_commands:911", message, coords)

end, "Send a 911 call", {{name = "Message", help = "Your message!"}})

RegisterNetEvent("em_police_commands:911")
AddEventHandler("em_police_commands:911", function(from_source, message, coords)

    TriggerServerEvent("em_commands:propagate_to_clients", {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(224, 17, 2, 0.8); border-radius: 3px; font-size:18px;"> (911) ({0}): {1}</div>',
        args = { from_source, message }
    })

    exports["em_blips"]:create_temp_blip(coords, 280, 4, string.format('911 call for %d', from_source), 60*1000)

end)

RegisterNetEvent("em_police_commands:911r")
AddEventHandler("em_police_commands:911r", function(to_source, message)

    TriggerServerEvent("em_commands:propagate_to_clients", {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(140, 9, 0, 0.8); border-radius: 3px; font-size:18px;"> (911) ({0}): {1}</div>',
        args = { to_source, message }
    })

end)