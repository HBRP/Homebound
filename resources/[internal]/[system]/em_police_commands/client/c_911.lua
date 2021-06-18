

exports["em_commands"]:register_command("911r", function(source, args, raw_command)



end, "Respond to a 911 call", {{name = "character_id", help = "integer"}, {name = "message", help = "Your message!"}})

exports["em_commands"]:register_command_no_perms("911", function(source, args, raw_command)

	local message = table.concat(raw_command, " ")


end, "Send a 911 call", {{name = "Message", help = "Your message!"}})

RegisterNetEvent("em_police_commands:911")
AddEventHandler("em_police_commands:911", function(character_id, )

end)